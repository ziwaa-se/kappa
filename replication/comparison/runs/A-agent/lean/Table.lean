import Mathlib

/-!
# Table 1 (mixing densities and the boundary `κ_ν[p,q)`) and the Appendix B inequality

For a score with Lebesgue mixing density `h`, the representation (2)–(3) gives
`∂_p S(p,0) = p h(p)` and `∂_p S(p,1) = -(1-p) h(p)`; conversely these derivative identities
(plus FTC) give `∫_p^q θ h = S(q,0) - S(p,0)` and `∫_p^q (1-θ) h = S(p,1) - S(q,1)`, so
`κ = A / (A + B)` with `A = S(q,0) - S(p,0)`, `B = S(p,1) - S(q,1)`.
-/

open Set intervalIntegral

noncomputable section

/-- FTC step: from the derivative identities, the two integrals over `[p,q]`. -/
lemma kappa_parts {S0 S1 h : ℝ → ℝ} {p q : ℝ} (hpq : p ≤ q)
    (hc : ContinuousOn h (Icc p q))
    (d0 : ∀ x ∈ Icc p q, HasDerivAt S0 (x * h x) x)
    (d1 : ∀ x ∈ Icc p q, HasDerivAt S1 (-((1 - x) * h x)) x) :
    (∫ x in p..q, x * h x) = S0 q - S0 p ∧ (∫ x in p..q, (1 - x) * h x) = S1 p - S1 q := by
  have hu : uIcc p q = Icc p q := uIcc_of_le hpq
  constructor
  · apply integral_eq_sub_of_hasDerivAt (fun x hx => d0 x (hu ▸ hx))
    apply ContinuousOn.intervalIntegrable
    rw [hu]; exact continuousOn_id.mul hc
  · have := integral_eq_sub_of_hasDerivAt (f := S1) (f' := fun x => -((1 - x) * h x))
      (fun x hx => d1 x (hu ▸ hx)) (by
        apply ContinuousOn.intervalIntegrable
        rw [hu]; exact ((continuousOn_const.sub continuousOn_id).mul hc).neg)
    rw [intervalIntegral.integral_neg] at this
    linarith

/-! ## Brier score: `S(p,0) = p^2`, `S(p,1) = (1-p)^2`, `h = 2`, `κ = (p+q)/2`. -/

lemma brier_d0 (x : ℝ) : HasDerivAt (fun p : ℝ => (p - 0) ^ 2) (x * 2) x := by
  have := (hasDerivAt_id x).sub_const 0 |>.pow 2
  simpa [mul_comm] using this

lemma brier_d1 (x : ℝ) : HasDerivAt (fun p : ℝ => (p - 1) ^ 2) (-((1 - x) * 2)) x := by
  have := ((hasDerivAt_id x).sub_const 1).pow 2
  convert this using 1; simp; ring

lemma brier_kappa {p q : ℝ} (hpq : p < q) :
    (q ^ 2 - p ^ 2) / ((q ^ 2 - p ^ 2) + ((p - 1) ^ 2 - (q - 1) ^ 2)) = (p + q) / 2 := by
  have : q - p ≠ 0 := by linarith
  rw [div_eq_div_iff (by nlinarith) (by norm_num)]; ring

/-! ## Logarithmic score: `S(p,0) = -log(1-p)`, `S(p,1) = -log p`, `h = 1/(θ(1-θ))`. -/

lemma log_d0 {x : ℝ} (hx0 : 0 < x) (hx : x < 1) :
    HasDerivAt (fun p : ℝ => -Real.log (1 - p)) (x * (1 / (x * (1 - x)))) x := by
  have hx' : (1 - x) ≠ 0 := by linarith
  have := ((hasDerivAt_id x).const_sub 1).log hx'
  convert this.neg using 1; field_simp

lemma log_d1 {x : ℝ} (hx : 0 < x) (hx1 : x < 1) :
    HasDerivAt (fun p : ℝ => -Real.log p) (-((1 - x) * (1 / (x * (1 - x))))) x := by
  have hx' : (1 - x) ≠ 0 := by linarith
  have := (Real.hasDerivAt_log hx.ne').neg
  convert this using 1; field_simp; ring

/-- Table 1, logarithmic score: `κ = log((1-p)/(1-q)) / log(q(1-p)/(p(1-q)))`. -/
lemma log_kappa {p q : ℝ} (hp : 0 < p) (hpq : p < q) (hq : q < 1) :
    let A := -Real.log (1 - q) - -Real.log (1 - p)
    let B := -Real.log p - -Real.log q
    A / (A + B) = Real.log ((1 - p) / (1 - q)) / Real.log (q * (1 - p) / (p * (1 - q))) := by
  intro A B
  have h1 : 0 < 1 - p := by linarith
  have h2 : 0 < 1 - q := by linarith
  have hq0 : 0 < q := by linarith
  have eA : A = Real.log ((1 - p) / (1 - q)) := by
    simp only [A]; rw [Real.log_div h1.ne' h2.ne']; ring
  have eAB : A + B = Real.log (q * (1 - p) / (p * (1 - q))) := by
    simp only [A, B]
    rw [Real.log_div (by positivity) (by positivity), Real.log_mul hq0.ne' h1.ne',
      Real.log_mul hp.ne' h2.ne']; ring
  rw [eA, ← eAB, ← eA]

/-! ## Spherical score: `S(p,1) = 1 - p/‖p‖`, `S(p,0) = 1 - (1-p)/‖p‖`,
`‖p‖ = (2p²-2p+1)^{1/2}`, `h = (2θ²-2θ+1)^{-3/2}`. -/

def nrm (p : ℝ) : ℝ := Real.sqrt (2 * p ^ 2 - 2 * p + 1)

lemma nrm_arg_pos (p : ℝ) : 0 < 2 * p ^ 2 - 2 * p + 1 := by nlinarith [sq_nonneg (2 * p - 1)]

lemma nrm_pos (p : ℝ) : 0 < nrm p := Real.sqrt_pos.mpr (nrm_arg_pos p)

lemma nrm_sq (p : ℝ) : nrm p ^ 2 = 2 * p ^ 2 - 2 * p + 1 :=
  Real.sq_sqrt (nrm_arg_pos p).le

/-- Spherical mixing density `h(θ) = ‖θ‖^{-3}`. -/
def hsph (θ : ℝ) : ℝ := 1 / nrm θ ^ 3

lemma hasDerivAt_nrm (x : ℝ) : HasDerivAt nrm ((2 * x - 1) / nrm x) x := by
  have hin : HasDerivAt (fun p : ℝ => 2 * p ^ 2 - 2 * p + 1) (4 * x - 2) x := by
    have := (((hasDerivAt_id x).pow 2).const_mul 2).sub ((hasDerivAt_id x).const_mul 2)
      |>.add_const 1
    convert this using 1; simp only [id]; ring
  have := hin.sqrt (nrm_arg_pos x).ne'
  convert this using 1
  have hN := nrm_pos x
  unfold nrm at hN ⊢
  rw [div_eq_div_iff hN.ne' (by positivity)]; ring

lemma sph_d0 (x : ℝ) : HasDerivAt (fun p => 1 - (1 - p) / nrm p) (x * hsph x) x := by
  have hN := nrm_pos x
  have := (((hasDerivAt_id x).const_sub 1).div (hasDerivAt_nrm x) hN.ne').const_sub 1
  convert this using 1
  simp only [hsph, id]
  have h2 := nrm_sq x
  rw [eq_comm, ← sub_eq_zero]
  have e : -((-1 * nrm x - (1 - x) * ((2 * x - 1) / nrm x)) / nrm x ^ 2) - x * (1 / nrm x ^ 3)
      = (nrm x ^ 2 - (2 * x ^ 2 - 2 * x + 1)) / nrm x ^ 3 := by
    field_simp; ring
  rw [e, h2, sub_self, zero_div]

lemma sph_d1 (x : ℝ) : HasDerivAt (fun p => 1 - p / nrm p) (-((1 - x) * hsph x)) x := by
  have hN := nrm_pos x
  have := ((hasDerivAt_id x).div (hasDerivAt_nrm x) hN.ne').const_sub 1
  convert this using 1
  simp only [hsph, id]
  have h2 := nrm_sq x
  rw [eq_comm, ← sub_eq_zero]
  have e : -((1 * nrm x - x * ((2 * x - 1) / nrm x)) / nrm x ^ 2) - -((1 - x) * (1 / nrm x ^ 3))
      = -(nrm x ^ 2 - (2 * x ^ 2 - 2 * x + 1)) / nrm x ^ 3 := by
    field_simp; ring
  rw [e, h2, sub_self, neg_zero, zero_div]

/-- Table 1, spherical score: `κ = ((q-1)‖p‖ - (p-1)‖q‖) / ((2q-1)‖p‖ - (2p-1)‖q‖)`. -/
lemma sph_kappa (p q : ℝ) (hden : (2 * q - 1) * nrm p - (2 * p - 1) * nrm q ≠ 0) :
    let A := (1 - (1 - q) / nrm q) - (1 - (1 - p) / nrm p)
    let B := (1 - p / nrm p) - (1 - q / nrm q)
    A / (A + B) = ((q - 1) * nrm p - (p - 1) * nrm q) / ((2 * q - 1) * nrm p - (2 * p - 1) * nrm q) := by
  intro A B
  have hp := (nrm_pos p).ne'
  have hq := (nrm_pos q).ne'
  have hAB : A + B ≠ 0 := by
    intro h; apply hden
    have : A + B = ((2 * q - 1) * nrm p - (2 * p - 1) * nrm q) / (nrm p * nrm q) := by
      simp only [A, B]; field_simp; ring
    rw [this, div_eq_zero_iff] at h
    rcases h with h | h
    · exact h
    · exact absurd h (mul_ne_zero hp hq)
  rw [div_eq_div_iff hAB hden]
  simp only [A, B]; field_simp; ring

/-! ## Appendix B: the stopping rule `τ_{α,h}` guarantees `e_{t+h-1} ≥ 1/α`. -/

/-- If every pending factor is at least `m > 0` (its worst case `1 - λ_j`), the current
partial products are `M_k ≥ 0`, and `e_t = (1/h) ∑ M_k ≥ (1/m)/α`, then
`e_{t+h-1} = (1/h) ∑ a_k M_k ≥ 1/α` whatever the pending outcomes. -/
lemma appendixB {n : ℕ} (a M : Fin n → ℝ) {m α c : ℝ} (hm : 0 < m) (hα : 0 < α) (hc : 0 < c)
    (ha : ∀ k, m ≤ a k) (hM : ∀ k, 0 ≤ M k)
    (he : m⁻¹ / α ≤ c * ∑ k, M k) :
    1 / α ≤ c * ∑ k, a k * M k := by
  have h1 : m * ∑ k, M k ≤ ∑ k, a k * M k := by
    rw [Finset.mul_sum]
    exact Finset.sum_le_sum (fun k _ => mul_le_mul_of_nonneg_right (ha k) (hM k))
  have h2 : 1 / α ≤ m * (c * ∑ k, M k) := by
    have := mul_le_mul_of_nonneg_left he hm.le
    rwa [mul_div_assoc', mul_inv_cancel₀ hm.ne'] at this
  calc 1 / α ≤ m * (c * ∑ k, M k) := h2
    _ = c * (m * ∑ k, M k) := by ring
    _ ≤ c * ∑ k, a k * M k := mul_le_mul_of_nonneg_left h1 hc.le

end
