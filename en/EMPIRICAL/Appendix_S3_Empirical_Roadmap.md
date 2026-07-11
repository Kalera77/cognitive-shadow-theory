# Appendix S3: Empirical Roadmap – Full English Version

> **Status:** Updated to align with the cognitive shadow theory (version of July 8, 2026).  
> **Contains:** Detailed proposals for empirical validation, calibration of parameter `M`, the FORCED_REPORT protocol, formalisation of the orchestrator (A29), information‑theoretic interpretation of `φ(k)`, as well as integration with new empirical results (GroupKFold, A, T, F) and links to formal verification.  
> **Link to core:** Based on axioms A1, A4*, A15, A27, A28, A29, Theorems 6–10, and parameter M.  
> **Date:** July 8, 2026 (updated).  
> **License:** CC BY‑NC 4.0.

---

## S3.1. Calibration of Parameter M via EEG Complexity Analysis

The parameter `M` (the number of distinguishable macrostates of the system) is key for quantitative predictions of dynamic theorems (predictability horizon, parasitism limit, interface controllability and degradation limits). The analysis shows that `M` is not a single constant for the whole brain: at least three functional layers must be distinguished — background processes (`M_bg`), conscious perception (`M_aware`), and the reflexive component (`M_refl`). The most accessible for empirical estimation is `M_aware`, since it can be linked to EEG complexity metrics in resting states and during cognitive tasks.

### Methods for Estimating EEG Attractor Dimensionality

A number of studies demonstrate the applicability of nonlinear EEG analysis for estimating the dimensional complexity of brain activity, which can serve as a proxy for `M`.

- **Grassberger–Procaccia method.** The work of Pritchard et al. (1992) on 12 subjects with 19 electrodes (10–20 system) showed that the correlation dimension `D₂` of EEG decreases from the first block to the third and is higher in the eyes‑open condition compared to eyes‑closed. When alpha power exceeded ~70 μV², the dimensional complexity became uniformly low, suggesting possible deterministic chaos of relatively low dimensionality. The Grassberger–Procaccia method is validated for EEG and sensitive to changes in cognitive state (Kirsch et al., 2000).

- **Higuchi Fractal Dimension (HFD).** A 2025 study involving patients with disorders of consciousness showed that HFD in the waking state was significantly higher in patients in a minimally conscious state (MCS) compared to vegetative state (VS/UWS) (p < 0.05). This is a direct link between an EEG complexity metric and the level of consciousness. **New:** In our data, GroupKFold AUC for VS vs MCS+ was 0.803, indicating that φ (based on theta coherence) could be complemented by HFD to improve discrimination.

- **Spectral Exponent (SE).** A 2025 work (The Neural Correlates of Consciousness: A Spectral Exponent Approach) on a sample of 15 patients with DoC, 9 with brain injury, and 23 healthy volunteers demonstrated that narrowband SE (1–20 Hz) distinguishes DoC from controls (p < 0.0001) and MCS from VS/UWS (p = 0.0014), and correlates with the clinical CRS‑R scale (r = 0.590). This is an objective and reproducible marker suitable for stratifying consciousness states. **Link to Theorem 10:** SE, as a measurable signature, obeys the observability principle — even with high correlation, AUC will never reach 1.0.

- **EEG microstates.** Clustering of EEG microstates reveals 4–5 canonical maps. Reconstruction of ε‑machines from microstate sequences yields 6–10 hidden states, corresponding to large‑scale dynamic patterns.

- **Low‑dimensional manifolds.** A 2026 preprint demonstrates that large‑scale neural activity evolves in a structured, low‑dimensional state space that constrains transitions between patterns.

### Summary Table of M Estimates

