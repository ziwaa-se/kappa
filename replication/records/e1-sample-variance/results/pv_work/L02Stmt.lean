import Defs

namespace Paper.L02

/-- source/main.tex:51 (Lemma lem:shortcut):
`∑ (x_i - x̄)^2 = ∑ x_i^2 - n x̄^2`. -/
def Conclusion {n : ℕ} (x : Sample n) : Prop :=
  ∑ i, (x i - sampleMean x) ^ 2 = ∑ i, (x i) ^ 2 - (n : ℝ) * (sampleMean x) ^ 2

end Paper.L02
