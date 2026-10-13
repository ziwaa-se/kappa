import Mathlib

/-!
Shared definitions for the proportions paper (source/main.tex).
Only definitions, no theorems.
-/

namespace Paper.DEFS

/-- main.tex:24, "$I$ denotes the unit interval". Open/closed is NOT stated in the source.
Both variants are given; each result's statement must say which it uses (and record it).
Open variant `(0,1)`. -/
def IOpen : Set ℝ := Set.Ioo 0 1

/-- main.tex:24, closed variant `[0,1]` of the unit interval (see `IOpen`). -/
def IClosed : Set ℝ := Set.Icc 0 1

/-- main.tex:26-27 (Definition `def:vp`): for `p ∈ ℝ`, `V_n(p) = p(1-p)/n`.
The convention `n ≥ 1` (main.tex:24) is not built into the definition; it is
a hypothesis `1 ≤ n` in each result. `n : ℕ` cast to `ℝ`. -/
noncomputable def V (n : ℕ) (p : ℝ) : ℝ := p * (1 - p) / (n : ℝ)

/-- main.tex:32 : `\bar u = (1/m) ∑ u_i`. Vectors are `Fin m → ℝ`. Defined for all `m`
(the source requires `m ≥ 2`; this is a hypothesis in results). -/
noncomputable def mean {m : ℕ} (u : Fin m → ℝ) : ℝ := (1 / (m : ℝ)) * ∑ i, u i

/-- main.tex:33 : `s^2(u) = (1/(m-1)) ∑ (u_i - \bar u)^2`, for `m ≥ 2` in the source.
Here `(m - 1)` is the real number `(m:ℝ) - 1` (no natural-number truncation). -/
noncomputable def s2 {m : ℕ} (u : Fin m → ℝ) : ℝ :=
  (1 / ((m : ℝ) - 1)) * ∑ i, (u i - mean u) ^ 2

end Paper.DEFS
