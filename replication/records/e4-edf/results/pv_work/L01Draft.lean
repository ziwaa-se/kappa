import L01Stmt

namespace Paper.L01

open Paper.Defs

/-- S1. source/main.tex:41: "If `s ≤ t`, every `i` with `x_i ≤ s` also satisfies `x_i ≤ t`, so
`F_n(s) ≤ F_n(t)`." Role: clause 1 (monotonicity). Uses no earlier step or external input. -/
theorem L01_S1 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) : Monotone (edf x) := by
  sorry

/-- S2. source/main.tex:41-42: "The number `n F_n(t)` counts a subset of `{1,…,n}`."
Role: clause 2 (`n F_n(t) ∈ {0,…,n}`). Uses no earlier step or external input. -/
theorem L01_S2 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) (t : ℝ) :
    ∃ k : ℕ, k ∈ Finset.range (n + 1) ∧ (n : ℝ) * edf x t = (k : ℝ) := by
  sorry

/-- Main theorem, main.tex:35-38 (`n ≥ 1` from Definition 1.1, main.tex:25). Assembled from S1, S2. -/
theorem L01_main {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) : Conclusion x :=
  ⟨L01_S1 hn x, L01_S2 hn x⟩

end Paper.L01