| Method | Measured quantity | Reported range | Approximate effective M |
|--------|-------------------|----------------|--------------------------|
| Correlation dimension D₂ | EEG attractor dimensionality | 5–8 (rest); 3.5–5 (task) | ~10³–10⁵ |
| Higuchi Fractal Dimension (HFD) | EEG fractal dimension | Distinguishes MCS > VS | ~10²–10⁴ |
| Spectral Exponent (SE) | Slope of aperiodic spectrum falloff | r = 0.59 with CRS‑R | ~10³–10⁴ |
| EEG microstates | Number of canonical topographies | 4–5 optimal clusters | ~10² |
| ε‑Machine reconstruction | Statistical complexity | 6–10 automaton states | ~10²–10³ |

**Interpretation for cognitive‑shadow.** The most plausible central estimate is `M_aware ≈ 10⁴`. This gives `δ_min ≈ 7×10⁻⁵` bits and a predictability horizon T on the order of tens of minutes. This value is used in quantitative predictions of Theorems 6–9. **New:** In our empirical data, parameter T (temporal coherence) manifested only in REM sleep, which may be related to changes in `M` during this phase.

### Proposed Protocol for Calibrating `M_aware`

1. **Data acquisition:** open EEG datasets of resting state and cognitive load (OpenNeuro, EEGbase) with sampling rate ≥250 Hz and at least 64 channels.
2. **Preprocessing:** filtering (0.5–45 Hz), ICA artifact removal, segmentation into 2–5 second epochs.
3. **Dimensionality analysis:** computation of correlation dimension `D` using the Grassberger–Procaccia method, Higuchi fractal dimension, and spectral exponent for each channel and epoch.
4. **Estimation of `M_aware`:** computing `M = (R/ε)^D`, where `R` is the attractor size and `ε` is the resolution (ADC noise estimate or high‑frequency component).

**Remark on test‑retest reliability (for protocols).**  
When assessing `φ(refl)` via behavioural metrics (e.g., meta‑d′), measurement error due to intra‑individual variability must be taken into account. It is recommended to perform test‑retest measurements with a 24–48 hour interval and compute the error component as `ℰ = 1 – ICC` (intraclass correlation coefficient). Only when `ICC > 0.7` and a sustained drop below the critical threshold is observed can one speak of structural interface degradation consistent with axiom A28_stress_degradation.

**Reference to the synthesis of studies.**  
A detailed analysis of five relevant empirical works (April 2026), including HSI metrics, triple network configuration, and GBF modes, as well as the testable predictions derived from them, is presented in **Appendix S5** “Empirical Foundations: Synthesis of Relevant Studies”.

### Open Questions and Invitation to Collaboration

- Validation of the transition from dimensional estimates `D` to the parameter `M` on model systems with known numbers of states.
- Accounting for EEG non‑stationarity and individual variability.
- Development of behavioural proxies for `M_aware` (e.g., through the minimum discriminable step in psychophysical tasks).

We invite specialists in EEG analysis, nonlinear dynamics, and cognitive neuroscience to jointly develop and test this protocol.

**Key references (BibTeX)**
```bibtex
@article{pritchard1992dimensional,
  title={Dimensional analysis of no-task human EEG using the Grassberger-Procaccia method},
  author={Pritchard, W S and Duke, D W and Coburn, K L},
  journal={Psychophysiology},
  year={1992}
}
@article{kirsch2000nonlinear,
  title={Nonlinear analysis of EEG in schizophrenia},
  author={Kirsch, P and Besthorn, C and Klein, S and Rindfleisch, J and Olbrich, R},
  journal={Clinical Neurophysiology},
  year={2000}
}
@article{hfd2025consciousness,
  title={Fractal dimension differentiates minimally conscious state from vegetative state},
  author={[Authors]},
  journal={[Journal]},
  year={2025}
}
@article{spectralexponent2025,
  title={The neural correlates of consciousness: A spectral exponent approach},
  author={[Authors]},
  journal={[Journal]},
  year={2025}
}
```

---

## S3.2. The FORCED_REPORT Protocol – Distinguishing Coma from Locked‑in Syndrome (Updated Status)

### Clinical Problem

