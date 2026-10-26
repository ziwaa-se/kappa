import T03_Counterexample1
import P04_Counterexample2
import T01_Counterexample1

/-!
# T03 issue 2: the step at source :337 "X =ᵈ h(Y), h increasing convex and h(0)=0"

Source `source/SuperParetoPaper-v12.tex:337`: "Given the shift invariance of the convex transform
order, X being super-Pareto is equivalent to X =ᵈ h(Y), where h is increasing convex and h(0)=0,
hence h is star-shaped." Here `Y = Z - 1`, `F_Z = 𝒫` (law `Paper.T03.lawY`).

* `not_PrintedStep337`: the forward direction consumed by the proof (for nonnegative
  super-Pareto X there is such an h with h(0)=0) is false at X = Z (Pareto(1) itself).
* `isInvSub_Z`: at that very X the conclusion of Thm 4.8 holds (Z is ITS, as :279 says), so this
  instance shows the step fails, not the theorem (the theorem fails by issue 1).
* `not_DraftS3b`: the draft obligation `T03_S3b` (∀-form) is false (g y = y + 1).
* `not_T03_T01Consumed`: the consumed clause (Thm 2.8 at Y) is refutable (g y = max (y-1) 0).
-/

open MeasureTheory ProbabilityTheory Set Paper.L01
open Paper.T03.Issue1

namespace Paper.T03.Issue2

/-- Forward direction of the claim printed at :337, for nonnegative X (only direction used). -/
def PrintedStep337 : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], Paper.P04.SuperPareto μ → Nonneg μ →
    ∃ g : ℝ → ℝ, MonotoneOn g (Ici 0) ∧ ConvexOn ℝ (Ici 0) g ∧ g 0 = 0 ∧ μ = lawY.map g

/-- Draft obligation `T03_S3b` (pv_work/T03Draft.lean:32-34), as a closed proposition. -/
def DraftS3b : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], Nonneg μ → ∀ g : ℝ → ℝ,
    MonotoneOn g (Ici 0) → ConvexOn ℝ (Ici 0) g → μ = lawY.map g → g 0 = 0

/-! ## X = Z satisfies the printed hypotheses -/

lemma sp_Z : Paper.P04.SuperPareto Paper.P04.paretoMeasure :=
  ⟨id, measurable_id, monotone_id.monotoneOn _, convexOn_id (convex_Ici 1),
    ⟨1, by norm_num, 2, by norm_num, by norm_num⟩, Measure.map_id.symm⟩

lemma nonneg_Z : Nonneg Paper.P04.paretoMeasure := by
  unfold Nonneg
  rw [pm_eq]
  exact measure_mono_null (fun z hz => by simp only [mem_Iio] at hz; simp only [mem_Iic]; linarith)
    Iic_one

/-! ## The printed step is false at X = Z -/

