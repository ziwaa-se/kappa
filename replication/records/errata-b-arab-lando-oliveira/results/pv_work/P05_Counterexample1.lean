import P05Stmt

/-!
# P05 issue 1: counterexample to the "if" direction of Prop cor:invNWU as printed

Source: `source/SuperParetoPaper-v12.tex:429-436` (Prop cor:invNWU), read against
Def 4.9 (F:344-353, preamble F:346 requires `F_X(0)=0`) and Def 5.1 (F:422-425).
Instance: `X = 0` almost surely, i.e. the law `Measure.dirac 0`.
Definitions are the gate-approved ones of `P05Stmt` / `L02Stmt` (unchanged).
-/

namespace Paper.P05

open MeasureTheory ProbabilityTheory Filter Topology Paper.L01 Paper.L02

/-- The "if" direction of Prop cor:invNWU as printed (F:431): every random variable `X`
(law `μ`, a probability measure) with `F_X ≤_{i-sb} ℋ` is super-heavy-tailed. -/
def PrintedIfClause : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], InvSubLE (F μ) Hcdf → IsSuperHeavyTailed μ

lemma F_dirac0_nonneg {y : ℝ} (hy : 0 ≤ y) : F (Measure.dirac (0 : ℝ)) y = 1 := by
  unfold F
  rw [cdf_eq_real]
  simp [Measure.real, Measure.dirac_apply' _ measurableSet_Iic, Set.indicator, hy]

lemma F_dirac0_neg {y : ℝ} (hy : y < 0) : F (Measure.dirac (0 : ℝ)) y = 0 := by
  unfold F
  rw [cdf_eq_real]
  have : ¬ (0 : ℝ) ≤ y := not_le.mpr hy
  simp [Measure.real, Measure.dirac_apply' _ measurableSet_Iic, Set.indicator, this]

/-- `F^-(t) = P(X < t) = 1` for `t > 0`. -/
lemma leftVer_dirac0_pos {t : ℝ} (ht : 0 < t) :
    leftVer (F (Measure.dirac (0 : ℝ))) t = 1 := by
  unfold leftVer
  apply leftLim_eq_of_tendsto (NeBot.ne inferInstance)
  apply tendsto_const_nhds.congr'
  filter_upwards [Ioo_mem_nhdsLT ht] with u hu
  exact (F_dirac0_nonneg hu.1.le).symm

/-- `F^-(t) = P(X < t) = 0` for `t < 0`. -/
lemma leftVer_dirac0_neg {t : ℝ} (ht : t < 0) :
    leftVer (F (Measure.dirac (0 : ℝ))) t = 0 := by
  unfold leftVer
  apply leftLim_eq_of_tendsto (NeBot.ne inferInstance)
  apply tendsto_const_nhds.congr'
  filter_upwards [Ioo_mem_nhdsLT (show t - 1 < t by linarith)] with u hu
  exact (F_dirac0_neg (hu.2.trans ht)).symm

/-- `ℋ^{-1}(1) = +∞` (generalised inverse, F:111): `ℋ < 1` everywhere. -/
lemma genInv_H_one : genInv Hcdf 1 = ⊤ := by
  unfold genInv
  rw [sSup_eq_top]
  intro b hb
  obtain ⟨r, hr1, _⟩ := EReal.lt_iff_exists_real_btwn.mp hb
  refine ⟨(r : EReal), ⟨r, ?_, rfl⟩, hr1⟩
  show Hcdf r ≤ 1
  unfold Hcdf
  split_ifs with h
  · rw [Real.exp_le_one_iff]
    have : 0 < 1 / r := by positivity
    linarith
  · norm_num

/-- `ℋ^{-1}(0) = 0`. Only used for the alternative domain reading `ℝ∖{0}`. -/
lemma genInv_H_zero : genInv Hcdf 0 = 0 := by
  unfold genInv
  have h : IsGreatest ((fun x : ℝ => (x : EReal)) '' {x : ℝ | Hcdf x ≤ 0}) (0 : EReal) := by
    constructor
    · exact ⟨0, by simp [Hcdf], by simp⟩
    · rintro _ ⟨x, hx, rfl⟩
      have : x ≤ 0 := by
        by_contra hpos
        push_neg at hpos
        have e : Hcdf x = Real.exp (-(1 / x)) := by simp [Hcdf, hpos]
        have h2 := Real.exp_pos (-(1 / x))
        simp only [Set.mem_setOf_eq] at hx
        linarith
      show ((x : ℝ) : EReal) ≤ 0
      exact_mod_cast this
  exact h.csSup_eq

/-- The order function of Def 5.1 for `X = 0` a.s. is `0` on `(0,∞)`. -/
lemma invSubFn_dirac0_pos {x : ℝ} (hx : 0 < x) :
    invSubFn (F (Measure.dirac (0 : ℝ))) Hcdf x = 0 := by
  unfold invSubFn
  rw [leftVer_dirac0_pos (one_div_pos.mpr hx), genInv_H_one]
  rfl

/-- ... and `+∞` on `(-∞,0)`. -/
lemma invSubFn_dirac0_neg {x : ℝ} (hx : x < 0) :
    invSubFn (F (Measure.dirac (0 : ℝ))) Hcdf x = ⊤ := by
  unfold invSubFn
  rw [leftVer_dirac0_neg (one_div_neg.mpr hx), genInv_H_zero]
  show (if (0:ℝ) = 0 then ⊤ else (((1:ℝ) / 0 : ℝ) : EReal)) = ⊤
  simp

/-- Every printed hypothesis holds: `F_X ≤_{i-sb} ℋ` (domain `(0,∞)`, as gated). -/
lemma invSubLE_dirac0 : InvSubLE (F (Measure.dirac (0 : ℝ))) Hcdf := by
  intro x hx y hy
  have hx : (0:ℝ) < x := hx
  have hy : (0:ℝ) < y := hy
  rw [invSubFn_dirac0_pos (add_pos hx hy), invSubFn_dirac0_pos hx, invSubFn_dirac0_pos hy]
  simp

/-- Robustness to the domain reading (gate item 4): the order function is also subadditive on
`ℝ∖{0}` (pairs with `x, y, x+y ≠ 0`), so the instance does not depend on our choice `(0,∞)`. -/
lemma invSub_dirac0_punctured :
    ∀ x y : ℝ, x ≠ 0 → y ≠ 0 → x + y ≠ 0 →
      invSubFn (F (Measure.dirac (0 : ℝ))) Hcdf (x + y) ≤
        invSubFn (F (Measure.dirac (0 : ℝ))) Hcdf x +
          invSubFn (F (Measure.dirac (0 : ℝ))) Hcdf y := by
  intro x y hx hy hxy
  have val : ∀ z : ℝ, z ≠ 0 → 0 ≤ invSubFn (F (Measure.dirac (0 : ℝ))) Hcdf z := by
    intro z hz
    rcases lt_or_gt_of_ne hz with h | h
    · rw [invSubFn_dirac0_neg h]; exact le_top
    · rw [invSubFn_dirac0_pos h]
  rcases lt_or_gt_of_ne hxy with h | h
  · -- x + y < 0: one of x, y is negative, so the right side is `+∞`
    rcases lt_or_gt_of_ne hx with hx' | hx'
    · rw [invSubFn_dirac0_neg hx', EReal.top_add_of_ne_bot (ne_bot_of_le_ne_bot
        EReal.zero_ne_bot (val y hy))]
      exact le_top
    · have hy' : y < 0 := by linarith
      rw [invSubFn_dirac0_neg hy', EReal.add_top_of_ne_bot (ne_bot_of_le_ne_bot
        EReal.zero_ne_bot (val x hx))]
      exact le_top
  · rw [invSubFn_dirac0_pos h]
    exact add_nonneg (val x hx) (val y hy)

