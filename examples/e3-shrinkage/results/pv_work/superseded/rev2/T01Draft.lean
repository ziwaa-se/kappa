import T01Stmt
import L01

namespace Paper.T01

open Paper

/-- S1. main.tex:64: "By Lemma lem:square, R(c) - ρ = (θ²+σ²)(c - c*)² ≥ 0".
Role: gives R(c) ≥ ρ. Uses L01 (Paper.L01.L01) and θ²+σ²>0. -/
theorem T01_S1 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    oracleRisk θ σ ≤ risk θ σ c := by
  sorry

/-- S2. main.tex:64-65: "with equality if and only if c = c*, because θ²+σ² > 0".
Role: equality case. Uses L01 and θ²+σ²>0. -/
theorem T01_S2 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    risk θ σ c = oracleRisk θ σ ↔ c = oracleFactor θ σ := by
  sorry

/-- S3. main.tex:65: "Since R(0) = θ²" (unstated direct computation from Definition def:risk). -/
theorem T01_S3 (θ σ : ℝ) : risk θ σ 0 = θ ^ 2 := by
  sorry

/-- S4. main.tex:65: "and R(1) = σ²" (unstated direct computation). -/
theorem T01_S4 (θ σ : ℝ) : risk θ σ 1 = σ ^ 2 := by
  sorry

/-- S5. main.tex:65-66: "Lemma lem:min gives ρ ≤ min{R(0), R(1)}".
Role: last clause. Uses T01_L02Consumed (L02 conclusion), S3, S4. -/
theorem T01_S5 (hL02 : T01_L02Consumed) (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (risk θ σ 0) (risk θ σ 1) := by
  sorry

/-- Theorem (source/main.tex:58-61): assemble from S1-S5. -/
theorem T01 (hL02 : T01_L02Consumed) (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ :=
  ⟨T01_S1 θ σ h, T01_S2 θ σ h, T01_S5 hL02 θ σ h⟩

end Paper.T01
