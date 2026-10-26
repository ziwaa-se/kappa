import Defs

/-!
L02 statement definitions (main.tex:47-49, Lemma `lem:positive`).
Reading of `I` (main.tex:24, not specified in source): OPEN unit interval `Defs.IOpen`.
-/

namespace Paper.L02

open Paper.DEFS

/-- main.tex:48: "For every `p ∈ I`, `V_n(p) > 0`", with `n ≥ 1` (main.tex:24) and
`I` read as the open interval `(0,1)` (`IOpen`). -/
def L02Claim (n : ℕ) (p : ℝ) : Prop := p ∈ IOpen → 0 < V n p

end Paper.L02
