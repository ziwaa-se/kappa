import L02Stmt

namespace Paper.L02

/-- S1. main.tex:53. -/
theorem L02_S1 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ = (1 / 2) * harmonicMean (θ ^ 2) (σ ^ 2) := by
  unfold oracleRisk harmonicMean
  ring

/-- S2. main.tex:54: stopped (false as stated: a=1, b=4). -/
theorem L02_S2 : HarmonicLeMin := by
  sorry

/-- S3. main.tex:54-55: S2 applied to θ², σ² (positive under Setting), rewritten via S1. -/
theorem L02_S3 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ (1 / 2) * min (θ ^ 2) (σ ^ 2) := by
  have hθ : 0 < θ ^ 2 := by have := h.theta_ne; positivity
  have hσ : 0 < σ ^ 2 := by have := h.sigma_pos; positivity
  have h2 := L02_S2 (θ ^ 2) (σ ^ 2) hθ hσ
  rw [L02_S1 θ σ h]
  linarith

/-- S4. main.tex:55. -/
theorem L02_S4 (θ σ : ℝ) (h : Setting θ σ) :
    (1 / 2) * min (θ ^ 2) (σ ^ 2) ≤ min (θ ^ 2) (σ ^ 2) := by
  have : 0 ≤ min (θ ^ 2) (σ ^ 2) := le_min (sq_nonneg _) (sq_nonneg _)
  linarith

/-- L02, main.tex:55: S3 then S4. -/
theorem L02 (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ :=
  le_trans (L02_S3 θ σ h) (L02_S4 θ σ h)

end Paper.L02
