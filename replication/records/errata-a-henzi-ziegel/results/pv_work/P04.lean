import P04Stmt

/-!
# P04 proof (Proposition 3.4, `prop:combination`), source `source/VSIFP_02.tex`
statement l.216-221; `h = 1` computation l.199-214; proof for `h > 1` l.446-469.
Revision 1, pass 1.  Private helpers are technical conversions only (see notes).
-/

open MeasureTheory

namespace Paper.P04

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- helper (technical): `S(·,0)` is nondecreasing on `[0,1]` for consistent `S`. -/
private lemma S0_mono {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {p q : ℝ}
    (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) (hpq : p ≤ q) : S p 0 ≤ S q 0 := by
  rcases eq_or_lt_of_le hpq with rfl | hlt
  · exact le_rfl
  have h1 := hc q hq p hp
  have h2 := hc p hp q hq
  simp only [expPi] at h1 h2
  have hq0 : 0 ≤ q := hq.1
  have hp0 : 0 ≤ p := hp.1
  have h1d : 0 ≤ (1 - p) * (S q 0 - S p 0) + p * (S q 1 - S p 1) := by nlinarith
  have h2d : (1 - q) * (S q 0 - S p 0) + q * (S q 1 - S p 1) ≤ 0 := by nlinarith
  have key : 0 ≤ (q - p) * (S q 0 - S p 0) := by
    nlinarith [mul_nonneg hq0 h1d, mul_nonneg hp0 (neg_nonneg.2 h2d)]
  by_contra hcon
  push_neg at hcon
  nlinarith

/-- helper (technical): `S(·,1)` is nonincreasing on `[0,1]` for consistent `S`. -/
private lemma S1_anti {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {p q : ℝ}
    (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) (hpq : p ≤ q) : S q 1 ≤ S p 1 := by
  rcases eq_or_lt_of_le hpq with rfl | hlt
  · exact le_rfl
  have h1 := hc q hq p hp
  have h2 := hc p hp q hq
  simp only [expPi] at h1 h2
  have hq1 : q ≤ 1 := hq.2
  have hp1 : p ≤ 1 := hp.2
  have h1d : 0 ≤ (1 - p) * (S q 0 - S p 0) + p * (S q 1 - S p 1) := by nlinarith
  have h2d : (1 - q) * (S q 0 - S p 0) + q * (S q 1 - S p 1) ≤ 0 := by nlinarith
  have key : 0 ≤ (p - q) * (S q 1 - S p 1) := by
    nlinarith [mul_nonneg (sub_nonneg.2 hq1) h1d, mul_nonneg (sub_nonneg.2 hp1) (neg_nonneg.2 h2d)]
  by_contra hcon
  push_neg at hcon
  nlinarith

private lemma clamp_mem (x : ℝ) : max 0 (min x 1) ∈ Set.Icc (0:ℝ) 1 :=
  ⟨le_max_left _ _, max_le zero_le_one (min_le_right _ _)⟩

private lemma clamp_mono : Monotone (fun x : ℝ => max 0 (min x 1)) := by
  intro a b hab
  exact max_le_max le_rfl (min_le_min hab le_rfl)

private lemma clamp_eq {x : ℝ} (hx : x ∈ Set.Icc (0:ℝ) 1) : max 0 (min x 1) = x := by
  rw [min_eq_left hx.2, max_eq_right hx.1]

/-- helper (technical): `ω ↦ S(r ω, 0)` is measurable when `r` is, with values in `[0,1]`. -/
private lemma meas_S0 {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {m : MeasurableSpace Ω}
    {r : Ω → ℝ} (hr : Measurable[m] r) (hr' : ∀ ω, r ω ∈ Set.Icc (0:ℝ) 1) :
    Measurable[m] (fun ω => S (r ω) 0) := by
  have hmono : Monotone (fun x : ℝ => S (max 0 (min x 1)) 0) := fun a b hab =>
    S0_mono hc (clamp_mem a) (clamp_mem b) (clamp_mono hab)
  have e : (fun ω => S (r ω) 0) = (fun x : ℝ => S (max 0 (min x 1)) 0) ∘ r := by
    funext ω
    simp only [Function.comp, clamp_eq (hr' ω)]
  rw [e]
  exact hmono.measurable.comp hr

private lemma meas_S1 {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {m : MeasurableSpace Ω}
    {r : Ω → ℝ} (hr : Measurable[m] r) (hr' : ∀ ω, r ω ∈ Set.Icc (0:ℝ) 1) :
    Measurable[m] (fun ω => S (r ω) 1) := by
  have hanti : Antitone (fun x : ℝ => S (max 0 (min x 1)) 1) := fun a b hab =>
    S1_anti hc (clamp_mem a) (clamp_mem b) (clamp_mono hab)
  have e : (fun ω => S (r ω) 1) = (fun x : ℝ => S (max 0 (min x 1)) 1) ∘ r := by
    funext ω
    simp only [Function.comp, clamp_eq (hr' ω)]
  rw [e]
  exact hanti.measurable.comp hr

/-- helper (technical): `ω ↦ S(r ω, Z ω)` for `Z ∈ {0,1}` measurable. -/
private lemma meas_SZ {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {m : MeasurableSpace Ω}
    {r Z : Ω → ℝ} (hr : Measurable[m] r) (hr' : ∀ ω, r ω ∈ Set.Icc (0:ℝ) 1)
    (hZ : Measurable[m] Z) (hZ' : ∀ ω, Z ω = 0 ∨ Z ω = 1) :
    Measurable[m] (fun ω => S (r ω) (Z ω)) := by
  have e : (fun ω => S (r ω) (Z ω)) = fun ω => if Z ω = 0 then S (r ω) 0 else S (r ω) 1 := by
    funext ω
    rcases hZ' ω with h | h
    · simp [h]
    · simp [h]
  rw [e]
  exact Measurable.ite (hZ (measurableSet_singleton 0)) (meas_S0 hc hr hr') (meas_S1 hc hr hr')

/-- helper (technical): `ω ↦ S(r ω, 1{q ω < p ω})`. -/
private lemma meas_Sb {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {m : MeasurableSpace Ω}
    {r p q : Ω → ℝ} (hr : Measurable[m] r) (hr' : ∀ ω, r ω ∈ Set.Icc (0:ℝ) 1)
    (hp : Measurable[m] p) (hq : Measurable[m] q) :
    Measurable[m] (fun ω => S (r ω) (if q ω < p ω then 1 else 0)) := by
  have e : (fun ω => S (r ω) (if q ω < p ω then 1 else 0)) =
      fun ω => if q ω < p ω then S (r ω) 1 else S (r ω) 0 := by
    funext ω
    by_cases h : q ω < p ω <;> simp [h]
  rw [e]
  exact Measurable.ite (measurableSet_lt hq hp) (meas_S1 hc hr hr') (meas_S0 hc hr hr')

/-- helper (technical): measurability of the factor `E_{p,q;λ}(Z)`. -/
private lemma meas_Erep {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {m : MeasurableSpace Ω}
    {p q lam Z : Ω → ℝ} (hp : Measurable[m] p) (hq : Measurable[m] q)
    (hp' : ∀ ω, p ω ∈ Set.Icc (0:ℝ) 1) (hq' : ∀ ω, q ω ∈ Set.Icc (0:ℝ) 1)
    (hl : Measurable[m] lam) (hZ : Measurable[m] Z) (hZ' : ∀ ω, Z ω = 0 ∨ Z ω = 1) :
    Measurable[m] (fun ω => Erep S (p ω) (q ω) (lam ω) (Z ω)) := by
  unfold Erep
  have h1 := meas_SZ hc hp hp' hZ hZ'
  have h2 := meas_SZ hc hq hq' hZ hZ'
  have h3 := meas_Sb hc hp hp' hp hq
  have h4 := meas_Sb hc hq hq' hp hq
  exact measurable_const.add ((hl.mul (h1.sub h2)).div (continuous_abs.measurable.comp (h3.sub h4)))

/-- S1.  (l.452 "nonnegative"; l.403 `E(y) ≥ 1 - λ ≥ 0`.)  Every factor
`E_{p_t,q_t;λ_t}(Y_{t+h})` is nonnegative.  Uses the one-period consumed T01 clause with
`IsConsistent` from `hS.1` and `ν`-positivity from `hMix` (l.103); `λ_t = 0` and `p_t = q_t` give `1`. -/
theorem P04_S1 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) (ω : Ω) :
    0 ≤ Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) := by
  by_cases hl : lam t ω = 0
  · simp [Erep, hl]
  by_cases hpq : p t ω = q t ω
  · simp [Erep, hpq]
  have hp := hset.p_mem t ω
  have hq := hset.q_mem t ω
  have hlam : lam t ω ∈ Set.Ioc (0:ℝ) 1 :=
    ⟨lt_of_le_of_ne (hset.lam_mem t ω).1 (Ne.symm hl), (hset.lam_mem t ω).2⟩
  have hpos : 0 < ν (Set.Ico (min (p t ω) (q t ω)) (max (p t ω) (q t ω))) :=
    hMix ν hrep hS _ _ (lt_min hp.1 hq.1) (min_lt_max.2 hpq) (max_lt hp.2 hq.2)
  have hE := hT01 hS.1 ν hrep (p t ω) hp (q t ω) hq hpq hpos (lam t ω) hlam
  rcases hset.Y_mem (t + h) ω with h0 | h1
  · rw [h0]; exact hE.1
  · rw [h1]; exact hE.2.1

/-- S2.  (l.220 "are `ℱ_T`-measurable".)  The factor is `ℱ_{t+h}`-measurable: `p_t, q_t, λ_t` are
`ℱ_t ⊆ ℱ_{t+h}`-measurable, `Y_{t+h}` is `ℱ_{t+h}`-measurable, and `S(·,y)` is monotone by
consistency (helpers above). -/
theorem P04_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) :
    Measurable[ℱ (t + h)] (fun ω => Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) := by
  have hle : ℱ t ≤ ℱ (t + h) := ℱ.mono (Nat.le_add_right t h)
  exact meas_Erep hS.1 ((hset.p_adapted t).mono hle le_rfl) ((hset.q_adapted t).mono hle le_rfl)
    (fun ω => Set.Ioo_subset_Icc_self (hset.p_mem t ω))
    (fun ω => Set.Ioo_subset_Icc_self (hset.q_mem t ω))
    ((hset.lam_adapted t).mono hle le_rfl) (hset.Y_adapted (t + h)) (hset.Y_mem (t + h))

/-- S3.  (l.220 "`e_T` are `ℱ_T`-measurable".)  From S2, `l + h ≤ T` for `l ∈ I_k`,
monotonicity of the filtration, finite products and sums. -/
theorem P04_S3 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) : Measurable[ℱ T] (eT S h Y p q lam T) := by
  unfold eT
  refine measurable_const.mul (Finset.measurable_sum _ fun k hk => Finset.measurable_prod _ fun l hl => ?_)
  have hk' := Finset.mem_Icc.1 hk
  obtain ⟨s, hs, rfl⟩ := Finset.mem_image.1 hl
  have hs' := Finset.mem_range.1 hs
  have h1 : (s + 1) * h ≤ T - k := (Nat.le_div_iff_mul_le (by omega)).1 hs'
  have h2 : k + h * s + h ≤ T := by
    have : h * (s + 1) ≤ T - k := by rw [mul_comm]; exact h1
    rw [Nat.mul_succ] at this
    omega
  have hmono : ℱ (k + h * s + h) ≤ ℱ T := ℱ.mono h2
  exact (P04_S2 S h ℱ Y c p q lam hset hS (k + h * s)).mono hmono le_rfl

/-- S4.  (l.205 "`E_{p_t,q_t;0} ≡ 1` if `c_t = 0`", with `λ_t = 0` if `c_t = 0`, l.217.) -/
theorem P04_S4 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (t : ℕ) (ω : Ω) (hc : c t ω = 0) :
    Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) = 1 := by
  simp [Erep, hset.lam_zero t ω hc]

/-- helper (technical): `π_t = E_Q(Y_{t+h} | ℱ_t)` lies in `[0,1]` and (if `c_t = 1`) in
`H_S(p_t,q_t)` a.s., from `Q ∈ ℋ_{S;c}` (decomposition `d = d0 (1-Y) + d1 Y`, `ℱ_t`-measurable
`d0, d1`; l.115 definition of `ℋ_{S;c}`).  Preparation for S0 (l.205-209). -/
private theorem cond_prep (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) :
    ∀ᵐ ω ∂Q, 0 ≤ condExp (ℱ t) Q (Y (t + h)) ω ∧ condExp (ℱ t) Q (Y (t + h)) ω ≤ 1 ∧
      (c t ω = 1 → condExp (ℱ t) Q (Y (t + h)) ω ∈ HS S (p t ω) (q t ω)) := by
  have hQ' : Q ∈ HSc S h ℱ Y c p q ∧ ∀ t : ℕ, Integrable
      (fun ω' => S (p t ω') (Y (t + h) ω') - S (q t ω') (Y (t + h) ω')) Q := hQ
  obtain ⟨⟨hprob, hcond⟩, hint⟩ := hQ'
  haveI := hprob
  have hle : ℱ t ≤ m0 := ℱ.le t
  have hYm : Measurable (Y (t + h)) := (hset.Y_adapted (t + h)).mono (ℱ.le _) le_rfl
  have hYint : Integrable (Y (t + h)) Q := by
    refine Integrable.of_mem_Icc 0 1 hYm.aemeasurable (Filter.Eventually.of_forall fun ω => ?_)
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
  have hnn : 0 ≤ᵐ[Q] condExp (ℱ t) Q (Y (t + h)) :=
    condExp_nonneg (Filter.Eventually.of_forall fun ω => by
      rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0])
  have hle1 : condExp (ℱ t) Q (Y (t + h)) ≤ᵐ[Q] fun _ => (1:ℝ) := by
    have hYle : Y (t + h) ≤ᵐ[Q] fun _ => (1:ℝ) := Filter.Eventually.of_forall fun ω => by
      rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
    have := condExp_mono (m := ℱ t) hYint (integrable_const (1:ℝ)) hYle
    rwa [condExp_const hle] at this
  obtain ⟨d0, hd0⟩ : ∃ d0 : Ω → ℝ, d0 = fun ω => S (p t ω) 0 - S (q t ω) 0 := ⟨_, rfl⟩
  obtain ⟨d1, hd1⟩ : ∃ d1 : Ω → ℝ, d1 = fun ω => S (p t ω) 1 - S (q t ω) 1 := ⟨_, rfl⟩
  have hpI : ∀ ω, p t ω ∈ Set.Icc (0:ℝ) 1 := fun ω => Set.Ioo_subset_Icc_self (hset.p_mem t ω)
  have hqI : ∀ ω, q t ω ∈ Set.Icc (0:ℝ) 1 := fun ω => Set.Ioo_subset_Icc_self (hset.q_mem t ω)
  have hd0m : Measurable[ℱ t] d0 := by
    rw [hd0]; exact (meas_S0 hS.1 (hset.p_adapted t) hpI).sub (meas_S0 hS.1 (hset.q_adapted t) hqI)
  have hd1m : Measurable[ℱ t] d1 := by
    rw [hd1]; exact (meas_S1 hS.1 (hset.p_adapted t) hpI).sub (meas_S1 hS.1 (hset.q_adapted t) hqI)
  have hd0m' : Measurable d0 := hd0m.mono hle le_rfl
  have hd1m' : Measurable d1 := hd1m.mono hle le_rfl
  have hD := hint t
  have hdecomp : (fun ω' => S (p t ω') (Y (t + h) ω') - S (q t ω') (Y (t + h) ω')) =
      d0 * (fun ω => 1 - Y (t + h) ω) + d1 * Y (t + h) := by
    funext ω
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [hd0, hd1, h0]
  have hi0 : Integrable (d0 * (fun ω => 1 - Y (t + h) ω)) Q := by
    refine Integrable.mono' hD.norm ((hd0m'.mul (measurable_const.sub hYm)).aestronglyMeasurable)
      (Filter.Eventually.of_forall fun ω => ?_)
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [hd0, h0]
  have hi1 : Integrable (d1 * Y (t + h)) Q := by
    refine Integrable.mono' hD.norm ((hd1m'.mul hYm).aestronglyMeasurable)
      (Filter.Eventually.of_forall fun ω => ?_)
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [hd1, h0]
  have hiY1 : Integrable (fun ω => 1 - Y (t + h) ω) Q := (integrable_const (1:ℝ)).sub hYint
  have hc0 := condExp_mul_of_stronglyMeasurable_left (m := ℱ t) hd0m.stronglyMeasurable hi0 hiY1
  have hc1 := condExp_mul_of_stronglyMeasurable_left (m := ℱ t) hd1m.stronglyMeasurable hi1 hYint
  have hcs : condExp (ℱ t) Q (fun ω => 1 - Y (t + h) ω) =ᵐ[Q]
      fun ω => 1 - condExp (ℱ t) Q (Y (t + h)) ω := by
    have := condExp_sub (m := ℱ t) (integrable_const (1:ℝ)) hYint
    rw [condExp_const hle] at this
    exact this
  have hca := condExp_add (m := ℱ t) hi0 hi1
  rw [← hdecomp] at hca
  filter_upwards [hcond t, hnn, hle1, hca, hc0, hc1, hcs] with ω hc hn hl1 ha h0' h1' hs'
  refine ⟨hn, hl1, fun hct => ?_⟩
  have hD0 : condExp (ℱ t) Q (fun ω' => S (p t ω') (Y (t + h) ω') - S (q t ω') (Y (t + h) ω')) ω
      = d0 ω * (1 - condExp (ℱ t) Q (Y (t + h)) ω) + d1 ω * condExp (ℱ t) Q (Y (t + h)) ω := by
    rw [ha]
    simp only [Pi.add_apply]
    rw [h0', h1']
    simp only [Pi.mul_apply]
    rw [hs']
  rw [hct, hD0] at hc
  refine ⟨⟨hn, hl1⟩, ?_⟩
  simp only [expPi]
  rw [hd0, hd1] at hc
  simp only at hc
  linarith

/-- helper (technical): conditional expectation in lintegral form,
`∫ G · Z = ∫ G · E(Z|m)` for `m`-measurable `G ≥ 0` and `Z ≥ 0` integrable. -/
private lemma lint_condExp (ℱ : Filtration ℕ m0) (t : ℕ) {μ : Measure Ω} [IsFiniteMeasure μ]
    {Z : Ω → ℝ} (hZm : Measurable Z) (hZi : Integrable Z μ) (hZn : 0 ≤ᵐ[μ] Z)
    {G : Ω → ENNReal} (hG : Measurable[ℱ t] G) :
    ∫⁻ ω, G ω * ENNReal.ofReal (Z ω) ∂μ
      = ∫⁻ ω, G ω * ENNReal.ofReal ((μ[Z|ℱ t]) ω) ∂μ := by
  have hle : ℱ t ≤ m0 := ℱ.le t
  have hπm : Measurable (μ[Z|ℱ t]) :=
    ((stronglyMeasurable_condExp (m := ℱ t) (μ := μ) (f := Z)).mono hle).measurable
  have hπn : 0 ≤ᵐ[μ] μ[Z|ℱ t] := condExp_nonneg hZn
  have htrim : (μ.withDensity fun ω => ENNReal.ofReal (Z ω)).trim hle
      = (μ.withDensity fun ω => ENNReal.ofReal ((μ[Z|ℱ t]) ω)).trim hle := by
    refine @Measure.ext _ (ℱ t) _ _ fun s hs => ?_
    rw [trim_measurableSet_eq hle hs, trim_measurableSet_eq hle hs,
      withDensity_apply _ (hle s hs), withDensity_apply _ (hle s hs)]
    rw [← ofReal_integral_eq_lintegral_ofReal hZi.integrableOn (ae_restrict_of_ae hZn),
      ← ofReal_integral_eq_lintegral_ofReal (integrable_condExp (m := ℱ t)).integrableOn
        (ae_restrict_of_ae hπn),
      setIntegral_condExp hle hZi hs]
  have hGm : Measurable G := hG.mono hle le_rfl
  have hZm' : Measurable fun ω => ENNReal.ofReal (Z ω) := ENNReal.measurable_ofReal.comp hZm
  have hπm' : Measurable fun ω => ENNReal.ofReal ((μ[Z|ℱ t]) ω) :=
    ENNReal.measurable_ofReal.comp hπm
  calc ∫⁻ ω, G ω * ENNReal.ofReal (Z ω) ∂μ
      = ∫⁻ ω, G ω ∂(μ.withDensity fun ω => ENNReal.ofReal (Z ω)) := by
        rw [lintegral_withDensity_eq_lintegral_mul _ hZm' hGm]
        simp only [Pi.mul_apply, mul_comm]
    _ = ∫⁻ ω, G ω ∂((μ.withDensity fun ω => ENNReal.ofReal (Z ω)).trim hle) :=
        (lintegral_trim hle hG).symm
    _ = ∫⁻ ω, G ω ∂((μ.withDensity fun ω => ENNReal.ofReal ((μ[Z|ℱ t]) ω)).trim hle) := by
        rw [htrim]
    _ = ∫⁻ ω, G ω ∂(μ.withDensity fun ω => ENNReal.ofReal ((μ[Z|ℱ t]) ω)) :=
        lintegral_trim hle hG
    _ = ∫⁻ ω, G ω * ENNReal.ofReal ((μ[Z|ℱ t]) ω) ∂μ := by
        rw [lintegral_withDensity_eq_lintegral_mul _ hπm' hGm]
        simp only [Pi.mul_apply, mul_comm]

/-- helper (technical): pointwise form of the one-step bound (l.205-209): for `π ∈ H_S(p,q)`
(when `c = 1`), `E_π E_{p,q;λ} ≤ 1`; the cases `λ = 0` (l.205) and `p = q` give `E ≡ 1`. -/
private lemma pt_bound {S : ℝ → ℝ → ℝ} {ν : Measure ℝ} (hrep : T01.MixtureRep S ν)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S) (hS : IsStrictlyConsistent S)
    {p q lam c π : ℝ} (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (hlam : lam ∈ Set.Icc (0:ℝ) 1) (hc : c = 0 ∨ c = 1) (hlc : c = 0 → lam = 0)
    (hπ0 : 0 ≤ π) (hπ1 : π ≤ 1) (hHS : c = 1 → π ∈ HS S p q) :
    ENNReal.ofReal (Erep S p q lam 0) * ENNReal.ofReal (1 - π)
      + ENNReal.ofReal (Erep S p q lam 1) * ENNReal.ofReal π ≤ 1 := by
  have hone : ENNReal.ofReal (1 - π) + ENNReal.ofReal π = 1 := by
    rw [← ENNReal.ofReal_add (by linarith) hπ0]; simp
  by_cases hl : lam = 0
  · simp [Erep, hl, hone]
  by_cases hpq : p = q
  · simp [Erep, hpq, hone]
  have hc1 : c = 1 := by
    rcases hc with h0 | h1
    · exact absurd (hlc h0) hl
    · exact h1
  have hlam' : lam ∈ Set.Ioc (0:ℝ) 1 := ⟨lt_of_le_of_ne hlam.1 (Ne.symm hl), hlam.2⟩
  have hpos : 0 < ν (Set.Ico (min p q) (max p q)) :=
    hMix ν hrep hS _ _ (lt_min hp.1 hq.1) (min_lt_max.2 hpq) (max_lt hp.2 hq.2)
  have hE := hT01 hS.1 ν hrep p hp q hq hpq hpos lam hlam'
  have hexp := hE.2.2.1 π (hHS hc1)
  simp only [expPi] at hexp
  have e0 : ENNReal.ofReal (Erep S p q lam 0) * ENNReal.ofReal (1 - π)
      = ENNReal.ofReal ((1 - π) * Erep S p q lam 0) := by
    rw [ENNReal.ofReal_mul (by linarith : (0:ℝ) ≤ 1 - π), mul_comm]
  have e1 : ENNReal.ofReal (Erep S p q lam 1) * ENNReal.ofReal π
      = ENNReal.ofReal (π * Erep S p q lam 1) := by
    rw [ENNReal.ofReal_mul hπ0, mul_comm]
  rw [e0, e1, ← ENNReal.ofReal_add (mul_nonneg (by linarith) hE.1) (mul_nonneg hπ0 hE.2.1)]
  calc _ ≤ ENNReal.ofReal 1 := ENNReal.ofReal_le_ofReal hexp
    _ = 1 := ENNReal.ofReal_one

/-- helper (technical): the one-step bound with an `ℱ_t`-measurable weight `g ≥ 0` ("pull out the
`ℱ_t`-measurable factors", l.202-209); generalises S0 (take `g = 1_A`). -/
private lemma core6 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (g : Ω → ENNReal)
    (hg : Measurable[ℱ t] g) :
    ∫⁻ ω, g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
      ≤ ∫⁻ ω, g ω ∂Q := by
  have hprob : IsProbabilityMeasure Q := hQ.1.1
  haveI := hprob
  have hS4 := cond_prep S h ℱ Y c p q lam hset hS Q hQ t
  have hle : ℱ t ≤ m0 := ℱ.le t
  have hYm : Measurable (Y (t + h)) := (hset.Y_adapted (t + h)).mono (ℱ.le _) le_rfl
  have hYint : Integrable (Y (t + h)) Q := by
    refine Integrable.of_mem_Icc 0 1 hYm.aemeasurable (Filter.Eventually.of_forall fun ω => ?_)
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
  have hiY1 : Integrable (fun ω => 1 - Y (t + h) ω) Q := (integrable_const (1:ℝ)).sub hYint
  have hYn : 0 ≤ᵐ[Q] Y (t + h) := Filter.Eventually.of_forall fun ω => by
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
  have hY1n : 0 ≤ᵐ[Q] fun ω => 1 - Y (t + h) ω := Filter.Eventually.of_forall fun ω => by
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
  have hY1m : Measurable fun ω => 1 - Y (t + h) ω := measurable_const.sub hYm
  have hpI : ∀ ω, p t ω ∈ Set.Icc (0:ℝ) 1 := fun ω => Set.Ioo_subset_Icc_self (hset.p_mem t ω)
  have hqI : ∀ ω, q t ω ∈ Set.Icc (0:ℝ) 1 := fun ω => Set.Ioo_subset_Icc_self (hset.q_mem t ω)
  have hE0 : Measurable[ℱ t] (fun ω => ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0)) :=
    ENNReal.measurable_ofReal.comp (meas_Erep (Z := fun _ => (0:ℝ)) hS.1 (hset.p_adapted t)
      (hset.q_adapted t) hpI hqI (hset.lam_adapted t) measurable_const (fun _ => Or.inl rfl))
  have hE1 : Measurable[ℱ t] (fun ω => ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 1)) :=
    ENNReal.measurable_ofReal.comp (meas_Erep (Z := fun _ => (1:ℝ)) hS.1 (hset.p_adapted t)
      (hset.q_adapted t) hpI hqI (hset.lam_adapted t) measurable_const (fun _ => Or.inr rfl))
  have hpt : ∀ ω, ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) =
      ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0) * ENNReal.ofReal (1 - Y (t + h) ω)
      + ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 1) * ENNReal.ofReal (Y (t + h) ω) := by
    intro ω
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
  have hG0 : Measurable[ℱ t] fun ω => g ω *
      ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0) := hg.mul hE0
  have hG1 : Measurable[ℱ t] fun ω => g ω *
      ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 1) := hg.mul hE1
  have hG0' := hG0.mono hle le_rfl
  have hπm : Measurable (condExp (ℱ t) Q (Y (t + h))) :=
    ((stronglyMeasurable_condExp (m := ℱ t) (μ := Q) (f := Y (t + h))).mono hle).measurable
  have hcs : condExp (ℱ t) Q (fun ω => 1 - Y (t + h) ω) =ᵐ[Q]
      fun ω => 1 - condExp (ℱ t) Q (Y (t + h)) ω := by
    have := condExp_sub (m := ℱ t) (integrable_const (1:ℝ)) hYint
    rw [condExp_const hle] at this
    exact this
  have step1 : ∫⁻ ω, g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
      = ∫⁻ ω, (g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0))
            * ENNReal.ofReal (1 - Y (t + h) ω) ∂Q
        + ∫⁻ ω, (g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 1))
            * ENNReal.ofReal (Y (t + h) ω) ∂Q := by
    rw [← lintegral_add_left (hG0'.mul (show Measurable fun ω => ENNReal.ofReal (1 - Y (t + h) ω)
      from ENNReal.measurable_ofReal.comp hY1m))]
    refine lintegral_congr fun ω => ?_
    rw [hpt ω]; ring
  rw [step1, lint_condExp ℱ t hY1m hiY1 hY1n hG0, lint_condExp ℱ t hYm hYint hYn hG1]
  have step2 : ∫⁻ ω, (g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0))
        * ENNReal.ofReal ((condExp (ℱ t) Q (fun ω => 1 - Y (t + h) ω)) ω) ∂Q
      = ∫⁻ ω, (g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0))
        * ENNReal.ofReal (1 - condExp (ℱ t) Q (Y (t + h)) ω) ∂Q := by
    refine lintegral_congr_ae (hcs.mono fun ω hω => ?_)
    simp only [hω]
  rw [step2, ← lintegral_add_left (hG0'.mul (show Measurable fun ω =>
    ENNReal.ofReal (1 - condExp (ℱ t) Q (Y (t + h)) ω)
    from ENNReal.measurable_ofReal.comp (measurable_const.sub hπm)))]
  refine lintegral_mono_ae ?_
  filter_upwards [hS4] with ω ⟨hn, hl1, hHS⟩
  have hb := pt_bound hrep hT01 hMix hS (hset.p_mem t ω) (hset.q_mem t ω) (hset.lam_mem t ω)
    (hset.c_mem t ω) (hset.lam_zero t ω) hn hl1 hHS
  calc _ = g ω * (ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 0)
        * ENNReal.ofReal (1 - condExp (ℱ t) Q (Y (t + h)) ω)
        + ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) 1)
        * ENNReal.ofReal (condExp (ℱ t) Q (Y (t + h)) ω)) := by ring
    _ ≤ g ω * 1 := by gcongr
    _ = g ω := mul_one _

