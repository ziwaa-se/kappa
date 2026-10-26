import T01Stmt

open MeasureTheory

namespace Paper.T01

/-! Private technical helpers (types / integrals / case analysis), see prover notes. -/

/-- `c = 1{p > q}` as a real number. -/
private noncomputable def cc (p q : ℝ) : ℝ := if q < p then 1 else 0

private lemma pos_int (ν : Measure ℝ) (a b : ℝ) (hν : 0 < ν (Set.Ico a b))
    (hsub : Set.Ico a b ⊆ Set.Icc (0:ℝ) 1) (f : ℝ → ℝ) (hf0 : ∀ θ, 0 ≤ f θ)
    (hpos : ∀ θ ∈ Set.Ico a b, 0 < f θ) (hint : Integrable f (ν.restrict (Set.Icc (0:ℝ) 1))) :
    0 < ∫ θ in Set.Icc (0:ℝ) 1, f θ ∂ν := by
  rw [integral_pos_iff_support_of_nonneg hf0 hint]
  have h1 : (ν.restrict (Set.Icc (0:ℝ) 1)) (Set.Ico a b) = ν (Set.Ico a b) := by
    rw [Measure.restrict_apply measurableSet_Ico, Set.inter_eq_left.2 hsub]
  refine lt_of_lt_of_le (h1 ▸ hν) (measure_mono ?_)
  intro θ hθ
  exact (hpos θ hθ).ne'

private lemma key (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : MixtureRep S ν) (a b : ℝ)
    (ha : 0 < a) (hb : b < 1) (hab : a < b) (hν : 0 < ν (Set.Ico a b)) :
    S a 0 - S b 0 < 0 ∧ 0 < S a 1 - S b 1 := by
  obtain ⟨_, hr⟩ := hrep
  have haI : a ∈ Set.Ioo (0:ℝ) 1 := ⟨ha, by linarith⟩
  have hbI : b ∈ Set.Ioo (0:ℝ) 1 := ⟨by linarith, hb⟩
  have h0m : (0:ℝ) ∈ ({0, 1} : Set ℝ) := by simp
  have h1m : (1:ℝ) ∈ ({0, 1} : Set ℝ) := by simp
  obtain ⟨i0a, e0a⟩ := hr a haI 0 h0m
  obtain ⟨i0b, e0b⟩ := hr b hbI 0 h0m
  obtain ⟨i1a, e1a⟩ := hr a haI 1 h1m
  obtain ⟨i1b, e1b⟩ := hr b hbI 1 h1m
  have hsub : Set.Ico a b ⊆ Set.Icc (0:ℝ) 1 := fun θ hθ =>
    ⟨by linarith [hθ.1], by linarith [hθ.2]⟩
  have hd0 : S a 0 - S b 0 = ∫ θ in Set.Icc (0:ℝ) 1, (elemScore θ a 0 - elemScore θ b 0) ∂ν := by
    rw [e0a, e0b, mixtureScore, mixtureScore, integral_sub i0a i0b]
  have hd1 : S a 1 - S b 1 = ∫ θ in Set.Icc (0:ℝ) 1, (elemScore θ a 1 - elemScore θ b 1) ∂ν := by
    rw [e1a, e1b, mixtureScore, mixtureScore, integral_sub i1a i1b]
  have p0 : ∀ θ, elemScore θ a 0 - elemScore θ b 0 = -(if θ ∈ Set.Ico a b then θ else 0) := by
    intro θ
    simp only [elemScore, Set.mem_Ico]
    by_cases h1 : θ < a
    · have h2 : θ < b := by linarith
      have h3 : ¬ (a ≤ θ) := not_le.2 h1
      simp [h1, h2, h3] <;> (try split_ifs) <;> ring
    · by_cases h2 : θ < b
      · have h3 : a ≤ θ := not_lt.1 h1
        simp [h1, h2, h3] <;> (try split_ifs) <;> ring
      · simp [h1, h2] <;> (try split_ifs) <;> ring
  have p1 : ∀ θ, elemScore θ a 1 - elemScore θ b 1 = (if θ ∈ Set.Ico a b then 1 - θ else 0) := by
    intro θ
    simp only [elemScore, Set.mem_Ico]
    by_cases h1 : θ < a
    · have h2 : θ < b := by linarith
      have h3 : ¬ (a ≤ θ) := not_le.2 h1
      simp [h1, h2, h3] <;> (try split_ifs) <;> ring
    · by_cases h2 : θ < b
      · have h3 : a ≤ θ := not_lt.1 h1
        simp [h1, h2, h3] <;> (try split_ifs) <;> ring
      · simp [h1, h2] <;> (try split_ifs) <;> ring
  constructor
  · have hint : Integrable (fun θ => if θ ∈ Set.Ico a b then θ else 0)
        (ν.restrict (Set.Icc (0:ℝ) 1)) := by
      have := (i0a.sub i0b).neg
      refine this.congr (Filter.Eventually.of_forall fun θ => ?_)
      simp only [Pi.neg_apply, Pi.sub_apply]
      rw [p0]; ring
    have hpos := pos_int ν a b hν hsub (fun θ => if θ ∈ Set.Ico a b then θ else 0)
      (fun θ => by
        by_cases h : θ ∈ Set.Ico a b
        · simp only [h, if_true]; linarith [h.1]
        · simp [h])
      (fun θ h => by simp only [h, if_true]; linarith [h.1]) hint
    rw [hd0]
    simp only [p0]
    rw [integral_neg]
    linarith
  · have hint : Integrable (fun θ => if θ ∈ Set.Ico a b then 1 - θ else 0)
        (ν.restrict (Set.Icc (0:ℝ) 1)) := by
      have := (i1a.sub i1b)
      refine this.congr (Filter.Eventually.of_forall fun θ => ?_)
      simp only [Pi.sub_apply]
      rw [p1]
    have hpos := pos_int ν a b hν hsub (fun θ => if θ ∈ Set.Ico a b then 1 - θ else 0)
      (fun θ => by
        by_cases h : θ ∈ Set.Ico a b
        · simp only [h, if_true]; linarith [h.2]
        · simp [h])
      (fun θ h => by simp only [h, if_true]; linarith [h.2]) hint
    rw [hd1]
    simp only [p1]
    exact hpos

