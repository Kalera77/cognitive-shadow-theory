(** * AlgorithmicEntropy.v — Linear entropy growth from state discretization *)

(*
   This module proves that the entropy of any shadow grows at least as
   t * δ_min(M), where M is the number of distinguishable macrostates.
   The irreversible step axiom connects the discreteness of the state space
   with the minimal entropy increment per time tick.
*)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Arith.Arith.
Require Import Coq.micromega.Lra.

(* Import global parameters: M, delta_min, and related lemmas *)
Require Import CognitiveShadow.GlobalParameters.

Open Scope R_scope.

Section AlgorithmicEntropy.
  (* Shadow state type *)
  Variable ShadowState : Type.
  (* State evolution over t steps *)
  Variable evolve    : ShadowState -> nat -> ShadowState.
  (* Entropy of a state *)
  Variable entropy   : ShadowState -> R.

  (* Entropy is non‑negative *)
  Axiom entropy_nonneg : forall s, entropy s >= 0.
  (* Base case of evolution *)
  Axiom evolve_base  : forall s, evolve s 0 = s.

  (*
     Irreversible step axiom: entropy increases by at least δ_min(M)
     per tick. This follows from finite state resolution (M) and the
     second law of thermodynamics.
  *)
  Axiom irreversible_step :
    forall (s : ShadowState) (t : nat), (t > 0)%nat ->
      entropy (evolve s t) - entropy (evolve s (t-1)) >= delta_min.

  (* Helper lemma: S n - 1 = n *)
  Lemma sub1_S : forall n, (S n - 1)%nat = n.
  Proof.
    intros n.
    rewrite Nat.sub_1_r.
    apply Nat.pred_succ.
  Qed.

  (*
     Theorem: linear lower bound for entropy:
     H(evolve s t) ≥ H(s) + t·δ_min(M).
  *)
  Theorem entropy_linear_bound :
    forall (s : ShadowState) (t : nat),
      entropy (evolve s t) >= entropy s + INR t * delta_min.
  Proof.
    intros s t. generalize dependent s.
    induction t as [| t' IH]; intros s.
    - (* t = 0 *)
      rewrite evolve_base, INR_0. ring_simplify. apply Rle_refl.
    - (* t = S t' *)
      rewrite S_INR. ring_simplify.
      assert (H_pos : (S t' > 0)%nat) by apply Nat.lt_0_succ.
      assert (H_step : entropy (evolve s (S t')) - entropy (evolve s (S t' - 1)) >= delta_min).
      { apply (irreversible_step s (S t') H_pos). }
      rewrite sub1_S in H_step.
      apply Rge_le in H_step.
      assert (H_sum : entropy (evolve s t') + delta_min <= entropy (evolve s (S t'))).
      {
        replace (entropy (evolve s (S t')) - entropy (evolve s t'))
          with (entropy (evolve s (S t')) + - entropy (evolve s t')) in H_step by ring.
        apply (Rplus_le_compat_r (entropy (evolve s t'))
                                 delta_min
                                 (entropy (evolve s (S t')) + - entropy (evolve s t')))
          in H_step.
        ring_simplify in H_step.
        rewrite Rplus_comm in H_step.
        exact H_step.
      }
      apply Rle_ge.
      apply Rle_trans with (r2 := entropy (evolve s t') + delta_min).
      + apply Rplus_le_compat_r.
        specialize (IH s).
        apply Rge_le in IH. exact IH.
      + exact H_sum.
  Qed.

  (*
     Predictability horizon: once entropy reaches H_min / 0.51,
     predictability is bounded by 0.51.
  *)
  (* ============================================================ *)
  (* Параметризованная версия: порог = 1/2 + ε                   *)
  (* ============================================================ *)
     Theorem predictability_horizon_param :
      forall (s : ShadowState) (H_min ε : R) (t : nat),
        H_min > 0 ->
        0 < ε -> ε < 1/2 ->
        entropy (evolve s t) >= H_min / (1/2 + ε) ->
        H_min / entropy (evolve s t) <= 1/2 + ε.
    Proof.
      intros s H_min ε t Hmin_pos ε_pos ε_lt_half H_bound.
      set (θ := 1/2 + ε).
      set (H_t := entropy (evolve s t)).
      assert (H_θ_pos : 0 < θ). { unfold θ; lra. }
      apply Rge_le in H_bound.                (* H_min / θ <= H_t *)
      assert (H_t_pos : 0 < H_t).
      { apply Rlt_le_trans with (r2 := H_min / θ).
        - apply Rmult_lt_0_compat.
          + exact Hmin_pos.
          + apply Rinv_0_lt_compat. exact H_θ_pos.
        - exact H_bound. }
      (* Шаг 1: H_min <= H_t * θ *)
      assert (H_θ_nonneg : 0 <= θ) by lra.
      assert (H_temp : (H_min / θ) * θ <= H_t * θ).
      { apply Rmult_le_compat_r; [exact H_θ_nonneg | exact H_bound]. }
      assert (H_eq : (H_min / θ) * θ = H_min).
      { field; lra. }
      rewrite H_eq in H_temp.
      (* Теперь H_temp : H_min <= H_t * θ *)
      (* Шаг 2: H_min / H_t <= θ *)
      apply Rmult_le_reg_l with (r := H_t).
      - exact H_t_pos.
      - assert (H_eq2 : H_t * (H_min / H_t) = H_min).
        { field; lra. }
        rewrite H_eq2.
        exact H_temp.
    Qed.
  (* ============================================================ *)
  (* Совместимость: старая версия с порогом 0.51 как королларий *)
  (* ============================================================ *)
  Theorem predictability_horizon :
      forall (s : ShadowState) (H_min : R) (t : nat),
        H_min > 0 ->
        entropy (evolve s t) >= H_min / 0.51 ->
        H_min / entropy (evolve s t) <= 0.51.
    Proof.
      intros s H_min t Hmin_pos H_bound.
      assert (H_eq : (0.51 : R) = 1/2 + 1/100) by lra.
      rewrite H_eq in H_bound.
      rewrite H_eq.
      apply predictability_horizon_param with (ε := 1/100).
      - exact Hmin_pos.
      - lra.
      - lra.
      - exact H_bound.
    Qed.

End AlgorithmicEntropy.