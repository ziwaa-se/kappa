import Mathlib

/-!
# P04 statement definitions (Proposition 4.6, label prop:conv)
Source: source/SuperParetoPaper-v12.tex:315-318 (statement), 319-321 (proof).
No sorry, no theorems.
-/

open MeasureTheory Set

namespace Paper.P04

/-- cdf `F_X(x) = P(X ≤ x)` of the law `μ` (source :113). -/
noncomputable def F (μ : Measure ℝ) (x : ℝ) : ℝ := ProbabilityTheory.cdf μ x

/-- Survival function `Fbar_X = 1 - F_X`. -/
noncomputable def Fbar (μ : Measure ℝ) (x : ℝ) : ℝ := 1 - F μ x

/-- Odds function `Λ_X = F_X / Fbar_X` (source :301). -/
noncomputable def Lam (μ : Measure ℝ) (x : ℝ) : ℝ := F μ x / Fbar μ x

/-- Interior of the support of a cdf `G`: `{x | 0 < G x < 1}` (an interval). The source never states
the domain on which concavity/convexity of `Λ`, `1/Fbar`, `F2⁻¹∘F1` is meant; this is our choice
(see notes, encoding choice E3). -/
def suppIn (G : ℝ → ℝ) : Set ℝ := {x | 0 < G x ∧ G x < 1}

/-- Pareto(1) cdf `𝒫(x) = 1 - 1/x` for `x ≥ 1` (source :279), extended by `0` for `x < 1`. -/
noncomputable def paretoCdf (x : ℝ) : ℝ := if 1 ≤ x then 1 - 1 / x else 0

/-- Pareto(1) law (density `x⁻²` on `(1,∞)`); its cdf is `paretoCdf` (not proved here). -/
noncomputable def paretoMeasure : Measure ℝ :=
  volume.withDensity (fun x => if 1 < x then ENNReal.ofReal (1 / x ^ 2) else 0)

/-- Generalised inverse of an increasing function, source :111:
`v⁻¹(u) = sup {x ∈ ℝ | v x ≤ u}` (real `sSup`; meaningful for `u ∈ (0,1)` where the set is
nonempty and bounded above for the cdf's used here). -/
noncomputable def quantile (G : ℝ → ℝ) (u : ℝ) : ℝ := sSup {x | G x ≤ u}

/-- Definition 4.5 (source :308-311): `F1 ≤_c F2` iff `F2⁻¹ ∘ F1` is convex (on the interior of the
support of `F1`, our choice, notes E3). -/
def ConvexTransformLE (F1 F2 : ℝ → ℝ) : Prop :=
  ConvexOn ℝ (suppIn F1) (fun x => quantile F2 (F1 x))

/-- Definition 4.4 (source :304-307): `X` is DOR if `Λ_X` is concave. Since `Λ_X = F/Fbar` is
real-valued concave in the source, we require `Fbar_X > 0` everywhere (else `Λ_X = +∞` at the top
of the support) and concavity on `suppIn (F μ)` (domain choice E3, notes). -/
def DOR (μ : Measure ℝ) : Prop :=
  (∀ x, F μ x < 1) ∧ ConcaveOn ℝ (suppIn (F μ)) (Lam μ)

/-- "Increasing odds rate" (source :317): `λ_X = Λ_X'` increasing, i.e. `Λ_X` convex
(source :301 equivalence concave/decreasing rate, :323 uses convexity of `Λ_H`). -/
def IOR (μ : Measure ℝ) : Prop := ConvexOn ℝ (suppIn (F μ)) (Lam μ)

/-- Definition 4.1 (source :284-287): `Y =ᵈ h(Z)`, `Z ~ 𝒫`, `h` increasing, convex, nonconstant.
`h` is taken on `[1,∞)` (support of `Z`), measurable; "increasing" read as monotone (non-strict). -/
def SuperPareto (μ : Measure ℝ) : Prop :=
  ∃ h : ℝ → ℝ, Measurable h ∧ MonotoneOn h (Ici 1) ∧ ConvexOn ℝ (Ici 1) h ∧
    (∃ x ∈ Ici (1:ℝ), ∃ y ∈ Ici (1:ℝ), h x ≠ h y) ∧ μ = paretoMeasure.map h

/-- External input X01 (type (i)): Proposition 1 of superPareto2024, quoted as Prop 4.3
(source :296-299): `X` super-Pareto iff `1/Fbar_X` is (real-valued) concave, i.e. `Fbar_X > 0`
everywhere and concave on `suppIn (F μ)` (domain choice E3, notes). Used for the parenthetical
"or, equivalently, X is super-Pareto" (source :317). -/
def P04_X01Tool : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (SuperPareto μ ↔
      ((∀ x, F μ x < 1) ∧ ConcaveOn ℝ (suppIn (F μ)) (fun x => 1 / Fbar μ x)))

end Paper.P04
