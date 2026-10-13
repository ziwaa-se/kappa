import L01Stmt

namespace Paper.L01

open Paper

/-- S1. source/main.tex:44: "Write s = θ²+σ², so that c* = θ²/s and 1 - c* = σ²/s."
Role: notation and the two identities used in the expansion. Needs s ≠ 0 (from Setting, implicit
division). Uses nothing. -/
theorem L01_S1 (θ σ : ℝ) (h : Setting θ σ) :
    oracleFactor θ σ = θ ^ 2 / (θ ^ 2 + σ ^ 2) ∧
    1 - oracleFactor θ σ = σ ^ 2 / (θ ^ 2 + σ ^ 2) := by
  sorry

/-- S2. source/main.tex:44-47: "For c = c* + d, R(c) = (c*+d)²σ² + (1-c*-d)²θ²."
Role: substitute c = c* + d into the definition of R. Uses nothing. -/
theorem L01_S2 (θ σ d : ℝ) :
    risk θ σ (oracleFactor θ σ + d)
      = (oracleFactor θ σ + d) ^ 2 * σ ^ 2 + (1 - oracleFactor θ σ - d) ^ 2 * θ ^ 2 := by
  sorry

/-- S3. source/main.tex:47-48 (first displayed equality): "(c*+d)²σ² + (1-c*-d)²θ² =
(θ⁴σ²+σ⁴θ²)/s² + 2d(θ²σ²/s - σ²θ²/s) + s d²", with s = θ²+σ².
Role: expansion of the squares using S1. Uses S1. -/
theorem L01_S3 (θ σ d : ℝ) (h : Setting θ σ) :
    (oracleFactor θ σ + d) ^ 2 * σ ^ 2 + (1 - oracleFactor θ σ - d) ^ 2 * θ ^ 2
      = (θ ^ 4 * σ ^ 2 + σ ^ 4 * θ ^ 2) / (θ ^ 2 + σ ^ 2) ^ 2
        + 2 * d * (θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2) - σ ^ 2 * θ ^ 2 / (θ ^ 2 + σ ^ 2))
        + (θ ^ 2 + σ ^ 2) * d ^ 2 := by
  sorry

/-- S4. source/main.tex:48-49 (second displayed equality): "(θ⁴σ²+σ⁴θ²)/s² +
2d(θ²σ²/s - σ²θ²/s) + s d² = ρ + s d²".
Role: constant term equals ρ and the linear term vanishes. Uses θ²+σ²>0 from Setting. -/
theorem L01_S4 (θ σ d : ℝ) (h : Setting θ σ) :
    (θ ^ 4 * σ ^ 2 + σ ^ 4 * θ ^ 2) / (θ ^ 2 + σ ^ 2) ^ 2
        + 2 * d * (θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2) - σ ^ 2 * θ ^ 2 / (θ ^ 2 + σ ^ 2))
        + (θ ^ 2 + σ ^ 2) * d ^ 2
      = oracleRisk θ σ + (θ ^ 2 + σ ^ 2) * d ^ 2 := by
  sorry

/-- S5. source/main.tex:49-51: "= ρ + s d², which is the claim."
Role: with d = c - c*, rearrange R(c) = ρ + s d² into the claim. Uses S2, S3, S4. -/
theorem L01_S5 (θ σ c : ℝ) (h : Setting θ σ) :
    risk θ σ c = oracleRisk θ σ + (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by
  sorry

/-- L01 main. source/main.tex:39-41: "For every c ∈ ℝ, R(c) - ρ = (θ²+σ²)(c - c*)²."
Assembled from S1-S5. -/
theorem L01 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    risk θ σ c - oracleRisk θ σ = (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by
  sorry

end Paper.L01
