import L02Stmt

namespace Paper.L02

/-- S1. source/main.tex:59. -/
theorem L02_S1 (θ σ : ℝ) (hθ : θ ≠ 0) (hσ : 0 < σ) :
    θ ^ 2 + σ ^ 2 > σ ^ 2 ∧ σ ^ 2 > 0 := by
  have h1 : 0 < θ ^ 2 := by positivity
  have h2 : 0 < σ ^ 2 := by positivity
  exact ⟨by linarith, h2⟩

/-- S2. source/main.tex:60: ρ < θ². Uses S1. -/
theorem L02_S2 (θ σ : ℝ) (hθ : θ ≠ 0) (hσ : 0 < σ) :
    oracleRisk θ σ < θ ^ 2 := by
  obtain ⟨h1, h2⟩ := L02_S1 θ σ hθ hσ
  have h0 : 0 < θ ^ 2 := by positivity
  unfold oracleRisk
  rw [div_lt_iff₀ (by linarith)]
  nlinarith

/-- S3. source/main.tex:60: ρ < σ². -/
theorem L02_S3 (θ σ : ℝ) (hθ : θ ≠ 0) (hσ : 0 < σ) :
    oracleRisk θ σ < σ ^ 2 := by
  obtain ⟨h1, h2⟩ := L02_S1 θ σ hθ hσ
  have h0 : 0 < θ ^ 2 := by positivity
  unfold oracleRisk
  rw [div_lt_iff₀ (by linarith)]
  nlinarith

/-- Main theorem, source/main.tex:54-56. -/
theorem L02_main (θ σ : ℝ) (hθ : θ ≠ 0) (hσ : 0 < σ) : Conclusion θ σ := by
  unfold Conclusion
  exact le_min (L02_S2 θ σ hθ hσ).le (L02_S3 θ σ hθ hσ).le

end Paper.L02
