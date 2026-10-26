import T03Stmt
import PVTools

/-!
# T03 issue 1: counterexamples to Theorem 4.8 (cor:inclusion) as printed

Source `source/SuperParetoPaper-v12.tex:332-335`: "If X is nonnegative super-Pareto then X is ITS."
Read with Def 2.2 (:122-124, ITS requires `F_X(0)=0` and `1 - F_X(1/x)` subadditive),
Def 4.1 (:284-287, super-Pareto: `X =ᵈ h(Z)`, `F_Z = 𝒫`, `h` increasing convex nonconstant),
:111 ("increasing" = non-decreasing). Encodings: the gate-approved `Paper.P04.SuperPareto`,
`Paper.L01.IsInvSub`, `Paper.T03.Nonneg`.

* Instance A: `X = max (Z - 2) 0`. Nonnegative super-Pareto, `F_X(0) = P(Z ≤ 2) = 1/2 ≠ 0`.
* Instance B: `X = Z + 1`. Nonnegative (even `F_X(0) = 0`, `X ≥ 2`) super-Pareto, but
  `1 - F_X(1/x)` is not subadditive: at `x = y = 1/4`, `1 > 1/3 + 1/3`.
  B shows that adding "positive" / `F_X(0) = 0` to the theorem does NOT rescue it.
-/

open MeasureTheory ProbabilityTheory Set Paper.L01

namespace Paper.T03.Issue1

/-- Theorem 4.8 as printed (:332-335), over the gate-approved definitions. -/
def PrintedThm48 : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ],
    Paper.P04.SuperPareto μ → Nonneg μ → IsInvSub μ

/-- Weaker clause (extra premise `F_X(0) = 0`, i.e. X positive a.s.): the "positive" repair. -/
def PrintedThm48Pos : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ],
    Paper.P04.SuperPareto μ → Nonneg μ → F μ 0 = 0 → IsInvSub μ

theorem pos_of_printed (h : PrintedThm48) : PrintedThm48Pos :=
  fun μ _ hs hn _ => h μ hs hn

/-! ## The Pareto(1) law (computations copied from T02_Counterexample1 / the auditor's P01 probe) -/

noncomputable def fP (t : ℝ) : ENNReal :=
  (Ioi (1:ℝ)).indicator (fun t => ENNReal.ofReal (t ^ (-2:ℝ))) t

lemma fP_meas : Measurable fP :=
  (ENNReal.measurable_ofReal.comp (measurable_id.pow_const _)).indicator measurableSet_Ioi

noncomputable def μP : Measure ℝ := volume.withDensity fP

/-- `μP` is exactly `Paper.P04.paretoMeasure` (densities agree pointwise). -/
lemma pm_eq : Paper.P04.paretoMeasure = μP := by
  unfold Paper.P04.paretoMeasure μP
  congr 1
  funext x
  unfold fP
  by_cases hx : 1 < x
  · rw [if_pos hx, indicator_of_mem (show x ∈ Ioi (1:ℝ) from hx)]
    congr 1
    have hx0 : 0 < x := by linarith
    rw [Real.rpow_neg hx0.le, Real.rpow_two, one_div]
  · rw [if_neg hx, indicator_of_not_mem (show x ∉ Ioi (1:ℝ) from hx)]

lemma tail (c : ℝ) (hc : 1 ≤ c) : μP (Ioi c) = ENNReal.ofReal (c ^ (-1:ℝ)) := by
  have hc0 : 0 < c := by linarith
  unfold μP
  rw [withDensity_apply _ measurableSet_Ioi]
  have : ∫⁻ t in Ioi c, fP t = ∫⁻ t in Ioi c, ENNReal.ofReal (t ^ (-2:ℝ)) := by
    refine setLIntegral_congr_fun measurableSet_Ioi (ae_of_all _ (fun t ht => ?_))
    have : t ∈ Ioi (1:ℝ) := lt_of_le_of_lt hc ht
    simp [fP, indicator_of_mem this]
  rw [this, ← ofReal_integral_eq_lintegral_ofReal
    (integrableOn_Ioi_rpow_of_lt (by norm_num) hc0)
    (ae_restrict_of_forall_mem measurableSet_Ioi
      (fun t (ht : c < t) => Real.rpow_nonneg (by linarith) _)),
    integral_Ioi_rpow_of_lt (by norm_num) hc0]
  norm_num

