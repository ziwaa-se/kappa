import Mathlib

noncomputable def V (n : ℕ) (p : ℝ) : ℝ := p * (1 - p) / n

/-! Lemma 2.1 -/
lemma quarter_identity (p : ℝ) : p * (1 - p) = 1/4 - (p - 1/2) ^ 2 := by ring

lemma quarter (n : ℕ) (p : ℝ) : V n p ≤ 1 / (4 * n) := by
  have h : p * (1 - p) ≤ 1/4 := by nlinarith [sq_nonneg (p - 1/2)]
  calc V n p = p * (1 - p) / n := rfl
    _ ≤ (1/4) / n := by gcongr
    _ = 1 / (4 * n) := by rw [div_div]

/-! Lemma 2.2: true on the open interval, false on the closed one -/
lemma positive (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) : 0 < V n p := by
  obtain ⟨h0, h1⟩ := hp
  have hn' : (0:ℝ) < n := by exact_mod_cast hn
  exact div_pos (mul_pos h0 (by linarith)) hn'

example (n : ℕ) : ¬ (0 < V n 0) := by simp [V]   -- counterexample at p = 0 ∈ [0,1]

/-! Proposition 2.3 -/
lemma V_nonneg (n : ℕ) {p : ℝ} (hp : p ∈ Set.Icc (0:ℝ) 1) : 0 ≤ V n p :=
  div_nonneg (mul_nonneg hp.1 (by linarith [hp.2])) (Nat.cast_nonneg n)

lemma concave_mid (n : ℕ) (p q : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) :
    (Real.sqrt (V n p) + Real.sqrt (V n q)) / 2 ≤ Real.sqrt (V n ((p + q) / 2)) := by
  set a := Real.sqrt (V n p)
  set b := Real.sqrt (V n q)
  have ha2 : a ^ 2 = V n p := Real.sq_sqrt (V_nonneg n hp)
  have hb2 : b ^ 2 = V n q := Real.sq_sqrt (V_nonneg n hq)
  have ha0 : 0 ≤ a := Real.sqrt_nonneg _
  have hb0 : 0 ≤ b := Real.sqrt_nonneg _
  have hid : V n ((p + q) / 2) = (V n p + V n q) / 2 + (p - q) ^ 2 / 4 / n := by
    unfold V; ring
  have hextra : 0 ≤ (p - q) ^ 2 / 4 / n := by positivity
  have key : ((a + b) / 2) ^ 2 ≤ V n ((p + q) / 2) := by
    rw [hid, ← ha2, ← hb2]
    nlinarith [sq_nonneg (a - b)]
  calc (a + b) / 2 = Real.sqrt (((a + b) / 2) ^ 2) := (Real.sqrt_sq (by positivity)).symm
    _ ≤ Real.sqrt (V n ((p + q) / 2)) := Real.sqrt_le_sqrt key

/-! Lemma 2.4: false as stated -/
example : ¬ ∀ n : ℕ, 1 ≤ n → ∀ p ∈ Set.Icc (0:ℝ) 1, V n p ≤ p / (4 * n) := by
  intro h
  have := h 1 le_rfl (1/2) ⟨by norm_num, by norm_num⟩
  norm_num [V] at this

-- corrected version
lemma linear_fixed (n : ℕ) (p : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) : V n p ≤ p / n := by
  unfold V
  gcongr
  nlinarith [hp.1, hp.2, sq_nonneg p]

/-! Proposition 2.5 -/
theorem uniform : ∃ C : ℝ, ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, V n p ≤ C / n :=
  ⟨1/4, fun n _ p => by
    unfold V; gcongr; nlinarith [sq_nonneg (p - 1/2)]⟩

/-! Proposition 2.6 -/
noncomputable def mean {m : ℕ} (u : Fin m → ℝ) : ℝ := (∑ i, u i) / m
noncomputable def s2 {m : ℕ} (u : Fin m → ℝ) : ℝ :=
  (∑ i, (u i - mean u) ^ 2) / ((m : ℝ) - 1)

lemma mean_add {m : ℕ} (x y : Fin m → ℝ) : mean (x + y) = mean x + mean y := by
  simp only [mean, Pi.add_apply, Finset.sum_add_distrib, add_div]

theorem sum_bound {m : ℕ} (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 (x + y) ≤ 2 * s2 x + 2 * s2 y := by
  have hm' : (0:ℝ) ≤ (m:ℝ) - 1 := by
    have : (2:ℝ) ≤ m := by exact_mod_cast hm
    linarith
  unfold s2
  rw [mean_add, mul_div_assoc', mul_div_assoc', ← add_div]
  gcongr
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro i _
  simp only [Pi.add_apply]
  nlinarith [sq_nonneg ((x i - mean x) - (y i - mean y))]

-- the identity used in the paper's proof is false
example : ¬ ∀ x y : Fin 2 → ℝ, s2 (x + y) = s2 x + s2 y := by
  intro h
  have := h ![0, 1] ![0, 1]
  norm_num [s2, mean, Fin.sum_univ_two] at this
