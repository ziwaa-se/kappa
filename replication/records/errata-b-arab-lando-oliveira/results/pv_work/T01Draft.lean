import T01Stmt

namespace Paper.T01

open MeasureTheory ProbabilityTheory
open Paper.L01

/-- S0 (F:180 "As every function considered is increasing", silently used; also needed to
apply the generalised inverse, F:111).  Source gives NO justification: star-shaped `h`
need not be increasing (e.g. `h x = x^2 - x`). Likely false; recorded, not repaired. -/
theorem T01_S0 (h : ℝ → ℝ) (hc : Continuous h) (hs : StarShaped h) :
    MonotoneOn h (Set.Ici 0) := by sorry

/-- S1 (F:174 "as h is continuous, F_{h(X)}(x)=F_X(h^{-1}(x))"), for `x ≥ 0`.
Role: expresses the cdf of `h(X)`. Uses nothing earlier. The premise `hbdd` excludes only the
source's `h^{-1}(x) = +∞` case, where our `sSup` gives the junk value `0`. -/
theorem T01_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (hc : Continuous h)
    (hs : StarShaped h) (hX : IsInvSub μ) (x : ℝ) (hx : 0 ≤ x)
    (hbdd : BddAbove {y : ℝ | 0 ≤ y ∧ h y ≤ x}) :
    F (μ.map h) x = F μ (ginv h x) := by sorry

/-- S2 (not in source; INVENTORY X11): `F_{h(X)}(0) = 0`, needed for `h(X)` to be InvSub
(Def 2.2 F:122-124).  Source never mentions it. Recorded, not repaired. -/
theorem T01_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (hc : Continuous h)
    (hs : StarShaped h) (hX : IsInvSub μ) : F (μ.map h) 0 = 0 := by sorry

/-- S3 (F:174, "its inverse h^{-1} is anti-star-shaped (Lemma 4.1 of ineq-order2024)").
Uses external input X02 (and monotonicity S0). -/
theorem T01_S3 (hX02 : T01_X02Tool) (h : ℝ → ℝ) (hc : Continuous h) (hs : StarShaped h)
    (hm : MonotoneOn h (Set.Ici 0)) : AntiStarShaped (ginv h) := by sorry

/-- S4 (F:174 "hence, given θ∈(0,1), h^{-1}(x/θ) ≤ h^{-1}(x)/θ and
h^{-1}(x/(1-θ)) ≤ h^{-1}(x)/(1-θ)"), for `x > 0`. Uses S3 (ratio monotonicity). -/
theorem T01_S4 (h : ℝ → ℝ) (hanti : AntiStarShaped (ginv h)) (x θ : ℝ) (hx : 0 < x)
    (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    ginv h (x / θ) ≤ ginv h x / θ ∧ ginv h (x / (1 - θ)) ≤ ginv h x / (1 - θ) := by sorry

/-- S5 (F:177-178, "as every function considered is increasing"): monotonicity of `F_X`
turns S4 into `F_X(h^{-1}(x/θ)) ≤ F_X(h^{-1}(x)/θ)` and likewise for `1-θ`. Uses S4. -/
theorem T01_S5 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (x θ : ℝ)
    (hθ : θ ∈ Set.Ioo (0:ℝ) 1)
    (h4 : ginv h (x / θ) ≤ ginv h x / θ ∧ ginv h (x / (1 - θ)) ≤ ginv h x / (1 - θ)) :
    F μ (ginv h (x / θ)) + F μ (ginv h (x / (1 - θ)))
      ≤ F μ (ginv h x / θ) + F μ (ginv h x / (1 - θ)) := by sorry

/-- S6 (F:178, "≤ F_X(h^{-1}(x)) + 1 ... using (eq:sub-1x)"): apply `SubCond μ` at the
point `h^{-1}(x)` (needs `h^{-1}(x) ≥ 0`, unwritten). -/
theorem T01_S6 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hsub : SubCond μ) (y θ : ℝ)
    (hy : 0 ≤ y) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F μ (y / θ) + F μ (y / (1 - θ)) ≤ F μ y + 1 := by sorry

/-- Theorem 2.8 (F:169-172): `X` InvSub, `h` continuous star-shaped, then `h(X)` InvSub.
`X` is its law `μ`; `h(X)` has law `μ.map h`. `h : ℝ → ℝ` is taken continuous on all of `ℝ`
(only `[0,∞)` matters since `F_X(0)=0`). Proof plan: S1, S3, S4, S5, S6 give `SubCond` of
`h(X)` for `x ≥ 0`, then L01 (`←`), whose premise `F μ 0 = 0` is fed by S2; S0 is silently needed. -/
theorem T01_main (hL01 : T01_L01Consumed) (hX02 : T01_X02Tool)
    (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (hc : Continuous h)
    (hs : StarShaped h) (hX : IsInvSub μ) : IsInvSub (μ.map h) := by sorry

end Paper.T01
