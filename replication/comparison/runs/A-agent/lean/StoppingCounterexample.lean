import Mathlib

/-!
# Counterexample to Proposition 3.5 for lag `h = 2`

Proposition 3.5 claims `E_Q(e_τ) ≤ 1` for every a.s. finite stopping time `τ`, for all
`Q ∈ H_S`, where (Proposition 3.4)
`e_T = (1/h) ∑_{k=1}^h ∏_{l ∈ I_k} E_{p_l,q_l;λ_l}(Y_{l+h})`,
`I_k = {k + h s : s = 0, …, ⌊(T-k)/h⌋ - 1}`.

We take `h = 2`, the Brier score, constant forecasts `p_t = 1/5`, `q_t = 3/5`,
`λ_t = 1`, `c_t = 1`, and observations
`Y_3 ~ Bernoulli(2/5)`, `Y_4 = Y_3`, `Y_t = 0` otherwise,
with the *natural* filtration of `Y` (`ℱ_t` trivial for `t ≤ 2`, everything for `t ≥ 3`).
The Brier boundary is `κ = (p+q)/2 = 2/5`, so the null hypothesis `H_S` holds at every `t`
(with equality at `t = 1, 2`).  The stopping time `τ = 3` if `Y_3 = 0`, `τ = 4` if `Y_3 = 1`
exploits the fact that at time 3 one already knows the outcome `Y_4` of the pending bet
`E_{p_2,q_2;λ_2}(Y_4)`, and `E(e_τ) = 13/10 > 1`.
-/

open MeasureTheory

noncomputable section

namespace Counterexample

/-- Probability space: `Ω = Bool` (the value of `Y_3`), with `P(true) = 2/5`. -/
abbrev Ω := Bool

lemma h25 : (2/5 : ENNReal) ≤ 1 := by
  rw [ENNReal.div_le_iff (by norm_num) (by norm_num)]; norm_num

def P : PMF Ω := PMF.bernoulli (2/5) h25

def μ : Measure Ω := P.toMeasure

instance : IsProbabilityMeasure μ := by unfold μ; infer_instance

lemma P_true : (P true).toReal = 2/5 := by
  simp only [P, PMF.bernoulli_apply, cond_true]
  rw [ENNReal.toReal_div]; norm_num

lemma P_false : (P false).toReal = 3/5 := by
  simp only [P, PMF.bernoulli_apply, cond_false]
  rw [ENNReal.toReal_sub_of_le h25 ENNReal.one_ne_top, ENNReal.toReal_div]; norm_num

/-- Integrals over `μ` are finite sums. -/
lemma integral_μ (f : Ω → ℝ) : ∫ ω, f ω ∂μ = 3/5 * f false + 2/5 * f true := by
  rw [μ, PMF.integral_eq_sum]
  simp [Fintype.sum_bool, P_true, P_false]; ring

/-- Observations: `Y_3 = Y_4 = 1{ω = true}`, all other `Y_t = 0`. -/
def Y (t : ℕ) (ω : Ω) : ℝ := if t = 3 ∨ t = 4 then (if ω then 1 else 0) else 0

/-- Forecasts (constant) and the Brier score. -/
def p : ℝ := 1/5
def q : ℝ := 3/5
def S (x y : ℝ) : ℝ := (x - y) ^ 2

/-- Score difference `d(y) = S(p,y) - S(q,y)`. -/
def d (y : ℝ) : ℝ := S p y - S q y

lemma d_zero : d 0 = -8/25 := by norm_num [d, S, p, q]
lemma d_one : d 1 = 12/25 := by norm_num [d, S, p, q]

/-- The e-value `E_{p,q;λ}(y)` of eq. (4) with `λ = 1` (here `p < q`, so `1{p>q} = 0`). -/
def lam : ℝ := 1
def E (y : ℝ) : ℝ := 1 + lam * d y / |d 0|

lemma E_zero : E 0 = 0 := by
  rw [E, d_zero, abs_of_neg (by norm_num)]; norm_num [lam]
lemma E_one : E 1 = 5/2 := by
  rw [E, d_zero, d_one, abs_of_neg (by norm_num)]; norm_num [lam]

/-- Lag. -/
def h : ℕ := 2

/-- Factors `Z_l = E_{p_l,q_l;λ_l}(Y_{l+h})`. -/
def Z (l : ℕ) (ω : Ω) : ℝ := E (Y (l + h) ω)

