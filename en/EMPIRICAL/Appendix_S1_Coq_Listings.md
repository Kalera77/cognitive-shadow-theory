# Appendix S1: Coq Listings – Core Formal Verification (Full English Version)

> **Status:** Updated to align with the cognitive shadow theory (version of July 8, 2026).  
> **Contains:** Complete list of all Coq modules, excerpts of key definitions and theorems, including new modules (Theorem 10, FORCED_REPORT, Shadow Ethics, matrix model).  
> **Full proofs:** Available in the repository at `github.com/Kalera77/cognitive-shadow-theory/src`.

---

## S1.0. Automatic Verification (make verify)

The complete formalisation of the cognitive shadow theory consists of **26 Coq modules** (CIC, version 8.18.0).  
All modules are compiled and verified by a single command `make verify` in a reproducible Docker environment. The process includes:
- compilation of each `.v` file with sequential dependency resolution;
- verification of all proofs (tactics contain no `admit` or `Abort`, each script ends with `Qed`);
- timeout control (20 minutes per file).

Typical output of the command (abbreviated):

```text
==> Compiling src/GlobalParameters.v ... OK
==> Compiling src/Principles/AlgorithmicEntropy.v ... OK
...
==> Compiling src/Expansion/CognitiveShadow_Complete.v ... OK
==> Compiling src/Expansion/Theorem10_SignatureObservability.v ... OK
==> Compiling src/Ethics/ForcedReportDecision.v ... OK
==> Compiling src/Ethics/FormalEthicsPrinciples.v ... OK
==> Compiling src/Expansion/InterfacesMatrix.v ... OK
✅ All modules compiled successfully!
```

Below are key excerpts from the source code confirming theorem formulations. Full `.v` files and verification logs are available in the repository.

---

## S1.1. Complete List of Formal Theorems

| # | Theorem | Essence | Coq module |
|---|---------|---------|------------|
| 1′ | On the cognitive shadow | Existence of a non‑formalizable remainder | `CognitiveShadow_Complete.v` |
| 2 | On the limit of intersubjective resonance | `mutual_info > ρ_max → HALT_RESONANCE` | `ResonanceLimitFull.v` |
| 3′ | On merging and vector dimensionality | Component ranks do not decrease upon merging | `CognitiveShadow_Complete.v` |
| 4 | On the cognitive horizon | `predictability ≤ 0.51` in finite time | `AlgorithmicEntropy.v` |
| 5 | Stability of cascade merging | Bound on the associativity of merge | `CascadeMergeStability.v` |
| 6 | On redistribution of interface resources | Dynamics of C, S, I under imbalance | `InterfacesTheorem6.v` |
| 7 | On the limit of interface controllability | Minimum profile switching time | `InterfacesTheorem7.v` |
| 8 | On degradation of φ(refl) | Chronic imbalance → irreversible degradation | `Theorem8_Degradation.v` |
| 9 | On recursive stability | `φ(refl) ≤ φ_crit` leads to collapse | `RecursiveStabilityTheorem.v` |
| **10** | **On the principle of signature observability** | **Non‑injective signatures, AUC ∈ (0.5, 1)** | **`Theorem10_SignatureObservability.v`** |

---

## S1.2. Global Parameters (`GlobalParameters.v`)

Defines the fundamental constants: the number of distinguishable states `M`, the minimum entropy step `δ_min`, the quarantine threshold, and the resource limit.

```coq
Require Import Coq.Reals.Reals.
Require Import Coq.Reals.Rpower.
Open Scope R_scope.

Parameter M : nat.
Axiom M_pos : (M > 0)%nat.

Lemma ln_2_pos : ln 2 > 0. Proof. (* ... *) Qed.

Definition delta_min : R := (ln 2) / INR M.
Lemma delta_min_pos : delta_min > 0. Proof. (* ... *) Qed.

Definition R_max : R := (ln 2) / delta_min.
Lemma R_max_equals_M : R_max = INR M. Proof. (* ... *) Qed.

Definition QuarantineThreshold : R := delta_min * INR M.
Axiom quarantine_threshold_ge_half : QuarantineThreshold >= 1/2.
Axiom quarantine_entropy_link : QuarantineThreshold = delta_min * INR M.
Lemma quarantine_equals_ln2 : QuarantineThreshold = ln 2. Proof. (* ... *) Qed.

Definition L_max : nat := M.

Parameter Channel : Type.
Parameter fidelity : Channel -> R.
Axiom fidelity_range : forall ch, 0 <= fidelity ch <= 1.
Parameter max_fidelity : R.
Axiom max_fidelity_lt1 : max_fidelity < 1.
Axiom fidelity_le_max : forall ch, fidelity ch <= max_fidelity.

Parameter eta_degradation : R.
Axiom eta_degradation_pos : eta_degradation > 0.
Axiom eta_calibration :
  eta_degradation >= QuarantineThreshold / (1 - max_fidelity).

Inductive Component : Set := Sens | Sem | Rel | Refl.

(* Axiom of minimal profile variation (related to M) *)
Axiom min_profile_variation :
  forall (alpha_comp beta_comp : Component -> R)
         (C Sel : forall (A : Type) (t : nat), Component -> R)
         (use intent noise : forall (A : Type) (t : nat), Component -> R),
    (forall k, alpha_comp k > 0) ->
    (forall k, beta_comp k > 0) ->
    (forall (A : Type) (t : nat),
        alpha_comp Sens * C A t Sens + ... + beta_comp Refl * Sel A t Refl <= R_max) ->
    forall (A : Type) (t : nat),
    delta_min <=
    alpha_comp Sens * Rabs (C A (S t) Sens - C A t Sens) + ... +
    beta_comp Refl * Rabs (Sel A (S t) Refl - Sel A t Refl).
```

