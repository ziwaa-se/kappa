import L01Stmt

namespace Paper.L01

open Paper

/-- S1. source/main.tex:43: "Expanding the squares, R(c) = (θ²+σ²)c² - 2θ²c + θ²."
Role: polynomial form of the risk. Uses nothing. -/
theorem L01_S1 (θ σ c : ℝ) :
    risk θ σ c = (θ ^ 2 + σ ^ 2) * c ^ 2 - 2 * θ ^ 2 * c + θ ^ 2 := by
  sorry

/-- S2. source/main.tex:43-44: "Completing the square gives
R(c) = (θ²+σ²)(c - c*)² + θ² - θ⁴/(θ²+σ²)."
Role: completed-square form; needs θ²+σ²>0 (from Setting, implicit division). Uses S1. -/
theorem L01_S2 (θ σ c : ℝ) (h : Setting θ σ) :
    risk θ σ c = (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2
      + (θ ^ 2 - θ ^ 4 / (θ ^ 2 + σ ^ 2)) := by
  sorry

/-- S3. source/main.tex:44-45: "θ² - θ⁴/(θ²+σ²) = ρ".
Role: identify the constant with the oracle risk. Uses θ²+σ²>0 from Setting. -/
theorem L01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    θ ^ 2 - θ ^ 4 / (θ ^ 2 + σ ^ 2) = oracleRisk θ σ := by
  sorry

/-- L01 main. source/main.tex:38-40: "For every c ∈ ℝ, R(c) - ρ = (θ²+σ²)(c - c*)²."
Assembled from S2, S3 (S1 feeds S2). -/
theorem L01 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    risk θ σ c - oracleRisk θ σ = (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by
  sorry

end Paper.L01
