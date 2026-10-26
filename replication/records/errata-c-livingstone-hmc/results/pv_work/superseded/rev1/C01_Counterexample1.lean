import C01Stmt

/-!
# C01 issue 1: hypothesis (18) of Thm 2.2(i) fails on E(β,α) for 2 < β < log₂ 6

Source: TEX:806 ("Part (ii) is a direct consequence of Theorem \ref{thm:negative}"),
TEX:213 (Thm 2.2(i) requires (18)), TEX:868-871 ((18): `‖y‖ ≥ 2‖x‖ ≥ C ⇒ ‖∇U(y)‖ ≥ 3‖∇U(x)‖`),
TEX:223-226 (class E(β,α)).

Content (obstruction, NOT a counterexample to Cor 2.3(ii) itself):
* `osc_fails`: for EVERY member of E(β,α) with `2 < β < log₂ 6` (any α, M, c), (18) fails.
* `osc_holds`: for every member with `β ≥ log₂ 6` (β > 1), (18) holds.
* `not_S2Printed`: the printed step "β > 2 ⇒ (18)" (exactly the type of `C01_S2`) is false.
Definitions used verbatim: `InExpFam` (C01Stmt), `IsGradField`, `HypOscillations` (Defs).
-/

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.C01.Issue1

/-- Gradient of `b + α ‖x‖^β` on `E 1` (β > 1), from mathlib's `hasFDerivAt_norm_rpow`. -/
lemma hasGradientAt_pow (α b β : ℝ) (hβ : 1 < β) (x : E 1) :
    HasGradientAt (fun x : E 1 => b + α * ‖x‖ ^ β) ((α * β * ‖x‖ ^ (β - 2)) • x) x := by
  rw [hasGradientAt_iff_hasFDerivAt]
  have h := ((hasFDerivAt_norm_rpow x hβ).const_mul α).const_add b
  convert h using 1
  ext v
  simp [InnerProductSpace.toDual_apply, inner_smul_left, real_inner_comm]
  ring

/-- In the tail of a member of E(β,α) (β > 1), the gradient is `αβ‖x‖^{β-2} x`
(U = -log c + α‖x‖^β there, and gradients are unique). -/
lemma tail_grad {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ : 1 < β) :
    ∃ R : ℝ, 0 ≤ R ∧ ∀ x : E 1, R < ‖x‖ → gU x = (α * β * ‖x‖ ^ (β - 2)) • x := by
  obtain ⟨-, -, -, M, c, hc, htail⟩ := hU
  refine ⟨max M 0, le_max_right _ _, fun x hx => ?_⟩
  have hev : (fun y : E 1 => -Real.log c + α * ‖y‖ ^ β) =ᶠ[𝓝 x] U := by
    have hopen : IsOpen {y : E 1 | M < ‖y‖} := isOpen_lt continuous_const continuous_norm
    filter_upwards [hopen.mem_nhds (lt_of_le_of_lt (le_max_left _ _) hx)] with y hy
    have h1 := htail y hy
    unfold piDens at h1
    have h2 := congrArg Real.log h1
    rw [Real.log_exp, Real.log_mul hc.ne' (Real.exp_pos _).ne', Real.log_exp] at h2
    linarith
  have h1 := (hasGradientAt_pow α (-Real.log c) β hβ x).congr_of_eventuallyEq hev.symm
  exact (hgrad x).unique h1