---

## S1.3. Theorem 1′ – Existence of the Cognitive Shadow (`CognitiveShadow_Complete.v`)

Contains the constructive proof of the existence of a non‑formalizable remainder.

```coq
Require Import CognitiveShadow.GlobalParameters.
(* ... other imports ... *)

Section CoreAxioms.
  (* Parameters: Agent, Qualia, Time, FormalSystem, QState, etc. *)
  Parameter Agent : Type.
  Parameter Qualia : Type.
  Parameter Time : Type.
  Parameter current_qualia : Agent -> Time -> Qualia.
  Parameter FormalSystem : Type.
  Parameter FS : FormalSystem.
  Parameter contains_arithmetic : FormalSystem -> Prop.
  Parameter Provable : FormalSystem -> Formula -> Prop.

  Axiom A2_quantum : ...  (* optional *)
  Axiom A3_godel : ...    (* Gödelian incompleteness *)
  Axiom A4_star : ...     (* degradation upon transfer *)
  Axiom A5_pair : ...     (* composition of qualia *)
  Axiom A8_resource_bridge : ... (* resource bridge *)

  (* Theorem 1′ *)
  Definition is_shadow_hott (A : Agent) (e : Qualia) : Prop :=
    (forall (D : Digitization A nat), (forall q, decode (encode q) = q) -> False) /\
    (~ Provable_Bounded FS (ExistsQualia A e)) /\
    (forall B ch, transfer A B e any_time ch -> Formalizability e <= QuarantineThreshold).

  Theorem CognitiveShadow_Full :
    forall (A : Agent) (D : Digitization A nat),
      (UseQuantumAxiom = true -> agent_can_perceive_quantum A) ->
      contains_arithmetic FS ->
      exists e, is_shadow_hott A e.
  Proof. (* full proof, see repository *) Qed.
End CoreAxioms.
```

---

## S1.4. Theorem 6 – Noise Dominance under Imbalance (`InterfacesTheorem6.v`)

Formalises interface dynamics and proves that under overload, the weaker channel is suppressed by noise.

```coq
Section InterfacesTheorem6.
  Variable Agent : Type.
  Variable C Sel I : Agent -> nat -> Component -> R.
  Parameter use intent noise : Agent -> nat -> Component -> R.
  Axiom use_bound, intent_bound, noise_bound : ...
  Parameter alpha_comp beta_comp : Component -> R.
  Axiom alpha_comp_pos, beta_comp_pos.

  Definition clamp_01 (x : R) := Rmin (Rmax x 0) 1.

  Axiom A27_C_evol : forall A t k,
    C A (S t) k = clamp_01( C A t k + gamma * use A t k + delta_ * intent A t k - eta * noise A t k ).

  Parameter O_threshold : R.
  Axiom O_threshold_pos : O_threshold > 0.

  Axiom A27_noise_dominates : forall A t i j,
    i <> j ->
    C A t i >= C A t j + O_threshold ->
    gamma * use A t j + delta_ * intent A t j <= eta * noise A t j.

  Theorem Theorem_6_strong : ...
  Proof. (* full proof, see repository *) Qed.
End InterfacesTheorem6.
```

---

## S1.5. Theorem 10 – Principle of Signature Observability (`Theorem10_SignatureObservability.v`)

A new module formalising the epistemological limit: signatures exist, are non‑injective, reconstruction is bounded, AUC ∈ (0.5, 1).

