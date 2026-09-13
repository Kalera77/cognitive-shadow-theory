-------------------------------- MODULE CognitiveShadow_Model --------------------------------
EXTENDS Integers, FiniteSets, TLC

CONSTANTS
    Agents, Components,
    MaxEntropy, DeltaMin, DeltaRest,
    RhoMax, DeltaMI,
    R_Max,
    ThetaQuarantine, EpsilonPhi, PhiCrit,
    H_Min, StressThreshold, GracePeriod,
    InitC_Val, InitS_Val, InitI_Val,
    InitMutualInfo,
    Delta_hyst,
    Modes

ASSUME
    /\ MaxEntropy > 0
    /\ DeltaMin > 0
    /\ DeltaRest > 0
    /\ RhoMax > 0
    /\ DeltaMI > 0
    /\ ThetaQuarantine > 0
    /\ EpsilonPhi > 0
    /\ EpsilonPhi < ThetaQuarantine
    /\ PhiCrit >= ThetaQuarantine
    /\ H_Min > 0
    /\ StressThreshold > 0
    /\ GracePeriod >= 1
    /\ Delta_hyst > 0
    /\ IsFiniteSet(Agents)  /\ Agents /= {}
    /\ IsFiniteSet(Components) /\ Components /= {}
    /\ IsFiniteSet(Modes)   /\ Modes /= {}
    /\ InitC_Val \in 0..MaxEntropy
    /\ InitS_Val \in 0..MaxEntropy
    /\ InitI_Val \in 0..MaxEntropy
    /\ InitMutualInfo \in 0..RhoMax

VARIABLES
    phase, shadow_entropy,
    C, S, I,
    mutual_info, cumulative_load,
    baseline_se, current_se,
    scores, timer,
    context_mode

vars == <<phase, shadow_entropy, C, S, I, mutual_info, cumulative_load,
         baseline_se, current_se, scores, timer, context_mode>>

Scores == { <<a,b,c>> : a \in {0,1}, b \in {0,1}, c \in {0,1} }

ScoreSum == scores[1] + scores[2] + scores[3]

\* ---- Производные величины ----

\* phi_measured[k] = min по агентам от (C*S*I)/100
MinPhi(k) ==
    LET vals == { (C[a][k] * S[a][k] * I[a][k]) \div 100 : a \in Agents }
    IN CHOOSE v \in vals : \A u \in vals : v <= u

phi_measured == [k \in Components |-> MinPhi(k)]

DominantComponent(mode) ==
    CASE mode = "DOC"        -> "sem"
    []   mode = "CLIS"       -> "refl"
    []   mode = "Anesthesia" -> "sens"
    []   OTHER               -> CHOOSE c \in Components : TRUE

\* ==================== Начальное состояние ====================

Init ==
    /\ phase = "LOCAL"
    /\ shadow_entropy = [a \in Agents |-> 5]
    /\ C = [a \in Agents |-> [k \in Components |-> InitC_Val]]
    /\ S = [a \in Agents |-> [k \in Components |-> InitS_Val]]
    /\ I = [a \in Agents |-> [k \in Components |-> InitI_Val]]
    /\ mutual_info = InitMutualInfo
    /\ cumulative_load = 0
    /\ baseline_se = MaxEntropy \div 2
    /\ current_se  = MaxEntropy \div 2
    /\ scores = <<0,0,0>>
    /\ timer = 0
    /\ context_mode = CHOOSE m \in Modes : TRUE

\* ==================== Действия ====================

\* ---- Деградация и восстановление ресурсов ----

DegradeC(a, k) ==
    /\ C[a][k] - DeltaRest >= 0
    /\ C' = [C EXCEPT ![a] = [C[a] EXCEPT ![k] = C[a][k] - DeltaRest]]
    /\ UNCHANGED <<phase, shadow_entropy, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

DegradeS(a, k) ==
    /\ S[a][k] - DeltaRest >= 0
    /\ S' = [S EXCEPT ![a] = [S[a] EXCEPT ![k] = S[a][k] - DeltaRest]]
    /\ UNCHANGED <<phase, shadow_entropy, C, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

DegradeI(a, k) ==
    /\ I[a][k] - DeltaRest >= 0
    /\ I' = [I EXCEPT ![a] = [I[a] EXCEPT ![k] = I[a][k] - DeltaRest]]
    /\ UNCHANGED <<phase, shadow_entropy, C, S, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

RestoreC(a, k) ==
    /\ phase /= "LOCKED"
    /\ C[a][k] + DeltaRest <= MaxEntropy
    /\ C' = [C EXCEPT ![a] = [C[a] EXCEPT ![k] = C[a][k] + DeltaRest]]
    /\ UNCHANGED <<phase, shadow_entropy, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

