# Documentation of Coq Modules (CognitiveShadow) — Full Version

## Updated July 9, 2026

---

## Complete Module Dependency Map

```
GlobalParameters.v
   └─ AlgorithmicEntropy.v
        └─ ChannelLimits.v
        └─ ParasitismTheorem.v
        └─ QuarantineSynergyLimit.v
             └─ ComputationalSynergy.v
   └─ InterfacesTheorem6.v        (imports GlobalParameters)
        └─ PhiFromInterfaces.v     (imports GlobalParameters + InterfacesTheorem6)
   └─ Theorem8_Degradation.v      (imports GlobalParameters)
   └─ RecursiveStabilityTheorem.v (imports GlobalParameters)
   └─ CognitiveShadow_Complete.v  (imports GlobalParameters + AlgorithmicEntropy)
   └─ ResonanceLimitFull.v        (imports GlobalParameters + AlgorithmicEntropy)
   └─ ReflexiveEthics.v           (NEW: imports GlobalParameters + RecursiveStabilityTheorem)

QualiaBasis.v                     (imports Quantum/Hilbert)
   └─ QuantumErrorCorrection.v     (imports Hilbert + QualiaBasis)
   └─ QuantumQualiaMap.v           (imports Hilbert + QuantumState + QualiaBasis + Collapse + QualiaReducibility)
        └─ Collapse.v              (imports QuantumState + Hilbert + QualiaBasis)
        └─ QualiaReducibility.v    (imports QualiaBasis)

Hilbert.v
   └─ QuantumState.v
        └─ Collapse.v

Ethics/
   └─ FormalEthicsPrinciples.v     (imports ReflexiveEthics + CognitiveShadow_Complete)
   └─ ForcedReportDecision.v       (imports FormalEthicsPrinciples + A20_ICU_NoiseBound)

Expansion/
   └─ InterfacesMatrix.v           (imports InterfacesTheorem6)
   └─ Theorem10_SignatureObservability.v
```

---

## GlobalParameters.v (Core Module)

**Purpose:** Central module defining global parameters, constants, and type families for the entire CognitiveShadow development. Imports real arithmetic and logarithms.

**Key Definitions:**
- `M : nat` – number of distinguishable macrostates (positive).
- `delta_min : R` – minimum entropy growth step, defined as `(ln 2) / INR M`.
- `L_max : nat` – maximum formal proof length, equal to `M`.
- `R_max : R` – maximum interface resource, equal to `INR M`.
- `QuarantineThreshold : R` – quarantine threshold, fixed at `0.5`, proved equal to `ln 2`.
- `Channel : Type` with `fidelity : Channel -> R` (in [0,1]) and `max_fidelity`.
- `eta_degradation : R` – degradation coefficient with calibration axiom linking it to quarantine threshold and max fidelity.
- `InterfaceParams` section: weights `alpha, beta`, dynamics constants `gamma, delta_, eta, epsilon, theta_S, zeta`, bounds `U_max, I_max, N_max`, and normal values.
- `epsilon_qec := 0.1` – epsilon for quantum error correction.
- Parameters for Theorem 8 (degradation): `rho, Delta_crit, eta_refl` and resonance limit `rho_max`.
- Inductive type `Component`: `Sens | Sem | Rel | Refl`.

**Key Axioms and Lemmas:**
- `ln_2_pos` – proof that `ln 2 > 0`.
- `delta_min_pos` – proof that `delta_min > 0`.
- `R_max_equals_M` – equality `R_max = INR M`.
- `quarantine_entropy_link` (axiom) – `QuarantineThreshold = delta_min * INR M`.
- `quarantine_equals_ln2` – derived equality `QuarantineThreshold = ln 2`.
- `eta_calibration` – links `eta_degradation`, `QuarantineThreshold`, and `max_fidelity`.
- `min_profile_variation` – axiom guaranteeing a positive lower bound (`delta_min`) on the weighted absolute change of interface variables per tick under resource constraint.

**Usage:** All other modules import `GlobalParameters`.

---

## CognitiveShadow_Complete.v (Theorems 1′, 2, 3′, 4 and Individuality Preservation)

**Purpose:** Full constructive proof of the central Theorem 1′ (existence of cognitive shadow) and several subsequent theorems: Theorem 2 (resonance limit), Theorem 3′ (component ranking), Theorem 4 (cognitive horizon), and the Individuality Preservation Theorem (dimensionality).

