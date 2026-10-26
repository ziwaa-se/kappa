import Mathlib

/-!
# Sequential e-values: one-step lemma, combination (Prop. 3.4), optional stopping (Prop. 3.5)

Setting: a probability space `(Ω, m0, μ)` with a discrete-time filtration `ℱ : Filtration ℕ m0`.
-/

open MeasureTheory ProbabilityTheory Filter Topology
open scoped ENNReal

namespace Sequential

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-! ## (A) One-step lemma -/

/-- **One-step lemma.** If `a` is `ℱ l`-measurable and bounded in `[0, C]`, `D` is integrable,
and `a * μ[D | ℱ l] ≤ 0` a.s. (this encodes the null hypothesis `H_{S;c}`: when `c_l = 0`
then `a = 0`, and when `c_l = 1` then `μ[D | ℱ l] ≤ 0`), then `Z = 1 + a D` satisfies
`μ[Z | ℱ l] ≤ 1` a.s. (No boundedness of `D` is needed.) -/
theorem condExp_one_add_mul_le_one (μ : Measure Ω) [IsProbabilityMeasure μ]
    (ℱ : Filtration ℕ m0) (l : ℕ) {a D : Ω → ℝ} {C : ℝ}
    (ha : StronglyMeasurable[ℱ l] a) (ha0 : ∀ ω, 0 ≤ a ω) (haC : ∀ ω, a ω ≤ C)
    (hD : Integrable D μ) (hnull : a * μ[D | ℱ l] ≤ᵐ[μ] 0) :
    μ[(fun ω => 1 + a ω * D ω) | ℱ l] ≤ᵐ[μ] 1 := by
  have haD : Integrable (a * D) μ := by
    have := hD.bdd_mul' (c := C) (ha.mono (ℱ.le l)).aestronglyMeasurable
      (ae_of_all _ fun ω => by
        rw [Real.norm_eq_abs, abs_of_nonneg (ha0 ω)]; exact haC ω)
    exact this
  have h1 : (fun ω => 1 + a ω * D ω) = (fun _ : Ω => (1 : ℝ)) + a * D := by
    funext ω; simp
  rw [h1]
  have hadd := condExp_add (m := ℱ l) (integrable_const (1 : ℝ)) haD
  have hmul := condExp_mul_of_stronglyMeasurable_left ha haD hD
  rw [condExp_const (ℱ.le l)] at hadd
  filter_upwards [hadd, hmul, hnull] with ω h1 h2 h3
  rw [h1]
  simp only [Pi.add_apply, Pi.mul_apply, Pi.zero_apply, Pi.one_apply] at h2 h3 ⊢
  rw [h2]; linarith

/-! ## (B) Products of sequential e-values -/

section Product

variable (μ : Measure Ω) [IsProbabilityMeasure μ] (ℱ : Filtration ℕ m0)

/-- Partial products are bounded: `0 ≤ ∏ ≤ |C|^n`. -/
lemma prod_bounds {Z : ℕ → Ω → ℝ} {C : ℝ} (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (f : ℕ → ℕ) (n : ℕ) (ω : Ω) :
    0 ≤ ∏ s ∈ Finset.range n, Z (f s) ω ∧ ∏ s ∈ Finset.range n, Z (f s) ω ≤ |C| ^ n := by
  refine ⟨Finset.prod_nonneg fun s _ => hZ0 _ _, ?_⟩
  calc ∏ s ∈ Finset.range n, Z (f s) ω ≤ ∏ _s ∈ Finset.range n, |C| :=
        Finset.prod_le_prod (fun s _ => hZ0 _ _) (fun s _ => (hZC _ _).trans (le_abs_self C))
    _ = |C| ^ n := by simp

/-- The partial product `P_n = ∏_{s<n} Z (k + h s)` is `ℱ (k + h n)`-measurable. -/
lemma prod_stronglyMeasurable {Z : ℕ → Ω → ℝ} {h : ℕ}
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + h)] (Z l)) (k n : ℕ) :
    StronglyMeasurable[ℱ (k + h * n)] (fun ω => ∏ s ∈ Finset.range n, Z (k + h * s) ω) := by
  induction n with
  | zero => simpa using (stronglyMeasurable_const : StronglyMeasurable[ℱ (k + h * 0)]
      (fun _ : Ω => (1 : ℝ)))
  | succ n ih =>
    simp only [Finset.prod_range_succ]
    have hle : ℱ (k + h * n) ≤ ℱ (k + h * (n + 1)) := ℱ.mono (by nlinarith)
    have h2 : StronglyMeasurable[ℱ (k + h * (n + 1))] (Z (k + h * n)) := by
      have := hZm (k + h * n)
      have e : k + h * n + h = k + h * (n + 1) := by ring
      rwa [e] at this
    exact (ih.mono hle).mul h2