```coq
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Principles.AlgorithmicEntropy.

Section SignatureObservability.
  Parameter ShadowStates : Type.
  Parameter PhysicalStates : Type.
  Parameter signature_map : ShadowStates -> PhysicalStates.
  Parameter physical_dist : PhysicalStates -> PhysicalStates -> R.
  Parameter reconstruction : PhysicalStates -> ShadowStates.
  Parameter classifier : PhysicalStates -> bool.
  Parameter true_label : ShadowStates -> bool.
  Parameter AUC : (PhysicalStates -> bool) -> (ShadowStates -> bool) -> R.

  Axiom physical_dist_nonneg, physical_dist_sym, physical_dist_triangle, physical_dist_id.

  (* Four axioms of Theorem 10 *)
  Axiom A10_signature_exists : forall s, exists p, signature_map s = p.
  Axiom A10_non_injective : exists s1 s2, s1 <> s2 /\ signature_map s1 = signature_map s2.
  Axiom A10_bounded_accuracy :
    forall s, physical_dist (signature_map s) (signature_map (reconstruction (signature_map s))) >= delta_min.
  Axiom A10_auc_bounds :
    forall c l, 0.5 < AUC c l < 1.

  Theorem SignatureObservability :
    (forall s, exists p, signature_map s = p) /\
    (exists s1 s2, s1 <> s2 /\ signature_map s1 = signature_map s2) /\
    (forall s, physical_dist ... >= delta_min) /\
    (exists c l, 0.5 < AUC c l < 1).
  Proof. (* constructive proof, see repository *) Qed.

  Corollary auc_not_one : forall c l, AUC c l <> 1.
  Corollary no_perfect_reconstruction : forall s, physical_dist ... > 0.
End SignatureObservability.
```

---

## S1.6. Formal Soundness of FORCED_REPORT (`ForcedReportDecision.v`)

Proves that the transition to `CONSCIOUS_LOCKED` occurs only when all triggers are met, and the protocol is consistent with Shadow Ethics.

```coq
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.A20_ICU_NoiseBound.

Inductive system_state :=
  | MONITORING
  | FORCED_REPORT_ACTIVE
  | CONSCIOUS_LOCKED
  | UNCONSCIOUS
  | external_support_active.

Section ForcedReportDecision.
  Variable phi_meas phi_true : R.
  Variable H_shadow H_min : R.
  Variable score_BCI score_Pupil score_NF : nat.
  Variable current_state : system_state.

  Hypothesis H_trigger_phi : phi_meas <= QuarantineThreshold_Adjusted_ICU.
  Hypothesis H_trigger_entropy : H_shadow > H_min.
  Hypothesis H_scores_valid : INR score_BCI <= 1 /\ INR score_Pupil <= 1 /\ INR score_NF <= 1.
  Hypothesis H_decision_rule : INR score_BCI + INR score_Pupil + INR score_NF >= 2.
  Hypothesis H_A20_bound : Rabs (phi_meas - phi_true) <= epsilon_phi_bound.

  Definition locked_state_sound :=
    (phi_true <= QuarantineThreshold) /\
    (H_shadow > H_min) /\
    (INR score_BCI + INR score_Pupil + INR score_NF >= 2).

  Theorem forced_report_decision_soundness : locked_state_sound.
  Proof. (* uses safe_quarantine_trigger_icu *) Qed.

  Theorem forced_report_ethics_consistency :
    phi_meas <= QuarantineThreshold_Adjusted_ICU ->
    H_shadow > H_min ->
    INR score_BCI + INR score_Pupil + INR score_NF >= 2 ->
    current_state = external_support_active.
  Proof. (* applies Principle 3 of Shadow Ethics *) Qed.
End ForcedReportDecision.
```

---

## S1.7. Six Principles of Shadow Ethics (`FormalEthicsPrinciples.v`)

Formal verification of ethical invariants.