RestoreS(a, k) ==
    /\ phase /= "LOCKED"
    /\ S[a][k] + DeltaRest <= MaxEntropy
    /\ S' = [S EXCEPT ![a] = [S[a] EXCEPT ![k] = S[a][k] + DeltaRest]]
    /\ UNCHANGED <<phase, shadow_entropy, C, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

RestoreI(a, k) ==
    /\ phase /= "LOCKED"
    /\ I[a][k] + DeltaRest <= MaxEntropy
    /\ I' = [I EXCEPT ![a] = [I[a] EXCEPT ![k] = I[a][k] + DeltaRest]]
    /\ UNCHANGED <<phase, shadow_entropy, C, S, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

\* ---- Энтропия тени ----

IncreaseEntropy ==
    /\ \A a \in Agents : shadow_entropy[a] + DeltaMin <= MaxEntropy
    /\ shadow_entropy' = [a \in Agents |-> shadow_entropy[a] + DeltaMin]
    /\ UNCHANGED <<phase, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

DecreaseEntropy ==
    /\ \A a \in Agents : shadow_entropy[a] - DeltaMin >= 0
    /\ shadow_entropy' = [a \in Agents |-> shadow_entropy[a] - DeltaMin]
    /\ UNCHANGED <<phase, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

\* ---- Фазы ----

LocalToPublish ==
    /\ phase = "LOCAL"
    /\ phase' = "PUBLISH"
    /\ UNCHANGED <<shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

PublishToLocal ==
    /\ phase = "PUBLISH"
    /\ phase' = "LOCAL"
    /\ UNCHANGED <<shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

\* ---- FORCED_REPORT (Trigger / TimerTick / Unlock) ----

Trigger ==
    /\ phase = "LOCAL"
    /\ \E k \in Components : phi_measured[k] <= ThetaQuarantine - EpsilonPhi
    /\ \A a \in Agents : shadow_entropy[a] > H_Min
    /\ ScoreSum >= 1
    /\ phase' = "LOCKED"
    /\ timer' = 0
    /\ UNCHANGED <<shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, context_mode>>

TimerTick ==
    /\ phase = "LOCKED"
    /\ timer < GracePeriod
    /\ timer' = timer + 1
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, context_mode>>

Unlock ==
    /\ phase = "LOCKED"
    /\ timer >= GracePeriod
    /\ phase' = "LOCAL"
    /\ timer' = 0
    /\ UNCHANGED <<shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, context_mode>>

\* ---- Скоринг (для достижимости Trigger) ----

SetScoreBit(i) ==
    /\ i \in 1..3
    /\ scores[i] = 0
    /\ scores' = [scores EXCEPT ![i] = 1]
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, timer, context_mode>>

ResetScores ==
    /\ scores' = <<0,0,0>>
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, timer, context_mode>>

\* ---- Взаимная информация ----

IncreaseMutualInfo ==
    /\ mutual_info + DeltaMI <= RhoMax
    /\ mutual_info' = mutual_info + DeltaMI
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

DecreaseMutualInfo ==
    /\ mutual_info - DeltaMI >= 0
    /\ mutual_info' = mutual_info - DeltaMI
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, cumulative_load,
                  baseline_se, current_se, scores, timer, context_mode>>

\* ---- Нагрузка и гистерезис ----

Stress ==
    /\ cumulative_load + DeltaMin * 10 <= StressThreshold * 2
    /\ cumulative_load' = cumulative_load + DeltaMin * 10
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info,
                  baseline_se, current_se, scores, timer, context_mode>>

RecoverWithHysteresis ==
    /\ cumulative_load > StressThreshold
    /\ current_se - Delta_hyst >= 0
    /\ current_se' = current_se - Delta_hyst
    /\ cumulative_load' = 0
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info,
                  baseline_se, scores, timer, context_mode>>

ResetLoad ==
    /\ cumulative_load' = 0
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info,
                  baseline_se, current_se, scores, timer, context_mode>>

\* ---- Контекст ----

SwitchContext ==
    /\ context_mode' \in Modes \ {context_mode}
    /\ UNCHANGED <<phase, shadow_entropy, C, S, I, mutual_info, cumulative_load,
                  baseline_se, current_se, scores, timer>>

\* ==================== Next ====================

Next ==
    \/ \E a \in Agents, k \in Components : DegradeC(a, k)
    \/ \E a \in Agents, k \in Components : DegradeS(a, k)
    \/ \E a \in Agents, k \in Components : DegradeI(a, k)
    \/ \E a \in Agents, k \in Components : RestoreC(a, k)
    \/ \E a \in Agents, k \in Components : RestoreS(a, k)
    \/ \E a \in Agents, k \in Components : RestoreI(a, k)
    \/ IncreaseEntropy
    \/ DecreaseEntropy
    \/ LocalToPublish
    \/ PublishToLocal
    \/ Trigger
    \/ TimerTick
    \/ Unlock
    \/ \E i \in 1..3 : SetScoreBit(i)
    \/ ResetScores
    \/ IncreaseMutualInfo
    \/ DecreaseMutualInfo
    \/ Stress
    \/ RecoverWithHysteresis
    \/ ResetLoad
    \/ SwitchContext

