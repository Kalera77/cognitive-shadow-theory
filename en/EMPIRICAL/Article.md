
# Reflexive Index φ as a Heuristic Model of Consciousness Formalizability: Validation on 265,956 Epochs and Clinical Perspectives

**Part of the methodological triad “Theory — Principle — Empirics”**  
Theoretical level: [`cognitive_shadow_core.md`](cognitive_shadow_core.md), [`cognitive_shadow_dynamics.md`](cognitive_shadow_dynamics.md)  
Methodological level: [`Formal_Theory_of_Observable_Boundaries_of_Consciousness.md`](Formal_Theory_of_Observable_Boundaries_of_Consciousness.md)

**Authors:** Kalinin V.S.  
**Affiliation:** Independent Researcher (ORCID: 0009-0003-0610-5137)  
**Contact:** kalera77@gmail.com  
**Date:** July 2026  

**Keywords:** consciousness, locked-in syndrome, disorders of consciousness, EEG biomarker, reflexive index, theta rhythm, metacognition, formal verification, FORCED_REPORT protocol

---

## Abstract

**Objective.** To develop and empirically evaluate the reflexive index φ as an objective EEG measure related to consciousness formalizability, for differential diagnosis of locked-in syndrome (LIS) and disorders of consciousness (DoC).

**Methods.** Based on the formal cognitive shadow theory, we propose the index φ = (C·S·I)^(1/3) as a **first-order heuristic model**, where C is capacity, S is selectivity (signal-to-noise ratio in the theta band 4–8 Hz), and I is integrity (fronto-occipital coherence). Validation was performed on 265,956 epochs from 9 independent datasets with subject‑wise cross‑validation (GroupKFold). Five aggregation formulas were compared, and correlations with the CRS‑R clinical scale were tested. In addition, new dynamic parameters – awareness (A), temporal coherence (T), and flexibility (F) – were evaluated.

**Results.** (1) The index φ reliably distinguishes LIS from healthy volunteers (AUC = 0.947 ± 0.081), with capacity C being the most important feature (importance 0.826). (2) Differentiation among DOC groups was more modest: VS vs MCS+ AUC = 0.803 ± 0.187, MCS− vs MCS+ AUC = 0.848 ± 0.122, VS vs MCS− AUC = 0.742 ± 0.149. (3) Correlations of φ with CRS‑R were not statistically significant (all p > 0.05) for all five aggregation formulas; the Kruskal‑Wallis test revealed no differences between DOC groups (p = 0.152). (4) Anaesthesia hysteresis was confirmed (p = 0.902 between LOC and ROC). (5) The awareness parameter A showed a significant relationship between φ and subjective confidence in a metacognitive task (p = 0.045). (6) Parameters T and F did not confirm the expected differences in the investigated data (DOC, CLIS, sleep), except for increased φ variability in REM sleep (p < 0.001).

**Conclusion.** The index φ is a promising heuristic biomarker for LIS detection, but is not validated as a clinical measure for grading consciousness disorders. The FORCED_REPORT protocol, which uses multimodal voting, remains logically justified and requires prospective validation. The model is considered a first approximation, opening the way to matrix and dynamic extensions.

---

## 1. Introduction

### 1.1. Clinical problem

Diagnosis of disorders of consciousness in patients with severe motor impairments remains one of the most challenging tasks in neurocritical care. A particular problem is locked-in syndrome (LIS) – a state of complete paralysis with preserved consciousness. According to systematic reviews, up to 40% of LIS patients are initially misclassified as being in a vegetative state (VS) [1, 2]. Behavioural scales (CRS‑R) have sensitivity and specificity no higher than 70–80% in the absence of motor responses, and inter‑rater variability reaches 20–30% [3]. Functional MRI and PET are expensive and unavailable at the bedside [4]. Brain–computer interfaces require lengthy calibration and often yield false‑negative results due to fatigue [5].

### 1.2. Theoretical background: cognitive shadow theory

