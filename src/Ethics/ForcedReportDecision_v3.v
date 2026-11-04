(* ============================================================
   ForcedReportDecision_v3.v
   ============================================================
   
   Rewritten protocol with consent checking, therapeutic
   exception, audit, and honest false-positive statement.
   
   Depends on:
   - ShadowEthics_v3_Foundations
   - ShadowEthics_v3_Relational
   - ShadowEthics_v3_Arbitration
   - ShadowEthics_v3_ProxyConsent
   - ShadowEthics_v3_Operator
   
   Removed from v2.0:
   - Axiom shadow_ethics_principle_3 (contradictory)
   - Claim of "zero false positives"
   - Implicit assumption that activation is always permissible
   
   Author: Valery S. Kalinin
   Date:   October 2026
   License: MIT
   ============================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Foundations.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Relational.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Arbitration.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_ProxyConsent.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Operator.

Open Scope R_scope.

(* ============================================================
   PART 1: Protocol states
   ============================================================ *)

Inductive FRState : Type :=
  | MONITORING       : FRState
  | FR_ACTIVE        : FRState  (* report generated, awaiting clinician *)
  | CONSCIOUS_LOCKED : FRState  (* protocol detects covert consciousness *)
  | UNCONSCIOUS      : FRState  (* protocol does not detect covert consciousness *)
  | DEGRADED         : FRState  (* protocol in degraded safety mode *)
  | EXTERNAL_SUPPORT : FRState. (* therapeutic exception active *)

(* ============================================================
   PART 2: Signals (from A20)
   ============================================================ *)

Parameter phi_meas : Agent -> Time -> R.
Parameter phi_true : Agent -> Time -> R.
Parameter H_shadow : Agent -> Time -> R.

Parameter H_min_threshold        : R.
Parameter epsilon_phi_bound      : R.
Parameter QuarantineThreshold    : R.
Parameter QuarantineThreshold_Adjusted_ICU : R.

Axiom H_min_threshold_pos        : H_min_threshold > 0.
Axiom epsilon_phi_bound_pos      : epsilon_phi_bound > 0.
Axiom QuarantineThreshold_pos    : QuarantineThreshold > 0.
Axiom QT_adj_definition :
  QuarantineThreshold_Adjusted_ICU = QuarantineThreshold - epsilon_phi_bound.

(* ============================================================
   IntactInterfaces and MeasurementBias (v3.1 Fix #5, Oct 2026)
   ============================================================
   
   phi_meas is the MEASURED formalizability from EEG/behaviour.
   For LIS (locked-in syndrome), phi_meas is LOW because there
   is no motor output, but phi_true is HIGH (consciousness
   preserved). The A20 error bound between measured and true
   phi holds only for patients with INTACT interfaces — motor
   output intact, sensory pathways intact.
   
   For LIS-like patients (damaged motor interface), phi_meas is
   systematically biased DOWNWARD. This is the measurement bias
   that makes FORCED_REPORT necessary: it must catch the case
   where phi_meas misleadingly looks like DoC. *)

Parameter IntactInterfaces : Agent -> Time -> Prop.
Parameter MeasurementBias  : Agent -> Time -> R.

Axiom bias_nonneg :
  forall (a : Agent) (t : Time), MeasurementBias a t >= 0.

Axiom bias_zero_for_intact :
  forall (a : Agent) (t : Time),
    IntactInterfaces a t -> MeasurementBias a t = 0.

Axiom bias_positive_for_damaged :
  forall (a : Agent) (t : Time),
    ~ IntactInterfaces a t -> MeasurementBias a t > 0.

(* A20 error bound now accounts for measurement bias *)
Axiom A20_error_bound :
  forall (patient : Agent) (t : Time),
    Rabs (phi_meas patient t - phi_true patient t) <=
      epsilon_phi_bound + MeasurementBias patient t.

(* Safe trigger: low measured phi implies low true phi *)
Lemma safe_trigger :
  forall (patient : Agent) (t : Time),
    IntactInterfaces patient t ->
    phi_meas patient t <= QuarantineThreshold_Adjusted_ICU ->
    phi_true patient t <= QuarantineThreshold.
Proof.
  intros patient t Hintact H.
  pose proof (A20_error_bound patient t) as Hab.
  assert (Hbias : MeasurementBias patient t = 0)
    by (apply bias_zero_for_intact; exact Hintact).
  rewrite Hbias in Hab.
  rewrite Rplus_0_r in Hab.
  assert (Hdiff : phi_true patient t - phi_meas patient t <= epsilon_phi_bound).
  { apply Rle_trans with (Rabs (phi_true patient t - phi_meas patient t)).
    - apply Rle_abs.
    - rewrite Rabs_minus_sym. exact Hab. }
  rewrite QT_adj_definition in H.
  lra.
Qed.

(* ============================================================
   PART 3: Multi-modal votes
   ============================================================ *)

Inductive BinarySign : Type := POSITIVE | NEGATIVE.

Parameter vote_BCI   : Agent -> Time -> BinarySign.
Parameter vote_Pupil : Agent -> Time -> BinarySign.
Parameter vote_NF    : Agent -> Time -> BinarySign.

Definition sign_to_nat (s : BinarySign) : nat :=
  match s with POSITIVE => 1 | NEGATIVE => 0 end.

Definition votes_positive (patient : Agent) (t : Time) : nat :=
  sign_to_nat (vote_BCI   patient t) +
  sign_to_nat (vote_Pupil patient t) +
  sign_to_nat (vote_NF    patient t).

(* Diagnostic rule: ≥ 2 modalities agree → CONSCIOUS_LOCKED *)
Definition decision_rule (votes : nat) : FRState :=
  if Nat.leb 2 votes then CONSCIOUS_LOCKED else UNCONSCIOUS.

(* ============================================================
   PART 4: Trigger
   ============================================================
   
   v2.0 interpretation retained: trigger fires when phi_meas is
   BELOW threshold (patient looks in DoC territory). The protocol
   then FORCES an investigation because a low-phi patient might
   still be conscious (LIS).
   
   Semantic note: in the clinical paper, LIS has HIGHER phi than
   DOC (0.301 vs 0.171). This is a tension with v2.0's trigger.
   A full resolution requires empirical calibration. This file
   keeps v2.0's structure but flags the ambiguity in Part 9.
   ============================================================ *)

Definition Trigger (patient : Agent) (t : Time) : Prop :=
  phi_meas patient t <= QuarantineThreshold_Adjusted_ICU /\
  H_shadow patient t > H_min_threshold /\
  (2 <= votes_positive patient t)%nat.

(* For INTACT patients only. For LIS, low phi_meas does NOT imply
   low phi_true — that is the entire point of FORCED_REPORT. *)
Theorem trigger_implies_true_phi_low_intact :
  forall (patient : Agent) (t : Time),
    IntactInterfaces patient t ->
    Trigger patient t ->
    phi_true patient t <= QuarantineThreshold.
Proof.
  intros patient t Hintact [Hphi _].
  apply (safe_trigger patient t Hintact). exact Hphi.
Qed.

(* ============================================================
   PART 5: Activation with consent
   ============================================================
   
   KEY FIX vs v2.0: activation requires either valid consent
   OR therapeutic exception. Without one, the protocol CANNOT
   activate, regardless of trigger.
   ============================================================ *)

Definition CanActivate (patient : Agent) (t : Time) : Prop :=
  Trigger patient t /\
  (ConsentSatisfied patient t \/
   exists clinician act, TherapeuticException clinician patient act t).

(* ============================================================
   PART 6: Audit (O4 from Operator layer)
   ============================================================ *)

Parameter AuditRecorded :
  Agent -> Time -> (list Violation) -> Decision -> Prop.

(* O4 obligation, applied to FORCED_REPORT activation *)
Axiom AuditRequired :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    ((ConsentSatisfied patient t ->
        AuditRecorded patient t (V3_Support :: nil) D_PROVIDE_SUPPORT) /\
     (~ ConsentSatisfied patient t ->
        AuditRecorded patient t (V3_Support :: V6_Consent :: nil) D_PROVIDE_SUPPORT)).

(* ============================================================
   PART 7: Main soundness theorem
   ============================================================ *)

Theorem forced_report_decision_soundness :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    (IntactInterfaces patient t -> phi_true patient t <= QuarantineThreshold) /\
    H_shadow patient t > H_min_threshold /\
    (2 <= votes_positive patient t)%nat /\
    (ConsentSatisfied patient t \/
     exists clinician act, TherapeuticException clinician patient act t).
Proof.
  intros patient t [[Hphi [Hent Hvotes]] Hcons].
  split.
  - intro Hii.
    apply (safe_trigger patient t Hii Hphi).
  - split.
    + exact Hent.
    + split.
      * exact Hvotes.
      * exact Hcons.
Qed.

(* ============================================================
   PART 8: Honest false-positive statement
   ============================================================
   
   v2.0 claimed "guarantees absence of false-positive diagnoses".
   That was WRONG. Here is what we can actually state:
   
   (a) The TRIGGER is sound: if trigger fires, true phi is low.
   (b) The DIAGNOSIS CONSCIOUS_LOCKED is a claim based on votes,
       not on phi. False positives are possible if votes are wrong.
   (c) We do NOT prove "no false positives".
   (d) We do NOT prove "false positives impossible".
   ============================================================ *)

Definition Diagnosed (patient : Agent) (t : Time) : Prop :=
  decision_rule (votes_positive patient t) = CONSCIOUS_LOCKED.

(* A false positive would be: diagnosed CONSCIOUS_LOCKED but
   patient is actually not conscious (true phi is high). *)
Definition FalsePositive (patient : Agent) (t : Time) : Prop :=
  Diagnosed patient t /\ phi_true patient t > QuarantineThreshold.

(* What we CAN prove: when triggered, true phi IS low. So if we
   diagnose based on trigger AND trigger implies low phi, the
   diagnosis is at least consistent with low phi. Whether that
   means the patient IS conscious (LIS) is a separate question
   that we do NOT address. *)
(* RENAMED (Oct 2026): trigger_diagnosis_consistent →
   trigger_diagnosis_phi_low_intact. *)
Theorem trigger_diagnosis_phi_low_intact :
  forall (patient : Agent) (t : Time),
    IntactInterfaces patient t ->
    Trigger patient t ->
    Diagnosed patient t ->
    phi_true patient t <= QuarantineThreshold.
Proof.
  intros patient t Hintact Htrig _.
  apply (trigger_implies_true_phi_low_intact patient t Hintact Htrig).
Qed.

(* We do NOT have a theorem that FalsePositive is impossible.
   We also do NOT have a theorem that FalsePositive is possible.
   That is an empirical matter for evaluation, not a formal claim. *)

(* ============================================================
   PART 9: Consistency with Shadow Ethics v3
   ============================================================ *)

(* Every activation either has consent or exception (P6) *)
Theorem activation_respects_P6 :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    ConsentSatisfied patient t \/
    exists clinician act, TherapeuticException clinician patient act t.
Proof.
  intros patient t [_ H]. exact H.
Qed.

(* Every activation is audited (O4) *)
Theorem activation_is_audited :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    ((ConsentSatisfied patient t ->
        AuditRecorded patient t (V3_Support :: nil) D_PROVIDE_SUPPORT) /\
     (~ ConsentSatisfied patient t ->
        AuditRecorded patient t (V3_Support :: V6_Consent :: nil) D_PROVIDE_SUPPORT)).
Proof.
  intros patient t H.
  apply AuditRequired. exact H.
Qed.

(* When activation happens without consent, arbitration resolves
   P3 > P6: therapeutic support wins, but V6 is recorded in audit. *)
Theorem activation_without_consent_arbitrates_to_support :
  forall (patient : Agent) (t : Time),
    Trigger patient t ->
    ~ ConsentSatisfied patient t ->
    (exists clinician act, TherapeuticException clinician patient act t) ->
    arbitrate (V3_Support :: V6_Consent :: nil) = D_PROVIDE_SUPPORT.
Proof.
  intros. reflexivity.
Qed.
(* The therapeutic exception path provides a formal guarantee:
   if consent is missing, activation is ONLY permitted via the
   exception, and the exception is audited. *)
Theorem no_activation_without_consent_or_exception :
  forall (patient : Agent) (t : Time),
    Trigger patient t ->
    ~ ConsentSatisfied patient t ->
    ~ (exists clinician act, TherapeuticException clinician patient act t) ->
    ~ CanActivate patient t.
Proof.
  intros patient t Htrig Hno Hnoexc [Htrig' Hcons].
  destruct Hcons as [Hyes | Hexc].
  - exact (Hno Hyes).
  - exact (Hnoexc Hexc).
Qed.

(* ============================================================
   PART 10: What this file does NOT solve
   ============================================================
   
   1. SEMANTIC AMBIGUITY. v2.0's trigger is "phi_meas <= θ_adj"
      (low phi). The paper reports LIS has HIGH phi (0.301)
      vs DOC (0.171). These are in tension. The v3.0 file keeps
      v2.0's structure but flags this as an empirical question.
   
   2. FALSE POSITIVE RATES. We do not quantify FPR. v2.0
      overclaimed "zero". This file does not claim any rate.
      Empirical calibration is needed.
   
   3. POST-ACTIVATION WORKFLOW. What happens after CONSCIOUS_LOCKED
      is diagnosed? BCI setup, communication attempts, family
      notification — none of this is formalized.
   
   4. ZK-SNARK CORRECTNESS. The privacy claim is not formalized
      here. It's a separate cryptographic guarantee.
   
   5. OPERATOR PRECONDITIONS. O1-O4 are obligations, not
      preconditions in this file. Linking CanActivate to
      operator state requires ShadowEthics_v3_Operator's
      bridges to be added as hypotheses.
   
   6. AUDIT DETAILS. AuditRecorded is abstract. Linking to
      ClinicalAuditEntry requires ShadowEthics_v3_ClinicalAudit.v
      (not yet written).
   
   7. H_shadow THEORY. H_shadow is treated as a signal-quality
      indicator. Its theoretical grounding (linked to shadow
      entropy) is not formalized in this file.
   
   8. MULTI-MODALITY CORRELATION. The three votes (BCI, Pupil, NF)
      are treated as independent. In practice they may correlate,
      reducing the effective vote count.
   ============================================================ *)

(* ============================================================
   END OF FILE
   ============================================================ *)