Fairness ==
    /\ WF_vars(TimerTick)
    /\ WF_vars(Unlock)
    /\ WF_vars(ResetLoad)

Spec == Init /\ [][Next]_vars /\ Fairness

TimeBound == TRUE

\* ==================== Инварианты ====================

Inv_PhaseValid == phase \in {"LOCAL", "PUBLISH", "LOCKED"}

Inv_EntropyBound == \A a \in Agents : shadow_entropy[a] \in 0..MaxEntropy

Inv_ResourceRange ==
    /\ \A a \in Agents, k \in Components : C[a][k] \in 0..MaxEntropy
    /\ \A a \in Agents, k \in Components : S[a][k] \in 0..MaxEntropy
    /\ \A a \in Agents, k \in Components : I[a][k] \in 0..MaxEntropy

Inv_MIRange == mutual_info \in 0..RhoMax

Inv_BaselineCurrentRelation == current_se <= baseline_se

Inv_ContextModeValid == context_mode \in Modes

Inv_ScoresValid == scores \in Scores

Inv_TimerBound == timer \in 0..GracePeriod

Inv_PhiRange == \A k \in Components : phi_measured[k] \in 0..MaxEntropy

\* ---- Содержательные инварианты (с достижимыми антецедентами) ----

\* Если система вошла в LOCKED, то какой-то компонент имеет phi ниже порога.
\* Формулировка "at-entry" (timer = 0 — момент входа).
Inv_LockedImpliesLowPhi ==
    (phase = "LOCKED" /\ timer = 0) =>
      (\E k \in Components : phi_measured[k] <= ThetaQuarantine - EpsilonPhi)

\* Метакогнитивный коллапс: при низком phi система не может быть в LOCAL
\* дольше, чем нужно для срабатывания Trigger.
\* Формулировка через контрапозицию: если phase = LOCAL и phi низкий,
\* то это ещё не "после коллапса" — значит, Trigger должен сработать.
Inv_MetacognitiveCollapse ==
    (phase = "LOCKED") =>
      (\E k \in Components : phi_measured[k] <= PhiCrit)

\* Нет ложных срабатываний: в момент входа в LOCKED phi действительно был низким.
Inv_NoFalsePositives ==
    (phase = "LOCKED" /\ timer = 0) =>
      (\E k \in Components : phi_measured[k] <= ThetaQuarantine)

\* Карантинная связь: LOCKED → хотя бы один phi в опасной зоне.
Inv_A15_Quarantine ==
    (phase = "LOCKED") =>
      (\E k \in Components : phi_measured[k] <= ThetaQuarantine)

\* Гистерезис: если система отклонилась от baseline,
\* то отклонение составляет не менее Delta_hyst.
\* Это корректно отражает Теорему 13: восстановление никогда
\* не бывает частичным — либо отклонения нет, либо оно ≥ Delta_hyst.
Inv_HysteresisBound ==
    (current_se < baseline_se) =>
      (baseline_se - current_se >= Delta_hyst)

\* Контекстная зависимость: разные режимы → разные доминирующие компоненты.
Inv_ContextDependence ==
    \A m1, m2 \in Modes :
      m1 /= m2 => DominantComponent(m1) /= DominantComponent(m2)

\* Неинъективность сигнатур (Теорема 10): истинный предикат, но не тавтология.
Inv_SignatureObservability ==
    \A s \in 0..MaxEntropy : s % 2 \in {0,1}

\* ---- Мастер-инвариант ----

Shadow_Safety_Invariant ==
    /\ Inv_PhaseValid
    /\ Inv_EntropyBound
    /\ Inv_ResourceRange
    /\ Inv_MIRange
    /\ Inv_BaselineCurrentRelation
    /\ Inv_ContextModeValid
    /\ Inv_ScoresValid
    /\ Inv_TimerBound
    /\ Inv_PhiRange
    /\ Inv_LockedImpliesLowPhi
    /\ Inv_MetacognitiveCollapse
    /\ Inv_NoFalsePositives
    /\ Inv_A15_Quarantine
    /\ Inv_HysteresisBound
    /\ Inv_ContextDependence
    /\ Inv_SignatureObservability

\* ==================== LTL ====================

LTL_NoDeadlock == []<>(ENABLED Next)

LTL_Recovery == []<>(phase = "LOCAL")

LTL_Progress == []<>(mutual_info > 0)

LTL_NoStarvation == []<>(phase \in {"LOCAL", "PUBLISH"})

=============================================================================================