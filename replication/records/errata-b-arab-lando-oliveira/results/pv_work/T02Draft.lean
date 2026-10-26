import T02Stmt

open MeasureTheory ProbabilityTheory Paper.L01

namespace Paper.T02

/-- Theorem 3.1 (thm:main), source :186-189: "If `X` is InvSub, then the stochastic dominance
(eq:main-st) holds."  (eq:main-st) (:95-98): for `n` i.i.d. copies `X₁,…,Xₙ` of `X` and weights
`θᵢ ≥ 0` with `∑ θᵢ = 1`, `X ≤st θ₁X₁+⋯+θₙXₙ`.
Encoding: `T02_L01Consumed` first (provenance (p), the "only if" half of L01).  The law of `X`
is `μ.map X`; InvSub is `Paper.L01.IsInvSub` (Def 2.2, includes `F_X(0)=0`).  Weights `θᵢ ≥ 0` as
in :95 (the proof :191, :219 treats only `θᵢ > 0`; recorded, not repaired; see notes). -/
theorem T02_main (hL01 : T02_L01Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ) (hiid : IIDCopies μ X Xs)
    (hits : IsInvSub (μ.map X))
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 ≤ θ i) (hsum : ∑ i, θ i = 1) :
    StDom μ X (fun ω => ∑ i, θ i * Xs i ω) := by
  sorry

/-! ### n = 2 case (source :191-217, unchanged by the revision) -/

