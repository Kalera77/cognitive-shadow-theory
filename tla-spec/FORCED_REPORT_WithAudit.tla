---------------------------- MODULE FORCED_REPORT_WithAudit ----------------------------
EXTENDS Integers, Sequences, TLC

CONSTANTS
  theta_raw, H_min, theta_min, theta_max, delta_theta_max, grace_period,
  MaxLogSize, InitRoot

ASSUME theta_raw > 0 /\ H_min > 0
ASSUME theta_min > 0 /\ theta_max <= theta_raw /\ theta_min <= theta_max
ASSUME delta_theta_max > 0 /\ grace_period >= 1
ASSUME MaxLogSize > 0

States == {"MONITORING", "FR_ACTIVE", "LOCKED", "UNCONSCIOUS", "QUARANTINE", "DEGRADED"}
Scores == { <<a,b,c>> : a \in {0,1}, b \in {0,1}, c \in {0,1} }

AuditEntry == [ts: Nat, site: Nat, action: Nat, state_from: STRING, state_to: STRING, receipt_id: Nat]
Log == Seq(AuditEntry)

VARIABLES
  state, phi, H, scores, ext_support, timer, theta_adj,
  audit_log, audit_root, audit_next_idx, audit_version,
  current_time

vars == <<state, phi, H, scores, ext_support, timer, theta_adj,
         audit_log, audit_root, audit_next_idx, audit_version, current_time>>

ScoreSum(s) == s[1] + s[2] + s[3]

MakeReceiptId(ts) == ts

RECURSIVE MerkleSum(_, _, _)
MerkleSum(seq, i, acc) ==
    IF i > Len(seq) THEN acc
    ELSE MerkleSum(seq, i+1, acc + seq[i].receipt_id)

ComputeMerkleRoot(seq) == MerkleSum(seq, 1, InitRoot)

TypeOK ==
  /\ state \in States
  /\ phi \in 0..100
  /\ H \in 0..100
  /\ scores \in Scores
  /\ ext_support \in {TRUE, FALSE}
  /\ timer \in Nat
  /\ theta_adj \in 0..100
  /\ audit_log \in Log
  /\ Len(audit_log) < MaxLogSize
  /\ audit_root \in Nat
  /\ audit_next_idx \in Nat
  /\ audit_version \in {1, 2}
  /\ current_time \in Nat

Safety ==
  /\ (ext_support <=> (state \in {"LOCKED", "DEGRADED"}))
  /\ (state = "QUARANTINE" => phi <= theta_adj)
  /\ (timer > 0 => state \in {"FR_ACTIVE", "LOCKED", "UNCONSCIOUS"})
  /\ ~(state = "QUARANTINE" /\ ext_support)
  /\ (state \in States)
  /\ theta_min <= theta_adj
  /\ theta_adj <= theta_raw

MerkleConsistent == audit_root = ComputeMerkleRoot(audit_log)
Chronological == \forall i, j \in 1..Len(audit_log): i < j => audit_log[i].ts <= audit_log[j].ts
UniqueReceipts == \forall i, j \in 1..Len(audit_log): i # j => audit_log[i].receipt_id # audit_log[j].receipt_id

ProtocolSafety == Safety /\ MerkleConsistent /\ Chronological /\ UniqueReceipts /\ TypeOK

\* ---- Действия -------------------------------------------------------------
AdaptTheta ==
  /\ state \in {"MONITORING", "DEGRADED"}
  /\ theta_adj' \in theta_min..theta_max
  /\ theta_adj' - theta_adj <= delta_theta_max
  /\ theta_adj - theta_adj' <= delta_theta_max
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 1,
                       state_from |-> state,
                       state_to |-> state,
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<state, phi, H, scores, ext_support, timer, audit_version>>

Trigger ==
  /\ state = "MONITORING"
  /\ phi <= theta_adj
  /\ H > H_min
  /\ timer = 0
  /\ state' = "FR_ACTIVE"
  /\ timer' = 1
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 2,
                       state_from |-> state,
                       state_to |-> state',
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<phi, H, scores, ext_support, theta_adj, audit_version>>

