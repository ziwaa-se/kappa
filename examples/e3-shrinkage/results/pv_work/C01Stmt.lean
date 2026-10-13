import Defs

namespace Paper.C01

open Paper

/-- Conclusion of Corollary (source/main.tex:74-76, label cor:half): "R(c*) ≤ R(1/2)".
Setting (main.tex:25) is a hypothesis of the theorem, not of this predicate. -/
def Conclusion (θ σ : ℝ) : Prop :=
  risk θ σ (oracleFactor θ σ) ≤ risk θ σ (1 / 2)

end Paper.C01
