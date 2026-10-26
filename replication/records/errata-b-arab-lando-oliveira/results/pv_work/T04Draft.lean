import T04Stmt

namespace Paper.T04

open Paper.L01 Paper.L02 MeasureTheory

/-- Theorem 4.12 (thm:inv-nwu-fsub), source F:376-379:
"If `X` is super-heavy-tailed, then `X` is InvSub."  `X` is represented by its law `μ`
(a probability measure on `ℝ`, F:119).  Single clause. -/
theorem T04_main (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h : IsSuperHeavyTailed μ) : IsInvSub μ := by
  sorry

/-- S1. Source F:381: "`X` being super-heavy-tailed means that
`Log(1-F^-_{1/X}(x)) = Log F_X(1/x)` is superadditive, that is
`Log F_X(1/(x+y)) ≥ Log F_X(1/x) + Log F_X(1/y)`".
Role: unfolds Def 4.9(1) (F:349, with the remark F:356).  Read for `x,y>0` where both
`F_X(1/x), F_X(1/y) > 0` (so `Log` is the real log); the positivity of `F_X(1/(x+y))` is
part of the conclusion (not stated in the source).  The case `F_X(1/x)=0` or `F_X(1/y)=0`
is covered by S4z (convention `Log 0 = -∞`). -/
theorem T04_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ)
    {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (hFx : 0 < F μ (1 / x)) (hFy : 0 < F μ (1 / y)) :
    0 < F μ (1 / (x + y)) ∧
      Real.log (F μ (1 / x)) + Real.log (F μ (1 / y)) ≤ Real.log (F μ (1 / (x + y))) := by
  sorry

/-- S2. Source F:381-382: "which implies that
`F_X(1/(x+y)) ≥ exp(Log F_X(1/x) + Log F_X(1/y))`".  Uses S1 (apply `exp`, monotone). -/
theorem T04_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ)
    {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (hFx : 0 < F μ (1 / x)) (hFy : 0 < F μ (1 / y)) :
    Real.exp (Real.log (F μ (1 / x)) + Real.log (F μ (1 / y))) ≤ F μ (1 / (x + y)) := by
  sorry

/-- S3. Source F:383: "as the exponential is superadditive" (INVENTORY X08, type (v)):
`exp(a+b) ≥ exp a + exp b - 1` for `a, b ≤ 0`.  Elementary (to be proved, not a parameter). -/
theorem T04_S3 {a b : ℝ} (ha : a ≤ 0) (hb : b ≤ 0) :
    Real.exp a + Real.exp b - 1 ≤ Real.exp (a + b) := by
  sorry

/-- S4. Source F:382-383: "`exp(Log F_X(1/x) + Log F_X(1/y)) ≥ F_X(1/x) + F_X(1/y) - 1`".
Uses S3 with `a = Log F_X(1/x) ≤ 0` (as `0 < F_X ≤ 1`), `b` likewise, and `exp ∘ Log = id`
on positive reals. -/
theorem T04_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    {x y : ℝ} (hFx : 0 < F μ (1 / x)) (hFy : 0 < F μ (1 / y)) :
    F μ (1 / x) + F μ (1 / y) - 1 ≤
      Real.exp (Real.log (F μ (1 / x)) + Real.log (F μ (1 / y))) := by
  sorry

/-- S4z. Source F:381-383, the same chain in the case `F_X(1/x)=0` or `F_X(1/y)=0`, read with
the convention `Log 0 = -∞`, `exp(-∞) = 0` adopted for Def 4.9 (`negLogInv`, L02Stmt):
the right-hand side is `F_X(1/y)-1 ≤ 0` (or symmetric) `≤ F_X(1/(x+y))`. FAIR_IMPLICIT_STEP. -/
theorem T04_S4z (μ : Measure ℝ) [IsProbabilityMeasure μ]
    {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (h0 : F μ (1 / x) = 0 ∨ F μ (1 / y) = 0) :
    F μ (1 / x) + F μ (1 / y) - 1 ≤ F μ (1 / (x + y)) := by
  sorry

/-- S5. Source F:384-385: "Finally, going to the complementary sets, this last inequality is
just `Fbar_X(1/(x+y)) ≤ Fbar_X(1/x) + Fbar_X(1/y)`, that is, `Fbar_X(1/x)` is subadditive,
that is, `X` is InvSub."  Uses S2, S4 (the chain `F(1/(x+y)) ≥ F(1/x)+F(1/y)-1`) for
`x,y>0`, rewrites it as subadditivity of `invDist (F μ)` on `(0,∞)`, together with
`F_X(0)=0` from Def 4.9(1).  `hchain` is supplied by S2+S4 when `F_X(1/x),F_X(1/y)>0`
and by S4z otherwise. -/
theorem T04_S5 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ)
    (hchain : ∀ x y : ℝ, 0 < x → 0 < y →
      F μ (1 / x) + F μ (1 / y) - 1 ≤ F μ (1 / (x + y))) :
    IsInvSub μ := by
  sorry

end Paper.T04
