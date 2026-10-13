import Mathlib

/-!
# Shared definitions (DEFS)

Source: `source/main.tex`, Section "Setting".
Only definitions; no theorems.
-/

open MeasureTheory

namespace Paper.Defs

/-- D01. source/main.tex:24-27 (Definition `def:edf`):
"For `n ≥ 1` and `x = (x_1, …, x_n) ∈ ℝ^n`, the empirical distribution function is
`F_n(t) = (1/n) #{ i : x_i ≤ t }` for `t ∈ ℝ`."

Representation: `x : Fin n → ℝ` (index `i : Fin n` corresponds to `x_{i+1}`).
The hypothesis `n ≥ 1` is NOT built into the definition (for `n = 0`, Lean gives
`0 / 0 = 0`); results that use it must carry `1 ≤ n` / `NeZero n` as in the source. -/
noncomputable def edf {n : ℕ} (x : Fin n → ℝ) (t : ℝ) : ℝ :=
  (1 / (n : ℝ)) * ((Finset.univ.filter (fun i : Fin n => x i ≤ t)).card : ℝ)

/-- D02. source/main.tex:29-30: "When `X_1, X_2, …` are random variables, `F_n` denotes the
empirical distribution function of `(X_1, …, X_n)`."

Representation: a sequence `X : ℕ → Ω → ℝ`, where `X k` stands for `X_{k+1}` (index shift:
Lean's `X 0` is the source's `X_1`). The random EDF at sample point `ω` is `edf` of
`fun i : Fin n => X i ω`, i.e. of `(X_1 ω, …, X_n ω)`. Measurability of the `X k` is not
part of this definition; it is a hypothesis of any result needing it. -/
noncomputable def edfRV {Ω : Type*} (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (t : ℝ) : ℝ :=
  edf (fun i : Fin n => X i ω) t

/-- D03a. source/main.tex:30-31: "`F` is the distribution function of `X_1`".

NOTATIONAL AMBIGUITY: the source does not write `F(t) = P(X_1 ≤ t)` explicitly. We read
"distribution function" in the standard sense `F(t) = P(X_1 ≤ t)` (right-continuous,
not `P(X_1 < t)`), consistent with the `≤` in D01. `X 0` is the source's `X_1`. -/
noncomputable def cdfOf {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (t : ℝ) : ℝ :=
  P.real {ω | X 0 ω ≤ t}

/-- D03b. source/main.tex:30: `D_n = sup_{t ∈ ℝ} |F_n(t) - F(t)|`.

Here `F_n = edfRV X n ω` and `F = cdfOf P X`. The supremum is Lean's real `⨆`
(`sSup` of the range); the range is bounded (both functions take values in `[0,1]` when
`P` is a probability measure and `n ≥ 1`), so it is the true supremum then. For `n = 0` or
non-probability `P` the value is junk, outside the source's scope. -/
noncomputable def Dn {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (n : ℕ) (ω : Ω) : ℝ :=
  ⨆ t : ℝ, |edfRV X n ω t - cdfOf P X t|

end Paper.Defs
