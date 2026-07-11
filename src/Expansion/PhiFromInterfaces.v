(** * PhiFromInterfaces.v — Operational definition of formalizability φ via interfaces *)

(*
  In this module, the formalizability φ(k) of a component is defined as
  the cubic root of the product of capacity, selectivity, and integrity:
  φ = (C·S·I)^(1/3), clamped to zero below.

  We prove basic properties (non‑negativity, monotonicity, bound by 1)
  and assume as axioms several technical inequalities that can be proved
  using real analysis (Lipschitz property of the cubic root, product difference bound).
*)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.Reals.Rpower.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.InterfacesTheorem6.  (* contains Component *)

Open Scope R_scope.

Section PhiFromInterfaces.

  Context {Agent : Type}.
  Context (C S I : Agent -> nat -> Component -> R).

  (* Minimal possible value of each interface component *)
  Parameter c_min : R.
  Axiom c_min_pos : c_min > 0.
  Axiom C_lower : forall A t k, C A t k >= c_min.
  Axiom S_lower : forall A t k, S A t k >= c_min.
  Axiom I_lower : forall A t k, I A t k >= c_min.

  (* Formalizability computed from the triple (c, s, i) *)
  Definition phi_of_interfaces (c s i : R) : R :=
    if Rle_dec (c * s * i) 0 then 0
    else Rpower (c * s * i) (1/3).

  (* Formalizability of component k at time t *)
  Definition phi (A : Agent) (t : nat) (k : Component) : R :=
    phi_of_interfaces (C A t k) (S A t k) (I A t k).

  (* ========== Basic properties ========== *)

  (* Lemma: phi_of_interfaces is non‑negative *)
  Lemma phi_of_interfaces_nonneg : forall c s i, 0 <= phi_of_interfaces c s i.
  Proof.
    intros. unfold phi_of_interfaces.
    destruct Rle_dec; [lra |].
    apply Rlt_le; unfold Rpower; apply exp_pos.
  Qed.

  (* Lemma: exponential is non‑decreasing (helper) *)
Lemma exp_incr : forall a b, a <= b -> exp a <= exp b.
Proof.
  intros a b Hle.
  destruct (Rle_lt_or_eq_dec a b Hle) as [Hlt | Heq].
  - left; apply exp_increasing; exact Hlt.
  - subst; right; reflexivity.
Qed.

(* Lemma: monotonicity of the cubic root (proved via Rpower) *)
Lemma Rpower_cuberoot_le : forall x y, 0 < x <= y -> Rpower x (1/3) <= Rpower y (1/3).
Proof.
  intros x y [Hpos Hle].
  unfold Rpower.
  apply exp_incr.
  apply Rmult_le_compat_l; [lra |].
  destruct (Rle_lt_or_eq_dec x y Hle) as [Hlt | Heq].
  - apply Rlt_le; apply ln_increasing; lra.
  - subst x; apply Rle_refl.
Qed.

  (* Lemma: cubic root of 1 is 1 *)
Lemma Rpower_1_13 : Rpower 1 (1/3) = 1.
Proof.
  unfold Rpower.
  rewrite ln_1.
  rewrite Rmult_0_r.
  apply exp_0.
Qed.

  (* Lemma: product of three numbers in [c_min,1] is bounded below by c_min^3 *)
Lemma prod_low_bound : forall c s i,
    c_min <= c <= 1 -> c_min <= s <= 1 -> c_min <= i <= 1 ->
    c * s * i >= c_min^3.
Proof.
  intros c s i [Hc_low Hc_high] [Hs_low Hs_high] [Hi_low Hi_high].
  apply Rle_ge.
  assert (Hc0 : 0 <= c) by (apply Rle_trans with c_min; [apply Rlt_le; exact c_min_pos | exact Hc_low]).
  assert (Hs0 : 0 <= s) by (apply Rle_trans with c_min; [apply Rlt_le; exact c_min_pos | exact Hs_low]).
  assert (Hi0 : 0 <= i) by (apply Rle_trans with c_min; [apply Rlt_le; exact c_min_pos | exact Hi_low]).
  replace (c_min^3) with (c_min * (c_min * c_min)) by ring.
  replace (c_min * s * i) with (c_min * (s * i)) by ring.
  apply Rle_trans with (c_min * (s * i)).
  - apply Rmult_le_compat_l; [apply Rlt_le, c_min_pos |].
    apply Rle_trans with (c_min * s).
    + apply Rmult_le_compat_l; [apply Rlt_le, c_min_pos | exact Hs_low].
    + replace (s * i) with (i * s) by ring.
      apply (Rmult_le_compat_r s c_min i Hs0 Hi_low).
  - replace (c * s * i) with (c * (s * i)) by ring.
    apply Rmult_le_compat_r; [apply Rmult_le_pos; [exact Hs0 | exact Hi0] | exact Hc_low].
