I couldn't run Lean here: no toolchain turned up and the shell checks gave me no usable output. So the Lean code below is **not compiled**. It sticks to standard Mathlib tactics (`field_simp`, `ring`, `nlinarith`, `positivity`), but please run it through `lake build` before relying on it.

## Summary

| Result | Statement | Proof |
|---|---|---|
| Lemma 2.1 (square) | ✅ correct | ✅ correct |
| Lemma 2.2 (min) | ✅ correct | ❌ **wrong** |
| Theorem 2.3 | ✅ correct | ✅ correct (given Lemma 2.2's statement) |
| Corollary 2.4 | ✅ correct | ✅ correct, but the second sentence is irrelevant |

## Errors in the paper

**Lemma 2.2's proof is false in two places.**

1. *"The harmonic mean of two positive numbers is at most the smaller of them."* This is backwards. The harmonic mean lies **between** the two numbers: min ≤ H ≤ max.
   - Take θ² = 1, σ² = 3. Then H = 2·3/4 = 3/2 > 1 = min.
2. The intermediate claim ρ ≤ ½·min{θ², σ²} is also false.
   - Same example: ρ = 3/4, but ½·min = 1/2.

The lemma's statement is still true, and the fix is short:

> ρ = θ² · σ²/(θ²+σ²) ≤ θ², since σ²/(θ²+σ²) ≤ 1. Symmetrically, ρ ≤ σ².

Since θ ≠ 0, both fractions are < 1, so you even get the strict bound ρ < min{θ², σ²}.

**Corollary 2.4, minor point.** The first sentence is a complete proof. The second ("moreover, R(c*) ≤ min{θ², σ²}") plays no role in proving R(c*) ≤ R(1/2) and should be deleted. The corollary also follows immediately from Theorem 2.3 with c = 1/2.

**The rest checks out:**
- Expanding the risk gives R(c) = (θ²+σ²)c² − 2θ²c + θ².
- The completed square is right, and θ² − θ⁴/(θ²+σ²) = θ²σ²/(θ²+σ²).
- The MSE interpretation E(cX−θ)² = c²σ² + (1−c)²θ² is correct.

## Lean 4 / Mathlib code (uncompiled)

```lean
import Mathlib

namespace OracleShrinkage

variable (θ σ : ℝ)

def R (c : ℝ) : ℝ := c ^ 2 * σ ^ 2 + (1 - c) ^ 2 * θ ^ 2
noncomputable def cstar : ℝ := θ ^ 2 / (θ ^ 2 + σ ^ 2)
noncomputable def ρ : ℝ := θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2)

lemma denom_pos (hσ : 0 < σ) : 0 < θ ^ 2 + σ ^ 2 := by positivity

/-- Lemma 2.1 -/
lemma square (hσ : 0 < σ) (c : ℝ) :
    R θ σ c - ρ θ σ = (θ ^ 2 + σ ^ 2) * (c - cstar θ σ) ^ 2 := by
  have h := (denom_pos θ σ hσ).ne'
  unfold R ρ cstar
  field_simp
  ring

/-- Lemma 2.2 (statement correct; proof uses ρ = θ²·σ²/(θ²+σ²) ≤ θ², σ²) -/
lemma le_min' (hσ : 0 < σ) : ρ θ σ ≤ min (θ ^ 2) (σ ^ 2) := by
  have hd := denom_pos θ σ hσ
  unfold ρ
  apply le_min
  · rw [div_le_iff₀ hd]; nlinarith [sq_nonneg θ, sq_nonneg σ, mul_nonneg (sq_nonneg θ) (sq_nonneg θ)]
  · rw [div_le_iff₀ hd]; nlinarith [sq_nonneg θ, sq_nonneg σ, mul_nonneg (sq_nonneg σ) (sq_nonneg σ)]

/-- Counterexample to the intermediate claim ρ ≤ ½·min in the paper's proof:
    θ = 1, σ² = 3 (σ = √3). -/
example : ¬ (ρ 1 (Real.sqrt 3) ≤ (1 / 2) * min (1 ^ 2) (Real.sqrt 3 ^ 2)) := by
  have h3 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  unfold ρ
  rw [h3]
  norm_num

/-- Theorem 2.3 -/
theorem oracle (hσ : 0 < σ) :
    (∀ c, ρ θ σ ≤ R θ σ c) ∧
    (∀ c, R θ σ c = ρ θ σ ↔ c = cstar θ σ) ∧
    ρ θ σ ≤ min (R θ σ 0) (R θ σ 1) := by
  have hd := denom_pos θ σ hσ
  refine ⟨fun c => ?_, fun c => ?_, ?_⟩
  · have := square θ σ hσ c
    nlinarith [mul_nonneg hd.le (sq_nonneg (c - cstar θ σ))]
  · have := square θ σ hσ c
    constructor
    · intro h
      have h0 : (θ ^ 2 + σ ^ 2) * (c - cstar θ σ) ^ 2 = 0 := by linarith
      rcases mul_eq_zero.mp h0 with h1 | h1
      · exact absurd h1 hd.ne'
      · exact sub_eq_zero.mp (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp h1)
    · intro h; subst h; simp at this; linarith
  · have h0 : R θ σ 0 = θ ^ 2 := by unfold R; ring
    have h1 : R θ σ 1 = σ ^ 2 := by unfold R; ring
    rw [h0, h1]
    exact le_min' θ σ hσ

/-- Corollary 2.4 -/
theorem half (hσ : 0 < σ) : R θ σ (cstar θ σ) ≤ R θ σ (1 / 2) := by
  have h1 := (oracle θ σ hσ).1 (1 / 2)
  have h2 := ((oracle θ σ hσ).2.1 (cstar θ σ)).mpr rfl
  linarith

end OracleShrinkage
```

Notes on the formalization:
- I only needed σ > 0, not θ ≠ 0, for all four results. The hypothesis θ ≠ 0 matters only if you want the strict version ρ < min{θ², σ²}.
- The `nlinarith` hint lists and the `pow_eq_zero_iff` call are the parts most likely to need small adjustments depending on your Mathlib version.

If you install Lean and Mathlib (`elan` plus a `lake new … math` project), I can compile this and fix whatever breaks.
