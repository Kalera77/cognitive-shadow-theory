(** * A20_MeasurementError.v – accounting for measurement errors in phi comparison *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lra.
Open Scope R_scope.

Section A20_MeasurementError.
  Context {Component : Type}.
  Context (phi_true phi_measured : Component -> R).

  (* Measurement error bound *)
  Parameter epsilon_phi : R.
  Axiom epsilon_phi_pos : epsilon_phi > 0.

  (* Axiom A20: absolute error between measured and true phi is bounded by epsilon_phi *)
  Axiom A20_error_bound : forall k, Rabs (phi_measured k - phi_true k) <= epsilon_phi.

  Definition QuarantineThreshold : R := 0.5.
  Definition QuarantineThreshold_Adjusted : R := QuarantineThreshold - epsilon_phi.

  Parameter IsQuarantined : Component -> Prop.

  (* Axiom A15_star: if measured phi ≤ adjusted threshold, component is quarantined *)
  Axiom A15_star_quarantine : forall k, phi_measured k <= QuarantineThreshold_Adjusted -> IsQuarantined k.

  (* Lemma: safe trigger for quarantine using true phi *)
  Lemma safe_quarantine_trigger : forall k, phi_true k <= QuarantineThreshold_Adjusted - epsilon_phi -> IsQuarantined k.
  Proof.
    intros k H_true. apply A15_star_quarantine.
    pose proof (A20_error_bound k) as H_abs.
    (* From |x| ≤ e we deduce x ≤ e *)
    assert (H_upper : phi_measured k - phi_true k <= epsilon_phi).
    { apply Rle_trans with (Rabs (phi_measured k - phi_true k)).
      - apply Rle_abs.
      - exact H_abs. }
    lra.
  Qed.
End A20_MeasurementError.