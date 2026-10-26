import T02Stmt

/-!
# T02 draft (source/VSIFP_02.tex:153-172 statement; proof l.429-463)

Statement of Theorem 3.2 and step obligations S1-S15 (all `sorry`).  Common hypotheses are those
of Theorem 3.1 (l.154 "Under the assumptions of Theorem 3.1"), encoded as in `T01Draft`
(`hcons`, `hrep : MixtureRep S ν`, `p q ∈ (0,1)`, `p ≠ q`, `ν[min,max) > 0`), plus `π₁ ∈ [0,1] \ H_S`.
Notation in docstrings: `d(y) = S(p,y) - S(q,y)`, `g(λ) = growthRate S p q π₁ λ`, `h = d(1)/d(0)`.
-/

open MeasureTheory Filter Topology

namespace Paper.T02

section Steps

variable (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : T01.MixtureRep S ν)
  (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
  (hν : 0 < ν (Set.Ico (min p q) (max p q))) (π₁ : ℝ) (hπ : π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q)

include hcons hrep hp hq hpq hν hπ

/-- S1 (l.430-434, "g(λ) = E_{π₁}[log E_{p,q;λ}(Y)] = (1-π₁) log[1 - λ d(0)/d(1{p>q})] + π₁ log[1 - λ d(1)/d(1{p>q})]").
Role: rewrite the growth rate using `E_{p,q;λ}(y) = 1 - λ d(y)/d(1{p>q})`, valid when
`d(1{p>q}) < 0` (so `|d(1{p>q})| = -d(1{p>q})`; sign from S2/S2').  Uses S2 (hypothesis `hD`). -/
theorem T02_S1
    (hD : S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0) < 0) (lam : ℝ) :
    growthRate S p q π₁ lam =
      (1 - π₁) * Real.log (1 - lam * ((S p 0 - S q 0) /
          (S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)))) +
      π₁ * Real.log (1 - lam * ((S p 1 - S q 1) /
          (S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)))) := by
  sorry

/-- S2 (l.435, "Consider the case p < q. Under this assumption d(0) < 0 < d(1)").
Role: sign of `d`.  Source gives no justification here; it is the same fact as l.407 of the proof of
Theorem 3.1 (mixture representation and `ν{[p,q)} > 0`).  Uses `hrep`.  (Case `p > q`, l.462:
`d(1) < 0 < d(0)`, never stated; see S15.) -/
theorem T02_S2 (hlt : p < q) : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1 := by
  sorry

/-- S3a (l.435, "g is continuous in λ with g(0) = 0 and lim_{λ→1} g(λ) = -∞"), case `p < q`.
Role: boundary behaviour of `g` on `[0,1)`.  Uses S2.  Note (recorded, not repaired): for `π₁ = 1`
(which lies in `[0,1] \ H_S`) `g(λ) = log(1 - λ h)` has a finite limit at `1`, so the printed limit
claim fails there. -/
theorem T02_S3a (hlt : p < q) :
    ContinuousOn (growthRate S p q π₁) (Set.Ico 0 1) ∧ growthRate S p q π₁ 0 = 0 ∧
      Tendsto (growthRate S p q π₁) (𝓝[<] 1) atBot := by
  sorry

/-- S3b (l.435, "so a maximum is attained at some λ ∈ [0,1)"), case `p < q`.
Role: existence of a maximizer of `g` on `[0,1)`.  Uses S3a (intermediate-value/compactness
argument is implicit). -/
theorem T02_S3b (hlt : p < q) :
    ∃ l ∈ Set.Ico (0:ℝ) 1, ∀ l' ∈ Set.Ico (0:ℝ) 1, growthRate S p q π₁ l' ≤ growthRate S p q π₁ l := by
  sorry

