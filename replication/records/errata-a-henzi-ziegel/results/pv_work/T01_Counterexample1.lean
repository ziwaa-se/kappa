import T01ModGaps

/-!
# T01 issue 1: counterexample to the printed step at source/VSIFP_02.tex:419

l.419: "It follows from (eq:evalueCond) and (eq:ratio) that E(0) ∈ (0,1)", in the case p < q
(l.403), for E an e-value with null H_S and alternative [0,1] \ H_S (l.407-409), under the
hypotheses of Theorem 3.1 (l.145).

Instance: ν = δ_{1/2} (a locally finite Borel measure on (0,1)), S = ∫ S_θ dν = S_{1/2},
p = 1/4, q = 3/4, E = E_{p,q;1} (λ = 1, allowed by the theorem, l.145).  Then E(0) = 0.
-/

open MeasureTheory

namespace Paper.T01.Issue1

/-- The printed clause of l.419, in its context: hypotheses of Theorem 3.1 (l.145) with the
case assumption p < q (l.403), E an e-value with null H_S and alternative [0,1] \ H_S
(l.407-409); conclusion E(0) ∈ (0,1). -/
def PrintedClause_l419 : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → MixtureRep S ν →
  ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p < q →
    0 < ν (Set.Ico (min p q) (max p q)) →
  ∀ E : ℝ → ℝ, IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) →
    E 0 ∈ Set.Ioo (0:ℝ) 1

noncomputable def ν0 : Measure ℝ := Measure.dirac (1/2 : ℝ)
noncomputable def S0 : ℝ → ℝ → ℝ := mixtureScore ν0

lemma restrict_ν0 : ν0.restrict (Set.Icc (0:ℝ) 1) = ν0 := by
  classical
  rw [ν0, MeasureTheory.restrict_dirac, if_pos (by norm_num : (1/2:ℝ) ∈ Set.Icc (0:ℝ) 1)]

lemma S0_eq (p y : ℝ) : S0 p y = elemScore (1/2) p y := by
  simp only [S0, mixtureScore]
  rw [restrict_ν0, ν0, integral_dirac]

lemma S0_zero (p : ℝ) : S0 p 0 = if (1/2:ℝ) < p then 1/2 else 0 := by
  rw [S0_eq, elemScore]
  split_ifs <;> norm_num at *

lemma S0_one (p : ℝ) : S0 p 1 = if (1/2:ℝ) < p then 0 else 1/2 := by
  rw [S0_eq, elemScore]
  split_ifs <;> norm_num at *

lemma S0_cons : IsConsistent S0 := by
  intro p hp π hπ
  obtain ⟨hπ0, hπ1⟩ := hπ
  simp only [expPi, S0_zero, S0_one]
  split_ifs <;> nlinarith

lemma ν0_mixing : IsMixingMeasure ν0 := by
  refine ⟨?_, fun K _ _ => by rw [ν0]; exact measure_lt_top _ _⟩
  rw [ν0, Measure.dirac_apply]
  have : (1/2:ℝ) ∉ (Set.Ioo (0:ℝ) 1)ᶜ := by
    simp only [Set.mem_compl_iff, not_not]; norm_num
  simp [Set.indicator, this] <;> norm_num

lemma S0_rep : MixtureRep S0 ν0 := by
  refine ⟨ν0_mixing, fun p _ y _ => ⟨?_, rfl⟩⟩
  unfold IntegrableOn
  rw [restrict_ν0, ν0]
  exact integrable_dirac

lemma ν0_pos : 0 < ν0 (Set.Ico (min (1/4:ℝ) (3/4)) (max (1/4:ℝ) (3/4))) := by
  rw [min_eq_left (by norm_num), max_eq_right (by norm_num), ν0,
    Measure.dirac_apply_of_mem (by norm_num)]
  exact zero_lt_one

/-- The consumed instance: E = E_{1/4,3/4;1}. -/
noncomputable def E0 : ℝ → ℝ := Erep S0 (1/4) (3/4) 1

lemma E0_evalue : IsEValue E0 (HS S0 (1/4) (3/4)) (Set.Icc (0:ℝ) 1 \ HS S0 (1/4) (3/4)) :=
  T01_S2 S0 ν0 S0_cons S0_rep (1/4) (3/4) (by norm_num) (by norm_num) (by norm_num) ν0_pos 1
    (by norm_num)

