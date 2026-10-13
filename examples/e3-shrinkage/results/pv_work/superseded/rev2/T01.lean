import T01Stmt
import L01

namespace Paper.T01

open Paper

/-- S1. main.tex:64: "By Lemma lem:square, R(c) - ρ = (θ²+σ²)(c - c*)² ≥ 0". -/
theorem T01_S1 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    oracleRisk θ σ ≤ risk θ σ c := by
  have h1 := Paper.L01.L01 θ σ h c
  have hp : 0 < θ ^ 2 + σ ^ 2 := by have := h.sigma_pos; positivity
  have : 0 ≤ (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 := by positivity
  linarith

/-- S2. main.tex:64-65: equality iff c = c*, because θ²+σ² > 0. -/
theorem T01_S2 (θ σ : ℝ) (h : Setting θ σ) (c : ℝ) :
    risk θ σ c = oracleRisk θ σ ↔ c = oracleFactor θ σ := by
  have h1 := Paper.L01.L01 θ σ h c
  have hp : 0 < θ ^ 2 + σ ^ 2 := by have := h.sigma_pos; positivity
  constructor
  · intro he
    have h0 : (θ ^ 2 + σ ^ 2) * (c - oracleFactor θ σ) ^ 2 = 0 := by
      rw [← h1, he]; ring
    rcases mul_eq_zero.mp h0 with h2 | h2
    · exact absurd h2 hp.ne'
    · have := (pow_eq_zero_iff two_ne_zero).mp h2
      linarith
  · intro hc
    have : risk θ σ c - oracleRisk θ σ = 0 := by rw [h1, hc]; ring
    linarith

/-- S3. main.tex:65: R(0) = θ². -/
theorem T01_S3 (θ σ : ℝ) : risk θ σ 0 = θ ^ 2 := by
  unfold risk; ring

/-- S4. main.tex:65: R(1) = σ². -/
theorem T01_S4 (θ σ : ℝ) : risk θ σ 1 = σ ^ 2 := by
  unfold risk; ring

/-- S5. main.tex:65-66: Lemma lem:min gives ρ ≤ min{R(0), R(1)}. -/
theorem T01_S5 (hL02 : T01_L02Consumed) (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ min (risk θ σ 0) (risk θ σ 1) := by
  rw [T01_S3, T01_S4]
  exact hL02 θ σ h

/-- Theorem (source/main.tex:58-61): assemble from S1-S5. -/
theorem T01 (hL02 : T01_L02Consumed) (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ :=
  ⟨T01_S1 θ σ h, T01_S2 θ σ h, T01_S5 hL02 θ σ h⟩

end Paper.T01
