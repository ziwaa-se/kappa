import L01Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.T02

/-- Stochastic dominance, Definition 2.1 (source :115-118): `X ≤st Y` iff
`F̄_X(x) ≤ F̄_Y(x)` for every real `x`, where `F̄_X(x) = P(X > x)`.  Random variables are
real functions on a probability space `(Ω, μ)`; `StDom μ X Y` is `X ≤st Y`. -/
def StDom {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) (X Y : Ω → ℝ) : Prop :=
  ∀ x : ℝ, μ {ω | x < X ω} ≤ μ {ω | x < Y ω}

/-- Survival function `F̄_X = 1 - F_X` (source :113), for the law `ν` of `X`
(`F` is the cdf of `Paper.L01`). -/
noncomputable def Fbar (ν : Measure ℝ) (x : ℝ) : ℝ := 1 - Paper.L01.F ν x

/-- "`X₁,…,Xₙ` are `n` i.i.d. copies of `X`" (source :95-96): `X` and every `Xᵢ` are random
variables (measurable), the `Xᵢ` are independent and each has the law of `X`. -/
structure IIDCopies {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) (X : Ω → ℝ) {n : ℕ}
    (Xs : Fin n → Ω → ℝ) : Prop where
  meas : Measurable X
  measXs : ∀ i, Measurable (Xs i)
  indep : iIndepFun Xs μ
  ident : ∀ i, IdentDistrib (Xs i) X μ μ

/-- Consumed clause of L01 (Lemma 2.3, lem:ITS-carac, source :128-135), provenance (p).
Exactly the direction used by Theorem 3.1: "using (eq:sub-1x)" (source :201 and :256), i.e.
"`X` ITS implies (eq:sub-1x)" (the "only if" direction), for the law of every random variable.
This is the direction NOT affected by the L01 issue (the "if" direction omits `F_X(0)=0`,
see `verification/audits/L01_issue_1.md`).  Location in L01: the "only if" half of the
biconditional (L01Draft main theorem).  Applicability here: applied once, to the law
`μ.map X` of the ITS variable `X` of the theorem, a probability measure on `ℝ`. -/
def T02_L01Consumed : Prop :=
  ∀ (ν : Measure ℝ) [IsProbabilityMeasure ν], Paper.L01.IsInvSub ν → Paper.L01.SubCond ν

end Paper.T02
