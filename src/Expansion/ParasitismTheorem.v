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

 (** Параметризованная версия: порог = 1/2 + ε *)
Lemma predictability_below_threshold_eps :
  forall (s : ShadowState) (H_t : R) (t : nat) (ε : R),
    0 < ε -> ε < 1/2 ->
    entropy (evolve s t) >= H_t ->
    H_t >= H_min / (1/2 + ε) ->
    predictability s t <= 1/2 + ε.
Proof.
  intros s H_t t ε ε_pos ε_lt_half H_ent H_bound.
  unfold predictability.
  set (θ := 1/2 + ε) in *.
  apply Rge_le in H_bound.                (* H_min / θ <= H_t *)
  apply Rge_le in H_ent.                  (* H_t <= entropy (evolve s t) *)
  assert (H_θ_pos : 0 < θ) by (unfold θ; lra).

  assert (H_min_div_pos : 0 < H_min / θ).
  { apply Rmult_lt_0_compat.
    - exact H_min_pos.
    - apply Rinv_0_lt_compat; exact H_θ_pos. }

  assert (H_t_pos : 0 < H_t).
  { apply Rlt_le_trans with (H_min / θ).
    - exact H_min_div_pos.
    - exact H_bound. }

  assert (H_ent_pos : 0 < entropy (evolve s t)).
  { apply Rlt_le_trans with H_t.
    - exact H_t_pos.
    - exact H_ent. }

  assert (H_mult : H_min <= H_t * θ).
  { rewrite Rmult_comm.
    replace H_min with (θ * (H_min / θ)) by (field; lra).
    apply Rmult_le_compat_l.
    - apply Rlt_le; exact H_θ_pos.
    - exact H_bound. }

  assert (H_mult2 : H_min <= entropy (evolve s t) * θ).
  { apply Rle_trans with (H_t * θ).
    - exact H_mult.
    - apply Rmult_le_compat_r.
      + apply Rlt_le; exact H_θ_pos.
      + exact H_ent. }

  apply Rmult_le_reg_r with (entropy (evolve s t)).
  - exact H_ent_pos.
  - replace ((H_min / entropy (evolve s t)) * entropy (evolve s t)) with H_min.
    2: { field; lra. }
    rewrite Rmult_comm.
    exact H_mult2.
Qed.

  (** Теорема 3.9 (параметризованная): существование времени T(ε) *)
Theorem parasitism_limit_param :
  forall (s : ShadowState) (H0 ε : R),
    0 < ε -> ε < 1/2 ->
    entropy s = H0 ->
    (forall t, entropy (evolve s t) >= H0 + INR t * delta_min) ->
    exists T : nat, predictability s T <= 1/2 + ε.
Proof.
  intros s H0 ε ε_pos ε_lt_half H_init H_growth.
  set (θ := 1/2 + ε).
  set (H_target := H_min / θ).
  assert (H_θ_pos : 0 < θ). { unfold θ; lra. }
  assert (H_target_pos : 0 < H_target).
  { unfold H_target.
    apply Rmult_lt_0_compat.
    - exact H_min_pos.
    - apply Rinv_0_lt_compat; exact H_θ_pos. }

  destruct (Rle_lt_dec H0 H_target) as [H_le | H_gt].
  - (* Случай 1: H0 <= H_target, нужно время для достижения порога *)
    set (T_raw := up ((H_target - H0) / delta_min)).
    assert (H_div_nonneg : 0 <= (H_target - H0) / delta_min).
    { unfold Rdiv; apply Rmult_le_pos.
      - apply (Rplus_le_reg_l H0). rewrite Rplus_0_r.
        replace (H0 + (H_target - H0)) with H_target by ring. exact H_le.
      - apply Rlt_le; apply Rinv_0_lt_compat; exact delta_min_pos. }
    assert (H_T_nonneg : (0 <= T_raw)%Z).
    { apply le_IZR.
      apply Rle_trans with ((H_target - H0) / delta_min).
      - exact H_div_nonneg.
      - destruct (archimed ((H_target - H0) / delta_min)) as [H_up_gt _].
        apply Rlt_le; exact H_up_gt. }
    set (T := Z.to_nat T_raw).
    exists T.
    apply predictability_below_threshold_eps with (H_t := H_target) (ε := ε).
    + exact ε_pos.
    + exact ε_lt_half.
    + (* entropy (evolve s T) >= H_target *)
      apply Rge_trans with (H0 + INR T * delta_min).
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
        replace (delta_min * ((H_target - H0) / delta_min))
          with (H_target - H0) in H_ineq_mul.
        2: { unfold Rdiv.
             replace (delta_min * ((H_target - H0) * / delta_min))
               with ((H_target - H0) * (delta_min * / delta_min)) by ring.
             rewrite Rinv_r. rewrite Rmult_1_r; reflexivity.
             apply Rgt_not_eq; exact delta_min_pos. }
        rewrite (Rmult_comm delta_min (IZR T_raw)) in H_ineq_mul.
        exact H_ineq_mul.
      + (* H_target >= H_min / (1/2 + ε) *)
      unfold H_target. apply Rle_refl.
  - (* Случай 2: H0 > H_target, порог уже достигнут *)
    exists 0%nat.
    apply predictability_below_threshold_eps with (H_t := H0) (ε := ε).
    + exact ε_pos.
    + exact ε_lt_half.
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

  (* ============================================================ *)
  (* НОВОЕ: Параметризованная функция вычисления времени          *)
  (* ============================================================ *)

  (** Параметризованная версия: порог = 1/2 + ε *)
  Definition compute_k_parasite_ci_eps (h0 h_min ε deff : R) : nat :=
    let θ := 1/2 + ε in
    let H_target := h_min / θ in
    if Rlt_dec H_target h0 then 0
    else Z.to_nat (up ((H_target - h0) / deff)).

  (** Совместимость: старая функция = новая при ε = 0.01 *)
  Lemma compute_k_ci_eps_agrees :
    forall h0 h_min deff,
      compute_k_parasite_ci h0 h_min deff =
      compute_k_parasite_ci_eps h0 h_min (1/100) deff.
  Proof.
    intros h0 h_min deff.
    unfold compute_k_parasite_ci, compute_k_parasite_ci_eps.
    assert (H_eq : h_min / 0.51 = h_min / (1/2 + 1/100)).
    { f_equal. lra. }
    rewrite H_eq; reflexivity.
  Qed.

  (* ============================================================ *)
  (* НОВОЕ: Операционный королларий через epsilon из              *)
  (*          GlobalParameters (если добавлен)                    *)
  (* ============================================================ *)

  (** Теорема 3.9 с операционным порогом (ε = 0.01 → порог 0.51) *)
  Corollary parasitism_limit_051 :
    forall (s : ShadowState) (H0 : R),
      entropy s = H0 ->
      (forall t, entropy (evolve s t) >= H0 + INR t * delta_min) ->
      exists T : nat, predictability s T <= 51/100.
  Proof.
    intros s H0 H_init H_growth.
    assert (H_eps_pos : 0 < 1/100) by lra.
    assert (H_eps_lt : 1/100 < 1/2) by lra.
    destruct (parasitism_limit_param s H0 (1/100)
              H_eps_pos H_eps_lt H_init H_growth)
      as [T H_T].
    exists T.
    replace (1/2 + 1/100) with (51/100) in H_T by lra.
    exact H_T.
  Qed.

End ParasitismTheorem.