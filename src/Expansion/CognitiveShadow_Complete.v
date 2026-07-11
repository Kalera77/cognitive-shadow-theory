(** * CognitiveShadow_Complete.v — complete constructive proof of Theorem 1' (version 5.1) *)

(*
  Russian:
  В этом модуле собрано полное формальное доказательство центральной
  Теоремы 1' о существовании когнитивной тени. Доказательство построено
  так, что оно может опираться либо на квантовую непредсказуемость (A2),
  либо на тривиальное квалиа — в зависимости от глобального флага
  UseQuantumAxiom.

  English:
  Complete constructive proof of Theorem 1' on the existence of a
  cognitive shadow. The proof can rely either on quantum unpredictability
  (A2) or on a trivial qualia, depending on the global flag
  UseQuantumAxiom.
*)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lia.
Require Import Coq.micromega.Lra.
Require Import Coq.Arith.Arith.
Require Import Coq.Lists.List.
Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Principles.AlgorithmicEntropy.
Import ListNotations.

Open Scope R_scope.

Section CoreAxioms.

(* ------------------------------------------------------------------------ *)
(* Basic types and axioms                                                   *)
(* ------------------------------------------------------------------------ *)

(* Agent type *)
Parameter Agent : Type.
(* Qualia type *)
Parameter Qualia : Type.
(* Time type *)
Parameter Time : Type.
Parameter current_qualia : Agent -> Time -> Qualia.
Parameter any_time : Time.
Parameter agent_can_perceive_quantum : Agent -> Prop.

Parameter QState : Type.
Parameter outcome_of : QState -> Qualia.
Parameter fixed_state : QState.

(* Axiom A2: quantum unpredictability *)
Axiom A2_quantum :
  forall (A : Agent) (P : QState),
    agent_can_perceive_quantum A ->
    exists t, current_qualia A t = outcome_of P.

(* Flag controlling the use of the quantum axiom *)
Parameter UseQuantumAxiom : bool.

(* Dummy qualia for when quantum axiom is disabled *)
Parameter q_dummy : Qualia.
Axiom q_dummy_exists : forall A, exists t, current_qualia A t = q_dummy.

(* Formal system (Peano arithmetic) *)
Inductive Formula : Type :=
| FTrue
| FFalse
| FEq (t1 t2 : nat)
| FNot (f : Formula)
| FAnd (f1 f2 : Formula)
| FExists (f : Formula).

(* Gödel numbering *)
Parameter code_Formula : Formula -> nat.
Parameter code_Proof : list nat -> nat.

(* Validity check for a proof *)
Parameter ValidProof : Formula -> list nat -> Prop.

(* Primitive recursive relation Proof(x,y) *)
Parameter Proof_rel : nat -> nat -> Prop.
Axiom Proof_rel_correct : forall f p,
  ValidProof f p <-> Proof_rel (code_Proof p) (code_Formula f).

(* Formal system FS *)
Parameter FormalSystem : Type.
Parameter FS : FormalSystem.
Parameter contains_arithmetic : FormalSystem -> Prop.
Parameter Provable : FormalSystem -> Formula -> Prop.

Axiom Provable_sound : forall s f, Provable s f -> exists p, ValidProof f p.

(* Gödel sentence *)
Parameter GodelSentence : FormalSystem -> Formula.

Axiom GodelSentence_prop : forall s, contains_arithmetic s ->
  (Provable s (GodelSentence s) <-> ~ Provable s (FNot (GodelSentence s))).

Definition Equiv (P Q : Prop) := (P -> Q) /\ (Q -> P).

(* Resource bound: L_max = M *)
Definition L_max : nat := M.

Definition Provable_Bounded (s : FormalSystem) (f : Formula) : Prop :=
  exists p, ValidProof f p /\ (length p <= L_max)%nat.

Axiom Provable_Bounded_implies_Provable :
  forall s f, Provable_Bounded s f -> Provable s f.

(* Axiom A8*: resource bridge *)
Axiom A8_resource_bridge :
  forall (s : FormalSystem) (G : Formula),
    contains_arithmetic s ->
    (Provable s G <-> ~ Provable s (FNot G)) ->
    Provable_Bounded s G -> False.

(* Mapping from qualia to formulas and vice versa *)
Parameter godel_qualia : FormalSystem -> Formula -> Qualia.
Axiom godel_qualia_injective :
  forall s G1 G2, godel_qualia s G1 = godel_qualia s G2 ->
    Equiv (Provable s G1) (Provable s G2).

(* Digitization class *)
Class Digitization (A : Agent) (S_type : Type) := {
  encode : Qualia -> S_type;
  decode : S_type -> Qualia;
  enc_dec : forall q, decode (encode q) = q;
  dec_enc : forall x, encode (decode x) = x;
}.

(* Composability of qualia *)
Parameter qualia_pair : Qualia -> Qualia -> Qualia.
Parameter qualia_fst : Qualia -> Qualia.
Axiom A5_proj : forall q1 q2, qualia_fst (qualia_pair q1 q2) = q1.
Axiom A5_pair_exists : forall A q1 q2,
  exists t, current_qualia A t = qualia_pair q1 q2.
Axiom A5_decomp : forall A q1 q2,
  (exists t, current_qualia A t = qualia_pair q1 q2) ->
  exists t, current_qualia A t = q1.

(* Transmission and degradation of formalizability *)
Parameter transfer : Agent -> Agent -> Qualia -> Time -> Channel -> Prop.

Parameter Formalizability : Qualia -> R.
Parameter SourceQualia : Qualia -> Qualia.
Axiom max_formalizability : forall q, Formalizability q <= 1.

(* Axiom A4_star: transmission degrades formalizability *)
Axiom A4_star : forall A B q t ch,
  transfer A B q t ch ->
  Formalizability q <= Formalizability (SourceQualia q) - eta_degradation * (1 - fidelity ch).

(* Lemma: any transmitted quale has formalizability ≤ QuarantineThreshold *)
Lemma transfer_below_threshold : forall A B q t ch,
  transfer A B q t ch ->
  Formalizability q <= QuarantineThreshold.
Proof.
  intros A B q t ch Htrans.
  pose proof (A4_star A B q t ch Htrans) as H_phi.
  pose proof (max_formalizability (SourceQualia q)) as H_source.
  pose proof (fidelity_le_max ch) as Hfid.
  pose proof (eta_degradation_pos) as Heta_pos.
  pose proof (max_fidelity_lt1) as Hmax_lt1.
  
  assert (H_one_minus : 1 - fidelity ch >= 1 - max_fidelity).
  { apply Rle_ge.
    apply (Rplus_le_reg_l (fidelity ch + max_fidelity)).
    replace (fidelity ch + max_fidelity + (1 - fidelity ch)) with (1 + max_fidelity) by ring.
    replace (fidelity ch + max_fidelity + (1 - max_fidelity)) with (1 + fidelity ch) by ring.
    apply Rplus_le_compat_l.
    exact Hfid. }
  
  assert (H_eta : eta_degradation * (1 - fidelity ch) >= eta_degradation * (1 - max_fidelity)).
  {
    apply Rle_ge.
    apply (Rmult_le_compat_l eta_degradation (1 - max_fidelity) (1 - fidelity ch)).
    - apply Rlt_le, Heta_pos.
    - apply Rge_le. exact H_one_minus.
  }
  assert (H_mid : 1 - eta_degradation * (1 - fidelity ch) <= 1 - eta_degradation * (1 - max_fidelity)).
  {
    unfold Rminus.
    apply Rplus_le_compat_l.
    apply Ropp_le_contravar.
    apply Rge_le in H_eta.
    exact H_eta.
  }
  assert (H_pos : 1 - max_fidelity > 0) by (apply Rgt_minus; exact Hmax_lt1).
  assert (H_mul : eta_degradation * (1 - max_fidelity) >= QuarantineThreshold).
  {
    pose proof eta_calibration as Hcal.
    apply Rge_le in Hcal.
    apply (Rmult_le_compat_r (1 - max_fidelity)) in Hcal; [| apply Rlt_le; exact H_pos].
    unfold Rdiv in Hcal.
    rewrite Rmult_assoc in Hcal.
    rewrite Rinv_l in Hcal; [| apply Rgt_not_eq; exact H_pos].
    rewrite Rmult_1_r in Hcal.
    apply Rle_ge; exact Hcal.
  }
  assert (H_goal : 1 - eta_degradation * (1 - max_fidelity) <= QuarantineThreshold).
  {
    apply Rle_trans with (1 - QuarantineThreshold).
    - apply Rplus_le_compat_l. apply Ropp_le_contravar. apply Rge_le. exact H_mul.
    - pose proof quarantine_threshold_ge_half as H_half.
      lra.
  }
  assert (H_temp : Formalizability q <= 1 - eta_degradation * (1 - max_fidelity)).
  {
    apply Rle_trans with (1 - eta_degradation * (1 - fidelity ch)).
    - apply Rle_trans with (Formalizability (SourceQualia q) - eta_degradation * (1 - fidelity ch)).
      + exact H_phi.
      + unfold Rminus. apply Rplus_le_compat_r. exact H_source.
    - exact H_mid.
  }
  (* Final step: combine H_temp and H_goal *)
  apply (Rle_trans _ _ _ H_temp H_goal).
Qed.

(* Axiom linking quarantine threshold to δ_min and M *)
Axiom quarantine_entropy_link :
  QuarantineThreshold = delta_min * INR M.

(* Encoding of statements about existence of qualia *)
Parameter code_Agent : Agent -> nat.
Parameter code_Time : Time -> nat.
Parameter code_Qualia : Qualia -> nat.

Parameter HasQualia : nat -> nat -> nat -> Formula.

Definition ExistsQualia (A : Agent) (q : Qualia) : Formula :=
  FExists (HasQualia (code_Agent A) 0 (code_Qualia q)).

Axiom ExistsQualia_sound : forall A q,
  Provable FS (ExistsQualia A q) -> exists t, current_qualia A t = q.

(* Gödel qualia encodes provability *)
Axiom godel_qualia_encodes_proof :
  forall (A : Agent) (G : Formula),
    contains_arithmetic FS ->
    (Provable FS G <-> ~ Provable FS (FNot G)) ->
    (exists t, current_qualia A t = godel_qualia FS G) ->
    Provable FS G.

Definition contains_proof (rep : Qualia -> nat) (G : Formula) : Prop :=
  exists p, Proof_rel (rep (godel_qualia FS G)) (code_Formula G) /\
            ValidProof G p /\ (length p <= L_max)%nat.

Axiom representation_contains_proof :
  forall (A : Agent) (D : Digitization A nat) (G : Formula),
    contains_arithmetic FS ->
    (Provable FS G <-> ~ Provable FS (FNot G)) ->
    (forall q, decode (encode q) = q) ->
    Provable FS G ->
    contains_proof (@encode A nat D) G.

(* Lemma: extract a bounded proof from a representation *)
Lemma extract_proof_from_rep :
  forall (A : Agent) (D : Digitization A nat) (G : Formula),
    contains_arithmetic FS ->
    (Provable FS G <-> ~ Provable FS (FNot G)) ->
    (forall q, decode (encode q) = q) ->
    Provable FS G ->
    Provable_Bounded FS G.
Proof.
  intros A D G Harith HG Hdec Hprov.
  pose proof (representation_contains_proof A D G Harith HG Hdec Hprov) as Hcontains.
  destruct Hcontains as [p [Hrel [Hvalid Hlen]]].
  exists p; split; auto.
Qed.

(* Definition of a cognitive shadow *)
Definition is_shadow_hott (A : Agent) (e : Qualia) : Prop :=
  (forall (D : Digitization A nat), (forall q, decode (encode q) = q) -> False) /\
  (~ Provable_Bounded FS (ExistsQualia A e)) /\
  (forall B ch, transfer A B e any_time ch -> Formalizability e <= QuarantineThreshold).

(* ------------------------------------------------------------------------ *)
(* THEOREM 1' (COGNITIVE SHADOW) with flag UseQuantumAxiom                  *)
(* ------------------------------------------------------------------------ *)

Theorem CognitiveShadow_Full :
  forall (A : Agent) (D : Digitization A nat),
    (UseQuantumAxiom = true -> agent_can_perceive_quantum A) ->
    contains_arithmetic FS ->
    exists e, is_shadow_hott A e.
Proof.
  intros A D Hquant_cond Harith.
  set (G := GodelSentence FS).
  assert (HG : Provable FS G <-> ~ Provable FS (FNot G))
    by (apply GodelSentence_prop; exact Harith).
    set (q_g := godel_qualia FS G).
  (* Obtain q_r depending on the flag *)
  pose (q_r := if UseQuantumAxiom then outcome_of fixed_state else q_dummy).
  assert (Hqr_ex : exists t, current_qualia A t = q_r).
  {
    unfold q_r; destruct (UseQuantumAxiom) eqn:Huse.
    - assert (Hagent : agent_can_perceive_quantum A) by (apply Hquant_cond; reflexivity).
      destruct (A2_quantum A fixed_state Hagent) as [t_r H].
      exists t_r; exact H.
    - destruct (q_dummy_exists A) as [t_r H].
      exists t_r; exact H.
  }
  (* Now we have q_r and Hqr_ex. The rest of the proof is identical for both branches *)
  destruct (A5_pair_exists A q_g q_r) as [t_e He].
  set (e := qualia_pair q_g q_r).
  exists e.
  split; [| split].

  - (* Clause 1: incompleteness of representation *)
    intros D' Hdec.
    assert (Hex : exists t, current_qualia A t = q_g).
    { apply (A5_decomp A q_g q_r). exists t_e; exact He. }
    destruct Hex as [t_g Ht_g].
    assert (Hprov_G : Provable FS G)
      by (eapply godel_qualia_encodes_proof; eauto; exists t_g; eauto).
    apply extract_proof_from_rep with (D := D') in Hprov_G; auto.
    apply (A8_resource_bridge FS G Harith HG Hprov_G).

  - (* Clause 2: unprovability of existence *)
    intros Hprov_e.
    apply Provable_Bounded_implies_Provable in Hprov_e.
    apply ExistsQualia_sound in Hprov_e as [t Ht].
    unfold e in Ht.
    assert (Hex : exists t, current_qualia A t = qualia_pair q_g q_r)
      by (exists t; exact Ht).
    apply (A5_decomp A q_g q_r) in Hex as [t' Ht'].
    assert (Hprov_G : Provable FS G)
      by (eapply godel_qualia_encodes_proof; eauto; exists t'; eauto).
    pose proof (extract_proof_from_rep A D G Harith HG enc_dec Hprov_G) as Hprov_bounded_G.
    apply (A8_resource_bridge FS G Harith HG Hprov_bounded_G).

  - (* Clause 3: non‑reducibility of transmission *)
    intros B ch Htrans.
    apply (transfer_below_threshold A B e any_time ch Htrans).
Qed.

(* ------------------------------------------------------------------------ *)
(* Theorem 2 (resonance limit)                                              *)
(* ------------------------------------------------------------------------ *)

Parameter ShadowState : Type.
Parameter shadow_merge : ShadowState -> ShadowState -> ShadowState.
Parameter mutual_info : ShadowState -> ShadowState -> R.
Parameter entropy : ShadowState -> R.
Parameter H_min_const : R.
Axiom H_min_const_pos : H_min_const > 0.
Axiom A10_leak_bound : forall s1 s2, mutual_info s1 s2 <= entropy s1 - H_min_const.

Inductive ConsensusOutcome := MERGE_ALLOWED | HALT_RESONANCE | HALT_SHADOW_COLLAPSE.

Definition consensus_check (s1 s2 : ShadowState) : ConsensusOutcome :=
  let rho := mutual_info s1 s2 in
  if Rle_dec rho rho_max then
    if Rge_dec rho delta_min then MERGE_ALLOWED else HALT_SHADOW_COLLAPSE
  else HALT_RESONANCE.

(* Theorem 2: if mutual information exceeds rho_max, consensus_check returns HALT_RESONANCE *)
Theorem ResonanceLimit_Theorem : forall s1 s2, mutual_info s1 s2 > rho_max ->
  consensus_check s1 s2 = HALT_RESONANCE.
Proof.
  intros s1 s2 H_rho. unfold consensus_check.
  destruct (Rle_dec (mutual_info s1 s2) rho_max) as [Hle|Hgt].
  - lra.
  - reflexivity.
Qed.

(* ------------------------------------------------------------------------ *)
(* Theorem 3' (component ranking)                                           *)
(* ------------------------------------------------------------------------ *)

Inductive Component : Type := Sens | Sem | Rel | Refl.
Parameter component_rank : ShadowState -> Component -> nat.

(* Axiom A11: merging does not decrease component ranks *)
Axiom A11_merge_non_decreasing :
  forall (s1 s2 : ShadowState) (k : Component),
    (component_rank (shadow_merge s1 s2) k >=
     Nat.max (component_rank s1 k) (component_rank s2 k))%nat.

(* Axiom A11 for Refl: strict increase *)
Axiom A11_refl_strict_growth :
  forall s1 s2 : ShadowState,
    (component_rank (shadow_merge s1 s2) Refl >=
     component_rank s1 Refl + component_rank s2 Refl + 1)%nat.

(* Theorem 3': component ranks do not decrease upon merging; Refl strictly increases *)
Theorem Theorem_3_components :
  forall (s1 s2 : ShadowState) (k : Component),
    (component_rank (shadow_merge s1 s2) k >= component_rank s1 k)%nat /\
    (component_rank (shadow_merge s1 s2) k >= component_rank s2 k)%nat /\
    (k = Refl ->
     (component_rank (shadow_merge s1 s2) Refl >=
      component_rank s1 Refl + component_rank s2 Refl + 1)%nat).
Proof.
  intros s1 s2 k.
  pose proof (A11_merge_non_decreasing s1 s2 k) as H_nd.
  split.
  - apply (Nat.le_trans (component_rank s1 k) (Nat.max (component_rank s1 k) (component_rank s2 k)) (component_rank (shadow_merge s1 s2) k)).
    + apply Nat.le_max_l.
    + apply H_nd.
  - split.
    + apply (Nat.le_trans (component_rank s2 k) (Nat.max (component_rank s1 k) (component_rank s2 k)) (component_rank (shadow_merge s1 s2) k)).
      * apply Nat.le_max_r.
      * apply H_nd.
    + intros Hk. subst k. apply A11_refl_strict_growth.
Qed.

(* ------------------------------------------------------------------------ *)
(* Theorem 4 (cognitive horizon)                                            *)
(* ------------------------------------------------------------------------ *)

Parameter evolve : ShadowState -> nat -> ShadowState.
Axiom entropy_nonneg : forall s, entropy s >= 0.
Axiom evolve_base : forall s, evolve s 0 = s.
Axiom irreversible_step :
  forall (s : ShadowState) (t : nat), (t > 0)%nat ->
    entropy (evolve s t) - entropy (evolve s (t-1)) >= delta_min.

(* Helper lemma: S n - 1 = n *)
Lemma sub1_S : forall n, (S n - 1)%nat = n.
Proof. intros n. rewrite Nat.sub_1_r. apply Nat.pred_succ. Qed.

(* Theorem: linear lower bound on entropy growth *)
Theorem entropy_linear_bound :
  forall (s : ShadowState) (t : nat),
    entropy (evolve s t) >= entropy s + INR t * delta_min.
Proof.
  intros s t. generalize dependent s. induction t as [| t' IH]; intros s.
  - rewrite evolve_base, INR_0. ring_simplify. apply Rle_refl.
  - rewrite S_INR. ring_simplify.
    assert (H_pos : (S t' > 0)%nat) by apply Nat.lt_0_succ.
    assert (H_step : entropy (evolve s (S t')) - entropy (evolve s (S t' - 1)) >= delta_min).
    { apply (irreversible_step s (S t') H_pos). }
    rewrite sub1_S in H_step.
    apply Rge_le in H_step.
    assert (H_sum : entropy (evolve s t') + delta_min <= entropy (evolve s (S t'))).
    {
      replace (entropy (evolve s (S t')) - entropy (evolve s t'))
        with (entropy (evolve s (S t')) + - entropy (evolve s t')) in H_step by ring.
      apply (Rplus_le_compat_r (entropy (evolve s t')) _ _) in H_step.
      ring_simplify in H_step. rewrite Rplus_comm in H_step. exact H_step.
    }
    apply Rle_ge.
    apply Rle_trans with (r2 := entropy (evolve s t') + delta_min).
    + apply Rplus_le_compat_r. apply Rge_le. apply IH.
    + exact H_sum.
Qed.

Definition predictability (s : ShadowState) (t : nat) (H_min : R) : R :=
  H_min / entropy (evolve s t).

(* Lemma: if entropy reaches H_min / 0.51, predictability ≤ 0.51 *)
Lemma predictability_horizon_aux :
  forall (s : ShadowState) (H_min : R) (t : nat),
    H_min > 0 ->
    entropy (evolve s t) >= H_min / 0.51 ->
    predictability s t H_min <= 0.51.
Proof.
  intros s H_min t Hmin_pos H_bound.
  set (H_t := entropy (evolve s t)).
  apply Rge_le in H_bound.
  assert (H_t_pos : 0 < H_t).
  {
    apply Rlt_le_trans with (r2 := H_min / 0.51).
    - apply Rmult_lt_0_compat.
      + exact Hmin_pos.
      + apply Rinv_0_lt_compat. lra.
    - exact H_bound.
  }
  apply (Rmult_le_reg_l H_t).
  - exact H_t_pos.
  - rewrite Rmult_comm. unfold predictability, Rdiv.
    rewrite Rmult_assoc. rewrite Rinv_l.
    + rewrite Rmult_1_r.
      apply (Rmult_le_compat_r 0.51) in H_bound; [| lra].
      unfold Rdiv in H_bound.
      rewrite Rmult_assoc in H_bound.
      rewrite Rinv_l in H_bound; [| lra].
      rewrite Rmult_1_r in H_bound.
      exact H_bound.
    + apply Rgt_not_eq, H_t_pos.
Qed.

(* Theorem 4: cognitive horizon – there exists T after which predictability ≤ 0.51 *)
Theorem CognitiveHorizon :
  forall (s : ShadowState) (H_min : R),
    H_min > 0 ->
    exists T : nat,
      forall t, (t >= T)%nat -> predictability s t H_min <= 0.51.
Proof.
  intros s H_min Hmin_pos.
  set (H0 := entropy s).
  set (delta := delta_min).
  assert (H_delta_pos : delta > 0) by apply delta_min_pos.
  set (H_target := H_min / 0.51).

  destruct (Rle_lt_dec H0 H_target) as [H_le | H_gt].
  - set (T_raw := up ((H_target - H0) / delta)).
    assert (H_div_nonneg : 0 <= (H_target - H0) / delta).
    { unfold Rdiv; apply Rmult_le_pos.
      - apply (Rplus_le_reg_l H0). rewrite Rplus_0_r.
        replace (H0 + (H_target - H0)) with H_target by ring. exact H_le.
      - apply Rlt_le. apply Rinv_0_lt_compat. exact H_delta_pos. }
    assert (H_T_nonneg : (0 <= T_raw)%Z).
    { apply le_IZR. apply Rle_trans with ((H_target - H0) / delta).
      - exact H_div_nonneg.
      - destruct (archimed ((H_target - H0) / delta)) as [H_up_gt _].
        apply Rlt_le; exact H_up_gt. }
    set (T := Z.to_nat T_raw).
    exists T.
    intros t Ht.
    apply predictability_horizon_aux; auto.
    apply Rge_trans with (H0 + INR t * delta).
    + apply entropy_linear_bound.
    + apply Rle_ge.
      assert (H_ineq : (H_target - H0) / delta <= IZR T_raw).
      { destruct (archimed ((H_target - H0) / delta)) as [H_up_gt _].
        apply Rlt_le; exact H_up_gt. }
      assert (H_mul : H_target - H0 <= delta * IZR T_raw).
      {
        apply (Rmult_le_compat_r delta) in H_ineq; [| lra].
        unfold Rdiv in H_ineq.
        rewrite Rmult_assoc in H_ineq.
        rewrite Rinv_l in H_ineq; [| apply Rgt_not_eq, H_delta_pos].
        rewrite Rmult_1_r in H_ineq.
        rewrite Rmult_comm in H_ineq.
        exact H_ineq.
      }
      assert (H_T_eq : INR T = IZR T_raw).
      { unfold T; rewrite INR_IZR_INZ; apply f_equal. apply Z2Nat.id; exact H_T_nonneg. }
      rewrite <- H_T_eq in H_mul.
      assert (H_t_ge_T_R : INR T <= INR t) by (apply le_INR; exact Ht).
      assert (H_main : H_target <= H0 + delta * INR t).
      {
        apply Rle_trans with (H0 + (H_target - H0)).
        - lra.
        - apply Rplus_le_compat_l.
          apply Rle_trans with (delta * INR T).
          + exact H_mul.
          + apply Rmult_le_compat_l; [lra | exact H_t_ge_T_R].
      }
      unfold H_target in H_main.
      rewrite (Rmult_comm delta (INR t)) in H_main.
      exact H_main. 
    - exists 0%nat.
    intros t Ht.
    apply predictability_horizon_aux; auto.
    apply Rge_trans with (H0 + INR t * delta).
    + apply entropy_linear_bound.
    + apply Rle_ge.
      apply Rle_trans with H0.
      * apply Rlt_le, H_gt.
      * assert (H_nonneg : 0 <= INR t * delta).
        { apply Rmult_le_pos; [apply pos_INR | lra]. }
        lra.
Qed.

(* ------------------------------------------------------------------------ *)
(* Individuality Preservation Theorem (dimensionality)                      *)
(* ------------------------------------------------------------------------ *)

Parameter dim_shadow : ShadowState -> nat.
Axiom merge_dim_growth : forall s1 s2,
  (dim_shadow (shadow_merge s1 s2) >= dim_shadow s1 + dim_shadow s2 + 1)%nat.

(* Theorem: dimensionality strictly increases upon merging *)
Theorem IndividualityPreservation_Theorem : forall s1 s2,
    (dim_shadow (shadow_merge s1 s2) > dim_shadow s1)%nat /\
    (dim_shadow (shadow_merge s1 s2) > dim_shadow s2)%nat.
Proof.
  intros s1 s2.
  pose proof (merge_dim_growth s1 s2) as H.
  split; lia.
Qed.

End CoreAxioms.