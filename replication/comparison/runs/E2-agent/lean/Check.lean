import Mathlib

open Finset

/-- Definition 1.1: `V_n(p) = p(1-p)/n`. -/
noncomputable def V (n : ℕ) (p : ℝ) : ℝ := p * (1 - p) / n

/-- Definition 1.2: sample mean and sample variance of `u : Fin m → ℝ`. -/
noncomputable def mean {m : ℕ} (u : Fin m → ℝ) : ℝ := (∑ i, u i) / m
noncomputable def svar {m : ℕ} (u : Fin m → ℝ) : ℝ :=
  (∑ i, (u i - mean u) ^ 2) / (m - 1)

/-! ## Lemma 2.1 — true -/
theorem lem_quarter_identity (p : ℝ) : p * (1 - p) = 1/4 - (p - 1/2) ^ 2 := by ring

theorem lem_quarter (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : V n p ≤ 1 / (4 * n) := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  unfold V
  rw [div_le_div_iff₀ hn' (by positivity)]
  nlinarith [sq_nonneg (p - 1/2)]

/-! ## Lemma 2.2 — false on the closed unit interval `I = [0,1]` -/
theorem lem_positive_false :
    ¬ ∀ n : ℕ, 1 ≤ n → ∀ p ∈ Set.Icc (0:ℝ) 1, 0 < V n p := by
  intro h
  have := h 1 le_rfl 0 ⟨le_rfl, zero_le_one⟩
  simp [V] at this

/-- The corrected statement: on the open interval it holds. -/
theorem lem_positive_open (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) :
    0 < V n p := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  unfold V
  have : 0 < 1 - p := by linarith [hp.2]
  have := hp.1
  positivity

/-- On `[0,1]` one only gets `V_n(p) ≥ 0`. -/
theorem lem_nonneg (n : ℕ) (p : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) : 0 ≤ V n p := by
  unfold V
  have : 0 ≤ 1 - p := by linarith [hp.2]
  have := hp.1
  positivity

/-! ## Proposition 2.3 — true (on `[0,1]`), proved directly via Cauchy–Schwarz -/
theorem prop_concave (n : ℕ) (hn : 1 ≤ n) (p q : ℝ)
    (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) :
    (Real.sqrt (V n p) + Real.sqrt (V n q)) / 2 ≤ Real.sqrt (V n ((p + q) / 2)) := by
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hq0, hq1⟩ := hq
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  set a := Real.sqrt (V n p)
  set b := Real.sqrt (V n q)
  have ha : 0 ≤ a := Real.sqrt_nonneg _
  have hb : 0 ≤ b := Real.sqrt_nonneg _
  have ha2 : a ^ 2 = p * (1 - p) / n := Real.sq_sqrt (lem_nonneg n p ⟨hp0, hp1⟩)
  have hb2 : b ^ 2 = q * (1 - q) / n := Real.sq_sqrt (lem_nonneg n q ⟨hq0, hq1⟩)
  apply Real.le_sqrt_of_sq_le
  -- ((a+b)/2)^2 ≤ m(1-m)/n  ⇔  n(a+b)^2 ≤ (p+q)(2-p-q)
  -- Cauchy–Schwarz: (√(p(1-p)) + √(q(1-q)))² ≤ (p+q)((1-p)+(1-q)), i.e.
  -- n²a²b² = pq(1-p)(1-q) and 2nab ≤ p(1-q) + q(1-p) by AM–GM.
  have hab2 : (n * a * b) ^ 2 = (p * (1 - q)) * (q * (1 - p)) := by
    have : (n * a * b) ^ 2 = n ^ 2 * a ^ 2 * b ^ 2 := by ring
    rw [this, ha2, hb2]; field_simp; ring
  have hx : 0 ≤ p * (1 - q) := mul_nonneg hp0 (by linarith)
  have hy : 0 ≤ q * (1 - p) := mul_nonneg hq0 (by linarith)
  have hnab : 0 ≤ n * a * b := by positivity
  have key : 2 * (n * a * b) ≤ p * (1 - q) + q * (1 - p) := by
    -- (X+Y)² - (2t)² = (X-Y)² ≥ 0 with t² = XY, and both sides are nonnegative
    nlinarith [sq_nonneg (p * (1 - q) - q * (1 - p)), hab2, hx, hy, hnab]
  have goal' : n * (a + b) ^ 2 ≤ (p + q) * (2 - p - q) := by
    have e : n * (a + b) ^ 2 = n * a ^ 2 + n * b ^ 2 + 2 * (n * a * b) := by ring
    rw [e, ha2, hb2]
    field_simp
    nlinarith [key]
  unfold V
  rw [le_div_iff₀ hn']
  nlinarith [goal']

/-! ## Lemma 2.4 — false: `V_n(p) ≤ p/(4n)` fails at `p = 1/2`, `n = 1` -/
theorem lem_linear_false :
    ¬ ∀ n : ℕ, 1 ≤ n → ∀ p ∈ Set.Icc (0:ℝ) 1, V n p ≤ p / (4 * n) := by
  intro h
  have := h 1 le_rfl (1/2) ⟨by norm_num, by norm_num⟩
  norm_num [V] at this

/-- What is actually true: `V_n(p) ≤ p/n` on `[0,1]`, and `≤ p/(4n)` exactly when `p ≥ 3/4`. -/
theorem lem_linear_fix (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) :
    V n p ≤ p / n := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  unfold V
  apply div_le_div_of_nonneg_right _ hn'.le
  nlinarith [hp.1]

/-! ## Proposition 2.5 — true -/
theorem prop_uniform : ∃ C : ℝ, ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, V n p ≤ C / n := by
  refine ⟨1/4, fun n hn p => ?_⟩
  have h := lem_quarter n hn p
  have : (1:ℝ) / (4 * n) = 1/4 / n := by ring
  linarith

/-! ## Proposition 2.6 — statement true, proof's identity false -/
lemma mean_add {m : ℕ} (x y : Fin m → ℝ) : mean (x + y) = mean x + mean y := by
  simp [mean, Finset.sum_add_distrib, add_div]

theorem prop_sum (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    svar (x + y) ≤ 2 * svar x + 2 * svar y := by
  have hm' : (0:ℝ) < (m:ℝ) - 1 := by
    have : (2:ℝ) ≤ m := by exact_mod_cast hm
    linarith
  unfold svar
  rw [mean_add]
  rw [mul_div_assoc', mul_div_assoc', div_add_div_same]
  apply div_le_div_of_nonneg_right _ hm'.le
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro i _
  simp only [Pi.add_apply]
  nlinarith [sq_nonneg ((x i - mean x) - (y i - mean y))]

/-- The identity `s²(x+y) = s²(x) + s²(y)` used in the proof is false:
take `m = 2`, `x = y = (0,1)`; then `s²(x+y) = 2` but `s²(x)+s²(y) = 1`. -/
theorem prop_sum_identity_false :
    ¬ ∀ x y : Fin 2 → ℝ, svar (x + y) = svar x + svar y := by
  intro h
  have := h ![0, 1] ![0, 1]
  norm_num [svar, mean, Fin.sum_univ_two] at this