Evaluate ==
  /\ state = "FR_ACTIVE"
  /\ timer < grace_period
  /\ scores' \in Scores
  /\ timer' = timer + 1
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 3,
                       state_from |-> state,
                       state_to |-> state,
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<state, phi, H, ext_support, theta_adj, audit_version>>

Decide ==
  /\ state = "FR_ACTIVE"
  /\ timer >= grace_period
  /\ IF ScoreSum(scores) >= 2
     THEN /\ state' = "LOCKED"
          /\ ext_support' = TRUE
     ELSE /\ state' = "UNCONSCIOUS"
          /\ ext_support' = FALSE
  /\ timer' = 0
  /\ scores' = <<0,0,0>>
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 4,
                       state_from |-> state,
                       state_to |-> state',
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<phi, H, theta_adj, audit_version>>

Quarantine ==
  /\ state \in {"MONITORING", "UNCONSCIOUS"}
  /\ phi <= theta_adj
  /\ H <= H_min
  /\ state' = "QUARANTINE"
  /\ ext_support' = FALSE
  /\ timer' = 0
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 5,
                       state_from |-> state,
                       state_to |-> state',
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<scores, theta_adj, phi, H, audit_version>>

Degraded ==
  /\ state \in {"MONITORING", "QUARANTINE", "FR_ACTIVE"}
  /\ phi <= theta_adj
  /\ ext_support = FALSE
  /\ state' = "DEGRADED"
  /\ ext_support' = TRUE
  /\ timer' = 0
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 6,
                       state_from |-> state,
                       state_to |-> state',
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<scores, theta_adj, phi, H, audit_version>>

Recover ==
  /\ state \in {"LOCKED", "UNCONSCIOUS", "DEGRADED"}
  /\ phi > theta_adj
  /\ H > H_min
  /\ timer = 0
  /\ state' = "MONITORING"
  /\ ext_support' = FALSE
  /\ timer' = 0 
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 7,
                       state_from |-> state,
                       state_to |-> state',
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<scores, theta_adj, phi, H, audit_version>>

ExitQuarantine ==
  /\ state = "QUARANTINE"
  /\ phi > theta_adj
  /\ state' = "MONITORING"
  /\ ext_support' = FALSE
  /\ timer' = 0
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 8,
                       state_from |-> state,
                       state_to |-> state',
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<scores, theta_adj, phi, H, audit_version>>

UpdateEnv ==
  /\ state \in {"MONITORING", "DEGRADED", "UNCONSCIOUS"}
  /\ state' = state
  /\ phi' \in 0..100
  /\ H' \in 0..100
  /\ Len(audit_log) < MaxLogSize
  /\ LET new_entry == [ts |-> current_time,
                       site |-> 1,
                       action |-> 9,
                       state_from |-> state,
                       state_to |-> state,
                       receipt_id |-> current_time]
     IN /\ audit_log' = audit_log \o <<new_entry>>
        /\ audit_root' = ComputeMerkleRoot(audit_log')
        /\ audit_next_idx' = audit_next_idx + 1
  /\ current_time' = current_time + 1
  /\ UNCHANGED <<scores, ext_support, timer, theta_adj, audit_version>>
Next == AdaptTheta \/ Trigger \/ Evaluate \/ Decide \/ Quarantine \/ Degraded \/ Recover \/ ExitQuarantine
        \* \/ UpdateEnv   \* временно отключаем

Fairness == /\ WF_vars(AdaptTheta)
           /\ WF_vars(Trigger)
           /\ WF_vars(Evaluate)
           /\ WF_vars(Decide)
           /\ WF_vars(Recover)

Init ==
  /\ state = "MONITORING"
  /\ phi \in {0, 30, 60, 100}
  /\ H \in {0, 30, 60, 100}
  /\ scores = <<0,0,0>>
  /\ ext_support = FALSE
  /\ timer = 0
  /\ theta_adj = theta_max
  /\ audit_log = <<>>
  /\ audit_root = InitRoot
  /\ audit_next_idx = 1
  /\ audit_version = 1
  /\ current_time = 0
 
 TimeBound == current_time < 20


Spec == Init /\ [][Next]_vars /\ Fairness
=============================================================================