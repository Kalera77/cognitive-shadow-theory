
# Formal Theory of Observable Boundaries of Consciousness 

**Status:** Mature methodological theory (formerly – “Principle of Signature Observability”)  
**Author:** Valeriy S. Kalinin  
**Date:** July 8, 2026 (updated)  
**Repository:** [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory)  
**License:** Text – CC BY‑NC 4.0, code – MIT  
**History:** Originally published as “Principle of Signature Observability of the Cognitive Shadow” (June 30, 2026). Renamed to “Formal Theory of Observable Boundaries of Consciousness” upon recognition of the maturity of the methodological framework.

---

## Part of the Methodological Triad “Theory — Principle — Empirics”

This document represents the **methodological level** of the triad, now an independent formal theory.
- Theoretical level: [`cognitive_shadow_core.md`](cognitive_shadow_core.md), [`cognitive_shadow_dynamics.md`](cognitive_shadow_dynamics.md)
- Empirical level: [`Article.md`](Article.md) (updated version with GroupKFold and dynamic parameters)
- Maturity manifest: [`MATURE_STATUS.md`](MATURE_STATUS.md)

---

## 1. Central Claim

**The Formal Theory of Observable Boundaries of Consciousness** establishes the fundamental limits of what can be observed, measured, and reconstructed with respect to subjective experience (the cognitive shadow) from physical signatures.

The theory does not claim that consciousness is unobservable altogether. It claims that:

1. **Direct observation** of subjective experience is fundamentally impossible (it is the “thing‑in‑itself” in the Kantian sense).
2. **Indirect observation** through signatures is possible, but limited by fundamental physical and informational barriers.
3. **Reconstruction** of the state of consciousness from signatures has a strict accuracy limit, expressed through the entropy of the preimage. Adding dynamic measurements (time derivatives, stability parameters) can narrow the set of possible interpretations, but cannot eliminate ambiguity entirely.

---

## 2. Formal Formulation

Let:
- **T** be the set of possible states of the cognitive shadow (subjective experience)
- **P** be the set of observable physical states (EEG, behaviour, physiology)
- **I: T → P** be the signature mapping, linking shadow states to their physical manifestations

Then four properties hold:

### 2.1. Unobservability of the Shadow (Direct)
$$\forall t \in T, \quad t \notin P$$
The state of the shadow is not a physical state. This is an ontological distinction, not an epistemological limitation.

### 2.2. Existence of Signatures
$$\forall t \in T, \quad \exists p \in P: \quad I(t) = p$$
Every shadow state leaves a measurable trace in the physical world. This makes a science of consciousness possible.

### 2.3. Non‑injectivity of the Mapping (Degeneracy Problem)
$$\exists t_1, t_2 \in T: \quad t_1 \neq t_2 \wedge I(t_1) = I(t_2)$$
Different shadow states may have identical or very close signatures. Reconstruction is fundamentally ambiguous.

**Empirical update (July 2026):** Under correct subject‑wise cross‑validation (GroupKFold), the index φ distinguishes VS from MCS− with AUC = 0.742 ± 0.149 — significantly better than chance but far from perfect. This indicates that signatures of VS and MCS− partially overlap but are not identical; non‑injectivity manifests as a broad distribution rather than absolute identity.

### 2.4. Bounded Reconstruction
For any observable $p \in P$, the set of possible shadow states $\{t \in T: I(t) = p\}$ has cardinality $|T_p| \geq 1$, and reconstruction accuracy is bounded by:

$$\text{Accuracy} \leq 1 - \frac{H(T_p)}{H(T)}$$

where $H$ is Shannon entropy.

**Important clarification:** This inequality sets an *upper bound* on accuracy. The actual accuracy depends on the choice of reconstruction algorithm and the available signatures. Adding dynamic measurements (time derivatives, parameters R, T, A, F) reduces $H(T_p)$, narrowing the set of possible interpretations, but cannot reverse the inequality.

---

## 3. Theorem on the Limit of Reconstruction Accuracy

**Statement.** For any reconstruction algorithm $R: P \to T$:

$$P(R(I(t)) = t) \leq \frac{1}{|T_p|}$$

**Proof.** Follows from the non‑injectivity of $I$ and the principle of insufficient reason (in the absence of additional information, all states in the preimage are equally probable).

**Corollary: impossibility of complete digitisation.** No digitisation algorithm $D: T \to S$ (where $S$ is the set of formal systems) can preserve all properties of the cognitive shadow. This is a direct consequence of Theorem 1′ of the cognitive shadow theory.

**Dynamic extension.** If instead of a static mapping $I$, we consider an augmented mapping including time derivatives $I_{dyn}: T \to P \times \dot{P}$, the cardinality of the preimage may decrease but remains >1 for some states. This is confirmed empirically: adding parameter A (awareness) increases discrimination between groups in metacognitive tasks (mixed model: p = 0.045).

---

## 4. Connection to Fundamental Physical Limits

