import L01Stmt

namespace Paper.L01

open MeasureTheory ProbabilityTheory

/-- S1. Source F:137, first half: "The subadditivity of `1-F_X(1/x)` is obviously equivalent to
`1-F_X(x/θ)+1-F_X(x/(1-θ)) ≥ 1-F_X(x)`, for every `x ≥ 0` and `θ ∈ (0,1)`."
Role: change of variables `s=θ/x, t=(1-θ)/x` (not written in source), `s+t=1/x`.
Subadditivity on `(0,∞)` iff the displayed inequality for `x>0`, `θ∈(0,1)`.
Uses: nothing. (Source gives only "obviously"; also silently restricts to x>0.) -/
theorem L01_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    SubadditiveOn (invDist (F μ)) (Set.Ioi 0) ↔
      ∀ x : ℝ, 0 < x → ∀ θ : ℝ, θ ∈ Set.Ioo (0:ℝ) 1 →
        1 - F μ x ≤ (1 - F μ (x / θ)) + (1 - F μ (x / (1 - θ))) := by
  sorry

/-- S2. Source F:137, second half: "which is clearly a rewriting of (eq:sub-1x)", and the
case `x = 0` (included in "for every x ≥ 0" but not discussed).
Role: the displayed inequality for `x>0` is the same as (eq:sub-1x) for `x>0`; at `x=0`
(eq:sub-1x) is `2F(0) ≤ F(0)+1`, i.e. `F(0) ≤ 1`.
Uses: nothing. -/
theorem L01_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    (∀ x : ℝ, 0 < x → ∀ θ : ℝ, θ ∈ Set.Ioo (0:ℝ) 1 →
        1 - F μ x ≤ (1 - F μ (x / θ)) + (1 - F μ (x / (1 - θ)))) ↔ SubCond μ := by
  sorry

/-- Lemma 2.3 (lem:ITS-carac), source F:128-135, exactly as printed: `X` is InvSub
(Def 2.2, which includes `F_X(0)=0`) iff (eq:sub-1x).
NOTE (suspected PAPER_ASSUMPTION_GAP): as printed, the "if" direction cannot be derived,
since (eq:sub-1x) does not imply `F_X(0)=0` (e.g. `X=0` a.s.). See notes. -/
theorem L01_main (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    IsInvSub μ ↔ SubCond μ := by
  sorry

end Paper.L01