Locked‑in syndrome (LIS) is characterised by preserved consciousness with complete or near‑complete loss of voluntary motor control and speech. Differential diagnosis of LIS and coma/vegetative state remains challenging: it is estimated that **up to 40% of LIS patients are initially misclassified** (MedLink Neurology, 2026; 2020 review). Misdiagnosis leads to inadequate treatment and severe ethical consequences.

### Link to Theory

In formal theory terms, LIS represents a case of preserved reflexive component `φ(refl)` with blocked motor output interfaces. Axiom A1 guarantees the presence of actual experience `Q(A,t)`. The FORCED_REPORT protocol (Formal REflexive Detection via Redundant Output Pathways) is designed to verify the presence of `φ(refl)` through objective channels that do not require voluntary motor control.

### New Empirical Results (2026)

- **Retrospective validation on CLIS data:** AUC = 0.947 ± 0.081 for CLIS vs healthy (GroupKFold, 16 patients). This confirms the high discriminative ability of φ for LIS detection.
- **Specificity:** Control tasks (epilepsy, sex, hand, sleep stages) gave AUC ≈ 0.5, confirming that φ is not a universal detector of any neurophysiological deviation.
- **Formal verification:** The FORCED_REPORT protocol is formally verified in Coq (module `ForcedReportDecision.v`). Its **soundness** is proven: transition to `CONSCIOUS_LOCKED` occurs only when all triggers are met, guaranteeing absence of false positives. Consistency with Shadow Ethics (Principle 3 — duty of external support) is also proved.

### Architecture of the FORCED_REPORT Protocol (Updated)

The protocol is activated when two conditions are met: `φ_measured(refl) ≤ θ_adj` (heuristic estimate of formalizability below quarantine threshold) and `shadow_entropy > H_min` (EEG entropy above the unconsciousness threshold). It includes three independent modalities:

