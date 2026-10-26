import P04Stmt
import PVTools

/-!
# P04 issue 2: counterexample to Proposition 4.6 (source :315-318) at a degenerate X

Instance: X = 0 almost surely, law `δ₀` (a nonnegative random variable; Prop 4.6 prints no
hypothesis on X). Encoding: the gate-approved definitions of `pv_work/P04Stmt.lean`
(`F`, `quantile` = :111, `ConvexTransformLE` = :310, `DOR` = :306, `SuperPareto` = :286).

* `not_PrintedClause2`: "X is super-Pareto iff 𝒫 ≤c F_X" (:317, parenthetical) is false at δ₀.
  Robust: `transform_d0` shows `F_X⁻¹ ∘ 𝒫 ≡ 0` on all of ℝ, so `𝒫 ≤c δ₀` holds for any convex
  choice of domain (`le_c_d0_any`); `not_SP_d0` uses only "nonconstant" (:286) and positivity of the
  Pareto law on intervals in (1,∞).
* `not_PrintedClause1`: "F_X is DOR iff 𝒫 ≤c F_X" (:317) is false at δ₀ under the gate-approved
  real-valued reading of "Λ_X concave" (requires Fbar_X > 0).
-/

open MeasureTheory Set

namespace Paper.P04.Issue2

/-- Source :317, clause "X is super-Pareto iff 𝒫 ≤c F_X", for every random variable X. -/
def PrintedClause2 : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (SuperPareto μ ↔ ConvexTransformLE paretoCdf (F μ))

/-- Source :317, clause "F_X is DOR iff 𝒫 ≤c F_X", for every random variable X. -/
def PrintedClause1 : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (DOR μ ↔ ConvexTransformLE paretoCdf (F μ))

