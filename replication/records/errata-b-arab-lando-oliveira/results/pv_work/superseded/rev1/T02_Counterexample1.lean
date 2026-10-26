import T02ModGaps

/-!
# T02 issue 1 (suspected issue B): source `SuperParetoPaper-v12.tex:256`

Line :254 gives `P ≥ b + d + a(a - b - d)` with `a = F̄(x)`, `b = F̄(x/θₙ)`, `d = F̄(x/(1-θₙ))`,
`P = P(θ₁X₁+⋯+θₙXₙ > x)`.  Line :256: "noting that the subadditivity assumption implies that
the large parenthesis is negative, it follows that `P ≥ F̄(x/θₙ) + F̄(x/(1-θₙ)) ≥ F̄(x)`".

Part A: the printed inference (drop a nonpositive term from a lower bound) is invalid.
Part B: the intermediate claim `P ≥ b + d` itself is false: it fails at `x = 0` for every
instance satisfying all printed premises (`b = d = 1`), and at `x = 1/2` for the Pareto(1) law
with three equal weights (`b + d = 2/3 + 1 = 5/3 > 1`).
Part C (positive, scope): the final claim `P ≥ a` does follow from line :254 and (eq:sub-1x)
by the algebra `(b+d+a(a-b-d)) - a = (1-a)(b+d-a) ≥ 0`.  This rearrangement is constructed by
the reviewer, not in the source; suggestion only, not used in any verification.
-/

open MeasureTheory ProbabilityTheory Set Paper.L01

namespace Paper.T02.Issue1

/-! ## Part A: the inference as printed -/

/-- The inference printed at :256, as pure real-number reasoning: from the lower bound of :254,
`0 ≤ a ≤ 1` (a survival value) and "the large parenthesis is negative" (`a - b - d ≤ 0`),
conclude `b + d ≤ P`. -/
def PrintedInference : Prop :=
  ∀ P a b d : ℝ, 0 ≤ a → a ≤ 1 → 0 ≤ b → b ≤ 1 → 0 ≤ d → d ≤ 1 →
    a - b - d ≤ 0 → b + d + a * (a - b - d) ≤ P → b + d ≤ P

theorem not_printedInference : ¬ PrintedInference := by
  intro h
  have := h (3/4) (1/2) (1/2) (1/2) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  norm_num at this

/-! ## Part C: the final inequality does follow from :254 and (eq:sub-1x) -/

/-- Reviewer-constructed algebra (not in the source; suggestion only). -/
theorem final_of_254 (P a b d : ℝ) (ha0 : 0 ≤ a) (ha1 : a ≤ 1) (hsub : a - b - d ≤ 0)
    (h254 : b + d + a * (a - b - d) ≤ P) : a ≤ P := by
  nlinarith [mul_nonneg (sub_nonneg.2 ha1) (by linarith : (0:ℝ) ≤ b + d - a)]

/-! ## Part B: the intermediate claim of :256 -/

/-- The intermediate claim of :256, `P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄_X(x/θₙ) + F̄_X(x/(1-θₙ))`, with every
premise of the induction step (:219-227): `n+1 ≥ 3` i.i.d. copies of an ITS variable `X`,
weights `θᵢ > 0` summing to 1, the induction hypothesis (eq:main-st for the first `n` copies with
normalised weights, as in `T02_S7`), and `x ≥ 0` (:191). -/
def PrintedIntermediate : Prop :=
  ∀ {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin (n + 1) → Ω → ℝ), IIDCopies μ X Xs →
    IsInvSub (μ.map X) → 2 ≤ n →
    ∀ θ : Fin (n + 1) → ℝ, (∀ i, 0 < θ i) → ∑ i, θ i = 1 →
    StDom μ X (fun ω => ∑ i : Fin n, (θ i.castSucc / (1 - θ (Fin.last n))) * Xs i.castSucc ω) →
    ∀ x : ℝ, 0 ≤ x →
      Fbar (μ.map X) (x / θ (Fin.last n)) + Fbar (μ.map X) (x / (1 - θ (Fin.last n)))
        ≤ (μ {ω | x < ∑ i, θ i * Xs i ω}).toReal

