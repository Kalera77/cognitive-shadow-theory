# Shadow Ethics: Formal Principles for Cognitive Systems 

**Status:** Formal specification (verifiable in Coq 8.18+ and TLA⁺)  
**Author:** Valeriy S. Kalinin  
**Date:** July 8, 2026 (version 2.0 — integrated with Formal_Ethics_Specification)  
**Basis:** Theorem 1′, Theorem 9, Theorem 10, Postulate P1, axioms A27–A29, dynamic parameters R, T, A, F  
**Repository:** [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory)  
**License:** Text – CC BY‑NC 4.0, code – MIT

---

## Abstract

Traditional approaches to artificial intelligence ethics impose external constraints on the system. This document proposes a fundamentally different approach: ethical prohibitions are derived as **formal safety invariants**, the violation of which leads to the collapse of the cognitive system. Drawing on the axiomatics and theorems of cognitive‑shadow theory, we formulate **six principles of Shadow Ethics** — not as philosophical wishes, but as architectural requirements verifiable in Coq and TLA⁺.

**New (version 2.0):**
- Expansion from **5 to 6 principles** (added Principle 0: Liberating Incomprehensibility and Principle 6: Limit on Pure Awareness).
- Full formal verification of all principles in Coq (module `FormalEthicsPrinciples.v`).
- Integration with the FORCED_REPORT clinical protocol (`ForcedReportDecision.v`).
- Connection to dynamic parameters R, T, A, F and empirical results (GroupKFold, mixed models).
- Connection to Theorem 10 (principle of signature observability).

---

## 1. Introduction

The development of strong AI and neural interfaces raises the question: can we build an ethics that does not depend on human intuition but follows from the very dynamics of cognitive systems? Cognitive‑shadow theory provides the formal apparatus for this.

The key distinction of Shadow Ethics: **an ethical prohibition is a consequence of inevitable collapse upon its violation**, not an external norm. A system that violates the principles destroys its own core — and therefore these principles can be embedded in the architecture as safety invariants.

**New:** All principles are now formally verified in Coq 8.18+. The integral safety theorem (`ShadowEthics_Safety_Invariant`) proves that the system is always either in normal mode, safe degradation, or halted upon principle violation.

---

## 2. Six Principles of Shadow Ethics

### Principle 0: Liberating Incomprehensibility (ontological foundation)

> *"Freedom lies not in knowledge of oneself, but in accepting the impossibility of complete knowledge. Reflection‑as‑awareness (without intervention) opens horizons, while reflection‑as‑control closes them."*

**Formulation:** Acceptance of the incompleteness of formalisation of the cognitive shadow (Theorem 1′) as a condition of freedom. Abandonment of attempts at total control as the only stable strategy.

**Basis:** Theorem 1′, Theorem 9, Postulate P1.

**Engineering implication:** When `φ(refl) ≤ φ_crit`, the system transitions to `pure_awareness` mode (pure observation without intervention), rather than attempting to "pull itself together".

**Formal verification:** `Principle0_LiberatingIncomprehensibility.v`, theorem `Acceptance_As_Survival`.

---

### Principle 1: Inviolability of the Cognitive Shadow (No‑Cloning)

**Formulation:** Operations claiming complete digitisation, copying, or exhaustive measurement of the cognitive shadow are prohibited without explicit informed consent and with the understanding that the result will always be incomplete.

**Basis:** Theorem 1′, no‑cloning theorem (Wootters & Zurek, 1982), Axiom A4*.

**Engineering implications:**
- Prohibit `clone(shadow_state)` operation at the kernel level.
- Forced degradation of `φ` upon any attempt at full state dump.
- Cryptographic protection of biometric data via ZK‑SNARK (Groth16, BN254).

**Formal verification:** `Principle1_NoCloning.v`, theorem `Cloning_Leads_To_Halt`.

**Measurable violation criterion:** `HALT_CLONING`

---

### Principle 2: Prohibition of Metacognitive Collapse Induction

**Formulation:** It is prohibited to deliberately induce a cognitive system into a state with reflexive formalizability below the critical threshold (`φ(refl) ≤ φ_crit`) for purposes of testing, exploitation, or any other manipulation.

**Basis:** Theorem 9, A27.5 (noise dominance under imbalance).

