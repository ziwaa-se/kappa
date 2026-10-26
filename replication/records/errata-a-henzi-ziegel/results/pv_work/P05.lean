import P05Stmt

/-!
# P05 proof (Proposition 3.5, `prop:stopping`), source `source/VSIFP_02.tex`
statement l.229-234; proof l.446-469 (the part l.456-468, `h > 1`).
Revision 1, pass 1.  Private helpers are technical conversions only (see notes).
-/

open MeasureTheory Paper.P04

namespace Paper.P05

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- helper (technical, copied from P04 S0_mono): `S(·,0)` nondecreasing on `[0,1]`. -/
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

/-- helper (technical): the factor is `m0`-measurable. -/
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

/-- helper (technical): `fk ≤ t ↔ τ ≤ ⌊(t-k)/h⌋ h + k` (integer arithmetic of l.460). -/
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

/-- helper (technical): `ofReal` of a finite sum is at most the sum of the `ofReal`s. -/
private lemma ofReal_sum_le' {ι : Type*} (s : Finset ι) (f : ι → ℝ) :
    ENNReal.ofReal (∑ i ∈ s, f i) ≤ ∑ i ∈ s, ENNReal.ofReal (f i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
    rw [Finset.sum_insert ha, Finset.sum_insert ha]
    exact (ENNReal.ofReal_add_le).trans (add_le_add le_rfl ih)

/-! ### Case `h = 1` (session 2): l.200-214 (one-step bound, supermartingale) and l.227
(optional stopping, Ramdas 2020 Sec. 3), filled in as in `P04_S9c`/`P04_S10`
(issue ruling `verification/audits/P05_issue_1.md` §6, FAIR_IMPLICIT_STEP). -/

/-- helper (technical, l.403 first sentence "`E(y) ≥ E{1(p>q)} = 1-λ ≥ 0`"): nonnegativity of
`E_{p,q;λ}(y)`.  The sign facts `S(p,b) ≤ S(q,b)` (`b = 1{p>q}`) and `S(p,1-b) ≥ S(q,1-b)` come
from consistency (`S0_mono`, `S1_anti`); `|·|` in the denominator, division by `0` gives `1`. -/
private lemma Erep_nonneg {S : ℝ → ℝ → ℝ} (hc : IsConsistent S) {p q lam y : ℝ}
    (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) (hlam : lam ∈ Set.Icc (0:ℝ) 1)
    (hy : y = 0 ∨ y = 1) : 0 ≤ Paper.Erep S p q lam y := by
  have hd : -|S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)| ≤ S p y - S q y := by
    by_cases hqp : q < p
    · simp only [hqp, if_true]
      rcases hy with rfl | rfl
      · have h1 := S0_mono hc hq hp hqp.le
        have h2 := abs_nonneg (S p 1 - S q 1)
        linarith
      · exact neg_abs_le _
    · simp only [hqp, if_false]
      push_neg at hqp
      rcases hy with rfl | rfl
      · exact neg_abs_le _
      · have h1 := S1_anti hc hp hq hqp
        have h2 := abs_nonneg (S p 0 - S q 0)
        linarith
  unfold Paper.Erep
  rcases (abs_nonneg (S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0))).eq_or_lt
    with h0 | hpos
  · rw [← h0, div_zero]
    norm_num
  · have hm : lam * (-|S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)|)
        ≤ lam * (S p y - S q y) := mul_le_mul_of_nonneg_left hd hlam.1
    have : -lam ≤ lam * (S p y - S q y) /
        |S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)| := by
      rw [le_div_iff₀ hpos]
      linarith
    linarith [hlam.2]

