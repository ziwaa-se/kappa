import Defs

namespace Paper.L01

open Paper.Defs

/-- L01 conclusion, source/main.tex:35-38 (Lemma `lem:steps`):
"For every `x ∈ ℝ^n`, `F_n` is nondecreasing, and `n F_n(t) ∈ {0,1,…,n}` for every `t ∈ ℝ`."
Two clauses, kept separate. -/
structure Conclusion {n : ℕ} (x : Fin n → ℝ) : Prop where
  /-- clause 1: `F_n` is nondecreasing (main.tex:36). -/
  mono : Monotone (edf x)
  /-- clause 2: `n F_n(t) ∈ {0,…,n}` for every `t` (main.tex:36-37). -/
  values : ∀ t : ℝ, ∃ k : ℕ, k ∈ Finset.range (n + 1) ∧ (n : ℝ) * edf x t = (k : ℝ)

end Paper.L01