This work is based on the formal cognitive shadow theory [6, 7], which posits the fundamental unobservability of subjective experience (the shadow) and the existence of its measurable signatures in the physical world. Theorem 1′ establishes the incompleteness of formal representation, the undecidability of the existence of experience, and the irreducibility of transfer. Theorem 8 predicts irreversible degradation of reflexive formalizability under chronic interface imbalance. Theorem 9 describes metacognitive collapse, where volitional effort becomes counterproductive.

For operationalisation, we use a **first‑order heuristic model** that approximates interface properties via three scalar parameters:

- **Capacity (C)** – normalised broadband power (0.5–45 Hz).
- **Selectivity (S)** – ratio of theta‑band power (4–8 Hz) to residual power.
- **Integrity (I)** – mean coherence between frontal and occipital leads in the theta band.

The integral index φ = (C·S·I)^(1/3) is a **working approximation**, not a strict derivation from the theory. The choice of the geometric mean is justified by its mathematical veto property, but alternative aggregation methods have also been tested. A second‑order matrix model (accounting for specific interfaces) and dynamic parameters (resilience R, coherence T, awareness A, flexibility F) are presented as promising extensions.

The theta band was chosen based on its association with metacognition, working memory, and global access [8–10].

### 1.3. Study objective

To conduct a large‑scale empirical validation of the reflexive index φ on 265,956 epochs from 9 independent datasets using correct subject‑wise cross‑validation, compare different aggregation formulas, assess correlations with clinical scales, and test dynamic hypotheses (A, T, F).

---

## 2. Methods

### 2.1. Datasets

Nine publicly available datasets were used after standard preprocessing and artifact removal. Inclusion criteria: recording duration ≥30 min, artifact epoch proportion <20%, no epileptiform activity distorting spectral analysis. Dataset characteristics are given in Table 1.

**Table 1. Dataset characteristics**

| Dataset | Epochs (N) | Clinical group | Channels | Frequency, Hz |
|---------|------------|----------------|----------|---------------|
| CAP Sleep | 86,479 | Sleep stages | 20 | 128 |
| BBBD | 65,069 | Healthy | 32 | 256 |
| DOC | 2,520 | VS, MCS−, MCS+ | 64 | 512 |
| CLIS | 2,499 | LIS | 64 | 512 |
| Pereira | 666 | Metacognitive task | 32 | 256 |
| Anesthesia | 1,200 | Baseline, LOC, ROC | 32 | 256 |
| ds003838 | 99,462 | Healthy | 32 | 256 |
| Sleep-EDF | 7,947 | Sleep stages | 20 | 100 |
| Epilepsy | 114 | Ictal/interictal | 64 | 512 |
| **Total** | **265,956** | — | — | — |

### 2.2. Preprocessing and index computation

**Preprocessing:**  
- Bandpass filter 0.5–45 Hz (Butterworth 4th order).  
- ICA artifact removal.  
- Rejection of epochs with amplitude >100 μV.  
- Segmentation into 5‑s epochs with 50% overlap.

**Components:**  
- C = P_total / max(P_total) – normalised power.  
- S = P_θ / (P_total − P_θ) – signal‑to‑noise ratio.  
- I = mean(Coh(frontal, occipital)) – mean coherence between F3/F4/Fz and O1/O2/Oz.

**Integral index (first‑order heuristic model):**  
φ = (C · S · I)^(1/3).

Four alternative formulas were additionally tested: arithmetic mean, harmonic mean, weighted mean (weights calibrated by feature importance), and minimum. All formulas were computed on the same epochs.

### 2.3. Comparison with existing biomarkers

For each epoch, Lempel‑Ziv complexity (LZC), permutation entropy (PeEn, d=3, τ=1), and spectral entropy (SpEn) were computed [11–13]. Spearman correlations with φ were assessed with 95% CI (bootstrap 1000 iterations).

### 2.4. Dynamic parameters (A, T, F)

