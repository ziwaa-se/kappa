import L01Stmt

namespace Paper.L01

open Paper.DEFS

/-- S1. main.tex:43, expanding. -/
theorem L01_S1 (p : ℝ) : p * (1 - p) = 1 / 4 - (p - 1 / 2) ^ 2 := by
  ring

/-- S2. main.tex:43-44, (p-1/2)^2 ≥ 0 and n > 0. -/
theorem L01_S2 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : V n p ≤ 1 / (4 * (n : ℝ)) := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  have h1 := L01_S1 p
  have h2 : 0 ≤ (p - 1 / 2) ^ 2 := sq_nonneg _
  unfold V
  rw [h1, div_le_div_iff₀ hn' (by positivity)]
  nlinarith

/-- Main theorem, main.tex:38-40 (Lemma `lem:quarter`). -/
theorem L01_main (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : Conclusion n p :=
  ⟨L01_S1 p, L01_S2 n hn p⟩

end Paper.L01
