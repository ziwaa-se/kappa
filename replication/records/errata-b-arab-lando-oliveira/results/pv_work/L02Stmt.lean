import L01Stmt

namespace Paper.L02

open Paper.L01

/-- `-Log F_X(1/x)` for `x > 0`, valued in `EReal` so that `F_X(1/x) = 0` gives `+∞`
(`-log 0 = +∞`), instead of Lean's junk value `Real.log 0 = 0`. Source F:349.
Only used at `x > 0` (Lean `1/0 = 0`; see notes). -/
noncomputable def negLogInv (μ : MeasureTheory.Measure ℝ) (x : ℝ) : EReal :=
  if F μ (1 / x) = 0 then ⊤ else ((-Real.log (F μ (1 / x)) : ℝ) : EReal)

/-- Subadditivity (F:111) of an `EReal`-valued function on a set `S`. -/
def SubadditiveOnE (v : ℝ → EReal) (S : Set ℝ) : Prop :=
  ∀ x ∈ S, ∀ y ∈ S, v (x + y) ≤ v x + v y

/-- Def 4.9(1) (F:344-349): `F_X(0)=0` and `-Log F_X(1/x)` subadditive (domain read as `(0,∞)`). -/
def IsSuperHeavyTailed (μ : MeasureTheory.Measure ℝ) : Prop :=
  F μ 0 = 0 ∧ SubadditiveOnE (negLogInv μ) (Set.Ioi 0)

/-- Displayed condition (eq:inv-NWU, F:364). -/
def InvNWUCond (μ : MeasureTheory.Measure ℝ) : Prop :=
  ∀ x : ℝ, 0 ≤ x → ∀ θ : ℝ, θ ∈ Set.Ioo (0:ℝ) 1 →
    F μ (x / θ) * F μ (x / (1 - θ)) ≤ F μ x

end Paper.L02
