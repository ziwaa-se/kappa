import Defs
import P03Stmt

/-!
P03 suspected issue 1 (pv-issue-checker): the proof step at main.tex:86,
"We have $s^2(x + y) = s^2(x) + s^2(y)$", for prop:sum (main.tex:81-83).

Contents:
* `PrintedStepS1`: main.tex:86 verbatim, under the proposition's hypotheses
  (`m ≥ 2`, `x y ∈ ℝ^m`, main.tex:82). Refuted at `m = 2`, `x = y = (0,1)` (`counterexample`).
* `PrintedStepS1_le`: the weaker reading "≤" of the same sentence (the most the chain at
  main.tex:86 could use). Also refuted at the same instance (`counterexample_le`), so the
  source route does not survive reading `=` as `≤`.
* `fails_every_m`: for EVERY `m ≥ 2` there are `x, y` violating the identity (scope: not an
  artefact of `m = 2`).
* `consumed_of_printed`: the printed step implies exactly the step obligation `P03_S1` in
  `pv_work/P03Draft.lean` (same statement), so the refutation hits precisely the consumed step.
* `concl_at_witness`: the printed CONCLUSION `P03Concl` (main.tex:82) holds at the witness
  (with equality 2 = 2): the counterexample refutes the step, not the proposition.
* `step2_holds`: the second link (main.tex:86-87) is true as printed, from the source's own
  reason (nonnegativity of `s²`).
-/

namespace Paper.P03.Issue1

open Paper.DEFS

/-- main.tex:86, "We have $s^2(x+y) = s^2(x)+s^2(y)$", with the hypotheses of prop:sum
(main.tex:82): `m ≥ 2`, `x, y ∈ ℝ^m`. Encoded verbatim; no extra premise, no stronger conclusion. -/
def PrintedStepS1 : Prop :=
  ∀ m : ℕ, 2 ≤ m → ∀ x y : Fin m → ℝ, s2 (x + y) = s2 x + s2 y

/-- Weaker reading of main.tex:86 with `≤` in place of `=` (implied by `PrintedStepS1`). -/
def PrintedStepS1_le : Prop :=
  ∀ m : ℕ, 2 ≤ m → ∀ x y : Fin m → ℝ, s2 (x + y) ≤ s2 x + s2 y

/-- The witness vector `(0,1) ∈ ℝ²`. -/
def w : Fin 2 → ℝ := ![0, 1]

theorem s2_w : s2 w = 1 / 2 := by
  simp [s2, mean, w, Fin.sum_univ_two]
  norm_num

theorem s2_ww : s2 (w + w) = 2 := by
  simp [s2, mean, w, Fin.sum_univ_two]
  norm_num

/-- Counterexample: `m = 2` (satisfies `m ≥ 2`), `x = y = (0,1)`:
`s²(x+y) = 2`, `s²(x)+s²(y) = 1`. -/
theorem counterexample : ¬ PrintedStepS1 := by
  intro h
  have := h 2 le_rfl w w
  rw [s2_ww, s2_w] at this
  norm_num at this

/-- Even the `≤` reading fails at the same witness (2 > 1). -/
theorem counterexample_le : ¬ PrintedStepS1_le := by
  intro h
  have := h 2 le_rfl w w
  rw [s2_ww, s2_w] at this
  norm_num at this

theorem eq_implies_le : PrintedStepS1 → PrintedStepS1_le := by
  intro h m hm x y
  exact le_of_eq (h m hm x y)

/-- Scope lemma (consumed_of_printed style): the printed step is literally the draft
obligation `P03_S1` (main.tex:86) at every consumed instance. -/
theorem consumed_of_printed (h : PrintedStepS1) (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 (x + y) = s2 x + s2 y :=
  h m hm x y

/-- The printed conclusion of prop:sum (main.tex:82) holds at the witness: `2 ≤ 2·½ + 2·½`. -/
theorem concl_at_witness : P03Concl w w := by
  unfold P03Concl
  rw [s2_ww, s2_w]
  norm_num

/-- `mean (x + x) = 2 * mean x`. -/
theorem mean_add_self {m : ℕ} (x : Fin m → ℝ) : mean (x + x) = 2 * mean x := by
  unfold mean
  simp only [Pi.add_apply, Finset.sum_add_distrib]
  ring

/-- `s²(x + x) = 4 s²(x)`. -/
theorem s2_add_self {m : ℕ} (x : Fin m → ℝ) : s2 (x + x) = 4 * s2 x := by
  unfold s2
  rw [mean_add_self]
  simp only [Pi.add_apply]
  rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- If `s²(x) = 0` with `m ≥ 2`, every coordinate equals the mean. -/
theorem coord_eq_mean_of_s2_zero {m : ℕ} (hm : 2 ≤ m) (x : Fin m → ℝ) (h0 : s2 x = 0)
    (i : Fin m) : x i = mean x := by
  unfold s2 at h0
  have hpos : (0 : ℝ) < (m : ℝ) - 1 := by
    have : (2 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
    linarith
  have hne : (1 / ((m : ℝ) - 1)) ≠ 0 := by positivity
  have hsum : ∑ j, (x j - mean x) ^ 2 = 0 := by
    rcases mul_eq_zero.mp h0 with h | h
    · exact absurd h hne
    · exact h
  have hall := (Finset.sum_eq_zero_iff_of_nonneg (fun j _ => sq_nonneg (x j - mean x))).mp hsum
  have := hall i (Finset.mem_univ i)
  have : x i - mean x = 0 := by
    rcases pow_eq_zero_iff (n := 2) (by norm_num) |>.mp this with h
    exact h
  linarith

/-- For EVERY `m ≥ 2` the identity fails for some `x, y` (take `x = y = e₀`). -/
theorem fails_every_m (m : ℕ) (hm : 2 ≤ m) :
    ∃ x y : Fin m → ℝ, s2 (x + y) ≠ s2 x + s2 y := by
  let i0 : Fin m := ⟨0, by omega⟩
  let i1 : Fin m := ⟨1, by omega⟩
  let x : Fin m → ℝ := fun i => if i = i0 then 1 else 0
  refine ⟨x, x, ?_⟩
  intro h
  rw [s2_add_self] at h
  have h0 : s2 x = 0 := by linarith
  have a := coord_eq_mean_of_s2_zero hm x h0 i0
  have b := coord_eq_mean_of_s2_zero hm x h0 i1
  have hne : i1 ≠ i0 := by
    intro e
    have := congrArg Fin.val e
    simp [i0, i1] at this
  have xa : x i0 = 1 := by simp [x]
  have xb : x i1 = 0 := by simp [x, hne]
  linarith

/-- Second link (main.tex:86-87), as printed, from the source's reason "both terms are
nonnegative" (nonnegativity of `s²`, from def:svar main.tex:33 with `m ≥ 2`). -/
theorem s2_nonneg {m : ℕ} (hm : 2 ≤ m) (x : Fin m → ℝ) : 0 ≤ s2 x := by
  unfold s2
  have hpos : (0 : ℝ) < (m : ℝ) - 1 := by
    have : (2 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
    linarith
  apply mul_nonneg
  · positivity
  · exact Finset.sum_nonneg (fun j _ => sq_nonneg (x j - mean x))

theorem step2_holds (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 x + s2 y ≤ 2 * s2 x + 2 * s2 y := by
  have := s2_nonneg hm x
  have := s2_nonneg hm y
  linarith

end Paper.P03.Issue1