private lemma dsign (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) :
    (p < q ∧ S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1) ∨
    (q < p ∧ 0 < S p 0 - S q 0 ∧ S p 1 - S q 1 < 0) := by
  rcases lt_or_gt_of_ne hpq with h | h
  · left
    rw [min_eq_left h.le, max_eq_right h.le] at hν
    exact ⟨h, key S ν hrep p q hp.1 hq.2 h hν⟩
  · right
    rw [min_eq_right h.le, max_eq_left h.le] at hν
    obtain ⟨k0, k1⟩ := key S ν hrep q p hq.1 hp.2 h hν
    exact ⟨h, by linarith, by linarith⟩

private lemma cfacts (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) :
    S p (cc p q) - S q (cc p q) < 0 ∧ 0 < S p (1 - cc p q) - S q (1 - cc p q) := by
  rcases dsign S ν hrep p q hp hq hpq hν with ⟨h, h0, h1⟩ | ⟨h, h0, h1⟩
  · have : cc p q = 0 := by simp [cc, not_lt.2 h.le]
    rw [this]; simp only [sub_zero]; exact ⟨h0, h1⟩
  · have : cc p q = 1 := by simp [cc, h]
    rw [this]; simp only [sub_self]; exact ⟨h1, h0⟩

private lemma cmem (p q y : ℝ) (hy : y ∈ ({0, 1} : Set ℝ)) : y = cc p q ∨ y = 1 - cc p q := by
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
  unfold cc
  split_ifs <;> rcases hy with rfl | rfl <;> norm_num

private lemma erep_eq (S : ℝ → ℝ → ℝ) (p q lam y : ℝ)
    (hneg : S p (cc p q) - S q (cc p q) < 0) :
    Erep S p q lam y = 1 + lam * (S p y - S q y) / (-(S p (cc p q) - S q (cc p q))) := by
  show 1 + lam * (S p y - S q y) / |S p (cc p q) - S q (cc p q)| = _
  rw [abs_of_neg hneg]