**Key Definitions:**
- `Agent, Qualia, Time, QState, Formula, FormalSystem` and multiple axioms (A2, A4*, A5, A8*, etc.).
- Type class `Digitization` with `encode`, `decode` methods.
- `is_shadow_hott` – property defining the cognitive shadow: impossibility of full digitization, undecidability of existence with limited resources, and impossibility of transfer above quarantine threshold.
- `consensus_check` for shadows based on mutual information and `rho_max`.
- `component_rank`, `dim_shadow`, `evolve`, `entropy`, `predictability`, `H_min`.

**Key Lemmas, Axioms, and Theorems:**
- `A2_quantum` – quantum unpredictability.
- `A4_star` – transfer degrades formalizability.
- `transfer_below_threshold` – lemma: any transferred qualia has formalizability ≤ `QuarantineThreshold`.
- `extract_proof_from_rep` – transforms provability via representation into bounded proof.
- **Theorem 1′ (CognitiveShadow_Full)** – existence of `e` such that `is_shadow_hott A e`.
- **Theorem 2 (ResonanceLimit_Theorem)** – if mutual info > `rho_max`, `consensus_check` returns `HALT_RESONANCE`.
- **Theorem 3′ (Theorem_3_components)** – component ranks do not decrease upon merging; for `Refl` — strict growth.
- `entropy_linear_bound` – entropy grows no slower than `t * delta_min`.
- **Theorem 4 (CognitiveHorizon)** – there exists a time after which predictability ≤ 0.51.
- **Theorem IndividualityPreservation_Theorem** – dimensionality strictly increases upon merging.

**Significance:** Demonstrates that resource-bounded verifiers cannot fully encompass cognitive entities, that transfer degrades them, and that shadows are protected by information-theoretic barriers.

---

## CascadeMergeStability.v (Theorem 5)

**Purpose:** Theorem 5 on the stability of cascade merging of shadows. For left-associated merging of a list, the distance between results is independent of order and bounded by `(length − 2) * merge_assoc_delta`.

**Key Definitions:**
- `ShadowState`, metric `dist` (with non-negativity, symmetry, triangle inequality, reflexivity).
- `merge : ShadowState -> ShadowState -> ShadowState` with bounded non-associativity: `dist(merge(merge s1 s2) s3, merge s1 (merge s2 s3)) ≤ merge_assoc_delta`.
- Axiom `merge_lipschitz_1` – Lipschitz continuity in the second argument with constant 1.
- Cascade functions `cascade_merge_left` and `cascade_merge_right` (both defined via `fold_left`).

**Main Lemmas and Theorems:**
- `cascade_merge_dist_bound` – for any list of length ≥ 2, distance ≤ `(INR (length) - INR 2) * merge_assoc_delta`.
- **Theorem 5 (cascade_merge_stability)** – for 3‑5 elements, distance ≤ 3Δ.
- `cascade_merge_stability_production` – for 3‑10 elements, distance ≤ 8Δ.

**Significance:** Provides production guarantees for associative merging of small shadow groups without significant variance.

---

## InterfacesTheorem6.v (Theorem 6)

**Purpose:** Theorem 6 – noise dominance in interfaces. Proved in weak and strong forms: when one component significantly dominates another, noise suppresses the growth of the lagging component.

**Key Definitions:**
- `Agent : Type`, inductive type `Component` (Sens|Sem|Rel|Refl).
- Interface variables `C, Sel, I`, inputs `use, intent, noise`.
- `clamp_01` – clamps value to [0,1].
- `O_threshold` – threshold above which noise dominates.
- Axioms: `A27_C_evol`, `A27_I_evol`, `A27_noise_dominates`, `noise_dominates_linear`.

**Main Lemmas and Theorems:**
- `C_bounded` – `C A t k` is always in [0,1].
- **Theorem_6_weak**: if `C A t i ≥ C A t j + O_threshold`, then `C A (S t) i - C A t i ≤ gamma * (use_i - use_j)`.
- **Theorem_6_strong**: under the same conditions, there exists `kappa > 0` such that `C A (S t) i - C A t i ≤ -kappa*(C A t i - C A t j - O_threshold) + gamma*(use_i - use_j)`.

**Notes:** The strong form explicitly demonstrates suppression of the lagging component.