/-- helper (technical, l.403 "one can easily verify that `E` has the given null hypothesis", used at
l.207): pointwise one-step bound `E_π E_{p,q;λ} ≤ 1` for `π ∈ H_S(p,q)` when `c = 1`
(`E_π E = 1 + λ E_π{S(p,Y)-S(q,Y)} / |…|`); `λ = 0` (l.205) gives `E ≡ 1`.  Same statement as P04's
private `pt_bound`, here derived from consistency (no T01 clause, no mixing measure). -/
private lemma pt_bound1 {S : ℝ → ℝ → ℝ} (hcons : IsConsistent S)
    {p q lam c π : ℝ} (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (hlam : lam ∈ Set.Icc (0:ℝ) 1) (hc : c = 0 ∨ c = 1) (hlc : c = 0 → lam = 0)
    (hπ0 : 0 ≤ π) (hπ1 : π ≤ 1) (hHS : c = 1 → π ∈ Paper.HS S p q) :
    ENNReal.ofReal (Paper.Erep S p q lam 0) * ENNReal.ofReal (1 - π)
      + ENNReal.ofReal (Paper.Erep S p q lam 1) * ENNReal.ofReal π ≤ 1 := by
  have hone : ENNReal.ofReal (1 - π) + ENNReal.ofReal π = 1 := by
    rw [← ENNReal.ofReal_add (by linarith) hπ0]; simp
  by_cases hl : lam = 0
  · simp [Paper.Erep, hl, hone]
  have hc1 : c = 1 := by
    rcases hc with h0 | h1
    · exact absurd (hlc h0) hl
    · exact h1
  have hpI : p ∈ Set.Icc (0:ℝ) 1 := Set.Ioo_subset_Icc_self hp
  have hqI : q ∈ Set.Icc (0:ℝ) 1 := Set.Ioo_subset_Icc_self hq
  have hE0 := Erep_nonneg hcons hpI hqI hlam (Or.inl rfl)
  have hE1 := Erep_nonneg hcons hpI hqI hlam (Or.inr rfl)
  have hexp : (1 - π) * Paper.Erep S p q lam 0 + π * Paper.Erep S p q lam 1 ≤ 1 := by
    obtain ⟨_, hf⟩ := hHS hc1
    simp only [Paper.expPi] at hf
    unfold Paper.Erep
    have e : (1 - π) * (1 + lam * (S p 0 - S q 0) /
          |S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)|)
        + π * (1 + lam * (S p 1 - S q 1) /
          |S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)|)
        = 1 + lam * ((1 - π) * (S p 0 - S q 0) + π * (S p 1 - S q 1)) /
          |S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)| := by ring
    rw [e]
    have : lam * ((1 - π) * (S p 0 - S q 0) + π * (S p 1 - S q 1)) /
        |S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)| ≤ 0 :=
      div_nonpos_of_nonpos_of_nonneg (mul_nonpos_of_nonneg_of_nonpos hlam.1 hf) (abs_nonneg _)
    linarith
  have e0 : ENNReal.ofReal (Paper.Erep S p q lam 0) * ENNReal.ofReal (1 - π)
      = ENNReal.ofReal ((1 - π) * Paper.Erep S p q lam 0) := by
    rw [ENNReal.ofReal_mul (by linarith : (0:ℝ) ≤ 1 - π), mul_comm]
  have e1 : ENNReal.ofReal (Paper.Erep S p q lam 1) * ENNReal.ofReal π
      = ENNReal.ofReal (π * Paper.Erep S p q lam 1) := by
    rw [ENNReal.ofReal_mul hπ0, mul_comm]
  rw [e0, e1, ← ENNReal.ofReal_add (mul_nonneg (by linarith) hE0) (mul_nonneg hπ0 hE1)]
  calc _ ≤ ENNReal.ofReal 1 := ENNReal.ofReal_le_ofReal hexp
    _ = 1 := ENNReal.ofReal_one

/-- helper (technical, copied from P04 `cond_prep`): `π_t = E_Q(Y_{t+h} | ℱ_t) ∈ [0,1]` and
(`c_t = 1`) `π_t ∈ H_S(p_t,q_t)` a.s., from the definition of `ℋ_{S;c}` (l.115). -/
private theorem cond_prep (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) :
    ∀ᵐ ω ∂Q, 0 ≤ condExp (ℱ t) Q (Y (t + h)) ω ∧ condExp (ℱ t) Q (Y (t + h)) ω ≤ 1 ∧
      (c t ω = 1 → condExp (ℱ t) Q (Y (t + h)) ω ∈ Paper.HS S (p t ω) (q t ω)) := by
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
  simp only [Paper.expPi]
  rw [hd0, hd1] at hc
  simp only at hc
  linarith

/-- helper (technical, copied from P04 `lint_condExp`): `∫ G · Z = ∫ G · E(Z|ℱ_t)` for
`ℱ_t`-measurable `G ≥ 0` and integrable `Z ≥ 0`. -/
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

