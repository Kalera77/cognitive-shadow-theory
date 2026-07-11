(** * ComputationalSynergy.v – computational synergy when merging shadows (Axiom A13, Theorem 3.7) *)

(*
  This module defines the computational capacity CompCapacity of a state
  as entropy * (1 + topological charge).
  Axiom A13_computational_synergy postulates superadditive capacity growth
  when merging two shadows under suitable mutual information bounds
  and non‑quarantined semantic component.
  The corollary synergy_lower_bound relates merged capacity to the sum
  of capacities via the synergy coefficient sigma.
*)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lia.
Require Import Coq.micromega.Lra.
Open Scope R_scope.

Section ComputationalSynergy.
  Parameter ShadowState : Type.
  Parameter merge : ShadowState -> ShadowState -> ShadowState.
  Parameter dim_shadow : ShadowState -> nat.
  Parameter shadow_entropy : ShadowState -> R.
  Parameter topological_charge : ShadowState -> nat.
  Parameter mutual_info : ShadowState -> ShadowState -> R.

  (* Computational capacity of a state *)
  Definition CompCapacity (s : ShadowState) : R :=
    shadow_entropy s * (1 + INR (topological_charge s)).

  Axiom entropy_positive : forall s, shadow_entropy s > 0.

  Lemma comp_capacity_pos : forall s, CompCapacity s > 0.
  Proof.
    intros s. unfold CompCapacity.
    apply Rmult_lt_0_compat.
    - apply entropy_positive.
    - assert (0 <= INR (topological_charge s)) by apply pos_INR.
      lra.
  Qed.

  Parameter delta_min_rho : R.          (* minimal allowed mutual information *)
  Parameter rho_max_synergy : R.        (* maximal allowed mutual information *)
  Axiom delta_min_pos : delta_min_rho > 0.
  Axiom rho_range : delta_min_rho < rho_max_synergy < 1.
  Axiom merge_dim_growth : forall s1 s2,
    (INR (dim_shadow (merge s1 s2)) >= INR (dim_shadow s1) + INR (dim_shadow s2) + 1)%R.
  Parameter gamma_synergy : R.          (* synergy coefficient *)
  Axiom gamma_range : 0 < gamma_synergy <= 1.
  Parameter phi_sem_above_threshold : ShadowState -> ShadowState -> Prop.
  Axiom quarantine_condition : forall s1 s2, phi_sem_above_threshold s1 s2 -> True.

  (* Axiom A13: non‑linear computational synergy *)
  Axiom A13_computational_synergy : forall s1 s2,
    mutual_info s1 s2 >= delta_min_rho -> mutual_info s1 s2 <= rho_max_synergy ->
    phi_sem_above_threshold s1 s2 ->
    CompCapacity (merge s1 s2) >= CompCapacity s1 + CompCapacity s2 +
      gamma_synergy * mutual_info s1 s2 *
      (INR (dim_shadow (merge s1 s2)) - INR (dim_shadow s1) - INR (dim_shadow s2)).

  (* Synergy coefficient σ *)
  Definition synergy_sigma (s1 s2 : ShadowState) : R :=
    (gamma_synergy * mutual_info s1 s2 *
      (INR (dim_shadow (merge s1 s2)) - INR (dim_shadow s1) - INR (dim_shadow s2)))
    / (CompCapacity s1 + CompCapacity s2).

  (* Corollary: merged capacity ≥ (1+σ) times sum of capacities *)
  Corollary synergy_lower_bound : forall s1 s2,
    mutual_info s1 s2 >= delta_min_rho -> mutual_info s1 s2 <= rho_max_synergy ->
    phi_sem_above_threshold s1 s2 ->
    CompCapacity (merge s1 s2) >= (1 + synergy_sigma s1 s2) * (CompCapacity s1 + CompCapacity s2).
  Proof.
    intros s1 s2 H_low H_high H_phi.
    unfold synergy_sigma.
    assert (H_sum_pos : CompCapacity s1 + CompCapacity s2 > 0).
    { apply Rplus_lt_0_compat; apply comp_capacity_pos. }
    rewrite Rmult_plus_distr_r.
    rewrite Rmult_1_l.
    set (num := gamma_synergy * mutual_info s1 s2 *
               (INR (dim_shadow (merge s1 s2)) - INR (dim_shadow s1) - INR (dim_shadow s2))).
    set (den := CompCapacity s1 + CompCapacity s2).
    replace (num / den * den) with num.
    - apply A13_computational_synergy; assumption.
    - unfold Rdiv.
      field; apply Rgt_not_eq; exact H_sum_pos.
  Qed.
End ComputationalSynergy.