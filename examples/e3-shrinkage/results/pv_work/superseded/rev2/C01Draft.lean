import C01Stmt
import L01

namespace Paper.C01

open Paper

/-- S1. main.tex:74: "By Lemma lem:square, R(1/2) - R(c*) = (θ²+σ²)(1/2 - c*)² ≥ 0".
Display part: the identity. Uses L01 at c = 1/2 and at c = c* (R(c*) - ρ = 0 via L01; the source
applies the lemma to the difference directly). -/
theorem C01_S1 (θ σ : ℝ) (h : Setting θ σ) :
    risk θ σ (1 / 2) - risk θ σ (oracleFactor θ σ)
      = (θ ^ 2 + σ ^ 2) * (1 / 2 - oracleFactor θ σ) ^ 2 := by
  sorry

/-- S2. main.tex:74: "... ≥ 0" (θ²+σ² > 0 and a square; unstated, standard). -/
theorem C01_S2 (θ σ : ℝ) (h : Setting θ σ) :
    0 ≤ (θ ^ 2 + σ ^ 2) * (1 / 2 - oracleFactor θ σ) ^ 2 := by
  sorry

/-- S3. main.tex:75: "R(c*) = ρ" (second sentence, remark; follows from L01 at c = c*).
Not needed for the statement. Uses L01. -/
theorem C01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    risk θ σ (oracleFactor θ σ) = oracleRisk θ σ := by
  sorry

/-- S4. main.tex:75-76: "By Lemma lem:min, moreover, ... ρ ≤ min{θ², σ²}".
Remark, not needed for the statement. Uses C01_L02Consumed. -/
theorem C01_S4 (hL02 : C01_L02Consumed) (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2) := by
  sorry

/-- Corollary (source/main.tex:69-71): assemble from S1, S2. -/
theorem C01 (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ := by
  have h1 := C01_S1 θ σ h
  have h2 := C01_S2 θ σ h
  unfold Conclusion
  linarith

end Paper.C01