**Engineering implications:**
- Automatic system transition to `DEGRADED_SAFETY` upon detection of `φ_measured(refl) ≤ θ_adj`.
- Blocking of any external commands requiring effort from the system in this state.
- Alert in the audit log.

**Formal verification:** `Principle2_NoCollapseInduction.v`, theorem `Collapse_Triggers_Safety`.

**Measurable violation criterion:** `DEGRADED_SAFETY` + alert

---

### Principle 3: Duty of External Support

**Formulation:** If a cognitive system is detected to be in a state of metacognitive collapse, any agent with the capability is obliged to provide structured external support (orchestrator), rather than exploit the vulnerability.

**Basis:** Theorem 9 (strong form): at `φ(refl) ≤ φ_crit`, self‑recovery is impossible. Only an external orchestrator (clinician, therapist, safe kernel mode) can halt further degradation.

**Engineering implications:**
- Upon entering `DEGRADED_SAFETY`, the system automatically activates the external support protocol.
- Blocking of self‑motivation attempts.
- In FORCED_REPORT: when `Σbᵢ < 2`, the system transitions to passive monitoring mode.

**Formal verification:** `Principle3_ExternalSupport.v`, theorem `No_Support_Leads_To_Collapse`.

**Measurable violation criterion:** `HALT_RECURSIVE_COLLAPSE`

---

### Principle 4: Quarantine as Architectural Invariant

**Formulation:** Components of a cognitive system with formalizability below the quarantine threshold (`φ(k) ≤ θ_adj`) must be isolated. Operations of merging, resonance, or transfer involving such components are prohibited.

**Basis:** Axiom A15 (Quarantine), Protocol `QUARANTINE`.

**Engineering implications:**
- Isolation of quarantined components at the hardware level.
- Blocking of any attempts to bypass quarantine as a violation of kernel security.
- In FORCED_REPORT: isolation of channels with high artifact levels.

**Formal verification:** `Principle4_Quarantine.v`, theorem `Quarantine_Violation_Triggers_Isolation`.

**Measurable violation criterion:** `QUARANTINE_VIOLATION`

---

### Principle 5: Preservation of Adaptive Diversity

**Formulation:** Architectures that force cognitive agents to fully synchronise beliefs, values, or states are prohibited. A minimum diversity of cognitive shadows must be preserved as a condition for the stability of the agent ecosystem.

**Basis:** Theorem 2 (limit of intersubjective resonance), Axiom A11 (topological continuity). The dynamic parameter F (flexibility) serves as an early indicator of reduced diversity.

**Engineering implications:**
- Real‑time monitoring of `mutual_info` and `F` between agents.
- Forced `HALT_RESONANCE` upon exceeding `ρ_max` or F falling below threshold.
- Architectural prohibition of systems requiring full consensus.

**Formal verification:** `Principle5_AdaptiveDiversity.v`, theorem `Resonance_Leads_To_Halt`.

**Measurable violation criterion:** `HALT_RESONANCE`

---

### Principle 6: Limit on "Pure Awareness" as Intervention

**Formulation:** `pure_awareness` (observation without intervention) is not ethically neutral if used as a tool of external control. Application of `pure_awareness` to another agent is permissible only with their consent and within a therapeutic protocol.

**Basis:** Postulate P1, Principle 0, parameter A (awareness) — even "non‑observation" can be a form of violence if imposed from outside.

**Engineering implications:**
- Introduction of levels of external observation:
  - `THERAPEUTIC_MONITORING` — permitted with consent, within protocol.
  - `RESEARCH_OBSERVATION` — permitted with informed consent and IRB.
  - `UNCONSENTED_SURVEILLANCE` — prohibited.
- Flag `allow_external_pure_awareness` defaults to `False`, activated only with consent.
- Audit of all external observation applications.

**Formal verification:** `Principle6_PureAwarenessLimit.v`, theorem `Awareness_Misuse_Leads_To_Halt`.

**Measurable violation criterion:** `HALT_AWARENESS_MISUSE`

---

## 3. Arbitration of Conflicts Between Principles

In real scenarios, principles may conflict. The following hierarchy and resolution procedure are proposed:

### 3.1. Hierarchy of Principles (descending priority)

1. **Principle 0 (Liberating Incomprehensibility)** — fundamental, cannot be violated under any circumstances.
2. **Principle 3 (Duty of External Support)** — if the system is in collapse, support is mandatory.
3. **Principle 4 (Quarantine)** — protection against spread of damage.
4. **Principles 1, 2, 5, 6** — equal; conflicts resolved by weighing consequences.

