(** * ParasitismTheorem.v – unconditional limit of semantic parasitism (Theorem 3.9) *)
Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lia.
Require Import Coq.micromega.Lra.
Require Import Coq.Reals.R_sqrt.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.ZArith.ZArith.
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Principles.AlgorithmicEntropy.

Open Scope R_scope.

Section ParasitismTheorem.
  Variable ShadowState : Type.
  Variable evolve : ShadowState -> nat -> ShadowState.
  Variable entropy : ShadowState -> R.

  Axiom entropy_nonneg : forall s, entropy s >= 0.
  Axiom evolve_base : forall s, evolve s 0 = s.

  Definition predictability (s : ShadowState) (t : nat) : R :=
    H_min / entropy (evolve s t).

  Lemma predictability_below_threshold :
    forall (s : ShadowState) (H_t : R) (t : nat),
      entropy (evolve s t) >= H_t ->
      H_t >= H_min / 0.51 ->
      predictability s t <= 0.51.
  Proof.
    intros s H_t t H_ent H_bound.
    unfold predictability.
    assert (H_c_pos : 0 < 0.51) by lra.
    assert (H_min_div_pos : 0 < H_min / 0.51).
    { apply Rmult_lt_0_compat; [exact H_min_pos | apply Rinv_0_lt_compat; exact H_c_pos]. }
    assert (H_pos : 0 < entropy (evolve s t)).
    { apply Rlt_le_trans with H_t.
      - apply Rlt_le_trans with (H_min / 0.51); [exact H_min_div_pos | apply Rge_le; exact H_bound].
      - apply Rge_le; exact H_ent. }
    apply Rmult_le_reg_l with (r := entropy (evolve s t)).
    - exact H_pos.
    - rewrite Rmult_comm.
      apply Rle_trans with (0.51 * H_t).
      {
        assert (H_cancel : entropy (evolve s t) * (H_min / entropy (evolve s t)) = H_min).
        { unfold Rdiv. rewrite <- Rmult_assoc. rewrite (Rmult_comm (entropy (evolve s t)) H_min).
          rewrite Rmult_assoc. rewrite Rinv_r. rewrite Rmult_1_r; reflexivity.
          apply Rgt_not_eq; exact H_pos. }
        replace (entropy (evolve s t) * (H_min / entropy (evolve s t))) with H_min by (exact H_cancel).
        assert (H_fact : H_min = 0.51 * (H_min / 0.51)).
        { replace (H_min / 0.51) with (H_min * / 0.51) by reflexivity.
          rewrite <- Rmult_assoc. rewrite (Rmult_comm 0.51 H_min). rewrite Rmult_assoc.
          rewrite Rinv_r. rewrite Rmult_1_r; reflexivity.
          apply Rgt_not_eq; exact H_c_pos. }
        rewrite H_fact.
        replace (0.51 * (H_min / 0.51) / entropy (evolve s t) * entropy (evolve s t))
          with (0.51 * (H_min / 0.51)).
        { apply Rmult_le_compat_l. apply Rlt_le; exact H_c_pos. apply Rge_le; exact H_bound. }
        { replace (0.51 * (H_min / 0.51) / entropy (evolve s t) * entropy (evolve s t))
            with (0.51 * (H_min / 0.51) * (/ entropy (evolve s t) * entropy (evolve s t))).
          - rewrite (Rinv_l (entropy (evolve s t))) by (apply Rgt_not_eq; exact H_pos).
            rewrite Rmult_1_r; reflexivity.
          - unfold Rdiv; ring. }
      }
      replace (entropy (evolve s t) * 0.51) with (0.51 * entropy (evolve s t)) by ring.
      apply Rmult_le_compat_l. apply Rlt_le; exact H_c_pos. apply Rge_le; exact H_ent.
  Qed.

  (* Theorem 3.9: existence of a time T after which predictability ≤ 0.51 *)
  Theorem parasitism_limit_unconditional :
    forall (s : ShadowState) (H0 : R),
      entropy s = H0 ->
      (forall t, entropy (evolve s t) >= H0 + INR t * delta_min) ->
      exists T : nat, predictability s T <= 0.51.
  Proof.
    intros s H0 H_init H_growth.
    set (H_target := H_min / 0.51).

    destruct (Rle_lt_dec H0 H_target) as [H_le | H_gt].
    - set (T_raw := up ((H_target - H0) / delta_min)).
      assert (H_div_nonneg : 0 <= (H_target - H0) / delta_min).
      { unfold Rdiv; apply Rmult_le_pos.
        - apply (Rplus_le_reg_l H0). rewrite Rplus_0_r.
          replace (H0 + (H_target - H0)) with H_target by ring. exact H_le.
        - apply Rlt_le; apply Rinv_0_lt_compat; exact delta_min_pos. }
      assert (H_T_nonneg : (0 <= T_raw)%Z).
      { apply le_IZR. apply Rle_trans with ((H_target - H0) / delta_min).
        - exact H_div_nonneg.
        - destruct (archimed ((H_target - H0) / delta_min)) as [H_up_gt _].
          apply Rlt_le; exact H_up_gt. }
      set (T := Z.to_nat T_raw).
      exists T.
      apply predictability_below_threshold with (H_t := H_target).
      + apply Rge_trans with (H0 + INR T * delta_min).
        * apply H_growth.
        * rewrite Rmult_comm.
          assert (H_T_eq : INR T = IZR T_raw).
          { unfold T; rewrite INR_IZR_INZ; apply f_equal. apply Z2Nat.id; exact H_T_nonneg. }
          rewrite H_T_eq; rewrite Rmult_comm.
          replace H_target with (H0 + (H_target - H0)) by ring.
          apply Rplus_ge_compat_l with (r := H0).
          replace (H0 + (H_target - H0) - H0) with (H_target - H0) by ring.
          apply Rle_ge.
          assert (H_ineq : (H_target - H0) / delta_min <= IZR T_raw).
          { destruct (archimed ((H_target - H0) / delta_min)) as [H_up_gt _].
            apply Rlt_le; exact H_up_gt. }
          assert (H_ineq_mul : delta_min * ((H_target - H0) / delta_min) <= delta_min * IZR T_raw).
          { apply Rmult_le_compat_l. apply Rlt_le; exact delta_min_pos. exact H_ineq. }
          replace (delta_min * ((H_target - H0) / delta_min)) with (H_target - H0) in H_ineq_mul.
          2: { unfold Rdiv. replace (delta_min * ((H_target - H0) * / delta_min))
                 with ((H_target - H0) * (delta_min * / delta_min)) by ring.
               rewrite Rinv_r. rewrite Rmult_1_r; reflexivity.
               apply Rgt_not_eq; exact delta_min_pos. }
          rewrite (Rmult_comm delta_min (IZR T_raw)) in H_ineq_mul.
          exact H_ineq_mul.
      + apply Rle_refl.
    - exists 0%nat.
      apply predictability_below_threshold with (H_t := H0).
      + specialize (H_growth 0%nat). rewrite Rmult_0_l in H_growth.
        replace (H0 + 0) with H0 in H_growth by ring.
        replace (entropy s) with H0 in H_growth by (rewrite H_init; reflexivity).
        exact H_growth.
      + apply Rle_ge. apply Rlt_le. exact H_gt.
  Qed.

  (* Helper function for computing the threshold time *)
  Definition compute_k_parasite_ci (h0 h_min deff : R) : nat :=
    let H_target := h_min / 0.51 in
    if Rlt_dec H_target h0 then 0
    else Z.to_nat (up ((H_target - h0) / deff)).

End ParasitismTheorem.