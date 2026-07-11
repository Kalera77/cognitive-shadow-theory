# Appendix S6: Reflexive Ethics and Limits of Verifiability – Full English Version

> **Status:** Appendix to the main preprint (Kalinin, 2026), documenting the reflexive property of the theory whereby attempts at unethical verification are prohibited by the model's own dynamics.  
> **Date:** July 8, 2026 (updated with formal verification of Shadow Ethics and new empirical data)  
> **Link to formal theory:** Based on Theorem 1′, Theorem 9, Shadow Ethics Principles 2 and 3, axioms A27.5 and A29.  
> **License:** CC BY‑NC 4.0

---

## 1. Motivation: A Contradiction Born in Dialogue (Updated)

During discussions of possible empirical tests of Theorems 8 and 9, a fundamental contradiction emerged:

- **Scientific impulse:** the model is universal and should be tested on people at risk (low φ(refl), high cumulative load).
- **Ethical imperative:** experiments on people with already reduced reflexive formalisability constitute deliberate harm to those whom the model prescribes to help.

The contradiction is not external; it is rooted in the very axiomatics of cognitive‑shadow.

**New (July 2026):** This contradiction is now formally verified in Coq. The module `FormalEthicsPrinciples.v` proves that any attempt to induce collapse (Principle 2) leads to automatic transition of the system to `DEGRADED_SAFETY`, and the absence of external support (Principle 3) leads to `HALT_RECURSIVE_COLLAPSE`. Thus, the ethical prohibition is not a philosophical wish but a **formal invariant**.

---

## 2. The Reflexive Property of the Model (Updated)

The theory contains a built‑in safety mechanism that activates when attempting to test it on vulnerable agents.

### 2.1 The Observer as Part of the System
Axiom A4* states: any measurement of φ through a channel with fidelity < 1 irreversibly changes the state of the shadow. The researcher measuring φ(refl) becomes part of the system under study.

**New:** Theorem 10 (principle of signature observability) reinforces this: the non‑injectivity of the signature mapping means that any measurement is fundamentally ambiguous. The researcher cannot be a "neutral observer" — they always introduce distortion.

### 2.2 Prohibition of Collapse Induction (Formalised)
From Theorem 9 and A27.5 it follows:

