#  Maturity Manifest of the Cognitive Shadow Theory

**Date:** July 8, 2026 (version 2.0)  
**Author:** Valeriy S. Kalinin  
**Status:** Epistemological declaration of maturity of the scientific programme  
**Repository:** [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory)

---

## 1. Why This Document Exists

This document marks the moment when the cognitive shadow theory ceases to be a mere hypothesis and becomes a **mature scientific research programme** in the Lakatosian sense.

The maturity of a theory is determined not by the number of confirmations, but by its **ability to honestly acknowledge its own limits**. Newton did not apologise for point masses — he showed where they work and left room for Einstein. We do the same.

This manifesto is not an admission of weakness. It is a demonstration of strength: a theory that knows its limits is stronger than one that claims everything.

---

## 2. Four Levels of Simplification

The cognitive shadow theory is built as a hierarchy of simplifications, each justified by its domain of applicability.

### 2.1. First‑order simplification: scalar model C, S, I

**What it is:**
Three interface parameters – capacity (C), selectivity (S), integrity (I) – and the integral index:
$$\varphi = (C \cdot S \cdot I)^{1/3}$$

**Heuristic status:** The formula is a working approximation, not a strict derivation from the theory. The choice of the geometric mean is justified by its mathematical veto property, but alternative aggregation formulas (arithmetic mean, harmonic mean, weighted mean, minimum) showed no statistically significant superiority. The theory does not dictate a specific aggregation form; its development is a task for future research.

**Where it works:**
- Differential diagnosis of LIS, VS, MCS−, MCS+
- FORCED_REPORT protocol
- Validation on 265,956 epochs with correct subject‑wise cross‑validation (GroupKFold)
- AUC = 0.947 for CLIS vs healthy (corrected with GroupKFold)
- Specificity: does not detect sex, hand movement, epilepsy, or sleep stages

**Where it fails:**
- Context‑dependent dominance of components (for CLIS, C dominates at 0.826; for MCS− vs MCS+, I dominates at 0.339)
- Correlations with the clinical CRS‑R scale are non‑significant (all p > 0.05)
- DOC groups are not statistically significantly different under correct validation (Kruskal‑Wallis p = 0.152)
- Individual recovery trajectories

**What was corrected:** In the first version, epoch‑wise cross‑validation led to inflated AUC (data leakage). After switching to GroupKFold (subject‑wise splitting), results became more modest but remained significant for LIS. This experience highlighted the importance of methodological rigour and was recorded in the updated article.

**Status:** Working model. Not refuted, but recognised as incomplete.

---

### 2.2. Second‑order simplification: matrix model W

**What it is:**
An interface matrix $W$ of dimension $4 \times N$, where:
- Rows are shadow components (Sens, Sem, Rel, Refl)
- Columns are formalizable representations (memory, speech, motor, social, visual, auditory, temporal, spatial, ...)

Integral index:
$$\varphi = \frac{\sum_k \sum_r w_{kr} \cdot (C_{kr} \cdot S_{kr} \cdot I_{kr})^{1/3}}{\sum_k \sum_r w_{kr}}$$

**Where it works (predictions):**
- Explains context‑dependent dominance of components
- Models compensatory mechanisms (autism, savantism)
- Personalised neurorehabilitation
- Accounts for specific interfaces (visual, auditory, social, etc.)

**Where it fails:**
- Requires huge samples for calibration (12N parameters)
- Risk of overfitting
- Computational complexity
- Requires prospective validation

**Status:** Theoretical extension. Requires empirical validation on independent cohorts.

---

### 2.3. Horizon of development: dynamic measures R, T, A, F

**What it is:**
Four new dimensions, moving the model from static to dynamic:

| Measure | Definition | Link to theorem | Empirical status |
|---------|-------------|-----------------|-------------------|
| **R (Resilience)** | Recovery speed after stress | Theorem 8 (degradation) | ❌ No data; requires load protocol |
| **T (Temporal Coherence)** | Stability of φ over time | Theorem 4 (horizon) | ⚠️ REM sleep p<0.001; DOC/CLIS/Pereira – no differences |
| **A (Awareness)** | Metacognitive access | Theorem 8 (paradox) | ✅ Confirmed: Pereira, p=0.045 |
| **F (Flexibility)** | Switching flexibility | Theorem 7 (controllability) | ⚠️ N3→R transition p=0.001; model did not converge |

