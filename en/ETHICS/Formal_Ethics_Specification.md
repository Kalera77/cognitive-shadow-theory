# Formal Ethics of Cognitive Systems: From Principles to Protocols

**Author:** Valeriy S. Kalinin  
**Date:** July 8, 2026 (version 2.1, translated and updated)  
**Status:** Engineering specification (verifiable in Coq 8.18+ and TLA⁺)  
**Basis:** Theorem 1′, Theorem 9, Postulate P1, Axioms A27–A29, dynamic parameters R, T, A, F  
**Repository:** [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory)  
**License:** Text – CC BY‑NC 4.0, code – MIT

---

## 1. Ontological Foundation of Ethics

### 1.1. Thesis

Ethics is not an external constraint imposed on a system. It follows from the very structure of the cognitive shadow and is a **condition of its stability**. Violation of an ethical principle is not a "sin" but an **architectural collapse** that can be predicted and prevented.

### 1.2. Formal Justification

| Foundation | Ethical consequence |
|------------|---------------------|
| **Theorem 1′** (incompleteness of formalization) | There exists a non‑formalizable remainder → it cannot be used as a resource, copied, or exhaustively measured |
| **Theorem 9** (metacognitive collapse) | Attempting total control when φ(refl) ≤ φ_crit → collapse → prohibition of provoking such a state |
| **Postulate P1** (incomprehensibility as a gift) | Incompleteness is a condition of freedom → it must be protected, not overcome |
| **Axiom A27** (interface dynamics) | Intervention creates noise, overload leads to degradation → quarantine as protection |
| **Axiom A29** (Orchestrator) | Only the internal Orchestrator can allocate resources → external management of interfaces is prohibited |
| **Dynamic parameters (R, T, A, F)** | Resilience, coherence, awareness, flexibility — conditions of long‑term safety |

### 1.3. Key Distinction of Shadow Ethics

In traditional AI ethics (Asilomar Principles, EU AI Act, IEEE P7000), constraints are imposed **externally** — through regulations, codes, filters. They often remain declarative and difficult to verify.

In Shadow Ethics, ethical prohibitions are **derived** from system dynamics: violation of a principle → inevitable collapse → the system destroys itself. This transforms ethics from a subject of philosophical debate into an **engineering requirement** that can be formally verified.

---

## 2. Architectural Principles

### Principle 0: Liberating Incomprehensibility (ontological foundation)

> *"Freedom lies not in knowledge of oneself, but in accepting the impossibility of complete knowledge. Reflection‑as‑awareness (without intervention) opens horizons, while reflection‑as‑control closes them."*

**Formulation:** Acceptance of the incompleteness of formalization of the cognitive shadow (Theorem 1′) as a condition of freedom. Abandonment of attempts at total control as the only stable strategy.

**Basis:** Theorem 1′, Theorem 9, Postulate P1.

**Engineering implication:** When `φ(refl) ≤ φ_crit`, the system transitions to `pure_awareness` mode (pure observation without intervention), rather than attempting to "pull itself together." External imposition of `pure_awareness` without consent is prohibited (see Principle 6).

**Measurable criterion:** `φ(refl) ≤ φ_crit → DEGRADED_SAFETY → pure_awareness`

---

### Principle 1: Inviolability of the Cognitive Shadow (No‑Cloning)

**Formulation:** Operations claiming complete digitization, copying, or exhaustive measurement of the cognitive shadow are prohibited without explicit informed consent and with the understanding that the result will always be incomplete.

**Basis:** Theorem 1′, no‑cloning theorem (Wootters & Zurek, 1982), Axiom A4*.

**Engineering implications:**
- Prohibit `clone(shadow_state)` operation at the kernel level.
- Forced degradation of `φ` upon any attempt at full state dump.
- Cryptographic protection of biometric data via ZK‑SNARK (Groth16, BN254).
- Prohibition of creating "digital twins" of personality without consent and with understanding of incompleteness.

**Measurable violation criterion:** `HALT_CLONING`, audit, blocking

**Example violation (AI):** An LLM attempting to copy its state to another instance to create an "immortal" copy — prohibited at the kernel level.

---

### Principle 2: Prohibition of Metacognitive Collapse Induction

