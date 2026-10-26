import L03Stmt

namespace Paper.C01

/-- source/main.tex:94-96 (Corollary cor:unit): conclusion `s^2 ≤ 2`. -/
def Conclusion {n : ℕ} (x : Sample n) : Prop :=
  sampleVar x ≤ 2

/-- Provenance (p): consumed clause of predecessor L03 (Lemma lem:raw, source/main.tex:85-87,
sentence "Suppose that n ≥ 2. Then s^2 ≤ (1/n) ∑ x_i^2."), used at main.tex:99
("By Lemma lem:raw, s^2 ≤ (1/n) ∑ x_i^2").  Stated exactly as printed (this printed clause is
known to be false, issue B01; it is NOT repaired).  It is `Paper.L03.Conclusion x` for all
`n ≥ 2` and all samples `x`, unfolded to the printed formula. -/
def C01_L03Consumed : Prop :=
  ∀ (n : ℕ) (x : Sample n), 2 ≤ n →
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2

end Paper.C01