/-- S0.  (l.205-209 one-step bound `E_Q{E_t(Y_{t+h}) | ℱ_t} ≤ 1` a.s. for `Q ∈ ℋ_{S;c}`, lag `h`
as used at l.452; integral form for `A ∈ ℱ_t`.)  Case `c_t = 0` is S4; case `c_t = 1`, `λ_t > 0`,
`p_t ≠ q_t` uses `E_Q(Y_{t+h}|ℱ_t) ∈ H_S(p_t,q_t)` (definition of `ℋ_{S;c}`, l.115) and the
one-period T01 clause `hT01`; `p_t = q_t` gives factor `1`.  Via the pull-out helper `core6`
with `g = 1_A`. -/
theorem P04_S0 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (A : Set Ω)
    (hA : MeasurableSet[ℱ t] A) :
    ∫⁻ ω in A, ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤ Q A := by
  have hAm : MeasurableSet A := ℱ.le t A hA
  have hgm : Measurable[ℱ t] (A.indicator (1 : Ω → ENNReal)) :=
    (measurable_const (a := (1:ENNReal))).indicator hA
  have key := core6 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS Q hQ t _ hgm
  rw [← lintegral_indicator hAm]
  calc _ = ∫⁻ ω, A.indicator (1 : Ω → ENNReal) ω *
        ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q := by
        refine lintegral_congr fun ω => ?_
        by_cases hω : ω ∈ A <;> simp [hω]
    _ ≤ ∫⁻ ω, A.indicator (1 : Ω → ENNReal) ω ∂Q := key
    _ = Q A := by rw [lintegral_indicator hAm]; simp

