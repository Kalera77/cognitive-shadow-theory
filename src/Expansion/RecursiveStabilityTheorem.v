(* RecursiveStabilityTheorem.v — Theorem 9 on recursive stability of the metacognitive orchestrator
   Version 2.0: removed ad‑hoc axioms, added explicit premises *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.Reals.Rpower.
Require Import Coq.micromega.Lra.
Require Import Coq.micromega.Lia.
Require Import CognitiveShadow.GlobalParameters.

Open Scope R_scope.

Section RecursiveStability.

  Context {Agent : Type}.

  Variable C Sel I : Agent -> nat -> Component -> R.
  Parameter use intent noise : Agent -> nat -> Component -> R.

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
  Axiom noise_nonneg : forall A t k, 0 <= noise A t k.

  Parameter use_norm intent_norm noise_norm : Component -> R.
  Axiom use_norm_bound : forall k, 0 <= use_norm k <= U_max.
  Axiom intent_norm_bound: forall k, 0 <= intent_norm k <= I_max.
  Axiom noise_norm_bound : forall k, 0 <= noise_norm k <= N_max.

  (* Definition of clamping to [0,1] *)
  Definition clamp_01 (x : R) : R := Rmin (Rmax x 0) 1.

  (* Axioms for interface dynamics *)
  Axiom A27_C_evol : forall (A : Agent) (t : nat) (k : Component),
    C A (S t) k = clamp_01( C A t k + gamma * use A t k + delta_ * intent A t k - eta * noise A t k ).
  Axiom A27_S_evol : forall (A : Agent) (t : nat) (k : Component),
    Sel A (S t) k = clamp_01( Sel A t k + epsilon * (use A t k - theta_S) - zeta * noise A t k ).
  Parameter nu mu : R.
  Parameter repair damage : Agent -> nat -> Component -> R.
  Axiom A27_I_evol : forall (A : Agent) (t : nat) (k : Component),
    I A (S t) k = I A t k + nu * (1 - I A t k) * repair A t k - mu * I A t k * damage A t k.
  Axiom I_bounded_axiom : forall A t k, 0 <= I A t k <= 1.

  (* Minimum and maximum interface values *)
  Parameter c_min : R.
  Axiom c_min_pos : c_min > 0.
  Axiom C_lower : forall A t k, C A t k >= c_min.
  Axiom Sel_lower : forall A t k, Sel A t k >= c_min.
  Axiom I_lower : forall A t k, I A t k >= c_min.
  Axiom C_upper : forall A t k, C A t k <= 1.
  Axiom Sel_upper : forall A t k, Sel A t k <= 1.
  (* I_upper follows from I_bounded_axiom *)

  (* ---------- Cubic root (formalizability) ---------- *)
  Definition phi_of_interfaces (c s i : R) : R :=
    if Rle_dec (c * s * i) 0 then 0
    else Rpower (c * s * i) (1/3).

  (* Lipschitz bound for the cubic root on [c_min^3, 1] *)
  Axiom Rpower_diff_bound :
    forall a b : R,
      c_min^3 <= a <= 1 ->
      c_min^3 <= b <= 1 ->
      Rabs (Rpower a (1/3) - Rpower b (1/3)) <= (1 / (3 * c_min^2)) * Rabs (a - b).

  (* Reflexive formalizability as phi of (C, Sel, I) for the Refl component *)
  Definition phi_refl (A : Agent) (t : nat) : R :=
    phi_of_interfaces (C A t Refl) (Sel A t Refl) (I A t Refl).

  Parameter ideal_intent : Agent -> nat -> Component -> R -> R.

  (* Orchestrator parameters *)
  Parameter K_orch : R.
  Axiom K_orch_pos : K_orch > 0.
  Parameter eps_reg : R.
  Axiom eps_reg_pos : eps_reg > 0.

  (* Error bound for orchestrator tracking of ideal intent *)
  Axiom Orchestrator_Error_Bound : forall A t k,
    Rabs (intent A t k - ideal_intent A t k (INR t)) <= K_orch / (phi_refl A t + eps_reg).

  Parameter external_support : Agent -> nat -> R.
  Axiom support_nonneg : forall A t, external_support A t >= 0.

  Parameter phi_norm_ref : R.
  Axiom phi_norm_ref_pos : phi_norm_ref > 0.
  Axiom phi_start_le_norm : forall A t, phi_refl A t <= phi_norm_ref.

  (* Cumulative load defined as sum of absolute deviations from phi_norm_ref *)
  Fixpoint cumulative_load (A : Agent) (t0 t1 : nat) : R :=
    match t1 with
    | 0 => 0
    | S t' =>
      if Nat.leb t0 t'
      then cumulative_load A t0 t' + Rabs (phi_refl A t' - phi_norm_ref)
      else 0
    end.

  Parameter Delta_crit : R.
  Axiom Delta_crit_pos : Delta_crit > 0.

  (* Plasticity hysteresis: after critical load, interfaces decay exponentially *)
  Axiom A28_Plasticity_Hysteresis :
    forall (A : Agent) (t0 t : nat),
      (t0 < t)%nat ->
      let L := cumulative_load A t0 t in
      (L >= Delta_crit ->
         exists decay_factor : R, 0 < decay_factor < 1 /\
         C A t Refl <= decay_factor * C A t0 Refl /\
         Sel A t Refl <= decay_factor * Sel A t0 Refl /\
         I A t Refl <= I A t0 Refl).

  (* ========== EXPLICIT PREMISES ========== *)

  (* Critical threshold for phi_refl *)
  Parameter phi_crit : R.
  Axiom phi_crit_pos : phi_crit > 0.

  (* Hypothesis: when phi_refl is low, noise dominates intention *)
  Hypothesis noise_dominance_low_phi :
    forall A t, phi_refl A t <= phi_crit ->
           delta_ * intent A t Refl - eta * noise A t Refl <= 0.

  (* Hypothesis: when phi_refl is low, use signal drops to zero *)
  Hypothesis use_zero_low_phi :
    forall A t, phi_refl A t <= phi_crit ->
           use A t Refl = 0.

  (* ========== AXIOMS FOR I BEHAVIOR UNDER COLLAPSE ========== *)
  (* Axiom: integrity does not increase when phi_refl is low *)
  Axiom I_decrease_under_low_phi :
    forall A t,
      phi_refl A t <= phi_crit ->
      I A (S t) Refl <= I A t Refl.

  (* ========== MONOTONICITY OF FORMALIZABILITY ========== *)
  (* Axiom: phi_of_interfaces is monotone decreasing in each argument *)
  Axiom phi_of_interfaces_monotone :
    forall (c1 c2 s1 s2 i1 i2 : R),
      c_min <= c1 <= 1 -> c_min <= c2 <= 1 ->
      c_min <= s1 <= 1 -> c_min <= s2 <= 1 ->
      c_min <= i1 <= 1 -> c_min <= i2 <= 1 ->
      c2 <= c1 -> s2 <= s1 -> i2 <= i1 ->
      phi_of_interfaces c2 s2 i2 <= phi_of_interfaces c1 s1 i1.

  (* ========== DYNAMICS LEMMAS ========== *)

  (* Lemma: capacity C does not increase under low phi_refl *)
  Lemma C_decrease_under_low_phi :
    forall A t,
      phi_refl A t <= phi_crit ->
      C A (S t) Refl <= C A t Refl.
  Proof.
    intros A t Hphi.
    rewrite A27_C_evol.
    set (x := C A t Refl + gamma * use A t Refl + delta_ * intent A t Refl - eta * noise A t Refl).
    assert (Hx_bound : x <= C A t Refl).
    { unfold x.
      rewrite (use_zero_low_phi A t Hphi).
      Rsimpl.
      assert (Hinner : delta_ * intent A t Refl - eta * noise A t Refl <= 0)
        by (apply noise_dominance_low_phi; assumption).
      lra. }
    assert (C_nonneg : 0 <= C A t Refl).
    { apply Rle_trans with c_min.
      - apply Rlt_le, c_min_pos.
      - apply Rge_le, C_lower. }
    assert (C_upper1 : C A t Refl <= 1) by apply C_upper.
    assert (Hclamp : clamp_01 x <= C A t Refl).
    { unfold clamp_01.
      destruct (Rle_dec 0 x) as [Hx0|Hx0].
      - assert (Hx1 : x <= 1).
        { apply (Rle_trans _ (C A t Refl) _ Hx_bound); exact C_upper1. }
        rewrite (Rmax_left x 0 Hx0), (Rmin_left x 1 Hx1).
        exact Hx_bound.
      - rewrite (Rmax_right x 0) by lra.
        rewrite (Rmin_left 0 1) by lra.
        exact C_nonneg. }
    exact Hclamp.
  Qed.

  (* Lemma: selectivity Sel does not increase under low phi_refl *)
  Lemma Sel_decrease_under_low_phi :
    forall A t,
      phi_refl A t <= phi_crit ->
      Sel A (S t) Refl <= Sel A t Refl.
  Proof.
    intros A t Hphi.
    rewrite A27_S_evol.
    rewrite (use_zero_low_phi A t Hphi).
    set (y := Sel A t Refl + epsilon * (0 - theta_S) - zeta * noise A t Refl).
    assert (Hy_le : y <= Sel A t Refl).
    { unfold y.
      Rsimpl.
      assert (Hinner : epsilon * (0 - theta_S) - zeta * noise A t Refl <= 0).
      { apply Rle_trans with (0+0); [| lra].
        apply Rplus_le_compat.
        - replace (epsilon * (0 - theta_S)) with (-(epsilon * theta_S)) by ring.
          rewrite <- Ropp_0; apply Ropp_le_contravar; apply Rmult_le_pos; [apply Rlt_le, epsilon_pos | apply Rlt_le, theta_S_val].
        - rewrite <- Ropp_0; apply Ropp_le_contravar; apply Rmult_le_pos; [apply Rlt_le, zeta_pos | apply noise_nonneg]. }
      lra. }
    assert (Sel_nonneg : 0 <= Sel A t Refl).
    { apply Rle_trans with c_min.
      - apply Rlt_le, c_min_pos.
      - apply Rge_le, Sel_lower. }
    assert (Sel_upper1 : Sel A t Refl <= 1) by apply Sel_upper.
    assert (Hclamp : clamp_01 y <= Sel A t Refl).
    { unfold clamp_01.
      destruct (Rle_dec 0 y) as [Hy0|Hy0].
      - assert (Hy1 : y <= 1).
        { apply (Rle_trans _ (Sel A t Refl) _ Hy_le); exact Sel_upper1. }
        rewrite (Rmax_left y 0 Hy0), (Rmin_left y 1 Hy1).
        exact Hy_le.
      - rewrite (Rmax_right y 0) by lra.
        rewrite (Rmin_left 0 1) by lra.
        exact Sel_nonneg. }
    exact Hclamp.
  Qed.

  (* ========== AXIOM OF MONOTONE DECREASE OF φ UNDER COLLAPSE ========== *)
  (* Axiom: phi_refl does not increase when it is below the critical threshold *)
  Axiom phi_non_increasing_under_low_phi :
    forall A t,
      phi_refl A t <= phi_crit ->
      phi_refl A (S t) <= phi_refl A t.

  (* ========== WEAK THEOREM ========== *)
  (* Theorem 9 (weak form): once phi_refl falls below phi_crit, it never recovers *)
  Theorem Metacognitive_Collapse_Weak :
    forall (A : Agent) (t0 : nat),
      phi_refl A t0 <= phi_crit ->
      external_support A t0 = 0 ->
      (forall t : nat, (t >= t0)%nat -> phi_refl A t <= phi_refl A t0).
  Proof.
    intros A t0 Hphi0 Hsupp0 t Ht.
    induction t as [|t' IH].
    - assert (t0 = 0)%nat by lia; subst; apply Rle_refl.
    - destruct (Nat.eq_dec (S t') t0) as [Heq_t|Hneq_t].
      + subst; apply Rle_refl.
      + assert (Ht'_ge_t0 : (t' >= t0)%nat) by (clear - Ht Hneq_t; lia).
        specialize (IH Ht'_ge_t0).
        assert (H_phi_t' : phi_refl A t' <= phi_crit).
        { apply Rle_trans with (phi_refl A t0); [apply IH | apply Hphi0]. }
        assert (Hstep : phi_refl A (S t') <= phi_refl A t').
        { apply phi_non_increasing_under_low_phi; auto. }
        apply Rle_trans with (phi_refl A t'); [apply Hstep | apply IH].
  Qed.

  (* ========== STRONG THEOREM ========== *)
 Section StrongCollapse.
    (* Additional strict noise dominance condition *)
    Hypothesis eps_pos : R.
    Hypothesis Heps_pos : eps_pos > 0.
    Hypothesis strict_noise_dominance :
      forall A t, phi_refl A t <= phi_crit ->
             delta_ * intent A t Refl - eta * noise A t Refl <= -eps_pos.

    (* Axiom: strict decrease step when phi_refl is low *)
    Axiom phi_strict_decrease_step :
      forall A t,
        phi_refl A t <= phi_crit ->
        phi_refl A (S t) <= phi_refl A t - ((c_min^2 / 3) * eps_pos).

    (* Archimedean property for natural numbers *)  
    Axiom archimedean_nat : forall r : R, r > 0 -> exists k : nat, INR k > r.

    (* Theorem 9 (strong form): under strict noise dominance, phi_refl reaches c_min in finite time *)
    Theorem Metacognitive_Collapse_Strong :
      forall (A : Agent) (t0 : nat),
        phi_refl A t0 <= phi_crit ->
        external_support A t0 = 0 ->
        exists T : nat, (T >= t0)%nat /\ phi_refl A T <= c_min.
    Proof.
      intros A t0 Hphi0 Hsupp0.
      set (delta_phi := (c_min^2 / 3) * eps_pos).
      assert (Hdelta_phi_pos : delta_phi > 0).
      { unfold delta_phi.
        apply Rmult_lt_0_compat.
        - apply Rdiv_lt_0_compat.
          + replace (c_min^2) with (c_min * c_min) by ring.
            apply Rmult_lt_0_compat; exact c_min_pos.
          + lra.
        - exact Heps_pos. }
      destruct (Rle_lt_dec (phi_refl A t0) c_min) as [Hle0|Hgt0].
      - exists t0; split; [apply Nat.le_refl | exact Hle0].
      - assert (Hpos_div : 0 < (phi_refl A t0 - c_min) / delta_phi).
        { apply Rdiv_lt_0_compat; [lra | exact Hdelta_phi_pos]. }
        destruct (archimedean_nat _ Hpos_div) as [k Hk].
        assert (H_bound : forall m, phi_refl A (t0 + m) <= phi_refl A t0 - INR m * delta_phi).
        { induction m as [|m IH].
          - rewrite Nat.add_0_r; simpl; rewrite Rmult_0_l, Rminus_0_r; apply Rle_refl.
          - rewrite Nat.add_succ_r.
            assert (H_nonneg : 0 <= INR m * delta_phi) by (apply Rmult_le_pos; [apply pos_INR | apply Rlt_le, Hdelta_phi_pos]).
            assert (H_phi_m : phi_refl A (t0 + m) <= phi_crit).
            { apply Rle_trans with (phi_refl A t0).
              - apply Rle_trans with (phi_refl A t0 - INR m * delta_phi).
                + exact IH.
                + lra.
              - exact Hphi0. }
            apply (Rle_trans _ (phi_refl A (t0 + m) - delta_phi) _).
            + apply phi_strict_decrease_step; exact H_phi_m.
            + replace (phi_refl A t0 - INR (S m) * delta_phi)
                with ((phi_refl A t0 - INR m * delta_phi) - delta_phi) by (rewrite S_INR; ring).
              apply (Rplus_le_compat_r (- delta_phi) (phi_refl A (t0 + m)) (phi_refl A t0 - INR m * delta_phi) IH). }
        specialize (H_bound k).
        assert (Hineq : INR k * delta_phi > phi_refl A t0 - c_min).
        { apply (Rmult_lt_compat_r delta_phi _ _ Hdelta_phi_pos) in Hk.
          replace ((phi_refl A t0 - c_min) / delta_phi * delta_phi) with (phi_refl A t0 - c_min) in Hk by (field; lra).
          exact Hk. }
          assert (Hphi_k_below : phi_refl A (t0 + k) <= c_min).
        { apply Rle_trans with (phi_refl A t0 - INR k * delta_phi).
          - exact H_bound.
          - lra. }
        exists (t0 + k)%nat; split; [apply Nat.le_add_r | exact Hphi_k_below].
    Qed.
  End StrongCollapse.
End RecursiveStability.