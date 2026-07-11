(* GlobalParameters.v — central module of global parameters for CognitiveShadow v5.0 *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.Arith.Arith.
Require Import Coq.micromega.Lra.
Require Import Coq.Reals.Rpower.   (* for ln *)

Open Scope R_scope.

(* Main parameter: number of distinguishable macrostates *)
Parameter M : nat.
Axiom M_pos : (M > 0)%nat.

(* Lemma: ln 2 > 0 *)
Lemma ln_2_pos : ln 2 > 0.
Proof.
  rewrite <- ln_1.
  apply ln_increasing.
  - apply Rlt_0_1.
  - pose proof (Rplus_lt_compat_l 1 0 1 Rlt_0_1) as H.
    replace (1 + 0) with 1 in H by ring.
    replace (1 + 1) with 2 in H by ring.
    exact H.
Qed.

(* Minimal entropy growth step derived from M *)
Definition delta_min : R := (ln 2) / INR M.

(* Lemma: δ_min > 0 *)
Lemma delta_min_pos : delta_min > 0.
Proof.
  unfold delta_min.
  apply Rdiv_lt_0_compat.
  - apply ln_2_pos.
  - apply lt_0_INR; exact M_pos.
Qed.

(* Derived parameters and constraints *)

(* Maximum length of a formal proof (resource bound A8) *)
Definition L_max : nat := M.

(* Maximum interface resource R_max (axiom A27) *)
Definition R_max : R := (ln 2) / delta_min.

(* Lemma: R_max equals M *)
Lemma R_max_equals_M : R_max = INR M.
Proof.
  unfold R_max, delta_min.
  field; split.
  - apply Rgt_not_eq, lt_0_INR, M_pos.
  - apply Rgt_not_eq, ln_2_pos.
Qed.

(* Quarantine threshold used in A15 and A4 *)
Definition QuarantineThreshold : R := delta_min * INR M.
Axiom quarantine_threshold_ge_half : QuarantineThreshold >= 1/2.

(* Axiom linking quarantine threshold to δ_min and M*)
Axiom quarantine_entropy_link :
  QuarantineThreshold = delta_min * INR M.

(* Lemma: quarantine threshold equals ln 2 *)
Lemma quarantine_equals_ln2 : QuarantineThreshold = ln 2.
Proof.
  rewrite quarantine_entropy_link.
  unfold delta_min.
  field.
  apply Rgt_not_eq, lt_0_INR, M_pos.
Qed.

(* Channel type and transmission parameters *)
Parameter Channel : Type.
Parameter fidelity : Channel -> R.
Axiom fidelity_range : forall ch, 0 <= fidelity ch <= 1.

Parameter max_fidelity : R.
Axiom max_fidelity_lt1 : max_fidelity < 1.
Axiom fidelity_le_max : forall ch, fidelity ch <= max_fidelity.

Parameter eta_degradation : R.
Axiom eta_degradation_pos : eta_degradation > 0.

(* Calibration axiom for degradation coefficient *)
Axiom eta_calibration :
  eta_degradation >= QuarantineThreshold / (1 - max_fidelity).

(* Interface parameters (from A27) *)
Section InterfaceParams.
  (** Component weights in resource constraint *)
  Parameter alpha : R.
  Parameter beta  : R.
  Axiom alpha_pos : alpha > 0.
  Axiom beta_pos  : beta > 0.

  (* Interface dynamics constants *)
  Parameter gamma delta_ eta epsilon theta_S zeta : R.
  Axiom gamma_pos   : gamma > 0.
  Axiom delta_pos   : delta_ > 0.
  Axiom eta_pos     : eta > 0.
  Axiom epsilon_pos : epsilon > 0.
  Axiom zeta_pos    : zeta > 0.
  Axiom theta_S_val : theta_S = 0.5.  (* fixed value *)

  (* Maximum values of input signals *)
  Parameter U_max I_max N_max : R.
  Axiom U_max_pos : U_max >= 0.
  Axiom I_max_pos : I_max >= 0.
  Axiom N_max_pos : N_max >= 0.

  (* Normal values (for Theorem 8) *)
  Parameter use_norm intent_norm noise_norm : R.
  Axiom use_norm_bound : 0 <= use_norm <= U_max.
  Axiom intent_norm_bound : 0 <= intent_norm <= I_max.
  Axiom noise_norm_bound : 0 <= noise_norm <= N_max.
End InterfaceParams.

(* Parameters for quantum error correction *)
Definition epsilon_qec : R := 0.1.   (* from A25 *)

(* Parameters for Theorem 8 (degradation) *)
Parameter rho : R.                (* recovery speed *)
Parameter Delta_crit : R.         (* critical load *)
Parameter eta_refl : R.           (* degradation coefficient *)
Axiom rho_in_01 : 0 < rho < 1.
Axiom Delta_crit_nonneg : Delta_crit >= 0.
Axiom eta_refl_pos : eta_refl > 0.

(* Parameters for resonance limit (Theorem 2) *)
Parameter rho_max : R.
Axiom rho_max_val : rho_max = 0.85.

(* Minimum entropy for meaningful communication *)
Parameter H_min : R.
Axiom H_min_pos : H_min > 0.

(* =============================================================== *)
(* Global component type for interfaces (Sens, Sem, Rel, Refl)     *)
(* =============================================================== *)
Inductive Component : Set := Sens | Sem | Rel | Refl.

(* =============================================================== *)
(* Axiom of minimal profile variation for interfaces               *)
(* (follows from quantum stochasticity and finite resolution)      *)
(* =============================================================== *)
Axiom min_profile_variation :
  forall (alpha_comp beta_comp : Component -> R)
         (C Sel : forall (A : Type) (t : nat), Component -> R)
         (use intent noise : forall (A : Type) (t : nat), Component -> R),
    (forall k, alpha_comp k > 0) ->
    (forall k, beta_comp k > 0) ->
    (forall (A : Type) (t : nat),
        alpha_comp Sens * C A t Sens + alpha_comp Sem * C A t Sem +
        alpha_comp Rel * C A t Rel + alpha_comp Refl * C A t Refl +
        beta_comp Sens * Sel A t Sens + beta_comp Sem * Sel A t Sem +
        beta_comp Rel * Sel A t Rel + beta_comp Refl * Sel A t Refl <= R_max) ->
    forall (A : Type) (t : nat),
    delta_min <=
    alpha_comp Sens * Rabs (C A (S t) Sens - C A t Sens) +
    alpha_comp Sem  * Rabs (C A (S t) Sem  - C A t Sem) +
    alpha_comp Rel  * Rabs (C A (S t) Rel  - C A t Rel) +
    alpha_comp Refl * Rabs (C A (S t) Refl - C A t Refl) +
    beta_comp Sens * Rabs (Sel A (S t) Sens - Sel A t Sens) +
    beta_comp Sem  * Rabs (Sel A (S t) Sem  - Sel A t Sem) +
    beta_comp Rel  * Rabs (Sel A (S t) Rel  - Sel A t Rel) +
    beta_comp Refl * Rabs (Sel A (S t) Refl - Sel A t Refl).

(* Helper tactic *)
Ltac Rsimpl := repeat (rewrite Rplus_0_l || rewrite Rplus_0_r || rewrite Rmult_0_l || rewrite Rmult_0_r || rewrite Rmult_1_l || rewrite Rmult_1_r).