lemma Iic_one : μP (Iic 1) = 0 := by
  unfold μP
  rw [withDensity_apply _ measurableSet_Iic]
  refine setLIntegral_eq_zero_iff' measurableSet_Iic fP_meas.aemeasurable |>.mpr ?_
  exact ae_of_all _ (fun t ht => by
    have : t ∉ Ioi (1:ℝ) := by simpa using ht
    simp [fP, indicator_of_not_mem this])

lemma univ_eq : μP univ = 1 := by
  have h2 := tail 1 le_rfl
  rw [← Iic_union_Ioi (a := (1:ℝ)), measure_union (Iic_disjoint_Ioi le_rfl) measurableSet_Ioi,
    Iic_one, h2]
  simp

instance μP_prob : IsProbabilityMeasure μP := ⟨univ_eq⟩

instance pm_prob : IsProbabilityMeasure Paper.P04.paretoMeasure := by
  rw [pm_eq]; infer_instance

lemma F_P_eq (x : ℝ) : F μP x = (μP (Iic x)).toReal := by
  unfold F; rw [cdf_eq_real]; rfl

lemma F_P_le1 (x : ℝ) (hx : x ≤ 1) : F μP x = 0 := by
  rw [F_P_eq, measure_mono_null (Iic_subset_Iic.2 hx) Iic_one]; rfl

lemma Fbar_P_ge1 (x : ℝ) (hx : 1 ≤ x) : 1 - F μP x = x⁻¹ := by
  have : 1 - F μP x = (μP (Ioi x)).toReal := by
    rw [F_P_eq, ← compl_Iic, measure_compl measurableSet_Iic (measure_ne_top _ _), measure_univ,
      ENNReal.toReal_sub_of_le prob_le_one ENNReal.one_ne_top]
    simp
  rw [this, tail x hx, ENNReal.toReal_ofReal (by positivity), Real.rpow_neg_one]

lemma F_P_ge1 (x : ℝ) (hx : 1 ≤ x) : F μP x = 1 - x⁻¹ := by
  have := Fbar_P_ge1 x hx; linarith

