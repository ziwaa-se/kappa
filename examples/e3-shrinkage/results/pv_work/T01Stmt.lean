import Defs

namespace Paper.T01

open Paper

/-- Conclusion of Theorem (source/main.tex:63-66, label thm:oracle), clauses separated.
(1) main.tex:64 "For every c, R(c) ≥ ρ"; (2) main.tex:64 "with equality iff c = c*";
(3) main.tex:64-65 "Moreover, ρ ≤ min{R(0), R(1)}". -/
structure Conclusion (θ σ : ℝ) : Prop where
  ge : ∀ c : ℝ, oracleRisk θ σ ≤ risk θ σ c
  eq_iff : ∀ c : ℝ, risk θ σ c = oracleRisk θ σ ↔ c = oracleFactor θ σ
  le_min : oracleRisk θ σ ≤ min (risk θ σ 0) (risk θ σ 1)

end Paper.T01
