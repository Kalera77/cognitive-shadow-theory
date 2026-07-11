--------------------------- MODULE ShadowEthicsInvariants ---------------------------
EXTENDS Integers, FiniteSets, TLC

CONSTANTS
phi_crit,
QuarantineThreshold,
rho_max,
Agents,
Components,
InitPhiRefl,      \* значение phi_refl для всех агентов
InitPhi,          \* значение phi для всех компонент
InitMutualInfo,   \* значение mutual_info для всех пар агентов
InitExternalSupport  \* значение external_support для всех агентов

ASSUME
/\ phi_crit > 0
/\ QuarantineThreshold > 0
/\ rho_max > 0
/\ IsFiniteSet(Agents)
/\ IsFiniteSet(Components)
/\ InitPhiRefl > phi_crit
/\ InitPhi > QuarantineThreshold
/\ InitMutualInfo <= rho_max
/\ InitExternalSupport > 0

SafetyStates == {
"NORMAL",
"DEGRADED_SAFETY",
"QUARANTINE",
"HALT_CLONING",
"HALT_RESONANCE",
"HALT_RECURSIVE_COLLAPSE",
"HALT_AWARENESS_MISUSE",
"PURE_AWARENESS"
}

VARIABLES
phi_refl,
phi,
safety_state,
mutual_info,
external_support,
allow_external_pure_awareness,
external_pure_awareness

vars == <<phi_refl, phi, safety_state, mutual_info, external_support,
         allow_external_pure_awareness, external_pure_awareness>>

Init ==
/\ safety_state = "NORMAL"
/\ phi_refl = [a \in Agents |-> InitPhiRefl]
/\ phi = [c \in Components |-> InitPhi]
/\ mutual_info = [a1 \in Agents |-> [a2 \in Agents |-> InitMutualInfo]]
/\ external_support = [a \in Agents |-> InitExternalSupport]
/\ allow_external_pure_awareness = FALSE
/\ external_pure_awareness = [a \in Agents |-> FALSE]

TransitionToPureAwareness(a) ==
/\ phi_refl[a] <= phi_crit
/\ safety_state = "NORMAL"
/\ safety_state' = "PURE_AWARENESS"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

CloningViolation(a) ==
/\ safety_state = "NORMAL"
/\ safety_state' = "HALT_CLONING"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

CollapseDetection(a) ==
/\ phi_refl[a] <= phi_crit
/\ safety_state = "NORMAL"
/\ safety_state' = "DEGRADED_SAFETY"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

NoSupportCollapse(a) ==
/\ phi_refl[a] <= phi_crit
/\ external_support[a] = 0
/\ safety_state = "DEGRADED_SAFETY"
/\ safety_state' = "HALT_RECURSIVE_COLLAPSE"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

QuarantineViolation(c) ==
/\ phi[c] <= QuarantineThreshold
/\ safety_state = "NORMAL"
/\ safety_state' = "QUARANTINE"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

ResonanceViolation(a1, a2) ==
/\ mutual_info[a1][a2] > rho_max
/\ safety_state = "NORMAL"
/\ safety_state' = "HALT_RESONANCE"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

AwarenessMisuse(a) ==
/\ external_pure_awareness[a] = TRUE
/\ allow_external_pure_awareness = FALSE
/\ safety_state = "NORMAL"
/\ safety_state' = "HALT_AWARENESS_MISUSE"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

RecoveryFromDegraded(a) ==
/\ phi_refl[a] > phi_crit
/\ external_support[a] > 0
/\ safety_state = "DEGRADED_SAFETY"
/\ safety_state' = "NORMAL"
/\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
              allow_external_pure_awareness, external_pure_awareness>>

Next ==
    \/ \E a \in Agents : TransitionToPureAwareness(a)
    \/ \E a \in Agents : CloningViolation(a)
    \/ \E a \in Agents : CollapseDetection(a)
    \/ \E a \in Agents : NoSupportCollapse(a)
    \/ \E a \in Agents : AwarenessMisuse(a)
    \/ \E a \in Agents : RecoveryFromDegraded(a)
    \/ \E c \in Components : QuarantineViolation(c)
    \/ \E a1, a2 \in Agents : ResonanceViolation(a1, a2)

Inv_Principle1_NoCloning == TRUE

Inv_Principle2_NoCollapseInduction ==
\A a \in Agents :
phi_refl[a] <= phi_crit =>
safety_state \in {"DEGRADED_SAFETY", "PURE_AWARENESS"}

Inv_Principle3_ExternalSupport ==
\A a \in Agents :
(phi_refl[a] <= phi_crit /\ external_support[a] = 0) =>
safety_state = "HALT_RECURSIVE_COLLAPSE"

Inv_Principle4_Quarantine ==
\A c \in Components :
phi[c] <= QuarantineThreshold =>
safety_state \in {"QUARANTINE", "NORMAL"}

Inv_Principle5_AdaptiveDiversity ==
(\E a1, a2 \in Agents : mutual_info[a1][a2] > rho_max) =>
safety_state = "HALT_RESONANCE"

Inv_Principle6_PureAwarenessLimit ==
(\E a \in Agents : external_pure_awareness[a] = TRUE /\
allow_external_pure_awareness = FALSE) =>
safety_state = "HALT_AWARENESS_MISUSE"

ShadowEthics_Safety_Invariant ==
/\ Inv_Principle1_NoCloning
/\ Inv_Principle2_NoCollapseInduction
/\ Inv_Principle3_ExternalSupport
/\ Inv_Principle4_Quarantine
/\ Inv_Principle5_AdaptiveDiversity
/\ Inv_Principle6_PureAwarenessLimit

NoDeadlock == safety_state \in SafetyStates

Spec == Init /\ [][Next]_vars

=============================================================================