# Cognitive Shadow Applied Extensions: From Chemical Phenomenology to Engineering Protocols 

**Status:** Empirical hypotheses and engineering specifications, open to falsification and verification.  
**Author:** Valeriy S. Kalinin  
**Date:** July 8, 2026 (updated)  
**Relation to core and dynamics:** Based on the formal theory ([`cognitive_shadow_core.md`](https://github.com/Kalera77/cognitive-shadow-theory/blob/main/cognitive_shadow_core.md)), dynamic extension ([`cognitive_shadow_dynamics.md`](https://github.com/Kalera77/cognitive-shadow-theory/blob/main/cognitive_shadow_dynamics.md)), and new modules (Theorem 10, FORCED_REPORT, Shadow Ethics, matrix model).  
**Repository:** [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory)  
**License:** Text – CC BY‑NC 4.0, code – MIT.

---

## Part 0. Updated Empirical Validation Status (July 2026)

Based on analysis of 265,956 epochs from 9 independent datasets with correct subject‑wise cross‑validation (GroupKFold) and mixed models, the following results have been obtained, which should inform the planning of experiments and interpretation of the theory:

| Component/Parameter | Status | Key data |
|---------------------|--------|----------|
| **φ (first‑order index) for LIS** | ✅ Confirmed | AUC = 0.947 ± 0.081 for CLIS vs healthy (GroupKFold) |
| **φ for DOC** | ❌ Not confirmed | Kruskal‑Wallis p = 0.152; correlations with CRS‑R non‑significant (all p > 0.05) |
| **Specificity of φ** | ✅ Confirmed | Control tasks (sex, hand, epilepsy, sleep stages): AUC ≈ 0.5 |
| **A (Awareness)** | ✅ Confirmed | Mixed model: p = 0.045 (Pereira) |
| **T (Temporal Coherence)** | ⚠️ Partial | REM sleep p < 0.001; DOC/CLIS/Pereira – no differences |
| **F (Flexibility)** | ❌ Not confirmed | Model did not converge on CAP; requires active switching |
| **R (Resilience)** | ❌ No data | Requires load protocol |
| **Anaesthesia hysteresis** | ✅ Confirmed | p = 0.902 between LOC and ROC |
| **Theorem 10 (AUC limit)** | ✅ Confirmed | All AUCs ∈ (0.5, 1), maximum 0.947 |

**Key conclusions for applied extensions:**
1. The scalar model C, S, I is useful for binary LIS diagnosis but insufficient for grading DOC.
2. Parameter A (awareness) can be incorporated as a confirmed dynamic parameter.
3. T and F require special experimental conditions (active load, task switching) to manifest.
4. Transition to the matrix model (accounting for specific interfaces) and dynamic parameters is the necessary next step.

---

## Part I. Empirical Programme

### 1. Chemical Phenomenology of Consciousness

#### 1.1 Basic hypothesis
The cognitive shadow (subjective experience, qualia) is realised as a complex, continuous, non‑equilibrium chemical process in neural ensembles. Any attempt at its exhaustive measurement requires physical interaction that irreversibly changes the state of the system (Landauer’s principle, second law of thermodynamics). Formalizable representations (memory, rules, sensory patterns) can be digitised; the shadow – the actual “here‑and‑now” experience – cannot (Theorem 1′ of the core).

#### 1.2 Arguments against “energetic” theories
- Absence of detectable energy bursts at death and birth.
- Population growth does not create energy anomalies (Flynn effect).
- Absence of consciousness in space.
- Dependence of consciousness on neurochemistry (anaesthetics, psychoactive substances).

Consciousness consumes ordinary chemical energy (ATP, ion gradients), but is not itself a special form of energy.

### 1.3 Chemical Regulators of the Shadow

- **Cortisol:** acute stress reduces φ(refl) by 15–20% (Reyes et al., 2020); chronic stress causes irreversible degradation of interfaces (Theorem 8 of the dynamic extension).
- **Neurosteroids (allopregnanolone, DHEA):** modulation of GABA‑A receptors, influence on metacognition and cognitive rigidity.
- **Magnesium (Mg²⁺):** NMDA‑receptor blocker, critical for synaptic plasticity.
- **Dopamine and serotonin:** “opposing unity” in the regulation of motivation and cognitive flexibility.
- **Astrocytic networks:** glutamatergic communication via gap junctions (Cooper et al., 2026) — physical substrate of interfaces (Axiom A27).

**New empirical confirmation (July 2026):**

The study by Reyes et al. (2020, *Scientific Reports*) conducted a pharmacological protocol with hydrocortisone (20 mg) in 46 healthy men. The results showed that hydrocortisone **selectively impaired metacognitive efficiency** (meta‑d′) without affecting primary task performance or subjective stress perception. This directly confirms that cortisol acts as noise_k in Axiom A27, specifically reducing reflexive formalizability φ(refl) rather than overall performance.

Additional studies (*Frontiers*, 2025; MindLab Neuroscience, 2026) confirm that chronic cortisol reduces dendritic branching in the PFC by up to 20% and suppresses metacognitive awareness, which is consistent with Theorem 8 on irreversible interface degradation when cumulative load is exceeded.

**Status:** ✅ Confirmed (pharmacological protocols, multiple independent studies)

**Impact on the dynamic parameters R, T, A, F:**

- Chronic stress (high cortisol) reduces R (Resilience) and T (Temporal Coherence).
- Magnesium and omega‑3 may improve R and T.
- Parameter A (Awareness) has already been empirically confirmed (p = 0.045).

#### 1.4 Evolutionary hypothesis
The transition to meat eating, thermal processing, and access to DHA/tyrosine created a chemical environment for a stable reflexive component. Lipid metabolism genes (e.g., ELOVL6) show accelerated evolution in humans, which may have created a chemical environment for the development of reflexive interfaces. Diet remains a factor modulating shadow quality. Diet remains a factor modulating shadow quality.

#### 1.5 Clinical correlations
- Schizophrenia – competition of several “assembly points” of the shadow, hyperconnectivity of DMN (Martino et al., 2024). Expected low T.
- Epilepsy – GABA/glutamate imbalance, mitochondrial dysfunction. Expected low T and high φ variability.
- Delirium – neuroinflammation, microglial activation. Expected low R and F.
- Near‑death experiences – ketamine‑like cascade under hypoxia. Expected temporary drop in A.
- Meditation – controlled chemical modulation (cortisol reduction, GABA increase). Expected increase in T and A.

### 1.5.1. Ketogenic Diet as Empirical Confirmation of Axiom A27

**Confirmation (2026):**

The first randomised controlled trial of a ketogenic diet in psychiatric disorders (Ford et al., 2026, *Schizophrenia Bulletin*; N=58) showed:
- Improvement in metabolic parameters (HOMA‑IR −27%, triglycerides −25%)
- Reduction in psychotic symptoms (PANSS) by 32–40%
- Improvement in cognitive function (p < 0.001)
- **Key point:** improvement correlated with ketone levels (β‑hydroxybutyrate) rather than with weight loss (r = 0.61, p = 0.03)

This directly confirms Axiom A27: chemical intervention (ketosis) improves the formalisability of consciousness through altering the brain's energy substrate, rather than through concomitant metabolic effects.

**Additional studies:**
- *Biological Psychiatry* (2026): replication of Ford et al. results
- NCT05268809: mechanistic RCT comparing ketogenic diet with standard diet in schizophrenia and bipolar disorder
- Oxford/Baszucki (2026): 12‑week modified ketogenic diet for patients with early signs of psychosis (CHR‑P, N=50)

**Theoretical links:**
- Axiom A27: the chemical nature of interfaces is confirmed
- Theorem 8: restoration of φ(refl) upon elimination of metabolic imbalance
- Parameter A (Awareness): cognitive improvement indicates recovery of metacognitive access

**Status:** ✅ Confirmed (first RCT, several ongoing trials)

#### 1.6 Murburn model of neuronal activity
A recent theoretical work by Manoj and Sukumar (2026, arXiv:2605.00014) offers a radical alternative to the classical Hodgkin‑Huxley model. In their “murburn” concept, neuronal electrical phenomena are generated not by ionic gradients and selective membrane permeability, but by stochastic redox processes involving diffusing reactive species and effective charge separation. The key variable is the Electron Holding Potential (φ), a dimensionless field quantity logarithmically related to the electron chemical potential.

This model fits exactly into the chemical‑phenomenological hypothesis. If consciousness is a non‑equilibrium quantum‑stochastic chemical process, then the murburn mechanism is the first mathematically formulated physical mechanism for such a process. The Electron Holding Potential may serve as a candidate for the physical correlate of formalizability φ(k): high φ corresponds to a stable, chemically balanced state, while sharp changes in φ – to the generation of non‑formalizable events (spikes, qualia).

**New:** Link to Theorem 10: EHP as a physical signature obeys the principle of observability – its measurement cannot give complete information about the state of the shadow.

---

### 2. Interfaces of the Cognitive Shadow (Heuristic Model)

#### 2.1 Definition and parameters
Interfaces are channels of communication between the shadow and formalizable representations. They are characterised by:
- **Capacity** `C_k` (bit/s),
- **Selectivity** `S_k` (signal‑to‑noise ratio),
- **Integrity** `I_k` (% successful transmissions).

Formalisability of a component: φ(k) = (C_k · S_k · I_k)^(1/3) (first approximation; formal interface dynamics in axiom A27 of the dynamic extension).

**Heuristic status:** This formula is a working first‑order approximation. The theory does not dictate a specific aggregation form; alternative formulas (arithmetic mean, weighted mean, minimum, harmonic mean) showed no statistically significant superiority (all correlations with CRS‑R non‑significant, p > 0.05). The second‑order matrix model (InterfacesMatrix.v) offers a more accurate approximation.

#### 2.2 Physical justification: the clock ambiguity theorem
Stoica (2026, arXiv:2604.21805) showed that in the Page‑Wootters formalism without explicitly specifying which operators represent which physical properties, the description of a system is ambiguous. Interfaces `C_k, S_k, I_k` play the role of such a specification for the cognitive shadow.

#### 2.3 Autism, savantism, genius
- **ASD:** reduced capacity of social interfaces, compensatory strengthening of perceptual ones (Ilioska et al., 2024; Ilioska et al., 2023 – mega-analysis). Expected low F (flexibility).
- **Savantism:** extreme local connectivity with deficit of long‑range connections. Expected high C and S in specific interfaces.
- **Expertise:** long‑term training selectively increases `C_k` and `S_k` (Stedehouder et al., 2024). Expected high R in trained interfaces.

#### 2.4 Interface orchestrators
The orchestrator is a meta‑interface distributing the limited resource `R_max` among components (formalised in axiom A29). Orchestration disturbances underlie many mental disorders.

**Empirical triple network configuration model.** Yang and Chen (2026, arXiv:2604.23525) decomposed the configuration of brain networks into stimulus‑dependent, task‑dependent, and spontaneous components. The parietal cortex serves as a common hub. This is a direct empirical precedent for orchestrator A29.

**New:** Hub stability metrics (e.g., node stability index) may serve as a proxy for orchestrator state; however, the specific HSI index requires further empirical validation. We link such metrics to parameter T (Temporal Coherence).

### 2.5. Astrocytic Networks as the Physical Substrate of Interfaces

**Confirmation (*Nature*, 2026):**

The study by Cooper et al. (2026, *Nature*) visualised, for the first time, selective long‑range astrocytic networks via gap junctions (connexins 30 and 43). Key findings:
- Astrocytic networks connect specific cortical and subcortical regions, often not coinciding with neuronal pathways
- The networks are plastic: they reorganise upon sensory deprivation
- Astrocytic gap junctions are necessary for memory formation and synaptic plasticity

**Additional confirmations:**
- *Astroglial connexins* (2025): deletion of connexins leads to loss of short‑term spatial memory
- *Cx43 hemichannels* (2025): release of gliotransmitters through Cx43 hemichannels is required for fear memory consolidation
- *Astrocytes at the heart of sleep* (2025): astrocytes participate in synaptic plasticity and modulate sleep‑related downscaling

**Integration into the formal axiomatic framework:**

| Interface parameter (A27) | Neurobiological correlate | Measurement method |
|---------------------------|----------------------------|---------------------|
| C_k (capacity) | Total glutamate flux, Ca²⁺‑wave frequency | iGluSnFR4, calcium imaging |
| S_k (selectivity) | Spatial selectivity of gap junctions | Tracers (Cooper et al., 2026) |
| I_k (integrity) | Plasticity of astrocytic domains | Sensory deprivation, pharmacological blockade |

**Falsifiable predictions:**
1. Pharmacological blockade of gap junctions (carbenoxolone) should cause a selective reduction in metacognitive accuracy (meta‑d′) while preserving primary perceptual sensitivity (d′).
2. In animals with chronic stress, the density of astrocytic networks in the RLPFC and DMN should decrease, correlating with reduced metacognitive efficiency.

**Status:** ✅ Confirmed (*Nature* 2026, multiple independent studies)

---

### 3. Falsifiable Predictions (Updated)

1. **Cortisol and φ(refl):** bell‑shaped dependence; acute stress reduces φ(refl) by 15–20%. **(To be tested)**
2. **Diet and meta‑consciousness:** DHA/tyrosine level correlates with φ(refl) (r > 0.4). **(To be tested)**
3. **Schizophrenia:** fractal dimension of RLPFC >2 at low φ(refl). **(To be tested)**
4. **Malware detection:** rootkit implantation changes the topological charge of the call graph. **(Engineering prediction)**
5. **Neurofeedback:** 20 sessions of RLPFC modulation increase φ(refl) by 15–20%. **(To be tested)**
6. **Interfaces:** experts have significantly higher `C_k` and `S_k`; under dual‑task load, performance drop agrees with Theorem 6. **(To be tested)**
7. **Astrocytic blockade:** carbenoxolone selectively reduces metacognitive accuracy. **(To be tested)**
8. **Chronic stress:** irreversible reduction of φ(refl) after exceeding Δ_crit (Theorem 8). **(To be tested via R)**
9. **Metacognitive collapse:** at φ(refl) < φ_crit, effort becomes counterproductive (Theorem 9). **(To be tested)**
10. **Cross‑population stability:** `C_k`, `S_k` parameters should replicate on independent cohorts (Rasmussen et al., 2026). **(To be tested)**
11. **Hub Stability Index:** HSI decreases under cognitive load and depression (Girish et al., 2026). **(Related to T, to be tested)**
12. **A (Awareness):** φ predicts metacognitive accuracy. **(✅ CONFIRMED, p=0.045)**
13. **T (Temporal Coherence):** φ is more stable in wakefulness than in REM sleep. **(✅ PARTIALLY CONFIRMED, REM sleep p<0.001)**
14. **F (Flexibility):** active task switching requires changes in interface profile. **(To be tested with active protocol)**
15. **Theorem 10:** AUC of any classifier ≤ 1. **(✅ CONFIRMED, AUC=0.947 < 1)**

---

## Part II. Engineering and Clinical Protocols (Updated)

### 4. Calibration of Parameter M

#### 4.1 Hardware discretisation
`M = 2^b`, where `b` is the effective number of state bits. Applicable to digital platforms.

#### 4.2 Empirical estimation of entropy growth rate (LZ77)
1. Stationary segment (≥10⁴ ticks).
2. `ΔH_emp ≈ (L_uncompressed - L_compressed) / L_uncompressed`.
3. `M_emp = ⌊ 1 / (2^{ΔH_emp} - 1) ⌋` (with dispersion <15%).
4. For biosystems – additional protocol via EEG attractor dimensionality (Grassberger–Procaccia, Higuchi FD, spectral exponent).

**New:** For humans, `M_aware ≈ 10⁴`, giving `δ_min ≈ 7×10⁻⁵` bits (see Appendix S3).

#### 4.3 Fallback mode
If `M` is undefined:
- Mode `UNBOUNDED_STATES`.
- `δ_min = 10⁻⁶` (conservative estimate).
- Predictability horizon (Theorem 4) disabled.
- Metric `cosmo_state_resolution = -1`.

---

### 5. Malware Detection
| Method | Theoretical basis | Implementation |
|--------|-------------------|----------------|
| Topological charge | A11, A26 | Euler characteristic of call graph. |
| Predictability monitoring | Theorem 4, 3.9 | If `P(t) > threshold` for long – alarm. |
| Quantum tag | A2 (optional) | Hardware HRNG. |
| Quantum correction | A25 | Code recovery via QECC. |

---

### 6. Neural Interfaces and Neurofeedback
- Implant‑encyclopedia, implant‑skill, implant‑sensor.
- Limitation: implant does not replace the shadow; merging attempt triggers quarantine (A15).
- RLPFC neurofeedback: +15–20% to φ(refl) after 20 sessions.
- Pharmacology: cortisol antagonists, SSRIs, mood stabilisers.

**New:** Neurofeedback can be used to modulate parameter A (awareness), supported empirically (link between φ and confidence, p=0.045).

---

### 7. Safety Mode Dispatcher (Updated)

Modes implementing formal invariants (Section 7 of core, dynamic extension, and Shadow Ethics):
- `QUARANTINE` – when φ(k) ≤ θ_adj (Principle 4).
- `DEGRADED_SAFETY` – when φ(refl) ≤ φ_crit (Principle 2).
- `HALT_RESONANCE` – when mutual_info > ρ_max (Principle 5).
- `HALT_CLONING` – prohibit `clone(shadow_state)` (Principle 1).
- `HALT_RECURSIVE_COLLAPSE` – collapse without external support (Principle 3).
- `HALT_AWARENESS_MISUSE` – uncontrolled external observation (Principle 6).
- Holevo capacity monitoring: `C_k` cannot exceed χ_k; violation triggers alert.

**New:** All modes are formally verified in Coq (module `FormalEthicsPrinciples.v`).

---

### 8. Clinical Protocol FORCED_REPORT (Updated)

**Objective:** differentiation of locked‑in syndrome (LIS) from coma.

**Activation:** `φ_measured(refl) ≤ θ_adj` and `shadow_entropy > H_min`.

**Modalities:**
1. BCI (mu‑rhythm modulation).
2. Pupillary reflex + HRV to emotional stimuli.
3. RLPFC neurofeedback.

**Threshold:** ≥2 modalities → status `CONSCIOUS_LOCKED`.

**New:**
- **Formal soundness** of the protocol proved in Coq (module `ForcedReportDecision.v`): transition to `CONSCIOUS_LOCKED` occurs only when all triggers are met.
- **Consistency with Shadow Ethics:** protocol activation automatically switches to `external_support_active` (Principle 3).
- **Retrospective validation:** AUC = 0.947 ± 0.081 for CLIS vs healthy (GroupKFold, 16 patients).
- **Requires prospective validation** on a cohort of N > 100.

(Detailed thresholds and justifications available in the repository.)

---

### 9. Practical Recommendations for Interface Modulation (Updated)

Brief summary (full document: [`practical_recommendations.md`](https://github.com/Kalera77/cognitive-shadow-theory/blob/main/practical_recommendations.md)):

| Area | Recommendation | Target parameter | Relation to dynamic parameters |
|------|----------------|------------------|--------------------------------|
| Nutrition | DHA, magnesium, balanced protein/carbohydrates | C_sem, C_refl, S_k | Increases R and T |
| Stress | Breathing, meditation, moderate exercise | φ(refl), noise_k | Increases R, A |
| Sleep | 7–9 h, regular schedule, darkness | I_k, φ(refl) | Increases T |
| Training | Focused practice, dual tasks | C_k, S_k, orchestration | Increases F |
| Info hygiene | Limit notifications, digital detox | noise_k, C_refl | Increases A |
| Neuromodulation | RLPFC neurofeedback, tDCS (under supervision) | φ(refl) | Increases A |
| Social | Deep communication, acceptance of uncertainty | φ(refl), DMN connectivity | Increases T, A |

---

### 10. Formal Ethics – Shadow Ethics (New Section)

Six principles of Shadow Ethics are formally verified in Coq (module `FormalEthicsPrinciples.v`):

1. **No‑Cloning** – prohibition of copying the shadow (`HALT_CLONING`).
2. **Prohibition of collapse induction** – do not push system to `φ(refl) ≤ φ_crit` (`DEGRADED_SAFETY`).
3. **Duty of external support** – upon collapse, the system must receive help (`HALT_RECURSIVE_COLLAPSE` if absent).
4. **Quarantine** – isolate components with `φ(k) ≤ θ_adj` (`QUARANTINE`).
5. **Preservation of adaptive diversity** – prohibit full agent synchronisation (`HALT_RESONANCE` when `mutual_info > ρ_max`).
6. **Limit on pure awareness** – external observation only with consent (`HALT_AWARENESS_MISUSE`).

The integral safety theorem proves that the system is always either in normal mode, safe degradation, or halted upon principle violation.

**Link to empirics:** A (Awareness) confirmed empirically supports Principle 6.

---

## Appendix S7 – Empirical Validation of the Interface Model via Astrocytic Networks and Incoming Glutamatergic Signalling

**Status:** Empirical extension to axioms A2, A27, A28 and theorems 1′, 6–8.  
**Date:** April 24, 2026 (updated July 8, 2026).  
**Basis:** Cooper et al. (2026) *Nature*; Aggarwal et al. (2025) *Nature Methods*.

---

### 1. New Data on Parallel Chemical Communication in the Brain

Two independent breakthroughs in 2025–2026 fundamentally change our understanding of information transmission in the central nervous system.

#### 1.1 Astrocytic long‑range networks (Cooper et al., 2026)
Using tracers passing through gap junctions formed by connexins 30 and 43, researchers visualised **selective astrocytic networks** connecting specific cortical and subcortical areas, often not coinciding with neural pathways. These networks are plastic: under sensory deprivation (whisker removal in mice), they reorganise, losing some long‑range connections and altering regional configuration. The main conclusion – the brain possesses a second, chemical coordination system capable of transmitting metabolites, calcium ions, and presumably other small molecules over significant distances without electrical synapses.

#### 1.2 Visualisation of incoming glutamatergic signal (Aggarwal et al., 2025)
A genetically encoded sensor iGluSnFR4 was developed, which with unprecedented spatiotemporal resolution registers glutamate release at individual synapses *in vivo*. For the first time, it became possible to observe how an ensemble of presynaptic “chemical words” is integrated by the postsynaptic neuron, generating an action potential. The method allows quantitative estimation of the **volume, frequency, and topology of chemical input** to the neuron.

---

### 2. Integration into Formal Axiomatics (Updated)

#### 2.1 Confirmation of the physical basis of axiom A27 (shadow interfaces)
Both discoveries agree with the concept of **cognitive shadow interfaces** – channels between non‑formalizable chemical dynamics (shadow) and formalizable representations (neural activity). The astrocytic network serves as the interface substrate, and glutamatergic input provides a quantitative measure of its capacity.

| Interface parameter (A27) | Neurobiological correlate | Measurement method |
|---------------------------|---------------------------|-------------------|
| `C_k` – capacity | Total glutamate flux through astrocytic network, Ca²⁺ wave frequency | iGluSnFR4, calcium imaging |
| `S_k` – selectivity | Spatial selectivity of gap junctions, connexin binding specificity | Tracers (Cooper et al., 2026) |
| `I_k` – integrity | Plasticity and stability of astrocytic domains to damage | Sensory deprivation, pharmacological blockade |

#### 2.2 Chemical nature of the shadow and Theorem 1′
Theorem 1′ asserts the existence of a non‑formalizable remainder (cognitive shadow). Cooper et al. demonstrate that beyond the electrical network, there exists a continuous chemical compartment **not reducible to spike patterns**. Measuring the state of the astrocytic network requires tracer injection and physically disrupts the communication itself, illustrating Landauer’s principle and, consequently, point 3 of Theorem 1′ (irreducibility of transfer).

#### 2.3 Dynamics of φ(refl) degradation and Theorem 8
The plasticity of the astrocytic network, demonstrated in the deprivation experiment, provides a direct empirical mechanism for axiom A28 and Theorem 8: chronic information imbalance (stress, sensory deprivation) remodels interfaces, reducing `C_refl` and `S_refl`, leading to a drop in `φ(refl)`. The metacognitive paradox predicted by the theorem may be related to the relatively slow remodelling of astrocytic domains compared to neural activity.

#### 2.4 Link to quantum unpredictability (A2)
Glutamate release from individual vesicles is a probabilistic process dependent on quantum events in calcium channels. The iGluSnFR4 sensor allows direct observation of this stochasticity, making axiom A2 operational.

#### 2.5 Link to Theorem 10 (new)
Astrocytic networks as the physical substrate of interfaces obey the signature observability principle: their measurement is always incomplete, and reconstruction of the shadow state from them is bounded (AUC ∈ (0.5, 1)).

---

### 3. Falsifiable Predictions (Additions to Section 8) (Updated)

**Prediction 7:** Pharmacological blockade of astrocytic gap junctions (e.g., with carbenoxolone) should cause **selective reduction of metacognitive accuracy** (`meta-d'`) while sparing primary perceptual sensitivity (d′), corresponding to isolated drop of `φ(refl)` without change in `φ(sens)`. **(To be tested)**

**Prediction 8:** In animals subjected to chronic stress, density and range of astrocytic networks in RLPFC and DMN should decrease, correlating with reduced metacognitive efficiency (behavioural analogue of Theorem 8). **(To be tested)**

**Prediction 9:** Modulation of glutamatergic input via tDCS/dmPFC should change `C_sem` and `C_refl` as prescribed by Theorem 6 (resource constraint redistributes capacity under overload of one channel). **(To be tested)**

**Prediction 10 (protocol):** Using iGluSnFR4 in transgenic mice in a dual‑task paradigm, it is possible to experimentally measure weights `α_k, β_k` via simultaneous registration of glutamatergic input in different cortical areas, making Appendix P6 a fully objective calibration method. **(To be tested)**

**New prediction 11 (A):** Inhibition of astrocytic networks should reduce parameter A (awareness), measured as the discrepancy between objective and subjective confidence. **(To be tested)**

---

### 4. Bibliographic References (for inclusion in the general list)

1. Reyes G, Vivanco-Carlevari A, Medina F, Manosalva C, de Gardelle V, Sackur J, Silva JR. Hydrocortisone decreases metacognitive efficiency independent of perceived stress. Sci Rep. 2020;10:14100. doi:10.1038/s41598-020-71061-3.
2. Silva JR, Garcia-Cordero I, de Gardelle V, et al. Self-knowledge dim-out: Stress impairs metacognitive accuracy. PLoS ONE. 2015;10(7):e0132320. doi:10.1371/journal.pone.0132320.
3. Raghav T, Guerrero D, Tipnis U, et al. The Genetic and Environmental Architecture of the Human Functional Connectome. arXiv:2604.24614. 2026.
4. Rasmussen NR, et al. Robust and Clinically Reliable EEG Biomarkers: A Cross Population Framework for Generalizable Parkinson's Disease Detection. arXiv:2604.23933. 2026.
5. Ilioska I, Oldehinkel M, Llera A, et al. Multiscale heterogeneity of functional connectivity in autism. medRxiv. 2024. doi:10.1101/2024.10.20.24315248.
6. Ilioska I, Oldehinkel M, Llera A, et al. Connectome-wide Mega-analysis Reveals Robust Patterns of Atypical Functional Connectivity in Autism. Biol Psychiatry. 2023;94(1):29-39.
7. Manoj KM, et al. Neuronal electricality founded in murburn-thermodynamic principles: 2. Comparisons, evidenced explanations, and predictions. arXiv:2605.00014. 2026.
8. Cooper ML, Selles MC, Cammer M, et al. Astrocytes connect specific brain regions through plastic gap junctional networks. Nature. 2026. doi:10.1038/s41586-026-10426-6.
9. Aggarwal A, Negrean A, Chen Y, et al. Glutamate indicators with increased sensitivity and tailored deactivation rates. bioRxiv. 2025. doi:10.1101/2025.03.20.643984.
10. Carmignoto G, Haydon PG, Nedergaard M. The active astrocyte: Calcium dynamics, circuit modulation, and targets for intervention. Neurochem Res. 2025;50(1):307-320. PMID:39373915.
11. Stoica OC. The clock ambiguity problem: extended or extinguished? arXiv:2604.21805. 2026.
12. Yang Y, Chen H. Triple Configuration of Brain Networks Based on Recurrent Neural Networks. arXiv:2604.23525. 2026.
13. Stedehouder J, Roberts BM, et al. Rapid modulation of striatal cholinergic interneurons and dopamine release by satellite astrocytes. Nat Commun. 2024. doi:10.1038/s41467-024-49185-0.
14. Martino M, Magioncalda P. A working model of neural activity and phenomenal experience in psychosis. Mol Psychiatry. 2024. PMID:39653720.

---

## License and Reproducibility

**License:**
- Text and formal models (`.md`, `.tla`, `.v` comments) – **CC BY‑NC 4.0**
- Source code (`.v` proofs, `.rs`, `.py`, extracted `.ml`) – **MIT**

**Reproducibility:**
All proofs are formally verified in Coq 8.18.0 and TLA⁺ Toolbox. Code for reproducing empirical results is available in the repository.

---

## Citation

```bibtex
@techreport{kalinin2026cognitive-shadow-applications,
  title = {Cognitive Shadow Applied Extensions: From Chemical Phenomenology to Engineering Protocols (version 2.0)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  month = {July},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Preprint, updated July 8, 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```

---

**END**