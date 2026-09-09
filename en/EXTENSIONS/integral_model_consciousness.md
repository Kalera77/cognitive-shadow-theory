
# Cognitive Shadow Theory: Integral Model of Consciousness, Pathology, and Mindfulness Practices

**Formal Axiomatics, Mathematical Extensions, and Empirical Implications**

| Field | Value |
|-------|-------|
| **Author** | Kalinin Valery S. |
| **Date** | September 2026 (version 3.0) |
| **Status** | Heuristic hypotheses formalized for empirical testing. Not a proven result. |
| **Relation to core** | Based on axioms A27–A29, Theorems 6–9, Postulate P1 |
| **Replaces** | “Three mathematical extensions of cognitive shadow theory” (August 2026) |
| **Repository** | [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory) |
| **DOI** | 10.5281/zenodo.21322891 |
| **License** | Text – CC BY-NC 4.0, code – MIT |

---

## 0. Abstract

This document presents an integral formal model of consciousness combining three previously heuristic directions: **(1)** the dynamics of awareness as anti-noise with decay coefficient $\gamma_{awareness}$, **(2)** a percolation model of the formation and destruction of semantic “toxic anchors”, and **(3)** the neurobiological correlate of “ontological courage” — metacognitive acceptance of one’s own architectural anomaly. All three extensions are consistent with axioms A27–A29 and theorems 6–9 of cognitive shadow theory. Testable predictions, empirical verification protocols, and practical implications for clinical and pedagogical practice are presented.

**Keywords:** cognitive shadow, awareness, addiction, semantic network, ontological courage, EEG biomarkers, metacognition, percolation.

**Theoretical basis.** All formulas and predictions of this document are derived from:
- Axiom A27 (resource limitation and interface dynamics): `[cognitive_shadow_dynamics.md](../cognitive_shadow_dynamics.md)`
- Theorem 9 (recursive instability): module `RecursiveStabilityTheorem.v`
- Postulate P1 (gift of incomprehensibility): module `PostulateP1_GiftOfIncomprehensibility.v`
- Axiom A26 (discrete homotopy): module `Homotopy.v`
- Theorem 7 (limit of controllability): module `InterfacesTheorem7.v`

**Epistemological status.** All three extensions are *formalized hypotheses*, not proven theorems. They are not verified in Coq. Each prediction is open to empirical falsification. Rejection of any of the three extensions does not refute the theoretical core of cognitive shadow theory.

---

## 1. Introduction: From Heuristics to Formal Model

### 1.1. Context

The cognitive shadow theory, developed in a series of prior works, postulates the existence of a non-formalizable remainder of consciousness (the “shadow”) and describes its interaction with formalizable representations through a system of interfaces with limited resource $R_{max}$. Key axioms (A27–A29) and theorems (6–9) have been verified empirically on clinical data (AUC = 0.947 for LIS detection) and received independent confirmation in neurobiological studies (Reyes et al., 2020; Ford et al., 2026; Cooper et al., 2026).

### 1.2. The Problem

A number of phenomena discussed in applied essays (“The Shadow and Its Masks”) remained at the level of heuristic hypotheses:

- **Awareness as anti-noise** — a mechanism by which pure observation ($pure\_awareness$) reduces entropy without consuming $R_{max}$.
- **Formation of a “toxic anchor”** — a process by which an object of addiction acquires a false positive charge in the semantic network.
- **Ontological courage** — a state of acceptance of one’s own architectural anomaly without surrogate compensation.

In the present work, these hypotheses receive a rigorous mathematical formulation consistent with the axiomatics and generate testable predictions.

### 1.3. Goal and Structure of the Document

The document is structured into three extensions (sections 2–4), an integration section (5), practical implications (6), a summary table of predictions (8), empirical justification (9), and supplementary materials (10–11).

---

## 2. Mathematical Extension I: Awareness as Anti-Noise ($\gamma_{awareness}$)

### 2.1. Formal Problem Statement

In axiom A27, the dynamics of noise in interface $k$ is described by the equation:

$$noise_k(t+1) = noise_k(t) + \eta \cdot external\_noise - \delta \cdot intent_k(t)$$

Here $intent_k$ is the control signal from the shadow (volitional effort). However, empirical data (Reyes et al., 2020; MBSR studies) show that mindfulness practice reduces noise even at $intent_k = 0$, i.e., without active intervention. This requires the introduction of a new term.

**Connection to axiomatics:** this extension modifies the right-hand side of the noise dynamics equation in A27 by adding the term $\gamma_{awareness}$. The rest of the axiomatics (resource limitation, dynamics of $C_k$, $S_k$, $I_k$) remains unchanged.

### 2.2. The Decay Coefficient $\gamma_{awareness}$

We introduce a parameter $\gamma_{awareness}(t) \in [0, \gamma_{max}]$ depending on accumulated mindfulness practice time $\tau_{MBSR}(t)$:

$$\gamma_{awareness}(t) = \gamma_{max} \cdot \left(1 - \exp\left(-\frac{\tau_{MBSR}(t)}{\tau_{plateau}}\right)\right)$$

where:
- $\gamma_{max} \approx 0.20$ (maximum noise reduction of 20%, consistent with hypothesis B.3 from “The Shadow and Its Masks”)
- $\tau_{plateau} \approx 200$ hours (time to plateau, empirical estimate from longitudinal MBSR studies)
- $\tau_{MBSR}(t) = \int_0^t practice\_rate(s)\, ds$ — accumulated practice time

### 2.3. Modified Equation for Noise Dynamics

$$noise_k(t+1) = noise_k(t) \cdot (1 - \gamma_{awareness}(t)) + \eta \cdot external\_noise - \delta \cdot intent_k(t)$$

**Key property:** at $intent_k = 0$ (pure observation) and $\gamma_{awareness} > 0$, noise monotonically decreases:

$$noise_k(t) \to \frac{\eta \cdot external\_noise}{\gamma_{awareness}}$$

This is the mathematical expression of Postulate P1: renunciation of intention + mindfulness practice → stationary noise reduction.

### 2.4. Recovery Rate of $\varphi(refl)$

From the definition $\varphi(refl) = (C_{refl} \cdot S_{refl} \cdot I_{refl})^{1/3}$ and axiom A27.1:

$$\frac{d\varphi(refl)}{dt} = \frac{1}{3} \varphi(refl)^{-2} \cdot \left( \frac{\partial \varphi}{\partial C} \cdot \frac{dC_{refl}}{dt} + \frac{\partial \varphi}{\partial S} \cdot \frac{dS_{refl}}{dt} \right)$$

Substituting the dynamics of $C_k$ and $S_k$ from A27 with $\gamma_{awareness}$:

$$\frac{d\varphi(refl)}{dt} = \alpha \cdot \gamma_{awareness}(t) \cdot (\varphi_{max} - \varphi(refl)) - \beta \cdot noise_k(t)$$

where $\alpha, \beta > 0$ are calibration constants.

Solution: at constant $\gamma_{awareness}$ and stationary $noise_k$:

$$\varphi(refl)(t) = \varphi_{max} - (\varphi_{max} - \varphi_0) \cdot \exp(-\alpha \gamma_{awareness} t)$$

This is a logistic recovery curve with characteristic time $\tau_{recovery} = 1 / (\alpha \gamma_{awareness})$.

### 2.5. Connection to Axiomatics

| Element of theory | Connection to extension |
|---|---|
| Axiom A27 | Extended by adding the term $\gamma_{awareness}$ to the noise dynamics equation |
| Theorem 9 | Gets a mechanism for exiting collapse: at $intent_k = 0$ and $\gamma_{awareness} > 0$, the system can self-recover |
| Postulate P1 | Formalized as condition $\gamma_{awareness} > 0$ when renouncing total control |

### 2.6. Testable Predictions

