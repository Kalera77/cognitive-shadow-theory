(** * SystemProfile.v – system profiles (QUANTUM, DETERMINISTIC, BCI_OPEN) with mode‑specific parameters *)
Require Import Coq.Reals.Reals.
Open Scope R_scope.

Section SystemProfile.
  Inductive SystemProfile := QUANTUM | DETERMINISTIC | BCI_OPEN.
  Parameter active_profile : SystemProfile.
  Parameter profile_rho_max : SystemProfile -> R.
  Parameter profile_H_min : SystemProfile -> R.
  Parameter profile_quarantine_mode : SystemProfile -> Type.

  (* Fixed parameter values for each profile *)
  Axiom profile_values :
    profile_rho_max QUANTUM = 0.85 /\
    profile_rho_max DETERMINISTIC = 0.92 /\
    profile_rho_max BCI_OPEN = 0.95 /\
    profile_H_min QUANTUM = 0.08 /\
    profile_H_min DETERMINISTIC = 0.05 /\
    profile_H_min BCI_OPEN = 0.03.

  Parameter A2_quantum : Prop.
  Parameter A4_no_transfer : Prop.
  Axiom A2_holds : active_profile = QUANTUM -> A2_quantum.
  Axiom A4_holds : active_profile = BCI_OPEN -> (~ A4_no_transfer).

  (* Convenience getters *)
  Definition get_rho_max : R := profile_rho_max active_profile.
  Definition get_H_min : R := profile_H_min active_profile.
End SystemProfile.
