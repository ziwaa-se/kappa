import L02Stmt

/-!
# L02 issue 1: counterexample to the "if" direction of Lemma 4.10 as printed

Source: `source/SuperParetoPaper-v12.tex:359-366` (Lemma 4.10, lem:inv-NWU), read against
Definition 4.9 at `:344-353`, whose preamble (F:346) requires `F_X(0) = 0`.
Instance: `X = 0` almost surely, i.e. the law `Measure.dirac 0`.
Compare `pv_work/L01_Counterexample1.lean` (same pattern for Lemma 2.3).
-/

namespace Paper.L02

open MeasureTheory ProbabilityTheory Paper.L01

/-- The "if" direction of Lemma 4.10 as printed (F:361-364): every random variable `X`
(law `μ`, a probability measure on `ℝ`) satisfying (eq:inv-NWU) is super-heavy-tailed
(Def 4.9(1), F:346-349). No printed hypothesis is dropped; none is added. -/
def PrintedIfClause : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], InvNWUCond μ → IsSuperHeavyTailed μ

/-- The cdf of `X = 0` a.s. is `1` on `[0, ∞)`. -/
lemma F_dirac_zero_of_nonneg' {y : ℝ} (hy : 0 ≤ y) : F (Measure.dirac (0 : ℝ)) y = 1 := by
  unfold F
  rw [cdf_eq_real]
  simp [Measure.real, Measure.dirac_apply' _ measurableSet_Iic, Set.indicator, hy]

/-- `X = 0` a.s. satisfies every printed hypothesis: (eq:inv-NWU) reads `1 * 1 ≤ 1`. -/
lemma invNWUCond_dirac_zero : InvNWUCond (Measure.dirac (0 : ℝ)) := by
  intro x hx θ hθ
  have h1 : 0 ≤ x / θ := div_nonneg hx hθ.1.le
  have h2 : 0 ≤ x / (1 - θ) := div_nonneg hx (by linarith [hθ.2])
  rw [F_dirac_zero_of_nonneg' h1, F_dirac_zero_of_nonneg' h2, F_dirac_zero_of_nonneg' hx]
  norm_num

/-- Scope: the failure is only in the `F_X(0)=0` conjunct; the subadditivity part of
Def 4.9(1) holds for `X = 0` a.s. (`-Log F(1/x) = -log 1 = 0` for `x > 0`). -/
lemma subadditive_dirac_zero :
    SubadditiveOnE (negLogInv (Measure.dirac (0 : ℝ))) (Set.Ioi 0) := by
  intro x hx y hy
  have hxy : (0 : ℝ) < x + y := add_pos hx hy
  simp only [negLogInv]
  rw [F_dirac_zero_of_nonneg' (one_div_pos.mpr hx).le,
    F_dirac_zero_of_nonneg' (one_div_pos.mpr hy).le,
    F_dirac_zero_of_nonneg' (one_div_pos.mpr hxy).le]
  simp

/-- `X = 0` a.s. is not super-heavy-tailed: `F_X(0) = 1 ≠ 0`. -/
lemma not_superHeavy_dirac_zero : ¬ IsSuperHeavyTailed (Measure.dirac (0 : ℝ)) := by
  intro h
  have h0 := h.1
  rw [F_dirac_zero_of_nonneg' le_rfl] at h0
  norm_num at h0

/-- The printed "if" direction is false. -/
theorem L02_if_counterexample : ¬ PrintedIfClause := by
  intro h
  exact not_superHeavy_dirac_zero (h (Measure.dirac (0 : ℝ)) invNWUCond_dirac_zero)

/-- Scope (consumed_of_printed): the printed biconditional (the gated `L02_main`,
quantified over all laws) implies the printed "if" clause. -/
theorem printedIf_of_printedIff
    (h : ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], IsSuperHeavyTailed μ ↔ InvNWUCond μ) :
    PrintedIfClause := by
  intro μ _ hS
  exact (h μ).2 hS

/-- The gated statement `L02_main` (L02Draft.lean:10-11), universally quantified, is false. -/
theorem L02_main_as_printed_false :
    ¬ (∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], IsSuperHeavyTailed μ ↔ InvNWUCond μ) :=
  fun h => L02_if_counterexample (printedIf_of_printedIff h)

/-- The prover's gap proposition (`L02_main_Gap`, pv_work/notes/L02_prover_notes.md:22) is false. -/
theorem prover_gap_false :
    ¬ (∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], InvNWUCond μ → F μ 0 = 0) := by
  intro h
  have h0 := h (Measure.dirac (0 : ℝ)) invNWUCond_dirac_zero
  rw [F_dirac_zero_of_nonneg' le_rfl] at h0
  norm_num at h0

end Paper.L02