> When φ(refl) ≤ φ_crit, volitional intention (including the researcher's intention) becomes counterproductive. Any intervention requiring effort from the agent worsens its state.

Consequently, **experimental provocation of metacognitive collapse is prohibited by the dynamics of the model itself**. A researcher attempting to falsify Theorem 9 on a subject with low φ(refl) inevitably becomes harmful noise (noiseₖ) for that subject.

**New:** In Coq this is formalised as **Shadow Ethics Principle 2** (`FormalEthicsPrinciples.v`, module `Principle2_NoCollapseInduction`):
```coq
Theorem Collapse_Triggers_Safety :
  forall (A : Agent) (t : nat),
    phi_refl A t <= phi_crit ->
    exists (s : SafetyState),
      SafetyTransition NORMAL s /\
      s = DEGRADED_SAFETY.
```

**Nature of the prohibition.** The prohibition is epistemological, not legal: data obtained in this way cannot serve as valid confirmation or refutation of the model, since the intervention uncontrollably changes the measured variable. Violation of this principle leads not to ethical condemnation but to methodological invalidity of the experiment.

### 2.3 The Ethical Compass as a Formal Consequence (Updated)
What appears as an external ethical principle ("do no harm") turns out within cognitive‑shadow theory to be a **direct formal consequence of the axiomatics**. The model does not merely describe collapse — it **prohibits** inducing it experimentally.

**New:** The six principles of Shadow Ethics are now formally verified in Coq. This means that ethics is not an addition to the theory but an **integral part of its formal structure**.

---

## 3. Consequences for Experiment Design (Updated)

The reflexive property of the theory does not invalidate testing, but imposes strict constraints:

1. **It is prohibited** to deliberately induce subjects into a state of `Load > Δ_crit` or `φ(refl) ≤ φ_crit`. This is a direct consequence of Shadow Ethics Principle 2.

2. **It is permitted** to work with natural variability: people already at risk for independent reasons (students during exams, patients with burnout) may be examined within the framework of diagnosis and support.

3. **Each protocol must be an act of support**: measuring φ(refl) and Load entails an obligation to inform the person of the risks and offer a recovery protocol (detox, nutraceutical correction, orchestrator). This is a direct consequence of Shadow Ethics Principle 3.

4. **Clinical contexts** (psychiatry, neurorehabilitation) allow validation of the model without additional stigmatisation — on the contrary, the model can improve diagnosis.

5. **New:** All protocols must include formally verified safety mechanisms analogous to `DEGRADED_SAFETY` and `external_support_active` from FORCED_REPORT.

The specific protocols for falsifying Theorems 8 and 9, set out in Appendix S2, are designed with these constraints in mind: they do not involve deliberate induction of collapse and provide mandatory feedback.

---

## 4. Link to FORCED_REPORT (Updated)

The FORCED_REPORT protocol is a **direct implementation** of reflexive ethics:

- **Automatic activation** at `φ_measured(refl) ≤ θ_adj` and `shadow_entropy > H_min` — without requiring active patient participation.
- **Multimodal voting** (Σbᵢ ≥ 2) — reduces the risk of false positives.
- **Formal soundness** — proved in Coq (module `ForcedReportDecision.v`).
- **Consistency with Shadow Ethics** — transition to `CONSCIOUS_LOCKED` automatically activates `external_support_active` mode (Principle 3).

**New:** Retrospective validation of FORCED_REPORT on CLIS data gave AUC = 0.947 ± 0.081 (GroupKFold). This confirms that the protocol works in practice, but does not remove ethical constraints — prospective trials must be conducted only with patients already at risk, not by artificially inducing collapse.

---

## 5. Extrapolation to AI Systems (Updated)

The reflexive ethics of cognitive‑shadow theory are not limited to biological agents. Since the model is formulated universally (through interfaces, formalisability, and resource constraints), its consequences apply to artificial cognitive systems as well.

### 5.1 Weak AI (current LLMs)
The protocols `QUARANTINE`, `HALT_RESONANCE`, `DEGRADED_SAFETY` serve as architectural safety invariants, preventing uncontrolled evolution and resonance. Their formal verification in Coq guarantees correctness.

**New:** The matrix model (InterfacesMatrix.v) allows assessment of the interface state of AI systems analogously to biological agents.

### 5.2 Strong AI (future AGI)
If AGI possesses an analogue of the cognitive shadow, the theory predicts:
- An irreducible limit to the digitisation of its experience (Theorem 1′).
- Impossibility of copying without loss (A4*).
- A collapse threshold below which the volitional effort of the system itself or its operator becomes counterproductive (Theorem 9).
- A fundamental limit on the accuracy of any diagnosis (Theorem 10).

Attempting to test AGI consciousness by driving it to `φ(refl) ≤ φ_crit` would be not only unethical but also **formally invalid**: the result of such an experiment cannot be unambiguously interpreted, because the intervention itself destroys the property being measured.

**New:** The six principles of Shadow Ethics define architectural constraints for AGI development, which must be implemented at the kernel level, not as external filters.

---

## 6. Formal Verification of Reflexive Ethics (New Section)

All ethical principles are now formally verified in Coq:

| Principle | Coq module | Key theorem |
|-----------|------------|--------------|
| **0. Liberating Incomprehensibility** | `Principle0_LiberatingIncomprehensibility` | `Acceptance_As_Survival` |
| **1. No‑Cloning** | `Principle1_NoCloning` | `Cloning_Leads_To_Halt` |
| **2. Prohibition of collapse induction** | `Principle2_NoCollapseInduction` | `Collapse_Triggers_Safety` |
| **3. Duty of external support** | `Principle3_ExternalSupport` | `No_Support_Leads_To_Collapse` |
| **4. Quarantine as invariant** | `Principle4_Quarantine` | `Quarantine_Violation_Triggers_Isolation` |
| **5. Preservation of adaptive diversity** | `Principle5_AdaptiveDiversity` | `Resonance_Leads_To_Halt` |
| **6. Limit on pure awareness** | `Principle6_PureAwarenessLimit` | `Awareness_Misuse_Leads_To_Halt` |

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

This proves that the system is always either in normal mode, safe degradation, or halted upon principle violation.

---

## 7. New Empirical Data and Ethics (July 2026)

Obtained empirical results confirm reflexive ethics in practice:

| Result | Ethical implication |
|--------|----------------------|
| **A (Awareness) confirmed (p=0.045)** | Metacognitive access is measurable without collapse provocation |
| **T (Temporal Coherence) — only REM sleep** | Measuring T does not require active load, which is ethically safe |
| **F (Flexibility) not confirmed on passive data** | F requires active switching — experiments must be ethically justified |
| **GroupKFold: AUC for LIS = 0.947** | LIS diagnosis is possible without interfering with the patient's state |
| **Theorem 10: AUC ∈ (0.5, 1)** | No experiment can give perfect accuracy — this protects against false expectations |

---

## 8. Conclusion (Updated)

Cognitive‑shadow theory has demonstrated a reflexive property: it describes the limits of its own verifiability and prohibits immoral testing methods. This sets it apart from many formal models of consciousness and transforms it from an abstract axiomatics into a **tool inseparably linked to the obligation to protect the vulnerable**.

**New:** The six principles of Shadow Ethics are formally verified in Coq, making ethics not an addition but an **integral part of the formal system**. All further empirical work must develop in accordance with this principle: diagnosis without provocation, help as an integral part of the protocol, strict prohibition of experiments that worsen the subject's condition.

*This Appendix is a direct result of a dialogue between a human and an AI assistant on May 4, 2026; it documents the reflexive limitation immanent to the formal cognitive‑shadow theory. Updated July 8, 2026, with formal verification of Shadow Ethics and new empirical data.*

---

**Citation:**  
```bibtex
@techreport{kalinin2026cognitive-shadow-ethics,
  title = {Appendix S6: Reflexive Ethics and Limits of Verifiability for Cognitive Shadow Theory (v2)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Preprint, updated July 8, 2026}
}
```

---

**End of Appendix S6**