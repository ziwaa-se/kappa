import Mathlib

/-!
# Proposition 2.5, Lemma 4.10, Theorem 4.12, Examples 2.4 / 2.7, Propositions 4.6 / 5.2 / 5.3
(real-function parts)
-/

open Set Real

noncomputable section

/-- The subadditivity condition of Definition 2.2 for a CDF-like function `F`. -/
def SubInv (F : ℝ → ℝ) : Prop :=
  ∀ x y : ℝ, 0 < x → 0 < y → 1 - F (1 / (x + y)) ≤ (1 - F (1 / x)) + (1 - F (1 / y))

/-- Anti-star-shaped (`G(x)/x` decreasing on `(0,∞)`) implies subadditive on `(0,∞)`. -/
lemma subadd_of_antistar (G : ℝ → ℝ) (hG : AntitoneOn (fun x => G x / x) (Ioi 0)) :
    ∀ x y : ℝ, 0 < x → 0 < y → G (x + y) ≤ G x + G y := by
  intro x y hx hy
  have hxy : 0 < x + y := by linarith
  have h1 := hG (show x ∈ Ioi 0 from hx) (show x + y ∈ Ioi 0 from hxy) (by linarith)
  have h2 := hG (show y ∈ Ioi 0 from hy) (show x + y ∈ Ioi 0 from hxy) (by linarith)
  simp only at h1 h2
  rw [div_le_div_iff₀ hxy hx] at h1
  rw [div_le_div_iff₀ hxy hy] at h2
  have : G (x + y) * (x + y) ≤ (G x + G y) * (x + y) := by nlinarith
  exact le_of_mul_le_mul_right this hxy

/-- **Proposition 2.5** (for a CDF that is differentiable on `(0,∞)` with derivative `f`):
if the hazard rate satisfies `f(u)/(1-F(u)) ≤ 1/u`, i.e. `u f(u) ≤ 1 - F(u)`, then
`1 - F(1/x)` is anti-star-shaped, hence subadditive. -/
theorem prop_2_5 (F f : ℝ → ℝ) (hF : ∀ u, 0 < u → HasDerivAt F (f u) u)
    (hhaz : ∀ u, 0 < u → u * f u ≤ 1 - F u) : SubInv F := by
  set G : ℝ → ℝ := fun x => (1 - F (1 / x)) / x
  have hGd : ∀ x, 0 < x → HasDerivAt G ((f (1 / x) / x - (1 - F (1 / x))) / x ^ 2) x := by
    intro x hx
    have hinv : HasDerivAt (fun x : ℝ => 1 / x) (-(x ^ 2)⁻¹) x := by
      simpa [one_div] using hasDerivAt_inv hx.ne'
    have hc := (hF (1 / x) (by positivity)).comp x hinv
    have hnum : HasDerivAt (fun x => 1 - F (1 / x)) (-(f (1 / x) * -(x ^ 2)⁻¹)) x :=
      (hc.const_sub 1)
    have := hnum.div (hasDerivAt_id x) hx.ne'
    convert this using 1
    simp only [id]
    field_simp
    ring
  have hanti : AntitoneOn G (Ioi 0) := by
    apply antitoneOn_of_deriv_nonpos (convex_Ioi 0)
    · intro x hx; exact (hGd x hx).continuousAt.continuousWithinAt
    · intro x hx
      rw [interior_Ioi] at hx
      exact (hGd x hx).differentiableAt.differentiableWithinAt
    · intro x hx
      rw [interior_Ioi] at hx
      rw [(hGd x hx).deriv]
      apply div_nonpos_of_nonpos_of_nonneg _ (by positivity)
      have := hhaz (1 / x) (one_div_pos.2 hx)
      have e : f (1 / x) / x = 1 / x * f (1 / x) := by ring
      linarith
  intro x y hx hy
  have := subadd_of_antistar (fun x => 1 - F (1 / x)) hanti x y hx hy
  simpa using this

/-! ## Lemma 4.10 and Theorem 4.12 -/

/-- Super-heavy-tailed (Definition 4.9(1)), for `F > 0` on `(0,∞)` (forced anyway, see the
report): `-log F(1/x)` subadditive on `(0,∞)`. -/
def SHT (F : ℝ → ℝ) : Prop :=
  ∀ x y : ℝ, 0 < x → 0 < y → -Real.log (F (1 / (x + y))) ≤ -Real.log (F (1 / x)) + -Real.log (F (1 / y))