/-- Scope: the subadditivity conjunct of Def 4.9(1) also holds for `X = 0` a.s.
(`-Log F(1/x) = -log 1 = 0`), so the failure is exactly the omitted `F_X(0)=0`. -/
lemma subadditive_negLogInv_dirac0 :
    SubadditiveOnE (negLogInv (Measure.dirac (0 : ℝ))) (Set.Ioi 0) := by
  intro x hx y hy
  have hx : (0:ℝ) < x := hx
  have hy : (0:ℝ) < y := hy
  simp only [negLogInv]
  rw [F_dirac0_nonneg (one_div_pos.mpr hx).le, F_dirac0_nonneg (one_div_pos.mpr hy).le,
    F_dirac0_nonneg (one_div_pos.mpr (add_pos hx hy)).le]
  simp

/-- `X = 0` a.s. is not super-heavy-tailed: `F_X(0) = 1 ≠ 0` (Def 4.9 preamble, F:346). -/
lemma not_superHeavy_dirac0 : ¬ IsSuperHeavyTailed (Measure.dirac (0 : ℝ)) := by
  intro h
  have h0 := h.1
  rw [F_dirac0_nonneg le_rfl] at h0
  norm_num at h0

/-- The printed "if" direction of Prop cor:invNWU is false. -/
theorem P05_if_counterexample : ¬ PrintedIfClause := by
  intro h
  exact not_superHeavy_dirac0 (h (Measure.dirac (0 : ℝ)) invSubLE_dirac0)

/-- Scope (consumed_of_printed): the printed biconditional implies the printed "if" clause. -/
theorem printedIf_of_printedIff
    (h : ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], P05Conclusion μ) : PrintedIfClause := by
  intro μ _ hO
  exact (h μ).2 hO

/-- The printed proposition, quantified over probability laws, is false. -/
theorem P05_as_printed_false :
    ¬ (∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], P05Conclusion μ) :=
  fun h => P05_if_counterexample (printedIf_of_printedIff h)

/-- The gated target `P05_main` (`∀ μ, P05Conclusion μ`, = prover's `P05_main_Gap`) is false. -/
theorem P05_main_gap_false : ¬ (∀ μ : Measure ℝ, P05Conclusion μ) :=
  fun h => P05_as_printed_false (fun μ _ => h μ)

end Paper.P05
