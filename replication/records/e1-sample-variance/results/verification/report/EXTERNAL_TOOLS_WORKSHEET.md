# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if one is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion, but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis, the constants in the conclusion.
3. **Notation.** `Sample n` is `Fin n → ℝ`; `sampleMean x` is the arithmetic mean (1/n)Σxᵢ (`pv_work/Defs.lean`).

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `C01_L03Consumed` | (p), counts as (iv); refuted | C01 |
| B | 2 | `Popoviciu` | (i); no theorem number given (`INVENTORY.md:43`); the gate calls the citation the standard attribution (`P01_gate.md` item 6) | P01 |

Gap hypotheses are not external inputs and are not listed here (`L03_S3_Gap`, refuted, is explained under B01 in AUTHOR_REPORT §4.1).

---

## Level A

### #1 `C01_L03Consumed`: Lemma 2.5 as printed, which is false

- **Source**: `source/main.tex:86` (clause), used at `:99`.
- **Why it needs checking**: predecessor L03 has issue B01. The clause is refuted, so it cannot be confirmed by a person.
- **Mathematical content**: for every n ≥ 2 and every sample x, s² ≤ (1/n)Σxᵢ², with s² normalised by 1/(n−1).
- **Suggested checking route**: none to confirm it. Counterexample n=2, x=(1,−1): s²=2 > 1 (`pv_work/L03_Counterexample1.lean`). What is needed is the authors' corrected Lemma 2.5, then a re-check of C01 (also note the separate gap B02).
- **Used by**: C01 (step S1, `C01_main`).
- **Lean definition** (`pv_work/C01Stmt.lean:14`, verbatim):

```lean
def C01_L03Consumed : Prop :=
  ∀ (n : ℕ) (x : Sample n), 2 ≤ n →
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2
```

- **Check result**: ☐ holds  ☑ does not hold (Lean counterexample, reviewed VALID)  ☐ needs change: ____

## Level B

### #2 `Popoviciu`: Popoviciu's inequality on variances, finite-sample form

- **Source**: `source/main.tex:66-67`, bibliography `:103-106` (Popoviciu 1935, Mathematica (Cluj) 9:129-145, a paper on algebraic equations; no theorem number given).
- **Why it needs checking**: no theorem number given in the citation (`INVENTORY.md:43`), though the gate calls it the standard attribution; the statement is the well-known variance inequality, but the cited place is not identified. Note `P01_final.md` §6 reports a probe proving it from mathlib in about 30 lines (not re-read in this run); if that holds, the parameter could be discharged.
- **Mathematical content**: for 1 ≤ n and a ≤ xᵢ ≤ b for all i: (1/n)Σ(xᵢ−x̄)² ≤ (b−a)²/4 (1/n normalisation, not 1/(n−1)).
- **Suggested checking route**: compare with the standard statement of Popoviciu's inequality (variance of a bounded variable ≤ (b−a)²/4) applied to the empirical distribution.
- **Used by**: P01, step S1 (`P01_S1`); step S2 is unconditional.
- **Lean definition** (`pv_work/P01Stmt.lean:11`, verbatim):

```lean
def Popoviciu : Prop :=
  ∀ (n : ℕ) (a b : ℝ) (x : Sample n), 1 ≤ n → (∀ i, a ≤ x i ∧ x i ≤ b) →
    (1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `Sample n`, `sampleMean`, `sampleVar`, `sampleStd` | `pv_work/Defs.lean` | x : Fin n → ℝ; mean; s² with 1/(n−1) (main.tex:35); s = √s² |
