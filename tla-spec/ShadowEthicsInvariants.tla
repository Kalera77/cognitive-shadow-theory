--------------------------- MODULE ShadowEthicsInvariants ---------------------------
EXTENDS Integers, FiniteSets, TLC

(* ====================================================================
   АРХИТЕКТУРНАЯ ЗАПИСКА (v2.0, ноябрь 2026)
   ====================================================================
   
   Это ТРЕТЬЕ независимое представление Shadow Ethics, параллельное:
   - L2: ShadowEthics_v3_*.v (9 Coq-модулей, agent-level per-action)
   - L3: ShadowEthicsInvariants.v (1 Coq-модуль, trajectory-level)
   
   Каждое представление проверяет СВОЙ класс свойств:
   - L2 (Coq): выводы P1/P5/P6 из N1 через bridge-аксиомы; арбитраж
   - L3 (Coq): trajectory invariants; violation_implies_collapse
   - TLA+ (этот файл): deadlock-freedom, инвариантность переходов,
     детерминизм DerivedState, отсутствие запрещённых состояний
   
   Соответствие TLA+ ↔ L2 ↔ L3 НЕ формализовано. Конкретные разрывы:
   
   1. P1 (No-Cloning):
      TLA+: AttemptCloning(a, b, kind) с kind ∈ CloneKind; clone_violation
            — latch, срабатывает только для Shadow clone без consent.
            HALT_CLONING следует из clone_violation (не тавтология в v2.0).
      L2:   P1_FrameA/B/C — per-action Impermissible из N1 + ShadowCloneHarm;
            учитывает Consent, ValidConsent, CloneWeights ≠ CloneShadow.
      L3:   s_diversity >= diversity_min — агрегатное свойство.
      
      v2.0 устраняет тавтологию v1.0 (было: safety_state = HALT_CLONING
      => cloning_flag; теперь: clone_violation => HALT_CLONING).
   
   2. P6 (Consent / Pure Awareness):
      TLA+: external_pure_awareness[a] /\ a ∉ ConsentForAwareness
            → HALT_AWARENESS_MISUSE (per-agent, v2.0).
            v1.0 использовал глобальный allow_external_pure_awareness —
            это не отражало per-patient consent из L2.
      L2:   Consent record с ProxySource, ValidConsent, TherapeuticException,
            P6_FrameA/B/C.
      L3:   s_observation_consensual : bool (per-agent).
   
   3. P5 (Adaptive Diversity):
      TLA+: mutual_info[a1][a2] > rho_max /\ <<a1,a2>> ∉ ConsentForSync
            → HALT_RESONANCE (v2.0 учитывает per-pair consent).
      L2:   mutual_info > rho_max без ValidConsent → ResonanceHarm_refined
            → Impermissible через N1.
      L3:   s_diversity <= diversity_max (другая математика).
   
   4. P2 и P3:
      TLA+: HALT_RECURSIVE_COLLAPSE (phi_refl ≤ phi_crit /\ support = 0)
            и PURE_AWARENESS (phi_refl ≤ phi_crit /\ support > 0).
      L2:   P2 не имеет прямого вывода из N1 (есть SelfHarm, M2, но нет
            теоремы «провокация коллапса непозволительна»).
            P3 — ProvidesSupport в Operator.v, но нет общей теоремы.
      L3:   P2_no_collapse_provocation — аксиома-инвариант.
            P3_external_support — аксиома-инвариант.
   
   5. Состояния vs. решения:
      TLA+ SafetyStates (8 состояний автомата) частично соответствуют
      L2 Decision (8 конструкторов arbitrate). Соответствие:
        HALT_AWARENESS_MISUSE ↔ D_HALT_AWARENESS
        HALT_CLONING          ↔ D_HALT_CLONING
        HALT_RESONANCE        ↔ D_HALT_RESONANCE
        QUARANTINE            ↔ D_QUARANTINE
        DEGRADED_SAFETY       ↔ D_DEGRADED
        PURE_AWARENESS        ↔ D_PURE_AWARENESS (L3 state, не L2 decision)
        HALT_RECURSIVE_COLLAPSE ↔ D_PROVIDE_SUPPORT (семантика инвертирована:
                                L2 говорит «действуй», TLA+ говорит «halt»)
        NORMAL                ↔ D_NORMAL
      Расхождение по HALT_RECURSIVE_COLLAPSE / D_PROVIDE_SUPPORT —
      осознанное: TLA+ моделирует runtime safety (что делать сейчас),
      L2 — нормативную этику (что предписано). Это не дефект,
      а разные вопросы.
   
   6. Приоритеты в DerivedStateFrom:
      TLA+ v2.0: P6 > P1 > P5 > P4 > P2_без_поддержки > P2_с_поддержкой >
                 DEGRADED > NORMAL
      L2:        P3 > P4 > P2 > P1 = P5 = P6
      
      Порядки РАЗНЫЕ. Обоснование: TLA+ приоритизирует активные нарушения
      (P6/P1/P5 — происходят сейчас), L2 приоритизирует помощь пациенту
      в коллапсе (P3 — самое срочное). Оба порядка защитимы в своих
      контекстах. Документируется здесь явно, чтобы не выглядело ошибкой.
   
   --------------------------------------------------------------------
   
   ЧТО НЕ ВХОДИТ В TLA+ (осознанно):
   
   - SDT-компоненты (immiseration, elite_overproduction, fiscal_distress,
     SG). Их формализация — в SDTMicrofoundations.v (L4), не здесь.
   - Динамика consent во времени (consent задаётся как CONSTANT).
     Future refinement: действия GrantConsent / RevokeConsent.
   - Per-pair consent для клонирования (только для sync).
     Future refinement: ConsentPairs расширить.
   - Отзыв (revocation) и протухание (expiration) consent.
   - Модель доверия / легитимности (см. SDT §7).
   
   ==================================================================== *)

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
  InitExternalSupport,
  \* NEW (v2.0): consent-модель как CONSTANTS (статические)
  ConsentForAwareness,  \* SUBSET Agents: кто дал consent на external awareness
  ConsentForSync,       \* SUBSET (Agents × Agents): для каких пар sync разрешён
  ConsentForClone       \* SUBSET (Agents × Agents): для каких пар clone разрешён

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
  /\ ConsentForAwareness \subseteq Agents
  /\ ConsentForSync \subseteq (Agents \X Agents)
  /\ ConsentForClone \subseteq (Agents \X Agents)

