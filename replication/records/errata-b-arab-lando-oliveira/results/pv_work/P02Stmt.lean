import Mathlib

open MeasureTheory ProbabilityTheory

namespace Paper.P02

/-- Definition 2.1 (source :115-118): `X ≤st Y` iff `F̄_X(x) ≤ F̄_Y(x)` for every real `x`,
where `F̄_X(x) = P(X > x)`. -/
def StDom {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) (X Y : Ω → ℝ) : Prop :=
  ∀ x : ℝ, μ {ω | x < X ω} ≤ μ {ω | x < Y ω}

/-- Conclusion of Proposition 3.2 (source :263): "`X` has infinite mean".
Encoding: `X` is not integrable (for a real-valued `X`; for nonnegative `X` this is `E X = ∞`).
See notes: the source never says `X` is nonnegative. -/
def InfiniteMean {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) (X : Ω → ℝ) : Prop :=
  ¬ Integrable X μ

/-- The case `n = 2` of Proposition 3.2 as used in the proof (source :266), written with the
same hypotheses as the proposition specialised to `n = 2`, `θ₁ = θ`, `θ₂ = 1 - θ`.
Used only as the hypothesis of step obligation S1 (the reduction "it is enough to prove n = 2"). -/
def TwoCase : Prop :=
  ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X X₁ X₂ : Ω → ℝ) (θ : ℝ),
    Measurable X → Measurable X₁ → Measurable X₂ →
    IndepFun X₁ X₂ μ →
    IdentDistrib X₁ X μ μ → IdentDistrib X₂ X μ μ →
    μ {ω | X₁ ω = X₂ ω} < 1 →
    0 < θ → θ < 1 →
    StDom μ X (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) →
    InfiniteMean μ X

end Paper.P02
