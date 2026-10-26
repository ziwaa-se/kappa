import L02Stmt

namespace Paper.L02

open Paper.L01

/-- Main theorem, Lemma 4.10 (F:359-366), as printed. Suspected paper issue (F:361 vs F:346):
the lemma omits "such that F_X(0)=0", which `IsSuperHeavyTailed` includes (Def 4.9); the "if"
direction then lacks the conjunct `F_X(0)=0` (e.g. X ≡ 0). No extra hypothesis is assumed. -/
theorem L02_main (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ] :
    IsSuperHeavyTailed μ ↔ InvNWUCond μ := by
  sorry

/-- S1 (F:358, "straightforward"; no proof printed). Forward direction, positive `x`:
subadditivity of `-Log F(1/·)` at the pair `(θ s, (1-θ) s)` with `s = 1/x`, exponentiated,
gives `F(x/θ) F(x/(1-θ)) ≤ F(x)`. Includes the `F = 0` (`-Log = +∞`) cases. Uses nothing else. -/
theorem L02_S1 (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ]
    (h : IsSuperHeavyTailed μ) :
    ∀ x : ℝ, 0 < x → ∀ θ : ℝ, θ ∈ Set.Ioo (0:ℝ) 1 →
      F μ (x / θ) * F μ (x / (1 - θ)) ≤ F μ x := by
  sorry

/-- S2 (F:358). Case `x = 0` of eq:inv-NWU: `F(0)F(0) ≤ F(0)`, from `F(0)=0` (Def 4.9 convention). -/
theorem L02_S2 (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ]
    (h0 : F μ 0 = 0) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F μ (0 / θ) * F μ (0 / (1 - θ)) ≤ F μ 0 := by
  sorry

/-- S3 (F:358). Converse: for `x,y>0`, take `x_0 = 1/(x+y)`, `θ = x/(x+y)` in eq:inv-NWU,
take `-Log` (with `+∞` when a factor is `0`) to get `-Log F(1/(x+y)) ≤ -Log F(1/x) - Log F(1/y)`.
Uses nothing else. -/
theorem L02_S3 (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ]
    (h : InvNWUCond μ) :
    SubadditiveOnE (negLogInv μ) (Set.Ioi 0) := by
  sorry

end Paper.L02
