import Mathlib

/-!
Shared definitions (source/main.tex, Section 1 "Setting").
Only definitions; no theorems.
-/

namespace Paper

/-- source/main.tex:26: `x = (x_1, …, x_n) ∈ ℝ^n` is encoded as `x : Fin n → ℝ`
(index `i : Fin n` is `x_{i+1}`); the hypothesis `n ≥ 1` is NOT built into the
definitions and must be a hypothesis of each statement that needs it. -/
abbrev Sample (n : ℕ) := Fin n → ℝ

/-- source/main.tex:28-30 (Definition def:mean): `x̄ = (1/n) ∑_{i=1}^n x_i`.
For `n = 0` Lean gives `0` (division by zero); the source only uses `n ≥ 1`. -/
noncomputable def sampleMean {n : ℕ} (x : Sample n) : ℝ :=
  (1 / (n : ℝ)) * ∑ i, x i

/-- source/main.tex:32-37 (Definition def:var): `s² = (1/(n-1)) ∑ (x_i - x̄)²`, for `n ≥ 2`.
The source defines it only for `n ≥ 2`; here it is a total function (real division,
`n-1` cast from ℕ truncated subtraction replaced by the real `(n:ℝ) - 1`), and
statements must assume `2 ≤ n` where the source does. -/
noncomputable def sampleVar {n : ℕ} (x : Sample n) : ℝ :=
  (1 / ((n : ℝ) - 1)) * ∑ i, (x i - sampleMean x) ^ 2

/-- source/main.tex:37: sample standard deviation `s = √(s²) ≥ 0`. -/
noncomputable def sampleStd {n : ℕ} (x : Sample n) : ℝ :=
  Real.sqrt (sampleVar x)

end Paper