/-- S1.  Source :191-194: "Conditioning, using the independence of the random variables, and
remembering they are nonnegative, it is easily seen that, for every `x ≥ 0` and `θ ∈ (0,1)`,
`P(θX₁+(1-θ)X₂ > x) = 1 - ∫_0^{x/θ} F_X((x-θt)/(1-θ)) F_X(dt)`."
Role: integral formula for `n=2`.  Nonnegativity is not a printed hypothesis; it is the
consequence `F_X(0)=0` of InvSub (Def 2.2).  `∫_0^{x/θ}` read as the closed interval `[0, x/θ]`
w.r.t. the law `F_X(dt) = μ.map X`.  Uses: nothing (independence + Fubini). -/
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
and `(x,x/θ]` (integrand `≤ F_X(x)`, mass `F_X(x/θ)-F_X(x)`).  Uses: nothing.
Also reused (as the "same argument", :226) in the induction step, with `θ = θₙ`. -/
theorem T02_S2 (ν : Measure ℝ) [IsProbabilityMeasure ν] (h0 : F ν 0 = 0)
    (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    ∫ t in Set.Icc 0 (x / θ), F ν ((x - θ * t) / (1 - θ)) ∂ν
      ≤ F ν (x / (1 - θ)) * F ν x + F ν x * (F ν (x / θ) - F ν x) := by
  sorry

/-- S3.  Source :198-201: "`≤ F_X(x)`, using (eq:sub-1x) for the last inequality."
Role: `F(x)(F(x/(1-θ)) + F(x/θ) - F(x)) ≤ F(x)` from (eq:sub-1x) and `F(x) ≥ 0`.
Uses: `T02_L01Consumed` (to get (eq:sub-1x) from InvSub).  Reused at :231-233. -/
theorem T02_S3 (hL01 : T02_L01Consumed) (ν : Measure ℝ) [IsProbabilityMeasure ν]
    (hits : IsInvSub ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F ν (x / (1 - θ)) * F ν x + F ν x * (F ν (x / θ) - F ν x) ≤ F ν x := by
  sorry

/-- S4.  Source :217: "So, it follows that `P(θX₁+(1-θ)X₂ > x) ≥ 1 - F_X(x) = P(X > x)`, so
(eq:main-st) holds for `n=2`."
Role: combine S1-S3 for `x ≥ 0`.  The source treats only `x ≥ 0` (:191); Definition 2.1 requires
all real `x` (the case `x < 0` is not written; EXPOSITION_GAP candidate, recorded only).  Weights `θ ∈ (0,1)` only (`θ₁,θ₂>0`).  Uses: S1, S2, S3. -/
theorem T02_S4 (hL01 : T02_L01Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X X₁ X₂ : Ω → ℝ) (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hind : IndepFun X₁ X₂ μ) (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hits : IsInvSub (μ.map X)) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    StDom μ X (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) := by
  sorry

/-! ### Induction step (source :219-233, rewritten in revision 1)

Indexing: the source's step goes from `n-1` to `n` variables; here there are `m + 1` copies
(`Fin (m+1)`, last index `Fin.last m` is the source's `X_n`) and the induction hypothesis is for
`m` copies, `m ≥ 2` (the case `n = 2`, i.e. `m = 1`, is the base case; the source's step is
used for `n ≥ 3`). -/

section InductionStep

variable {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
  (X : Ω → ℝ) {m : ℕ} (Xs : Fin (m + 1) → Ω → ℝ) (θ : Fin (m + 1) → ℝ)

/-- S5.  Source :219-223 (first line of the display): "Given `θ₁,…,θₙ > 0` with
`∑ θᵢ = 1` ... `P(θ₁X₁+⋯+θₙXₙ ≤ x) = ∫_0^{x/θₙ}
P((θ₁X₁+⋯+θ_{n-1}X_{n-1})/(1-θₙ) ≤ (x-θₙt)/(1-θₙ)) F_X(dt)`."
Role: conditioning on `Xₙ = t` (independence of `Xₙ` from the others; nonnegativity so that the
range is `t ≤ x/θₙ`, from `F_X(0)=0`); no justification beyond "using the induction hypothesis"
is printed for this line (the equality itself uses no IH).  `∫_0^{x/θₙ}` read as `[0,x/θₙ]`.
`x ≥ 0` as in :191 (range of `x` not printed in the step).  Positive weights `θᵢ > 0` as in
:219.  Uses: nothing (same type of conditioning as S1). -/
theorem T02_S5 (hm : 2 ≤ m) (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1) (x : ℝ) (hx : 0 ≤ x) :
    (μ {ω | ∑ i, θ i * Xs i ω ≤ x}).toReal
      = ∫ t in Set.Icc 0 (x / θ (Fin.last m)),
          (μ {ω | (∑ i : Fin m, θ i.castSucc * Xs i.castSucc ω) / (1 - θ (Fin.last m))
              ≤ (x - θ (Fin.last m) * t) / (1 - θ (Fin.last m))}).toReal
          ∂(μ.map X) := by
  sorry

/-- S6.  Source :224 (second line of the display, "using the induction hypothesis"):
`∫_0^{x/θₙ} P(Y/(1-θₙ) ≤ y(t)) F_X(dt) ≤ ∫_0^{x/θₙ} F_X(y(t)) F_X(dt)` with
`y(t) = (x-θₙt)/(1-θₙ)` and `Y = θ₁X₁+⋯+θ_{n-1}X_{n-1}`.
The induction hypothesis (:219: (eq:main-st) for `n-1` variables with `n-1` nonnegative weights
summing to 1; here the normalised weights `θᵢ/(1-θₙ)`, the normalisation being implicit) is
`hIH : X ≤st Y/(1-θₙ)`, used only through the pointwise consequence
`P(Y/(1-θₙ) ≤ y) ≤ F_X(y)` (taking complements of `F̄_X(y) ≤ P(Y/(1-θₙ) > y)`), then monotonicity
of the integral.  Uses: `hIH`. -/
theorem T02_S6 (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hIH : StDom μ X (fun ω => ∑ i : Fin m, (θ i.castSucc / (1 - θ (Fin.last m))) * Xs i.castSucc ω))
    (x : ℝ) (hx : 0 ≤ x) :
    ∫ t in Set.Icc 0 (x / θ (Fin.last m)),
        (μ {ω | (∑ i : Fin m, θ i.castSucc * Xs i.castSucc ω) / (1 - θ (Fin.last m))
            ≤ (x - θ (Fin.last m) * t) / (1 - θ (Fin.last m))}).toReal ∂(μ.map X)
      ≤ ∫ t in Set.Icc 0 (x / θ (Fin.last m)),
          F (μ.map X) ((x - θ (Fin.last m) * t) / (1 - θ (Fin.last m))) ∂(μ.map X) := by
  sorry

/-- S7.  Source :226-230: "Now, this integral has exactly the same form as the one bounded in
the first step, so we may use the same argument, described geometrically in Figure 1, to find
that `∫_0^{x/θₙ} F_X((x-θₙt)/(1-θₙ)) F_X(dt) ≤ F_X(x/(1-θₙ))F_X(x) + F_X(x)(F_X(x/θₙ)-F_X(x))`."
This is S2 with `θ := θₙ ∈ (0,1)` (`θₙ < 1` because the other weights are positive).
Uses: S2. -/
theorem T02_S7 (hm : 2 ≤ m) (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1) (x : ℝ) (hx : 0 ≤ x) :
    ∫ t in Set.Icc 0 (x / θ (Fin.last m)),
        F (μ.map X) ((x - θ (Fin.last m) * t) / (1 - θ (Fin.last m))) ∂(μ.map X)
      ≤ F (μ.map X) (x / (1 - θ (Fin.last m))) * F (μ.map X) x
        + F (μ.map X) x * (F (μ.map X) (x / θ (Fin.last m)) - F (μ.map X) x) := by
  sorry

/-- S8.  Source :231-233: "`≤ F_X(x)`, taking into account (eq:sub-1x)" (same estimate as S3
with `θ := θₙ`), then "Taking complements, we have just proved that
`P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄_X(x)`, which concludes the proof."
Role: chain S5-S7 and S3 to `P(sum ≤ x) ≤ F_X(x)`, hence `X ≤st sum` at `x ≥ 0` for positive
weights.  Uses: S3, S5, S6, S7, `hIH` (T02_L01Consumed via S3).  Only `x ≥ 0` is covered by the
printed argument (the range `x < 0` is not written). -/
theorem T02_S8 (hL01 : T02_L01Consumed) (hm : 2 ≤ m) (hiid : IIDCopies μ X Xs)
    (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hIH : StDom μ X (fun ω => ∑ i : Fin m, (θ i.castSucc / (1 - θ (Fin.last m))) * Xs i.castSucc ω))
    (x : ℝ) (hx : 0 ≤ x) :
    (μ {ω | x < ∑ i, θ i * Xs i ω}).toReal ≥ (μ {ω | x < X ω}).toReal := by
  sorry

end InductionStep

end Paper.T02
