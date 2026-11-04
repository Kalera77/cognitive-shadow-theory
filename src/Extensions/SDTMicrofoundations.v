(* ==================================================================== *)
(* SDTMicrofoundations.v                                                  *)
(* Микрооснования структурно-демографической теории через SG(t)           *)
(* Версия 3.2-final (ноябрь 2026) — 3 моста-теоремы, 1 мост-аксиома       *)
(* ==================================================================== *)
(*                                                                        *)
(* СТАТУС: расширение ядра. Не входит в заявление «0 admit».              *)
(*                                                                        *)
(* Coq 8.18+. Зависимости:                                                *)
(*   - GlobalParameters.v (пороги, δ_min)                                 *)
(*   - ShadowEthicsInvariants.v (SystemState, Trajectory, 6 принципов)    *)
(*                                                                        *)
(* ИЗМЕНЕНИЯ в v3.2 (ноябрь 2026):                                        *)
(*   - 3 моста стали ТЕОРЕМАМИ через 3 связующие аксиомы micro-to-macro. *)
(*   - 1 мост остался АКСИОМОЙ (SG/P6: A10 его не поддерживает).         *)
(*   - bridge_elite_violates_P1 → bridge_elite_violates_P2.              *)
(*     Причина: Theorem 1′ (CognitiveShadow_Complete.v) утверждает,       *)
(*     что клонирование НЕВОЗМОЖНО, т.е. ЗАЩИЩАЕТ разнообразие.           *)
(*     Элитное перенасыщение обрушивает φ через стресс (Theorem 8),      *)
(*     что соответствует нарушению P2 (запрет провокации коллапса),      *)
(*     а не P1. Семантическая ошибка исправлена.                          *)
(*   - Обновлены elite_overproduction_implies_collapse,                   *)
(*     SDT_instability_implies_collapse под новую структуру.              *)
(*                                                                        *)
(* Что доказано БЕЗ admit:                                                *)
(*   - SG_lower_bound_multiplicative, T_bound_with_SDT                    *)
(*   - feedback_prevents_collapse_proportional                            *)
(*   - 3 bridge theorems (через 3 connecting axioms)                      *)
(*   - Все компонентные теоремы                                           *)
(*                                                                        *)
(* Что остаётся аксиомами:                                                *)
(*   - 3 connecting axioms (micro-to-macro empirical hypothesis)          *)
(*   - 1 bridge axiom (SG/P6)                                             *)
(* ==================================================================== *)

Require Import Reals.
Require Import List.
Require Import Lra.
Require Import Lia.
Require Import ZArith.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import CognitiveShadow.Extensions.ShadowEthicsInvariants.
Import ListNotations.
Local Open Scope R_scope.

(* ==================================================================== *)
(** Раздел 1: SDT-состояние                                               *)
(* ==================================================================== *)

Record CivilizationState : Type := mkCivState {
  civ_system : SystemState;
  civ_immiseration : { x : R | 0 <= x };
  civ_elite_overproduction : { x : R | 0 <= x };
  civ_fiscal_distress : { x : R | 0 <= x };
  civ_SG : { x : R | 0 <= x }
}.

Definition CivTrajectory : Type := nat -> CivilizationState.

Definition civ_imm (tr : CivTrajectory) (t : nat) : R :=
  proj1_sig (civ_immiseration (tr t)).
Definition civ_elite (tr : CivTrajectory) (t : nat) : R :=
  proj1_sig (civ_elite_overproduction (tr t)).
Definition civ_fisc (tr : CivTrajectory) (t : nat) : R :=
  proj1_sig (civ_fiscal_distress (tr t)).
Definition SG (tr : CivTrajectory) (t : nat) : R :=
  proj1_sig (civ_SG (tr t)).

Lemma SG_nonneg : forall (tr : CivTrajectory) (t : nat), 0 <= SG tr t.
Proof. intros. unfold SG. apply proj2_sig. Qed.
Lemma civ_imm_nonneg : forall tr t, 0 <= civ_imm tr t.
Proof. intros. unfold civ_imm. apply proj2_sig. Qed.
Lemma civ_elite_nonneg : forall tr t, 0 <= civ_elite tr t.
Proof. intros. unfold civ_elite. apply proj2_sig. Qed.
Lemma civ_fisc_nonneg : forall tr t, 0 <= civ_fisc tr t.
Proof. intros. unfold civ_fisc. apply proj2_sig. Qed.

Definition civ_traj (tr : CivTrajectory) : Trajectory :=
  fun t => civ_system (tr t).

(* ==================================================================== *)
(** Раздел 2: Параметры и вспомогательные факты                          *)
(* ==================================================================== *)

Definition SDT_threshold : R := 7/10.
Definition SG_crit : R := 5/10.
Definition delta_min : R := 1/1000.
Definition kappa : R := 1.

