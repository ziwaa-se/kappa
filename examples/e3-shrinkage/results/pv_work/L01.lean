import L01Stmt

namespace Paper.L01

open Paper

private lemma s_ne (θ σ : ℝ) (h : Setting θ σ) : θ ^ 2 + σ ^ 2 ≠ 0 := by
  have h1 := sq_pos_of_ne_zero h.theta_ne
  have h2 := sq_pos_of_pos h.sigma_pos
  exact ne_of_gt (add_pos h1 h2)

/-- S1. source/main.tex:44. -/
theorem L01_S1 (θ σ : ℝ) (h : Setting θ σ) :
    oracleFactor θ σ = θ ^ 2 / (θ ^ 2 + σ ^ 2) ∧
    1 - oracleFactor θ σ = σ ^ 2 / (θ ^ 2 + σ ^ 2) := by
  have hs := s_ne θ σ h
  refine ⟨rfl, ?_⟩
  unfold oracleFactor
  field_simp

/-- S2. source/main.tex:44-47. -/
theorem L01_S2 (θ σ d : ℝ) :
    risk θ σ (oracleFactor θ σ + d)
      = (oracleFactor θ σ + d) ^ 2 * σ ^ 2 + (1 - oracleFactor θ σ - d) ^ 2 * θ ^ 2 := by
  unfold risk
  ring

/-- S3. source/main.tex:47-48. -/
theorem L01_S3 (θ σ d : ℝ) (h : Setting θ σ) :
    (oracleFactor θ σ + d) ^ 2 * σ ^ 2 + (1 - oracleFactor θ σ - d) ^ 2 * θ ^ 2
      = (θ ^ 4 * σ ^ 2 + σ ^ 4 * θ ^ 2) / (θ ^ 2 + σ ^ 2) ^ 2
        + 2 * d * (θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2) - σ ^ 2 * θ ^ 2 / (θ ^ 2 + σ ^ 2))
        + (θ ^ 2 + σ ^ 2) * d ^ 2 := by
  have hs := s_ne θ σ h
  unfold oracleFactor
  field_simp
  ring

/-- S4. source/main.tex:48-49. -/
theorem L01_S4 (θ σ d : ℝ) (h : Setting θ σ) :
    (θ ^ 4 * σ ^ 2 + σ ^ 4 * θ ^ 2) / (θ ^ 2 + σ ^ 2) ^ 2
        + 2 * d * (θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2) - σ ^ 2 * θ ^ 2 / (θ ^ 2 + σ ^ 2))
        + (θ ^ 2 + σ ^ 2) * d ^ 2
      = oracleRisk θ σ + (θ ^ 2 + σ ^ 2) * d ^ 2 := by
  have hs := s_ne θ σ h
  unfold oracleRisk
  field_simp
  ring

/-- S5. source/main.tex:49-51. -/
theorem L01_S5 (θ σ c : ℝ) (h : Setting θ σ) :
    risk θ σ c = oracleRisk θ σ + (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by
  have e2 := L01_S2 θ σ (c - oracleFactor θ σ)
  have e3 := L01_S3 θ σ (c - oracleFactor θ σ) h
  have e4 := L01_S4 θ σ (c - oracleFactor θ σ) h
  have hc : oracleFactor θ σ + (c - oracleFactor θ σ) = c := by ring
  have hc' : 1 - oracleFactor θ σ - (c - oracleFactor θ σ) = 1 - c := by ring
  rw [hc] at e2
  rw [hc'] at e2
  rw [hc, hc'] at e3
  rw [e2, e3, e4]

/-- L01 main. source/main.tex:39-41. -/
theorem L01 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    risk θ σ c - oracleRisk θ σ = (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by
  have := L01_S5 θ σ c h
  linarith

end Paper.L01
