# Review of "Elementary bounds on the sample variance"

**Lean not installed.** There is no Lean, `lake` or `elan` on this machine, so I could not compile the code below. I wrote it against current Mathlib and checked each step by hand, but it has not been machine-checked. I can install elan and Mathlib (a few GB) and compile it if you want.

## Summary

| Result | Statement | Proof |
|---|---|---|
| Lemma 2.1 (centred) | ✅ true | ✅ correct |
| Lemma 2.2 (shortcut) | ✅ true | ✅ correct (terse) |
| Prop 2.3 (Popoviciu) | ✅ true | ✅ correct (citation is accurate) |
| Prop 2.4 (Samuelson) | ✅ true | ⚠️ small gap: divides by `s`, which may be 0 |
| **Lemma 2.5 (raw)** | ❌ **false** | ❌ invalid step |
| Cor 2.6 (unit) | ✅ true | ❌ relies on the false lemma, and its middle step is false |

## Errors in the paper

**1. Lemma 2.5 is false.** Take n = 2 and x = (1, −1). Then x̄ = 0 and s² = (1 + 1)/1 = 2, but (1/n)Σxᵢ² = 1. So 2 ≤ 1 fails.

The proof correctly reaches (n−1)s² ≤ Σxᵢ², but "dividing by n" does not give s² ≤ (1/n)Σxᵢ². Dividing by n−1 gives the correct statement:

  s² ≤ (1/(n−1)) Σxᵢ².

**2. Corollary 2.6: the statement is true, but the proof is wrong.** The chain s² ≤ (1/n)Σxᵢ² ≤ 1 is false; the same example gives s² = 2. A correct proof:

  s² ≤ Σxᵢ²/(n−1) ≤ n/(n−1) ≤ 2 (since n ≥ 2).

The bound 2 is attained at x = (1, −1). Alternatively, Prop 2.3 with a = −1 and b = 1 gives s² ≤ n/(n−1) ≤ 2 directly.

**3. Prop 2.4 (Samuelson): proof gap.** The proof defines zⱼ = (xⱼ − x̄)/s, which is undefined when s = 0. Either handle that case separately (then every xᵢ = x̄ and the claim is trivial), or avoid dividing at all, as the Lean proof below does. It uses (xᵢ − x̄ + (n−1)(xⱼ − x̄))-type sums together with a single-term-≤-sum argument instead of Cauchy–Schwarz.

**Minor:** the proof of Lemma 2.2 just says "expanding the square". It is fine, but one more line would help: Σxᵢ² − 2x̄·nx̄ + nx̄².

## Lean 4 / Mathlib code

