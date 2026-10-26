import Defs

namespace Paper.L03

/-- source/main.tex:86 (Lemma lem:raw): `s^2 ≤ (1/n) ∑ x_i^2` (for `n ≥ 2`, which is a
hypothesis of the main theorem). -/
def Conclusion {n : ℕ} (x : Sample n) : Prop :=
  sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2

end Paper.L03
