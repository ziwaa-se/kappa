import L02Stmt

namespace Paper.P05

open Paper.L01 Paper.L02

/-- Left-continuous version `F^-(x)` of a cdf `G : ℝ → ℝ` (source F:113, `F_X^-(x)=P(X<x)`),
as the left limit `lim_{y ↑ x} G y`. For the cdf of a measure this equals `P(X < x)`. -/
noncomputable def leftVer (G : ℝ → ℝ) (x : ℝ) : ℝ := Function.leftLim G x

/-- Generalised inverse `v^{-1}(u) = sup {x ∈ ℝ : v x ≤ u}` (source F:111), valued in `EReal`
(the sup may be `+∞`; the empty sup would be `⊥`). -/
noncomputable def genInv (G : ℝ → ℝ) (u : ℝ) : EReal :=
  sSup ((fun x : ℝ => (x : EReal)) '' {x : ℝ | G x ≤ u})

/-- Reciprocal on `EReal` with the conventions `1/0 = +∞`, `1/(+∞) = 0` (needed because
`F_2^{-1}` may be `0` or `+∞`; the source does not state these conventions). The value at `⊥`
is junk (`0`) and is never reached for `u ≥ 0` since `{x | G x ≤ u}` is then non-empty for a cdf. -/
noncomputable def recipE : EReal → EReal
  | ⊥ => 0
  | ⊤ => 0
  | (r : ℝ) => if r = 0 then ⊤ else ((1 / r : ℝ) : EReal)

/-- The function `x ↦ 1 / F_2^{-1}(F_1^-(1/x))` of Def 5.1 (F:424). -/
noncomputable def invSubFn (F₁ F₂ : ℝ → ℝ) (x : ℝ) : EReal :=
  recipE (genInv F₂ (leftVer F₁ (1 / x)))

/-- Def 5.1 (F:422-425): `F₁ ≤_{i-sb} F₂` iff `x ↦ 1/(F₂^{-1}(F₁^-(1/x)))` is subadditive.
Domain of that function read as `(0,∞)` (where `1/x` is meaningful), as in L02 / L01.
`F₁`, `F₂` are cdfs given as functions `ℝ → ℝ`. -/
def InvSubLE (F₁ F₂ : ℝ → ℝ) : Prop :=
  SubadditiveOnE (invSubFn F₁ F₂) (Set.Ioi 0)

/-- Benchmark `ℋ(x) = e^{-1/x}`, `x > 0` (source F:142, Fréchet shape 1); the source gives no
value for `x ≤ 0`; the cdf value `0` is used there. -/
noncomputable def Hcdf (x : ℝ) : ℝ := if 0 < x then Real.exp (-(1 / x)) else 0

/-- Conclusion of Proposition (F:429-432): `X` super-heavy-tailed (Def 4.9(1), reused from
`Paper.L02.IsSuperHeavyTailed`) iff `F_X ≤_{i-sb} ℋ`. -/
def P05Conclusion (μ : MeasureTheory.Measure ℝ) : Prop :=
  IsSuperHeavyTailed μ ↔ InvSubLE (F μ) Hcdf

end Paper.P05
