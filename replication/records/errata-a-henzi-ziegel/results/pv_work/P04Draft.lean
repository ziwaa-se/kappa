import P04Stmt

/-!
# P04 draft, revision 1 (Proposition 3.4, `prop:combination`)

Source `source/VSIFP_02.tex`: statement l.216-221; `h = 1` computation l.199-214; remark on `ℋ_S`
l.135-138; proof for `h > 1` via the supermartingales `M^{[k]}` l.446-469 (its stopping-time part
l.456-468 is what Proposition 3.5 (P05) uses; P05's conclusion `E(e_{τ+h-1}) ≤ 1` is NOT stated here).
Draft only: the `sorry`s are for the prover.

Case structure (per the source): `h = 1` is the computation of l.199-214 (steps S5-S7);
`h > 1` is the proof of l.446-469 (steps S8-S11).  Steps S12-S14 are the stopping-time
ingredients of l.456-468, stated for P05 and not used by the main theorem.
-/

open MeasureTheory

namespace Paper.P04

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- Main theorem (l.216-221).  For all `T ≥ h+1`, `e_T` is `ℱ_T`-measurable and an e-value under
`ℋ_{S;c}`.  Hypotheses: l.217 (`SeqSetting`, strict consistency), lag `h ≥ 1` (l.108), the mixing
measure `ν` of `S` (l.90-102), the one-period consumed clause of T01 (l.143-148, first
hypothesis) and the l.103 sentence. -/
theorem P04_main (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) :
    ∀ T : ℕ, h + 1 ≤ T → P04Conclusion S h ℱ Y c p q lam T := by
  sorry

/-- S1.  (l.452 "nonnegative"; l.403 `E(y) ≥ 1 - λ ≥ 0`.  The source gives no justification for the
factors of the new proof.)  Every factor `E_{p_t,q_t;λ_t}(Y_{t+h})` is nonnegative.  Uses the one-period
consumed T01 clause (e-value, hence nonnegative) with `IsConsistent` from `hS.1` and the premise
`ν{[min,max)} > 0` obtained from `hMix` (l.103). -/
theorem P04_S1 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) (ω : Ω) :
    0 ≤ Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) := by
  sorry

/-- S2.  (l.220 "are `ℱ_T`-measurable"; the source gives no justification.)  The factor
`ω ↦ E_{p_t,q_t;λ_t}(Y_{t+h}(ω))` is `ℱ_{t+h}`-measurable.  Silently needs measurability of
`S(·,y)` on `(0,1)` (not stated in the source; follows from consistency by monotonicity). -/
theorem P04_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) :
    Measurable[ℱ (t + h)] (fun ω => Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) := by
  sorry

/-- S3.  (l.220 "`e_T` are `ℱ_T`-measurable"; no justification in the source.)  From S2, `l + h ≤ T`
for `l ∈ I_k` (`l ≤ k + h(⌊(T-k)/h⌋ - 1)`), monotonicity of the filtration, finite products and
sums. -/
theorem P04_S3 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) : Measurable[ℱ T] (eT S h Y p q lam T) := by
  sorry

/-- S4.  (l.205 "`E_{p_t,q_t;0} ≡ 1` if `c_t = 0`", with `λ_t = 0` if `c_t = 0` from l.217.)
If `c_t = 0` the factor is `1`. -/
theorem P04_S4 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (t : ℕ) (ω : Ω) (hc : c t ω = 0) :
    Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) = 1 := by
  sorry

/-- S0.  (l.205-209 one-step bound `E_Q{E_t(Y_{t+h}) | ℱ_t} ≤ 1` a.s. for `Q ∈ ℋ_{S;c}`, applied at
lag `h` at l.452; derivation: definition of `ℋ_{S;c}` (l.115), linearity, pull-out of the
`ℱ_t`-measurable `λ_t/D_t`, the case `c_t = 0` being S4.)  Integral form for `A ∈ ℱ_t`. -/
theorem P04_S0 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (A : Set Ω)
    (hA : MeasurableSet[ℱ t] A) :
    ∫⁻ ω in A, ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤ Q A := by
  sorry

/-! ### Case `h = 1` (l.199-214) -/

