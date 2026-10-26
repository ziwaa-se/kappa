import Mathlib

/-!
# One-period results (Theorems 3.1, 3.2, 3.3 of the paper)

Notation.  A forecast of a binary event `Y ∈ {0,1}` is a number in `(0,1)`.
For a pair of forecasts `p, q` and a scoring function `S`, write
`d0 = S(p,0) - S(q,0)`, `d1 = S(p,1) - S(q,1)`.
Under `Y ~ Bernoulli(π)` the expected score difference is `(1-π) d0 + π d1`,
and the expected value of a function `E` of `Y` is `(1-π) E0 + π E1`.
-/

open MeasureTheory Set
open Real (log log_le_sub_one_of_pos log_lt_sub_one_of_pos log_div log_lt_log)

noncomputable section

/-! ## Elementary scores -/

/-- Elementary score `S_θ(p,y) = (θ - y) {1(p > θ) - 1(y > θ)}` (eq. (3)). -/
def Sθ (θ p y : ℝ) : ℝ := (θ - y) * ((if θ < p then 1 else 0) - (if θ < y then 1 else 0))

/-- For `p < q`, `S_θ(p,0) - S_θ(q,0) = -θ 1{p ≤ θ < q}` for every real `θ`. -/
lemma Sθ_diff_zero {p q : ℝ} (hp : 0 ≤ p) (hpq : p < q) (θ : ℝ) :
    Sθ θ p 0 - Sθ θ q 0 = - (Ico p q).indicator (fun t => t) θ := by
  unfold Sθ; simp only [indicator, mem_Ico]
  split_ifs <;> first | ring1 | (exfalso; push_neg at *; linarith) |
    (exfalso; obtain ⟨h1, h2⟩ := ‹p ≤ θ ∧ θ < q›; push_neg at *; linarith) |
    (exfalso; apply ‹¬(p ≤ θ ∧ θ < q)›; push_neg at *; constructor <;> linarith)

/-- For `p < q`, `S_θ(p,1) - S_θ(q,1) = (1-θ) 1{p ≤ θ < q}` for every real `θ`. -/
lemma Sθ_diff_one {p q : ℝ} (hpq : p < q) (hq : q ≤ 1) (θ : ℝ) :
    Sθ θ p 1 - Sθ θ q 1 = (Ico p q).indicator (fun t => 1 - t) θ := by
  unfold Sθ; simp only [indicator, mem_Ico]
  split_ifs <;> first | ring1 | (exfalso; push_neg at *; linarith) |
    (exfalso; obtain ⟨h1, h2⟩ := ‹p ≤ θ ∧ θ < q›; push_neg at *; linarith) |
    (exfalso; apply ‹¬(p ≤ θ ∧ θ < q)›; push_neg at *; constructor <;> linarith)

/-! ## Mixtures: signs of the score differences and the boundary `κ_ν`

For a mixing measure `ν` we work directly with the integrated *differences*
`d(y) = ∫ {S_θ(p,y) - S_θ(q,y)} dν(θ)` (this avoids `∞ - ∞` when `S` is unbounded). -/

section Mixture
variable (ν : Measure ℝ) {p q : ℝ}

/-- `d(0) = -∫_{[p,q)} θ dν` and `d(1) = ∫_{[p,q)} (1-θ) dν` for `p < q`. -/
lemma d_zero_eq (hp : 0 ≤ p) (hpq : p < q) :
    ∫ θ, (Sθ θ p 0 - Sθ θ q 0) ∂ν = - ∫ θ in Ico p q, θ ∂ν := by
  simp_rw [Sθ_diff_zero hp hpq]
  rw [integral_neg, integral_indicator measurableSet_Ico]

lemma d_one_eq (hpq : p < q) (hq : q ≤ 1) :
    ∫ θ, (Sθ θ p 1 - Sθ θ q 1) ∂ν = ∫ θ in Ico p q, (1 - θ) ∂ν := by
  simp_rw [Sθ_diff_one hpq hq]
  rw [integral_indicator measurableSet_Ico]