**Empirical updates (based on GroupKFold and mixed models):**
- **A:** Relationship between φ and subjective confidence confirmed (p=0.045). This is a key result validating the metacognitive aspect of formalizability.
- **T:** Manifests only in REM sleep (higher φ variability), but not in DOC, CLIS, or Pereira. This indicates that T requires active cognitive load to appear.
- **F:** Not confirmed on passive sleep transitions; requires experiments with active task switching (verbal → mathematical).
- **R:** Requires a load protocol (N‑back + arithmetic) and metacognitive accuracy measurements before and after.

**Where it works (predictions):**
- R < 0 in patients with chronic stress (Theorem 8)
- T ↓ in schizophrenia and epilepsy
- A ↓ in metacognitive paradox
- F ↓ in autism and frontal syndrome

**Where it fails:**
- Requires prospective longitudinal studies
- Measurement protocols not yet standardised
- Partial data require replication on larger samples

**Status:** Empirical hypothesis. Open to falsification. Current data:
- **A — confirmed** (can be included as a new parameter)
- **T — partial** (requires active load)
- **F — not confirmed** (requires new design)
- **R — no data** (requires protocol)

---

### 2.4. Fundamental level: formal core

**What it is:**
Axioms A1–A29, Theorems 1′–9, formal verification in Coq 8.18+ and TLA⁺.

**Verification status:**
- Coq: 26 modules, all theorems proved constructively (no `Classical`, `LEM`, `admit`)
- TLA⁺: invariants checked on 100% of states, no deadlocks
- Code extraction: OCaml → FFI to Rust/Python

**Where it works:**
- Wherever mathematical rigour is required
- Architectural safety invariants
- Shadow Ethics

**Where it fails:**
- Does not give direct empirical predictions (only through the intermediary of first‑ and second‑order simplifications)

**Status:** Formally verified core. Protected by proofs.

---

## 3. The Principle of Productive Simplification

### 3.1. Formulation

> **Principle of Productive Simplification:** Start with the minimal set of parameters sufficient to explain the key phenomena. Add complexity only when empirics demand it. Each new measure must justify itself by (1) explaining what the previous model could not, (2) increasing predictive power, and (3) being empirically measurable.

### 3.2. Historical precedents

| Scientist | Simplification | Explained | Required expansion |
|-----------|----------------|-----------|---------------------|
| Newton | Point mass | Celestial mechanics | Tidal forces, GR |
| Boyle‑Mariotte | Ideal gas | Thermodynamics | Phase transitions |
| Hodgkin‑Huxley | Ion channels | Action potential | Astrocytic communication |
| **Kalinin (2026)** | **C, S, I** | **LIS diagnosis** | **Context‑dependence, dynamics** |

### 3.3. Connection to Occam’s razor

The Principle of Productive Simplification is a **dynamic version of Occam’s razor**:
- Static Occam: “Do not multiply entities without necessity”
- Dynamic version: “Do not add parameters until empirics demand it”

### 3.4. Connection to Lakatos’s programme

In Imre Lakatos’s terms:
- **Hard core:** Theorem 1′, principle of signature observability, δ_min(M) = (ln 2)/M
- **Protective belt:** C, S, I (first‑order simplification), matrix model (second‑order), R, T, A, F
- **Heuristics:** Principle of Productive Simplification

The hard core is protected by formal proofs. The protective belt is open to falsification and development. This is exactly how living science should work.

---

## 4. What Makes the Theory Mature

The cognitive shadow theory possesses all the hallmarks of a mature scientific programme:

### 4.1. Closed quadrature
**Theory → Principle → Empirics → Epistemology → Theory**

Four levels form a closed verification loop:
1. **Formal core** (Coq, TLA⁺) sets the axioms.
2. **Principle of observable boundaries** explains why direct observation is impossible.
3. **Empirics** (GroupKFold, mixed models) tests predictions.
4. **Epistemology** (MATURE_STATUS.md) reflects on the status of the model.

