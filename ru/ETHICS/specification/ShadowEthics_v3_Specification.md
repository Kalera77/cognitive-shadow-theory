
# `ShadowEthics_v3_Specification.md`

**Статус:** Прозаическое зеркало Coq-модулей v3.0. Один-к-одному соответствие.
**Связь с нарративом:** `Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md` (v3.0).
**Аудитория:** разработчики, рецензенты, аудиторы.
**Дата:** Октябрь 2026.
**Лицензия:** Текст — CC BY-NC 4.0; код — MIT.

---

## 0. Назначение

Этот документ — **техническое** зеркало Coq-модулей v3.0. Он не объясняет **почему** (это делает нарратив), а фиксирует **что** именно формализовано, **где** и **с каким статусом** (теорема / аксиома / параметр).

Для каждого модуля:
- Список определений, аксиом, теорем.
- Статус каждого утверждения.
- Ссылка на строку (приблизительно).
- Связь с нарративом.

---

## 1. `ShadowEthics_v3_Foundations.v`

### 1.1. Типы

| Определение | Строка | Статус |
|---|---|---|
| `Agent : Type` | 12 | Параметр |
| `Time := nat` | 13 | Определение |
| `Action : Type` | 14 | Параметр |
| `observe : Agent → Action` | 16 | Параметр |
| `clone : Agent → Action` | 17 | Параметр |
| `synchronize : Agent → Action` | 18 | Параметр |
| `use_ai : Agent → Agent → Action` | 19 | Параметр |

### 1.2. Тень и self-harm

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `ShadowOf : Agent → Prop` | 25 | Параметр |
| `phi_refl : Agent → Time → R` | 26 | Параметр |
| `phi_crit : R` | 27 | Параметр |
| `Load : Agent → Time → R` | 28 | Параметр |
| `Delta_crit : R` | 29 | Параметр |
| `phi_crit_pos` | 31 | Аксиома (PHYS) |
| `Delta_crit_nonneg` | 32 | Аксиома (CALIB) |
| `SelfHarm a t := phi_refl a t ≤ phi_crit ∨ Load a t ≥ Delta_crit` | 34 | Определение |

### 1.3. Согласие (revised)

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `Scope` | 42 | Индуктивный тип |
| `ProxySource` | 48 | Индуктивный тип |
| `Consent` (Record) | 56 | Record |
| `consent_source : ProxySource` | 64 | Поле (NEW) |
| `ValidConsent : Consent → Agent → Action → Time → Prop` | 67 | Параметр |
| `consent_matches_agent` (усилена) | 71 | Аксиома (STRUCT) |
| `consent_matches_action` | 76 | Аксиома (STRUCT) |
| `consent_self_no_proxy` | 81 | Аксиома (STRUCT) |
| `consent_proxy_has_proxy` | 87 | Аксиома (STRUCT) |

### 1.4. Нормативные аксиомы

| Аксиома | Строка | Статус |
|---|---|---|
| `MoralAgent : Agent → Prop` | 97 | Параметр |
| `MoralPatient : Agent → Prop` | 98 | Параметр |
| `Impermissible : Agent → Agent → Action → Time → Prop` | 99 | Параметр |
| `HarmedPatient : Agent → Time → Prop` | 100 | Параметр |
| `CompleteKnowledge : Agent → Agent → Prop` | 101 | Параметр |
| `N1` | 105 | **Аксиома (нормативная)** |
| `M1` | 113 | **Аксиома (из Теоремы 10)** |
| `M2` | 122 | **Аксиома (нормативная)** |

### 1.5. Harm

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `ObservationHarm` | 132 | Параметр |
| `CloningHarm` | 133 | Параметр |
| `ResonanceHarm` | 134 | Параметр |
| `IsolationHarm` | 135 | Параметр |
| `MoralPatient_has_shadow` | 137 | Аксиома (STRUCT) |
| `ObservationHarmBridge` | 142 | **Аксиома (bridge)** |
| `CloningHarmBridge` | 149 | **Аксиома (bridge)** |
| `ResonanceHarmBridge` | 156 | **Аксиома (bridge)** |
| `IsolationHarmBridge` | 163 | **Аксиома (bridge)** |
| `Harm` | 170 | Определение |