lemma integrableOn_Ico_of_bdd (hfin : ν (Ico p q) ≠ ⊤) {f : ℝ → ℝ} (hf : Continuous f) :
    IntegrableOn f (Ico p q) ν := by
  obtain ⟨C, hC⟩ := (isCompact_Icc (a := p) (b := q)).exists_bound_of_continuousOn
    hf.continuousOn
  refine Measure.integrableOn_of_bounded (M := C) hfin hf.aestronglyMeasurable ?_
  filter_upwards [ae_restrict_mem measurableSet_Ico] with x hx
  exact hC x ⟨hx.1, hx.2.le⟩

/-- Under the assumption of Theorem 3.1 (`0 < p < q < 1`, `0 < ν[p,q) < ∞`),
`d(0) < 0 < d(1)`. -/
lemma d_signs (hp : 0 < p) (hpq : p < q) (hq : q < 1)
    (hpos : 0 < ν (Ico p q)) (hfin : ν (Ico p q) ≠ ⊤) :
    ∫ θ, (Sθ θ p 0 - Sθ θ q 0) ∂ν < 0 ∧ 0 < ∫ θ, (Sθ θ p 1 - Sθ θ q 1) ∂ν := by
  have hr : 0 < ν.real (Ico p q) := ENNReal.toReal_pos hpos.ne' hfin
  rw [d_zero_eq ν hp.le hpq, d_one_eq ν hpq hq.le]
  constructor
  · have := setIntegral_ge_of_const_le (c := p) measurableSet_Ico hfin
      (fun x hx => hx.1) (integrableOn_Ico_of_bdd ν hfin continuous_id)
    nlinarith
  · have := setIntegral_ge_of_const_le (c := 1 - q) (f := fun x => 1 - x) measurableSet_Ico hfin
      (fun x hx => show 1 - q ≤ 1 - x by linarith [hx.2])
      (integrableOn_Ico_of_bdd ν hfin (by fun_prop))
    nlinarith

/-- The boundary `-d0/(d1-d0)` of `H_S` equals `κ_ν[p,q) = ∫_{[p,q)} θ dν / ν[p,q)`. -/
lemma boundary_eq_kappa (hp : 0 ≤ p) (hpq : p < q) (hq : q ≤ 1) (hfin : ν (Ico p q) ≠ ⊤)
    {d0 d1 : ℝ} (hd0 : d0 = ∫ θ, (Sθ θ p 0 - Sθ θ q 0) ∂ν)
    (hd1 : d1 = ∫ θ, (Sθ θ p 1 - Sθ θ q 1) ∂ν) :
    -d0 / (d1 - d0) = (∫ θ in Ico p q, θ ∂ν) / (ν (Ico p q)).toReal := by
  have h1 : d1 - d0 = (ν (Ico p q)).toReal := by
    rw [hd0, hd1, d_zero_eq ν hp hpq, d_one_eq ν hpq hq]
    rw [sub_neg_eq_add, ← integral_add
      (integrableOn_Ico_of_bdd ν hfin (f := fun θ => 1 - θ) (by fun_prop))
      (integrableOn_Ico_of_bdd ν hfin (f := fun θ => θ) continuous_id)]
    simp [Measure.real]
  rw [h1, hd0, d_zero_eq ν hp hpq, neg_neg]

end Mixture

/-! ## Theorem 3.1: characterisation of the e-values -/

/-- `E = (E0, E1)` is an e-value with null hypothesis `H_S` and alternative `[0,1] \ H_S`. -/
def IsEvalNullAlt (d0 d1 E0 E1 : ℝ) : Prop :=
  0 ≤ E0 ∧ 0 ≤ E1 ∧
    ∀ π ∈ Icc (0:ℝ) 1, ((1 - π) * E0 + π * E1 ≤ 1 ↔ (1 - π) * d0 + π * d1 ≤ 0)

