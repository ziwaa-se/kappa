import L01Stmt

/-!
# L01 issue 1: counterexample to the "if" direction of Lemma 2.3 as printed

Source: `source/SuperParetoPaper-v12.tex:128-135` (Lemma 2.3, lem:ITS-carac), read against
Definition 2.2 at `:122-124`, which requires `F_X(0) = 0`.
Instance: `X = 0` almost surely, i.e. the law `Measure.dirac 0`.
-/

namespace Paper.L01

open MeasureTheory ProbabilityTheory

/-- The "if" direction of Lemma 2.3 as printed (F:130-133): every random variable `X`
(law `μ`, a probability measure on `ℝ`, F:119) satisfying (eq:sub-1x) is ITS (Def 2.2,
F:124). No hypothesis beyond those printed at F:130 is dropped; none is added. -/
def PrintedIfClause : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], SubCond μ → IsInvSub μ

/-- The cdf of `X = 0` a.s. is `1` on `[0, ∞)`. -/
lemma F_dirac_zero_of_nonneg {y : ℝ} (hy : 0 ≤ y) : F (Measure.dirac (0 : ℝ)) y = 1 := by
  unfold F
  rw [cdf_eq_real]
  simp [Measure.real, Measure.dirac_apply' _ measurableSet_Iic, Set.indicator, hy]

/-- `X = 0` a.s. satisfies every printed hypothesis: (eq:sub-1x) holds (it reads `2 ≤ 2`). -/
lemma subCond_dirac_zero : SubCond (Measure.dirac (0 : ℝ)) := by
  intro x hx θ hθ
  have h1 : 0 ≤ x / θ := div_nonneg hx hθ.1.le
  have h2 : 0 ≤ x / (1 - θ) := div_nonneg hx (by linarith [hθ.2])
  rw [F_dirac_zero_of_nonneg h1, F_dirac_zero_of_nonneg h2, F_dirac_zero_of_nonneg hx]

/-- Scope: the failure is only in the `F_X(0)=0` conjunct of Def 2.2; the subadditivity
part of Def 2.2 does hold for `X = 0` a.s. -/
lemma subadditive_dirac_zero :
    SubadditiveOn (invDist (F (Measure.dirac (0 : ℝ)))) (Set.Ioi 0) := by
  intro x hx y hy
  have hxy : (0 : ℝ) < x + y := add_pos hx hy
  simp only [invDist]
  rw [F_dirac_zero_of_nonneg (one_div_pos.mpr hx).le,
    F_dirac_zero_of_nonneg (one_div_pos.mpr hy).le,
    F_dirac_zero_of_nonneg (one_div_pos.mpr hxy).le]
  norm_num

/-- `X = 0` a.s. is not ITS: `F_X(0) = 1 ≠ 0`. -/
lemma not_isInvSub_dirac_zero : ¬ IsInvSub (Measure.dirac (0 : ℝ)) := by
  intro h
  have h0 := h.1
  rw [F_dirac_zero_of_nonneg le_rfl] at h0
  norm_num at h0

/-- The printed "if" direction is false. -/
theorem L01_if_counterexample : ¬ PrintedIfClause := by
  intro h
  exact not_isInvSub_dirac_zero (h (Measure.dirac (0 : ℝ)) subCond_dirac_zero)

/-- Scope (consumed_of_printed): the printed biconditional `L01_main` implies the printed
"if" clause, so the counterexample refutes the lemma as printed. -/
theorem printedIf_of_printedIff
    (h : ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], IsInvSub μ ↔ SubCond μ) :
    PrintedIfClause := by
  intro μ _ hS
  exact (h μ).2 hS

/-- Scope (consumed_of_printed): the version consumed in Thm 2.6 (F:180), namely
"(eq:sub-1x) for the law of `h(X)` implies `h(X)` is ITS", is an instance of the
printed clause, so it is exactly what is refuted. -/
theorem consumed_of_printed (h : PrintedIfClause) (ν : Measure ℝ) [IsProbabilityMeasure ν]
    (hS : SubCond ν) : IsInvSub ν :=
  h ν hS

theorem L01_main_as_printed_false :
    ¬ (∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], IsInvSub μ ↔ SubCond μ) :=
  fun h => L01_if_counterexample (printedIf_of_printedIff h)

end Paper.L01
