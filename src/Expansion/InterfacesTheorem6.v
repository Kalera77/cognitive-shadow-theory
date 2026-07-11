(** * InterfacesTheorem6.v – Theorem 6 on noise dominance in interfaces *)
Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lia.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.GlobalParameters.

Open Scope R_scope.

Section InterfacesTheorem6.
  Variable Agent : Type.
  Inductive Component : Set := Sens | Sem | Rel | Refl.

  Variable C : Agent -> nat -> Component -> R.
  Variable Sel : Agent -> nat -> Component -> R.
  Variable I : Agent -> nat -> Component -> R.
  Parameter use    : Agent -> nat -> Component -> R.
  Parameter intent : Agent -> nat -> Component -> R.
  Parameter noise  : Agent -> nat -> Component -> R.

  (* Input bounds *)
  Axiom use_bound   : forall A t k, 0 <= use A t k <= U_max.
  Axiom intent_bound: forall A t k, 0 <= intent A t k <= I_max.
  Axiom noise_bound : forall A t k, 0 <= noise A t k <= N_max.

  Parameter alpha_comp beta_comp : Component -> R.
  Axiom alpha_comp_pos : forall k, alpha_comp k > 0.
  Axiom beta_comp_pos  : forall k, beta_comp k > 0.

  Parameter nu mu : R.
  Parameter repair damage : Agent -> nat -> Component -> R.

  (* Clamping helper function *)
  Definition clamp_01 (x : R) : R := Rmin (Rmax x 0) 1.

  Lemma clamp_01_spec : forall x, 0 <= clamp_01 x <= 1 /\
    ( (0 <= x <= 1) -> clamp_01 x = x ).
  Proof.
    intros x; unfold clamp_01.
    split.
    - split.
      + destruct (Rle_dec (Rmax x 0) 1) as [H|H].
        * rewrite Rmin_left; [| exact H]. apply Rmax_r.
        * assert (Rmin (Rmax x 0) 1 = 1) as ->.
          { apply Rmin_right. apply Rlt_le. apply Rnot_le_lt. exact H. }
          apply Rle_0_1.
      + apply Rmin_r.
    - intros [H0 H1].
      rewrite Rmax_left; [| exact H0].
      rewrite Rmin_left; [| exact H1].
      reflexivity.
  Qed.

  Lemma clamp_01_nonpos : forall x, x <= 0 -> clamp_01 x = 0.
  Proof.
    intros x Hx.
    unfold clamp_01.
    assert (Hmax : Rmax x 0 = 0).
    { apply Rle_antisym.
      - apply Rmax_lub; [exact Hx | apply Rle_refl].
      - apply Rmax_r. }
    rewrite Hmax.
    apply Rmin_left; apply Rle_0_1.
  Qed.

  Axiom C_init_bound : forall A k, 0 <= C A 0 k <= 1.

  (* Evolution equations from A27 *)
  Axiom A27_C_evol : forall (A : Agent) (t : nat) (k : Component),
    C A (S t) k = clamp_01( C A t k + gamma * use A t k + delta_ * intent A t k - eta * noise A t k ).

  Axiom A27_I_evol : forall (A : Agent) (t : nat) (k : Component),
    I A (S t) k = I A t k + nu * (1 - I A t k) * repair A t k - mu * I A t k * damage A t k.

  Axiom I_bounded_axiom : forall A t k, 0 <= I A t k <= 1.

  Parameter O_threshold : R.
  Axiom O_threshold_pos : O_threshold > 0.

  (* Noise dominance condition *)
  Axiom A27_noise_dominates : forall A t i j,
    i <> j ->
    C A t i >= C A t j + O_threshold ->
    gamma * use A t j + delta_ * intent A t j <= eta * noise A t j.

  Axiom noise_dominates_linear : forall A t i j,
    i <> j ->
    C A t i >= C A t j + O_threshold ->
    gamma * use A t j + delta_ * intent A t j - eta * noise A t j <=
    - (C A t i - C A t j - O_threshold).

  (* Lemma: C always in [0,1] *)
  Lemma C_bounded : forall A t k, 0 <= C A t k <= 1.
  Proof.
    induction t; [apply C_init_bound | intros; rewrite A27_C_evol; apply clamp_01_spec].
  Qed.

  (* Theorem 6 (weak form): upper bound on capacity increase difference *)
  Theorem Theorem_6_weak : forall (A : Agent) (t : nat) (i j : Component),
      i <> j ->
      C A t i >= C A t j + O_threshold ->
      intent A t i = intent A t j ->
      noise A t i = noise A t j ->
      use A t i >= use A t j ->
      let Di := C A t i in
      let Dj := C A t j in
      let use_i := use A t i in
      let use_j := use A t j in
      (C A (S t) i - Di) <= gamma * (use_i - use_j).
  Proof.
    (* proof as in original *)
    intros A t i j Hneq Hge Hintent Hnoise Huse_le Di Dj use_i use_j.
    rewrite A27_C_evol.
    set (common := gamma * use_j + delta_ * intent A t j - eta * noise A t j).
    assert (common_le_0 : common <= 0)
      by (unfold common; apply Rle_minus; apply (A27_noise_dominates A t i j); auto).
    rewrite Hintent, Hnoise.
    set (x := Di + gamma * use_i + delta_ * intent A t j - eta * noise A t j).
    assert (H1 : clamp_01 x - Di <= Rmax x 0 - Di).
    { apply Rplus_le_compat_r. unfold clamp_01. apply Rmin_l. }
    assert (H2 : Rmax x 0 - Di <= x - Di \/ Rmax x 0 - Di <= 0 - Di).
    { destruct (Rle_dec 0 x) as [Hx|Hx].
      - left. rewrite Rmax_left; [apply Rle_refl | exact Hx].
      - right. rewrite Rmax_right; [apply Rle_refl | lra]. }
    destruct H2 as [H2 | H2].
    - apply Rle_trans with (x - Di).
      + apply Rle_trans with (Rmax x 0 - Di); [apply H1 | apply H2].
      + unfold x.
        replace (Di + gamma * use_i + delta_ * intent A t j - eta * noise A t j - Di)
          with (gamma * use_i + delta_ * intent A t j - eta * noise A t j) by ring.
        replace (gamma * use_i + delta_ * intent A t j - eta * noise A t j)
          with (gamma * (use_i - use_j) + common) by (unfold common; ring).
        apply Rle_trans with (gamma * (use_i - use_j) + common).
        * apply Rle_refl.
        * lra.
    - apply Rle_trans with (0 - Di).
      + apply Rle_trans with (Rmax x 0 - Di); [apply H1 | apply H2].
      + apply Rle_trans with 0.
        * rewrite Rminus_0_l. replace 0 with (-0) by ring. apply Ropp_le_contravar. apply C_bounded.
        * apply Rmult_le_pos.
          { apply Rlt_le, gamma_pos. }
          { cut (-0 <= -(use_j - use_i)).
            - intro Hcut. replace (-0) with 0 in Hcut by ring.
              replace (-(use_j - use_i)) with (use_i - use_j) in Hcut by ring. apply Hcut.
            - apply Ropp_le_contravar. apply Rle_minus. apply Rge_le. apply Huse_le. }
  Qed.

  (* Theorem 6 (strong form): explicit suppression of the lagging component *)
  Theorem Theorem_6_strong : forall (A : Agent) (t : nat) (i j : Component),
      i <> j ->
      C A t i >= C A t j + O_threshold ->
      intent A t i = intent A t j ->
      noise A t i = noise A t j ->
      use A t i >= use A t j ->
      let Di := C A t i in
      let Dj := C A t j in
      let use_i := use A t i in
      let use_j := use A t j in
      exists kappa : R, kappa > 0 /\
      (C A (S t) i - Di) <= - kappa * (Di - Dj - O_threshold) + gamma * (use_i - use_j).
  Proof.
    intros A t i j Hneq Hge Hintent Hnoise Huse_le Di Dj use_i use_j.
    exists 1. split; [lra |].
    set (common := gamma * use_j + delta_ * intent A t j - eta * noise A t j).
    set (xi := Di + gamma * use_i + delta_ * intent A t i - eta * noise A t i).
    destruct (Rle_dec 0 xi) as [Hxi_ge0 | Hxi_lt0].
    - rewrite A27_C_evol.
      assert (Hclamp : clamp_01 xi - Di <= xi - Di).
      { apply Rplus_le_compat_r. unfold clamp_01. rewrite Rmax_left; [apply Rmin_l | exact Hxi_ge0]. }
      apply Rle_trans with (xi - Di).
      + apply Hclamp.
      + unfold xi.
        replace (intent A t i) with (intent A t j) by (rewrite Hintent; auto).
        replace (noise A t i) with (noise A t j) by (rewrite Hnoise; auto).
        replace (Di + gamma * use_i + delta_ * intent A t j - eta * noise A t j - Di)
          with (gamma * use_i + delta_ * intent A t j - eta * noise A t j) by ring.
        replace (gamma * use_i + delta_ * intent A t j - eta * noise A t j)
          with (gamma * (use_i - use_j) + common) by (unfold common; ring).
        rewrite (Rplus_comm (gamma * (use_i - use_j)) common).
        apply Rplus_le_compat_r.
        assert (H_common_le : common <= - (Di - Dj - O_threshold)).
        { unfold Di, Dj, common. apply noise_dominates_linear; auto. }
        apply Rle_trans with (- (Di - Dj - O_threshold)).
        * exact H_common_le.
        * rewrite <- (Rmult_1_l (- (Di - Dj - O_threshold))). right; ring.
    - assert (Hxi_le0 : xi <= 0) by (apply Rlt_le; apply Rnot_le_lt; exact Hxi_lt0).
      assert (Hclamp0 : clamp_01 xi = 0) by (apply clamp_01_nonpos; exact Hxi_le0).
      pose proof (A27_C_evol A t i) as Heq.
      replace (C A (S t) i) with (clamp_01 xi) by (rewrite Heq; reflexivity).
      rewrite Hclamp0. rewrite Rminus_0_l.
      apply Rplus_le_reg_l with Di. ring_simplify.
      unfold xi.
      replace (intent A t i) with (intent A t j) by (rewrite Hintent; auto).
      replace (noise A t i) with (noise A t j) by (rewrite Hnoise; auto).
      replace (Dj + O_threshold + gamma * use_i - gamma * use_j)
        with ((Dj + O_threshold) + (gamma * use_i - gamma * use_j)) by ring.
      apply Rplus_le_le_0_compat with (r1 := Dj + O_threshold) (r2 := gamma * use_i - gamma * use_j).
      { apply Rplus_le_le_0_compat with (r1 := Dj) (r2 := O_threshold).
        - apply (proj1 (C_bounded A t j)).
        - apply Rlt_le; apply O_threshold_pos. }
      { rewrite <- Rmult_minus_distr_l.
        apply Rmult_le_pos.
        - apply Rlt_le; exact gamma_pos.
        - apply Rplus_le_reg_l with use_j. ring_simplify. apply Rge_le. exact Huse_le. }
  Qed.

End InterfacesTheorem6.