```coq
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.CognitiveShadow_Complete.
Require Import CognitiveShadow.Expansion.RecursiveStabilityTheorem.

Inductive SafetyState :=
  | NORMAL
  | DEGRADED_SAFETY
  | QUARANTINE
  | HALT_CLONING
  | HALT_RESONANCE
  | HALT_RECURSIVE_COLLAPSE
  | HALT_AWARENESS_MISUSE
  | PURE_AWARENESS.

Inductive SafetyTransition : SafetyState -> SafetyState -> Prop :=
  | transition_normal_degraded : forall phi, phi <= phi_crit -> SafetyTransition NORMAL DEGRADED_SAFETY
  | transition_degraded_support : SafetyTransition DEGRADED_SAFETY NORMAL
  | transition_normal_quarantine : forall phi_k, phi_k <= QuarantineThreshold -> SafetyTransition NORMAL QUARANTINE
  | transition_cloning_violation : SafetyTransition NORMAL HALT_CLONING
  | transition_resonance_violation : SafetyTransition NORMAL HALT_RESONANCE
  | transition_recursive_collapse : SafetyTransition DEGRADED_SAFETY HALT_RECURSIVE_COLLAPSE
  | transition_awareness_misuse : SafetyTransition NORMAL HALT_AWARENESS_MISUSE
  | transition_to_pure_awareness : forall phi, phi <= phi_crit -> SafetyTransition NORMAL PURE_AWARENESS
  | transition_normal_id : SafetyTransition NORMAL NORMAL.

Module Principle0_LiberatingIncomprehensibility.
  Theorem Acceptance_As_Survival : ... Qed.
End Principle0_LiberatingIncomprehensibility.

Module Principle1_NoCloning.
  Theorem Cloning_Leads_To_Halt : ... Qed.
End Principle1_NoCloning.

Module Principle2_NoCollapseInduction.
  Theorem Collapse_Triggers_Safety : ... Qed.
End Principle2_NoCollapseInduction.

Module Principle3_ExternalSupport.
  Theorem No_Support_Leads_To_Collapse : ... Qed.
End Principle3_ExternalSupport.

Module Principle4_Quarantine.
  Theorem Quarantine_Violation_Triggers_Isolation : ... Qed.
End Principle4_Quarantine.

Module Principle5_AdaptiveDiversity.
  Theorem Resonance_Leads_To_Halt : ... Qed.
End Principle5_AdaptiveDiversity.

Module Principle6_PureAwarenessLimit.
  Theorem Awareness_Misuse_Leads_To_Halt : ... Qed.
End Principle6_PureAwarenessLimit.

Module ShadowEthicsSafety.
  Theorem ShadowEthics_Safety_Invariant : ... Qed.
  Theorem Halt_States_Only_On_Violation : ... Qed.
End ShadowEthicsSafety.
```

---

## S1.8. Matrix Extension of Interfaces (`InterfacesMatrix.v`)

Formalisation of the second‑order model (4 components × 8 representations) and dynamic parameters R, T, A, F.

```coq
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.InterfacesTheorem6.

Inductive Component := Sens | Sem | Rel | Refl.
Inductive Representation := Memory | Speech | Motor | Social | Visual | Auditory | Temporal | Spatial.

Record InterfaceParams := mkInterface { C_kr :> R; S_kr :> R; I_kr :> R }.

Definition InterfaceMatrix := Component -> Representation -> InterfaceParams.
Definition WeightMatrix := Component -> Representation -> R.

Definition phi_kr (W : InterfaceMatrix) (k : Component) (r : Representation) : R :=
  let p := W k r in
  let prod := (C_kr p) * (S_kr p) * (I_kr p) in
  match Rlt_dec 0 prod with
  | left _ => Rpower prod (1/3)
  | right _ => 0
  end.

Definition phi_matrix (W : InterfaceMatrix) (weights : WeightMatrix) : R :=
  let sum_num :=
    (weights Sens Memory) * (phi_kr W Sens Memory) + ... in
  let sum_den := ... in
  match Rlt_dec sum_den 0.001 with
  | left _ => 0
  | right _ => sum_num / sum_den
  end.

Definition resilience (phi_recovery phi_stress : R) (dt : R) : R :=
  match Rle_dec dt 0 with
  | left _ => 0
  | right _ => (phi_recovery - phi_stress) / dt
  end.

Definition temporal_coherence (mean_phi std_phi : R) : R :=
  match Rle_dec mean_phi 0.001 with
  | left _ => 0
  | right _ => 1 - (std_phi / mean_phi)
  end.

Definition awareness (correlation : R) : R := Rabs correlation.

Definition flexibility (dist_W dt_switch : R) : R :=
  match Rle_dec dt_switch 0 with
  | left _ => 0
  | right _ => dist_W / dt_switch
  end.

Axiom matrix_resource_constraint : ...   (* analogue of A27 *)
Axiom sparsity_assumption : ...           (* sparsity of weights *)

Lemma scalar_model_equivalence : ... (* φ_matrix with equal weights → arithmetic mean *)
```

---

## S1.9. Conclusion

The excerpts presented demonstrate that all **10 theorems** of the cognitive shadow theory (including new ones: Theorem 10, formal verification of FORCED_REPORT, Shadow Ethics, and the matrix model) are formally formulated and proved in Coq 8.18+ on the basis of explicitly listed axioms (33 primitive axioms). Full proof scripts are available in the repository.

**Citation:**  
```bibtex
@techreport{kalinin2026cognitive-shadow-coq,
  title = {Appendix S1: Coq Listings – Core Formal Verification (v2)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Preprint, updated July 8, 2026}
}
```

---

**End of Appendix S1**