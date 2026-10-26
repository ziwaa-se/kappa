import T03Stmt

namespace Paper.T03
open Paper

/-- helper (technical): explicit form of the expectation in `HAll` for `θ ∈ [0,1]`. -/
private lemma expPi_diff (p q π θ : ℝ) (hθ : θ ∈ Set.Icc (0:ℝ) 1) :
    expPi π (fun y => elemScore θ p y - elemScore θ q y) =
      ((if θ < p then (1:ℝ) else 0) - (if θ < q then (1:ℝ) else 0)) * (θ - π) := by
  have h0 : ¬ θ < 0 := not_lt.mpr hθ.1
  simp only [expPi, elemScore, h0, if_false]
  ring

/-- helper (technical): `E_π E^{π₁*}_{p}(Y) - 1` in closed form. -/
private lemma expPi_grow (p π₁ π : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) :
    expPi π (EGrowAll p π₁) - 1 = (π - p) * (π₁ - p) / (p * (1 - p)) := by
  obtain ⟨h0, h1⟩ := hp
  have : (1 - p) ≠ 0 := by linarith
  have : p ≠ 0 := by linarith
  simp only [expPi, EGrowAll, if_true, one_ne_zero, if_false]
  field_simp
  ring

private lemma HAll_self (p : ℝ) : HAll p p = Set.Icc 0 1 := by
  ext π
  simp only [HAll, Set.mem_setOf_eq]
  constructor
  · exact fun h => h.1
  · intro h
    refine ⟨h, fun θ hθ => ?_⟩
    rw [expPi_diff p p π θ hθ]; simp

