import Defs

/-!
L03 statement definitions (main.tex:65-67, Lemma `lem:linear`).
Reading of `I` (main.tex:24, not specified in source): OPEN unit interval `Defs.IOpen`
(L02 precedent; the source proof does not use openness, and the suspected failure at p = 1/10
occurs in both readings).
-/

namespace Paper.L03

open Paper.DEFS

/-- main.tex:66: "For every `p ∈ I`, `V_n(p) ≤ p/(4n)`", with `n ≥ 1` (main.tex:24) as a
hypothesis in the theorem, and `I` read as `(0,1)` (`IOpen`). -/
def L03Claim (n : ℕ) (p : ℝ) : Prop := p ∈ IOpen → V n p ≤ p / (4 * (n : ℝ))

end Paper.L03