/-- For EVERY instance satisfying the premises (the induction hypothesis is not even needed),
the intermediate claim fails at `x = 0`: its right side is `F̄(0) + F̄(0) = 2 > 1 ≥ P`. -/
theorem intermediate_fails_at_zero {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] {n : ℕ} (X : Ω → ℝ) (Xs : Fin (n + 1) → Ω → ℝ)
    (hits : IsInvSub (μ.map X)) (θ : Fin (n + 1) → ℝ) :
    ¬ (Fbar (μ.map X) (0 / θ (Fin.last n)) + Fbar (μ.map X) (0 / (1 - θ (Fin.last n)))
        ≤ (μ {ω | (0:ℝ) < ∑ i, θ i * Xs i ω}).toReal) := by
  intro h
  have h0 : Fbar (μ.map X) 0 = 1 := by unfold Fbar; rw [hits.1]; norm_num
  simp only [zero_div, h0] at h
  have hle : (μ {ω | (0:ℝ) < ∑ i, θ i * Xs i ω}).toReal ≤ 1 :=
    ENNReal.toReal_le_of_le_ofReal zero_le_one (by simpa using prob_le_one)
  linarith

/-! ### A concrete instance: Pareto(1), three i.i.d. copies, equal weights -/

/-- Pareto(1) density on (1, ∞): f(t) = t^(-2) (copied from the auditor's P01 probe). -/
noncomputable def fP (t : ℝ) : ENNReal :=
  (Ioi (1:ℝ)).indicator (fun t => ENNReal.ofReal (t ^ (-2:ℝ))) t

lemma fP_meas : Measurable fP :=
  (ENNReal.measurable_ofReal.comp (measurable_id.pow_const _)).indicator measurableSet_Ioi

noncomputable def μP : Measure ℝ := volume.withDensity fP

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

instance : IsProbabilityMeasure μP := ⟨univ_eq⟩

lemma F_P_eq (x : ℝ) : F μP x = (μP (Iic x)).toReal := by
  unfold F; rw [cdf_eq_real]; rfl

lemma F_P_le1 (x : ℝ) (hx : x ≤ 1) : F μP x = 0 := by
  rw [F_P_eq, measure_mono_null (Iic_subset_Iic.2 hx) Iic_one]; rfl

lemma Fbar_P_ge1 (x : ℝ) (hx : 1 ≤ x) : Fbar μP x = x⁻¹ := by
  have : Fbar μP x = (μP (Ioi x)).toReal := by
    unfold Fbar
    rw [F_P_eq, ← compl_Iic, measure_compl measurableSet_Iic (measure_ne_top _ _), measure_univ,
      ENNReal.toReal_sub_of_le prob_le_one ENNReal.one_ne_top]
    simp
  rw [this, tail x hx, ENNReal.toReal_ofReal (by positivity), Real.rpow_neg_one]

lemma F_P_ge1 (x : ℝ) (hx : 1 ≤ x) : F μP x = 1 - x⁻¹ := by
  have := Fbar_P_ge1 x hx; unfold Fbar at this; linarith

lemma invDist_P (y : ℝ) (hy : 0 < y) : invDist (F μP) y = min y 1 := by
  unfold invDist
  rcases le_or_lt y 1 with h | h
  · rw [F_P_ge1 _ (by rw [le_div_iff₀ hy]; linarith), min_eq_left h]; field_simp
  · rw [F_P_le1 _ (by rw [div_le_iff₀ hy]; linarith), min_eq_right h.le]; norm_num

/-- The Pareto(1) law is ITS (Def 2.2), as the source asserts at :279. -/
lemma isInvSub_P : IsInvSub μP := by
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

abbrev Ω3 := Fin 3 → ℝ
noncomputable def μ3 : Measure Ω3 := Measure.pi (fun _ => μP)
instance : IsProbabilityMeasure μ3 := by unfold μ3; infer_instance

def Xs3 : Fin 3 → Ω3 → ℝ := fun i ω => ω i
def X3 : Ω3 → ℝ := fun ω => ω 0

lemma map_eval (i : Fin 3) : μ3.map (fun ω => ω i) = μP := by
  classical
  ext s hs
  rw [Measure.map_apply (measurable_pi_apply i) hs]
  have : (fun ω : Ω3 => ω i) ⁻¹' s = Set.pi univ (Function.update (fun _ => univ) i s) :=
    Set.eval_preimage
  rw [this, μ3, Measure.pi_pi]
  rw [Finset.prod_eq_single i (fun j _ hj => by simp [Function.update_of_ne hj])
    (fun h => absurd (Finset.mem_univ i) h)]
  simp

lemma iid3 : IIDCopies μ3 X3 Xs3 where
  meas := measurable_pi_apply 0
  measXs := fun i => measurable_pi_apply i
  indep := by
    show iIndepFun (fun (i : Fin 3) (ω : Ω3) => ω i) μ3
    rw [iIndepFun_iff_map_fun_eq_pi_map (fun i => (measurable_pi_apply i).aemeasurable)]
    have h1 : (fun ω : Ω3 => fun i => ω i) = id := rfl
    rw [h1, Measure.map_id]
    simp only [map_eval]
    rfl
  ident := fun i => by
    refine ⟨(measurable_pi_apply i).aemeasurable, (measurable_pi_apply 0).aemeasurable, ?_⟩
    unfold Xs3 X3
    rw [map_eval i, map_eval 0]

lemma lawX3 : μ3.map X3 = μP := map_eval 0

/-- Non-vacuity of the premises; the induction hypothesis (2-variable case of Theorem 3.1) is
obtained from the project's `T02_S4`, which is conditional on the external parameter
`T02_L01Consumed` (the same parameter T02 already uses). -/
theorem not_printedIntermediate (hL01 : T02_L01Consumed) : ¬ PrintedIntermediate := by
  intro h
  have hθ : ∀ i : Fin 3, (0:ℝ) < (fun _ => (1:ℝ)/3) i := fun _ => by norm_num
  have hsum : ∑ i : Fin 3, (fun _ => (1:ℝ)/3) i = 1 := by norm_num
  have hits : IsInvSub (μ3.map X3) := by rw [lawX3]; exact isInvSub_P
  have hind : IndepFun (Xs3 0) (Xs3 1) μ3 := iid3.indep.indepFun (by decide)
  have hIH0 := T02_S4 hL01 μ3 X3 (Xs3 0) (Xs3 1) iid3.meas (iid3.measXs 0) (iid3.measXs 1)
    hind (iid3.ident 0) (iid3.ident 1) hits (1/2) (by norm_num)
  have hfun : (fun ω => ∑ i : Fin 2, ((fun _ => (1:ℝ)/3) i.castSucc
        / (1 - (fun _ => (1:ℝ)/3) (Fin.last 2))) * Xs3 i.castSucc ω)
      = (fun ω => 1/2 * Xs3 0 ω + (1 - 1/2) * Xs3 1 ω) := by
    funext ω; simp [Fin.sum_univ_two]; norm_num
  have hIH : StDom μ3 X3 (fun ω => ∑ i : Fin 2, ((fun _ => (1:ℝ)/3) i.castSucc
        / (1 - (fun _ => (1:ℝ)/3) (Fin.last 2))) * Xs3 i.castSucc ω) := by
    rw [hfun]; exact hIH0
  have key := h μ3 X3 Xs3 iid3 hits le_rfl (fun _ => (1:ℝ)/3) hθ hsum hIH (1/2) (by norm_num)
  rw [lawX3] at key
  have hb : Fbar μP ((1/2) / (1/3)) = 2/3 := by
    rw [Fbar_P_ge1 _ (by norm_num)]; norm_num
  have hd : Fbar μP ((1/2) / (1 - 1/3)) = 1 := by
    unfold Fbar; rw [F_P_le1 _ (by norm_num)]; norm_num
  simp only [hb, hd] at key
  have hle : (μ3 {ω | (1/2:ℝ) < ∑ i, (fun _ => (1:ℝ)/3) i * Xs3 i ω}).toReal ≤ 1 :=
    ENNReal.toReal_le_of_le_ofReal zero_le_one (by simpa using prob_le_one)
  linarith

/-- Scope (`consumed_of_printed` style): the printed sentence of :256 asserts both
`P ≥ b + d` (refuted above) and `b + d ≥ a`; the latter is (eq:sub-1x), true for every ITS law
(project obligation `T02_S11`, proved in `T02ModGaps`).  Only the first inequality fails. -/
theorem second_half_true (ν : Measure ℝ) [IsProbabilityMeasure ν] (hsub : SubCond ν)
    (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Ioo (0:ℝ) 1) :
    Fbar ν x ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) :=
  T02_S11 ν hsub x hx θ hθ

end Paper.T02.Issue1