/-- **Proposition 3.4 (combination of e-values), product form.**
If each `Z l` is bounded in `[0, C]`, `ℱ (l + h)`-measurable and satisfies `μ[Z l | ℱ l] ≤ 1`,
then for every offset `k` and length `n`, the product of the `h`-spaced factors
`Z k, Z (k+h), …, Z (k + h (n-1))` has expectation at most `1`.
(The hypothesis `h ≥ 1` is not needed for this statement.) -/
theorem integral_prod_le_one {Z : ℕ → Ω → ℝ} {C : ℝ} {h : ℕ}
    (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + h)] (Z l))
    (hZce : ∀ l, μ[Z l | ℱ l] ≤ᵐ[μ] 1) (k n : ℕ) :
    ∫ ω, ∏ s ∈ Finset.range n, Z (k + h * s) ω ∂μ ≤ 1 := by
  induction n with
  | zero => simp
  | succ n ih =>
    set P : Ω → ℝ := fun ω => ∏ s ∈ Finset.range n, Z (k + h * s) ω with hPdef
    set m := ℱ (k + h * n)
    set g := Z (k + h * n)
    have hP : StronglyMeasurable[m] P := prod_stronglyMeasurable ℱ hZm k n
    have hPb := prod_bounds hZ0 hZC (fun s => k + h * s) n
    have hPbound : ∀ᵐ ω ∂μ, ‖P ω‖ ≤ |C| ^ n := ae_of_all _ fun ω => by
      rw [Real.norm_eq_abs, abs_of_nonneg (hPb ω).1]; exact (hPb ω).2
    have hg : Integrable g μ := by
      refine Integrable.mono' (integrable_const |C|)
        ((hZm _).mono (ℱ.le _)).aestronglyMeasurable (ae_of_all _ fun ω => ?_)
      rw [Real.norm_eq_abs, abs_of_nonneg (hZ0 _ ω)]; exact (hZC _ ω).trans (le_abs_self C)
    have hPint : Integrable P μ :=
      Integrable.mono' (integrable_const (|C| ^ n)) (hP.mono (ℱ.le _)).aestronglyMeasurable
        hPbound
    have heq : (fun ω => ∏ s ∈ Finset.range (n + 1), Z (k + h * s) ω) = P * g := by
      funext ω; simp [hPdef, g, Finset.prod_range_succ]
    rw [heq]
    have hpull := condExp_stronglyMeasurable_mul_of_bound (ℱ.le (k + h * n)) hP hg _ hPbound
    calc ∫ ω, (P * g) ω ∂μ = ∫ ω, (μ[P * g | m]) ω ∂μ := (integral_condExp (ℱ.le _)).symm
      _ = ∫ ω, (P * μ[g | m]) ω ∂μ := integral_congr_ae hpull
      _ ≤ ∫ ω, P ω ∂μ := by
          refine integral_mono_ae ?_ hPint ?_
          · exact integrable_condExp.bdd_mul' (hP.mono (ℱ.le _)).aestronglyMeasurable hPbound
          · filter_upwards [hZce (k + h * n)] with ω hω
            simp only [Pi.mul_apply, Pi.one_apply] at hω ⊢
            exact mul_le_of_le_one_right (hPb ω).1 hω
      _ ≤ 1 := ih

