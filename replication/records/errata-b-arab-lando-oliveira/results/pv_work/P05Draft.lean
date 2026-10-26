import P05Stmt

namespace Paper.P05

open Paper.L01 Paper.L02

/-- S1. Source F:434 (first half): "Note that `ℋ^{-1}(p) = -1/Log p`".
Role: quantile of the benchmark. The source states it with no range; it is only meaningful for
`p ∈ (0,1)` (for `p = 0`, `ℋ^{-1}(0) = 0`; for `p = 1`, `ℋ^{-1}(1) = +∞`), so it is stated for
`p ∈ (0,1)`. Uses: nothing. -/
theorem P05_S1 (p : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) :
    genInv Hcdf p = ((-(1 / Real.log p) : ℝ) : EReal) := by
  sorry

/-- S2. Source F:434 (second half): "so `1/ℋ^{-1}(F_X(1/x)) = -Log(F_X(1/x))`", written with
`F_X(1/x)` (NOT `F_X^-(1/x)`) exactly as printed, for `x > 0`; `-Log` read in `EReal` as in L02
(`-Log 0 = +∞`). Role: identifies the order's function with the super-heavy-tailed function.
Uses: S1 (and the endpoint values `p = 0, 1`, not discussed in the source). -/
theorem P05_S2 (μ : MeasureTheory.Measure ℝ) (x : ℝ) (hx : 0 < x) :
    recipE (genInv Hcdf (F μ (1 / x))) = negLogInv μ x := by
  sorry

/-- S3. Source F:431-435 (silent step): the order (F:424) uses `F_1^-(1/x)`, whereas the proof
works with `F_X(1/x)`; equivalently subadditivity of the order function (built from `F_X^-`)
is identified with subadditivity of the one built from `F_X`. No justification is printed
(candidate PAPER_ARGUMENT_GAP; the source also never reconciles `F_X(0)=0` in Def 4.9 with the
order). Stated as the bridge exactly needed by the proof.
Uses: nothing printed. -/
theorem P05_S3 (μ : MeasureTheory.Measure ℝ) :
    SubadditiveOnE (invSubFn (F μ) Hcdf) (Set.Ioi 0) ↔
      SubadditiveOnE (fun x => recipE (genInv Hcdf (F μ (1 / x)))) (Set.Ioi 0) := by
  sorry

/-- S4. Source F:431: `X` is super-heavy-tailed iff `F_X ≤_{i-sb} ℋ`. Assembly of S1-S3 (also
requires `F_X(0)=0`, part of `IsSuperHeavyTailed`, to be matched, see notes). -/
theorem P05_main (μ : MeasureTheory.Measure ℝ) : P05Conclusion μ := by
  sorry

end Paper.P05