The theory of observable boundaries of consciousness is not an arbitrary philosophical construct. It rests on three independent physical barriers:

### 4.1. Landauer’s Principle
The erasure of one bit of information inevitably releases heat $kT \ln 2$. Any measurement of the cognitive shadow physically alters its state, making “free” observation impossible.

### 4.2. Holevo Bound
The maximum amount of classical information extractable from a quantum system is bounded by $\chi$. Formalizability $\varphi(k)$ has a physical ceiling. Even with optimal measurement, part of the information about the shadow remains inaccessible.

### 4.3. No‑cloning Theorem
It is impossible to create an exact copy of an arbitrary unknown quantum state. The cognitive shadow, if it includes quantum degrees of freedom, is fundamentally non‑copyable. This explains why the transfer of experience is always accompanied by degradation of formalizability (axiom A4*).

---

## 5. Empirical Illustration (Updated)

### 5.1. Signature Mapping in the Current Heuristic Model
In the FORCED_REPORT protocol and validation study, the mapping $I$ is approximated by the reflexive index $\varphi = (C \cdot S \cdot I)^{1/3}$, where C, S, I are capacity, selectivity, and integrity. This is a **first‑order heuristic model**, not a strict derivation from the theory, but a working operationalisation.

Clinical states produce measurable signatures (averaged across epochs):
- LIS → $\varphi = 0.301 \pm 0.073$
- MCS+ → $\varphi = 0.189 \pm 0.036$
- VS → $\varphi = 0.168 \pm 0.049$
- MCS− → $\varphi = 0.154 \pm 0.030$

These means show a monotonic decrease from LIS to MCS−, but with overlap, especially between VS and MCS−.

### 5.2. Degeneracy Problem in Data
Under correct subject‑wise cross‑validation (GroupKFold), classification of VS vs MCS− yields AUC = 0.742 ± 0.149. This is significantly better than chance (0.5), but substantially lower than distinguishing LIS from healthy (AUC = 0.947). Thus, $\varphi$ contains some information for distinguishing VS from MCS−, but not enough for reliable clinical diagnosis.

This is a direct manifestation of the non‑injectivity of $I$: for $p \approx 0.16–0.17$, the set $|T_p| > 1$, including both VS and MCS− states. The preimage size is not infinite — with more complex features (dynamic parameters) ambiguity can be reduced.

### 5.3. Refined Accuracy Limit
For the VS vs MCS− case, where $|T_p| = 2$ (or slightly more), the theoretical accuracy limit is:

$$\text{Accuracy} \leq 1 - \frac{H(T_p)}{H(T)}$$

If $T_p$ contains two approximately equally entropic states, the maximum accuracy may be around 0.75–0.80. The empirical AUC of 0.742 lies in this range, consistent with the theory. Adding additional dynamic features (e.g., coefficient of variation of φ — parameter T) may reduce $H(T_p)$ and improve accuracy, which is being investigated in current research.

### 5.4. Cross-population validation as an illustration of Theorem 10

Cross-population validation (training on DOC, testing on CLIS) yielded AUC = 0.887 — one of the best results in the literature. However, transfer to sleep (CAP) did not exceed chance (AUC ≈ 0.5). This directly illustrates **non‑injectivity of the signature mapping** (Theorem 10): signatures of clinical pathology (DOC, LIS) do not coincide with those of physiological changes (sleep).

This confirms the **Kantian turn** of the theory: we cannot observe the shadow itself, but we can analyse its signatures with due regard for fundamental limits. Different states of consciousness (clinical pathologies vs natural sleep) produce different signatures, and reconstruction of the shadow state from signatures is always limited by the domain from which data are drawn.

Thus, Theorem 10 is not an abstract mathematical result — it has direct empirical confirmation: AUC never reaches 1.0, and reconstruction accuracy depends on context. This fundamental limitation must be taken into account when interpreting any consciousness biomarkers.

---

## 6. Philosophical Foundations

### 6.1. Connection to Kantian Transcendentalism

| Kant | Theory of Observable Boundaries of Consciousness |
|------|--------------------------------------------------|
| Thing‑in‑itself (Ding an sich) | Cognitive shadow (unobservable) |
| Appearance (Erscheinung) | Signatures (observable) |
| Transcendental conditions | Formal limits of reconstruction |
| Critical philosophy | Empirical validation of limits |

As Kant argued: “We cannot know the thing‑in‑itself, but we can study its appearances.” Similarly, the theory states: “We cannot observe the shadow itself, but we can analyse its signatures, taking into account fundamental limits.”

### 6.2. Connection to the Problem of Other Minds
The theory solves a classic philosophical problem: how can we know that other beings possess consciousness? Answer: through the observation of signatures, with attention to reconstruction limits. If signatures correspond to conscious experience (e.g., stable high φ in LIS), we can conclude with some confidence that consciousness is present, but never with absolute certainty.

