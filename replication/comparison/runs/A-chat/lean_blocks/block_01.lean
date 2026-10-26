import Mathlib

namespace EProb

/-! ## Theorem 3.3: elementary scores and the null set `H = [0,p]` (case p < q) -/

noncomputable def Sθ (θ p y : ℝ) : ℝ :=
  (θ - y) * ((if θ < p then 1 else 0) - (if θ < y then 1 else 0))

/-- expected elementary score when `P(Y=1) = r` -/
noncomputable def ESθ (θ p r : ℝ) : ℝ := (1 - r) * Sθ θ p 0 + r * Sθ θ p 1

theorem nullH_of_lt {p q r : ℝ} (hp0 : 0 < p) (hpq : p < q) (hq1 : q < 1) :
    (∀ θ, 0 ≤ θ → θ ≤ 1 → ESθ θ p r ≤ ESθ θ q r) ↔ r ≤ p := by
  have hp1 : p < 1 := hpq.trans hq1
  constructor
  · intro h
    have h' := h p hp0.le hp1.le
    simp [ESθ, Sθ, hpq, hp1, not_lt.mpr hp0.le] at h'
    nlinarith
  · intro hr θ hθ0 hθ1
    simp only [ESθ, Sθ]
    split_ifs <;> nlinarith

/-! ## Reduction (p < q): A = ∫_{[p,q)} θ dν, N = ν[p,q), d(0) = -A, d(1) = N - A -/

theorem reduction {A N r : ℝ} (hA : 0 < A) (hAN : A < N) :
    ((1 - r) * (-A) + r * (N - A) ≤ 0 ↔ r ≤ A / N) ∧
    (N - A) / |(-A)| = (1 - A / N) / (A / N) ∧
    -- the paper's λ for p<q equals (r - κ)/(1 - κ)
    r + (1 - r) * ((-A) / (N - A)) = (r - A / N) / (1 - A / N) := by
  have hN : 0 < N := hA.trans hAN
  have hA' : A ≠ 0 := hA.ne'
  have hN' : N ≠ 0 := hN.ne'
  have hNA : N - A ≠ 0 := (sub_pos.mpr hAN).ne'
  refine ⟨?_, ?_, ?_⟩
  · rw [le_div_iff₀ hN]
    constructor <;> intro h <;> nlinarith
  · rw [abs_neg, abs_of_pos hA]
    field_simp <;> ring
  · field_simp <;> ring

/-! ## Theorem 3.1 (after reduction, boundary κ ∈ (0,1)) -/