/-- S3 (l.407). -/
theorem T01_S3 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p < q)
    (hν : 0 < ν (Set.Ico p q)) :
    S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1 :=
  key S ν hrep p q hp.1 hq.2 hpq hν

/-- S1 (l.403). -/
theorem T01_S1 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) (lam : ℝ) (hlam : lam ∈ Set.Ioc (0:ℝ) 1) :
    ∀ y ∈ ({0, 1} : Set ℝ), Erep S p q lam y ≥ Erep S p q lam (if q < p then 1 else 0) ∧
      Erep S p q lam (if q < p then 1 else 0) = 1 - lam ∧ 0 ≤ 1 - lam := by
  obtain ⟨hneg, hposo⟩ := cfacts S ν hrep p q hp hq hpq hν
  have hD : 0 < -(S p (cc p q) - S q (cc p q)) := by linarith
  have hc : Erep S p q lam (cc p q) = 1 - lam := by
    rw [erep_eq S p q lam _ hneg, mul_div_assoc, div_neg, div_self hneg.ne]
    ring
  intro y hy
  change Erep S p q lam y ≥ Erep S p q lam (cc p q) ∧ Erep S p q lam (cc p q) = 1 - lam ∧ _
  refine ⟨?_, hc, by linarith [hlam.2]⟩
  rcases cmem p q y hy with rfl | h
  · exact le_refl _
  · rw [h, erep_eq S p q lam _ hneg, erep_eq S p q lam _ hneg]
    have h1 : 0 < lam * (S p (1 - cc p q) - S q (1 - cc p q)) / (-(S p (cc p q) - S q (cc p q))) :=
      div_pos (mul_pos hlam.1 hposo) hD
    have h2 : lam * (S p (cc p q) - S q (cc p q)) / (-(S p (cc p q) - S q (cc p q))) < 0 :=
      div_neg_of_neg_of_pos (mul_neg_of_pos_of_neg hlam.1 hneg) hD
    linarith

/-- S2 (l.403). -/
theorem T01_S2 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) (lam : ℝ) (hlam : lam ∈ Set.Ioc (0:ℝ) 1) :
    IsEValue (Erep S p q lam) (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) := by
  obtain ⟨hneg, hposo⟩ := cfacts S ν hrep p q hp hq hpq hν
  have hD : 0 < -(S p (cc p q) - S q (cc p q)) := by linarith
  have hS1 := T01_S1 S ν hcons hrep p q hp hq hpq hν lam hlam
  have hk : ∀ π, expPi π (Erep S p q lam) =
      1 + lam * expPi π (fun y => S p y - S q y) / (-(S p (cc p q) - S q (cc p q))) := by
    intro π
    simp only [expPi, erep_eq S p q lam _ hneg]
    ring
  refine ⟨?_, ?_, ?_, ?_⟩
  · have := hS1 0 (by simp); linarith [this.1, this.2.1, this.2.2]
  · have := hS1 1 (by simp); linarith [this.1, this.2.1, this.2.2]
  · intro π hπ
    rw [hk]
    have : lam * expPi π (fun y => S p y - S q y) / (-(S p (cc p q) - S q (cc p q))) ≤ 0 :=
      div_nonpos_of_nonpos_of_nonneg (mul_nonpos_of_nonneg_of_nonpos hlam.1.le hπ.2) hD.le
    linarith
  · intro π hπ
    rw [hk]
    have hf : 0 < expPi π (fun y => S p y - S q y) := by
      by_contra hh
      exact hπ.2 ⟨hπ.1, not_lt.1 hh⟩
    have : 0 < lam * expPi π (fun y => S p y - S q y) / (-(S p (cc p q) - S q (cc p q))) :=
      div_pos (mul_pos hlam.1 hf) hD
    linarith