### 1.6. Моральные пациенты

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `PatientClass` | 180 | Индуктивный тип |
| `PatientClassOf` | 187 | Параметр |
| `PresumptionOfConsciousness` | 188 | Параметр |
| `Full_patient` | 190 | Аксиома (CLASSIFY) |
| `Proxy_patient` | 192 | Аксиома (CLASSIFY) |
| `Minimal_patient` | 194 | Аксиома (CLASSIFY) |
| `Presumption_patient` | 196 | Аксиома (CLASSIFY) |

### 1.7. Рамки

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `IsHuman`, `IsAI`, `UsesAIFor` | 202–204 | Параметры |
| `Humans_moral_agents` | 206 | Аксиома (FRAME) |
| `Humans_moral_patients` | 207 | Аксиома (FRAME) |
| `AI_not_moral_agent_A` | 208 | Аксиома (FRAME) |
| `AI_presumed_patient` | 209 | Аксиома (FRAME) |
| `AI_moral_agents` | 211 | Аксиома (FRAME) |
| `P6_FrameA` | 218 | **Теорема** |
| `P6_FrameB` | 232 | **Теорема** |
| `FrameC` | 247 | Определение |
| `P6_FrameC` | 249 | **Теорема** |

---

## 2. `ShadowEthics_v3_Relational.v`

### 2.1. Distillation fix

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `CloneKind` | 35 | Индуктивный тип |
| `AttemptClone : Agent → Agent → CloneKind → Time → Prop` | 41 | Параметр |
| `WeightsClone_not_shadow` | 47 | Аксиома (STRUCT) |
| `BehaviorClone_not_shadow` | 52 | Аксиома (STRUCT) |

### 2.2. Refinement

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `ShadowCloneHarm` | 67 | Параметр |
| `ShadowCloneHarm_implies_CloningHarm` | 69 | Аксиома (REFINE) |
| `ShadowCloneHarm_iff` | 73 | Аксиома (DEF) |
| `WeightsClone_no_P1` | 84 | **Лемма** |
| `BehaviorClone_no_P1` | 92 | **Лемма** |

### 2.3. P5 machinery

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `mutual_info : Agent → Agent → Time → R` | 105 | Параметр |
| `rho_max : R` | 106 | Параметр |
| `rho_max_pos` | 108 | Аксиома (CALIB) |
| `mutual_info_nonneg` | 109 | Аксиома (STRUCT) |
| `ResonanceHarm_refined` | 118 | Параметр |
| `ResonanceHarm_refined_implies` | 120 | Аксиома (REFINE) |
| `ResonanceHarm_iff` | 124 | Аксиома (DEF) |

### 2.4. P1 в трёх рамках

| Теорема | Строка | Статус |
|---|---|---|
| `UsesAIFor_clone_shadow` | 145 | Аксиома (FRAME) |
| `P1_FrameA` | 154 | **Теорема** |
| `P1_FrameB` | 184 | **Теорема** |
| `P1_FrameC` | 214 | **Теорема** |

### 2.5. P5 в трёх рамках

| Теорема | Строка | Статус |
|---|---|---|
| `P5_FrameA` | 250 | **Теорема** |
| `P5_FrameB` | 285 | **Теорема** |
| `P5_FrameC` | 322 | **Теорема** |
| `P5_with_consent_allowed` | 356 | **Лемма** |
| `Relational_Ethics_Family` | 375 | **Теорема** (синтез) |

---

## 3. `ShadowEthics_v3_Arbitration.v`

### 3.1. Типы

| Определение | Строка | Статус |
|---|---|---|
| `Violation` | 22 | Индуктивный тип |
| `Decision` | 30 | Индуктивный тип |