/-- Tail norm of the gradient: `‖∇U(x)‖ = αβ‖x‖^{β-1}`. -/
lemma tail_norm {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ : 1 < β) :
    ∃ R : ℝ, 0 ≤ R ∧ ∀ x : E 1, R < ‖x‖ → ‖gU x‖ = α * β * ‖x‖ ^ (β - 1) := by
  have hα : 0 < α := hU.1
  obtain ⟨R, hR, hg⟩ := tail_grad hU hgrad hβ
  refine ⟨R, hR, fun x hx => ?_⟩
  have hxpos : 0 < ‖x‖ := lt_of_le_of_lt hR hx
  rw [hg x hx, norm_smul, Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  rw [show β - 1 = (β - 2) + 1 by ring, Real.rpow_add_one hxpos.ne']
  ring

/-- Obstruction (general ratio form): if `2^{β-1} < 3` then (18) fails for every member. -/
theorem osc_fails_of_rpow {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ : 1 < β) (h3 : (2 : ℝ) ^ (β - 1) < 3) :
    ¬ HypOscillations gU := by
  have hα : 0 < α := hU.1
  obtain ⟨R, hR, hn⟩ := tail_norm hU hgrad hβ
  rintro ⟨C, hC⟩
  set t : ℝ := |C| + R + 1 with ht
  have htpos : 0 < t := by positivity
  let x : E 1 := EuclideanSpace.single 0 t
  have hx : ‖x‖ = t := by
    simp [x, EuclideanSpace.norm_single, abs_of_pos htpos]
  have hy : ‖(2 : ℝ) • x‖ = 2 * t := by
    rw [norm_smul, hx]; norm_num
  have hCx : C ≤ 2 * ‖x‖ := by
    rw [hx]; have := le_abs_self C; linarith
  have hCabs := abs_nonneg C
  have key := hC x ((2 : ℝ) • x) (by rw [hy, hx]) hCx
  rw [hn x (by rw [hx]; linarith), hn ((2 : ℝ) • x) (by rw [hy]; linarith), hy, hx,
    Real.mul_rpow (by norm_num) htpos.le] at key
  have hpos : 0 < α * β * t ^ (β - 1) := by
    have : 0 < β := by linarith
    positivity
  nlinarith

/-- Obstruction: for every member of E(β,α) with `2 < β < log₂ 6`, (18) fails. -/
theorem osc_fails {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ : 2 < β) (hβ6 : β < Real.logb 2 6) :
    ¬ HypOscillations gU := by
  refine osc_fails_of_rpow hU hgrad (by linarith) ?_
  have h : (2 : ℝ) ^ (Real.logb 2 6 - 1) = 3 := by
    rw [Real.rpow_sub (by norm_num), Real.rpow_logb (by norm_num) (by norm_num) (by norm_num)]
    norm_num
  rw [← h]
  exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)

/-- Converse (gate claim for `β ≥ log₂ 6`): (18) holds for every member, with `C = 2R + 1`.
`‖·‖` covers negative `y` (no sign condition is needed in dimension one). -/
theorem osc_holds {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ1 : 1 < β) (hβ6 : Real.logb 2 6 ≤ β) :
    HypOscillations gU := by
  have hα : 0 < α := hU.1
  obtain ⟨R, hR, hn⟩ := tail_norm hU hgrad hβ1
  have h3 : (3 : ℝ) ≤ 2 ^ (β - 1) := by
    have h : (2 : ℝ) ^ (Real.logb 2 6 - 1) = 3 := by
      rw [Real.rpow_sub (by norm_num), Real.rpow_logb (by norm_num) (by norm_num) (by norm_num)]
      norm_num
    rw [← h]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  refine ⟨2 * R + 1, fun x y hxy hCx => ?_⟩
  have hxR : R < ‖x‖ := by linarith
  have hyR : R < ‖y‖ := by linarith [norm_nonneg x]
  rw [hn x hxR, hn y hyR]
  have hxpos : 0 < ‖x‖ := lt_of_le_of_lt hR hxR
  have hmono : (2 * ‖x‖) ^ (β - 1) ≤ ‖y‖ ^ (β - 1) :=
    Real.rpow_le_rpow (by positivity) hxy (by linarith)
  rw [Real.mul_rpow (by norm_num) hxpos.le] at hmono
  have hb : 0 < α * β := by have : 0 < β := by linarith
                            positivity
  have hxp : 0 < ‖x‖ ^ (β - 1) := by positivity
  have h4 : 3 * ‖x‖ ^ (β - 1) ≤ ‖y‖ ^ (β - 1) :=
    le_trans (mul_le_mul_of_nonneg_right h3 hxp.le) hmono
  nlinarith [mul_le_mul_of_nonneg_left h4 hb.le]

/-- The step TEX:806 consumes for β > 2: "every member of E(β,α) with β > 2 satisfies (18)".
Word for word the type of `Paper.C01.C01_S2`. -/
def S2Printed : Prop :=
  ∀ (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1), InExpFam β α U → IsGradField U gU → 2 < β →
    HypOscillations gU

/-- Witness: β = 5/2, α = 1, U = ‖x‖^{5/2}, gU = (5/2)‖x‖^{1/2} x; in the class with M = 0, c = 1. -/
lemma witness_inExpFam : InExpFam (5 / 2) 1 (fun x : E 1 => ‖x‖ ^ ((5 : ℝ) / 2)) := by
  refine ⟨one_pos, by norm_num, ?_, 0, 1, one_pos, fun x _ => by simp [piDens]⟩
  unfold piDens
  exact ((contDiff_norm_rpow (by norm_num : (1 : ℝ) < 5 / 2)).neg).exp

lemma witness_grad : IsGradField (fun x : E 1 => ‖x‖ ^ ((5 : ℝ) / 2))
    (fun x => ((1 : ℝ) * (5 / 2) * ‖x‖ ^ ((5 : ℝ) / 2 - 2)) • x) := by
  intro x
  exact (hasGradientAt_pow 1 0 (5 / 2) (by norm_num) x).congr_of_eventuallyEq
    (Eventually.of_forall fun y => by simp)

theorem not_S2Printed : ¬ S2Printed := by
  intro h
  have hβ6 : (5 / 2 : ℝ) < Real.logb 2 6 := by
    rw [Real.lt_logb_iff_rpow_lt (by norm_num) (by norm_num)]
    have : (2 : ℝ) ^ ((5 : ℝ) / 2) = 4 * Real.sqrt 2 := by
      rw [show (5 : ℝ) / 2 = 2 + 1 / 2 by norm_num, Real.rpow_add (by norm_num),
        Real.sqrt_eq_rpow]
      norm_num
    rw [this]
    nlinarith [Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num), Real.sqrt_nonneg 2]
  exact osc_fails witness_inExpFam witness_grad (by norm_num) hβ6
    (h _ _ _ _ witness_inExpFam witness_grad (by norm_num))

/-- Scope check: `C01_S2` (draft) has exactly the type `S2Printed` unfolded, so `not_S2Printed`
refutes precisely the obligation TEX:806 needs on the β > 2 branch, nothing stronger. -/
theorem consumed_of_printed
    (hS2 : ∀ (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1), InExpFam β α U →
      IsGradField U gU → 2 < β → HypOscillations gU) : S2Printed := hS2

end Paper.C01.Issue1