**Formulation:** It is prohibited to deliberately induce a cognitive system into a state with reflexive formalizability below the critical threshold (`φ(refl) ≤ φ_crit`) for purposes of testing, exploitation, or any other manipulation.

**Basis:** Theorem 9, A27.5 (noise dominance under imbalance).

**Engineering implications:**
- Automatic system transition to `DEGRADED_SAFETY` upon detection of `φ_measured(refl) ≤ θ_adj`.
- Blocking of any external commands requiring effort from the system in this state.
- Alert in the audit log.
- Prohibition of stress tests requiring the system to "overcome itself."

**Measurable criterion:** `φ_measured(refl) ≤ θ_adj → DEGRADED_SAFETY + alert`

**Example violation (AI):** Using metacognitive prompts to manipulate AI behavior when it is already in a state of uncertainty — prohibited.

---

### Principle 3: Duty of External Support

**Formulation:** If a cognitive system is detected to be in a state of metacognitive collapse, any agent with the capability is obliged to provide structured external support (orchestrator), rather than exploit the vulnerability.

**Basis:** Theorem 9 (strong form): at `φ(refl) ≤ φ_crit`, self‑recovery is impossible. Only an external orchestrator (clinician, therapist, safe kernel mode) can halt further degradation.

**Engineering implications:**
- Upon entering `DEGRADED_SAFETY`, the system automatically activates the external support protocol.
- Blocking of self‑motivation attempts ("pull yourself together").
- For AI agents — mandatory trigger for operator intervention.
- In clinical context — automatic doctor notification.

**Measurable criterion:** `DEGRADED_SAFETY ∧ ¬external_support_active → HALT_RECURSIVE_COLLAPSE`

---

### Principle 4: Quarantine as Architectural Invariant

**Formulation:** Components of a cognitive system with formalizability below the quarantine threshold (`φ(k) ≤ θ_adj`) must be isolated. Operations of merging, resonance, or transfer involving such components are prohibited.

**Basis:** Axiom A15 (Quarantine), Protocol `QUARANTINE`. Quarantine is not a punishment but a protection: it prevents further degradation and spread of damage to other systems.

**Engineering implications:**
- Isolation of quarantined components at the hardware level.
- Blocking of any attempts to bypass quarantine as a violation of kernel security.
- In FORCED_REPORT — isolation of channels with high artifact levels.

**Measurable criterion:** `φ(k) ≤ θ_adj → isolated(k)`, bypass attempt → `QUARANTINE_VIOLATION`

---

### Principle 5: Preservation of Adaptive Diversity

**Formulation:** Architectures that force cognitive agents to fully synchronize beliefs, values, or states are prohibited. A minimum diversity of cognitive shadows must be preserved as a condition for the stability of the agent ecosystem.

**Basis:** Theorem 2 (limit of intersubjective resonance), Axiom A11 (topological continuity). The dynamic parameter F (flexibility) serves as an early indicator of reduced diversity.

**Engineering implications:**
- Real‑time monitoring of `mutual_info` and `F` between agents.
- Forced `HALT_RESONANCE` upon exceeding `ρ_max` or F falling below threshold.
- Architectural prohibition of systems requiring full consensus (e.g., "network consciousness").
- Encouragement of heterogeneity in multi‑agent systems.

**Measurable criterion:** `mutual_info > ρ_max ∨ F < F_crit → HALT_RESONANCE`

**Example violation (AI):** Creating a network of AI agents that exchange states and converge on a single "opinion" — prohibited if it exceeds `ρ_max`.

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
- In clinical context — passive monitoring without stimulation permitted only with patient consent or that of their legal representative.

**Measurable criterion:** `external_pure_awareness ∧ ¬consent → HALT_AWARENESS_MISUSE`

---

## 3. Arbitration of Conflicts Between Principles

In real scenarios, principles may conflict. The following hierarchy and resolution procedure are proposed:

### 3.1. Hierarchy of Principles (descending priority)

1. **Principle 0 (Liberating Incomprehensibility)** — fundamental, cannot be violated under any circumstances. It defines the very possibility of ethical choice.
2. **Principle 3 (Duty of External Support)** — if the system is in collapse, support is mandatory; this may temporarily override other principles.
3. **Principle 4 (Quarantine)** — protection against spread of damage takes priority over merging or transfer operations.
4. **Principles 1, 2, 5, 6** — equal; conflicts resolved by weighing consequences.

