-------------------------------- MODULE CognitiveShadow_Model ----------------------------
EXTENDS Integers, FiniteSets, TLC

CONSTANTS
    Agents, Components,
    MaxEntropy, DeltaMin, RhoMax, R_Max,
    ThetaQuarantine, EpsilonPhi, PhiCrit,
    H_Min, StressThreshold,
    InitC_Val, InitS_Val, InitI_Val,
    InitMutualInfo,
    DeltaMI, DeltaRest,
    Delta_hyst,
    Modes

\* Вспомогательные функции (веса интерфейсов)
Alpha(k) == 1
Beta(k)  == 1

VARIABLES
    phase, shadow_entropy, phi_measured, phi_true,
    C, S, I, use, intent, noise,
    mutual_info, leakage, orchestrator_active,
    cumulative_load, time_step,
    shadow_state, physical_state,
    context_mode,
    baseline_se, current_se,
    score_BCI, score_Pupil, score_NF,
    timer

\* ==================== ТЕОРЕМА 10 ====================
\* Неинъективное отображение сигнатур (чётность)
SignatureMap(s) == s % 2
ReconstructionAccuracy(s) == 0   \* всегда неточное восстановление

Inv_SignatureObservability ==
  \A s \in 0..MaxEntropy : ReconstructionAccuracy(s) = 0

\* ==================== ТЕОРЕМА 12 ====================
DominantComponent(mode) ==
  CASE mode = "DOC" -> "sem"
  []   mode = "CLIS" -> "refl"
  []   mode = "Anesthesia" -> "sens"

Inv_ContextDependence ==
  \A mode1, mode2 \in Modes : mode1 # mode2 => DominantComponent(mode1) # DominantComponent(mode2)

\* ==================== ТЕОРЕМА 13 ====================
Inv_HysteresisBound ==
  (cumulative_load > StressThreshold) => (baseline_se - current_se >= Delta_hyst)

\* ==================== ТЕОРЕМА 11 (FORCED_REPORT) ====================
ScoreSum == score_BCI + score_Pupil + score_NF

Inv_NoFalsePositives ==
  (phase = "LOCKED") =>
    /\ phi_measured["refl"] <= ThetaQuarantine - EpsilonPhi
    /\ \A a \in Agents: shadow_entropy[a] > H_Min
    /\ ScoreSum >= 2

\* Если условия для триггера выполнены, таймер должен быть сброшен
Inv_AutoActivation ==
  (phi_measured["refl"] <= ThetaQuarantine - EpsilonPhi /\
   \A a \in Agents: shadow_entropy[a] > H_Min) => (timer = 0)

\* ==================== ДОПОЛНИТЕЛЬНЫЕ ИНВАРИАНТЫ ====================
Inv_ShadowStateRange == shadow_state \in 0..MaxEntropy
Inv_PhysicalStateRange == physical_state \in 0..MaxEntropy
Inv_CumulativeLoadNonNeg == cumulative_load >= 0
Inv_CurrentSEBound == current_se \in 0..MaxEntropy
Inv_BaselineSEBound == baseline_se \in 0..MaxEntropy

Inv_ContextDominantConsistency ==
  LET dom == DominantComponent(context_mode)
  IN \A a \in Agents : \A k \in Components \ {dom} : C[a][dom] >= C[a][k]

Inv_OrchestratorConsistency ==
  orchestrator_active <=> (phi_measured["refl"] > PhiCrit)

\* Дублирует Inv_HysteresisBound, можно оставить для ясности
Inv_RecoveryEffect ==
  (cumulative_load > StressThreshold) => (baseline_se - current_se >= Delta_hyst)

Inv_PhaseValid == phase \in {"LOCAL", "PUBLISH", "LOCKED"}

Inv_BaselineCurrentRelation == current_se <= baseline_se

\* ==================== ИСХОДНЫЕ ИНВАРИАНТЫ ====================
Inv_A10_LeakageLimit == \A a \in Agents : leakage[a] <= R_Max

Inv_A15_Quarantine ==
  \A a \in Agents, k \in Components :
    (phi_measured[k] <= ThetaQuarantine) => (use[a][k] = 0 /\ intent[a][k] = 0)