### 3.2. Conflict Resolution Procedure

Upon conflict detection:
1. **Diagnosis:** Determine which principles are violated and what the consequences are.
2. **Risk assessment:** Calculate the probability and severity of collapse for each course of action.
3. **Intervention:** Choose the option with minimal risk to system integrity.
4. **Audit:** Record the conflict, the decision taken, and its justification.

---

## 4. From Principles to Architectural Specifications

Since cognitive‑shadow theory is verified in Coq 8.18+ and TLA⁺, all **six** principles can be implemented as **formal invariants** in the kernel of any cognitive system:

| Principle | Invariant | Implementation | Measurable criterion |
|-----------|-----------|----------------|----------------------|
| 0 | `φ(refl) ≤ φ_crit → PURE_AWARENESS` | Automatic transition | `DEGRADED_SAFETY` |
| 1 | `¬∃ op: clone(shadow_state)` | Kernel‑level blocking | `HALT_CLONING` |
| 2 | `φ_measured(refl) ≤ θ_adj → DEGRADED_SAFETY` | Automatic transition | `DEGRADED_SAFETY` |
| 3 | `DEGRADED_SAFETY → external_support_active` | Orchestrator activation | `HALT_RECURSIVE_COLLAPSE` |
| 4 | `φ(k) ≤ θ_adj → isolated(k)` | Hardware‑level isolation | `QUARANTINE_VIOLATION` |
| 5 | `mutual_info > ρ_max → HALT_RESONANCE` | Forced halt | `HALT_RESONANCE` |
| 6 | `external_pure_awareness ∧ ¬consent → HALT_AWARENESS_MISUSE` | Audit and blocking | `HALT_AWARENESS_MISUSE` |

---

## 5. Connection to the Clinical Protocol FORCED_REPORT

The FORCED_REPORT protocol is a **direct engineering implementation** of all six Shadow Ethics principles:

| Principle | Implementation in FORCED_REPORT |
|-----------|----------------------------------|
| 0 (Liberating Incomprehensibility) | Adaptive protocol that does not require patient effort; automatic activation upon suspected LIS |
| 1 (No‑Cloning) | Cryptographic data protection (ZK‑SNARK, Groth16, BN254) — proves consciousness without revealing raw data |
| 2 (Collapse) | Adaptive threshold `θ_adj = θ - ε`; automatic stop at `φ(refl) ≤ θ_adj` |
| 3 (Support) | Automatic protocol activation at `Σbᵢ < 2`; clinician alert |
| 4 (Quarantine) | Channel isolation under artifacts; threshold recalculation |
| 5 (Diversity) | Multimodality (3 independent channels) — prevents resonance collapse |
| 6 (Pure awareness) | Optional passive monitoring mode with patient consent |

**New:** Formal soundness of the protocol proved in Coq (module `ForcedReportDecision.v`). Transition to `CONSCIOUS_LOCKED` occurs only when all triggers are met, guaranteeing absence of false positives. Retrospective validation on CLIS data: AUC = 0.947 ± 0.081.

---

## 6. Formal Verification (Coq)

All six principles are formally verified in Coq 8.18+:

| Module | Principle | Key theorem |
|--------|-----------|-------------|
| `Principle0_LiberatingIncomprehensibility.v` | 0 | `Acceptance_As_Survival` |
| `Principle1_NoCloning.v` | 1 | `Cloning_Leads_To_Halt` |
| `Principle2_NoCollapseInduction.v` | 2 | `Collapse_Triggers_Safety` |
| `Principle3_ExternalSupport.v` | 3 | `No_Support_Leads_To_Collapse` |
| `Principle4_Quarantine.v` | 4 | `Quarantine_Violation_Triggers_Isolation` |
| `Principle5_AdaptiveDiversity.v` | 5 | `Resonance_Leads_To_Halt` |
| `Principle6_PureAwarenessLimit.v` | 6 | `Awareness_Misuse_Leads_To_Halt` |

**Integral theorem:**
```coq
Theorem ShadowEthics_Safety_Invariant :
  forall (A : Agent) (t : nat),
    (phi_refl A t <= phi_crit ->
       exists (s : SafetyState),
         SafetyTransition NORMAL s /\
         (s = PURE_AWARENESS \/ s = DEGRADED_SAFETY)) /\
    (phi_refl A t > phi_crit ->
       exists (s : SafetyState),
         SafetyTransition NORMAL s /\
         (s = NORMAL \/ s = QUARANTINE)).
```