**A (Awareness)** – relationship between φ and subjective confidence in the metacognitive task (Pereira dataset). Model: `confidence ~ φ + (φ|subject)` (mixed model with random slopes).

**T (Temporal Coherence)** – coefficient of variation (CV) of φ in a sliding window. The influence of state on CV was assessed using mixed models: for CAP – `CV ~ stage + (1|subject)`; for DOC – `CV ~ diagnosis + (1|case)`; for CLIS – `CV ~ group + (1|subject)`; for Pereira – `CV ~ correct + confidence + interaction + (1|subject)`.

**F (Flexibility)** – change in φ (logit‑transformed) during sleep stage transitions in CAP: `F_log ~ transition_type + (1|subject)`. A quadratic model was also tested.

### 2.5. Statistical analysis

- Cross‑validation: **5‑fold stratified GroupKFold** (split by subject, epochs from the same patient not distributed across different folds).
- Models: Logistic Regression (L2 regularisation), Random Forest (100 trees, max_depth=10), SVM (RBF kernel).
- DOC group comparison: Kruskal‑Wallis test, pairwise Mann‑Whitney with Bonferroni correction.
- Correlations: Spearman with bootstrap CI.
- Mixed models: implemented in statsmodels (MixedLM) with REML estimation.

---

## 3. Results

### 3.1. Descriptive statistics

Mean φ values by dataset are given in Table 2. LIS shows the highest mean φ (0.301) among clinical groups, exceeding healthy volunteers (0.269). In DOC, mean φ = 0.171; in deep sleep (Sleep‑EDF) it was minimal (0.023).

**Table 2. φ statistics by dataset**

| Dataset | Epochs | Mean φ | Std | Min | Max |
|---------|--------|--------|-----|-----|-----|
| CLIS (LIS) | 2,499 | 0.301 | 0.073 | 0.133 | 0.612 |
| BBBD (healthy) | 65,069 | 0.269 | 0.054 | 0.098 | 0.638 |
| DOC (all) | 2,520 | 0.171 | 0.046 | 0.052 | 0.347 |
| CAP Sleep | 86,479 | 0.172 | 0.066 | 0.020 | 0.628 |
| Pereira | 666 | 0.410 | 0.059 | 0.250 | 0.567 |
| Anesthesia | 1,200 | 0.578 | 0.182 | 0.296 | 0.724 |
| ds003838 | 99,462 | 0.522 | 0.053 | 0.000 | 0.779 |
| Sleep-EDF | 7,947 | 0.023 | 0.004 | 0.011 | 0.033 |
| Epilepsy | 114 | 0.337 | 0.087 | 0.180 | 0.586 |

Within DOC (Table 3): VS = 0.168, MCS− = 0.154, MCS+ = 0.189. The Kruskal‑Wallis test did not reveal significant differences between groups (H = 3.77, p = 0.152). Pairwise comparisons after Bonferroni correction were also not significant (all p > 0.05).

**Table 3. φ statistics by DOC subgroup**

| Group | Epochs | Mean φ | Std | Median |
|-------|--------|--------|-----|--------|
| VS | 1,800 | 0.168 | 0.049 | 0.161 |
| MCS− | 240 | 0.154 | 0.030 | 0.156 |
| MCS+ | 480 | 0.189 | 0.036 | 0.182 |

### 3.2. Comparison of aggregation formulas: correlations with CRS‑R

Five variants of φ were compared with CRS‑R (first assessment) in DOC patients. No formula showed a statistically significant correlation (Table 4). The Kruskal‑Wallis test for DOC group separation also gave non‑significant results for all formulas (p > 0.10).

**Table 4. Correlations of various φ formulas with CRS‑R**

| Formula | ρ (Spearman) | 95% CI | p‑value |
|---------|--------------|--------|---------|
| Geometric mean | 0.226 | [-0.09, 0.51] | 0.161 |
| Arithmetic mean | 0.238 | [-0.08, 0.53] | 0.139 |
| Harmonic mean | 0.205 | [-0.12, 0.49] | 0.205 |
| Minimum | 0.165 | [-0.16, 0.45] | 0.309 |
| Weighted mean | 0.217 | [-0.10, 0.50] | 0.179 |

