# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** Confirm that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature (extra hypotheses, special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis, constants.
3. **Notation.** `∫⁻` is an integral with values in `[0,∞]`; `ENNReal.ofReal` truncates negatives to 0; `essSup` is w.r.t. `targetMeas U` (equivalent to Lebesgue since `e^{-U}>0`).

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `C01_T01Consumed` | (p), predecessor T01 unfinished, counts as (iv) | C01 |
| C | 2 | `T02_Prop35` | (ii) by user instruction (INVENTORY); the source also cites Roberts–Tweedie (TEX:298), so type (i) is arguable; priority may move to B/D | T02, T01(i), C01 |
| C | 3 | `T02_Prop35Rand` | (ii) | T02 random-L clause |
| C | 4 | `T01_Thm518` | (ii) | T01(ii) |
| C | 5 | `T01_Thm518Rand` | (ii) | T01 random-L (ii) |
| C | 6 | `T01_T02Consumed` | (p), T02 final, not reconnected | T01(i) |
| E | 7 | `T02_GaussFacts` | (v) | T02 |

`T01Rand_T02Consumed` is reached only through the gap hypothesis `T01_main_randL_partI_Gap` and is not a condition of any result; the gap is a formalization-side stop, not an external input (AUTHOR_REPORT §4.1). No type (iii) parameter exists.

---

## Level A

### #1 `C01_T01Consumed`: Theorem 2.2 (i) with revised (18), and (ii), for d = 1 and deterministic L

