# Appendix S2: Experimental Protocols – Full English Version

> **Status:** Updated to align with the cognitive shadow theory (version of July 8, 2026).  
> **Contains:** Four main experimental protocols for falsification of Theorems 6–9, PsychoPy script, updated success criteria reflecting new empirical data (A, T, F), and links to formal verification of FORCED_REPORT and Shadow Ethics.  
> **Full protocols:** Available in the repository at `github.com/Kalera77/cognitive-shadow-theory/protocols/`.

---

## S2.0. Updated Status of Empirical Validation (2026)

Based on analysis of 265,956 epochs from 9 independent datasets with correct subject‑wise cross‑validation (GroupKFold) and mixed models, the following results have been obtained and should inform experiment planning:

| Parameter | Status | Data |
|-----------|--------|------|
| **φ (1st‑order index)** | ✅ Confirmed for LIS | AUC = 0.947 ± 0.081 for CLIS vs healthy |
| **φ for DOC** | ❌ Not confirmed | Kruskal‑Wallis p = 0.152; correlations with CRS‑R non‑significant |
| **A (Awareness)** | ✅ Confirmed | Mixed model: p = 0.045 (Pereira) |
| **T (Temporal Coherence)** | ⚠️ Partial | REM sleep p < 0.001; DOC/CLIS/Pereira — no differences |
| **F (Flexibility)** | ❌ Not confirmed | Model did not converge on CAP; requires active switching |
| **R (Resilience)** | ❌ No data | Requires load protocol |

**Conclusion for protocols:** Protocols 1 and 4 (noise dominance and metacognitive collapse) are **priority** for testing. Protocol 2 (controllability limit) requires revision given that T did not manifest in passive data. Protocol 3 (degradation threshold) may be strengthened by measuring R.

---

## S2.1. PsychoPy Script: 2AFC Protocol with Auto‑Export

The script implements a sequential prediction task with a 2nd‑order Markov chain. It automatically computes `H_source` and `I_pred` upon block completion and saves data in a format ready for `fit_delta_min.py`.

