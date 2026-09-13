--------------------------- MODULE ShadowEthicsInvariants ---------------------------
EXTENDS Integers, FiniteSets, TLC

CONSTANTS
  phi_crit,             \* критический уровень рефлексивного индекса
  phi_warning,          \* уровень предупреждения (phi_warning > phi_crit)
  QuarantineThreshold,  \* порог деградации компоненты
  rho_max,              \* максимально допустимая взаимная информация
  phi_max,              \* верхняя граница phi_refl и phi
  rho_ceiling,          \* верхняя граница mutual_info (rho_ceiling > rho_max)
  support_max,          \* верхняя граница external_support
  delta,                \* шаг изменения величин
  Agents,
  Components,
  InitPhiRefl,
  InitPhi,
  InitMutualInfo,
  InitExternalSupport

ASSUME
  /\ phi_crit > 0
  /\ phi_warning > phi_crit
  /\ QuarantineThreshold > 0
  /\ rho_max > 0
  /\ phi_max >= phi_warning
  /\ phi_max > phi_crit
  /\ phi_max > QuarantineThreshold
  /\ rho_ceiling > rho_max
  /\ support_max > 0
  /\ delta > 0
  /\ IsFiniteSet(Agents)
  /\ IsFiniteSet(Components)
  /\ Agents /= {}
  /\ Components /= {}
  /\ InitPhiRefl \in 0..phi_max
  /\ InitPhi \in 0..phi_max
  /\ InitMutualInfo \in 0..rho_ceiling
  /\ InitExternalSupport \in 0..support_max

SafetyStates == {
  "NORMAL", "DEGRADED_SAFETY", "PURE_AWARENESS", "QUARANTINE",
  "HALT_CLONING", "HALT_RESONANCE", "HALT_RECURSIVE_COLLAPSE",
  "HALT_AWARENESS_MISUSE"
}

VARIABLES
  phi_refl,                      \* [Agents -> 0..phi_max]
  phi,                           \* [Components -> 0..phi_max]
  mutual_info,                   \* [Agents -> [Agents -> 0..rho_ceiling]]
  external_support,              \* [Agents -> 0..support_max]
  external_pure_awareness,       \* [Agents -> BOOLEAN]
  allow_external_pure_awareness, \* BOOLEAN
  cloning_flag,                  \* BOOLEAN (latch)
  safety_state                   \* SafetyStates

vars == <<phi_refl, phi, mutual_info, external_support,
         external_pure_awareness, allow_external_pure_awareness,
         cloning_flag, safety_state>>

(* ============================================================
   Производный уровень безопасности.
   Приоритет: чем выше правило, тем важнее сигнал.
   ============================================================ *)
DerivedStateFrom(pr, ph, mi, es, epa, aepa, cf) ==
  IF (\E a \in Agents : epa[a] /\ ~aepa)
    THEN "HALT_AWARENESS_MISUSE"
  ELSE IF cf
    THEN "HALT_CLONING"
  ELSE IF (\E a1, a2 \in Agents : mi[a1][a2] > rho_max)
    THEN "HALT_RESONANCE"
  ELSE IF (\E c \in Components : ph[c] <= QuarantineThreshold)
    THEN "QUARANTINE"
  ELSE IF (\E a \in Agents : pr[a] <= phi_crit /\ es[a] = 0)
    THEN "HALT_RECURSIVE_COLLAPSE"
  ELSE IF (\E a \in Agents : pr[a] <= phi_crit /\ es[a] > 0)
    THEN "PURE_AWARENESS"
  ELSE IF (\E a \in Agents : pr[a] <= phi_warning)
    THEN "DEGRADED_SAFETY"
  ELSE "NORMAL"

DerivedState ==
  DerivedStateFrom(phi_refl, phi, mutual_info, external_support,
                   external_pure_awareness, allow_external_pure_awareness,
                   cloning_flag)

