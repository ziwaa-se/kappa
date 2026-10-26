import L02Stmt

namespace Paper.L02

open Paper.L01

private lemma F_nonneg (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ] (x : ℝ) :
    0 ≤ F μ x := ProbabilityTheory.cdf_nonneg μ x

/-- S1 (F:358, "straightforward"; no proof printed). -/
theorem L02_S1 (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ]
    (h : IsSuperHeavyTailed μ) :
    ∀ x : ℝ, 0 < x → ∀ θ : ℝ, θ ∈ Set.Ioo (0:ℝ) 1 →
      F μ (x / θ) * F μ (x / (1 - θ)) ≤ F μ x := by
  intro x hx θ hθ
  obtain ⟨hθ0, hθ1⟩ := hθ
  have h1θ : 0 < 1 - θ := by linarith
  have hs : 0 < 1 / x := by positivity
  have hsub := h.2 (θ * (1 / x)) (Set.mem_Ioi.2 (by positivity)) ((1 - θ) * (1 / x))
    (Set.mem_Ioi.2 (by positivity))
  have e1 : 1 / (θ * (1 / x)) = x / θ := by field_simp
  have e2 : 1 / ((1 - θ) * (1 / x)) = x / (1 - θ) := by field_simp
  have e3 : θ * (1 / x) + (1 - θ) * (1 / x) = 1 / x := by ring
  have e4 : (1:ℝ) / (1 / x) = x := by field_simp
  rw [e3] at hsub
  unfold negLogInv at hsub
  rw [e1, e2, e4] at hsub
  have hA := F_nonneg μ (x / θ)
  have hB := F_nonneg μ (x / (1 - θ))
  have hC := F_nonneg μ x
  by_cases hAz : F μ (x / θ) = 0
  · rw [hAz]; simpa using hC
  by_cases hBz : F μ (x / (1 - θ)) = 0
  · rw [hBz]; simpa using hC
  have hAp : 0 < F μ (x / θ) := lt_of_le_of_ne hA (Ne.symm hAz)
  have hBp : 0 < F μ (x / (1 - θ)) := lt_of_le_of_ne hB (Ne.symm hBz)
  by_cases hCz : F μ x = 0
  · exfalso
    rw [if_pos hCz, if_neg hAz, if_neg hBz] at hsub
    have : ((-Real.log (F μ (x / θ)) : ℝ) : EReal) + ((-Real.log (F μ (x / (1 - θ))) : ℝ) : EReal) < ⊤ := by
      rw [← EReal.coe_add]; exact EReal.coe_lt_top _
    exact absurd (lt_of_le_of_lt hsub this) (lt_irrefl _)
  · have hCp : 0 < F μ x := lt_of_le_of_ne hC (Ne.symm hCz)
    rw [if_neg hCz, if_neg hAz, if_neg hBz, ← EReal.coe_add, EReal.coe_le_coe_iff] at hsub
    have hl : Real.log (F μ (x / θ) * F μ (x / (1 - θ))) ≤ Real.log (F μ x) := by
      rw [Real.log_mul hAz hBz]; linarith
    exact (Real.log_le_log_iff (mul_pos hAp hBp) hCp).1 hl

/-- S2 (F:358). -/
theorem L02_S2 (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ]
    (h0 : F μ 0 = 0) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F μ (0 / θ) * F μ (0 / (1 - θ)) ≤ F μ 0 := by
  simp [h0]

/-- S3 (F:358). -/
theorem L02_S3 (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ]
    (h : InvNWUCond μ) :
    SubadditiveOnE (negLogInv μ) (Set.Ioi 0) := by
  intro x hx y hy
  have hx : 0 < x := hx
  have hy : 0 < y := hy
  have hxy : 0 < x + y := by linarith
  have hθ : x / (x + y) ∈ Set.Ioo (0:ℝ) 1 := by
    constructor
    · positivity
    · rw [div_lt_one hxy]; linarith
  have key := h (1 / (x + y)) (by positivity) _ hθ
  have e1 : 1 / (x + y) / (x / (x + y)) = 1 / x := by field_simp
  have e2 : 1 / (x + y) / (1 - x / (x + y)) = 1 / y := by
    have : 1 - x / (x + y) = y / (x + y) := by field_simp
    rw [this]; field_simp
  rw [e1, e2] at key
  have hA := F_nonneg μ (1 / x)
  have hB := F_nonneg μ (1 / y)
  have hC := F_nonneg μ (1 / (x + y))
  unfold negLogInv
  by_cases hAz : F μ (1 / x) = 0
  · rw [if_pos hAz]
    have : ∀ a : EReal, a ≠ ⊥ → (⊤ : EReal) + a = ⊤ := fun a ha => EReal.top_add_of_ne_bot ha
    rw [this]
    · exact le_top
    · split_ifs <;> simp
  by_cases hBz : F μ (1 / y) = 0
  · rw [if_pos hBz]
    have : ∀ a : EReal, a ≠ ⊥ → a + (⊤ : EReal) = ⊤ := fun a ha => EReal.add_top_of_ne_bot ha
    rw [this]
    · exact le_top
    · split_ifs <;> simp
  have hAp : 0 < F μ (1 / x) := lt_of_le_of_ne hA (Ne.symm hAz)
  have hBp : 0 < F μ (1 / y) := lt_of_le_of_ne hB (Ne.symm hBz)
  have hCp : 0 < F μ (1 / (x + y)) := lt_of_lt_of_le (mul_pos hAp hBp) key
  have hCz : F μ (1 / (x + y)) ≠ 0 := hCp.ne'
  rw [if_neg hCz, if_neg hAz, if_neg hBz, ← EReal.coe_add, EReal.coe_le_coe_iff]
  have := (Real.log_le_log_iff (mul_pos hAp hBp) hCp).2 key
  rw [Real.log_mul hAz hBz] at this
  linarith

/-- Main theorem, Lemma 4.10 (F:359-366), as printed. Suspected paper issue (F:361 vs F:346):
the lemma omits "such that F_X(0)=0", which `IsSuperHeavyTailed` includes (Def 4.9); the "if"
direction then lacks the conjunct `F_X(0)=0` (e.g. X ≡ 0). No extra hypothesis is assumed. -/
theorem L02_main (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ] :
    IsSuperHeavyTailed μ ↔ InvNWUCond μ := by
  constructor
  · intro h x hx θ hθ
    rcases hx.eq_or_lt with h0 | hpos
    · rw [← h0]; exact L02_S2 μ h.1 θ hθ
    · exact L02_S1 μ h x hpos θ hθ
  · intro h
    refine ⟨?_, L02_S3 μ h⟩
    -- STOPPED: F:361-364 give no F_X(0)=0 in the right-hand side; not derivable
    -- (counterexample μ = dirac 0).
    sorry

end Paper.L02