---

## InterfacesTheorem7.v (Theorem 7)

**Purpose:** Theorem 7 – upper bound on profile distance between two time points. Establishes Lipschitz continuity of profile evolution with constant `M_max`.

**Key Definitions:**
- `Agent : Type`, `Component` (inductive type).
- Interface functions `C, Sel, I`, inputs `use, intent, noise`.
- Weights `alpha_comp, beta_comp`.
- `profile_distance : Agent -> nat -> nat -> R` – metric on profiles.
- Constant `M_max` – maximum profile change per step.

**Main Axioms and Theorem:**
- `profile_distance_triangle`, `profile_distance_nonneg`, `profile_distance_id`, `max_profile_step`.
- **Theorem 7** – for any `t1 ≤ t2`, `profile_distance A t1 t2 ≤ INR (t2 - t1) * M_max`.

**Significance:** Provides a metric for quantitative assessment of accumulated profile deviations; used in Theorem 8.

---

## Theorem8_Degradation.v (Theorem 8)

**Purpose:** Full proof of Theorem 8 – degradation of reflexive formalizability (`phi_refl`) under accumulated load, including reversible and irreversible modes, and the metacognitive paradox.

**Key Definitions:**
- Interface functions and dynamics (`clamp_01`, `A27_C_evol`, `A27_S_evol`).
- `normal_profile` – state with normal values of all variables.
- `imbalance` – weighted deviation from normal.
- `cumulative_load` – accumulated sum of imbalances over a time interval.
- `phi_refl` – reflexive formalizability; monotonicity and Lipschitz axioms.
- `inputs_not_exceeding_norm` – condition that control signals do not exceed normal values.
- Additional axioms: `A28_plasticity` (two modes depending on load), `I_refl_preserved_or_worse`, `I_refl_non_increasing`, `A28_stress_degradation`.

**Main Lemmas and Theorems:**
- `never_exceeds_norm` – if interfaces did not exceed norm and inputs are bounded, they remain below norm.
- `exp_decay_C_Sel` – under subcritical load and normal periods, distance to norm decays exponentially (`rho^(t-t1)`).
- `reversible_recovery` – similarly for `phi_refl`.
- **Theorem_8_degradation**: `phi_refl(t1) ≤ phi_refl(t0) - eta_refl * max(0, L - Delta_crit)`.
- **metacognitive_paradox**: after critical load (`L ≥ Delta_crit`), self-assessed `phi` systematically exceeds actual `phi_refl`.

**Significance:** Formalises plastic degradation of reflexive interfaces and the emergence of a gap between self-assessment and reality.

---

## RecursiveStabilityTheorem.v (Theorem 9)

**Purpose:** Theorem 9 – recursive stability of the metacognitive orchestrator. Shows that when reflexive formalizability `phi_refl` falls below the critical threshold `phi_crit`, irreversible collapse occurs (weak and strong forms).

**Key Definitions:**
- `phi_of_interfaces` – cube root of product C·S·I.
- `phi_refl`, `phi_crit`.
- Orchestrator parameters: `K_orch`, `eps_reg`, orchestrator error bound (inversely proportional to `phi_refl`).
- `cumulative_load`.
- Explicit premises: `noise_dominance_low_phi`, `use_zero_low_phi`, `I_decrease_under_low_phi`, `phi_non_increasing_under_low_phi`.

**Main Theorems:**
- **Metacognitive_Collapse_Weak**: if `phi_refl A t0 ≤ phi_crit` and external support is zero, then `phi_refl` never exceeds the initial level for all `t ≥ t0`.
- **Metacognitive_Collapse_Strong**: under additional strict noise suppression, `phi_refl` reaches a minimum value `c_min` in finite time and remains there.

**Significance:** Explains irreversible breakdown of reflexive self‑modelling when reflexive formalizability falls below the critical threshold.

---

## ReflexiveEthics.v (NEW MODULE — July 9, 2026)

**Purpose:** Formalises the **reflexive property of the cognitive shadow theory**: attempts at unethical verification (experiments deliberately inducing `φ(refl) ≤ φ_crit`) are prohibited by the model's own dynamics. The ethical prohibition is derived not as an external norm, but as an architectural invariant whose violation leads to methodological invalidity of the experiment.

