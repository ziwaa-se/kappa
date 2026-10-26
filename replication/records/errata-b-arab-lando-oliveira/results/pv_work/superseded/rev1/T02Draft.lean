import T02Stmt

open MeasureTheory ProbabilityTheory Paper.L01

namespace Paper.T02

/-- Theorem 3.1 (thm:main), source :186-189: "If `X` is InvSub, then the stochastic dominance
(eq:main-st) holds."  (eq:main-st) (:95-98): for `n` i.i.d. copies `X₁,…,Xₙ` of `X` and weights
`θᵢ ≥ 0` with `∑ θᵢ = 1`, `X ≤st θ₁X₁+⋯+θₙXₙ`.
Encoding: `T02_L01Consumed` first (provenance (p), the "only if" half of L01).  The law of `X`
is `μ.map X`; InvSub is `Paper.L01.IsInvSub` (Def 2.2, includes `F_X(0)=0`).  Weights `θᵢ ≥ 0` as
in :95 (the proof treats only `θᵢ > 0`; see notes). -/
theorem T02_main (hL01 : T02_L01Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ) (hiid : IIDCopies μ X Xs)
    (hits : IsInvSub (μ.map X))
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 ≤ θ i) (hsum : ∑ i, θ i = 1) :
    StDom μ X (fun ω => ∑ i, θ i * Xs i ω) := by
  sorry

/-! ### n = 2 case (source :191-217) -/

/-- S1.  Source :191-194: "Conditioning, using the independence of the random variables, and
remembering they are nonnegative, it is easily seen that, for every `x ≥ 0` and `θ ∈ (0,1)`,
`P(θX₁+(1-θ)X₂ > x) = 1 - ∫_0^{x/θ} F_X((x-θt)/(1-θ)) F_X(dt)`."
Role: integral formula for `n=2` (INVENTORY X05, X10).  Nonnegativity is not a printed hypothesis;
it is the consequence `F_X(0)=0` of InvSub (Def 2.2).  `∫_0^{x/θ}` is read as the closed interval
`[0, x/θ]` w.r.t. the law `F_X(dt) = μ.map X` (atoms at the endpoints would matter; the integrand
vanishes at `t = x/θ` because `F_X(0)=0`).  Uses: nothing (external standard fact, X05;
here a step obligation: provable by independence + Fubini). -/
theorem T02_S1 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X X₁ X₂ : Ω → ℝ) (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hind : IndepFun X₁ X₂ μ) (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hits : IsInvSub (μ.map X)) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    (μ {ω | x < θ * X₁ ω + (1 - θ) * X₂ ω}).toReal
      = 1 - ∫ t in Set.Icc 0 (x / θ), F (μ.map X) ((x - θ * t) / (1 - θ)) ∂(μ.map X) := by
  sorry