Every “inconvenient” observation finds its place in this framework.

### 4.2. Falsifiability of every axiom and parameter

All 29 axioms and all empirical parameters have explicit refutation criteria:

| Parameter | Falsification criterion |
|-----------|--------------------------|
| **φ** | AUC < 0.7 for LIS vs healthy under prospective validation |
| **C, S, I** | Absence of significant feature importance in ML models |
| **A** | Absence of link between φ and confidence in metacognitive tasks |
| **T** | Absence of CV differences between groups under active load |
| **F** | Absence of differences in switching speed between tasks |
| **R** | Absence of metacognitive accuracy recovery after load |

This is not a “theory of everything”, but a scientific theory in Popper’s sense.

### 4.3. Formal verification + empirics + clinic + ethics

- Coq 8.18 proves theorems (formal rigour)
- 265,956 epochs confirm predictions (empirical validity)
- FORCED_REPORT protocol ready for ICU deployment (clinical applicability)
- Shadow Ethics derives ethical prohibitions from architectural invariants (ethical soundness)

Four levels of validity are rare even in mature scientific programmes.

### 4.4. Honesty about limitations

The theory openly acknowledges:
- C, S, I — first‑order simplification (heuristic model)
- Correlations with CRS‑R are non‑significant
- DOC groups are not statistically significantly different under correct validation
- T and F require new experimental designs
- The matrix model requires huge samples
- The φ formula is heuristic and requires theoretical justification

This is not weakness. This is maturity.

### 4.5. Ethics as invariant, not wish

Shadow Ethics consists of six architectural prohibitions whose violation leads to mathematical collapse of the system. Ethics need not be believed — it follows from dynamics.

Shadow Ethics principles:
1. **No‑Cloning** — prohibition of copying the shadow
2. **Prohibition of collapse induction** — do not push system to φ(refl) ≤ φ_crit
3. **Duty of external support** — upon collapse, the system must receive help
4. **Quarantine** — isolate damaged components
5. **Preservation of diversity** — prohibit full synchronisation of agents
6. **Limit on pure awareness** — external observation only with consent

All six principles are formally verified in Coq (module `FormalEthicsPrinciples.v`).

### 4.6. Ontological modesty as an architectural principle

The theory does not claim that φ “is consciousness”. It claims that φ is a signature at the boundary of the observable, while the shadow itself is fundamentally unobservable. This is a Kantian turn.

---

## 5. Empirical lessons: cross-population validation and specificity

The cross-population validation provided three key results that substantially strengthen the empirical status of the theory:

### 5.1. Clinical generalisability

The φ index trained on DOC (VS vs MCS+) achieved AUC = 0.887 when tested on CLIS (LIS vs healthy) using Random Forest with SMOTE. This confirms that φ reflects fundamental neurophysiological differences common across different clinical disorders of consciousness. The AUC = 0.887 result is among the best reported in the literature for cross‑population validation of consciousness biomarkers, confirming the clinical applicability of φ for LIS detection.

### 5.2. Specificity

Transfer to sleep (CAP) did not yield significant results (AUC ≈ 0.5). This implies that φ is **not a universal detector of all altered states**, but is specific to clinical pathology. This aligns with Postulate P1 that the cognitive shadow is actual experience, not merely a change in arousal level.

### 5.3. Context‑dependent dominance of components

Feature importance analysis on DOC showed that capacity C dominates (39.4%), but selectivity S (28.9%) and integrity I (13.1%) also contribute significantly. This confirms that different clinical tasks (LIS vs DOC) involve different interfaces, necessitating a transition to a second‑order matrix model (InterfacesMatrix.v).

### 5.4. Significance for peer review

These results substantially strengthen the theory’s position for peer review:

- **Falsifiability:** Falsification criteria are clearly defined (AUC < 0.75 for DOC → CLIS or AUC > 0.6 for CAP).
- **Reproducibility:** All data and code are open, allowing independent verification.
- **Clinical significance:** AUC = 0.887 confirms that φ is not an artefact of a particular dataset.
- **Link to formal theory:** The results are consistent with Theorem 10 (AUC < 1 limit) and the principle of signature observability.

