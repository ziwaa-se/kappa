import Mathlib

namespace Paper

/-- D04. Standing assumption (source/main.tex:25): "Throughout, θ ≠ 0 and σ > 0 are real numbers."
Encoded as a hypothesis structure; theorems take `(h : Setting θ σ)`. -/
structure Setting (θ σ : ℝ) : Prop where
  theta_ne : θ ≠ 0
  sigma_pos : 0 < σ

/-- D01. Risk (source/main.tex:28-29): "R(c) = c^2 σ^2 + (1-c)^2 θ^2". -/
noncomputable def risk (θ σ c : ℝ) : ℝ := c ^ 2 * σ ^ 2 + (1 - c) ^ 2 * θ ^ 2

/-- D02. Oracle factor (source/main.tex:30-31): "c* = θ^2 / (θ^2 + σ^2)". -/
noncomputable def oracleFactor (θ σ : ℝ) : ℝ := θ ^ 2 / (θ ^ 2 + σ ^ 2)

/-- D03. Oracle risk (source/main.tex:32-33): "ρ = θ^2 σ^2 / (θ^2 + σ^2)". -/
noncomputable def oracleRisk (θ σ : ℝ) : ℝ := θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2)

end Paper
