import T01Stmt

/-!
# T02 statement definitions (source/VSIFP_02.tex:153-172, Theorem 3.2 `thm:grow`)

Reused (imported, not redeclared): `Paper.IsConsistent`, `Paper.HS`, `Paper.Erep`,
`Paper.IsGrowLambda`, `Paper.growthRate`, `Paper.EGrow`, `Paper.kappa`, `Paper.expPi`
(`Defs.lean`) and `Paper.T01.MixtureRep` (`T01Stmt.lean`).
-/

open MeasureTheory

namespace Paper.T02

/-- The value of `λ` of Theorem 3.2 (l.156-159):
`(1-π₁) + π₁ (S(p,1)-S(q,1))/(S(p,0)-S(q,0))` if `p > q`,
`π₁ + (1-π₁) (S(p,0)-S(q,0))/(S(p,1)-S(q,1))` if `p < q`.
Since `p ≠ q` is assumed, the `else` branch is the case `p < q`. -/
noncomputable def growLambda (S : ℝ → ℝ → ℝ) (p q π₁ : ℝ) : ℝ :=
  if q < p then (1 - π₁) + π₁ * ((S p 1 - S q 1) / (S p 0 - S q 0))
  else π₁ + (1 - π₁) * ((S p 0 - S q 0) / (S p 1 - S q 1))

/-- Conclusion of Theorem 3.2 (l.154-167), two separable clauses.
* `grow_iff` (l.154-160): `E_{π₁}{log E_{p,q;λ}}` is maximal in `λ` (over the family `λ ∈ (0,1]`
  of Theorem 3.1, `IsGrowLambda`) iff `λ = growLambda`.
* `evalue` (l.161-167): the corresponding e-value `E_{p,q;λ}` for that `λ` equals
  `E^{π₁}_{p,q}` on `y ∈ {0,1}` (N4). -/
structure Conclusion (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (p q π₁ : ℝ) : Prop where
  grow_iff : ∀ lam : ℝ, IsGrowLambda S p q π₁ lam ↔ lam = growLambda S p q π₁
  evalue : ∀ y ∈ ({0, 1} : Set ℝ),
    Erep S p q (growLambda S p q π₁) y = EGrow ν p q π₁ y

/-- Consumed clause (p) of Theorem 3.1 (`T01`, l.144-149), the direction "only if" which is the
sentence of the proof of Theorem 3.2 at l.430: "All e-values for the given null hypothesis are of
the form (6)".  Located in `T01` as the `→` direction of its iff (`IsEValue E (HS S p q)
([0,1] \ HS S p q) → ∃ λ ∈ (0,1], E = E_{p,q;λ}` on `{0,1}`), with exactly the hypotheses of
Theorem 3.1.  Applicability in T02: the hypotheses of T02 are those of T01 (l.154 "Under the
assumptions of Theorem 3.1"), so the clause applies to the same `S, ν, p, q`; it is quantified here
over all of them since T02 may use it at its own `S, ν, p, q`. -/
def T02_T01Consumed : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ p q : ℝ, p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
      0 < ν (Set.Ico (min p q) (max p q)) →
      ∀ E : ℝ → ℝ, IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) →
        ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ), E y = Erep S p q lam y

end Paper.T02
