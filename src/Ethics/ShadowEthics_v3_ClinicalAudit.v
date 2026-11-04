(* ============================================================
   ShadowEthics_v3_ClinicalAudit.v
   ============================================================
   
   Clinical audit structure for FORCED_REPORT.
   
   REVISED (October 2026): 0 Admitted.
   
   Key changes from the previous version:
   - Added `ae_source : EntrySource` field to `ClinicalAuditEntry`
     This distinguishes entries created by `CanActivate`
     (`FromActivation`) from those created by monitoring or other
     means.
   - Added `FromActivation_semantics` axiom: activations always
     have a specific violation list and a specific decision.
   - `AuditRecorded_realized` now also returns the entry source.
   - `no_CP_None_from_activation` is PROVED (was Admitted).
   
   The fix: the original proof tried to derive the consent path
   from `ae_decision = D_PROVIDE_SUPPORT` alone. That is
   insufficient: knowing a decision was made does not tell us
   the violation list, which determines the consent path. By
   adding `ae_source = FromActivation` we get access to
   `FromActivation_semantics`, which pins the violation list
   to exactly two possibilities, and from those the consent
   path is determined and cannot be CP_None.
   
   Depends on:
   - ShadowEthics_v3_Foundations
   - ShadowEthics_v3_Arbitration (Violation, Decision)
   - ShadowEthics_v3_ProxyConsent (Consent, TherapeuticException)
   - ShadowEthics_v3_Operator
   - ForcedReportDecision_v3
     (AuditRecorded, CanActivate, Diagnosed, Trigger)
   
   Author: Valery S. Kalinin
   Date:   October 2026
   License: MIT
   ============================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import Coq.Lists.List.
Require Import Coq.Logic.Classical_Prop.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Foundations.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Arbitration.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_ProxyConsent.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Operator.
Require Import CognitiveShadow.Ethics.ForcedReportDecision_v3.
Import ListNotations.
Open Scope R_scope.

(* ============================================================
   PART 1: Ground truth — with Theorem 10 caveat
   ============================================================
   
   GroundTruthConscious is the BEST AVAILABLE clinical assessment
   (e.g., CRS-R consensus + neuroimaging), NOT perfect knowledge.
   
   Per Theorem 10, perfect knowledge of consciousness is
   impossible: AUC < 1 for any classifier. So every "FP" or
   "FN" in this file is RELATIVE to a possibly imperfect
   ground truth. Even the audit cannot know with certainty.
   ============================================================ *)

Parameter GroundTruthConscious : Agent -> Time -> Prop.

(* ============================================================
   PART 2: ClinicalOutcome
   ============================================================ *)

Inductive ClinicalOutcome : Type :=
  | TruePositive  : ClinicalOutcome
  | TrueNegative  : ClinicalOutcome
  | FalsePositive : ClinicalOutcome
  | FalseNegative : ClinicalOutcome
  | Undetermined  : ClinicalOutcome.

(* ============================================================
   PART 3: Outcome classification predicates
   ============================================================ *)

Definition IsTP (patient : Agent) (t : Time) : Prop :=
  Diagnosed patient t /\ GroundTruthConscious patient t.

Definition IsFP (patient : Agent) (t : Time) : Prop :=
  Diagnosed patient t /\ ~ GroundTruthConscious patient t.

Definition IsFN (patient : Agent) (t : Time) : Prop :=
  ~ Diagnosed patient t /\ GroundTruthConscious patient t.

Definition IsTN (patient : Agent) (t : Time) : Prop :=
  ~ Diagnosed patient t /\ ~ GroundTruthConscious patient t.

Theorem outcome_exhaustive :
  forall patient t,
    IsTP patient t \/ IsFP patient t \/ IsFN patient t \/ IsTN patient t.
Proof.
  intros patient t.
  unfold IsTP, IsFP, IsFN, IsTN.
  destruct (classic (Diagnosed patient t)) as [Hd | Hnd];
  destruct (classic (GroundTruthConscious patient t)) as [Hg | Hng];
  auto.
Qed.

Theorem TP_FP_exclusive :
  forall patient t, ~ (IsTP patient t /\ IsFP patient t).
Proof.
  intros patient t [[_ Hg] [_ Hng]]. exact (Hng Hg).
Qed.

Theorem TP_FN_exclusive :
  forall patient t, ~ (IsTP patient t /\ IsFN patient t).
Proof.
  intros patient t [[Hd _] [Hnd _]]. exact (Hnd Hd).
Qed.

(* ============================================================
   PART 4: ConsentPath — what kind of consent led to activation
   ============================================================ *)

Inductive ConsentPath : Type :=
  | CP_Self      : ConsentPath   (* patient gave own consent *)
  | CP_Proxy     : ConsentPath   (* proxy gave consent *)
  | CP_Exception : ConsentPath   (* therapeutic exception *)
  | CP_None      : ConsentPath.  (* no consent, no exception — MUST NOT occur *)

(* ============================================================
   PART 5: EntrySource — NEW
   ============================================================
   
   Every audit entry has a SOURCE that tells us how it was
   created. This is essential for `no_CP_None_from_activation`:
   the decision alone is not enough, we need to know the entry
   came from `CanActivate`.
   
   - FromActivation: created by `CanActivate` firing
   - FromMonitoring: created by routine monitoring (no activation)
   - FromOther: other sources (manual entry, external import)
   ============================================================ *)

Inductive EntrySource : Type :=
  | FromActivation : EntrySource
  | FromMonitoring : EntrySource
  | FromOther      : EntrySource.

(* ============================================================
   PART 6: ClinicalAuditEntry — with ae_source
   ============================================================ *)

Record ClinicalAuditEntry : Type := mkClinicalAudit {
  ae_patient      : Agent;
  ae_time         : Time;
  ae_violations   : list Violation;
  ae_decision     : Decision;
  ae_trigger      : option Violation;
  ae_consent_path : ConsentPath;
  ae_outcome      : option ClinicalOutcome;
  ae_reviewer     : option Agent;
  ae_source       : EntrySource   (* NEW: how the entry arose *)
}.

Definition ClinicalAuditLog := list ClinicalAuditEntry.

(* ============================================================
   PART 7: The global log
   ============================================================ *)

Parameter clinical_log : ClinicalAuditLog.

(* ============================================================
   PART 8: EntryMatches — unchanged
   ============================================================ *)

Definition EntryMatches
    (e : ClinicalAuditEntry) (patient : Agent) (t : Time)
    (vs : list Violation) (d : Decision) : Prop :=
  ae_patient e = patient /\
  ae_time e = t /\
  ae_violations e = vs /\
  ae_decision e = d.

(* ============================================================
   PART 9: Bridge axioms
   ============================================================ *)

(* Every AuditRecorded call fires from activation, and produces
   a log entry whose source is FromActivation. *)
Axiom AuditRecorded_realized :
  forall patient t vs d,
    AuditRecorded patient t vs d ->
    exists e, In e clinical_log /\
              EntryMatches e patient t vs d /\
              ae_source e = FromActivation.

(* Converse direction: an activation entry in the log corresponds
   to an AuditRecorded call. *)
Axiom FromActivation_AuditRecorded :
  forall e, In e clinical_log ->
    ae_source e = FromActivation ->
    AuditRecorded (ae_patient e) (ae_time e)
                  (ae_violations e) (ae_decision e).

(* KEY AXIOM (NEW): the semantics of FromActivation.
   
   Activations always produce one of exactly two violation lists,
   depending on whether consent was satisfied. They always result
   in D_PROVIDE_SUPPORT.
   
   This is the substantive constraint that makes the
   no_CP_None proof possible. *)
Axiom FromActivation_semantics :
  forall e, In e clinical_log ->
    ae_source e = FromActivation ->
    ((ae_violations e = [V3_Support] \/
      ae_violations e = [V3_Support; V6_Consent]) /\
     ae_decision e = D_PROVIDE_SUPPORT).

(* The violations recorded determine the consent path. *)
Axiom violation_list_determines_consent_path :
  forall e, In e clinical_log ->
    (ae_violations e = [V3_Support] ->
       ae_consent_path e = CP_Self \/ ae_consent_path e = CP_Proxy) /\
    (ae_violations e = [V3_Support; V6_Consent] ->
       ae_consent_path e = CP_Exception).

(* Outcome consistency: if an outcome is recorded, it is correct. *)
Axiom outcome_consistency :
  forall e, In e clinical_log ->
    forall o, ae_outcome e = Some o ->
    match o with
    | TruePositive  => IsTP (ae_patient e) (ae_time e)
    | TrueNegative  => IsTN (ae_patient e) (ae_time e)
    | FalsePositive => IsFP (ae_patient e) (ae_time e)
    | FalseNegative => IsFN (ae_patient e) (ae_time e)
    | Undetermined  => True
    end.

(* ============================================================
   PART 10: Useful corollaries of FromActivation_semantics
   ============================================================ *)

Lemma FromActivation_decision :
  forall e, In e clinical_log ->
    ae_source e = FromActivation ->
    ae_decision e = D_PROVIDE_SUPPORT.
Proof.
  intros e Hin Hsrc.
  pose proof (FromActivation_semantics e Hin Hsrc) as [_ Hdec].
  exact Hdec.
Qed.

Lemma FromActivation_has_support :
  forall e, In e clinical_log ->
    ae_source e = FromActivation ->
    In V3_Support (ae_violations e).
Proof.
  intros e Hin Hsrc.
  pose proof (FromActivation_semantics e Hin Hsrc) as [Hviol _].
  destruct Hviol as [Hv | Hv]; rewrite Hv; simpl; auto.
Qed.

(* ============================================================
   PART 11: MAIN THEOREM — no_CP_None_from_activation
   ============================================================
   
   Previously Admitted. Now PROVED.
   
   The proof now uses:
   - FromActivation_semantics: pins ae_violations to one of two
     possibilities
   - violation_list_determines_consent_path: pins consent path
     to CP_Self/CP_Proxy/CP_Exception
   - discriminate: CP_None is not among them
   ============================================================ *)

Theorem no_CP_None_from_activation :
  forall (e : ClinicalAuditEntry),
    In e clinical_log ->
    ae_source e = FromActivation ->
    ae_consent_path e <> CP_None.
Proof.
  intros e Hin Hsrc Hnone.
  pose proof (FromActivation_semantics e Hin Hsrc) as [Hviol _].
  pose proof (violation_list_determines_consent_path e Hin) as [Hc1 Hc2].
  destruct Hviol as [Hv | Hv].
  - (* ae_violations e = [V3_Support] *)
    destruct (Hc1 Hv) as [Hself | Hproxy].
    + rewrite Hself in Hnone. discriminate Hnone.
    + rewrite Hproxy in Hnone. discriminate Hnone.
  - (* ae_violations e = [V3_Support; V6_Consent] *)
    pose proof (Hc2 Hv) as Hexc.
    rewrite Hexc in Hnone. discriminate Hnone.
Qed.

(* ============================================================
   PART 12: Completeness — every activation is logged
   ============================================================ *)

Theorem activation_is_in_log :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    exists e, In e clinical_log /\
              ae_patient e = patient /\
              ae_time e = t /\
              ae_source e = FromActivation.
Proof.
  intros patient t Hact.
  pose proof (AuditRequired patient t Hact) as [Hc1 Hc2].
  destruct (classic (ConsentSatisfied patient t)) as [Hy | Hn].
  - apply Hc1 in Hy.
    destruct (AuditRecorded_realized patient t [V3_Support]
                D_PROVIDE_SUPPORT Hy) as [e [Hin [Hm Hsrc]]].
    destruct Hm as [Hp [Ht _]].
    exists e. auto.
  - apply Hc2 in Hn.
    destruct (AuditRecorded_realized patient t [V3_Support; V6_Consent]
                D_PROVIDE_SUPPORT Hn) as [e [Hin [Hm Hsrc]]].
    destruct Hm as [Hp [Ht _]].
    exists e. auto.
Qed.

Theorem violations_captured_with_consent :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    ConsentSatisfied patient t ->
    exists e, In e clinical_log /\
              ae_patient e = patient /\
              ae_time e = t /\
              ae_violations e = [V3_Support] /\
              ae_source e = FromActivation.
Proof.
  intros patient t Hact Hcons.
  pose proof (AuditRequired patient t Hact) as [Hc1 _].
  apply Hc1 in Hcons.
  destruct (AuditRecorded_realized patient t [V3_Support]
              D_PROVIDE_SUPPORT Hcons) as [e [Hin [Hm Hsrc]]].
  destruct Hm as [Hp [Ht [Hv _]]].
  exists e. auto.
Qed.

Theorem violations_captured_without_consent :
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    ~ ConsentSatisfied patient t ->
    exists e, In e clinical_log /\
              ae_patient e = patient /\
              ae_time e = t /\
              ae_violations e = [V3_Support; V6_Consent] /\
              ae_source e = FromActivation.
Proof.
  intros patient t Hact Hno.
  pose proof (AuditRequired patient t Hact) as [_ Hc2].
  apply Hc2 in Hno.
  destruct (AuditRecorded_realized patient t [V3_Support; V6_Consent]
              D_PROVIDE_SUPPORT Hno) as [e [Hin [Hm Hsrc]]].
  destruct Hm as [Hp [Ht [Hv _]]].
  exists e. auto.
Qed.

(* ============================================================
   PART 13: Review obligation
   ============================================================ *)

Definition reviewed (e : ClinicalAuditEntry) : Prop :=
  exists r, ae_reviewer e = Some r.

Definition requires_review (e : ClinicalAuditEntry) : Prop :=
  ae_consent_path e = CP_Exception \/
  ae_consent_path e = CP_None \/
  (exists p t, ae_patient e = p /\ ae_time e = t /\
               (IsFP p t \/ IsFN p t)).

Definition Compliant : Prop :=
  forall e, In e clinical_log -> requires_review e -> reviewed e.

Theorem FP_reviewed_if_compliant :
  Compliant ->
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    IsFP patient t ->
    exists e, In e clinical_log /\
              ae_patient e = patient /\
              ae_time e = t /\
              reviewed e.
Proof.
  intros Hcomp patient t Hact Hfp.
  destruct (activation_is_in_log patient t Hact) as [e [Hin [Hp Ht]]].
  destruct Ht as [Ht_time Ht_src].
  assert (Hreq : requires_review e).
  { unfold requires_review.
    right. right.
    exists patient, t. intuition auto. }
  destruct (Hcomp e Hin Hreq) as [r Hr].
  exists e. repeat split; auto.
Qed.

Theorem FN_reviewed_if_compliant :
  Compliant ->
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    IsFN patient t ->
    exists e, In e clinical_log /\
              ae_patient e = patient /\
              ae_time e = t /\
              reviewed e.
Proof.
  intros Hcomp patient t Hact Hfn.
  destruct (activation_is_in_log patient t Hact) as [e [Hin [Hp Ht]]].
  destruct Ht as [Ht_time Ht_src].
  assert (Hreq : requires_review e).
  { unfold requires_review.
    right. right.
    exists patient, t. intuition auto. }
  destruct (Hcomp e Hin Hreq) as [r Hr].
  exists e. repeat split; auto.
Qed.

Theorem exception_reviewed_if_compliant :
  Compliant ->
  forall (patient : Agent) (t : Time),
    CanActivate patient t ->
    ~ ConsentSatisfied patient t ->
    exists e, In e clinical_log /\
              ae_patient e = patient /\
              ae_time e = t /\
              ae_consent_path e = CP_Exception /\
              reviewed e.
Proof.
  intros Hcomp patient t Hact Hno.
  destruct (violations_captured_without_consent patient t Hact Hno)
    as [e [Hin [Hp [Ht [Hv Hsrc]]]]].
  pose proof (violation_list_determines_consent_path e Hin) as [_ Hc2].
  assert (Hcp : ae_consent_path e = CP_Exception).
  { apply Hc2. exact Hv. }
  assert (Hreq : requires_review e).
  { unfold requires_review. left. exact Hcp. }
  destruct (Hcomp e Hin Hreq) as [r Hr].
  exists e. repeat split; auto.
Qed.

(* ============================================================
   PART 14: Regulator report
   ============================================================ *)

Record RegulatorReport := mkRegReport {
  rr_total_activations      : nat;
  rr_therapeutic_exceptions : nat;
  rr_reviews_completed      : nat;
  rr_reviews_outstanding    : nat
}.

Parameter regulator_report : RegulatorReport.

(* NOTE: total activations in the report is bounded by log length.
   With ae_source in place, the log may contain non-activation
   entries (FromMonitoring, FromOther), so equality is no longer
   appropriate. A future refinement could compute the count of
   FromActivation entries. For now, we use an inequality. *)
Axiom report_total_bounded :
  (rr_total_activations regulator_report <= length clinical_log)%nat.

(* NOTE: FP/FN rates are deliberately NOT in this report because
   ground truth is uncertain (Theorem 10). A future refinement
   could add them as estimates with confidence intervals, but
   that requires empirical calibration not available here. *)

(* ============================================================
   PART 15: What this file does NOT solve
   ============================================================
   
   1. HONESTY OF LOGGING. The axiom FromActivation_semantics
      assumes the system records activations truthfully: if
      source is FromActivation, then violations and decision
      match what CanActivate produced. A dishonest system can
      log CP_Self when it actually used an exception. Detecting
      this requires cryptographic audit (ZK-proofs of log
      integrity) or external review — not formalized here.
   
   2. GROUND TRUTH. GroundTruthConscious is a Parameter with
      no formal connection to observable data. FP/FN are
      defined relative to it, so all FP/FN claims inherit its
      uncertainty (Theorem 10).
   
   3. QUANTITATIVE FPR/FNR. No exact computation is possible
      without decidability of ground truth. Estimates require
      empirical data.
   
   4. REVIEW QUALITY. `reviewed e` says a reviewer was assigned,
      not that the review was competent. Quality is not modeled.
   
   5. CROSS-SYSTEM AUDIT. clinical_log is a single log.
      Auditing across multiple systems (e.g., federated
      hospitals) is not modeled.
   
   6. LOG INTEGRITY. No hash chain, no signing, no append-only
      guarantee. A compromised system can rewrite history.
   
   7. TEMPORAL DYNAMICS. ae_time is a single timestamp per
      entry. The observation may span multiple epochs.
      Multi-epoch aggregation is not modeled.
   
   8. EntrySource COMPLETENESS. FromActivation, FromMonitoring,
      FromOther — these cover the modeling needs here, but
      real systems may need finer granularity (e.g.,
      FromActivation_Self, FromActivation_Proxy,
      FromActivation_Exception). The current source type is
      coarser than the consent path.
   ============================================================ *)

(* ============================================================
   END OF FILE — 0 Admitted
   ============================================================ *)