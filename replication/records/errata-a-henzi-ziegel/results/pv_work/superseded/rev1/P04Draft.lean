import P04Stmt

/-!
# P04 draft (source/VSIFP_02.tex:222-227, Proposition 3.4; proof 469-471 and h=1 sketch 205-220)
Draft only: the `sorry`s are for the prover.
-/

open MeasureTheory

namespace Paper.P04

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- Main theorem (l.222-227).  For all `T ≥ h+1`, `e_T` is `ℱ_T`-measurable and an e-value under
`ℋ_{S;c}`.  Hypotheses: l.223 (`SeqSetting`, strict consistency, lag `h ≥ 1` from l.111),
the consumed T01 clause and the mixing-measure input. -/
theorem P04_main (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) :
    ∀ T : ℕ, h + 1 ≤ T → P04Conclusion S h ℱ Y c p q lam T := by
  sorry

/-- S1.  (source l.213-215 and 403, the factor-wise fact behind "e-value"; l.470 gives nothing.)
Every factor `E_{p_t,q_t;λ_t}(Y_{t+h})` is nonnegative.  Uses T01 consumed clause (l.403:
`E(y) ≥ 1-λ ≥ 0`) with `ν` from `hrep` and `P04_MixingOfStrict`; for `λ_t = 0` the factor is `1`;
for `p_t = q_t` the source (T01 needs `p ≠ q`) gives nothing: in Lean `Erep = 1` then. -/
theorem P04_S1 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) (ω : Ω) :
    0 ≤ Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) := by
  sorry

/-- S2.  (l.223 "are `ℱ_T`-measurable"; the source gives no justification.)  The factor
`ω ↦ E_{p_t,q_t;λ_t}(Y_{t+h}(ω))` is `ℱ_{t+h}`-measurable.  Silently needs measurability of
`S(·,y)` on `(0,1)` (not stated in the source; follows from consistency by monotonicity). -/
theorem P04_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) :
    Measurable[ℱ (t + h)] (fun ω => Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) := by
  sorry

/-- S3.  (l.223 "`e_T` are `ℱ_T`-measurable".)  From S2, `l + h ≤ T` for `l ∈ I_k`
(`l ≤ k + h(⌊(T-k)/h⌋ - 1)`), monotonicity of the filtration, finite products and sums. -/
theorem P04_S3 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) : Measurable[ℱ T] (eT S h Y p q lam T) := by
  sorry

/-- S4.  (h=1 sketch l.211-215, general lag l.469-470; X04.)  Pointwise preparation:
with `π_t = E_Q(Y_{t+h} | ℱ_t)`, a.s. `π_t ∈ [0,1]`, and (if `c_t = 1`) `π_t ∈ H_S(p_t,q_t)`,
i.e. `E_{π_t}{S(p_t,Y) - S(q_t,Y)} ≤ 0`.  The source states only
"almost surely for `Q ∈ ℋ_{S;c}`" (l.215) with no derivation of this identification. -/
theorem P04_S4 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) :
    ∀ᵐ ω ∂Q, 0 ≤ condExp (ℱ t) Q (Y (t + h)) ω ∧ condExp (ℱ t) Q (Y (t + h)) ω ≤ 1 ∧
      (c t ω = 1 → condExp (ℱ t) Q (Y (t + h)) ω ∈ HS S (p t ω) (q t ω)) := by
  sorry

/-- S5.  (l.213-215.)  One-step conditional e-value bound: for `Q ∈ ℋ_{S;c}` and `A ∈ ℱ_t`,
`∫_A E_{p_t,q_t;λ_t}(Y_{t+h}) dQ ≤ Q(A)` (the lintegral form of
`E_Q{E_{p_t,q_t;λ_t}(Y_{t+h}) | ℱ_t} ≤ 1` a.s.).  Uses S1, S4, the T01 consumed clause with
`ν` from `hrep` and `P04_MixingOfStrict` applied pointwise with `π_t` (X04), the case `c_t = 0`
(`λ_t = 0`, factor `≡ 1`, l.211) and `p_t = q_t` (factor `1`, not addressed by the source). -/
theorem P04_S5 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (A : Set Ω)
    (hA : MeasurableSet[ℱ t] A) :
    ∫⁻ ω in A, ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤ Q A := by
  sorry

/-- S6.  (l.209: "pull out the `ℱ_T`-measurable factors"; X07.)  For `ℱ_t`-measurable
`g : Ω → ℝ≥0∞`: `∫ g · E_t(Y_{t+h}) dQ ≤ ∫ g dQ`.  Uses S5. -/
theorem P04_S6 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (g : Ω → ENNReal)
    (hg : Measurable[ℱ t] g) :
    ∫⁻ ω, g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
      ≤ ∫⁻ ω, g ω ∂Q := by
  sorry

/-- S7.  (l.470: "sequential conditioning on `ℱ_{k+hl}` ... for each of the `h` products";
l.217-220 iteration.)  For each start `k` and number `n` of factors,
`E_Q ∏_{s<n} E_{k+hs}(Y_{k+hs+h}) ≤ 1`, by induction on `n`: condition on the time of the last
factor (`ℱ_{k+h(n-1)}`; the earlier factors are `ℱ_{k+h(n-1)}`-measurable by S2) and use S6.
NOTE: the source writes the conditioning σ-fields as `ℱ_{k+hl}`, `l = 1..⌊(T-k)/h⌋`, which is
shifted by `h` relative to what the argument needs (see notes, suspected issue). -/
theorem P04_S7 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (k n : ℕ) :
    ∫⁻ ω, ENNReal.ofReal (∏ s ∈ Finset.range n,
        Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω)
          (Y (k + h * s + h) ω)) ∂Q ≤ 1 := by
  sorry

/-- S8.  (l.223-226 "are e-values", l.220 averaging "in the spirit of U-statistics merging";
X07.)  `e_T ≥ 0` (S1, nonneg of products and the factor `1/h`) and
`E_Q e_T = (1/h) ∑_k E_Q ∏_{l∈I_k} ≤ 1`, using S7 with `n = ⌊(T-k)/h⌋` for each `k ∈ {1..h}`
(`I_k` is the image of `range n` under `s ↦ k + h s`).  The source gives no explicit
statement of this linearity/average step. -/
theorem P04_S8 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) :
    IsEValueUnder (eT S h Y p q lam T) (HScInt S h ℱ Y c p q) := by
  sorry

end Paper.P04