theorem not_PrintedStep337 : ¬ PrintedStep337 := by
  intro H
  obtain ⟨g, -, hc, h0, hμ⟩ := H Paper.P04.paretoMeasure sp_Z nonneg_Z
  set c := max (g 1) 1 with hcdef
  have hc1 : 1 ≤ c := le_max_right _ _
  have hcpos : 0 < c := by linarith
  set ε := 1 / c with hεdef
  have hε0 : 0 < ε := by positivity
  have hε1 : ε ≤ 1 := by rw [hεdef, div_le_one hcpos]; exact hc1
  have hεc : ε * c = 1 := by rw [hεdef]; field_simp
  have key : ∀ y, 0 ≤ y → y ≤ ε → g y ≤ 1 := by
    intro y hy0 hyε
    have hconv := hc.2 (mem_Ici.2 (le_refl (0:ℝ))) (mem_Ici.2 (zero_le_one' ℝ))
      (show (0:ℝ) ≤ 1 - y by linarith) hy0 (show (1 - y) + y = 1 by ring)
    simp only [smul_eq_mul, mul_zero, zero_add, mul_one, h0] at hconv
    have t1 : y * g 1 ≤ y * c := mul_le_mul_of_nonneg_left (le_max_left _ _) hy0
    have t2 : y * c ≤ ε * c := mul_le_mul_of_nonneg_right hyε hcpos.le
    linarith
  by_cases hae : AEMeasurable g lawY
  · have h1 : lawY (g ⁻¹' Iic 1) ≤ (lawY.map g) (Iic 1) := Measure.le_map_apply hae _
    have h2 : Paper.P04.paretoMeasure ((fun z : ℝ => z - 1) ⁻¹' (g ⁻¹' Iic 1)) ≤
        lawY (g ⁻¹' Iic 1) := by
      unfold lawY
      exact Measure.le_map_apply (measurable_id.sub_const 1).aemeasurable _
    have h3 : (lawY.map g) (Iic 1) = 0 := by rw [← hμ, pm_eq]; exact Iic_one
    have hsub : Icc (1 + ε / 2) (1 + ε) ⊆ (fun z : ℝ => z - 1) ⁻¹' (g ⁻¹' Iic 1) := by
      intro z hz
      simp only [mem_preimage, mem_Iic]
      exact key _ (by linarith [hz.1]) (by linarith [hz.2])
    have hpos := Paper.P04.Issue2.pareto_Icc_pos (a := 1 + ε / 2) (b := 1 + ε)
      (by linarith) (by linarith)
    have := measure_mono (μ := Paper.P04.paretoMeasure) hsub
    have hle : Paper.P04.paretoMeasure (Icc (1 + ε / 2) (1 + ε)) ≤ 0 := by
      calc _ ≤ _ := this
        _ ≤ _ := h2
        _ ≤ _ := h1
        _ = 0 := h3
    exact absurd (le_antisymm hle (zero_le _)) hpos.ne'
  · have h0' : lawY.map g = 0 := Measure.map_of_not_aemeasurable hae
    have hu := measure_univ (μ := Paper.P04.paretoMeasure)
    rw [hμ, h0'] at hu
    simp at hu

/-! ## ... while the conclusion of Thm 4.8 holds at X = Z (copied from T02_Counterexample1) -/

lemma invDist_P (y : ℝ) (hy : 0 < y) : invDist (F μP) y = min y 1 := by
  unfold invDist
  rcases le_or_lt y 1 with h | h
  · rw [F_P_ge1 _ (by rw [le_div_iff₀ hy]; linarith), min_eq_left h]; field_simp
  · rw [F_P_le1 _ (by rw [div_le_iff₀ hy]; linarith), min_eq_right h.le]; norm_num

lemma isInvSub_Z : IsInvSub Paper.P04.paretoMeasure := by
  rw [pm_eq]
  refine ⟨F_P_le1 0 zero_le_one, ?_⟩
  intro x hx y hy
  have hx' : 0 < x := hx
  have hy' : 0 < y := hy
  rw [invDist_P _ (by linarith), invDist_P _ hx', invDist_P _ hy']
  have m1 := min_le_left (x + y) 1
  have m2 := min_le_right (x + y) 1
  rcases le_total x 1 with h1 | h1 <;> rcases le_total y 1 with h2 | h2
  · rw [min_eq_left h1, min_eq_left h2]; linarith
  · rw [min_eq_left h1, min_eq_right h2]; linarith
  · rw [min_eq_right h1, min_eq_left h2]; linarith
  · rw [min_eq_right h1, min_eq_right h2]; linarith

/-! ## The draft obligation S3b (∀-form) is false -/

lemma lawY_map_succ : lawY.map (fun y : ℝ => y + 1) = Paper.P04.paretoMeasure := by
  unfold lawY
  rw [Measure.map_map (by fun_prop) (by fun_prop)]
  have : ((fun y : ℝ => y + 1) ∘ fun z : ℝ => z - 1) = id := by funext z; simp
  rw [this, Measure.map_id]

theorem not_DraftS3b : ¬ DraftS3b := by
  intro H
  have := H Paper.P04.paretoMeasure nonneg_Z (fun y => y + 1)
    (fun a _ b _ hab => by simp only; linarith)
    ⟨convex_Ici 0, fun x _ y _ a b _ _ hab => by simp only [smul_eq_mul]; linarith⟩
    lawY_map_succ.symm
  norm_num at this

/-! ## The consumed clause `T03_T01Consumed` is refutable -/

instance lawY_prob : IsProbabilityMeasure lawY := by
  unfold lawY; exact isProbabilityMeasure_map (measurable_id.sub_const 1).aemeasurable

lemma F_lawY (x : ℝ) : F lawY x = F μP (x + 1) := by
  unfold lawY
  rw [F_map_pre _ (fun z : ℝ => z - 1) (measurable_id.sub_const 1) x (x + 1)
    (by ext z; simp only [mem_preimage, mem_Iic]; constructor <;> intro <;> linarith), pm_eq]

/-- Obligation S5 holds (Y is ITS). -/
lemma isInvSub_lawY : IsInvSub lawY := by
  refine ⟨by rw [F_lawY, zero_add]; exact F_P_le1 1 le_rfl, ?_⟩
  have key : ∀ s : ℝ, 0 < s → invDist (F lawY) s = s / (1 + s) := by
    intro s hs
    unfold invDist
    have hs' : 0 < 1 / s := one_div_pos.mpr hs
    rw [F_lawY, F_P_ge1 _ (by linarith)]
    have h1 : 1 / s + 1 ≠ 0 := by linarith
    have h2 : 1 + s ≠ 0 := by linarith
    field_simp
    try ring
  intro x hx y hy
  have hx' : (0:ℝ) < x := hx
  have hy' : (0:ℝ) < y := hy
  rw [key x hx', key y hy', key (x + y) (add_pos hx' hy')]
  have e : (x + y) / (1 + (x + y)) = x / (1 + (x + y)) + y / (1 + (x + y)) := by ring
  rw [e]
  apply add_le_add
  · exact div_le_div_of_nonneg_left hx'.le (by linarith) (by linarith)
  · exact div_le_div_of_nonneg_left hy'.le (by linarith) (by linarith)

lemma F_map_h0_zero : F (lawY.map Paper.T01.Issue1.h0) 0 = 1 / 2 := by
  rw [F_map_pre _ _ Paper.T01.Issue1.h0_cont.measurable 0 1
    (by ext z; simp [Paper.T01.Issue1.h0]), F_lawY, F_P_ge1 _ (by norm_num)]
  norm_num

theorem not_T03_T01Consumed : ¬ T03_T01Consumed := by
  intro H
  have := (H Paper.T01.Issue1.h0 Paper.T01.Issue1.h0_cont Paper.T01.Issue1.h0_star
    isInvSub_lawY).1
  rw [F_map_h0_zero] at this
  norm_num at this

/-- Scope: X = Z satisfies every printed hypothesis of Thm 4.8 and its conclusion. -/
theorem consumed_of_printed :
    IsProbabilityMeasure Paper.P04.paretoMeasure ∧ Paper.P04.SuperPareto Paper.P04.paretoMeasure ∧
      Nonneg Paper.P04.paretoMeasure ∧ IsInvSub Paper.P04.paretoMeasure :=
  ⟨inferInstance, sp_Z, nonneg_Z, isInvSub_Z⟩

end Paper.T03.Issue2

#pv_walk_decl Paper.T03.Issue2.not_PrintedStep337
#pv_walk_decl Paper.T03.Issue2.not_DraftS3b
#pv_walk_decl Paper.T03.Issue2.not_T03_T01Consumed
#pv_walk_decl Paper.T03.Issue2.consumed_of_printed
#print axioms Paper.T03.Issue2.not_PrintedStep337
#print axioms Paper.T03.Issue2.not_DraftS3b
#print axioms Paper.T03.Issue2.not_T03_T01Consumed
#print axioms Paper.T03.Issue2.consumed_of_printed