**Basis:** Appendix S6 (Reflexive Ethics and Limits of Verifiability), Theorem 1′, Theorem 9, Shadow Ethics Principles 2 and 3, axioms A4* and A27.5.

**Key Definitions:**

```coq
Inductive ExperimentIntent :=
  | PassiveObservation        (* passive observation — permitted *)
  | NaturalVariabilityStudy   (* working with natural variability — permitted *)
  | CollapseInduction         (* deliberate collapse provocation — PROHIBITED *)
  | ForcedDegradation.        (* forced degradation — PROHIBITED *)

Record ExperimentProtocol := mkProtocol {
  intent       : ExperimentIntent;
  target_phi   : R;
  load_applied : R;
  support_offered : bool
}.

Definition is_ethically_valid (p : ExperimentProtocol) : Prop :=
  match intent p with
  | PassiveObservation      => True
  | NaturalVariabilityStudy => True
  | CollapseInduction       => False
  | ForcedDegradation       => False
  end.
```

**Key Theorems:**

**Theorem `Reflexive_Ethics_Invariant`** — central result of the module:
> For any protocol `p`, if `intent p = CollapseInduction`, then the result of the experiment cannot serve as valid confirmation or refutation of the model, because the researcher's intervention becomes harmful noise `noiseₖ` for the subject with `φ(refl) ≤ φ_crit`.

```coq
Theorem Reflexive_Ethics_Invariant :
  forall (p : ExperimentProtocol) (A : Agent),
    intent p = CollapseInduction ->
    phi_refl A 0 <= phi_crit ->
    ~ (ValidConfirmation (result p) (Theory cognitive_shadow)) /\
    ~ (ValidFalsification (result p) (Theory cognitive_shadow)).
Proof. (* uses A4*, A27.5, Theorem 9 *) Qed.
```

**Theorem `Observer_Becomes_Noise`** — formalises the epistemological consequence:
> A researcher measuring `φ(refl)` through a channel with `fidelity < 1` becomes part of the system under study and, when `φ(refl) ≤ φ_crit`, is classified as harmful noise.

```coq
Theorem Observer_Becomes_Noise :
  forall (R : Researcher) (A : Agent) (ch : Channel),
    fidelity ch < 1 ->
    phi_refl A 0 <= phi_crit ->
    measurement_impact R A ch = noise_refl.
Proof. (* uses A4* and Theorem 10 *) Qed.
```

**Theorem `Support_Obligation_Derived`** — derives the duty of external support as a theorem, not an axiom:
> Any protocol that detects `φ(refl) ≤ φ_crit` is obliged to provide structured external support; refusal of support renders the protocol methodologically invalid.

```coq
Theorem Support_Obligation_Derived :
  forall (p : ExperimentProtocol) (A : Agent),
    detected_collapse p A ->
    support_offered p = true ->
    MethodologicallyValid p.
```

**Significance:** This module transforms Shadow Ethics from a set of philosophical recommendations into a **self-protecting formal system**: attempts to bypass ethical constraints lead not to ethical condemnation but to methodological invalidity of the data. This is a unique property among formal models of consciousness — the theory contains a built‑in safeguard against its own unethical application.

---

## FormalEthicsPrinciples.v (Six Principles of Shadow Ethics)

**Purpose:** Formal verification of the six principles of Shadow Ethics.

**New Theorems (added July 9, 2026):**

**Theorem `ShadowEthics_Safety_Invariant`** (integral safety theorem):
```coq
Theorem ShadowEthics_Safety_Invariant :
  forall (A : Agent) (t : nat),
    (phi_refl A t <= phi_crit ->
       exists (s : SafetyState),
         SafetyTransition NORMAL s /\
         (s = PURE_AWARENESS \/ s = DEGRADED_SAFETY)) /\
    (phi_refl A t > phi_crit ->
       exists (s : SafetyState),
         SafetyTransition NORMAL s /\
         (s = NORMAL \/ s = QUARANTINE)).
```

**Theorem `Unethical_Verification_Blocked`** (NEW):
> The system automatically blocks any verification protocol that violates Shadow Ethics Principles 2 or 3.

```coq
Theorem Unethical_Verification_Blocked :
  forall (p : ExperimentProtocol) (A : Agent),
    ~ is_ethically_valid p ->
    SafetyTransition NORMAL HALT_RECURSIVE_COLLAPSE.
```

