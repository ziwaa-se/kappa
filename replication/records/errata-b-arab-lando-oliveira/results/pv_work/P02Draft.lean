import P02Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P02

/-- Proposition 3.2 (prop:inf-mean), source :261-264.
"Let `X₁,…,Xₙ` be independent random variables such that `P(X₁=⋯=Xₙ)<1`, and `θ₁,…,θₙ>0`
with `θ₁+⋯+θₙ=1`. If (eq:main-st) holds, then `X` has infinite mean."
Encoding: `X` is not defined in the statement; following (eq:main-st) (:95-98) the `Xᵢ` are
i.i.d. copies of `X` (`IdentDistrib (Xs i) X`). No nonnegativity is assumed (none is printed). -/
theorem P02_main {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ)
    (hX : Measurable X) (hXs : ∀ i, Measurable (Xs i))
    (hindep : iIndepFun Xs μ)
    (hid : ∀ i, IdentDistrib (Xs i) X μ μ)
    (hne : μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1)
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hdom : StDom μ X (fun ω => ∑ i, θ i * Xs i ω)) :
    InfiniteMean μ X := by
  sorry

/-- S1. Source :266 "It is enough to prove the case n=2."  Reduction of general `n` to
`n = 2` (never justified in the source; INVENTORY X09). Uses: nothing (external to the n=2
argument). Role: reduces `P02_main` to `TwoCase`. -/
theorem P02_S1 (h2 : TwoCase) {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ)
    (hX : Measurable X) (hXs : ∀ i, Measurable (Xs i))
    (hindep : iIndepFun Xs μ)
    (hid : ∀ i, IdentDistrib (Xs i) X μ μ)
    (hne : μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1)
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hdom : StDom μ X (fun ω => ∑ i, θ i * Xs i ω)) :
    InfiniteMean μ X := by
  sorry

section TwoCaseSteps

variable {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
  (X X₁ X₂ : Ω → ℝ) (θ : ℝ)

/-- S2. Source :266 "Moreover, assume E(X) is finite. As then follows that E(Y)=E(X), both
finite". Hypotheses: `X₁, X₂` copies of `X`, `X` integrable.  Uses: nothing. -/
theorem P02_S2 (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hint : Integrable X μ) :
    Integrable (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) μ ∧
    ∫ ω, (θ * X₁ ω + (1 - θ) * X₂ ω) ∂μ = ∫ ω, X ω ∂μ := by
  sorry

/-- S3. Source :266 "this, together with (eq:main-st), implies that X and Y have the same
distribution." (`X ≤st Y`, both integrable, equal means). Uses S2. -/
theorem P02_S3 (Y : Ω → ℝ) (hX : Measurable X) (hY : Measurable Y)
    (hdom : StDom μ X Y) (hXi : Integrable X μ) (hYi : Integrable Y μ)
    (hmean : ∫ ω, Y ω ∂μ = ∫ ω, X ω ∂μ) :
    IdentDistrib X Y μ μ := by
  sorry

/-- S4a. Source :266 "Therefore Var(√X) = Var(√Y)".  Nonnegativity of `X` is NOT printed;
it is assumed here only because `√` is used (a silent assumption, INVENTORY X14/X15).
Uses S3. -/
theorem P02_S4a (Y : Ω → ℝ) (hid : IdentDistrib X Y μ μ) :
    variance (fun ω => Real.sqrt (X ω)) μ = variance (fun ω => Real.sqrt (Y ω)) μ := by
  sorry

/-- S4b. Source :266 "implying that E(√X) = E(√Y)".  The step uses `E X = E Y` (S2, premise
`hmean`) and `Var √X = E X - (E √X)²` (for `X ≥ 0` integrable), so `(E√X)² = (E√Y)²` and
`E√· ≥ 0` give the claim (gate: FAIR_IMPLICIT_STEP).  The drafter's earlier suspicion of a gap
is forwarded to pv-issue-checker.  Stated in the context of the proof (all hypotheses of
the case, including dominance and the variance equality), without the equal-distribution
conclusion of S3.  Finite variance of `√X` is not noted in the source. -/
theorem P02_S4b (Y : Ω → ℝ) (hX : Measurable X) (hY : Measurable Y)
    (hnn : ∀ ω, 0 ≤ X ω) (hnnY : ∀ ω, 0 ≤ Y ω)
    (hXi : Integrable X μ) (hYi : Integrable Y μ)
    (hmean : ∫ ω, Y ω ∂μ = ∫ ω, X ω ∂μ)
    (hdom : StDom μ X Y)
    (hvar : variance (fun ω => Real.sqrt (X ω)) μ = variance (fun ω => Real.sqrt (Y ω)) μ) :
    ∫ ω, Real.sqrt (X ω) ∂μ = ∫ ω, Real.sqrt (Y ω) ∂μ := by
  sorry

/-- S5. Source :266 "Jensen's inequality implies E√Y = E√(θX₁+(1-θ)X₂) > θE√X + (1-θ)E√X
= E√X, the inequality being strict because P(X₁≠X₂)>0."  Strict Jensen for the strictly
concave `√`; nonnegativity again silently assumed. -/
theorem P02_S5 (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hnn₁ : ∀ ω, 0 ≤ X₁ ω) (hnn₂ : ∀ ω, 0 ≤ X₂ ω)
    (hX₁i : Integrable X₁ μ) (hX₂i : Integrable X₂ μ)
    (hne : 0 < μ {ω | X₁ ω ≠ X₂ ω}) (hθ0 : 0 < θ) (hθ1 : θ < 1) :
    ∫ ω, Real.sqrt (X ω) ∂μ <
      ∫ ω, Real.sqrt (θ * X₁ ω + (1 - θ) * X₂ ω) ∂μ := by
  sorry

/-- S6. Source :266 "But this is not possible": S4b equality contradicts S5, so `E X` is not
finite.  Assembles S2-S5; yields `TwoCase` (with nonnegativity as silently assumed). -/
theorem P02_S6 (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hnn : ∀ ω, 0 ≤ X ω) (hnn₁ : ∀ ω, 0 ≤ X₁ ω) (hnn₂ : ∀ ω, 0 ≤ X₂ ω)
    (hind : IndepFun X₁ X₂ μ)
    (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hne : μ {ω | X₁ ω = X₂ ω} < 1) (hθ0 : 0 < θ) (hθ1 : θ < 1)
    (hdom : StDom μ X (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω)) :
    InfiniteMean μ X := by
  sorry

end TwoCaseSteps

end Paper.P02
