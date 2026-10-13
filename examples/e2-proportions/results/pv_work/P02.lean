import P02Stmt
import L01

namespace Paper.P02

open Paper.DEFS

/-- S1. main.tex:78, "By Lemma lem:quarter" : for every `n ≥ 1`, `p`,
`V_n(p) ≤ 1/(4n)`. Role: the only input. Uses L01 (`Paper.L01.L01_main`). -/
theorem P02_S1 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : V n p ≤ 1 / (4 * (n : ℝ)) :=
  (Paper.L01.L01_main n hn p).2

/-- S2. main.tex:78, "`C = 1/4` works": `1/(4n) = (1/4)/n`, so `C = 1/4` satisfies the
claim for all `n ≥ 1` and all `p`. Uses S1. -/
theorem P02_S2 : ∃ C : ℝ, C = 1 / 4 ∧ ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, V n p ≤ C / (n : ℝ) := by
  refine ⟨1 / 4, rfl, fun n hn p => ?_⟩
  have h := P02_S1 n hn p
  have e : (1 : ℝ) / 4 / (n : ℝ) = 1 / (4 * (n : ℝ)) := by
    rw [div_div]
  rw [e]; exact h

/-- Main theorem, main.tex:73-75 (Proposition `prop:uniform`). Assembles from S1, S2. -/
theorem P02_main : Conclusion := by
  obtain ⟨C, _, h⟩ := P02_S2
  exact ⟨C, h⟩

end Paper.P02
