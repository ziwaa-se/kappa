import Defs

namespace Paper.L02

/-- L02 conclusion (source/main.tex:54-56, lem:min): "ρ ≤ min{θ², σ²}".
Setting (main.tex:25): θ ≠ 0, σ > 0 are hypotheses of the theorem, not of this predicate. -/
def Conclusion (θ σ : ℝ) : Prop :=
  oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2)

end Paper.L02