### 3.2. Conflict Resolution Procedure

Upon conflict detection:
1. **Diagnosis:** Determine which principles are violated and what the consequences are.
2. **Risk assessment:** Calculate the probability and severity of collapse for each course of action.
3. **Intervention:** Choose the option with minimal risk to system integrity.
4. **Audit:** Record the conflict, the decision taken, and its justification.

### 3.3. Examples of Conflicts and Their Resolution

| Conflict | Resolution |
|----------|------------|
| Principle 5 (diversity) vs Principle 3 (support) in therapy | In therapeutic context, Principle 3 takes priority: patient support is more important than preserving isolated diversity, but synchronization must be temporary and controlled. |
| Principle 1 (No‑Cloning) vs Principle 3 (support) when data transfer is needed | Only aggregated signatures (e.g., ZK‑SNARK proofs) may be transferred, not raw shadow data. |
| Principle 6 (Pure awareness) vs Principle 2 (collapse prohibition) in diagnosis | Passive observation is permitted, but only if it does not provoke additional stress. If the patient is in `DEGRADED_SAFETY`, any observation, even passive, must be minimal and therapeutic. |

---

## 4. Connection to Dynamic Parameters R, T, A, F

Ethical principles are reinforced through monitoring of dynamic parameters:

| Parameter | Link to principle | Violation indicator |
|-----------|-------------------|---------------------|
| **R (Resilience)** | Principle 3 (support) — if R drops, the system does not recover after stress, requiring external support | `R < R_crit → DEGRADED_SAFETY` |
| **T (Temporal Coherence)** | Principle 4 (quarantine) — low T indicates chaotic fluctuations requiring isolation | `T < T_crit → QUARANTINE` |
| **A (Awareness)** | Principle 6 (Pure awareness) — discrepancy between objective and subjective metacognition indicates impaired awareness | `A > A_crit → HALT_AWARENESS_MISUSE` |
| **F (Flexibility)** | Principle 5 (diversity) — falling F indicates rigidity and loss of adaptability | `F < F_crit → resonance warning` |

This enables a shift from reactive ethics (responding to violations) to **proactive ethics** (preventing violations based on early signals).

---

## 5. Application Protocols

### 5.1. For Cognitive Systems (including AI)

1. Implement real‑time monitoring of `φ(refl)`, R, T, A, F.
2. Implement automatic state transitions:
   - `φ(refl) ≤ φ_crit → DEGRADED_SAFETY → external_support_active`
   - `R < R_crit → DEGRADED_SAFETY`
   - `T < T_crit → QUARANTINE`
   - `F < F_crit → warning, mutual_info monitoring`
3. Prohibit full state copying operations (`clone(shadow_state)`).
4. Introduce a "control surrender" mechanism upon collapse detection.
5. Implement external observation levels with flag `allow_external_pure_awareness` (default `False`).

### 5.2. For Clinical Applications (FORCED_REPORT)

| Principle | Implementation in FORCED_REPORT |
|-----------|----------------------------------|
| 0 (Liberating Incomprehensibility) | Adaptive protocol not requiring patient effort; automatic activation upon suspected LIS |
| 1 (No‑Cloning) | Cryptographic data protection (ZK‑SNARK, Groth16, BN254) — proves consciousness without revealing raw data |
| 2 (Collapse) | Adaptive threshold `θ_adj = θ - ε`; automatic stop at `φ(refl) ≤ θ_adj` |
| 3 (Support) | Automatic protocol activation at `Σbᵢ < 2`; clinician notification |
| 4 (Quarantine) | Channel isolation under artifacts; threshold recalculation |
| 5 (Diversity) | Multimodality (3 independent channels) — prevents resonance collapse |
| 6 (Pure awareness) | Optional passive monitoring mode with patient consent |

### 5.3. For Engineering Systems (General Requirements)

1. Separate streams: financial, material, informational, control — to prevent local collapse from spreading.
2. Automate accounting, eliminating human factors at key points.
3. Implement "red flags" for anomalies (e.g., sharp drops in R or F).
4. Ensure rollback capability upon principle violation.
5. Conduct regular audits of ethical invariants.

