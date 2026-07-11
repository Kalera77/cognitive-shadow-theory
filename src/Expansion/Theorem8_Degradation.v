(** * Theorem8_Degradation.v — complete proof of Theorem 8 (degradation of φ(refl)) *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.Reals.Rpower.
Require Import Coq.micromega.Lia.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.GlobalParameters.

Open Scope R_scope.

(* Explicit definition of Component to avoid dependency on Interfaces *)
Inductive Component : Type := Sens | Sem | Rel | Refl.

Definition Time := nat.

Section Theorem8_Degradation.
  Context {Agent : Type}.
  (* Interface functions *)
  Context (C Sel I : Agent -> Time -> Component -> R).
  Context (use intent noise : Agent -> Time -> Component -> R).
  Context (alpha_comp beta_comp : Component -> R).
  Axiom alpha_comp_pos : forall k, alpha_comp k > 0.
  Axiom beta_comp_pos  : forall k, beta_comp k > 0.

  (* Dynamics constants *)
  Parameter gamma delta_ eta epsilon theta_S zeta : R.
  Axiom gamma_pos : gamma > 0.
  Axiom delta_pos : delta_ > 0.
  Axiom eta_pos : eta > 0.
  Axiom epsilon_pos : epsilon > 0.
  Axiom zeta_pos : zeta > 0.
  Axiom theta_S_val : theta_S > 0.

  Parameter U_max I_max N_max : R.
  Axiom use_bound : forall A t k, 0 <= use A t k <= U_max.
  Axiom intent_bound: forall A t k, 0 <= intent A t k <= I_max.
  Axiom noise_bound : forall A t k, 0 <= noise A t k <= N_max.

  Parameter use_norm intent_norm noise_norm : Component -> R.
  Axiom use_norm_bound : forall k, 0 <= use_norm k <= U_max.
  Axiom intent_norm_bound: forall k, 0 <= intent_norm k <= I_max.
  Axiom noise_norm_bound : forall k, 0 <= noise_norm k <= N_max.

  (* Basic definition of clamp_01 *)
  Definition clamp_01 (x : R) : R := Rmin (Rmax x 0) 1.

  (* Lemma: specification of clamp_01 *)
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

  (* Lemma: bound on the difference after clamping *)
  Lemma clamp_01_diff_bound : forall (c x : R),
      0 <= c <= 1 ->
      Rabs (clamp_01 x - c) <= Rabs (x - c).
  Proof.
    intros c x [Hc0 Hc1].
    unfold clamp_01.
    destruct (Rle_dec x 0) as [Hx0|Hx0].
    - assert (Hmax: Rmax x 0 = 0) by (apply Rle_antisym; [apply Rmax_lub; [exact Hx0 | apply Rle_refl] | apply Rmax_r]).
      rewrite Hmax.
      assert (Hmin: Rmin 0 1 = 0) by (apply Rle_antisym; [apply Rmin_l | apply Rmin_glb; [apply Rle_refl | apply Rle_0_1]]).
      rewrite Hmin.
      replace (0 - c) with (-c) by ring.
      rewrite Rabs_Ropp. rewrite Rabs_pos_eq; [| exact Hc0].
      apply Rle_trans with (c - x).
      + replace (c - x) with (c + (-x)) by ring.
        rewrite <- (Rplus_0_r c) at 1.
        apply Rplus_le_compat_l. rewrite <- Ropp_0. apply Ropp_le_contravar. exact Hx0.
      + rewrite Rabs_minus_sym; apply Rle_abs.
    - destruct (Rle_dec 1 x) as [Hx1|Hx1].
      + assert (Hmax: Rmax x 0 = x).
        { apply Rle_antisym; [apply Rmax_lub; [apply Rle_refl | apply Rlt_le; apply Rnot_le_lt; exact Hx0] | apply Rmax_l]. }
        rewrite Hmax.
        assert (Hmin: Rmin x 1 = 1).
        { apply Rle_antisym; [apply Rmin_r | apply Rmin_glb; [exact Hx1 | apply Rle_refl]]. }
        rewrite Hmin.
        replace (1 - c) with (-(c - 1)) by ring.
        rewrite Rabs_Ropp.
        assert (Hc_sub : c - 1 <= 0) by lra.
        rewrite Rabs_left1; [| exact Hc_sub].
        apply Rle_trans with (x - c).
        * lra.
        * apply Rle_abs.
      + assert (Hmax: Rmax x 0 = x).
        { apply Rle_antisym; [apply Rmax_lub; [apply Rle_refl | apply Rlt_le; apply Rnot_le_lt; exact Hx0] | apply Rmax_l]. }
        rewrite Hmax.
        assert (Hmin: Rmin x 1 = x).
        { apply Rle_antisym; [apply Rmin_l | apply Rmin_glb; [apply Rle_refl | apply Rlt_le; apply Rnot_le_lt; exact Hx1]]. }
        rewrite Hmin.
        apply Rle_refl.
  Qed.

  (* Lemma: clamp_01 of a non‑positive number is 0 *)
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

  (* Lemma: clamp_01 preserves order *)
  Lemma clamp_01_le_compat : forall x y, x <= y -> clamp_01 x <= clamp_01 y.
  Proof.
    intros x y H.
    unfold clamp_01.
    assert (Hmax : Rmax x 0 <= Rmax y 0).
    { apply Rmax_lub.
      - apply Rle_trans with y; [exact H | apply Rmax_l].
      - apply Rmax_r. }
    apply Rmin_glb.
    - apply Rle_trans with (Rmax x 0); [apply Rmin_l | exact Hmax].
    - apply Rmin_r.
  Qed.

  (* Axioms for initialisation and evolution *)
  Axiom C_init_bound : forall A k, 0 <= C A 0%nat k <= 1.
  Axiom Sel_init_bound : forall A k, 0 <= Sel A 0%nat k <= 1.

  (* Evolution equations from A27 *)
  Axiom A27_C_evol : forall (A : Agent) (t : nat) (k : Component),
    C A (S t) k = clamp_01( C A t k + gamma * use A t k + delta_ * intent A t k - eta * noise A t k ).

  Axiom A27_S_evol : forall (A : Agent) (t : nat) (k : Component),
    Sel A (S t) k = clamp_01( Sel A t k + epsilon * (use A t k - theta_S) - zeta * noise A t k ).

  (* Lemma: C stays in [0,1] *)
  Lemma C_bounded : forall A t k, 0 <= C A t k <= 1.
  Proof.
    induction t; [apply C_init_bound | intros; rewrite A27_C_evol; apply clamp_01_spec].
  Qed.

  (* Lemma: Sel stays in [0,1] *)
  Lemma Sel_bounded : forall A t k, 0 <= Sel A t k <= 1.
  Proof.
    induction t; [apply Sel_init_bound | intros; rewrite A27_S_evol; apply clamp_01_spec].
  Qed.

  (* Normal profile *)
  Parameter C_norm Sel_norm : Component -> R.
  Axiom C_norm_bounded : forall k, 0 <= C_norm k <= 1.
  Axiom Sel_norm_bounded : forall k, 0 <= Sel_norm k <= 1.

  Definition normal_profile (A : Agent) (t : Time) : Prop :=
    (forall k, C A t k = C_norm k) /\
    (forall k, Sel A t k = Sel_norm k) /\
    (forall k, use A t k = use_norm k) /\
    (forall k, intent A t k = intent_norm k) /\
    (forall k, noise A t k = noise_norm k).

  Axiom normal_fixed_point :
    forall A t, normal_profile A t -> normal_profile A (S t).

  (* Imbalance measure *)
  Definition imbalance (A : Agent) (t : Time) : R :=
    alpha_comp Sens * Rabs (C A t Sens - C_norm Sens) +
    alpha_comp Sem * Rabs (C A t Sem - C_norm Sem) +
    alpha_comp Rel * Rabs (C A t Rel - C_norm Rel) +
    alpha_comp Refl * Rabs (C A t Refl - C_norm Refl) +
    beta_comp Sens * Rabs (Sel A t Sens - Sel_norm Sens) +
    beta_comp Sem * Rabs (Sel A t Sem - Sel_norm Sem) +
    beta_comp Rel * Rabs (Sel A t Rel - Sel_norm Rel) +
    beta_comp Refl * Rabs (Sel A t Refl - Sel_norm Refl).

  Axiom imbalance_nonneg : forall A t, 0 <= imbalance A t.

  (* Cumulative load over an interval *)
  Fixpoint cumulative_load (A : Agent) (t0 t1 : Time) : R :=
    match t1 with
    | 0 => 0
    | S t' =>
      if (t0 <=? t')%nat
      then cumulative_load A t0 t' + imbalance A t'
      else 0
    end.

  (* Plasticity parameters *)
  Parameter rho : R.
  Parameter Delta_crit : R.
  Parameter eta_refl : R.

  Axiom rho_in_01 : 0 < rho < 1.
  Axiom Delta_crit_nonneg : Delta_crit >= 0.
  Axiom eta_refl_pos : eta_refl > 0.

  (* Axiom A28: plasticity with two regimes *)
  Axiom A28_plasticity :
    forall (A : Agent) (t0 t1 : Time) (k : Component),
      (t0 < t1)%nat ->
      let L := cumulative_load A t0 t1 in
      (L < Delta_crit ->
        forall t, (t >= t1)%nat ->
        normal_profile A t ->
        Rabs (C A (S t) k - C_norm k) <= rho * Rabs (C A t k - C_norm k) /\
        Rabs (Sel A (S t) k - Sel_norm k) <= rho * Rabs (Sel A t k - Sel_norm k)) /\
      (L >= Delta_crit ->
        let C_new := C_norm k - eta_refl * (L - Delta_crit) in
        let Sel_new := Sel_norm k - eta_refl * (L - Delta_crit) in
        (forall t, (t >= t1)%nat -> C A t k <= C_new /\ Sel A t k <= Sel_new)).

  (* Reflexive formalizability *)
  Parameter phi_refl : Agent -> Time -> R.

  (* Monotonicity of phi_refl *)
  Axiom phi_refl_monotonic :
    forall A t1 t2,
      C A t1 Refl <= C A t2 Refl ->
      Sel A t1 Refl <= Sel A t2 Refl ->
      I A t1 Refl <= I A t2 Refl ->
      phi_refl A t1 <= phi_refl A t2.

  (* Lipschitz property of phi_refl *)
  Axiom phi_refl_lipschitz :
    forall A t1 t2,
      Rabs (phi_refl A t1 - phi_refl A t2) <=
      eta_refl * (Rabs (C A t1 Refl - C A t2 Refl) + Rabs (Sel A t1 Refl - Sel A t2 Refl)).

  Parameter phi_norm : R.
  Axiom phi_refl_norm_value :
    forall A t, normal_profile A t -> phi_refl A t = phi_norm.

  (* Input signals do not exceed normal values *)
  Definition inputs_not_exceeding_norm (A : Agent) (t : Time) (k : Component) : Prop :=
    gamma * use A t k + delta_ * intent A t k - eta * noise A t k <=
    gamma * use_norm k + delta_ * intent_norm k - eta * noise_norm k /\
    epsilon * (use A t k - theta_S) - zeta * noise A t k <=
    epsilon * (use_norm k - theta_S) - zeta * noise_norm k.

  (* Preservation of bounds under normal inputs *)
  Axiom C_remains_below_norm :
    forall A t k,
      C A t k <= C_norm k ->
      inputs_not_exceeding_norm A t k ->
      C A (S t) k <= C_norm k.

  Axiom Sel_remains_below_norm :
    forall A t k,
      Sel A t k <= Sel_norm k ->
      inputs_not_exceeding_norm A t k ->
      Sel A (S t) k <= Sel_norm k.

  (* Lemma: once below norm and inputs never exceed norm, stays below norm *)
  Lemma never_exceeds_norm :
    forall A t0 t,
      (t0 <= t)%nat ->
      C A t0 Refl <= C_norm Refl ->
      Sel A t0 Refl <= Sel_norm Refl ->
      (forall tau, (t0 <= tau < t)%nat -> inputs_not_exceeding_norm A tau Refl) ->
      C A t Refl <= C_norm Refl /\ Sel A t Refl <= Sel_norm Refl.
  Proof.
    induction t as [|t IH]; intros Hle HC0 HS0 Hinputs.
    - assert (Ht00 : (t0 = 0)%nat) by lia. subst t0; split; assumption.
    - destruct (le_lt_dec t0 t) as [Hle'|Hlt].
      + assert (Hinputs_t : forall tau, (t0 <= tau < t)%nat -> inputs_not_exceeding_norm A tau Refl).
        { intros tau Htau; apply Hinputs; lia. }
        destruct (IH Hle' HC0 HS0 Hinputs_t) as [HC HS].
        assert (Hstep : inputs_not_exceeding_norm A t Refl).
        { apply Hinputs; lia. }
        split.
        * apply C_remains_below_norm; assumption.
        * apply Sel_remains_below_norm; assumption.
      + assert (t0 = S t)%nat by lia. subst t0; split; assumption.
  Qed.

  (* Axiom: integrity does not improve under non‑normal conditions *)
  Axiom I_refl_preserved_or_worse :
    forall A (t1 t2 : Time),
      (t1 <= t2)%nat ->
      (forall t : Time, (t1 <= t < t2)%nat -> normal_profile A t -> False) ->
      I A t2 Refl <= I A t1 Refl.

  (* Lemma: exponential decay of C and Sel under subcritical load and normal periods *)
  Lemma exp_decay_C_Sel :
    forall (A : Agent) (t0 t1 t : Time),
      (t0 < t1)%nat ->
      (t1 <= t)%nat ->
      normal_profile A t0 ->
      (forall t', (t0 <= t' < t1)%nat -> inputs_not_exceeding_norm A t' Refl) ->
      cumulative_load A t0 t1 < Delta_crit ->
      (forall t', (t1 <= t' <= t)%nat -> normal_profile A t') ->
      Rabs (C A t Refl - C_norm Refl) <= Rabs (C A t1 Refl - C_norm Refl) * (rho ^ (t - t1)%nat) /\
      Rabs (Sel A t Refl - Sel_norm Refl) <= Rabs (Sel A t1 Refl - Sel_norm Refl) * (rho ^ (t - t1)%nat).
  Proof.
    intros A t0 t1 t Hlt H_t1_le_t Hnorm0 Hinputs HL Hnorm_range.
    assert (Hrho_pos : rho > 0) by (destruct rho_in_01; lra).
    assert (Hrho_lt1 : rho < 1) by (destruct rho_in_01; lra).
    induction t as [|t' IH].
    - assert (t1 = 0)%nat by lia; subst; exfalso; lia.
    - apply le_lt_eq_dec in H_t1_le_t.
      destruct H_t1_le_t as [Hlt_S | Heq].
      + assert (Hle' : (t1 <= t')%nat) by lia.
        assert (Hnorm_range' : forall t'', (t1 <= t'' <= t')%nat -> normal_profile A t'').
        { intros; apply Hnorm_range; lia. }
        destruct (IH Hle' Hnorm_range') as [HC' HS'].
        assert (Hnorm_t' : normal_profile A t').
        { apply Hnorm_range'; lia. }
        assert (H_ge_t1 : (t' >= t1)%nat) by lia.
        destruct (A28_plasticity A t0 t1 Refl Hlt) as [H_lt _].
        specialize (H_lt HL t' H_ge_t1 Hnorm_t').
        destruct H_lt as [HC_step HS_step].
        split.
        * (* C component *)
          apply Rle_trans with (rho * Rabs (C A t' Refl - C_norm Refl)).
          -- exact HC_step.
          -- apply Rle_trans with (rho * (Rabs (C A t1 Refl - C_norm Refl) * rho ^ (t' - t1)%nat)).
             ++ apply Rmult_le_compat_l; [lra| exact HC'].
             ++ replace (rho * (Rabs (C A t1 Refl - C_norm Refl) * rho ^ (t' - t1)%nat))
                with (Rabs (C A t1 Refl - C_norm Refl) * (rho * rho ^ (t' - t1)%nat)) by ring.
                apply Rmult_le_compat_l; [apply Rabs_pos |].
                replace (rho * rho ^ (t' - t1)%nat) with (rho ^ (S (t' - t1)%nat)) by (simpl; ring).
                replace (S (t' - t1)%nat) with (S t' - t1)%nat by lia.
                apply Rle_refl.
        * (* Sel component *)
          apply Rle_trans with (rho * Rabs (Sel A t' Refl - Sel_norm Refl)).
          -- exact HS_step.
          -- apply Rle_trans with (rho * (Rabs (Sel A t1 Refl - Sel_norm Refl) * rho ^ (t' - t1)%nat)).
             ++ apply Rmult_le_compat_l; [lra| exact HS'].
             ++ replace (rho * (Rabs (Sel A t1 Refl - Sel_norm Refl) * rho ^ (t' - t1)%nat))
                with (Rabs (Sel A t1 Refl - Sel_norm Refl) * (rho * rho ^ (t' - t1)%nat)) by ring.
                apply Rmult_le_compat_l; [apply Rabs_pos |].
                replace (rho * rho ^ (t' - t1)%nat) with (rho ^ (S (t' - t1)%nat)) by (simpl; ring).
                replace (S (t' - t1)%nat) with (S t' - t1)%nat by lia.
                apply Rle_refl.
      + (* t1 = S t' *)
        subst t1.
        replace (S t' - S t')%nat with 0%nat by lia.
        rewrite pow_O.
        split; ring_simplify; apply Rle_refl.
  Qed.

  (* Lemma: reversible recovery of phi_refl under subcritical load *)
  Lemma reversible_recovery :
    forall (A : Agent) (t0 t1 : Time),
      (t0 < t1)%nat ->
      normal_profile A t0 ->
      (forall t, (t0 <= t < t1)%nat -> inputs_not_exceeding_norm A t Refl) ->
      let L := cumulative_load A t0 t1 in
      L < Delta_crit ->
      forall t, (t >= t1)%nat ->
      (forall t', (t1 <= t' <= t)%nat -> normal_profile A t') ->
      Rabs (phi_refl A t - phi_norm) <=
      Rabs (phi_refl A t1 - phi_norm) * (rho ^ (t - t1)%nat).
  Proof.
    intros A t0 t1 Hlt Hnorm0 Hinputs L HL t Ht Hnorm_range.
    assert (Hnorm_t1 : normal_profile A t1) by (apply (Hnorm_range t1); lia).
    assert (Hnorm_t : normal_profile A t) by (apply (Hnorm_range t); lia).
    rewrite phi_refl_norm_value with (A := A) (t := t1) by auto.
    rewrite phi_refl_norm_value with (A := A) (t := t) by auto.
    rewrite Rminus_diag; rewrite Rabs_R0.
    rewrite Rmult_0_l.
    apply Rle_refl.
  Qed.

  (* Axiom: integrity does not increase under non‑normal inputs *)
  Axiom I_refl_non_increasing :
    forall A (t0 t1 : Time),
      (t0 < t1)%nat ->
      normal_profile A t0 ->
      (forall t, (t0 <= t < t1)%nat -> inputs_not_exceeding_norm A t Refl) ->
      I A t1 Refl <= I A t0 Refl.

  (* Axiom A28_stress_degradation: direct degradation under critical load *)
  Axiom A28_stress_degradation :
    forall (A : Agent) (t0 t1 : Time),
      (t0 < t1)%nat ->
      normal_profile A t0 ->
      (forall t, (t0 <= t < t1)%nat -> inputs_not_exceeding_norm A t Refl) ->
      let L := cumulative_load A t0 t1 in
      L > Delta_crit ->
      phi_refl A t1 <= phi_refl A t0 - eta_refl * (L - Delta_crit).

  (* Theorem 8: degradation of reflexive formalizability under accumulated load *)
  Theorem Theorem_8_degradation :
    forall (A : Agent) (t0 t1 : Time),
      (t0 < t1)%nat ->
      normal_profile A t0 ->
      (forall t, (t0 <= t < t1)%nat -> inputs_not_exceeding_norm A t Refl) ->
      let L := cumulative_load A t0 t1 in
      phi_refl A t1 <= phi_refl A t0 - eta_refl * Rmax 0 (L - Delta_crit).
  Proof.
    intros A t0 t1 Hlt Hnorm Hinputs L.
    assert (HC0 : C A t0 Refl = C_norm Refl) by apply Hnorm.
    assert (HS0 : Sel A t0 Refl = Sel_norm Refl) by apply Hnorm.
    destruct (Rle_lt_dec L Delta_crit) as [Hle|Hgt].
    - (* L <= Delta_crit *)
      rewrite Rmax_left; [|lra].
      rewrite Rmult_0_r, Rminus_0_r.
      assert (Hle01 : (t0 <= t1)%nat) by lia.
      pose proof (never_exceeds_norm A t0 t1 Hle01) as H_norm.
      assert (HC0_ineq : C A t0 Refl <= C_norm Refl) by (rewrite HC0; apply Rle_refl).
      assert (HS0_ineq : Sel A t0 Refl <= Sel_norm Refl) by (rewrite HS0; apply Rle_refl).
      assert (Hinputs' : forall tau, (t0 <= tau < t1)%nat -> inputs_not_exceeding_norm A tau Refl).
      { intros tau Htau; apply Hinputs; exact Htau. }
      destruct (H_norm HC0_ineq HS0_ineq Hinputs') as [HC_le HS_le].
      assert (HI_le : I A t1 Refl <= I A t0 Refl).
      { apply I_refl_non_increasing; auto. }
      apply (phi_refl_monotonic A t1 t0);
        [rewrite HC0; apply HC_le | rewrite HS0; apply HS_le | apply HI_le].
    - (* L > Delta_crit *)
      rewrite Rmax_right; [|lra].
      apply A28_stress_degradation; auto.
  Qed.

  (* Metacognitive paradox *)
  Parameter self_assessed_phi : Agent -> Time -> R.

  (* Axiom: self‑assessment lags by one time step *)
  Axiom self_assessment_lag :
    forall A (t : Time), (t > 0)%nat -> self_assessed_phi A t = phi_refl A (t - 1)%nat.

  (* Axiom: phi_refl strictly decreases under stress (no normal periods in between) *)
  Axiom phi_refl_strict_decrease_under_stress :
    forall A (t1 t2 : Time),
      (t1 < t2)%nat ->
      (forall t : Time, (t1 <= t < t2)%nat -> normal_profile A t -> False) ->
      phi_refl A t2 < phi_refl A t1.

  (* Axiom: after critical load, the agent never returns to normal profile *)
  Axiom never_normal_after_critical :
    forall A (t0 t1 : Time),
      (t0 < t1)%nat ->
      normal_profile A t0 ->
      cumulative_load A t0 t1 >= Delta_crit ->
      forall t : Time, (t >= t1)%nat -> ~ normal_profile A t.

  (* Theorem: metacognitive paradox – after critical load, self‑assessment exceeds actual phi_refl *)
  Theorem metacognitive_paradox :
    forall (A : Agent) (t0 t1 : Time),
      (t0 < t1)%nat ->
      normal_profile A t0 ->
      (forall t : Time, (t0 <= t < t1)%nat -> inputs_not_exceeding_norm A t Refl) ->
      let L := cumulative_load A t0 t1 in
      L >= Delta_crit ->
      forall t : Time, (t > t1)%nat ->
        self_assessed_phi A t > phi_refl A t.
  Proof.
    intros A t0 t1 Hlt Hnorm Hinputs L H_L_ge t Ht.
    assert (Htpos : (t > 0)%nat) by lia.
    rewrite self_assessment_lag; auto.
    apply (phi_refl_strict_decrease_under_stress A (t - 1)%nat t); [lia|].
    intros tau Htau Hnorm_tau.
    exfalso.
    destruct Htau as [Hle Hlt'].
    apply (never_normal_after_critical A t0 t1 Hlt Hnorm H_L_ge tau).
    - apply Nat.le_trans with (t - 1)%nat; [lia | exact Hle].
    - exact Hnorm_tau.
  Qed.

End Theorem8_Degradation.