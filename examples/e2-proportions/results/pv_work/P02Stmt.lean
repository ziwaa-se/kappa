import Defs

namespace Paper.P02

open Paper.DEFS

/-- main.tex:73-74 (Proposition `prop:uniform`): there is a constant `C` such that
`V_n(p) ≤ C/n` for every `n ≥ 1` and every `p ∈ ℝ`. `C` is chosen before `n` and `p`. -/
def Conclusion : Prop :=
  ∃ C : ℝ, ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, V n p ≤ C / (n : ℝ)

end Paper.P02
