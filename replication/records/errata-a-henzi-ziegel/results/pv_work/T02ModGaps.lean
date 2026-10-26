import T02Stmt

/-!
# T02 proof modulo gaps (source/VSIFP_02.tex:153-172 statement; proof l.429-463)

Gap file for `T02.lean`.  Stopped obligations S3a, S3b, S8, S11, S15 are replaced by `def ..._Gap : Prop`.
Gap-dependent obligations: S9 (uses S8), main theorem (uses S9, S15).
-/

open MeasureTheory Filter Topology

namespace Paper.T02

/-! Private technical helpers (conversion of the mixture representation into `A`, `N`). -/

private lemma core (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (p q : ℝ) (hp : 0 < p) (hq : q < 1) (hlt : p < q) (hν : 0 < ν (Set.Ico p q)) :
    ∃ A N : ℝ, S p 0 - S q 0 = -A ∧ S p 1 - S q 1 = N - A ∧ 0 < A ∧ A < N ∧
      kappa ν p q = A / N := by
  obtain ⟨hmix, hr⟩ := hrep
  have haI : p ∈ Set.Ioo (0:ℝ) 1 := ⟨hp, by linarith⟩
  have hbI : q ∈ Set.Ioo (0:ℝ) 1 := ⟨by linarith, hq⟩
  have h0m : (0:ℝ) ∈ ({0, 1} : Set ℝ) := by simp
  have h1m : (1:ℝ) ∈ ({0, 1} : Set ℝ) := by simp
  obtain ⟨i0a, e0a⟩ := hr p haI 0 h0m
  obtain ⟨i0b, e0b⟩ := hr q hbI 0 h0m
  obtain ⟨i1a, e1a⟩ := hr p haI 1 h1m
  obtain ⟨i1b, e1b⟩ := hr q hbI 1 h1m
  have hsub : Set.Ico p q ⊆ Set.Icc (0:ℝ) 1 := fun θ hθ =>
    ⟨by linarith [hθ.1], by linarith [hθ.2]⟩
  have hfin : ν (Set.Ico p q) < ⊤ :=
    lt_of_le_of_lt (measure_mono Set.Ico_subset_Icc_self)
      (hmix.2 (Set.Icc p q) isCompact_Icc (fun θ hθ => ⟨by linarith [hθ.1], by linarith [hθ.2]⟩))
  haveI : IsFiniteMeasure (ν.restrict (Set.Ico p q)) :=
    ⟨by rw [Measure.restrict_apply_univ]; exact hfin⟩
  have iθ : IntegrableOn (fun θ : ℝ => θ) (Set.Ico p q) ν := by
    refine (integrable_const q).mono' measurable_id.aestronglyMeasurable ?_
    refine (ae_restrict_iff' measurableSet_Ico).2 (Filter.Eventually.of_forall fun θ hθ => ?_)
    rw [Real.norm_eq_abs, abs_of_nonneg (by linarith [hθ.1])]; exact hθ.2.le
  have iC : ∀ c : ℝ, IntegrableOn (fun _ : ℝ => c) (Set.Ico p q) ν := fun c => integrable_const c
  have hd0 : S p 0 - S q 0 = ∫ θ in Set.Icc (0:ℝ) 1, (elemScore θ p 0 - elemScore θ q 0) ∂ν := by
    rw [e0a, e0b, mixtureScore, mixtureScore, integral_sub i0a i0b]
  have hd1 : S p 1 - S q 1 = ∫ θ in Set.Icc (0:ℝ) 1, (elemScore θ p 1 - elemScore θ q 1) ∂ν := by
    rw [e1a, e1b, mixtureScore, mixtureScore, integral_sub i1a i1b]
  have p0 : ∀ θ, elemScore θ p 0 - elemScore θ q 0 =
      -((Set.Ico p q).indicator (fun θ => θ) θ) := by
    intro θ
    simp only [elemScore, Set.indicator_apply, Set.mem_Ico]
    by_cases h1 : θ < p
    · have h2 : θ < q := by linarith
      have h3 : ¬ (p ≤ θ) := not_le.2 h1
      simp [h1, h2, h3] <;> (try split_ifs) <;> ring
    · by_cases h2 : θ < q
      · have h3 : p ≤ θ := not_lt.1 h1
        simp [h1, h2, h3] <;> (try split_ifs) <;> ring
      · simp [h1, h2] <;> (try split_ifs) <;> ring
  have p1 : ∀ θ, elemScore θ p 1 - elemScore θ q 1 =
      (Set.Ico p q).indicator (fun θ => 1 - θ) θ := by
    intro θ
    simp only [elemScore, Set.indicator_apply, Set.mem_Ico]
    by_cases h1 : θ < p
    · have h2 : θ < q := by linarith
      have h3 : ¬ (p ≤ θ) := not_le.2 h1
      simp [h1, h2, h3] <;> (try split_ifs) <;> ring
    · by_cases h2 : θ < q
      · have h3 : p ≤ θ := not_lt.1 h1
        simp [h1, h2, h3] <;> (try split_ifs) <;> ring
      · simp [h1, h2] <;> (try split_ifs) <;> ring
  have hinter : Set.Icc (0:ℝ) 1 ∩ Set.Ico p q = Set.Ico p q := Set.inter_eq_right.2 hsub
  have hA : ∫ θ in Set.Icc (0:ℝ) 1, (Set.Ico p q).indicator (fun θ => θ) θ ∂ν
      = ∫ θ in Set.Ico p q, θ ∂ν := by
    rw [setIntegral_indicator measurableSet_Ico, hinter]
  have hN : ∫ θ in Set.Icc (0:ℝ) 1, (Set.Ico p q).indicator (fun θ => 1 - θ) θ ∂ν
      = (ν (Set.Ico p q)).toReal - ∫ θ in Set.Ico p q, θ ∂ν := by
    rw [setIntegral_indicator measurableSet_Ico, hinter, integral_sub (iC 1) iθ,
      setIntegral_const]
    simp [Measure.real]
  have hNpos : 0 < (ν (Set.Ico p q)).toReal := ENNReal.toReal_pos hν.ne' hfin.ne
  have hlow : p * (ν (Set.Ico p q)).toReal ≤ ∫ θ in Set.Ico p q, θ ∂ν := by
    have := setIntegral_mono_on (iC p) iθ measurableSet_Ico (fun θ hθ => hθ.1)
    rw [setIntegral_const] at this
    simpa [Measure.real, mul_comm] using this
  have hup : ∫ θ in Set.Ico p q, θ ∂ν ≤ q * (ν (Set.Ico p q)).toReal := by
    have := setIntegral_mono_on iθ (iC q) measurableSet_Ico (fun θ hθ => hθ.2.le)
    rw [setIntegral_const] at this
    simpa [Measure.real, mul_comm] using this
  refine ⟨∫ θ in Set.Ico p q, θ ∂ν, (ν (Set.Ico p q)).toReal, ?_, ?_, ?_, ?_, rfl⟩
  · rw [hd0]; simp only [p0]; rw [integral_neg, hA]
  · rw [hd1]; simp only [p1]; exact hN
  · nlinarith
  · nlinarith

private lemma core2 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hlt : p < q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) :
    ∃ A N : ℝ, S p 0 - S q 0 = -A ∧ S p 1 - S q 1 = N - A ∧ 0 < A ∧ A < N ∧
      kappa ν p q = A / N := by
  rw [min_eq_left hlt.le, max_eq_right hlt.le] at hν
  exact core S ν hrep p q hp.1 hq.2 hlt hν

private lemma erep_lt (S : ℝ → ℝ → ℝ) (p q lam y : ℝ) (hlt : p < q)
    (hneg : S p 0 - S q 0 < 0) :
    Erep S p q lam y = 1 - lam * ((S p y - S q y) / (S p 0 - S q 0)) := by
  have hc : ¬ (q < p) := not_lt.2 hlt.le
  simp only [Erep, hc, if_false]
  rw [abs_of_neg hneg, mul_div_assoc, div_neg]; ring

private lemma growLambda_eq (S : ℝ → ℝ → ℝ) (p q π₁ : ℝ) (hlt : p < q) (h : ℝ)
    (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    growLambda S p q π₁ = π₁ + (1 - π₁) / h := by
  have hc : ¬ (q < p) := not_lt.2 hlt.le
  simp only [growLambda, hc, if_false, hh]
  rw [div_div_eq_mul_div, mul_div_assoc]

/-! Gaps: full ∀-closures of the stopped obligations (binder order: S ν hcons hrep p q hp hq hpq hν
π₁ hπ, then the step's own binders). -/

/-- Gap for S3a (l.435). -/
def T02_S3a_Gap : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    ContinuousOn (growthRate S p q π₁) (Set.Ico 0 1) ∧ growthRate S p q π₁ 0 = 0 ∧
      Tendsto (growthRate S p q π₁) (𝓝[<] 1) atBot

/-- Gap for S3b (l.435). -/
def T02_S3b_Gap : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    ∃ l ∈ Set.Ico (0:ℝ) 1, ∀ l' ∈ Set.Ico (0:ℝ) 1, growthRate S p q π₁ l' ≤ growthRate S p q π₁ l

/-- Gap for S8 (silent step between l.435/442/448 and the conclusion). -/
def T02_S8_Gap : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    ∀ (h : ℝ), h = (S p 1 - S q 1) / (S p 0 - S q 0) →
    π₁ + (1 - π₁) / h < 1 ∧
      ∀ l ∈ Set.Ico (0:ℝ) 1, l ≠ π₁ + (1 - π₁) / h →
        growthRate S p q π₁ l < growthRate S p q π₁ (π₁ + (1 - π₁) / h)

/-- Gap for S11 (l.454). -/
def T02_S11_Gap : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    ∀ (y : ℝ), y ∈ ({0, 1} : Set ℝ) →
    S p y - S q y = ∫ θ in Set.Icc (0:ℝ) 1, (if p ≤ θ ∧ θ < q then θ - y else 0) ∂ν

/-- Gap for S15 (l.462 "The case p > q is analogous"). -/
def T02_S15_Gap : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q →
    T02_T01Consumed → q < p → Conclusion S ν p q π₁

section Steps

variable (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : T01.MixtureRep S ν)
  (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
  (hν : 0 < ν (Set.Ico (min p q) (max p q))) (π₁ : ℝ) (hπ : π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q)

include hcons hrep hp hq hpq hν hπ

/-- S1 (l.430-434). -/
theorem T02_S1
    (hD : S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0) < 0) (lam : ℝ) :
    growthRate S p q π₁ lam =
      (1 - π₁) * Real.log (1 - lam * ((S p 0 - S q 0) /
          (S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)))) +
      π₁ * Real.log (1 - lam * ((S p 1 - S q 1) /
          (S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)))) := by
  have e : ∀ y : ℝ, Erep S p q lam y = 1 - lam * ((S p y - S q y) /
      (S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0))) := by
    intro y
    simp only [Erep]
    rw [abs_of_neg hD, mul_div_assoc, div_neg]; ring
  simp only [growthRate, expPi]
  rw [e 0, e 1]