/-- **Theorem 3.1** (case `p < q`, i.e. `d0 < 0 < d1`). -/
theorem thm_uniqueness {d0 d1 : ℝ} (h0 : d0 < 0) (h1 : 0 < d1) (E0 E1 : ℝ) :
    IsEvalNullAlt d0 d1 E0 E1 ↔
      ∃ l ∈ Ioc (0:ℝ) 1, E0 = 1 - l ∧ E1 = 1 + l * d1 / |d0| := by
  rw [abs_of_neg h0]
  constructor
  · rintro ⟨hE0, hE1, hH⟩
    set π0 := -d0 / (d1 - d0) with hπ0
    have hden : 0 < d1 - d0 := by linarith
    have hπ0pos : 0 < π0 := div_pos (by linarith) hden
    have hπ0lt : π0 < 1 := by rw [div_lt_one hden]; linarith
    have hf0 : (1 - π0) * d0 + π0 * d1 = 0 := by
      rw [hπ0]; field_simp; ring
    -- value at π = 1 and π = 0
    have hg1 : 1 < E1 := by
      have := (hH 1 ⟨zero_le_one, le_rfl⟩).not.mpr (by simp; linarith)
      simpa using this
    have hg0 : E0 ≤ 1 := by
      have := (hH 0 ⟨le_rfl, zero_le_one⟩).mpr (by simp; linarith)
      simpa using this
    have hle : (1 - π0) * E0 + π0 * E1 ≤ 1 := (hH π0 ⟨hπ0pos.le, hπ0lt.le⟩).mpr hf0.le
    -- the linear function exceeds 1 to the right of π0, so it equals 1 at π0
    have hge : 1 ≤ (1 - π0) * E0 + π0 * E1 := by
      by_contra hcon
      push_neg at hcon
      set g := (1 - π0) * E0 + π0 * E1
      set δ := min (1 - π0) ((1 - g) / (2 * (|E1 - E0| + 1))) with hδ
      have hδpos : 0 < δ := lt_min (by linarith)
        (div_pos (by linarith) (by positivity))
      have hδ1 : δ ≤ 1 - π0 := min_le_left _ _
      have hδ2 : δ ≤ (1 - g) / (2 * (|E1 - E0| + 1)) := min_le_right _ _
      have hπ : π0 + δ ∈ Icc (0:ℝ) 1 := ⟨by linarith, by linarith⟩
      have hfpos : ¬ ((1 - (π0 + δ)) * d0 + (π0 + δ) * d1 ≤ 0) := by
        push_neg; nlinarith
      apply hfpos
      apply (hH _ hπ).mp
      have hlin : (1 - (π0 + δ)) * E0 + (π0 + δ) * E1 = g + δ * (E1 - E0) := by ring
      rw [hlin]
      have hab : δ * (E1 - E0) ≤ δ * (|E1 - E0| + 1) :=
        mul_le_mul_of_nonneg_left (by linarith [le_abs_self (E1 - E0)]) hδpos.le
      have : δ * (|E1 - E0| + 1) ≤ (1 - g) / 2 := by
        have := mul_le_mul_of_nonneg_right hδ2 (by positivity : (0:ℝ) ≤ |E1 - E0| + 1)
        rwa [div_mul_eq_mul_div, mul_comm 2, ← div_div, mul_div_assoc, div_self (by positivity),
          mul_one] at this
      linarith
    have heq : (1 - π0) * E0 + π0 * E1 = 1 := le_antisymm hle hge
    have hE0lt : E0 < 1 := by
      rcases hg0.lt_or_eq with h | h
      · exact h
      · exfalso; rw [h] at heq; nlinarith
    refine ⟨1 - E0, ⟨by linarith, by linarith⟩, by ring, ?_⟩
    have hd0 : d0 ≠ 0 := h0.ne
    have hnd : -d0 ≠ 0 := neg_ne_zero.mpr hd0
    have heq' : d1 * E0 - d0 * E1 = d1 - d0 := by
      rw [hπ0] at heq
      have : (1 - -d0 / (d1 - d0)) = d1 / (d1 - d0) := by field_simp; try ring
      rw [this] at heq
      field_simp at heq
      linarith
    have key : (1 - E0) * d1 / -d0 = E1 - 1 := by
      rw [div_eq_iff hnd]; linear_combination (-1 : ℝ) * heq'
    linarith
  · rintro ⟨l, ⟨hl0, hl1⟩, rfl, rfl⟩
    have hnd : -d0 ≠ 0 := neg_ne_zero.mpr h0.ne
    refine ⟨by linarith, ?_, ?_⟩
    · have : 0 ≤ l * d1 / -d0 := div_nonneg (by positivity) (by linarith)
      linarith
    · intro π _
      have hd0' : d0 ≠ 0 := h0.ne
      have key : (1 - π) * (1 - l) + π * (1 + l * d1 / -d0) - 1
          = l / -d0 * ((1 - π) * d0 + π * d1) := by
        rw [div_neg, div_neg]; field_simp; ring
      have hc : 0 < l / -d0 := div_pos hl0 (by linarith)
      constructor
      · intro h
        have : l / -d0 * ((1 - π) * d0 + π * d1) ≤ 0 := by linarith
        rcases le_or_lt ((1 - π) * d0 + π * d1) 0 with hneg | hpos
        · exact hneg
        · nlinarith [mul_pos hc hpos]
      · intro h
        have : l / -d0 * ((1 - π) * d0 + π * d1) ≤ 0 :=
          mul_nonpos_of_nonneg_of_nonpos hc.le h
        linarith