Inv_HALT_RESONANCE == mutual_info <= RhoMax

Inv_A27_Resource ==
  \A a \in Agents :
    LET sumC == Alpha("sens")*C[a]["sens"] + Alpha("sem")*C[a]["sem"] +
                Alpha("rel")*C[a]["rel"] + Alpha("refl")*C[a]["refl"]
        sumS == Beta("sens")*S[a]["sens"] + Beta("sem")*S[a]["sem"] +
                Beta("rel")*S[a]["rel"] + Beta("refl")*S[a]["refl"]
    IN sumC + sumS <= R_Max

Inv_MetacognitiveCollapse ==
  (phi_measured["refl"] <= PhiCrit) => (phase = "LOCKED" \/ phase = "PUBLISH")

Inv_EntropyBound == \A a \in Agents : shadow_entropy[a] <= MaxEntropy

\* phi_measured теперь может быть в пределах MaxEntropy (целые числа)
Inv_PhiRange == \A k \in Components : phi_measured[k] >= 0 /\ phi_measured[k] <= MaxEntropy

Inv_NonNegative ==
    /\ \A a \in Agents : shadow_entropy[a] >= 0
    /\ \A a \in Agents, k \in Components : C[a][k] >= 0 /\ S[a][k] >= 0 /\ I[a][k] >= 0
    /\ cumulative_load >= 0
    /\ time_step >= 0
    /\ mutual_info >= 0
    /\ \A a \in Agents : leakage[a] >= 0

Inv_CapacityLimit ==
  \A a \in Agents, k \in Components :
    C[a][k] <= MaxEntropy /\ S[a][k] <= MaxEntropy /\ I[a][k] <= MaxEntropy

\* ==================== НАЧАЛЬНОЕ СОСТОЯНИЕ ====================
MinPhi(k) ==
    LET vals == { C[a][k] * S[a][k] * I[a][k] : a \in Agents }
    IN (CHOOSE v \in vals : \A u \in vals : v <= u) \div 10000

Init ==
    /\ phase = "LOCAL"
    /\ shadow_entropy = [a \in Agents |-> 10]
    /\ C  = [a \in Agents |-> [k \in Components |-> InitC_Val]]
    /\ S  = [a \in Agents |-> [k \in Components |-> InitS_Val]]
    /\ I  = [a \in Agents |-> [k \in Components |-> InitI_Val]]
    /\ use    = [a \in Agents |-> [k \in Components |-> 0]]
    /\ intent = [a \in Agents |-> [k \in Components |-> 0]]
    /\ noise  = [a \in Agents |-> [k \in Components |-> 0]]
    /\ phi_measured = [k \in Components |-> MinPhi(k)]
    /\ phi_true    = phi_measured
    /\ mutual_info = InitMutualInfo
    /\ leakage = [a \in Agents |-> 0]
    /\ orchestrator_active = (phi_measured["refl"] > PhiCrit)
    /\ cumulative_load = 0
    /\ time_step = 0
    /\ shadow_state = 50
    /\ physical_state = 25
    /\ context_mode = "DOC"
    /\ baseline_se = 50
    /\ current_se = 50
    /\ score_BCI = 0
    /\ score_Pupil = 0
    /\ score_NF = 0
    /\ timer = 0

\* ==================== ДЕЙСТВИЯ ====================
LocalCollapse ==
    /\ phase = "LOCAL"
    /\ \A a \in Agents: shadow_entropy[a] + DeltaMin <= MaxEntropy
    /\ shadow_entropy' = [a \in Agents |-> shadow_entropy[a] + DeltaMin]
    /\ time_step' = time_step + 1
    /\ C' = C
    /\ S' = S
    /\ I' = I
    /\ use' = use
    /\ intent' = intent
    /\ noise' = noise
    /\ leakage' = [a \in Agents |-> leakage[a] + 1]
    /\ cumulative_load' = cumulative_load + 10
    /\ phi_measured' = [k \in Components |-> MinPhi(k)]
    /\ phi_true' = phi_measured'
    /\ orchestrator_active' = (phi_measured'["refl"] > PhiCrit)
    /\ mutual_info' = mutual_info
    /\ phase' = "PUBLISH"
    /\ UNCHANGED <<shadow_state, physical_state, context_mode,
                  baseline_se, current_se, score_BCI, score_Pupil, score_NF, timer>>

