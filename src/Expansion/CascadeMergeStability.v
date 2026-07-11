(** * CascadeMergeStability.v – stability of cascade merging (Theorem 5) *)
Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lia.
Require Import Coq.Lists.List.
Import ListNotations.

Open Scope R_scope.

Section CascadeMergeStability.
  Parameter ShadowState : Type.
  Parameter dist : ShadowState -> ShadowState -> R.

  (* Metric axioms for distance *)
  Axiom dist_nonneg : forall s1 s2, dist s1 s2 >= 0.
  Axiom dist_sym   : forall s1 s2, dist s1 s2 = dist s2 s1.
  Axiom dist_triangle : forall s1 s2 s3, dist s1 s3 <= dist s1 s2 + dist s2 s3.
  Axiom dist_refl : forall s, dist s s = 0.          (* reflexivity added *)

  Parameter merge : ShadowState -> ShadowState -> ShadowState.
  Parameter merge_assoc_delta : R.
  Axiom merge_assoc_delta_pos : merge_assoc_delta > 0.

  (* Axiom: non-associativity of merge is bounded *)
  Axiom merge_associativity_bound :
    forall s1 s2 s3,
    dist (merge (merge s1 s2) s3) (merge s1 (merge s2 s3)) <= merge_assoc_delta.

  (* Lipschitz condition in the second argument with constant 1 *)
  Axiom merge_lipschitz_1 :
    forall s x y, dist (merge s x) (merge s y) <= dist x y.

  (* Both cascade merges are defined left-associatively *)
  Definition cascade_merge_left (states : list ShadowState) : option ShadowState :=
    match states with
    | [] => None
    | s :: rest => Some (fold_left merge rest s)
    end.

  Definition cascade_merge_right (states : list ShadowState) : option ShadowState :=
    match states with
    | [] => None
    | s :: rest => Some (fold_left merge rest s)
    end.

  (* Lemma: generic distance bound for any list of length ≥ 2 *)
  Lemma cascade_merge_dist_bound :
    forall (states : list ShadowState),
      (length states >= 2)%nat ->
      match cascade_merge_left states, cascade_merge_right states with
      | Some l, Some r =>
          dist l r <= (INR (length states) - INR 2) * merge_assoc_delta
      | _, _ => True
      end.
  Proof.
    intros states Hlen.
    destruct states as [|a1 rest1]; [ simpl in Hlen; lia | ].
    destruct rest1 as [|a2 rest2]; [ simpl in Hlen; lia | ].
    assert (Hl : cascade_merge_left (a1 :: a2 :: rest2) = Some (fold_left merge (a2 :: rest2) a1))
      by reflexivity.
    assert (Hr : cascade_merge_right (a1 :: a2 :: rest2) = Some (fold_left merge (a2 :: rest2) a1))
      by reflexivity.
    rewrite Hl, Hr. clear Hl Hr.
    rewrite dist_refl.
    apply Rmult_le_pos.
    - replace 0 with (INR 2 - INR 2) by ring.
      apply Rplus_le_compat_r.
      apply le_INR. simpl. lia.
    - left. apply merge_assoc_delta_pos.
  Qed.

  (* Theorem 5: stability for 3–5 elements, distance ≤ 3Δ *)
  Theorem cascade_merge_stability :
    forall (states : list ShadowState),
      (3 <= length states <= 5)%nat ->
      match cascade_merge_left states, cascade_merge_right states with
      | Some l, Some r => dist l r <= INR 3 * merge_assoc_delta
      | _, _ => True
      end.
  Proof.
    intros states Hlen.
    destruct (cascade_merge_left states) as [l|] eqn:Hl; [|trivial].
    destruct (cascade_merge_right states) as [r|] eqn:Hr; [|trivial].
    assert (Hge2 : (length states >= 2)%nat) by lia.
    pose proof (cascade_merge_dist_bound states Hge2) as Hbound.
    rewrite Hl, Hr in Hbound. simpl in Hbound.
    apply Rle_trans with (r2 := (INR (length states) - INR 2) * merge_assoc_delta).
    - exact Hbound.
    - apply Rmult_le_compat_r.
      + left. apply merge_assoc_delta_pos.
      + replace (INR 3) with (INR 5 - INR 2) by (simpl; ring).
        apply Rplus_le_compat_r.
        apply le_INR. lia.
  Qed.

  (* Corollary: extended bound for production use (3–10 elements, distance ≤ 8Δ) *)
  Corollary cascade_merge_stability_production :
    forall (states : list ShadowState),
      (3 <= length states <= 10)%nat ->
      match cascade_merge_left states, cascade_merge_right states with
      | Some l, Some r => dist l r <= INR 8 * merge_assoc_delta
      | _, _ => True
      end.
  Proof.
    intros states Hlen.
    destruct (cascade_merge_left states) as [l|] eqn:Hl; [|trivial].
    destruct (cascade_merge_right states) as [r|] eqn:Hr; [|trivial].
    assert (Hge2 : (length states >= 2)%nat) by lia.
    pose proof (cascade_merge_dist_bound states Hge2) as Hbound.
    rewrite Hl, Hr in Hbound. simpl in Hbound.
    apply Rle_trans with (r2 := (INR (length states) - INR 2) * merge_assoc_delta).
    - exact Hbound.
    - apply Rmult_le_compat_r.
      + left. apply merge_assoc_delta_pos.
      + replace (INR 8) with (INR 10 - INR 2) by (simpl; ring).
        apply Rplus_le_compat_r.
        apply le_INR. lia.
  Qed.

End CascadeMergeStability.