/-- S5.  (l.200-211, the display chain and "`E_Q{E_{p_T,q_T;λ_T}(Y_{T+1}) | ℱ_T} ≤ 1` a.s. for
`Q ∈ ℋ_{S;c}`" at l.207-209, and the conclusion l.211.)  For `h = 1`, `Q ∈ ℋ_{S;c}` and `n ≥ 0`
(`T = n + 1`): `E_Q ∏_{t=1}^{n+1} E_t(Y_{t+1}) ≤ E_Q ∏_{t=1}^{n} E_t(Y_{t+1})`.
Route of the source: condition on `ℱ_T` (l.202-203), pull out the `ℱ_T`-measurable factors of
`t < T` (needs S2, S1; "pull out" for nonnegative variables, silently), apply the one-step bound.
The one-step bound for `Q ∈ ℋ_{S;c}` is S0 (for `c_T = 1`; the case `c_T = 0`
is S4, l.205-207). -/
theorem P04_S5 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh1 : h = 1) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (n : ℕ) :
    ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 (n + 1),
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤
      ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 n,
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q := by
  sorry

/-- S6.  (l.214 "Iterating this argument shows that the product ... is an e-value for
`ℋ_{S;c}`".)  For `h = 1`, `Q ∈ ℋ_{S;c}`: `E_Q ∏_{t=1}^n E_t(Y_{t+1}) ≤ 1` for all `n`.  By
induction from S5, the empty product being `1`. -/
theorem P04_S6 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh1 : h = 1) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (n : ℕ) :
    ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 n,
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤ 1 := by
  sorry

/-- S7.  (l.217-221 for `h = 1`, with `I_1 = {1, …, T-1}`, `e_T = ∏_{t=1}^{T-1} E_t(Y_{t+1})`;
l.214.)  For `h = 1` and `T ≥ 2`, `e_T` is nonnegative and `E_Q e_T ≤ 1` on `ℋ_{S;c}`.  Uses S1, S6
with `n = T - 1`, and `Ik 1 T 1 = Icc 1 (T-1)` (the source's `T` in l.200-211 is shifted by one against
the `e_T` of l.218; noted). -/
theorem P04_S7 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh1 : h = 1) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) :
    IsEValueUnder (eT S h Y p q lam T) (HScInt S h ℱ Y c p q) := by
  sorry

/-! ### Case `h > 1` (l.446-469) -/

