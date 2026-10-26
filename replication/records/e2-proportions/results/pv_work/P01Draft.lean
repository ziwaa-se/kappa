import P01Stmt

namespace Paper.P01

open Paper.DEFS

/-- S0. main.tex:61, "It is well known that the function `p ↦ √(p(1-p))` is concave on `I`."
Role: the classical fact the proof invokes (asserted without proof in the source; supplied
from mathlib, e.g. `Real.strictConcaveOn_sqrt` and `ConcaveOn.comp`). Uses nothing earlier. -/
theorem P01_S0 : SqrtConcave := by
  sorry

/-- S1. main.tex:61, "The claim is the inequality defining concavity at the midpoint of
`p` and `q`": from `SqrtConcave` (S0), for `p q ∈ I`,
`(1/2)(√(p(1-p)) + √(q(1-q))) ≤ √(((p+q)/2)(1-(p+q)/2))`.
Role: concavity at the midpoint. Uses S0. -/
theorem P01_S1 (p q : ℝ) (hp : p ∈ IClosed) (hq : q ∈ IClosed) :
    (1 / 2) * (Real.sqrt (p * (1 - p)) + Real.sqrt (q * (1 - q))) ≤
      Real.sqrt (((p + q) / 2) * (1 - (p + q) / 2)) := by
  sorry

/-- S2. main.tex:61-62, "divided by `√n`": for `n ≥ 1` and real `x`,
`√(V_n x) = √(x(1-x)) / √n`. Role: scaling step. Uses nothing earlier. -/
theorem P01_S2 (n : ℕ) (hn : 1 ≤ n) (x : ℝ) :
    Real.sqrt (V n x) = Real.sqrt (x * (1 - x)) / Real.sqrt (n : ℝ) := by
  sorry

/-- S3. main.tex:61-62, dividing the S1 inequality by `√n > 0` gives the claim.
Uses S1, S2. -/
theorem P01_S3 (n : ℕ) (hn : 1 ≤ n) (p q : ℝ) :
    P01Claim n p q := by
  sorry

/-- Main theorem (Proposition 2.3, main.tex:55-58). Assemble from S0, S1, S2, S3. -/
theorem P01_main (n : ℕ) (hn : 1 ≤ n) :
    ∀ p q : ℝ, P01Claim n p q := by
  intro p q
  exact P01_S3 n hn p q

end Paper.P01