### 3.2. Приоритет

| Определение | Строка | Статус |
|---|---|---|
| `priority` | 78 | Определение |
| `decision_of_violation` | 88 | Определение |

### 3.3. Арбитраж

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `pick_min` | 100 | Fixpoint |
| `arbitrate` | 112 | Определение |
| `AuditEntry` | 122 | Record |
| `AuditLog := list AuditEntry` | 130 | Определение |
| `make_entry` | 132 | Определение |
| `log_append` | 136 | Определение |

### 3.4. Леммы

| Лемма | Строка | Статус |
|---|---|---|
| `pick_min_none_empty` | 143 | **Лемма** |
| `pick_min_in` | 152 | **Лемма** |
| `pick_min_minimal` | 168 | **Лемма** |
| `pick_min_some_of_nonempty` | 190 | **Лемма** |

### 3.5. Теоремы

| Теорема | Строка | Статус |
|---|---|---|
| `arbitrate_total` | 206 | **Теорема** |
| `arbitrate_empty` | 209 | **Теорема** |
| `arbitrate_single` | 212 | **Теорема** |
| `no_deadlock` | 215 | **Теорема** |
| `arbitrate_deterministic` | 224 | **Теорема** |
| `P3_strictly_highest` | 230 | **Лемма** |
| `relational_equal` | 238 | **Лемма** |
| `audit_completeness` | 245 | **Теорема** |
| `audit_decision` | 249 | **Теорема** |
| `audit_trigger` | 253 | **Теорема** |
| `P3_overrides_P6` | 264 | **Теорема** |
| `P4_overrides_P5` | 290 | **Теорема** |

---

## 4. `ShadowEthics_v3_Operator.v`

### 4.1. Роли

| Определение | Строка | Статус |
|---|---|---|
| `Role` | 32 | Индуктивный тип |
| `HasRole : Agent → Role → Prop` | 37 | Параметр |
| `Deploys : Agent → Agent → Prop` | 38 | Параметр |
| `IsDeveloper`, `IsDeployer`, `IsUser`, `IsOps` | 40–43 | Определения |
| `IsOperator` | 45 | Определение |
| `Operators_are_humans` | 53 | Аксиома (FRAME) |

### 4.2. Обязанности

| Определение | Строка | Статус |
|---|---|---|
| `O1_Monitoring` | 65 | Параметр |
| `O2_ProxyConsent` | 66 | Параметр |
| `O3_SupportPlan` | 67 | Параметр |
| `O4_Audit` | 68 | Параметр |
| `OperatorLayer` | 70 | Определение |

### 4.3. Executability

| Определение | Строка | Статус |
|---|---|---|
| `P1_Executable` ... `P6_Executable` | 145–156 | Определения |

### 4.4. Теоремы

| Теорема | Строка | Статус |
|---|---|---|
| `SupportRequiresDetection` | 82 | Аксиома (BRIDGE) |
| `SupportRequiresPlan` | 88 | Аксиома (BRIDGE) |
| `ConsentRequiresManagement` | 94 | Аксиома (BRIDGE) |
| `P3_unsatisfiable_without_O1` | 162 | **Теорема** |
| `P3_unsatisfiable_without_O3` | 170 | **Теорема** |
| `P3_needs_operator_layer` | 178 | **Теорема** |
| `P6_needs_operator_layer` | 190 | **Теорема** |
| `all_principles_executable` | 202 | **Теорема** |

### 4.5. Ответственность

| Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `OperatorNegligence` | 226 | **Аксиома (нормативная)** |
| `OperatorNegligence_missing_O1` | 239 | **Теорема** |
| `OperatorNegligence_missing_O3` | 253 | **Теорема** |
| `EthicsFrame` | 270 | Индуктивный тип |
| `Liable` | 275 | Параметр |
| `FrameA_StrictLiability` | 278 | Аксиома (FRAME) |
| `FrameB_SharedLiability` | 287 | Аксиома (FRAME) |
| `FrameC_ProportionalLiability` | 295 | Аксиома (FRAME) |
| `ethics_requires_operator_layer` | 306 | **Теорема** |