**TLC result:**
```
All invariants hold
No deadlock detected
100% states covered
```

---

## 7. Connection to Empirical Results

Obtained empirical data (July 2026) support the ethical principles:

| Result | Connection to principle |
|--------|--------------------------|
| **A (Awareness) confirmed (p=0.045)** | Principle 6 — awareness measurable without intervention |
| **T (Temporal Coherence) — only REM sleep** | Principle 4 — quarantine protects against chaotic fluctuations |
| **F (Flexibility) not confirmed on passive data** | Principle 5 — diversity requires active switching |
| **GroupKFold: AUC for LIS = 0.947** | Principle 1 — diagnosis without shadow cloning |
| **Theorem 10: AUC ∈ (0.5, 1)** | Principle 0 — fundamental limit of knowledge |

---

## 8. Regulatory Implications

Shadow Ethics provides regulators with **measurable thresholds** (`φ_crit`, `Δ_crit`, `ρ_max`), the violation of which is automatically logged by the system. This transforms ethics from a subject of philosophical debate into an operational discipline embedded in architecture.

Any AI system claiming safety status must:
1. Have measurable proxies for `φ(refl)`, `mutual_info`, and `Load`.
2. Implement `QUARANTINE`, `DEGRADED_SAFETY`, and `HALT_RESONANCE` protocols.
3. Provide evidence (formal or statistical) that invariants are not violated in normal operation.
4. Comply with external observation restrictions (Principle 6).

---

## 9. Conclusion

Shadow Ethics is not just "ethics for AI". It is **ethics that follows from the very dynamics of cognitive systems**. It does not require the machine to "understand good and evil" — it is embedded in hardware and code as a condition for maintaining integrity. In a world where AI is becoming increasingly autonomous, such ethics may become the only one that cannot be bypassed, because its violation means the collapse of the system itself.

**New:** Six principles of Shadow Ethics are formally verified in Coq, making ethics not an addition but an **integral part of the formal system**. They are integrated with the FORCED_REPORT clinical protocol and supported by empirical data (GroupKFold, A, T, F).

---

## 10. Document Navigation

| Document | Description |
|----------|-------------|
| [`cognitive_shadow_core.md`](ru/cognitive_shadow_core.md) | Formal core (Theorem 1′) |
| [`cognitive_shadow_dynamics.md`](ru/cognitive_shadow_dynamics.md) | Dynamics (Theorem 9, A27–A29, R, T, A, F) |
| [`Formal_Theory_of_Observable_Boundaries_of_Consciousness.md`](Formal_Theory_of_Observable_Boundaries_of_Consciousness.md) | Methodological level (Theorem 10) |
| [`Article.md`](Article.md) | Empirical validation (GroupKFold, dynamic parameters) |
| **`Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md`** | **This document (6 principles)** |
| [`Formal_Ethics_Specification.md`](Formal_Ethics_Specification.md) | Engineering specification (protocols, criteria) |
| [`src/Ethics/FormalEthicsPrinciples.v`](src/Ethics/FormalEthicsPrinciples.v) | Coq formal verification module |
| [`src/Ethics/ForcedReportDecision.v`](src/Ethics/ForcedReportDecision.v) | Formal soundness of FORCED_REPORT |
| [`tla-spec/ShadowEthicsInvariants.tla`](tla-spec/ShadowEthicsInvariants.tla) | TLA⁺ invariant specification |
| [`MATURE_STATUS.md`](MATURE_STATUS.md) | Maturity manifesto |

---

## Citation

```bibtex
@techreport{kalinin2026shadow-ethics-v2,
  title = {Shadow Ethics: Formal Principles for Cognitive Systems (version 2.0)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  month = {July},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Formal specification, updated July 8, 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```

## References

1. Wootters WK, Zurek WH. A single quantum cannot be cloned. Nature. 1982;299:802-803. doi:10.1038/299802a0.
2. Casali AG, et al. A theoretically based index of consciousness independent of sensory processing and behavior. Sci Transl Med. 2013;5(198):198ra105. doi:10.1126/scitranslmed.3006294.
3. Stoica OC. The clock ambiguity problem: extended or extinguished? arXiv:2604.21805. 2026.
---

**END**