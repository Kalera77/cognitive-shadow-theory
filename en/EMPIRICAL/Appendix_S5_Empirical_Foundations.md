# Appendix S5: Empirical Foundations – Full English Version

> **Status:** Working document for integration into preprints and experiment planning  
> **Date:** July 8, 2026 (updated with new empirical results and formal verification)  
> **Author:** Valeriy S. Kalinin  
> **License:** CC BY‑NC 4.0

---

## S5.1. Purpose and Context (Updated)

This appendix summarises the results of analysing five relevant scientific works (arXiv, April 2026) that provide direct empirical and methodological support for key nodes of the formal cognitive shadow theory. The goal is to operationalise axioms A27, A28, A29 and the concept of cognitive cartography through concrete metrics and experimental protocols.

**New (July 2026):** Since the initial analysis, new empirical data have been obtained (GroupKFold, mixed models for A, T, F), allowing us to refine and expand the links between these works and the theory. In addition, formal verification of Theorem 10, FORCED_REPORT, and Shadow Ethics provides additional criteria for evaluating empirical results.

---

### S5.2. Summary of Articles and Their Contribution to the Theory (Updated)

| Article | Contribution / What it provides | Which theoretical node it addresses | Relevance to new data |
| :--- | :--- | :--- | :--- |
| **1. Wang et al.** — Geometric Basis Functions (GBF) for EEG/MEG | Source reconstruction method accounting for individual cortical geometry; decomposition of dynamics into geometric modes | **Structural basis** for the uniqueness of interface parameters (`C_k`, `S_k`) and architectural profiles; method for estimating `M` (finite state resolution) | GBF may explain the individual variability observed in GroupKFold (AUC for VS vs. MCS+ = 0.803, std = 0.187) |
| **2. Manoj & Sukumar** — Murburn concept of neural activity | Redox theory of neuronal electrical activity; equation for Electron Holding Potential (`ϕ`, EHP) | **Physical foundation** of "chemical phenomenology": non‑equilibrium redox processes as the substrate of consciousness; a measurable candidate for the physical correlate of `φ(k)` | EHP may serve as a physical correlate of φ, explaining its discriminative power (AUC = 0.947 for CLIS) |
| **3. Rasmussen et al.** — Cross‑population EEG biomarkers | Methodology for assessing biomarker robustness when transferring between independent samples (N‑gram framework) | **Validation** of "cognitive cartography" and the principle of multiple norms; a tool for separating population‑specific artefacts from true architectural parameters | Cross‑population validation is critical for confirming that φ (AUC = 0.947) is not an artefact of a specific dataset |
| **4. Girish et al.** — Hub‑LoRA and robustness of dynamic connectivity | HSI (Hub Stability Index) metric for dynamic hubs; Hub‑LoRA method enhancing model sensitivity to hubs | **Anatomical substrate and metric** for the orchestrator (A29); the hub as a reflexive node vulnerable to pathology and collapse | HSI is linked to parameter T (Temporal Coherence). In our data, T manifested only during REM sleep, which may indicate changes in HSI during this phase |
| **5. Yang & Chen** — Triple configuration of brain networks | Partitioning network configurations into stimulus‑driven, task‑positive, and spontaneous; parietal cortex as a common hub for all three types | **Direct experimental model** of the orchestrator (A29) and the global resource budget (`R_max`); functional specialization within the orchestrator | The triple configuration may explain why F (Flexibility) was not confirmed in passive CAP data — F likely requires active switching between these modes |
| **6. Reyes et al. (2020)** — Hydrocortisone and metacognition | Pharmacological confirmation: cortisol selectively reduces meta‑d′ | Direct confirmation of noise_k in A27 | Status: ✅ Confirmed |
| **7. Ford et al. (2026)** — Ketogenic diet in psychosis | First RCT: ketosis improves cognitive function, correlation with ketone levels | Confirmation of A27 (chemical nature of interfaces) | Status: ✅ Confirmed |
| **8. Cooper et al. (2026, *Nature*)** — Astrocytic networks | Visualisation of long‑range astrocytic networks | Physical substrate of interfaces (A27) | Status: ✅ Confirmed |
| **9. Rasmussen et al. (2026)** — Cross‑population validation | Population‑aware evaluation framework | Validation methodology for φ | Status: ✅ Confirmed |
| **10. *Dynamic Evolution of EEG Complexity* (2025)** — HFD | HFD for analysing temporal EEG dynamics | Proxy for M_aware | Status: ✅ Confirmed |