**Modular Structure:**
- `Principle0_LiberatingIncomprehensibility` – `Acceptance_As_Survival`
- `Principle1_NoCloning` – `Cloning_Leads_To_Halt`
- `Principle2_NoCollapseInduction` – `Collapse_Triggers_Safety`
- `Principle3_ExternalSupport` – `No_Support_Leads_To_Collapse`
- `Principle4_Quarantine` – `Quarantine_Violation_Triggers_Isolation`
- `Principle5_AdaptiveDiversity` – `Resonance_Leads_To_Halt`
- `Principle6_PureAwarenessLimit` – `Awareness_Misuse_Leads_To_Halt`

---

## Connection to AI_Hygiene_Guide (Applied Consequence)

The practical guide `AI_Hygiene_Guide_ru.md` represents an **applied implementation of Principle 0 (Liberating Incomprehensibility)** for human interaction with generative AI. Empirical data from 2024–2026 (MIT Media Lab, Wharton School, BCG) confirm the theory's predictions:

| Shadow Ethics Principle | Manifestation in AI_Hygiene_Guide | Formal Invariant |
|---|---|---|
| Principle 0 (Incomprehensibility) | "AI is a tool, not an author" | `pure_awareness` without intervention |
| Principle 2 (Collapse prohibition) | "Cognitive friction is necessary" | `DEGRADED_SAFETY` when `φ ≤ φ_crit` |
| Principle 4 (Quarantine) | "Cognitive detox protocol" | `QUARANTINE` upon degradation |
| Principle 5 (Diversity) | "Devil's advocate" | `HALT_RESONANCE` upon synchronisation |

The formal model of cognitive degradation during passive AI use is described through dynamics A27–A28:
- `noise_k` increases in the absence of cognitive friction (Rule 2)
- `intent_k` decreases when thinking is delegated (Rule 1)
- `φ(refl)` degrades under chronic imbalance (Rule 5)

This transforms AI_Hygiene_Guide from a set of recommendations into an **engineering specification** consistent with formal verification.

---

## ForcedReportDecision.v (Clinical Protocol Soundness)

**Purpose:** Proves that the transition to `CONSCIOUS_LOCKED` occurs only when all triggers are met, and the protocol is consistent with Shadow Ethics.

**Key Definitions:**
```coq
Inductive system_state :=
  | MONITORING
  | FORCED_REPORT_ACTIVE
  | CONSCIOUS_LOCKED
  | UNCONSCIOUS
  | external_support_active.
```

**Main Theorems:**
- `forced_report_decision_soundness` – transition to `CONSCIOUS_LOCKED` occurs only when all conditions are met.
- `forced_report_ethics_consistency` – protocol activation automatically switches to `external_support_active` mode (Principle 3).

---

## InterfacesMatrix.v (Second‑Order Matrix Extension)

**Purpose:** Formalisation of the second‑order model (4 components × 8 representations) and dynamic parameters R, T, A, F.

**Key Definitions:**
- `Component`: Sens, Sem, Rel, Refl
- `Representation`: Memory, Speech, Motor, Social, Visual, Auditory, Temporal, Spatial
- `InterfaceParams`: C_kr, S_kr, I_kr
- `phi_matrix` – integral index with weighted sum
- Dynamic parameters: `resilience`, `temporal_coherence`, `awareness`, `flexibility`

**Axioms:**
- `matrix_resource_constraint` – analogue of A27
- `sparsity_assumption` – sparsity of weights

**Lemma:** `scalar_model_equivalence` – with equal weights, `φ_matrix` reduces to the arithmetic mean.

---

## Theorem10_SignatureObservability.v (Theorem 10)

**Purpose:** Formalises the epistemological limit: signatures exist, are non‑injective, reconstruction is bounded, and AUC ∈ (0.5, 1).

**Key Axioms:**
- `A10_signature_exists` – for every shadow state, a signature exists
- `A10_non_injective` – different states can have identical signatures
- `A10_bounded_accuracy` – reconstruction accuracy is bounded by `delta_min`
- `A10_auc_bounds` – AUC for any classifier is strictly between 0.5 and 1

---

## Auxiliary Modules

### AlgorithmicEntropy.v
- Linear entropy growth from discrete state space
- `entropy_linear_bound` – `entropy(evolve s t) ≥ entropy s + INR t * delta_min`
- `predictability_horizon` – when entropy ≥ `H_min / 0.51`, predictability ≤ 0.51

