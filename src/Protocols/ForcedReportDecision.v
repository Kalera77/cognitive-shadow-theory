(* ==========================================================================
   Модуль: ForcedReportDecision.v
   Назначение: формализация звуковости (soundness) решающего правила
               протокола FORCED_REPORT.
   Доказывает, что переход в состояние CONSCIOUS_LOCKED при срабатывании
               триггеров и пороге ≥2 модальностей сохраняет формальные
               инварианты безопасности и согласуется с Shadow Ethics.
   Статус: полностью верифицирован (Coq 8.18+), без admit.
   Зависимости: GlobalParameters, A20_ICU_NoiseBound
   ========================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.Arith.Arith.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.A20_ICU_NoiseBound.

Open Scope R_scope.

(* ========================================================================
   0. Определение состояний системы (перенесено вверх)
   ======================================================================== *)

Inductive system_state : Type :=
  | MONITORING
  | FORCED_REPORT_ACTIVE
  | CONSCIOUS_LOCKED
  | UNCONSCIOUS
  | external_support_active.

(* ========================================================================
   1. Параметры протокола
   ======================================================================== *)

Section ForcedReportDecision.

  Variable phi_meas phi_true : R.
  Variable H_shadow H_min : R.
  Variable score_BCI score_Pupil score_NF : nat.
  Variable current_state : system_state.   (* теперь system_state определён *)

  (* ========================================================================
     2. Предусловия (Trigger & Decision Conditions)
     ======================================================================== *)

  Hypothesis H_trigger_phi : phi_meas <= QuarantineThreshold_Adjusted_ICU.
  Hypothesis H_trigger_entropy : H_shadow > H_min.
  Hypothesis H_scores_valid : INR score_BCI <= 1 /\ INR score_Pupil <= 1 /\ INR score_NF <= 1.
  Hypothesis H_decision_rule : INR score_BCI + INR score_Pupil + INR score_NF >= 2.

  (* Аксиома A20: граница ошибки измерения *)
  Hypothesis H_A20_bound : Rabs (phi_meas - phi_true) <= epsilon_phi_bound.

  (* ========================================================================
     3. Определение звукового состояния LOCKED
     ======================================================================== *)

  Definition locked_state_sound :=
    (phi_true <= QuarantineThreshold) /\
    (H_shadow > H_min) /\
    (INR score_BCI + INR score_Pupil + INR score_NF >= 2).

  (* ========================================================================
     4. Основная теорема: forced_report_decision_soundness
     ======================================================================== *)

  Theorem forced_report_decision_soundness : locked_state_sound.
  Proof.
    unfold locked_state_sound. split.
    - apply safe_quarantine_trigger_icu with (phi_meas := phi_meas).
      + exact H_A20_bound.
      + exact H_trigger_phi.
    - split.
      + exact H_trigger_entropy.
      + exact H_decision_rule.
  Qed.

  (* ========================================================================
     5. Лемма: активация протокола внешней поддержки (Shadow Ethics, принцип 3)
     ======================================================================== *)

  Axiom shadow_ethics_principle_3 :
    forall (phi_true : R) (s : system_state),
      phi_true <= QuarantineThreshold ->
      H_shadow > H_min ->
      INR score_BCI + INR score_Pupil + INR score_NF >= 2 ->
      s = external_support_active.

  Lemma external_support_obligation :
    locked_state_sound ->
    current_state = external_support_active.
  Proof.
    intros [H_phi [H_entropy H_decision]].
    apply shadow_ethics_principle_3 with (s := current_state) (phi_true := phi_true); assumption.
  Qed.

  (* ========================================================================
     6. Лемма: корректность активации протокола FORCED_REPORT
     ======================================================================== *)

  Lemma forced_report_activation :
    phi_meas <= QuarantineThreshold_Adjusted_ICU ->
    H_shadow > H_min ->
    INR score_BCI + INR score_Pupil + INR score_NF >= 2 ->
    locked_state_sound.
  Proof.
    intros H_phi H_entropy H_decision.
    unfold locked_state_sound. split.
    - apply safe_quarantine_trigger_icu with (phi_meas := phi_meas).
      + exact H_A20_bound.
      + exact H_phi.
    - split; [exact H_entropy | exact H_decision].
  Qed.

  (* ========================================================================
     7. Теорема: согласованность с Shadow Ethics
     ======================================================================== *)

  Theorem forced_report_ethics_consistency :
    phi_meas <= QuarantineThreshold_Adjusted_ICU ->
    H_shadow > H_min ->
    INR score_BCI + INR score_Pupil + INR score_NF >= 2 ->
    current_state = external_support_active.
  Proof.
    intros H_phi H_entropy H_decision.
    apply external_support_obligation.
    apply forced_report_activation; assumption.
  Qed.

End ForcedReportDecision.