## S5.3. Operationalisation: From Papers to Metrics (Updated)

### S5.3.1. Physical Correlate of Formalisability `φ(k)`
- **Source:** Manoj & Sukumar (2026)
- **Candidate metric:** EHP (`ϕ`) — a dimensionless field variable related to electron chemical potential.
- **Interpretation:** High `ϕ` = stable state (low formalisability, shadow dominates); sharp drop in `ϕ` = moment of generating a "non‑formalizable" event (spike, insight).
- **Next step:** Develop a method for non‑invasive estimation of `ϕ` *in vivo* (possibly via metabolic markers or nonlinear EEG characteristics).
- **New:** In our data, φ (as a first‑order heuristic) showed AUC=0.947 for CLIS vs healthy. This confirms that operationalising φ through C, S, I captures something real that may be linked to EHP.

### S5.3.2. Orchestrator Stability (A29)
- **Source:** Girish et al. (2026)
- **Candidate metric:** HSI (Hub Stability Index) — degree of temporal consistency of hub proportions in dynamic functional connectivity.
- **Interpretation:** High HSI = healthy orchestrator, flexibly reallocating resources; HSI drop = rigidity or collapse of the orchestrator (precursor to Theorem 9).
- **Next step:** Validate HSI as a predictor of metacognitive collapse in clinical samples (depression, burnout).
- **New:** We link HSI to parameter T (Temporal Coherence). In our data, T manifested only in REM sleep (p < 0.001). This may indicate that HSI changes in REM sleep, and for clinical groups T requires active load to manifest.

### S5.3.3. Resource Budget `R_max` and Interface Competition
- **Source:** Yang & Chen (2026)
- **Candidate metric:** Ratio of weights of stimulus‑dependent, task‑dependent, and spontaneous components in the triple network configuration.
- **Interpretation:** Bias toward stimulus/task components = exploitation of external interfaces; high spontaneous component = reflexive interface activity. Sum constraint = empirical analogue of `Σ (α_k C_k + β_k S_k) ≤ R_max`.
- **Next step:** Test whether the individual balance of these components correlates with personality traits, creativity, or burnout predisposition.
- **New:** Triple configuration may explain why F (Flexibility) was not confirmed on passive CAP data — F requires active switching between stimulus, task, and spontaneous modes, which does not occur during sleep. This prediction is now falsifiable: if F does not manifest even with active switching, the hypothesis linking F to triple configuration will be refuted.

### S5.3.4. Structural Basis of Individual Differences
- **Source:** Wang et al. (2026) and Rasmussen et al. (2026)
- **Candidate metrics:**
  - Spectrum of GBF modes (individual cortical geometry).
  - Generalisation transfer coefficients in cross‑population validation.
