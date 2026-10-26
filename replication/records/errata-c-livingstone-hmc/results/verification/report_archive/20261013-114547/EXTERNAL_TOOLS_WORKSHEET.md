# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order (which determines what the constants depend on), every hypothesis, the constants in the conclusion.
3. **Notation.** `∫⁻` is an integral with values in `[0,∞]`; `ENNReal.ofReal` truncates negative numbers to 0; `E d` is `EuclideanSpace ℝ (Fin d)`; `xLF gU eps x0 p0 i` is the position after `i` leapfrog steps (`pv_work/Defs.lean:48`).

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 2 | `L03_L02Consumed` | (p), predecessor L02 has issue B01, not reconnected | L03 |
| A | 3 | `T02_L02Consumed` | (p), predecessor L02 has issue B01, not reconnected | T02, T01 (i), C01 (β>2) |
| C | 4 | `T02_Prop35` | (ii) Prop 3.5 | T02, T01 (i), C01 (β>2) |
| C | 6 | `T01_Thm518` | (ii) Thm 5.18 | T01 (ii), C01 (β<1) |
| D | 1 | `L02_L01Consumed` | (p), predecessor L01 unconditional | L02 (gap file) |
| E | 5 | `T02_GaussFacts` | (v) | T02, T01 (i), C01 (β>2) |

- **A**: (iv) clauses of the paper's own lemmas whose proofs have issues; and (p) whose predecessor has an issue and could not be reconnected. These most need a mathematical check.
- **C**: (ii) facts the source asserts but does not prove.
- **D**: (p) with a clean predecessor. **E**: (v) standard facts that merely lack an interface in mathlib.

Gap hypotheses are not external inputs and are not listed here. They are explained under the corresponding issue in AUTHOR_REPORT §4 (B01 gap `L02_main_fixedDelta_Gap`, B02 gap `C01_S2_Gap`).

---

## Level A

### #2 `L03_L02Consumed`: the conclusion of Lemma 5.16 as Lemma 5.17 consumes it

- **Source**: `source/geo_erg_HMC_v3.1.tex:899-901` (part (a)), `:934` (part (b), proved but not printed in the statement).
- **Why it needs checking**: Lemma 5.16 carries issue B01 (its proof uses (18) at TEX:930 but the lemma assumes only (17)). The clause was not reconnected.
- **Mathematical content**: (a) `‖x_{Lε}‖ ≥ 2^L‖x_0‖` for large `‖x_0‖` and `‖p_0‖ ≤ ‖x_0‖^δ`; (b) per-step doubling `‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖`, 1≤i≤L.
- **Suggested checking route** (`L02_final` §7, `T02_final` §4): the auditor probe derives the clause from `L01_main_fixedDelta`, `L02_main_fixedDelta_osc` and `L02_S10` under (17)+(18)+ε>0. Confirm that Lemma 5.17 has (17), (18) in force (TEX:940) and that a statement of Lemma 5.16 including (b) is what the authors intend.
- **Used by**: L03 (S4a at TEX:954; S9, S11 at TEX:968, 970).
- **Lean definition** (`pv_work/L03Stmt.lean:25`, quoted verbatim):

```lean
def L03_L02Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  Paper.L02.ConclFixedDelta gU eps L ∧
  ∀ δ : ℝ, δ < 1 → ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    ∀ i : ℕ, 1 ≤ i → i ≤ L → 2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #3 `T02_L02Consumed`: same clause as consumed by Theorem 5.14

- **Source**: `source/geo_erg_HMC_v3.1.tex:879` ("Lemmas xelower and xlower establish ..."), `:899-901`, `:934`.
- **Why it needs checking**: as #2. Applicability: (17) and (18) are the hypotheses `hexp`, `hosc` of `T02_main`. Note: the registry meaning in `RESULTS.json` mentions only part (a).
- **Mathematical content**: same as #2.
- **Suggested checking route**: as #2; the reconnection file `T02Closed_r1` was recommended by `T02_final` §4 but not produced. Decision open.
- **Used by**: T02 step S2 (via `L03_main`); T01 clause (i) (`hL02 h.1 h.2.1`); C01 β>2 branch.
- **Lean definition** (`pv_work/T02Stmt.lean:101`, quoted verbatim):

```lean
def T02_L02Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  Paper.L02.ConclFixedDelta gU eps L ∧
  ∀ δ : ℝ, δ < 1 → ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    ∀ i : ℕ, 1 ≤ i → i ≤ L → 2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level C