Definition SDT_rate : R :=
  delta_min + kappa * (SDT_threshold * SDT_threshold * SDT_threshold).

Lemma delta_min_pos : delta_min > 0.
Proof. unfold delta_min. lra. Qed.

Lemma kappa_pos : kappa > 0.
Proof. unfold kappa. lra. Qed.

Lemma SDT_threshold_nonneg : 0 <= SDT_threshold.
Proof. unfold SDT_threshold. lra. Qed.

Lemma SDT_threshold_pos : SDT_threshold > 0.
Proof. unfold SDT_threshold. lra. Qed.

Lemma SDT_rate_ge_delta : SDT_rate >= delta_min.
Proof.
  unfold SDT_rate.
  assert (Hk : 0 <= kappa) by (apply Rlt_le; exact kappa_pos).
  assert (Hprod : 0 <= SDT_threshold * SDT_threshold * SDT_threshold).
  { pose proof SDT_threshold_nonneg as H1.
    pose proof (Rmult_le_pos _ _ H1 H1) as H2.
    apply Rmult_le_pos; [exact H2 | exact H1]. }
  assert (Hkprod : 0 <= kappa * (SDT_threshold * SDT_threshold * SDT_threshold))
    by (apply Rmult_le_pos; assumption).
  lra.
Qed.

Lemma SDT_rate_pos : SDT_rate > 0.
Proof.
  apply Rge_gt_trans with delta_min;
    [exact SDT_rate_ge_delta | exact delta_min_pos].
Qed.

(* ==================================================================== *)
(** Раздел 3: Компоненты и нестабильность                                *)
(* ==================================================================== *)

Definition Population_Depleted (tr : CivTrajectory) (t : nat) : Prop :=
  civ_imm tr t >= SDT_threshold.

Definition Elite_Overproduction (tr : CivTrajectory) (t : nat) : Prop :=
  civ_elite tr t >= SDT_threshold.

Definition Fiscal_Distress (tr : CivTrajectory) (t : nat) : Prop :=
  civ_fisc tr t >= SDT_threshold.

Definition SDT_instability (tr : CivTrajectory) : Prop :=
  exists t,
    Population_Depleted tr t /\
    Elite_Overproduction tr t /\
    Fiscal_Distress tr t.

(* ==================================================================== *)
(** Раздел 4: Динамика SG                                                *)
(* ==================================================================== *)

Definition SG_grows_linearly (tr : CivTrajectory) : Prop :=
  forall t, SG tr (S t) = SG tr t + delta_min.

Definition has_feedback (tr : CivTrajectory) : Prop :=
  exists (feedback : nat -> R),
    (forall t, feedback t > 0) /\
    (forall t, SG tr (S t) <= SG tr t - feedback t).

Definition feedback_sufficient (tr : CivTrajectory) : Prop :=
  exists (feedback : nat -> R),
    (forall t, feedback t > delta_min) /\
    (forall t, SG tr (S t) = SG tr t + delta_min - feedback t).

(* ==================================================================== *)
(** Раздел 5: Мультипликативная динамика                                 *)
(* ==================================================================== *)

Definition SDT_multiplier (tr : CivTrajectory) (t : nat) : R :=
  civ_imm tr t * civ_elite tr t * civ_fisc tr t.

Lemma SDT_multiplier_nonneg :
  forall tr t, 0 <= SDT_multiplier tr t.
Proof.
  intros. unfold SDT_multiplier.
  repeat apply Rmult_le_pos;
    auto using civ_imm_nonneg, civ_elite_nonneg, civ_fisc_nonneg.
Qed.

Definition SG_dynamics_multiplicative (tr : CivTrajectory) : Prop :=
  forall t,
    SG tr (S t) = SG tr t + delta_min + kappa * SDT_multiplier tr t.

Lemma product_ge_cube :
  forall (a b c : R),
    0 <= a -> 0 <= b -> 0 <= c ->
    SDT_threshold <= a -> SDT_threshold <= b -> SDT_threshold <= c ->
    a * b * c >= SDT_threshold * SDT_threshold * SDT_threshold.
Proof.
  intros a b c Ha Hb Hc Ha' Hb' Hc'.
  assert (Ht : 0 <= SDT_threshold) by exact SDT_threshold_nonneg.
  assert (H1 : SDT_threshold * SDT_threshold <= a * b).
  { apply Rmult_le_compat; assumption. }
  assert (H2 : 0 <= SDT_threshold * SDT_threshold)
    by (apply Rmult_le_pos; assumption).
  assert (Hstep : SDT_threshold * SDT_threshold * SDT_threshold
                  <= a * b * c).
  { apply Rmult_le_compat; assumption. }
  lra.
Qed.