```lean
import Mathlib

open Finset

noncomputable section

/-- Sample mean (Definition 1.1). -/
def mean {n : ℕ} (x : Fin n → ℝ) : ℝ := (∑ i, x i) / n

/-- Sample variance with denominator `n - 1` (Definition 1.2). -/
def svar {n : ℕ} (x : Fin n → ℝ) : ℝ := (∑ i, (x i - mean x) ^ 2) / ((n : ℝ) - 1)

lemma sum_eq_mul_mean {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) :
    ∑ i, x i = n * mean x := by
  have hn' : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hn.ne'
  rw [mean]; field_simp

/-- Lemma 2.1. -/
theorem sum_sub_mean {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) :
    ∑ i, (x i - mean x) = 0 := by
  rw [Finset.sum_sub_distrib, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul, sum_eq_mul_mean hn, sub_self]

/-- Lemma 2.2. -/
theorem sum_sq_sub_mean {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) :
    ∑ i, (x i - mean x) ^ 2 = ∑ i, x i ^ 2 - n * mean x ^ 2 := by
  have h : ∀ i, (x i - mean x) ^ 2 = x i ^ 2 - 2 * mean x * x i + mean x ^ 2 :=
    fun i => by ring
  simp only [h, Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum,
    Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul,
    sum_eq_mul_mean hn]
  ring

/-- Popoviciu's inequality (population form), proved from scratch:
`(xᵢ - a)(b - xᵢ) ≥ 0` summed over `i`. -/
theorem popoviciu_sum {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) {a b : ℝ}
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) :
    ∑ i, (x i - mean x) ^ 2 ≤ n * ((b - a) ^ 2 / 4) := by
  have key : ∑ i, x i ^ 2 ≤ ∑ i, ((a + b) * x i - a * b) :=
    Finset.sum_le_sum fun i _ => by nlinarith [(hx i).1, (hx i).2]
  simp only [Finset.sum_sub_distrib, ← Finset.mul_sum, Finset.sum_const,
    Finset.card_univ, Fintype.card_fin, nsmul_eq_mul, sum_eq_mul_mean hn] at key
  rw [sum_sq_sub_mean hn]
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  nlinarith [mul_nonneg hn0 (sq_nonneg (mean x - (a + b) / 2))]

/-- Proposition 2.3. -/
theorem svar_le_popoviciu {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) {a b : ℝ}
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) :
    svar x ≤ n / (n - 1) * ((b - a) ^ 2 / 4) := by
  have hn1 : (0 : ℝ) < n - 1 := by
    have : (2 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  rw [svar, div_mul_eq_mul_div]
  exact div_le_div_of_nonneg_right (popoviciu_sum (by omega) x hx) hn1.le

/-- Proposition 2.4 (Samuelson). No division by `s`, so `s = 0` needs no special case. -/
theorem samuelson {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) (i : Fin n) :
    |x i - mean x| ≤ (n - 1) / Real.sqrt n * Real.sqrt (svar x) := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast (by omega : 0 < n)
  have hn1 : (0 : ℝ) < n - 1 := by
    have : (2 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  have hsum : ∑ j, (x j - mean x) = 0 := sum_sub_mean (by omega) x
  have hsq : ∑ j, (x j - mean x) ^ 2 = (n - 1) * svar x := by
    have := hn1.ne'
    rw [svar]; field_simp
  -- Σⱼ ((n-1)dⱼ + dᵢ)² = (n-1)² Σ dⱼ² + n dᵢ²
  have hT : ∑ j, ((n - 1 : ℝ) * (x j - mean x) + (x i - mean x)) ^ 2
      = (n - 1) ^ 2 * ∑ j, (x j - mean x) ^ 2 + n * (x i - mean x) ^ 2 := by
    have e : ∀ j, ((n - 1 : ℝ) * (x j - mean x) + (x i - mean x)) ^ 2
        = (n - 1) ^ 2 * (x j - mean x) ^ 2
          + (2 * (n - 1) * (x i - mean x)) * (x j - mean x) + (x i - mean x) ^ 2 :=
      fun j => by ring
    simp only [e, Finset.sum_add_distrib, ← Finset.mul_sum, hsum, Finset.sum_const,
      Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    ring
  -- the j = i term is at most the whole (nonnegative) sum
  have hle : ((n - 1 : ℝ) * (x i - mean x) + (x i - mean x)) ^ 2
      ≤ ∑ j, ((n - 1 : ℝ) * (x j - mean x) + (x i - mean x)) ^ 2 :=
    Finset.single_le_sum
      (f := fun j => ((n - 1 : ℝ) * (x j - mean x) + (x i - mean x)) ^ 2)
      (fun j _ => sq_nonneg _) (Finset.mem_univ i)
  rw [hT, hsq] at hle
  have h2 : (n - 1 : ℝ) * (n * (x i - mean x) ^ 2)
      ≤ (n - 1) * ((n - 1) ^ 2 * svar x) := by nlinarith [hle]
  have key : (n : ℝ) * (x i - mean x) ^ 2 ≤ (n - 1) ^ 2 * svar x :=
    le_of_mul_le_mul_left h2 hn1
  have hs := Real.sqrt_le_sqrt key
  rw [Real.sqrt_mul hn0.le, Real.sqrt_sq_eq_abs, Real.sqrt_mul (sq_nonneg _),
    Real.sqrt_sq hn1.le] at hs
  have hsn : 0 < Real.sqrt n := Real.sqrt_pos.mpr hn0
  rw [div_mul_eq_mul_div, le_div_iff₀ hsn]
  nlinarith [hs]

/-- Lemma 2.5 as stated is FALSE: counterexample n = 2, x = (1, -1). -/
theorem lem_raw_false :
    ¬ ∀ (n : ℕ), 2 ≤ n → ∀ x : Fin n → ℝ, svar x ≤ (1 / n) * ∑ i, x i ^ 2 := by
  intro h
  have := h 2 le_rfl ![1, -1]
  norm_num [svar, mean, Fin.sum_univ_two] at this

/-- Lemma 2.5, corrected: denominator `n - 1` instead of `n`. -/
theorem svar_le_raw {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) :
    svar x ≤ (∑ i, x i ^ 2) / (n - 1) := by
  have hn1 : (0 : ℝ) < n - 1 := by
    have : (2 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  rw [svar, sum_sq_sub_mean (by omega)]
  refine div_le_div_of_nonneg_right ?_ hn1.le
  have : (0 : ℝ) ≤ n * mean x ^ 2 := by positivity
  linarith

/-- Corollary 2.6 (true; proved via the corrected Lemma 2.5). -/
theorem svar_le_two {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) (hx : ∀ i, |x i| ≤ 1) :
    svar x ≤ 2 := by
  have hn2 : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have hn1 : (0 : ℝ) < n - 1 := by linarith
  have hsum : ∑ i, x i ^ 2 ≤ n := by
    calc ∑ i, x i ^ 2 ≤ ∑ _i : Fin n, (1 : ℝ) :=
          Finset.sum_le_sum fun i _ => by
            nlinarith [hx i, abs_nonneg (x i), sq_abs (x i)]
      _ = n := by simp
  calc svar x ≤ (∑ i, x i ^ 2) / (n - 1) := svar_le_raw hn x
    _ ≤ n / (n - 1) := div_le_div_of_nonneg_right hsum hn1.le
    _ ≤ 2 := by rw [div_le_iff₀ hn1]; linarith

end
```

### Notes on the formalization

- Observations are `x : Fin n → ℝ`. The hypothesis n ≥ 1 (or n ≥ 2) is passed explicitly where the paper assumes it.
- Mathlib has no ready-made Popoviciu inequality, so `popoviciu_sum` proves it from scratch. This also gives a self-contained proof you could put in the paper instead of the citation. The idea: (xᵢ−a)(b−xᵢ) ≥ 0 sums to Σ(xᵢ−x̄)² = n[(b−a)²/4 − (x̄ − (a+b)/2)²] − (nonneg) ≤ n(b−a)²/4.
- A few Mathlib names change between versions (`div_le_div_of_nonneg_right`, `le_div_iff₀`, `le_of_mul_le_mul_left`). If compilation fails, those lines are the most likely cause, and I'll fix them once I can run Lean.