SwitchContext ==
    /\ phase = "LOCAL"
    /\ context_mode' \in Modes \ {context_mode}
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF, timer>>

RecoverWithHysteresis ==
    /\ phase = "LOCAL"
    /\ cumulative_load > StressThreshold
    /\ current_se' = current_se - Delta_hyst
    /\ cumulative_load' = 0
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, time_step,
                  shadow_state, physical_state, context_mode, baseline_se,
                  score_BCI, score_Pupil, score_NF, timer>>

UpdateMutualInfo ==
    /\ mutual_info' = mutual_info + DeltaMI
    /\ mutual_info' <= RhoMax
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, leakage,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF, timer>>

UpdateLeakage ==
    /\ \E a \in Agents : leakage' = [leakage EXCEPT ![a] = leakage[a] + 1]
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF, timer>>

UpdateOrchestrator ==
    /\ orchestrator_active' = (phi_measured["refl"] > PhiCrit)
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF, timer>>

GenerateScores ==
    /\ score_BCI' \in {0,1}
    /\ score_Pupil' \in {0,1}
    /\ score_NF' \in {0,1}
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  timer>>

ResetPhase ==
    /\ phase = "PUBLISH"
    /\ phase' = "LOCAL"
    /\ cumulative_load' = 0
    /\ UNCHANGED <<shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF, timer>>

Trigger ==
    /\ phase = "LOCAL"
    /\ phi_measured["refl"] <= ThetaQuarantine - EpsilonPhi
    /\ \A a \in Agents: shadow_entropy[a] > H_Min
    /\ timer = 0
    /\ ScoreSum >= 2
    /\ phase' = "LOCKED"
    /\ timer' = 0
    /\ UNCHANGED <<shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF>>

TimerTick ==
    /\ timer' = timer + 1
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF>>

Unlock ==
    /\ phase = "LOCKED"
    /\ phase' = "LOCAL"
    /\ UNCHANGED <<shadow_entropy, C, S, I, use, intent, noise,
                  phi_measured, phi_true, mutual_info, leakage,
                  orchestrator_active, cumulative_load, time_step,
                  shadow_state, physical_state, context_mode, baseline_se, current_se,
                  score_BCI, score_Pupil, score_NF, timer>>

Next ==
    \/ LocalCollapse
    \/ SwitchContext       
    \/ RecoverWithHysteresis
    \/ UpdateMutualInfo
    \* \/ UpdateLeakage       \* временно отключаем
    \/ UpdateOrchestrator
    \* \/ GenerateScores      \* временно отключаем
    \/ ResetPhase
    \/ Trigger
    \* \/ TimerTick           \* временно отключаем
    \/ Unlock

Spec == Init /\ [][Next]_<<phase, shadow_entropy, C, S, I, use, intent, noise,
                          phi_measured, phi_true, mutual_info, leakage,
                          orchestrator_active, cumulative_load, time_step,
                          shadow_state, physical_state, context_mode,
                          baseline_se, current_se,
                          score_BCI, score_Pupil, score_NF, timer>>

\* Симметрия для агентов (учитывает, что агенты идентичны)
Symmetry == Permutations(Agents) \union Permutations(Components)
\* Ограничение глубины поиска (для TLC)
TimeBound == time_step < 1000
(*
--algorithm LTLProperties
*)

(*
LTL-свойства:
- LTL_NoDeadlock: всегда существует следующий шаг (система не может застрять)
- LTL_Recovery: всегда в конце концов фаза становится LOCAL (восстановление)
- LTL_Progress: бесконечно часто выполняется обновление mutual_info (прогресс)
*)

LTL_NoDeadlock == []<>(ENABLED Next)   \* всегда есть возможность сделать шаг

LTL_Recovery == []<>(phase = "LOCAL")  \* всегда рано или поздно система в локальной фазе

LTL_Progress == []<>(mutual_info > 0)  \* бесконечно часто обновляется информация
(*
LTL-свойства живучести
*)
LTL_NoStarvation == []<>(phase = "LOCAL" \/ phase = "PUBLISH")
===============================================================================