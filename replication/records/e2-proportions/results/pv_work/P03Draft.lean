import P03Stmt

namespace Paper.P03

open Paper.DEFS

/-- S1. main.tex:86, "We have $s^2(x+y) = s^2(x) + s^2(y)$."
Role: first step of the proof; reduces the claim to a sum of two variances.
Uses: nothing (the source gives no justification; the cross term 2*cov(x,y) is not
addressed; recorded as suspected PAPER_ARGUMENT_GAP / ERROR for this step, not repaired). -/
theorem P03_S1 (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 (x + y) = s2 x + s2 y := by
  sorry

/-- S2. main.tex:86-87, "$s^2(x)+s^2(y) \le 2s^2(x)+2s^2(y)$ because both terms are nonnegative."
Role: second step; finishes the inequality.
Uses: nonnegativity of s2 (implicit from Definition def:svar, main.tex:33); S1 for chaining. -/
theorem P03_S2 (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 x + s2 y ≤ 2 * s2 x + 2 * s2 y := by
  sorry

/-- Main theorem, main.tex:81-83 (prop:sum). Assembled from S1 and S2. -/
theorem P03_main (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) : P03Concl x y := by
  sorry

end Paper.P03
