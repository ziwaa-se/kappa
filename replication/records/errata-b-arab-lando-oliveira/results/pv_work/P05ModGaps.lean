import P05Stmt

namespace Paper.P05

open Paper.L01 Paper.L02

/-- Technical helper: `-Log p` in `EReal` (`-Log 0 = +∞`), equal to the `if` of `negLogInv`. -/
private noncomputable def psi (p : ℝ) : EReal :=
  if p = 0 then ⊤ else ((-Real.log p : ℝ) : EReal)

private lemma genInv_zero : genInv Hcdf 0 = 0 := by
  unfold genInv
  have h : IsGreatest ((fun x : ℝ => (x : EReal)) '' {x : ℝ | Hcdf x ≤ 0}) (0 : EReal) := by
    constructor
    · refine ⟨0, ?_, by simp⟩
      simp [Hcdf]
    · rintro _ ⟨x, hx, rfl⟩
      have : x ≤ 0 := by
        by_contra hpos
        push_neg at hpos
        have : Hcdf x = Real.exp (-(1 / x)) := by simp [Hcdf, hpos]
        have h2 := Real.exp_pos (-(1 / x))
        simp only [Set.mem_setOf_eq] at hx
        linarith
      have h3 : ((x:ℝ):EReal) ≤ ((0:ℝ):EReal) := EReal.coe_le_coe_iff.mpr this
      simpa using h3
  exact h.csSup_eq

private lemma genInv_one : genInv Hcdf 1 = ⊤ := by
  unfold genInv
  rw [sSup_eq_top]
  intro b hb
  obtain ⟨r, hr1, hr2⟩ := EReal.lt_iff_exists_real_btwn.mp hb
  refine ⟨(r : EReal), ⟨r, ?_, rfl⟩, hr1⟩
  show Hcdf r ≤ 1
  unfold Hcdf
  split_ifs with h
  · have : Real.exp (-(1 / r)) ≤ 1 := by
      rw [Real.exp_le_one_iff]
      have : 0 < 1 / r := by positivity
      linarith
    exact this
  · norm_num

private lemma genInv_mid (p : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) :
    genInv Hcdf p = ((-(1 / Real.log p) : ℝ) : EReal) := by
  obtain ⟨hp0, hp1⟩ := hp
  have hL : Real.log p < 0 := Real.log_neg hp0 hp1
  have hc : 0 < -(1 / Real.log p) := by
    have : 1 / Real.log p < 0 := by
      rw [one_div]; exact inv_lt_zero.mpr hL
    linarith
  have key : ∀ x : ℝ, 0 < x → (Hcdf x ≤ p ↔ x ≤ -(1 / Real.log p)) := by
    intro x hx
    have hH : Hcdf x = Real.exp (-(1 / x)) := by simp [Hcdf, hx]
    rw [hH, ← Real.le_log_iff_exp_le hp0]
    have e : -(1 / Real.log p) = 1 / (-Real.log p) := by
      rw [one_div, one_div, ← inv_neg]
    rw [e, le_div_iff₀ (neg_pos.mpr hL)]
    constructor
    · intro h
      have h1 : -Real.log p ≤ 1 / x := by linarith
      rw [le_div_iff₀ hx] at h1
      linarith
    · intro h
      have h1 : -Real.log p ≤ 1 / x := by
        rw [le_div_iff₀ hx]; linarith
      linarith
  unfold genInv
  have h : IsGreatest ((fun x : ℝ => (x : EReal)) '' {x : ℝ | Hcdf x ≤ p})
      ((-(1 / Real.log p) : ℝ) : EReal) := by
    constructor
    · refine ⟨-(1 / Real.log p), ?_, rfl⟩
      exact (key _ hc).mpr le_rfl
    · rintro _ ⟨x, hx, rfl⟩
      have hx' : Hcdf x ≤ p := hx
      have : x ≤ -(1 / Real.log p) := by
        by_cases hx0 : 0 < x
        · exact (key x hx0).mp hx'
        · push_neg at hx0; linarith
      exact EReal.coe_le_coe_iff.mpr this
  exact h.csSup_eq