/-- S4 (l.407). -/
theorem T01_S4 (S : ℝ → ℝ → ℝ) (p q : ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1) :
    StrictMonoOn (fun π => expPi π (fun y => S p y - S q y)) (Set.Icc (0:ℝ) 1) ∧
      ∃ π₀ ∈ Set.Ioo (0:ℝ) 1, expPi π₀ (fun y => S p y - S q y) = 0 := by
  obtain ⟨h0, h1⟩ := hd
  have hδ : 0 < (S p 1 - S q 1) - (S p 0 - S q 0) := by linarith
  constructor
  · intro a _ b _ hab
    simp only [expPi]
    nlinarith [mul_pos (sub_pos.2 hab) hδ]
  · refine ⟨-(S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)), ⟨?_, ?_⟩, ?_⟩
    · exact div_pos (by linarith) hδ
    · rw [div_lt_one hδ]; linarith
    · simp only [expPi]
      field_simp
      ring

/-- S5 (l.407-409). -/
theorem T01_S5 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hE : IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q)) :
    0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0) := by
  obtain ⟨h0, h1, hH, hH'⟩ := hE
  refine ⟨h0, h1, fun π hπ => ⟨fun hle => ?_, fun hf => hH π ⟨hπ, hf⟩⟩⟩
  by_contra hgt
  have := hH' π ⟨hπ, fun hh => hgt hh.2⟩
  linarith

/-- S6 (l.411-414). -/
theorem T01_S6 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h : 0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0)) :
    E 1 ≠ E 0 ∧ (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) = (E 0 - 1) / (E 1 - E 0) := by
  obtain ⟨hd0, hd1⟩ := hd
  obtain ⟨_, _, hiff⟩ := h
  have hE0 : E 0 ≤ 1 := by
    have := (hiff 0 ⟨le_rfl, zero_le_one⟩).2 (by simp only [expPi]; linarith)
    simp only [expPi] at this; linarith
  have hE1 : 1 < E 1 := by
    by_contra hh
    have := (hiff 1 ⟨zero_le_one, le_rfl⟩).1 (by simp only [expPi]; linarith)
    simp only [expPi] at this; linarith
  have hu : 0 < E 1 - E 0 := by linarith
  have hδ : 0 < (S p 1 - S q 1) - (S p 0 - S q 0) := by linarith
  refine ⟨by linarith, ?_⟩
  set π₀ : ℝ := -(S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) with hπ₀
  set π' : ℝ := (1 - E 0) / (E 1 - E 0) with hπ'
  have m0 : π₀ ∈ Set.Icc (0:ℝ) 1 :=
    ⟨(div_pos (by linarith) hδ).le, ((div_lt_one hδ).2 (by linarith)).le⟩
  have m1 : π' ∈ Set.Icc (0:ℝ) 1 :=
    ⟨div_nonneg (by linarith) hu.le, (div_le_one hu).2 (by linarith)⟩
  have f0 : expPi π₀ (fun y => S p y - S q y) = 0 := by
    simp only [hπ₀, expPi]; field_simp; ring
  have g1 : expPi π' E = 1 := by
    simp only [hπ', expPi]; field_simp; ring
  have A : π₀ ≤ π' := by
    have := (hiff π₀ m0).2 (by rw [f0])
    have e : expPi π₀ E = E 0 + π₀ * (E 1 - E 0) := by simp only [expPi]; ring
    rw [hπ', le_div_iff₀ hu]; linarith
  have B : π' ≤ π₀ := by
    have := (hiff π' m1).1 (by rw [g1])
    have e : expPi π' (fun y => S p y - S q y) =
        (S p 0 - S q 0) + π' * ((S p 1 - S q 1) - (S p 0 - S q 0)) := by simp only [expPi]; ring
    rw [hπ₀, le_div_iff₀ hδ]; linarith
  have hEq : π₀ = π' := le_antisymm A B
  rw [hπ₀, hπ', div_eq_div_iff hδ.ne' hu.ne'] at hEq
  rw [div_eq_div_iff hδ.ne' hu.ne']
  linarith

/-- S7 (l.415-418). -/
theorem T01_S7 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1) (h1 : E 1 ≠ E 0)
    (hr : (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) = (E 0 - 1) / (E 1 - E 0)) :
    E 1 = 1 - (1 - E 0) * (S p 1 - S q 1) / (S p 0 - S q 0) := by
  obtain ⟨hd0, hd1⟩ := hd
  have hδ : 0 < (S p 1 - S q 1) - (S p 0 - S q 0) := by linarith
  have hu : E 1 - E 0 ≠ 0 := sub_ne_zero.2 h1
  rw [div_eq_div_iff hδ.ne' hu] at hr
  have hne : S p 0 - S q 0 ≠ 0 := hd0.ne
  field_simp
  nlinarith [hr]

/-- S8 (l.419): STOPPED, false as stated (gate counterexample); see notes. -/
theorem T01_S8 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h : 0 ≤ E 0 ∧ 0 ≤ E 1 ∧ ∀ π ∈ Set.Icc (0:ℝ) 1,
      (expPi π E ≤ 1 ↔ expPi π (fun y => S p y - S q y) ≤ 0))
    (hr : E 1 ≠ E 0 ∧ (S p 0 - S q 0) / ((S p 1 - S q 1) - (S p 0 - S q 0)) = (E 0 - 1) / (E 1 - E 0)) :
    E 0 ∈ Set.Ioo (0:ℝ) 1 := by
  sorry

/-- S9 (l.419-421). -/
theorem T01_S9 (S : ℝ → ℝ → ℝ) (p q : ℝ) (E : ℝ → ℝ)
    (hd : S p 0 - S q 0 < 0 ∧ 0 < S p 1 - S q 1)
    (h1 : E 1 = 1 - (1 - E 0) * (S p 1 - S q 1) / (S p 0 - S q 0)) (h0 : E 0 ∈ Set.Ioo (0:ℝ) 1) :
    ∀ y ∈ ({0, 1} : Set ℝ),
      E y = 1 + (1 - E 0) * (S p y - S q y) / |S p 0 - S q 0| := by
  obtain ⟨hd0, hd1⟩ := hd
  have hne : S p 0 - S q 0 ≠ 0 := hd0.ne
  intro y hy
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
  rw [abs_of_neg hd0]
  rcases hy with rfl | rfl
  · rw [div_neg, mul_div_assoc, div_self hne]; ring
  · rw [h1, div_neg]; ring

/-- S10 (l.423-426): STOPPED (same defect as S8; "similar arguments"). -/
theorem T01_S10 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : q < p)
    (hν : 0 < ν (Set.Ico q p)) (E : ℝ → ℝ)
    (hE : IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q)) :
    ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ), E y = Erep S p q lam y := by
  sorry

