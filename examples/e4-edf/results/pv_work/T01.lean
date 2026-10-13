import T01Stmt

open MeasureTheory Set

namespace Paper.T01
open Paper.Defs

/-- Technical: `edf` takes values in `[0,1]` (`n = 0` gives `0`). -/
private lemma edf_bounds {n : ℕ} (x : Fin n → ℝ) (t : ℝ) : 0 ≤ edf x t ∧ edf x t ≤ 1 := by
  unfold edf
  have hc : ((Finset.univ.filter (fun i : Fin n => x i ≤ t)).card : ℝ) ≤ n := by
    exact_mod_cast (Finset.card_filter_le _ _).trans (by simp)
  constructor
  · positivity
  · rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp
    · have hn' : (0:ℝ) < n := by exact_mod_cast hn
      rw [one_div, inv_mul_le_iff₀ hn']
      linarith

/-! Private technical helpers for S1 (session 2 of pass 2): measurability facts only
(FAIR_IMPLICIT_STEP, issue ruling verification/audits/T01_issue_1.md §6). -/

/-- Technical measurability: a finite `sup` of measurable `EReal`-valued functions. -/
private lemma meas_finset_sup {Ω ι : Type} [MeasurableSpace Ω] [DecidableEq ι] (s : Finset ι)
    (f : ι → Ω → EReal) (hf : ∀ i, Measurable (f i)) :
    Measurable (fun ω => s.sup (fun i => f i ω)) := by
  induction s using Finset.induction_on with
  | empty => simpa using (measurable_const : Measurable (fun _ : Ω => (⊥ : EReal)))
  | insert a s ha ih =>
    simp only [Finset.sup_insert]
    exact (hf a).max ih

/-- Technical measurability: a finite `inf` of measurable `EReal`-valued functions. -/
private lemma meas_finset_inf {Ω ι : Type} [MeasurableSpace Ω] [DecidableEq ι] (s : Finset ι)
    (f : ι → Ω → EReal) (hf : ∀ i, Measurable (f i)) :
    Measurable (fun ω => s.inf (fun i => f i ω)) := by
  induction s using Finset.induction_on with
  | empty => simpa using (measurable_const : Measurable (fun _ : Ω => (⊤ : EReal)))
  | insert a s ha ih =>
    simp only [Finset.inf_insert]
    exact (hf a).min ih

/-- Technical measurability: for a fixed set `U ⊆ ℝ` and measurable `EReal` bounds `L, R`,
the event "some `t ∈ U` lies in `[L, R)`" is measurable (it is `{ψ ∘ L < R}` for the
monotone map `ψ a = inf (U ∩ [a, ∞))`). -/
private lemma meas_exists_mem_Ico {Ω : Type} [MeasurableSpace Ω] (U : Set ℝ)
    (L R : Ω → EReal) (hL : Measurable L) (hR : Measurable R) :
    MeasurableSet {ω | ∃ t ∈ U, L ω ≤ (t : EReal) ∧ (t : EReal) < R ω} := by
  let ψ : EReal → EReal := fun a =>
    sInf ((fun t : ℝ => (t : EReal)) '' (U ∩ {t | a ≤ (t : EReal)}))
  have hψ : Monotone ψ := fun a b hab =>
    sInf_le_sInf (image_subset _ (fun t ht => ⟨ht.1, hab.trans ht.2⟩))
  have hset : {ω | ∃ t ∈ U, L ω ≤ (t : EReal) ∧ (t : EReal) < R ω} = {ω | ψ (L ω) < R ω} := by
    ext ω
    simp only [mem_setOf_eq, ψ, sInf_lt_iff, mem_image, mem_inter_iff]
    constructor
    · rintro ⟨t, htU, h1, h2⟩
      exact ⟨t, ⟨t, ⟨htU, h1⟩, rfl⟩, h2⟩
    · rintro ⟨_, ⟨t, ⟨htU, h1⟩, rfl⟩, h2⟩
      exact ⟨t, htU, h1, h2⟩
  rw [hset]
  exact measurableSet_lt (hψ.measurable.comp hL) hR

/-- S1. Implicit (silent; not in source): `D_n` is measurable, needed for the
distributional statement (main.tex:54-55). Uses nothing. -/
theorem T01_S1 {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (hmeas : ∀ k, Measurable (X k)) (n : ℕ) : Measurable (Dn P X n) := by
  classical
  -- `F(t) = P.real {X_1 ≤ t} ≥ 0` (main.tex:30-31, D03a)
  have hc0 : ∀ t, 0 ≤ cdfOf P X t := fun t => measureReal_nonneg
  by_cases hb : BddAbove (range (cdfOf P X))
  · obtain ⟨M, hM⟩ := hb
    -- the family `t ↦ |F_n(t) - F(t)|` is bounded (by `1 + M`), so `D_n` is a true supremum
    have hbdd : ∀ ω, BddAbove (range fun t => |edfRV X n ω t - cdfOf P X t|) := by
      intro ω
      refine ⟨1 + M, ?_⟩
      rintro _ ⟨t, rfl⟩
      obtain ⟨h0, h1⟩ := edf_bounds (fun i : Fin n => X i ω) t
      have hct : cdfOf P X t ≤ M := hM ⟨t, rfl⟩
      have := hc0 t
      exact abs_sub_le_iff.mpr ⟨by simp only [edfRV]; linarith, by simp only [edfRV]; linarith⟩
    refine measurable_of_Ioi fun r => ?_
    -- `D_n > r` iff some `t` has `|F_n(t) - F(t)| > r`; `F_n(t)` depends on `t` only through
    -- the finite pattern `S = {i : X_i ≤ t}`, i.e. `t ∈ [max_S X_i, min_{Sᶜ} X_i)`.
    have hpre : Dn P X n ⁻¹' Ioi r = ⋃ S : Finset (Fin n),
        {ω | ∃ t ∈ {t : ℝ | r < |(1 / (n : ℝ)) * (S.card : ℝ) - cdfOf P X t|},
          S.sup (fun i => ((X i ω : ℝ) : EReal)) ≤ (t : EReal) ∧
          (t : EReal) < Sᶜ.inf (fun i => ((X i ω : ℝ) : EReal))} := by
      ext ω
      simp only [mem_preimage, mem_Ioi, mem_iUnion, mem_setOf_eq]
      unfold Dn
      rw [lt_ciSup_iff (hbdd ω)]
      constructor
      · rintro ⟨t, ht⟩
        refine ⟨Finset.univ.filter (fun i : Fin n => X i ω ≤ t), t, ht, ?_, ?_⟩
        · rw [Finset.sup_le_iff]
          intro i hi
          simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hi
          exact EReal.coe_le_coe_iff.mpr hi
        · rw [Finset.lt_inf_iff (EReal.coe_lt_top t)]
          intro i hi
          simp only [Finset.mem_compl, Finset.mem_filter, Finset.mem_univ, true_and] at hi
          exact EReal.coe_lt_coe_iff.mpr (not_le.mp hi)
      · rintro ⟨S, t, ht, h1, h2⟩
        refine ⟨t, ?_⟩
        have hS : Finset.univ.filter (fun i : Fin n => X i ω ≤ t) = S := by
          ext i
          simp only [Finset.mem_filter, Finset.mem_univ, true_and]
          constructor
          · intro hi
            by_contra hiS
            have := (Finset.lt_inf_iff (EReal.coe_lt_top t)).mp h2 i (Finset.mem_compl.mpr hiS)
            exact absurd (EReal.coe_lt_coe_iff.mp this) (not_lt.mpr hi)
          · intro hi
            exact EReal.coe_le_coe_iff.mp ((Finset.sup_le_iff.mp h1) i hi)
        have he : edfRV X n ω t = (1 / (n : ℝ)) * (S.card : ℝ) := by
          simp only [edfRV, edf]
          rw [hS]
        rw [he]
        exact ht
    rw [hpre]
    refine MeasurableSet.iUnion fun S => meas_exists_mem_Ico _ _ _ ?_ ?_
    · exact meas_finset_sup S (fun i ω => ((X i ω : ℝ) : EReal))
        (fun i => measurable_coe_real_ereal.comp (hmeas i))
    · exact meas_finset_inf Sᶜ (fun i ω => ((X i ω : ℝ) : EReal))
        (fun i => measurable_coe_real_ereal.comp (hmeas i))
  · -- `F` unbounded (only possible for non-probability `P`, Lean junk): then the family is
    -- unbounded, the real `⨆` is `0`, and `D_n` is constant.
    have hDn : Dn P X n = fun _ => 0 := by
      funext ω
      apply Real.iSup_of_not_bddAbove
      rintro ⟨M, hM⟩
      apply hb
      refine ⟨M + 1, ?_⟩
      rintro _ ⟨t, rfl⟩
      have h := hM ⟨t, rfl⟩
      obtain ⟨h0, h1⟩ := edf_bounds (fun i : Fin n => X i ω) t
      have h2 : cdfOf P X t - edfRV X n ω t ≤ |edfRV X n ω t - cdfOf P X t| := by
        rw [abs_sub_comm]; exact le_abs_self _
      simp only [edfRV] at h h2
      linarith
    rw [hDn]
    exact measurable_const

/-! Private technical helpers (session 2). Fill-in of the standard implicit step ruled
FAIR_IMPLICIT_STEP in verification/audits/T01_issue_1.md §5 (continuity hypothesis,
main.tex:54). -/

/-- Technical conversion: `cdfOf P X` is mathlib's `cdf` of the law of `X 0`
(main.tex:30-31, "F is the distribution function of X_1"). -/
private lemma cdfOf_eq_cdf {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (h0 : Measurable (X 0)) :
    cdfOf P X = ProbabilityTheory.cdf (P.map (X 0)) := by
  haveI : IsProbabilityMeasure (P.map (X 0)) := isProbabilityMeasure_map h0.aemeasurable
  funext t
  rw [ProbabilityTheory.cdf_eq_real, Measure.real, Measure.map_apply h0 measurableSet_Iic]
  rfl

/-- Technical set identity. -/
private lemma Iic_inter_Icc01 (u : ℝ) : Iic u ∩ Icc (0:ℝ) 1 = Icc 0 (min u 1) := by
  ext x
  simp only [mem_inter_iff, mem_Iic, mem_Icc, le_min_iff]
  tauto

/-- Probability integral transform (part of S2; issue ruling §5, S2 item 3): for a
probability measure on ℝ with continuous cdf `F`, the image of `μ` under `F` is uniform. -/
private lemma pit_law (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hF : Continuous (ProbabilityTheory.cdf μ)) :
    μ.map (ProbabilityTheory.cdf μ) = volume.restrict (Icc (0:ℝ) 1) := by
  have hmono : Monotone (ProbabilityTheory.cdf μ) := ProbabilityTheory.monotone_cdf μ
  have hFm : Measurable (ProbabilityTheory.cdf μ) := hF.measurable
  haveI : IsProbabilityMeasure (μ.map (ProbabilityTheory.cdf μ)) :=
    isProbabilityMeasure_map hFm.aemeasurable
  refine Measure.ext_of_Iic _ _ (fun u => ?_)
  rw [Measure.map_apply hFm measurableSet_Iic, Measure.restrict_apply measurableSet_Iic,
    Iic_inter_Icc01, Real.volume_Icc, sub_zero]
  rcases le_or_gt 1 u with hu | hu
  · -- u ≥ 1: F ≤ 1, preimage is everything
    have : (ProbabilityTheory.cdf μ) ⁻¹' Iic u = univ := by
      ext x
      simp only [mem_preimage, mem_Iic, mem_univ, iff_true]
      exact (ProbabilityTheory.cdf_le_one μ x).trans hu
    rw [this, measure_univ, min_eq_right hu, ENNReal.ofReal_one]
  · rw [min_eq_left hu.le]
    rcases ((ProbabilityTheory.cdf μ) ⁻¹' Iic u).eq_empty_or_nonempty with hSe | hSne
    · -- empty sublevel set: then u ≤ 0 (F → 0 at -∞)
      rw [hSe, measure_empty]
      by_contra hne
      have hupos : 0 < u := by
        by_contra h
        push_neg at h
        exact hne (by rw [ENNReal.ofReal_eq_zero.mpr h])
      obtain ⟨x, hx⟩ :=
        ((ProbabilityTheory.tendsto_cdf_atBot μ).eventually (gt_mem_nhds hupos)).exists
      have hxS : x ∈ (ProbabilityTheory.cdf μ) ⁻¹' Iic u := le_of_lt hx
      rw [hSe] at hxS
      exact hxS
    · -- sublevel set is closed, nonempty, bounded above, downward closed: = Iic q, F q = u
      have hSc : IsClosed ((ProbabilityTheory.cdf μ) ⁻¹' Iic u) := isClosed_Iic.preimage hF
      have hSb : BddAbove ((ProbabilityTheory.cdf μ) ⁻¹' Iic u) := by
        obtain ⟨M, hM⟩ := Filter.eventually_atTop.mp
          ((ProbabilityTheory.tendsto_cdf_atTop μ).eventually (lt_mem_nhds hu))
        refine ⟨M, fun y hy => ?_⟩
        by_contra hyM
        push_neg at hyM
        exact absurd (show ProbabilityTheory.cdf μ y ≤ u from hy) (not_le.mpr (hM y hyM.le))
      have hqS := hSc.csSup_mem hSne hSb
      have hSeq : (ProbabilityTheory.cdf μ) ⁻¹' Iic u
          = Iic (sSup ((ProbabilityTheory.cdf μ) ⁻¹' Iic u)) := by
        ext y
        constructor
        · intro hy
          exact le_csSup hSb hy
        · intro hy
          exact le_trans (hmono hy) hqS
      have hFq : ProbabilityTheory.cdf μ (sSup ((ProbabilityTheory.cdf μ) ⁻¹' Iic u)) = u := by
        refine le_antisymm hqS ?_
        have hcl : IsClosed {y | u ≤ ProbabilityTheory.cdf μ y} :=
          isClosed_le continuous_const hF
        have hsub : Ioi (sSup ((ProbabilityTheory.cdf μ) ⁻¹' Iic u))
            ⊆ {y | u ≤ ProbabilityTheory.cdf μ y} := by
          intro y hy
          simp only [mem_setOf_eq]
          by_contra h
          have hyS : y ∈ (ProbabilityTheory.cdf μ) ⁻¹' Iic u := (not_le.mp h).le
          exact absurd (le_csSup hSb hyS) (not_le.mpr hy)
        have hmem : sSup ((ProbabilityTheory.cdf μ) ⁻¹' Iic u)
            ∈ closure (Ioi (sSup ((ProbabilityTheory.cdf μ) ⁻¹' Iic u))) := by
          rw [closure_Ioi]
          exact left_mem_Ici
        exact hcl.closure_subset_iff.mpr hsub hmem
      rw [hSeq, ← ProbabilityTheory.ofReal_cdf, hFq]

/-- Law part of S2 for each `k` (issue ruling §5, S2 item 3), stated without independence
so that S3 (whose statement has no independence hypothesis) can use it. -/
private lemma law_comp {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) (k : ℕ) :
    P.map (fun ω => cdfOf P X (X k ω)) = volume.restrict (Icc (0:ℝ) 1) := by
  haveI : IsProbabilityMeasure (P.map (X 0)) := isProbabilityMeasure_map (hmeas 0).aemeasurable
  have hFeq := cdfOf_eq_cdf P X (hmeas 0)
  have hFm : Measurable (cdfOf P X) := hF.measurable
  have : (fun ω => cdfOf P X (X k ω)) = cdfOf P X ∘ X k := rfl
  rw [this, ← Measure.map_map hFm (hmeas k), hid k, hFeq]
  rw [hFeq] at hF
  exact pit_law _ hF

/-- S2. Silent reduction (not in source; main.tex:61): `U k = F ∘ X k` are measurable,
independent, uniform on [0,1] when `F` continuous. Fill-in: issue ruling
verification/audits/T01_issue_1.md §5 (FAIR_IMPLICIT_STEP; continuity, main.tex:54). -/
theorem T01_S2 {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hind : ProbabilityTheory.iIndepFun X P)
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) :
    (∀ k, Measurable (fun ω => cdfOf P X (X k ω))) ∧
    ProbabilityTheory.iIndepFun (fun k ω => cdfOf P X (X k ω)) P ∧
    ∀ k, P.map (fun ω => cdfOf P X (X k ω)) = volume.restrict (Icc (0:ℝ) 1) := by
  have hFm : Measurable (cdfOf P X) := hF.measurable
  -- §5 S2.1 measurability, S2.2 independence (functions of independent variables),
  -- S2.3 law (probability integral transform)
  exact ⟨fun k => hFm.comp (hmeas k), hind.comp (fun _ => cdfOf P X) (fun _ => hFm),
    law_comp P X hmeas hid hF⟩

/-- S3. Silent reduction (not in source): `D_n(X) = D_n(F ∘ X)` almost surely, for
all `n` simultaneously (continuity of F). Fill-in: issue ruling §5 (S3 items 1-5). -/
theorem T01_S3 {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) :
    ∀ᵐ ω ∂P, ∀ n, Dn P X n ω = Dn P (fun k ω => cdfOf P X (X k ω)) n ω := by
  haveI : IsProbabilityMeasure (P.map (X 0)) := isProbabilityMeasure_map (hmeas 0).aemeasurable
  have hFeq := cdfOf_eq_cdf P X (hmeas 0)
  have hlaw := law_comp P X hmeas hid hF
  have hFm : Measurable (cdfOf P X) := hF.measurable
  have hmono : Monotone (cdfOf P X) := by
    rw [hFeq]; exact ProbabilityTheory.monotone_cdf _
  have hnn : ∀ t, 0 ≤ cdfOf P X t := by
    intro t; rw [hFeq]; exact ProbabilityTheory.cdf_nonneg _ t
  have hle1 : ∀ t, cdfOf P X t ≤ 1 := by
    intro t; rw [hFeq]; exact ProbabilityTheory.cdf_le_one _ t
  have hbot : Filter.Tendsto (cdfOf P X) Filter.atBot (nhds 0) := by
    rw [hFeq]; exact ProbabilityTheory.tendsto_cdf_atBot _
  have htop : Filter.Tendsto (cdfOf P X) Filter.atTop (nhds 1) := by
    rw [hFeq]; exact ProbabilityTheory.tendsto_cdf_atTop _
  -- §5 S3.1: the countable set C = F(ℚ) is null for the uniform law of each F(X k)
  have hC : (range (fun q : ℚ => cdfOf P X q)).Countable := countable_range _
  have hnull : ∀ k, ∀ᵐ ω ∂P, cdfOf P X (X k ω) ∉ range (fun q : ℚ => cdfOf P X q) := by
    intro k
    have hmk : Measurable (fun ω => cdfOf P X (X k ω)) := hFm.comp (hmeas k)
    have h2 : P ((fun ω => cdfOf P X (X k ω)) ⁻¹' range (fun q : ℚ => cdfOf P X q)) = 0 := by
      rw [← Measure.map_apply hmk hC.measurableSet, hlaw k]
      exact hC.measure_zero _
    rw [ae_iff]
    simpa using h2
  -- §5 S3.3: the distribution function of U = F ∘ X is G u = max (min u 1) 0
  have hG : ∀ u, cdfOf P (fun k ω => cdfOf P X (X k ω)) u = max (min u 1) 0 := by
    intro u
    have h1 : cdfOf P (fun k ω => cdfOf P X (X k ω)) u
        = (P.map (fun ω => cdfOf P X (X 0 ω))).real (Iic u) := by
      have hm0 : Measurable (fun ω => cdfOf P X (X 0 ω)) := hFm.comp (hmeas 0)
      rw [Measure.real, Measure.map_apply hm0 measurableSet_Iic]
      rfl
    rw [h1, hlaw 0, Measure.real, Measure.restrict_apply measurableSet_Iic, Iic_inter_Icc01,
      Real.volume_Icc, sub_zero, ENNReal.toReal_ofReal']
  filter_upwards [ae_all_iff.mpr hnull] with ω hω n
  -- §5 S3.2: pointwise identity off the null set
  have key : ∀ k t, X k ω ≤ t ↔ cdfOf P X (X k ω) ≤ cdfOf P X t := by
    intro k t
    constructor
    · exact fun h => hmono h
    · intro h
      rcases le_or_gt (X k ω) t with hle | hlt
      · exact hle
      · exfalso
        obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn hlt
        exact hω k ⟨q, le_antisymm (hmono hq2.le) (h.trans (hmono hq1.le))⟩
  have hedf : ∀ t, edfRV X n ω t
      = edfRV (fun k ω => cdfOf P X (X k ω)) n ω (cdfOf P X t) := by
    intro t
    simp only [edfRV, edf, key]
  obtain ⟨g, hg⟩ : ∃ g : ℝ → ℝ, ∀ u,
      g u = |edfRV (fun k ω => cdfOf P X (X k ω)) n ω u - max (min u 1) 0| := ⟨_, fun _ => rfl⟩
  have hGF : ∀ t, max (min (cdfOf P X t) 1) 0 = cdfOf P X t := by
    intro t
    rw [min_eq_left (hle1 t), max_eq_left (hnn t)]
  have hDX : Dn P X n ω = ⨆ t, g (cdfOf P X t) := by
    unfold Dn
    congr 1
    funext t
    rw [hg, hedf t, hGF t]
  have hDU : Dn P (fun k ω => cdfOf P X (X k ω)) n ω = ⨆ u, g u := by
    unfold Dn
    congr 1
    funext u
    rw [hg, hG u]
  have hg1 : ∀ u, g u ≤ 1 := by
    intro u
    rw [hg]
    obtain ⟨h0, h1⟩ := edf_bounds (fun i : Fin n => cdfOf P X (X i ω)) u
    have hm0 : 0 ≤ max (min u 1) 0 := le_max_right _ _
    have hm1 : max (min u 1) 0 ≤ 1 := max_le (min_le_right _ _) zero_le_one
    exact abs_sub_le_iff.mpr ⟨by simp only [edfRV]; linarith, by simp only [edfRV]; linarith⟩
  have hbdd : BddAbove (range g) := ⟨1, by rintro _ ⟨u, rfl⟩; exact hg1 u⟩
  have hbdd' : BddAbove (range fun t => g (cdfOf P X t)) :=
    ⟨1, by rintro _ ⟨t, rfl⟩; exact hg1 _⟩
  rw [hDX, hDU]
  -- §5 S3.4: compare the two suprema
  apply le_antisymm
  · exact ciSup_le fun t => le_ciSup hbdd (cdfOf P X t)
  · refine ciSup_le fun u => ?_
    by_cases hu : ∃ t, cdfOf P X t = u
    · obtain ⟨t, rfl⟩ := hu
      exact le_ciSup hbdd' t
    · push_neg at hu
      have hsup0 : 0 ≤ ⨆ t, g (cdfOf P X t) :=
        le_ciSup_of_le hbdd' 0 (by rw [hg]; exact abs_nonneg _)
      -- range F ⊇ (0,1) by the intermediate value theorem
      have hout : u ≤ 0 ∨ 1 ≤ u := by
        rcases le_or_gt u 0 with hu0 | h0
        · exact Or.inl hu0
        rcases le_or_gt 1 u with hu1 | h1
        · exact Or.inr hu1
        exfalso
        obtain ⟨a, ha⟩ := (hbot.eventually (gt_mem_nhds h0)).exists
        obtain ⟨b, hb⟩ := (htop.eventually (lt_mem_nhds h1)).exists
        obtain ⟨t, ht⟩ := intermediate_value_univ a b hF ⟨ha.le, hb.le⟩
        exact hu t ht
      rcases hout with hu0 | hu1
      · -- u ≤ 0, u ∉ range F: no U k ω ≤ u, so the term is 0
        have he : edfRV (fun k ω => cdfOf P X (X k ω)) n ω u = 0 := by
          simp only [edfRV, edf]
          rw [Finset.filter_false_of_mem]
          · simp
          · intro i _ hi
            exact hu (X i ω) (le_antisymm hi (hu0.trans (hnn _)))
        rw [hg, he, max_eq_right ((min_le_left _ _).trans hu0), sub_zero, abs_zero]
        exact hsup0
      · rcases Nat.eq_zero_or_pos n with hn | hn
        · -- n = 0 (Lean junk, §5 S3.5): term ≤ 1 ≤ sup_t F t
          subst hn
          have he0 : ∀ v, edfRV (fun k ω => cdfOf P X (X k ω)) 0 ω v = 0 := by
            intro v; simp [edfRV, edf]
          refine (hg1 u).trans (le_of_tendsto' htop (fun t => ?_))
          refine le_trans ?_ (le_ciSup hbdd' t)
          rw [hg, he0, zero_sub, abs_neg, hGF t]
          exact le_abs_self _
        · -- u ≥ 1, n ≥ 1: edf is 1 and G u = 1, so the term is 0
          have he : edfRV (fun k ω => cdfOf P X (X k ω)) n ω u = 1 := by
            simp only [edfRV, edf]
            rw [Finset.filter_true_of_mem (fun i _ => (hle1 _).trans hu1), Finset.card_univ,
              Fintype.card_fin, one_div, inv_mul_cancel₀ (by exact_mod_cast hn.ne')]
          rw [hg, he, min_eq_right hu1, max_eq_left zero_le_one, sub_self, abs_zero]
          exact hsup0

/-- S4. Silent standard fact: a.e. equal sequences have the same limit in distribution
(used to transfer S3 + Donsker). -/
theorem T01_S4 {Ω Ω' : Type} [MeasurableSpace Ω] [MeasurableSpace Ω'] (P : Measure Ω)
    (Y Y' : ℕ → Ω → ℝ) (Q : Measure Ω') (Z : Ω' → ℝ)
    (h : ∀ᵐ ω ∂P, ∀ n, Y n ω = Y' n ω) (hc : ConvInDist P Y' Q Z) : ConvInDist P Y Q Z := by
  intro f
  have : (fun n => ∫ ω, f (Y n ω) ∂P) = (fun n => ∫ ω, f (Y' n ω) ∂P) := by
    funext n
    apply integral_congr_ae
    filter_upwards [h] with ω hω
    simp [hω n]
  rw [this]
  exact hc f

/-- S5. main.tex:61-62: Donsker + sup continuous functional, applied to `U = F ∘ X`
(uses DonskerUniformSup, S2, S3, S4). -/
theorem T01_S5 (hDon : DonskerUniformSup)
    {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hind : ProbabilityTheory.iIndepFun X P)
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) :
    ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
      (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ConvInDist P (fun n ω => Real.sqrt n * Paper.Defs.Dn P X n ω) Q (supAbs B) := by
  intro Ω' _ Q _ B hB
  obtain ⟨h1, h2, h3⟩ := T01_S2 P X hmeas hind hid hF
  -- main.tex:61: Donsker applied to the (uniform) samples F ∘ X_k
  have hU := hDon Ω P (fun k ω => cdfOf P X (X k ω)) h1 h2 h3 Ω' Q B hB
  -- transfer along S3 (a.e. equality of the D_n)
  refine T01_S4 P _ _ Q _ ?_ hU
  filter_upwards [T01_S3 P X hmeas hid hF] with ω hω n
  rw [hω n]

/-- S6. main.tex:62: Kolmogorov's form of `K` (uses KolmogorovFormula). -/
theorem T01_S6 (hKol : KolmogorovFormula)
    (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
    (B : ℝ → Ω' → ℝ) (hB : IsBrownianBridge Q B) :
    ∀ z : ℝ, 0 < z → Q.real {ω | supAbs B ω ≤ z} = Kfun z :=
  hKol Ω' Q B hB

/-- Main theorem, main.tex:53-58. -/
theorem T01 (hDon : DonskerUniformSup) (hKol : KolmogorovFormula)
    {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hind : ProbabilityTheory.iIndepFun X P)
    (hid : ∀ k, P.map (X k) = P.map (X 0))
    (hF : Continuous (cdfOf P X)) :
    KSConclusion P X :=
  -- main.tex:61-62 (conv clause), main.tex:62 (cdf clause)
  ⟨fun Ω' _ Q _ B hB => T01_S5 hDon P X hmeas hind hid hF Ω' Q B hB,
   fun Ω' _ Q _ B hB => T01_S6 hKol Ω' Q B hB⟩

end Paper.T01