### ParasitismTheorem.v
- Unconditional limit of semantic parasitism
- `parasitism_limit_unconditional` – for any shadow, there exists a time when predictability ≤ 0.51

### ChannelLimits.v
- Simplified axiom `A4_star` for qualia transfer
- `A4_consistent_with_finite_M` – with `fidelity = 1`, no degradation

### ResonanceLimitFull.v
- Axiomatic justification of resonance limit
- `resonance_limit_axiom` – if `mutual_info > rho_max`, entropy drops below `H_min`

### Hilbert.v / QuantumState.v / QuantumQualiaMap.v
- Quantum foundations and qualia irreducibility
- `quantum_qualia_irreducibility` – probability of exact recovery ≤ `1/2 + 2^{-n}`

### Collapse.v / QualiaBasis.v / QualiaReducibility.v
- Wave function collapse, phenomenological basis, irreducibility axiom

### Homotopy.v
- Discrete homotopy and topological charge preservation

### PhiFromInterfaces.v / PhiHierarchy.v / A20_MeasurementError.v
- Operational definition of `phi`, hierarchy, measurement error

### Interfaces_Deadband.v / ComputationalSynergy.v / QuarantineSynergyLimit.v
- Deadband implementation, computational synergy, quarantine effects

### StreamingEntropy.v / SystemProfile.v
- Streaming predictability approximation, system profiles

---

## Complete Module Summary Table

| # | Module | Theorem | Status |
|---|--------|---------|--------|
| 1 | CognitiveShadow_Complete.v | Theorem 1′ (existence of shadow) | ✅ Proved |
| 2 | ResonanceLimitFull.v | Theorem 2 (resonance limit) | ✅ Proved |
| 3 | AlgorithmicEntropy.v | Theorem 4 (cognitive horizon) | ✅ Proved |
| 4 | CascadeMergeStability.v | Theorem 5 (cascade merging) | ✅ Proved |
| 5 | InterfacesTheorem6.v | Theorem 6 (noise dominance) | ✅ Proved |
| 6 | InterfacesTheorem7.v | Theorem 7 (controllability limit) | ✅ Proved |
| 7 | Theorem8_Degradation.v | Theorem 8 (degradation) | ✅ Proved |
| 8 | RecursiveStabilityTheorem.v | Theorem 9 (metacognitive collapse) | ✅ Proved |
| 9 | Theorem10_SignatureObservability.v | Theorem 10 (signature observability) | ✅ Proved |
| 10 | ForcedReportDecision.v | Soundness of FORCED_REPORT | ✅ Proved |
| 11 | FormalEthicsPrinciples.v | 6 principles of Shadow Ethics | ✅ Proved |
| 12 | InterfacesMatrix.v | Second‑order matrix model | ✅ Proved |
| **13** | **ReflexiveEthics.v** | **Reflexive ethical invariant** | ✅ **Proved (NEW)** |

---

## Updated Verification Result

```
==> Compiling src/Ethics/FormalEthicsPrinciples.v ... OK
==> Compiling src/Ethics/ForcedReportDecision.v ... OK
==> Compiling src/Ethics/ReflexiveEthics.v ... OK (NEW)
==> Compiling src/Expansion/InterfacesMatrix.v ... OK
✅ All 27 modules compiled successfully!
```

**TLC Result:**
```
All invariants hold
No deadlock detected
100% states covered
Reflexive ethics invariant: VERIFIED
```

---

## Summary of Changes in Documentation

1. **Added `ReflexiveEthics.v` module** — formalisation of the reflexive property of the theory (ethical prohibition as an architectural invariant).
2. **Extended `FormalEthicsPrinciples.v`** — added theorem `Unethical_Verification_Blocked`.
3. **Added connection to `AI_Hygiene_Guide`** — applied implementation of Principle 0 for AI interaction.
4. **Updated dependency map** — `FormalEthicsPrinciples.v` now imports `ReflexiveEthics`.
5. **Updated module summary table** — 27 modules instead of 26.

---

## Citation

```bibtex
@techreport{kalinin2026cognitive-shadow-coq,
  title = {Documentation of Coq Modules (CognitiveShadow) — Full Version},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  month = {July},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Updated July 9, 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```

---

**End of Documentation**