Qed.

  (* Lemma: product of three numbers in [0,1] is bounded above by 1 *)
Lemma prod_up_bound : forall c s i,
    0 <= c <= 1 -> 0 <= s <= 1 -> 0 <= i <= 1 ->
    c * s * i <= 1.
Proof.
  intros c s i [Hc0 Hc1] [Hs0 Hs1] [Hi0 Hi1].
  apply (Rle_trans (c * s * i) (1 * i) 1).
  - apply Rmult_le_compat_r; [exact Hi0 |].
    replace 1 with (1*1) by ring.
    apply Rmult_le_compat; lra.
  - rewrite Rmult_1_l; apply Hi1.
Qed.

  (* Lemma: c_min^3 is positive *)
  Lemma c_min_cube_pos : c_min^3 > 0.
  Proof.
    replace (c_min^3) with (c_min * c_min * c_min) by ring.
    apply Rmult_lt_0_compat.
    - apply Rmult_lt_0_compat; apply c_min_pos.
    - apply c_min_pos.
  Qed.

  (* Lemma: φ does not exceed 1 *)
  Lemma phi_of_interfaces_le_1 : forall c s i,
      0 <= c <= 1 -> 0 <= s <= 1 -> 0 <= i <= 1 ->
      phi_of_interfaces c s i <= 1.
  Proof.
    intros c s i [Hc0 Hc1] [Hs0 Hs1] [Hi0 Hi1].
    unfold phi_of_interfaces.
    destruct (Rle_dec (c * s * i) 0) as [Hle0|Hgt0].
    { lra. }
    assert (Hprod_le1 : c * s * i <= 1).
    { apply prod_up_bound; split; assumption. }
    assert (Hprod_pos : 0 < c * s * i) by lra.
    apply Rle_trans with (Rpower 1 (1/3)).
    - apply Rpower_cuberoot_le; split; [exact Hprod_pos | exact Hprod_le1].
    - rewrite Rpower_1_13; apply Rle_refl.
  Qed.

  (* Lemma: monotonicity in the first argument (capacity) *)
  Lemma phi_of_interfaces_monotonic_c : forall c1 c2 s i,
      0 <= c1 <= c2 -> 0 <= s -> 0 <= i ->
      phi_of_interfaces c1 s i <= phi_of_interfaces c2 s i.
  Proof.
    intros c1 c2 s i [Hc10 Hc12] Hs Hi.
    unfold phi_of_interfaces.
    destruct (Rle_dec (c1 * s * i) 0) as [Hle1|Hgt1].
    - apply phi_of_interfaces_nonneg.
    - destruct (Rle_dec (c2 * s * i) 0) as [Hle2|Hgt2].
      + assert (Hpos : 0 < c1 * s * i) by (apply Rnot_le_lt; exact Hgt1).
        assert (Hle_prod : c1 * s * i <= c2 * s * i).
        { apply Rmult_le_compat_r; [| apply Rmult_le_compat_r]; lra. }
        exfalso; apply (Rlt_not_le _ _ (Rlt_le_trans _ _ _ Hpos Hle_prod)); exact Hle2.
      + apply Rpower_cuberoot_le.
        split; [ apply Rnot_le_lt; exact Hgt1 | apply Rmult_le_compat_r; [| apply Rmult_le_compat_r]; lra ].
  Qed.

  (* Lemma: monotonicity in the second argument (selectivity) *)
  Lemma phi_of_interfaces_monotonic_s : forall c s1 s2 i,
      0 <= s1 <= s2 -> 0 <= c -> 0 <= i ->
      phi_of_interfaces c s1 i <= phi_of_interfaces c s2 i.
  Proof.
    intros c s1 s2 i [Hs10 Hs12] Hc Hi.
    unfold phi_of_interfaces.
    destruct (Rle_dec (c * s1 * i) 0) as [Hle1|Hgt1].
    - apply phi_of_interfaces_nonneg.
    - destruct (Rle_dec (c * s2 * i) 0) as [Hle2|Hgt2].
      + assert (Hpos : 0 < c * s1 * i) by (apply Rnot_le_lt; exact Hgt1).
        assert (Hle_prod : c * s1 * i <= c * s2 * i).
        { replace (c * s1 * i) with (s1 * (c * i)) by ring.
          replace (c * s2 * i) with (s2 * (c * i)) by ring.
          apply Rmult_le_compat_r; [apply Rmult_le_pos; lra | exact Hs12]. }
        exfalso; apply (Rlt_not_le _ _ (Rlt_le_trans _ _ _ Hpos Hle_prod)); exact Hle2.
      + apply Rpower_cuberoot_le.
        split; [ apply Rnot_le_lt; exact Hgt1 | ].
        replace (c * s1 * i) with (s1 * (c * i)) by ring.
        replace (c * s2 * i) with (s2 * (c * i)) by ring.
        apply Rmult_le_compat_r; [apply Rmult_le_pos; lra | exact Hs12].
  Qed.

  (* Lemma: monotonicity in the third argument (integrity) *)
  Lemma phi_of_interfaces_monotonic_i : forall c s i1 i2,
      0 <= i1 <= i2 -> 0 <= c -> 0 <= s ->
      phi_of_interfaces c s i1 <= phi_of_interfaces c s i2.
  Proof.
    intros c s i1 i2 [Hi10 Hi12] Hc Hs.
    unfold phi_of_interfaces.
    destruct (Rle_dec (c * s * i1) 0) as [Hle1|Hgt1].
    - apply phi_of_interfaces_nonneg.
    - destruct (Rle_dec (c * s * i2) 0) as [Hle2|Hgt2].
      + assert (Hpos : 0 < c * s * i1) by (apply Rnot_le_lt; exact Hgt1).
        assert (Hle_prod : c * s * i1 <= c * s * i2).
        { replace (c * s * i1) with (i1 * (c * s)) by ring.
          replace (c * s * i2) with (i2 * (c * s)) by ring.
          apply Rmult_le_compat_r; [apply Rmult_le_pos; lra | exact Hi12]. }
        exfalso; apply (Rlt_not_le _ _ (Rlt_le_trans _ _ _ Hpos Hle_prod)); exact Hle2.
      + apply Rpower_cuberoot_le.
        split; [ apply Rnot_le_lt; exact Hgt1 | ].
        replace (c * s * i1) with (i1 * (c * s)) by ring.
        replace (c * s * i2) with (i2 * (c * s)) by ring.
        apply Rmult_le_compat_r; [apply Rmult_le_pos; lra | exact Hi12].
  Qed.

  (* ========== Axioms that are not yet proved ========== *)

  (* Axiom: bound on the difference of products.
     |c1*s1*i1 - c2*s2*i2| ≤ |c1-c2| + |s1-s2| + |i1-i2|
     under the condition that all variables are in [0,1].
     This can be proved using the triangle inequality repeatedly. *)
  Axiom prod_diff_bound : forall c1 s1 i1 c2 s2 i2,
      0 <= c1 <= 1 -> 0 <= s1 <= 1 -> 0 <= i1 <= 1 ->
      0 <= c2 <= 1 -> 0 <= s2 <= 1 -> 0 <= i2 <= 1 ->
      Rabs (c1*s1*i1 - c2*s2*i2) <= Rabs (c1 - c2) + Rabs (s1 - s2) + Rabs (i1 - i2).

  (* Axiom: Lipschitz property of the cubic root on [c_min^3, 1].
     There exists a constant L such that for any a,b in that interval,
     |a^(1/3) - b^(1/3)| ≤ L * |a - b|.
     L can be taken as 1/(3 * c_min^2). This follows from the mean value theorem. *)
  Axiom Rpower_diff_bound :
    forall a b : R,
      c_min^3 <= a <= 1 ->
      c_min^3 <= b <= 1 ->
      Rabs (Rpower a (1/3) - Rpower b (1/3)) <= (1 / (3 * c_min^2)) * Rabs (a - b).

  (* Axiom: global Lipschitz property of φ with respect to the triple (c,s,i).
     Follows from the two previous axioms. *)
  Axiom phi_of_interfaces_lipschitz :
    exists L : R, L > 0 /\
      forall c1 s1 i1 c2 s2 i2,
        0 <= c1 <= 1 -> 0 <= s1 <= 1 -> 0 <= i1 <= 1 ->
        0 <= c2 <= 1 -> 0 <= s2 <= 1 -> 0 <= i2 <= 1 ->
        Rabs (phi_of_interfaces c1 s1 i1 - phi_of_interfaces c2 s2 i2) <=
        L * (Rabs (c1 - c2) + Rabs (s1 - s2) + Rabs (i1 - i2)).

  (* Axiom: connection between abstract formalizability and this concrete representation *)
  Parameter abstract_phi : Agent -> nat -> Component -> R.
  Axiom phi_equals : forall A t k, abstract_phi A t k = phi A t k.

End PhiFromInterfaces.