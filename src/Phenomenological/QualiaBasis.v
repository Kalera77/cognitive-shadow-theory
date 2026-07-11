(** * Qualia basis and phenomenological states *)
Require Import Coq.Reals.Reals.
Require Import Coq.Lists.List.
Require Import CognitiveShadow.Quantum.Hilbert.
Import ListNotations.

Local Open Scope R_scope.

Inductive QualiaLevel : Type :=
| L1_Sensory | L2_Analytical | L3_Causal | L4_Counterfactual | L5_Generative.

Definition qualia_levels : list QualiaLevel :=
  [L1_Sensory; L2_Analytical; L3_Causal; L4_Counterfactual; L5_Generative].

Definition level_index (l : QualiaLevel) : nat :=
  match l with
  | L1_Sensory => 0 | L2_Analytical => 1 | L3_Causal => 2
  | L4_Counterfactual => 3 | L5_Generative => 4
  end.

(* Qualia vector type and tensor product *)
Parameter QualiaVector : Type.
Parameter qualia_tensor : QualiaVector -> QualiaVector -> QualiaVector.

Reserved Notation "q1 ⊗ q2" (at level 40, left associativity).
Notation "q1 ⊗ q2" := (qualia_tensor q1 q2).

(* Phenomenological state record *)
Record PhenomenologicalState : Type := {
  ps_level : QualiaLevel;
  ps_intensity : R;
  ps_coherence : R;
  ps_intentional_object : Type
}.

Definition QUALIA_INTENSITY_MIN : R := 0.1.
Definition QUALIA_INTENSITY_MAX : R := 1.0.
Definition QUALIA_COHERENCE_MIN : R := 0.6.
Definition QUALIA_COHERENCE_MAX : R := 0.8.

Definition InformationContent_P (p_state : PhenomenologicalState) : R :=
  p_state.(ps_intensity) * p_state.(ps_coherence).

Inductive QualiaComponent : Type :=
| QComp_Sens | QComp_Sem | QComp_Rel | QComp_Refl.

(* Formalizability function φ on components *)
Parameter phi : QualiaComponent -> R.