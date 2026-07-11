---------------------------- MODULE FORCED_REPORT_States ----------------------------
EXTENDS Integers, Sequences, TLC

CONSTANTS
  theta_adj,
  H_min,
  grace_period

ASSUME theta_adj > 0 /\ H_min > 0 /\ grace_period >= 1

VARIABLES
  state, phi, H, scores, ext_support, timer

vars == <<state, phi, H, scores, ext_support, timer>>

States == {"MONITORING", "FR_ACTIVE", "LOCKED", "UNCONSCIOUS", "QUARANTINE", "DEGRADED"}
Scores == { <<a,b,c>> : a \in {0,1}, b \in {0,1}, c \in {0,1} }

Init == /\ state = "MONITORING"
        /\ phi \in 0..100
        /\ H \in 0..100
        /\ scores = <<0,0,0>>
        /\ ext_support = FALSE
        /\ timer = 0

ScoreSum(s) == Head(s) + Head(Tail(s)) + Head(Tail(Tail(s)))

Trigger ==
  /\ state = "MONITORING"
  /\ phi <= theta_adj
  /\ H > H_min
  /\ timer = 0
  /\ state' = "FR_ACTIVE"
  /\ timer' = 1
  /\ UNCHANGED <<phi, H, scores, ext_support>>

Evaluate ==
  /\ state = "FR_ACTIVE"
  /\ timer < grace_period
  /\ scores' \in Scores
  /\ timer' = timer + 1
  /\ UNCHANGED <<state, phi, H, ext_support>>

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
  /\ UNCHANGED <<phi, H>>

Quarantine ==
  /\ state \in {"MONITORING", "UNCONSCIOUS"}
  /\ phi <= theta_adj
  /\ H <= H_min
  /\ state' = "QUARANTINE"
  /\ ext_support' = FALSE
  /\ timer' = 0
  /\ UNCHANGED <<scores, phi, H>>

Degraded ==
  /\ state \in {"MONITORING", "QUARANTINE", "FR_ACTIVE"}
  /\ phi <= theta_adj
  /\ ext_support = FALSE
  /\ state' = "DEGRADED"
  /\ ext_support' = TRUE
  /\ timer' = 0
  /\ UNCHANGED <<scores, phi, H>>

Recover ==
  /\ state \in {"LOCKED", "UNCONSCIOUS", "DEGRADED"}
  /\ phi > theta_adj
  /\ H > H_min
  /\ timer = 0
  /\ state' = "MONITORING"
  /\ ext_support' = FALSE
  /\ UNCHANGED <<scores, phi, H, timer>>

ExitQuarantine ==
  /\ state = "QUARANTINE"
  /\ phi > theta_adj
  /\ state' = "MONITORING"
  /\ ext_support' = FALSE
  /\ timer' = 0
  /\ UNCHANGED <<scores, phi, H>>

UpdateEnv ==
  /\ state \in {"MONITORING", "DEGRADED"}
  /\ state' = state
  /\ phi' \in 0..100
  /\ H' \in 0..100
  /\ UNCHANGED <<scores, ext_support, timer>>

Next == Trigger \/ Evaluate \/ Decide \/ Quarantine \/ Degraded \/ Recover \/ UpdateEnv \/ ExitQuarantine

Fairness == /\ WF_vars(Trigger)
           /\ WF_vars(Evaluate)
           /\ WF_vars(Decide)
           /\ WF_vars(Recover)

Spec == Init /\ [][Next]_vars /\ Fairness
TimeBound == timer < 5
Safety ==
  /\ (ext_support <=> (state \in {"LOCKED", "DEGRADED"}))
  /\ (state = "QUARANTINE" => phi <= theta_adj)
  /\ (timer > 0 => state \in {"FR_ACTIVE", "LOCKED", "UNCONSCIOUS"})
  /\ ~(state = "QUARANTINE" /\ ext_support)
  /\ (state \in States)
=============================================================================