```python
# -*- coding: utf-8 -*-
"""
Protocol_2AFC_Prediction.py
Two‑alternative forced choice task with sequential prediction.
Data export compatible with fit_delta_min.py (cognitive‑shadow)
Dependencies: psychopy, pandas, numpy
Version: 2.0 (updated July 8, 2026)
"""

from psychopy import core, visual, event, gui, data, logging
import numpy as np
import pandas as pd
import os
import math
import time

# ================= CONFIGURATION =================
BLOCK_ENTROPIES = [0.2, 0.35, 0.5, 0.65, 0.8, 1.0]  # Target conditional entropy (bits)
TRIALS_PER_BLOCK = 60
FIXATION_DUR = 0.5
PREDICT_DUR = 2.0
STIM_DUR = 0.5
FEEDBACK_DUR = 0.3
ITISI = 0.8

# Transition probabilities for approximating target entropy (Markov‑2)
TRANSITION_MAP = {
    0.2: {'LL': {'L': 0.85, 'R': 0.15}, 'RR': {'L': 0.15, 'R': 0.85}},
    0.35: {'LL': {'L': 0.75, 'R': 0.25}, 'RR': {'L': 0.25, 'R': 0.75}},
    0.5: {'LL': {'L': 0.65, 'R': 0.35}, 'RR': {'L': 0.35, 'R': 0.65}},
    0.65: {'LL': {'L': 0.55, 'R': 0.45}, 'RR': {'L': 0.45, 'R': 0.55}},
    0.8: {'LL': {'L': 0.51, 'R': 0.49}, 'RR': {'L': 0.49, 'R': 0.51}},
    1.0: {'LL': {'L': 0.5, 'R': 0.5}, 'RR': {'L': 0.5, 'R': 0.5}}
}

# ================= UTILITIES =================
def compute_conditional_entropy(sequence):
    """Computes H(X_t | X_{t-1}, X_{t-2}) for a binary sequence."""
    if len(sequence) < 3: return 1.0
    counts = {'LL': {'L':0, 'R':0}, 'RR': {'L':0, 'R':0}, 'LR': {'L':0, 'R':0}, 'RL': {'L':0, 'R':0}}
    for i in range(2, len(sequence)):
        ctx = sequence[i-2] + sequence[i-1]
        nxt = sequence[i]
        if ctx in counts and nxt in counts[ctx]:
            counts[ctx][nxt] += 1
    ent = 0.0
    for ctx in counts:
        total = sum(counts[ctx].values())
        if total > 0:
            for nxt in counts[ctx]:
                p = counts[ctx][nxt] / total
                if p > 0: ent -= (total / (len(sequence)-2)) * p * math.log2(p)
    return ent

def export_fitting_data(df, subject_id, out_dir="data"):
    """Generates summary for fit_delta_min.py"""
    os.makedirs(out_dir, exist_ok=True)
    summary = []
    for target_h in BLOCK_ENTROPIES:
        block_data = df[df['block_target_entropy'] == target_h]
        actual_h = compute_conditional_entropy(block_data['stimulus'].tolist())
        acc = block_data['correct'].mean()
        h_emp = -acc*math.log2(acc) - (1-acc)*math.log2(1-acc) if 0<acc<1 else 0
        i_pred = actual_h - h_emp
        summary.append({
            'H_source': actual_h,
            'I_pred': max(0.0, min(1.0, i_pred)),
            'target_H': target_h,
            'n_trials': len(block_data)
        })
    out_df = pd.DataFrame(summary)
    out_path = os.path.join(out_dir, f"fitting_input_{subject_id}.csv")
    out_df.to_csv(out_path, index=False)
    return out_path

# ================= EXPERIMENT =================
def run_experiment():
    dlg = gui.DlgFromDict(dictionary={'participant': '', 'session': '001'}, title="cognitive-shadow 2AFC Protocol")
    if not dlg.OK: core.quit()
    subject = dlg.data['participant']
    win = visual.Window([1024, 768], color='gray', units='height', fullscr=False)
    fixation = visual.TextStim(win, text='+', height=0.1, color='white')
    stim_L = visual.Circle(win, radius=0.1, pos=(-0.2, 0), fillColor='blue')
    stim_R = visual.Circle(win, radius=0.1, pos=(0.2, 0), fillColor='red')
    feedback_txt = visual.TextStim(win, height=0.08, color='white')
    
    all_data = []
    np.random.seed(int(time.time()))
    
    for target_h in BLOCK_ENTROPIES:
        trans = TRANSITION_MAP[target_h]
        seq = ['L', 'L']
        for _ in range(TRIALS_PER_BLOCK + 2):
            ctx = seq[-2] + seq[-1]
            probs = trans.get(ctx, {'L': 0.5, 'R': 0.5})
            nxt = np.random.choice(['L', 'R'], p=[probs['L'], probs['R']])
            seq.append(nxt)
        
        for trial_idx, stim_code in enumerate(seq[2:]):
            fixation.draw()
            win.flip()
            core.wait(FIXATION_DUR)
            
            clock = core.Clock()
            keys = event.waitKeys(maxWait=PREDICT_DUR, keyList=['left', 'right'], timeStamped=clock)
            if not keys: resp, rt = 'none', 0
            else: resp, rt = keys[0]
            
            (stim_L if stim_code == 'L' else stim_R).draw()
            win.flip()
            core.wait(STIM_DUR)
            
            correct = (resp == f"{'left' if stim_code=='L' else 'right'}")
            feedback_txt.text = "Correct!" if correct else "Wrong"
            feedback_txt.color = 'green' if correct else 'red'
            feedback_txt.draw()
            win.flip()
            core.wait(FEEDBACK_DUR)
            
            all_data.append({
                'subject': subject,
                'block': len([b for b in BLOCK_ENTROPIES if b < target_h]),
                'block_target_entropy': target_h,
                'trial': trial_idx,
                'response': resp,
                'stimulus': stim_code,
                'correct': int(correct),
                'RT': rt
            })
    
    df = pd.DataFrame(all_data)
    raw_path = os.path.join("data", f"raw_trials_{subject}.csv")
    df.to_csv(raw_path, index=False)
    fit_path = export_fitting_data(df, subject)
    
    print(f"✅ Data saved: {raw_path}")
    print(f"📊 Fitting data: {fit_path}")
    win.close()
    core.quit()

if __name__ == "__main__":
    run_experiment()
```