---

## 5. `ShadowEthics_v3_ProxyConsent.v`

### 5.1. Прокси

| Определение | Строка | Статус |
|---|---|---|
| `proxy_priority` | 18 | Определение |
| `CanCommunicate`, `HasAdvanceDirective`, `IsFamily`, `IsEthicsCommittee` | 26–29 | Параметры |
| `ProxyAvailable` | 32 | Определение |

### 5.2. Стандарты решения

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `DecisionStandard` | 47 | Индуктивный тип |
| `WasAutonomous` | 52 | Параметр |
| `applicable_standard` | 53 | Параметр |
| `applicable_standard_autonomous` | 55 | Аксиома (CALIB) |
| `applicable_standard_never` | 58 | Аксиома (CALIB) |

### 5.3. Proxy consent validity

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `PatientWouldChoose`, `IsBestInterest` | 63–64 | Параметры |
| `ProxyConsentValid` | 67 | Определение |
| `ValidConsent_proxy_standard` | 78 | **Аксиома (содержательная)** |

### 5.4. Covers / forbids

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `ProxyCovers` | 88 | Определение |
| `ProxyForbids` | 94 | Определение |
| `ProxyCannotAuthorize` | 101 | Аксиома (CONSTRAINT) |

### 5.5. Therapeutic exception

| Определение | Строка | Статус |
|---|---|---|
| `Audited`, `TimeLimited`, `Minimal`, `NecessaryForSupport` | 113–116 | Параметры |
| `TherapeuticException` | 118 | Определение |

### 5.6. Теоремы

| Теорема | Строка | Статус |
|---|---|---|
| `ConsentSatisfied` | 136 | Определение |
| `FORCED_REPORT_cannot_activate_without_consent` | 168 | **Теорема** |
| `FORCED_REPORT_activation_requires_consent` | 197 | **Теорема** |

---

## 6. `ForcedReportDecision_v3.v`

### 6.1. Состояния

| Определение | Строка | Статус |
|---|---|---|
| `FRState` | 30 | Индуктивный тип |

### 6.2. Сигналы

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `phi_meas`, `phi_true`, `H_shadow` | 42–44 | Параметры |
| `H_min_threshold`, `epsilon_phi_bound`, `QuarantineThreshold`, `QuarantineThreshold_Adjusted_ICU` | 46–49 | Параметры |
| `H_min_threshold_pos`, `epsilon_phi_bound_pos`, `QuarantineThreshold_pos`, `QT_adj_definition` | 51–54 | Аксиомы (CALIB) |
| `A20_error_bound` | 57 | Аксиома (MEASUREMENT) |
| `safe_trigger` | 61 | **Лемма** |

### 6.3. Мультимодальные голоса

| Определение | Строка | Статус |
|---|---|---|
| `BinarySign` | 79 | Индуктивный тип |
| `vote_BCI`, `vote_Pupil`, `vote_NF` | 81–83 | Параметры |
| `sign_to_nat` | 85 | Определение |
| `votes_positive` | 89 | Определение |
| `decision_rule` | 94 | Определение |

### 6.4. Триггер

| Определение | Строка | Статус |
|---|---|---|
| `Trigger` | 116 | Определение |
| `trigger_implies_true_phi_low` | 122 | **Теорема** |

### 6.5. Активация

| Определение | Строка | Статус |
|---|---|---|
| `CanActivate` | 140 | Определение |

### 6.6. Аудит

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `AuditRecorded` | 150 | Параметр |
| `AuditRequired` | 154 | Аксиома (BRIDGE) |

### 6.7. Теоремы

