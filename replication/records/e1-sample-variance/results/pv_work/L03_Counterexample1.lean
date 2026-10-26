import L03Stmt

/-!
L03 issue 1: counterexample to Lemma lem:raw, source/main.tex:85-87.
Printed: "Suppose that n ≥ 2. Then s^2 ≤ (1/n) ∑_{i=1}^n x_i^2", with
s^2 = (1/(n-1)) ∑ (x_i - x̄)^2 (main.tex:35).
Instance: n = 2, x = (1, -1). Then x̄ = 0, s^2 = 2, (1/n) ∑ x_i^2 = 1.
-/

namespace Paper.L03

/-- The clause printed at source/main.tex:86, verbatim against the gated statement
`Paper.L03.Conclusion` (L03Stmt.lean): for every `n ≥ 2` and every `x ∈ ℝ^n`,
`s^2 ≤ (1/n) ∑ x_i^2`. Same shape as the gated `L03_main` (L03Draft.lean:30). -/
def PrintedClause : Prop :=
  ∀ {n : ℕ} (_hn : 2 ≤ n) (x : Sample n), Conclusion x

/-- The version actually consumed downstream (Corollary cor:unit, main.tex:99):
the lemma applied to samples with `|x_i| ≤ 1`. Extra premise, so weaker. -/
def ConsumedByC01 : Prop :=
  ∀ {n : ℕ} (_hn : 2 ≤ n) (x : Sample n), (∀ i, |x i| ≤ 1) → Conclusion x

theorem consumed_of_printed (h : PrintedClause) : ConsumedByC01 :=
  fun hn x _ => h hn x

/-- The instance `x = (1, -1)`. -/
noncomputable def x0 : Sample 2 := ![1, -1]

theorem x0_mean : sampleMean x0 = 0 := by
  simp [sampleMean, x0, Fin.sum_univ_two]

theorem x0_var : sampleVar x0 = 2 := by
  simp [sampleVar, sampleMean, x0, Fin.sum_univ_two]
  norm_num

theorem x0_rhs : (1 / ((2 : ℕ) : ℝ)) * ∑ i, (x0 i) ^ 2 = 1 := by
  simp [x0, Fin.sum_univ_two]
  norm_num

/-- The instance satisfies the printed hypothesis `n ≥ 2`, and also `|x_i| ≤ 1`
(the extra hypothesis of the consumed version). -/
theorem x0_bounded : ∀ i, |x0 i| ≤ 1 := by
  intro i
  fin_cases i <;> simp [x0]

theorem x0_not_conclusion : ¬ Conclusion x0 := by
  unfold Conclusion
  rw [x0_var, x0_rhs]
  norm_num

/-- Main counterexample: the printed clause of Lemma lem:raw is false. -/
theorem counterexample : ¬ PrintedClause := by
  intro h
  exact x0_not_conclusion (h (by norm_num) x0)

/-- Even the weaker version consumed by Corollary cor:unit is false. -/
theorem counterexample_consumed : ¬ ConsumedByC01 := by
  intro h
  exact x0_not_conclusion (h (by norm_num) x0 x0_bounded)

/-- The step at main.tex:91 in isolation: the premise produced at main.tex:90 holds
at the instance, while the claimed result of "dividing by n" fails. -/
theorem step91_premise_holds :
    ((2 : ℝ) - 1) * sampleVar x0 ≤ ∑ i, (x0 i) ^ 2 := by
  rw [x0_var]
  simp [x0, Fin.sum_univ_two]
  norm_num

/-- Corollary cor:unit's proof (main.tex:99) asserts `s^2 ≤ 1` as an intermediate;
at the instance `s^2 = 2`, so that intermediate fails, while the corollary's own
printed conclusion `s^2 ≤ 2` holds with equality. -/
theorem x0_C01_intermediate_fails : ¬ sampleVar x0 ≤ 1 := by
  rw [x0_var]; norm_num

theorem x0_C01_conclusion_holds : sampleVar x0 ≤ 2 := by
  rw [x0_var]

end Paper.L03
