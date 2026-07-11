(** * InterfacesTheorem7.v – Theorem 7 on profile distance upper bound *)
Require Import Coq.Reals.Reals.
Require Import Coq.Reals.RIneq.
Require Import Coq.micromega.Lia.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.GlobalParameters.

Open Scope R_scope.

Section InterfacesTheorem7.
  Variable Agent : Type.

  Variable C : Agent -> nat -> Component -> R.
  Variable Sel : Agent -> nat -> Component -> R.
  Variable I : Agent -> nat -> Component -> R.
  Parameter use    : Agent -> nat -> Component -> R.
  Parameter intent : Agent -> nat -> Component -> R.
  Parameter noise  : Agent -> nat -> Component -> R.

  Parameter alpha_comp beta_comp : Component -> R.

  Parameter profile_distance : Agent -> nat -> nat -> R.

  (* Metric axioms for profile distance *)
  Axiom profile_distance_triangle :
    forall (A : Agent) (t1 t2 t3 : nat),
      profile_distance A t1 t3 <= profile_distance A t1 t2 + profile_distance A t2 t3.

  Axiom profile_distance_nonneg :
    forall (A : Agent) (t1 t2 : nat),
      0 <= profile_distance A t1 t2.

  Axiom profile_distance_id :
    forall (A : Agent) (t : nat),
      profile_distance A t t = 0.

  (* Maximal one-step profile change *)
  Definition M_max : R :=
    (alpha_comp Sens + alpha_comp Sem + alpha_comp Rel + alpha_comp Refl) *
      (gamma * U_max + delta_ * I_max + eta * N_max) +
    (beta_comp Sens + beta_comp Sem + beta_comp Rel + beta_comp Refl) *
      (epsilon * (U_max + Rabs theta_S) + zeta * N_max).

  Axiom max_profile_step :
    forall (A : Agent) (t : nat),
      profile_distance A t (S t) <= M_max.

  (* Theorem 7: Lipschitz growth of profile distance over time *)
  Theorem Theorem_7 : forall (A : Agent) (t1 t2 : nat),
    (t2 >= t1)%nat -> profile_distance A t1 t2 <= INR (t2 - t1) * M_max.
  Proof.
    intros A t1 t2 Hle.
    induction t2 as [|t2' IH].
    - (* t2 = 0 *)
      assert (t1 = 0)%nat by lia.
      subst t1; simpl; rewrite profile_distance_id; lra.
    - (* t2 = S t2' *)
      destruct (Nat.eq_dec t1 (S t2')) as [Heq|Hneq].
      + (* t1 = S t2' *)
        subst t1.
        replace (S t2' - S t2')%nat with 0%nat by lia.
        simpl; rewrite profile_distance_id; lra.
      + (* t1 <= t2' *)
        assert (Hle' : (t1 <= t2')%nat) by lia.
        specialize (IH Hle').
        replace (S t2' - t1)%nat with (S (t2' - t1))%nat by lia.
        rewrite S_INR, Rmult_plus_distr_r.
        apply Rle_trans with (profile_distance A t1 t2' + profile_distance A t2' (S t2')).
        * apply profile_distance_triangle with (t2 := t2').
        * apply Rplus_le_compat; [apply IH |].
          apply Rle_trans with M_max.
          -- apply max_profile_step.
          -- rewrite Rmult_1_l; apply Rle_refl.
  Qed.

End InterfacesTheorem7.