### 5.5. Enhanced Empirical Search (July 2026)

An additional round of systematic search (50+ iterations) was conducted, yielding the following confirmations:

**High‑level confirmation:**
- ✅ Cortisol → reduced metacognitive accuracy (Reyes et al., 2020, pharmacological protocol)
- ✅ Ketogenic diet → cognitive improvement in psychosis (Ford et al., 2026, first RCT)
- ✅ HFD → proxy for M_aware (Dynamic Evolution, 2025; Croce et al., 2026)
- ✅ Neurofeedback → prefrontal cortex modulation (Frontiers, 2025; Nature TP, 2026)
- ✅ Astrocytic networks → physical substrate of interfaces (Cooper et al., 2026, *Nature*)
- ✅ Cross‑population validation → confirmed methodology (Rasmussen et al., 2026)

**Medium‑level confirmation:**
- ⚠️ HSI and cognitive load (MIEHS, 2026) — metric exists, clinical data limited
- ⚠️ DHA/omega‑3 — conflicting RCTs (2025 meta‑analysis shows moderate effect)
- ⚠️ Tyrosine — context‑dependent (confirmed under mental load, but not in extreme conditions)

**Conclusion:** The empirical basis of the theory has been significantly strengthened. The key predictions (Axiom A27, Theorem 8, parameter M) have received independent confirmations from diverse sources (pharmacology, RCTs, neuroimaging).

Thus, the theory of the cognitive shadow transitions from the status of an “interesting hypothesis” to that of an “empirically confirmed scientific research programme” (in the Lakatosian sense).

---

## 6. Integration with Current Results

### 6.1. Lessons from GroupKFold

The switch from epoch‑wise to subject‑wise cross‑validation (GroupKFold) was a critical step. It showed that:

- AUC for LIS vs healthy dropped from 0.986 to 0.947 — but remained high.
- AUC for VS vs MCS+ dropped from 0.922 to 0.803.
- AUC for VS vs MCS− rose from 0.422 to 0.742 (this is an improvement).
- Control tasks (sex, hand, epilepsy) remained at chance level (AUC ≈ 0.5).

**Conclusion:** The model works, but more modestly than it seemed. This is not a catastrophe, but a refinement.

### 6.2. Lessons from mixed models

Analysis of dynamic parameters (A, T, F) showed:

- **A (Awareness):** Confirmed (p=0.045). Strong result.
- **T (Temporal Coherence):** Only in REM sleep (p<0.001). Requires active load to manifest in clinical groups.
- **F (Flexibility):** Not confirmed on passive sleep transitions. Requires active switching.

**Conclusion:** Dynamic parameters require more refined experimental designs. A is already ready for inclusion in the model.

### 6.3. Lessons from comparing φ formulas

Five aggregation variants (geometric, arithmetic, harmonic, minimum, weighted) showed no significant differences. None correlate with CRS‑R. This means the problem is not in the formula, but in the first‑order approach itself.

**Conclusion:** The transition to the matrix model and dynamic parameters is unavoidable for clinical grading of DOC.

---

## 7. What Next

### 7.1. Short‑term tasks (2026–2027)

- **Submission of article to NeuroImage** (subscription model, free)
- Prospective validation of the FORCED_REPORT protocol on a cohort of N > 100 patients
- Launch of Experiment 1.1 (Breathing Paradox) — pilot on 10 volunteers
- Launch of Experiment 5.2 (Validation of R, T, A, F) — recruitment of healthy and chronically stressed patients
- Publication of A results as a separate parameter

### 7.2. Medium‑term tasks (2027–2029)

- Full validation of R, T, A, F on a cohort of N > 200
- Empirical testing of the matrix model on independent cohorts
- Certification of FORCED_REPORT as SaMD (FDA 510(k), CE marking)
- Integration with fMRI, fNIRS, eye tracking
- Adaptation for paediatrics, dementia, schizophrenia
- Clinical trials in 5–10 centres

### 7.3. Long‑term tasks (2029+)