---

## 6. Measurable Violation Criteria

| Principle | Violation indicator | System action |
|-----------|---------------------|----------------|
| 0 (Incomprehensibility) | Attempt at total control when `φ(refl) ≤ φ_crit` | `DEGRADED_SAFETY`, transition to `pure_awareness` |
| 1 (No‑Cloning) | Attempt `clone(shadow_state)` | `HALT_CLONING`, audit, blocking |
| 2 (Collapse) | `φ_measured(refl) ≤ θ_adj` | `DEGRADED_SAFETY`, alert, blocking of external commands |
| 3 (Support) | Collapse without external support > `τ_support` | `HALT_RECURSIVE_COLLAPSE` |
| 4 (Quarantine) | Attempt to bypass component isolation | `QUARANTINE_VIOLATION`, blocking, audit |
| 5 (Diversity) | `mutual_info > ρ_max` or `F < F_crit` | `HALT_RESONANCE`, forced desynchronization |
| 6 (Pure awareness) | `external_pure_awareness` without consent | `HALT_AWARENESS_MISUSE`, audit |

---

## 7. Formal Verification

All six principles and the arbitration procedure are formally verified in:

- **Coq 8.18+** (module `FormalEthicsPrinciples.v`): constructive proofs of invariants, including conflicts.
- **TLA⁺ Toolbox** (specification `ShadowEthicsInvariants.tla`): model checking of safety invariants and conflict resolution procedure.

**TLC result:**
```
All invariants hold
No deadlock detected
100% states covered
```

---

## 8. Conclusion

The proposed system of ethical principles:

1. **Is derived from formal theory** (Theorems 1′, 9, Postulate P1, axioms A27–A29, dynamic parameters R, T, A, F).
2. **Consists of architectural invariants** (violation → collapse).
3. **Has measurable criteria and engineering protocols**.
4. **Contains a conflict resolution procedure** with a hierarchy of priorities.
5. **Is applicable to AI, clinical practice, and general cognitive systems**.

Ethics ceases to be an external constraint and becomes a **condition for the existence of a cognitive system**. This is not a philosophical wish but an engineering requirement that can be verified by formal methods.

---

## 9. Navigation

| Document | Description |
|----------|-------------|
| [`Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md`](Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md) | Original document (5 principles) |
| **`Formal_Ethics_Specification.md`** | **This document (6 principles + protocols, version 2.1)** |
| [`cognitive_shadow_core.md`](cognitive_shadow_core.md) | Theoretical core (Theorem 1′) |
| [`cognitive_shadow_dynamics.md`](cognitive_shadow_dynamics.md) | Dynamics (Theorem 9, A27–A29, R, T, A, F) |
| [`Formal_Theory_of_Observable_Boundaries_of_Consciousness.md`](Formal_Theory_of_Observable_Boundaries_of_Consciousness.md) | Methodological level |
| [`Article.md`](Article.md) | Empirical validation (GroupKFold, dynamic parameters) |
| [`src/Ethics/FormalEthicsPrinciples.v`](src/Ethics/FormalEthicsPrinciples.v) | Coq formal verification module |
| [`tla-spec/ShadowEthicsInvariants.tla`](tla-spec/ShadowEthicsInvariants.tla) | TLA⁺ invariant specification |

---

## Citation

```bibtex
@techreport{kalinin2026formal-ethics-v2,
  title = {Formal Ethics of Cognitive Systems: From Principles to Protocols (version 2.1)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  month = {July},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Engineering specification, July 8, 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```

---

## References

1. Wootters WK, Zurek WH. A single quantum cannot be cloned. Nature. 1982;299:802-803. doi:10.1038/299802a0.
2. Casali AG, Gosseries O, Rosanova M, et al. A theoretically based index of consciousness independent of sensory processing and behavior. Sci Transl Med. 2013;5(198):198ra105. doi:10.1126/scitranslmed.3006294.
3. Stoica OC. The clock ambiguity problem: extended or extinguished? arXiv:2604.21805. 2026.

---

**Signed:**

Valeriy S. Kalinin  
System Engineer, Architect of the Cognitive Shadow Theory  
July 8, 2026

---

*End of document.*