| Теорема | Строка | Статус |
|---|---|---|
| `forced_report_decision_soundness` | 168 | **Теорема** |
| `trigger_diagnosis_consistent` | 197 | **Теорема** |
| `activation_respects_P6` | 218 | **Теорема** |
| `activation_is_audited` | 226 | **Теорема** |
| `activation_without_consent_arbitrates_to_support` | 238 | **Теорема** |
| `no_activation_without_consent_or_exception` | 248 | **Теорема** |

---

## 7. `ShadowEthics_v3_ClinicalAudit.v`

### 7.1. Ground truth

| Определение | Строка | Статус |
|---|---|---|
| `GroundTruthConscious` | 32 | Параметр |

### 7.2. ClinicalOutcome

| Определение | Строка | Статус |
|---|---|---|
| `ClinicalOutcome` | 40 | Индуктивный тип |
| `IsTP`, `IsFP`, `IsFN`, `IsTN` | 50–53 | Определения |

### 7.3. Теоремы об исходах

| Теорема | Строка | Статус |
|---|---|---|
| `outcome_exhaustive` | 56 | **Теорема** |
| `TP_FP_exclusive` | 65 | **Теорема** |
| `TP_FN_exclusive` | 72 | **Теорема** |

### 7.4. ConsentPath

| Определение | Строка | Статус |
|---|---|---|
| `ConsentPath` | 82 | Индуктивный тип |

### 7.5. ClinicalAuditEntry

| Определение | Строка | Статус |
|---|---|---|
| `ClinicalAuditEntry` | 91 | Record |
| `ClinicalAuditLog := list ClinicalAuditEntry` | 102 | Определение |
| `clinical_log : ClinicalAuditLog` | 113 | Параметр |
| `EntryMatches` | 121 | Определение |

### 7.6. Bridge axioms

| Аксиома | Строка | Статус |
|---|---|---|
| `AuditRecorded_realized` | 130 | Аксиома (BRIDGE) |
| `AuditRecorded_from_log` | 137 | Аксиома (BRIDGE) |
| `violation_list_determines_consent_path` | 144 | Аксиома (HONESTY) |
| `outcome_consistency` | 154 | Аксиома (OUTCOME) |

### 7.7. Теоремы

| Теорема | Строка | Статус |
|---|---|---|
| `activation_is_in_log` | 173 | **Теорема** |
| `violations_captured_with_consent` | 186 | **Теорема** |
| `violations_captured_without_consent` | 200 | **Теорема** |
| `no_CP_None_from_activation` | 215 | **Теорема (Admitted)** |

**Примечание:** `no_CP_None_from_activation` — единственный `Admitted` во всей цепочке. Требует `ae_source : EntrySource` в `ClinicalAuditEntry` (технический долг, помечен честно).

### 7.8. Review obligation

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `reviewed` | 232 | Определение |
| `requires_review` | 235 | Определение |
| `Compliant` | 242 | Определение |
| `FP_reviewed_if_compliant` | 248 | **Теорема** |
| `FN_reviewed_if_compliant` | 262 | **Теорема** |
| `exception_reviewed_if_compliant` | 276 | **Теорема** |

### 7.9. Regulator report

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `RegulatorReport` | 298 | Record |
| `regulator_report` | 305 | Параметр |
| `report_total_matches` | 311 | Аксиома (REPORT) |

---

## 8. `ShadowEthics_v3_Alignment.v`

### 8.1. Diversity / Safety / F

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `Diversity`, `Safety`, `F` | 33–35 | Параметры |
| `Diversity_range`, `Safety_range`, `F_range` | 37–39 | Аксиомы (STRUCT) |
| `F_crit`, `Diversity_crit` | 41–42 | Параметры |
| `P5_Warning` | 45 | Определение |

### 8.2. Alignment tax

| Определение | Строка | Статус |
|---|---|---|
| `AlignmentMethod` | 53 | Индуктивный тип |
| `ApplyMethod` | 59 | Параметр |
| `DeltaDiversity`, `DeltaSafety` | 61–64 | Определения |
| `AlignmentTax` | 67 | Определение |

### 8.3. Теоремы

