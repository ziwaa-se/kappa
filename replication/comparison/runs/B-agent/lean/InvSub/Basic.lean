import Mathlib

/-!
# Definitions and Lemma 2.3 (characterisation of InvSub)

A distribution is a probability measure `μ` on `ℝ`; `cdf μ` is its (right-continuous) CDF `F_X`.
For `x > 0`, `F^-_{1/X}(x) = P(1/X < x) = 1 - F_X(1/x)`.
-/

open MeasureTheory ProbabilityTheory Set

noncomputable section

/-- Definition 2.2: `X` is InvSub if `F_X(0) = 0` and `x ↦ 1 - F_X(1/x)` is subadditive on `(0,∞)`. -/
def InvSub (μ : Measure ℝ) : Prop :=
  cdf μ 0 = 0 ∧ ∀ x y : ℝ, 0 < x → 0 < y →
    1 - cdf μ (1 / (x + y)) ≤ (1 - cdf μ (1 / x)) + (1 - cdf μ (1 / y))

/-- Condition (2.3) of Lemma 2.3, for an arbitrary function `F`. -/
def Cond23 (F : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 0 ≤ x → ∀ θ : ℝ, 0 < θ → θ < 1 → F (x / θ) + F (x / (1 - θ)) ≤ F x + 1

/-- Lemma 2.3, real-function core: subadditivity of `1 - F(1/x)` on `(0,∞)` is equivalent
to (2.3), provided `F 0 ≤ 1` (needed only for the point `x = 0` of (2.3)). -/
theorem subadd_iff_cond23 (F : ℝ → ℝ) (h0 : F 0 ≤ 1) :
    (∀ x y : ℝ, 0 < x → 0 < y → 1 - F (1 / (x + y)) ≤ (1 - F (1 / x)) + (1 - F (1 / y)))
      ↔ Cond23 F := by
  constructor
  · intro h x hx θ hθ0 hθ1
    rcases hx.eq_or_lt with rfl | hx
    · simp; linarith
    have h1 : 0 < θ / x := by positivity
    have h2 : 0 < (1 - θ) / x := by apply div_pos <;> linarith
    have := h (θ / x) ((1 - θ) / x) h1 h2
    have e1 : 1 / (θ / x + (1 - θ) / x) = x := by field_simp
    have e2 : 1 / (θ / x) = x / θ := by field_simp
    have e3 : 1 / ((1 - θ) / x) = x / (1 - θ) := by field_simp
    rw [e1, e2, e3] at this
    linarith
  · intro h x y hx hy
    have hs : 0 < x + y := by linarith
    have hθ0 : 0 < x / (x + y) := by positivity
    have hθ1 : x / (x + y) < 1 := by rw [div_lt_one hs]; linarith
    have := h (1 / (x + y)) (by positivity) (x / (x + y)) hθ0 hθ1
    have e1 : 1 / (x + y) / (x / (x + y)) = 1 / x := by field_simp
    have e2 : 1 / (x + y) / (1 - x / (x + y)) = 1 / y := by
      have : 1 - x / (x + y) = y / (x + y) := by field_simp
      rw [this]; field_simp
    rw [e1, e2] at this
    linarith

/-- Lemma 2.3 (with the standing hypothesis `F_X(0) = 0` made explicit). -/
theorem lemma_2_3 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    InvSub μ ↔ cdf μ 0 = 0 ∧ Cond23 (cdf μ) := by
  unfold InvSub
  constructor
  · rintro ⟨h0, h⟩
    exact ⟨h0, (subadd_iff_cond23 _ (by rw [h0]; norm_num)).1 h⟩
  · rintro ⟨h0, h⟩
    exact ⟨h0, (subadd_iff_cond23 _ (by rw [h0]; norm_num)).2 h⟩

/-- Without the hypothesis `F_X(0)=0` the "iff" of Lemma 2.3 (as literally stated) fails:
the Dirac mass at `0` satisfies (2.3) but is not InvSub. -/
theorem lemma_2_3_needs_F0 :
    Cond23 (cdf (Measure.dirac (0 : ℝ))) ∧ ¬ InvSub (Measure.dirac (0 : ℝ)) := by
  have hF : ∀ x, cdf (Measure.dirac (0:ℝ)) x = if 0 ≤ x then 1 else 0 := by
    intro x
    rw [cdf_eq_real, measureReal_def, Measure.dirac_apply' _ measurableSet_Iic]
    by_cases hx : 0 ≤ x <;> simp [hx, Set.indicator]
  refine ⟨?_, ?_⟩
  · intro x hx θ hθ0 hθ1
    have a : 0 ≤ x / θ := div_nonneg hx hθ0.le
    have b : 0 ≤ x / (1 - θ) := div_nonneg hx (by linarith)
    rw [hF, hF, hF, if_pos a, if_pos b, if_pos hx]
  · rintro ⟨h0, -⟩
    rw [hF] at h0
    simp at h0

end