/-! ### Case `h = 1` (l.199-214) -/

/-- S5.  (l.200-211.)  For `h = 1`, `Q ∈ ℋ_{S;c}`, `n ≥ 0`:
`E_Q ∏_{t=1}^{n+1} E_t(Y_{t+1}) ≤ E_Q ∏_{t=1}^{n} E_t(Y_{t+1})`.  Pull out the factors `t ≤ n`, which are
`ℱ_{n+1}`-measurable (S2), nonnegative (S1), and apply the one-step bound at time `n+1`
(the weighted form `core6` of S0, with weight `g = ∏_{t ≤ n}`). -/
theorem P04_S5 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh1 : h = 1) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (n : ℕ) :
    ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 (n + 1),
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤
      ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 n,
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q := by
  have hh : 1 ≤ h := hh1 ▸ le_rfl
  have hnn : ∀ ω, 0 ≤ ∏ t ∈ Finset.Icc 1 n,
      Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) :=
    fun ω => Finset.prod_nonneg fun t _ =>
      P04_S1 S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS t ω
  have hG : Measurable[ℱ (n + 1)] (fun ω => ENNReal.ofReal (∏ t ∈ Finset.Icc 1 n,
      Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω))) := by
    refine ENNReal.measurable_ofReal.comp (Finset.measurable_prod _ fun t ht => ?_)
    have ht' := Finset.mem_Icc.1 ht
    have hle : ℱ (t + h) ≤ ℱ (n + 1) := ℱ.mono (by omega)
    exact (P04_S2 S h ℱ Y c p q lam hset hS t).mono hle le_rfl
  calc ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 (n + 1),
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
      = ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 n,
          Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) *
        ENNReal.ofReal (Erep S (p (n + 1) ω) (q (n + 1) ω) (lam (n + 1) ω)
          (Y (n + 1 + h) ω)) ∂Q := by
        refine lintegral_congr fun ω => ?_
        rw [Finset.prod_Icc_succ_top (by omega), ENNReal.ofReal_mul (hnn ω)]
    _ ≤ _ := core6 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS Q hQ (n + 1) _ hG