theorem thm31 {κ E0 E1 : ℝ} (hκ0 : 0 < κ) (hκ1 : κ < 1) (hE0 : 0 ≤ E0) (hE1 : 0 ≤ E1) :
    (∀ r : ℝ, 0 ≤ r → r ≤ 1 → ((1 - r) * E0 + r * E1 ≤ 1 ↔ r ≤ κ)) ↔
    ∃ l : ℝ, 0 < l ∧ l ≤ 1 ∧ E0 = 1 - l ∧ E1 = 1 + l * (1 - κ) / κ := by
  constructor
  · intro h
    have hk : (1 - κ) * E0 + κ * E1 ≤ 1 := (h κ hκ0.le hκ1.le).mpr le_rfl
    have h1 : 1 < E1 := by
      by_contra hc
      push_neg at hc
      have := (h 1 zero_le_one le_rfl).mp (by linarith)
      linarith
    -- the boundary is attained with equality (the step missing in the paper)
    have heq : (1 - κ) * E0 + κ * E1 = 1 := by
      by_contra hne
      obtain ⟨g, hg⟩ : ∃ g : ℝ, g = (1 - κ) * E0 + κ * E1 := ⟨_, rfl⟩
      rw [← hg] at hk hne
      have hlt : g < 1 := lt_of_le_of_ne hk hne
      have hden : 0 < E1 - g := by linarith
      obtain ⟨t, ht⟩ : ∃ t : ℝ, t = (1 - g) / (2 * (E1 - g)) := ⟨_, rfl⟩
      have ht0 : 0 < t := by rw [ht]; exact div_pos (by linarith) (by linarith)
      have htg : t * (E1 - g) = (1 - g) / 2 := by
        rw [ht, div_mul_eq_mul_div,
          div_eq_div_iff (mul_pos two_pos hden).ne' two_ne_zero]
        ring
      have ht1 : t < 1 := by
        by_contra hc
        push_neg at hc
        nlinarith [mul_nonneg (sub_nonneg.mpr hc) hden.le]
      have hval : (1 - (κ + t * (1 - κ))) * E0 + (κ + t * (1 - κ)) * E1
          = g + (1 - g) / 2 := by
        linear_combination htg + (t - 1) * hg
      have hle := (h (κ + t * (1 - κ))
        (by nlinarith [mul_pos ht0 (sub_pos.mpr hκ1)])
        (by nlinarith [mul_pos (sub_pos.mpr ht1) (sub_pos.mpr hκ1)])).mp
        (by linarith [hval])
      nlinarith [mul_pos ht0 (sub_pos.mpr hκ1)]
    have hE0lt : E0 < 1 := by
      by_contra hc
      push_neg at hc
      nlinarith [mul_le_mul_of_nonneg_left hc (sub_pos.mpr hκ1).le,
        mul_lt_mul_of_pos_left h1 hκ0]
    -- note E0 = 0 (λ = 1) is allowed: the paper's "E(0) ∈ (0,1)" is wrong
    refine ⟨1 - E0, by linarith, by linarith, by ring, ?_⟩
    have hfrac : (1 - E0) * (1 - κ) / κ = E1 - 1 := by
      rw [div_eq_iff hκ0.ne']
      linear_combination (-1 : ℝ) * heq
    linarith
  · rintro ⟨l, hl0, hl1, rfl, rfl⟩ r hr0 hr1
    have hκ' : κ ≠ 0 := hκ0.ne'
    have key : κ * ((1 - r) * (1 - l) + r * (1 + l * (1 - κ) / κ) - 1) = l * (r - κ) := by
      field_simp <;> ring
    constructor
    · intro h
      by_contra hc
      push_neg at hc
      nlinarith [mul_pos hl0 (sub_pos.mpr hc), mul_nonneg hκ0.le (sub_nonneg.mpr h)]
    · intro h
      by_contra hc
      push_neg at hc
      nlinarith [mul_pos hκ0 (sub_pos.mpr hc), mul_nonneg hl0.le (sub_nonneg.mpr h)]

/-! ## Theorems 3.2 / 3.3: growth-rate optimality via Gibbs' inequality.
Any valid E satisfies (1-κ)E(0) + κE(1) ≤ 1 (validity at r = κ; κ = p for Thm 3.3). -/

theorem grow {κ r E0 E1 : ℝ} (hκ0 : 0 < κ) (hκ1 : κ < 1) (hr0 : 0 < r) (hr1 : r < 1)
    (hE0 : 0 < E0) (hE1 : 0 < E1) (hval : (1 - κ) * E0 + κ * E1 ≤ 1) :
    (1 - r) * Real.log E0 + r * Real.log E1 ≤
      (1 - r) * Real.log ((1 - r) / (1 - κ)) + r * Real.log (r / κ) := by
  have hr' : (1 : ℝ) - r ≠ 0 := (sub_pos.mpr hr1).ne'
  have hκ' : (1 : ℝ) - κ ≠ 0 := (sub_pos.mpr hκ1).ne'
  have hκ'' : κ ≠ 0 := hκ0.ne'
  have hr'' : r ≠ 0 := hr0.ne'
  have ha : 0 < (1 - r) / (1 - κ) := div_pos (sub_pos.mpr hr1) (sub_pos.mpr hκ1)
  have hb : 0 < r / κ := div_pos hr0 hκ0
  have h1 := Real.log_le_sub_one_of_pos (div_pos hE0 ha)
  have h2 := Real.log_le_sub_one_of_pos (div_pos hE1 hb)
  rw [Real.log_div hE0.ne' ha.ne'] at h1
  rw [Real.log_div hE1.ne' hb.ne'] at h2
  have e1 : (1 - r) * (E0 / ((1 - r) / (1 - κ)) - 1) = (1 - κ) * E0 - (1 - r) := by
    field_simp <;> ring
  have e2 : r * (E1 / (r / κ) - 1) = κ * E1 - r := by
    field_simp <;> ring
  nlinarith [mul_le_mul_of_nonneg_left h1 (sub_pos.mpr hr1).le,
    mul_le_mul_of_nonneg_left h2 hr0.le]

/-- the optimiser E* = ((1-r)/(1-κ), r/κ) lies in the family of Thm 3.1 with λ = (r-κ)/(1-κ) -/
theorem grow_in_family {κ r : ℝ} (hκ0 : 0 < κ) (hκ1 : κ < 1) :
    (1 - r) / (1 - κ) = 1 - (r - κ) / (1 - κ) ∧
    r / κ = 1 + (r - κ) / (1 - κ) * (1 - κ) / κ := by
  have h1 : (1 : ℝ) - κ ≠ 0 := (sub_pos.mpr hκ1).ne'
  have h2 : κ ≠ 0 := hκ0.ne'
  constructor <;> field_simp <;> ring

/-! ## Counterexample to Proposition 3.5 (h = 2)
Brier, p ≡ 1/4, q ≡ 3/4, λ ≡ 1; Y₃ ~ Bern(1/2), Y₄ = Y₃; τ = 3 + Y₃. -/

noncomputable def brier (p y : ℝ) : ℝ := (p - y) ^ 2
noncomputable def dC (y : ℝ) : ℝ := brier (1/4) y - brier (3/4) y
noncomputable def EC (y : ℝ) : ℝ := 1 + 1 * dC y / |dC 0|   -- eq. (3.1), p < q, λ = 1

lemma dC0 : dC 0 = -1/2 := by norm_num [dC, brier]
lemma dC1 : dC 1 = 1/2 := by norm_num [dC, brier]
lemma EC0 : EC 0 = 0 := by
  rw [EC, dC0, abs_of_neg (by norm_num : (-1/2 : ℝ) < 0)]; norm_num
lemma EC1 : EC 1 = 2 := by
  rw [EC, dC1, dC0, abs_of_neg (by norm_num : (-1/2 : ℝ) < 0)]; norm_num

/-- the null holds: conditional probability 1/2 = κ gives zero expected score difference -/
lemma null_ok : (1/2 : ℝ) * dC 0 + (1/2) * dC 1 = 0 := by rw [dC0, dC1]; norm_num

/-- fixed times are fine: E[e₃] = E[e₄] = 1 -/
lemma fixed_ok :
    (1/2 : ℝ) * ((EC 1 + 1) / 2) + (1/2) * ((EC 0 + 1) / 2) = 1 ∧
    (1/2 : ℝ) * ((EC 1 + EC 1) / 2) + (1/2) * ((EC 0 + EC 0) / 2) = 1 := by
  rw [EC0, EC1]; norm_num

/-- but E[e_τ] = 5/4 > 1 -/
theorem prop35_false :
    (1/2 : ℝ) * ((EC 1 + EC 1) / 2) + (1/2) * ((EC 0 + 1) / 2) = 5/4 := by
  rw [EC0, EC1]; norm_num

end EProb
