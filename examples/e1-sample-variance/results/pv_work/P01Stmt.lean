import Defs

namespace Paper.P01

/-- External input (provenance (i): external result cited by the source, source/main.tex:66-67,
bib :103-106, Popoviciu 1935).  Popoviciu's inequality on variances, as a closed statement
quantified over all samples: for every `n ≥ 1`, `a b` and sample `x` with all `x_i ∈ [a,b]`,
`(1/n) ∑ (x_i - x̄)² ≤ (b-a)²/4`.
mathlib only has the probabilistic form `ProbabilityTheory.variance_le_sq_of_bounded`,
no finite-sample/`Fin n` interface, hence kept as a parameter. -/
def Popoviciu : Prop :=
  ∀ (n : ℕ) (a b : ℝ) (x : Sample n), 1 ≤ n → (∀ i, a ≤ x i ∧ x i ≤ b) →
    (1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4

end Paper.P01