theorem T03_S1 (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (h : p < q) :
    HAll p q = Set.Icc 0 p := by
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hq0, hq1⟩ := hq
  ext π
  simp only [HAll, Set.mem_setOf_eq, Set.mem_Icc]
  constructor
  · rintro ⟨⟨a, b⟩, hall⟩
    have := hall p ⟨hp0.le, hp1.le⟩
    rw [expPi_diff p q π p ⟨hp0.le, hp1.le⟩] at this
    simp only [lt_self_iff_false, if_false, h, if_true] at this
    exact ⟨a, by linarith⟩
  · rintro ⟨a, b⟩
    refine ⟨⟨a, by linarith⟩, fun θ hθ => ?_⟩
    rw [expPi_diff p q π θ hθ]
    by_cases c1 : θ < p
    · have c2 : θ < q := by linarith
      simp [c1, c2]
    · by_cases c2 : θ < q
      · simp only [c1, c2, if_true, if_false]; nlinarith [not_lt.mp c1]
      · simp [c1, c2]

theorem T03_S2 (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (h : q < p) :
    HAll p q = Set.Icc p 1 := by
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hq0, hq1⟩ := hq
  ext π
  simp only [HAll, Set.mem_setOf_eq, Set.mem_Icc]
  constructor
  · rintro ⟨⟨a, b⟩, hall⟩
    refine ⟨?_, b⟩
    by_contra hc
    push_neg at hc
    have m1 : q ≤ max q π := le_max_left _ _
    have m2 : π ≤ max q π := le_max_right _ _
    have m3 : max q π < p := max_lt h hc
    obtain ⟨θ, hθ⟩ : ∃ θ, θ = (max q π + p) / 2 := ⟨_, rfl⟩
    have t1 : q < θ := by rw [hθ]; linarith
    have t2 : θ < p := by rw [hθ]; linarith
    have t3 : π < θ := by rw [hθ]; linarith
    have := hall θ ⟨by linarith, by linarith⟩
    rw [expPi_diff p q π θ ⟨by linarith, by linarith⟩] at this
    simp only [t2, if_true, not_lt.mpr t1.le, if_false] at this
    linarith
  · rintro ⟨a, b⟩
    refine ⟨⟨by linarith, b⟩, fun θ hθ => ?_⟩
    rw [expPi_diff p q π θ hθ]
    by_cases c1 : θ < p
    · by_cases c2 : θ < q
      · simp [c1, c2]
      · simp only [c1, c2, if_true, if_false]; nlinarith
    · have c2 : ¬ θ < q := by intro c; apply c1; linarith
      simp [c1, c2]

private lemma S34 (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    (p < q ∧ p < π₁ ∧ HAll p q = Set.Icc 0 p) ∨ (q < p ∧ π₁ < p ∧ HAll p q = Set.Icc p 1) := by
  rcases lt_trichotomy p q with h | h | h
  · have e := T03_S1 p q hp hq h
    left
    refine ⟨h, ?_, e⟩
    by_contra hc
    exact h2 (by rw [e]; exact ⟨h1.1, not_lt.mp hc⟩)
  · subst h
    exact absurd (by rw [HAll_self]; exact h1) h2
  · have e := T03_S2 p q hp hq h
    right
    refine ⟨h, ?_, e⟩
    by_contra hc
    exact h2 (by rw [e]; exact ⟨not_lt.mp hc, h1.2⟩)

theorem T03_S3 (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    ∀ π ∈ HAll p q, expPi π (EGrowAll p π₁) ≤ 1 := by
  intro π hπ
  have hpos : 0 < p * (1 - p) := mul_pos hp.1 (by linarith [hp.2])
  have key := expPi_grow p π₁ π hp
  rcases S34 p q π₁ hp hq h1 h2 with ⟨_, c, e⟩ | ⟨_, c, e⟩ <;> rw [e] at hπ
  · have : (π - p) * (π₁ - p) / (p * (1 - p)) ≤ 0 :=
      div_nonpos_of_nonpos_of_nonneg
        (mul_nonpos_of_nonpos_of_nonneg (by linarith [hπ.2]) (by linarith)) hpos.le
    linarith
  · have : (π - p) * (π₁ - p) / (p * (1 - p)) ≤ 0 :=
      div_nonpos_of_nonpos_of_nonneg
        (mul_nonpos_of_nonneg_of_nonpos (by linarith [hπ.1]) (by linarith)) hpos.le
    linarith

theorem T03_S4 (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    ∀ π ∈ Set.Icc (0:ℝ) 1, π ∉ HAll p q → 1 < expPi π (EGrowAll p π₁) := by
  intro π hπ hn
  have hpos : 0 < p * (1 - p) := mul_pos hp.1 (by linarith [hp.2])
  have key := expPi_grow p π₁ π hp
  rcases S34 p q π₁ hp hq h1 h2 with ⟨_, c, e⟩ | ⟨_, c, e⟩ <;> rw [e] at hn
  · have hlt : p < π := by
      by_contra hc; exact hn ⟨hπ.1, not_lt.mp hc⟩
    have : 0 < (π - p) * (π₁ - p) / (p * (1 - p)) :=
      div_pos (mul_pos (by linarith) (by linarith)) hpos
    linarith
  · have hlt : π < p := by
      by_contra hc; exact hn ⟨not_lt.mp hc, hπ.2⟩
    have : 0 < (π - p) * (π₁ - p) / (p * (1 - p)) :=
      div_pos (mul_pos_of_neg_of_neg (by linarith) (by linarith)) hpos
    linarith

theorem T03_S5 (X03 : GruenwaldThm1) (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1)
    (hq : q ∈ Set.Ioo (0:ℝ) 1) (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q)
    (s3 : ∀ π ∈ HAll p q, expPi π (EGrowAll p π₁) ≤ 1)
    (s4 : ∀ π ∈ Set.Icc (0:ℝ) 1, π ∉ HAll p q → 1 < expPi π (EGrowAll p π₁)) :
    GrowIs (HAll p q) π₁ (EGrowAll p π₁) :=
  X03 (HAll p q) π₁ p (fun π hπ => hπ.1) h1 h2 hp s3 s4

theorem T03_main (X03 : GruenwaldThm1) (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1)
    (hq : q ∈ Set.Ioo (0:ℝ) 1) (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    GrowIs (HAll p q) π₁ (EGrowAll p π₁) :=
  T03_S5 X03 p q π₁ hp hq h1 h2 (T03_S3 p q π₁ hp hq h1 h2) (T03_S4 p q π₁ hp hq h1 h2)

end Paper.T03