| No. | Prediction | Verification Method |
|---|---|---|
| 1 | $\varphi(refl)$ recovers exponentially with $\tau_{recovery} \propto 1/\gamma_{awareness}$ | Longitudinal EEG study with weekly meta-d' measurements |
| 2 | $\gamma_{awareness}$ saturates at $\tau_{MBSR} \approx 200$ hours | Cross-sectional comparison of beginners, intermediates, and meditation experts |
| 3 | At $intent_k > 0$ (volitional effort) recovery is slower than at $intent_k = 0 + \gamma_{awareness} > 0$ | RCT: “acceptance” group vs “volitional control” group under equal stress |

---

## 3. Mathematical Extension II: Percolation Model of the “Toxic Anchor”

### 3.1. Formal Problem Statement

The semantic component $C_{sem}$ is modeled as a weighted directed graph $G = (V, E, \chi)$:

- $V$ — set of concepts (nodes), $|V| = N$
- $E$ — set of associative links (edges)
- $\chi: V \to [-1, 1]$ — topological charge of each concept (axiom A26)

The object of addiction (e.g., alcohol) is a node $v_{alc} \in V$ with initial charge $\chi_{alc}(0) < 0$ (social disapproval, awareness of harm).

### 3.2. Charge Dynamics During Addiction Formation

With each consumption act, dopamine reinforcement modifies charges in the neighborhood of $v_{alc}$:

$$\chi_i(t+1) = \chi_i(t) + \lambda \cdot R(t) \cdot \mathbb{1}[d(v_i, v_{alc}) \leq r]$$

where:
- $R(t) \in [0, 1]$ — reward signal (dopamine response)
- $d(v_i, v_{alc})$ — graph distance (number of edges)
- $r$ — radius of influence (usually $r = 2$)
- $\lambda > 0$ — learning rate

**Key effect:** nodes associatively related to alcohol (relaxation, friends, stress relief) gradually acquire positive charge.

### 3.3. Percolation Transition

Define the positive cluster $C^+$ as the connected component of the subgraph induced by nodes with $\chi_i > 0$.

**Critical threshold:** when the fraction of positive nodes $p = |C^+| / N > p_c$ (percolation threshold, $p_c \approx 0.31$ for random Erdős–Rényi graphs), a phase transition occurs:

- The entire semantic network restructures
- Alcohol becomes the central node of the giant component
- Alternative coping strategies end up in small components

**Mathematical expression:** at $p > p_c$, the size of the giant component $S(p) \sim (p - p_c)^\beta$, where $\beta \approx 0.41$ (critical exponent).

### 3.4. Modeling Therapeutic “Detachment”

Therapeutic intervention aims to reduce $\chi_{alc}$ and break associative links:

$$\chi_{alc}(t+1) = \chi_{alc}(t) - \mu \cdot intervention(t)$$
$$w_{ij}(t+1) = w_{ij}(t) \cdot (1 - \nu \cdot intervention(t)) \quad \text{for } (i,j) \in E_{alc}$$

**Hysteresis problem:** due to the percolation transition, the system has memory. Even at $\chi_{alc} \to 0$, the giant component may persist due to the inertia of associative links. This explains the high frequency of relapse.

**Condition for complete detachment:** it is necessary not only to reduce $\chi_{alc}$ but also to break enough edges so that $p < p_c$. This requires time $\tau_{min} \sim |E_{alc}| / (\nu \cdot intervention)$, consistent with Theorem 7 (limit of controllability).

### 3.5. Connection to Axiomatics

| Element of theory | Connection to extension |
|---|---|
| Axiom A26 (discrete homotopy) | Topological basis for charge changes |
| Theorem 7 (limit of controllability) | Defines minimal time $\tau_{min}$ for network restructuring |
| Axiom A28 (irreversible degradation) | Gets a mechanism via percolation hysteresis |

### 3.6. Testable Predictions

| No. | Prediction | Verification Method |
|---|---|---|
| 4 | In dependent patients, the semantic association test (IAT) shows bimodal distribution of reaction times | Behavioral experiment with latency measurement |
| 5 | Resting-state fMRI reveals enhanced connectivity between ventral striatum and medial prefrontal cortex in dependent patients | fMRI study with seed-based correlation analysis |
| 6 | After 6 months of therapy, connectivity normalizes, but relapse is provoked by stress | Longitudinal study with measurements before/after and at relapse |

