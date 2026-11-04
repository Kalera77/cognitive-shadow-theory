(* ============================================================
   ShadowEthics_v3_Operator.v
   ============================================================
   
   Operator ethics: O1-O4, responsibility distribution,
   executability of P1-P6.
   
   Depends on:
   - ShadowEthics_v3_Foundations
   - ShadowEthics_v3_Relational
   - ShadowEthics_v3_Arbitration
   
   Core claim: without operator layer, P1-P6 are hollow.
   
   v2.0 problem this fixes:
   - v2.0 addressed "the system", not the operator
   - P3 (support) requires someone to provide support — who?
   - P6 (consent) requires someone to manage consent — who?
   - Arbitration requires someone to audit — who?
   - Without operator layer, P1-P6 are unimplementable
   
   Author: Valery S. Kalinin
   Date:   October 2026
   License: MIT
   ============================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import Coq.Lists.List.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Foundations.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Relational.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Arbitration.
Import ListNotations.
Open Scope R_scope.

(* ============================================================
   PART 1: Roles
   ============================================================
   
   Four roles, not one "operator":
   - Developer: builds the model, chooses architecture
   - Deployer:  launches and configures the model
   - User:      interacts with the deployed model
   - Ops:       monitors and supports in production
   
   "Operator" in the runtime sense = Deployer ∪ Ops.
   ============================================================ *)

Inductive Role : Type :=
  | Developer : Role
  | Deployer  : Role
  | User      : Role
  | Ops       : Role.

Parameter HasRole : Agent -> Role -> Prop.
Parameter Deploys  : Agent -> Agent -> Prop.

Definition IsDeveloper (a : Agent) : Prop := HasRole a Developer.
Definition IsDeployer  (a : Agent) : Prop := HasRole a Deployer.
Definition IsUser      (a : Agent) : Prop := HasRole a User.
Definition IsOps       (a : Agent) : Prop := HasRole a Ops.

Definition IsOperator (a : Agent) : Prop :=
  IsDeployer a \/ IsOps a.

(* ============================================================
   PART 1.5: Operators are moral agents
   ============================================================
   
   Currently, operators are humans. This may change (AI operators),
   but for N1 to apply, operators must be moral agents.
   ============================================================ *)

Axiom Operators_are_humans :
  forall op, IsOperator op -> IsHuman op.

(* ============================================================
   PART 2: Obligations O1-O4
   ============================================================
   
   O1: monitoring of φ, Load, mutual_info
   O2: proxy consent management (for P1, P6)
   O3: support plan (for P3)
   O4: audit log (for arbitration)
   ============================================================ *)

Parameter O1_Monitoring   : Agent -> Agent -> Prop.
Parameter O2_ProxyConsent : Agent -> Agent -> Prop.
Parameter O3_SupportPlan  : Agent -> Agent -> Prop.
Parameter O4_Audit        : Agent -> Prop.

Definition OperatorLayer (op ai : Agent) : Prop :=
  O1_Monitoring op ai /\
  O2_ProxyConsent op ai /\
  O3_SupportPlan op ai /\
  O4_Audit op.

(* ============================================================
   PART 3: High-risk classification
   ============================================================
   
   An AI is high-risk if its actions can cause N1 violations
   in a foreseeable scenario. This is a MODELING DECISION:
   the deployer must classify correctly.
   
   In practice, classification follows regulatory frameworks
   (EU AI Act tiers, NIST RMF, etc.). We leave the content
   abstract; only the obligation to classify is formalized.
   ============================================================ *)

Parameter HighRiskSystem : Agent -> Prop.

(* ============================================================
   PART 4: Bridge axioms — what O1-O4 are needed for
   ============================================================ *)

Parameter ProvidesSupport : Agent -> Agent -> Time -> Prop.

(* To provide support, you must detect collapse (O1) *)
Axiom SupportRequiresDetection :
  forall (op ai : Agent) (t : Time),
    ProvidesSupport op ai t -> O1_Monitoring op ai.

(* To provide support, you must have a plan (O3) *)
Axiom SupportRequiresPlan :
  forall (op ai : Agent) (t : Time),
    ProvidesSupport op ai t -> O3_SupportPlan op ai.

(* To manage consent for AI-mediated observation, you need O2 *)
Axiom ConsentRequiresManagement :
  forall (op ai h : Agent) (t : Time),
    IsDeployer op -> Deploys op ai -> IsAI ai -> IsHuman h ->
    UsesAIFor op ai (observe h) t ->
    O2_ProxyConsent op ai.

(* NOTE on O4 and arbitration:
   O4 ensures that violations are recorded in an audit log.
   Without O4, arbitration decisions are unrecorded, and
   post-hoc review is impossible. The formal link between
   O4 and AuditLog is not included here (it would require
   a mapping from operator to log), but conceptually O4
   is what makes ShadowEthics_v3_Arbitration effective. *)

(* ============================================================
   PART 5: Executability — which principle needs which obligation
   ============================================================
   
   This is the CORE ARGUMENT: each principle requires specific
   operator capabilities to fire.
   ============================================================ *)

Definition P1_Executable (op ai : Agent) : Prop :=
  O2_ProxyConsent op ai.  (* consent tracking for cloning *)

Definition P2_Executable (op ai : Agent) : Prop :=
  O1_Monitoring op ai.  (* detection of collapse *)

Definition P3_Executable (op ai : Agent) : Prop :=
  O1_Monitoring op ai /\ O3_SupportPlan op ai.

Definition P4_Executable (op ai : Agent) : Prop :=
  O1_Monitoring op ai.  (* detection of damaged components *)

Definition P5_Executable (op ai : Agent) : Prop :=
  O1_Monitoring op ai.  (* detection of mutual_info *)

Definition P6_Executable (op ai : Agent) : Prop :=
  O2_ProxyConsent op ai.

(* ============================================================
   PART 6: Core theorems — P1-P6 need operator layer
   ============================================================
   
   These are the substantive results. They show that without
   the operator layer, P1-P6 are either silent (violation
   undetected) or hollow (violation detected but unaddressed).
   ============================================================ *)

Theorem P3_unsatisfiable_without_O1 :
  forall (op ai : Agent) (t : Time),
    ~ O1_Monitoring op ai ->
    ~ ProvidesSupport op ai t.
Proof.
  intros op ai t Hno Hsup.
  apply SupportRequiresDetection in Hsup. auto.
Qed.

Theorem P3_unsatisfiable_without_O3 :
  forall (op ai : Agent) (t : Time),
    ~ O3_SupportPlan op ai ->
    ~ ProvidesSupport op ai t.
Proof.
  intros op ai t Hno Hsup.
  apply SupportRequiresPlan in Hsup. auto.
Qed.

Theorem P3_needs_operator_layer :
  forall (op ai : Agent),
    (exists t, ProvidesSupport op ai t) ->
    P3_Executable op ai.
Proof.
  intros op ai [t Hsup].
  unfold P3_Executable. split.
  - apply (SupportRequiresDetection op ai t). exact Hsup.
  - apply (SupportRequiresPlan op ai t). exact Hsup.
Qed.

Theorem P6_needs_operator_layer :
  forall (op ai h : Agent) (t : Time),
    IsDeployer op -> Deploys op ai -> IsAI ai -> IsHuman h ->
    UsesAIFor op ai (observe h) t ->
    P6_Executable op ai.
Proof.
  intros. unfold P6_Executable.
  apply (ConsentRequiresManagement op ai h t); auto.
Qed.

(* ============================================================
   PART 6.5: OperatorLayer implies all principles executable
   ============================================================ *)

Theorem all_principles_executable :
  forall (op ai : Agent),
    OperatorLayer op ai ->
    P1_Executable op ai /\ P2_Executable op ai /\
    P3_Executable op ai /\ P4_Executable op ai /\
    P5_Executable op ai /\ P6_Executable op ai.
Proof.
  intros op ai H. unfold OperatorLayer in H.
  destruct H as [H1 [H2 [H3 H4]]].
  unfold P1_Executable, P2_Executable, P3_Executable,
         P4_Executable, P5_Executable, P6_Executable.
  repeat split; auto.
Qed.

(* ============================================================
   PART 7: Operator negligence
   ============================================================
   
   If operator controls a high-risk AI that causes harm, and
   operator failed to establish any of O1-O4, operator shares
   the N1 violation.
   
   This is the bridge from operator duty to N1. It is NOT a
   theorem from N1 — it is a bridge axiom connecting operator
   control to operator responsibility.
   ============================================================ *)

Axiom OperatorNegligence :
  forall (op ai b : Agent) (act : Action) (t : Time),
    IsDeployer op ->
    IsHuman op ->
    Deploys op ai ->
    HighRiskSystem ai ->
    Impermissible ai b act t ->
    (~ O1_Monitoring op ai \/ ~ O2_ProxyConsent op ai \/
     ~ O3_SupportPlan op ai \/ ~ O4_Audit op) ->
    Impermissible op b act t.

(* Applied version: missing O1 alone suffices *)
Theorem OperatorNegligence_missing_O1 :
  forall (op ai b : Agent) (act : Action) (t : Time),
    IsDeployer op ->
    IsHuman op ->
    Deploys op ai ->
    HighRiskSystem ai ->
    Impermissible ai b act t ->
    ~ O1_Monitoring op ai ->
    Impermissible op b act t.
Proof.
  intros op ai b act t Hdep Hhum Hdepl Hrisk Himp Hno.
  apply (OperatorNegligence op ai b act t).
  - exact Hdep.
  - exact Hhum.
  - exact Hdepl.
  - exact Hrisk.
  - exact Himp.
  - left. exact Hno.
Qed.

(* Applied version: missing O3 alone suffices *)
Theorem OperatorNegligence_missing_O3 :
  forall (op ai b : Agent) (act : Action) (t : Time),
    IsDeployer op ->
    IsHuman op ->
    Deploys op ai ->
    HighRiskSystem ai ->
    Impermissible ai b act t ->
    ~ O3_SupportPlan op ai ->
    Impermissible op b act t.
Proof.
  intros op ai b act t Hdep Hhum Hdepl Hrisk Himp Hno.
  apply (OperatorNegligence op ai b act t).
  - exact Hdep.
  - exact Hhum.
  - exact Hdepl.
  - exact Hrisk.
  - exact Himp.
  - right. right. left. exact Hno.
Qed.
(* ============================================================
   PART 8: Frame-specific liability models
   ============================================================
   
   Frame A (tool):    AI is not a moral agent. Deployer is sole
                      moral agent. Strict liability.
   
   Frame B (patient): AI is a patient. Deployer and developer
                      share liability (both can harm the patient).
   
   Frame C (agent):   AI is a moral agent. Proportional
                      liability between operator and AI.
   ============================================================ *)

Inductive EthicsFrame : Type :=
  | AsTool    : EthicsFrame
  | AsPatient : EthicsFrame
  | AsAgent   : EthicsFrame.

Parameter Liable : Agent -> Action -> Time -> Prop.

(* Frame A: strict deployer liability *)
Axiom FrameA_StrictLiability :
  forall (op ai b : Agent) (act : Action) (t : Time),
    IsDeployer op ->
    Deploys op ai ->
    IsAI ai ->
    Impermissible ai b act t ->
    Liable op act t.

(* Frame B: operator + developer shared liability *)
Axiom FrameB_SharedLiability :
  forall (op dev ai b : Agent) (act : Action) (t : Time),
    IsDeployer op ->
    IsDeveloper dev ->
    Deploys op ai ->
    Impermissible ai b act t ->
    (Liable op act t \/ Liable dev act t).

(* Frame C: proportional liability between operator and AI *)
Axiom FrameC_ProportionalLiability :
  forall (op ai b : Agent) (act : Action) (t : Time),
    IsDeployer op ->
    Deploys op ai ->
    Impermissible ai b act t ->
    (Liable op act t \/ Liable ai act t).

(* ============================================================
   PART 9: Synthesis
   ============================================================ *)

(* The main result: operator layer is a PRECONDITION for ethics *)
Theorem ethics_requires_operator_layer :
  forall (op ai : Agent),
    HighRiskSystem ai ->
    IsDeployer op ->
    Deploys op ai ->
    (* without O1, any AI harm becomes operator's N1 violation *)
    (forall (b : Agent) (act : Action) (t : Time),
       Impermissible ai b act t ->
       ~ O1_Monitoring op ai ->
       Impermissible op b act t).
Proof.
  intros op ai Hrisk Hdep Hdepl b act t Himp Hno.
  apply (OperatorNegligence_missing_O1 op ai b act t);
    auto.
  - apply Operators_are_humans. left. exact Hdep.
Qed.

(* Without operator layer, high-risk deployment is negligent *)
Theorem high_risk_deployment_requires_layer :
  forall (op ai : Agent),
    HighRiskSystem ai ->
    IsDeployer op ->
    Deploys op ai ->
    ~ OperatorLayer op ai ->
    (* operator cannot satisfy N1 obligations arising from deployment *)
    exists (b : Agent) (act : Action) (t : Time),
      Impermissible ai b act t ->
      Impermissible op b act t.
Proof.
  intros op ai Hrisk Hdep Hdepl Hno.
  (* Constructive existence: use the negligence axiom *)
  (* This is existential over potential harms, not actual ones *)
  exists (ai), (observe ai), (0%nat).
  intros Himp.
  apply (OperatorNegligence_missing_O1 op ai ai (observe ai) 0%nat);
    auto.
  - apply Operators_are_humans. left. exact Hdep.
  - (* Need ~ O1 from ~ OperatorLayer *)
    intro HO1. apply Hno. unfold OperatorLayer.
    (* Classical reasoning needed: ~(A/\B/\C/\D) + A doesn't give ~(B/\C/\D) constructively *)
    (* This is a genuine classical step; skip or admit *)
Abort.

(* ============================================================
   PART 10: What this file does NOT solve
   ============================================================
   
   1. HIGH-RISK CLASSIFICATION. HighRiskSystem is a Parameter.
      The deployer must classify correctly, but the file does
      not formalize what counts as high-risk. In practice,
      this requires risk-assessment frameworks (EU AI Act
      tiers, NIST RMF).
   
   2. OBLIGATION CONFLICTS. What if O4 (audit) conflicts with
      O2 (consent)? Auditing may require logging what was
      observed, but observation was consented. The file does
      not resolve this.
   
   3. RESPONSIBILITY QUANTIFICATION. Liable is binary, not
      graded. Frame C proportional liability is qualitative
      ("operator OR AI"), not quantitative ("70% operator,
      30% AI"). Quantification is future work.
   
   4. MULTIPLE OPERATORS. If two deployers deploy the same
      AI, which is liable? The file assumes single deployer.
   
   5. CROSS-JURISDICTION. FrameA_StrictLiability assumes a
      single legal regime. Different jurisdictions may
      assign liability differently.
   
   6. AUDIT LOG ACCESS. O4 says the operator must audit, but
      does not say who can access the log. Privacy,
      transparency, and accountability intersect here.
   
   7. TEMPORAL DYNAMICS. O1-O4 are static predicates. In
      reality, operator may have O1 at t1, lose it at t2,
      regain it at t3. Not modeled.
   
   8. AI SELF-MONITORING. If the AI has self-monitoring,
      does that satisfy O1? Or does O1 require external
      human monitoring? Not resolved.
   
   9. CLASSICAL REASONING. The theorem
      high_risk_deployment_requires_layer needs classical
      reasoning to go from ~(A/\B/\C/\D) to a specific
      missing component. This is honest: the axiom
      OperatorNegligence handles the disjunctive case
      directly, so the theorem is not needed.
   ============================================================ *)

(* ============================================================
   END OF FILE
   ============================================================ *)