- **Source**: `source/geo_erg_HMC_v3.1.tex:208-219, 900-903`; used at TEX:806 and 834.
- **Why it needs checking**: the predecessor T01 is UNFINISHED (random-L part (i) only), so by `VERDICTS.md` §4.1 the clause counts as (iv). The clause itself equals the conclusion of `T01_main` at d=1 (itself conditional on #4, #6) (gate probes `consumed_from_T01Concl`, `T01Concl_from_consumed`); no reconnect audit was run.
- **Mathematical content**: under the standing conventions, (17)+(18)+(19) imply non-geometric ergodicity; and `‖∇U‖≤M` with infinite exponential moments implies the same.
- **Suggested checking route**: T01 deterministic part is verified (`T01_final.md`) conditional on #4 and #6; so checking #1 reduces to those.
- **Used by**: C01 (S1c, S6).
- **Lean definition** (`pv_work/C01Stmt.lean:43`):

```lean
def C01_T01Consumed : Prop :=
  (∀ (U : E 1 → ℝ) (gU : E 1 → E 1) (eps : ℝ) (L : ℕ),
    IsGradField U gU → (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    HypExplode gU → HypOscillations3 gU → HypOscillation2 U L → ¬ GeomErgodic U gU eps L) ∧
  (∀ (U : E 1 → ℝ) (gU : E 1 → E 1) (eps : ℝ) (L : ℕ),
    IsGradField U gU → (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    HypPartII U gU → ¬ GeomErgodic U gU eps L)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level B

### #2 `T02_Prop35`: Proposition 3.5 specialised to the HMC kernel

- **Source**: TEX:298-303 (cites Roberts–Tweedie 1996; bib entry `geo_erg_HMC_v3.1.bbl:543`).
- **Why it needs checking**: labelled (ii) "as instructed" (`INVENTORY.md:28`), but the source explicitly cites the literature. Applicability to a kernel whose acceptance depends on `p_0` (not of form eqn:accept) is not argued.
- **Mathematical content**: if `esssup r = 1` (r the rejection probability) then the chain is not geometrically ergodic.
- **Suggested checking route**: Prop 3.3 (irreducibility, TEX:283-289) conditions; the Lean proves only the form `αQ + rδ_x` (S6); check Roberts–Tweedie's hypotheses on that form.
- **Used by**: T02 (S9, TEX:932); transitively T01(i), C01.
- **Lean definition** (`pv_work/T02Stmt.lean:82`):

```lean
def Prop35 : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 →
    ¬ GeomErgodic U gU eps L
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level C

### #3 `T02_Prop35Rand`: Proposition 3.5 for the random-L kernel

- **Source**: TEX:934-940, Prop 3.5 at TEX:298-303.
- **Why it needs checking**: applied implicitly to the 𝔏-mixture kernel. The `A1Law` antecedent (line 149) is NOT in printed Prop 3.5 (formalization-side defect, harmless for T02; see AUTHOR_REPORT §4.1).
- **Mathematical content**: as #2 for `hmcStepRand`.
- **Suggested checking route**: mixture of MH-type kernels is MH-type with `Q` the mixture of proposals.
- **Used by**: `T02_main_randL`, `main_randL_closed` only.
- **Lean definition** (`pv_work/T02Stmt.lean:146`):

```lean
def Prop35Rand : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    A1Law gU eps Lmeas →
    essSup (fun x : E d => ENNReal.ofReal (rejProbRand U gU eps Lmeas x)) (targetMeas U) = 1 →
    ¬ GeomErgodicRand U gU eps Lmeas
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #4 `T01_Thm518`: Theorem 5.18, fixed L

- **Source**: TEX:1103-1109, proof 1111-1121, Prop 3.6 (TEX:307-313, Jarner–Tweedie 2003).
- **Why it needs checking**: a numbered result outside the user's scope, so not proved here. Thm 2.2(ii) says `‖∇U‖≤M`, Thm 5.18 says `<M` (bridged by M+1, FAIR_IMPLICIT_STEP).
- **Mathematical content**: bounded gradient and geometric ergodicity force a finite exponential moment of π.
- **Suggested checking route**: read TEX:1111-1121 and Prop 3.6.
- **Used by**: T01 (S3, part (ii)); C01 only through T01.
- **Lean definition** (`pv_work/T01Stmt.lean:29`):

```lean
def Thm518 : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    (∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M) →
    GeomErgodic U gU eps L →
    ∃ s : ℝ, 0 < s ∧ (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) < ⊤
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #5 `T01_Thm518Rand`: Theorem 5.18, random L

- **Source**: TEX:1103-1121, 209. The source proof (display at TEX:1118) is for fixed L only.
- **Why it needs checking**: random-L extension unproved in the source.
- **Used by**: T01 random-L part (ii).
- **Lean definition** (`pv_work/T01Stmt.lean:69`):

```lean
def Thm518Rand : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    IsProbabilityMeasure Lmeas → Lmeas {0} = 0 →
    (∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M) →
    GeomErgodicRand U gU eps Lmeas →
    ∃ s : ℝ, 0 < s ∧ (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) < ⊤
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #6 `T01_T02Consumed`: Theorem 5.14 as consumed by Theorem 2.2(i)

- **Source**: TEX:895-941; TEX:213 restates the hypotheses; the identification Thm 2.2(i)=Thm 5.14 is not printed (X3).
- **Why it needs checking**: T02 is final (`T02Closed_r1`) but T01 was not reconnected. On reconnection T01 inherits `T02_Prop35` and `T02_GaussFacts`.
- **Used by**: T01 part (i).
- **Lean definition** (`pv_work/T01Stmt.lean:54`):

```lean
def T01_T02Consumed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    HypPartI U gU L → ¬ GeomErgodic U gU eps L
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level E

### #7 `T02_GaussFacts`: standard Gaussian facts

- **Source**: TEX:917-921 (tail, stated without proof); normalisation silent.
- **Why**: no mathlib interface. The source argument needs δ∈(0,1) (for δ≤0 the display is false); the Lean statement covers every δ>0, which is a true statement.
- **Used by**: T02 (S2, S4); transitively T01, C01.
- **Lean definition** (`pv_work/T02Stmt.lean:92`):

```lean
def GaussFacts : Prop :=
  ∀ d : ℕ, IsProbabilityMeasure (gaussMeas d) ∧
    ∀ δ : ℝ, 0 < δ →
      Tendsto (fun R : ℝ => (gaussMeas d) {p : E d | ‖p‖ ≤ R ^ δ}) atTop (𝓝 1)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Discharged (no longer conditions)

`L02_L01Consumed`, `L03_L02Consumed`, `T02_L03Consumed` were reconnected (`L02_reconnect_r1.md`, `L03_reconnect_r1.md`, `T02_reconnect_r1.md`). The registry's "used by" and line numbers for them are stale.

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `targetMeas`, `rejProb`, `hmcStep`, `GeomErgodic`, `tvDist`, `gaussMeas` | `pv_work/T02Stmt.lean:31-72` | target measure, rejection probability, HMC kernel, eqn:geoerg |
| `E d`, `piDens`, `HypExplode`, `HypOscillation2` | `pv_work/Defs.lean` | Euclidean space, target density, (17), (19) |
| `HypOscillations3` | `Paper.L03` (`L03Stmt.lean`) | revised (18), `‖y‖ ≥ 3‖x‖ ≥ C` (TEX:900-903) |
| `A1Law`, `gaussMeas`, `hmcStepRand`, `GeomErgodicRand` | `pv_work/T02Stmt.lean` | A1 (TEX:393), N(0,I), random-L kernel and geometric ergodicity |