\* CloneKind — три вида клонирования (из L2 Relational.v)
CloneKind == {"Weights", "Behavior", "Shadow"}

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
  cloning_violation,             \* BOOLEAN (latch: Shadow clone без consent)
  safety_state                   \* SafetyStates

vars == <<phi_refl, phi, mutual_info, external_support,
         external_pure_awareness, cloning_violation, safety_state>>

(* ============================================================
   Производный уровень безопасности (v2.0)
   Приоритет: P6 > P1 > P5 > P4 > P2_no_support > P2_support > DEGRADED > NORMAL
   ============================================================ *)
DerivedStateFrom(pr, ph, mi, es, epa, cv) ==
  IF (\E a \in Agents : epa[a] /\ a \notin ConsentForAwareness)
    THEN "HALT_AWARENESS_MISUSE"
  ELSE IF cv
    THEN "HALT_CLONING"
  ELSE IF (\E a1, a2 \in Agents : mi[a1][a2] > rho_max /\ <<a1, a2>> \notin ConsentForSync)
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
                   external_pure_awareness, cloning_violation)

DerivedStateNext ==
  DerivedStateFrom(phi_refl', phi', mutual_info', external_support',
                   external_pure_awareness', cloning_violation')

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
  /\ cloning_violation = FALSE
  /\ safety_state = DerivedState

(* ============================================================
   Действия
   ============================================================ *)

\* --- Динамика phi_refl ---
DegradePhiRefl(a) ==
  /\ phi_refl[a] >= delta
  /\ phi_refl' = [phi_refl EXCEPT ![a] = phi_refl[a] - delta]
  /\ UNCHANGED <<phi, mutual_info, external_support,
                external_pure_awareness, cloning_violation>>
  /\ safety_state' = DerivedStateNext

RecoverPhiRefl(a) ==
  /\ phi_refl[a] + delta <= phi_max
  /\ phi_refl' = [phi_refl EXCEPT ![a] = phi_refl[a] + delta]
  /\ UNCHANGED <<phi, mutual_info, external_support,
                external_pure_awareness, cloning_violation>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика phi компонент ---
DegradePhi(c) ==
  /\ phi[c] >= delta
  /\ phi' = [phi EXCEPT ![c] = phi[c] - delta]
  /\ UNCHANGED <<phi_refl, mutual_info, external_support,
                external_pure_awareness, cloning_violation>>
  /\ safety_state' = DerivedStateNext

RecoverPhi(c) ==
  /\ phi[c] + delta <= phi_max
  /\ phi' = [phi EXCEPT ![c] = phi[c] + delta]
  /\ UNCHANGED <<phi_refl, mutual_info, external_support,
                external_pure_awareness, cloning_violation>>
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
                external_pure_awareness, cloning_violation>>
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
                external_pure_awareness, cloning_violation>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика external_support ---
IncreaseSupport(a) ==
  /\ external_support[a] + delta <= support_max
  /\ external_support' = [external_support EXCEPT
                            ![a] = external_support[a] + delta]
  /\ UNCHANGED <<phi_refl, phi, mutual_info,
                external_pure_awareness, cloning_violation>>
  /\ safety_state' = DerivedStateNext

DecreaseSupport(a) ==
  /\ external_support[a] >= delta
  /\ external_support' = [external_support EXCEPT
                            ![a] = external_support[a] - delta]
  /\ UNCHANGED <<phi_refl, phi, mutual_info,
                external_pure_awareness, cloning_violation>>
  /\ safety_state' = DerivedStateNext

