(** * PhiHierarchy.v – three‑level phi hierarchy with fallback *)
Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.Reals.Rfunctions.
Require Import Coq.micromega.Lra.
Open Scope R_scope.

Section PhiHierarchy.
  Context {Component : Type}.
  Context (phi_l1 phi_l2 phi_l3 : Component -> R).
  Context (L2_available L3_available : bool).
  Parameter epsilon_phi : R.
  Axiom epsilon_phi_pos : epsilon_phi > 0.

  (* Axiom A20 error bounds between levels *)
  Axiom A20_error_bound :
    forall k, Rabs (phi_l1 k - phi_l2 k) <= epsilon_phi /\ Rabs (phi_l2 k - phi_l3 k) <= epsilon_phi.

  (* Effective phi chooses the highest available level *)
  Definition phi_effective (k : Component) : R :=
    if L3_available then phi_l3 k else if L2_available then phi_l2 k else phi_l1 k.

  Definition QuarantineThreshold : R := 0.5.
  Definition QuarantineThreshold_Adjusted : R := QuarantineThreshold - epsilon_phi.
  Definition IsQuarantined (k : Component) : Prop := phi_effective k <= QuarantineThreshold_Adjusted.

  (* Theorem: fallback preserves order between components *)
  Theorem hierarchy_fallback_preserves_order : forall k1 k2,
    (L3_available = true -> phi_l3 k1 <= phi_l3 k2) ->
    (L2_available = true -> phi_l2 k1 <= phi_l2 k2) ->
    (L3_available = false -> L2_available = false -> phi_l1 k1 <= phi_l1 k2) ->
    phi_effective k1 <= phi_effective k2.
  Proof.
    intros k1 k2 H3 H2 H1.
    unfold phi_effective.
    case_eq L3_available.
    { intros HL3. apply H3. exact HL3. }
    { intros HL3. case_eq L2_available.
      { intros HL2. apply H2. exact HL2. }
      { intros HL2. apply H1; assumption. } }
  Qed.

  (* Helper: Rabs implies inequality *)
  Lemma Rabs_le_impl : forall a b, Rabs a <= b -> a <= b.
  Proof.
    intros a b H. apply Rle_trans with (Rabs a).
    - apply Rle_abs.
    - exact H.
  Qed.

  (* Lemma: safe quarantine trigger using the lowest level phi_l1 *)
  Lemma safe_quarantine_trigger :
    forall k, phi_l1 k <= QuarantineThreshold - 3 * epsilon_phi -> IsQuarantined k.
  Proof.
    intros k H. unfold IsQuarantined, phi_effective.
    case L3_available.
    { (* L3 = true *)
      destruct (A20_error_bound k) as [H12 H23].
      rewrite Rabs_minus_sym in H12, H23.
      apply Rabs_le_impl in H12. apply Rabs_le_impl in H23.
      unfold QuarantineThreshold, QuarantineThreshold_Adjusted in *.
      assert (H2le1 : phi_l2 k <= phi_l1 k + epsilon_phi) by lra.
      assert (H3le2 : phi_l3 k <= phi_l2 k + epsilon_phi) by lra.
      assert (H3le1 : phi_l3 k <= phi_l1 k + 2 * epsilon_phi) by lra.
      apply Rle_trans with (phi_l1 k + 2 * epsilon_phi).
      { exact H3le1. }
      { apply (Rplus_le_compat_r (2 * epsilon_phi)) in H.
        ring_simplify (phi_l1 k + 2 * epsilon_phi) in H.
        ring_simplify (0.5 - 3 * epsilon_phi + 2 * epsilon_phi) in H.
        unfold Rminus in H.
        replace (0.5 + (-3 * epsilon_phi + 2 * epsilon_phi)) with (0.5 - epsilon_phi) in H by ring.
        exact H. } }
    { (* L3 = false *)
      case L2_available.
      { (* L2 = true *)
        destruct (A20_error_bound k) as [H12 _].
        rewrite Rabs_minus_sym in H12.
        apply Rabs_le_impl in H12.
        unfold QuarantineThreshold, QuarantineThreshold_Adjusted in *.
        assert (H2le1 : phi_l2 k <= phi_l1 k + epsilon_phi) by lra.
        apply Rle_trans with (phi_l1 k + epsilon_phi).
        { exact H2le1. }
        { apply (Rplus_le_compat_r epsilon_phi) in H.
          ring_simplify (phi_l1 k + epsilon_phi) in H.
          ring_simplify (0.5 - 3 * epsilon_phi + epsilon_phi) in H.
          unfold Rminus in H.
          replace (0.5 + (-3 * epsilon_phi + epsilon_phi)) with (0.5 - 2 * epsilon_phi) in H by ring.
          apply Rle_trans with (0.5 - 2 * epsilon_phi).
          { exact H. }
          { unfold QuarantineThreshold_Adjusted.
            apply Rplus_le_compat_l.
            apply Ropp_le_contravar.
            cut (0 <= epsilon_phi).
            { intros Hpos. apply Rplus_le_compat_r with (r := epsilon_phi) in Hpos.
              replace (0 + epsilon_phi) with epsilon_phi in Hpos by ring.
              replace (epsilon_phi + epsilon_phi) with (2 * epsilon_phi) in Hpos by ring.
              exact Hpos. }
            { left. exact epsilon_phi_pos. } } } }
      { (* L2 = false *)
        unfold QuarantineThreshold, QuarantineThreshold_Adjusted in *.
        apply Rle_trans with (0.5 - 3 * epsilon_phi).
        { exact H. }
        { apply Rplus_le_compat_l.
          apply Ropp_le_contravar.
          cut (0 <= 2 * epsilon_phi).
          { intros Hpos. apply Rplus_le_compat_r with (r := epsilon_phi) in Hpos.
            replace (0 + epsilon_phi) with epsilon_phi in Hpos by ring.
            replace (2 * epsilon_phi + epsilon_phi) with (3 * epsilon_phi) in Hpos by ring.
            exact Hpos. }
          { apply Rmult_le_pos.
            - left. apply Rlt_0_2.
            - left. exact epsilon_phi_pos. } } } }
  Qed.
End PhiHierarchy.