/-- The combined e-value `e_T` of Proposition 3.4. -/
def e (T : ℕ) (ω : Ω) : ℝ :=
  (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, ∏ s ∈ Finset.range ((T - k) / h), Z (k + h * s) ω

/-- Natural filtration of `Y`: trivial up to time 2, full from time 3 on. -/
def ℱ : Filtration ℕ (inferInstance : MeasurableSpace Ω) where
  seq t := if t ≤ 2 then ⊥ else ⊤
  mono' := by
    intro i j hij
    simp only
    split_ifs <;> first | exact le_rfl | exact bot_le | exact le_top | (exfalso; omega)
  le' := fun _ s _ => MeasurableSet.of_discrete

lemma ℱ_small {t : ℕ} (ht : t ≤ 2) : ℱ t = ⊥ := by
  show (if t ≤ 2 then ⊥ else ⊤) = _; rw [if_pos ht]

lemma ℱ_large {t : ℕ} (ht : ¬ t ≤ 2) : ℱ t = ⊤ := by
  show (if t ≤ 2 then ⊥ else ⊤) = _; rw [if_neg ht]

/-- `Y` is adapted to `ℱ`. -/
lemma Y_adapted : Adapted ℱ Y := by
  intro t
  by_cases ht : t ≤ 2
  · have : Y t = fun _ => 0 := by
      funext ω; simp only [Y]; rw [if_neg (by omega)]
    rw [this]; exact stronglyMeasurable_const
  · rw [ℱ_large ht]
    exact @StronglyMeasurable.of_discrete _ _ ⊤ _ _ _ _

/-- `ℱ` is the natural filtration of `Y`: for `t ≥ 3`, `Y_3` already generates everything
(for `t ≤ 2` all of `Y_0, …, Y_t` are constant). -/
lemma ℱ_natural {t : ℕ} (ht : ¬ t ≤ 2) :
    ℱ t = MeasurableSpace.comap (Y 3) inferInstance := by
  rw [ℱ_large ht]
  apply le_antisymm _ le_top
  intro s _
  refine ⟨Y 3 '' s, (Set.toFinite _).measurableSet, ?_⟩
  ext ω
  simp only [Set.mem_preimage, Set.mem_image]
  constructor
  · rintro ⟨ω', hω', heq⟩
    have : ω' = ω := by
      cases ω <;> cases ω' <;> simp_all [Y]
    exact this ▸ hω'
  · intro hω; exact ⟨ω, hω, rfl⟩

/-- **The null hypothesis `H_S` holds** (with `c_t = 1` for all `t`):
`E[S(p_t, Y_{t+2}) - S(q_t, Y_{t+2}) | ℱ_t] ≤ 0` a.s. for every `t`. -/
lemma null_holds (t : ℕ) : μ[fun ω => d (Y (t + h) ω) | ℱ t] ≤ᵐ[μ] 0 := by
  by_cases ht : t ≤ 2
  · rw [ℱ_small ht, condExp_bot']
    refine Filter.Eventually.of_forall (fun ω => ?_)
    simp only [Pi.zero_apply, integral_μ, measureReal_univ_eq_one, inv_one, one_smul]
    interval_cases t <;> norm_num [Y, h, d_zero, d_one]
  · have hc : (fun ω => d (Y (t + h) ω)) = fun _ => d 0 := by
      funext ω; simp only [Y, h]; rw [if_neg (by omega)]
    rw [hc, condExp_const (ℱ.le t)]
    exact Filter.Eventually.of_forall (fun ω => by rw [d_zero]; norm_num)

/-- The stopping time: stop at 3 if `Y_3 = 0`, otherwise at 4. -/
def τ (ω : Ω) : ℕ := if ω then 4 else 3

lemma τ_isStoppingTime : IsStoppingTime ℱ τ := by
  intro i
  by_cases hi : i ≤ 2
  · have : {ω | τ ω ≤ i} = ∅ := by
      ext ω; cases ω <;> simp [τ] <;> omega
    rw [this]; exact @MeasurableSet.empty Ω (ℱ i)
  · exact (ℱ_large hi).symm ▸ @MeasurableSpace.measurableSet_top Ω _

lemma e3 (ω : Ω) : e 3 ω = (Z 1 ω + 1) / 2 := by
  simp [e, h, Finset.sum_Icc_succ_top, Finset.prod_range_succ]; ring

lemma e4 (ω : Ω) : e 4 ω = (Z 1 ω + Z 2 ω) / 2 := by
  simp [e, h, Finset.sum_Icc_succ_top, Finset.prod_range_succ]; ring

/-- Fixed-time e-values are valid (consistent with Proposition 3.4). -/
lemma e3_valid : ∫ ω, e 3 ω ∂μ = 1 := by
  rw [integral_μ]; simp only [e3, Z, Y, h]; norm_num [E_zero, E_one]

lemma e4_valid : ∫ ω, e 4 ω ∂μ = 1 := by
  rw [integral_μ]; simp only [e4, Z, Y, h]; norm_num [E_zero, E_one]

/-- **Proposition 3.5 fails for `h = 2`**: `E(e_τ) = 13/10 > 1`. -/
theorem stopped_evalue : ∫ ω, e (τ ω) ω ∂μ = 13/10 := by
  rw [integral_μ]
  simp only [τ, Bool.false_eq_true, ↓reduceIte, e3, e4, Z, Y, h]; norm_num [E_zero, E_one]

theorem prop_3_5_false_h2 :
    Adapted ℱ Y ∧ (∀ t, μ[fun ω => d (Y (t + h) ω) | ℱ t] ≤ᵐ[μ] 0) ∧
    IsStoppingTime ℱ τ ∧ 1 < ∫ ω, e (τ ω) ω ∂μ :=
  ⟨Y_adapted, null_holds, τ_isStoppingTime, by rw [stopped_evalue]; norm_num⟩

/-- The paper's actual stopping *procedure* (Section 3.2 / Appendix B: set `λ_t = 0` for
`t ≥ τ` and report `e_{τ+h-1}`) is fine here: with `τ = 3` the pending factor
`E(Y_4) = 0` is still included.  We record the value of that procedure: -/
lemma procedure_value : ∫ ω, (if ω then e 4 ω else (Z 1 ω + Z 2 ω) / 2) ∂μ = 1 := by
  rw [integral_μ]; simp only [e4, Z, Y, h]; norm_num [E_zero, E_one]

end Counterexample