---

## 4. Mathematical Extension III: Ontological Courage as an EEG Correlate

### 4.1. Phenomenological Definition

**Ontological courage** — a metacognitive state in which an agent with abnormally high $C_{genius}$:

1. **Aware** of its architectural anomaly ($\varphi(refl)$ high)
2. **Accepts** it without attempting to compensate with surrogates ($intent_{compensation} = 0$)
3. **Integrates** the anomaly into a coherent identity (high $I_{refl}$)

The opposite: an attempt to suppress the anomaly through addiction, vanity, or hypercompensation.

### 4.2. Neurobiological Hypothesis

Ontological courage requires simultaneous activation of:

- **RLPFC** (rostrolateral prefrontal cortex) — metacognitive monitoring, self-reflection
- **Insula** — interoceptive awareness, emotional integration
- **Low DMN activity** (default mode network) — absence of rumination, self-flagellation

**Hypothesis:** ontological courage manifests as high theta coherence (4–8 Hz) between RLPFC (Fp1/Fp2) and anterior insula (F7/F8) in resting state with eyes closed.

### 4.3. Formal Model

Introduce the ontological courage index:

$$OS = \frac{Coh_{\theta}(RLPFC, Insula) \cdot \varphi(refl)}{1 + Power_{DMN}(\alpha)}$$