/-- S2 (l.435). -/
theorem T02_S2 (hlt : p < q) : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1 := by
  obtain ⟨A, N, h0, h1, hA, hAN, -⟩ := core2 S ν hrep p q hp hq hlt hν
  exact ⟨by rw [h0]; linarith, by rw [h1]; linarith⟩

/-- S4 (l.435-439). -/
theorem T02_S4 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    h < 0 ∧ ∀ lam ∈ Set.Ico (0:ℝ) 1,
      growthRate S p q π₁ lam = (1 - π₁) * Real.log (1 - lam) + π₁ * Real.log (1 - lam * h) ∧
      HasDerivAt (growthRate S p q π₁) (-(1 - π₁) / (1 - lam) - π₁ * h / (1 - lam * h)) lam := by
  obtain ⟨hd0, hd1⟩ := T02_S2 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt
  have hc : ¬ (q < p) := not_lt.2 hlt.le
  have hhneg : h < 0 := by rw [hh]; exact div_neg_of_pos_of_neg hd1 hd0
  have hg : growthRate S p q π₁ = fun lam =>
      (1 - π₁) * Real.log (1 - lam) + π₁ * Real.log (1 - lam * h) := by
    funext lam
    have := T02_S1 S ν hcons hrep p q hp hq hpq hν π₁ hπ (by rw [if_neg hc]; exact hd0) lam
    rw [if_neg hc, div_self hd0.ne, mul_one, ← hh] at this
    exact this
  refine ⟨hhneg, fun lam hlam => ⟨by rw [hg], ?_⟩⟩
  have ha : 1 - lam ≠ 0 := by linarith [hlam.2]
  have hb : 1 - lam * h ≠ 0 := by nlinarith [hlam.1]
  have h1 : HasDerivAt (fun x : ℝ => 1 - x) (-1) lam := by
    simpa using (hasDerivAt_id lam).const_sub 1
  have h2 : HasDerivAt (fun x : ℝ => 1 - x * h) (-h) lam := by
    simpa using ((hasDerivAt_id lam).mul_const h).const_sub 1
  have := ((h1.log ha).const_mul (1 - π₁)).add ((h2.log hb).const_mul π₁)
  rw [hg]
  convert this using 1
  ring