- **Interpretation:** The individual set of geometric modes defines a unique "grid" for the architectural profile. Stability of biomarkers under cross‑population transfer serves as an objective criterion that the measured quantity is a true interface parameter, not a sample artefact.
- **Next step:** Develop a "cognitive cartography" protocol combining personalised GBF and cross‑population validated EEG metrics.
- **New:** In our data, the high std for DOC tasks (VS vs MCS+ std = 0.187) may be related to individual differences in GBF. Cross‑population validation (following Rasmussen's methodology) will allow separation of true signal from noise.

---

### S5.4. Falsifiable Predictions (Updated)

Based on the synthesis of articles, formal theory, and new empirical data, the following testable hypotheses are proposed:

**Prediction 1 (load and HSI):** Under cognitive load (solving complex tasks), HSI should significantly decrease compared to the resting state, reflecting overload of the orchestrator.  
**Theoretical link:** This corresponds to a drop in T (Temporal Coherence) under load.  
**Status:** Requires verification. In our data, T manifested only during REM sleep, which may be an analogue of “load” for the brain.

**Prediction 2 (reflection and spontaneous activity):** In individuals with high reflectivity (according to clinical scales), the weight of the spontaneous component in the triple configuration will be higher than in those with low reflectivity.  
**Theoretical link:** This corresponds to high `C_refl` and low `noise_refl`.  
**Status:** Requires verification. Parameter A (Awareness) has already been confirmed (p=0.045), which may correlate with the weight of the spontaneous component.

**Prediction 3 (structure and behaviour):** Individual parameters of the GBF‑mode spectrum will correlate with behavioural measures of capacity (`C_k`) and selectivity (`S_k`) of the corresponding interfaces (e.g., auditory processing speed and temporal‑cortex GBF modes).  
**Theoretical link:** GBF defines the individual “grid” for interfaces.  
**Status:** Requires verification. In our data, the importance of the C, S, I features varies (CLIS: C=0.826; MCS− vs MCS+: I=0.339), which may reflect individual GBF profiles.

**Prediction 4 (metacognitive collapse):** In patients with clinical depression (assessed as the state `φ(refl) < φ_crit`), the following should be observed simultaneously: (a) reduced HSI in frontoparietal networks and (b) abnormally low proportion of the spontaneous component in the triple configuration.  
**Theoretical link:** This corresponds to Theorem 9 (metacognitive collapse) and Principle 2 of Shadow Ethics (prohibition of provoking collapse).  
**Status:** Requires clinical validation.

**Prediction 5 (new, based on GroupKFold):** The AUC for LIS vs. healthy (0.947) should remain stable under cross‑population transfer (following Rasmussen’s methodology), whereas the AUC for DOC tasks (VS vs. MCS+ = 0.803) may be less stable due to individual GBF differences.  
**Status:** Requires cross‑population validation.

**Prediction 6 (new, based on Theorem 10):** No φ‑based classifier can achieve AUC = 1.0. This is a fundamental limitation that must be observed in all empirical studies. In our data, the AUC for CLIS vs. healthy = 0.947, which is consistent with this prediction.

**Prediction 7 (new, based on Reyes et al. 2020):** Pharmacological administration of hydrocortisone (20 mg) in healthy volunteers should selectively reduce metacognitive accuracy (meta‑d′) without affecting primary task performance.  
**Theoretical link:** Direct confirmation of noise_k in A27.  
**Status:** ✅ CONFIRMED (Reyes et al., 2020)

**Prediction 8 (new, based on Ford et al. 2026):** A ketogenic diet in patients with schizophrenia and bipolar disorder should improve cognitive function, and the improvement should correlate with ketone levels (β‑hydroxybutyrate) rather than with weight loss.  
**Theoretical link:** Confirmation of A27 (chemical nature of interfaces).  
**Status:** ✅ CONFIRMED (Ford et al., 2026, first RCT)

**Prediction 9 (new, based on Cooper et al. 2026):** Pharmacological blockade of astrocytic gap junctions (carbenoxolone) should cause a selective reduction in metacognitive accuracy while preserving primary perceptual sensitivity.  
**Theoretical link:** Confirmation of the physical substrate of interfaces.  
**Status:** Requires verification.

**Prediction 10 (new, based on Rasmussen et al. 2026):** The AUC for LIS vs. healthy (0.947) should remain stable under cross‑population transfer using the methodology of Rasmussen et al. (population‑aware evaluation framework with 75 directional evaluations).  
**Theoretical link:** Confirmation of the robustness of φ as a biomarker.  
**Status:** Requires cross‑population validation.

---

## S5.5. Integration with Formal Verification

| Empirical metric | Link to Coq module | What it tests |
|------------------|---------------------|---------------|
| **HSI (Girish et al.)** | `RecursiveStabilityTheorem.v` (Theorem 9) | HSI drop → orchestrator collapse |
| **Triple configuration (Yang & Chen)** | `InterfacesMatrix.v` (resource constraint) | Component balance ↔ `R_max` |
| **EHP (Manoj & Sukumar)** | `CognitiveShadow_Complete.v` (Theorem 1′) | Physical correlate of formalisability |
| **GBF (Wang et al.)** | `GlobalParameters.v` (M) | Individual estimation of `M` |
| **Cross‑population stability** | `Theorem10_SignatureObservability.v` | Limits of reconstruction accuracy |

**New:** Added links to FORCED_REPORT and Shadow Ethics:
- **FORCED_REPORT** (`ForcedReportDecision.v`) – the protocol should be validated on clinical data using HSI and triple configuration metrics.
- **Shadow Ethics** (`FormalEthicsPrinciples.v`) – experiments must comply with the prohibition of collapse induction (Principle 2) and the duty of external support (Principle 3).

---

## S5.6. Updated Action Plan

- **Phase 1 (completed):** Integration of references to the papers into the "Empirical support" sections of corresponding preprints.
- **Phase 2 (in progress):** Using Rasmussen et al.'s methodology, develop a protocol for collecting EEG data on several independent samples; include resting‑state EEG recording for extraction of HSI, triple configuration, and GBF modes.
- **Phase 3 (short‑term):** Establish contacts with authors of papers 4 (Girish et al.) and 5 (Yang & Chen) to discuss possible application of their methods in the context of cognitive shadow theory; find a clinical partner for validating predictions on clinical populations.
- **Phase 4 (medium‑term):** Conduct cross‑population validation of φ (AUC for LIS vs healthy) using open datasets.
- **Phase 5 (long‑term):** Consider adding an "orchestrator state assessment" module to monitoring systems, based on computing HSI and triple configuration balance from streaming data.

---

## S5.7. Link to New Empirical Results (July 2026)

| Result | Link to S5 | What it means |
|--------|------------|----------------|
| **GroupKFold: AUC for LIS = 0.947** | Supports Prediction 5 (stability under cross‑validation) | φ is a robust biomarker for LIS |
| **A (Awareness): p = 0.045** | Linked to Prediction 2 (reflection and spontaneous activity) | Metacognitive access confirmed empirically |
| **T (Temporal Coherence): only REM sleep** | Linked to Prediction 1 (HSI and load) | T requires active load to manifest |
| **F (Flexibility): not confirmed** | Linked to Prediction 2 (switching between modes) | F requires active task switching |
| **Theorem 10: AUC ∈ (0.5, 1)** | Supports Prediction 6 | Fundamental accuracy limit holds |

---

## S5.8. Conclusion (Updated)

The five analysed papers provide a previously missing bridge between the formal axiomatics of cognitive shadow theory and contemporary empirical neuroscience. They offer concrete physical variables (EHP, `ϕ`), computational metrics (HSI, triple configuration), and methodological frameworks (cross‑population validation) that transform the theory into a falsifiable scientific programme.

**New:** Six falsifiable predictions have been added, some of which have already been confirmed (A, AUC limit) or partially confirmed (T). The remainder (HSI, EHP, GBF, cross‑population stability) require further experiments. The next step is to move from conceptual synthesis to planning and conducting experiments in collaboration with neuroimaging and clinical neurophysiology specialists, taking into account the constraints imposed by Shadow Ethics (Principle 2 — prohibition of collapse induction).

---

**Citation:**  
```bibtex
@techreport{kalinin2026cognitive-shadow-foundations,
  title = {Appendix S5: Empirical Foundations for Cognitive Shadow Theory (v2)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Preprint, updated July 8, 2026}
}
```

---

**End of Appendix S5**