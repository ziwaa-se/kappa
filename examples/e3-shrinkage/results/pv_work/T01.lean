import T01Stmt
import L01
import L02

namespace Paper.T01

open Paper

/-- S1. source/main.tex:69. -/
theorem T01_S1 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    oracleRisk θ σ ≤ risk θ σ c ∧
      (risk θ σ c = oracleRisk θ σ ↔ c = oracleFactor θ σ) := by
  -- main.tex:69 "By Lemma 2.1"
  have hL := Paper.L01.L01 θ σ h c
  -- main.tex:69 "because θ²+σ² > 0"
  have hs : 0 < θ ^ 2 + σ ^ 2 := by
    have := h.theta_ne
    have := h.sigma_pos
    positivity
  constructor
  · have : 0 ≤ (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by positivity
    linarith
  · constructor
    · intro he
      have h0 : (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 = 0 := by linarith
      rcases mul_eq_zero.mp h0 with h1 | h1
      · exact absurd h1 hs.ne'
      · have := pow_eq_zero_iff (two_ne_zero) |>.mp h1
        linarith
    · intro he
      rw [he] at hL ⊢
      linarith

/-- S2. source/main.tex:70. -/
theorem T01_S2 (θ σ : ℝ) : risk θ σ 0 = θ ^ 2 ∧ risk θ σ 1 = σ ^ 2 := by
  unfold risk
  constructor <;> ring

/-- S3. source/main.tex:70-71. -/
theorem T01_S3 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (risk θ σ 0) (risk θ σ 1) := by
  obtain ⟨h0, h1⟩ := T01_S2 θ σ
  rw [h0, h1]
  exact Paper.L02.L02_main θ σ h.theta_ne h.sigma_pos

/-- Main theorem, source/main.tex:63-66 (proof 68-72): assembled from S1, S3. -/
theorem T01_main (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ :=
  ⟨fun c => (T01_S1 θ σ h c).1, fun c => (T01_S1 θ σ h c).2, T01_S3 θ σ h⟩

end Paper.T01