/-- **Theorem 3.1** (source/VSIFP_02.tex:144-149). -/
theorem T01 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hcons : IsConsistent S) (hrep : MixtureRep S ν)
    (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (hpq : p ≠ q)
    (hν : 0 < ν (Set.Ico (min p q) (max p q))) (E : ℝ → ℝ) :
    IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) ↔
      ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ), E y = Erep S p q lam y := by
  constructor
  · intro hE
    rcases dsign S ν hrep p q hp hq hpq hν with ⟨hlt, hd⟩ | ⟨hlt, _⟩
    · have h5 := T01_S5 S p q E hE
      have h6 := T01_S6 S p q E hd h5
      have h7 := T01_S7 S p q E hd h6.1 h6.2
      have h8 := T01_S8 S p q E hd h5 h6
      have h9 := T01_S9 S p q E hd h7 h8
      refine ⟨1 - E 0, ⟨by linarith [h8.2], by linarith [h8.1]⟩, fun y hy => ?_⟩
      rw [h9 y hy]
      simp only [Erep, if_neg (not_lt.2 hlt.le)]
    · rw [max_eq_left hlt.le, min_eq_right hlt.le] at hν
      exact T01_S10 S ν hcons hrep p q hp hq hlt hν E hE
  · rintro ⟨lam, hlam, hy⟩
    have e0 : E 0 = Erep S p q lam 0 := hy 0 (by simp)
    have e1 : E 1 = Erep S p q lam 1 := hy 1 (by simp)
    obtain ⟨a, b, c, d⟩ := T01_S2 S ν hcons hrep p q hp hq hpq hν lam hlam
    refine ⟨by rw [e0]; exact a, by rw [e1]; exact b, fun π hπ => ?_, fun π hπ => ?_⟩
    · have := c π hπ
      simp only [expPi] at this ⊢
      rw [e0, e1]; exact this
    · have := d π hπ
      simp only [expPi] at this ⊢
      rw [e0, e1]; exact this

end Paper.T01
