import L02Stmt

namespace Paper.L02

open Paper.DEFS

/-- S1. main.tex:52, "For p ∈ I both p and 1 - p are positive" (open reading of `I`). -/
theorem L02_S1 (p : ℝ) (hp : p ∈ IOpen) : 0 < p ∧ 0 < 1 - p := by
  obtain ⟨h0, h1⟩ := hp
  exact ⟨h0, by linarith⟩

/-- S2. main.tex:52, "and n > 0" (from the convention n ≥ 1, main.tex:24). -/
theorem L02_S2 (n : ℕ) (hn : 1 ≤ n) : (0 : ℝ) < (n : ℝ) := by
  exact_mod_cast hn

/-- Main theorem, main.tex:47-49. Assemble from S1, S2 (product and quotient of positives). -/
theorem L02_main (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : L02Claim n p := by
  intro hp
  obtain ⟨h1, h2⟩ := L02_S1 p hp
  have h3 := L02_S2 n hn
  unfold V
  exact div_pos (mul_pos h1 h2) h3

end Paper.L02