/-- S8.  (l.447-452 "Then `e_t = ∑_{k=1}^h M^{[k]}_t / h`".)  Unfolding of the definitions
(`eT`, `Mk`); holds for every `t`. -/
theorem P04_S8 (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ) (ω : Ω) :
    eT S h Y p q lam t ω = (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k t ω := by
  sorry

/-- S9a.  (l.452 "`(M^{[k]}_t)` is a nonnegative supermartingale with respect to `𝔉^{[k]}`":
adaptedness.  No justification in the source.)  `M^{[k]}_t` is `ℱ_{⌊(t-k)/h⌋h+k}`-measurable
(`ℱ_j` trivial for `j ≤ 0`): the factors `l ∈ I_k(t)` have `l + h ≤ ⌊(t-k)/h⌋h+k`.  Uses S2. -/
theorem P04_S9a (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (t : ℕ) :
    Measurable[filtK ℱ h k t] (Mk S h Y p q lam k t) := by
  sorry

/-- S9b.  (l.452 "nonnegative".)  `M^{[k]}_t ≥ 0`: a finite product of nonnegative factors (S1). -/
theorem P04_S9b (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (t : ℕ) (ω : Ω) :
    0 ≤ Mk S h Y p q lam k t ω := by
  sorry

/-- S9c.  (l.452 "supermartingale with respect to `𝔉^{[k]}` for any `Q ∈ ℋ_S`" -- the source gives NO
justification, and no definition of the supermartingale property beyond the word.)  Supermartingale
inequality in integral form (for nonnegative adapted `M` with `M_0 = 1`, this is the supermartingale
property including integrability): for `Q ∈ ℋ_{S;c}`, `A ∈ 𝔉^{[k]}_t`,
`∫_A M^{[k]}_{t+1} dQ ≤ ∫_A M^{[k]}_t dQ`.  Route (not in the source): `M^{[k]}_{t+1} = M^{[k]}_t` unless
`t + 1 ≡ k (mod h)`, in which case `M^{[k]}_{t+1} = M^{[k]}_t · E_{t+1-h}(Y_{t+1})`, `M^{[k]}_t` and `A` are
`ℱ_{t+1-h}`-measurable, and the one-step bound S0 applies.  Uses S9a, S0. -/
theorem P04_S9c (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (t : ℕ) (A : Set Ω) (hA : MeasurableSet[filtK ℱ h k t] A) :
    ∫⁻ ω in A, ENNReal.ofReal (Mk S h Y p q lam k (t + 1) ω) ∂Q ≤
      ∫⁻ ω in A, ENNReal.ofReal (Mk S h Y p q lam k t ω) ∂Q := by
  sorry

/-- S10.  (l.452 "and therefore satisfies `E_Q(M^{[k]}_{τ[k]}) ≤ 1` for any `𝔉^{[k]}`-stopping time
`τ[k]`".)  Optional stopping for a nonnegative supermartingale with `M_0 = 1` and a `ℕ`-valued
(finite) stopping time (standard fact (v), l.227 cites Ramdas et al. for `h = 1`).  Stopping time:
`{τ' ≤ t} ∈ 𝔉^{[k]}_t` for all `t`.  Uses S9a, S9b, S9c (and `M_0 = 1`, `I_k(0) = ∅`). -/
theorem P04_S10 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (τ' : Ω → ℕ)
    (hτ' : ∀ t, MeasurableSet[filtK ℱ h k t] {ω | τ' ω ≤ t}) :
    ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (τ' ω) ω) ∂Q ≤ 1 := by
  sorry

/-- S11.  (l.452-455, with deterministic `τ[k] ≡ T`; the displayed average at l.453-455.)  For `h > 1`
and `T ≥ h+1`: `e_T ≥ 0` and `E_Q e_T = (1/h) ∑_k E_Q M^{[k]}_T ≤ 1` on `ℋ_{S;c}`.  Uses S8, S9b, S10 with
the constant stopping time `T` (a stopping time for every filtration), and linearity of `∫⁻`.  (The source
does not say that `τ ≡ T` is used for the e-value statement of Proposition 3.4; the proof l.446-469 never
mentions measurability of `e_T`; see notes.) -/
theorem P04_S11 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) :
    IsEValueUnder (eT S h Y p q lam T) (HScInt S h ℱ Y c p q) := by
  sorry

/-! ### Stopping-time ingredients (l.456-468), for P05; not used by `P04_main` -/

/-- S12.  (l.456-459 "`f_k(τ) ∈ {τ, …, τ+h-1}`".)  Arithmetic: for `1 ≤ k ≤ h`,
`τ ≤ f_k(τ) ≤ τ + h - 1`. -/
theorem P04_S12 (h k τ : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    τ ≤ fk h k τ ∧ fk h k τ ≤ τ + h - 1 := by
  sorry

/-- S13.  (l.459-463 "`f_k(τ)` is an `𝔉^{[k]}`-stopping time".)  For an `𝔉`-stopping time `τ`
(`{τ ≤ n} ∈ ℱ_n`), `{f_k(τ) ≤ t} ∈ 𝔉^{[k]}_t`.  The source's argument: `t = k + hs + j`,
`f_k(τ) ≤ t ⇔ τ ≤ k + hs`.  (The source writes "`k ∈ {1, …, k}`" for `k ∈ {1, …, h}`: typo.)
`τ ∈ ℕ = {1,2,…}` (l.230), `ℱ_j` trivial for `j ≤ 0` (l.452); hence `hτ1`. -/
theorem P04_S13 (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0) (k : ℕ) (hk : k ∈ Finset.Icc 1 h)
    (τ : Ω → ℕ) (hτ : ∀ n, MeasurableSet[ℱ n] {ω | τ ω ≤ n}) (hτ1 : ∀ ω, 1 ≤ τ ω) (t : ℕ) :
    MeasurableSet[filtK ℱ h k t] {ω | fk h k (τ ω) ≤ t} := by
  sorry

/-- S14.  (l.468 "using the fact that `M_{t+h-1} = ∑_{k=1}^h M^{[k]}_{f_k(t)}/h` for `t ∈ ℕ`";
the source writes `M_t` for the e-value `e_t = ∑_k M^{[k]}_t/h` of l.452, never defining `M`
without superscript.)  Deterministic identity: `I_k(t + h - 1) = I_k(f_k(t))` since
`⌊(f_k(t) - k)/h⌋ = ⌊(t-k-1)/h⌋ + 1 = ⌊(t+h-1-k)/h⌋`. -/
theorem P04_S14 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ)
    (ht : 1 ≤ t) (ω : Ω) :
    eT S h Y p q lam (t + h - 1) ω =
      (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k (fk h k t) ω := by
  sorry

end Paper.P04
