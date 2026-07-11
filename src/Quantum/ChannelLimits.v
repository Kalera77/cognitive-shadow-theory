(** * ChannelLimits.v – formalization of A4_star and its consequence *)
Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import CognitiveShadow.Principles.AlgorithmicEntropy.

Open Scope R_scope.

Section ChannelLimits.

  Variable Agent Qualia Time Channel : Type.
  Variable transfer : Agent -> Agent -> Qualia -> Time -> Channel -> Prop.
  Variable phi : Qualia -> R.
  Variable fidelity : Channel -> R.
  Parameter eta : R.
  Axiom eta_pos : eta > 0.
  Axiom fidelity_range : forall ch, 0 <= fidelity ch <= 1.
  Parameter SourceQualia : Qualia -> Qualia.

  (* Axiom A4_star: transmission degrades formalizability *)
  Axiom A4_star :
    forall A B q t ch,
      transfer A B q t ch ->
      phi q <= phi (SourceQualia q) - eta * (1 - fidelity ch).

  (* Lemma: consistency with finite M when fidelity = 1 *)
  Lemma A4_consistent_with_finite_M :
    forall (M : nat) (A B : Agent) (q : Qualia) (t : Time) (ch : Channel),
      (M > 0)%nat ->
      transfer A B q t ch ->
      fidelity ch = 1.0 ->
      phi q <= phi (SourceQualia q).
  Proof.
    intros M A B q t ch HM Htrans Hfid.
    apply A4_star in Htrans.
    rewrite Hfid in Htrans.
    lra.
  Qed.

End ChannelLimits.