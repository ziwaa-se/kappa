import P04Stmt

/-!
# P04 proof (source/VSIFP_02.tex:222-227, Proposition 3.4; proof 469-471 and h=1 sketch 205-220)
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

/-- S1.  (source l.213-215 and 403, the factor-wise fact behind "e-value"; l.470 gives nothing.)
Every factor `E_{p_t,q_t;λ_t}(Y_{t+h})` is nonnegative.  Uses T01 consumed clause (l.403:
`E(y) ≥ 1-λ ≥ 0`) with `ν` from `hrep` and `P04_MixingOfStrict`; for `λ_t = 0` the factor is `1`;
for `p_t = q_t` the source (T01 needs `p ≠ q`) gives nothing: in Lean `Erep = 1` then. -/
theorem P04_S1 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
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

/-- S2.  (l.223 "are `ℱ_T`-measurable"; the source gives no justification.)  The factor
`ω ↦ E_{p_t,q_t;λ_t}(Y_{t+h}(ω))` is `ℱ_{t+h}`-measurable.  Silently needs measurability of
`S(·,y)` on `(0,1)` (not stated in the source; follows from consistency by monotonicity). -/
theorem P04_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) (t : ℕ) :
    Measurable[ℱ (t + h)] (fun ω => Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) := by
  have hle : ℱ t ≤ ℱ (t + h) := ℱ.mono (Nat.le_add_right t h)
  exact meas_Erep hS.1 ((hset.p_adapted t).mono hle le_rfl) ((hset.q_adapted t).mono hle le_rfl)
    (fun ω => Set.Ioo_subset_Icc_self (hset.p_mem t ω))
    (fun ω => Set.Ioo_subset_Icc_self (hset.q_mem t ω))
    ((hset.lam_adapted t).mono hle le_rfl) (hset.Y_adapted (t + h)) (hset.Y_mem (t + h))

/-- S3.  (l.223 "`e_T` are `ℱ_T`-measurable".)  From S2, `l + h ≤ T` for `l ∈ I_k`
(`l ≤ k + h(⌊(T-k)/h⌋ - 1)`), monotonicity of the filtration, finite products and sums. -/
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

/-- S4.  (h=1 sketch l.211-215, general lag l.469-470; X04.)  Pointwise preparation:
with `π_t = E_Q(Y_{t+h} | ℱ_t)`, a.s. `π_t ∈ [0,1]`, and (if `c_t = 1`) `π_t ∈ H_S(p_t,q_t)`,
i.e. `E_{π_t}{S(p_t,Y) - S(q_t,Y)} ≤ 0`.  The source states only
"almost surely for `Q ∈ ℋ_{S;c}`" (l.215) with no derivation of this identification. -/
theorem P04_S4 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
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
  -- the score difference is `d0 * (1 - Y) + d1 * Y` with `ℱ_t`-measurable `d0, d1`
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

/-- helper (technical): pointwise form of the one-step bound (l.213-215): for `π ∈ H_S(p,q)`
(when `c = 1`), `E_π E_{p,q;λ} ≤ 1`; the cases `λ = 0` (l.211) and `p = q` give `E ≡ 1`. -/
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

/-- helper (technical): the one-step bound of S6 (core). -/
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
  have hS4 := P04_S4 S h ℱ Y c p q lam hset hS Q hQ t
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