/-- S5 (l.440-443). -/
theorem T02_S5 (h : ℝ) (hh : h < 0) (hπ' : π₁ ∈ Set.Icc (0:ℝ) 1) (l0 : ℝ) (hl0 : l0 ∈ Set.Ico (0:ℝ) 1) :
    (-(1 - π₁) / (1 - l0) - π₁ * h / (1 - l0 * h) = 0) ↔ l0 = π₁ + (1 - π₁) / h := by
  have ha : 0 < 1 - l0 := by linarith [hl0.2]
  have hb : 0 < 1 - l0 * h := by nlinarith [hl0.1]
  have hh0 : h ≠ 0 := hh.ne
  have e : -(1 - π₁) / (1 - l0) - π₁ * h / (1 - l0 * h) =
      (l0 * h - (1 - π₁) - π₁ * h) / ((1 - l0) * (1 - l0 * h)) := by
    field_simp
    ring
  rw [e, div_eq_zero_iff]
  constructor
  · rintro (h1 | h1)
    · field_simp
      linarith
    · exact absurd h1 (mul_pos ha hb).ne'
  · intro h1
    left
    rw [h1]
    field_simp

/-- S6 (l.444-447). -/
theorem T02_S6 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0))
    (hπ' : π₁ ∈ Set.Icc (0:ℝ) 1) :
    (π₁ ∉ HS S p q ↔ 0 < expPi π₁ (fun y => S p y - S q y)) ∧
      (0 < expPi π₁ (fun y => S p y - S q y) ↔ 0 < π₁ + (1 - π₁) / h) := by
  obtain ⟨hd0, hd1⟩ := T02_S2 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt
  constructor
  · constructor
    · intro hn
      by_contra hle
      exact hn ⟨hπ', not_lt.1 hle⟩
    · intro hpos hmem
      exact absurd hmem.2 (not_le.2 hpos)
  · have e : expPi π₁ (fun y => S p y - S q y) = (S p 1 - S q 1) * (π₁ + (1 - π₁) / h) := by
      rw [hh]
      simp only [expPi]
      field_simp
      ring
    rw [e]
    exact mul_pos_iff_of_pos_left hd1

/-- S7 (l.448). -/
theorem T02_S7 (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    0 < π₁ + (1 - π₁) / h := by
  have h6 := T02_S6 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt h hh hπ.1
  exact h6.2.1 (h6.1.1 hπ.2)

/-- S9 (l.430, l.435; A09 bridge).  Gap-dependent: uses `hGap_S8`. -/
theorem T02_S9 (hGap_S8 : T02_S8_Gap) (hT01 : T02_T01Consumed) (hlt : p < q) :
    ∀ lam : ℝ, IsGrowLambda S p q π₁ lam ↔ lam = growLambda S p q π₁ := by
  obtain ⟨hd0, hd1⟩ := T02_S2 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt
  set h : ℝ := (S p 1 - S q 1) / (S p 0 - S q 0) with hh
  have hhneg : h < 0 := div_neg_of_pos_of_neg hd1 hd0
  have hL := growLambda_eq S p q π₁ hlt h hh
  have h7 := T02_S7 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt h hh
  have h8 := hGap_S8 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt h hh
  have hE0 : ∀ lam, Erep S p q lam 0 = 1 - lam := by
    intro lam; rw [erep_lt S p q lam 0 hlt hd0, div_self hd0.ne, mul_one]
  have hE1 : ∀ lam, Erep S p q lam 1 = 1 - lam * h := by
    intro lam; rw [erep_lt S p q lam 1 hlt hd0]
  have hL1 : growLambda S p q π₁ < 1 := by rw [hL]; exact h8.1
  have hL0 : 0 < growLambda S p q π₁ := by rw [hL]; exact h7
  have hπ1 : π₁ ≠ 1 := by
    intro e
    have := hL1
    rw [hL, e] at this
    simp at this
  have hGF : GrowFinite S p q π₁ (growLambda S p q π₁) :=
    ⟨fun _ => by rw [hE0]; linarith,
     fun _ => by rw [hE1]; nlinarith [mul_pos hL0 (neg_pos.2 hhneg)]⟩
  intro lam
  constructor
  · rintro ⟨hm, hfin, hmax⟩
    have hlam1 : lam < 1 := by
      rcases hm.2.lt_or_eq with h1 | h1
      · exact h1
      · exfalso
        have := hfin.1 hπ1
        rw [hE0, h1] at this
        linarith
    by_contra hne
    have h8' := h8.2 lam ⟨hm.1.le, hlam1⟩ (by rw [← hL]; exact hne)
    have hmx := hmax (growLambda S p q π₁) ⟨hL0, hL1.le⟩ hGF
    rw [hL] at hmx
    linarith
  · intro e
    rw [e]
    refine ⟨⟨hL0, hL1.le⟩, hGF, fun l hl hfl => ?_⟩
    rcases hl.2.lt_or_eq with h1 | h1
    · by_cases hle : l = growLambda S p q π₁
      · rw [hle]
      · have := h8.2 l ⟨hl.1.le, h1⟩ (by rw [← hL]; exact hle)
        rw [← hL] at this
        exact this.le
    · exfalso
      have := hfl.1 hπ1
      rw [hE0, h1] at this
      linarith

/-- S10 (l.449-453). -/
theorem T02_S10 (hlt : p < q) :
    Erep S p q (growLambda S p q π₁) 0 =
        (1 - π₁) * (((S p 1 - S q 1) - (S p 0 - S q 0)) / (S p 1 - S q 1)) ∧
      Erep S p q (growLambda S p q π₁) 1 =
        π₁ * (((S p 0 - S q 0) - (S p 1 - S q 1)) / (S p 0 - S q 0)) := by
  obtain ⟨hd0, hd1⟩ := T02_S2 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt
  have hc : ¬ (q < p) := not_lt.2 hlt.le
  have e0 := erep_lt S p q (growLambda S p q π₁) 0 hlt hd0
  have e1 := erep_lt S p q (growLambda S p q π₁) 1 hlt hd0
  rw [e0, e1]
  simp only [growLambda, hc, if_false]
  have n0 := hd0.ne
  have n1 := hd1.ne'
  constructor <;> field_simp <;> ring

/-- S12 (l.455-457); proved from the (correctly signed) mixture formula `core`, not through S11. -/
theorem T02_S12 (hlt : p < q) :
    ((S p 1 - S q 1) - (S p 0 - S q 0)) / (S p 1 - S q 1) = 1 / (1 - kappa ν p q) := by
  obtain ⟨A, N, h0, h1, hA, hAN, hk⟩ := core2 S ν hrep p q hp hq hlt hν
  rw [h0, h1, hk]
  have hN : 0 < N := by linarith
  have hne : N - A ≠ 0 := by linarith
  field_simp

/-- S13a (l.459-460); from `core`, not through S11. -/
theorem T02_S13a (hlt : p < q) (h : ℝ) (hh : h = (S p 1 - S q 1) / (S p 0 - S q 0)) :
    1 - h = ((S p 0 - S q 0) - (S p 1 - S q 1)) / (S p 0 - S q 0) ∧ 1 - h = 1 / kappa ν p q := by
  obtain ⟨A, N, h0, h1, hA, hAN, hk⟩ := core2 S ν hrep p q hp hq hlt hν
  have hN : 0 < N := by linarith
  have hne : A ≠ 0 := hA.ne'
  rw [hh, h0, h1, hk]
  have e : (N - A) / (-A) = 1 - N / A := by
    rw [div_neg, ← neg_div, neg_sub, sub_div, div_self hne]
  constructor
  · rw [show (-A - (N - A)) = -N by ring, neg_div_neg_eq, e]; ring
  · rw [e, one_div_div]; ring

/-- S13b (l.460). -/
theorem T02_S13b (hlt : p < q) : 1 / π₁ < 1 / kappa ν p q := by
  obtain ⟨A, N, h0, h1, hA, hAN, hk⟩ := core2 S ν hrep p q hp hq hlt hν
  have hN : 0 < N := by linarith
  have h6 := T02_S6 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt _ rfl hπ.1
  have hpos := h6.1.1 hπ.2
  simp only [expPi] at hpos
  rw [h0, h1] at hpos
  have hκ : A / N < π₁ := by
    rw [div_lt_iff₀ hN]; nlinarith
  rw [hk]
  exact one_div_lt_one_div_of_lt (div_pos hA hN) hκ

/-- S14 (l.461-462). -/
theorem T02_S14 (hlt : p < q) :
    ∀ y ∈ ({0, 1} : Set ℝ), Erep S p q (growLambda S p q π₁) y = EGrow ν p q π₁ y := by
  intro y hy
  have s10 := T02_S10 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt
  have s12 := T02_S12 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt
  have s13 := T02_S13a S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt _ rfl
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
  rcases hy with rfl | rfl
  · rw [s10.1, s12, EGrow, if_pos rfl, min_eq_left hlt.le, max_eq_right hlt.le, mul_one_div]
  · rw [s10.2, ← s13.1, s13.2, EGrow, if_neg one_ne_zero, min_eq_left hlt.le,
      max_eq_right hlt.le, mul_one_div]

end Steps

/-- **Theorem 3.2** modulo gaps (source/VSIFP_02.tex:153-172).  Gap premises first. -/
theorem T02_mod_gaps (hGap_S8 : T02_S8_Gap) (hGap_S15 : T02_S15_Gap)
    (hT01 : T02_T01Consumed) (S : ℝ → ℝ → ℝ) (ν : Measure ℝ)
    (hcons : IsConsistent S) (hrep : T01.MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q)))
    (π₁ : ℝ) (hπ : π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q) :
    Conclusion S ν p q π₁ := by
  rcases lt_or_gt_of_ne hpq with hlt | hgt
  · exact ⟨T02_S9 S ν hcons hrep p q hp hq hpq hν π₁ hπ hGap_S8 hT01 hlt,
      T02_S14 S ν hcons hrep p q hp hq hpq hν π₁ hπ hlt⟩
  · exact hGap_S15 S ν hcons hrep p q hp hq hpq hν π₁ hπ hT01 hgt

end Paper.T02