where:
- $Coh_{\theta}(RLPFC, Insula)$ — theta coherence between Fp1/Fp2 and F7/F8
- $\varphi(refl)$ — reflective formalizability (measured via meta-d')
- $Power_{DMN}(\alpha)$ — alpha-band power in posterior cingulate cortex (Pz) as a proxy for DMN activity

**Expected values:**
- “Accepted” group (ontological courage): $OS > 0.7$
- “Suppressing” group (addiction, vanity): $OS < 0.4$
- Control group (no anomaly): $OS \approx 0.5$

### 4.4. Connection to Axiomatics

| Element of theory | Connection to extension |
|---|---|
| Theorem 1′ (incompleteness) | Awareness of incompleteness as a condition of courage |
| Theorem 9 (collapse) | Renunciation of $intent_{compensation}$ as a condition of courage |
| Axiom A28 (plasticity) | High $I_{refl}$ as a result of anomaly integration |

### 4.5. Testable Predictions

| No. | Prediction | Verification Method |
|---|---|---|
| 7 | In creative people without addictions, $Coh_{\theta}(RLPFC, Insula)$ is significantly higher than in creative people with addiction | EEG study with group division |
| 8 | $OS$ predicts long-term stability better than $\varphi(refl)$ alone | Predictive validation with 12-month follow-up |
| 9 | MBSR increases $Coh_{\theta}(RLPFC, Insula)$ after 8 weeks | RCT with EEG measurement before/after intervention |

---

## 5. Integration: Unified Model and Its Predictive Power

### 5.1. Interrelation of the Three Extensions

The three extensions are not independent:

- $\gamma_{awareness}$ reduces $noise_k$, facilitating the breaking of associative links in the percolation model (accelerates $\tau_{min}$)
- Reduced $noise_k$ increases $\varphi(refl)$, strengthening the metacognitive monitoring necessary for ontological courage
- High $OS$ (ontological courage) supports mindfulness practice ($\gamma_{awareness}$), creating a positive feedback loop

This forms a triad of self-sustaining recovery:

$$\text{Mindfulness} \to \text{Noise reduction} \to \text{Growth of } \varphi(refl) \to \text{Ontological courage} \to \text{Support of mindfulness}$$

### 5.2. Unified Formal Language

All three extensions use a common formal apparatus:

- **State dynamics:** evolution equations for $noise_k$, $\varphi(refl)$, $\chi_i$
- **Critical thresholds:** $\gamma_{awareness} > 0$, $p > p_c$, $OS > 0.7$
- **Time scales:** $\tau_{plateau}$, $\tau_{recovery}$, $\tau_{min}$

This allows building predictive models for specific clinical and behavioral scenarios.

### 5.3. Comprehensive Verification Protocol

The following study design is proposed to verify the entire model:

- **Participant groups:** 4 groups — (A) creative without addictions, (B) creative with addiction, (C) non-creative with addiction, (D) control. $N = 100$ (~25 per group).
- **Pre-intervention measurements:** EEG (coherence, spectrum), meta-d', IAT, vanity/burnout scales.
- **Intervention:** 8-week MBSR training.
- **Post-intervention and 6-month follow-up:** repeat all measures.
- **Analysis:** testing predictions 1–9 using mixed models and percolation analysis.

---

## 6. Practical Implications

### 6.1. Clinical Practice

- **Diagnostics:** $OS$ can serve as a biomarker of readiness for therapy. At $OS < 0.4$, external orchestrators (quarantine, pharmacology) are indicated; at $OS > 0.4$, psychotherapy is effective.
- **Prognosis:** $\gamma_{awareness}$ (estimated via adherence to MBSR) predicts the recovery rate of $\varphi(refl)$.
- **Monitoring:** percolation analysis of semantic associations (IAT + fMRI) allows tracking detachment from the “toxic anchor”.

### 6.2. Pedagogy and Work with Gifted Individuals

- **Ontological courage** as an educational goal for creative individuals: developing the skill of accepting one’s own complexity without surrogates.
- **Mindfulness training** as a mandatory component of burnout prevention in creative professions.

### 6.3. AI System Development (Connection to Shadow Ethics)

- The $\gamma_{awareness}$ model can be implemented as a metacognitive regulator in AI agents: when interfaces are overloaded, the system automatically switches to `pure_awareness` mode.
- The percolation model predicts the emergence of “toxic anchors” in training data and allows designing protective mechanisms (semantic disinfection).

---

## 7. Simulation Scripts

### 7.1. Simulation of $\varphi(refl)$ Recovery (Extension I)

```python
import numpy as np
import matplotlib.pyplot as plt

# A priori calibration
GAMMA_MAX = 0.18
TAU_PLATEAU = 80.0
ALPHA = 0.05
BETA = 0.02
PHI_MAX = 0.85
NOISE_BASELINE = 0.15

def simulate_recovery(days=100, practice_hours_per_day=0.0):
    phi = np.zeros(days)
    gamma = np.zeros(days)
    tau_mbsr = 0.0
    phi[0] = 0.25  # collapse after stress (Theorem 9)

    for t in range(1, days):
        tau_mbsr += practice_hours_per_day
        gamma[t] = GAMMA_MAX * (1 - np.exp(-tau_mbsr / TAU_PLATEAU))
        noise_effective = NOISE_BASELINE * (1 - gamma[t])
        delta_phi = ALPHA * gamma[t] * (PHI_MAX - phi[t-1]) - BETA * noise_effective
        phi[t] = np.clip(phi[t-1] + delta_phi, 0.0, PHI_MAX)

    return phi, gamma

days = 120
scenarios = {
    "No practice": {"hours": 0.0, "color": "red"},
    "Sporadic (0.2 h/day)": {"hours": 0.2, "color": "orange"},
    "MBSR (1.5 h/day)": {"hours": 1.5, "color": "green"}
}

plt.figure(figsize=(12, 6))
for name, params in scenarios.items():
    phi, gamma = simulate_recovery(days=days, practice_hours_per_day=params["hours"])
    plt.plot(phi, label=name, color=params["color"], linewidth=2)

plt.axhline(y=0.40, color='black', linestyle='--', label=r'$\varphi_{crit}$')
plt.axhline(y=0.85, color='gray', linestyle=':', label=r'$\varphi_{max}$')
plt.title(r"Recovery of $\varphi(refl)$ under different practice regimes")
plt.xlabel("Time (days)")
plt.ylabel(r"$\varphi(refl)$")
plt.legend()
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("gamma_awareness_simulation.png", dpi=300)
plt.show()
```

### 7.2. Percolation Model of the “Toxic Anchor” (Extension II)

```python
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

def simulate_toxic_anchor(G, alcohol_node, steps=50, lr=0.1, intervention_start=0):
    chi = {node: np.random.uniform(-0.5, 0.5) for node in G.nodes()}
    chi[alcohol_node] = -0.8
    history = []

    for t in range(steps):
        new_chi = chi.copy()
        reward = 0.5 if t < intervention_start else -0.2
        for node in G.nodes():
            if node == alcohol_node:
                new_chi[node] = np.clip(chi[node] + lr * 0.5, -1, 1)
                continue
            neighbors = list(G.neighbors(node))
            if alcohol_node in neighbors:
                new_chi[node] = np.clip(chi[node] + lr * reward * 1.5, -1, 1)
            elif any(n in neighbors for n in G.neighbors(alcohol_node)):
                new_chi[node] = np.clip(chi[node] + lr * reward * 0.5, -1, 1)
        chi = new_chi

        positive_nodes = [n for n, c in chi.items() if c > 0]
        subgraph = G.subgraph(positive_nodes)
        if len(positive_nodes) > 0:
            largest_cc = max(nx.connected_components(subgraph), key=len)
            fraction = len(largest_cc) / G.number_of_nodes()
        else:
            fraction = 0.0
        history.append(fraction)

    return history, chi

N = 500
G_er = nx.erdos_renyi_graph(N, p=0.02)
G_ba = nx.barabasi_albert_graph(N, m=3)
steps_form, steps_therapy = 30, 20
total = steps_form + steps_therapy

hist_er, _ = simulate_toxic_anchor(G_er, 0, steps=total, intervention_start=steps_form)
hist_ba, _ = simulate_toxic_anchor(G_ba, 0, steps=total, intervention_start=steps_form)

plt.figure(figsize=(10, 6))
plt.plot(range(total), hist_er, label="Erdős–Rényi", color="blue", linestyle="--")
plt.plot(range(total), hist_ba, label="Barabási–Albert (genius)", color="purple", linewidth=2)
plt.axvline(x=steps_form, color='red', linestyle='-', label="Therapy start")
plt.axhline(y=0.31, color='black', linestyle=':', label=r"$p_c \approx 0.31$")
plt.title("Percolation transition of the 'Toxic Anchor'")
plt.xlabel("Time step")
plt.ylabel("Fraction of giant positive component")
plt.legend()
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("percolation_toxic_anchor.png", dpi=300)
plt.show()
```

### 7.3. EEG Study Protocol (Extension III)

**Design:** cross-sectional study with three groups.

| Group | Inclusion criteria | Target size |
|-------|-------------------|-------------|
| “Accepted” | Torrance test > 90th percentile, no addictions, high AAQ-II scores | N=33 |
| “Suppressing” | Torrance test > 90th percentile, subclinical signs of addiction or burnout (MBI-GS > 27) | N=33 |
| “Control” | Average creative potential, no psychopathology | N=34 |

**Paradigm:** 5 min rest (eyes closed) + 5 min rest (eyes open) + metacognitive task (adaptation of Pereira).

**Metrics:**
- $Coh_{\theta}(Fp1/Fp2, F7/F8)$ — theta coherence (4–8 Hz)
- $Power_{\alpha}(Pz)$ — alpha power at Pz (DMN proxy)
- $\varphi(refl)$ — meta-d' in the task

**Power calculation:** at $f = 0.35$ (medium/large effect), $\alpha = 0.05$, power = 0.80, 3 groups: $n \approx 28$ per group. With 15% dropout: $N = 100$.

**Falsification criteria (pre-registration):**
1. ANOVA shows no significant differences in $OS$ index between groups ($p > 0.05$)
2. Post-hoc tests (Tukey HSD) do not confirm “Accepted” > “Suppressing” and “Control”
3. Correlation between $OS$ and stability measures is not significant ($p > 0.05$)

---

## 8. Summary Table of Testable Predictions

| No. | Prediction | Extension | Relation to theory | Method |
|---|---|---|---|---|
| 1 | $\varphi(refl)$ recovers exponentially | I | Postulate P1 | Longitudinal EEG |
| 2 | $\gamma_{awareness}$ saturates at ~200 h | I | A27 | Cross-sectional |
| 3 | Recovery at $intent=0$ faster | I | Theorem 9 | RCT |
| 4 | Bimodal reaction time distribution in addicts | II | A26, Theorem 7 | Behavioral |
| 5 | Enhanced striatum–mPFC connectivity in addicts | II | Percolation | fMRI |
| 6 | Relapse provoked by stress | II | A28 | Longitudinal |
| 7 | $Coh_{\theta}$ higher in creative without addictions | III | Theorem 1′, 9 | EEG |
| 8 | $OS$ predicts stability | III | Theorem 9 | Predictive |
| 9 | MBSR increases $Coh_{\theta}$ after 8 weeks | III | $\gamma_{awareness}$ | RCT |

---

## 9. Empirical Justification: Verification of Hypotheses from Adjacent Sources

All seven verified hypotheses from the architectural model of consciousness found confirmation in independent studies:

| No. | Hypothesis | Status | Key source |
|---|---|---|---|
| 1 | Low prevalence of self-reflection (10–15%) | ✅ | Eurich, 2018 |
| 2 | Link between creativity and addictions | ✅ | Li et al. (2024), DOI: 10.1177/00332941221137239 |
| 3 | Genetic link between creativity and mental disorders | ✅ | Li et al. (2020), DOI: 10.1093/schbul/sbaa025 |
| 4 | Stress → cortisol → reduced creativity | ✅ | Guo et al. (2024), DOI: 10.1016/j.tsc.2024.101521 |
| 5 | Inverted U-shaped link between narcissism and creativity | ✅ | Ji et al. (2023), DOI: 10.3389/fpsyg.2022.1091770 |
| 6 | DMN-ECN switching as basis for creativity | ✅ | Chen et al. (2025), DOI: 10.1038/s42003-025-07470-9 |
| 7 | Reduced theta activity in alcohol dependence | ✅ | Harper et al. (2018), DOI: 10.1016/j.biopsycho.2018.10.002 |

---

## 10. Conclusion

The three mathematical extensions presented:

1. **Complete the formalization** of key heuristic hypotheses of cognitive shadow theory.
2. **Generate testable predictions** open to empirical falsification.
3. **Integrate into a unified model** linking micro- (neurophysiology), meso- (behavior), and macro- (sociocultural patterns) levels.
4. **Offer practical tools** for clinical, pedagogical, and engineering practice.

---

## 11. Navigation and Citation

### Navigation Across Documents

| Document | Description |
|----------|-------------|
| `cognitive_shadow_core.md` | Formal core (A1–A8*, Theorem 1′) |
| `cognitive_shadow_dynamics.md` | Dynamics (A9–A29, Theorems 2–9) |
| `Formal_Theory_of_Observable_Boundaries_of_Consciousness.md` | Methodology (Theorem 10) |
| `Article.md` | Empirics (265,956 epochs, GroupKFold) |
| `Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md` | Ethics (6 principles) |
| `MATURE_STATUS.md` | Maturity Manifesto |
| **This document** | Integral model (3 extensions) |
| `extensions/artificial_existence.md` | Perspective article (CST for AGI) |

### Citation

```bibtex
@techreport{kalinin2026integral-model,
  title   = {Cognitive Shadow Theory: Integral Model of Consciousness, Pathology,
             and Mindfulness Practices (version 3.0)},
  author  = {Kalinin, Valery Sergeevich},
  year    = {2026},
  month   = {September},
  institution = {System Engineering Research},
  url     = {https://github.com/Kalera77/cognitive-shadow-theory},
  note    = {Preprint, updated September 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```

### License

Text — CC BY-NC 4.0 · Code (simulation scripts) — MIT

---

*End of document.*