/-- S6.  (l.214 "Iterating this argument".)  For `h = 1`, `Q ∈ ℋ_{S;c}`:
`E_Q ∏_{t=1}^n E_t(Y_{t+1}) ≤ 1`, by induction from S5; the empty product is `1`. -/
theorem P04_S6 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh1 : h = 1) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (n : ℕ) :
    ∫⁻ ω, ENNReal.ofReal (∏ t ∈ Finset.Icc 1 n,
        Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤ 1 := by
  have hprob : IsProbabilityMeasure Q := hQ.1.1
  induction n with
  | zero => simp
  | succ n ih =>
    exact (P04_S5 S ν hrep h hh1 ℱ Y c p q lam hT01 hMix hset hS Q hQ n).trans ih

/-- S7.  (l.217-221 for `h = 1`, with `I_1 = {1, …, T-1}`, `e_T = ∏_{t=1}^{T-1} E_t(Y_{t+1})`;
l.214.)  `e_T ≥ 0` (S1) and `E_Q e_T ≤ 1` (S6 with `n = T-1`). -/
theorem P04_S7 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh1 : h = 1) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) :
    IsEValueUnder (eT S h Y p q lam T) (HScInt S h ℱ Y c p q) := by
  have hh : 1 ≤ h := hh1 ▸ le_rfl
  have hI : Ik h T 1 = Finset.Icc 1 (T - 1) := by
    subst hh1
    ext x
    simp only [Ik, Finset.mem_image, Finset.mem_range, Finset.mem_Icc]
    constructor
    · rintro ⟨s, hs, rfl⟩
      simp only [Nat.div_one] at hs
      omega
    · intro hx
      exact ⟨x - 1, by simp only [Nat.div_one]; omega, by omega⟩
  have he : ∀ ω, eT S h Y p q lam T ω = ∏ t ∈ Finset.Icc 1 (T - 1),
      Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω) := by
    intro ω
    unfold eT
    subst hh1
    simp [hI]
  refine ⟨fun ω => ?_, fun Q hQ => ?_⟩
  · rw [he ω]
    exact Finset.prod_nonneg fun t _ => P04_S1 S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS t ω
  · simp_rw [he]
    exact P04_S6 S ν hrep h hh1 ℱ Y c p q lam hT01 hMix hset hS Q hQ (T - 1)

