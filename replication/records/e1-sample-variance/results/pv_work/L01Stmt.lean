import Defs

namespace Paper.L01

/-- source/main.tex:42-44 (Lemma lem:centred): `∑_{i=1}^n (x_i - x̄) = 0`. -/
def Conclusion {n : ℕ} (x : Sample n) : Prop :=
  ∑ i, (x i - sampleMean x) = 0

end Paper.L01
