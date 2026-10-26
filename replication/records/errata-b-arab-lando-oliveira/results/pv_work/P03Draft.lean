import P03Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P03

/-- Proposition 3.3 (prop:mean-fsub), source :270-273: "If `X` is InvSub, then `E X` is
infinite."  Proof (source :269): "As a consequence of Theorem 3.1 and Proposition 3.2, the
following result is immediate."
Encoding: `X` a (real-valued, measurable) random variable on a probability space `(Ω, μ)`;
InvSub is `Paper.L01.IsInvSub (μ.map X)` (Def 2.2, includes `F_X(0)=0`); "`E X` is infinite" is
`Paper.P02.InfiniteMean μ X` (= `¬ Integrable X μ`; for `X ≥ 0` a.s., which follows from
`F_X(0)=0`, this is `E X = ∞`).  Extended-valued `X` (Ex. 2.7) is not encoded.
Parameters: `hT02`, `hP02` are the consumed clauses (p); `hL01` is T02's own consumed clause
(needed to discharge the antecedent of `hT02`). -/
theorem P03_main (hL01 : Paper.T02.T02_L01Consumed)
    (hT02 : P03_T02Consumed) (hP02 : P03_P02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X)
    (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.P02.InfiniteMean μ X := by
  sorry

/-- S1.  Source :269 (silent): T02 and P02 speak of `n` i.i.d. copies `X₁,…,Xₙ` of `X`
(:95-96), but P03 gives only one `X`.  Copies are realised on `(Ω×Ω, μ⊗μ)` as the coordinates
`X∘fst`, `X∘snd` (two copies, `X∘fst` playing the role of `X`).  Not stated in the source
(FAIR_IMPLICIT_STEP candidate: standard enlargement of the probability space).  Uses: nothing. -/
theorem P03_S1 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) :
    Paper.T02.IIDCopies (μ.prod μ) (fun p : Ω × Ω => X p.1)
      (fun i : Fin 2 => if i = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) := by
  sorry

/-- S2.  Source :269 (silent, INVENTORY X14): the nondegeneracy hypothesis `P(X₁=⋯=Xₙ)<1` of
Proposition 3.2 (:263) is not checked for an InvSub `X`.  Statement: an InvSub variable is not
a.s. constant, so two independent copies differ with positive probability.  No justification
in the source.  Candidate class: EXPOSITION_GAP / PAPER_ASSUMPTION_GAP (recorded only).
Uses: nothing. -/
theorem P03_S2 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    (μ.prod μ) {p : Ω × Ω | ∀ i j : Fin 2,
        (if i = 0 then X p.1 else X p.2) = (if j = 0 then X p.1 else X p.2)} < 1 := by
  sorry

/-- S3.  Source :269 (silent, INVENTORY X14): nonnegativity of `X`, needed so that P02's
square roots make sense and so that "infinite mean" (`¬Integrable`) means `E X = ∞`.  It is not
printed for P03; here the consequence of `F_X(0)=0` in Def 2.2: `X > 0` a.s. (hence `X ≥ 0`
a.s.).  Uses: nothing. -/
theorem P03_S3 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    ∀ᵐ ω ∂μ, 0 < X ω := by
  sorry

/-- S4.  Source :269 "As a consequence of Theorem 3.1": InvSub `X` gives `X ≤st (X₁+X₂)/2`
for the copies of S1.  Uses: S1 and the consumed clause `P03_T02Consumed` (T02; note T02's
S10b is a suspected gap, so this is conditional on that clause).  Needs
`IsInvSub (law of X∘fst) = IsInvSub (μ.map X)` (law of the coordinate; part of the step). -/
theorem P03_S4 (hL01 : Paper.T02.T02_L01Consumed) (hT02 : P03_T02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.T02.StDom (μ.prod μ) (fun p : Ω × Ω => X p.1)
      (fun p => ∑ i : Fin 2, (1 / 2 : ℝ) *
        (if i = 0 then X p.1 else X p.2)) := by
  sorry

/-- S5.  Bridge between the two copies `Paper.T02.StDom` and `Paper.P02.StDom` of Definition 2.1
(both are `∀ x, μ {x < X} ≤ μ {x < Y}`; definitionally equal).  Encoding step only.
Uses: nothing. -/
theorem P03_S5 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) (X Y : Ω → ℝ) :
    Paper.T02.StDom μ X Y ↔ Paper.P02.StDom μ X Y := by
  sorry

/-- S6.  Source :269 "and Proposition 3.2": from dominance (S4, S5), independence and
identical distribution (S1) and nondegeneracy (S2), conclude that `X∘fst` has infinite mean on the
product space.  Uses: S1, S2, S4, S5 and the consumed clause `P03_P02Consumed` (P02). -/
theorem P03_S6 (hL01 : Paper.T02.T02_L01Consumed) (hT02 : P03_T02Consumed)
    (hP02 : P03_P02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.P02.InfiniteMean (μ.prod μ) (fun p : Ω × Ω => X p.1) := by
  sorry

/-- S7.  Source :269 (silent): transfer of the conclusion from the enlarged space back to `X`
on `(Ω, μ)`: integrability depends only on the law, and `fst` is measure preserving.
Uses: nothing. -/
theorem P03_S7 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X)
    (h : Paper.P02.InfiniteMean (μ.prod μ) (fun p : Ω × Ω => X p.1)) :
    Paper.P02.InfiniteMean μ X := by
  sorry

end Paper.P03
