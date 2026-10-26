import Defs

namespace Paper.L01

open Paper.DEFS

/-- main.tex:38-39 (Lemma `lem:quarter`), conclusion for given `n` and `p`:
clause 1: `p(1-p) = 1/4 - (p-1/2)^2`; clause 2: `V_n(p) ≤ 1/(4n)`. -/
structure Conclusion (n : ℕ) (p : ℝ) : Prop where
  identity : p * (1 - p) = 1 / 4 - (p - 1 / 2) ^ 2
  bound : V n p ≤ 1 / (4 * (n : ℝ))

end Paper.L01