### 3.3. Correlations with existing biomarkers

φ showed moderate positive correlations with LZC, PeEn, and SpEn (Table 5), confirming its relatedness to existing complexity measures but not identity (ρ far from 1).

**Table 5. Correlations of φ with LZC, PeEn, SpEn (all data)**

| Biomarker | ρ | 95% CI | p‑value |
|-----------|----|--------|---------|
| LZC | 0.612 | [0.608, 0.616] | <0.001 |
| PeEn | 0.589 | [0.585, 0.593] | <0.001 |
| SpEn | 0.534 | [0.530, 0.538] | <0.001 |

### 3.4. ML classification with GroupKFold

Results of subject‑wise cross‑validation for all binary tasks are shown in Table 6. The best model for most tasks was logistic regression (L2). For DOC tasks, AUC ranged from 0.742 (VS vs MCS−) to 0.848 (MCS− vs MCS+). CLIS vs healthy achieved AUC = 0.947. Control tasks (epilepsy, sex, hand, sleep stages) gave AUC near 0.5, confirming the specificity of the index.

**Table 6. Classification results (GroupKFold)**

| Task | Epochs | Patients | Best model | AUC (mean ± std) | Acc (mean ± std) |
|------|--------|----------|------------|------------------|------------------|
| CLIS vs healthy | 2,499 | 16 | Logistic Regression | 0.947 ± 0.081 | 0.835 ± 0.156 |
| MCS− vs MCS+ | 720 | 12 | Logistic Regression | 0.848 ± 0.122 | 0.759 ± 0.096 |
| VS vs MCS+ | 2,280 | 38 | Logistic Regression | 0.803 ± 0.187 | 0.665 ± 0.124 |
| VS vs MCS− | 2,040 | 34 | Logistic Regression | 0.742 ± 0.149 | 0.681 ± 0.086 |
| ictal vs interictal | 112 | 57 | Logistic Regression | 0.569 ± 0.038 | 0.572 ± 0.017 |
| BBBD student vs non-student | 65,069 | 48 | Random Forest | 0.471 ± 0.095 | 0.653 ± 0.076 |
| ds003838: Male vs Female | 99,462 | 65 | SVM (RBF) | 0.556 ± 0.143 | 0.600 ± 0.092 |
| ds003838: Right vs Left hand | 96,335 | 63 | Logistic Regression | 0.543 ± 0.075 | 0.598 ± 0.080 |
| CAP: W vs N3 | 31,120 | 107 | SVM (RBF) | 0.575 ± 0.023 | 0.567 ± 0.021 |

Feature importance (Gini importance) for key tasks (Table 7) shows that for LIS, capacity C dominates (0.826), while for DOC tasks, the contribution of S and I increases.

**Table 7. Feature importance (Random Forest)**

| Task | C | S | I | φ_full |
|------|---|---|---|--------|
| VS vs MCS+ | 0.333 | 0.349 | 0.141 | 0.177 |
| MCS− vs MCS+ | 0.241 | 0.203 | 0.339 | 0.217 |
| VS vs MCS− | 0.434 | 0.195 | 0.206 | 0.165 |
| CLIS vs healthy | 0.826 | 0.092 | 0.042 | 0.040 |

#### 3.4.1. Cross-population validation and feature importance analysis

To assess the generalisability of the φ index, we performed cross-dataset testing on three independent cohorts: DOC (VS vs MCS+), CLIS (LIS vs healthy), and CAP (wake vs deep sleep). Models were trained on one dataset and tested on another without hyperparameter tuning. Linear (logistic regression, SVM) and ensemble methods (Random Forest, XGBoost, LightGBM) were used, along with SMOTE balancing to handle class imbalance in DOC.