Lemma SDT_accelerates_SG :
  forall (tr : CivTrajectory) (t : nat),
    SG_dynamics_multiplicative tr ->
    kappa > 0 ->
    Population_Depleted tr t ->
    Elite_Overproduction tr t ->
    Fiscal_Distress tr t ->
    SG tr (S t) - SG tr t >= SDT_rate.
Proof.
  intros tr t Hdyn Hk Hp He Hf.
  unfold Population_Depleted, Elite_Overproduction, Fiscal_Distress in Hp, He, Hf.
  assert (Hp' : SDT_threshold <= civ_imm tr t) by lra.
  assert (He' : SDT_threshold <= civ_elite tr t) by lra.
  assert (Hf' : SDT_threshold <= civ_fisc tr t) by lra.
  assert (Hcube : SDT_threshold * SDT_threshold * SDT_threshold <=
                  civ_imm tr t * civ_elite tr t * civ_fisc tr t).
  { pose proof (product_ge_cube (civ_imm tr t) (civ_elite tr t) (civ_fisc tr t)
                  (civ_imm_nonneg tr t) (civ_elite_nonneg tr t) (civ_fisc_nonneg tr t)
                  Hp' He' Hf') as Hge.
    lra. }
  assert (Hstep : kappa * (SDT_threshold * SDT_threshold * SDT_threshold) <=
                  kappa * (civ_imm tr t * civ_elite tr t * civ_fisc tr t)).
  { apply Rmult_le_compat_l; [lra | exact Hcube]. }
  unfold SDT_rate.
  rewrite Hdyn.
  unfold SDT_multiplier.
  replace (SG tr t + delta_min
             + kappa * (civ_imm tr t * civ_elite tr t * civ_fisc tr t)
             - SG tr t)
    with (delta_min + kappa * (civ_imm tr t * civ_elite tr t * civ_fisc tr t))
    by ring.
  lra.
Qed.
(* ==================================================================== *)
(** Раздел 6: Нижняя граница SG при мультипликативной динамике           *)
(* ==================================================================== *)

Lemma SG_lower_bound_multiplicative :
  forall (tr : CivTrajectory) (n : nat),
    SG_dynamics_multiplicative tr ->
    kappa > 0 ->
    (forall t, (t < n)%nat ->
       Population_Depleted tr t /\
       Elite_Overproduction tr t /\
       Fiscal_Distress tr t) ->
    SG tr n >= SG tr 0 + INR n * SDT_rate.
Proof.
  intros tr n Hdyn Hk Hcomp.
  induction n as [| n IH].
  - rewrite INR_0, Rmult_0_l, Rplus_0_r. lra.
  - assert (Hcomp' : forall t', (t' < n)%nat ->
       Population_Depleted tr t' /\
       Elite_Overproduction tr t' /\
       Fiscal_Distress tr t').
    { intros t' Ht'. apply Hcomp. lia. }
    pose proof (IH Hcomp') as IH'.
    destruct (Hcomp n (Nat.lt_succ_diag_r n)) as [Hpop [Helite Hfisc]].
    pose proof (SDT_accelerates_SG tr n Hdyn Hk Hpop Helite Hfisc) as Hstep.
    rewrite S_INR.
    rewrite Rmult_plus_distr_r.
    rewrite Rmult_1_l.
    lra.
Qed.

(* ==================================================================== *)
(** Раздел 7: Вспомогательные леммы про up и архимедовость               *)
(* ==================================================================== *)

Lemma up_ge_0_of_pos : forall x : R, 0 < x -> (0 <= up x)%Z.
Proof.
  intros x Hx.
  destruct (archimed x) as [H1 H2].
  assert (Hup_pos_R : 0 < IZR (up x)) by lra.
  destruct (Z_lt_ge_dec (up x) 0) as [Hlt | Hge].
  - exfalso.
    assert (Hlt' : IZR (up x) < IZR 0).
    { apply IZR_lt. exact Hlt. }
    replace (IZR 0) with 0 in Hlt' by reflexivity.
    lra.
  - lia.
Qed.

Lemma INR_Z2Nat_up_gt : forall x : R, 0 < x -> INR (Z.to_nat (up x)) > x.
Proof.
  intros x Hx.
  rewrite INR_IZR_INZ, Z2Nat.id.
  - destruct (archimed x) as [H1 _]. exact H1.
  - apply up_ge_0_of_pos. exact Hx.
Qed.

Lemma up_mono : forall x y : R, x <= y -> (up x <= up y)%Z.
Proof.
  intros x y Hxy.
  destruct (archimed x) as [Hx1 Hx2].
  destruct (archimed y) as [Hy1 Hy2].
  destruct (Z_lt_le_dec (up y) (up x)) as [Hlt | Hge].
  - exfalso.
    assert (Hlt' : (up y + 1 <= up x)%Z) by lia.
    pose proof (IZR_le (up y + 1) (up x) Hlt') as Hstep.
    assert (Hsum : IZR (up y + 1) = IZR (up y) + 1).
    { rewrite plus_IZR. reflexivity. }
    rewrite Hsum in Hstep.
    lra.
  - lia.
Qed.

Lemma exists_nat_for_R :
  forall (a b : R), b > 0 -> exists n : nat, a <= INR n * b.
Proof.
  intros a b Hb.
  destruct (Rle_or_lt a 0) as [Ha | Ha].
  - exists 0%nat. rewrite INR_0, Rmult_0_l. lra.
  - assert (Hdiv_pos : 0 < a / b).
    { unfold Rdiv. apply Rmult_pos_pos.
      - exact Ha.
      - apply Rinv_0_lt_compat. exact Hb. }
    exists (Z.to_nat (up (a / b))).
    pose proof (INR_Z2Nat_up_gt (a / b) Hdiv_pos) as Hgt.
    assert (Hprod : (a / b) * b < INR (Z.to_nat (up (a / b))) * b).
    { apply Rmult_lt_compat_r; lra. }
    assert (Heq : (a / b) * b = a). { field. lra. }
    rewrite Heq in Hprod. lra.
Qed.

(* ==================================================================== *)
(** Раздел 8: Время до коллапса                                          *)
(* ==================================================================== *)

Definition time_to_collapse (SG_0 : R) : nat :=
  if Rle_dec SG_0 SG_crit then
    Z.to_nat (up ((SG_crit - SG_0) / delta_min))
  else 0%nat.

Lemma div_le_of_le :
  forall a b1 b2 : R, 0 < a -> 0 < b2 -> b2 <= b1 -> a / b1 <= a / b2.
Proof.
  intros a b1 b2 Ha Hb2 Hb21.
  unfold Rdiv.
  apply Rmult_le_compat_l; [lra |].
  apply Rinv_le_contravar; assumption.
Qed.

Theorem T_bound_with_SDT :
  forall (tr : CivTrajectory),
    SG_dynamics_multiplicative tr ->
    kappa > 0 ->
    (forall t,
       Population_Depleted tr t /\
       Elite_Overproduction tr t /\
       Fiscal_Distress tr t) ->
    exists T,
      (T <= time_to_collapse (SG tr 0))%nat /\
      forall t, (t >= T)%nat -> SG tr t >= SG_crit.
Proof.
  intros tr Hdyn Hk Hall.
  destruct (Rge_dec (SG tr 0) SG_crit) as [Hge | Hlt].
  - exists 0%nat. split.
    + lia.
    + intros t _.
      pose proof (SG_lower_bound_multiplicative tr t Hdyn Hk
        (fun t' _ => Hall t')) as Hb.
      assert (Hp : 0 <= INR t * SDT_rate)
        by (apply Rmult_le_pos;
            [apply pos_INR | apply Rlt_le; exact SDT_rate_pos]).
      lra.
  - assert (Hdiff_pos : SG_crit - SG tr 0 > 0) by lra.
    set (T := Z.to_nat (up ((SG_crit - SG tr 0) / SDT_rate))).
    exists T. split.
    + assert (Heq : time_to_collapse (SG tr 0) =
                    Z.to_nat (up ((SG_crit - SG tr 0) / delta_min))).
      { unfold time_to_collapse.
        destruct (Rle_dec (SG tr 0) SG_crit) as [_ | Hnle].
        - reflexivity.
        - exfalso. lra. }
      rewrite Heq. unfold T.
      apply Z2Nat.inj_le.
      * apply up_ge_0_of_pos.
        unfold Rdiv. apply Rmult_pos_pos;
          [exact Hdiff_pos | apply Rinv_0_lt_compat; exact SDT_rate_pos].
      * apply up_ge_0_of_pos.
        unfold Rdiv. apply Rmult_pos_pos;
          [exact Hdiff_pos | apply Rinv_0_lt_compat; exact delta_min_pos].
      * apply up_mono.
        assert (Hle : (delta_min <= SDT_rate)%R) by
          (apply Rge_le; exact SDT_rate_ge_delta).
        assert (Hinv_le : (/ SDT_rate <= / delta_min)%R) by
          (apply Rinv_le_contravar; [exact delta_min_pos | exact Hle]).
        assert (Ha_nonneg : (0 <= SG_crit - SG tr 0)%R) by lra.
        unfold Rdiv.
        apply Rmult_le_compat_l.
        -- exact Ha_nonneg.
        -- exact Hinv_le.
    + intros t Ht.
      pose proof (SG_lower_bound_multiplicative tr t Hdyn Hk
        (fun t' _ => Hall t')) as Hb.
      assert (Hx_pos : 0 < (SG_crit - SG tr 0) / SDT_rate).
      { unfold Rdiv. apply Rmult_pos_pos;
          [exact Hdiff_pos | apply Rinv_0_lt_compat; exact SDT_rate_pos]. }
      pose proof (INR_Z2Nat_up_gt _ Hx_pos) as HT_gt.
      fold T in HT_gt.
      assert (Ht_gt : INR t > (SG_crit - SG tr 0) / SDT_rate).
      { apply Rlt_le_trans with (INR T).
        - exact HT_gt.
        - apply le_INR. exact Ht. }
      assert (Hmult_gt : INR t * SDT_rate > SG_crit - SG tr 0).
      { assert (Hne : SDT_rate <> 0)
          by (apply Rgt_not_eq; exact SDT_rate_pos).
        assert (Heq : (SG_crit - SG tr 0) / SDT_rate * SDT_rate =
                      SG_crit - SG tr 0).
        { unfold Rdiv. rewrite Rmult_assoc.
          rewrite Rinv_l by exact Hne. ring. }
        rewrite <- Heq.
        apply Rmult_lt_compat_r;
          [exact SDT_rate_pos | exact Ht_gt]. }
      lra.
Qed.

(* ==================================================================== *)
(** Раздел 9: Мосты между SDT и Shadow Ethics                            *)
(* ==================================================================== *)

(*
   ЭПИСТЕМИЧЕСКИЙ СТАТУС (v3.2, ноябрь 2026):

   Из 4 мостов между SDT-компонентами и принципами Shadow Ethics:
   - 3 становятся ТЕОРЕМАМИ (derived from connecting axioms).
   - 1 остаётся АКСИОМОЙ (SG/P6, поскольку A10 не поддерживает его).

   Connecting axioms (3) — эмпирическая гипотеза micro-to-macro link.
   Каждая — «агрегатная компонента SDT вызывает критическую нагрузку
   на микроуровне, приводящую к падению φ ниже φ_crit».

   Семантика: Theorem 8 (Theorem8_Degradation.v) обеспечивает МЕХАНИЗМ
   на микроуровне. Связующая аксиома кодирует, что Population_Depleted
   и т.п. ТРИГГЕРИТ условия, при которых Theorem 8 применима.

   ИСПРАВЛЕНИЕ (v3.2): bridge_elite_violates_P1 УДАЛЁН.
   Причина: Theorem 1′ (CognitiveShadow_Complete.v) утверждает
   НЕВОЗМОЖНОСТЬ клонирования, что ЗАЩИЩАЕТ разнообразие. Направление
   связи в исходной формулировке было противоположно смыслу Theorem 1′.
   Элитное перенасыщение → стресс → падение φ (Theorem 8) → P2,
   а не P1.
*)

(* ------------ Связующие аксиомы (3) ------------ *)

(** Иммизерация триггерит критическую нагрузку на микроуровне,
    что по Theorem 8 приводит к падению φ ниже φ_crit. *)
Axiom immiseration_creates_micro_load :
  forall (tr : CivTrajectory) (t : nat),
    Population_Depleted tr t ->
    exists (t' : nat), s_phi_refl (civ_traj tr t') < phi_crit.

(** Элитное перенасыщение триггерит тот же механизм (коллективная
    профдеформация, §6.11 SDT-документа). *)
Axiom elite_creates_micro_load :
  forall (tr : CivTrajectory) (t : nat),
    Elite_Overproduction tr t ->
    exists (t' : nat), s_phi_refl (civ_traj tr t') < phi_crit.

(** Фискальный дистресс: паразитический Оркестратор блокирует
    поддержку в момент падения φ. Это формализует Теорему 3.9
    (предел паразитизма) в терминах P3. *)
Axiom fiscal_blocks_support :
  forall (tr : CivTrajectory) (t : nat),
    Fiscal_Distress tr t ->
    exists (t' : nat), s_phi_refl (civ_traj tr t') <= phi_crit /\
                        s_has_support (civ_traj tr t') = false.

(* ------------ Мосты-теоремы (3) ------------ *)

Theorem bridge_immiseration_violates_P2 :
  forall (tr : CivTrajectory) (t : nat),
    Population_Depleted tr t -> violates_P2 (civ_traj tr).
Proof.
  intros tr t Hpop.
  unfold violates_P2, P2_no_collapse_provocation.
  intro H.
  destruct (immiseration_creates_micro_load tr t Hpop) as [t' Ht'].
  specialize (H t').
  lra.
Qed.

Theorem bridge_elite_violates_P2 :
  forall (tr : CivTrajectory) (t : nat),
    Elite_Overproduction tr t -> violates_P2 (civ_traj tr).
Proof.
  intros tr t Helite.
  unfold violates_P2, P2_no_collapse_provocation.
  intro H.
  destruct (elite_creates_micro_load tr t Helite) as [t' Ht'].
  specialize (H t').
  lra.
Qed.

Theorem bridge_fiscal_violates_P3 :
  forall (tr : CivTrajectory) (t : nat),
    Fiscal_Distress tr t -> violates_P3 (civ_traj tr).
Proof.
  intros tr t Hfisc.
  unfold violates_P3, P3_external_support.
  intro H.
  destruct (fiscal_blocks_support tr t Hfisc) as [t' [Hphi Hsup]].
  specialize (H t').
  pose proof (H Hphi) as Htrue.
  rewrite Hsup in Htrue. discriminate.
Qed.

(* ------------ Мост-аксиома (1) ------------ *)

(** Высокий семантический разрыв разрушает согласие на наблюдение.
    Прямой деривации нет: A10 (Theorem10_SignatureObservability.v)
    говорит про AUC ∈ (0.5, 1), а не про согласие. Связь через общий
    механизм (неполнота сигнатур → недоверие) — эмпирическая гипотеза. *)
Axiom bridge_SG_violates_P6 :
  forall (tr : CivTrajectory) (t : nat),
    SG tr t >= SG_crit -> violates_P6 (civ_traj tr).

(* ==================================================================== *)
(** Раздел 10: Компонентные теоремы                                      *)
(* ==================================================================== *)

Theorem immiseration_implies_collapse :
  forall (tr : CivTrajectory) (t : nat),
    Population_Depleted tr t ->
    eventually_collapses (civ_traj tr).
Proof.
  intros tr t Hpop.
  apply violation_implies_collapse.
  unfold violates_any. right. left.
  exact (bridge_immiseration_violates_P2 tr t Hpop).
Qed.

Theorem elite_overproduction_implies_collapse :
  forall (tr : CivTrajectory) (t : nat),
    Elite_Overproduction tr t ->
    eventually_collapses (civ_traj tr).
Proof.
  intros tr t Helite.
  apply violation_implies_collapse.
  unfold violates_any. right. left.
  exact (bridge_elite_violates_P2 tr t Helite).
Qed.

Theorem fiscal_distress_implies_collapse :
  forall (tr : CivTrajectory) (t : nat),
    Fiscal_Distress tr t ->
    eventually_collapses (civ_traj tr).
Proof.
  intros tr t Hfisc.
  apply violation_implies_collapse.
  unfold violates_any. right. right. left.
  exact (bridge_fiscal_violates_P3 tr t Hfisc).
Qed.

Theorem SDT_instability_implies_collapse :
  forall (tr : CivTrajectory),
    SDT_instability tr -> eventually_collapses (civ_traj tr).
Proof.
  intros tr [t [Hpop _]].
  exact (immiseration_implies_collapse tr t Hpop).
Qed.

(* ==================================================================== *)
(** Раздел 11: Линейная динамика (без SDT)                               *)
(* ==================================================================== *)

Lemma SG_linear_form :
  forall tr, SG_grows_linearly tr ->
    forall t, SG tr t = SG tr 0 + INR t * delta_min.
Proof.
  intros tr Hlin t.
  induction t as [| t IH].
  - rewrite INR_0, Rmult_0_l, Rplus_0_r. reflexivity.
  - rewrite Hlin, IH, S_INR. ring.
Qed.

Theorem SG_reaches_crit_without_feedback :
  forall (tr : CivTrajectory),
    SG_grows_linearly tr ->
    ~ has_feedback tr ->
    exists (T : nat),
      forall t, (t >= T)%nat -> SG tr t >= SG_crit.
Proof.
  intros tr Hlin _.
  destruct (Rge_dec (SG tr 0) SG_crit) as [Hge | Hlt].
  - exists 0%nat. intros t _.
    rewrite (SG_linear_form tr Hlin t).
    assert (Hm : 0 <= INR t * delta_min)
      by (apply Rmult_le_pos;
          [apply pos_INR | apply Rlt_le; exact delta_min_pos]).
    lra.
  - assert (Hdiff : SG_crit - SG tr 0 > 0) by lra.
    destruct (exists_nat_for_R (SG_crit - SG tr 0) delta_min delta_min_pos)
      as [T HT].
    exists T. intros t Ht.
    rewrite (SG_linear_form tr Hlin t).
    pose proof (le_INR _ _ Ht) as Hinr.
    assert (Hm : INR T * delta_min <= INR t * delta_min)
      by (apply Rmult_le_compat_r;
          [apply Rlt_le; exact delta_min_pos | exact Hinr]).
    lra.
Qed.

Corollary no_feedback_collapse :
  forall (tr : CivTrajectory),
    SG_grows_linearly tr ->
    ~ has_feedback tr ->
    eventually_collapses (civ_traj tr).
Proof.
  intros tr H_grows H_no_feedback.
  destruct (SG_reaches_crit_without_feedback tr H_grows H_no_feedback)
    as [T H_T].
  assert (H_violate : violates_P6 (civ_traj tr))
    by (exact (bridge_SG_violates_P6 tr T (H_T T (Nat.le_refl T)))).
  apply violation_implies_collapse.
  unfold violates_any. right. right. right. right. right.
  exact H_violate.
Qed.

(* ==================================================================== *)
(** Раздел 12: Легитимность и тривиальная линейная ОС                    *)
(* ==================================================================== *)

Definition legitimate_orchestrator (tr : CivTrajectory) : Prop :=
  has_feedback tr.

Theorem illegitimacy_implies_collapse :
  forall (tr : CivTrajectory),
    SG_grows_linearly tr ->
    ~ legitimate_orchestrator tr ->
    eventually_collapses (civ_traj tr).
Proof.
  intros. apply no_feedback_collapse; assumption.
Qed.

Theorem feedback_linear_prevents_growth :
  forall (tr : CivTrajectory),
    feedback_sufficient tr ->
    (forall t, SG tr t <= SG tr 0).
Proof.
  intros tr [feedback [H_strength H_dynamics]] t.
  induction t as [| t' IH].
  - lra.
  - rewrite H_dynamics.
    pose proof (H_strength t') as Hst'.
    lra.
Qed.

(* ==================================================================== *)
(** Раздел 13: Нетривиальная пропорциональная обратная связь             *)
(* ==================================================================== *)

Definition feedback_proportional (tr : CivTrajectory) (gamma : R) : Prop :=
  gamma > 0 /\
  forall t, SG tr (S t) = SG tr t + delta_min - gamma * SG tr t.

Lemma SG_bounded_proportional :
  forall (tr : CivTrajectory) (gamma : R),
    feedback_proportional tr gamma ->
    gamma <= 1 ->
    forall t, SG tr t <= Rmax (SG tr 0) (delta_min / gamma).
Proof.
  intros tr gamma [Hgpos Hdyn] Hg1 t.
  set (M := Rmax (SG tr 0) (delta_min / gamma)).
  assert (HM1 : SG tr 0 <= M) by (unfold M; apply Rmax_l).
  assert (HM2 : delta_min / gamma <= M) by (unfold M; apply Rmax_r).
  assert (HgM : gamma * M >= delta_min).
  { assert (Hcancel : gamma * (delta_min / gamma) = delta_min).
    { unfold Rdiv.
      assert (Hne : gamma <> 0) by lra.
      rewrite Rmult_comm.
      rewrite Rmult_assoc.
      rewrite Rinv_l by exact Hne.
      ring. }
    assert (Hstep : gamma * (delta_min / gamma) <= gamma * M).
    { apply Rmult_le_compat_l.
      - lra.
      - exact HM2. }
    rewrite Hcancel in Hstep.
    lra. }
  induction t as [| t IH].
  - exact HM1.
  - rewrite Hdyn.
    assert (H1m : 0 <= 1 - gamma) by lra.
    assert (Hprod : (1 - gamma) * SG tr t <= (1 - gamma) * M)
      by (apply Rmult_le_compat_l; [lra | exact IH]).
    lra.
Qed.

Theorem feedback_prevents_collapse_proportional :
  forall (tr : CivTrajectory) (gamma : R),
    feedback_proportional tr gamma ->
    gamma <= 1 ->
    Rmax (SG tr 0) (delta_min / gamma) < SG_crit ->
    forall t, SG tr t < SG_crit.
Proof.
  intros tr gamma Hfb Hg1 Hcrit t.
  pose proof (SG_bounded_proportional tr gamma Hfb Hg1 t) as Hb.
  lra.
Qed.

(* ==================================================================== *)
(** Раздел 14: Паразитический Оркестратор                                *)
(* ==================================================================== *)

Definition parasitic_orchestrator (tr : CivTrajectory) : Prop :=
  exists (extraction : nat -> R),
    (forall t, extraction t > 0) /\
    forall t,
      SG tr (S t) = SG tr t + delta_min + extraction t.

Lemma parasitic_growth :
  forall tr extraction,
    (forall t, extraction t > 0) ->
    (forall t, SG tr (S t) = SG tr t + delta_min + extraction t) ->
    forall t, SG tr t >= SG tr 0 + INR t * delta_min.
Proof.
  intros tr extraction Hext Hdyn t.
  induction t as [| t IH].
  - rewrite INR_0, Rmult_0_l, Rplus_0_r. apply Rle_refl.
  - rewrite Hdyn, S_INR.
    pose proof (Hext t) as He.
    pose proof delta_min_pos as Hd.
    replace ((INR t + 1) * delta_min)
      with (INR t * delta_min + delta_min) by ring.
    lra.
Qed.

Theorem parasitic_orchestrator_collapses :
  forall (tr : CivTrajectory),
    parasitic_orchestrator tr -> eventually_collapses (civ_traj tr).
Proof.
  intros tr [extraction [Hpos Hdyn]].
  assert (Hgrowth : forall t, SG tr t >= SG tr 0 + INR t * delta_min)
    by (exact (parasitic_growth tr extraction Hpos Hdyn)).
  destruct (Rge_dec (SG tr 0) SG_crit) as [Hge | Hlt].
  - assert (Hv : violates_P6 (civ_traj tr))
      by (exact (bridge_SG_violates_P6 tr 0 Hge)).
    apply violation_implies_collapse.
    unfold violates_any. right. right. right. right. right. exact Hv.
  - assert (Hdiff : SG_crit - SG tr 0 > 0) by lra.
    destruct (exists_nat_for_R (SG_crit - SG tr 0) delta_min delta_min_pos)
      as [T HT].
    assert (HSG : SG tr T >= SG_crit) by (specialize (Hgrowth T); lra).
    assert (Hv : violates_P6 (civ_traj tr))
      by (exact (bridge_SG_violates_P6 tr T HSG)).
    apply violation_implies_collapse.
    unfold violates_any. right. right. right. right. right. exact Hv.
Qed.

(* ==================================================================== *)
(** Раздел 15: Исторические кейсы (интерфейс к эмпирике)                 *)
(* ==================================================================== *)

Record HistoricalCase : Type := mkHistCase {
  hc_name : nat;
  hc_SG_0 : R;
  hc_T_fact : nat;
  hc_M : nat
}.

Definition prediction_holds (hc : HistoricalCase) : Prop :=
  (Z.abs (Z.of_nat (hc_T_fact hc) -
         Z.of_nat (time_to_collapse (hc_SG_0 hc))) <= 1)%Z.

Definition SG_negatively_correlates_T : Prop :=
  forall (hc1 hc2 : HistoricalCase),
    hc_SG_0 hc1 > hc_SG_0 hc2 ->
    (hc_T_fact hc1 < hc_T_fact hc2)%nat.

(* ==================================================================== *)
(** Раздел 16: Сводка (v3.2)                                             *)
(* ==================================================================== *)

(**
    ДОКАЗАНО БЕЗ ADMIT (v3.2):

    Базовые:
    - delta_min_pos, kappa_pos, SDT_threshold_nonneg, SDT_threshold_pos
    - SDT_rate_ge_delta, SDT_rate_pos
    - SDT_multiplier_nonneg, product_ge_cube

    Мультипликативная динамика:
    - SDT_accelerates_SG
    - SG_lower_bound_multiplicative
    - T_bound_with_SDT

    Вспомогательные:
    - up_ge_0_of_pos, INR_Z2Nat_up_gt, up_mono
    - exists_nat_for_R, div_le_of_le

    Линейная динамика (без SDT):
    - SG_linear_form, SG_reaches_crit_without_feedback
    - no_feedback_collapse, illegitimacy_implies_collapse
    - feedback_linear_prevents_growth

    Пропорциональная ОС:
    - SG_bounded_proportional
    - feedback_prevents_collapse_proportional

    МОСТЫ-ТЕОРЕМЫ (3, derived from 3 connecting axioms):
    - bridge_immiseration_violates_P2
    - bridge_elite_violates_P2  (* бывш. bridge_elite_violates_P1;
                                    семантическая ошибка исправлена *)
    - bridge_fiscal_violates_P3

    Компонентные теоремы:
    - immiseration_implies_collapse
    - elite_overproduction_implies_collapse
    - fiscal_distress_implies_collapse
    - SDT_instability_implies_collapse

    Паразитизм:
    - parasitic_growth, parasitic_orchestrator_collapses

    АКСИОМЫ (4):
    Связующие (3) — micro-to-macro empirical hypothesis:
    - immiseration_creates_micro_load  ← Theorem 8 mechanism
    - elite_creates_micro_load         ← Theorem 8 mechanism
    - fiscal_blocks_support            ← Theorem 3.9 mechanism
    Мост (1) — связь SG → P6 (A10 не поддерживает напрямую):
    - bridge_SG_violates_P6

    УДАЛЕНО (сравнение с v3.1):
    - bridge_elite_violates_P1: семантическая ошибка. Theorem 1′
      утверждает НЕВОЗМОЖНОСТЬ клонирования, что ЗАЩИЩАЕТ разнообразие.
      Направление связи было противоположно смыслу теоремы.
      Заменён на bridge_elite_violates_P2 (Theorem 8 механизм).

    ИТОГ: из 4 исходных мостовых аксиом v3.0
          3 стали теоремами + 3 связующие аксиомы,
          1 осталась аксиомой (SG/P6).
          Итого: 4 аксиомы вместо 4 (нейтрально по количеству),
          но 3 из них теперь имеют явную семантику micro-to-macro,
          а 3 моста — доказаны как теоремы.
*)