/-- helper (technical, P04 `core6` with `pt_bound1`): weighted one-step bound (l.202-209, "pull out
the `ℱ_T`-measurable factors" and `E_Q{E_T(Y_{T+1}) | ℱ_T} ≤ 1`):
`∫ g · E_t(Y_{t+h}) dQ ≤ ∫ g dQ` for `ℱ_t`-measurable `g ≥ 0`. -/
private lemma core1 (S : ℝ → ℝ → ℝ) (h : ℕ)
    (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (g : Ω → ENNReal)
    (hg : Measurable[ℱ t] g) :
    ∫⁻ ω, g ω * ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
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
  have hE0 : Measurable[ℱ t] (fun ω => ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0)) :=
    ENNReal.measurable_ofReal.comp (meas_Erep (Z := fun _ => (0:ℝ)) hS.1 (hset.p_adapted t)
      (hset.q_adapted t) hpI hqI (hset.lam_adapted t) measurable_const (fun _ => Or.inl rfl))
  have hE1 : Measurable[ℱ t] (fun ω => ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 1)) :=
    ENNReal.measurable_ofReal.comp (meas_Erep (Z := fun _ => (1:ℝ)) hS.1 (hset.p_adapted t)
      (hset.q_adapted t) hpI hqI (hset.lam_adapted t) measurable_const (fun _ => Or.inr rfl))
  have hpt : ∀ ω, ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) =
      ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0) * ENNReal.ofReal (1 - Y (t + h) ω)
      + ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 1) * ENNReal.ofReal (Y (t + h) ω) := by
    intro ω
    rcases hset.Y_mem (t + h) ω with h0 | h0 <;> simp [h0]
  have hG0 : Measurable[ℱ t] fun ω => g ω *
      ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0) := hg.mul hE0
  have hG1 : Measurable[ℱ t] fun ω => g ω *
      ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 1) := hg.mul hE1
  have hG0' := hG0.mono hle le_rfl
  have hπm : Measurable (condExp (ℱ t) Q (Y (t + h))) :=
    ((stronglyMeasurable_condExp (m := ℱ t) (μ := Q) (f := Y (t + h))).mono hle).measurable
  have hcs : condExp (ℱ t) Q (fun ω => 1 - Y (t + h) ω) =ᵐ[Q]
      fun ω => 1 - condExp (ℱ t) Q (Y (t + h)) ω := by
    have := condExp_sub (m := ℱ t) (integrable_const (1:ℝ)) hYint
    rw [condExp_const hle] at this
    exact this
  have step1 : ∫⁻ ω, g ω * ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q
      = ∫⁻ ω, (g ω * ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0))
            * ENNReal.ofReal (1 - Y (t + h) ω) ∂Q
        + ∫⁻ ω, (g ω * ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 1))
            * ENNReal.ofReal (Y (t + h) ω) ∂Q := by
    rw [← lintegral_add_left (hG0'.mul (show Measurable fun ω => ENNReal.ofReal (1 - Y (t + h) ω)
      from ENNReal.measurable_ofReal.comp hY1m))]
    refine lintegral_congr fun ω => ?_
    rw [hpt ω]; ring
  rw [step1, lint_condExp ℱ t hY1m hiY1 hY1n hG0, lint_condExp ℱ t hYm hYint hYn hG1]
  have step2 : ∫⁻ ω, (g ω * ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0))
        * ENNReal.ofReal ((condExp (ℱ t) Q (fun ω => 1 - Y (t + h) ω)) ω) ∂Q
      = ∫⁻ ω, (g ω * ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0))
        * ENNReal.ofReal (1 - condExp (ℱ t) Q (Y (t + h)) ω) ∂Q := by
    refine lintegral_congr_ae (hcs.mono fun ω hω => ?_)
    simp only [hω]
  rw [step2, ← lintegral_add_left (hG0'.mul (show Measurable fun ω =>
    ENNReal.ofReal (1 - condExp (ℱ t) Q (Y (t + h)) ω)
    from ENNReal.measurable_ofReal.comp (measurable_const.sub hπm)))]
  refine lintegral_mono_ae ?_
  filter_upwards [hS4] with ω ⟨hn, hl1, hHS⟩
  have hb := pt_bound1 hS.1 (hset.p_mem t ω) (hset.q_mem t ω) (hset.lam_mem t ω)
    (hset.c_mem t ω) (hset.lam_zero t ω) hn hl1 hHS
  calc _ = g ω * (ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 0)
        * ENNReal.ofReal (1 - condExp (ℱ t) Q (Y (t + h)) ω)
        + ENNReal.ofReal (Paper.Erep S (p t ω) (q t ω) (lam t ω) 1)
        * ENNReal.ofReal (condExp (ℱ t) Q (Y (t + h)) ω)) := by ring
    _ ≤ g ω * 1 := by gcongr
    _ = g ω := mul_one _