### #4 `T02_Prop35`: Proposition 3.5 specialised to HMC

- **Source**: `source/geo_erg_HMC_v3.1.tex:300-303` (cited from `roberts1996geometric`, TEX:298); Prop 3.3 at TEX:283-289.
- **Why it needs checking**: the paper asserts it without proof. The HMC acceptance depends on `p_0`, so HMC fits the form (eqn:mhtype) with `r = 1 − ∫α dμ^G` but not literally with α of eqn:accept (TEX:163-167, 274-278) (`T02_final` §6; observation, not a confirmed issue).
- **Mathematical content**: if `esssup_π r = 1` then the HMC chain is not geometrically ergodic.
- **Suggested checking route**: check that the Roberts-Tweedie argument uses only the rejection mass `P(x,{x}) ≥ r(x)` (the audit's reasoning, unverified against the paper cited), and the Prop 3.3 conditions (not encoded).
- **Used by**: T02 step S8; T01 (i); C01 β>2.
- **Lean definition** (`pv_work/T02Stmt.lean:78`, quoted verbatim):

```lean
def Prop35 : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 →
    ¬ GeomErgodic U gU eps L
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #6 `T01_Thm518`: Theorem 5.18 specialised to HMC

- **Source**: `source/geo_erg_HMC_v3.1.tex:978-984`; its proof TEX:986-996 uses Prop 3.6 (TEX:307-313, `jarner2003necessary`).
- **Why it needs checking**: out-of-scope numbered result used as an input. Thm 2.2(ii) says `‖∇U‖ ≤ M` (TEX:217) while Thm 5.18 says `< M` (TEX:979); passage by M→M+1 is a fair implicit step. Deterministic L only (the paper's version covers random 𝔏).
- **Mathematical content**: bounded gradient + geometric ergodicity ⇒ some exponential moment of π is finite.
- **Suggested checking route**: compare with TEX:978-984; check the proof via Prop 3.6.
- **Used by**: T01 clause (ii), step S3; C01 β<1.
- **Lean definition** (`pv_work/T01Stmt.lean:25`, quoted verbatim):

```lean
def Thm518 : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    (∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M) →
    GeomErgodic U gU eps L →
    ∃ s : ℝ, 0 < s ∧ (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) < ⊤
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Levels D and E

### #1 `L02_L01Consumed` (D)

- **Source**: TEX:884-886 (Lemma 5.15 statement); used at TEX:912, 930, 934. Predecessor L01 is unconditional; check only that the fixed-δ reading (η may depend on δ) is the intended one (TEX:885 quantifier order). Dischargeable by reconnection to `Paper.L01.L01_main_fixedDelta` (not done; L02 is ISSUE). Used by: L02 gap file only.
- **Lean definition** (`pv_work/L02Stmt.lean:34`, verbatim):

```lean
def L02_L01Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) : Prop :=
  Paper.L01.ConclFixedDelta gU eps
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #5 `T02_GaussFacts` (E)

- **Source**: TEX:879 ("we simply note that P(‖p_0‖≤‖x_0‖^δ) → 1"). Standard Gaussian concentration; the gate's evidence of absence from Mathlib is a `grep` (`T02_gate.md:108-112`), not a `#check`. Used by: T02 (S4-S6), T01 (i), C01 β>2.
- **Lean definition** (`pv_work/T02Stmt.lean:88`, verbatim):

```lean
def GaussFacts : Prop :=
  ∀ d : ℕ, IsProbabilityMeasure (gaussMeas d) ∧
    ∀ δ : ℝ, 0 < δ →
      Tendsto (fun R : ℝ => (gaussMeas d) {p : E d | ‖p‖ ≤ R ^ δ}) atTop (𝓝 1)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `E d`, `piDens`, `H`, `IsGradField` | `pv_work/Defs.lean:16, 20, 24, 28` | state space, target density `exp(−U)`, Hamiltonian, `gU` is the gradient of `U` |
| `leapfrogStep`, `xLF`, `pLF` | `pv_work/Defs.lean:34, 48, 52` | leapfrog map and positions/momenta after `i` steps |
| `HypExplode`, `HypOscillations`, `HypOscillation2` | `pv_work/Defs.lean:75, 80, 86` | hypotheses (17), (18), (19) |
| `rejProb`, `GeomErgodic`, `hmcStep`, `gaussMeas`, `targetMeas` | `pv_work/T02Stmt.lean` (before line 70) | HMC rejection probability, geometric ergodicity, kernel, N(0,I), target measure |
