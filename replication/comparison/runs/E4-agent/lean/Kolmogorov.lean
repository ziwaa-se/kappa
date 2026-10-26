import Mathlib

/-! Theorem 2.3: sanity checks on the Kolmogorov distribution function
`K(z) = 1 - 2 ∑_{k ≥ 1} (-1)^{k-1} e^{-2 k^2 z^2}` (re-indexed with `k ↦ k + 1`). -/

open Filter Topology Real

noncomputable section

def kterm (z : ℝ) (k : ℕ) : ℝ := (-1) ^ k * exp (-2 * ((k : ℝ) + 1) ^ 2 * z ^ 2)

def K (z : ℝ) : ℝ := 1 - 2 * ∑' k : ℕ, kterm z k

theorem kterm_bound (z : ℝ) (k : ℕ) :
    ‖kterm z k‖ ≤ exp (-2 * z ^ 2) ^ (k + 1) := by
  rw [kterm, norm_mul, norm_pow, norm_neg, norm_one, one_pow, one_mul, Real.norm_eq_abs,
    abs_of_pos (exp_pos _), ← Real.exp_nat_mul]
  apply exp_le_exp.2
  have h1 : ((k : ℝ) + 1) ≤ ((k : ℝ) + 1) ^ 2 := by
    nlinarith [(Nat.cast_nonneg k : (0 : ℝ) ≤ k)]
  push_cast
  nlinarith [sq_nonneg z]

theorem r_lt_one {z : ℝ} (hz : 0 < z) : exp (-2 * z ^ 2) < 1 := by
  have : -2 * z ^ 2 < 0 := by nlinarith [sq_pos_of_pos hz]
  simpa using exp_lt_exp.2 this

theorem geom_succ {r : ℝ} (hr0 : 0 ≤ r) (hr : r < 1) :
    HasSum (fun k : ℕ => r ^ (k + 1)) (r / (1 - r)) := by
  have h := (hasSum_geometric_of_lt_one hr0 hr).mul_right r
  have e : (fun k : ℕ => r ^ k * r) = fun k => r ^ (k + 1) := funext fun k => (pow_succ r k).symm
  rw [e] at h
  convert h using 1
  field_simp

theorem summable_kterm {z : ℝ} (hz : 0 < z) : Summable (kterm z) :=
  Summable.of_norm_bounded _ (geom_succ (exp_pos _).le (r_lt_one hz)).summable (kterm_bound z)

/-- `|K z - 1| ≤ 2 r / (1 - r)` with `r = e^{-2 z^2}`. -/
theorem K_close_one {z : ℝ} (hz : 0 < z) :
    |K z - 1| ≤ 2 * (exp (-2 * z ^ 2) / (1 - exp (-2 * z ^ 2))) := by
  have hn : ‖∑' k, kterm z k‖ ≤ exp (-2 * z ^ 2) / (1 - exp (-2 * z ^ 2)) :=
    tsum_of_norm_bounded (geom_succ (exp_pos _).le (r_lt_one hz)) (kterm_bound z)
  rw [K, show 1 - 2 * ∑' k, kterm z k - 1 = -(2 * ∑' k, kterm z k) by ring, abs_neg, abs_mul,
    abs_two]
  rw [Real.norm_eq_abs] at hn
  linarith

/-- `K(z) → 1` as `z → ∞`. -/
theorem K_tendsto_one : Tendsto K atTop (𝓝 1) := by
  have hr : Tendsto (fun z : ℝ => exp (-2 * z ^ 2)) atTop (𝓝 0) := by
    apply tendsto_exp_atBot.comp
    have : Tendsto (fun z : ℝ => 2 * z ^ 2) atTop atTop :=
      (tendsto_pow_atTop two_ne_zero).const_mul_atTop two_pos
    refine (tendsto_neg_atTop_atBot.comp this).congr fun z => ?_
    simp only [Function.comp]; ring
  have hb : Tendsto (fun z : ℝ => 2 * (exp (-2 * z ^ 2) / (1 - exp (-2 * z ^ 2)))) atTop
      (𝓝 0) := by
    have := (hr.div (tendsto_const_nhds.sub hr) (by norm_num : (1 : ℝ) - 0 ≠ 0)).const_mul 2
    simpa using this
  rw [tendsto_iff_norm_sub_tendsto_zero]
  refine squeeze_zero' (Eventually.of_forall fun _ => norm_nonneg _) ?_ hb
  filter_upwards [eventually_gt_atTop 0] with z hz
  exact K_close_one hz

end

#print axioms K_tendsto_one
#print axioms summable_kterm