lemma E0_at_zero : E0 0 = 0 := by
  simp only [E0, Erep]
  norm_num [S0_zero, S0_one]
  rw [abs_of_pos (by norm_num : (0:ℝ) < 1/2)]; norm_num

/-- The instance lies inside the theorem's conclusion (λ = 1 ∈ (0,1]): the theorem itself is
not contradicted. -/
lemma E0_in_family : ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ),
    E0 y = Erep S0 (1/4) (3/4) lam y :=
  ⟨1, ⟨by norm_num, le_rfl⟩, fun _ _ => rfl⟩

/-- **The printed clause of l.419 is false.** -/
theorem not_PrintedClause_l419 : ¬ PrintedClause_l419 := by
  intro h
  have := h S0 ν0 S0_cons S0_rep (1/4) (3/4) (by norm_num) (by norm_num) (by norm_num) ν0_pos
    E0 E0_evalue
  rw [E0_at_zero] at this
  exact lt_irrefl _ this.1

/-- Scope check: the gate-approved obligation S8 (`T01_S8_Gap`) implies the printed clause,
so the refutation of the printed clause also refutes S8 and is not stronger than S8. -/
theorem printed_of_S8Gap (h8 : T01_S8_Gap) : PrintedClause_l419 := by
  intro S ν hcons hrep p q hp hq hpq hν E hE
  rw [min_eq_left hpq.le, max_eq_right hpq.le] at hν
  have hd := T01_S3 S ν hcons hrep p q hp hq hpq hν
  have h5 := T01_S5 S p q E hE
  have h6 := T01_S6 S p q E hd h5
  exact h8 S p q E hd h5 h6

theorem not_S8Gap : ¬ T01_S8_Gap := fun h => not_PrintedClause_l419 (printed_of_S8Gap h)

/-- Mirror instance for the case p > q (l.423 "similar arguments"): the mirrored step
"E(1) ∈ (0,1)" fails for E = E_{3/4,1/4;1}.  This refutes only the mirror of l.419,
not the printed conclusion of l.423-426. -/
lemma mirror_E1_zero : Erep S0 (3/4) (1/4) 1 1 = 0 := by
  simp only [Erep]
  norm_num [S0_zero, S0_one]
  rw [abs_of_pos (by norm_num : (0:ℝ) < 1/2)]; norm_num

lemma mirror_evalue : IsEValue (Erep S0 (3/4) (1/4) 1) (HS S0 (3/4) (1/4))
    (Set.Icc (0:ℝ) 1 \ HS S0 (3/4) (1/4)) := by
  refine T01_S2 S0 ν0 S0_cons S0_rep (3/4) (1/4) (by norm_num) (by norm_num) (by norm_num) ?_ 1
    (by norm_num)
  rw [min_eq_right (by norm_num), max_eq_left (by norm_num), ν0,
    Measure.dirac_apply_of_mem (by norm_num)]
  exact zero_lt_one

/-- Suggested fix check (constructed by the reviewer, not in the source, suggestion only, not used
in any verification): under the hypotheses of S8, E(0) ∈ [0,1). -/
theorem S8_corrected_range (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h : 0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0))
    (hr : E 1 ≠ E 0 ∧ (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) =
      (E 0 - 1) / (E 1 - E 0)) :
    E 0 ∈ Set.Ico (0:ℝ) 1 := by
  obtain ⟨hd0, hd1⟩ := hd
  obtain ⟨h0, _, hiff⟩ := h
  obtain ⟨_, hrat⟩ := hr
  have hE0 : E 0 ≤ 1 := by
    have := (hiff 0 ⟨le_rfl, zero_le_one⟩).2 (by simp only [expPi]; linarith)
    simp only [expPi] at this; linarith
  refine ⟨h0, lt_of_le_of_ne hE0 ?_⟩
  intro heq
  rw [heq, sub_self, zero_div] at hrat
  have hδ : 0 < (S p 1 - S q 1) - (S p 0 - S q 0) := by linarith
  have : (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) < 0 := div_neg_of_neg_of_pos hd0 hδ
  linarith

end Paper.T01.Issue1
