import T02Stmt
import P02Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P03

/-- Consumed clause of T02 (Theorem 3.1, thm:main, source :186-189), provenance (p).
Exactly the sentence used by Proposition 3.3 (source :269, "As a consequence of Theorem 3.1"):
"If `X` is InvSub, then (eq:main-st) holds", i.e. `X ≤st θ₁X₁+⋯+θₙXₙ` for `n` i.i.d. copies.
Specialised (weaker than T02_main, as the source's "immediate" needs only one choice of weights)
to `n = 2`, `θ₁ = θ₂ = 1/2`.  Location in T02: `T02_main` (T02Draft), conclusion of the theorem.
T02's own consumed clause `T02_L01Consumed` is an antecedent here (as in the signature of
`T02_main`), so that this clause reproduces T02's hypotheses exactly.
Applicability here: `IsInvSub (μ.map X)` is the hypothesis of P03; the i.i.d. copies are built in
step S1 on a product space (the source never mentions this). -/
def P03_T02Consumed : Prop :=
  Paper.T02.T02_L01Consumed →
  ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (Xs : Fin 2 → Ω → ℝ),
    Paper.T02.IIDCopies μ X Xs →
    Paper.L01.IsInvSub (μ.map X) →
    Paper.T02.StDom μ X (fun ω => ∑ i, (1 / 2 : ℝ) * Xs i ω)

/-- Consumed clause of P02 (Proposition 3.2, prop:inf-mean, source :261-264), provenance (p).
Exactly the sentence used (source :269): "If (eq:main-st) holds [for independent `Xᵢ` with
`P(X₁=⋯=Xₙ)<1`, weights `θᵢ>0` summing to 1], then `X` has infinite mean."  Specialised to
`n = 2`, `θ = (1/2, 1/2)`.  Location in P02: `P02_main` (P02Draft), the whole statement
(no nonnegativity hypothesis is printed or encoded there; the P02 proof silently uses it,
INVENTORY X14/X15).  Applicability here: the nondegeneracy hypothesis `hne` is NOT printed
as available for InvSub `X`; it is the step obligation S2 of the draft. -/
def P03_P02Consumed : Prop :=
  ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (Xs : Fin 2 → Ω → ℝ),
    Measurable X → (∀ i, Measurable (Xs i)) →
    iIndepFun Xs μ →
    (∀ i, IdentDistrib (Xs i) X μ μ) →
    μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1 →
    Paper.P02.StDom μ X (fun ω => ∑ i, (1 / 2 : ℝ) * Xs i ω) →
    Paper.P02.InfiniteMean μ X

end Paper.P03
