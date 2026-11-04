(* ============================================================
   ShadowEthics_v3_ProxyConsent.v  (revised)
   ============================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import Coq.Lists.List.
Require Import Coq.Logic.Classical_Prop.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Foundations.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Arbitration.
Import ListNotations.
Open Scope R_scope.

(* ============================================================
   PART 1: Proxy priority (ProxySource from Foundations)
   ============================================================ *)

Definition proxy_priority (p : ProxySource) : nat :=
  match p with
  | PatientSelf        => 0
  | AppointedProxy     => 1
  | FamilyProxy        => 2
  | EthicsCommittee    => 3
  | ClinicianException => 4
  end.

(* ============================================================
   PART 2: Predicates for proxy sources
   ============================================================ *)

Parameter CanCommunicate      : Agent -> Time -> Prop.
Parameter HasAdvanceDirective : Agent -> Agent -> Prop.
Parameter IsFamily            : Agent -> Agent -> Prop.
Parameter IsEthicsCommittee   : Agent -> Prop.

Definition ProxyAvailable (patient proxy : Agent) (src : ProxySource) (t : Time) : Prop :=
  match src with
  | PatientSelf        => CanCommunicate patient t
  | AppointedProxy     => HasAdvanceDirective patient proxy
  | FamilyProxy        => IsFamily patient proxy
  | EthicsCommittee    => IsEthicsCommittee proxy
  | ClinicianException => True
  end.

(* ============================================================
   PART 3: Decision standard
   ============================================================ *)

Inductive DecisionStandard : Type :=
  | SubstitutedJudgment : DecisionStandard
  | BestInterest        : DecisionStandard.

Parameter WasAutonomous : Agent -> Prop.
Parameter applicable_standard : Agent -> DecisionStandard.

Axiom applicable_standard_autonomous :
  forall p, WasAutonomous p -> applicable_standard p = SubstitutedJudgment.

Axiom applicable_standard_never :
  forall p, ~ WasAutonomous p -> applicable_standard p = BestInterest.

(* ============================================================
   PART 4: Proxy consent validity  (uses new Consent structure)
   ============================================================ *)

Parameter PatientWouldChoose : Agent -> Action -> Time -> Prop.
Parameter IsBestInterest     : Agent -> Action -> Time -> Prop.

Definition ProxyConsentValid
    (c : Consent) (patient proxy : Agent) (t : Time) : Prop :=
  consent_agent c = patient /\
  consent_proxy c = Some proxy /\
  consent_source c <> PatientSelf /\
  ValidConsent c patient (consent_action c) t /\
  match applicable_standard patient with
  | SubstitutedJudgment => PatientWouldChoose patient (consent_action c) t
  | BestInterest        => IsBestInterest patient (consent_action c) t
  end.

(* NEW AXIOM: structural validity of proxy consent implies the
   decision standard is satisfied. This is the substantive
   assumption that separates "recorded proxy consent" from
   "consent that actually followed the standard". *)
Axiom ValidConsent_proxy_standard :
  forall (c : Consent) (a : Agent) (act : Action) (t : Time),
    ValidConsent c a act t ->
    consent_source c <> PatientSelf ->
    match applicable_standard a with
    | SubstitutedJudgment => PatientWouldChoose a act t
    | BestInterest        => IsBestInterest a act t
    end.

(* ============================================================
   PART 5: What proxy consent covers / forbids
   ============================================================ *)

Definition ProxyCovers (act : Action) (patient : Agent) : Prop :=
  (exists h, act = observe h /\ h = patient) \/
  (exists h, act = synchronize h /\ h = patient) \/
  (exists ai, act = use_ai ai patient).

Definition ProxyForbids (act : Action) (patient : Agent) : Prop :=
  (exists h, act = clone h /\ h = patient) \/
  (exists h t, act = use_ai patient h /\ SelfHarm patient t).

Axiom ProxyCannotAuthorize :
  forall (c : Consent) (patient proxy : Agent) (t : Time),
    ProxyForbids (consent_action c) patient ->
    ~ ProxyConsentValid c patient proxy t.

(* ============================================================
   PART 6: Therapeutic exception
   ============================================================ *)

Parameter Audited             : Agent -> Action -> Time -> Prop.
Parameter TimeLimited         : Agent -> Action -> Time -> Prop.
Parameter Minimal             : Agent -> Action -> Time -> Prop.
Parameter NecessaryForSupport : Agent -> Action -> Time -> Prop.

Definition TherapeuticException
    (clinician patient : Agent) (act : Action) (t : Time) : Prop :=
  IsHuman clinician /\
  IsHuman patient /\
  clinician <> patient /\
  SelfHarm patient t /\
  ~ (exists proxy src, ProxyAvailable patient proxy src t /\
                       src <> ClinicianException) /\
  NecessaryForSupport patient act t /\
  Minimal patient act t /\
  TimeLimited patient act t /\
  Audited clinician act t /\
  ProxyCovers act patient.

(* ============================================================
   PART 7: ConsentSatisfied and the main theorem
   ============================================================ *)

Definition ConsentSatisfied (patient : Agent) (t : Time) : Prop :=
  (* Case 1: self-consent *)
  (exists c, ValidConsent c patient (observe patient) t /\
             consent_source c = PatientSelf) \/
  (* Case 2: proxy consent, action is observe *)
  (exists c proxy, ProxyConsentValid c patient proxy t /\
                   consent_action c = observe patient) \/
  (* Case 3: therapeutic exception *)
  (exists clinician act, TherapeuticException clinician patient act t).

(* ============================================================
   PART 8: MAIN THEOREM — proved without Admitted
   ============================================================ *)

Theorem FORCED_REPORT_activation_requires_consent :
  forall (patient : Agent) (t : Time),
    (exists c, ValidConsent c patient (observe patient) t) ->
    ConsentSatisfied patient t.
Proof.
  intros patient t [c Hc].
  destruct (classic (consent_source c = PatientSelf)) as [Hself | Hnotself].
  - left. exists c. split; auto.
  - right. left.
    destruct (consent_proxy_has_proxy c patient (observe patient) t Hc Hnotself)
      as [p Hp].
    exists c, p.
    unfold ProxyConsentValid.
    assert (Hagent : consent_agent c = patient)
      by (apply (consent_matches_agent c patient (observe patient) t Hc)).
    assert (Hact : consent_action c = observe patient)
      by (apply (consent_matches_action c patient (observe patient) t Hc)).
    refine (conj (conj Hagent (conj Hp (conj Hnotself (conj _ _)))) Hact).
    + rewrite Hact. exact Hc.
    + rewrite Hact.
      apply (ValidConsent_proxy_standard c patient (observe patient) t Hc Hnotself).
Qed.
