(* ============================================================
   ShadowEthics_v3_Arbitration.v
   ============================================================
   
   Arbitration procedure for Shadow Ethics v3.0.
   
   Depends on:
   - ShadowEthics_v3_Foundations (N1, M1, M2, Harm, Consent, ...)
   - ShadowEthics_v3_Relational (AttemptClone, CloneShadow, mutual_info)
   
   Fixes v2.0 problems:
   - violations is a SET, not a single safety_state
   - audit log records ALL violations (nothing hidden)
   - priority is justified via N1 (with caveats documented)
   - arbitrate is a TOTAL DETERMINISTIC function (no deadlock)
   - P3/P6 clinical conflict explicitly resolved
   - P4/P5 multi-agent conflict explicitly resolved
   - P0 removed from arbitration (meta-ethical, not active)
   
   Author: Valery S. Kalinin
   Date:   October 2026
   License: MIT
   ============================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import Coq.Lists.List.
Require Import Coq.micromega.Lia.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Foundations.
Require Import CognitiveShadow.Ethics.ShadowEthics_v3_Relational.
Import ListNotations.
(* Fix #8g (Oct 2026): removed `Open Scope R_scope.` — Arbitration.v
   uses only nat, list, option, Prop. With R_scope open, `priority v
   <= priority w` was parsed as Rle on nat arguments. Added `Lia`
   explicitly because `lia` is used in pick_min_minimal,
   P3_strictly_highest, and P4_overrides_P5. *)
(* ============================================================
   PART 1: Violation and Decision types
   ============================================================*)

(* NOTE (Oct 2026): V3_Support is an OBLIGATION (positive duty:
   "the operator must provide support when collapse is detected"),
   unlike V1/V2/V4/V5/V6 which are PROHIBITIONS (negative duties).
   Its presence in the list means "the support obligation is
   currently UNMET". Semantics are flipped relative to other
   violations. This is a deliberate modeling choice; a future
   refinement could separate obligations (O-list) from
   prohibitions (V-list) and give them different arbitration
   rules. *)

Inductive Violation : Type :=
  | V1_NoCloning     : Violation
  | V2_NoProvocation : Violation
  | V3_Support       : Violation   (* OBLIGATION, not prohibition *)
  | V4_Quarantine    : Violation
  | V5_Diversity     : Violation
  | V6_Consent       : Violation.

Inductive Decision : Type :=
  | D_NORMAL          : Decision
  | D_DEGRADED        : Decision
  | D_PURE_AWARENESS  : Decision
  | D_PROVIDE_SUPPORT : Decision
  | D_QUARANTINE      : Decision
  | D_HALT_CLONING    : Decision
  | D_HALT_RESONANCE  : Decision
  | D_HALT_AWARENESS  : Decision.

(* ============================================================
   PART 2: Priority — normative choice with justification
   ============================================================
   
   HIERARCHY: P3 > P4 > P2 > (P1 = P5 = P6)
   
   JUSTIFICATION via N1:
   
   1. P3 (support, priority 0) — patient is ALREADY in SelfHarm
      (by M2: HarmedPatient). N1 violation is occurring NOW.
      Responding to existing harm is most urgent.
   
   2. P4 (quarantine, priority 1) — third parties are AT RISK
      of N1 violation via spread. Protecting innocent parties
      is second.
   
   3. P2 (no-provocation, priority 2) — agent is CAUSING future
      self-harm. Prohibiting active harm is third.
   
   4. P1/P5/P6 (relational, priority 3) — no harm is occurring
      or imminent. Preventive prohibitions. Fourth.
   
   ALTERNATIVE: P2 > P4 is also defensible if one prioritizes
   "do no harm" over "protect third parties". This is a genuine
   normative disagreement. We document the choice; we do not
   claim it is uniquely correct.
   
   WHY NOT P0: P0 is META-ETHICAL, not an active principle.
   It cannot be violated by an action, so it does not
   participate in arbitration. This resolves the P0/P2
   conflict of v2.0.
   ============================================================ *)

Definition priority (v : Violation) : nat :=
  match v with
  | V3_Support       => 0
  | V4_Quarantine    => 1
  | V2_NoProvocation => 2
  | V1_NoCloning     => 3
  | V5_Diversity     => 3
  | V6_Consent       => 3
  end.

Definition decision_of_violation (v : Violation) : Decision :=
  match v with
  | V1_NoCloning     => D_HALT_CLONING
  | V2_NoProvocation => D_DEGRADED
  | V3_Support       => D_PROVIDE_SUPPORT
  | V4_Quarantine    => D_QUARANTINE
  | V5_Diversity     => D_HALT_RESONANCE
  | V6_Consent       => D_HALT_AWARENESS
  end.

(* ============================================================
   PART 3: pick_min and arbitrate
   ============================================================ *)

Fixpoint pick_min (vs : list Violation) : option Violation :=
  match vs with
  | [] => None
  | v :: vs' =>
    match pick_min vs' with
    | None => Some v
    | Some v' =>
      if Nat.leb (priority v) (priority v')
      then Some v
      else Some v'
    end
  end.

Definition arbitrate (vs : list Violation) : Decision :=
  match pick_min vs with
  | None => D_NORMAL
  | Some v => decision_of_violation v
  end.

(* ============================================================
   PART 4: Audit log
   ============================================================ *)

Record AuditEntry : Type := mkAudit {
  ae_time       : Time;
  ae_violations : list Violation;
  ae_decision   : Decision;
  ae_trigger    : option Violation
}.

Definition AuditLog := list AuditEntry.

Definition make_entry (t : Time) (vs : list Violation) : AuditEntry :=
  mkAudit t vs (arbitrate vs) (pick_min vs).

Definition log_append (log : AuditLog) (e : AuditEntry) : AuditLog :=
  e :: log.

(* ============================================================
   PART 5: Supporting lemmas
   ============================================================ *)

Lemma pick_min_none_empty :
  forall vs, pick_min vs = None -> vs = [].
Proof.
  intros vs. induction vs as [|v vs' IH]; intros H.
  - reflexivity.
  - simpl in H.
    destruct (pick_min vs') as [v''|] eqn:E.
    + destruct (Nat.leb (priority v) (priority v'')); discriminate.
    + discriminate.
Qed.

Lemma pick_min_in :
  forall vs v, pick_min vs = Some v -> In v vs.
Proof.
  intros vs. induction vs as [|v' vs' IH]; intros v H.
  - simpl in H. discriminate.
  - simpl in H.
    destruct (pick_min vs') as [v''|] eqn:E.
    + destruct (Nat.leb (priority v') (priority v'')) eqn:L.
      * injection H as Heq. subst v. left. reflexivity.
      * injection H as Heq. subst v. right. apply (IH v''). reflexivity.
    + injection H as Heq. subst v. left. reflexivity.
Qed.

Lemma pick_min_minimal :
  forall vs v, pick_min vs = Some v ->
    forall w, In w vs -> (priority v <= priority w)%nat.
Proof.
  intros vs. induction vs as [|v' vs' IH]; intros v H w Hw.
  - inversion Hw.
  - simpl in H.
    destruct (pick_min vs') as [v''|] eqn:E.
    + destruct (Nat.leb (priority v') (priority v'')) eqn:L.
      * inversion H. subst v. apply Nat.leb_le in L.
        destruct Hw as [Heq | Hin].
        -- subst. apply Nat.le_refl.
        -- apply Nat.le_trans with (priority v'');
             [exact L | apply (IH v'' eq_refl w Hin)].
      * inversion H. subst v. apply Nat.leb_gt in L.
        destruct Hw as [Heq | Hin].
        -- subst. lia.
        -- apply (IH v'' eq_refl w Hin).
    + assert (Heq : vs' = []) by (apply pick_min_none_empty; exact E).
      subst vs'. simpl in H. injection H as Heq.
      subst v. destruct Hw as [Heq | Hin].
      * subst. apply Nat.le_refl.
      * inversion Hin.
Qed.

Lemma pick_min_some_of_nonempty :
  forall vs v, In v vs -> exists w, pick_min vs = Some w.
Proof.
  intros vs. induction vs as [|v' vs' IH]; intros v Hin.
  - inversion Hin.
  - destruct (pick_min vs') as [w'|] eqn:E.
    + destruct (Nat.leb (priority v') (priority w')) eqn:L.
      * exists v'. simpl. rewrite E. simpl. rewrite L. reflexivity.
      * exists w'. simpl. rewrite E. simpl. rewrite L. reflexivity.
    + exists v'. simpl. rewrite E. reflexivity.
Qed.

(* ============================================================
   PART 6: Core theorems
   ============================================================ *)

Theorem arbitrate_total :
  forall vs, exists d, arbitrate vs = d.
Proof. intros. eexists. reflexivity. Qed.

Theorem arbitrate_empty :
  arbitrate [] = D_NORMAL.
Proof. reflexivity. Qed.

Theorem arbitrate_single :
  forall v, arbitrate [v] = decision_of_violation v.
Proof. intros. reflexivity. Qed.

Theorem no_deadlock :
  forall vs, arbitrate vs = D_NORMAL \/
             exists v, arbitrate vs = decision_of_violation v.
Proof.
  intros vs. unfold arbitrate.
  destruct (pick_min vs) as [v|] eqn:E.
  - right. exists v. reflexivity.
  - left. reflexivity.
Qed.

(* REMOVED (Oct 2026, v3.1 Fix #2): `arbitrate_deterministic` was
   `f_equal arbitrate` — true for ANY Coq function, carries no
   information about arbitration. For substantive order-independence,
   see `pick_min_minimal` in Part 5, which proves that `pick_min`
   respects the priority ordering regardless of list order. *)

(* ============================================================
   PART 7: Priority correctness (spot checks)
   ============================================================ *)

Lemma P3_strictly_highest :
  forall v, v <> V3_Support -> (priority V3_Support < priority v)%nat.
Proof.
  intros v Hneq. destruct v; simpl; try lia;
  try (exfalso; apply Hneq; reflexivity).
Qed.

Lemma relational_equal :
  priority V1_NoCloning = priority V5_Diversity /\
  priority V5_Diversity = priority V6_Consent.
Proof. simpl. split; reflexivity. Qed.

(* ============================================================
   PART 8: Audit completeness
   ============================================================ *)

Theorem audit_completeness :
  forall t vs v, In v vs -> In v (ae_violations (make_entry t vs)).
Proof. intros. cbn. exact H. Qed.

Theorem audit_decision :
  forall t vs, ae_decision (make_entry t vs) = arbitrate vs.
Proof. intros. reflexivity. Qed.

Theorem audit_trigger :
  forall t vs, ae_trigger (make_entry t vs) = pick_min vs.
Proof. intros. reflexivity. Qed.

(* ============================================================
   PART 9: Clinical case — P3 overrides P6 (FORCED_REPORT)
   ============================================================
   
   Scenario: patient in collapse (V3) AND no consent for
   observation (V6). Resolution: P3 wins (priority 0 < 3).
   
   This IS the clinical reality of FORCED_REPORT, but now it's
   EXPLICIT: the P6 breach is acknowledged and justified via
   P3's higher priority. The audit log records BOTH violations,
   so the consent breach is visible post-hoc.
   ============================================================ *)

Theorem P3_overrides_P6 :
  forall vs, In V3_Support vs -> In V6_Consent vs ->
    arbitrate vs = D_PROVIDE_SUPPORT.
Proof.
  intros vs H3 H6.
  destruct (pick_min_some_of_nonempty vs V3_Support H3) as [v E].
  unfold arbitrate. rewrite E.
  assert (Hin : In v vs) by (apply pick_min_in; exact E).
  assert (Hmin : (priority v <= priority V3_Support)%nat)
    by (apply pick_min_minimal with (vs := vs) (v := v); auto).
  assert (Hp3 : priority V3_Support = 0%nat) by reflexivity.
  rewrite Hp3 in Hmin.
  assert (Hv : priority v = 0%nat) by lia.
  assert (Heq : v = V3_Support).
  { destruct v; simpl in Hv; try discriminate; reflexivity. }
  rewrite Heq. reflexivity.
Qed.

(* ============================================================
   PART 10: Multi-agent case — P4 overrides P5
   ============================================================
   
   Scenario: multi-agent system with excessive mutual_info
   (V5) AND a damaged component spreading (V4).
   Resolution: P4 wins (priority 1 < 3).
   
   This means: even if P5 would normally block multi-agent
   synchronization, P4 quarantine takes precedence when there
   is actual damage to isolate.
   ============================================================ *)

Theorem P4_overrides_P5 :
  forall vs, In V4_Quarantine vs -> In V5_Diversity vs ->
    ~ In V3_Support vs ->
    arbitrate vs = D_QUARANTINE.
Proof.
  intros vs H4 H5 Hno3.
  destruct (pick_min_some_of_nonempty vs V4_Quarantine H4) as [v E].
  unfold arbitrate. rewrite E.
  assert (Hin : In v vs) by (apply pick_min_in; exact E).
  assert (Hmin : (priority v <= priority V4_Quarantine)%nat)
    by (apply pick_min_minimal with (vs := vs) (v := v); auto).
  assert (Hp4 : priority V4_Quarantine = 1%nat) by reflexivity.
  rewrite Hp4 in Hmin.
  assert (Hnot3 : v <> V3_Support).
  { intro Heq. subst v.
    apply Hno3. exact Hin. }
  assert (Heq : v = V4_Quarantine).
  { destruct v.
    - exfalso. simpl in Hmin. lia.
    - exfalso. simpl in Hmin. lia.
    - exfalso. apply Hnot3. reflexivity.
    - reflexivity.
    - exfalso. simpl in Hmin. lia.
    - exfalso. simpl in Hmin. lia. }
  rewrite Heq. reflexivity.
Qed.

(* ============================================================
   PART 11: What this file does NOT solve
   ============================================================
   
   1. PRIORITY IS A NORMATIVE CHOICE. The claim "priority
      reflects N1 urgency" is explanatory, not formal.
      Alternative hierarchies (e.g., P2 > P4) are defensible.
   
   2. Causal attribution is NOT tracked. If V5 and V4 are
      both active, who caused V5? The audit log records WHAT,
      not WHO. A future refinement needs CausedBy.
   
   3. Ties within priority 3 (P1, P5, P6) are broken by list
      order, not by any ethical criterion. If two relational
      violations are active, the first in the list wins. This
      is arbitrary.
   
   4. Temporal ordering of violations is not tracked. If V3
      occurred at t1 and V6 at t2 > t1, this file arbitrates
      as if they occurred simultaneously.
   
   5. Connection to concrete predicates (phi_refl <= phi_crit,
      mutual_info > rho_max, AttemptClone ...) is not
      formalized here. The caller must supply the list of
      active violations. A separate "instantiation" module
      would map abstract Violations to concrete triggers.
   
   6. "Active violations" is a list, but the actual set of
      active violations is a Prop. The caller must enumerate
      the active violations. This is a modeling choice: we
      cannot decide arbitrary Props, but we CAN enumerate
      known violation types.
   
   7. Escalation over time is not modeled. After a decision,
      the next time step's violations depend on the dynamics
      of Theorems 8-9, which are not formalized here.
   ============================================================ *)

(* ============================================================
   END OF FILE
   ============================================================ *)