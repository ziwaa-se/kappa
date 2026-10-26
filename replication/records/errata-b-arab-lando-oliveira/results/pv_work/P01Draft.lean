import P01Stmt

open MeasureTheory ProbabilityTheory Set

namespace Paper.P01

/-- Main theorem. Source :148-151 (Proposition 2.5): "Assume the nonnegative random variable `X`
has density `f_X` such that its hazard rate `r_X(x) = f_X(x)/Fbar_X(x) ≤ 1/x`, for `x>0`.
Then `X` is InvSub."  `X` is represented by its law `μ` (probability measure, no mass on `(-∞,0)`),
density `f` w.r.t. Lebesgue measure. -/
theorem P01_main
    (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hnn : μ (Iio 0) = 0)
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    InvSub μ := by
  sorry

/-- S1. Source :124 / :153 (implicit: Def 2.2 requires `F_X(0)=0`).
"We say that a random variable X such that F_X(0)=0 is InvSub".
Role: first component of `InvSub`; follows from nonnegativity and the density (no atom at 0).
Uses: nothing else. -/
theorem P01_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hnn : μ (Iio 0) = 0)
    (f : ℝ → ENNReal) (hdens : μ = volume.withDensity f) : F μ 0 = 0 := by
  sorry

/-- S2. Source :153 (implicit, never stated): the density `f` is the a.e. derivative of `F_X`,
so `F_X` is differentiable with derivative `f` at almost every `u`. Needed for "the derivative of ...".
Uses: nothing. -/
theorem P01_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f) :
    ∀ᵐ u ∂(volume : Measure ℝ), HasDerivAt (F μ) (f u).toReal u := by
  sorry

/-- S3. Source :153: "the derivative of `(1/x)(1-F_X(1/x))` has the same sign as
`(1/x) f_X(1/x) + F_X(1/x) - 1`." Precisely: where `F` has derivative `d` at `1/x`,
`g(x)=(1/x)(1-F(1/x))` has derivative `x⁻² * ((1/x) d + F(1/x) - 1)` at `x>0`.
Uses: nothing. -/
theorem P01_S3 (μ : Measure ℝ) (x d : ℝ) (hx : 0 < x) (hd : HasDerivAt (F μ) d (1 / x)) :
    HasDerivAt (fun t => (1 / t) * (1 - F μ (1 / t)))
      ((x ^ 2)⁻¹ * ((1 / x) * d + F μ (1 / x) - 1)) x := by
  sorry

/-- S4. Source :153: "which, according to the assumption, is easily seen to be negative"
(the hypothesis gives only `≤ 0`). A.e. version in the density context: on `{Fbar > 0}` it is
the hazard bound; on `{Fbar = 0}`, `f = 0` a.e. since `μ` puts no mass there (implicit step D2).
Uses: hypothesis `hhaz`, `hdens`. -/
theorem P01_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    ∀ᵐ x ∂(volume : Measure ℝ), 0 < x →
      (1 / x) * (f (1 / x)).toReal + F μ (1 / x) - 1 ≤ 0 := by
  sorry

/-- S5. Source :153: "It follows that `1-F_X(1/x)` is anti-star-shaped": `x ↦ (1/x)(1-F_X(1/x))`
is non-increasing on `(0,∞)`. (Passing from a.e. nonpositive derivative to monotonicity is not
written in the source.) Uses: S2, S3, S4. -/
theorem P01_S5 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    AntitoneOn (fun x => invDist μ x / x) (Ioi 0) := by
  sorry

/-- S6. Source :153: "as it vanishes at zero": `1 - F_X(1/x) → 0` as `x → 0+`, i.e. `F_X(∞)=1`;
justifies that the extension `vExt` with `vExt 0 = 0` is anti-star-shaped on `[0,∞)`.
Uses: S5. -/
theorem P01_S6 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h5 : AntitoneOn (fun x => invDist μ x / x) (Ioi 0)) :
    AntiStarShaped (vExt μ) := by
  sorry

/-- S7. Source :153: "therefore, it is subadditive". Uses: S6; standard
anti-star-shaped ⇒ subadditive argument, proved in place. -/
theorem P01_S7 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h6 : AntiStarShaped (vExt μ)) : SubadditiveOnPos (invDist μ) := by
  sorry

end Paper.P01
