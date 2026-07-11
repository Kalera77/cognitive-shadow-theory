(** * Homotopy.v – discrete homotopy and preservation of topological charge (A26, Theorem 3.11) *)

Section Homotopy.

  Variable ShadowState : Type.
  Parameter merge : ShadowState -> ShadowState -> ShadowState.
  Parameter topological_charge : ShadowState -> nat.

  Inductive HomotopyPath : ShadowState -> ShadowState -> Type :=
  | hp_refl : forall s, HomotopyPath s s
  | hp_merge_assoc : forall s1 s2 s3, HomotopyPath (merge (merge s1 s2) s3) (merge s1 (merge s2 s3))
  | hp_sym : forall s1 s2, HomotopyPath s1 s2 -> HomotopyPath s2 s1
  | hp_trans : forall s1 s2 s3, HomotopyPath s1 s2 -> HomotopyPath s2 s3 -> HomotopyPath s1 s3.

  (* Axiom A26: homotopy paths preserve topological charge *)
  Axiom A26_preserves_charge : forall s1 s2 (p : HomotopyPath s1 s2),
    topological_charge s1 = topological_charge s2.

  (* Homotopy of commutativity for merge *)
  Axiom merge_commutes_homotopy : 
    forall s1 s2, HomotopyPath (merge s1 s2) (merge s2 s1).

  (* Corollary: merging preserves charge up to commutativity *)
  Corollary merge_preserves_charge :
    forall s1 s2, topological_charge (merge s1 s2) = topological_charge (merge s2 s1).
  Proof.
    intros s1 s2.
    apply A26_preserves_charge.
    apply merge_commutes_homotopy.
  Qed.

End Homotopy.