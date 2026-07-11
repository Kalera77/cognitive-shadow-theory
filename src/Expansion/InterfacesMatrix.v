(* ============================================================================
   InterfacesMatrix.v — Matrix model of cognitive shadow interfaces
   ============================================================================ *)

Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rpower.
Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Require Import Coq.Program.Program.
Require Import Coq.micromega.Lra.
Import ListNotations.
Open Scope R_scope.

Require Import CognitiveShadow.GlobalParameters.
Require Import CognitiveShadow.Expansion.InterfacesTheorem6.

(* ============================================================================
   Section 1: Types and basic definitions
   ============================================================================ *)

Inductive Component : Type :=
  | Sens : Component
  | Sem : Component
  | Rel : Component
  | Refl : Component.

Inductive Representation : Type :=
  | Memory : Representation
  | Speech : Representation
  | Motor : Representation
  | Social : Representation
  | Visual : Representation
  | Auditory : Representation
  | Temporal : Representation
  | Spatial : Representation.

Record InterfaceParams := mkInterface {
  C_kr :> R;
  S_kr :> R;
  I_kr :> R
}.

Definition InterfaceMatrix := Component -> Representation -> InterfaceParams.
Definition WeightMatrix := Component -> Representation -> R.

(* ============================================================================
   Section 2: Operations
   ============================================================================ *)

Definition clamp_01 (x : R) : R :=
  match Rle_dec 0 x with
  | left _ => match Rle_dec x 1 with
              | left _ => x
              | right _ => 1
              end
  | right _ => 0
  end.

Definition phi_kr (W : InterfaceMatrix) (k : Component) (r : Representation) : R :=
  let p := W k r in
  let prod := (C_kr p) * (S_kr p) * (I_kr p) in
  match Rlt_dec 0 prod with
  | left _ => Rpower prod (1/3)
  | right _ => 0
  end.

Definition phi_matrix (W : InterfaceMatrix) (weights : WeightMatrix) : R :=
  let sum_num :=
    (weights Sens Memory) * (phi_kr W Sens Memory) +
    (weights Sens Speech) * (phi_kr W Sens Speech) +
    (weights Sens Motor) * (phi_kr W Sens Motor) +
    (weights Sens Social) * (phi_kr W Sens Social) +
    (weights Sem Memory) * (phi_kr W Sem Memory) +
    (weights Sem Speech) * (phi_kr W Sem Speech) +
    (weights Rel Motor) * (phi_kr W Rel Motor) +
    (weights Refl Speech) * (phi_kr W Refl Speech)
  in
  let sum_den :=
    (weights Sens Memory) + (weights Sens Speech) +
    (weights Sens Motor) + (weights Sens Social) +
    (weights Sem Memory) + (weights Sem Speech) +
    (weights Rel Motor) + (weights Refl Speech)
  in
  match Rlt_dec sum_den 0.001 with
  | left _ => 0
  | right _ => sum_num / sum_den
  end.

(* ============================================================================
   Section 3: Metrics
   ============================================================================ *)

Definition resilience (phi_recovery phi_stress : R) (dt : R) : R :=
  match Rle_dec dt 0 with
  | left _ => 0
  | right _ => (phi_recovery - phi_stress) / dt
  end.

Definition temporal_coherence (mean_phi std_phi : R) : R :=
  match Rle_dec mean_phi 0.001 with
  | left _ => 0
  | right _ => 1 - (std_phi / mean_phi)
  end.

Definition awareness (correlation : R) : R :=
  match Rlt_dec correlation 0 with
  | left _ => (-1) * correlation
  | right _ => correlation
  end.

Definition flexibility (dist_W dt_switch : R) : R :=
  match Rle_dec dt_switch 0 with
  | left _ => 0
  | right _ => dist_W / dt_switch
  end.

(* ============================================================================
   Section 4: Resource constraint
   ============================================================================ *)

Axiom matrix_resource_constraint :
  forall (W : InterfaceMatrix) (weights : WeightMatrix),
  (weights Sens Memory) * (C_kr (W Sens Memory)) +
  (weights Sens Speech) * (C_kr (W Sens Speech)) +
  (weights Sem Memory) * (C_kr (W Sem Memory)) +
  (weights Refl Speech) * (C_kr (W Refl Speech)) <= R_max.

Axiom sparsity_assumption :
  forall (weights : WeightMatrix),
  (weights Sens Memory) + (weights Sens Speech) +
  (weights Sem Memory) + (weights Refl Speech) <= R_max.

(* ============================================================================
   Section 5: Connection to scalar model
   ============================================================================ *)

Definition uniform_weights : WeightMatrix := fun _ _ => 1.

Lemma scalar_model_equivalence :
  forall (W : InterfaceMatrix),
  phi_matrix W uniform_weights =
  (phi_kr W Sens Memory + phi_kr W Sens Speech + phi_kr W Sens Motor + phi_kr W Sens Social +
   phi_kr W Sem Memory + phi_kr W Sem Speech + phi_kr W Rel Motor + phi_kr W Refl Speech) / 8.
Proof.
  intros W.
  unfold phi_matrix, uniform_weights.
  replace (1 * (phi_kr W Sens Memory) + 1 * (phi_kr W Sens Speech) + 1 * (phi_kr W Sens Motor) +
           1 * (phi_kr W Sens Social) + 1 * (phi_kr W Sem Memory) + 1 * (phi_kr W Sem Speech) +
           1 * (phi_kr W Rel Motor) + 1 * (phi_kr W Refl Speech))
    with (phi_kr W Sens Memory + phi_kr W Sens Speech + phi_kr W Sens Motor + phi_kr W Sens Social +
          phi_kr W Sem Memory + phi_kr W Sem Speech + phi_kr W Rel Motor + phi_kr W Refl Speech) by ring.
  replace (1 + 1 + 1 + 1 + 1 + 1 + 1 + 1) with 8 by ring.
  match goal with
  | |- context [Rlt_dec 8 0.001] =>
      destruct (Rlt_dec 8 0.001) as [H|H]; [exfalso; lra | reflexivity]
  end.
Qed.

(* ============================================================================
   Section 6: Connections to Theorems 8, 9
   ============================================================================ *)

Axiom resilience_degradation :
  forall (L Delta_crit : R),
  L >= Delta_crit ->
  forall (phi_recovery phi_stress : R) (dt : R),
  resilience phi_recovery phi_stress dt <= 0.

Axiom awareness_paradox :
  forall (L Delta_crit : R),
  L >= Delta_crit ->
  forall (phi_measured phi_self_reported : R),
  phi_self_reported > phi_measured.

Axiom flexibility_collapse :
  forall (phi_refl phi_crit : R),
  phi_refl <= phi_crit ->
  forall (dist_W dt_switch : R),
  flexibility dist_W dt_switch = 0.

(* ============================================================================
   Section 7: Falsifiable predictions
   ============================================================================ *)

Axiom savant_prediction :
  forall (weights : WeightMatrix),
  (weights Refl Motor) > 5 * (weights Sem Social).

Axiom stress_resilience_prediction :
  forall (R_normal R_stress : R),
  R_stress <= 0.7 * R_normal.

Axiom schizophrenia_temporal_prediction :
  forall (T_healthy T_schizophrenia : R),
  T_schizophrenia < 0.5 * T_healthy.

Axiom autism_flexibility_prediction :
  forall (F_neurotypical F_autism : R),
  F_autism < 0.5 * F_neurotypical.