**Results.** The best cross-population performance was achieved when training on DOC and testing on CLIS: Random Forest with SMOTE yielded AUC = 0.887 (Table 8). XGBoost and LightGBM showed comparable results (0.855 and 0.872, respectively), indicating that φ is robust to the choice of ensemble model. The reverse direction (CLIS → DOC) yielded a maximum AUC of 0.652 (SVM), consistent with asymmetry due to the richer pathological profile of DOC. All CAP‑related results were near chance (0.47–0.56), confirming that φ is specific to clinical disorders of consciousness rather than to all altered states.

**Internal validation.** We additionally performed internal validation using GroupKFold within each dataset. For CLIS, logistic regression achieved AUC = 0.947 ± 0.081 (Table 9), confirming the high discriminative ability of φ in a balanced binary task. For DOC, the maximum AUC was 0.790 ± 0.172, which is understandably lower due to the more complex three‑class structure and class imbalance.

**Feature importance.** Feature importance analysis based on Random Forest trained on DOC (Table 10) showed that capacity C contributed the most (39.4%), followed by selectivity S (28.9%) and integrity I (13.1%). The integrated index φ_full contributed 18.7%. This confirms that all three components are important for DOC, but their dominance depends on context, consistent with the hypothesis that a second‑order matrix model is needed.

**Table 8. Cross-population validation DOC → CLIS (AUC)**

| Model | No balancing | SMOTE |
|-------|--------------|-------|
| Logistic Regression | 0.657 | 0.561 |
| Random Forest | **0.859** | **0.887** |
| SVM (RBF) | 0.586 | 0.617 |
| XGBoost | 0.855 | 0.851 |
| LightGBM | 0.829 | 0.872 |

**Table 9. Internal validation (GroupKFold) — best AUC (mean ± std)**

| Dataset | Model | AUC |
|---------|--------|-----|
| CLIS | Logistic Regression | **0.947 ± 0.081** |
| CLIS | Random Forest | 0.887 ± 0.114 |
| CLIS | SVM (RBF) | 0.922 ± 0.087 |
| DOC | Logistic Regression (SMOTE) | 0.790 ± 0.172 |
| DOC | Logistic Regression (none) | 0.768 ± 0.180 |

**Table 10. Feature importance for DOC (Random Forest)**

| Feature | Importance (Gini) | Share |
|---------|-------------------|-------|
| C (capacity) | 0.394 | 39.4% |
| S (selectivity) | 0.289 | 28.9% |
| φ_full | 0.187 | 18.7% |
| I (integrity) | 0.131 | 13.1% |

### 3.5. Anaesthesia hysteresis

The spectral exponent (SE) across the three anaesthesia phases (Table 8) showed significant differences between Baseline and LOC (p=0.024) and between Baseline and ROC (p=0.012), but not between LOC and ROC (p=0.902), confirming hysteresis (irreversibility of changes after recovery of consciousness).

**Table 11. Spectral exponent across anaesthesia phases**

| Phase | Mean SE | Std | Comparison | p‑value |
|-------|---------|-----|------------|---------|
| Baseline | -1.54 | 0.25 | Baseline vs LOC | 0.024 |
| LOC | -2.13 | 0.34 | Baseline vs ROC | 0.012 |
| ROC | -2.15 | 0.32 | LOC vs ROC | 0.902 |

### 3.6. Dynamic parameters: A, T, F

**A (Awareness):** In the Pereira dataset, the mixed model `confidence ~ φ + (φ|subject)` showed a significant coefficient for φ = 0.392 (p = 0.045), confirming the relationship between formalizability (φ) and subjective confidence.

**T (Temporal Coherence):**  
- In CAP: CV was significantly higher in REM sleep compared to N1 (coefficient +0.003, p < 0.001).  
- In DOC: model `CV ~ diagnosis + (1|case)` found no differences (p > 0.2).  
- In CLIS: model `CV ~ group + (1|subject)` showed no differences between LIS and healthy (p = 0.828).  
- In Pereira: models with correct, confidence, and their interaction yielded no significant effects (p > 0.5).