/-- Reflection `y ↦ 1 - y`, `π ↦ 1 - π` turns the case `p > q` into the case `p < q`. -/
lemma isEvalNullAlt_swap (d0 d1 E0 E1 : ℝ) :
    IsEvalNullAlt d0 d1 E0 E1 ↔ IsEvalNullAlt d1 d0 E1 E0 := by
  unfold IsEvalNullAlt
  constructor <;>
  · rintro ⟨a, b, h⟩
    refine ⟨b, a, fun π hπ => ?_⟩
    have := h (1 - π) ⟨by linarith [hπ.2], by linarith [hπ.1]⟩
    simp only [sub_sub_cancel] at this
    rw [add_comm ((1-π) * _), add_comm ((1-π) * _)]; exact this

/-- **Theorem 3.1** (case `p > q`, i.e. `d1 < 0 < d0`): now the denominator is `|d1|`. -/
theorem thm_uniqueness' {d0 d1 : ℝ} (h1 : d1 < 0) (h0 : 0 < d0) (E0 E1 : ℝ) :
    IsEvalNullAlt d0 d1 E0 E1 ↔
      ∃ l ∈ Ioc (0:ℝ) 1, E1 = 1 - l ∧ E0 = 1 + l * d0 / |d1| := by
  rw [isEvalNullAlt_swap]; exact thm_uniqueness h1 h0 E1 E0

/-! ## Theorem 3.2: the GROW e-value within the family `E_{p,q;λ}` (case `p < q`) -/

/-- Expected log-growth of `E_{p,q;λ}` under `π1`, with `h = d1/d0 < 0`:
`E(0) = 1 - λ`, `E(1) = 1 - λ h`. -/
def growth (π1 h l : ℝ) : ℝ := (1 - π1) * log (1 - l) + π1 * log (1 - l * h)

