import P05Stmt

/-!
# P05 proof with gaps (Proposition 3.5, `prop:stopping`), source `source/VSIFP_02.tex`
Gap file: obligation `P05_S0` (h = 1, no source proof) is replaced by `P05_S0_Gap`.
-/

open MeasureTheory Paper.P04

namespace Paper.P05

universe u_1

variable {Ω : Type u_1} {m0 : MeasurableSpace Ω}

private lemma S0_mono {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {p q : ℝ}
    (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) (hpq : p ≤ q) : S p 0 ≤ S q 0 := by
  rcases eq_or_lt_of_le hpq with rfl | hlt
  · exact le_rfl
  have h1 := hc q hq p hp
  have h2 := hc p hp q hq
  simp only [Paper.expPi] at h1 h2
  have hq0 : 0 ≤ q := hq.1
  have hp0 : 0 ≤ p := hp.1
  have h1d : 0 ≤ (1 - p) * (S q 0 - S p 0) + p * (S q 1 - S p 1) := by nlinarith
  have h2d : (1 - q) * (S q 0 - S p 0) + q * (S q 1 - S p 1) ≤ 0 := by nlinarith
  have key : 0 ≤ (q - p) * (S q 0 - S p 0) := by
    nlinarith [mul_nonneg hq0 h1d, mul_nonneg hp0 (neg_nonneg.2 h2d)]
  by_contra hcon
  push_neg at hcon
  nlinarith

private lemma S1_anti {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {p q : ℝ}
    (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) (hpq : p ≤ q) : S q 1 ≤ S p 1 := by
  rcases eq_or_lt_of_le hpq with rfl | hlt
  · exact le_rfl
  have h1 := hc q hq p hp
  have h2 := hc p hp q hq
  simp only [Paper.expPi] at h1 h2
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

private lemma meas_Erep {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {m : MeasurableSpace Ω}
    {p q lam Z : Ω → ℝ} (hp : Measurable[m] p) (hq : Measurable[m] q)
    (hp' : ∀ ω, p ω ∈ Set.Icc (0:ℝ) 1) (hq' : ∀ ω, q ω ∈ Set.Icc (0:ℝ) 1)
    (hl : Measurable[m] lam) (hZ : Measurable[m] Z) (hZ' : ∀ ω, Z ω = 0 ∨ Z ω = 1) :
    Measurable[m] (fun ω => Paper.Erep S (p ω) (q ω) (lam ω) (Z ω)) := by
  unfold Paper.Erep
  have h1 := meas_SZ hc hp hp' hZ hZ'
  have h2 := meas_SZ hc hq hq' hZ hZ'
  have h3 := meas_Sb hc hp hp' hp hq
  have h4 := meas_Sb hc hq hq' hp hq
  exact measurable_const.add ((hl.mul (h1.sub h2)).div (continuous_abs.measurable.comp (h3.sub h4)))

private lemma meas_factor (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (t : ℕ) :
    Measurable (fun ω => Paper.Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) := by
  have hle : ℱ t ≤ ℱ (t + h) := ℱ.mono (Nat.le_add_right t h)
  have := meas_Erep hS.1 ((hset.p_adapted t).mono hle le_rfl) ((hset.q_adapted t).mono hle le_rfl)
    (fun ω => Set.Ioo_subset_Icc_self (hset.p_mem t ω))
    (fun ω => Set.Ioo_subset_Icc_self (hset.q_mem t ω))
    ((hset.lam_adapted t).mono hle le_rfl) (hset.Y_adapted (t + h)) (hset.Y_mem (t + h))
  exact this.mono (ℱ.le _) le_rfl

private lemma fk_le_iff (h k τ t : ℕ) (hh : 1 ≤ h) :
    fk h k τ ≤ t ↔ (τ : ℤ) ≤ ((t : ℤ) - k) / h * h + k := by
  have hpos : (0 : ℤ) < h := by exact_mod_cast hh
  unfold fk
  rw [Int.toNat_le]
  constructor
  · intro H
    have h1 : (((τ : ℤ) - k - 1) / h + 1) * h ≤ (t : ℤ) - k := by linarith
    have h2 : ((τ : ℤ) - k - 1) / h + 1 ≤ ((t : ℤ) - k) / h := (Int.le_ediv_iff_mul_le hpos).2 h1
    have h3 : ((τ : ℤ) - k - 1) / h < ((t : ℤ) - k) / h := by linarith
    have h4 := (Int.ediv_lt_iff_lt_mul hpos).1 h3
    linarith
  · intro H
    have h4 : (τ : ℤ) - k - 1 < ((t : ℤ) - k) / h * h := by linarith
    have h3 := (Int.ediv_lt_iff_lt_mul hpos).2 h4
    have h2 : ((τ : ℤ) - k - 1) / h + 1 ≤ ((t : ℤ) - k) / h := by linarith
    have h1 := (Int.le_ediv_iff_mul_le hpos).1 h2
    linarith

private lemma ofReal_sum_le' {ι : Type*} (s : Finset ι) (f : ι → ℝ) :
    ENNReal.ofReal (∑ i ∈ s, f i) ≤ ∑ i ∈ s, ENNReal.ofReal (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
    rw [Finset.sum_insert ha, Finset.sum_insert ha]
    exact (ENNReal.ofReal_add_le).trans (add_le_add le_rfl ih)

/-- Gap: S0 (the case `h = 1`), full ∀-closure of the type of `P05_S0`. -/
def P05_S0_Gap : Prop :=
  ∀ {Ω : Type u_1} {m0 : MeasurableSpace Ω} (S : ℝ → ℝ → ℝ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ),
    P05Conclusion S 1 ℱ Y p q lam τ

theorem P05_S1 (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ) (ω : Ω) :
    eT S h Y p q lam t ω = (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k t ω := rfl

theorem P05_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) :
    HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q ⊆ HScInt S h ℱ Y c p q := by
  intro Q hQ
  obtain ⟨⟨hP, hH⟩, hI⟩ := hQ
  refine ⟨⟨hP, fun t => ?_⟩, hI⟩
  filter_upwards [hH t] with ω hω
  rcases hset.c_mem t ω with h0 | h1
  · rw [h0]; simp
  · rw [h1]; simpa using hω

theorem P05_S3 (h k τ : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    τ ≤ fk h k τ ∧ fk h k τ ≤ τ + h - 1 := by
  have hk' := Finset.mem_Icc.1 hk
  have hpos : (0 : ℤ) < h := by exact_mod_cast hk'.1.trans hk'.2
  set a : ℤ := (τ : ℤ) - k - 1 with ha
  have e := Int.emod_add_ediv a h
  have r0 := Int.emod_nonneg a hpos.ne'
  have r1 := Int.emod_lt_of_pos a hpos
  have hX : (a / h + 1) * h + k = (τ : ℤ) - 1 - a % h + h := by
    linear_combination e
  unfold fk
  rw [← ha, hX]
  omega

theorem P05_S4 (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0) (k : ℕ) (hk : k ∈ Finset.Icc 1 h)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) (t : ℕ) :
    MeasurableSet[filtK ℱ h k t] {ω | fk h k (τ ω) ≤ t} := by
  have e : {ω | fk h k (τ ω) ≤ t} = {ω | (τ ω : ℤ) ≤ ((t : ℤ) - k) / h * h + k} := by
    ext ω
    exact fk_le_iff h k (τ ω) t (by omega)
  rw [e]
  unfold filtK
  split_ifs with hJ
  · have : {ω | (τ ω : ℤ) ≤ ((t : ℤ) - k) / h * h + k} = ∅ := by
      ext ω
      have := hτ.pos ω
      simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false, not_le]
      omega
    rw [this]
    exact @MeasurableSet.empty _ ⊥
  · have : {ω | (τ ω : ℤ) ≤ ((t : ℤ) - k) / h * h + k}
        = {ω | τ ω ≤ (((t : ℤ) - k) / h * h + k).toNat} := by
      ext ω
      simp only [Set.mem_setOf_eq]
      omega
    rw [this]
    exact hτ.le_meas _

theorem P05_S5 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ)
    (ht : 1 ≤ t) (ω : Ω) :
    eT S h Y p q lam (t + h - 1) ω =
      (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k (fk h k t) ω := by
  unfold eT Mk
  congr 1
  refine Finset.sum_congr rfl fun k hk => ?_
  have hk' := Finset.mem_Icc.1 hk
  have hpos : (0 : ℤ) < h := by exact_mod_cast (by omega : 0 < h)
  have hkle : k ≤ t + h - 1 := by omega
  set n := (t + h - 1 - k) / h with hn
  have hn' : (n : ℤ) = ((t : ℤ) - k - 1) / h + 1 := by
    rw [hn, Int.natCast_div, Nat.cast_sub hkle, Nat.cast_sub (by omega : 1 ≤ t + h)]
    push_cast
    have : (t : ℤ) + h - 1 - k = ((t : ℤ) - k - 1) + 1 * h := by ring
    rw [this, Int.add_mul_ediv_right _ _ hpos.ne']
  have hf : fk h k t = n * h + k := by
    unfold fk
    rw [← hn']
    have : (n : ℤ) * h + k = ((n * h + k : ℕ) : ℤ) := by push_cast; ring
    rw [this, Int.toNat_natCast]
  have : (fk h k t - k) / h = n := by
    rw [hf, Nat.add_sub_cancel]
    exact Nat.mul_div_cancel n (by omega)
  unfold Ik
  rw [this, hn]

theorem P05_S6 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    Measurable (fun ω => Mk S h Y p q lam k (fk h k (τ ω)) ω) := by
  have hτm : Measurable τ := by
    refine measurable_to_countable' fun n => ?_
    have hn : τ ⁻¹' {n} = {ω | τ ω ≤ n} ∩ {ω | τ ω ≤ n - 1}ᶜ := by
      ext ω
      have := hτ.pos ω
      simp only [Set.mem_preimage, Set.mem_singleton_iff, Set.mem_inter_iff, Set.mem_setOf_eq,
        Set.mem_compl_iff, not_le]
      omega
    rw [hn]
    exact ((ℱ.le n) _ (hτ.le_meas n)).inter ((ℱ.le (n - 1) _ (hτ.le_meas (n - 1))).compl)
  have hM : ∀ n, Measurable (fun ω => Mk S h Y p q lam k n ω) := fun n => by
    unfold Mk
    exact Finset.measurable_prod _ fun l _ => meas_factor S h ℱ Y c p q lam hset hS l
  have hfk : Measurable (fun ω => fk h k (τ ω)) :=
    (measurable_from_top (f := fk h k)).comp hτm
  have := (measurable_from_prod_countable (f := fun (x : Ω × ℕ) => Mk S h Y p q lam k x.2 x.1)
    (fun n => hM n))
  have hg : Measurable (fun ω : Ω => (ω, fk h k (τ ω))) := measurable_id.prodMk hfk
  exact Measurable.comp (g := fun (x : Ω × ℕ) => Mk S h Y p q lam k x.2 x.1)
    (f := fun ω : Ω => (ω, fk h k (τ ω))) this hg

theorem P05_S7 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (fk h k (τ ω)) ω) ∂Q ≤ 1 :=
  hP04 hrep hset hS hh Q hQ k hk (fun ω => fk h k (τ ω)) (P05_S4 h hh ℱ k hk τ hτ)

theorem P05_S8 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S h ℱ Y p q lam τ := by
  intro Q hQ
  have hpt : ∀ ω, ENNReal.ofReal (eT S h Y p q lam (τ ω + h - 1) ω)
      ≤ ENNReal.ofReal (1 / (h : ℝ)) *
        ∑ k ∈ Finset.Icc 1 h, ENNReal.ofReal (Mk S h Y p q lam k (fk h k (τ ω)) ω) := by
    intro ω
    rw [P05_S5 S h hh Y p q lam (τ ω) (hτ.pos ω) ω,
      ENNReal.ofReal_mul (by positivity)]
    exact mul_le_mul_left' (ofReal_sum_le' _ _) _
  calc ∫⁻ ω, ENNReal.ofReal (eT S h Y p q lam (τ ω + h - 1) ω) ∂Q
      ≤ ∫⁻ ω, ENNReal.ofReal (1 / (h : ℝ)) *
        ∑ k ∈ Finset.Icc 1 h, ENNReal.ofReal (Mk S h Y p q lam k (fk h k (τ ω)) ω) ∂Q :=
        lintegral_mono hpt
    _ = ENNReal.ofReal (1 / (h : ℝ)) *
        ∑ k ∈ Finset.Icc 1 h, ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (fk h k (τ ω)) ω) ∂Q := by
        rw [lintegral_const_mul' _ _ ENNReal.ofReal_ne_top,
          lintegral_finset_sum]
        intro k hk
        exact ENNReal.measurable_ofReal.comp (P05_S6 S h hh ℱ Y c p q lam hset hS k hk τ hτ)
    _ ≤ ENNReal.ofReal (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, (1 : ENNReal) :=
        mul_le_mul_left' (Finset.sum_le_sum fun k hk =>
          P05_S7 S ν hrep h hh ℱ Y c p q lam hP04 hset hS τ hτ Q hQ k hk) _
    _ = 1 := by
        rw [Finset.sum_const, Nat.card_Icc, nsmul_eq_mul, mul_one, Nat.add_sub_cancel,
          ← ENNReal.ofReal_natCast, ← ENNReal.ofReal_mul (by positivity)]
        have : (h : ℝ) ≠ 0 := by positivity
        rw [one_div, inv_mul_cancel₀ this]
        simp

/-- Main theorem (l.229-234), modulo the `h = 1` gap. -/
theorem P05_main_mod_gaps (hGap_0 : P05_S0_Gap.{u_1})
    (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S h ℱ Y p q lam τ := by
  rcases Nat.eq_or_lt_of_le hh with h1 | h1
  · subst h1
    exact hGap_0 S ℱ Y c p q lam hset hS τ hτ
  · exact P05_S8 S ν hrep h h1 ℱ Y c p q lam hP04 hset hS τ hτ

end Paper.P05
