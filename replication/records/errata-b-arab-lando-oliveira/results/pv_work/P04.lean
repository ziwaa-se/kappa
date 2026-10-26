import P04Stmt

/-!
# P04 proof (Proposition 4.6, prop:conv), source/SuperParetoPaper-v12.tex:315-321
S4 (clause 1 of :317) is filled in as the FAIR_IMPLICIT_STEP ruled in
verification/audits/P04_issue_1.md (§5): the source identity P⁻¹∘F_X = 1/Fbar_X = Λ_X+1 (:320,
`P04_S2`) plus the standard duality "increasing concave ↔ inverse convex", written out for the
generalised inverse of :111. The private helpers `s4_*` below are copied from the issue-checker
probe pv_work/probes/issue/P04/P04_issue1_S4fill.lean (proof session 2).
-/

open MeasureTheory Set

namespace Paper.P04

/-- S1 (source :320). -/
theorem P04_S1 (u : ℝ) (hu0 : 0 < u) (hu1 : u < 1) :
    quantile paretoCdf u = 1 / (1 - u) := by
  have h1 : 0 < 1 - u := by linarith
  have h2 : 1 < 1 / (1 - u) := by rw [lt_div_iff₀ h1]; linarith
  have : {x | paretoCdf x ≤ u} = Iic (1 / (1 - u)) := by
    ext x
    simp only [mem_setOf_eq, mem_Iic, paretoCdf]
    split_ifs with hx
    · have hx0 : 0 < x := by linarith
      constructor
      · intro h
        rw [le_div_iff₀ h1]
        have : 1 / x ≥ 1 - u := by linarith
        rw [ge_iff_le, le_div_iff₀ hx0] at this
        nlinarith
      · intro h
        rw [le_div_iff₀ h1] at h
        have : 1 - u ≤ 1 / x := by rw [le_div_iff₀ hx0]; nlinarith
        linarith
    · constructor
      · intro _; have : x < 1 := not_le.mp hx
        linarith
      · intro _; exact hu0.le
  unfold quantile
  rw [this, csSup_Iic]

/-- S2 (source :320). -/
theorem P04_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] (x : ℝ) (hx : x ∈ suppIn (F μ)) :
    quantile paretoCdf (F μ x) = 1 / Fbar μ x ∧ 1 / Fbar μ x = Lam μ x + 1 := by
  obtain ⟨h0, h1⟩ := hx
  have hF : Fbar μ x = 1 - F μ x := rfl
  have hne : Fbar μ x ≠ 0 := by rw [hF]; linarith
  refine ⟨by rw [P04_S1 _ h0 h1, hF], ?_⟩
  unfold Lam
  field_simp
  rw [hF]; ring

private lemma lam_eq (μ : Measure ℝ) (h : ∀ x, F μ x < 1) (x : ℝ) :
    Lam μ x = 1 / Fbar μ x + (-1) := by
  have hne : Fbar μ x ≠ 0 := by
    have : Fbar μ x = 1 - F μ x := rfl
    rw [this]; linarith [h x]
  have hF : Fbar μ x = 1 - F μ x := rfl
  unfold Lam
  field_simp
  rw [hF]; ring

/-- S3 (source :320, "the result follows"). -/
theorem P04_S3 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    ConvexTransformLE (F μ) paretoCdf ↔ IOR μ := by
  unfold ConvexTransformLE IOR
  have heq : EqOn (fun x => quantile paretoCdf (F μ x)) (fun x => Lam μ x + 1) (suppIn (F μ)) :=
    fun x hx => by
      simp only
      rw [(P04_S2 μ x hx).1, (P04_S2 μ x hx).2]
  constructor
  · intro h
    have := (h.congr heq).add_const (-1 : ℝ)
    refine this.congr ?_
    intro x _; simp
  · intro h
    exact (h.add_const (1:ℝ)).congr (fun x hx => (heq hx).symm)

/-! ### Private helpers for S4 (technical; copied from the issue-1 probe)
Quantile facts Q1-Q3 for the generalised inverse of :111 (`s4_le_Q`, `s4_le_F_Q`,
`s4_F_le_of_lt_Q`), the criterion `s4_Q_le`, monotonicity `s4_Q_mono`, the Pareto value and support
(`s4_pareto_val`, `s4_supp_pareto`, cf. `P04_S1`), the algebra `s4_key_le/lt`, and
`s4_G = 1/(1-F) = Λ+1` (the identity of :320, `P04_S2`). -/

