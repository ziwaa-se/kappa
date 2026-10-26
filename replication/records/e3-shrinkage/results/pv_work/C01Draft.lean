import C01Stmt
import L01
import L02

namespace Paper.C01

open Paper

/-- S1. main.tex:79: "By Lemma lem:square, R(1/2) - R(c*) = (θ²+σ²)(1/2 - c*)²".
Role: the identity. Formally L01 at c = 1/2 minus L01 at c = c* (the latter gives
R(c*) - ρ = 0, see S3). Uses L01 (Paper.L01.L01). -/
theorem C01_S1 (θ σ : ℝ) (h : Setting θ σ) :
    risk θ σ (1 / 2) - risk θ σ (oracleFactor θ σ)
      = (θ ^ 2 + σ ^ 2) * (1 / 2 - oracleFactor θ σ) ^ 2 := by
  sorry

/-- S2. main.tex:79: "... ≥ 0" (θ²+σ² > 0 and a square; unstated, standard). Uses nothing. -/
theorem C01_S2 (θ σ : ℝ) (h : Setting θ σ) :
    0 ≤ (θ ^ 2 + σ ^ 2) * (1 / 2 - oracleFactor θ σ) ^ 2 := by
  sorry

/-- S3. main.tex:80: "R(c*) = ρ" (second sentence, a remark; follows from L01 at c = c*;
the source cites Lemma lem:min for it, which does not give it: editorial point; Definition 1.1,
main.tex:34, also says it). Not needed for the statement. Uses Paper.L01.L01. -/
theorem C01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    risk θ σ (oracleFactor θ σ) = oracleRisk θ σ := by
  sorry

/-- S4. main.tex:80-81: "By Lemma lem:min, moreover, ... ρ ≤ min{θ², σ²}".
Remark, not needed for the statement. Uses Paper.L02.L02_main. -/
theorem C01_S4 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2) := by
  sorry

/-- Corollary (source/main.tex:74-76): assemble from S1, S2. S3, S4 are remarks, not used. -/
theorem C01 (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ := by
  have h1 := C01_S1 θ σ h
  have h2 := C01_S2 θ σ h
  unfold Conclusion
  linarith

end Paper.C01
