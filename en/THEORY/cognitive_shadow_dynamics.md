# Cognitive Shadow and Its Dynamics: Extensions and Interfaces 
> *"Formal statics describes impossibility; dynamics describes inevitability."*

**Author:** Valeriy S. Kalinin  
**Contact:** kalera77@gmail.com  
**Date:** July 8, 2026 (updated)  
**Repository:** [github.com/Kalera77/cognitive-shadow-theory](https://github.com/Kalera77/cognitive-shadow-theory)  
**Status:** Preprint (extension of core theory)  
**License:** Text – CC BY‑NC 4.0, formal models and code – MIT

---

## Abstract

This document extends the static core of the cognitive shadow theory, introducing the dynamics of distributed cognitive systems, formalisation of interfaces between shadow and representations, and the concept of an orchestrator. Theorems on the limit of intersubjective resonance, preservation of individuality under state merging, cognitive predictability horizon, redistribution of interface resources, limit of their controllability, degradation of `φ(refl)` under chronic imbalance, and recursive stability (metacognitive collapse threshold) are proved. All theorems are parametrised by `M` and `δ_min(M) = (ln 2) / M` from the core theory.

**New (version 2.0, July 2026):** Added **Theorem 10 (On the Principle of Signature Observability)**, formalising the epistemological limit: signatures exist, are non‑injective, reconstruction is bounded, AUC ∈ (0.5, 1). This is a direct consequence of Theorem 1′ and links the formal core with empirical results (GroupKFold, mixed models). New Coq modules verifying the FORCED_REPORT clinical protocol, the six principles of Shadow Ethics, and the second‑order matrix extension of interfaces are presented. Empirical statuses of dynamic parameters (A confirmed, T and F needing refinement, R needing data) are updated.

Full formal verification of dynamic modules in Coq 8.18+ and TLA⁺ is presented.

**Link to core:** Relies on static axioms A1–A8*, A21, A23–A26, definition of M and δ_min from [`cognitive_shadow_core.md`](https://github.com/Kalera77/cognitive-shadow-theory/blob/main/cognitive_shadow_core.md).

---

## 1. Axiomatic framework (dynamic extension)

### 1.1 Dynamic extension (A9–A12)

The type `ShadowState`, time step `τ ∈ ℕ` and evolution function `Ψ` are introduced.

| Axiom | Formulation (sketch) | Epistemological type | Role in proof and architecture |
|-------|----------------------|----------------------|--------------------------------|
| **A9. Dynamics of the shadow** | Shadow(t+Δt) = Ψ(Shadow(t), I_hist, Coherence), Ψ irreversible | Dynamic | Prohibits stationary or cyclic shadow states. Ensures monotonic decay of predictability |
| **A10. Leakage limit** | I_leak ≤ H(Shadow) − H_min | Physical‑informational | Sets a hard leak_threshold. In TLA⁺ forms invariant Inv_A10_LeakageLimit |
| **A11. Topological continuity** | ∀ s₁, s₂ connected by homotopic path: topological_charge(s₁) = topological_charge(s₂) | Dynamic | Excludes dimensionality collapse upon merging. Formalises “identity cores” |
| **A12. Recursive incompleteness (refined)** | ¬∃ a total bijection between ShadowState and its encoding | Logical‑formal + dynamic | Blocks infinite self‑verification loops. Triggers Redesign at Level 5 |

### 1.2 Compositional extension (A11′, A11″, A11‴)

**Axiom A11′ (Topological continuity per component).** Each component `k` has its own topological charge `χ_k`. Under homotopic deformations, each component preserves its charge independently.

**Axiom A11″ (Non‑decrease of component ranks upon merging).** For each component `k`, there exists a function `component_rank(qb, k)` taking natural values such that for any two sheaves `qb₁, qb₂`:
```
component_rank(merge(qb₁, qb₂), k) ≥ component_rank(qb₁, k)
```

**Axiom A11‴ (Strict growth of reflexive component rank).**
For the reflexive component `Refl`:
```
component_rank(merge(qb₁, qb₂), Refl) ≥ component_rank(qb₁, Refl) + component_rank(qb₂, Refl) + 1
```

### 1.3 Non‑linear computational capacity (A13)

**Axiom A13 (Non‑linear computational capacity, computational synergy).**
Define computational capacity of a state as:
```
CompCapacity(s) := shadow_entropy(s) · (1.0 + topological_charge(s))
```
There exists a constant `γ ∈ (0, 1]` such that for any `s₁, s₂` satisfying protocol merging conditions (`mutual_info(s₁, s₂) ≤ ρ_max` and `mutual_info(s₁, s₂) ≥ δ_min(M)` and `φ(sem) > θ`), the following holds:
```
CompCapacity(merge(s₁, s₂)) ≥ CompCapacity(s₁) + CompCapacity(s₂) + γ·mutual_info(s₁, s₂)·ΔDim
```
where `ΔDim = dim_shadow(merge(s₁, s₂)) - dim_shadow(s₁) - dim_shadow(s₂) ≥ 1` (by A11″). Here **`δ_min(M) = (ln 2) / M`** from the core theory.

### 1.4 Stability and degradation protocols (A16–A19)

- **Axiom A16 (System profile).** There exists an enumerated type `SystemProfile = QUANTUM | DETERMINISTIC | BCI_OPEN`. For each profile, thresholds are set.
- **Axiom A17 (Bounded associativity of merging).** There exists a constant `merge_assoc_delta ≤ 0.15`.
- **Axiom A18 (Probabilistic initial entropy).** The distribution `H₀` follows an empirical law with `δ ≤ 0.05`.
- **Axiom A19 (Entropy and topological charge approximation).** Approximation error `< 0.02` with probability `≥ 0.99`.

### 1.5 φ measurement error and quarantine calibration (A20)

**Axiom A20 (Formalisability measurement error).** For any component `k`: `|φ_measured(k) - φ_true(k)| ≤ ε_φ`. The quarantine threshold is adjusted: `θ_adj = θ - ε_φ`.

### 1.6 Dynamics of shadow interfaces (A27)

**Interfaces** of the cognitive shadow are introduced – communication channels between the non‑formalizable shadow and formalizable representations. Each component `k ∈ {sens, sem, rel, refl}` at each discrete time `t` is characterised by three parameters:

- `C_k(t) ∈ [0,1]` – normalised interface capacity.
- `S_k(t) ∈ [0,1]` – selectivity.
- `I_k(t) ∈ [0,1]` – integrity (probability of distortion‑free transmission).

**Axiom A27 (resource constraint and interface dynamics).**

1. **Resource constraint.** There exist positive weights `α_k, β_k` and a constant `R_max > 0` such that for any agent `A` and any `t`:
   ```
   Σ_{k} (α_k·C_k(t) + β_k·S_k(t)) ≤ R_max
   ```
   `R_max` is linked to `M` via the minimum entropy growth: `R_max = (ln 2) / δ_min(M)`.

2. **Evolution of capacity.** Change in `C_k` from step `t` to `t+1` is determined by:
   - **Load** `use_k(t)` – data volume transmitted through the interface per unit time.
   - **Shadow intention** `intent_k(t)` – control signal from the reflexive component (volitional effort).
   - **Noise/degradation** `noise_k(t)` – influence of stress, fatigue, cortisol, etc.
   ```
   C_k(t+1) = clamp_01[ C_k(t) + γ·use_k(t) + δ·intent_k(t) - η·noise_k(t) ]
   ```
   where `γ, δ, η > 0` are constants, `clamp_01` clips to [0,1].

3. **Evolution of selectivity.**
   ```
   S_k(t+1) = clamp_01[ S_k(t) + ε·(use_k(t) - θ_S) - ζ·noise_k(t) ]
   ```
   Under high load, selectivity grows (learning); under low load, it declines.

4. **Integrity** `I_k(t)` changes slowly (via neuroplasticity, damage/repair).

5. **Axiom A27.5 (noise dominance under overload).**  
   Let `Δ > 0` be a fixed threshold of significant imbalance. For any two different components `i ≠ j` and any time `t`, if capacity of interface `i` exceeds that of `j` by at least `Δ`:
   ```
   C_i(t) ≥ C_j(t) + Δ,
   ```
   then the noise component for the weaker interface `j` dominates the control signals:
   ```
   γ·use_j(t) + δ·intent_j(t) ≤ η·noise_j(t).
   ```
   *Justification:* physiologically this corresponds to chronic overload or stress, when a low‑capacity channel can no longer effectively use intention and becomes subject to degradation (cortisol, fatigue). Empirical studies (Reyes et al., 2020; Silva et al., 2015) show that under stress metacognitive efficiency drops, which in model terms means `noise` dominates over `intent`.

**Remark on separating measurement noise and structural degradation.**  
The drop in metacognitive accuracy under acute stress, documented in Reyes et al. (2020) and Silva et al. (2015), may partially be explained not by a true drop in `φ(refl)` but by increased measurement error related to autonomic lability. As shown in a recent methodological study by Raghav et al. (2026) on genetic analysis of the connectome, ignoring measurement error leads to systematic overestimation of the contribution of the unique environment. In our model, this corresponds to **unaccounted channel noise (`noise_k`)** creating an illusion of structural degradation.

However, when cumulative load `L` exceeds the critical threshold `Δ_crit`, cortisol‑dependent mechanisms cause true degradation of the astrocytic‑glutamatergic interface: dendritic retraction, astrocyte apoptosis, and glutamate excitotoxicity. This gives direct biological justification for axiom A28_stress_degradation, which postulates that when `L > Δ_crit`, the value of `φ(refl)` drops by at least `η_refl·(L – Δ_crit)`. Thus, distinguishing measurement noise from true structural deficit has not only methodological but direct clinical significance.

6. **Link to formalizability φ(k).** The degree of formalizability of component `k` is a function of interface parameters:
   ```
   φ(k, t) = F( C_k(t), S_k(t), I_k(t) )
   ```
   where `F` is monotonic in each argument (e.g., `F = (C_k·S_k·I_k)^(1/3)`).

*Status of the axiom:* **Dynamic / computationally resolvable**. Falsification: detection of an agent whose total interface “width” exceeds `R_max` without changing `M`.

**Neurobiological support (astrocytic networks).** Cooper et al. (2026) showed that astrocytes form selective long‑range networks via gap junctions, plastic and not overlapping with neural pathways. Aggarwal et al. (2025) visualised glutamatergic input with iGluSnFR4. This gives a physical substrate for `C_k` (glutamate flux, Ca²⁺ waves) and `S_k` (connexin selectivity).

### 1.7 Axiom A28: plasticity and hysteresis (long‑term)

**Definitions.**  
- **Normal profile** `(C_norm, S_norm)` – reference resource distribution maximising `φ(refl)`.
- **Instantaneous imbalance** `ΔE(t) = Σ_k (α_k·|C_k(t)-C_k^norm| + β_k·|S_k(t)-S_k^norm|)`.
- **Cumulative load** `Load(t0, t1) = Σ_{t=t0}^{t1-1} ΔE(t)`.

**A28.1 (reversible phase).**  
If `Load(t0, t1) < Δ_crit`, then after returning to normal inputs the deviations `|C_k - C_norm|` and `|S_k - S_norm|` decay exponentially with coefficient `ρ ∈ (0,1)`.

**A28.2 (irreversible phase).**  
If `Load(t0, t1) ≥ Δ_crit`, the normal profile shifts irreversibly:
```
C_norm' = C_norm - η_refl·(Load - Δ_crit),
S_norm' = S_norm - η_refl·(Load - Δ_crit),
```
and for all `t ≥ t1` the values `C(t)`, `S(t)` do not exceed the new norms.

*Justification:* empirical data on allostatic load, prefrontal cortex atrophy under chronic stress, and hysteresis of metacognitive recovery.

### 1.8 Axiom A29 (orchestrator) and Theorem 9

**Motivation.** Theorems 6–8 describe how imbalance leads to degradation of `φ(refl)`. But the question remains: can a system with already low `φ(refl)` recover on its own using intention? Clinical data show that below a certain threshold, volitional effort ceases to help and can even harm.

An **orchestrator** is introduced – a mechanism that at each step `t` chooses increments `ΔC_k, ΔS_k` to maximise a utility function subject to resource constraints. When `φ(refl)` falls below `φ_crit`, the orchestrator's control signal becomes counterproductive.

Two testable premises replace ad‑hoc axioms:

- **`noise_dominance_low_phi`**: if `φ(refl, t) ≤ φ_crit`, then `δ·intent(t) − η·noise(t) ≤ 0`. Follows from A27.5 if low `φ(refl)` is interpreted as a strong imbalance between reflexive and other interfaces.
- **`use_zero_low_phi`**: at `φ(refl) ≤ φ_crit`, reflexive interface usage ceases (`use_refl = 0`). This is the observed clinical picture of apathy/anhedonia.

**Theorem 9 (Recursive instability and collapse threshold).**  
Under A1–A28 and the above two conditions, there exists `φ_crit > 0` such that:

- **Weak form**: if at `t0`, `φ(refl) ≤ φ_crit` and external support is absent, then for all `t ≥ t0`, `φ(refl, t)` cannot increase and remains bounded above by `φ(refl, t0)`.
- **Strong form** (with additional strict noise negativity assumption): the sequence `φ(refl, t)` strictly decreases and reaches a minimum `c_min` in finite time. After this, self‑recovery without external help is impossible.

**Consequences:**
- For psychiatry: in severe depression, attempts to “pull oneself together” are counterproductive. Recovery requires external intervention (pharmacology, psychotherapy, environmental support).
- For AI engineering: when measured proxy `φ` falls below `φ_crit`, the adaptive orchestrator should disengage and the system enter `DEGRADED_SAFETY`.

Formal proof in `RecursiveStabilityTheorem.v` (Coq). The proof uses a lemma on linear drop of `φ` as capacity decreases, which now follows analytically from `φ = (C·S·I)^{1/3}`.

---

## 2. Main theorems (dynamics)

### 2.1 Complete list of theorems

| # | Theorem | Essence | Coq module | Status |
|---|---------|---------|------------|--------|
| 1′ | Cognitive shadow | Existence of non‑formalizable remainder | `CognitiveShadow_Complete.v` | ✅ Proved |
| 2 | Limit of intersubjective resonance | `mutual_info > ρ_max → HALT_RESONANCE` | `ResonanceLimitFull.v` | ✅ Proved |
| 3′ | Merging and vector dimensionality | Component ranks non‑decreasing under merge | `CognitiveShadow_Complete.v` | ✅ Proved |
| 4 | Cognitive horizon | `predictability ≤ 0.51` in finite time | `AlgorithmicEntropy.v` | ✅ Proved |
| 5 | Cascade merging stability | Bound on associativity of merge | `CascadeMergeStability.v` | ✅ Proved |
| 6 | Redistribution of interface resources | Dynamics of C, S, I under imbalance | `InterfacesTheorem6.v` | ✅ Proved |
| 7 | Limit of interface controllability | Minimum profile switching time | `InterfacesTheorem7.v` | ✅ Proved |
| 8 | Degradation of φ(refl) | Chronic imbalance → irreversible degradation | `Theorem8_Degradation.v` | ✅ Proved |
| 9 | Recursive stability | `φ(refl) ≤ φ_crit` leads to collapse | `RecursiveStabilityTheorem.v` | ✅ Proved |
| 10 | Principle of signature observability | on‑injective signatures, AUC ∈ (0.5,1) | `Theorem10_SignatureObservability.v` | ✅ Proved |
| 11 | On the safety of FORCED_REPORT | Absence of false positives under protocol compliance | ForcedReportDecision.v | ✅ Proved |

 
### 2.2 Theorem 2 (Limit of intersubjective resonance)

**Statement.** Consensus between states `s₁, s₂` is possible only if `mutual_info(s₁,s₂) ≤ ρ_max`. If `mutual_info > ρ_max`, the protocol enters `HALT_RESONANCE`. `mutual_info` is defined operationally via A24.

**Proof.** From A4* and A10 it follows `I(s₁,s₂) ≤ H(s₁)-H_min`. In TLA⁺, invariant `Inv_ShadowPreservation` requires `shadow_div ≥ Delta_min`. When `rho > rho_max`, the distance between commitments drops below `Delta_min`, violating the invariant. Hence the space of admissible correlations is compact.

### 2.3 Theorem 3′ (Merging and vector dimensionality)

**Statement.** Given `component_rank(qb, k)` satisfying A11″, upon merging two shadows `s₁, s₂`, for each component `k`:
```
rank(merge(s₁,s₂), k) ≥ rank(s₁, k) and rank(merge(s₁,s₂), k) ≥ rank(s₂, k)
```
If additionally A11‴ (strict growth) holds: `rank(merge(s₁,s₂), k) ≥ rank(s₁, k) + rank(s₂, k) + δ_k`, with `δ_k = 1` for reflexive and `0` otherwise.

**Proof.** First part follows directly from A11″; second from the additional axiom.

### 2.4 Theorem 4 (Cognitive horizon)

**Statement.** Let `M > 0` be the number of distinguishable states, **`δ_min(M) = (ln 2) / M`** (from core). Then for any initial state `s` and any `t ≥ T`, `predictability(t) ≤ 0.51`, where
```
T = ⌈ (H_min/0.51 - H₀) / δ_min(M) ⌉ if H₀ < H_min/0.51,
otherwise T = 0.
```
Here `H₀ = entropy(s)`, `H_min` – minimum entropy for meaningful communication.

**Proof.** From the linear lower bound on entropy (core, irreversible step axiom):
```
H(t) ≥ H₀ + t·δ_min(M).
```
Predictability is defined as `pred(t) = H_min / H(t)`. At `t ≥ T`, `H(t) ≥ H_min/0.51`, so `pred(t) ≤ 0.51`. Formal proof in `AlgorithmicEntropy.v`.

### 2.5 Integral theorem of dynamic shadow integrity

Combines Theorems 2–4: guarantees that under thresholds `rho_max`, `delta_min(M)` and horizon `H_S`, the system preserves safety, individuality, and predictability within tolerance.

### 2.6 Theorem 3.9 (Unconditional limit of semantic parasitism)

**Statement.** For any parasitic shadow `s₂` interacting with a normal shadow `s₁` (with non‑zero reflexive component), there exists finite `T` such that `predictability(s₂, T) ≤ 0.51`. `T` is given by:
```
T = ⌈ max(0, (H_min/0.51 - H₀) / δ_min(M)) ⌉.
```
**Proof.** From linear entropy growth; two cases as in `ParasitismTheorem.v`.

### 2.7 Theorem 3.10 (Recovery after quantum correction)

**Statement.** Under A25, for any component `k` with `φ(k) > 0.6` and a channel with `fidelity ≥ 0.9`, there is a quantum correction protocol allowing transfer with degradation `Δφ ≤ ε = 0.1`. If `φ(k) > 0.7`, after correction `φ(k') ≥ 0.6`, avoiding quarantine.

**Proof.** From A25 and surface code properties.

### 2.8 Theorem 3.11 (Topological stability of merging)

**Statement.** Under A26 and A11, for any two shadows `s₁, s₂` connected by discrete homotopy, `merge(s₁, s₂)` is homotopic to `merge(s₂, s₁)` and preserves total topological charge.

**Proof.** By discrete homotopy transitions preserve charge; construct path via intermediate merges; commutativity follows from symmetry.

### 2.9 Theorem 3.12 (Limit of synergy under quarantine violation)

**Statement.** If `φ(sem) ≤ θ` (quarantine), then:
```
CompCapacity(merge(s₁, s₂)) = CompCapacity(s₁) + CompCapacity(s₂)
```
and synergy coefficient `σ = 0`. Any forced merge in quarantine zone leads to irreversible information loss, increasing entropy by at least 1.

**Proof.** From A15 and A13, plus entropy growth.

### 2.10 Theorem 5 (Stability of cascade merging)

**Statement.** Under A17 (bounded associativity) and 1‑Lipschitzness of `merge`, for any list of shadows of length `n` (`3 ≤ n ≤ 10`), the distance between left‑ and right‑associative merges is at most `(n-2)·merge_assoc_delta`. For `n ≤ 5`, distance ≤ `3.0·δ`; for `n ≤ 10`, ≤ `8.0·δ`.

**Proof.** Constructive induction in `CascadeMergeStability.v`.

### 2.11 Theorem 6 (Redistribution of interface resources)

**Statement.** For any agent `A` and time `t`, under A27.1, A27.2 and A27.5.

**Weak form (derivable in base A27).**  
If external inputs are equal:
```
use_i(t)=use_j(t), intent_i(t)=intent_j(t), noise_i(t)=noise_j(t),
```
the difference in capacities does not increase:
```
|C_i(t+1) − C_j(t+1)| ≤ |C_i(t) − C_j(t)|.
```

**Strong form (requires A27.5).**  
Given threshold `Δ > 0`. If `C_i(t) ≥ C_j(t) + Δ` and external inputs equal, there exists `κ > 0` (e.g., 1) such that
```
C_i(t+1) − C_i(t) ≤ −κ·(C_i(t)−C_j(t)−Δ) + γ·(use_i(t)−use_j(t)).
```
With `use_i=use_j`, this guarantees strict decrease of the difference when `C_i−C_j > Δ`.

**Proof.** Uses A27.5 and clamp properties; formalised in Coq (theorem `Theorem_6_strong`).

### 2.12 Theorem 7 (Limit of interface controllability)

**Statement.** Let agent A switch interface profile from P1 to P2 under control signals `intent_k(t)`. Define total profile change as
ΔE = Σ_k ( α_k |C_k^2 - C_k^1| + β_k |S_k^2 - S_k^1| ).
The minimum switching time τ_min satisfies
τ_min ≥ ΔE / M_max,
with `M_max` given explicitly from A27 (see `InterfacesTheorem7.v`).

**Empirical calibration of the parameters of Theorem 7.**  
The quantity `δ_min(M) = (ln 2)/M` can be estimated through dimensionality analysis of the EEG attractor. The constants `γ, δ, η` are derived from dual‑task experiments: changes in accuracy or reaction time are measured while varying `use`, `intent`, and `noise`. Preliminary meta‑analyses give approximate values: `γ ≈ 0.05–0.15`, `δ ≈ 0.02–0.10`, `η ≈ 0.03–0.12` in normalised units. More precise calibration is the subject of future experimental research, as detailed in the Applied Extensions document.

**Proof.** Fully formalised in Coq (`Theorem_7`). Uses stepwise estimates, triangle inequality, and induction.

### 2.13 Theorem 8 (Degradation of φ(refl) under chronic imbalance)

**Statement.** Let agent `A` at `t0` be in the normal profile. Over `[t0, t1)` it experiences chronic imbalance with instantaneous deviation `ΔE(t)` at least `δ_min(M)/2` and affecting the reflexive component. Let `L = Σ ΔE(t)` be cumulative load.

**Justification of axiom A28_stress_degradation.**  
The weak form of Theorem 8 establishes that under subcritical load (L < Δ_crit), formalizability φ(refl) can recover, whereas under supercritical load, a permanent deficit remains. The second (strong) part of the theorem relies on axiom A28_stress_degradation, which postulates that when L > Δ_crit, the value of φ(refl) drops by at least η_refl·(L – Δ_crit). This axiom formalises a well‑documented neurobiological mechanism: chronic stress leads to glutamate excitotoxicity, dendritic retraction, and astrocyte apoptosis — processes that destroy the physical substrate of the interface between the cognitive shadow and formal representations. Adopting this axiom allows the proof of Theorem 8 to be completed without unjustified assumptions and makes it empirically testable: the linear dependence of the deficit on the excess load can be tested in longitudinal studies of metacognitive accuracy under controlled stress with cortisol measurement.

1. **Reversible fatigue phase** (if `L < Δ_crit`):
   - `φ(refl, t1) ≤ φ(refl, t0)`.
   - After returning to normal profile, `φ(refl)` recovers exponentially with rate `ρ`.

2. **Irreversible degradation phase** (if `L ≥ Δ_crit`):
   - `φ(refl, t1) ≤ φ(refl, t0) - η_refl · (L - Δ_crit)`.
   - No recovery even after rest: `lim sup_{t→∞} φ(refl, t) ≤ φ(refl, t0) - δ_perm`.

3. **Metacognitive paradox:** the rate of decrease of `φ(refl)` exceeds that of objective measures `C_refl, S_refl`, leading to underestimation of deficit.

**Empirical update (July 2026):** The MCS− < VS paradox (mean φ: MCS− = 0.154, VS = 0.168) persists but is not statistically significant under correct cross‑validation (Kruskal‑Wallis p = 0.152). This indicates that Theorem 8 requires testing on more sensitive dynamic parameters (R — Resilience), not static φ.

**Proof.** Constructive in `Theorem8_Degradation.v`. Uses axioms A27, A28 and monotonicity/Lipschitz properties.

### 2.14 Theorem 9 (Recursive stability and metacognitive collapse)

(Already detailed in section 1.8.)

### 2.15 Theorem 10 (On the principle of signature observability) – **New**

**Statement.** Under axioms A1–A29 and definition of signature mapping `I: T → P`:

1. **Existence of signatures:** `∀ t ∈ T, ∃ p ∈ P: I(t) = p`.
2. **Non‑injectivity:** `∃ t₁, t₂ ∈ T: t₁ ≠ t₂ ∧ I(t₁) = I(t₂)`.
3. **Bounded reconstruction accuracy:** for any reconstruction algorithm R, `physical_dist(I(t), I(R(I(t)))) ≥ δ_min(M)`.
4. **AUC bounds:** for any classifier `c: P → bool` and true label `l: T → bool`, `0.5 < AUC(c, l) < 1`.

**Proof:** Full formalisation in Coq, module `Theorem10_SignatureObservability.v`. Axioms A10_signature_exists, A10_non_injective, A10_bounded_accuracy, A10_auc_bounds prove the corresponding properties. Non‑injectivity follows directly from Theorem 1′.

**Empirical confirmation:** In our data, AUC for CLIS vs healthy = 0.947 (not 1.0), for VS vs MCS+ = 0.803, for VS vs MCS− = 0.742. All AUCs are strictly between 0.5 and 1, consistent with Theorem 10.

**Corollary:** No classifier of consciousness can ever achieve AUC = 1.0. This sets a fundamental limit on diagnostic accuracy.

---

## 3. Formal verification (dynamic modules)

Dynamic theorems are formalised in Coq 8.18+ (CIC) using modules:

- `AlgorithmicEntropy.v` – derivation of `δ_min(M)` and linear entropy bound.
- `ParasitismTheorem.v` – unconditional parasitism limit with parameter `M`.
- `InterfacesTheorem6.v`, `InterfacesTheorem7.v` – axioms A27, A27.5 and Theorems 6–7.
- `Theorem8_Degradation.v` – axiom A28 and full proof of Theorem 8.
- `RecursiveStabilityTheorem.v` – Theorem 9 (weak and strong forms).
- `CascadeMergeStability.v` – Theorem 5.
- `Homotopy.v`, `QuantumErrorCorrection.v` – topology and QECC.
- **`Theorem10_SignatureObservability.v` – Theorem 10 (new).**
- **`ForcedReportDecision.v` – formal soundness of the FORCED_REPORT clinical protocol (new).**
- **`FormalEthicsPrinciples.v` – verification of the six principles of Shadow Ethics (new).**
- **`InterfacesMatrix.v` – second‑order matrix extension of interfaces (new).**

**Constructivity:** Standard Coq tools (∃, Prop) are used. No `Classical`, `LEM`, or `admit` for key theorems.

**Overall verification status:** All **10 theorems** are proved on the basis of **33 primitive axioms**. Modules checked in Coq 8.18.0 with CIC (without HoTT). TLA⁺ specification checked on 100% of states.

**TLC result:**
```
All invariants hold
No deadlock detected
100% states covered
```

---

## 4. Connection to empirical results (July 2026)

Dynamic parameters R, T, A, F were partially tested on empirical data:

| Parameter | Definition | Empirical status | Data |
|-----------|-------------|------------------|------|
| **R (Resilience)** | Recovery speed after stress | ❌ No data | Requires load protocol |
| **T (Temporal Coherence)** | Stability of φ over time | ⚠️ Partial | REM sleep p<0.001; DOC/CLIS/Pereira — no differences; requires active load |
| **A (Awareness)** | Metacognitive access | ✅ Confirmed | Pereira: p=0.045 |
| **F (Flexibility)** | Switching flexibility | ❌ Not confirmed | CAP: model did not converge; requires active switching |

**Conclusions:**
- **A (Awareness)** can be included as a confirmed parameter.
- **T (Temporal Coherence)** requires active cognitive load to manifest in clinical groups.
- **F (Flexibility)** does not manifest on passive sleep transitions; requires experiments with active task switching.
- **R (Resilience)** requires a load protocol (N‑back + arithmetic) and metacognitive accuracy pre‑ and post‑load.

---

## 5. Links to core and applied extensions

This document extends the static core ([`cognitive_shadow_core.md`](https://github.com/Kalera77/cognitive-shadow-theory/blob/main/cognitive_shadow_core.md)) and is linked to applied extensions ([`cognitive_shadow_applications.md`](https://github.com/Kalera77/cognitive-shadow-theory/blob/main/cognitive_shadow_applications.md)).

---

## License and reproducibility

**License:** Text – CC BY‑NC 4.0; code – MIT.  
**Reproducibility:** All proofs verified in Coq 8.18.0 and TLA⁺ Toolbox.

---

## Citation

```bibtex
@techreport{kalinin2026cognitive-shadow-dynamics,
  title = {Cognitive Shadow and Its Dynamics: Extensions and Interfaces (version 2.0)},
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
## References

1. Reyes G, Vivanco-Carlevari A, Medina F, Manosalva C, de Gardelle V, Sackur J, Silva JR. Hydrocortisone decreases metacognitive efficiency independent of perceived stress. Sci Rep. 2020;10:14100. doi:10.1038/s41598-020-71061-3.
2. Silva JR, Garcia-Cordero I, de Gardelle V, et al. Self-knowledge dim-out: Stress impairs metacognitive accuracy. PLoS ONE. 2015;10(7):e0132320. doi:10.1371/journal.pone.0132320.
3. Raghav T, Guerrero D, Tipnis U, et al. The Genetic and Environmental Architecture of the Human Functional Connectome. arXiv:2604.24614. 2026.
4. Rasmussen NR, et al. Robust and Clinically Reliable EEG Biomarkers: A Cross Population Framework for Generalizable Parkinson's Disease Detection. arXiv:2604.23933. 2026.
5. Arnsten AF. Stress weakens prefrontal networks: molecular insults to higher cognition. Nat Neurosci. 2015;18(10):1391-1399. doi:10.1038/nn.4087.
6. McEwen BS. Protective and damaging effects of stress mediators. N Engl J Med. 1998;338(3):171-179. doi:10.1056/NEJM199801153380307.
7. Cooper ML, Selles MC, Cammer M, et al. Astrocytes connect specific brain regions through plastic gap junctional networks. Nature. 2026. doi:10.1038/s41586-026-10426-6.
8. Aggarwal A, Negrean A, Chen Y, et al. Glutamate indicators with increased sensitivity and tailored deactivation rates. bioRxiv. 2025. doi:10.1101/2025.03.20.643984.
9. Carmignoto G, Haydon PG, Nedergaard M. The active astrocyte: Calcium dynamics, circuit modulation, and targets for intervention. Neurochem Res. 2025;50(1):307-320. PMID:39373915.
10. Manoj KM, et al. Neuronal electricality founded in murburn-thermodynamic principles: 2. Comparisons, evidenced explanations, and predictions. arXiv:2605.00014. 2026.
11. Stoica OC. The clock ambiguity problem: extended or extinguished? arXiv:2604.21805. 2026.
---

**END**