/-- **Proposition 3.4 (combination of e-values), averaged form.**
The average over the `h` offsets `k = 1, …, h` of the `h`-spaced products
`∏_{s < (T - k)/h} Z (k + h s)` has expectation at most `1`.
(For `h = 0` the statement is trivially true since `1/0 = 0` in Lean; so `h ≥ 1` is not
needed as a hypothesis.) -/
theorem integral_avg_prod_le_one {Z : ℕ → Ω → ℝ} {C : ℝ} {h : ℕ}
    (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + h)] (Z l))
    (hZce : ∀ l, μ[Z l | ℱ l] ≤ᵐ[μ] 1) (T : ℕ) :
    ∫ ω, (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h,
      ∏ s ∈ Finset.range ((T - k) / h), Z (k + h * s) ω ∂μ ≤ 1 := by
  have hint : ∀ k n, Integrable (fun ω => ∏ s ∈ Finset.range n, Z (k + h * s) ω) μ := by
    intro k n
    have hPb := prod_bounds hZ0 hZC (fun s => k + h * s) n
    refine Integrable.mono' (integrable_const (|C| ^ n))
      ((prod_stronglyMeasurable ℱ hZm k n).mono (ℱ.le _)).aestronglyMeasurable
      (ae_of_all _ fun ω => ?_)
    rw [Real.norm_eq_abs, abs_of_nonneg (hPb ω).1]; exact (hPb ω).2
  rw [integral_const_mul, integral_finset_sum _ (fun k _ => hint k _)]
  have hsum : ∑ k ∈ Finset.Icc 1 h,
      ∫ ω, ∏ s ∈ Finset.range ((T - k) / h), Z (k + h * s) ω ∂μ ≤ (h : ℝ) := by
    calc _ ≤ ∑ _k ∈ Finset.Icc 1 h, (1 : ℝ) :=
          Finset.sum_le_sum fun k _ => integral_prod_le_one μ ℱ hZ0 hZC hZm hZce k _
      _ = (h : ℝ) := by simp
  rcases Nat.eq_zero_or_pos h with h0 | hpos
  · subst h0; simp
  · have hh : (0 : ℝ) < h := by exact_mod_cast hpos
    calc 1 / (h : ℝ) * _ ≤ 1 / (h : ℝ) * h :=
          mul_le_mul_of_nonneg_left hsum (by positivity)
      _ = 1 := by field_simp

end Product

/-! ## (C) Optional stopping, case `h = 1` -/

section OptionalStopping

variable (μ : Measure Ω) [IsProbabilityMeasure μ] (ℱ : Filtration ℕ m0)

/-- The running product `e t = ∏_{s < t} Z s` of the sequential e-values (case `h = 1`). -/
def eproc (Z : ℕ → Ω → ℝ) (t : ℕ) (ω : Ω) : ℝ := ∏ s ∈ Finset.range t, Z s ω

variable {Z : ℕ → Ω → ℝ} {C : ℝ}

lemma eproc_stronglyMeasurable (hZm : ∀ l, StronglyMeasurable[ℱ (l + 1)] (Z l)) (t : ℕ) :
    StronglyMeasurable[ℱ t] (eproc Z t) := by
  have := prod_stronglyMeasurable ℱ (h := 1) hZm 0 t
  simpa [eproc] using this

lemma eproc_integrable (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + 1)] (Z l)) (t : ℕ) :
    Integrable (eproc Z t) μ := by
  have hPb := prod_bounds hZ0 hZC (fun s => s) t
  refine Integrable.mono' (integrable_const (|C| ^ t))
    ((eproc_stronglyMeasurable ℱ hZm t).mono (ℱ.le _)).aestronglyMeasurable
    (ae_of_all _ fun ω => ?_)
  rw [Real.norm_eq_abs, eproc, abs_of_nonneg (hPb ω).1]; exact (hPb ω).2

/-- **Proposition 3.5, case `h = 1`: the e-process is a supermartingale.**
`e t = ∏_{s<t} Z s` is adapted to `ℱ` and `μ[e (t+1) | ℱ t] = e t * μ[Z t | ℱ t] ≤ e t`. -/
theorem eproc_supermartingale (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + 1)] (Z l))
    (hZce : ∀ l, μ[Z l | ℱ l] ≤ᵐ[μ] 1) :
    Supermartingale (eproc Z) ℱ μ := by
  refine supermartingale_nat (fun t => eproc_stronglyMeasurable ℱ hZm t)
    (eproc_integrable μ ℱ hZ0 hZC hZm) fun t => ?_
  have hPb := prod_bounds hZ0 hZC (fun s => s) t
  have hPbound : ∀ᵐ ω ∂μ, ‖eproc Z t ω‖ ≤ |C| ^ t := ae_of_all _ fun ω => by
    rw [Real.norm_eq_abs, eproc, abs_of_nonneg (hPb ω).1]; exact (hPb ω).2
  have hg : Integrable (Z t) μ := by
    refine Integrable.mono' (integrable_const |C|)
      ((hZm _).mono (ℱ.le _)).aestronglyMeasurable (ae_of_all _ fun ω => ?_)
    rw [Real.norm_eq_abs, abs_of_nonneg (hZ0 _ ω)]; exact (hZC _ ω).trans (le_abs_self C)
  have heq : eproc Z (t + 1) = eproc Z t * Z t := by
    funext ω; simp [eproc, Finset.prod_range_succ]
  rw [heq]
  have hpull := condExp_stronglyMeasurable_mul_of_bound (ℱ.le t)
    (eproc_stronglyMeasurable ℱ hZm t) hg _ hPbound
  filter_upwards [hpull, hZce t] with ω h1 h2
  rw [h1]
  simp only [Pi.mul_apply, Pi.one_apply] at h2 ⊢
  exact mul_le_of_le_one_right (hPb ω).1 h2