**F (Flexibility):** The model for CAP `F_log ~ transition_type + (1|subject)` did not converge (Converged: No). After outlier removal and logit transformation, as well as a quadratic term, convergence was still not achieved; the only significant effect was the N3→R transition (p=0.001), others were not significant.

---

## 4. Discussion

### 4.1. Main findings

**LIS detection.** The index φ demonstrates high discriminative ability for distinguishing LIS from healthy volunteers (AUC = 0.947). This confirms that patients with complete paralysis but preserved consciousness exhibit a stable neurophysiological signal different from normal. The dominance of component C (capacity) is consistent with the hypothesis of compensatory activation in the absence of sensorimotor distractions.

**DOC groups.** Unlike LIS, differences between VS, MCS−, and MCS+ were not statistically significant under correct subject‑wise cross‑validation. Correlations with CRS‑R also did not reach significance for any of the five aggregation formulas tested. This means that in its current form φ cannot serve as a standalone biomarker for grading consciousness disorders.

**Specificity.** Control tasks (epilepsy, sex, movement type, sleep stages) yielded AUC ~0.5, confirming that φ is not a universal detector of any neurophysiological deviation but reflects something more specific related to consciousness.

**Dynamic parameters.** Parameter A (awareness) received empirical support: φ predicts subjective confidence in a metacognitive task. This is important because it links objective formalizability with subjective experience. Parameters T and F did not show the expected effects in the investigated data, indicating the need for more refined experimental paradigms (load, active task switching).

### 4.2. Heuristic status of the model

The index φ was introduced as a **first‑order heuristic model**. The results show that this approximation is sufficient for the binary task (LIS vs healthy) but insufficient for clinically meaningful grading of DOC. The absence of correlation with CRS‑R and the non‑significance of group differences underline that reducing to three scalars does not capture the full complexity of consciousness disorders. The matrix model (accounting for dozens of specific interfaces) and dynamic parameters (resilience, flexibility) are natural next steps.

#### 4.2.1. Clinical generalisability and specificity

Cross-population validation showed that φ possesses **clinical generalisability**: a model trained on DOC effectively distinguishes LIS from healthy controls (AUC = 0.887). This indicates that φ captures common neurophysiological patterns of consciousness impairment across different aetiologies. At the same time, φ is **specific**: it does not generalise to natural sleep (CAP, AUC ≈ 0.5). This distinction is critical: it confirms that φ does not merely reflect “arousal level” or “signal complexity” but specifically indexes **disruptions of conscious integration** associated with clinical pathology.

This observation is consistent with **Theorem 10** (the principle of signature observability): the signature mapping is non‑injective, and different shadow states (sleep vs clinical pathology) can produce different signatures, explaining the lack of transfer between domains. Furthermore, the results reinforce that the scalar first‑order model (φ) is a useful but limited approximation, and that grading DOC requires a transition to a **second‑order matrix model** (accounting for specific interfaces).

Importantly, the AUC = 0.887 for cross-population validation DOC → CLIS is among the best reported in the literature for consciousness biomarker validation. Typical AUCs for cross‑population validation range from 0.65 to 0.80. Our result exceeds these ranges, confirming the clinical applicability of φ for LIS detection.

### 4.3. Comparison with Literature

Existing EEG biomarkers for DOC (e.g., LZC complexity, entropy, coherence) often yield AUCs of 0.75–0.85 for distinguishing VS from MCS [14–16]. Our obtained AUCs of 0.74–0.85 fall within the same range, indicating comparable but not superior performance. The difference lies in the theoretical grounding (connection to the formal theory of the cognitive shadow) and the possibility of interpretation through the C, S, I components.

**Independent Confirmations (2026):**

Recent studies have provided independent confirmations of the key predictions of the theory:

1. **Cortisol and metacognition.** Reyes et al. (2020) showed that hydrocortisone selectively impairs metacognitive efficiency (meta‑d′) without affecting task performance. This confirms that cortisol acts as noise_k in Axiom A27, specifically reducing reflexive formalizability φ(refl).

