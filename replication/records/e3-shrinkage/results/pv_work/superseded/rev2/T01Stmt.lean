import Defs
import L02Stmt

namespace Paper.T01

open Paper

/-- Conclusion of Theorem (source/main.tex:58-61, label thm:oracle), clauses separated.
(1) main.tex:59 "For every c, R(c) ≥ ρ"; (2) main.tex:59 "with equality iff c = c*";
(3) main.tex:60 "Moreover, ρ ≤ min{R(0), R(1)}". -/
structure Conclusion (θ σ : ℝ) : Prop where
  ge : ∀ c : ℝ, oracleRisk θ σ ≤ risk θ σ c
  eq_iff : ∀ c : ℝ, risk θ σ c = oracleRisk θ σ ↔ c = oracleFactor θ σ
  le_min : oracleRisk θ σ ≤ min (risk θ σ 0) (risk θ σ 1)

/-- Consumed clause (p) of Lemma L02 (source/main.tex:48-50, "ρ ≤ min{θ², σ²}"),
used at main.tex:66-67 ("Lemma~\ref{lem:min} gives ρ ≤ min{R(0), R(1)}").
Stated for all (θ, σ) satisfying the standing assumption (main.tex:25). The L02 proof has a
recorded issue; this is the lemma's conclusion only (L02.Conclusion). -/
def T01_L02Consumed : Prop :=
  ∀ θ σ : ℝ, Setting θ σ → Paper.L02.Conclusion θ σ

end Paper.T01