lemma F_d0 (x : ℝ) : F (Measure.dirac (0:ℝ)) x = if 0 ≤ x then 1 else 0 := by
  unfold F
  rw [ProbabilityTheory.cdf_eq_real]
  split_ifs with h
  · simp [Measure.real, Measure.dirac_apply_of_mem (show (0:ℝ) ∈ Iic x from mem_Iic.2 h)]
  · simp [Measure.real, Measure.dirac_apply' _ (measurableSet_Iic (a := x)), h]

lemma pareto_lt_one (x : ℝ) : paretoCdf x < 1 := by
  unfold paretoCdf
  split_ifs with h
  · have hx : (0:ℝ) < x := by linarith
    have : 0 < 1 / x := by positivity
    linarith
  · norm_num

lemma pareto_nonneg (x : ℝ) : 0 ≤ paretoCdf x := by
  unfold paretoCdf
  split_ifs with h
  · have hx : (0:ℝ) < x := by linarith
    have : 1 / x ≤ 1 := by rw [div_le_one hx]; exact h
    linarith
  · exact le_refl 0

lemma quantile_d0 {u : ℝ} (hu0 : 0 ≤ u) (hu1 : u < 1) :
    quantile (F (Measure.dirac (0:ℝ))) u = 0 := by
  have hset : {x | F (Measure.dirac (0:ℝ)) x ≤ u} = Iio 0 := by
    ext x
    simp only [mem_setOf_eq, mem_Iio, F_d0]
    split_ifs with h
    · constructor
      · intro h1; linarith
      · intro h2; linarith
    · constructor
      · intro _; exact not_le.mp h
      · intro _; exact hu0
  unfold quantile
  rw [hset, csSup_Iio]

/-- The transform `F_X⁻¹ ∘ 𝒫` of Def 4.5 for `F_1 = 𝒫`, `F_2 = F_{δ₀}` is identically `0` on ℝ. -/
lemma transform_d0 (x : ℝ) : quantile (F (Measure.dirac (0:ℝ))) (paretoCdf x) = 0 :=
  quantile_d0 (pareto_nonneg x) (pareto_lt_one x)

lemma supp_pareto : suppIn paretoCdf = Ioi 1 := by
  ext x
  simp only [suppIn, mem_setOf_eq, mem_Ioi]
  constructor
  · rintro ⟨h0, _⟩
    by_contra h
    push_neg at h
    rcases h.lt_or_eq with h | h
    · simp [paretoCdf, not_le.2 h] at h0
    · subst h; simp [paretoCdf] at h0
  · intro hx
    have hv : paretoCdf x = 1 - 1 / x := by simp [paretoCdf, hx.le]
    rw [hv]
    have hx0 : 0 < x := by linarith
    have : 1 / x < 1 := by rw [div_lt_one hx0]; exact hx
    have : 0 < 1 / x := by positivity
    constructor <;> linarith

/-- `𝒫 ≤c δ₀` in the encoding (domain `suppIn 𝒫 = (1,∞)`). -/
lemma le_c_d0 : ConvexTransformLE paretoCdf (F (Measure.dirac (0:ℝ))) := by
  unfold ConvexTransformLE
  rw [supp_pareto]
  have e : (fun x => quantile (F (Measure.dirac (0:ℝ))) (paretoCdf x)) = fun _ => (0:ℝ) :=
    funext transform_d0
  rw [e]
  exact convexOn_const 0 (convex_Ioi 1)

/-- Robustness: `𝒫 ≤c δ₀` holds for every convex choice of domain (the transform is constant). -/
lemma le_c_d0_any (s : Set ℝ) (hs : Convex ℝ s) :
    ConvexOn ℝ s (fun x => quantile (F (Measure.dirac (0:ℝ))) (paretoCdf x)) := by
  have e : (fun x => quantile (F (Measure.dirac (0:ℝ))) (paretoCdf x)) = fun _ => (0:ℝ) :=
    funext transform_d0
  rw [e]
  exact convexOn_const 0 hs

lemma not_DOR_d0 : ¬ DOR (Measure.dirac (0:ℝ)) := by
  rintro ⟨h, -⟩
  have h0 := h 0
  rw [F_d0] at h0
  simp at h0

lemma pareto_Icc_pos {a b : ℝ} (ha : 1 < a) (hab : a < b) : 0 < paretoMeasure (Icc a b) := by
  unfold paretoMeasure
  rw [withDensity_apply _ measurableSet_Icc]
  have hb : 0 < b := by linarith
  have hle : ∀ x ∈ Icc a b, ENNReal.ofReal (1 / b ^ 2) ≤
      (if 1 < x then ENNReal.ofReal (1 / x ^ 2) else 0) := by
    intro x hx
    have hx1 : 1 < x := lt_of_lt_of_le ha hx.1
    rw [if_pos hx1]
    apply ENNReal.ofReal_le_ofReal
    have hx0 : 0 < x := by linarith
    apply one_div_le_one_div_of_le (by positivity)
    exact pow_le_pow_left₀ hx0.le hx.2 2
  calc (0:ENNReal) < ENNReal.ofReal (1 / b ^ 2) * volume (Icc a b) := by
        rw [Real.volume_Icc]
        apply ENNReal.mul_pos
        · rw [ne_eq, ENNReal.ofReal_eq_zero, not_le]; positivity
        · rw [ne_eq, ENNReal.ofReal_eq_zero, not_le]; linarith
    _ = ∫⁻ _ in Icc a b, ENNReal.ofReal (1 / b ^ 2) := (setLIntegral_const _ _).symm
    _ ≤ ∫⁻ x in Icc a b, (if 1 < x then ENNReal.ofReal (1 / x ^ 2) else 0) :=
        setLIntegral_mono' measurableSet_Icc hle

/-- δ₀ is not super-Pareto (Def 4.1, :286: `h` nonconstant). -/
lemma not_SP_d0 : ¬ SuperPareto (Measure.dirac (0:ℝ)) := by
  rintro ⟨h, hmeas, hmono, hconv, ⟨x, hx, y, hy, hxy⟩, hμ⟩
  have hnull : paretoMeasure (h ⁻¹' {0}ᶜ) = 0 := by
    have h1 : (Measure.dirac (0:ℝ)) ({0}ᶜ) = 0 := by
      simp [Measure.dirac_apply' _ (measurableSet_singleton (0:ℝ)).compl]
    rw [hμ, Measure.map_apply hmeas (measurableSet_singleton 0).compl] at h1
    exact h1
  have hzero : ∀ t, 1 < t → h t = 0 := by
    intro t ht
    by_contra hne
    rcases lt_or_gt_of_ne hne with hneg | hpos
    · have hsub : Icc ((1 + t) / 2) t ⊆ h ⁻¹' {0}ᶜ := by
        intro s hs
        have hs1 : s ∈ Ici (1:ℝ) := by rw [mem_Ici]; linarith [hs.1]
        have hle : h s ≤ h t := hmono hs1 (by rw [mem_Ici]; linarith) hs.2
        simp only [mem_preimage, mem_compl_iff, mem_singleton_iff]
        intro h0; linarith
      have hp := pareto_Icc_pos (a := (1 + t) / 2) (b := t) (by linarith) (by linarith)
      exact absurd (measure_mono_null hsub hnull) hp.ne'
    · have hsub : Icc t (t + 1) ⊆ h ⁻¹' {0}ᶜ := by
        intro s hs
        have hle : h t ≤ h s :=
          hmono (by rw [mem_Ici]; linarith) (by rw [mem_Ici]; linarith [hs.1]) hs.1
        simp only [mem_preimage, mem_compl_iff, mem_singleton_iff]
        intro h0; linarith
      have hp := pareto_Icc_pos (a := t) (b := t + 1) ht (by linarith)
      exact absurd (measure_mono_null hsub hnull) hp.ne'
  have h2 := hzero 2 (by norm_num)
  have h32 := hzero (3 / 2) (by norm_num)
  have m1 : (1:ℝ) ∈ Ici (1:ℝ) := by rw [mem_Ici]
  have m2 : (2:ℝ) ∈ Ici (1:ℝ) := by rw [mem_Ici]; norm_num
  have h1le : h 1 ≤ 0 := by rw [← h2]; exact hmono m1 m2 (by norm_num)
  have key := hconv.2 m1 m2 (show (0:ℝ) ≤ 1 / 2 by norm_num) (show (0:ℝ) ≤ 1 / 2 by norm_num)
    (show (1 / 2 : ℝ) + 1 / 2 = 1 by norm_num)
  have e : (1 / 2 : ℝ) • (1:ℝ) + (1 / 2 : ℝ) • (2:ℝ) = 3 / 2 := by norm_num
  rw [e, smul_eq_mul, smul_eq_mul, h32, h2] at key
  have h1eq : h 1 = 0 := by linarith
  have hall : ∀ t ∈ Ici (1:ℝ), h t = 0 := by
    intro t ht
    rcases (mem_Ici.1 ht).lt_or_eq with h' | h'
    · exact hzero t h'
    · rw [← h']; exact h1eq
  exact hxy (by rw [hall x hx, hall y hy])

/-- Main counterexample: the parenthetical clause "X super-Pareto iff 𝒫 ≤c F_X" fails at X = 0. -/
theorem not_PrintedClause2 : ¬ PrintedClause2 := fun H =>
  not_SP_d0 ((H (Measure.dirac (0:ℝ)) inferInstance).2 le_c_d0)

/-- Clause "F_X DOR iff 𝒫 ≤c F_X" fails at X = 0 (real-valued reading of DOR, gate A2). -/
theorem not_PrintedClause1 : ¬ PrintedClause1 := fun H =>
  not_DOR_d0 ((H (Measure.dirac (0:ℝ)) inferInstance).2 le_c_d0)

/-- Scope check: the instance is a probability law (the only printed premise), it is nonnegative,
and it is exactly what the gate-approved TFA `hnd` excludes. -/
theorem consumed_of_printed :
    IsProbabilityMeasure (Measure.dirac (0:ℝ)) ∧
    (Measure.dirac (0:ℝ)) (Iio 0) = 0 ∧
    ¬ (∀ c : ℝ, Measure.dirac (0:ℝ) ≠ Measure.dirac c) :=
  ⟨inferInstance, by simp [Measure.dirac_apply' _ measurableSet_Iio], fun h => h 0 rfl⟩

end Paper.P04.Issue2

#pv_walk_decl Paper.P04.Issue2.not_PrintedClause2
#pv_walk_decl Paper.P04.Issue2.not_PrintedClause1
#pv_walk_decl Paper.P04.Issue2.consumed_of_printed
#pv_walk_decl Paper.P04.Issue2.le_c_d0_any
#print axioms Paper.P04.Issue2.not_PrintedClause2
#print axioms Paper.P04.Issue2.not_PrintedClause1
