import P06Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P06

/-- S1. Source F:445, first clause: "As `𝒫⁻¹(p) = 1/(1-p)`".  Stated for `p ∈ [0,1)`
(generalised inverse of the Pareto cdf).  Role: computes the benchmark's quantile.
Uses no earlier step.  (The source gives no derivation; the range `p = 1` is S1'.) -/
theorem P06_S1 (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p < 1) :
    genInv paretoCdf p = ((1 / (1 - p) : ℝ) : EReal) := by
  sorry

/-- S1'. Source F:445 (same clause, edge value, not printed): at `p = 1` the generalised
inverse is `+∞`, so `1/𝒫⁻¹(1) = 0 = 1 - 1`.  Combined with S1 gives, for every `p ∈ [0,1]`,
`1/𝒫⁻¹(p) = 1 - p`.  Uses: S1. -/
theorem P06_S1' (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    recipE (genInv paretoCdf p) = ((1 - p : ℝ) : EReal) := by
  sorry

/-- S2. Source F:445: "we are reduced to verifying the subadditivity of `1 - F_X(1/x)`",
first half: by S1', for any cdf `F`, `F ≤_{i-sb} 𝒫` iff `x ↦ 1 - F⁻(1/x)` is subadditive on
`(0,∞)` (here `F⁻(t)` is `Function.leftLim F t`, as in Def 5.1 / F:113).  Role: unfolds
Def 5.1 with the Pareto benchmark.  Uses: S1' (values of `F⁻` lie in `[0,1]`). -/
theorem P06_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    isbOrder (ProbabilityTheory.cdf μ) paretoCdf ↔
      SubadditiveOn
        (fun x : ℝ => 1 - Function.leftLim (ProbabilityTheory.cdf μ) (1 / x)) (Set.Ioi 0) := by
  sorry

/-- S3. Source F:445, the passage from `F⁻` (Def 5.1, F:424) to `F_X` (the printed expression
"`1 - F_X(1/x)`"): subadditivity of `x ↦ 1 - F_X⁻(1/x)` iff of `x ↦ 1 - F_X(1/x)` on `(0,∞)`.
NOT justified in the source (inventory X17 / A1; recorded as an implicit step, not repaired).
Uses: nothing earlier. -/
theorem P06_S3 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    SubadditiveOn
        (fun x : ℝ => 1 - Function.leftLim (ProbabilityTheory.cdf μ) (1 / x)) (Set.Ioi 0) ↔
      SubadditiveOn (fun x : ℝ => 1 - ProbabilityTheory.cdf μ (1 / x)) (Set.Ioi 0) := by
  sorry

/-- S4. Source F:445 / Def 2.2 (F:122-124) and the hypothesis `F_X(0)=0` of F:442:
under `F_X(0)=0`, `X` is InvSub iff `1 - F_X(1/x)` is subadditive (the condition `F_X(0)=0`
is used only to match the definition's first requirement).  Uses: nothing earlier. -/
theorem P06_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h0 : ProbabilityTheory.cdf μ 0 = 0) :
    IsInvSub μ ↔
      SubadditiveOn (fun x : ℝ => 1 - ProbabilityTheory.cdf μ (1 / x)) (Set.Ioi 0) := by
  sorry

/-- Proposition 5.3 (source F:440-443, label cor:fsub):
"A random variable `X` such that `F_X(0)=0` is InvSub if and only if `F_X ≤_{i-sb} 𝒫`."
`X` is represented by its law `μ`; `F_X = cdf μ`.  Proof plan: assemble S2, S3, S4
(S2 uses S1, S1'). -/
theorem P06_main (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h0 : ProbabilityTheory.cdf μ 0 = 0) :
    IsInvSub μ ↔ isbOrder (ProbabilityTheory.cdf μ) paretoCdf := by
  rw [P06_S4 μ h0, P06_S2 μ, P06_S3 μ]

end Paper.P06
