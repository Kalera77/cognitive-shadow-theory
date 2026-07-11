(** * Quantum states, measurements, and MPO primitives *)
Require Import CognitiveShadow.Quantum.Hilbert.
Require Import Coq.Reals.Reals.

Local Open Scope R_scope.

(* Type of measurements *)
Parameter Measurement : Type.

(* Outcome of a measurement on a quantum state *)
Parameter outcome : Measurement -> QState -> R.
Axiom outcome_probability : forall m psi, 0 <= outcome m psi <= 1.

(* Probability of a specific outcome (by index) *)
Parameter probability : QState -> nat -> R.

(* Tensor product of two quantum states *)
Parameter tensor_product : QState -> QState -> QState.

(* Matrix product operator type and application *)
Parameter MatrixProductOperator : Type.
Parameter mpo_apply : MatrixProductOperator -> QState -> QState.