/-- S4 (l.435-439, "Define h = d(1)/d(0) < 0, so that g(λ) = (1-π₁) log(1-λ) + π₁ log(1-λh),
g'(λ) = -(1-π₁)/(1-λ) - π₁ h/(1-λh)"), case `p < q`.  Role: explicit form and derivative of `g` on
`[0,1)`.  Uses S1, S2. -/
theorem T02_S4 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    h < 0 ∧ ∀ lam ∈ Set.Ico (0:ℝ) 1,
      growthRate S p q π₁ lam = (1 - π₁) * Real.log (1 - lam) + π₁ * Real.log (1 - lam * h) ∧
      HasDerivAt (growthRate S p q π₁) (-(1 - π₁) / (1 - lam) - π₁ * h / (1 - lam * h)) lam := by
  sorry

/-- S5 (l.440-443, "g'(λ₀) = 0 ⟺ λ₀ = π₁ + (1-π₁)/h"), case `p < q`, `h < 0`.  Role: critical point.
Uses S4. -/
theorem T02_S5 (h : ℝ) (hh : h < 0) (hπ' : π₁ ∈ Set.Icc (0:ℝ) 1) (l0 : ℝ) (hl0 : l0 ∈ Set.Ico (0:ℝ) 1) :
    (-(1 - π₁) / (1 - l0) - π₁ * h / (1 - l0 * h) = 0) ↔ l0 = π₁ + (1 - π₁) / h := by
  sorry

/-- S6 (l.444-447, "π₁ ∉ H_S ⟺ E_{π₁}{d(Y)} > 0 ⟺ π₁ + (1-π₁)/h > 0"), case `p < q`.
Role: translate the alternative into positivity of `λ₀`.  Uses S2. -/
theorem T02_S6 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0))
    (hπ' : π₁ ∈ Set.Icc (0:ℝ) 1) :
    (π₁ ∉ HS S p q ↔ 0 < expPi π₁ (fun y => S p y - S q y)) ∧
      (0 < expPi π₁ (fun y => S p y - S q y) ↔ 0 < π₁ + (1 - π₁) / h) := by
  sorry

/-- S7 (l.448, "we indeed have λ₀ > 0 for all π₁ ∉ H_S"), case `p < q`, `λ₀ = π₁ + (1-π₁)/h`.
Uses S6. -/
theorem T02_S7 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    0 < π₁ + (1 - π₁) / h := by
  sorry

/-- S8 (SILENT, X06; not stated in the source).  The proof passes from "a maximum is attained in
`[0,1)` (l.435)" and "`g'(λ₀) = 0 ⟺ λ₀ = …` (l.442)" and "`λ₀ > 0` (l.448)" to "`λ₀` is *the*
maximizer".  Needed but never written: `λ₀ < 1` (the source only shows `λ₀ > 0`; at `π₁ = 1`,
`λ₀ = 1 ∉ [0,1)`), that the maximum is not at the endpoint `0` (`g'(0) > 0`), and uniqueness
(strict concavity of `g`).  Recorded as an obligation only: if it is false for some admissible `π₁`
it is a `PAPER_ARGUMENT_GAP`/`EXPOSITION_GAP` candidate, not to be repaired.  Case `p < q`.
Uses S3b, S4, S5, S7. -/
theorem T02_S8 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    π₁ + (1 - π₁) / h < 1 ∧
      ∀ l ∈ Set.Ico (0:ℝ) 1, l ≠ π₁ + (1 - π₁) / h →
        growthRate S p q π₁ l < growthRate S p q π₁ (π₁ + (1 - π₁) / h) := by
  sorry

/-- S9 (l.430, l.435, "a maximum ... λ ∈ [0,1)" vs the family `λ ∈ (0,1]` of eq:representation;
A09), case `p < q`.  Role: the first clause of the theorem (l.154-159) for `p < q`: `λ` maximizes
`g` over the family `(0,1]` (with `GrowFinite`) iff `λ = π₁ + (1-π₁) d(0)/d(1)`.  The source does
not discuss the passage from `[0,1)` to `(0,1]` (`λ = 1`).  Uses S8, S7, S1. (Consumed clause
`hT01` is the sentence l.430 "All e-values … are of the form (6)", used to identify the e-values
with the family.) -/
theorem T02_S9 (hT01 : T02_T01Consumed) (hlt : p < q) :
    ∀ lam : ℝ, IsGrowLambda S p q π₁ lam ↔ lam = growLambda S p q π₁ := by
  sorry

/-- S10 (l.449-453), case `p < q`: with `λ₀ = π₁ + (1-π₁)/h`,
`E(0) = 1 - λ₀ = (1-π₁)(1 - 1/h) = (1-π₁)(d(1)-d(0))/d(1)` and
`E(1) = 1 - λ₀ d(1)/d(0) = π₁ (d(0)-d(1))/d(0)`.  Role: closed form of the optimal e-value.
Uses S2, S7. -/
theorem T02_S10 (hlt : p < q) :
    Erep S p q (growLambda S p q π₁) 0 =
        (1 - π₁) * (((S p 1 - S q 1) - (S p 0 - S q 0)) / (S p 1 - S q 1)) ∧
      Erep S p q (growLambda S p q π₁) 1 =
        π₁ * (((S p 0 - S q 0) - (S p 1 - S q 1)) / (S p 0 - S q 0)) := by
  sorry