/-- S0.  The case `h = 1`.  Source: l.200-211 (one-step bound, with `T` the conditioning time),
l.214/l.227 ("`(e_t)_{t ≥ 2}` is a non-negative supermartingale"; the index of l.214 is shifted as at
l.227, EDITORIAL), l.227 (optional stopping, Ramdas 2020 Sec. 3: standard proof filled in as in
`P04_S10`: stopped process, one-step bound on `{τ > n}`, Fatou).  `ℋ_S` is `ℋ_{S;c}` with `c ≡ 1`
(l.232).  At `h = 1`, `e_t = ∏_{l=1}^{t-1} E_l(Y_{l+1})` (l.217-218, `I_1 = {1,…,t-1}`). -/
theorem P05_S0 (S : ℝ → ℝ → ℝ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S 1 ℱ Y p q lam τ := by
  intro Q hQ
  have hprob : IsProbabilityMeasure Q := hQ.1.1
  -- `ℋ_S` (l.232): the data with `c ≡ 1` (λ unrestricted) satisfy the setting of l.217
  have hset1 : SeqSetting ℱ Y (fun _ _ => (1 : ℝ)) p q lam :=
    { Y_adapted := hset.Y_adapted, c_adapted := fun _ => measurable_const,
      p_adapted := hset.p_adapted, q_adapted := hset.q_adapted,
      lam_adapted := hset.lam_adapted, Y_mem := hset.Y_mem, c_mem := fun _ _ => Or.inr rfl,
      p_mem := hset.p_mem, q_mem := hset.q_mem, lam_mem := hset.lam_mem,
      lam_zero := fun _ _ h => absurd h one_ne_zero }
  -- the product `∏_{t=1}^{n} E_t(Y_{t+1})` of l.202 (index `s = t - 1`)
  obtain ⟨G, hG⟩ : ∃ G : ℕ → Ω → ℝ, G = fun n ω => ∏ s ∈ Finset.range n,
      Paper.Erep S (p (s + 1) ω) (q (s + 1) ω) (lam (s + 1) ω) (Y (s + 1 + 1) ω) := ⟨_, rfl⟩
  -- l.217-218 at `h = 1`: `e_t = ∏_{l=1}^{t-1} E_l(Y_{l+1}) = G (t-1)`
  have heG : ∀ t ω, eT S 1 Y p q lam t ω = G (t - 1) ω := by
    intro t ω
    simp only [hG, eT, Ik, Nat.cast_one, div_one, one_mul, Finset.Icc_self,
      Finset.sum_singleton, Nat.div_one]
    rw [Finset.prod_image (fun x _ y _ hxy => by simpa using hxy)]
    refine Finset.prod_congr rfl fun s _ => ?_
    rw [Nat.add_comm 1 s]
  -- nonnegativity (l.214 "non-negative"; l.403)
  have hnn : ∀ n ω, 0 ≤ G n ω := fun n ω => by
    simp only [hG]
    exact Finset.prod_nonneg fun s _ => Erep_nonneg hS.1
      (Set.Ioo_subset_Icc_self (hset.p_mem _ ω)) (Set.Ioo_subset_Icc_self (hset.q_mem _ ω))
      (hset.lam_mem _ ω) (hset.Y_mem _ ω)
  -- adaptedness: `G n` is `ℱ_{n+1}`-measurable (each factor `s < n` is `ℱ_{s+2}`-measurable)
  have hGm : ∀ n, Measurable[ℱ (n + 1)] (G n) := fun n => by
    simp only [hG]
    refine Finset.measurable_prod _ fun s hs => ?_
    have hs' := Finset.mem_range.1 hs
    have hle : ℱ (s + 1) ≤ ℱ (s + 1 + 1) := ℱ.mono (Nat.le_succ _)
    have hf := meas_Erep hS.1 ((hset.p_adapted (s + 1)).mono hle le_rfl)
      ((hset.q_adapted (s + 1)).mono hle le_rfl)
      (fun ω => Set.Ioo_subset_Icc_self (hset.p_mem (s + 1) ω))
      (fun ω => Set.Ioo_subset_Icc_self (hset.q_mem (s + 1) ω))
      ((hset.lam_adapted (s + 1)).mono hle le_rfl) (hset.Y_adapted (s + 1 + 1))
      (hset.Y_mem (s + 1 + 1))
    exact hf.mono (ℱ.mono (by omega)) le_rfl
  -- one-step bound (l.200-211), integral form on `A ∈ ℱ_{n+1}`: supermartingale property
  have hone : ∀ n (A : Set Ω), MeasurableSet[ℱ (n + 1)] A →
      ∫⁻ ω in A, ENNReal.ofReal (G (n + 1) ω) ∂Q ≤ ∫⁻ ω in A, ENNReal.ofReal (G n ω) ∂Q := by
    intro n A hA
    have hAm : MeasurableSet A := ℱ.le _ A hA
    have hg : Measurable[ℱ (n + 1)] (A.indicator (fun ω => ENNReal.ofReal (G n ω))) :=
      (ENNReal.measurable_ofReal.comp (hGm n)).indicator hA
    have key := core1 S 1 ℱ Y (fun _ _ => (1 : ℝ)) p q lam hset1 hS Q hQ (n + 1) _ hg
    have hfac : ∀ ω, G (n + 1) ω = G n ω *
        Paper.Erep S (p (n + 1) ω) (q (n + 1) ω) (lam (n + 1) ω) (Y (n + 1 + 1) ω) := by
      intro ω
      simp only [hG]
      exact Finset.prod_range_succ _ _
    rw [← lintegral_indicator hAm, ← lintegral_indicator hAm]
    calc ∫⁻ ω, A.indicator (fun ω => ENNReal.ofReal (G (n + 1) ω)) ω ∂Q
        = ∫⁻ ω, A.indicator (fun ω => ENNReal.ofReal (G n ω)) ω *
            ENNReal.ofReal (Paper.Erep S (p (n + 1) ω) (q (n + 1) ω) (lam (n + 1) ω)
              (Y (n + 1 + 1) ω)) ∂Q := by
          refine lintegral_congr fun ω => ?_
          by_cases hω : ω ∈ A
          · simp only [Set.indicator_of_mem hω]
            rw [hfac ω, ENNReal.ofReal_mul (hnn n ω)]
          · simp [Set.indicator_of_not_mem hω]
      _ ≤ _ := key
  -- optional stopping (l.227), filled in as in `P04_S10`
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
  have hGjoint : Measurable fun x : Ω × ℕ => G x.2 x.1 :=
    measurable_from_prod_countable (f := fun x : Ω × ℕ => G x.2 x.1)
      (fun n => (hGm n).mono (ℱ.le _) le_rfl)
  obtain ⟨F, hF⟩ : ∃ F : ℕ → Ω → ENNReal,
      F = fun n ω => ENNReal.ofReal (G (min (τ ω - 1) n) ω) := ⟨_, rfl⟩
  have hFmeas : ∀ n, Measurable (F n) := fun n => by
    rw [hF]
    have hmin : Measurable fun ω => min (τ ω - 1) n :=
      (measurable_from_top (f := fun k : ℕ => min (k - 1) n)).comp hτm
    have hpair : Measurable fun ω : Ω => (ω, min (τ ω - 1) n) := measurable_id.prodMk hmin
    exact ENNReal.measurable_ofReal.comp (hGjoint.comp hpair)
  have hstep : ∀ n, ∫⁻ ω, F (n + 1) ω ∂Q ≤ ∫⁻ ω, F n ω ∂Q := by
    intro n
    have hB : MeasurableSet[ℱ (n + 1)] {ω | τ ω ≤ n + 1} := hτ.le_meas (n + 1)
    have hBm : MeasurableSet {ω | τ ω ≤ n + 1} := ℱ.le _ _ hB
    rw [← lintegral_add_compl (F (n + 1)) hBm, ← lintegral_add_compl (F n) hBm]
    refine add_le_add (le_of_eq (setLIntegral_congr_fun hBm
      (Filter.Eventually.of_forall fun ω hω => ?_))) ?_
    · have hω' : τ ω ≤ n + 1 := hω
      have e1 : min (τ ω - 1) (n + 1) = τ ω - 1 := by omega
      have e2 : min (τ ω - 1) n = τ ω - 1 := by omega
      simp only [hF, e1, e2]
    · calc ∫⁻ ω in {ω | τ ω ≤ n + 1}ᶜ, F (n + 1) ω ∂Q
          = ∫⁻ ω in {ω | τ ω ≤ n + 1}ᶜ, ENNReal.ofReal (G (n + 1) ω) ∂Q :=
            setLIntegral_congr_fun hBm.compl (Filter.Eventually.of_forall fun ω hω => by
              have hω' : n + 1 < τ ω := not_le.1 hω
              have e1 : min (τ ω - 1) (n + 1) = n + 1 := by omega
              simp only [hF, e1])
        _ ≤ ∫⁻ ω in {ω | τ ω ≤ n + 1}ᶜ, ENNReal.ofReal (G n ω) ∂Q := hone n _ hB.compl
        _ = ∫⁻ ω in {ω | τ ω ≤ n + 1}ᶜ, F n ω ∂Q :=
            setLIntegral_congr_fun hBm.compl (Filter.Eventually.of_forall fun ω hω => by
              have hω' : n + 1 < τ ω := not_le.1 hω
              have e1 : min (τ ω - 1) n = n := by omega
              simp only [hF, e1])
  have hbound : ∀ n, ∫⁻ ω, F n ω ∂Q ≤ 1 := by
    intro n
    induction n with
    | zero => simp [hF, hG]
    | succ n ih => exact (hstep n).trans ih
  have hlim : ∀ ω, Filter.liminf (fun n => F n ω) Filter.atTop
      = ENNReal.ofReal (G (τ ω - 1) ω) := by
    intro ω
    refine Filter.Tendsto.liminf_eq (tendsto_atTop_of_eventually_const (i₀ := τ ω - 1)
      fun n hn => ?_)
    simp only [hF, min_eq_left hn]
  have he : ∀ ω, eT S 1 Y p q lam (τ ω + 1 - 1) ω = G (τ ω - 1) ω := fun ω => by
    rw [heG, Nat.add_sub_cancel]
  simp_rw [he]
  calc ∫⁻ ω, ENNReal.ofReal (G (τ ω - 1) ω) ∂Q
      = ∫⁻ ω, Filter.liminf (fun n => F n ω) Filter.atTop ∂Q := by simp_rw [hlim]
    _ ≤ Filter.liminf (fun n => ∫⁻ ω, F n ω ∂Q) Filter.atTop := lintegral_liminf_le hFmeas
    _ ≤ Filter.limsup (fun n => ∫⁻ ω, F n ω ∂Q) Filter.atTop := Filter.liminf_le_limsup
    _ ≤ 1 := Filter.limsup_le_of_le (h := Filter.Eventually.of_forall hbound)

/-- S1.  (l.452 "Then `e_t = ∑_{k=1}^h M^{[k]}_t / h`".) -/
theorem P05_S1 (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ) (ω : Ω) :
    eT S h Y p q lam t ω = (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k t ω := rfl

/-- S2.  `ℋ_S ⊆ ℋ_{S;c}` for `c_t ∈ {0,1}`. -/
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

/-- S3.  (l.456-459.) -/
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

/-- S4.  (l.459-463.) -/
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

/-- S5.  (l.468.) -/
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

/-- S6.  (silent measurability.) -/
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

/-- S7.  (l.452-456.) -/
theorem P05_S7 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (fk h k (τ ω)) ω) ∂Q ≤ 1 :=
  hP04 hrep hset hS hh Q hQ k hk (fun ω => fk h k (τ ω)) (P05_S4 h hh ℱ k hk τ hτ)

/-- S8.  (l.464-466.) -/
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

/-- Main theorem (l.229-234). -/
theorem P05_main (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S h ℱ Y p q lam τ := by
  rcases Nat.eq_or_lt_of_le hh with h1 | h1
  · subst h1
    exact P05_S0 S ℱ Y c p q lam hset hS τ hτ
  · exact P05_S8 S ν hrep h h1 ℱ Y c p q lam hP04 hset hS τ hτ

end Paper.P05