/-- **Theorem 3.2** (case `p < q`, `π1 < 1`).  `λ0 = π1 + (1-π1) d0/d1` lies in `(0,1)` and is
the unique maximiser of the growth rate over `λ ∈ [0,1)` (for `λ = 1` the growth rate is `-∞`).
The resulting e-value is `E(0) = (1-π1)/(1-κ)`, `E(1) = π1/κ`, with `κ = -d0/(d1-d0)`. -/
theorem thm_grow {d0 d1 π1 : ℝ} (h0 : d0 < 0) (h1 : 0 < d1)
    (halt : 0 < (1 - π1) * d0 + π1 * d1) (hπ1 : π1 < 1) :
    let h := d1 / d0
    let l0 := π1 + (1 - π1) * (d0 / d1)
    let κ := -d0 / (d1 - d0)
    l0 ∈ Ioo (0:ℝ) 1 ∧
    (∀ l ∈ Ico (0:ℝ) 1, growth π1 h l ≤ growth π1 h l0) ∧
    (∀ l ∈ Ico (0:ℝ) 1, growth π1 h l = growth π1 h l0 → l = l0) ∧
    1 - l0 = (1 - π1) / (1 - κ) ∧ 1 - l0 * h = π1 / κ := by
  intro h l0 κ
  have hd0 : d0 ≠ 0 := h0.ne
  have hd1 : d1 ≠ 0 := h1.ne'
  have hπ1pos : 0 < π1 := by
    by_contra hc; push_neg at hc; nlinarith
  have hl0pos : 0 < l0 := by
    have : l0 = ((1 - π1) * d0 + π1 * d1) / d1 := by simp only [l0]; field_simp; ring
    rw [this]; positivity
  have hl0lt : l0 < 1 := by
    have : (1 - π1) * (d0 / d1) < 0 :=
      mul_neg_of_pos_of_neg (by linarith) (div_neg_of_neg_of_pos h0 h1)
    simp only [l0]; linarith
  -- a0 = 1 - l0 and b0 = 1 - l0 h
  have ha0 : 1 - l0 = (1 - π1) * (d1 - d0) / d1 := by simp only [l0]; field_simp; ring
  have hb0 : 1 - l0 * h = π1 * (d0 - d1) / d0 := by simp only [l0, h]; field_simp; ring
  have ha0pos : 0 < 1 - l0 := by linarith
  have hb0pos : 0 < 1 - l0 * h := by
    rw [hb0]; exact div_pos_of_neg_of_neg (by nlinarith) h0
  -- Gibbs-type identity
  have gibbs : ∀ l, (1 - π1) * ((1 - l) / (1 - l0)) + π1 * ((1 - l * h) / (1 - l0 * h)) = 1 := by
    intro l
    rw [ha0, hb0]
    have : (1 - π1) ≠ 0 := by linarith
    have : d1 - d0 ≠ 0 := by linarith
    have : d0 - d1 ≠ 0 := by linarith
    simp only [h]; field_simp; ring
  have hbpos : ∀ l ∈ Ico (0:ℝ) 1, 0 < 1 - l * h := by
    intro l hl
    have : l * h ≤ 0 := mul_nonpos_of_nonneg_of_nonpos hl.1 (div_nonpos_of_nonneg_of_nonpos
      h1.le h0.le |>.trans_eq' rfl)
    simp only [h] at this ⊢; linarith
  have diff : ∀ l ∈ Ico (0:ℝ) 1, growth π1 h l - growth π1 h l0 =
      (1 - π1) * log ((1 - l) / (1 - l0)) + π1 * log ((1 - l * h) / (1 - l0 * h)) := by
    intro l hl
    have ha : 0 < 1 - l := by linarith [hl.2]
    rw [log_div ha.ne' ha0pos.ne', log_div (hbpos l hl).ne' hb0pos.ne']
    simp only [growth]; ring
  refine ⟨⟨hl0pos, hl0lt⟩, ?_, ?_, ?_, ?_⟩
  · intro l hl
    have ha : 0 < 1 - l := by linarith [hl.2]
    have e1 := log_le_sub_one_of_pos (div_pos ha ha0pos)
    have e2 := log_le_sub_one_of_pos (div_pos (hbpos l hl) hb0pos)
    have := diff l hl
    have := gibbs l
    nlinarith [mul_le_mul_of_nonneg_left e1 (by linarith : (0:ℝ) ≤ 1 - π1),
      mul_le_mul_of_nonneg_left e2 hπ1pos.le]
  · intro l hl heq
    by_contra hne
    have ha : 0 < 1 - l := by linarith [hl.2]
    have hne' : (1 - l) / (1 - l0) ≠ 1 := by
      intro hc; rw [div_eq_one_iff_eq ha0pos.ne'] at hc; exact hne (by linarith)
    have e1 := log_lt_sub_one_of_pos (div_pos ha ha0pos) hne'
    have e2 := log_le_sub_one_of_pos (div_pos (hbpos l hl) hb0pos)
    have := diff l hl
    have := gibbs l
    nlinarith [mul_lt_mul_of_pos_left e1 (by linarith : (0:ℝ) < 1 - π1),
      mul_le_mul_of_nonneg_left e2 hπ1pos.le]
  · have hne : d1 - d0 ≠ 0 := by linarith
    have hk1 : 1 - κ = d1 / (d1 - d0) := by simp only [κ]; field_simp; try ring
    rw [ha0, hk1, div_div_eq_mul_div]
  · have hne : d1 - d0 ≠ 0 := by linarith
    rw [hb0]; simp only [κ]
    rw [div_div_eq_mul_div, div_eq_div_iff hd0 (neg_ne_zero.mpr hd0)]; ring

/-- Theorem 3.2, boundary case `π1 = 1`: then `λ0 = 1` and the growth rate `log(1 - λ h)` is
strictly increasing, so `λ = 1` is the unique maximiser (the proof's claim
`lim_{λ→1} g(λ) = -∞` is false in this case, but the statement survives). -/
theorem thm_grow_one {d0 d1 : ℝ} (h0 : d0 < 0) (h1 : 0 < d1) :
    (1 : ℝ) + (1 - 1) * (d0 / d1) = 1 ∧
    ∀ l ∈ Icc (0:ℝ) 1, l < 1 → log (1 - l * (d1 / d0)) < log (1 - 1 * (d1 / d0)) := by
  refine ⟨by ring, fun l hl hl1 => ?_⟩
  have hh : d1 / d0 < 0 := div_neg_of_pos_of_neg h1 h0
  apply log_lt_log
  · nlinarith [hl.1]
  · nlinarith

/-! ## Theorem 3.3: dominance for all elementary scores -/

/-- Expected elementary-score difference under `π`. -/
def elemDiff (θ p q π : ℝ) : ℝ := (1 - π) * (Sθ θ p 0 - Sθ θ q 0) + π * (Sθ θ p 1 - Sθ θ q 1)

/-- For `0 ≤ p < q ≤ 1`, `H = [0,p]`. -/
theorem H_eq_lt {p q π : ℝ} (hp : 0 ≤ p) (hpq : p < q) (hq : q ≤ 1) :
    (∀ θ ∈ Icc (0:ℝ) 1, elemDiff θ p q π ≤ 0) ↔ π ≤ p := by
  have key : ∀ θ, elemDiff θ p q π = (Ico p q).indicator (fun t => π - t) θ := by
    intro θ; simp only [elemDiff, Sθ_diff_zero hp hpq, Sθ_diff_one hpq hq, indicator]
    split_ifs <;> ring
  simp_rw [key]
  constructor
  · intro h
    have h' := h p ⟨hp, by linarith⟩
    simp [indicator, hpq] at h'; linarith
  · intro h θ _
    simp only [indicator]; split_ifs with hθ
    · linarith [hθ.1]
    · exact le_rfl

/-- For `0 ≤ q < p ≤ 1`, `H = [p,1]` (the supremum over `θ ∈ [q,p)` is not attained). -/
theorem H_eq_gt {p q π : ℝ} (hq : 0 ≤ q) (hqp : q < p) (hp : p ≤ 1) :
    (∀ θ ∈ Icc (0:ℝ) 1, elemDiff θ p q π ≤ 0) ↔ p ≤ π := by
  have key : ∀ θ, elemDiff θ p q π = (Ico q p).indicator (fun t => t - π) θ := by
    intro θ
    have e0 := Sθ_diff_zero hq hqp θ
    have e1 := Sθ_diff_one hqp hp θ
    simp only [elemDiff, indicator] at *
    split_ifs at * <;> linear_combination (π - 1) * e0 - π * e1
  simp_rw [key]
  constructor
  · intro h
    by_contra! hc
    set θ := max q ((π + p) / 2)
    have hθ1 : q ≤ θ := le_max_left _ _
    have hθ2 : θ < p := max_lt hqp (by linarith)
    have hθ3 : π < θ := lt_of_lt_of_le (by linarith) (le_max_right _ _)
    have h' := h θ ⟨by linarith, by linarith⟩
    simp [indicator, hθ1, hθ2] at h'; linarith
  · intro h θ _
    simp only [indicator]; split_ifs with hθ
    · linarith [hθ.2]
    · exact le_rfl

/-- The likelihood ratio `E*` of Theorem 3.3 (case `p < q`) has null `H = [0,p]` and
alternative `(p,1]`. -/
theorem Estar_valid {p π1 : ℝ} (hp0 : 0 < p) (hp1 : p < 1) (hπ1 : p < π1) (π : ℝ) :
    ((1 - π) * ((1 - π1) / (1 - p)) + π * (π1 / p) ≤ 1 ↔ π ≤ p) := by
  have h1p : 0 < 1 - p := by linarith
  have key : (1 - π) * ((1 - π1) / (1 - p)) + π * (π1 / p) - 1
      = (π - p) * (π1 - p) / (p * (1 - p)) := by field_simp; ring
  constructor
  · intro h
    by_contra hcon; push_neg at hcon
    have : 0 < (π - p) * (π1 - p) / (p * (1 - p)) := by
      apply div_pos <;> nlinarith
    linarith
  · intro h
    have : (π - p) * (π1 - p) / (p * (1 - p)) ≤ 0 := by
      apply div_nonpos_of_nonpos_of_nonneg <;> nlinarith
    linarith

/-- **Theorem 3.3** (case `p < q`, `p < π1 < 1`): among *all* e-values `(E0,E1)` for `H = [0,p]`
(only validity at `π = p` is used), `E*` maximises the growth rate, uniquely.
(`E0, E1 > 0` is assumed only because Lean's `log 0 = 0`; a zero value gives growth `-∞`.) -/
theorem thm_allscores {p π1 E0 E1 : ℝ} (hp0 : 0 < p) (hp1 : p < 1) (hπ1 : p < π1)
    (hπ1' : π1 < 1) (hE0 : 0 < E0) (hE1 : 0 < E1)
    (hvalid : (1 - p) * E0 + p * E1 ≤ 1) :
    (1 - π1) * log E0 + π1 * log E1 ≤
      (1 - π1) * log ((1 - π1) / (1 - p)) + π1 * log (π1 / p) ∧
    ((1 - π1) * log E0 + π1 * log E1 =
      (1 - π1) * log ((1 - π1) / (1 - p)) + π1 * log (π1 / p) →
      E0 = (1 - π1) / (1 - p) ∧ E1 = π1 / p) := by
  have ha : 0 < (1 - π1) / (1 - p) := div_pos (by linarith) (by linarith)
  have hb : 0 < π1 / p := div_pos (by linarith) hp0
  have hπpos : 0 < π1 := by linarith
  have h1π : 0 < 1 - π1 := by linarith
  have diff : (1 - π1) * log E0 + π1 * log E1 -
      ((1 - π1) * log ((1 - π1) / (1 - p)) + π1 * log (π1 / p)) =
      (1 - π1) * log (E0 / ((1 - π1) / (1 - p))) + π1 * log (E1 / (π1 / p)) := by
    rw [log_div hE0.ne' ha.ne', log_div hE1.ne' hb.ne']; ring
  have gibbs : (1 - π1) * (E0 / ((1 - π1) / (1 - p))) + π1 * (E1 / (π1 / p)) =
      (1 - p) * E0 + p * E1 := by
    field_simp; ring
  have e1 := log_le_sub_one_of_pos (div_pos hE0 ha)
  have e2 := log_le_sub_one_of_pos (div_pos hE1 hb)
  constructor
  · nlinarith [mul_le_mul_of_nonneg_left e1 h1π.le, mul_le_mul_of_nonneg_left e2 hπpos.le]
  · intro heq
    have hA : E0 / ((1 - π1) / (1 - p)) = 1 := by
      by_contra hne
      have := log_lt_sub_one_of_pos (div_pos hE0 ha) hne
      nlinarith [mul_lt_mul_of_pos_left this h1π, mul_le_mul_of_nonneg_left e2 hπpos.le]
    have hB : E1 / (π1 / p) = 1 := by
      by_contra hne
      have := log_lt_sub_one_of_pos (div_pos hE1 hb) hne
      nlinarith [mul_lt_mul_of_pos_left this hπpos, mul_le_mul_of_nonneg_left e1 h1π.le]
    exact ⟨(div_eq_one_iff_eq ha.ne').mp hA, (div_eq_one_iff_eq hb.ne').mp hB⟩

end