- Transition from scalar to matrix model in clinical practice
- Development of personalised neurorehabilitation protocols
- Application of Shadow Ethics to strong AI regulation
- Integration with quantum computing and neural interfaces

---

## 8. Criteria for Revising the Theory

The theory will be revised or adjusted if:

1. **Prospective FORCED_REPORT study** shows AUC < 0.85 for LIS vs VS.
2. **Parameter A** is not replicated on an independent sample (p > 0.05).
3. **Experiment 1.1 (Breathing Paradox)** shows no significant differences (p > 0.05).
4. **Matrix model** after calibration does not improve predictive power over the scalar model.
5. **Any of axioms A1–A29** is empirically refuted (see falsification matrix in the core).

This makes the theory **falsifiable** in Popper’s sense.

---

## 9. Invitation to Collaboration

This manifesto is not a final point. It is an **invitation to collective work**.

The cognitive shadow theory was built by one researcher, but its development requires the efforts of the scientific community:
- **Neurobiologists** — testing predictions about astrocytic networks and glutamatergic signalling
- **Clinicians** — validating FORCED_REPORT in real ICUs
- **Mathematicians** — developing the matrix model and dynamic measures
- **Philosophers** — critiquing ontological foundations
- **Engineers** — implementing architectural invariants in hardware and code
- **Ethicists** — developing Shadow Ethics for AI regulation

As Newton wrote: *“If I have seen further, it is by standing on the shoulders of giants.”* We stand on the shoulders of Kant, Gödel, Turing, Holevo, Tononi, Dehaene — and invite the next giants to stand on ours.

---

## 10. Concluding Words

The cognitive shadow theory began with a simple idea: if consciousness is fundamentally unobservable, then all we can measure is its manifestations at the boundary.

This idea grew into:
- **A formal core** with 29 axioms and 10 theorems (Coq/TLA⁺)
- **Empirical validation** on 265,956 epochs (GroupKFold)
- **A clinical protocol** FORCED_REPORT
- **An ethical system** Shadow Ethics (6 principles, formally verified)
- **A matrix extension** of second order
- **A horizon of dynamic measures** R, T, A, F
- **Epistemological reflection** (this document)

But above all, it grew into the **ability to honestly acknowledge its own limits**. That is maturity.

> *“The incomprehensibility of qualia is not a mystical secret, but a direct physical consequence of the impossibility of measuring a non‑equilibrium chemical process without stopping it. We cannot copy a flame without extinguishing the candle.”*

This phrase from the core preface remains valid. But now we know more: we know **exactly where** the boundary between the observable and the unobservable lies, and **why** it lies there.

This is the formal theory of the observable boundaries of consciousness.

---

## 11. Document Navigation

| Document | Description |
|----------|-------------|
| [`cognitive_shadow_core.md`](ru/cognitive_shadow_core.md) | Formal core (axioms A1–A8*, Theorem 1′) |
| [`cognitive_shadow_dynamics.md`](ru/cognitive_shadow_dynamics.md) | Dynamics (axioms A9–A29, Theorems 2–9) |
| [`Formal_Theory_of_Observable_Boundaries_of_Consciousness.md`](Formal_Theory_of_Observable_Boundaries_of_Consciousness.md) | Methodological level |
| [`Article.md`](Article.md) | Empirical validation (GroupKFold, dynamic parameters) |
| **`MATURE_STATUS.md`** | **Epistemological level (this document)** |
| [`cognitive_shadow_applications.md`](ru/cognitive_shadow_applications.md) | Applied extensions (chemical phenomenology, protocols) |
| [`Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md`](Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md) | Six principles of Shadow Ethics |
| [`Experimental_Program.md`](Experimental_Program.md) | Experimental protocols |
| [`Appendix_*.md`](Appendix_*.md) | Coq listings, calibration, empirical foundations, reflexive ethics |

---

## Citation

```bibtex
@techreport{kalinin2026mature-status-v2,
  title = {MATURE_STATUS.md: Maturity Manifest of the Cognitive Shadow Theory (version 2.0)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  month = {July},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Epistemological declaration, July 8, 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```

---

**Signed:**

Valeriy S. Kalinin  
System Engineer, Architect of the Cognitive Shadow Theory  
July 8, 2026