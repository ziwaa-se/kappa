import Mathlib

/-!
# Light tails: Lemmas 5.15–5.17, Theorem 5.14 and Theorem 2.2(i)

Leapfrog integrator in an arbitrary real normed space `E` (the paper uses `E = ℝ^d`),
with gradient field `g = ∇U` (no regularity of `g` is needed for the deterministic part).
-/

open Filter Topology MeasureTheory

noncomputable section

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- One leapfrog (Störmer–Verlet) step of size `ε` (paper, Section 4, with `M = I`). -/
def lfStep (g : E → E) (ε : ℝ) (s : E × E) : E × E :=
  let p' := s.2 - (ε / 2) • g s.1
  let x' := s.1 + ε • p'
  (x', p' - (ε / 2) • g x')

/-- `lf g ε x0 p0 n = (x_{nε}, p_{nε})`. -/
def lf (g : E → E) (ε : ℝ) (x0 p0 : E) : ℕ → E × E
  | 0 => (x0, p0)
  | n + 1 => lfStep g ε (lf g ε x0 p0 n)

section identities
variable (g : E → E) (ε : ℝ) (x0 p0 : E)

lemma X_succ (n : ℕ) :
    (lf g ε x0 p0 (n+1)).1 = (lf g ε x0 p0 n).1 + ε • (lf g ε x0 p0 n).2
      - (ε ^ 2 / 2) • g (lf g ε x0 p0 n).1 := by
  simp only [lf, lfStep]; rw [smul_sub, smul_smul]; ring_nf; abel

lemma P_succ (n : ℕ) :
    (lf g ε x0 p0 (n+1)).2 = (lf g ε x0 p0 n).2
      - (ε / 2) • (g (lf g ε x0 p0 n).1 + g (lf g ε x0 p0 (n+1)).1) := by
  conv_rhs => rw [smul_add]
  simp only [lf, lfStep]; abel

/-- `ε p_{(n+1)ε} = x_{(n+1)ε} - x_{nε} - (ε²/2) ∇U(x_{(n+1)ε})`. -/
lemma eps_P (n : ℕ) :
    ε • (lf g ε x0 p0 (n+1)).2 = (lf g ε x0 p0 (n+1)).1 - (lf g ε x0 p0 n).1
      - (ε ^ 2 / 2) • g (lf g ε x0 p0 (n+1)).1 := by
  rw [P_succ, X_succ]
  simp only [smul_sub, smul_add, smul_smul]; ring_nf; abel

/-- Two–step (Störmer) form of leapfrog: `x_{n+2} = 2x_{n+1} - x_n - ε² ∇U(x_{n+1})`. -/
lemma two_step (n : ℕ) :
    (lf g ε x0 p0 (n+2)).1 = (2:ℝ) • (lf g ε x0 p0 (n+1)).1 - (lf g ε x0 p0 n).1
      - ε ^ 2 • g (lf g ε x0 p0 (n+1)).1 := by
  have h1 := X_succ g ε x0 p0 (n+1)
  have h2 := eps_P g ε x0 p0 n
  rw [h1, h2]; simp only [two_smul]
  have : (ε ^ 2 / 2) • g (lf g ε x0 p0 (n+1)).1 + (ε ^ 2 / 2) • g (lf g ε x0 p0 (n+1)).1
      = ε ^ 2 • g (lf g ε x0 p0 (n+1)).1 := by
    rw [← add_smul]; ring_nf
  rw [← this]; abel

end identities

/-- elementary: for `δ < 1` and `c > 0`, eventually `c * t^δ ≤ t`. -/
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

omit [NormedSpace ℝ E] in
/-- reverse triangle inequality used repeatedly -/
lemma norm_ge_aux (a b c : E) : ‖c‖ - ‖a‖ - ‖b‖ ≤ ‖a + b - c‖ := by
  have h := norm_sub_le (a + b) (a + b - c)
  have h2 := norm_add_le a b
  simp only [sub_sub_cancel] at h
  linarith

/-- (explode), condition (5.?) of the paper: `‖∇U(x)‖/‖x‖ → ∞`. -/
def Explode (g : E → E) : Prop := ∀ K : ℝ, ∃ R : ℝ, ∀ x : E, R ≤ ‖x‖ → K * ‖x‖ ≤ ‖g x‖

/-- **Lemma 5.15.** -/
theorem lemma_5_15 (g : E → E) {ε δ : ℝ} (hε : 0 < ε) (hδ : δ < 1) (hg : Explode g) :
    ∃ η : ℝ, ∀ x0 p0 : E, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖x0‖ < ‖(lf g ε x0 p0 1).1‖ := by
  obtain ⟨R1, hR1⟩ := hg (10 / ε ^ 2)
  obtain ⟨R2, hR2pos, hR2⟩ := rpow_small hδ hε
  refine ⟨max R1 R2, fun x0 p0 hx hp => ?_⟩
  have hx0 : 0 < ‖x0‖ := lt_of_le_of_lt (le_trans hR2pos.le (le_max_right _ _)) hx
  have hgx := hR1 x0 (le_trans (le_max_left _ _) hx.le)
  have hpx : ε * ‖p0‖ ≤ ‖x0‖ :=
    le_trans (mul_le_mul_of_nonneg_left hp hε.le) (hR2 _ (le_trans (le_max_right _ _) hx.le))
  have hX := X_succ g ε x0 p0 0
  simp only [lf] at hX ⊢
  rw [hX]
  have h := norm_ge_aux x0 (ε • p0) ((ε ^ 2 / 2) • g x0)
  rw [norm_smul, norm_smul, Real.norm_of_nonneg hε.le,
    Real.norm_of_nonneg (by positivity : (0:ℝ) ≤ ε ^ 2 / 2)] at h
  have : ε ^ 2 / 2 * (10 / ε ^ 2 * ‖x0‖) = 5 * ‖x0‖ := by field_simp; ring
  have h3 : 5 * ‖x0‖ ≤ ε ^ 2 / 2 * ‖g x0‖ := by
    rw [← this]; exact mul_le_mul_of_nonneg_left hgx (by positivity)
  linarith

/-- **Lemma 5.16** (under (explode) only, as stated in the paper — the paper's proof
additionally uses (oscillations), which is *not* a hypothesis of the lemma; the proof below
avoids it via the two-step form of leapfrog).  We even get doubling at every step. -/
theorem lemma_5_16_doubling (g : E → E) {ε δ : ℝ} (hε : 0 < ε) (hδ : δ < 1) (hg : Explode g) :
    ∃ η : ℝ, 0 < η ∧ ∀ x0 p0 : E, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ n, 2 * ‖(lf g ε x0 p0 n).1‖ ≤ ‖(lf g ε x0 p0 (n+1)).1‖ ∧
        ‖x0‖ ≤ ‖(lf g ε x0 p0 n).1‖ := by
  obtain ⟨η1, h1⟩ := lemma_5_15 g hε hδ hg
  obtain ⟨R, hR⟩ := hg (5 / ε ^ 2)
  refine ⟨max (max η1 R) 1, by positivity, fun x0 p0 hx hp n => ?_⟩
  have hxη : η1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
  have hxR : R ≤ ‖x0‖ := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hx.le
  induction n with
  | zero => exact ⟨(h1 x0 p0 hxη hp).le, by simp [lf]⟩
  | succ n ih =>
    obtain ⟨ih1, ih2⟩ := ih
    have hpos : 0 ≤ ‖(lf g ε x0 p0 n).1‖ := norm_nonneg _
    refine ⟨?_, by linarith⟩
    set a := (lf g ε x0 p0 n).1
    set b := (lf g ε x0 p0 (n+1)).1
    have hb : R ≤ ‖b‖ := by linarith
    have hgb := hR b hb
    rw [two_step g ε x0 p0 n]
    -- ‖2b - a - ε² g b‖ ≥ ε²‖g b‖ - 2‖b‖ - ‖a‖
    have h := norm_ge_aux ((2:ℝ) • b) (-a) (ε ^ 2 • g b)
    rw [norm_smul, norm_smul, norm_neg, Real.norm_of_nonneg (by positivity : (0:ℝ) ≤ ε ^ 2),
      Real.norm_two, ← sub_eq_add_neg] at h
    have : ε ^ 2 * (5 / ε ^ 2 * ‖b‖) = 5 * ‖b‖ := by field_simp
    have h3 : 5 * ‖b‖ ≤ ε ^ 2 * ‖g b‖ := by
      rw [← this]; exact mul_le_mul_of_nonneg_left hgb (by positivity)
    show 2 * ‖b‖ ≤ ‖(2:ℝ) • b - a - ε ^ 2 • g b‖
    linarith

/-- **Lemma 5.16** as stated: `‖x_{Lε}‖ ≥ 2^L ‖x_0‖`. -/
theorem lemma_5_16 (g : E → E) {ε δ : ℝ} (hε : 0 < ε) (hδ : δ < 1) (hg : Explode g) :
    ∃ η : ℝ, 0 < η ∧ ∀ x0 p0 : E, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ L : ℕ, 2 ^ L * ‖x0‖ ≤ ‖(lf g ε x0 p0 L).1‖ := by
  obtain ⟨η, hη, h⟩ := lemma_5_16_doubling g hε hδ hg
  refine ⟨η, hη, fun x0 p0 hx hp L => ?_⟩
  induction L with
  | zero => simp [lf]
  | succ L ih =>
    have := (h x0 p0 hx hp L).1
    rw [pow_succ]; nlinarith

/-- Uniform version of (oscillation2) for a fixed `L`. -/
def Osc2 (U : E → ℝ) (L : ℕ) : Prop :=
  ∀ M : ℝ, ∃ R : ℝ, ∀ x y : E, R ≤ ‖x‖ → 2 ^ L * ‖x‖ ≤ ‖y‖ → U x - U y - ‖x‖ ^ 2 / 2 ≤ -M

/-- (oscillations): `‖y‖ ≥ 2‖x‖ ≥ C ⇒ ‖∇U(y)‖ ≥ 3 ‖∇U(x)‖`. -/
def Osc (g : E → E) : Prop :=
  ∃ C : ℝ, ∀ x y : E, C ≤ 2 * ‖x‖ → 2 * ‖x‖ ≤ ‖y‖ → 3 * ‖g x‖ ≤ ‖g y‖

/-- log of the HMC acceptance ratio: `H(x0,p0) - H(x_{Lε}, p_{Lε})`. -/
def logAcc (U : E → ℝ) (g : E → E) (ε : ℝ) (L : ℕ) (x0 p0 : E) : ℝ :=
  U x0 - U (lf g ε x0 p0 L).1 + ‖p0‖ ^ 2 / 2 - ‖(lf g ε x0 p0 L).2‖ ^ 2 / 2

/-- HMC acceptance probability `α(x0, x_{Lε}) = 1 ∧ exp(H(x0,p0) - H(x_{Lε},p_{Lε}))`. -/
def acc (U : E → ℝ) (g : E → E) (ε : ℝ) (L : ℕ) (x0 p0 : E) : ℝ :=
  min 1 (Real.exp (logAcc U g ε L x0 p0))

/-- **Lemma 5.17, strengthened**: (explode) and (oscillation2) suffice; (oscillations) is
not needed. The log acceptance ratio tends to `-∞` uniformly over `‖p0‖ ≤ ‖x0‖^δ`. -/
theorem logAcc_tendsto (U : E → ℝ) (g : E → E) {ε δ : ℝ} {L : ℕ} (hε : 0 < ε) (hδ : δ < 1)
    (hL : 1 ≤ L) (hg : Explode g) (hU : Osc2 U L) :
    ∀ M : ℝ, ∃ R : ℝ, ∀ x0 p0 : E, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      logAcc U g ε L x0 p0 ≤ -M := by
  intro M
  obtain ⟨η, hη, hdbl⟩ := lemma_5_16_doubling g hε hδ hg
  obtain ⟨_, _, hpow⟩ := lemma_5_16 g hε hδ hg
  obtain ⟨η', hη', hpow⟩ := lemma_5_16 g hε hδ hg
  obtain ⟨RK, hRK⟩ := hg ((4 * ε + 4) / ε ^ 2)
  obtain ⟨R2, hR2pos, hR2⟩ := rpow_small hδ one_pos
  obtain ⟨R3, hR3⟩ := hU M
  refine ⟨max (max η η') (max RK (max R2 R3)), fun x0 p0 hx hp => ?_⟩
  simp only [max_lt_iff] at hx
  obtain ⟨⟨hxη, hxη'⟩, hxK, hx2, hx3⟩ := hx
  obtain ⟨m, rfl⟩ : ∃ m, L = m + 1 := ⟨L - 1, by omega⟩
  set a := (lf g ε x0 p0 m).1
  set b := (lf g ε x0 p0 (m+1)).1
  have hab := (hdbl x0 p0 hxη hp m).1
  have hbx : 2 ^ (m+1) * ‖x0‖ ≤ ‖b‖ := hpow x0 p0 hxη' hp (m+1)
  have h2pow : (1:ℝ) ≤ 2 ^ (m+1) := one_le_pow₀ (by norm_num)
  have hx0 : 0 ≤ ‖x0‖ := norm_nonneg _
  have hb1 : ‖x0‖ ≤ ‖b‖ := by nlinarith
  have hgb := hRK b (by linarith)
  -- momentum at the end is large: ‖p_L‖ ≥ 2‖x_L‖
  have hP := eps_P g ε x0 p0 m
  have h := norm_ge_aux b (-a) ((ε ^ 2 / 2) • g b)
  rw [norm_smul, norm_neg, Real.norm_of_nonneg (by positivity : (0:ℝ) ≤ ε ^ 2 / 2),
    ← sub_eq_add_neg, ← hP, norm_smul, Real.norm_of_nonneg hε.le] at h
  have : ε ^ 2 / 2 * ((4 * ε + 4) / ε ^ 2 * ‖b‖) = (2 * ε + 2) * ‖b‖ := by field_simp; ring
  have h3 : (2 * ε + 2) * ‖b‖ ≤ ε ^ 2 / 2 * ‖g b‖ := by
    rw [← this]; exact mul_le_mul_of_nonneg_left hgb (by positivity)
  have ha0 : 0 ≤ ‖a‖ := norm_nonneg _
  have hPL : 2 * ε * ‖b‖ ≤ ε * ‖(lf g ε x0 p0 (m+1)).2‖ := by linarith
  have hPL' : 2 * ‖b‖ ≤ ‖(lf g ε x0 p0 (m+1)).2‖ := by
    have := le_of_mul_le_mul_left (by linarith : ε * (2 * ‖b‖) ≤ ε * _) hε; linarith
  have hp' : ‖p0‖ ≤ ‖x0‖ := by
    have := hR2 ‖x0‖ hx2.le; linarith
  have hp0 : 0 ≤ ‖p0‖ := norm_nonneg _
  have hkin : ‖p0‖ ^ 2 / 2 - ‖(lf g ε x0 p0 (m+1)).2‖ ^ 2 / 2 ≤ -(‖x0‖ ^ 2 / 2) := by
    nlinarith
  have hosc := hR3 x0 b hx3.le hbx
  unfold logAcc
  linarith

/-- **Lemma 5.17** (as stated in the paper, with all three hypotheses):
`α(x0, x_{Lε}) → 0` uniformly over `‖p0‖ ≤ ‖x0‖^δ`. -/
theorem lemma_5_17 (U : E → ℝ) (g : E → E) {ε δ : ℝ} {L : ℕ} (hε : 0 < ε) (hδ : δ < 1)
    (hL : 1 ≤ L) (hg : Explode g) (_hosc : Osc g) (hU : Osc2 U L) :
    ∀ η > 0, ∃ R : ℝ, ∀ x0 p0 : E, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      acc U g ε L x0 p0 < η := by
  intro η hη
  obtain ⟨R, hR⟩ := logAcc_tendsto U g hε hδ hL hg hU (1 - Real.log η)
  refine ⟨R, fun x0 p0 hx hp => ?_⟩
  have h := hR x0 p0 hx hp
  calc acc U g ε L x0 p0 ≤ Real.exp (logAcc U g ε L x0 p0) := min_le_right _ _
    _ ≤ Real.exp (-(1 - Real.log η)) := Real.exp_le_exp.2 h
    _ < Real.exp (Real.log η) := Real.exp_lt_exp.2 (by linarith)
    _ = η := Real.exp_log hη

/-- acceptance → 0 using only (explode) and (oscillation2). -/
theorem acc_small (U : E → ℝ) (g : E → E) {ε δ : ℝ} {L : ℕ} (hε : 0 < ε) (hδ : δ < 1)
    (hL : 1 ≤ L) (hg : Explode g) (hU : Osc2 U L) :
    ∀ η > 0, ∃ R : ℝ, ∀ x0 p0 : E, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      acc U g ε L x0 p0 < η := by
  intro η hη
  obtain ⟨R, hR⟩ := logAcc_tendsto U g hε hδ hL hg hU (1 - Real.log η)
  refine ⟨R, fun x0 p0 hx hp => ?_⟩
  have h := hR x0 p0 hx hp
  calc acc U g ε L x0 p0 ≤ Real.exp (logAcc U g ε L x0 p0) := min_le_right _ _
    _ ≤ Real.exp (-(1 - Real.log η)) := Real.exp_le_exp.2 h
    _ < Real.exp (Real.log η) := Real.exp_lt_exp.2 (by linarith)
    _ = η := Real.exp_log hη

/-- tails of any finite measure: `μ{‖p‖ > T} → 0`. -/
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

/-- The expected acceptance probability `∫ α(x0, x_{Lε}(p)) μ(dp)` tends to `0` as
`‖x0‖ → ∞` for *any* probability law `μ` of the momentum (e.g. `N(0,I)`), so the rejection
probability `r(x0) → 1`, i.e. `ess sup r = 1` (since `π` has a positive density).
Only (explode) and (oscillation2) are used. -/
theorem expected_acc_tendsto_zero [MeasurableSpace E] [OpensMeasurableSpace E]
    (μ : Measure E) [IsProbabilityMeasure μ]
    (U : E → ℝ) (g : E → E) {ε δ : ℝ} {L : ℕ} (hε : 0 < ε) (hδ0 : 0 < δ) (hδ : δ < 1)
    (hL : 1 ≤ L) (hg : Explode g) (hU : Osc2 U L) :
    ∀ η : ENNReal, 0 < η → ∃ R : ℝ, ∀ x0 : E, R < ‖x0‖ →
      ∫⁻ p, ENNReal.ofReal (acc U g ε L x0 p) ∂μ < η := by
  intro η hη
  have hη2 : 0 < η / 2 := ENNReal.half_pos hη.ne'
  obtain ⟨T, hT⟩ := tail_small μ hη2
  set e : ENNReal := min (η / 2) 1 with he_def
  have he_top : e ≠ ⊤ := ne_top_of_le_ne_top ENNReal.one_ne_top (min_le_right _ _)
  have he0 : 0 < e.toReal := ENNReal.toReal_pos (lt_min hη2 one_pos).ne' he_top
  obtain ⟨R1, hR1⟩ := acc_small U g hε hδ hL hg hU e.toReal he0
  obtain ⟨R2, hR2⟩ := eventually_atTop.1 ((tendsto_rpow_atTop hδ0).eventually_ge_atTop T)
  refine ⟨max (max R1 R2) 0, fun x0 hx => ?_⟩
  simp only [max_lt_iff] at hx
  obtain ⟨⟨hx1, hx2⟩, _⟩ := hx
  set S := {p : E | ‖x0‖ ^ δ < ‖p‖}
  have hS : MeasurableSet S := measurableSet_lt measurable_const measurable_norm
  have hbound : ∀ p, ENNReal.ofReal (acc U g ε L x0 p) ≤ S.indicator 1 p + e := by
    intro p
    by_cases hp : p ∈ S
    · rw [Set.indicator_of_mem hp]
      calc ENNReal.ofReal (acc U g ε L x0 p) ≤ ENNReal.ofReal 1 :=
            ENNReal.ofReal_le_ofReal (min_le_left _ _)
        _ = 1 := ENNReal.ofReal_one
        _ ≤ (1 : E → ENNReal) p + e := le_self_add
    · rw [Set.indicator_of_not_mem hp, zero_add]
      have hp' : ‖p‖ ≤ ‖x0‖ ^ δ := not_lt.1 hp
      calc ENNReal.ofReal (acc U g ε L x0 p) ≤ ENNReal.ofReal e.toReal :=
            ENNReal.ofReal_le_ofReal (hR1 x0 p hx1 hp').le
        _ = e := ENNReal.ofReal_toReal he_top
  calc ∫⁻ p, ENNReal.ofReal (acc U g ε L x0 p) ∂μ ≤ ∫⁻ p, (S.indicator 1 p + e) ∂μ :=
        lintegral_mono hbound
    _ = e + μ S := by
        rw [lintegral_add_left (measurable_one.indicator hS), lintegral_indicator_one hS,
          lintegral_const, measure_univ, mul_one, add_comm]
    _ < η / 2 + η / 2 :=
        ENNReal.add_lt_add_of_le_of_lt he_top (min_le_left _ _) (hT _ (hR2 _ hx2.le))
    _ = η := ENNReal.add_halves η

/-- **Theorem 5.14** (core): under the paper's hypotheses (explode), (oscillations),
(oscillation2) the rejection probability tends to one; Proposition 3.5 then gives the
claim. -/
theorem thm_5_14 [MeasurableSpace E] [OpensMeasurableSpace E]
    (μ : Measure E) [IsProbabilityMeasure μ]
    (U : E → ℝ) (g : E → E) {ε : ℝ} {L : ℕ} (hε : 0 < ε) (hL : 1 ≤ L)
    (hg : Explode g) (_hosc : Osc g) (hU : Osc2 U L) :
    ∀ η : ENNReal, 0 < η → ∃ R : ℝ, ∀ x0 : E, R < ‖x0‖ →
      ∫⁻ p, ENNReal.ofReal (acc U g ε L x0 p) ∂μ < η :=
  expected_acc_tendsto_zero μ U g hε (by norm_num : (0:ℝ) < 1/2) (by norm_num) hL hg hU

/-! ## Corollary 2.3(ii), case `β > 2`, in dimension one -/

section expfam

/-- (oscillations) FAILS for the exponential family whenever `2^(β-1) < 3`,
i.e. for `2 < β < 1 + log₂ 3 ≈ 2.585`. -/
theorem not_osc_expfam {α β M0 : ℝ} (hα : 0 < α) (hβ : 1 < β)
    (h23 : (2:ℝ) ^ (β - 1) < 3) (g : ℝ → ℝ)
    (hg : ∀ x, M0 < |x| → |g x| = α * β * |x| ^ (β - 1)) : ¬ Osc g := by
  rintro ⟨C, hC⟩
  set x : ℝ := max (max C (M0 + 1)) 1
  have hx1 : 1 ≤ x := le_max_right _ _
  have hx0 : 0 < x := by linarith
  have hxC : C ≤ x := le_trans (le_max_left _ _) (le_max_left _ _)
  have hxM : M0 < x := by
    have := le_trans (le_max_right C (M0 + 1)) (le_max_left _ 1); linarith
  have h := hC x (2 * x) (by rw [Real.norm_eq_abs, abs_of_pos hx0]; linarith)
    (by rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hx0, abs_of_pos (by linarith)])
  rw [Real.norm_eq_abs, Real.norm_eq_abs, hg x (by rw [abs_of_pos hx0]; exact hxM),
    hg (2 * x) (by rw [abs_of_pos (by linarith)]; linarith), abs_of_pos hx0,
    abs_of_pos (by linarith), Real.mul_rpow (by norm_num) hx0.le] at h
  have hpos : 0 < α * β * x ^ (β - 1) := by
    have := Real.rpow_pos_of_pos hx0 (β - 1)
    have : 0 < β := by linarith
    positivity
  nlinarith

/-- concrete instance: `β = 5/2` (here `2^(3/2) = 2√2 < 3`). -/
lemma two_rpow_three_halves_lt_three : (2:ℝ) ^ ((5:ℝ) / 2 - 1) < 3 := by
  have h : ((2:ℝ) ^ ((5:ℝ) / 2 - 1)) ^ 2 = 8 := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]; norm_num
  exact lt_of_pow_lt_pow_left₀ 2 (by norm_num) (by rw [h]; norm_num)

/-- `g = U'` really is the derivative of `U(x) = α|x|^β` (at `x > 0`). -/
lemma hasDerivAt_expfam {α β x : ℝ} (hx : 0 < x) :
    HasDerivAt (fun y : ℝ => α * |y| ^ β) (α * (β * x ^ (β - 1))) x := by
  have h := (Real.hasDerivAt_rpow_const (p := β) (Or.inl hx.ne')).const_mul α
  apply h.congr_of_eventuallyEq
  filter_upwards [lt_mem_nhds hx] with y hy
  rw [abs_of_pos hy]

theorem not_osc_beta_five_halves (g : ℝ → ℝ)
    (hg : ∀ x, 0 < |x| → |g x| = 1 * (5 / 2) * |x| ^ ((5:ℝ) / 2 - 1)) : ¬ Osc g :=
  not_osc_expfam one_pos (by norm_num) two_rpow_three_halves_lt_three g hg

/-- For `β > 2`, the exponential family satisfies (explode). -/
theorem explode_expfam {α β M0 : ℝ} (hα : 0 < α) (hβ : 2 < β) (g : ℝ → ℝ)
    (hg : ∀ x, M0 < |x| → |g x| = α * β * |x| ^ (β - 1)) : Explode g := by
  intro K
  obtain ⟨R0, hR0⟩ := eventually_atTop.1
    ((tendsto_rpow_atTop (by linarith : (0:ℝ) < β - 2)).eventually_ge_atTop (K / (α * β)))
  refine ⟨max (max R0 (M0 + 1)) 1, fun x hx => ?_⟩
  rw [Real.norm_eq_abs] at hx ⊢
  have hx1 : 1 ≤ |x| := le_trans (le_max_right _ _) hx
  have hxM : M0 < |x| := by
    have := le_trans (le_trans (le_max_right R0 (M0 + 1)) (le_max_left _ 1)) hx; linarith
  have hxR : K / (α * β) ≤ |x| ^ (β - 2) :=
    hR0 _ (le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hx)
  rw [Real.norm_eq_abs, hg x hxM]
  have hab : 0 < α * β := by
    have : 0 < β := by linarith
    positivity
  have : |x| ^ (β - 1) = |x| ^ (β - 2) * |x| := by
    rw [← Real.rpow_add_one (by linarith)]; ring_nf
  rw [this]
  have : K ≤ α * β * |x| ^ (β - 2) := by
    rw [div_le_iff₀ hab] at hxR; linarith
  nlinarith

/-- For `β > 0`, the exponential family satisfies (oscillation2) for every `L ≥ 1`. -/
theorem osc2_expfam {α β M0 c : ℝ} (hα : 0 < α) (hβ : 1 ≤ β) (U : ℝ → ℝ)
    (hU : ∀ x, M0 < |x| → U x = α * |x| ^ β + c) (L : ℕ) (hL : 1 ≤ L) : Osc2 U L := by
  intro M
  obtain ⟨R0, hR0⟩ := eventually_atTop.1
    ((tendsto_rpow_atTop (by linarith : (0:ℝ) < β)).eventually_ge_atTop (M / α))
  refine ⟨max (max R0 (M0 + 1)) 1, fun x y hx hy => ?_⟩
  rw [Real.norm_eq_abs] at hx hy
  rw [Real.norm_eq_abs] at hy
  rw [Real.norm_eq_abs]
  have hx1 : 1 ≤ |x| := le_trans (le_max_right _ _) hx
  have hxM : M0 < |x| := by
    have := le_trans (le_trans (le_max_right R0 (M0 + 1)) (le_max_left _ 1)) hx; linarith
  have hxR : M / α ≤ |x| ^ β :=
    hR0 _ (le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hx)
  have h2L : (2:ℝ) ≤ 2 ^ L := by
    calc (2:ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ L := pow_le_pow_right₀ (by norm_num) hL
  have hy2 : 2 * |x| ≤ |y| := le_trans (by nlinarith) hy
  have hyM : M0 < |y| := by linarith
  rw [hU x hxM, hU y hyM]
  have h1 : (2 * |x|) ^ β ≤ |y| ^ β := Real.rpow_le_rpow (by positivity) hy2 (by linarith)
  have h2 : (2:ℝ) ^ (1:ℝ) ≤ 2 ^ β := Real.rpow_le_rpow_of_exponent_le (by norm_num) hβ
  rw [Real.mul_rpow (by norm_num) (by positivity), Real.rpow_one] at *
  have hxb : 0 ≤ |x| ^ β := by positivity
  have : M ≤ α * |x| ^ β := by rw [div_le_iff₀ hα] at hxR; linarith
  have h3 : 2 * |x| ^ β ≤ |y| ^ β := by nlinarith
  have h4 : α * (2 * |x| ^ β) ≤ α * |y| ^ β := mul_le_mul_of_nonneg_left h3 hα.le
  have h5 : 0 ≤ |x| ^ 2 / 2 := by positivity
  linarith

/-- **Corollary 2.3(ii), `β > 2`** (any `β > 2`, including `2 < β < 1 + log₂3` where the
paper's route through (oscillations) is unavailable): the expected acceptance probability
tends to `0` as `|x0| → ∞`, for any momentum law `μ`, any `ε > 0`, any `L ≥ 1`. -/
theorem cor_2_3_ii_large {α β M0 c ε : ℝ} {L : ℕ} (hα : 0 < α) (hβ : 2 < β) (hε : 0 < ε)
    (hL : 1 ≤ L) (U g : ℝ → ℝ)
    (hU : ∀ x, M0 < |x| → U x = α * |x| ^ β + c)
    (hg : ∀ x, M0 < |x| → |g x| = α * β * |x| ^ (β - 1))
    (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    ∀ η : ENNReal, 0 < η → ∃ R : ℝ, ∀ x0 : ℝ, R < ‖x0‖ →
      ∫⁻ p, ENNReal.ofReal (acc U g ε L x0 p) ∂μ < η :=
  expected_acc_tendsto_zero μ U g hε (by norm_num : (0:ℝ) < 1/2) (by norm_num) hL
    (explode_expfam hα hβ g hg) (osc2_expfam hα (by linarith) U hU L hL)

end expfam

end
