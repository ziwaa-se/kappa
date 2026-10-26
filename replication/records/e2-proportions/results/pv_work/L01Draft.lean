import L01Stmt

namespace Paper.L01

open Paper.DEFS

/-- S1. main.tex:43, "Expanding, 1/4 - (p-1/2)^2 = 1/4 - p^2 + p - 1/4 = p(1-p)".
Role: first clause (identity). Uses nothing. -/
theorem L01_S1 (p : ℝ) : p * (1 - p) = 1 / 4 - (p - 1 / 2) ^ 2 := by
  sorry

/-- S2. main.tex:43-44, "Since (p-1/2)^2 ≥ 0 and n > 0, the bound follows."
Role: second clause V_n(p) ≤ 1/(4n). Uses S1. -/
theorem L01_S2 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : V n p ≤ 1 / (4 * (n : ℝ)) := by
  sorry

/-- Main theorem, main.tex:38-40 (Lemma `lem:quarter`). Convention n ≥ 1 (main.tex:24). -/
theorem L01_main (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : Conclusion n p :=
  ⟨L01_S1 p, L01_S2 n hn p⟩

end Paper.L01