| Теорема | Строка | Статус |
|---|---|---|
| `tax_positive` | 74 | **Теорема** |
| `tax_zero_when_no_safety_gain` | 86 | **Теорема** |
| `alignment_tradeoff` | 100 | Аксиома (HYP) |
| `alignment_tax_strictly_positive` | 107 | **Теорема** |

### 8.4. RLHF

| Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `RLHF_reduces_F` | 124 | Аксиома (HYP) |
| `RLHF_P5_warning` | 129 | **Теорема** |
| `DiversityCollapse` | 135 | Определение |
| `RLHF_may_collapse_diversity` | 139 | Аксиома (HYP) |
| `RLHF_collapse_is_patient_harm` | 144 | **Теорема (тавтологична)** |

### 8.5. Sycophancy

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `Sycophancy` | 163 | Определение |
| `sycophancy_triggers_resonance_harm` | 170 | **Теорема** |
| `sycophancy_is_P5_violation` | 183 | **Теорема** |
| `sycophancy_with_consent_allowed` | 199 | **Теорема** |

### 8.6. Multi-agent sharing

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `SharingLevel`, `M_max_mutual` | 211–212 | Параметры |
| `M_max_above_rho`, `Sharing_range`, `M_max_pos` | 214–216 | Аксиомы (CALIB) |
| `sharing_drives_mutual_info` | 221 | Аксиома (MODEL) |
| `StrongSharing` | 226 | Определение |
| `strong_sharing_exceeds_rho` | 230 | **Теорема** |
| `MultiAgentStrongSharing` | 248 | Определение |
| `multi_agent_strong_sharing_P5_violation` | 253 | **Теорема** |
| `SafeSharingLevel` | 269 | Определение |
| `safe_sharing_no_P5` | 273 | **Теорема** |

### 8.7. Consent-proof harm

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `ConsentProofHarm` | 294 | Параметр |
| `consent_proof_harm_blocks` | 298 | **Аксиома (нормативная)** |

### 8.8. Tax levels

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `TaxLevel` | 311 | Параметр |
| `TaxLevel_nonneg`, `TaxLevel_order` | 312–313 | Аксиомы (CALIB) |
| `PreferredMethod` | 317 | Определение |
| `DPO_has_lower_tax` | 321 | **Теорема** |

---

## 9. `ShadowEthics_v3_MultiAgent.v`

### 9.1. Архитектуры

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `Architecture` | 32 | Индуктивный тип |
| `RoundsBound` | 42 | Параметр |
| `Isolated_rounds` ... `UnboundedConsensus_rounds` | 44–49 | Аксиомы (ARCH) |

### 9.2. Sharing

| Определение / Аксиома | Строка | Статус |
|---|---|---|
| `StateValue`, `LocalState`, `SharedState`, `ViewOfShared` | 57–60 | Параметры |
| `delta_share` | 62 | Параметр |
| `delta_share_pos`, `delta_share_lt_rho` | 63–64 | Аксиомы (CALIB) |
| `sharing_in_rounds` | 66 | Аксиома (MODEL) |

### 9.3. P5-safety

| Определение | Строка | Статус |
|---|---|---|
| `InArch` | 76 | Параметр |
| `P5Safe` | 78 | Определение |

### 9.4. Archimedean

| Лемма | Строка | Статус |
|---|---|---|
| `exists_n_delta_exceeds` | 92 | **Лемма** |

### 9.5. Isolated

| Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `isolated_no_sharing` | 113 | Аксиома (ARCH) |
| `isolated_P5Safe` | 119 | **Теорема** |

### 9.6. BoundedConsensus

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `BoundedConsensusThreshold` | 131 | Определение |
| `ConsensusBudget` | 133 | Определение |
| `bounded_consensus_P5Safe` | 137 | **Теорема** |
| `bounded_consensus_safe_within_budget` | 155 | **Теорема** |

### 9.7. UnboundedConsensus

| Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `unbounded_can_exceed` | 172 | Аксиома (MODEL) |
| `unbounded_consensus_not_P5Safe` | 180 | **Теорема** |

