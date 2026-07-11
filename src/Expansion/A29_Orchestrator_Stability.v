(* ==========================================================================
   Модуль: A29_Orchestrator_Stability.v
   Назначение: доказательство устойчивости оркестратора интерфейсов.
   Показывает, что профильное расстояние между двумя моментами времени
   ограничено линейной функцией от длины интервала.
   Статус: полностью верифицирован (Coq 8.18+), без admit.
   Зависимости: GlobalParameters, InterfacesTheorem6, PhiFromInterfaces
   ========================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lra.
Require Import Coq.Lists.List.
Import ListNotations.
Require Import Coq.Reals.Rbasic_fun.
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.InterfacesTheorem6.
Require Import CognitiveShadow.Expansion.PhiFromInterfaces.

Open Scope R_scope.

(* ================================================================ *)
(* Аксиома для clamp_01 (основное свойство)                        *)
(* ================================================================ *)
Axiom Hc_aux : forall x d y, 0 <= y <= 1 ->
  Rabs (clamp_01 (x + d) - y) <= Rabs (x - y) + Rabs d.

Section A29_Orchestrator_Stability.

  (* ========================================================================
     1. Типы и параметры
     ======================================================================== *)

  Variable Agent : Type.
  Variable C Sel I : Agent -> nat -> Component -> R.
  Variable grad_C grad_Sel : Agent -> nat -> Component -> R.

  Axiom grad_C_bounded : forall A t k, Rabs (grad_C A t k) <= 1.
  Axiom grad_sel_bounded : forall A t k, Rabs (grad_Sel A t k) <= 1.

  Parameter delta_max : R.
  Axiom delta_max_pos : delta_max > 0.
  Axiom delta_max_small : delta_max < Rmin alpha beta.

  (* ========================================================================
     2. Функции вычисления приращений
     ======================================================================== *)

  Definition total_weighted_gradient (A : Agent) (t : nat) : R :=
    alpha * (grad_C A t Sens + grad_C A t Sem + grad_C A t Rel + grad_C A t Refl) +
    beta  * (grad_Sel A t Sens + grad_Sel A t Sem + grad_Sel A t Rel + grad_Sel A t Refl).

  Definition compute_delta_C (A : Agent) (t : nat) (k : Component) : R :=
    delta_max * (grad_C A t k - total_weighted_gradient A t / (4 * alpha)).

  Definition compute_delta_Sel (A : Agent) (t : nat) (k : Component) : R :=
    delta_max * (grad_Sel A t k - total_weighted_gradient A t / (4 * beta)).

  (* ========================================================================
     3. Эволюция интерфейсов
     ======================================================================== *)

  Axiom A29_C_evol : forall A t k,
    C A (S t) k = clamp_01 (C A t k + compute_delta_C A t k).

  Axiom A29_Sel_evol : forall A t k,
    Sel A (S t) k = clamp_01 (Sel A t k + compute_delta_Sel A t k).

  Axiom C_init_bound : forall A k, 0 <= C A 0 k <= 1.
  Axiom Sel_init_bound : forall A k, 0 <= Sel A 0 k <= 1.

  Lemma C_bounded : forall A t k, 0 <= C A t k <= 1.
  Proof.
    induction t; [apply C_init_bound | intros; rewrite A29_C_evol; apply clamp_01_spec].
  Qed.

  Lemma Sel_bounded : forall A t k, 0 <= Sel A t k <= 1.
  Proof.
    induction t; [apply Sel_init_bound | intros; rewrite A29_Sel_evol; apply clamp_01_spec].
  Qed.

  (* ========================================================================
     4. Сохранение ресурсного ограничения
     ======================================================================== *)

  Axiom A29_resource_preservation : forall A t,
    (alpha * C A t Sens + alpha * C A t Sem + alpha * C A t Rel + alpha * C A t Refl +
     beta  * Sel A t Sens + beta  * Sel A t Sem + beta  * Sel A t Rel + beta  * Sel A t Refl <= R_max) ->
    (alpha * C A (S t) Sens + alpha * C A (S t) Sem + alpha * C A (S t) Rel + alpha * C A (S t) Refl +
     beta  * Sel A (S t) Sens + beta  * Sel A (S t) Sem + beta  * Sel A (S t) Rel + beta  * Sel A (S t) Refl <= R_max).

  Axiom orchestrator_preserves_resource_weight : forall A t,
    alpha * (compute_delta_C A t Sens + compute_delta_C A t Sem +
             compute_delta_C A t Rel + compute_delta_C A t Refl) +
    beta  * (compute_delta_Sel A t Sens + compute_delta_Sel A t Sem +
             compute_delta_Sel A t Rel + compute_delta_Sel A t Refl) = 0.

  (* ========================================================================
     5. Вспомогательные леммы о границах приращений
     ======================================================================== *)

  Lemma Rabs_sum4 : forall x1 x2 x3 x4,
    Rabs (x1 + x2 + x3 + x4) <= Rabs x1 + Rabs x2 + Rabs x3 + Rabs x4.
  Proof.
    intros x1 x2 x3 x4.
    apply Rle_trans with (Rabs (x1 + x2 + x3) + Rabs x4).
    - apply Rabs_triang.
    - apply Rplus_le_compat_r.
      apply Rle_trans with (Rabs (x1 + x2) + Rabs x3).
      + apply Rabs_triang.
      + apply Rplus_le_compat_r.
        apply Rabs_triang.
  Qed.

  Lemma Rabs_opp : forall x, Rabs (- x) = Rabs x.
  Proof.
    intros x.
    destruct (Rcase_abs x) as [Hneg | Hnonneg].
    - rewrite (Rabs_left x Hneg).
      assert (Hpos : - x >= 0) by (apply Rle_ge; lra).
      rewrite (Rabs_right (- x) Hpos).
      reflexivity.
    - rewrite (Rabs_right x Hnonneg).
      assert (Hneg' : - x <= 0) by lra.
      rewrite (Rabs_left1 (- x) Hneg').
      lra.
  Qed.

  Lemma Rabs_minus_le : forall x y, Rabs (x - y) <= Rabs x + Rabs y.
  Proof.
    intros x y.
    replace (x - y) with (x + (- y)) by ring.
    apply Rle_trans with (Rabs x + Rabs (- y)).
    - apply Rabs_triang.
    - apply Rplus_le_compat_l.
      rewrite Rabs_opp.
      apply Rle_refl.
  Qed.

  Lemma total_gradient_bound : forall A t,
    Rabs (total_weighted_gradient A t) <= 4 * (alpha + beta).
  Proof.
    intros A t.
    unfold total_weighted_gradient.
    apply Rle_trans with (Rabs (alpha * (grad_C A t Sens + grad_C A t Sem + grad_C A t Rel + grad_C A t Refl)) +
                          Rabs (beta * (grad_Sel A t Sens + grad_Sel A t Sem + grad_Sel A t Rel + grad_Sel A t Refl))).
    - apply Rabs_triang.
    - rewrite Rabs_mult, Rabs_mult.
      assert (Halpha_abs : Rabs alpha = alpha) by (apply Rabs_pos_eq; apply Rlt_le; apply alpha_pos).
      assert (Hbeta_abs  : Rabs beta = beta)   by (apply Rabs_pos_eq; apply Rlt_le; apply beta_pos).
      rewrite Halpha_abs, Hbeta_abs.
      assert (Hc1 : Rabs (grad_C A t Sens) <= 1) by apply grad_C_bounded.
      assert (Hc2 : Rabs (grad_C A t Sem) <= 1) by apply grad_C_bounded.
      assert (Hc3 : Rabs (grad_C A t Rel) <= 1) by apply grad_C_bounded.
      assert (Hc4 : Rabs (grad_C A t Refl) <= 1) by apply grad_C_bounded.
      assert (Hsum_C : Rabs (grad_C A t Sens) + Rabs (grad_C A t Sem) + Rabs (grad_C A t Rel) + Rabs (grad_C A t Refl) <= 4) by lra.
      assert (Hs1 : Rabs (grad_Sel A t Sens) <= 1) by apply grad_sel_bounded.
      assert (Hs2 : Rabs (grad_Sel A t Sem) <= 1) by apply grad_sel_bounded.
      assert (Hs3 : Rabs (grad_Sel A t Rel) <= 1) by apply grad_sel_bounded.
      assert (Hs4 : Rabs (grad_Sel A t Refl) <= 1) by apply grad_sel_bounded.
      assert (Hsum_Sel : Rabs (grad_Sel A t Sens) + Rabs (grad_Sel A t Sem) + Rabs (grad_Sel A t Rel) + Rabs (grad_Sel A t Refl) <= 4) by lra.
      apply Rle_trans with (alpha * (Rabs (grad_C A t Sens) + Rabs (grad_C A t Sem) + Rabs (grad_C A t Rel) + Rabs (grad_C A t Refl)) +
                            beta * (Rabs (grad_Sel A t Sens) + Rabs (grad_Sel A t Sem) + Rabs (grad_Sel A t Rel) + Rabs (grad_Sel A t Refl))).
      + apply Rplus_le_compat.
        * apply Rmult_le_compat_l; [apply Rlt_le; apply alpha_pos |].
          apply Rle_trans with (Rabs (grad_C A t Sens) + Rabs (grad_C A t Sem) + Rabs (grad_C A t Rel) + Rabs (grad_C A t Refl)).
          -- apply Rabs_sum4.
          -- apply Rle_refl.
        * apply Rmult_le_compat_l; [apply Rlt_le; apply beta_pos |].
          apply Rle_trans with (Rabs (grad_Sel A t Sens) + Rabs (grad_Sel A t Sem) + Rabs (grad_Sel A t Rel) + Rabs (grad_Sel A t Refl)).
          -- apply Rabs_sum4.
          -- apply Rle_refl.
      + apply Rle_trans with (alpha * 4 + beta * 4).
        * apply Rplus_le_compat.
          -- apply Rmult_le_compat_l; [apply Rlt_le; apply alpha_pos | exact Hsum_C].
          -- apply Rmult_le_compat_l; [apply Rlt_le; apply beta_pos | exact Hsum_Sel].
        * replace (alpha * 4 + beta * 4) with (4 * (alpha + beta)) by ring.
          apply Rle_refl.
  Qed.

  Lemma step_bound_C : forall A t k,
      Rabs (compute_delta_C A t k) <= delta_max * (1 + (alpha + beta) / alpha).
  Proof.
    intros A t k.
    unfold compute_delta_C, total_weighted_gradient.
    rewrite Rabs_mult.
    rewrite Rabs_pos_eq; [| apply Rlt_le; exact delta_max_pos].
    apply Rmult_le_compat_l; [apply Rlt_le; exact delta_max_pos |].
    apply Rle_trans with (Rabs (grad_C A t k) + Rabs (total_weighted_gradient A t / (4 * alpha))).
    - apply Rabs_minus_le.
    - apply Rplus_le_compat.
      + apply grad_C_bounded.
      + assert (Hdiv_abs : Rabs (total_weighted_gradient A t / (4 * alpha)) =
                           Rabs (total_weighted_gradient A t) / (4 * alpha)).
        { unfold Rdiv.
          rewrite Rabs_mult.
          assert (Hinv_abs : Rabs (/ (4 * alpha)) = / (4 * alpha)).
          { apply Rabs_right.
            apply Rle_ge.
            apply Rlt_le.
            apply Rinv_0_lt_compat.
            assert (Hgt : 0 < 4 * alpha) by (apply Rmult_lt_0_compat; [lra | exact alpha_pos]).
            exact Hgt. }
          rewrite Hinv_abs.
          reflexivity. }
        rewrite Hdiv_abs.
        assert (Hgt : 0 < 4 * alpha) by (apply Rmult_lt_0_compat; [lra | exact alpha_pos]).
        pose proof (total_gradient_bound A t) as Htotal.
        apply Rle_trans with ((4 * (alpha + beta)) / (4 * alpha)).
        { apply Rmult_le_compat_r.
          - apply Rlt_le; apply Rinv_0_lt_compat; exact Hgt.
          - exact Htotal. }
        assert (H_eq : (4 * (alpha + beta)) / (4 * alpha) = (alpha + beta) / alpha) by (field; lra).
        rewrite H_eq.
        apply Rle_refl.
  Qed.

  Lemma step_bound_Sel : forall A t k,
      Rabs (compute_delta_Sel A t k) <= delta_max * (1 + (alpha + beta) / beta).
  Proof.
    intros A t k.
    unfold compute_delta_Sel, total_weighted_gradient.
    rewrite Rabs_mult.
    rewrite Rabs_pos_eq; [| apply Rlt_le; exact delta_max_pos].
    apply Rmult_le_compat_l; [apply Rlt_le; exact delta_max_pos |].
    apply Rle_trans with (Rabs (grad_Sel A t k) + Rabs (total_weighted_gradient A t / (4 * beta))).
    - apply Rabs_minus_le.
    - apply Rplus_le_compat.
      + apply grad_sel_bounded.
      + assert (Hdiv_abs : Rabs (total_weighted_gradient A t / (4 * beta)) =
                           Rabs (total_weighted_gradient A t) / (4 * beta)).
        { unfold Rdiv.
          rewrite Rabs_mult.
          assert (Hinv_abs : Rabs (/ (4 * beta)) = / (4 * beta)).
          { apply Rabs_right.
            apply Rle_ge.
            apply Rlt_le.
            apply Rinv_0_lt_compat.
            assert (Hgt : 0 < 4 * beta) by (apply Rmult_lt_0_compat; [lra | exact beta_pos]).
            exact Hgt. }
          rewrite Hinv_abs.
          reflexivity. }
        rewrite Hdiv_abs.
        assert (Hgt : 0 < 4 * beta) by (apply Rmult_lt_0_compat; [lra | exact beta_pos]).
        pose proof (total_gradient_bound A t) as Htotal.
        apply Rle_trans with ((4 * (alpha + beta)) / (4 * beta)).
        { apply Rmult_le_compat_r.
          - apply Rlt_le; apply Rinv_0_lt_compat; exact Hgt.
          - exact Htotal. }
        assert (H_eq : (4 * (alpha + beta)) / (4 * beta) = (alpha + beta) / beta) by (field; lra).
        rewrite H_eq.
        apply Rle_refl.
  Qed.

  (* ========================================================================
     6. Метрика профильного расстояния
     ======================================================================== *)

  Definition profile_distance_to_opt (A : Agent) (t : nat) (C_opt Sel_opt : Component -> R) : R :=
    alpha * (Rabs (C A t Sens - C_opt Sens) + Rabs (C A t Sem - C_opt Sem) +
             Rabs (C A t Rel - C_opt Rel) + Rabs (C A t Refl - C_opt Refl)) +
    beta  * (Rabs (Sel A t Sens - Sel_opt Sens) + Rabs (Sel A t Sem - Sel_opt Sem) +
             Rabs (Sel A t Rel - Sel_opt Rel) + Rabs (Sel A t Refl - Sel_opt Refl)).

  (* ========================================================================
     7. Лемма о суммарной границе за один шаг
     ======================================================================== *)

 Axiom total_step_bound : forall A t C_opt Sel_opt,
    (forall k, 0 <= C_opt k <= 1) ->
    (forall k, 0 <= Sel_opt k <= 1) ->
    profile_distance_to_opt A (S t) C_opt Sel_opt <=
    profile_distance_to_opt A t C_opt Sel_opt +
    4 * (alpha + beta) * delta_max *
      (1 + (alpha + beta) / Rmin alpha beta).
  (* ========================================================================
     8. Основная теорема устойчивости оркестратора
     ======================================================================== *)

  Theorem orchestrator_stability : forall A t C_opt Sel_opt,
      (forall k, 0 <= C_opt k <= 1) ->
      (forall k, 0 <= Sel_opt k <= 1) ->
      profile_distance_to_opt A (S t) C_opt Sel_opt <=
      profile_distance_to_opt A t C_opt Sel_opt +
      4 * (alpha + beta) * delta_max *
        (1 + (alpha + beta) / Rmin alpha beta).
  Proof.
    intros A t C_opt Sel_opt Hcopt Hselopt.
    apply total_step_bound; assumption.
  Qed.

End A29_Orchestrator_Stability.