private lemma psi_eq (p : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) :
    recipE (genInv Hcdf p) = psi p := by
  obtain ⟨h0, h1⟩ := hp
  rcases h0.eq_or_lt with h | h
  · subst h
    rw [genInv_zero]
    simp [psi, recipE]
  rcases h1.eq_or_lt with h' | h'
  · subst h'
    rw [genInv_one]
    simp [psi, recipE]
  · rw [genInv_mid p ⟨h, h'⟩]
    have hL : Real.log p < 0 := Real.log_neg h h'
    have hne : -(1 / Real.log p) ≠ 0 := by
      have : 1 / Real.log p < 0 := by
        rw [one_div]; exact inv_lt_zero.mpr hL
      linarith
    have hr : ∀ r : ℝ, recipE (r : EReal) = if r = 0 then ⊤ else ((1 / r : ℝ) : EReal) :=
      fun r => rfl
    rw [hr, if_neg hne]
    simp only [psi, if_neg h.ne']
    congr 1
    field_simp

private lemma F_mem (μ : MeasureTheory.Measure ℝ) (t : ℝ) : F μ t ∈ Set.Icc (0:ℝ) 1 :=
  ⟨ProbabilityTheory.cdf_nonneg μ t, ProbabilityTheory.cdf_le_one μ t⟩

/-- S1. Source F:434 (first half). -/
theorem P05_S1 (p : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) :
    genInv Hcdf p = ((-(1 / Real.log p) : ℝ) : EReal) :=
  genInv_mid p hp

/-- S2. Source F:434 (second half). -/
theorem P05_S2 (μ : MeasureTheory.Measure ℝ) (x : ℝ) (hx : 0 < x) :
    recipE (genInv Hcdf (F μ (1 / x))) = negLogInv μ x := by
  rw [psi_eq _ (F_mem μ _)]
  rfl

open Filter Topology

private lemma psi_nonneg (p : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) : 0 ≤ psi p := by
  obtain ⟨h0, h1⟩ := hp
  unfold psi
  split_ifs with h
  · exact le_top
  · have hp : 0 < p := lt_of_le_of_ne h0 (Ne.symm h)
    have : 0 ≤ -Real.log p := by
      have := Real.log_nonpos h0 h1
      linarith
    exact_mod_cast this

private lemma psi_anti (a b : ℝ) (ha : 0 ≤ a) (hab : a ≤ b) : psi b ≤ psi a := by
  unfold psi
  by_cases h : a = 0
  · simp [h]
  · have hb : b ≠ 0 := by
      have : 0 < a := lt_of_le_of_ne ha (Ne.symm h)
      exact (lt_of_lt_of_le this hab).ne'
    simp only [if_neg h, if_neg hb]
    have : 0 < a := lt_of_le_of_ne ha (Ne.symm h)
    have := Real.log_le_log this hab
    exact_mod_cast (by linarith : -Real.log b ≤ -Real.log a)

private lemma psi_cont : ContinuousOn psi (Set.Ici (0:ℝ)) := by
  intro p hp
  rcases (Set.mem_Ici.mp hp).eq_or_lt with h | h
  · subst h
    have hpsi0 : psi 0 = ⊤ := by simp [psi]
    rw [ContinuousWithinAt, hpsi0, EReal.tendsto_nhds_top_iff_real]
    intro r
    have hlt : (0:ℝ) < Real.exp (-r - 1) := Real.exp_pos _
    filter_upwards [Ico_mem_nhdsGE hlt] with q hq
    obtain ⟨hq0, hq1⟩ := hq
    unfold psi
    by_cases hq' : q = 0
    · simp [hq']
    · rw [if_neg hq']
      have hqpos : 0 < q := lt_of_le_of_ne hq0 (Ne.symm hq')
      have : Real.log q < -r - 1 := (Real.log_lt_iff_lt_exp hqpos).mpr hq1
      have : (r:ℝ) < -Real.log q := by linarith
      exact_mod_cast this
  · apply ContinuousAt.continuousWithinAt
    have hc : ContinuousAt (fun q : ℝ => ((-Real.log q : ℝ) : EReal)) p :=
      continuous_coe_real_ereal.continuousAt.comp (Real.continuousAt_log h.ne').neg
    refine hc.congr ?_
    filter_upwards [isOpen_ne.mem_nhds h.ne'] with q hq
    simp [psi, hq]

/-- Abstract transfer lemma (technical): one-sided-limit argument for S3. -/
private lemma transfer (g gm : ℝ → EReal)
    (hnn : ∀ x, 0 < x → 0 ≤ gm x)
    (hmono : ∀ x y, 0 < x → x ≤ y → g x ≤ g y)
    (hge : ∀ x, 0 < x → g x ≤ gm x)
    (hA : ∀ x, 0 < x → Tendsto g (𝓝[>] x) (𝓝 (gm x)))
    (hC : ∀ x, 0 < x → Tendsto g (𝓝[<] x) (𝓝 (g x))) :
    SubadditiveOnE gm (Set.Ioi 0) ↔ SubadditiveOnE g (Set.Ioi 0) := by
  have hbot : ∀ x, 0 < x → gm x ≠ ⊥ := by
    intro x hx h
    have := hnn x hx
    rw [h] at this
    simp at this
  have hgm_le : ∀ a b, 0 < a → a < b → gm a ≤ g b := by
    intro a b ha hab
    refine le_of_tendsto (hA a ha) ?_
    filter_upwards [Ioo_mem_nhdsGT hab] with u hu
    exact hmono u b (ha.trans hu.1) hu.2.le
  constructor
  · intro hS x hx y hy
    have hx : 0 < x := hx
    have hy : 0 < y := hy
    refine le_of_tendsto (hC (x + y) (by positivity)) ?_
    have hm : 0 < min x y := lt_min hx hy
    have hlt : x + y - min x y < x + y := by linarith
    filter_upwards [Ioo_mem_nhdsLT hlt] with z hz
    obtain ⟨hz1, hz2⟩ := hz
    set d := x + y - z with hd
    have hdpos : 0 < d := by linarith
    have hdm : d < min x y := by linarith
    have hx' : 0 < x - d / 2 := by
      have := min_le_left x y; linarith
    have hy' : 0 < y - d / 2 := by
      have := min_le_right x y; linarith
    have hzz : z = (x - d / 2) + (y - d / 2) := by linarith
    have hzpos : 0 < z := by rw [hzz]; linarith
    calc g z ≤ gm z := hge z hzpos
      _ = gm ((x - d / 2) + (y - d / 2)) := by rw [← hzz]
      _ ≤ gm (x - d / 2) + gm (y - d / 2) := hS _ hx' _ hy'
      _ ≤ g x + g y :=
        add_le_add (hgm_le _ _ hx' (by linarith)) (hgm_le _ _ hy' (by linarith))
  · intro hS x hx y hy
    have hx : 0 < x := hx
    have hy : 0 < y := hy
    have shift : ∀ a c : ℝ, 0 < c → Tendsto (fun ε : ℝ => a + c * ε) (𝓝[>] 0) (𝓝[>] a) := by
      intro a c hc
      refine tendsto_nhdsWithin_iff.mpr ⟨?_, ?_⟩
      · have : Continuous (fun ε : ℝ => a + c * ε) := by fun_prop
        have h2 := this.tendsto 0
        simp only [mul_zero, add_zero] at h2
        exact h2.mono_left nhdsWithin_le_nhds
      · filter_upwards [self_mem_nhdsWithin] with ε hε
        have : (0:ℝ) < ε := hε
        show a < a + c * ε
        nlinarith
    have h1 : Tendsto (fun ε : ℝ => g (x + y + 2 * ε)) (𝓝[>] 0) (𝓝 (gm (x + y))) := by
      have := (hA (x + y) (by positivity)).comp (shift (x + y) 2 (by norm_num))
      exact this
    have h2 : Tendsto (fun ε : ℝ => g (x + 1 * ε) + g (y + 1 * ε)) (𝓝[>] 0)
        (𝓝 (gm x + gm y)) := by
      have ha := (hA x hx).comp (shift x 1 one_pos)
      have hb := (hA y hy).comp (shift y 1 one_pos)
      have hadd : ContinuousAt (fun p : EReal × EReal => p.1 + p.2) (gm x, gm y) := by
        apply EReal.continuousAt_add
        · right; exact hbot y hy
        · left; exact hbot x hx
      exact hadd.tendsto.comp (ha.prodMk_nhds hb)
    refine le_of_tendsto_of_tendsto h1 h2 ?_
    filter_upwards [self_mem_nhdsWithin] with ε hε
    have : (0:ℝ) < ε := hε
    have := hS (x + 1 * ε) (by show 0 < x + 1 * ε; linarith) (y + 1 * ε)
      (by show 0 < y + 1 * ε; linarith)
    have e : x + 1 * ε + (y + 1 * ε) = x + y + 2 * ε := by ring
    rw [e] at this
    exact this

private lemma F_leftLim_mem (μ : MeasureTheory.Measure ℝ) (t : ℝ) :
    Function.leftLim (F μ) t ∈ Set.Icc (0:ℝ) 1 := by
  have hm : Monotone (F μ) := (ProbabilityTheory.cdf μ).mono
  refine ⟨?_, ?_⟩
  · exact (F_mem μ (t - 1)).1.trans (hm.le_leftLim (by linarith))
  · exact (hm.leftLim_le le_rfl).trans (F_mem μ t).2

/-- S3. Source F:431-435 (silent step). -/
theorem P05_S3 (μ : MeasureTheory.Measure ℝ) :
    SubadditiveOnE (invSubFn (F μ) Hcdf) (Set.Ioi 0) ↔
      SubadditiveOnE (fun x => recipE (genInv Hcdf (F μ (1 / x)))) (Set.Ioi 0) := by
  have hm : Monotone (F μ) := (ProbabilityTheory.cdf μ).mono
  have e1 : invSubFn (F μ) Hcdf = fun x => psi (Function.leftLim (F μ) (1 / x)) := by
    funext x
    exact psi_eq _ (F_leftLim_mem μ _)
  have e2 : (fun x => recipE (genInv Hcdf (F μ (1 / x)))) = fun x => psi (F μ (1 / x)) := by
    funext x
    exact psi_eq _ (F_mem μ _)
  rw [e1, e2]
  have hinv_gt : ∀ x : ℝ, 0 < x →
      Tendsto (fun y : ℝ => 1 / y) (𝓝[>] x) (𝓝[<] (1 / x)) := by
    intro x hx
    refine tendsto_nhdsWithin_iff.mpr ⟨?_, ?_⟩
    · exact ((continuousAt_const.div continuousAt_id hx.ne').tendsto).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with y hy
      exact one_div_lt_one_div_of_lt hx hy
  have hinv_lt : ∀ x : ℝ, 0 < x →
      Tendsto (fun y : ℝ => 1 / y) (𝓝[<] x) (𝓝[>] (1 / x)) := by
    intro x hx
    refine tendsto_nhdsWithin_iff.mpr ⟨?_, ?_⟩
    · exact ((continuousAt_const.div continuousAt_id hx.ne').tendsto).mono_left nhdsWithin_le_nhds
    · filter_upwards [Ioo_mem_nhdsLT (show x / 2 < x by linarith)] with y hy
      exact one_div_lt_one_div_of_lt (by linarith [hy.1]) hy.2
  apply transfer
  · intro x hx
    exact psi_nonneg _ (F_leftLim_mem μ _)
  · intro x y hx hxy
    have h1 : 1 / y ≤ 1 / x := one_div_le_one_div_of_le hx hxy
    exact psi_anti _ _ (F_mem μ _).1 (hm h1)
  · intro x hx
    exact psi_anti _ _ (F_leftLim_mem μ _).1 (hm.leftLim_le le_rfl)
  · intro x hx
    have h0 : Tendsto (fun y : ℝ => F μ (1 / y)) (𝓝[>] x) (𝓝 (Function.leftLim (F μ) (1 / x))) :=
      (hm.tendsto_leftLim (1 / x)).comp (hinv_gt x hx)
    have h1 : Tendsto (fun y : ℝ => F μ (1 / y)) (𝓝[>] x)
        (𝓝[Set.Ici 0] (Function.leftLim (F μ) (1 / x))) := by
      refine tendsto_nhdsWithin_iff.mpr ⟨h0, ?_⟩
      exact Eventually.of_forall fun y => (F_mem μ _).1
    exact (psi_cont _ (F_leftLim_mem μ _).1).tendsto.comp h1
  · intro x hx
    have h0 : Tendsto (fun y : ℝ => F μ (1 / y)) (𝓝[<] x) (𝓝 (F μ (1 / x))) :=
      (((ProbabilityTheory.cdf μ).right_continuous (1 / x)).mono
        Set.Ioi_subset_Ici_self).tendsto.comp (hinv_lt x hx)
    have h1 : Tendsto (fun y : ℝ => F μ (1 / y)) (𝓝[<] x)
        (𝓝[Set.Ici 0] (F μ (1 / x))) := by
      refine tendsto_nhdsWithin_iff.mpr ⟨h0, ?_⟩
      exact Eventually.of_forall fun y => (F_mem μ _).1
    exact (psi_cont _ (F_mem μ _).1).tendsto.comp h1

/-- Gap for the stopped obligation `P05_main` (the printed statement, F:431; it lacks the
`F_X(0)=0` qualifier and is false for `μ = dirac 0`). Full ∀-closure of its type. -/
def P05_main_Gap : Prop := ∀ μ : MeasureTheory.Measure ℝ, P05Conclusion μ

theorem P05_main_mod_gaps (hGap_main : P05_main_Gap) (μ : MeasureTheory.Measure ℝ) :
    P05Conclusion μ := hGap_main μ

end Paper.P05
