import T01Stmt

open MeasureTheory

namespace Paper.T01

/-- **Theorem 3.1** (source/VSIFP_02.tex:144-149).  `S` consistent with mixing measure `ν`,
`p ≠ q ∈ (0,1)`, `ν{[min p q, max p q)} > 0`.  Then `E` is an e-value with null `H_S` and
alternative `[0,1] \ H_S` iff `E = E_{p,q;λ}` (on `y ∈ {0,1}`) for some `λ ∈ (0,1]`. -/
theorem T01 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) (E : ℝ → ℝ) :
    IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) ↔
      ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ), E y = Erep S p q lam y := by
  sorry

/-! Step obligations.  Common hypotheses are repeated in each step. -/

/-- S1 (l.403, "If E(y) is of the stated form, then E(y) ≥ E{1(p>q)} = 1-λ ≥ 0").
Role: nonnegativity of `E_{p,q;λ}`.  Uses S2/S2' (sign of d).  Source gives the inequality
without justification of why `E(y) ≥ E(1{p>q})` (follows from the signs of d; implicit). -/
theorem T01_S1 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) (lam : ℝ) (hlam : lam ∈ Set.Ioc (0:ℝ) 1) :
    ∀ y ∈ ({0, 1} : Set ℝ), Erep S p q lam y ≥ Erep S p q lam (if q < p then 1 else 0) ∧
      Erep S p q lam (if q < p then 1 else 0) = 1 - lam ∧ 0 ≤ 1 - lam := by
  sorry

/-- S2 (l.403, "one can easily verify that E has the given null hypothesis" (X08, not
justified in the source)).  Role: sufficiency direction: `E_{p,q;λ}` is an e-value with null
`H_S` and alternative `[0,1] \ H_S`.  Uses S1 and the form of `expPi`. -/
theorem T01_S2 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) (lam : ℝ) (hlam : lam ∈ Set.Ioc (0:ℝ) 1) :
    IsEValue (Erep S p q lam) (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) := by
  sorry

/-- S3 (l.407, case `p < q`): "The elementary score representation (eq:mixture) and
`ν{[p,q)} > 0` imply that `d_{p,q}(0) < 0 < d_{p,q}(1)`", `d = S(p,·) - S(q,·)`.
Role: sign of `d`.  Uses the mixture representation (X01 consumed as hypothesis `hrep`). -/
theorem T01_S3 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p < q)
    (hν : 0 < ν (Set.Ico p q)) :
    S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1 := by
  sorry

/-- S4 (l.407, case `p < q`): "so `f(π)` is strictly increasing in `π` and equal to zero for
some `π₀ ∈ (0,1)`" with `f(π) = (1-π) d(0) + π d(1)` (eq:expscore, l.405).  Uses S3. -/
theorem T01_S4 (S : ℝ → ℝ → ℝ) (p q : ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1) :
    StrictMonoOn (fun π => expPi π (fun y => S p y - S q y)) (Set.Icc (0:ℝ) 1) ∧
      ∃ π₀ ∈ Set.Ioo (0:ℝ) 1, expPi π₀ (fun y => S p y - S q y) = 0 := by
  sorry

/-- S5 (l.407-409, eq:evalueCond): an e-value for `H_S` with alternative `H_S^c` satisfies
`E(y) ≥ 0` and `E_π E ≤ 1 ↔ f π ≤ 0` for `π ∈ [0,1]`.  Role: translation of the e-value
definition (with `H_S^c = [0,1] \ H_S`) into the iff of eq:evalueCond.  Source gives no
detail; follows from the definition l.142. -/
theorem T01_S5 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hE : IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q)) :
    0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0) := by
  sorry

/-- S6 (l.411-414, eq:ratio): "Condition (evalueCond) implies `E_π E = 1` iff `f(π) = 0`, which
yields `d(0)/(d(1)-d(0)) = (E(0)-1)/(E(1)-E(0))`" (case `p < q`).  Role: the zero `π₀` of `f`
is the zero of `π ↦ E_π E - 1`, comparing the two affine functions.  Uses S3, S4, S5.
Source gives no justification of the implication "≤1 iff ≤0 gives = iff =" (a continuity/
monotonicity step) nor of `E(1) ≠ E(0)`. -/
theorem T01_S6 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h : 0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0)) :
    E 1 ≠ E 0 ∧ (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) = (E 0 - 1) / (E 1 - E 0) := by
  sorry

/-- S7 (l.415-418): "Rearranging this equation gives
`E(1) = 1 - {1 - E(0)} d(1)/d(0)`".  Uses S6. -/
theorem T01_S7 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1) (h1 : E 1 ≠ E 0)
    (hr : (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) = (E 0 - 1) / (E 1 - E 0)) :
    E 1 = 1 - (1 - E 0) * (S p 1 - S q 1) / (S p 0 - S q 0) := by
  sorry

/-- S8 (l.419): "It follows from (evalueCond) and (ratio) that `E(0) ∈ (0,1)`".  Role: range of
`λ = 1 - E(0)`.  NOTE (suspected issue): the printed open interval excludes `E(0) = 0`, i.e.
`λ = 1`, which the theorem allows (`λ ∈ (0,1]`); only `E(0) ∈ [0,1)` is plausible (E ≥ 0).
Stated here as printed; the prover must stop if it is false.  Uses S3, S5, S6. -/
theorem T01_S8 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h : 0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0))
    (hr : E 1 ≠ E 0 ∧ (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) = (E 0 - 1) / (E 1 - E 0)) :
    E 0 ∈ Set.Ioo (0:ℝ) 1 := by
  sorry

/-- S9 (l.419-421): with `λ = 1 - E(0)`, `E(y) = 1 - λ d(y)/d(0) = 1 + λ d(y)/|d(0)|` for
`y ∈ {0,1}` (case `p < q`).  Uses S3, S7, S8. -/
theorem T01_S9 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h1 : E 1 = 1 - (1 - E 0) * (S p 1 - S q 1) / (S p 0 - S q 0)) (h0 : E 0 ∈ Set.Ioo (0:ℝ) 1) :
    ∀ y ∈ ({0, 1} : Set ℝ),
      E y = 1 + (1 - E 0) * (S p y - S q y) / |S p 0 - S q 0| := by
  sorry

/-- S10 (l.423-426): "Similar arguments for the case `p > q` show that in general
`E(y) = 1 + λ d(y)/|d{1(p>q)}|`" (X08: "similar arguments", not written out).  Role: the
necessity direction for `q < p`.  Uses the analogues of S3-S9. -/
theorem T01_S10 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : q < p)
    (hν : 0 < ν (Set.Ico q p)) (E : ℝ → ℝ)
    (hE : IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q)) :
    ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ), E y = Erep S p q lam y := by
  sorry

end Paper.T01