/-- cdf of a push-forward through a measurable map whose sublevel preimage is a half-line. -/
lemma F_map_pre (ν : Measure ℝ) [IsProbabilityMeasure ν] (f : ℝ → ℝ) (hf : Measurable f)
    (x c : ℝ) (h : f ⁻¹' Iic x = Iic c) : F (ν.map f) x = F ν c := by
  haveI := isProbabilityMeasure_map (μ := ν) hf.aemeasurable
  unfold F
  rw [cdf_eq_real, cdf_eq_real, map_measureReal_apply hf measurableSet_Iic, h]

/-! ## Instance A: `X = max (Z - 2) 0` -/

def hA (z : ℝ) : ℝ := max (z - 2) 0

lemma hA_cont : Continuous hA := (continuous_id.sub continuous_const).max continuous_const

lemma hA_mono : Monotone hA := fun a b hab => max_le_max (by linarith) le_rfl

lemma hA_convex : ConvexOn ℝ univ hA :=
  ((convexOn_id convex_univ).sub (concaveOn_const _ convex_univ)).sup
    (convexOn_const _ convex_univ)

noncomputable def μA : Measure ℝ := Paper.P04.paretoMeasure.map hA

instance μA_prob : IsProbabilityMeasure μA :=
  isProbabilityMeasure_map hA_cont.measurable.aemeasurable

/-- Printed hypothesis "super-Pareto" (Def 4.1, :286): `h = hA` increasing, convex, nonconstant. -/
lemma sp_A : Paper.P04.SuperPareto μA :=
  ⟨hA, hA_cont.measurable, hA_mono.monotoneOn _,
    hA_convex.subset (subset_univ _) (convex_Ici 1),
    ⟨1, by norm_num, 3, by norm_num, by norm_num [hA]⟩, rfl⟩

/-- Printed hypothesis "nonnegative" (:334). -/
lemma nonneg_A : Nonneg μA := by
  unfold Nonneg μA
  rw [Measure.map_apply hA_cont.measurable measurableSet_Iio]
  have : hA ⁻¹' Iio 0 = ∅ := by
    ext z; simp [hA]
  rw [this, measure_empty]

lemma F_A_zero : F μA 0 = 1 / 2 := by
  unfold μA
  rw [F_map_pre _ hA hA_cont.measurable 0 2 (by ext z; simp [hA]), pm_eq, F_P_ge1 2 (by norm_num)]
  norm_num

lemma not_inv_A : ¬ IsInvSub μA := by
  intro h
  have := h.1
  rw [F_A_zero] at this
  norm_num at this

theorem not_PrintedThm48 : ¬ PrintedThm48 :=
  fun H => not_inv_A (H μA sp_A nonneg_A)

/-! ## Instance B: `X = Z + 1` (strictly positive; defeats the "positive" repair) -/

def hB (z : ℝ) : ℝ := z + 1

lemma hB_cont : Continuous hB := continuous_id.add continuous_const

noncomputable def μB : Measure ℝ := Paper.P04.paretoMeasure.map hB

instance μB_prob : IsProbabilityMeasure μB :=
  isProbabilityMeasure_map hB_cont.measurable.aemeasurable

lemma sp_B : Paper.P04.SuperPareto μB :=
  ⟨hB, hB_cont.measurable, fun a _ b _ hab => by simp only [hB]; linarith,
    ⟨convex_Ici 1, fun x _ y _ a b _ _ hab => by
      simp only [hB, smul_eq_mul]
      linarith⟩,
    ⟨1, by norm_num, 3, by norm_num, by norm_num [hB]⟩, rfl⟩

lemma F_B (x : ℝ) : F μB x = F μP (x - 1) := by
  unfold μB
  rw [F_map_pre _ hB hB_cont.measurable x (x - 1) (by ext z; simp [hB]; constructor <;> intro <;> linarith),
    pm_eq]

lemma nonneg_B : Nonneg μB := by
  unfold Nonneg μB
  rw [Measure.map_apply hB_cont.measurable measurableSet_Iio, pm_eq]
  refine measure_mono_null (fun z hz => ?_) Iic_one
  simp only [mem_preimage, mem_Iio, hB] at hz
  simp only [mem_Iic]; linarith

/-- Extra premise of `PrintedThm48Pos`: `F_X(0) = 0`. -/
lemma F_B_zero : F μB 0 = 0 := by
  rw [F_B]; exact F_P_le1 _ (by norm_num)

lemma not_inv_B : ¬ IsInvSub μB := by
  intro h
  have hs := h.2 (1 / 4) (by norm_num) (1 / 4) (by norm_num)
  unfold invDist at hs
  have e1 : (1:ℝ) / (1 / 4 + 1 / 4) = 2 := by norm_num
  have e2 : (1:ℝ) / (1 / 4) = 4 := by norm_num
  rw [e1, e2, F_B, F_B] at hs
  rw [show (2:ℝ) - 1 = 1 by norm_num, show (4:ℝ) - 1 = 3 by norm_num,
    F_P_le1 1 le_rfl, F_P_ge1 3 (by norm_num)] at hs
  norm_num at hs

theorem not_PrintedThm48Pos : ¬ PrintedThm48Pos :=
  fun H => not_inv_B (H μB sp_B nonneg_B F_B_zero)

/-- Scope: each instance satisfies every printed hypothesis (probability law, super-Pareto,
nonnegative); B also satisfies `F_X(0)=0`. Failure in A is the `F(0)=0` conjunct of Def 2.2;
failure in B is the subadditivity conjunct. -/
theorem consumed_of_printed :
    (IsProbabilityMeasure μA ∧ Paper.P04.SuperPareto μA ∧ Nonneg μA ∧ ¬ IsInvSub μA) ∧
    (IsProbabilityMeasure μB ∧ Paper.P04.SuperPareto μB ∧ Nonneg μB ∧ F μB 0 = 0 ∧
      ¬ IsInvSub μB) :=
  ⟨⟨inferInstance, sp_A, nonneg_A, not_inv_A⟩, ⟨inferInstance, sp_B, nonneg_B, F_B_zero, not_inv_B⟩⟩

end Paper.T03.Issue1

#pv_walk_decl Paper.T03.Issue1.not_PrintedThm48
#pv_walk_decl Paper.T03.Issue1.not_PrintedThm48Pos
#pv_walk_decl Paper.T03.Issue1.consumed_of_printed
#print axioms Paper.T03.Issue1.not_PrintedThm48
#print axioms Paper.T03.Issue1.not_PrintedThm48Pos
#print axioms Paper.T03.Issue1.consumed_of_printed
