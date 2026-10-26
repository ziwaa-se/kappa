import Mathlib

namespace Paper.L01

open MeasureTheory ProbabilityTheory

/-- The cdf `F_X` of a random variable `X`, represented by its law `μ` (a probability
measure on `ℝ`); source F:113 ("we shall refer to the random variables or to their cdfs
with the same notations", F:119). -/
noncomputable def F (μ : Measure ℝ) (x : ℝ) : ℝ := ProbabilityTheory.cdf μ x

/-- Inverted distribution `F^-_{1/X}(x) = 1 - F_X(1/x)` (source F:121), for a cdf `G`.
Only used at `x > 0` below (see notes: domain ambiguity, Lean `1/0 = 0`). -/
noncomputable def invDist (G : ℝ → ℝ) (x : ℝ) : ℝ := 1 - G (1 / x)

/-- Subadditivity of `v` on the set `S` (source F:111: `v(x+y) ≤ v(x)+v(y)` for all `x,y`
in the domain of `v`). -/
def SubadditiveOn (v : ℝ → ℝ) (S : Set ℝ) : Prop :=
  ∀ x ∈ S, ∀ y ∈ S, v (x + y) ≤ v x + v y

/-- Definition 2.2 (F:122-125): `X` with `F_X(0)=0` is InvSub iff `F^-_{1/X}` is subadditive.
The domain of `F^-_{1/X}` is read as `(0,∞)` (where `1/x` is meaningful); see notes. -/
def IsInvSub (μ : Measure ℝ) : Prop :=
  F μ 0 = 0 ∧ SubadditiveOn (invDist (F μ)) (Set.Ioi 0)

/-- Displayed condition (eq:sub-1x, F:133). -/
def SubCond (μ : Measure ℝ) : Prop :=
  ∀ x : ℝ, 0 ≤ x → ∀ θ : ℝ, θ ∈ Set.Ioo (0:ℝ) 1 →
    F μ (x / θ) + F μ (x / (1 - θ)) ≤ F μ x + 1

end Paper.L01