/-- **Proposition 3.5 (optional stopping), case `h = 1`, bounded stopping times.**
For every stopping time `τ` bounded by `N`, `𝔼[e_τ] ≤ 1`. -/
theorem integral_stoppedValue_le_one (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + 1)] (Z l))
    (hZce : ∀ l, μ[Z l | ℱ l] ≤ᵐ[μ] 1)
    {τ : Ω → ℕ} (hτ : IsStoppingTime ℱ τ) {N : ℕ} (hbdd : ∀ ω, τ ω ≤ N) :
    ∫ ω, stoppedValue (eproc Z) τ ω ∂μ ≤ 1 := by
  have hsub := (eproc_supermartingale μ ℱ hZ0 hZC hZm hZce).neg
  have h := hsub.expected_stoppedValue_mono (isStoppingTime_const ℱ 0) hτ
    (fun ω => Nat.zero_le (τ ω)) hbdd
  have hneg : ∀ σ : Ω → ℕ, stoppedValue (-eproc Z) σ = fun ω => -stoppedValue (eproc Z) σ ω := by
    intro σ; funext ω; simp [stoppedValue]
  rw [hneg, hneg, integral_neg, integral_neg, neg_le_neg_iff] at h
  refine h.trans (le_of_eq ?_)
  simp [stoppedValue, eproc]

/-- **Proposition 3.5 (optional stopping), case `h = 1`, arbitrary stopping times.**
For an arbitrary (possibly unbounded) `ℕ`-valued stopping time `τ` (hence finite everywhere),
`𝔼[e_τ] ≤ 1`, stated with the lower Lebesgue integral since `e_τ` need not be integrable a
priori. Proof: Fatou's lemma applied to `e_{τ ∧ n} → e_τ`. -/
theorem lintegral_stoppedValue_le_one (hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C)
    (hZm : ∀ l, StronglyMeasurable[ℱ (l + 1)] (Z l))
    (hZce : ∀ l, μ[Z l | ℱ l] ≤ᵐ[μ] 1)
    {τ : Ω → ℕ} (hτ : IsStoppingTime ℱ τ) :
    ∫⁻ ω, ENNReal.ofReal (stoppedValue (eproc Z) τ ω) ∂μ ≤ 1 := by
  set f : ℕ → Ω → ℝ≥0∞ := fun n ω =>
    ENNReal.ofReal (stoppedValue (eproc Z) (fun ω => min (τ ω) n) ω) with hf
  have hτn : ∀ n, IsStoppingTime ℱ (fun ω => min (τ ω) n) := fun n =>
    hτ.min (isStoppingTime_const ℱ n)
  have hint : ∀ n, Integrable (stoppedValue (eproc Z) (fun ω => min (τ ω) n)) μ := fun n =>
    integrable_stoppedValue ℕ (hτn n) (eproc_integrable μ ℱ hZ0 hZC hZm)
      (fun ω => min_le_right _ _)
  have hlim : ∀ ω, liminf (fun n => f n ω) atTop =
      ENNReal.ofReal (stoppedValue (eproc Z) τ ω) := by
    intro ω
    apply Tendsto.liminf_eq
    apply tendsto_atTop_of_eventually_const (i₀ := τ ω)
    intro n hn
    simp [hf, stoppedValue, min_eq_left hn]
  have hle : ∀ n, ∫⁻ ω, f n ω ∂μ ≤ 1 := by
    intro n
    rw [hf, ← ofReal_integral_eq_lintegral_ofReal (hint n)
      (ae_of_all _ fun ω => (prod_bounds hZ0 hZC (fun s => s) _ ω).1)]
    calc ENNReal.ofReal _ ≤ ENNReal.ofReal 1 :=
          ENNReal.ofReal_le_ofReal
            (integral_stoppedValue_le_one μ ℱ hZ0 hZC hZm hZce (hτn n) (fun ω => min_le_right _ _))
      _ = 1 := ENNReal.ofReal_one
  calc ∫⁻ ω, ENNReal.ofReal (stoppedValue (eproc Z) τ ω) ∂μ
      = ∫⁻ ω, liminf (fun n => f n ω) atTop ∂μ := by simp_rw [hlim]
    _ ≤ liminf (fun n => ∫⁻ ω, f n ω ∂μ) atTop :=
        lintegral_liminf_le' fun n => (hint n).aemeasurable.ennreal_ofReal
    _ ≤ 1 := liminf_le_of_frequently_le' (Eventually.of_forall hle).frequently

end OptionalStopping

end Sequential