/-- S6.  (l.209: "pull out the `ℱ_T`-measurable factors"; X07.)  For `ℱ_t`-measurable
`g : Ω → ℝ≥0∞`: `∫ g · E_t(Y_{t+h}) dQ ≤ ∫ g dQ`.  Uses S5. -/
theorem P04_S6 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (g : Ω → ENNReal)
    (hg : Measurable[ℱ t] g) :
    ∫⁻ ω, g ω * ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
      ≤ ∫⁻ ω, g ω ∂Q :=
  core6 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS Q hQ t g hg

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
  have hprob : IsProbabilityMeasure Q := hQ.1.1
  induction n with
  | zero => simp
  | succ n ih =>
    have hnn : ∀ ω, 0 ≤ ∏ s ∈ Finset.range n,
        Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω) (Y (k + h * s + h) ω) :=
      fun ω => Finset.prod_nonneg fun s _ =>
        P04_S1 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS (k + h * s) ω
    have hG : Measurable[ℱ (k + h * n)] (fun ω => ENNReal.ofReal (∏ s ∈ Finset.range n,
        Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω)
          (Y (k + h * s + h) ω))) :=
      ENNReal.measurable_ofReal.comp (prod_meas S h ℱ Y c p q lam hset hS k n)
    calc ∫⁻ ω, ENNReal.ofReal (∏ s ∈ Finset.range (n + 1),
          Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω)
            (Y (k + h * s + h) ω)) ∂Q
        = ∫⁻ ω, ENNReal.ofReal (∏ s ∈ Finset.range n,
          Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω)
            (Y (k + h * s + h) ω)) *
          ENNReal.ofReal (Erep S (p (k + h * n) ω) (q (k + h * n) ω) (lam (k + h * n) ω)
            (Y (k + h * n + h) ω)) ∂Q := by
          refine lintegral_congr fun ω => ?_
          rw [Finset.prod_range_succ, ENNReal.ofReal_mul (hnn ω)]
      _ ≤ ∫⁻ ω, ENNReal.ofReal (∏ s ∈ Finset.range n,
          Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω)
            (Y (k + h * s + h) ω)) ∂Q :=
          P04_S6 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS Q hQ (k + h * n) _ hG
      _ ≤ 1 := ih

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
  have hnn : ∀ (ω : Ω) (k : ℕ), 0 ≤ ∏ l ∈ Ik h T k,
      Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω) :=
    fun ω k => Finset.prod_nonneg fun l _ =>
      P04_S1 S ν hrep h ℱ Y c p q lam hT01 hMix hset hS l ω
  refine ⟨fun ω => ?_, fun Q hQ => ?_⟩
  · unfold eT
    exact mul_nonneg (by positivity) (Finset.sum_nonneg fun k _ => hnn ω k)
  · have hprob : IsProbabilityMeasure Q := hQ.1.1
    -- `I_k` is the image of `range ((T-k)/h)` under the injective map `s ↦ k + h s`
    have hIk : ∀ (k : ℕ) (ω : Ω), ∏ l ∈ Ik h T k,
        Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω) =
        ∏ s ∈ Finset.range ((T - k) / h),
          Erep S (p (k + h * s) ω) (q (k + h * s) ω) (lam (k + h * s) ω) (Y (k + h * s + h) ω) := by
      intro k ω
      unfold Ik
      refine Finset.prod_image fun x _ y _ hxy => ?_
      have hxy' : h * x = h * y := by simpa using hxy
      exact Nat.eq_of_mul_eq_mul_left (by omega) hxy'
    have hmeas : ∀ k : ℕ, Measurable fun ω => ENNReal.ofReal (∏ l ∈ Ik h T k,
        Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω)) := by
      intro k
      simp_rw [hIk k]
      exact ENNReal.measurable_ofReal.comp
        ((prod_meas S h ℱ Y c p q lam hset hS k ((T - k) / h)).mono (ℱ.le _) le_rfl)
    have hk : ∀ k : ℕ, ∫⁻ ω, ENNReal.ofReal (∏ l ∈ Ik h T k,
        Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω)) ∂Q ≤ 1 := by
      intro k
      simp_rw [hIk k]
      exact P04_S7 S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS Q hQ k ((T - k) / h)
    have hpt : ∀ ω, ENNReal.ofReal (eT S h Y p q lam T ω) =
        ENNReal.ofReal (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, ENNReal.ofReal (∏ l ∈ Ik h T k,
          Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω)) := by
      intro ω
      unfold eT
      rw [ENNReal.ofReal_mul (by positivity),
        ENNReal.ofReal_sum_of_nonneg fun k _ => hnn ω k]
    simp_rw [hpt]
    rw [lintegral_const_mul' _ _ ENNReal.ofReal_ne_top,
      lintegral_finset_sum _ fun k _ => hmeas k]
    calc ENNReal.ofReal (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, ∫⁻ ω, ENNReal.ofReal
          (∏ l ∈ Ik h T k, Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω)) ∂Q
        ≤ ENNReal.ofReal (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, (1 : ENNReal) := by
          gcongr with k hk'
          exact hk k
      _ = 1 := by
          rw [Finset.sum_const, Nat.card_Icc, nsmul_eq_mul, Nat.add_sub_cancel]
          have hh0 : (h : ℝ) ≠ 0 := by positivity
          rw [mul_one, ← ENNReal.ofReal_natCast, ← ENNReal.ofReal_mul (by positivity)]
          rw [one_div, inv_mul_cancel₀ hh0]
          exact ENNReal.ofReal_one

/-- Main theorem (l.222-227).  For all `T ≥ h+1`, `e_T` is `ℱ_T`-measurable and an e-value under
`ℋ_{S;c}`.  Hypotheses: l.223 (`SeqSetting`, strict consistency, lag `h ≥ 1` from l.111),
the consumed T01 clause and the mixing-measure input. -/
theorem P04_main (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S) :
    ∀ T : ℕ, h + 1 ≤ T → P04Conclusion S h ℱ Y c p q lam T := by
  intro T hT
  exact ⟨P04_S3 S h hh ℱ Y c p q lam hset hS T hT,
    P04_S8 S ν hrep h hh ℱ Y c p q lam hT01 hMix hset hS T hT⟩

end Paper.P04