---

## S2.2. Protocol 1: Falsification of Noise Dominance (Theorem 6)

**Gap tested:** The counterproductive effect of intention under strong interface imbalance.

**Quantitative justification (M ≈ 10⁴, δ_min ≈ 7×10⁻⁵).** Imbalance threshold Δ_threshold ≈ 0.15–0.20 (normalised units). When `C_refl − C_sens ≥ Δ_threshold`, additional effort in the sensory channel should lead to a drop in d′ of 0.3–0.5 (Cohen's d ≈ 0.5–0.8). Required sample size: N = 25–35.

**Experimental hypothesis:**  
When the imbalance threshold `Δ_threshold` is exceeded, increasing volitional effort (intent) in the weak sensory channel leads to a *decrease* in its performance and selectivity (increased noise).

**Design:** Within‑subjects, multifactorial (2×2×2):  
- Factor 1: Level of reflexive load (low / high, the latter should create imbalance by overloading `C_refl`).  
- Factor 2: Instruction on effort in the probe sensory task ("work at your own pace" / "give it your maximum").  
- Factor 3: Presence of noise (high level of distractors in the probe task).

**Participants:** N = 40 healthy adults (20–40 years), pre‑calibrated on interface profile to ensure variability in `C_refl` and `R_max`.

**Tasks:**
- *Background reflexive load:* adaptive task assessing confidence in perceptual decisions (meta‑d′), difficulty adjusted to maintain ~80% accuracy. High load additionally includes concurrent maintenance of a 5‑digit number in memory.
- *Probe sensory task:* detection of a faint tonal signal in white noise; 80 trials per block. In "high noise" conditions, an irrelevant speech stream is added.

**Procedure (1 session, 2 hours):**
1. Calibration of `M` (10 min resting‑state EEG with eyes open, Higuchi FD computation).
2. Baseline measurement of meta‑d′ in each task separately.
3. 8 experimental blocks (conditions randomised), 5 min each. Within each block, background and probe tasks are performed concurrently.
4. At the end of each block — salivary cortisol measurement (Salivette sample) and subjective effort rating (Borg CR‑10 scale).

**Measured variables:**
- *Behavioural:* d′ of the sensory task, reaction time, error variance.
- *Metacognitive:* meta‑d′ in background and probe tasks.
- *Physiological:* salivary cortisol (proxy for `noise_k`), alpha power in RLPFC regions (proxy for `C_refl`).
- *Derived:* individual `Δ_threshold` from calibration data (Appendix P6). Current imbalance is estimated as the difference `C_refl − C_sens`, normalised by `R_max`.

**Cognitive‑shadow prediction:**
In conditions where `C_refl − C_sens ≥ Δ_threshold`:
- The gain in d′ from the "try harder" instruction will be negative (d′_high_effort < d′_low_effort).
- Error variance will increase.
- The correlation between subjective effort and d′ will become negative.
- The effect will not be observed under low reflexive load (no imbalance).

**Falsification criterion:**
If no significant "Load × Instruction" interaction is found in any condition, where higher effort worsens performance (p > 0.05 in ANOVA with post‑hoc tests), the noise dominance hypothesis is rejected. In particular, if d′_high_effort ≥ d′_low_effort in all conditions, the strong form of the cognitive‑shadow model is falsified.

---

## S2.3. Protocol 2: Empirical Validation of the Controllability Limit (Theorem 7)

**Gap tested:** Relationship between the irreducible residual switching cost (`τ_min`) and the dimensional complexity of the system (`M`).

**Quantitative justification:** At M ~10⁴, expected Pearson correlation r ≈ 0.4–0.6 between δ_min and asymptotic switch cost. To detect r=0.4 with power 0.8, N=47 is required.

**Experimental hypothesis:**  
Individual asymptotic residual task‑switching cost (switch cost) correlates positively with the estimate of `δ_min(M) = ln 2 / M`, where `M` is measured via Higuchi fractal dimension of EEG.

**Design:** Correlational‑experimental, two sessions.

**Participants:** N = 60 healthy adults (broad age range 20–65 years to ensure variability in `M`).

**Task:** Two simple categorisation tasks: "digit parity" and "greater/less than 5" for digits 1–9 (excluding 5). Switching is cued by an external signal (frame colour).

**Procedure:**
1. *Session 1 (EEG):* 10 min resting‑state recording with eyes open (64 channels, ≥500 Hz). Higuchi FD computed per channel; averaging over fronto‑central leads yields an estimate of `M` via the calibration formula `M = (R/ε)^D` with fixed window parameters.
2. *Session 2 (Behavioural):* Training to stable performance (5 blocks of 120 trials). Then switch cost measurement at different preparation intervals (CTI: 100, 200, 400, 800, 1500 ms) — 10 blocks per CTI, random order. Instruction: "maximum speed while maintaining accuracy". Reaction times (RT) are recorded for repeat and switch trials.

**Measured variables:**
- *Asymptotic switch cost:* computed as the RT difference between switch and repeat trials, averaged over the longest CTIs (800 and 1500 ms), where a plateau is reached.
- *Individual `δ_min` estimate* via `M` from Session 1.

**Cognitive‑shadow prediction:**
- Significant positive correlation (r > 0.3, p < 0.05) between asymptotic switch cost and `δ_min` (or negative correlation with `M`).
- No correlation between switch cost at short CTIs and `δ_min` (since at short CTIs the limiting factor is not `τ_min` but reconfiguration processes).

**Falsification criterion:**  
If the correlation between asymptotic switch cost and `δ_min` is not statistically significant (p > 0.1) and the Bayes factor favours the null model (BF₀₁ > 3), the hypothesis linking `τ_min` to `M` is rejected.

---

## S2.4. Protocol 3: Verification of the Irreversible Degradation Threshold (Theorem 8)

**Gap tested:** Existence of a threshold `Δ_crit` of cumulative load separating reversible fatigue from irreversible degradation of `φ(refl)`.

**Quantitative justification (M ≈ 10⁴, δ_min ≈ 7×10⁻⁵).** Δ_crit ≈ 0.05–0.10 bits, corresponding to 7–14 days of pronounced imbalance. Expected residual deficit δ_perm ≥ 0.2–0.4 units of meta‑d′ for participants above threshold.

**Experimental hypothesis:**  
Participants who accumulate cumulative load `Load ≥ Δ_crit` will retain a residual metacognitive accuracy deficit `δ_perm > 0` after prolonged rest, while those with `Load < Δ_crit` will show full recovery.

**Design:** Longitudinal, with two groups formed post‑hoc by median of accumulated load.

**Participants:** N = 50 healthy students during the exam period (natural high load) or participants undergoing a 3‑week intensive training course with controlled load.

**Procedure (6 weeks):**
- *Week 0:* Baseline measurements: meta‑d′ (perceptual discrimination + confidence), burnout questionnaire (MBI), cortisol (morning), HRV, polysomnography (one night).
- *Weeks 1–3 (Load phase):* Daily 8‑hour sessions requiring high concentration and complex problem‑solving; evening cognitive tests; sleep restriction (5–6 h). Weekly meta‑d′, MBI, and cortisol measurements.
- *Weeks 4–5 (Rest phase):* Complete cessation of academic load, free schedule, sleep encouragement.
- *Week 6:* Final measurements identical to Week 0.

**Cumulative load calculation:**
For each participant each week, instantaneous deviation `ΔE(t)` from the baseline normal profile is computed. The profile is defined by three indicators: meta‑d′, morning cortisol, RMSSD. Normalised z‑transformed values are used, and `ΔE(t)` is the Euclidean distance from the baseline vector. Cumulative load `Load` = sum of `ΔE(t)` over Weeks 1–3.

**Threshold `Δ_crit` determination:** Segmented regression is used to identify the breakpoint on the curve of residual deficit `δ_perm` (Week 0 meta‑d′ − Week 6 meta‑d′) versus `Load`.

**Cognitive‑shadow prediction:**
- A statistically significant threshold `Δ_crit` exists, below which `δ_perm` does not differ from zero, and above which `δ_perm > 0` and increases linearly with `Load`.
- The group above threshold will show a metacognitive paradox: subjective fatigue complaints (MBI) recover to baseline, while objective `δ_perm` persists.

**Falsification criterion:**
If the segmented regression model with a threshold does not provide a significantly better fit than a linear model without a threshold (Davies test, p > 0.1), or if after rest `δ_perm` does not differ from zero for all participants regardless of `Load`, then Theorem 8 is falsified with respect to irreversibility.

---

## S2.5. Protocol 4: Direct Test of Metacognitive Collapse (Theorem 9)

**Gap tested:** Existence of a threshold `φ_crit` below which intention becomes harmful and self‑recovery without external help is impossible.

**Quantitative justification:** For healthy individuals, φ(refl) corresponds to meta‑d′ 1.5–2.5. Collapse threshold φ_crit ≈ 0.5–0.8 meta‑d′. Expected negative effort effect: drop of 0.3–0.6.

**Experimental hypothesis:**
1. In individuals with `φ(refl) < φ_crit`, the instruction "try harder" in a metacognitive task will *reduce* metacognitive accuracy.
2. After stress induction, they will show a cascading drop in `φ(refl)` that does not stop after rest, but halts when structured external support is provided.

**Design:** Mixed, with three comparison groups and control.

**Participants:**
- Group 1 (n=20): Healthy controls with high `φ(refl)` (meta‑d′ > 1.5).
- Group 2 (n=20): Subclinical depression (PHQ‑9 10–14), medium `φ(refl)`.
- Group 3 (n=20): Clinical depression (PHQ‑9 ≥ 15), low `φ(refl)` (< 1.0).

**Procedure (1 session, 3 hours):**
1. **Baseline measurement:** Meta‑d′ in a discrimination task (100 trials), mood scale (PANAS).
2. **Stress induction:** Trier Social Stress Test (TSST) — 5 min preparation, 5 min speech, 5 min arithmetic before a panel. Immediately after — cortisol measurement and meta‑d′.
3. **"Effort" phase:** Repeated metacognitive task with the instruction "You must beat your previous result; an important bonus depends on it".
4. **Spontaneous rest phase:** 40 min in a quiet room without any stimulation. Meta‑d′ measurement.
5. **External support phase:** The experimenter provides standardised feedback ("Your result is now stable, you are doing well"), gives a simple mnemonic strategy for confidence estimation, then another meta‑d′ measurement.

**Measurements:** Meta‑d′ at all phases, cortisol after TSST and at the end of rest, heart rate.

**Cognitive‑shadow prediction:**
- In Group 3:
  - `meta‑d′_effort < meta‑d′_post‑TSST` (negative effort effect).
  - `meta‑d′_rest ≤ meta‑d′_post‑TSST` (no spontaneous recovery).
  - `meta‑d′_support > meta‑d′_rest` (recovery only with external orchestrator).
- In Groups 1 and 2: effort either increases or does not change meta‑d′; after rest, spontaneous recovery to baseline occurs.
- The point `φ_crit` is estimated post‑hoc as the threshold value of `φ(refl)` at Phase 2 below which the negative effort effect begins to appear.

**Falsification criterion:**
If in Group 3 (low `φ(refl)`) no significant reduction in meta‑d′ is found in the effort phase, or if after rest all groups show recovery without external help, the predictions of Theorem 9 regarding the collapse threshold and the need for an external orchestrator are considered falsified.

---

## S2.6. Summary Table of Protocols and Statuses

| Theorem | Key gap | Proposed protocol | Strictest falsification criterion | Current status |
| :--- | :--- | :--- | :--- | :--- |
| **6** | Counterproductive effect of intention | Dual‑task + effort manipulation under stress | Absence of significant negative effort effect under high imbalance | ✅ Ready to launch |
| **7** | Link between `τ_min` and dimensional complexity `M` | Correlation of residual switch cost with `δ_min(M)` from Higuchi FD | Zero correlation between asymptotic switch cost and `δ_min` | ⚠️ Requires revision (T did not manifest in passive data) |
| **8** | Threshold `Δ_crit` of irreversible degradation | Longitudinal with load and rest phases; segmented regression | No breakpoint on the `δ_perm` vs `Load` curve | ✅ Ready to launch (strengthen with R measurement) |
| **9** | Threshold `φ_crit` of metacognitive collapse | Comparison of groups with different `φ(refl)`, TSST, effort/rest/support phases | Absence of negative effort effect and spontaneous recovery in all groups | ✅ Ready to launch (priority) |

---

## S2.7. Connection to Formal Verification of FORCED_REPORT and Shadow Ethics

All protocols are designed in accordance with the following formally verified invariants:

1. **Prohibition of collapse induction (Shadow Ethics Principle 2):** No protocol involves deliberately inducing a subject into a state of `φ(refl) ≤ φ_crit`. Work is conducted only with natural variability or already existing clinical states.

2. **Duty of external support (Principle 3):** In Protocol 4, the external support phase is a mandatory part of the procedure, not an optional addition.

3. **Soundness of FORCED_REPORT:** The FORCED_REPORT protocol is formally verified in Coq (module `ForcedReportDecision.v`) — transition to `CONSCIOUS_LOCKED` occurs only when all triggers are met, guaranteeing absence of false positives.

4. **Ethical consistency:** All protocols are aligned with the six principles of Shadow Ethics, formally verified in `FormalEthicsPrinciples.v`.

---

## S2.8. IRB Ethics Template (Summary)

> **Title:** Neurochemical modulation of metacognitive formalisability under acute stress  
> **PI:** Kalinin V.S. | **Institution:** System Engineering Research  
> **Risks:** Temporary discomfort during TSST (stress, fatigue). Mitigation: voluntary withdrawal at any time, debriefing, compensation.  
> **Benefits:** Scientific contribution to validating formal models of consciousness, individual feedback on metacognitive profiles.  
> **Confidentiality:** Data anonymised (UUID), stored encrypted (AES‑256), access only to PI and statistician. Raw EEG/saliva destroyed after 5 years.  
> **Consent:** Voluntary, informed, right to withdraw data without explanation.

---

## S2.9. GitHub Actions Workflow: Zenodo DOI + TLC Report

```yaml
name: CI & Zenodo Release

on:
  push:
    branches: [ main, release/** ]
  release:
    types: [ published ]

env:
  COQ_VERSION: "8.18.0"
  TLC_VERSION: "2.18"

jobs:
  verify:
    runs-on: ubuntu-latest
    timeout-minutes: 45
    steps:
      - uses: actions/checkout@v4
      - name: Setup Coq 8.18
        run: |
          sudo apt-get update && sudo apt-get install -y opam m4
          opam init -y --bare --disable-sandboxing
          opam switch create 4.14.1
          eval $(opam env)
          opam install coq.${{ env.COQ_VERSION }} coq-hott -y
      - name: Verify Coq
        run: make verify
      - name: Run Python Tests
        uses: actions/setup-python@v5
        with: { python-version: "3.11" }
      - run: |
          python -m venv .venv
          .venv/bin/pip install -r requirements.txt
          .venv/bin/pytest tests/ -v
      - name: Run TLC
        run: |
          wget -q -O tla2tools.jar https://github.com/tlaplus/tlaplus/releases/download/v${{ env.TLC_VERSION }}/tla2tools.jar
          java -Xmx4g -cp tla2tools.jar tlc2.TLC -workers auto -deadlock tla-spec/ShadowAwareConsensus_Extended.cfg
      - name: Upload Reports
        uses: actions/upload-artifact@v4
        with:
          name: verification-reports
          path: reports/
```

---

**Citation:**  
```bibtex
@techreport{kalinin2026cognitive-shadow-protocols,
  title = {Appendix S2: Experimental Protocols for Theorems 6–9 (v2)},
  author = {Kalinin, Valeriy S.},
  year = {2026},
  institution = {System Engineering Research},
  url = {https://github.com/Kalera77/cognitive-shadow-theory},
  note = {Preprint, updated July 8, 2026}
}
```

---

**End of Appendix S2**