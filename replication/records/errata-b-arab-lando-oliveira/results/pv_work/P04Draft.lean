import P04Stmt

/-!
# P04 draft (Proposition 4.6, prop:conv), source/SuperParetoPaper-v12.tex:315-318, proof 319-321
-/

open MeasureTheory Set

namespace Paper.P04

/-- S1 (source :320): "the quantile of the Pareto is `𝒫⁻¹(u) = 1/(1-u)`", with `𝒫⁻¹` the
generalised inverse of :111 (`sup {x | 𝒫 x ≤ u}`; here the set is `(-∞, 1/(1-u)]`).
Role: computation of `𝒫⁻¹`. Uses nothing. -/
theorem P04_S1 (u : ℝ) (hu0 : 0 < u) (hu1 : u < 1) :
    quantile paretoCdf u = 1 / (1 - u) := by sorry

/-- S2 (source :320): "`𝒫⁻¹∘F_X = 1/Fbar_X = Λ_X + 1`" (on the interior of the support).
Role: the displayed computation (with the :111 sup-inverse). Uses S1. -/
theorem P04_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] (x : ℝ) (hx : x ∈ suppIn (F μ)) :
    quantile paretoCdf (F μ x) = 1 / Fbar μ x ∧ 1 / Fbar μ x = Lam μ x + 1 := by sorry

/-- S3 (source :320-317, "so the result follows"): `F_X ≤_c 𝒫` iff `F_X` has increasing odds rate.
By the definition :310 and S2 this is convexity of `Λ_X + 1`. Uses S2. -/
theorem P04_S3 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    ConvexTransformLE (F μ) paretoCdf ↔ IOR μ := by sorry

/-- S4 (source :320, "the result follows immediately"): `𝒫 ≤_c F_X` iff `F_X` is DOR.
GAP OBLIGATION (INVENTORY X13): by definition :310 this needs `F_X⁻¹∘𝒫` convex, whereas
S2 only gives concavity of `𝒫⁻¹∘F_X`; the passage between a concave increasing function and
convexity of its (generalised, :111) inverse is not in the source. Do not fill in. Uses S2.
`hnd` is a candidate TFA (Dirac laws excluded, see notes). -/
theorem P04_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hnd : ∀ c : ℝ, μ ≠ Measure.dirac c) :
    DOR μ ↔ ConvexTransformLE paretoCdf (F μ) := by sorry

/-- S5 (source :317, "or, equivalently, X is super-Pareto"): DOR iff super-Pareto,
by external X01 (Prop 4.3, :296-299) and `Λ_X = 1/Fbar_X - 1` (:301). -/
theorem P04_S5 (hX01 : P04_X01Tool) (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    DOR μ ↔ SuperPareto μ := by sorry

/-- Main theorem (Proposition 4.6, source :315-318), three clauses. -/
theorem P04_main (hX01 : P04_X01Tool) (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hnd : ∀ c : ℝ, μ ≠ Measure.dirac c) :
    (DOR μ ↔ ConvexTransformLE paretoCdf (F μ)) ∧
    (SuperPareto μ ↔ ConvexTransformLE paretoCdf (F μ)) ∧
    (IOR μ ↔ ConvexTransformLE (F μ) paretoCdf) :=
  ⟨P04_S4 μ hnd, (P04_S5 hX01 μ).symm.trans (P04_S4 μ hnd), (P04_S3 μ).symm⟩

end Paper.P04
