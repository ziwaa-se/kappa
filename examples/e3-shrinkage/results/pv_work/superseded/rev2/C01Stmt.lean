import Defs
import L02Stmt

namespace Paper.C01

open Paper

/-- Conclusion of Corollary (source/main.tex:69-71, label cor:half): "R(c*) ≤ R(1/2)". -/
def Conclusion (θ σ : ℝ) : Prop :=
  risk θ σ (oracleFactor θ σ) ≤ risk θ σ (1 / 2)

/-- Consumed clause (p) of Lemma L02 (source/main.tex:48-50, "ρ ≤ min{θ², σ²}"),
used only by the second proof sentence (main.tex:75-76), which is a remark not needed for the
statement. For all (θ, σ) satisfying the standing assumption (main.tex:25). -/
def C01_L02Consumed : Prop :=
  ∀ θ σ : ℝ, Setting θ σ → Paper.L02.Conclusion θ σ

end Paper.C01