section S4Helpers
open Filter Topology ProbabilityTheory

variable (μ : Measure ℝ) [IsProbabilityMeasure μ]

private lemma s4_F_mono : Monotone (F μ) := monotone_cdf μ

private lemma s4_set_nonempty {u : ℝ} (hu : 0 < u) : {x | F μ x ≤ u}.Nonempty := by
  obtain ⟨t, ht⟩ := ((tendsto_cdf_atBot μ).eventually (gt_mem_nhds hu)).exists
  exact ⟨t, le_of_lt ht⟩

private lemma s4_set_bdd {u : ℝ} (hu : u < 1) : BddAbove {x | F μ x ≤ u} := by
  obtain ⟨M, hM⟩ := ((tendsto_cdf_atTop μ).eventually (lt_mem_nhds hu)).exists
  refine ⟨M, fun t ht => ?_⟩
  by_contra h
  push_neg at h
  have h1 := monotone_cdf μ h.le
  simp only [mem_setOf_eq, F] at ht
  linarith

/-- Q1 -/
private lemma s4_le_Q {u t : ℝ} (hu1 : u < 1) (ht : F μ t ≤ u) : t ≤ quantile (F μ) u :=
  le_csSup (s4_set_bdd μ hu1) ht

/-- Q3 -/
private lemma s4_F_le_of_lt_Q {u t : ℝ} (hu0 : 0 < u) (ht : t < quantile (F μ) u) :
    F μ t ≤ u := by
  obtain ⟨s, hs, hts⟩ := exists_lt_of_lt_csSup (s4_set_nonempty μ hu0) ht
  exact (s4_F_mono μ hts.le).trans hs

/-- criterion for `Q u ≤ z` -/
private lemma s4_Q_le {u z : ℝ} (hu0 : 0 < u) (h : ∀ s, z < s → u < F μ s) :
    quantile (F μ) u ≤ z := by
  refine csSup_le (s4_set_nonempty μ hu0) (fun t ht => ?_)
  by_contra h'
  push_neg at h'
  have h2 := h t h'
  simp only [mem_setOf_eq] at ht
  linarith

/-- Q2 (right-continuity of the cdf) -/
private lemma s4_le_F_Q {u : ℝ} (hu0 : 0 < u) (hu1 : u < 1) : u ≤ F μ (quantile (F μ) u) := by
  set q := quantile (F μ) u
  have hcont : Tendsto (cdf μ) (𝓝[>] q) (𝓝 (cdf μ q)) :=
    ((cdf μ).right_continuous q).mono Ioi_subset_Ici_self
  refine ge_of_tendsto hcont ?_
  filter_upwards [self_mem_nhdsWithin] with s hs
  by_contra h
  push_neg at h
  have : s ≤ q := s4_le_Q μ hu1 (le_of_lt h)
  exact absurd hs (not_lt.2 this)

private lemma s4_Q_mono {u v : ℝ} (hu0 : 0 < u) (hv1 : v < 1) (huv : u ≤ v) :
    quantile (F μ) u ≤ quantile (F μ) v :=
  csSup_le_csSup (s4_set_bdd μ hv1) (s4_set_nonempty μ hu0) (fun _ ht => le_trans ht huv)

end S4Helpers

private lemma s4_pareto_val {x : ℝ} (hx : 1 < x) : paretoCdf x = 1 - 1 / x := by
  simp [paretoCdf, hx.le]

private lemma s4_supp_pareto : suppIn paretoCdf = Ioi 1 := by
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
    rw [s4_pareto_val hx]
    have hx0 : 0 < x := by linarith
    have : 1 / x < 1 := by rw [div_lt_one hx0]; exact hx
    have : 0 < 1 / x := by positivity
    constructor <;> linarith

/-- `1 - 1/X ≤ f ↔ X ≤ 1/(1-f)` for `f < 1`, `X > 0`. -/
private lemma s4_key_le {f X : ℝ} (hf : f < 1) (hX : 0 < X) :
    1 - 1 / X ≤ f ↔ X ≤ 1 / (1 - f) := by
  have hd : 0 < 1 - f := by linarith
  rw [le_div_iff₀ hd]
  constructor
  · intro h
    have : 1 - f ≤ 1 / X := by linarith
    rw [le_div_iff₀ hX] at this; linarith
  · intro h
    have : 1 - f ≤ 1 / X := by rw [le_div_iff₀ hX]; linarith
    linarith