### 6.3. Connection to Operationalism (Bridgman, 1927)
Scientific concepts must be defined through measurement operations. The cognitive shadow is defined not by its intrinsic nature, but through the operations of observing its signatures — with explicit indication of accuracy limits. This makes the theory empirically testable and falsifiable.

---

## 7. Practical Implications

### 7.1. For the FORCED_REPORT Protocol
The protocol is a direct implementation of the theory:
- **Observed signatures:** EEG activity (φ), eye movements, heart rate variability.
- **Reconstruction of shadow properties:** through multimodal voting (rule “two out of three”), which reduces reconstruction ambiguity.
- **Limitations:** the theory predicts that even with an optimal set of signatures, some false positives and false negatives will remain. Hence the protocol requires prospective validation and should not be used as the sole criterion.

### 7.2. For Empirical Validation
All empirical tests of the cognitive shadow theory are tests of the theory of observable boundaries:
- We do not measure the cognitive shadow itself.
- We measure correlations between signatures and clinical states.
- High correlations (ρ > 0.6 for CLIS vs healthy, AUC > 0.9) confirm that signatures carry information about shadow properties, but never reach 1.0.

### 7.3. For AI Ethics (Shadow Ethics)
The theory has critical ethical consequences:
- We cannot directly observe whether AI possesses consciousness.
- But we can observe signatures of consciousness (behaviour, architecture, reactions).
- If signatures correspond to conscious experience, we are obliged to treat the system as conscious (presumption of consciousness) — even understanding that reconstruction is incomplete.

This is enshrined in the principles of Shadow Ethics: inviolability of the shadow, prohibition of collapse induction, duty of external support.

---

## 8. Limitations of the Theory

### 8.1. Problem of Incomplete Signatures
Not all properties of the cognitive shadow leave measurable signatures. Some aspects of subjective experience may be fundamentally unobservable. The theory does not claim that all signatures are known; it merely sets boundaries for any signature system.

### 8.2. Problem of Signature Interpretation
The observation of signatures requires interpretation, which itself depends on theoretical presuppositions. Different theories of consciousness may interpret the same signatures differently. The Theory of Observable Boundaries does not solve this problem, but makes it explicit, requiring that the theoretical framework be stated for any interpretation.

### 8.3. Problem of Context‑Dependence
The dominance of components C, S, I changes depending on clinical context (for CLIS, C dominates; for MCS− vs MCS+, I dominates). This indicates that the mapping I is not universal, but depends on the state of the system. The theory predicts such dependence but does not provide a way to fully account for it without transitioning to a matrix model (second order).

---

## 9. Conclusion

**The Formal Theory of Observable Boundaries of Consciousness** establishes that:

1. Direct observation of consciousness is impossible (ontological limit).
2. Indirect observation via signatures is possible (methodological opportunity), but limited by physical laws.
3. Reconstruction has a strict accuracy limit, expressed through the entropy of the preimage.
4. These limits are not arbitrary but derive from fundamental physical laws (Landauer, Holevo, no‑cloning) and the axiomatics of cognitive shadow theory.

The theory is not a final answer to the “hard problem of consciousness.” It is a **map of the boundaries** beyond which scientifically inaccessible territory begins — and therefore worthy of ontological modesty and ethical respect. It provides a language for discussing these boundaries and criteria for evaluating any empirical research on consciousness.
Updated empirical data (GroupKFold, dynamic parameters) are consistent with the theory’s predictions and point the way to its further development — from scalar heuristics to matrix and dynamic models.

---

## Navigation within the Triad

- **Theory (formal core):** [`cognitive_shadow_core.md`](cognitive_shadow_core.md), [`cognitive_shadow_dynamics.md`](cognitive_shadow_dynamics.md)
- **Methodology (this document):** [`Formal_Theory_of_Observable_Boundaries_of_Consciousness.md`](Formal_Theory_of_Observable_Boundaries_of_Consciousness.md)
- **Empirics (updated):** [`Article.md`](Article.md)
- **Maturity manifest:** [`MATURE_STATUS.md`](MATURE_STATUS.md)
- **Coq documentation:** [`Documentation of Coq Modules (CognitiveShadow).md`](Documentation%20of%20Coq%20Modules%20(CognitiveShadow).md)

---

**Document updated July 8, 2026, with GroupKFold results and dynamic parameters (A, T, F). All empirical illustrations are aligned with current data.**

---

## References

1. Wootters WK, Zurek WH. A single quantum cannot be cloned. Nature. 1982;299:802-803. doi:10.1038/299802a0.
2. Holevo AS. Bounds for the quantity of information transmitted by a quantum communication channel. Probl Peredachi Inf. 1973;9(3):3-11.
3. Landauer R. Irreversibility and heat generation in the computing process. IBM J Res Dev. 1961;5(3):183-191. doi:10.1147/rd.53.0183.
4. Stoica OC. The clock ambiguity problem: extended or extinguished? arXiv:2604.21805. 2026.

**END**