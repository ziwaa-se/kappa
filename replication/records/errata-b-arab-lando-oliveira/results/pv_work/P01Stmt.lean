import Mathlib

/-!
# P01 statement definitions (Proposition 2.5, label prop:ITS-dens)
Source: source/SuperParetoPaper-v12.tex:148-151 (statement), 152-154 (proof).
No sorry, no theorems.
-/

open MeasureTheory ProbabilityTheory Set

namespace Paper.P01

/-- Cumulative distribution function `F_X(x) = P(X ≤ x)` of the law `μ` of `X`
(source :113). `X` is represented by its law `μ` on `ℝ`; only the cdf matters (source :119). -/
noncomputable def F (μ : Measure ℝ) (x : ℝ) : ℝ := ProbabilityTheory.cdf μ x

/-- Survival function `Fbar_X = 1 - F_X` (source :113). -/
noncomputable def Fbar (μ : Measure ℝ) (x : ℝ) : ℝ := 1 - F μ x

/-- The inverted distribution `F^-_{1/X}(x) = 1 - F_X(1/x)` (source :121), for `x > 0`. -/
noncomputable def invDist (μ : Measure ℝ) (x : ℝ) : ℝ := 1 - F μ (1 / x)

/-- Subadditivity (source :111) of a function on its domain, here the domain is `(0,∞)`
(domain choice: see notes, the source does not state the domain of `F^-_{1/X}`). -/
def SubadditiveOnPos (v : ℝ → ℝ) : Prop :=
  ∀ x y : ℝ, 0 < x → 0 < y → v (x + y) ≤ v x + v y

/-- Definition 2.2 (source :122-125): `X` with `F_X(0)=0` is InvSub if `F^-_{1/X}` is subadditive. -/
def InvSub (μ : Measure ℝ) : Prop :=
  F μ 0 = 0 ∧ SubadditiveOnPos (invDist μ)

/-- Hazard rate `r_X(x) = f_X(x) / Fbar_X(x)` (source :150), `f` a density of `μ`
(an `ℝ≥0∞`-valued density, read through `toReal`; Lean real division, `a/0 = 0`). -/
noncomputable def hazard (μ : Measure ℝ) (f : ℝ → ENNReal) (x : ℝ) : ℝ :=
  (f x).toReal / Fbar μ x

/-- The function `v` of the proof (source :153): `v(x) = 1 - F_X(1/x)` for `x>0`,
extended by `v(0) = 0` ("as it vanishes at zero"). -/
noncomputable def vExt (μ : Measure ℝ) (x : ℝ) : ℝ := if x = 0 then 0 else invDist μ x

/-- Anti-star-shaped (source :111): `v 0 = 0`-type convention is carried by `vExt`;
`v(x)/x` decreasing (= non-increasing) on `x > 0`. -/
def AntiStarShaped (v : ℝ → ℝ) : Prop :=
  v 0 = 0 ∧ AntitoneOn (fun x => v x / x) (Ioi 0)

end Paper.P01