private lemma s4_key_lt {f X : ℝ} (hf : f < 1) (hX : 0 < X) :
    1 - 1 / X < f ↔ X < 1 / (1 - f) := by
  have hd : 0 < 1 - f := by linarith
  rw [lt_div_iff₀ hd]
  constructor
  · intro h
    have : 1 - f < 1 / X := by linarith
    rw [lt_div_iff₀ hX] at this; linarith
  · intro h
    have : 1 - f < 1 / X := by rw [lt_div_iff₀ hX]; linarith
    linarith

section S4Directions
open Filter Topology ProbabilityTheory

variable (μ : Measure ℝ) [IsProbabilityMeasure μ]

/-- `G = 1/Fbar = P⁻¹∘F` (source :320, `P04_S2`). -/
private noncomputable def s4_G (y : ℝ) : ℝ := 1 / (1 - F μ y)

omit [IsProbabilityMeasure μ] in
private lemma s4_lam_add_one {y : ℝ} (hy : F μ y < 1) : Lam μ y + 1 = s4_G μ y := by
  have hd : 1 - F μ y ≠ 0 := by linarith
  unfold Lam Fbar s4_G
  field_simp

/-- Forward direction (source :317 clause 1, ⇒): DOR → 𝒫 ≤c F, via :320 (`Λ+1 = 1/Fbar`)
and "concave increasing ⇒ inverse convex" (FAIR_IMPLICIT_STEP, issue 1 §5 (⇒) (a)-(d)). -/
private theorem s4_fwd (h : DOR μ) : ConvexTransformLE paretoCdf (F μ) := by
  obtain ⟨hF1, hconc⟩ := h
  have hS : Convex ℝ (suppIn (F μ)) := hconc.1
  -- :320: Λ+1 = 1/Fbar is concave on S
  have hG : ConcaveOn ℝ (suppIn (F μ)) (s4_G μ) :=
    (hconc.add_const (1 : ℝ)).congr (fun y _ => s4_lam_add_one μ (hF1 y))
  -- (a) upward closure of S
  have hup : ∀ z s, z ∈ suppIn (F μ) → z ≤ s → s ∈ suppIn (F μ) :=
    fun z s hz hzs => ⟨lt_of_lt_of_le hz.1 (s4_F_mono μ hzs), hF1 s⟩
  -- (b) G strictly increasing to the right of a point of S
  have hstrict : ∀ z s, z ∈ suppIn (F μ) → z < s → s4_G μ z < s4_G μ s := by
    intro z s hz hzs
    by_contra hcon
    push_neg at hcon
    have hGz : 0 < s4_G μ z := by
      unfold s4_G; have := hF1 z; apply div_pos one_pos; linarith
    have hX : (0:ℝ) < s4_G μ z + 1 := by linarith
    have hu : 1 - 1 / (s4_G μ z + 1) < 1 := by
      have : 0 < 1 / (s4_G μ z + 1) := by positivity
      linarith
    obtain ⟨w, hw⟩ := (((tendsto_cdf_atTop μ).eventually (lt_mem_nhds hu)).and
      (eventually_gt_atTop s)).exists
    have hwF : s4_G μ z + 1 < s4_G μ w := (s4_key_lt (hF1 w) hX).1 hw.1
    have hws : s < w := hw.2
    have hsS : s ∈ suppIn (F μ) := hup z s hz hzs.le
    have hwS : w ∈ suppIn (F μ) := hup z w hz (hzs.trans hws).le
    set l := (w - s) / (w - z) with hl
    have hwz : 0 < w - z := by linarith
    have hl0 : 0 ≤ l := div_nonneg (by linarith) hwz.le
    have hl1 : 0 ≤ 1 - l := by
      rw [hl, one_sub_div hwz.ne']; exact div_nonneg (by linarith) hwz.le
    have hc := hG.2 hz hwS hl0 hl1 (by ring)
    have hpt : l • z + (1 - l) • w = s := by
      simp only [smul_eq_mul, hl]; field_simp; ring
    rw [hpt] at hc
    simp only [smul_eq_mul] at hc
    have h1l : 0 < 1 - l := by
      rw [hl, one_sub_div hwz.ne']; exact div_pos (by linarith) hwz
    nlinarith
  unfold ConvexTransformLE
  rw [s4_supp_pareto]
  refine ⟨convex_Ioi 1, ?_⟩
  intro x1 hx1 x2 hx2 a b ha hb hab
  have hX := (convex_Ioi (1:ℝ)) hx1 hx2 ha hb hab
  simp only [mem_Ioi, smul_eq_mul] at hx1 hx2 hX ⊢
  rw [s4_pareto_val hx1, s4_pareto_val hx2, s4_pareto_val hX]
  set X := a * x1 + b * x2
  have hu : ∀ x : ℝ, 1 < x → 0 < 1 - 1 / x ∧ 1 - 1 / x < 1 := by
    intro x hx
    have hx0 : 0 < x := by linarith
    have : 1 / x < 1 := by rw [div_lt_one hx0]; exact hx
    have : 0 < 1 / x := by positivity
    constructor <;> linarith
  -- (c)
  set t1 := quantile (F μ) (1 - 1 / x1)
  set t2 := quantile (F μ) (1 - 1 / x2)
  have hFt1 : 1 - 1 / x1 ≤ F μ t1 := s4_le_F_Q μ (hu x1 hx1).1 (hu x1 hx1).2
  have hFt2 : 1 - 1 / x2 ≤ F μ t2 := s4_le_F_Q μ (hu x2 hx2).1 (hu x2 hx2).2
  have ht1S : t1 ∈ suppIn (F μ) := ⟨lt_of_lt_of_le (hu x1 hx1).1 hFt1, hF1 t1⟩
  have ht2S : t2 ∈ suppIn (F μ) := ⟨lt_of_lt_of_le (hu x2 hx2).1 hFt2, hF1 t2⟩
  have hG1 : x1 ≤ s4_G μ t1 := (s4_key_le (hF1 t1) (by linarith)).1 hFt1
  have hG2 : x2 ≤ s4_G μ t2 := (s4_key_le (hF1 t2) (by linarith)).1 hFt2
  -- (d)
  have hzS := hS ht1S ht2S ha hb hab
  have hcz := hG.2 ht1S ht2S ha hb hab
  simp only [smul_eq_mul] at hzS hcz
  refine s4_Q_le μ (hu X hX).1 (fun s hs => ?_)
  have h1 := hstrict _ s hzS hs
  have hXG : X < s4_G μ s := by
    have : X ≤ a * s4_G μ t1 + b * s4_G μ t2 := by
      have := mul_le_mul_of_nonneg_left hG1 ha
      have := mul_le_mul_of_nonneg_left hG2 hb
      simp only [X]
      linarith
    linarith
  exact (s4_key_lt (hF1 s) (by linarith)).2 hXG

/-- Backward direction (source :317 clause 1, ⇐): 𝒫 ≤c F, μ not Dirac → DOR, via :320 and
"convex increasing inverse ⇒ concave" (FAIR_IMPLICIT_STEP, issue 1 §5 (⇐) A-D). -/
private theorem s4_bwd (hnd : ∀ c : ℝ, μ ≠ Measure.dirac c)
    (hT0 : ConvexTransformLE paretoCdf (F μ)) : DOR μ := by
  unfold ConvexTransformLE at hT0
  rw [s4_supp_pareto] at hT0
  set T := fun x => quantile (F μ) (paretoCdf x) with hTdef
  have hu : ∀ x : ℝ, 1 < x → 0 < 1 - 1 / x ∧ 1 - 1 / x < 1 := by
    intro x hx
    have hx0 : 0 < x := by linarith
    have : 1 / x < 1 := by rw [div_lt_one hx0]; exact hx
    have : 0 < 1 / x := by positivity
    constructor <;> linarith
  -- every u ∈ (0,1) is a Pareto value
  have hpar : ∀ u : ℝ, 0 < u → u < 1 → 1 < 1 / (1 - u) ∧ paretoCdf (1 / (1 - u)) = u := by
    intro u hu0 hu1
    have hd : 0 < 1 - u := by linarith
    have h1 : 1 < 1 / (1 - u) := by rw [lt_div_iff₀ hd]; linarith
    refine ⟨h1, ?_⟩
    rw [s4_pareto_val h1]; field_simp
  -- Step B: F < 1 everywhere
  have hF1 : ∀ x, F μ x < 1 := by
    by_contra hcon
    push_neg at hcon
    obtain ⟨b0, hb0⟩ := hcon
    have hTb : ∀ x, 1 < x → T x ≤ b0 := by
      intro x hx
      simp only [hTdef]
      rw [s4_pareto_val hx]
      refine s4_Q_le μ (hu x hx).1 (fun s hs => ?_)
      have := s4_F_mono μ hs.le
      linarith [(hu x hx).2]
    -- convex and bounded above on (1,∞): nonincreasing
    have hnoninc : ∀ x1 x2, 1 < x1 → x1 < x2 → T x2 ≤ T x1 := by
      intro x1 x2 hx1 hx12
      by_contra hc
      push_neg at hc
      have hd : 0 < T x2 - T x1 := by linarith
      have hx2 : 1 < x2 := by linarith
      obtain ⟨k, hk⟩ := exists_nat_gt ((b0 - T x2) / (T x2 - T x1))
      obtain ⟨kr, hkr⟩ : ∃ kr : ℝ, kr = (k : ℝ) := ⟨_, rfl⟩
      rw [← hkr] at hk
      have hk0 : (0:ℝ) ≤ kr := by rw [hkr]; exact Nat.cast_nonneg k
      have hk1 : (0:ℝ) < kr + 1 := by linarith
      have hx3 : 1 < x2 + kr * (x2 - x1) := by
        have : 0 ≤ kr * (x2 - x1) := mul_nonneg hk0 (by linarith)
        linarith
      have hwa : (0:ℝ) ≤ kr / (kr + 1) := div_nonneg hk0 hk1.le
      have hwb : (0:ℝ) ≤ 1 / (kr + 1) := div_nonneg zero_le_one hk1.le
      have hwab : kr / (kr + 1) + 1 / (kr + 1) = 1 := by field_simp
      have hc3 := hT0.2 (show x1 ∈ Ioi (1:ℝ) from hx1)
        (show x2 + kr * (x2 - x1) ∈ Ioi (1:ℝ) from hx3) hwa hwb hwab
      have hpt : (kr / (kr + 1)) • x1 + (1 / (kr + 1)) • (x2 + kr * (x2 - x1)) = x2 := by
        simp only [smul_eq_mul]; field_simp; ring
      rw [hpt] at hc3
      simp only [smul_eq_mul] at hc3
      have : (kr + 1) * T x2 ≤ kr * T x1 + T (x2 + kr * (x2 - x1)) := by
        have e : kr / (kr + 1) * T x1 + 1 / (kr + 1) * T (x2 + kr * (x2 - x1))
            = (kr * T x1 + T (x2 + kr * (x2 - x1))) / (kr + 1) := by
          field_simp
        rw [e, le_div_iff₀ hk1] at hc3; linarith
      have hT3 := hTb _ hx3
      have : b0 - T x2 < kr * (T x2 - T x1) := by
        rwa [div_lt_iff₀ hd] at hk
      nlinarith
    -- T is monotone
    have hmono : ∀ x1 x2, 1 < x1 → x1 ≤ x2 → T x1 ≤ T x2 := by
      intro x1 x2 hx1 hx12
      have hx2 : 1 < x2 := by linarith
      simp only [hTdef]
      rw [s4_pareto_val hx1, s4_pareto_val hx2]
      refine s4_Q_mono μ (hu x1 hx1).1 (hu x2 hx2).2 ?_
      have : 1 / x2 ≤ 1 / x1 := one_div_le_one_div_of_le (by linarith) hx12
      linarith
    -- T constant = c on (1,∞)
    set c := T 2 with hc
    have hconst : ∀ x, 1 < x → T x = c := by
      intro x hx
      rcases lt_trichotomy x 2 with hx2 | hx2 | hx2
      · exact le_antisymm (hmono x 2 hx hx2.le) (hnoninc x 2 hx hx2)
      · rw [hx2]
      · exact le_antisymm (hnoninc 2 x (by norm_num) hx2) (hmono 2 x (by norm_num) hx2.le)
    have hQc : ∀ u : ℝ, 0 < u → u < 1 → quantile (F μ) u = c := by
      intro u hu0 hu1
      obtain ⟨h1, h2⟩ := hpar u hu0 hu1
      have := hconst _ h1
      simp only [hTdef, h2] at this
      exact this
    have hbelow : ∀ t, t < c → F μ t = 0 := by
      intro t ht
      refine le_antisymm ?_ (cdf_nonneg μ t)
      refine le_of_forall_pos_le_add (fun ε hε => ?_)
      rcases lt_or_ge ε 1 with hε1 | hε1
      · have := s4_F_le_of_lt_Q μ hε
          (show t < quantile (F μ) ε by rw [hQc ε hε hε1]; exact ht)
        linarith
      · have h1 : F μ t ≤ 1 := cdf_le_one μ t
        linarith
    have habove : ∀ t, c ≤ t → F μ t = 1 := by
      intro t ht
      refine le_antisymm (cdf_le_one μ t) ?_
      have hFc : ∀ u : ℝ, 0 < u → u < 1 → u ≤ F μ t := by
        intro u hu0 hu1
        have := s4_le_F_Q μ hu0 hu1
        rw [hQc u hu0 hu1] at this
        exact this.trans (s4_F_mono μ ht)
      rcases lt_or_ge (F μ t) 1 with hlt | hge
      · have h0 : 0 ≤ F μ t := cdf_nonneg μ t
        have hm := hFc ((F μ t + 1) / 2) (by linarith) (by linarith)
        linarith
      · exact hge
    apply hnd c
    refine Measure.ext_of_Iic μ (Measure.dirac c) (fun x => ?_)
    rw [← ofReal_cdf, Measure.dirac_apply' _ measurableSet_Iic]
    by_cases hcx : c ≤ x
    · have := habove x hcx
      simp only [F] at this
      simp [this, indicator, hcx]
    · have := hbelow x (not_le.1 hcx)
      simp only [F] at this
      simp [this, indicator, hcx]
  -- Step C: Q (F p) = p for p ∈ S
  have hTcont : ContinuousOn T (Ioi 1) := hT0.continuousOn isOpen_Ioi
  have hQF : ∀ p, p ∈ suppIn (F μ) → quantile (F μ) (F μ p) = p := by
    intro p hp
    refine le_antisymm ?_ (s4_le_Q μ hp.2 le_rfl)
    refine le_of_not_lt (fun hgt => ?_)
    set v := F μ p
    obtain ⟨hxp, hparv⟩ := hpar v hp.1 hp.2
    set xp := 1 / (1 - v)
    have hTxp : T xp = quantile (F μ) v := by simp only [hTdef, hparv]
    have hleft : ∀ x ∈ Ioo 1 xp, T x ≤ p := by
      intro x hx
      simp only [hTdef]
      rw [s4_pareto_val hx.1]
      refine s4_Q_le μ (hu x hx.1).1 (fun s hs => ?_)
      have h1 : F μ p ≤ F μ s := s4_F_mono μ hs.le
      have hx0 : 0 < x := by linarith [hx.1]
      have : 1 - 1 / x < v := by
        exact (s4_key_lt hp.2 hx0).2 hx.2
      linarith
    have hca : ContinuousAt T xp := hTcont.continuousAt (isOpen_Ioi.mem_nhds hxp)
    have hlim : T xp ≤ p :=
      le_of_tendsto (hca.tendsto.mono_left nhdsWithin_le_nhds)
        (eventually_of_mem (Ioo_mem_nhdsLT hxp) hleft)
    rw [hTxp] at hlim
    linarith
  -- Step D: G = 1/Fbar concave on S
  have hG : ConcaveOn ℝ (suppIn (F μ)) (s4_G μ) := by
    have hS : Convex ℝ (suppIn (F μ)) := by
      refine Set.OrdConnected.convex ⟨fun x hx y hy z hz => ?_⟩
      exact ⟨lt_of_lt_of_le hx.1 (s4_F_mono μ hz.1), lt_of_le_of_lt (s4_F_mono μ hz.2) hy.2⟩
    refine ⟨hS, ?_⟩
    intro p hp q hq a b ha hb hab
    simp only [smul_eq_mul]
    have hwS := hS hp hq ha hb hab
    simp only [smul_eq_mul] at hwS
    set w := a * p + b * q
    have hGgt : ∀ y, y ∈ suppIn (F μ) → 1 < s4_G μ y := by
      intro y hy
      unfold s4_G
      have hd : 0 < 1 - F μ y := by linarith [hy.2]
      rw [lt_div_iff₀ hd]; linarith [hy.1]
    have hGp := hGgt p hp
    have hGq := hGgt q hq
    set X := a * s4_G μ p + b * s4_G μ q
    have hX : 1 < X := by
      have := (convex_Ioi (1:ℝ)) (show s4_G μ p ∈ Ioi 1 from hGp)
        (show s4_G μ q ∈ Ioi 1 from hGq) ha hb hab
      simpa [smul_eq_mul] using this
    refine (s4_key_le (hF1 w) (by linarith)).1 ?_
    refine le_of_not_lt (fun hlt => ?_)
    have hwQ : w < quantile (F μ) (1 - 1 / X) := by
      refine lt_of_not_le (fun hge => ?_)
      have := s4_le_F_Q μ (hu X hX).1 (hu X hX).2
      have := s4_F_mono μ hge
      linarith
    have hTX : T X = quantile (F μ) (1 - 1 / X) := by simp only [hTdef, s4_pareto_val hX]
    have hTp : T (s4_G μ p) = p := by
      simp only [hTdef, s4_pareto_val hGp]
      have : 1 - 1 / s4_G μ p = F μ p := by unfold s4_G; field_simp
      rw [this, hQF p hp]
    have hTq : T (s4_G μ q) = q := by
      simp only [hTdef, s4_pareto_val hGq]
      have : 1 - 1 / s4_G μ q = F μ q := by unfold s4_G; field_simp
      rw [this, hQF q hq]
    have hc := hT0.2 (show s4_G μ p ∈ Ioi (1:ℝ) from hGp)
      (show s4_G μ q ∈ Ioi (1:ℝ) from hGq) ha hb hab
    simp only [smul_eq_mul] at hc
    have : T X ≤ w := by
      have e : T X = T (a * s4_G μ p + b * s4_G μ q) := rfl
      rw [e]
      calc T (a * s4_G μ p + b * s4_G μ q) ≤ a * T (s4_G μ p) + b * T (s4_G μ q) := hc
        _ = w := by rw [hTp, hTq]
    rw [hTX] at this
    linarith
  -- Λ = G - 1 concave (:320)
  refine ⟨hF1, (hG.add_const (-1 : ℝ)).congr (fun y hy => ?_)⟩
  show s4_G μ y + -1 = Lam μ y
  rw [← s4_lam_add_one μ (hF1 y)]; ring

end S4Directions

/-- S4 (source :317 clause 1, proof :320): filled in as the FAIR_IMPLICIT_STEP of
verification/audits/P04_issue_1.md §5 (duality increasing concave ↔ inverse convex). -/
theorem P04_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hnd : ∀ c : ℝ, μ ≠ Measure.dirac c) :
    DOR μ ↔ ConvexTransformLE paretoCdf (F μ) :=
  ⟨s4_fwd μ, s4_bwd μ hnd⟩

/-- S5 (source :317, :301). -/
theorem P04_S5 (hX01 : P04_X01Tool) (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    DOR μ ↔ SuperPareto μ := by
  rw [hX01 μ inferInstance]
  unfold DOR
  constructor
  · rintro ⟨h, hc⟩
    refine ⟨h, ?_⟩
    have := hc.add_const (1 : ℝ)
    refine this.congr ?_
    intro x _; simp [lam_eq μ h x]
  · rintro ⟨h, hc⟩
    refine ⟨h, ?_⟩
    have := hc.add_const (-1 : ℝ)
    refine this.congr ?_
    intro x _; simp [lam_eq μ h x]

/-- Main theorem (Proposition 4.6, source :315-318). -/
theorem P04_main (hX01 : P04_X01Tool) (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hnd : ∀ c : ℝ, μ ≠ Measure.dirac c) :
    (DOR μ ↔ ConvexTransformLE paretoCdf (F μ)) ∧
    (SuperPareto μ ↔ ConvexTransformLE paretoCdf (F μ)) ∧
    (IOR μ ↔ ConvexTransformLE (F μ) paretoCdf) :=
  ⟨P04_S4 μ hnd, (P04_S5 hX01 μ).symm.trans (P04_S4 μ hnd), (P04_S3 μ).symm⟩

end Paper.P04
