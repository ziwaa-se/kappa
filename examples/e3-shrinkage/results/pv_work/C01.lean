import C01Stmt
import L01
import L02

namespace Paper.C01

open Paper

/-- S1. main.tex:79: by Lemma lem:square (L01) at c = 1/2 and at c = c*. -/
theorem C01_S1 (θ σ : ℝ) (h : Setting θ σ) :
    risk θ σ (1 / 2) - risk θ σ (oracleFactor θ σ)
      = (θ ^ 2 + σ ^ 2) * (1 / 2 - oracleFactor θ σ) ^ 2 := by
  have a := Paper.L01.L01 θ σ h (1 / 2)
  have b := Paper.L01.L01 θ σ h (oracleFactor θ σ)
  rw [sub_self] at b
  have b' : (θ ^ 2 + σ ^ 2) * 0 ^ 2 = 0 := by norm_num
  linarith

/-- S2. main.tex:79: "≥ 0" (standard). -/
theorem C01_S2 (θ σ : ℝ) (h : Setting θ σ) :
    0 ≤ (θ ^ 2 + σ ^ 2) * (1 / 2 - oracleFactor θ σ) ^ 2 := by
  positivity

/-- S3. main.tex:80: R(c*) = ρ, from L01 at c = c*. -/
theorem C01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    risk θ σ (oracleFactor θ σ) = oracleRisk θ σ := by
  have b := Paper.L01.L01 θ σ h (oracleFactor θ σ)
  rw [sub_self] at b
  have b' : (θ ^ 2 + σ ^ 2) * 0 ^ 2 = 0 := by norm_num
  linarith

/-- S4. main.tex:80-81: by Lemma lem:min (L02). -/
theorem C01_S4 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2) := by
  exact Paper.L02.L02_main θ σ h.theta_ne h.sigma_pos

/-- Corollary (source/main.tex:74-76): assemble from S1, S2. -/
theorem C01 (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ := by
  have h1 := C01_S1 θ σ h
  have h2 := C01_S2 θ σ h
  unfold Conclusion
  linarith

end Paper.C01