/-- S11 (l.454, "With d(y) = ∫ 1{p ≤ θ < q}(θ - y) dν(θ)"), case `p < q`, `y ∈ {0,1}`, AS PRINTED.
Role: express `d` through `ν`.  Source gives no justification beyond eq:mixture.  SUSPECTED SIGN
ERROR: from `S_θ(p,0) = θ 1{θ<p}` and `S_θ(p,1) = -(1-θ)1{θ ≥ p}` one gets
`d(y) = -∫ 1{p ≤ θ < q}(θ - y) dν` (indeed `d(0) < 0` by l.435 while the printed integral is `> 0`).
Recorded, not repaired.  Uses `hrep`. -/
theorem T02_S11 (hlt : p < q) (y : ℝ) (hy : y ∈ ({0, 1} : Set ℝ)) :
    S p y - S q y = ∫ θ in Set.Icc (0:ℝ) 1, (if p ≤ θ ∧ θ < q then θ - y else 0) ∂ν := by
  sorry

/-- S12 (l.455-457, `(d(1)-d(0))/d(1) = -ν{[p,q)} / (-ν{[p,q)} + ∫_{[p,q)} θ dν) = 1/(1-κ_ν{[p,q)})`),
case `p < q`.  Role: identify the denominator of `E(0)`.  Stated with the quantity itself (the
ratio is insensitive to the sign issue of S11).  Uses S11/S2, `hν`. -/
theorem T02_S12 (hlt : p < q) :
    ((S p 1 - S q 1) - (S p 0 - S q 0)) / (S p 1 - S q 1) = 1 / (1 - kappa ν p q) := by
  sorry

/-- S13a (l.459-460, "1 - h = (d(0)-d(1))/d(0) = 1/κ_ν{[p,q)}"), case `p < q`.
Role: identify the factor of `E(1)`.  Uses S11/S2, `hν`. -/
theorem T02_S13a (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    1 - h = ((S p 0 - S q 0) - (S p 1 - S q 1)) / (S p 0 - S q 0) ∧ 1 - h = 1 / kappa ν p q := by
  sorry

/-- S13b (l.460, "1/κ_ν{[p,q)} > 1/π₁" for `π₁ ∉ H_S`), case `p < q`.  Role: remark; uses that
`π₁ ∉ H_S ⟺ π₁ > κ` (not stated in the source; the equivalence `1/κ > 1/π₁ ⟺ π₁ ∉ H_S` is
X06).  Not used for the formula of `E`.  Uses S6, S13a. -/
theorem T02_S13b (hlt : p < q) : 1 / π₁ < 1 / kappa ν p q := by
  sorry

/-- S14 (l.461-462, "which gives the desired result"), case `p < q`: second clause of the theorem:
`E_{p,q;λ₀}(y) = E^{π₁}_{p,q}(y)` for `y ∈ {0,1}`.  Uses S10, S12, S13a, and `min p q = p`,
`max p q = q`. -/
theorem T02_S14 (hlt : p < q) :
    ∀ y ∈ ({0, 1} : Set ℝ), Erep S p q (growLambda S p q π₁) y = EGrow ν p q π₁ y := by
  sorry

/-- S15 (l.462, "The case p > q is analogous"): the full conclusion of Theorem 3.2 for `p > q`
(no argument given).  Includes the sign `d(1) < 0 < d(0)`, `λ₀ = (1-π₁) + π₁ d(1)/d(0)`, and the
analogues of S3-S14.  Uses `hT01`. -/
theorem T02_S15 (hT01 : T02_T01Consumed) (hgt : q < p) : Conclusion S ν p q π₁ := by
  sorry

end Steps

/-- **Theorem 3.2** (source/VSIFP_02.tex:153-172).  Under the assumptions of Theorem 3.1
(`S` consistent with mixing measure `ν`, `p ≠ q ∈ (0,1)`, `ν{[min,max)} > 0`), for any
`π₁ ∈ [0,1] \ H_S`: `λ` maximizes `E_{π₁} log E_{p,q;λ}` iff `λ` is the printed value, and the
corresponding e-value is `E^{π₁}_{p,q}`.  First parameter: consumed clause of Theorem 3.1. -/
theorem T02 (hT01 : T02_T01Consumed) (S : ℝ → ℝ → ℝ) (ν : Measure ℝ)
    (hcons : IsConsistent S) (hrep : T01.MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q)))
    (π₁ : ℝ) (hπ : π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q) :
    Conclusion S ν p q π₁ := by
  sorry

end Paper.T02
