import Defs

namespace Paper.P02

/-- source/main.tex:76: `z_j = (x_j - x̄)/s`.  Lean real division: if `s = 0` this is `0`;
the source does not treat `s = 0` (see notes). -/
noncomputable def z {n : ℕ} (x : Sample n) (j : Fin n) : ℝ :=
  (x j - sampleMean x) / sampleStd x

/-- source/main.tex:71-73 (Proposition prop:samuelson), conclusion for a sample `x`:
`|x_i - x̄| ≤ (n-1)/√n · s` for every `i`.  (The hypothesis `n ≥ 2` is in the theorem.) -/
def Conclusion {n : ℕ} (x : Sample n) : Prop :=
  ∀ i : Fin n, |x i - sampleMean x| ≤ ((n : ℝ) - 1) / Real.sqrt (n : ℝ) * sampleStd x

end Paper.P02
