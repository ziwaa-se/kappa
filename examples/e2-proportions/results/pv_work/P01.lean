import P01Stmt

namespace Paper.P01

open Paper.DEFS

/-- S0. main.tex:61, "It is well known that ... concave on `I`." Supplied from mathlib
(`Real.strictConcaveOn_sqrt`, monotonicity of sqrt, concavity of `p(1-p)`). -/
theorem P01_S0 : SqrtConcave := by
  unfold SqrtConcave IClosed
  have hsq := (Real.strictConcaveOn_sqrt).concaveOn
  refine ⟨convex_Icc 0 1, ?_⟩
  intro x hx y hy a b ha hb hab
  obtain ⟨hx0, hx1⟩ := hx
  obtain ⟨hy0, hy1⟩ := hy
  simp only [smul_eq_mul]
  have hfx : (0:ℝ) ≤ x * (1 - x) := by nlinarith
  have hfy : (0:ℝ) ≤ y * (1 - y) := by nlinarith
  have step1 := hsq.2 (Set.mem_Ici.mpr hfx) (Set.mem_Ici.mpr hfy) ha hb hab
  simp only [smul_eq_mul] at step1
  refine le_trans step1 (Real.sqrt_le_sqrt ?_)
  have hb' : b = 1 - a := by linarith
  subst hb'
  nlinarith [sq_nonneg (x - y), mul_nonneg ha hb]

/-- S1. main.tex:61, concavity at the midpoint. -/
theorem P01_S1 (p q : ℝ) (hp : p ∈ IClosed) (hq : q ∈ IClosed) :
    (1 / 2) * (Real.sqrt (p * (1 - p)) + Real.sqrt (q * (1 - q))) ≤
      Real.sqrt (((p + q) / 2) * (1 - (p + q) / 2)) := by
  have S0 : ConcaveOn ℝ IClosed (fun p : ℝ => Real.sqrt (p * (1 - p))) := P01_S0
  have h := S0.2 hp hq (show (0:ℝ) ≤ 1/2 by norm_num) (show (0:ℝ) ≤ 1/2 by norm_num)
    (show (1/2 : ℝ) + 1/2 = 1 by norm_num)
  simp only [smul_eq_mul] at h
  have e : (1/2:ℝ) * p + 1/2 * q = (p + q) / 2 := by ring
  rw [e] at h
  linarith

/-- S2. main.tex:61-62, "divided by `√n`". -/
theorem P01_S2 (n : ℕ) (hn : 1 ≤ n) (x : ℝ) :
    Real.sqrt (V n x) = Real.sqrt (x * (1 - x)) / Real.sqrt (n : ℝ) := by
  unfold V
  exact Real.sqrt_div' _ (by positivity)

/-- S3. main.tex:61-62. -/
theorem P01_S3 (n : ℕ) (hn : 1 ≤ n) (p q : ℝ) :
    P01Claim n p q := by
  unfold P01Claim
  intro hp hq
  have hn' : 0 < Real.sqrt (n : ℝ) := Real.sqrt_pos.mpr (by exact_mod_cast hn)
  rw [P01_S2 n hn p, P01_S2 n hn q, P01_S2 n hn ((p + q) / 2)]
  have h := P01_S1 p q hp hq
  have e : (1 / 2) * (Real.sqrt (p * (1 - p)) / Real.sqrt (n : ℝ) +
      Real.sqrt (q * (1 - q)) / Real.sqrt (n : ℝ)) =
      ((1 / 2) * (Real.sqrt (p * (1 - p)) + Real.sqrt (q * (1 - q)))) / Real.sqrt (n : ℝ) := by
    ring
  rw [e]
  exact div_le_div_of_nonneg_right h hn'.le

/-- Main theorem (Proposition 2.3, main.tex:55-58). -/
theorem P01_main (n : ℕ) (hn : 1 ≤ n) :
    ∀ p q : ℝ, P01Claim n p q := by
  intro p q
  exact P01_S3 n hn p q

end Paper.P01