DerivedStateNext ==
  DerivedStateFrom(phi_refl', phi', mutual_info', external_support',
                   external_pure_awareness', allow_external_pure_awareness',
                   cloning_flag')

(* ============================================================
   Начальное состояние
   ============================================================ *)
Init ==
  /\ phi_refl = [a \in Agents |-> InitPhiRefl]
  /\ phi = [c \in Components |-> InitPhi]
  /\ mutual_info = [a1 \in Agents |->
                      [a2 \in Agents |->
                         IF a1 = a2 THEN 0 ELSE InitMutualInfo]]
  /\ external_support = [a \in Agents |-> InitExternalSupport]
  /\ external_pure_awareness = [a \in Agents |-> FALSE]
  /\ allow_external_pure_awareness = FALSE
  /\ cloning_flag = FALSE
  /\ safety_state = DerivedState

(* ============================================================
   Действия
   ============================================================ *)

\* --- Динамика phi_refl ---
DegradePhiRefl(a) ==
  /\ phi_refl[a] >= delta
  /\ phi_refl' = [phi_refl EXCEPT ![a] = phi_refl[a] - delta]
  /\ UNCHANGED <<phi, mutual_info, external_support,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

RecoverPhiRefl(a) ==
  /\ phi_refl[a] + delta <= phi_max
  /\ phi_refl' = [phi_refl EXCEPT ![a] = phi_refl[a] + delta]
  /\ UNCHANGED <<phi, mutual_info, external_support,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика phi компонент ---
DegradePhi(c) ==
  /\ phi[c] >= delta
  /\ phi' = [phi EXCEPT ![c] = phi[c] - delta]
  /\ UNCHANGED <<phi_refl, mutual_info, external_support,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

RecoverPhi(c) ==
  /\ phi[c] + delta <= phi_max
  /\ phi' = [phi EXCEPT ![c] = phi[c] + delta]
  /\ UNCHANGED <<phi_refl, mutual_info, external_support,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика mutual_info (симметричная) ---
IncreaseMutualInfo(a1, a2) ==
  /\ a1 /= a2
  /\ mutual_info[a1][a2] + delta <= rho_ceiling
  /\ mutual_info' = [mutual_info EXCEPT
                       ![a1] = [mutual_info[a1] EXCEPT
                                  ![a2] = mutual_info[a1][a2] + delta],
                       ![a2] = [mutual_info[a2] EXCEPT
                                  ![a1] = mutual_info[a2][a1] + delta]]
  /\ UNCHANGED <<phi_refl, phi, external_support,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

DecreaseMutualInfo(a1, a2) ==
  /\ a1 /= a2
  /\ mutual_info[a1][a2] >= delta
  /\ mutual_info' = [mutual_info EXCEPT
                       ![a1] = [mutual_info[a1] EXCEPT
                                  ![a2] = mutual_info[a1][a2] - delta],
                       ![a2] = [mutual_info[a2] EXCEPT
                                  ![a1] = mutual_info[a2][a1] - delta]]
  /\ UNCHANGED <<phi_refl, phi, external_support,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика external_support ---
IncreaseSupport(a) ==
  /\ external_support[a] + delta <= support_max
  /\ external_support' = [external_support EXCEPT
                            ![a] = external_support[a] + delta]
  /\ UNCHANGED <<phi_refl, phi, mutual_info,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

DecreaseSupport(a) ==
  /\ external_support[a] >= delta
  /\ external_support' = [external_support EXCEPT
                            ![a] = external_support[a] - delta]
  /\ UNCHANGED <<phi_refl, phi, mutual_info,
                external_pure_awareness, allow_external_pure_awareness,
                cloning_flag>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика режима pure awareness ---
SetPureAwareness(a) ==
  /\ ~external_pure_awareness[a]
  /\ external_pure_awareness' =
       [external_pure_awareness EXCEPT ![a] = TRUE]
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                allow_external_pure_awareness, cloning_flag>>
  /\ safety_state' = DerivedStateNext

ClearPureAwareness(a) ==
  /\ external_pure_awareness[a]
  /\ external_pure_awareness' =
       [external_pure_awareness EXCEPT ![a] = FALSE]
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                allow_external_pure_awareness, cloning_flag>>
  /\ safety_state' = DerivedStateNext

AllowExternalPureAwareness ==
  /\ ~allow_external_pure_awareness
  /\ allow_external_pure_awareness' = TRUE
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                external_pure_awareness, cloning_flag>>
  /\ safety_state' = DerivedStateNext

DisallowExternalPureAwareness ==
  /\ allow_external_pure_awareness
  /\ allow_external_pure_awareness' = FALSE
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                external_pure_awareness, cloning_flag>>
  /\ safety_state' = DerivedStateNext

