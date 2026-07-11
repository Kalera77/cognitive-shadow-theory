---------------------------- MODULE FORCED_REPORT_AdaptiveThreshold ----------------------------
EXTENDS Integers, Sequences, TLC

CONSTANTS
  theta_raw,      (* базовый порог карантина *)
  H_min,
  theta_min,      (* нижняя граница адаптации *)
  theta_max,      (* верхняя граница адаптации *)
  delta_theta_max,(* макс. шаг изменения порога *)
  grace_period

ASSUME theta_raw > 0 /\ H_min > 0
ASSUME theta_min > 0 /\ theta_max <= theta_raw /\ theta_min <= theta_max
ASSUME delta_theta_max > 0 /\ grace_period >= 1

VARIABLES
  state, phi, H, scores, ext_support, timer, theta_adj

vars == <<state, phi, H, scores, ext_support, timer, theta_adj>>

States == {"MONITORING", "FR_ACTIVE", "LOCKED", "UNCONSCIOUS", "QUARANTINE", "DEGRADED"}
Scores == { <<a,b,c>> : a \in {0,1}, b \in {0,1}, c \in {0,1} }

Init == /\ state = "MONITORING"
        /\ phi \in 0..100
        /\ H \in 0..100
        /\ scores = <<0,0,0>>
        /\ ext_support = FALSE
        /\ timer = 0
        /\ theta_adj = theta_max

ScoreSum(s) == Head(s) + Head(Tail(s)) + Head(Tail(Tail(s)))

AdaptTheta ==
  /\ state \in {"MONITORING", "DEGRADED"}   \* адаптация только в безопасных состояниях
  /\ theta_adj' \in theta_min..theta_max
  /\ theta_adj' - theta_adj <= delta_theta_max
  /\ theta_adj - theta_adj' <= delta_theta_max
  /\ UNCHANGED <<state, phi, H, scores, ext_support, timer>>

Trigger ==
  /\ state = "MONITORING"
  /\ phi <= theta_adj
  /\ H > H_min
  /\ timer = 0
  /\ state' = "FR_ACTIVE"
  /\ timer' = 1
  /\ UNCHANGED <<phi, H, scores, ext_support, theta_adj>>

Evaluate ==
  /\ state = "FR_ACTIVE"
  /\ timer < grace_period
  /\ scores' \in Scores
  /\ timer' = timer + 1
  /\ UNCHANGED <<state, phi, H, ext_support, theta_adj>>

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
  /\ UNCHANGED <<phi, H, theta_adj>>

Quarantine ==
  /\ state \in {"MONITORING", "UNCONSCIOUS"}
  /\ phi <= theta_adj
  /\ H <= H_min
  /\ state' = "QUARANTINE"
  /\ ext_support' = FALSE
  /\ UNCHANGED <<scores, timer, theta_adj, phi, H>>

Degraded ==
  /\ state \in {"MONITORING", "QUARANTINE", "FR_ACTIVE"}
  /\ phi <= theta_adj
  /\ ext_support = FALSE
  /\ state' = "DEGRADED"
  /\ ext_support' = TRUE
  /\ timer' = 0
  /\ UNCHANGED <<scores, theta_adj, phi, H>>

Recover ==
  /\ state \in {"LOCKED", "UNCONSCIOUS", "DEGRADED"}
  /\ phi > theta_adj
  /\ H > H_min
  /\ timer = 0
  /\ state' = "MONITORING"
  /\ ext_support' = FALSE
  /\ timer' = 0
  /\ UNCHANGED <<scores, theta_adj, phi, H>>

ExitQuarantine ==
  /\ state = "QUARANTINE"
  /\ phi > theta_adj
  /\ state' = "MONITORING"
  /\ ext_support' = FALSE
  /\ timer' = 0
  /\ UNCHANGED <<scores, theta_adj, phi, H>>

UpdateEnv ==
  /\ state \in {"MONITORING", "DEGRADED"}
  /\ state' = state
  /\ phi' \in 0..100
  /\ H' \in 0..100
  /\ UNCHANGED <<scores, ext_support, timer, theta_adj>>

Next == AdaptTheta \/ Trigger \/ Evaluate \/ Decide \/ Quarantine \/ Degraded \/ Recover \/ ExitQuarantine
        \* \/ UpdateEnv   \* временно отключаем для ограничения пространства состояний

Fairness == /\ WF_vars(AdaptTheta)
           /\ WF_vars(Trigger)
           /\ WF_vars(Evaluate)
           /\ WF_vars(Decide)
           /\ WF_vars(Recover)

Spec == Init /\ [][Next]_vars /\ Fairness
TimeBound == timer < 3
Safety ==
  /\ (ext_support <=> (state \in {"LOCKED", "DEGRADED"}))
  /\ (state = "QUARANTINE" => phi <= theta_adj)
  /\ (timer > 0 => state \in {"FR_ACTIVE", "LOCKED", "UNCONSCIOUS"})
  /\ ~(state = "QUARANTINE" /\ ext_support)
  /\ (state \in States)
  /\ theta_min <= theta_adj
  /\ theta_adj <= theta_raw

(*
THEOREM Spec => []Safety
PROOF ...
*)
=============================================================================