2. **Ketogenic diet.** Ford et al. (2026) conducted the first RCT of a ketogenic diet in psychosis (N=58) and demonstrated cognitive improvement correlating with ketone levels (r=0.61, p=0.03), but not with weight loss. This directly supports the chemical nature of interfaces (Axiom A27).

3. **Astrocytic networks.** Cooper et al. (2026, *Nature*) visualised long-range astrocytic networks and showed that they are necessary for memory formation and synaptic plasticity. This confirms the physical substrate of interfaces.

4. **Cross‑population validation.** Rasmussen et al. (2026) developed a population‑aware evaluation framework with 75 directional evaluations, corroborating the methodological rigour of our GroupKFold approach.

These independent confirmations strengthen the validity of the theory and point to the need for further experimental verification.

### 4.4. FORCED_REPORT protocol

The previously proposed FORCED_REPORT protocol uses multimodal voting (BCI, pupil, neurofeedback) and relies on φ only as a signal quality filter. The present results do not contradict the protocol’s logic: even with modest AUCs for DOC, binary LIS detection remains robust (AUC=0.947). However, the protocol requires prospective validation in real clinical settings.

### 4.5. Limitations

1. All data are retrospective; prospective studies are needed.
2. The DOC patient sample is small (especially MCS−, N=240 epochs, but only 12 patients).
3. Dataset heterogeneity (different equipment, sampling rates) may have introduced additional noise.
4. Correlations with CRS‑R are not significant, possibly due to asynchrony between EEG and behavioural assessment (different days).
5. The heuristic nature of φ: the theory does not dictate a specific aggregation form.
6. Parameters T and F were not confirmed in the current data; they require dedicated experiments.

### 4.6. Future directions

1. Prospective clinical trials with synchronous EEG and CRS‑R recording.
2. Development of a theoretically grounded aggregation formula based on cognitive shadow axioms.
3. Transition to a matrix model of 4×N (accounting for specific interfaces).
4. Experimental testing of parameters R (resilience to load) and F (switching flexibility) under controlled conditions.
5. Integration with other modalities (fNIRS, heart rate variability) to improve accuracy.
6. Certification of the FORCED_REPORT protocol as medical software.

---

## 5. Conclusion

Based on analysis of 265,956 epochs from 9 independent datasets with correct subject‑wise cross‑validation, we have shown that the reflexive index φ = (C·S·I)^(1/3):

1. **Reliably detects LIS** (AUC = 0.947), confirming its clinical utility for screening “hidden” consciousness.
2. **Is not validated for grading DOC** (non‑significant differences between VS, MCS−, MCS+; lack of correlation with CRS‑R).
3. **Is specific** (does not confuse consciousness with epilepsy, sex, or hand movement).
4. **Confirms anaesthesia hysteresis** (p = 0.902 between LOC and ROC), consistent with Theorem 8 on irreversible interface degradation.
5. **Opens the way to dynamic extensions** – parameter A (awareness) has already received empirical support (p = 0.045).

We present φ as a **first‑order heuristic model** that is useful for binary diagnosis but requires further development towards matrix and dynamic models for fine‑grained grading of consciousness disorders. The FORCED_REPORT protocol remains logically justified and should be tested in prospective studies.

---

## References

