import T01Stmt
import L01
import L02

namespace Paper.T01

open Paper

/-- S1. source/main.tex:69: "By Lemma 2.1, R(c) - ρ = (θ²+σ²)(c - c*)² ≥ 0, with equality iff
c = c*, because θ²+σ² > 0."  Role: clauses (1) and (2). Uses `Paper.L01.L01`
(main theorem of L01) and θ²+σ² > 0 (from Setting, main.tex:25). -/
theorem T01_S1 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    oracleRisk θ σ ≤ risk θ σ c ∧
      (risk θ σ c = oracleRisk θ σ ↔ c = oracleFactor θ σ) := by
  sorry

/-- S2. source/main.tex:70: "Since R(0) = θ² and R(1) = σ²". Direct computation from
Definition 1.1 (main.tex:28-29). Role: rewrites the min in clause (3). Uses no earlier step. -/
theorem T01_S2 (θ σ : ℝ) : risk θ σ 0 = θ ^ 2 ∧ risk θ σ 1 = σ ^ 2 := by
  sorry

/-- S3. source/main.tex:70-71: "Lemma 2.2 gives ρ ≤ min{R(0), R(1)}". Role: clause (3).
Uses `Paper.L02.L02_main` and S2. -/
theorem T01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (risk θ σ 0) (risk θ σ 1) := by
  sorry

/-- Main theorem, source/main.tex:63-66 (proof 68-72): assembled from S1, S3. -/
theorem T01_main (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ :=
  ⟨fun c => (T01_S1 θ σ h c).1, fun c => (T01_S1 θ σ h c).2, T01_S3 θ σ h⟩

end Paper.T01
