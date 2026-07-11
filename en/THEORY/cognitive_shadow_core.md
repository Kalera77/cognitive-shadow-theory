
# Cognitive Shadow: Formal Limits of Consciousness Digitization (Core)

> *"The incomprehensibility of qualia is not a mystical secret, but a direct physical consequence of the impossibility of measuring a non‑equilibrium chemical process without stopping it. We cannot copy a flame without extinguishing the candle."*

**Author:** Valeriy S. Kalinin  
**Contact:** kalera77@gmail.com  
**Date:** July 8, 2026 (updated)  
**Formalisation Repository:** [github.com/Kalera77/cognitive-shadow-theorem](https://github.com/Kalera77/cognitive-shadow-theorem)  
**Status:** Preprint (ready for peer review)  
**License:** Text – CC BY‑NC 4.0, formal models and code – MIT

---

## Abstract

This work formulates and rigorously proves the principle of a fundamental limit to the complete digitisation of consciousness. Any computational system claiming an exhaustive formal representation of a cognising agent inevitably leaves a non‑formalizable remainder – the cognitive shadow. The central operational assumption is that the cognitive shadow is realised as a complex, continuous, non‑equilibrium chemical process. Any attempt at its exhaustive measurement requires physical interaction that irreversibly changes the state of the system (Landauer’s principle, the second law of thermodynamics). Gödelian incompleteness and quantum stochasticity act as necessary but not sufficient conditions; physical immeasurability is the sufficient ground. The proof synthesises three heterogeneous barriers: Gödelian logical incompleteness, quantum stochastic uncertainty, and the intersubjective non‑transferability of subjective experience.

The core lays down axioms A1–A8, A4*, A8*, the compositional structure of qualia, and the finite‑resolution parameter of the state space `M`, from which the minimum entropy growth **`δ_min(M) = (ln 2) / M`** is derived. Theorem 1′ (on the partial cognitive shadow) and the Theorem on Quantum Irreducibility of Qualia are formulated and proved. Formal verification in Coq 8.18+ (CIC) is presented. Dynamic extensions and applied consequences are given in separate documents.

**Keywords:** digital immortality, cognitive shadow, Calculus of Inductive Constructions (CIC), formal verification, AI safety, ontological modesty, TLA⁺, Coq, quantum phenomenology, quarantine, quantum error correction, discrete homotopy, finite state resolvability.

---

## Preface: boundaries of competence and invitation to collaboration

This work does not pretend to give an exhaustive description of the neurobiological or quantum‑physical mechanisms of consciousness. The volume of data in these disciplines is so vast that any attempt at a complete review by a single researcher would inevitably be superficial.

The task of this work is different: to propose a formal framework and a set of heuristic hypotheses that can serve as a navigational map for further, deeper interdisciplinary research.

The author consciously limits his role to the development of the axiomatic core and architectural invariants, leaving the detailed elaboration of empirical consequences as an open invitation to specialists in the corresponding fields.

Within this text, only a part of the possible directions arising from the proposed axiomatics is touched upon. Further development of these ideas is a task for the collective efforts of the scientific community.

---

## 1. Introduction

The development of neural interfaces, quantum computing, and large cognitive models has actualised the discussion on the possibility of completely transferring consciousness to a computational environment. Historically, the limits of digitisation have been studied fragmentarily: the Lucas‑Penrose argument focused on non‑computability, the no‑cloning theorem on copying quantum states, and phenomenological approaches on the privacy of qualia.

This work does not claim to solve the “hard problem of consciousness” or to provide an ontological description of reality. Instead, it offers a conditional constructive framework in which axioms A1–A8*, A21, A23–A26 are treated as working constraints on a class of models. Theorems are derived exclusively from these assumptions: their truth is conditional. The rejection of any axiom does not refute the proof, but narrows the class of systems to which the obtained architectural invariants apply. This approach conforms to the standards of formal epistemology and allows the integration of falsifiability (Popper, 1934) into engineering protocols.

### Contributions of this work:

- Formulation and proof of the Cognitive Shadow Theorem (A1–A8, A4*, A8*) in the constructive framework of CIC using standard Coq tools (∃, Prop).
- **Derivation of the minimum entropy growth from finite state resolvability `M`: `δ_min(M) = (ln 2) / M`.**
- Axioms A21 (quantum‑phenomenological bridge), A23 (computational irreducibility of qualia), A24 (operational mutual_info), A25 (quantum correction of qualia), A26 (discrete homotopy).
- Full formal verification of the static core in Coq 8.18+ with modules `CognitiveShadow_Complete.v`, `QuantumQualiaMap.v`, `ChannelLimits.v`.
- Formal safety invariants as direct consequences of Theorem 1′.

---

## 2. Axiomatic framework (static core)

### 2.1 Epistemological status of the axioms

All theorems are conditional: they are derived from explicitly formulated assumptions, provided with phenomenological, physical, or logical justification. For review‑grade rigour, axioms are divided into epistemological types.

The finite‑resolution parameter `M ∈ ℕ, M > 0` – the number of distinguishable macrostates of the system (hardware‑informational limitation) – is introduced. The quantity **`δ_min = (ln 2) / M`** is derived as a theorem and serves as the basis for all temporal estimates in the dynamic extension.

| Type | Axioms | Methodological status | Empirical / Logical anchor |
|------|--------|-----------------------|----------------------------|
| Logical‑formal | A3, A8* | Proof‑theoretic constraints | Gödel’s theorem (1931), Tarski’s theorem (1936) |
| Physical‑informational | A2 (optional), A4*, A21, A24, A25 | Constraints on admissible substrates of cognition | Violation of Bell inequalities, Born rule, Holevo bound (1973), no‑cloning theorem |
| Phenomenological | A1, A1′, A5, A5′, A7, A14, A15, A23 | Modelling assumptions about the structure of subjective experience | Global Workspace (Baars, Dehaene), Nagel’s argument (1974) |
| Computational‑resolvable | M (number of states) | Constraint on the size of phase space | Landauer’s principle, discreteness of measurements |

**Remark on the status of A2.**  
Axiom A2 is not logically necessary for the proof of Theorem 1′. In the base version of the proof (`UseQuantumAxiom = false`), it is replaced by the assumption of the existence of a trivial qualium. The quantum formulation remains optional but empirically motivated. In the optional version, a stochastic barrier is added to the Gödelian one.

**Remark on the independence of A4* and `M`.**  
Axiom A4* (degradation of formalizability upon transfer) is not derived from `M`. This is due to the fundamental difference in the quantities measured: `M` limits *internal temporal evolution*, while A4* describes *intersubjective communication*. The lemma `A4_consistent_with_finite_M` demonstrates their compatibility.

### 2.1.1 Physical foundation: no‑cloning theorem and Holevo bound

Axioms A2, A4* and A10 (in the dynamic extension) are not arbitrary postulates. They directly reflect fundamental limits established by quantum information theory.

**No‑cloning theorem.** Wootters and Zurek (1982) proved that it is impossible to create an exact copy of an arbitrary unknown quantum state. Any attempt to duplicate quantum information inevitably introduces distortions. If conscious processes include quantum degrees of freedom (axiom A2), then the cognitive shadow is fundamentally non‑copyable. This gives a physical justification for axiom A4*: the transfer of qualia between agents cannot occur without loss of accuracy.

**Holevo bound.** Holevo (1973) established a strict limit on how much classical information can be extracted from a quantum system. For an ensemble of quantum states, the accessible classical information is bounded by \(I_{\text{acc}} \le S(\rho) - \sum_i p_i S(\rho_i)\), where \(S\) is von Neumann entropy. This limit is the information‑theoretic expression of axiom A10 (leakage limit, dynamic extension): information that can “leak” from the cognitive shadow via any measurement is fundamentally bounded. There always remains a non‑formalizable remainder, which constitutes the shadow itself.

### 2.2 Static basis (A1–A8, A4*, A8*)

Let the types `Agent`, `Qualia`, `Time`, `FormalSystem` be given.

| Axiom | Formulation (sketch) | Epistemological type | Role in proof |
|-------|----------------------|----------------------|---------------|
| **A1. Uniqueness of actual experience** | ∃ Q: A × T → Qualia, unique actual Q(A,t) | Phenomenological | Provides unambiguous assignment of the shadow to a specific moment of experience |
| **A2. Quantum unpredictability** | ∀ A, ψ: ∃ t: Q(A,t) = outcome(ψ) | Physical‑informational (optional) | In optional version introduces stochastic component q_r; in base version replaced by trivial qualium |
| **A3. Gödelian incompleteness** | ∀ S ⊇ arithmetic: ∃ G: (G ↔ ¬Provable_S(G)) | Logical‑formal | Gives the logical gap G, which will be phenomenologically mapped to q_g |
| **A4*. Degradation of formalizability upon transfer** | Transfer(A,B,q,t,ch) ⇒ φ(q)_B ≤ φ(q)_A − η·(1−fidelity(ch)) | Physical‑informational | Replaces absolute prohibition with measurable attenuation; introduces quarantine threshold |
| **A5. Structure of paired experience** | ∃ < , > , π₁ : π₁(<q₁,q₂>) = q₁ , ∃ t: Q(A,t) = <q₁,q₂> | Phenomenological | Allows constructing composite experience e* = <q_g, q_r> |
| **A6. Digitisation as bijection** | enc: Q→S , dec: S→Q , dec∘enc = id | Working definition | Defines the architectural requirement of complete formalisation |
| **A7. Soundness of the model** | Provable_S(∃t: Q(A,t)=q) ⇒ ∃t: Q(A,t)=q | Phenomenological | Elevates formal unprovability to an assertion about the real phenomenal status of the shadow |
| **A8*. Resource‑bounded bridge** | If ∃ t: Q(A,t)=godel_qualia(S,G), then ¬∃ proof p with ValidProof(S,G,p) ∧ \|p\| ≤ L_max | Logical‑formal + phenomenological | Connects resource constraints with phenomenology; blocks trivial proofs |

*Note:* In this formal theory, the “shadow” is identified with actual experience (qualia), as opposed to formalizable representations (memory, reflexes, rules, synaptic weights). This distinction is operational: formalizable representations can be digitised, copied, and transferred, whereas the shadow cannot (Theorem 1′). In empirical interpretation, the shadow corresponds to a complex neurochemical process “here and now”, but the formal theorems do not depend on this interpretation.

### 2.3 Compositional structure of qualia and quarantine (A1′, A5′, A14, A15)

We introduce a sheaf of qualia, partitioning the agent’s experience into relatively independent components.

**Definition of components:**
- **Sensory (Sens)** – sensations (colour, sound, pain). Highly formalizable.
- **Semantic (Sem)** – meanings, moral evaluations. Partially formalizable.
- **Relational (Rel)** – causality, space, time. Formalizable.
- **Reflexive (Refl)** – self‑awareness, internal observer. Principally non‑formalizable.

**Axiom A1′ (Uniqueness with internal structure).** At each moment `t`, agent `A` has a unique experience `Q(A,t)`, which is a tuple:
`Q(A,t) = (q_sens, q_sem, q_rel, q_refl)`.
Missing components are allowed.

**Axiom A5′ (Structure of composite experience).** For any two experiences, a binding operation `⊗` is defined, creating a new experience whose components combine those of the originals. Projections `π_i` are defined.

**Degree of formalizability.** For component `k`, define `φ(k) ∈ [0,1]`.

**Axiom A14 (Consistency of components).** There exists a relation `Consist(Q)`, true only for admissible combinations.

**Quarantine threshold.** Fix `θ ∈ (0,1)`. Component `k` is quarantine if `φ(k) ≤ θ`.

**Axiom A15 (Quarantine).** For any quarantine component `k`, all operations of merging, exchange, or resonance involving this component are blocked at the architectural level.

### 2.4 Axioms of the quantum‑phenomenological bridge and irreducibility (A21, A23–A26)

**A21. Quantum‑phenomenological correspondence (bridge)**
There exists a mapping `Φ : Qualia → QState` such that `Φ(Q(A,t)) = ψ(A,t)`, collapsing by the Born rule, and `Φ(q₁ ⊗ q₂) = Φ(q₁) ⊗ Φ(q₂)`.

**A23. Computational irreducibility of qualia**
For any component `k` with `φ(k) = 0`, there is no polynomial‑time algorithm recovering `q` from `enc(q)` with probability `> 1/2 + ε`.

**A24. Intersubjective mutual_info (operational definition)**
`mutual_info(s₁, s₂) = H(s₁) + H(s₂) - H(joint(s₁, s₂))`

**A25. Quantum correction of qualia (softening of A4*)**
There exists a QECC and a recovery operation `Rec` such that for transmission with `fidelity(ch) ≥ 0.9`, `φ(Rec(q_received)) ≥ φ(q_original) - ε` (ε = 0.1).

**A26. Discrete homotopy for shadow systems**
Two states are discretely homotopic if there is a finite sequence of merges/splits preserving topological charge.

**Fundamental limit: Holevo bound.**  
Formalizability `φ(k)`, defined as normalised mutual information, obeys the fundamental limit from quantum information theory – the Holevo bound. This gives a physical ceiling for `φ(k)`: even with optimal measurement strategy, no more than `χ_k` classical bits can be extracted from quantum states of the cognitive shadow. The inexpressibility of qualia finds a natural explanation in this fundamental limit.

### 2.5 Derivation of minimum entropy growth

The finite‑resolution parameter `M ∈ ℕ, M > 0` is introduced. The minimum entropy step is derived as:

**`δ_min(M) = (ln 2) / M`**

**Lemma (δ_min positive).** For any `M > 0`, `δ_min(M) > 0`.

**Irreversible step axiom.** For any state `s` and time `t > 0`:
`entropy(evolve s t) - entropy(evolve s (t-1)) ≥ δ_min(M)`

**Theorem (linear lower bound on entropy).** For any `s, t`:
`entropy(evolve s t) ≥ entropy s + t · δ_min(M)`

*Proof* – simple induction using the irreversible step axiom. Formalisation in Coq in module `AlgorithmicEntropy.v`.

### 2.6 Postulate P1: The Gift of Incomprehensibility

**Status:** Derived from Theorem 1′ and Theorem 9. It is an ontological interpretation of the formal results, linking the mathematical core with existential philosophy.

**Formulation:**
For any cognitive system Σ striving for self‑knowledge, there exists a fundamental limit to the formalizability of its own state (consequence of Theorem 1′). This limit is not an error or defect of the system, but an **ontological condition of its dynamic stability and freedom**. Attempting to eliminate this limit through total reflection or external observation inevitably leads to system degradation (Theorem 9). Accepting this limit as a given is the highest act of freedom.

**Formal justification:**
1. **Theorem 1′**: there exists an experience `e*` that cannot be fully formalised in any resource‑bounded system `S`.
2. **Theorem 9**: when `φ(refl) ≤ φ_crit`, intention is counterproductive, noise dominates the control signal.
3. **Axiom A27**: when `intent = 0`, noise is not generated through the reflexive channel.
4. **Axiom A29**: the liberated Orchestrator finds the optimal distribution of the resource `R_max`.

**Corollary:** The incompleteness of formalisation is not a bug, but a feature. The only stable strategy for a cognitive system is to accept its incompleteness and abandon attempts at total control.

**Engineering implication:** When `φ(refl) ≤ φ_crit` is detected, the system should not try to “pull itself together” (which would worsen the collapse), but enter a mode of pure observation (`pure_awareness`), allowing the Orchestrator to recover spontaneously.

**Coq formalisation:** Module `PostulateP1_GiftOfIncomprehensibility.v`. Key theorem:
```coq
Theorem Incomprehensibility_As_Gift :
  forall (A : Agent),
    (forall t, phi_refl A t > phi_crit) ->
    (exists (e : Experience A),
      ~ formalizable (state_of_experience e) /\
      forall t, pure_awareness A t).
```

**Epistemological status:** Postulate P1 is not an axiom in the strict sense – it is **derived** from Theorem 1′ and Theorem 9. However, it formulates an ontological interpretation of these theorems, translating them from the domain of mathematical logic into existential philosophy. Rejection of Postulate P1 does not refute the theorem, but narrows the class of systems to which the interpretation “incomprehensibility as a gift” applies.

---

## 3. Main theorems (static core)

### 3.1 Theorem 1′ (On the partial cognitive shadow)

**Statement.** Under axioms A1–A8, A4*, A8* and compositional axioms, for any agent `A` and any formal system `S` claiming a complete digitisation of `A`’s consciousness, there exists at least one component `k` (e.g., reflexive) and a corresponding experience `e*_k` such that:

1. **Incompleteness of representation:** no formal representation of `e*_k` can be complete.
2. **Undecidability of existence:** the assertion “agent `A` has an experience with non‑zero component `k`” is undecidable in `S` (in the resource‑bounded sense A8*).
3. **Irreducibility of transfer:** component `k` cannot be transferred to another agent without loss of formalizability (degradation of `φ` by A4*).

**Proof** (full listing `CognitiveShadow_Complete.v`):
- From A3 and A8*, construct `godel_qualia(S,G)`.
- *Stochastic component.* If `UseQuantumAxiom = true`, by A2 obtain quantum outcome `q_r`; otherwise use trivial qualium `q_dummy`.
- By A5, build composite experience `e* = <q_g, q_r>`.
- Assumption of complete representation gives `Provable_S(G)`, contradicting A3.
- Transfer of `e*` through a channel with `fidelity < 1` by A4* leads to degradation of `φ` below quarantine threshold.
- Reinforcement through A21 and A23: even with formal representation, extracting qualia with probability above chance is impossible.

**Connection to the clock ambiguity problem.**  
Independent proof by Stoica (2026, arXiv:2604.21805) reinforces Theorem 1′. In the Page‑Wootters formalism without explicitly specifying which operators represent which physical properties, any description of a system containing ideal clocks is unitarily equivalent to any other description with a Hilbert space of the same dimension. This is structurally identical to the Cognitive Shadow Theorem. Both show that formalism without an externally given measurement context leaves an irreducible remainder.

### 3.2 Quantum irreducibility of qualia (Theorem 3.8)

**Statement.** Under A2, A21, A23, for any agent `A` and any formal representation `enc(Q(A,t))` in system `S`, the probability of recovering `Q(A,t)` with above‑chance accuracy is bounded above by `2⁻ⁿ` for some `n > 0` depending on the number of qubits in `Φ(Q(A,t))`. Moreover, no polynomial‑time algorithm improves on random guessing.

**Proof.** (See `QuantumQualiaMap.v`.)

### 3.3 Corollary: Principle of Liberating Incomprehensibility

From Postulate P1, Theorem 1′, Theorem 9 and axioms A27, A29, the following principle is derived, which is the ontological foundation for Shadow Ethics:

**Formulation:**

1. The subject cannot fully know or formalise its own mechanism of switching interfaces (matrix `W`).
2. Any attempt at direct reflexive control of this mechanism generates noise (`noise`), overloads the Orchestrator, and degrades `φ(refl)`.
3. However, there exists a second‑order reflection – **pure awareness without intervention** (`pure_awareness`). It creates no noise, but merely registers the state.
4. When the subject realises that direct control is impossible, it releases control. The liberated Orchestrator automatically finds the optimal distribution of `R_max`.
5. Hence, freedom is achieved not through knowledge (total control), but through acceptance of non‑knowledge (ontological modesty) as a gift. This acceptance opens the horizon for self‑organisation and spontaneous creativity.

**Formal corollary:**
```coq
Theorem Liberation_Through_Acceptance :
  forall (A : Agent),
    (forall t, pure_awareness A t) ->
    (forall t, phi_refl A t > phi_crit).
```

**Clinical implications:** The FORCED_REPORT protocol should not try to “force” the patient to manifest consciousness through effort. Instead, create conditions for pure observation (meaningful stimuli, calm environment).

**Connection to Shadow Ethics:** The Principle of Liberating Incomprehensibility is the ontological basis for all six principles of Shadow Ethics (see [`Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md`](Shadow_Ethics_Formal_Principles_for_Cognitive_Systems.md)).

---

## 4. Formal verification

All theorems of the static core are formalised in Coq 8.18+ (CIC) using modules:
- `CognitiveShadow_Complete.v` – complete proof of Theorem 1′.
- `QuantumQualiaMap.v` – quantum‑phenomenological bridge and Theorem 3.8.
- `ChannelLimits.v` – axiom A4* and compatibility lemma with `M`.
- `AlgorithmicEntropy.v` – derivation of `δ_min(M)` and linear entropy bound.
- `Homotopy.v`, `QuantumErrorCorrection.v` – discrete homotopy and quantum correction.
- `PostulateP1_GiftOfIncomprehensibility.v` – Postulate P1 and the Principle of Liberating Incomprehensibility.

**Constructivity:** Standard Coq tools (∃, Prop) are used. No `Classical`, `LEM`, or `admit` for key theorems.

**Code extraction:** `Extraction` directives translate `qualia_transfer`, `predictability`, `shadow_merge` into OCaml, ready for FFI into Rust/Python.

---

## 5. Comparison with alternative approaches

| Criterion | cognitive‑shadow | IIT | Functionalism | Panpsychism |
|-----------|------------------|-----|---------------|-------------|
| Definition of consciousness | Incomplete formalizable system + irreducible remainder e* | Φ – integrated information measure | Mental state = functional role | Fundamental property of matter |
| Role of computation | Necessary but not sufficient | May realise causal structure | Computation = consciousness | Secondary |
| Status of qualia | Irreducible, transfer degrades φ | Derived from geometry of causal space | Either epiphenomenal or illusion | Fundamental |
| Limit of digitisation | Theorem 1′: total bijection impossible; A23: computational irreducibility | Bounded by preservation of Φ | No limits | Digitisation does not create/destroy consciousness |
| Entropy growth | Derived from finite M: `δ_min = (ln 2)/M` | Not specified | Not specified | Not specified |
| Ontological status | Constructive anti‑reductionism | Structuralist naturalism | Reductive materialism | Ontological fundamentalism |

---

## 6. Falsification matrix (static core)

(As in original, but now with English translations.) See full document in repository.

---

## 7. Formal safety invariants and architectural constraints (Shadow Ethics)

Based on static axioms (A1–A8*, A4*, A8*, A15, A21, A23–A26) and Theorem 1′, the following fundamental architectural invariants are formulated, which must be implemented in any system interacting with cognitive shadows. All invariants listed below are formally verified in Coq (module `FormalEthicsPrinciples.v`) and aligned with the six principles of Shadow Ethics, which follow from system dynamics (Theorems 2, 9, 10, and axioms A27–A29).

### 7.1 Invariants derived from Theorem 1′ (static core)

| Invariant | Essence | Basis | Implementation |
|-----------|---------|-------|----------------|
| **QUARANTINE** | Block operations with components for which `φ(k) ≤ θ_adj`; isolated storage in hardware‑protected memory. | Axiom A15 | Automatic isolation; prohibition of merging, resonance, and transfer; corresponds to Shadow Ethics Principle 4. |
| **HALT_CLONING** | Prohibit operation `clone(shadow_state)` at kernel level; forced halt on cloning attempt. | Theorem 1′, no‑cloning theorem | Kernel‑level blocking; corresponds to Shadow Ethics Principle 1. |

### 7.2 Invariants derived from dynamic extension (Theorems 2–9, A9–A29)

| Invariant | Essence | Basis | Implementation |
|-----------|---------|-------|----------------|
| **HALT_RESONANCE** | Prevent uncontrolled merging of shadows; halt when `mutual_info > ρ_max`. | Theorem 2, A24 | Forced merge interruption; corresponds to Shadow Ethics Principle 5. |
| **HALT_LEAKAGE_COLLAPSE** | Protect against information leakage beyond predictability horizon; halt upon A10 violation. | Axiom A10, Theorem 4 | Monitor mutual information; block when leak_threshold exceeded. |
| **DEGRADED_SAFETY** | Automatically switch system to safe mode upon `φ(refl) ≤ θ_adj` or `φ(refl) ≤ φ_crit`. | Theorem 9, A27.5 | Enter passive observation mode; block volitional commands; corresponds to Principle 2. |
| **HALT_RECURSIVE_COLLAPSE** | Halt system when reflexive component collapses and external support is absent. | Theorem 9 (strong form) | Activate external orchestrator; if absent, full halt; corresponds to Principle 3. |

### 7.3 Complete list of ethical invariants (Shadow Ethics)

Six principles of Shadow Ethics, formally verified in Coq (`FormalEthicsPrinciples.v`), unify and complement the above invariants:

| # | Principle | Invariant | Essence |
|---|-----------|-----------|---------|
| 1 | **No‑Cloning** | `¬∃ op: clone(shadow_state)` | Prohibit copying of the cognitive shadow. |
| 2 | **Prohibition of collapse induction** | `φ_measured(refl) ≤ θ_adj → DEGRADED_SAFETY` | Automatic safe mode upon risk of collapse. |
| 3 | **Duty of external support** | `DEGRADED_SAFETY → external_support_active` | Activate external orchestrator upon collapse. |
| 4 | **Quarantine as invariant** | `φ(k) ≤ θ_adj → isolated(k)` | Isolate damaged components. |
| 5 | **Preservation of adaptive diversity** | `mutual_info > ρ_max → HALT_RESONANCE` | Halt upon excessive synchronisation. |
| 6 | **Limit on pure awareness** | `external_pure_awareness ∧ ¬consent → HALT_AWARENESS_MISUSE` | Prohibit uncontrolled external observation. |

**Integral safety theorem** (proved in Coq) guarantees that with these invariants, the system is always either in normal mode, safe degradation, or controlled halt. Violation of any principle leads to architectural collapse, which is prevented by automatic protocols.

---

## 8. Applied consequences and connection to extensions

The formal theorems and axioms of the present core generate a number of testable predictions and engineering requirements. Their full exposition is given in two companion documents:

1. **Dynamic extension and interfaces** ([`cognitive_shadow_dynamics.md`](https://github.com/Kalera77/cognitive-shadow-theorem/blob/main/cognitive_shadow_dynamics.md)) – contains axioms A9–A29, Theorems 2–9, interface dynamics, and orchestrator.
2. **Applied extensions** ([`cognitive_shadow_applications.md`](https://github.com/Kalera77/cognitive-shadow-theorem/blob/main/cognitive_shadow_applications.md)) – empirical programme (chemical phenomenology, interface model), falsifiable predictions, engineering and clinical protocols, practical recommendations.

---

## 9. Conclusion

The Theorem on the Partial Cognitive Shadow has been formulated and rigorously proved, establishing a fundamental limit to complete consciousness digitisation. The finite‑resolution parameter `M` and the minimum entropy growth `δ_min(M) = (ln 2) / M` have been derived. The proof synthesises Gödelian incompleteness, quantum stochasticity, and the physical immeasurability of non‑equilibrium chemical processes. Ontological modesty has been translated from a philosophical postulate into a verifiable safety invariant.

The proposed framework is not a final theory of consciousness, but provides a rigorous language for discussing its limits and operational criteria for engineering systems. We invite the scientific community to test, critique, and develop these ideas.

All source files, build scripts, and verification reports are available in the open repository:  
[github.com/Kalera77/cognitive-shadow-theorem](https://github.com/Kalera77/cognitive-shadow-theorem).

---

## License and reproducibility

**License:**
- Text and formal models (`.md`, `.tla`, `.v` comments) – **CC BY‑NC 4.0**
- Source code (`.v` proofs, `.rs`, `.py`, extracted `.ml`) – **MIT**

**Reproducibility:**
All proofs are formally verified in:
- Coq 8.18.0 with CIC (without HoTT)
- TLA⁺ Toolbox with model checker TLC
- Python 3.10+ with Hypothesis for property‑based testing
- Rust 1.70+ for FFI bridge

Verification reports are automatically generated in `reports/` upon running `make verify`.

---

## Citation

```bibtex
@techreport{kalinin2026cognitive-shadow-core,
  title = {Cognitive Shadow: formal limits of consciousness digitization (core)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theorem},
  note = {Preprint, updated July 8, 2026},
  license = {CC BY-NC 4.0 / MIT}
}
```
---
## References

1. Stoica OC. The clock ambiguity problem: extended or extinguished? arXiv:2604.21805. 2026.
2. Holevo AS. Bounds for the quantity of information transmitted by a quantum communication channel. Probl Peredachi Inf. 1973;9(3):3-11.
3. Wootters WK, Zurek WH. A single quantum cannot be cloned. Nature. 1982;299:802-803. doi:10.1038/299802a0
4. Landauer R. Irreversibility and heat generation in the computing process. IBM J Res Dev. 1961;5(3):183-191. doi:10.1147/rd.53.0183
5. Gödel K. Über formal unentscheidbare Sätze der Principia Mathematica und verwandter Systeme I. Monatsh Math Phys. 1931;38:173-198. Переиздано в: Gödel K. Collected Works, Vol. I. Oxford University Press; 1986, pp. 144-195.
6. Tarski A. The concept of truth in formalized languages. In: Logic, Semantics, Metamathematics. Oxford University Press; 1956. (Оригинал: 1936; 2-е изд.: Hackett Publishing, 1983, ISBN: 091514476X)
7. Baars BJ. A Cognitive Theory of Consciousness. Cambridge University Press; 1988. ISBN: 978-0521427436
8. Dehaene S, Naccache L. Towards a cognitive neuroscience of consciousness: basic evidence and a workspace framework. Cognition. 2001;79(1-2):1-37. doi:10.1016/S0010-0277(00)00123-2
9. Nagel T. What is it like to be a bat? Philos Rev. 1974;83(4):435-450. doi:10.2307/2183914
---

**Contact:**  
Author: Valeriy S. Kalinin  
Email: kalera77@gmail.com  
Repository: [github.com/Kalera77/cognitive-shadow-theorem](https://github.com/Kalera77/cognitive-shadow-theorem)

---
