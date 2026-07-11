(** * Wavefunction collapse and probabilistic outcomes *)
Require Import Coq.Reals.Reals.
Require Import Coq.Lists.List.
Require Import CognitiveShadow.Quantum.QuantumState.   (* contains QState *)
Require Import CognitiveShadow.Quantum.Hilbert.
Require Import CognitiveShadow.Phenomenological.QualiaBasis.
Import ListNotations.

Local Open Scope R_scope.

(* Measurement and outcome *)
Parameter Measurement : Type.
Parameter outcome : Measurement -> QState -> R.
Axiom outcome_probability : forall m psi, 0 <= outcome m psi <= 1.

Parameter outcome_probability_nat : QState -> nat -> R.  (* renamed to avoid conflict *)

(* Tensor product *)
Parameter tensor_product : QState -> QState -> QState.

(* Matrix product operator *)
Parameter MatrixProductOperator : Type.
Parameter mpo_apply : MatrixProductOperator -> QState -> QState.

(* Collapse probability for a quale level *)
Parameter collapse_probability : QualiaVector -> QualiaLevel -> R.
Axiom collapse_probability_nonneg : forall q l, 0 <= collapse_probability q l <= 1.
Axiom collapse_probability_sum : forall q,
  fold_left Rplus (map (collapse_probability q) qualia_levels) 0 = 1.  (* sum to 1 *)

(* Collapse to phenomenological state and maximum entropy state *)
Parameter collapse_to_phenomenological : QualiaVector -> PhenomenologicalState.
Parameter maximum_entropy_state : PhenomenologicalState -> QualiaVector.

(* Morphism types *)
Parameter QuantumMorphism : Type -> Type -> Type.
Parameter PhenomenologicalMorphism : Type -> Type -> Type.

(* Identities *)
Parameter id_quantum_morphism : forall A, QuantumMorphism A A.
Parameter id_phenomenological_morphism : forall A, PhenomenologicalMorphism A A.

(* Composition: compose f g = g ∘ f (first f, then g) *)
Parameter compose_quantum_morphisms : forall {A B C}, QuantumMorphism A B -> QuantumMorphism B C -> QuantumMorphism A C.
Parameter compose_phenomenological_morphisms : forall {A B C}, PhenomenologicalMorphism A B -> PhenomenologicalMorphism B C -> PhenomenologicalMorphism A C.

(* Associativity axioms *)
Axiom quantum_assoc : forall A B C D (f: QuantumMorphism A B) (g: QuantumMorphism B C) (h: QuantumMorphism C D),
  compose_quantum_morphisms (compose_quantum_morphisms f g) h = compose_quantum_morphisms f (compose_quantum_morphisms g h).

Axiom phenomenological_assoc : forall A B C D (f: PhenomenologicalMorphism A B) (g: PhenomenologicalMorphism B C) (h: PhenomenologicalMorphism C D),
  compose_phenomenological_morphisms (compose_phenomenological_morphisms f g) h = compose_phenomenological_morphisms f (compose_phenomenological_morphisms g h).

(* Identity laws *)
Axiom quantum_id_left : forall A B (f: QuantumMorphism A B), compose_quantum_morphisms f (id_quantum_morphism B) = f.
Axiom quantum_id_right : forall A B (f: QuantumMorphism A B), compose_quantum_morphisms (id_quantum_morphism A) f = f.

Axiom phenomenological_id_left : forall A B (f: PhenomenologicalMorphism A B), compose_phenomenological_morphisms f (id_phenomenological_morphism B) = f.
Axiom phenomenological_id_right : forall A B (f: PhenomenologicalMorphism A B), compose_phenomenological_morphisms (id_phenomenological_morphism A) f = f.

(* Functor-like mappings between quantum and phenomenological morphisms *)
Parameter awareness_morph_of_quantum : forall {A B}, QuantumMorphism A B -> PhenomenologicalMorphism A B.
Parameter quantum_lift_of_phenomenological : forall {A B}, PhenomenologicalMorphism A B -> QuantumMorphism A B.

(* Proofs of functoriality *)
Axiom qp_identity_proof : forall A, awareness_morph_of_quantum (id_quantum_morphism A) = id_phenomenological_morphism A.
Axiom qp_composition_proof : forall A B C (f: QuantumMorphism A B) (g: QuantumMorphism B C),
  awareness_morph_of_quantum (compose_quantum_morphisms f g) = compose_phenomenological_morphisms (awareness_morph_of_quantum f) (awareness_morph_of_quantum g).

Axiom pq_identity_proof : forall A, quantum_lift_of_phenomenological (id_phenomenological_morphism A) = id_quantum_morphism A.
Axiom pq_composition_proof : forall A B C (f: PhenomenologicalMorphism A B) (g: PhenomenologicalMorphism B C),
  quantum_lift_of_phenomenological (compose_phenomenological_morphisms f g) = compose_quantum_morphisms (quantum_lift_of_phenomenological f) (quantum_lift_of_phenomenological g).

(* Mutual inverses between QualiaVector and PhenomenologicalState *)
Axiom quantum_phenomenological_roundtrip : forall (A : PhenomenologicalState),
  collapse_to_phenomenological (maximum_entropy_state A) = A.
Axiom phenomenological_quantum_roundtrip : forall (A : QualiaVector),
  maximum_entropy_state (collapse_to_phenomenological A) = A.