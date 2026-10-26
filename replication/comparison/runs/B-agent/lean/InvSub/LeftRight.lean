import Mathlib

/-!
# The gap in Propositions 5.2 / 5.3: `F` versus `F⁻`

Definition 5.1 uses the left-continuous `F₁⁻`, so `F_X ≤_{i-sb} 𝒫` means that
`x ↦ 1 - F_X⁻(1/x) = P(X ≥ 1/x)` is subadditive, while InvSub (Definition 2.2) asks for
subadditivity of `x ↦ 1 - F_X(1/x) = P(X > 1/x)`. The paper silently identifies the two.
They are different functions for distributions with atoms, but their subadditivity is
equivalent; we prove this here, which closes the gap in Proposition 5.3.
-/

open MeasureTheory Set Filter Topology

noncomputable section

def SubA (μ : Measure ℝ) : Prop :=
  ∀ x y : ℝ, 0 < x → 0 < y → μ (Ioi (1 / (x + y))) ≤ μ (Ioi (1 / x)) + μ (Ioi (1 / y))

def SubB (μ : Measure ℝ) : Prop :=
  ∀ x y : ℝ, 0 < x → 0 < y → μ (Ici (1 / (x + y))) ≤ μ (Ici (1 / x)) + μ (Ici (1 / y))

/-- `P(X > 1/(x + 1/(n+1))) → P(X ≥ 1/x)`. -/
lemma tendsto_Ioi_to_Ici (μ : Measure ℝ) [IsFiniteMeasure μ] (x : ℝ) (hx : 0 < x) :
    Tendsto (fun n : ℕ => μ (Ioi (1 / (x + 1 / ((n : ℝ) + 1))))) atTop (𝓝 (μ (Ici (1 / x)))) := by
  have hanti : Antitone fun n : ℕ => Ioi (1 / (x + 1 / ((n : ℝ) + 1))) := by
    intro m n hmn
    apply Ioi_subset_Ioi
    have : 1 / ((n : ℝ) + 1) ≤ 1 / ((m : ℝ) + 1) :=
      one_div_le_one_div_of_le (by positivity) (by exact_mod_cast Nat.add_le_add_right hmn 1)
    exact one_div_le_one_div_of_le (by positivity) (by linarith)
  have hI : (⋂ n : ℕ, Ioi (1 / (x + 1 / ((n : ℝ) + 1)))) = Ici (1 / x) := by
    ext s
    simp only [mem_iInter, mem_Ioi, mem_Ici]
    constructor
    · intro h
      by_contra! hlt
      -- choose n with 1/(x + 1/(n+1)) > s
      have hc : Tendsto (fun n : ℕ => 1 / (x + 1 / ((n : ℝ) + 1))) atTop (𝓝 (1 / (x + 0))) := by
        have : Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (𝓝 0) :=
          tendsto_one_div_add_atTop_nhds_zero_nat
        exact (tendsto_const_nhds (x := (1:ℝ))).div (tendsto_const_nhds.add this)
          (by rw [add_zero]; exact hx.ne')
      rw [add_zero] at hc
      obtain ⟨n, hn⟩ := (hc.eventually (lt_mem_nhds hlt)).exists
      exact absurd (h n) (not_lt.2 hn.le)
    · intro h n
      refine lt_of_lt_of_le ?_ h
      apply one_div_lt_one_div_of_lt hx
      have : 0 < 1 / ((n : ℝ) + 1) := by positivity
      linarith
  rw [← hI]
  exact tendsto_measure_iInter_atTop (fun n => measurableSet_Ioi.nullMeasurableSet) hanti
    ⟨0, measure_ne_top _ _⟩

/-- `P(X ≥ 1/s) → P(X > 1/x)` along `s ↑ x`, in the form we need. -/
lemma tendsto_Ici_to_Ioi (μ : Measure ℝ) [IsFiniteMeasure μ] (x : ℝ) (hx : 0 < x) :
    Tendsto (fun n : ℕ => μ (Ici (1 / x + 1 / ((n : ℝ) + 1)))) atTop (𝓝 (μ (Ioi (1 / x)))) := by
  have hmono : Monotone fun n : ℕ => Ici (1 / x + 1 / ((n : ℝ) + 1)) := by
    intro m n hmn
    apply Ici_subset_Ici.2
    have : 1 / ((n : ℝ) + 1) ≤ 1 / ((m : ℝ) + 1) :=
      one_div_le_one_div_of_le (by positivity) (by exact_mod_cast Nat.add_le_add_right hmn 1)
    linarith
  have hU : (⋃ n : ℕ, Ici (1 / x + 1 / ((n : ℝ) + 1))) = Ioi (1 / x) := by
    ext s
    simp only [mem_iUnion, mem_Ici, mem_Ioi]
    constructor
    · rintro ⟨n, hn⟩
      have : 0 < 1 / ((n : ℝ) + 1) := by positivity
      linarith
    · intro h
      obtain ⟨n, hn⟩ := exists_nat_one_div_lt (sub_pos.2 h)
      exact ⟨n, by linarith⟩
  rw [← hU]
  exact tendsto_measure_iUnion_atTop hmono

theorem subA_iff_subB (μ : Measure ℝ) [IsFiniteMeasure μ] : SubA μ ↔ SubB μ := by
  constructor
  · intro hA x y hx hy
    have hlim := (tendsto_Ioi_to_Ici μ x hx).add (tendsto_Ioi_to_Ici μ y hy)
    refine ge_of_tendsto hlim (Eventually.of_forall fun n => ?_)
    set ε := 1 / ((n : ℝ) + 1)
    have hε : 0 < ε := by positivity
    calc μ (Ici (1 / (x + y))) ≤ μ (Ioi (1 / ((x + ε) + (y + ε)))) := by
          apply measure_mono
          apply Ici_subset_Ioi.2
          apply one_div_lt_one_div_of_lt (by linarith); linarith
      _ ≤ μ (Ioi (1 / (x + ε))) + μ (Ioi (1 / (y + ε))) := hA _ _ (by linarith) (by linarith)
  · intro hB x y hx hy
    have hs : 0 < x + y := by linarith
    refine le_of_tendsto (tendsto_Ici_to_Ioi μ (x + y) hs) (Eventually.of_forall fun n => ?_)
    set ε := 1 / ((n : ℝ) + 1)
    have hε : 0 < ε := by positivity
    -- `1/(x+y) + ε = 1/s'` with `s' = λ (x + y)`, `λ = 1/(1 + ε (x+y)) ∈ (0,1)`
    set lam := 1 / (1 + ε * (x + y))
    have hlam0 : 0 < lam := by positivity
    have hlam1 : lam < 1 := by
      rw [div_lt_one (by positivity)]; nlinarith
    have e : 1 / (x + y) + ε = 1 / (lam * x + lam * y) := by
      simp only [lam]; field_simp
    have hx' : 1 / x < 1 / (lam * x) := by
      apply one_div_lt_one_div_of_lt (by positivity); nlinarith
    have hy' : 1 / y < 1 / (lam * y) := by
      apply one_div_lt_one_div_of_lt (by positivity); nlinarith
    rw [e]
    calc μ (Ici (1 / (lam * x + lam * y))) ≤ μ (Ici (1 / (lam * x))) + μ (Ici (1 / (lam * y))) :=
          hB _ _ (by positivity) (by positivity)
      _ ≤ μ (Ioi (1 / x)) + μ (Ioi (1 / y)) := by
          gcongr
          · exact Ici_subset_Ioi.2 hx'
          · exact Ici_subset_Ioi.2 hy'

end
