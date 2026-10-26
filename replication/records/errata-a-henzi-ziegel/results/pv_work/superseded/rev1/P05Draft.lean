import P05Stmt

/-!
# P05 draft (source/VSIFP_02.tex:235-240, Proposition 3.5 `prop:stopping`; proof l.473-478)
Draft only: the `sorry`s are for the prover.
-/

open MeasureTheory

namespace Paper.P05

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- Main theorem (l.235-240).  `τ ∈ ℕ` a stopping time (modelled as `τ : Ω → ℕ`, see notes on
"almost surely finite"), `e_τ(ω) = e_{τ ω}(ω)` with `e_T = P04.eT` (l.224-225).  Assumptions of
P04 (l.236): `SeqSetting`, strictly consistent `S`.  Conclusion: `E_Q(e_τ) ≤ 1` for `Q ∈ ℋ_S`
(`c ≡ 1`, l.238; the assumption `SeqSetting` keeps the general `c_t`, A08).  `e_τ ≥ 0` is part of
the consumed clause, so the lower integral of `ofReal e_τ` is `E_Q e_τ`.
CANDIDATE TFA: `τ ≥ h+1` Q-a.s. (`e_T` is defined only for `T ≥ h+1`, l.223; A07). -/
theorem P05_main (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStoppingTime ℱ τ) :
    ∀ Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q,
      (∀ᵐ ω ∂Q, h + 1 ≤ τ ω) →
      ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω) ∂Q ≤ 1 := by
  sorry

/-- S0 (candidate-TFA bookkeeping, not in the source).  `Q{τ = t} = 0` for `t ≤ h`, from the extra
premise `τ ≥ h+1` a.s.  Only needed because the source sums over all `t ≥ 1` (l.476) although
`e_t` is defined only for `t ≥ h+1`. -/
theorem P05_S0 (h : ℕ) (Q : Measure Ω) (τ : Ω → ℕ) (hτ1 : ∀ᵐ ω ∂Q, h + 1 ≤ τ ω) (t : ℕ)
    (ht : t ≤ h) : Q {ω | τ ω = t} = 0 := by
  sorry

/-- Sapp.  (source l.236 "under the assumptions of Lemma prop:combination", l.238 `ℋ_S`; l.116-122.)
`ℋ_S ⊆ ℋ_{S;c}` since `c_t ∈ {0,1}`: so `Q ∈ ℋ_S` lets the P04 clause (stated for `ℋ_{S;c}`) be
applied.  FAIR_IMPLICIT_STEP.  Uses `hset.c_mem`. -/
theorem P05_Sapp (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q) :
    Q ∈ Paper.P04.HScInt S h ℱ Y c p q := by
  sorry

/-- Snn.  (source l.226 P04 conclusion; presupposed at l.474-476 by writing `E(e_t | F_t)`.)
For `t ≥ h+1` and `Q ∈ ℋ_{S;c}`: `e_t ≥ 0` and `e_t` is `Q`-integrable.  Follows from the P04
clause (nonnegativity, `ℱ t ≤ m0` measurability, `∫⁻ ≤ 1`).  Uses `hP04`, `P05_Sapp`. -/
theorem P05_Snn (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t) :
    (∀ ω, 0 ≤ Paper.P04.eT S h Y p q lam t ω) ∧ Integrable (Paper.P04.eT S h Y p q lam t) Q := by
  sorry

/-- Sbridge.  (source l.236 / l.474: "`e_t`, `t ∈ ℕ`, a sequence of random variables such that
`E(e_t | F_t) ≤ 1` almost surely", applied to P04's `e_t`.)  NOT justified by the source: P04 gives
only `E_Q e_t ≤ 1`, and since `e_t` is `ℱ_t`-measurable this is equivalent to `e_t ≤ 1` `Q`-a.s.,
expected FALSE as stated in non-degenerate cases.  Suspected PAPER_ARGUMENT_GAP; recorded as an
obligation, and the prover must not try to prove it by another route. -/
theorem P05_Sbridge (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (hh : 1 ≤ h)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t) :
    ∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1 := by
  sorry

/-- S1.  (source l.476, first equality `E(e_τ) = ∑_{t≥1} E{e_t 1(τ=t)}`; l.474 "almost surely
finite stopping time".)  Decomposition of `e_τ` along the (a.s. partition) events `{τ = t}` and
interchange of sum and expectation (nonnegative terms; the source does not name the theorem
used). -/
theorem P05_S1 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y p q lam : ℕ → Ω → ℝ)
    (τ : Ω → ℕ) (hτ : IsStoppingTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (hτ1 : ∀ᵐ ω ∂Q, h + 1 ≤ τ ω) :
    ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω) ∂Q
      = ∑' t : ℕ, ∫⁻ ω in {ω | τ ω = t}, ENNReal.ofReal (Paper.P04.eT S h Y p q lam t ω) ∂Q := by
  sorry

/-- S2.  (source l.474 "by the definition of the conditional expectation with respect to a
σ-field", l.476 second equality `E{e_t 1(τ=t)} = E{E(e_t | F_t) 1(τ=t)}`.)  Uses `{τ = t} ∈ ℱ_t`
(stopping time), integrability of `e_t` and the defining property of `condExp`.  Source does not
mention integrability or that `{τ = t} ∈ ℱ_t`. For `t ≥ h+1`. -/
theorem P05_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y p q lam : ℕ → Ω → ℝ)
    (τ : Ω → ℕ) (hτ : IsStoppingTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t)
    (h0 : ∀ ω, 0 ≤ Paper.P04.eT S h Y p q lam t ω)
    (hint : Integrable (Paper.P04.eT S h Y p q lam t) Q) :
    ∫⁻ ω in {ω | τ ω = t}, ENNReal.ofReal (Paper.P04.eT S h Y p q lam t ω) ∂Q
      = ∫⁻ ω in {ω | τ ω = t},
          ENNReal.ofReal (condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω) ∂Q := by
  sorry

/-- S3.  (source l.476 "`E(e_t | F_t)` ≤ 1 a.s." underbrace, and the integrated inequality
`E{E(e_t|F_t) 1(τ=t)} ≤ E 1(τ=t)`.)  Uses the conditional bound `hcb` (= `P05_Sbridge`, NOT
given by P04). -/
theorem P05_S3 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y p q lam : ℕ → Ω → ℝ)
    (τ : Ω → ℕ)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t)
    (hcb : ∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1) :
    ∫⁻ ω in {ω | τ ω = t},
        ENNReal.ofReal (condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω) ∂Q
      ≤ Q {ω | τ ω = t} := by
  sorry

/-- S4.  (source l.476 last `≤ 1`; implicit: events `{τ = t}` are disjoint and `Q` is a
probability measure, `τ` finite so they exhaust `Ω`.)  `∑_t Q{τ = t} ≤ 1`. -/
theorem P05_S4 (Q : Measure Ω) [IsProbabilityMeasure Q] (τ : Ω → ℕ) (hτm : Measurable τ) :
    ∑' t : ℕ, Q {ω | τ ω = t} ≤ 1 := by
  sorry

end Paper.P05