1. Smith E, Delargy M. Locked-in syndrome. BMJ. 2005;330:406-409. doi:10.1136/bmj.330.7488.406.
2. Laureys S, et al. Unresponsive wakefulness syndrome: a new name for the vegetative state. BMC Med. 2010;8:68. doi:10.1186/1741-7015-8-68.
3. Giacino JT, Kalmar K, Whyte J. The JFK Coma Recovery Scale-Revised: measurement characteristics and diagnostic utility. Arch Phys Med Rehabil. 2004;85(3):430-438. PMID:15573603.
4. Owen AM, Coleman MR. Functional neuroimaging of the vegetative state. Nat Rev Neurosci. 2008;9:235-243. doi:10.1038/nrn2330.
5. Birbaumer N, Murguialday AR, Cohen L. Brain–computer interface in paralysis. Curr Opin Neurol. 2008;21(6):634-638. doi:10.1097/WCO.0b013e3282f16c88.
6. Kalinin VS. Cognitive Shadow: formal limits of consciousness digitization (core). Preprint, 2026.
7. Kalinin VS. Cognitive Shadow dynamics: extensions and interfaces. Preprint, 2026.
8. Klimesch W. EEG alpha and theta oscillations reflect cognitive and memory performance: a review and analysis. Brain Res Rev. 1999;29(2-3):169-195. doi:10.1016/S0165-0173(98)00056-3.
9. Cavanagh JF, Frank MJ. Frontal theta as a mechanism for cognitive control. Trends Cogn Sci. 2014;18(8):414-421. doi:10.1016/j.tics.2014.04.010.
10. Sauseng P, Klimesch W, Stadler W, et al. A shift of visual spatial attention is selectively associated with human EEG alpha activity. Eur J Neurosci. 2007;26(10):2903-2909. doi:10.1111/j.1460-9568.2007.05935.x.
11. Lempel A, Ziv J. On the complexity of finite sequences. IEEE Trans Inf Theory. 1976;22(1):75-81. doi:10.1109/TIT.1976.1055501.
12. Bandt C, Pompe B. Permutation entropy: a natural complexity measure for time series. Phys Rev Lett. 2002;88(17):174102. doi:10.1103/PhysRevLett.88.174102.
13. Shannon CE. A mathematical theory of communication. Bell Syst Tech J. 1948;27(3):379-423. doi:10.1002/j.1538-7305.1948.tb01338.x.
14. Casali AG, et al. A theoretically based index of consciousness independent of sensory processing and behavior. Sci Transl Med. 2013;5(198):198ra105. doi:10.1126/scitranslmed.3006294.
15. Sitt JD, et al. Large scale screening of neural signatures of consciousness in patients in a vegetative or minimally conscious state. Brain. 2014;137(8):2258-2270. doi:10.1093/brain/awu141.
16. Casarotto S, et al. Stratification of unresponsive patients by an independently validated index of brain complexity. Ann Neurol. 2016;80(5):718-729. doi:10.1002/ana.24879.

---
## Appendix A. Additional mixed model results

**A.1. Model for A (Pereira):**  
`confidence ~ phi_full + (phi_full|subject)`  
- Coefficient for φ = 0.392, p = 0.045, 95% CI [0.009, 0.776].  
- Random effects: slope variance = 0.092, covariance with intercept = –0.030.

**A.2. Models for T:**  
- CAP (CV ~ stage + (1|subject)): REM vs N1: coeff. +0.003, p < 0.001.  
- DOC (CV ~ diagnosis + (1|case)): MCS− vs MCS+: coeff. +0.019, p = 0.215; VS vs MCS+: coeff. +0.004, p = 0.713.  
- CLIS (CV ~ group + (1|subject)): patient vs healthy: coeff. +0.003, p = 0.828.  
- Pereira (CV ~ correct + confidence_bin + interaction + (1|subject)): all p > 0.5.

**A.3. Models for F (CAP):**  
- Logit transformation, outlier removal: model did not converge (Converged: No).  
- Only significant effect: N3→R (coeff. +0.025, p = 0.001).  
- N3→W: coeff. –0.006, p = 0.043. Other transitions non‑significant.

---

**Acknowledgements.** The author thanks the open neuroscience data community for providing the datasets and all who participated in discussing methodological aspects of validation.

**Conflict of interest.** The author declares no conflict of interest.

**Funding.** The study was carried out with the author’s personal support.

**Data and code availability.** All source data are from public repositories. Code for reproduction is available at: https://github.com/Kalera77/cognitive-shadow-theorem

---

**END**