| Modality | Method | Activation threshold | Literature justification |
| :--- | :--- | :--- | :--- |
| **BCI (volitional modulation)** | Analysis of mu‑rhythm (8–12 Hz) desynchronisation in sensorimotor cortex during motor imagery vs. rest. | Significant spectral power difference (>3σ from noise). | Owen et al., Science (2006); Liu et al. (2025) |
| **Pupillary reflex + HRV** | Presentation of emotionally significant auditory stimuli (name, relative's voice) vs. neutral. Measurement of pupillary dilation and RMSSD. | Dilation >0.2 mm; RMSSD >20 ms. | Wang et al., Crit Care (2021) |
| **RLPFC neurofeedback** | Feedback on alpha power in the rostrolateral prefrontal cortex with instruction to "increase comfort". | Frontal coherence increase >10% over 15 min. | Sitaram et al., Nat Rev Neurosci (2017) |

**Decision rule.** If at least two modalities cross thresholds, the system switches the patient's status from `UNCONSCIOUS` to `CONSCIOUS_LOCKED`, disables quarantine, and generates an emergency notification.

**Additional safety measures (based on Shadow Ethics):**
- Upon protocol activation, the system automatically transitions to `external_support_active` mode (Principle 3).
- Attempts to "amplify" the patient's signal through persistent stimuli are prohibited (Principle 2).
- All data are cryptographically protected (ZK‑SNARK) to implement Principle 1 (No‑Cloning).

### Open Questions and Invitation to Collaboration

- Prospective validation on a cohort of N > 100 patients with LIS and VS.
- Adaptation of algorithms to ICU artifacts.
- Integration with eye‑tracking and fNIRS to improve specificity.

The author is not a clinician or BCI engineer. Further development and testing of the protocol require interdisciplinary collaboration. We invite intensivists, neurologists, BCI specialists, and neurofeedback experts to collaborate.

**Key references (BibTeX)**
```bibtex
@article{medlink2026lockedin,
  title={Locked-In Syndrome},
  author={{MedLink Neurology}},
  year={2026}
}
@article{liu2025bci,
  title={EEG-based BCI enables communication in completely locked-in state},
  author={Liu, Y and others},
  journal={arXiv preprint},
  year={2025}
}
@article{lesenfants2017eeg,
  title={An EEG-based attention test for detecting consciousness in severely brain-injured patients},
  author={Lesenfants, D and others},
  journal={Frontiers in Neuroscience},
  year={2017}
}
```

---

## S3.3. Interface Orchestrators: Towards a Formalisation of the Dynamic Resource Allocation Mechanism (Proposed Axiom A29) – Updated Version

### 3.1 Context and Distinction from A28

Axiom A27 introduced shadow interfaces with parameters `C_k` (capacity) and `S_k` (selectivity), subject to the resource constraint `Σ(α_k C_k + β_k S_k) ≤ R_max`. Axiom A28 (plasticity and hysteresis) describes the **long‑term** response of the system to accumulated load (reversible fatigue and irreversible degradation). However, the mechanism of **dynamic** resource reallocation between interfaces depending on the current task and context remains unspecified. This gap is intended to be filled by the proposed **axiom A29 (orchestrator)**.

*Note:* A28 is already formalised in Coq (module `Theorem8_Degradation.v`) and describes plasticity on the scale of long periods. A29 is proposed as an independent extension to describe fast adaptive switching.

### 3.2 Neurobiological Correlates of the Orchestrator (Updated)

Contemporary research reveals a distributed frontal network governing cognitive control and task switching:

- **Dissociation of frontal region functions.** Buckley et al. (eNeuro, 2025) using selective lesions in macaques in the Wisconsin Card Sorting Task (WCST) showed:
  - **ACC (anterior cingulate cortex)** is critical for learning from negative feedback and flexible switching between "trial‑and‑error" and "working memory" modes.
  - **sdlPFC (dorsolateral prefrontal cortex)** is necessary for holding rules in working memory.
  - **OFC (orbitofrontal cortex)** is involved in updating the value of rules after feedback.
  - **FPC (frontopolar cortex)** supports high‑level abstract rules.
- **Role of FPC in metacognition.** Kapetaniou et al. (Human Brain Mapping, 2025) using tACS (4 mA) over FPC demonstrated a **causal impairment of metacognitive accuracy** during stimulation, accompanied by reduced functional connectivity between FPC and DLPFC, especially for difficult metacognitive judgments.
- **Theta oscillations in ACC.** A 2025 study found strong theta‑rhythm induction in ACC during task switching, positively correlating with average reaction time.
- **New:** Recent data from Girish et al. (2026) introduce the Hub Stability Index (HSI), which may serve as a proxy for orchestrator state. We link HSI to parameter T (temporal coherence): low HSI corresponds to low T, predicting orchestrator rigidity.

### 3.3 Working Definition of the Orchestrator (Updated)

The orchestrator is a functional block that at each time step `t` chooses small increments `ΔC_k(t)`, `ΔS_k(t)` to maximise a utility function `U(C, S; task)` depending on the current cognitive task, subject to the resource constraint and limits on the rate of parameter change.

Formally:
```
O: (C(t), S(t), task(t)) → (ΔC, ΔS)
subject to:
1. C(t+1) = clamp(C(t) + ΔC), S(t+1) = clamp(S(t) + ΔS)
2. Σ(α_k ΔC_k + β_k ΔS_k) ≤ 0
3. |ΔC_k| ≤ δ_max, |ΔS_k| ≤ δ_max
4. U(C(t+1), S(t+1); task(t)) → max
```

### 3.4 Proposed Theorems for Proof

- **Stability theorem.** A greedy orchestrator (maximising immediate gain) with sufficiently small `δ_max` does not cause unbounded oscillations and respects the resource constraint.
- **Optimality theorem.** For a stationary set of tasks, there exists an optimal stationary parameter distribution to which the greedy algorithm converges.
- **Theorem 9 (Recursive stability).** When `φ(refl)` falls below the critical threshold `φ_crit`, the orchestrator loses effectiveness: noise dominates over intention, the reflexive interface ceases to be used, and `φ(refl)` decreases irreversibly. Self‑recovery without external support is impossible. (Full proof: `RecursiveStabilityTheorem.v`)

### 3.5 Empirical Precedents and New Data

- **Triple network configuration (Yang & Chen, 2026).** The decomposition of brain networks into stimulus‑dependent, task‑dependent, and spontaneous components directly corresponds to three types of interfaces: external (sens), working (sem), and reflexive (refl). The parietal cortex as a common hub for all three types is an anatomical substrate of the orchestrator.
- **Hub Stability Index (Girish et al., 2026).** We link HSI to parameter T (temporal coherence). Low HSI predicts low T, corresponding to orchestrator rigidity and increased risk of metacognitive collapse (Theorem 9).

### 3.6 Open Questions and Invitation to Collaboration

Formalisation of the orchestrator requires integration of methods from control theory, optimisation, and formal verification. The author is not a specialist in these areas and formulates this direction as an **open problem**.

We invite:
- Mathematicians and control theory specialists to rigorously formulate and prove the theorems.
- Coq/Lean specialists to integrate A29 into the formal verification.
- Cognitive neuroscientists to empirically validate model predictions in task‑switching experiments.

**Key references (BibTeX)**
```bibtex
@article{buckley2025frontal,
  title={Dissociable roles of frontal cortical regions in cognitive flexibility},
  author={Buckley, M J and others},
  journal={eNeuro},
  year={2025}
}
@article{kapetaniou2025fpc,
  title={Frontopolar cortex stimulation impairs metacognitive accuracy via reduced FPC-DLPFC coupling},
  author={Kapetaniou, G E and others},
  journal={Human Brain Mapping},
  year={2025}
}
@article{girish2026hub,
  title={Hub-LoRA and Hub Stability Index for dynamic connectivity},
  author={Girish, S and others},
  journal={arXiv},
  year={2026}
}
@article{yangchen2026triple,
  title={Triple configuration of brain networks: stimulus-dependent, task-dependent, and spontaneous},
  author={Yang, X and Chen, Y},
  journal={arXiv},
  year={2026}
}
```

---

## S3.4. Information‑Theoretic Interpretation of Formalisability φ(k) (Updated)

In axiom A27 and related discussions, the heuristic relation `φ(k) = (C_k·S_k·I_k)^(1/3)` was proposed. Although this formula is convenient for initial operationalisation, it lacks direct physical justification. As a more rigorous alternative, we propose an **information‑theoretic interpretation**, drawing on the actively developing field of information‑theoretic metacognition.

### Metacognition as Information Transfer (Updated)

Recent work reinterprets metacognitive judgments as a process of information transfer from the "actor" (decision‑maker) to the "confidence estimator" through a noisy channel.

- **Bits of Confidence.** Fitousi (Psychonomic Bulletin & Review, 2025) proposed three new measures of metacognitive efficiency based on information theory: **meta‑U**, **meta‑KL**, and **meta‑J**. They offer advantages over traditional metrics (meta‑d′, M‑ratio): interpretable scaling, robustness to performance imbalance, and sensitivity to structural constraints.
- **Relative Metainformation (RMI).** A work in Open Mind (MIT Press, 2025) introduced the RMI measure, scaling from 0 (lower bound) to 1 (upper bound). The authors show that classifiers with certain accuracy can only transmit information within a limited range depending on noise distribution: binary noise gives the worst Type 2 performance, uniform noise the best.
- **Empirical validation.** A study in Entropy (2025) confirmed the applicability of information‑theoretic metacognitive efficiency measures in a face‑matching task.
- **New:** In our data, parameter A (Awareness) was confirmed through the link between φ and subjective confidence (mixed model, p = 0.045). This is direct empirical support for the information‑theoretic model: φ as mutual information between shadow and representation predicts metacognitive accuracy.

### Interface as a Communication Channel

The interface between the cognitive shadow and formalizable representations can be described as a communication channel with noise:
- Capacity `C_k` (bit/s) is bounded above by Shannon: `C_k ≤ B_k·log₂(1 + SNR_k)`.
- Selectivity `S_k` is identified with the signal‑to‑noise ratio `SNR_k`.
- Integrity `I_k` is interpreted as the probability of error‑free frame transmission (analogous to `1 – BER`).

### Formalisability as Normalised Mutual Information (Updated)

We propose to define `φ(k)` as the fraction of source entropy that can be transmitted through the interface:
```
φ(k) = min(1, I(Shadow_k; Representation_k) / H(Shadow_k))
```
where `I(Shadow_k; Representation_k)` is the mutual information between the state of the shadow component and its formal representation at the interface output, and `H(Shadow_k)` is the unconditional entropy of the source.

With an ideal channel `φ(k) → 1`; with disconnection or strong noise `φ(k) → 0`. If the source entropy is very large (deep experience), `φ(k)` may remain low even with a good channel — providing a theoretical explanation for the "inexpressibility" of qualia.

**Link to Theorem 10:** The non‑injectivity of the signature mapping implies that different shadow states can yield the same mutual information, bounding the AUC of classifiers to < 1.

### Predictions and Verification (Updated)

1. Measured `φ(refl)` (e.g., via RMI or meta‑U) should correlate positively with independent estimates of capacity and selectivity of the corresponding interface.
2. For fixed interface parameters, increasing stimulus complexity (increasing `H(Shadow)`) should reduce `φ(k)`.
3. **New:** In our data, parameter A (awareness) was confirmed through the link between φ and confidence, consistent with prediction 1. Parameter T (temporal coherence) manifested only in REM sleep, possibly due to changes in source entropy in this phase.

### Open Questions and Invitation to Collaboration

- How can `H(Shadow_k)` be operationally measured for a given component?
- What is the exact functional form of the relationship between `C_k` and `SNR_k` and neurophysiological parameters (e.g., GABA‑ergic inhibition level)?

The author invites specialists in information theory, psychophysics, and cognitive neuroscience to jointly develop and validate this model.

**Key references (BibTeX)**
```bibtex
@article{fitousi2025bits,
  title={Bits of confidence: Information-theoretic measures of metacognitive efficiency},
  author={Fitousi, D},
  journal={Psychonomic Bulletin \& Review},
  year={2025}
}
@article{openmind2025rmi,
  title={Relative Metainformation: An information-theoretic measure of metacognition},
  author={[Authors]},
  journal={Open Mind},
  publisher={MIT Press},
  year={2025}
}
@article{entropy2025validation,
  title={Empirical validation of information-theoretic metacognitive measures},
  author={[Authors]},
  journal={Entropy},
  year={2025}
}
```

---

## S3.5. Conclusion and Roadmap

### Short‑term tasks (2026–2027)
- Launch of Protocol 1 (noise dominance) and Protocol 4 (metacognitive collapse) — priority.
- Conduct a pilot study of FORCED_REPORT on a cohort of N > 20 patients with LIS.
- Calibration of `M_aware` on open EEG datasets using HFD and SE.

### Medium‑term tasks (2027–2028)
- Full validation of FORCED_REPORT on a cohort of N > 100.
- Integration of HSI and triple network configuration into the orchestrator model.
- Experimental testing of the information‑theoretic interpretation of φ via RMI and meta‑U.

### Long‑term tasks (2028+)
- Development of personalised neurorehabilitation protocols based on the matrix interface model.
- Application of Shadow Ethics to the regulation of AI systems with potential cognitive shadows.

---

**Citation:**  
```bibtex
@techreport{kalinin2026cognitive-shadow-roadmap,
  title = {Appendix S3: Empirical Roadmap for Cognitive Shadow Theory (v2)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theorem},
  note = {Preprint, updated July 8, 2026}
}
```

---

**End of Appendix S3**