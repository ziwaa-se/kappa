import L01Stmt

namespace Paper.L01

open Paper

private theorem pos_of_setting {θ σ : ℝ} (h : Setting θ σ) : 0 < θ ^ 2 + σ ^ 2 := by
  have := h.sigma_pos
  positivity

/-- S1. source/main.tex:43 -/
theorem L01_S1 (θ σ c : ℝ) :
    risk θ σ c = (θ ^ 2 + σ ^ 2) * c ^ 2 - 2 * θ ^ 2 * c + θ ^ 2 := by
  unfold risk; ring

/-- S2. source/main.tex:43-44 (completing the square; uses S1) -/
theorem L01_S2 (θ σ c : ℝ) (h : Setting θ σ) :
    risk θ σ c = (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2
      + (θ ^ 2 - θ ^ 4 / (θ ^ 2 + σ ^ 2)) := by
  have hp := (pos_of_setting h).ne'
  rw [L01_S1]
  unfold oracleFactor
  field_simp
  ring

/-- S3. source/main.tex:44-45 -/
theorem L01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    θ ^ 2 - θ ^ 4 / (θ ^ 2 + σ ^ 2) = oracleRisk θ σ := by
  have hp := (pos_of_setting h).ne'
  unfold oracleRisk
  field_simp
  ring

/-- L01 main. source/main.tex:38-40 -/
theorem L01 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    risk θ σ c - oracleRisk θ σ = (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by
  rw [L01_S2 θ σ c h, L01_S3 θ σ h]
  ring

end Paper.L01