/-- S2.  Source :195-198: "To find an upper bound for the integral, we consider the
decomposition described in Figure 1, from which follows easily that
`∫_0^{x/θ} F_X((x-θt)/(1-θ)) F_X(dt) ≤ F_X(x/(1-θ))F_X(x) + F_X(x)(F_X(x/θ) - F_X(x))`."
Role: split `[0,x/θ]` into `[0,x]` (integrand `≤ F_X(x/(1-θ))`, mass `F_X(x)`, uses `F_X(0)=0`)
and `(x,x/θ]` (integrand `≤ F_X(x)`, mass `F_X(x/θ)-F_X(x)`).  Uses: nothing. -/
theorem T02_S2 (ν : Measure ℝ) [IsProbabilityMeasure ν] (h0 : F ν 0 = 0)
    (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    ∫ t in Set.Icc 0 (x / θ), F ν ((x - θ * t) / (1 - θ)) ∂ν
      ≤ F ν (x / (1 - θ)) * F ν x + F ν x * (F ν (x / θ) - F ν x) := by
  sorry

/-- S3.  Source :198-201: "`≤ F_X(x)`, using (eq:sub-1x) for the last inequality."
Role: `F(x)(F(x/(1-θ)) + F(x/θ) - F(x)) ≤ F(x)` from (eq:sub-1x) and `F(x) ≥ 0`.
Uses: `T02_L01Consumed` (to get (eq:sub-1x) from InvSub). -/
theorem T02_S3 (hL01 : T02_L01Consumed) (ν : Measure ℝ) [IsProbabilityMeasure ν]
    (hits : IsInvSub ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F ν (x / (1 - θ)) * F ν x + F ν x * (F ν (x / θ) - F ν x) ≤ F ν x := by
  sorry

/-- S4.  Source :217: "So, it follows that `P(θX₁+(1-θ)X₂ > x) ≥ 1 - F_X(x) = P(X > x)`, so
(eq:main-st) holds for `n=2`."
Role: combine S1-S3 for `x ≥ 0`.  The source treats only `x ≥ 0` (:191); Definition 2.1 requires
all real `x` (the case `x < 0` is not written; gate point).  Weights `θ ∈ (0,1)` only (`θ₁,θ₂>0`).
Uses: S1, S2, S3. -/
theorem T02_S4 (hL01 : T02_L01Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X X₁ X₂ : Ω → ℝ) (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hind : IndepFun X₁ X₂ μ) (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hits : IsInvSub (μ.map X)) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    StDom μ X (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) := by
  sorry

/-! ### Induction step (source :219-256) -/

section InductionStep

variable {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
  (X : Ω → ℝ) {n : ℕ} (Xs : Fin (n + 1) → Ω → ℝ) (θ : Fin (n + 1) → ℝ)

/-- S5.  Source :219-222: "Given `θ₁,…,θₙ > 0` with `∑ θᵢ = 1`,
`P(θ₁X₁+⋯+θₙXₙ > x) = P(Xₙ ≥ x/θₙ) + P(θ₁X₁+⋯+θₙXₙ ≥ x, Xₙ ≤ x/θₙ)`."
Written exactly as printed (`>` on the left, `≥` and `≤` on the right).  SUSPECTED (INVENTORY
X10): the events `{Xₙ ≥ x/θₙ}` and `{Xₙ ≤ x/θₙ}` overlap on `{Xₙ = x/θₙ}`, so with an atom
there the printed equality double-counts it.  Range of `x` not printed; `x ≥ 0` as in :191.
Uses: nothing. (Here `Xₙ = Xs (Fin.last n)`, `n ≥ 1` copies in the source's induction, `n+1` here.) -/
theorem T02_S5 (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1) (x : ℝ) (hx : 0 ≤ x) :
    (μ {ω | x < ∑ i, θ i * Xs i ω}).toReal
      = (μ {ω | x / θ (Fin.last n) ≤ Xs (Fin.last n) ω}).toReal
        + (μ {ω | x ≤ ∑ i, θ i * Xs i ω ∧ Xs (Fin.last n) ω ≤ x / θ (Fin.last n)}).toReal := by
  sorry

/-- S6a.  Source :223: first term `= F̄_X(x/θₙ)`, i.e. `P(Xₙ ≥ x/θₙ) = F̄_X(x/θₙ)`.
SUSPECTED (INVENTORY X10): `P(Xₙ ≥ c) = F̄_X(c) = P(X > c)` fails if `X` has an atom at `c`.
Uses: nothing. -/
theorem T02_S6a (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (x : ℝ) (hx : 0 ≤ x) :
    (μ {ω | x / θ (Fin.last n) ≤ Xs (Fin.last n) ω}).toReal
      = Fbar (μ.map X) (x / θ (Fin.last n)) := by
  sorry

/-- S6b.  Source :223-224: "`P(θ₁X₁+⋯+θₙXₙ ≥ x, Xₙ ≤ x/θₙ) = ∫_0^{x/θₙ}
P((θ₁X₁+⋯+θ_{n-1}X_{n-1})/(1-θₙ) ≥ (x-θₙt)/(1-θₙ)) F_X(dt)`."
Conditioning on `Xₙ = t` using independence of `Xₙ` from the others (same justification as S1,
INVENTORY X05).  `∫_0^{x/θₙ}` read as the closed interval `[0,x/θₙ]`.  Uses: nothing.
The binder `hn : 2 ≤ n` is the source's induction range (:219, step for `n ≥ 3` variables;
here `n + 1` copies); at `n = 0` the statement is false (gate amendment 1). -/
theorem T02_S6b (hn : 2 ≤ n) (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1) (x : ℝ) (hx : 0 ≤ x) :
    (μ {ω | x ≤ ∑ i, θ i * Xs i ω ∧ Xs (Fin.last n) ω ≤ x / θ (Fin.last n)}).toReal
      = ∫ t in Set.Icc 0 (x / θ (Fin.last n)),
          (μ {ω | (x - θ (Fin.last n) * t) / (1 - θ (Fin.last n))
              ≤ (∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω) / (1 - θ (Fin.last n))}).toReal
          ∂(μ.map X) := by
  sorry

/-- S7.  Source :224-225: "`≥ F̄_X(x/θₙ) + ∫_0^{x/θₙ} F̄_X((x-θₙt)/(1-θₙ)) F_X(dt)`, using the
induction hypothesis."  The induction hypothesis is (eq:main-st) for the `n` copies
`X₁,…,X_{n}` (here `Fin n`) with the normalised weights `θᵢ/(1-θₙ)` (:219 "(eq:main-st) holds
whenever considering `n-1` random variables"; the normalisation is implicit).  Role: the
integrand bound `P(Y ≥ y) ≥ P(Y > y) ≥ F̄_X(y)` and monotonicity of the integral.
Uses: the induction hypothesis `hIH`. -/
theorem T02_S7 (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hIH : StDom μ X (fun ω => ∑ i : Fin n, (θ i.castSucc / (1 - θ (Fin.last n))) * Xs i.castSucc ω))
    (x : ℝ) (hx : 0 ≤ x) :
    ∫ t in Set.Icc 0 (x / θ (Fin.last n)), Fbar (μ.map X) ((x - θ (Fin.last n) * t) / (1 - θ (Fin.last n)))
        ∂(μ.map X)
      ≤ ∫ t in Set.Icc 0 (x / θ (Fin.last n)),
          (μ {ω | (x - θ (Fin.last n) * t) / (1 - θ (Fin.last n))
              ≤ (∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω) / (1 - θ (Fin.last n))}).toReal
          ∂(μ.map X) := by
  sorry

end InductionStep

/-! ### Figure 2 decomposition and the final estimates (source :246-256) -/

section Estimates

variable (ν : Measure ℝ) [IsProbabilityMeasure ν]

/-- S8.  Source :246-252: "using the decomposition depicted in Figure 2, from which follows that
`∫_0^{x/θₙ} F̄_X((x-θₙt)/(1-θₙ)) F_X(dt) ≥ F̄_X(x/(1-θₙ))F_X(x) + F̄_X(x)(F_X(x/θₙ)-F_X(x))`."
(`θ` stands for `θₙ ∈ (0,1)`.)  Role: lower bound, mirror of S2 (uses `F_X(0)=0`). Uses: nothing. -/
theorem T02_S8 (h0 : F ν 0 = 0) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν (x / (1 - θ)) * F ν x + Fbar ν x * (F ν (x / θ) - F ν x)
      ≤ ∫ t in Set.Icc 0 (x / θ), Fbar ν ((x - θ * t) / (1 - θ)) ∂ν := by
  sorry

/-- S9.  Source :252-254, third line: the algebraic rewriting
`F̄(x/θ) + F̄(x/(1-θ))F(x) + F̄(x)(F(x/θ)-F(x)) ≥ F̄(x/θ) + F̄(x/(1-θ))
 + F̄(x)(F̄(x) - F̄(x/θ) - F̄(x/(1-θ)))` (with `F = 1 - F̄`; it is an equality).  Uses: nothing. -/
theorem T02_S9 (x : ℝ) (θ : ℝ) :
    Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) + Fbar ν x * (Fbar ν x - Fbar ν (x / θ) - Fbar ν (x / (1 - θ)))
      ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) * F ν x + Fbar ν x * (F ν (x / θ) - F ν x) := by
  sorry

/-- S10a.  Source :256: "(eq:sub-1x) written in terms of the survival function":
`F̄(x) ≤ F̄(x/θ) + F̄(x/(1-θ))`, i.e. the large parenthesis
`F̄(x) - F̄(x/θ) - F̄(x/(1-θ))` is `≤ 0` ("negative").  Uses: (eq:sub-1x) (`SubCond`, obtained
from InvSub through `T02_L01Consumed` in the assembly). -/
theorem T02_S10a (hsub : SubCond ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν x - Fbar ν (x / θ) - Fbar ν (x / (1 - θ)) ≤ 0 := by
  sorry

/-- S10b.  Source :256: "Finally, noting that the subadditivity assumption implies that the large
parenthesis is negative, it follows that `P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄_X(x/θₙ) + F̄_X(x/(1-θₙ))`."
Encoded as the lower-bound step on the displayed quantity: from `F̄(x/θ) + F̄(x/(1-θ)) +
F̄(x)·(parenthesis) ` with `F̄(x) ≥ 0` and parenthesis `≤ 0`, conclude
`≥ F̄(x/θ) + F̄(x/(1-θ))`.  SUSPECTED PAPER_ARGUMENT_GAP: the term `F̄(x)·(parenthesis)` is
nonpositive, so dropping it gives an UPPER bound, not the claimed lower bound (expected false,
e.g. for Fréchet(1)).  Recorded, not repaired.  Uses: S10a. -/
theorem T02_S10b (hsub : SubCond ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν (x / θ) + Fbar ν (x / (1 - θ))
      ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ))
        + Fbar ν x * (Fbar ν x - Fbar ν (x / θ) - Fbar ν (x / (1 - θ))) := by
  sorry

/-- S11.  Source :256: "`≥ F̄_X(x/θₙ) + F̄_X(x/(1-θₙ)) ≥ F̄_X(x)`, using (eq:sub-1x) written in
terms of the survival function."  The last inequality (same content as S10a).  Uses: SubCond. -/
theorem T02_S11 (hsub : SubCond ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν x ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) := by
  sorry

end Estimates

end Paper.T02