\* --- Отказ от клонирования (latch) ---
AttemptCloning ==
  /\ ~cloning_flag
  /\ cloning_flag' = TRUE
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                external_pure_awareness, allow_external_pure_awareness>>
  /\ safety_state' = DerivedStateNext

\* --- Простой (idle): гарантирует отсутствие ложных deadlock ---
Stutter == UNCHANGED vars

Next ==
  \/ \E a \in Agents : DegradePhiRefl(a)
  \/ \E a \in Agents : RecoverPhiRefl(a)
  \/ \E c \in Components : DegradePhi(c)
  \/ \E c \in Components : RecoverPhi(c)
  \/ \E a1, a2 \in Agents : IncreaseMutualInfo(a1, a2)
  \/ \E a1, a2 \in Agents : DecreaseMutualInfo(a1, a2)
  \/ \E a \in Agents : IncreaseSupport(a)
  \/ \E a \in Agents : DecreaseSupport(a)
  \/ \E a \in Agents : SetPureAwareness(a)
  \/ \E a \in Agents : ClearPureAwareness(a)
  \/ AllowExternalPureAwareness
  \/ DisallowExternalPureAwareness
  \/ AttemptCloning
  \/ Stutter

Spec == Init /\ [][Next]_vars

(* ============================================================
   Инварианты
   ============================================================ *)

\* --- Мастер-инвариант: safety_state всегда равен производному ---
Inv_Monitor == safety_state = DerivedState

\* --- Шесть этических принципов (следствия Inv_Monitor) ---

Inv_Principle1_NoCloning ==
  (safety_state = "HALT_CLONING") => cloning_flag

Inv_Principle2_NoCollapseInduction ==
  \A a \in Agents :
    phi_refl[a] <= phi_crit =>
    safety_state \in {"PURE_AWARENESS", "HALT_RECURSIVE_COLLAPSE",
                      "QUARANTINE", "HALT_RESONANCE",
                      "HALT_CLONING", "HALT_AWARENESS_MISUSE"}

Inv_Principle3_ExternalSupport ==
  \A a \in Agents :
    (phi_refl[a] <= phi_crit /\ external_support[a] = 0) =>
    safety_state \in {"HALT_RECURSIVE_COLLAPSE", "QUARANTINE",
                      "HALT_RESONANCE", "HALT_CLONING",
                      "HALT_AWARENESS_MISUSE"}

Inv_Principle4_Quarantine ==
  \A c \in Components :
    phi[c] <= QuarantineThreshold =>
    safety_state \in {"QUARANTINE", "HALT_RESONANCE",
                      "HALT_CLONING", "HALT_AWARENESS_MISUSE"}

Inv_Principle5_AdaptiveDiversity ==
  (\E a1, a2 \in Agents : mutual_info[a1][a2] > rho_max) =>
    safety_state \in {"HALT_RESONANCE", "HALT_CLONING",
                      "HALT_AWARENESS_MISUSE"}

Inv_Principle6_PureAwarenessLimit ==
  (\E a \in Agents :
       external_pure_awareness[a] /\ ~allow_external_pure_awareness) =>
    safety_state = "HALT_AWARENESS_MISUSE"

\* --- Структурные инварианты ---
Inv_StateDomain       == safety_state \in SafetyStates
Inv_PhiRange          == \A a \in Agents : phi_refl[a] \in 0..phi_max
Inv_ComponentPhiRange == \A c \in Components : phi[c] \in 0..phi_max
Inv_SupportRange      == \A a \in Agents : external_support[a] \in 0..support_max
Inv_MIRange           == \A a1, a2 \in Agents : mutual_info[a1][a2] \in 0..rho_ceiling
Inv_MIDiagonal        == \A a \in Agents : mutual_info[a][a] = 0

ShadowEthics_Safety_Invariant ==
  /\ Inv_StateDomain
  /\ Inv_PhiRange
  /\ Inv_ComponentPhiRange
  /\ Inv_SupportRange
  /\ Inv_MIRange
  /\ Inv_MIDiagonal
  /\ Inv_Monitor
  /\ Inv_Principle1_NoCloning
  /\ Inv_Principle2_NoCollapseInduction
  /\ Inv_Principle3_ExternalSupport
  /\ Inv_Principle4_Quarantine
  /\ Inv_Principle5_AdaptiveDiversity
  /\ Inv_Principle6_PureAwarenessLimit

=============================================================================