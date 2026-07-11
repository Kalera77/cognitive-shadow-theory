(* ==========================================================================
   Модуль: Theorem11_FORCED_REPORT_Safety.v
   ========================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.A20_MeasurementError.
Require Import CognitiveShadow.Expansion.PhiFromInterfaces.

Open Scope R_scope.

Section FORCED_REPORT_Safety.

  Inductive ProtocolState : Type :=
    | MONITORING
    | FR_ACTIVE
    | CONSCIOUS_LOCKED
    | UNCONSCIOUS
    | QUARANTINE
    | DEGRADED.

  Inductive BinarySign : Type :=
    | POSITIVE
    | NEGATIVE.

  Parameter signal_quality : R -> R.
  Parameter vote_count : BinarySign -> BinarySign -> BinarySign -> nat.
  Parameter diagnostic_rule : nat -> ProtocolState.

  Definition false_positive (phi_meas : R) (st : ProtocolState) : Prop :=
    st = CONSCIOUS_LOCKED.

  Axiom A11_theta_adj_filter :
    forall (phi_meas : R) (votes : nat),
      signal_quality phi_meas < QuarantineThreshold_Adjusted ->
      diagnostic_rule votes <> CONSCIOUS_LOCKED.

  Axiom A11_multimodal_safety :
    forall (phi_true : R) (b1 b2 b3 : BinarySign),
      phi_true < QuarantineThreshold ->
      (forall b : BinarySign, b = POSITIVE -> signal_quality phi_true >= QuarantineThreshold_Adjusted) ->
      diagnostic_rule (vote_count b1 b2 b3) <> CONSCIOUS_LOCKED.

  Axiom A11_auto_activation :
    forall (phi_meas : R),
      signal_quality phi_meas >= QuarantineThreshold_Adjusted ->
      exists votes : nat, INR votes >= 2.

  Axiom A11_theta_adj_equals_ln2_minus_eps :
    QuarantineThreshold_Adjusted = ln 2 - epsilon_phi.

  Lemma no_false_positive_low_quality :
    forall (phi_meas : R) (votes : nat),
      signal_quality phi_meas < QuarantineThreshold_Adjusted ->
      ~ false_positive phi_meas (diagnostic_rule votes).
  Proof.
    intros phi_meas votes Hq Hfp.
    unfold false_positive in Hfp.
    assert (Hneq : diagnostic_rule votes <> CONSCIOUS_LOCKED)
      by (apply (A11_theta_adj_filter phi_meas votes Hq)).
    elim Hneq; exact Hfp.
  Qed.

  Lemma auto_activation :
    forall (phi_meas : R),
      signal_quality phi_meas >= QuarantineThreshold_Adjusted ->
      exists votes : nat, INR votes >= 2.
  Proof.
    intros phi_meas Hq.
    destruct (A11_auto_activation phi_meas Hq) as [v Hv].
    exists v; exact Hv.
  Qed.

Theorem FORCED_REPORT_Safety :
  (QuarantineThreshold_Adjusted = ln 2 - epsilon_phi) /\
  (forall (phi_meas : R) (votes : nat),
    signal_quality phi_meas < QuarantineThreshold_Adjusted ->
    ~ false_positive phi_meas (diagnostic_rule votes)) /\
  (forall (phi_meas : R),
    signal_quality phi_meas >= QuarantineThreshold_Adjusted ->
    exists votes : nat, INR votes >= 2).
Proof.
  split.
  - apply A11_theta_adj_equals_ln2_minus_eps.
  - split.
    + intros phi_meas votes Hq.
      apply (no_false_positive_low_quality phi_meas votes Hq).
    + intros phi_meas Hq.
      apply (auto_activation phi_meas Hq).
Qed.

End FORCED_REPORT_Safety.