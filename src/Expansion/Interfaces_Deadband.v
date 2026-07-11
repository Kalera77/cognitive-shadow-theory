(** * Interfaces_Deadband.v – deadband to prevent chattering in interface regime switching *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.Arith.Arith.
Open Scope R_scope.

Section Interfaces_Deadband.
  Parameter tau_min : nat.
  Parameter Delta_hi Delta_lo : R.
  Axiom deadband_gap : Delta_lo < Delta_hi /\ Delta_lo > 0.
  Let Delta_gap := Delta_hi - Delta_lo.

  Lemma Delta_gap_pos : Delta_gap > 0.
  Proof.
    destruct deadband_gap as [H_lt _].
    unfold Delta_gap.
    apply Rgt_minus; assumption.
  Qed.

  Axiom tau_min_ge_1 : (tau_min >= 1)%nat.

  Parameter C : nat -> nat -> R.
  Parameter gamma delta eta : R.
  Axiom params_pos : gamma > 0 /\ delta > 0 /\ eta > 0.

  (* Step bound ensures no instantaneous jump across the deadband gap *)
  Axiom step_bound : forall k t, Rabs (C k (t+1) - C k t) < Delta_gap / 2.

  (* Definition: regime active (NOISE_DOMINANT) for at least tau_min steps *)
  Definition regime_active (i j t : nat) : Prop :=
    (t >= tau_min)%nat /\
    (forall s, (s < tau_min)%nat -> C i (t - s) >= C j (t - s) + Delta_hi).

  (* Definition: regime deactive (INTENT_DRIVEN) at a single moment *)
  Definition regime_deactive (i j t : nat) : Prop :=
    C i t <= C j t + Delta_lo.

  (* Lemma: active and deactive cannot hold simultaneously *)
  Lemma active_excludes_deactive :
    forall i j t, regime_active i j t -> ~ regime_deactive i j t.
  Proof.
    intros i j t [Ht Hcond] Hdeact.
    assert (H0 : (0 < tau_min)%nat).
    { apply Nat.lt_le_trans with 1%nat; [ apply Nat.lt_0_succ | exact tau_min_ge_1 ]. }
    specialize (Hcond 0%nat H0).
    rewrite Nat.sub_0_r in Hcond.
    destruct deadband_gap as [H_lt _].
    apply Rle_not_lt in Hdeact.
    apply Hdeact.
    apply Rlt_le_trans with (C j t + Delta_hi).
    { apply Rplus_lt_compat_l. exact H_lt. }
    { apply Rge_le. exact Hcond. }
  Qed.

  Inductive InterfaceRegime : Type := NOISE_DOMINANT | INTENT_DRIVEN.

  (* Current regime based on comparison with thresholds *)
  Definition current_regime (i j t : nat) : InterfaceRegime :=
    match Rle_lt_dec (C i t) (C j t + Delta_lo) with
    | left _ => INTENT_DRIVEN
    | right _ =>
        match Rle_lt_dec (C j t + Delta_hi) (C i t) with
        | left _ => NOISE_DOMINANT
        | right _ => NOISE_DOMINANT
        end
    end.

  (* Theorem: no chattering – impossible to switch from active to deactive in one step *)
  Lemma no_chattering_deadband :
    forall i j t,
      regime_active i j t ->
      current_regime i j t = NOISE_DOMINANT ->
      current_regime i j (t + 1) = INTENT_DRIVEN ->
      False.
  Proof.
    intros i j t Hactive _ Hflip.
    unfold current_regime in Hflip.
    destruct (Rle_lt_dec (C i (t + 1)) (C j (t + 1) + Delta_lo)) as [Hle_flip | Hgt_flip].
    { destruct Hactive as [Ht Hcond].
      assert (H0 : (0 < tau_min)%nat).
      { apply Nat.lt_le_trans with 1%nat; [ apply Nat.lt_0_succ | exact tau_min_ge_1 ]. }
      specialize (Hcond 0%nat H0).
      rewrite Nat.sub_0_r in Hcond.
      set (D_t := C i t - C j t).
      set (D_tp1 := C i (t+1) - C j (t+1)).
      assert (H_D_tp1_le : D_tp1 <= Delta_lo).
      { unfold D_tp1. apply (Rplus_le_reg_l (C j (t+1))). ring_simplify. exact Hle_flip. }
      assert (H_D_t_ge : D_t >= Delta_hi).
      { unfold D_t.
        apply Rge_le in Hcond.
        replace (C i t) with (C j t + (C i t - C j t)) in Hcond by ring.
        apply (Rplus_le_reg_l (C j t)) in Hcond.
        apply Rle_ge. exact Hcond. }
      pose proof (step_bound i t) as Hbd_i.
      pose proof (step_bound j t) as Hbd_j.
      apply Rabs_def2 in Hbd_i.
      apply Rabs_def2 in Hbd_j.
      destruct Hbd_i as [Hbd_i_l Hbd_i_u].
      destruct Hbd_j as [Hbd_j_l Hbd_j_u].
      assert (H_diff : D_tp1 - D_t = (C i (t+1) - C i t) - (C j (t+1) - C j t)).
      { unfold D_tp1, D_t. ring. }
      assert (H_lower : D_tp1 - D_t > - Delta_gap).
      { rewrite H_diff.
        assert (H1 : C i (t+1) - C i t > - (Delta_gap/2)).
        { apply Rlt_gt. exact Hbd_i_u. }
        assert (H2 : - (C j (t+1) - C j t) > - (Delta_gap/2)).
        { apply Ropp_lt_contravar in Hbd_j_l.
          unfold Rgt. exact Hbd_j_l. }
        pose proof (Rplus_lt_compat _ _ _ _ H1 H2) as H_sum.
        replace (- (Delta_gap/2) + - (Delta_gap/2)) with (- Delta_gap) in H_sum by field.
        replace ((C i (t+1) - C i t) + - (C j (t+1) - C j t))
          with ((C i (t+1) - C i t) - (C j (t+1) - C j t)) in H_sum by ring.
        exact H_sum. }
      assert (H_upper : D_tp1 - D_t <= - Delta_gap).
      { apply Rle_trans with (Delta_lo - D_t).
        { apply (Rplus_le_compat_r (- D_t)) in H_D_tp1_le.
          replace (D_tp1 + (- D_t)) with (D_tp1 - D_t) in H_D_tp1_le by ring.
          replace (Delta_lo + (- D_t)) with (Delta_lo - D_t) in H_D_tp1_le by ring.
          exact H_D_tp1_le. }
        { assert (H_neg : - D_t <= - Delta_hi).
          { apply Ropp_le_contravar. apply Rge_le. exact H_D_t_ge. }
          apply (Rplus_le_compat_l Delta_lo) in H_neg.
          replace (Delta_lo + (- D_t)) with (Delta_lo - D_t) in H_neg by ring.
          replace (Delta_lo + (- Delta_hi)) with (Delta_lo - Delta_hi) in H_neg by ring.
          replace (- Delta_gap) with (Delta_lo - Delta_hi) by (unfold Delta_gap; ring).
          exact H_neg. } }
      apply (Rlt_irrefl (- Delta_gap)).
      apply Rlt_le_trans with (D_tp1 - D_t).
      { exact H_lower. }
      { exact H_upper. } }
    { destruct (Rle_lt_dec (C j (t + 1) + Delta_hi) (C i (t + 1))) in Hflip; discriminate. }
  Qed.
End Interfaces_Deadband.