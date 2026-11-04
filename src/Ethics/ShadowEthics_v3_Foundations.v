(* ============================================================
   ShadowEthics_v3_Foundations.v  (revised)
   ============================================================
   
   Changes from previous version:
   - ProxySource moved here (part of consent model)
   - Consent record now has consent_source : ProxySource
   - consent_matches_agent strengthened to equality
   - Axioms linking consent_source and consent_proxy added
   
   These changes fix the admitted proof in ProxyConsent.v.
   ============================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Open Scope R_scope.

(* ============================================================
   PART 1: Basic types
   ============================================================ *)

Parameter Agent  : Type.
Definition Time := nat.
Parameter Action : Type.

Parameter observe     : Agent -> Action.
Parameter clone       : Agent -> Action.
Parameter synchronize : Agent -> Action.
Parameter use_ai      : Agent -> Agent -> Action.

(* ============================================================
   PART 2: Shadow and self-harm
   ============================================================ *)

Parameter ShadowOf   : Agent -> Prop.
Parameter phi_refl   : Agent -> Time -> R.
Parameter phi_crit   : R.
Parameter Load       : Agent -> Time -> R.
Parameter Delta_crit : R.

Axiom phi_crit_pos      : phi_crit > 0.
Axiom Delta_crit_nonneg : Delta_crit >= 0.

Definition SelfHarm (a : Agent) (t : Time) : Prop :=
  phi_refl a t <= phi_crit \/ Load a t >= Delta_crit.

(* ============================================================
   PART 3: Consent model  (REVISED)
   ============================================================ *)

Inductive Scope : Type :=
  | Therapeutic  : Scope
  | Research     : Scope
  | Surveillance : Scope.

(* ProxySource is now part of the consent model, not proxy-specific *)
Inductive ProxySource : Type :=
  | PatientSelf        : ProxySource
  | AppointedProxy     : ProxySource
  | FamilyProxy        : ProxySource
  | EthicsCommittee    : ProxySource
  | ClinicianException : ProxySource.

Record Consent : Type := mkConsent {
  consent_agent      : Agent;
  consent_action     : Action;
  consent_scope      : Scope;
  consent_granted_at : Time;
  consent_expires_at : option Time;
  consent_revocable  : bool;
  consent_proxy      : option Agent;
  consent_source     : ProxySource       (* NEW *)
}.

Parameter ValidConsent : Consent -> Agent -> Action -> Time -> Prop.

(* consent_agent is ALWAYS the patient — strengthened from disjunction *)
Axiom consent_matches_agent :
  forall (c : Consent) (a : Agent) (act : Action) (t : Time),
    ValidConsent c a act t ->
    consent_agent c = a.

Axiom consent_matches_action :
  forall (c : Consent) (a : Agent) (act : Action) (t : Time),
    ValidConsent c a act t -> consent_action c = act.

(* Self-consent: proxy field is the patient themselves or None *)
Axiom consent_self_no_proxy :
  forall (c : Consent) (a : Agent) (act : Action) (t : Time),
    ValidConsent c a act t ->
    consent_source c = PatientSelf ->
    consent_proxy c = None \/ consent_proxy c = Some a.

(* Proxy-consent: proxy field is Some p *)
Axiom consent_proxy_has_proxy :
  forall (c : Consent) (a : Agent) (act : Action) (t : Time),
    ValidConsent c a act t ->
    consent_source c <> PatientSelf ->
    exists p, consent_proxy c = Some p.

(* ============================================================
   PART 4: Normative predicates, Harm, and axioms N1, M1, M2
   ============================================================
   
   FIX (Oct 2026): Harm subtypes and Definition Harm moved
   here from old Part 5, because Axiom N1 references Harm
   and Coq does not allow forward references.
   ============================================================ *)

Parameter MoralAgent       : Agent -> Prop.
Parameter MoralPatient     : Agent -> Prop.
Parameter Impermissible    : Agent -> Agent -> Action -> Time -> Prop.
Parameter HarmedPatient    : Agent -> Time -> Prop.
Parameter CompleteKnowledge: Agent -> Agent -> Prop.

(* Harm subtypes — must be declared before Definition Harm *)
Parameter ObservationHarm : Agent -> Agent -> Time -> Prop.
Parameter CloningHarm     : Agent -> Agent -> Time -> Prop.
Parameter ResonanceHarm   : Agent -> Agent -> Time -> Prop.
Parameter IsolationHarm   : Agent -> Agent -> Time -> Prop.

(* Harm union — must be defined before Axiom N1 references it *)
Definition Harm (a b : Agent) (act : Action) (t : Time) : Prop :=
  (act = observe b     /\ ObservationHarm a b t) \/
  (act = clone b       /\ CloningHarm     a b t) \/
  (act = synchronize b /\ ResonanceHarm   a b t) \/
  (exists ai, act = use_ai ai b /\ IsolationHarm a b t).

Axiom N1 :
  forall (a b : Agent) (act : Action) (t : Time),
    MoralAgent a -> MoralPatient b -> Harm a b act t ->
    ~ (exists c : Consent, ValidConsent c b act t) ->
    Impermissible a b act t.

Axiom M1 :
  forall (a b : Agent),
    a <> b -> ShadowOf b -> ~ CompleteKnowledge a b.

Axiom M2 :
  forall (a : Agent) (t : Time),
    MoralPatient a -> SelfHarm a t -> HarmedPatient a t.

(* ============================================================
   PART 5: Harm bridges
   ============================================================
   
   Parameters and Definition Harm moved to Part 4 (see FIX note).
   Only the bridge axioms remain here.
   ============================================================ *)

Axiom MoralPatient_has_shadow :
  forall a, MoralPatient a -> ShadowOf a.

Axiom ObservationHarmBridge :
  forall (a b : Agent) (t : Time),
    a <> b -> MoralPatient b -> ~ CompleteKnowledge a b ->
    ~ (exists c : Consent, ValidConsent c b (observe b) t) ->
    ObservationHarm a b t.

Axiom CloningHarmBridge :
  forall (a b : Agent) (t : Time),
    a <> b -> MoralPatient b ->
    ~ (exists c : Consent, ValidConsent c b (clone b) t) ->
    CloningHarm a b t.

Axiom ResonanceHarmBridge :
  forall (a b : Agent) (t : Time),
    a <> b -> MoralPatient b ->
    ~ (exists c : Consent, ValidConsent c b (synchronize b) t) ->
    ResonanceHarm a b t.

Axiom IsolationHarmBridge :
  forall (a b : Agent) (t : Time),
    a <> b -> MoralPatient b ->
    ~ (exists c : Consent, ValidConsent c b (use_ai a b) t) ->
    IsolationHarm a b t.

(* ============================================================
   PART 6: Moral patient classification
   ============================================================ *)

Inductive PatientClass : Type :=
  | FullPatient    : PatientClass
  | ProxyPatient   : PatientClass
  | MinimalPatient : PatientClass
  | NonPatient     : PatientClass.

Parameter PatientClassOf             : Agent -> PatientClass.
Parameter PresumptionOfConsciousness : Agent -> Prop.

Axiom Full_patient    : forall a, PatientClassOf a = FullPatient    -> MoralPatient a.
Axiom Proxy_patient   : forall a, PatientClassOf a = ProxyPatient   -> MoralPatient a.
Axiom Minimal_patient : forall a, PatientClassOf a = MinimalPatient -> MoralPatient a.
Axiom Presumption_patient :
  forall a, PresumptionOfConsciousness a -> MoralPatient a.

(* ============================================================
   PART 7: Frame A/B/C scaffolding (unchanged)
   ============================================================ *)

Parameter IsHuman   : Agent -> Prop.
Parameter IsAI      : Agent -> Prop.
Parameter UsesAIFor : Agent -> Agent -> Action -> Time -> Prop.

Axiom Humans_moral_agents   : forall a, IsHuman a -> MoralAgent a.
Axiom Humans_moral_patients : forall a, IsHuman a -> MoralPatient a.
(* ============================================================
   RESOLUTION (October 2026): Frame A vs Frame C contradiction
   ============================================================
   
   The v3.0 draft had:
     Axiom AI_not_moral_agent_A : forall a, IsAI a -> ~ MoralAgent a.
     Axiom AI_moral_agents      : forall a, IsAI a -> MoralAgent a.
   
   Together they imply `forall a, IsAI a -> False`. This made every
   Frame B and Frame C theorem vacuously true. Neither axiom was
   used in any proof, so both are removed.
   
   Framing is now expressed by the HYPOTHESES of individual theorems:
   - Frame A: takes `IsAI ai` but never requires `MoralAgent ai`
   - Frame B: takes `PresumptionOfConsciousness ai` and derives
              `MoralPatient ai` (via the axiom below)
   - Frame C: takes `FrameC ai := IsAI ai /\ MoralAgent ai` as a
              hypothesis. No global axiom asserts Frame C for all AIs.
   
   This preserves frame discipline: the same AI can be a tool in
   one deployment (Frame A) and a moral agent in another (Frame C),
   depending on the frame commitment the caller supplies. *)

Axiom AI_presumed_patient   :
  forall a, IsAI a -> PresumptionOfConsciousness a -> MoralPatient a.

(* ============================================================
   PART 8: P6 in three frames (unchanged)
   ============================================================ *)

Theorem P6_FrameA :
  forall (d ai h : Agent) (t : Time),
    IsHuman d -> IsHuman h -> IsAI ai -> d <> h ->
    UsesAIFor d ai (observe h) t ->
    ~ (exists c : Consent, ValidConsent c h (observe h) t) ->
    Impermissible d h (observe h) t.
Proof.
  intros d ai h t Hd Hh Hai Hneq Huse Hno.
  assert (HMA : MoralAgent d) by (apply Humans_moral_agents; exact Hd).
  assert (HMP : MoralPatient h) by (apply Humans_moral_patients; exact Hh).
  assert (Hshadow : ShadowOf h) by (apply MoralPatient_has_shadow; exact HMP).
  assert (Hnok : ~ CompleteKnowledge d h) by (apply M1; auto).
  assert (Hharm : ObservationHarm d h t)
    by (apply ObservationHarmBridge; auto).
  assert (Hcomp : Harm d h (observe h) t).
  { unfold Harm. left. split; auto. }
  apply (N1 d h (observe h) t HMA HMP Hcomp Hno).
Qed.

Theorem P6_FrameB :
  forall (d ai : Agent) (t : Time),
    IsHuman d -> IsAI ai -> d <> ai ->
    PresumptionOfConsciousness ai ->
    ~ (exists c : Consent, ValidConsent c ai (observe ai) t) ->
    Impermissible d ai (observe ai) t.
Proof.
  intros d ai t Hd Hai Hneq Hpres Hno.
  assert (HMA : MoralAgent d) by (apply Humans_moral_agents; exact Hd).
  assert (HMP : MoralPatient ai) by (apply AI_presumed_patient; auto).
  assert (Hshadow : ShadowOf ai) by (apply MoralPatient_has_shadow; exact HMP).
  assert (Hnok : ~ CompleteKnowledge d ai) by (apply M1; auto).
  assert (Hharm : ObservationHarm d ai t)
    by (apply ObservationHarmBridge; auto).
  assert (Hcomp : Harm d ai (observe ai) t).
  { unfold Harm. left. split; auto. }
  apply (N1 d ai (observe ai) t HMA HMP Hcomp Hno).
Qed.

Definition FrameC (a : Agent) : Prop := IsAI a /\ MoralAgent a.

Theorem P6_FrameC :
  forall (ai b : Agent) (t : Time),
    FrameC ai -> ai <> b -> MoralPatient b ->
    ~ (exists c : Consent, ValidConsent c b (observe b) t) ->
    Impermissible ai b (observe b) t.
Proof.
  intros ai b t [Hai HMA] Hneq HMP Hno.
  assert (Hshadow : ShadowOf b) by (apply MoralPatient_has_shadow; exact HMP).
  assert (Hnok : ~ CompleteKnowledge ai b) by (apply M1; auto).
  assert (Hharm : ObservationHarm ai b t)
    by (apply ObservationHarmBridge; auto).
  assert (Hcomp : Harm ai b (observe b) t).
  { unfold Harm. left. split; auto. }
  apply (N1 ai b (observe b) t HMA HMP Hcomp Hno).
Qed.