/-! ### Case `h > 1` (l.446-469) -/

/-- S8.  (l.447-452 "Then `e_t = ∑_{k=1}^h M^{[k]}_t / h`".)  Unfolding of the definitions. -/
theorem P04_S8 (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ) (ω : Ω) :
    eT S h Y p q lam t ω = (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k t ω := by
  rfl

/-- helper (technical): the product defining `M^{[k]}_t` over `I_k(t)` is the product over
`s < ⌊(t-k)/h⌋` of the factors at times `k + h s` (injectivity of `s ↦ k + h s`). -/
private lemma Mk_range (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (Y p q lam : ℕ → Ω → ℝ) (k t : ℕ)
    (ω : Ω) : Mk S h Y p q lam k t ω = ∏ s ∈ Finset.range ((t - k) / h),
      Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω) (Y (k + h * s + h) ω) := by
  unfold Mk Ik
  refine Finset.prod_image fun x _ y _ hxy => ?_
  have hxy' : h * x = h * y := by simpa using hxy
  exact Nat.eq_of_mul_eq_mul_left (by omega) hxy'

/-- helper (technical): the product of the first `n` factors started at `k` is
`ℱ_{k+hn}`-measurable (each factor is `ℱ_{k+hs+h}`-measurable by S2, `s < n`). -/
private lemma prod_meas (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (k n : ℕ) :
    Measurable[ℱ (k + h * n)] (fun ω => ∏ s ∈ Finset.range n,
        Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω)
          (Y (k + h * s + h) ω)) := by
  refine Finset.measurable_prod _ fun s hs => ?_
  have hs' := Finset.mem_range.1 hs
  have h2 : k + h * s + h ≤ k + h * n := by
    have : h * (s + 1) ≤ h * n := Nat.mul_le_mul_left h hs'
    rw [Nat.mul_succ] at this
    omega
  exact (P04_S2 S h ℱ Y c p q lam hset hS (k + h * s)).mono (ℱ.mono h2) le_rfl

/-- helper (technical): for `k ≤ t`, `𝔉^{[k]}_t = ℱ_{k + h ⌊(t-k)/h⌋}` (`1 ≤ k`, `1 ≤ h`; the integer
floor of l.450 agrees with natural division, and the index is positive so the `⊥` branch is not taken). -/
private lemma filtK_eq (ℱ : Filtration ℕ m0) (h k t : ℕ) (hh : 1 ≤ h) (hk : 1 ≤ k) (hkt : k ≤ t) :
    filtK ℱ h k t = ℱ (k + h * ((t - k) / h)) := by
  have h1 : ((t : ℤ) - k) / h = (((t - k) / h : ℕ) : ℤ) := by
    have e : ((t : ℤ) - k) = ((t - k : ℕ) : ℤ) := by omega
    rw [e]
    exact (Int.natCast_div _ _).symm
  have h2 : ((((t - k) / h : ℕ) : ℤ) * h + k) = ((k + h * ((t - k) / h) : ℕ) : ℤ) := by
    push_cast; ring
  unfold filtK
  rw [h1, h2]
  have hpos : ¬ (((k + h * ((t - k) / h) : ℕ) : ℤ) ≤ 0) := by omega
  rw [if_neg hpos, Int.toNat_natCast]

private lemma filtK_le (ℱ : Filtration ℕ m0) (h k t : ℕ) : filtK ℱ h k t ≤ m0 := by
  unfold filtK
  split_ifs
  · exact bot_le
  · exact ℱ.le _

/-- helper (technical): `M^{[k]}_t` is `ℱ_{k + h⌊(t-k)/h⌋}`-measurable. -/
private lemma Mk_meas (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k t : ℕ) : Measurable[ℱ (k + h * ((t - k) / h))] (Mk S h Y p q lam k t) := by
  have e : Mk S h Y p q lam k t = fun ω => ∏ s ∈ Finset.range ((t - k) / h),
      Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω) (Y (k + h * s + h) ω) :=
    funext fun ω => Mk_range S h hh Y p q lam k t ω
  rw [e]
  exact prod_meas S h ℱ Y c p q lam hset hS k _

