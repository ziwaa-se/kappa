import Mathlib

/-!
# Heavy tails: Theorem 2.2(ii) (via Theorem 5.18 / Prop. 3.6) and Corollary 2.3(ii), `β < 1`
-/

open Filter Topology MeasureTheory

noncomputable section

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- One leapfrog step (same as in `LightTails.lean`). -/
def lfStep (g : E → E) (ε : ℝ) (s : E × E) : E × E :=
  let p' := s.2 - (ε / 2) • g s.1
  let x' := s.1 + ε • p'
  (x', p' - (ε / 2) • g x')

def lf (g : E → E) (ε : ℝ) (x0 p0 : E) : ℕ → E × E
  | 0 => (x0, p0)
  | n + 1 => lfStep g ε (lf g ε x0 p0 n)

lemma X_succ (g : E → E) (ε : ℝ) (x0 p0 : E) (n : ℕ) :
    (lf g ε x0 p0 (n+1)).1 = (lf g ε x0 p0 n).1 + ε • (lf g ε x0 p0 n).2
      - (ε ^ 2 / 2) • g (lf g ε x0 p0 n).1 := by
  simp only [lf, lfStep]; rw [smul_sub, smul_smul]; ring_nf; abel

lemma P_succ (g : E → E) (ε : ℝ) (x0 p0 : E) (n : ℕ) :
    (lf g ε x0 p0 (n+1)).2 = (lf g ε x0 p0 n).2
      - (ε / 2) • (g (lf g ε x0 p0 n).1 + g (lf g ε x0 p0 (n+1)).1) := by
  conv_rhs => rw [smul_add]
  simp only [lf, lfStep]; abel

/-- Displacement bound behind Theorem 5.18: if `‖∇U‖ ≤ B` then
`‖x_{nε} - x_0‖ ≤ nε‖p_0‖ + ε² B n² / 2`  (the paper's `Lε²M/2 + Mε²L(L-1)/2 + Lε‖p0‖`). -/
theorem displacement (g : E → E) {ε B : ℝ} (hε : 0 ≤ ε) (hB : ∀ x, ‖g x‖ ≤ B)
    (x0 p0 : E) (n : ℕ) :
    ‖(lf g ε x0 p0 n).2 - p0‖ ≤ n * ε * B ∧
      ‖(lf g ε x0 p0 n).1 - x0‖ ≤ n * ε * ‖p0‖ + ε ^ 2 * B * n ^ 2 / 2 := by
  have hB0 : 0 ≤ B := le_trans (norm_nonneg _) (hB x0)
  induction n with
  | zero => simp [lf]
  | succ n ih =>
    obtain ⟨ih1, ih2⟩ := ih
    constructor
    · rw [P_succ]
      have : (lf g ε x0 p0 n).2 - (ε / 2) • (g (lf g ε x0 p0 n).1 + g (lf g ε x0 p0 (n+1)).1)
          - p0 = ((lf g ε x0 p0 n).2 - p0)
            - (ε / 2) • (g (lf g ε x0 p0 n).1 + g (lf g ε x0 p0 (n+1)).1) := by abel
      rw [this]
      calc _ ≤ ‖(lf g ε x0 p0 n).2 - p0‖
              + ‖(ε / 2) • (g (lf g ε x0 p0 n).1 + g (lf g ε x0 p0 (n+1)).1)‖ := norm_sub_le _ _
        _ ≤ n * ε * B + ε / 2 * (B + B) := by
            gcongr
            rw [norm_smul, Real.norm_of_nonneg (by positivity)]
            gcongr
            exact le_trans (norm_add_le _ _) (add_le_add (hB _) (hB _))
        _ = (↑(n+1)) * ε * B := by push_cast; ring
    · rw [X_succ]
      have : (lf g ε x0 p0 n).1 + ε • (lf g ε x0 p0 n).2 - (ε ^ 2 / 2) • g (lf g ε x0 p0 n).1
          - x0 = ((lf g ε x0 p0 n).1 - x0) + ε • ((lf g ε x0 p0 n).2 - p0) + ε • p0
            - (ε ^ 2 / 2) • g (lf g ε x0 p0 n).1 := by
        rw [smul_sub]; abel
      rw [this]
      have hp : ‖ε • ((lf g ε x0 p0 n).2 - p0)‖ ≤ ε * (n * ε * B) := by
        rw [norm_smul, Real.norm_of_nonneg hε]; gcongr
      have hq : ‖ε • p0‖ = ε * ‖p0‖ := by rw [norm_smul, Real.norm_of_nonneg hε]
      have hr : ‖(ε ^ 2 / 2) • g (lf g ε x0 p0 n).1‖ ≤ ε ^ 2 / 2 * B := by
        rw [norm_smul, Real.norm_of_nonneg (by positivity)]; gcongr; exact hB _
      calc _ ≤ ‖((lf g ε x0 p0 n).1 - x0) + ε • ((lf g ε x0 p0 n).2 - p0) + ε • p0‖
              + ‖(ε ^ 2 / 2) • g (lf g ε x0 p0 n).1‖ := norm_sub_le _ _
        _ ≤ ‖(lf g ε x0 p0 n).1 - x0‖ + ‖ε • ((lf g ε x0 p0 n).2 - p0)‖ + ‖ε • p0‖
              + ‖(ε ^ 2 / 2) • g (lf g ε x0 p0 n).1‖ := by
            gcongr
            exact le_trans (norm_add_le _ _) (add_le_add_right (norm_add_le _ _) _)
        _ ≤ (n * ε * ‖p0‖ + ε ^ 2 * B * n ^ 2 / 2) + ε * (n * ε * B) + ε * ‖p0‖
              + ε ^ 2 / 2 * B := by rw [hq]; gcongr
        _ = (↑(n+1)) * ε * ‖p0‖ + ε ^ 2 * B * (↑(n+1)) ^ 2 / 2 := by push_cast; ring

omit [NormedSpace ℝ E] in
lemma tail_small [MeasurableSpace E] [OpensMeasurableSpace E] (μ : Measure E) [IsFiniteMeasure μ]
    {η : ENNReal} (hη : 0 < η) : ∃ T : ℝ, ∀ T' ≥ T, μ {p | T' < ‖p‖} < η := by
  let s : ℕ → Set E := fun n => {p | (n:ℝ) < ‖p‖}
  have hs : ∀ n, MeasurableSet (s n) := fun n => measurableSet_lt measurable_const measurable_norm
  have hanti : Antitone s := fun m n hmn p hp =>
    show (m:ℝ) < ‖p‖ from lt_of_le_of_lt (Nat.cast_le.2 hmn) hp
  have hinter : (⋂ n, s n) = ∅ := by
    ext p
    simp only [Set.mem_iInter, Set.mem_empty_iff_false, iff_false, not_forall, not_lt, s,
      Set.mem_setOf_eq]
    exact exists_nat_ge ‖p‖
  have ht := tendsto_measure_iInter_atTop (μ := μ) (fun n => (hs n).nullMeasurableSet) hanti
    ⟨0, measure_ne_top _ _⟩
  rw [hinter, measure_empty] at ht
  obtain ⟨N, hN⟩ := eventually_atTop.1 (ht.eventually (gt_mem_nhds hη))
  refine ⟨N, fun T hT => lt_of_le_of_lt (measure_mono ?_) (hN N le_rfl)⟩
  intro p hp; exact lt_of_le_of_lt hT hp

/-- **Theorem 5.18 (core), hence Theorem 2.2(ii)**: with bounded gradient, the proposal is
uniformly tight around the current point: for every `η > 0` there is `δ` with
`Q(x0, B_δ(x0)ᶜ) < η` for **all** `x0` (and `P(x0,B_δ(x0)ᶜ) ≤ Q(x0,B_δ(x0)ᶜ)`).
This is the hypothesis of Proposition 3.6 (Jarner–Tweedie). -/
theorem thm_5_18 [MeasurableSpace E] [OpensMeasurableSpace E] (μ : Measure E)
    [IsProbabilityMeasure μ] (g : E → E) {ε B : ℝ} (hε : 0 < ε) (hB : ∀ x, ‖g x‖ ≤ B)
    (L : ℕ) : ∀ η : ENNReal, 0 < η → ∃ δ : ℝ, ∀ x0 : E,
      μ {p | δ ≤ ‖(lf g ε x0 p L).1 - x0‖} < η := by
  intro η hη
  obtain ⟨T, hT⟩ := tail_small μ hη
  refine ⟨L * ε * (|T| + 1) + ε ^ 2 * B * L ^ 2 / 2 + 1, fun x0 => ?_⟩
  refine lt_of_le_of_lt (measure_mono ?_) (hT T le_rfl)
  intro p hp
  simp only [Set.mem_setOf_eq] at hp ⊢
  have h := (displacement g hε.le hB x0 p L).2
  by_contra hc
  push_neg at hc
  have hLe : 0 ≤ (L:ℝ) * ε := by positivity
  have hT' : ‖p‖ ≤ |T| := le_trans hc (le_abs_self T)
  have : (L:ℝ) * ε * ‖p‖ ≤ L * ε * |T| := mul_le_mul_of_nonneg_left hT' hLe
  nlinarith

/-! ## Corollary 2.3(ii), case `0 < β < 1` (dimension one) -/

/-- The gradient is globally bounded (needs `U ∈ C¹`, i.e. `g` continuous). -/
theorem bounded_grad_expfam {α β M0 : ℝ} (hα : 0 < α) (hβ0 : 0 < β) (hβ : β < 1)
    (g : ℝ → ℝ) (hgc : Continuous g) (hg : ∀ x, M0 < |x| → |g x| = α * β * |x| ^ (β - 1)) :
    ∃ B, ∀ x, ‖g x‖ ≤ B := by
  set K := max M0 1
  obtain ⟨C, hC⟩ := (isCompact_Icc (a := -K) (b := K)).exists_bound_of_continuousOn
    hgc.continuousOn
  refine ⟨max C (α * β), fun x => ?_⟩
  by_cases hx : |x| ≤ K
  · exact le_trans (hC x (abs_le.1 hx)) (le_max_left _ _)
  · push_neg at hx
    have hxM : M0 < |x| := lt_of_le_of_lt (le_max_left _ _) hx
    have hx1 : 1 ≤ |x| := le_trans (le_max_right _ _) hx.le
    rw [Real.norm_eq_abs, hg x hxM]
    have : |x| ^ (β - 1) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos hx1 (by linarith)
    have hab : 0 ≤ α * β := by positivity
    calc α * β * |x| ^ (β - 1) ≤ α * β * 1 := mul_le_mul_of_nonneg_left this hab
      _ = α * β := mul_one _
      _ ≤ _ := le_max_right _ _

lemma rpow_small {δ c : ℝ} (hδ : δ < 1) (hc : 0 < c) :
    ∃ R > 0, ∀ t : ℝ, R ≤ t → c * t ^ δ ≤ t := by
  have h := (tendsto_rpow_neg_atTop (y := 1 - δ) (by linarith)).eventually
    (gt_mem_nhds (show (0:ℝ) < 1 / c by positivity))
  obtain ⟨R, hR⟩ := eventually_atTop.1 h
  refine ⟨max R 1, by positivity, fun t ht => ?_⟩
  have ht0 : 0 < t := lt_of_lt_of_le (by positivity) ht
  have h1 := hR t (le_trans (le_max_left _ _) ht)
  have : t ^ δ = t ^ (-(1 - δ)) * t := by
    rw [← Real.rpow_add_one ht0.ne']; ring_nf
  rw [this]
  calc c * (t ^ (-(1 - δ)) * t) = (c * t ^ (-(1 - δ))) * t := by ring
    _ ≤ 1 * t := by
        apply mul_le_mul_of_nonneg_right _ ht0.le
        have := mul_lt_mul_of_pos_left h1 hc
        rw [mul_one_div_cancel hc.ne'] at this; linarith
    _ = t := one_mul t

/-- No exponential moments: `∫ e^{s|x|} e^{-U(x)} dx = ∞` for every `s > 0` when `β < 1`. -/
theorem no_exp_moment_expfam {α β M0 c : ℝ} (hα : 0 < α) (hβ : β < 1) (U : ℝ → ℝ)
    (hU : ∀ x, M0 < |x| → U x = α * |x| ^ β + c) {s : ℝ} (hs : 0 < s) :
    ∫⁻ x, ENNReal.ofReal (Real.exp (s * |x|) * Real.exp (-U x)) = ⊤ := by
  obtain ⟨R1, hR1pos, hR1⟩ := rpow_small hβ (show 0 < 2 * α / s by positivity)
  set R := max (max R1 (M0 + 1)) (2 * |c| / s)
  apply top_unique
  calc (⊤ : ENNReal) = volume (Set.Ici R) := Real.volume_Ici.symm
    _ = ∫⁻ x, (Set.Ici R).indicator 1 x := (lintegral_indicator_one measurableSet_Ici).symm
    _ ≤ _ := by
      apply lintegral_mono
      intro x
      by_cases hx : x ∈ Set.Ici R
      · rw [Set.indicator_of_mem hx, Pi.one_apply, ← ENNReal.ofReal_one]
        apply ENNReal.ofReal_le_ofReal
        have hxR : R ≤ x := hx
        have hx1 : R1 ≤ x := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hxR
        have hxM : M0 + 1 ≤ x := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hxR
        have hxc : 2 * |c| / s ≤ x := le_trans (le_max_right _ _) hxR
        have hx0 : 0 < x := lt_of_lt_of_le hR1pos hx1
        have habs : |x| = x := abs_of_pos hx0
        rw [hU x (by rw [habs]; linarith), habs, ← Real.exp_add]
        have h1 := hR1 x hx1
        have h2 : 2 * α / s * x ^ β = (2 * α * x ^ β) / s := by ring
        rw [h2, div_le_iff₀ hs] at h1
        rw [div_le_iff₀ hs] at hxc
        have := le_abs_self c
        apply Real.one_le_exp
        nlinarith
      · rw [Set.indicator_of_not_mem hx]; exact zero_le _

end
