import T04Stmt

namespace Paper.T04

open Paper.L01 Paper.L02 MeasureTheory

private lemma F_le_one (μ : Measure ℝ) [IsProbabilityMeasure μ] (x : ℝ) : F μ x ≤ 1 :=
  ProbabilityTheory.cdf_le_one μ x

private lemma F_nonneg (μ : Measure ℝ) [IsProbabilityMeasure μ] (x : ℝ) : 0 ≤ F μ x :=
  ProbabilityTheory.cdf_nonneg μ x

theorem T04_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ)
    {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (hFx : 0 < F μ (1 / x)) (hFy : 0 < F μ (1 / y)) :
    0 < F μ (1 / (x + y)) ∧
      Real.log (F μ (1 / x)) + Real.log (F μ (1 / y)) ≤ Real.log (F μ (1 / (x + y))) := by
  have hsub := h.2 x hx y hy
  unfold negLogInv at hsub
  rw [if_neg hFx.ne', if_neg hFy.ne'] at hsub
  by_cases h0 : F μ (1 / (x + y)) = 0
  · rw [if_pos h0] at hsub
    exfalso
    rw [← EReal.coe_add] at hsub
    exact absurd (top_le_iff.mp hsub) (EReal.coe_ne_top _)
  · rw [if_neg h0, ← EReal.coe_add, EReal.coe_le_coe_iff] at hsub
    have hpos : 0 < F μ (1 / (x + y)) := lt_of_le_of_ne (F_nonneg μ _) (Ne.symm h0)
    exact ⟨hpos, by linarith⟩

theorem T04_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ)
    {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (hFx : 0 < F μ (1 / x)) (hFy : 0 < F μ (1 / y)) :
    Real.exp (Real.log (F μ (1 / x)) + Real.log (F μ (1 / y))) ≤ F μ (1 / (x + y)) := by
  obtain ⟨hp, hl⟩ := T04_S1 μ h hx hy hFx hFy
  calc _ ≤ Real.exp (Real.log (F μ (1 / (x + y)))) := Real.exp_le_exp.mpr hl
    _ = _ := Real.exp_log hp

theorem T04_S3 {a b : ℝ} (ha : a ≤ 0) (hb : b ≤ 0) :
    Real.exp a + Real.exp b - 1 ≤ Real.exp (a + b) := by
  have h1 : Real.exp a ≤ 1 := Real.exp_le_one_iff.mpr ha
  have h2 : Real.exp b ≤ 1 := Real.exp_le_one_iff.mpr hb
  rw [Real.exp_add]
  nlinarith [mul_nonneg (sub_nonneg.mpr h1) (sub_nonneg.mpr h2)]

theorem T04_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    {x y : ℝ} (hFx : 0 < F μ (1 / x)) (hFy : 0 < F μ (1 / y)) :
    F μ (1 / x) + F μ (1 / y) - 1 ≤
      Real.exp (Real.log (F μ (1 / x)) + Real.log (F μ (1 / y))) := by
  have ha : Real.log (F μ (1 / x)) ≤ 0 := Real.log_nonpos hFx.le (F_le_one μ _)
  have hb : Real.log (F μ (1 / y)) ≤ 0 := Real.log_nonpos hFy.le (F_le_one μ _)
  have := T04_S3 ha hb
  rwa [Real.exp_log hFx, Real.exp_log hFy] at this

theorem T04_S4z (μ : Measure ℝ) [IsProbabilityMeasure μ]
    {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (h0 : F μ (1 / x) = 0 ∨ F μ (1 / y) = 0) :
    F μ (1 / x) + F μ (1 / y) - 1 ≤ F μ (1 / (x + y)) := by
  have h1 := F_le_one μ (1 / x)
  have h2 := F_le_one μ (1 / y)
  have h3 := F_nonneg μ (1 / (x + y))
  rcases h0 with h0 | h0 <;> rw [h0] <;> linarith

theorem T04_S5 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ)
    (hchain : ∀ x y : ℝ, 0 < x → 0 < y →
      F μ (1 / x) + F μ (1 / y) - 1 ≤ F μ (1 / (x + y))) :
    IsInvSub μ := by
  refine ⟨h.1, ?_⟩
  intro x hx y hy
  have := hchain x y hx hy
  unfold invDist
  linarith

theorem T04_main (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h : IsSuperHeavyTailed μ) : IsInvSub μ := by
  refine T04_S5 μ h ?_
  intro x y hx hy
  by_cases hFx : 0 < F μ (1 / x)
  · by_cases hFy : 0 < F μ (1 / y)
    · exact (T04_S4 μ hFx hFy).trans (T04_S2 μ h hx hy hFx hFy)
    · exact T04_S4z μ hx hy (Or.inr (le_antisymm (not_lt.mp hFy) (F_nonneg μ _)))
  · exact T04_S4z μ hx hy (Or.inl (le_antisymm (not_lt.mp hFx) (F_nonneg μ _)))

end Paper.T04