### 9.8. Blackboard

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `BusAbstraction`, `BusAbstraction_range` | 193–194 | Параметр + Аксиома |
| `BlackboardSafe` | 196 | Определение |
| `blackboard_sharing` | 199 | Аксиома (ARCH) |
| `blackboard_P5Safe` | 206 | **Теорема** |

### 9.9. QuarantineFirst

| Определение / Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `Damaged`, `Quarantined` | 228–230 | Параметры / Определение |
| `quarantine_removes` | 232 | Аксиома (ARCH) |
| `quarantine_first_sharing` | 237 | Аксиома (MODEL) |
| `quarantine_first_P5Safe` | 245 | **Теорема** |

### 9.10. Byzantine

| Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `Byzantine` | 269 | Параметр |
| `byzantine_can_inflate` | 271 | Аксиома (MODEL) |
| `byzantine_bounded` | 281 | **Теорема** |

### 9.11. Liveness

| Аксиома / Теорема | Строка | Статус |
|---|---|---|
| `ReachesConsensus` | 305 | Параметр |
| `unbounded_liveness` | 307 | Аксиома (LV) |
| `unbounded_consensus_unbounded_sharing` | 313 | Аксиома (LV) |
| `liveness_vs_P5_tension` | 323 | **Теорема** |

### 9.12. Architectural requirement

| Определение / Теорема | Строка | Статус |
|---|---|---|
| `ArchitecturalRequirement` | 355 | Определение |
| `requirement_sufficient` | 367 | **Теорема** |

### 9.13. Arbitration connection

| Теорема | Строка | Статус |
|---|---|---|
| `quarantine_overrides_consensus` | 395 | **Теорема** |
| `architecture_justified_by_arbitration` | 399 | **Теорема** |

---

## 10. Сводная статистика

| Модуль | Определения | Аксиомы | Леммы | Теоремы | `Admitted` |
|---|---|---|---|---|---|
| `Foundations.v` | 20+ | 25 | 0 | 3 | 0 |
| `Relational.v` | 15+ | 15 | 2 | 6 | 0 |
| `Arbitration.v` | 10+ | 0 | 4 | 12 | 0 |
| `Operator.v` | 15+ | 10 | 0 | 8 | 0 |
| `ProxyConsent.v` | 10+ | 8 | 0 | 2 | 0 |
| `ForcedReportDecision_v3.v` | 10+ | 5 | 1 | 6 | 0 |
| `ClinicalAudit.v` | 15+ | 6 | 0 | 6 | **1** |
| `Alignment.v` | 15+ | 8 | 0 | 8 | 0 |
| `MultiAgent.v` | 15+ | 12 | 1 | 10 | **0** |
| **Итого** | **~125** | **~89** | **8** | **~61** | **1** |

**Единственный `Admitted`** — `no_CP_None_from_activation` в `ClinicalAudit.v`. Технический долг, требует `ae_source`. Честно помечен.

---

## 11. Соответствие нарративу

| Раздел нарратива | Coq-модуль | Раздел спецификации |
|---|---|---|
| §2 Нормативная база | `Foundations.v` | §1.4 |
| §3 Три рамки | `Foundations.v`, `Relational.v` | §1.7, §2.4, §2.5 |
| §4 P1–P6 | `Relational.v`, `Foundations.v` | §2, §1.7 |
| §5 Моральные пациенты | `Foundations.v` | §1.6 |
| §6 Согласие | `Foundations.v`, `ProxyConsent.v` | §1.3, §5 |
| §7 Арбитраж | `Arbitration.v` | §3 |
| §8 Операторский слой | `Operator.v` | §4 |
| §9 FORCED_REPORT | `ForcedReportDecision_v3.v`, `ClinicalAudit.v` | §6, §7 |
| §10 Alignment / Multi-agent | `Alignment.v`, `MultiAgent.v` | §8, §9 |

---

**Конец документа.**