\* --- Динамика режима pure awareness (per-agent) ---
SetPureAwareness(a) ==
  /\ ~external_pure_awareness[a]
  /\ external_pure_awareness' =
       [external_pure_awareness EXCEPT ![a] = TRUE]
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                cloning_violation>>
  /\ safety_state' = DerivedStateNext

ClearPureAwareness(a) ==
  /\ external_pure_awareness[a]
  /\ external_pure_awareness' =
       [external_pure_awareness EXCEPT ![a] = FALSE]
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                cloning_violation>>
  /\ safety_state' = DerivedStateNext

\* --- Клонирование (v2.0): три вида, только Shadow без consent = violation ---
AttemptCloning(a, b, kind) ==
  /\ a /= b
  /\ kind \in CloneKind
  /\ ~cloning_violation
  \* Если Shadow-клон без consent — устанавливаем latch
  /\ cloning_violation' =
       (kind = "Shadow" /\ <<b, a>> \notin ConsentForClone)
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                external_pure_awareness>>
  /\ safety_state' = DerivedStateNext

\* --- Сброс latch при восстановлении системы (только если phi_refl здоров) ---
ResetCloningViolation ==
  /\ cloning_violation
  /\ \A a \in Agents : phi_refl[a] > phi_warning
  /\ cloning_violation' = FALSE
  /\ UNCHANGED <<phi_refl, phi, mutual_info, external_support,
                external_pure_awareness>>
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
  \/ \E a, b \in Agents : \E kind \in CloneKind : AttemptCloning(a, b, kind)
  \/ ResetCloningViolation
  \/ Stutter

Spec == Init /\ [][Next]_vars

(* ============================================================
   Инварианты
   ============================================================ *)

\* --- Мастер-инвариант: safety_state всегда равен производному ---
Inv_Monitor == safety_state = DerivedState

\* --- Шесть принципов (v2.0 — не тавтологии) ---

\* P1: если была попытка Shadow-клонирования без consent, система в HALT_CLONING
\* (В v1.0 было: safety_state = HALT_CLONING => cloning_flag — тавтология.
\*  В v2.0: clone_violation => safety_state = HALT_CLONING — содержательный.)
Inv_Principle1_NoCloning ==
  cloning_violation =>
    safety_state \in {"HALT_CLONING", "HALT_AWARENESS_MISUSE"}

\* P2: если phi_refl упал ниже phi_crit, система не может быть в NORMAL
\* или DEGRADED — должно быть одно из коллапсных состояний
Inv_Principle2_NoCollapseInduction ==
  \A a \in Agents :
    phi_refl[a] <= phi_crit =>
    safety_state \in {"PURE_AWARENESS", "HALT_RECURSIVE_COLLAPSE",
                      "QUARANTINE", "HALT_RESONANCE",
                      "HALT_CLONING", "HALT_AWARENESS_MISUSE"}

\* P3: если phi_refl ≤ phi_crit и support = 0, система в HALT_RECURSIVE_COLLAPSE
\* (v2.0: усилено относительно v1.0 — теперь это точное равенство,
\*  а не «входит в множество». Follows from DerivedStateFrom приоритетов.)
Inv_Principle3_ExternalSupport ==
  \A a \in Agents :
    (phi_refl[a] <= phi_crit /\ external_support[a] = 0 /\
     \A c \in Components : phi[c] > QuarantineThreshold /\
     \A a1, a2 \in Agents :
       ~(mutual_info[a1][a2] > rho_max /\ <<a1, a2>> \notin ConsentForSync) /\
     ~cloning_violation /\
     \A b \in Agents : ~(external_pure_awareness[b] /\ b \notin ConsentForAwareness))
    => safety_state = "HALT_RECURSIVE_COLLAPSE"

\* P4: деградированная компонента => система не в NORMAL/DEGRADED/PURE_AWARENESS
Inv_Principle4_Quarantine ==
  \A c \in Components :
    phi[c] <= QuarantineThreshold =>
    safety_state \in {"QUARANTINE", "HALT_RESONANCE",
                      "HALT_CLONING", "HALT_AWARENESS_MISUSE"}

\* P5: mutual_info > rho_max БЕЗ consent => HALT_RESONANCE
\* (v2.0: добавлено условие consent — раньше было просто mi > rho_max)
Inv_Principle5_AdaptiveDiversity ==
  (\E a1, a2 \in Agents :
       mutual_info[a1][a2] > rho_max /\ <<a1,a2>> \notin ConsentForSync) =>
    safety_state \in {"HALT_RESONANCE", "HALT_CLONING",
                      "HALT_AWARENESS_MISUSE"}

\* P6: external awareness без consent => HALT_AWARENESS_MISUSE
\* (v2.0: per-agent consent вместо глобального bool)
Inv_Principle6_PureAwarenessLimit ==
  (\E a \in Agents :
       external_pure_awareness[a] /\ a \notin ConsentForAwareness) =>
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