/-- Condition (4.10) in Lemma 4.10. -/
def Cond410 (F : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 0 < x → ∀ θ : ℝ, 0 < θ → θ < 1 → F (x / θ) * F (x / (1 - θ)) ≤ F x

/-- **Lemma 4.10** (for `x > 0`; at `x = 0` (4.10) reads `F(0)² ≤ F(0)`). -/
theorem lemma_4_10 (F : ℝ → ℝ) (hpos : ∀ u, 0 < u → 0 < F u) : SHT F ↔ Cond410 F := by
  have key : ∀ a b c : ℝ, 0 < a → 0 < b → 0 < c →
      (-Real.log c ≤ -Real.log a + -Real.log b ↔ a * b ≤ c) := by
    intro a b c ha hb hc
    rw [← neg_add, neg_le_neg_iff, ← Real.log_mul ha.ne' hb.ne']
    exact Real.log_le_log_iff (mul_pos ha hb) hc
  constructor
  · intro h x hx θ hθ0 hθ1
    have h1 : 0 < θ / x := by positivity
    have h2 : 0 < (1 - θ) / x := by apply div_pos <;> linarith
    have := h (θ / x) ((1 - θ) / x) h1 h2
    have e1 : 1 / (θ / x + (1 - θ) / x) = x := by field_simp
    have e2 : 1 / (θ / x) = x / θ := by field_simp
    have e3 : 1 / ((1 - θ) / x) = x / (1 - θ) := by field_simp
    rw [e1, e2, e3] at this
    exact (key _ _ _ (hpos _ (by positivity)) (hpos _ (by apply div_pos hx; linarith))
      (hpos _ hx)).1 this
  · intro h x y hx hy
    have hs : 0 < x + y := by linarith
    have hθ0 : 0 < x / (x + y) := by positivity
    have hθ1 : x / (x + y) < 1 := by rw [div_lt_one hs]; linarith
    have := h (1 / (x + y)) (by positivity) (x / (x + y)) hθ0 hθ1
    have e1 : 1 / (x + y) / (x / (x + y)) = 1 / x := by field_simp
    have e2 : 1 / (x + y) / (1 - x / (x + y)) = 1 / y := by
      have : 1 - x / (x + y) = y / (x + y) := by field_simp
      rw [this]; field_simp
    rw [e1, e2] at this
    exact (key _ _ _ (hpos _ (by positivity)) (hpos _ (by positivity)) (hpos _ (by positivity))).2
      this

/-- **Theorem 4.12** (super-heavy-tailed ⇒ InvSub), for `F` with values in `[0,1]`.
The correct reason is `ab ≥ a + b - 1` for `a, b ≤ 1`, i.e. `(1-a)(1-b) ≥ 0`
(the paper's "the exponential is superadditive" is not literally true: `e^0 < e^0 + e^0`). -/
theorem theorem_4_12 (F : ℝ → ℝ) (hpos : ∀ u, 0 < u → 0 < F u) (hle : ∀ u, F u ≤ 1)
    (h : SHT F) : SubInv F := by
  intro x y hx hy
  have hs : 0 < x + y := by linarith
  have a := (lemma_4_10 F hpos).1 h
  have hθ0 : 0 < x / (x + y) := by positivity
  have hθ1 : x / (x + y) < 1 := by rw [div_lt_one hs]; linarith
  have := a (1 / (x + y)) (by positivity) (x / (x + y)) hθ0 hθ1
  have e1 : 1 / (x + y) / (x / (x + y)) = 1 / x := by field_simp
  have e2 : 1 / (x + y) / (1 - x / (x + y)) = 1 / y := by
    have : 1 - x / (x + y) = y / (x + y) := by field_simp
    rw [this]; field_simp
  rw [e1, e2] at this
  nlinarith [hle (1 / x), hle (1 / y)]

/-- The paper's justification "the exponential is superadditive" is false as stated. -/
example : ¬ ∀ s t : ℝ, Real.exp s + Real.exp t ≤ Real.exp (s + t) := by
  intro h; have := h 0 0; norm_num at this

/-! ## Example 2.4: the Fréchet(1) identity -/

theorem example_2_4 (x θ : ℝ) (hx : 0 < x) (hθ : 0 < θ) (hθ1 : θ < 1) :
    1 + exp (-1 / x) - exp (-1 / (x / θ)) - exp (-1 / (x / (1 - θ))) =
      (1 - exp (-θ / x)) * (1 - exp (-(1 - θ) / x)) := by
  have h1 : -1 / (x / θ) = -θ / x := by field_simp
  have h2 : -1 / (x / (1 - θ)) = -(1 - θ) / x := by
    have : (1 - θ) ≠ 0 := by linarith
    field_simp
  rw [h1, h2]
  have h3 : exp (-1 / x) = exp (-θ / x) * exp (-(1 - θ) / x) := by
    rw [← exp_add]; congr 1; field_simp; ring
  rw [h3]; ring

/-! ## Example 2.7: the discrete example is also super-heavy-tailed

`F(x) = (1-p)^⌈1/x⌉`, so `F(x/θ) F(x/(1-θ)) = (1-p)^(⌈θ/x⌉ + ⌈(1-θ)/x⌉) ≤ (1-p)^⌈1/x⌉ = F(x)`.
This contradicts the claim (Introduction) that InvSub "seems the only [class] including some
discrete distributions". -/
theorem example_2_7_SHT (p : ℝ) (hp0 : 0 < p) (hp1 : p < 1) :
    Cond410 (fun x => (1 - p) ^ ⌈1 / x⌉) := by
  intro x hx θ hθ0 hθ1
  have hb0 : 0 < 1 - p := by linarith
  have hb1 : 1 - p ≤ 1 := by linarith
  have e1 : 1 / (x / θ) = θ / x := by field_simp
  have e2 : 1 / (x / (1 - θ)) = (1 - θ) / x := by
    have : (1 - θ) ≠ 0 := by linarith
    field_simp
  simp only [e1, e2]
  rw [← zpow_add₀ hb0.ne']
  apply zpow_le_zpow_right_of_le_one₀ hb0 hb1
  have : 1 / x = θ / x + (1 - θ) / x := by field_simp
  rw [this]
  exact Int.ceil_add_le _ _

/-- ... and its inverted distribution `1-(1-p)^⌈x⌉` is subadditive (the InvSub claim). -/
theorem example_2_7_InvSub (p : ℝ) (hp0 : 0 < p) (hp1 : p < 1) :
    ∀ x y : ℝ, 0 < x → 0 < y →
      1 - (1 - p) ^ ⌈x + y⌉ ≤ (1 - (1 - p) ^ ⌈x⌉) + (1 - (1 - p) ^ ⌈y⌉) := by
  intro x y hx hy
  have hb0 : 0 < 1 - p := by linarith
  have hb1 : 1 - p ≤ 1 := by linarith
  have hx1 : (1 - p) ^ ⌈x⌉ ≤ 1 := zpow_le_one₀ hb0 hb1 (Int.ceil_nonneg hx.le)
  have hy1 : (1 - p) ^ ⌈y⌉ ≤ 1 := zpow_le_one₀ hb0 hb1 (Int.ceil_nonneg hy.le)
  have hs : (1 - p) ^ (⌈x⌉ + ⌈y⌉) ≤ (1 - p) ^ ⌈x + y⌉ :=
    zpow_le_zpow_right_of_le_one₀ hb0 hb1 (Int.ceil_add_le x y)
  rw [zpow_add₀ hb0.ne'] at hs
  nlinarith

/-! ## Propositions 4.6, 5.2, 5.3: quantile computations -/

/-- Pareto quantile used in Props 4.6 / 5.3: for `F < 1`, `1/(1-F) = Λ + 1` where `Λ = F/(1-F)`. -/
theorem prop_4_6_identity (F : ℝ) (h : F < 1) : 1 / (1 - F) = F / (1 - F) + 1 := by
  have : 1 - F ≠ 0 := by linarith
  field_simp

/-- Generalised inverse of `𝒫(x) = 1 - 1/max(x,1)` at `p ∈ [0,1)` is `1/(1-p)`. -/
theorem pareto_quantile (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p < 1) :
    sSup {x : ℝ | 1 - (max x 1)⁻¹ ≤ p} = 1 / (1 - p) := by
  have h1p : 0 < 1 - p := by linarith
  have hS : {x : ℝ | 1 - (max x 1)⁻¹ ≤ p} = Iic (1 / (1 - p)) := by
    ext x
    simp only [mem_setOf_eq, mem_Iic]
    have hm : 0 < max x 1 := lt_of_lt_of_le one_pos (le_max_right _ _)
    have hq : 1 ≤ 1 / (1 - p) := by rw [le_div_iff₀ h1p]; linarith
    constructor
    · intro h
      have : 1 - p ≤ (max x 1)⁻¹ := by linarith
      have := (le_inv_comm₀ h1p hm).1 this
      rw [one_div]; exact (le_max_left x 1).trans this
    · intro h
      have : max x 1 ≤ 1 / (1 - p) := max_le h hq
      have := (inv_anti₀ hm this)
      rw [one_div, inv_inv] at this
      linarith
  rw [hS, csSup_Iic]

/-- Prop 5.3 core: `1 / 𝒫⁻¹(p) = 1 - p`. -/
theorem prop_5_3_core (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p < 1) :
    1 / sSup {x : ℝ | 1 - (max x 1)⁻¹ ≤ p} = 1 - p := by
  rw [pareto_quantile p hp0 hp1]; field_simp

/-- Fréchet quantile used in Prop 5.2: for `p ∈ (0,1)`, `ℋ⁻¹(p) = -1/log p`
(here `ℋ(x) = e^{-1/x}` for `x > 0`, `0` otherwise), and `1/ℋ⁻¹(p) = -log p`. -/
theorem frechet_quantile (p : ℝ) (hp0 : 0 < p) (hp1 : p < 1) :
    sSup {x : ℝ | (if 0 < x then exp (-1 / x) else 0) ≤ p} = -1 / Real.log p ∧
      1 / (-1 / Real.log p) = -Real.log p := by
  have hl : Real.log p < 0 := Real.log_neg hp0 hp1
  have hq : 0 < -1 / Real.log p := div_pos_of_neg_of_neg (by norm_num) hl
  have hS : {x : ℝ | (if 0 < x then exp (-1 / x) else 0) ≤ p} = Iic (-1 / Real.log p) := by
    ext x
    simp only [mem_setOf_eq, mem_Iic]
    split_ifs with hx
    · rw [← Real.le_log_iff_exp_le hp0, div_le_iff₀ hx]
      rw [le_div_iff_of_neg hl]
      constructor <;> intro h <;> nlinarith
    · constructor
      · intro _; linarith
      · intro _; exact hp0.le
  refine ⟨by rw [hS, csSup_Iic], ?_⟩
  field_simp

end
