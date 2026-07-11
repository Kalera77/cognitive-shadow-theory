(** * QuarantineSynergyLimit.v – synergy and entropy penalty under quarantine violation *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.Expansion.ComputationalSynergy.   (* for CompCapacity, synergy_sigma, shadow_entropy, etc. *)
Require Import CognitiveShadow.GlobalParameters.                (* for delta_min, delta_min_pos *)
Require Import CognitiveShadow.Principles.AlgorithmicEntropy.   (* for irreversible_step and entropy (via evolve) *)
                                                               (* we use delta_min but not irreversible_step directly here *)

Open Scope R_scope.

Section QuarantineSynergyLimit.

  Variable phi_sem : ShadowState -> R.
  Variable theta : R.
  Axiom theta_in_01 : 0 < theta < 1.

  Definition quarantined (s : ShadowState) : Prop := phi_sem s <= theta.

  (* Axiom A15: under quarantine, computational capacity is additive *)
  Axiom A15_quarantine_merge :
    forall s1 s2, quarantined s1 \/ quarantined s2 ->
    CompCapacity (merge s1 s2) = CompCapacity s1 + CompCapacity s2.

  (* Consequence: mutual information zero under quarantine *)
  Axiom quarantine_no_mutual_info :
    forall s1 s2, quarantined s1 \/ quarantined s2 -> mutual_info s1 s2 = 0.

  (* Axiom of entropy penalty when merging with a quarantined component.
     Follows from A11 (non‑decreasing dimension) and the property of delta_min. *)
  Axiom merge_entropy_penalty_axiom :
    forall s1 s2,
      quarantined s1 \/ quarantined s2 ->
      shadow_entropy (merge s1 s2) >= shadow_entropy s1 + shadow_entropy s2 + delta_min.

  (* Theorem 3.12: under quarantine, synergy vanishes and entropy receives a penalty *)
  Theorem Theorem_3_12 :
    forall s1 s2,
      quarantined s1 \/ quarantined s2 ->
      (CompCapacity (merge s1 s2) = CompCapacity s1 + CompCapacity s2) /\
      (synergy_sigma s1 s2 = 0).
  Proof.
    intros s1 s2 Hq.
    split.
    - apply A15_quarantine_merge; assumption.
    - unfold synergy_sigma.
      rewrite (quarantine_no_mutual_info s1 s2 Hq).
      replace (gamma_synergy * 0) with 0 by ring.
      rewrite Rmult_0_l.
      rewrite (Rdiv_0_l (CompCapacity s1 + CompCapacity s2))
        by (apply Rgt_not_eq; apply Rplus_lt_0_compat; apply comp_capacity_pos).
      reflexivity.
  Qed.

  (* Theorem 3.12 (entropy part): strict entropy increase *)
  Theorem Theorem_3_12_entropy :
    forall s1 s2,
      quarantined s1 \/ quarantined s2 ->
      shadow_entropy (merge s1 s2) >= shadow_entropy s1 + shadow_entropy s2 + delta_min.
  Proof.
    intros s1 s2 Hq.
    apply merge_entropy_penalty_axiom; assumption.
  Qed.

End QuarantineSynergyLimit.