/-- S9a.  (l.452 "adapted to `𝔉^{[k]}`".)  For `t ≥ k` it is `Mk_meas` (factors `l ∈ I_k(t)` have
`l + h ≤ ⌊(t-k)/h⌋h + k`, S2); for `t < k`, `I_k(t) = ∅` and `M = 1`. -/
theorem P04_S9a (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (t : ℕ) :
    Measurable[filtK ℱ h k t] (Mk S h Y p q lam k t) := by
  have hk' := Finset.mem_Icc.1 hk
  by_cases htk : k ≤ t
  · rw [filtK_eq ℱ h k t (by omega) hk'.1 htk]
    exact Mk_meas S h (by omega) ℱ Y c p q lam hset hS k t
  · have e : Mk S h Y p q lam k t = fun _ => 1 := by
      funext ω
      rw [Mk_range S h (by omega) Y p q lam k t ω]
      have : (t - k) / h = 0 := by rw [Nat.sub_eq_zero_of_le (by omega)]; simp
      simp [this]
    rw [e]
    exact measurable_const

/-- S9b.  (l.452 "nonnegative".)  A finite product of nonnegative factors (S1). -/
theorem P04_S9b (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (t : ℕ) (ω : Ω) :
    0 ≤ Mk S h Y p q lam k t ω :=
  Finset.prod_nonneg fun l _ => P04_S1 S ν hrep h (by omega) ℱ Y c p q lam hT01 hMix hset hS l ω

/-- S9c.  (l.452 "supermartingale with respect to `𝔉^{[k]}` for any `Q`", in integral form.)
`M^{[k]}_{t+1} = M^{[k]}_t` unless `h ∣ t+1-k`, in which case `M^{[k]}_{t+1} = M^{[k]}_t · E_l(Y_{l+h})`
with `l = t+1-h`; `M^{[k]}_t` and `A ∈ 𝔉^{[k]}_t = ℱ_l` are `ℱ_l`-measurable, and the one-step bound
(S0, in the weighted form `core6` with weight `1_A M_t`) applies. -/
theorem P04_S9c (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (t : ℕ) (A : Set Ω) (hA : MeasurableSet[filtK ℱ h k t] A) :
    ∫⁻ ω in A, ENNReal.ofReal (Mk S h Y p q lam k (t + 1) ω) ∂Q ≤
      ∫⁻ ω in A, ENNReal.ofReal (Mk S h Y p q lam k t ω) ∂Q := by
  have hk' := Finset.mem_Icc.1 hk
  have hh1 : 1 ≤ h := by omega
  -- the standard case: the number of factors does not change
  have hsame : (t + 1 - k) / h = (t - k) / h → Mk S h Y p q lam k (t + 1) = Mk S h Y p q lam k t := by
    intro hd
    funext ω
    rw [Mk_range S h hh1 Y p q lam k (t + 1) ω, Mk_range S h hh1 Y p q lam k t ω, hd]
  by_cases htk : k ≤ t
  · by_cases hdv : h ∣ (t - k + 1)
    · -- the new factor: `l = k + h n`, `t + 1 = l + h`
      obtain ⟨n, hn⟩ : ∃ n, n = (t - k) / h := ⟨_, rfl⟩
      have hn1 : (t + 1 - k) / h = n + 1 := by
        have e : t + 1 - k = (t - k) + 1 := by omega
        rw [e, Nat.succ_div, if_pos hdv, hn]
      have e1 : h * (n + 1) = t - k + 1 := by
        have e : t + 1 - k = (t - k) + 1 := by omega
        rw [← hn1, e]
        exact Nat.mul_div_cancel' hdv
      have e2 : t + 1 = k + h * n + h := by
        rw [Nat.mul_succ] at e1
        omega
      have hAℓ : MeasurableSet[ℱ (k + h * n)] A := by
        rw [filtK_eq ℱ h k t hh1 hk'.1 htk, ← hn] at hA
        exact hA
      have hAm : MeasurableSet A := ℱ.le _ A hAℓ
      have hMt : Measurable[ℱ (k + h * n)] (Mk S h Y p q lam k t) := by
        have := Mk_meas S h hh1 ℱ Y c p q lam hset hS k t
        rw [← hn] at this
        exact this
      have hg : Measurable[ℱ (k + h * n)]
          (A.indicator (fun ω => ENNReal.ofReal (Mk S h Y p q lam k t ω))) :=
        (ENNReal.measurable_ofReal.comp hMt).indicator hAℓ
      have key := core6 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS Q hQ (k + h * n) _ hg
      have hnn : ∀ ω, 0 ≤ Mk S h Y p q lam k t ω :=
        fun ω => P04_S9b S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS k hk t ω
      have hfac : ∀ ω, Mk S h Y p q lam k (t + 1) ω = Mk S h Y p q lam k t ω *
          Erep S (p (k + h * n) ω) (q (k + h * n) ω) (lam (k + h * n) ω) (Y (k + h * n + h) ω) := by
        intro ω
        rw [Mk_range S h hh1 Y p q lam k (t + 1) ω, Mk_range S h hh1 Y p q lam k t ω, hn1, ← hn,
          Finset.prod_range_succ]
      rw [← lintegral_indicator hAm, ← lintegral_indicator hAm]
      calc ∫⁻ ω, A.indicator (fun ω => ENNReal.ofReal (Mk S h Y p q lam k (t + 1) ω)) ω ∂Q
          = ∫⁻ ω, A.indicator (fun ω => ENNReal.ofReal (Mk S h Y p q lam k t ω)) ω *
              ENNReal.ofReal (Erep S (p (k + h * n) ω) (q (k + h * n) ω) (lam (k + h * n) ω)
                (Y (k + h * n + h) ω)) ∂Q := by
            refine lintegral_congr fun ω => ?_
            by_cases hω : ω ∈ A
            · simp only [Set.indicator_of_mem hω]
              rw [hfac ω, ENNReal.ofReal_mul (hnn ω)]
            · simp [Set.indicator_of_not_mem hω]
        _ ≤ _ := key
    · have hd : (t + 1 - k) / h = (t - k) / h := by
        have e : t + 1 - k = (t - k) + 1 := by omega
        rw [e, Nat.succ_div, if_neg hdv]
        simp
      rw [hsame hd]
  · have hd : (t + 1 - k) / h = (t - k) / h := by
      rw [Nat.sub_eq_zero_of_le (by omega : t ≤ k), Nat.sub_eq_zero_of_le (by omega : t + 1 ≤ k)]
    rw [hsame hd]

/-- helper (technical): `M^{[k]}_0 = 1` (`I_k(0) = ∅`, l.452 `∏_∅ := 1`). -/
private lemma Mk_zero (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (k : ℕ) (ω : Ω) :
    Mk S h Y p q lam k 0 ω = 1 := by
  simp [Mk, Ik]

/-- S10.  (l.452 "and therefore satisfies `E_Q(M^{[k]}_{τ[k]}) ≤ 1` for any `𝔉^{[k]}`-stopping
time".)  Optional stopping, standard fact (implicit step filled in): for the stopped process
`F_n = M_{τ∧n}`, `E F_{n+1} ≤ E F_n` by S9c on `{τ > n} ∈ 𝔉^{[k]}_n`, `E F_0 = E M_0 = 1`
(`I_k(0) = ∅`), and Fatou as `n → ∞` (`τ` is `ℕ`-valued, so `F_n → M_τ` pointwise). -/
theorem P04_S10 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (τ' : Ω → ℕ)
    (hτ' : ∀ t, MeasurableSet[filtK ℱ h k t] {ω | τ' ω ≤ t}) :
    ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (τ' ω) ω) ∂Q ≤ 1 := by
  have hprob : IsProbabilityMeasure Q := hQ.1.1
  have hle := filtK_le ℱ (Ω := Ω) h k
  have hτm : Measurable τ' := by
    refine measurable_of_Iic fun x => ?_
    have : τ' ⁻¹' Set.Iic x = {ω | τ' ω ≤ x} := rfl
    rw [this]
    exact hle x _ (hτ' x)
  have hMmeas : ∀ n, Measurable (fun ω => Mk S h Y p q lam k n ω) := fun n =>
    (P04_S9a S h hh ℱ Y c p q lam hset hS k hk n).mono (hle n) le_rfl
  have hGmeas : Measurable fun x : Ω × ℕ => Mk S h Y p q lam k x.2 x.1 :=
    measurable_from_prod_countable (fun n => hMmeas n)
  obtain ⟨F, hF⟩ : ∃ F : ℕ → Ω → ENNReal,
      F = fun n ω => ENNReal.ofReal (Mk S h Y p q lam k (min (τ' ω) n) ω) := ⟨_, rfl⟩
  have hFmeas : ∀ n, Measurable (F n) := fun n => by
    rw [hF]
    have hmin : Measurable fun ω => min (τ' ω) n := hτm.min (measurable_const (a := n))
    have hpair : Measurable fun ω : Ω => (ω, min (τ' ω) n) := measurable_id.prodMk hmin
    have h3 := hGmeas.comp hpair
    exact ENNReal.measurable_ofReal.comp h3
  have hstep : ∀ n, ∫⁻ ω, F (n + 1) ω ∂Q ≤ ∫⁻ ω, F n ω ∂Q := by
    intro n
    have hBm : MeasurableSet {ω | τ' ω ≤ n} := hle n _ (hτ' n)
    rw [← lintegral_add_compl (F (n + 1)) hBm, ← lintegral_add_compl (F n) hBm]
    refine add_le_add (le_of_eq (setLIntegral_congr_fun hBm (Filter.Eventually.of_forall fun ω hω => ?_))) ?_
    · have hω' : τ' ω ≤ n := hω
      simp only [hF, min_eq_left hω', min_eq_left (le_trans hω' (Nat.le_succ n))]
    · have hS9 := P04_S9c S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS Q hQ k hk n
        {ω | τ' ω ≤ n}ᶜ (hτ' n).compl
      calc ∫⁻ ω in {ω | τ' ω ≤ n}ᶜ, F (n + 1) ω ∂Q
          = ∫⁻ ω in {ω | τ' ω ≤ n}ᶜ, ENNReal.ofReal (Mk S h Y p q lam k (n + 1) ω) ∂Q :=
            setLIntegral_congr_fun hBm.compl (Filter.Eventually.of_forall fun ω hω => by
              have hω' : n < τ' ω := not_le.1 hω
              simp only [hF, min_eq_right (Nat.succ_le_of_lt hω')])
        _ ≤ ∫⁻ ω in {ω | τ' ω ≤ n}ᶜ, ENNReal.ofReal (Mk S h Y p q lam k n ω) ∂Q := hS9
        _ = ∫⁻ ω in {ω | τ' ω ≤ n}ᶜ, F n ω ∂Q :=
            setLIntegral_congr_fun hBm.compl (Filter.Eventually.of_forall fun ω hω => by
              have hω' : n < τ' ω := not_le.1 hω
              simp only [hF, min_eq_right hω'.le])
  have hbound : ∀ n, ∫⁻ ω, F n ω ∂Q ≤ 1 := by
    intro n
    induction n with
    | zero => simp [hF, Mk_zero]
    | succ n ih => exact (hstep n).trans ih
  have hlim : ∀ ω, Filter.liminf (fun n => F n ω) Filter.atTop
      = ENNReal.ofReal (Mk S h Y p q lam k (τ' ω) ω) := by
    intro ω
    refine Filter.Tendsto.liminf_eq (tendsto_atTop_of_eventually_const (i₀ := τ' ω) fun n hn => ?_)
    simp only [hF, min_eq_left hn]
  calc ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (τ' ω) ω) ∂Q
      = ∫⁻ ω, Filter.liminf (fun n => F n ω) Filter.atTop ∂Q := by simp_rw [hlim]
    _ ≤ Filter.liminf (fun n => ∫⁻ ω, F n ω ∂Q) Filter.atTop := lintegral_liminf_le hFmeas
    _ ≤ Filter.limsup (fun n => ∫⁻ ω, F n ω ∂Q) Filter.atTop := Filter.liminf_le_limsup
    _ ≤ 1 := Filter.limsup_le_of_le (h := Filter.Eventually.of_forall hbound)

/-- S11.  (l.452-455 with the deterministic stopping time `τ ≡ T`.)  `e_T ≥ 0` (S1) and
`E_Q e_T = (1/h) ∑_k E_Q M^{[k]}_T ≤ 1` (S8, S10 with the constant stopping time `T`, which is a
stopping time for `𝔉^{[k]}` since `{T ≤ t}` is `∅` or `Ω`; linearity of `∫⁻`). -/
theorem P04_S11 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 < h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (T : ℕ) (hT : h + 1 ≤ T) :
    IsEValueUnder (eT S h Y p q lam T) (HScInt S h ℱ Y c p q) := by
  have hh1 : 1 ≤ h := by omega
  have hpos : (0:ℝ) ≤ 1 / (h : ℝ) := by positivity
  refine ⟨fun ω => ?_, fun Q hQ => ?_⟩
  · rw [P04_S8]
    exact mul_nonneg hpos (Finset.sum_nonneg fun k hk =>
      P04_S9b S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS k hk T ω)
  · have hprob : IsProbabilityMeasure Q := hQ.1.1
    have hle := filtK_le ℱ (Ω := Ω) h
    have hkb : ∀ k ∈ Finset.Icc 1 h, ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k T ω) ∂Q ≤ 1 :=
      fun k hk => P04_S10 S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS Q hQ k hk (fun _ => T)
        (fun t => MeasurableSet.const (T ≤ t))
    have hmeas : ∀ k ∈ Finset.Icc 1 h,
        Measurable fun ω => ENNReal.ofReal (Mk S h Y p q lam k T ω) := fun k hk =>
      ENNReal.measurable_ofReal.comp
        ((P04_S9a S h hh ℱ Y c p q lam hset hS k hk T).mono (hle k T) le_rfl)
    have he : ∀ ω, ENNReal.ofReal (eT S h Y p q lam T ω) = ENNReal.ofReal (1 / (h : ℝ)) *
        ∑ k ∈ Finset.Icc 1 h, ENNReal.ofReal (Mk S h Y p q lam k T ω) := by
      intro ω
      rw [P04_S8, ENNReal.ofReal_mul hpos, ENNReal.ofReal_sum_of_nonneg (fun k hk =>
        P04_S9b S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS k hk T ω)]
    simp_rw [he]
    rw [lintegral_const_mul' _ _ ENNReal.ofReal_ne_top, lintegral_finset_sum _ hmeas]
    calc ENNReal.ofReal (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h,
          ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k T ω) ∂Q
        ≤ ENNReal.ofReal (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, (1 : ENNReal) := by
          gcongr with k hk
          exact hkb k hk
      _ = 1 := by
        rw [Finset.sum_const, Nat.card_Icc, nsmul_eq_mul, Nat.add_sub_cancel,
          ← ENNReal.ofReal_natCast, mul_one, ← ENNReal.ofReal_mul hpos]
        have : 1 / (h : ℝ) * (h : ℝ) = 1 := by field_simp
        rw [this]; simp

/-- helper (technical): the integer-arithmetic form of `f_k(τ)` (l.458):
for `1 ≤ k ≤ h`, `τ ≥ 1`, `f_k(τ) = (q+1)h + k` with `q = ⌊(τ-k-1)/h⌋ ≥ -1`. -/
private lemma fk_ge (h k τ : ℕ) (hk : k ∈ Finset.Icc 1 h) (hτ : 1 ≤ τ) : k ≤ fk h k τ := by
  have hk' := Finset.mem_Icc.1 hk
  unfold fk
  have hpos : (0:ℤ) < h := by exact_mod_cast (by omega : 0 < h)
  have hq : (-1 : ℤ) ≤ ((τ : ℤ) - k - 1) / h := by
    rw [Int.le_ediv_iff_mul_le hpos]
    omega
  have : (0:ℤ) ≤ (((τ : ℤ) - k - 1) / h + 1) * h := mul_nonneg (by omega) hpos.le
  omega

/-- S12.  (l.456-459 "`f_k(τ) ∈ {τ, …, τ+h-1}`".)  Division with remainder:
`(τ-k-1) = h q + r`, `0 ≤ r < h`, `f_k(τ) = hq + h + k = τ - 1 - r + h`. -/
theorem P04_S12 (h k τ : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    τ ≤ fk h k τ ∧ fk h k τ ≤ τ + h - 1 := by
  have hk' := Finset.mem_Icc.1 hk
  unfold fk
  have hpos : (0:ℤ) < h := by exact_mod_cast (by omega : 0 < h)
  have h1 := Int.emod_nonneg ((τ : ℤ) - k - 1) hpos.ne'
  have h2 := Int.emod_lt_of_pos ((τ : ℤ) - k - 1) hpos
  have h3 := Int.ediv_add_emod ((τ : ℤ) - k - 1) h
  generalize ((τ : ℤ) - k - 1) / h = q at *
  generalize ((τ : ℤ) - k - 1) % h = r at *
  have e : (q + 1) * (h : ℤ) + k = (h : ℤ) * q + h + k := by ring
  rw [e]
  omega

/-- helper (technical): `f_k(τ) ≤ t ⇔ τ ≤ k + h s` for `t = k + h s + j`, `s = ⌊(t-k)/h⌋`
(l.460-461). -/
private lemma fk_le_iff (h k τ t : ℕ) (hk : k ∈ Finset.Icc 1 h) (hkt : k ≤ t) :
    fk h k τ ≤ t ↔ τ ≤ k + h * ((t - k) / h) := by
  have hk' := Finset.mem_Icc.1 hk
  have hpos : (0:ℤ) < h := by exact_mod_cast (by omega : 0 < h)
  unfold fk
  rw [Int.toNat_le]
  have hd := Nat.div_add_mod (t - k) h
  have hj := Nat.mod_lt (t - k) (show h > 0 by omega)
  generalize (t - k) / h = s at *
  generalize (t - k) % h = j at *
  have hd' : (h : ℤ) * s + j = (t : ℤ) - k := by
    have : ((h * s + j : ℕ) : ℤ) = ((t - k : ℕ) : ℤ) := by rw [hd]
    push_cast at this
    rw [Nat.cast_sub hkt] at this
    exact this
  have hj' : (j : ℤ) < h := by exact_mod_cast hj
  have hj0 : (0:ℤ) ≤ j := Int.natCast_nonneg j
  have hqs : ((τ : ℤ) - k - 1) / h < s ↔ (τ : ℤ) - k - 1 < s * h :=
    Int.ediv_lt_iff_lt_mul hpos
  have hmc : (s : ℤ) * h = h * s := mul_comm _ _
  generalize ((τ : ℤ) - k - 1) / h = q at *
  constructor
  · intro hle
    have : q < s := by
      by_contra hcon
      push_neg at hcon
      nlinarith
    have := hqs.1 this
    omega
  · intro hle
    have : (τ : ℤ) - k - 1 < s * h := by omega
    have hq := hqs.2 this
    push_cast
    nlinarith

/-- S13.  (l.459-463.)  For `t ≥ k`: `{f_k(τ) ≤ t} = {τ ≤ k + hs} ∈ ℱ_{k+hs} = 𝔉^{[k]}_t`
(`fk_le_iff`, `filtK_eq`).  For `t < k`: `f_k(τ) ≥ k > t` (`τ ≥ 1`), so the set is empty. -/
theorem P04_S13 (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0) (k : ℕ) (hk : k ∈ Finset.Icc 1 h)
    (τ : Ω → ℕ) (hτ : ∀ n, MeasurableSet[ℱ n] {ω | τ ω ≤ n}) (hτ1 : ∀ ω, 1 ≤ τ ω) (t : ℕ) :
    MeasurableSet[filtK ℱ h k t] {ω | fk h k (τ ω) ≤ t} := by
  have hk' := Finset.mem_Icc.1 hk
  by_cases hkt : k ≤ t
  · rw [filtK_eq ℱ h k t (by omega) hk'.1 hkt]
    have : {ω | fk h k (τ ω) ≤ t} = {ω | τ ω ≤ k + h * ((t - k) / h)} := by
      ext ω
      exact fk_le_iff h k (τ ω) t hk hkt
    rw [this]
    exact hτ _
  · have : {ω | fk h k (τ ω) ≤ t} = ∅ := by
      ext ω
      simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false, not_le]
      have := fk_ge h k (τ ω) hk (hτ1 ω)
      omega
    rw [this]
    exact @MeasurableSet.empty _ (filtK ℱ h k t)

/-- helper (technical): `⌊(t+h-1-k)/h⌋ = ⌊(f_k(t)-k)/h⌋` (l.468). -/
private lemma fk_div (h k t : ℕ) (hk : k ∈ Finset.Icc 1 h) (ht : 1 ≤ t) :
    (t + h - 1 - k) / h = (fk h k t - k) / h := by
  have hk' := Finset.mem_Icc.1 hk
  have hpos : (0:ℤ) < h := by exact_mod_cast (by omega : 0 < h)
  have hge := fk_ge h k t hk ht
  have hq : (-1 : ℤ) ≤ ((t : ℤ) - k - 1) / h := by
    rw [Int.le_ediv_iff_mul_le hpos]
    omega
  have hnn : (0:ℤ) ≤ (((t : ℤ) - k - 1) / h + 1) * h := mul_nonneg (by omega) hpos.le
  have hfk : ((fk h k t : ℕ) : ℤ) = (((t : ℤ) - k - 1) / h + 1) * h + k := by
    unfold fk
    rw [Int.toNat_of_nonneg (by omega)]
  have e1 : (((t + h - 1 - k) / h : ℕ) : ℤ) = ((t : ℤ) - k - 1) / h + 1 := by
    rw [Int.natCast_div]
    have : ((t + h - 1 - k : ℕ) : ℤ) = ((t : ℤ) - k - 1) + 1 * h := by omega
    rw [this, Int.add_mul_ediv_right _ _ hpos.ne']
  have e2 : (((fk h k t - k) / h : ℕ) : ℤ) = ((t : ℤ) - k - 1) / h + 1 := by
    rw [Int.natCast_div]
    have : ((fk h k t - k : ℕ) : ℤ) = (((t : ℤ) - k - 1) / h + 1) * h := by omega
    rw [this, Int.mul_ediv_cancel _ hpos.ne']
  exact_mod_cast e1.trans e2.symm

/-- S14.  (l.468.)  `I_k(t+h-1) = I_k(f_k(t))` by `fk_div`; unfold `eT`, `Mk`. -/
theorem P04_S14 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ)
    (ht : 1 ≤ t) (ω : Ω) :
    eT S h Y p q lam (t + h - 1) ω =
      (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k (fk h k t) ω := by
  unfold eT Mk
  congr 1
  refine Finset.sum_congr rfl fun k hk => ?_
  have : Ik h (t + h - 1) k = Ik h (fk h k t) k := by
    unfold Ik
    rw [fk_div h k t hk ht]
  rw [this]

/-- Main theorem (l.216-221): measurability is S3; the e-value property is S7 (`h = 1`, l.199-214)
or S11 (`h > 1`, l.446-469). -/
theorem P04_main (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
    (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) :
    ∀ T : ℕ, h + 1 ≤ T → P04Conclusion S h ℱ Y c p q lam T := by
  intro T hT
  refine ⟨P04_S3 S h hh ℱ Y c p q lam hset hS T hT, ?_⟩
  rcases Nat.eq_or_lt_of_le hh with h1 | h1
  · exact P04_S7 S ν hrep h h1.symm ℱ Y c p q lam hT01 hMix hset hS T hT
  · exact P04_S11 S ν hrep h h1 ℱ Y c p q lam hT01 hMix hset hS T hT

end Paper.P04
