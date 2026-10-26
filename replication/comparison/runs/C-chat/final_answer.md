**Note:** No tools were available in this turn, so I could not compile anything. The Lean code below is written against current Mathlib but has **not been machine-checked**. Run `lake build` on it before relying on it.

**Scope of the Lean code.** Mathlib has no theory of Metropolis–Hastings kernels, geometric ergodicity, or Proposition 3.5 (Roberts–Tweedie). So the full theorems cannot be stated faithfully in Lean today. Instead I formalise:
- the deterministic inequalities the proofs depend on, and
- the counterexample behind the one real gap.

**Numbering**, from the shared `defn` counter:
- 2.2 is the negative theorem.
- 2.3 is the exponential-family corollary.
- 5.14 is Theorem `thm:light`.
- 5.15, 5.16 and 5.17 are `lem:xelower`, `lem:xlower` and `lem:arate_0`.

## Summary

| Result | Statement | Proof |
|---|---|---|
| Thm 2.2 (i) | True for fixed `L`; ambiguous under **A1** | Reduces to Thm 5.14; fine for fixed `L` |
| Thm 2.2 (ii) | True | Reduces to Thm 5.18; fine |
| Cor 2.3 (ii), β<1 | True | Correct via Thm 2.2(ii) |
| Cor 2.3 (ii), β>2 | True | **Gap:** (5.oscillations) fails for 2 < β < 1+log₂3 ≈ 2.585 |
| Thm 5.14 | True | Correct modulo the lemma issues; (oscillations) is actually unnecessary |
| Lem 5.15 | True | Arithmetic slip: the constant 6/ε² does not give a strict bound |
| Lem 5.16 | True as stated | Proof uses (oscillations), which is not a hypothesis; it is avoidable |
| Lem 5.17 | True | Correct; typos; relies on intermediate doublings not recorded in 5.16 |

## Details

### Theorem 2.2

**(i)** The statement says "HMC" in general. Theorem 5.14 is proved only for a fixed `T = Lε`, and (5.oscillation2) contains `2^L`, which is meaningless when `L` is random under **A1**.

The fix is easy. The set `{‖y‖ ≥ 2^L‖x‖}` shrinks as `L` grows, so the `L = 1` version of (oscillation2) implies all the others. If each `r_L(x) → 1`, then `r(x) = Σ_l P(L=l) r_l(x) → 1` by dominated convergence. State (oscillation2) with factor 2 and say this explicitly.

The final step, Prop 3.5, is fine. It holds because `r(x) ≥ 1 − sup_{‖p₀‖≤‖x‖^δ} α − P(‖p₀‖>‖x‖^δ) → 1` and π charges every neighbourhood of infinity.

**(ii)** This follows from Theorem 5.18. Note that 2.2 uses `≤ M` while 5.18 uses `< M`, which is harmless. Random `L` is also harmless: `L` is a.s. finite, so `Q(x, B_δ(x))` is still uniformly close to 1.

### Corollary 2.3(ii)

**β < 1.** Here `U ∈ C¹` and `|U'(x)| = αβ|x|^{β−1} → 0`, so `U'` is globally bounded. Since `|x|^β = o(|x|)`, we have `E_π e^{s|x|} = ∞` for every `s`. Theorem 2.2(ii) therefore applies. ✔

**β > 2.** Conditions (explode) and (oscillation2) hold. However, (5.oscillations) requires `|U'(y)| ≥ 3|U'(x)|` whenever `|y| ≥ 2|x|`. Taking `y = 2x` gives the ratio `2^{β−1}`, which is `< 3` when `β < 1 + log₂3`.

So for β ∈ (2, 2.585), **"direct consequence of Theorem 2.2" is false as written**. The conclusion is still true, because (oscillations) can be removed from Theorem 5.14 (see below). A Lean counterexample for β = 5/2 is at the end.

### Lemma 5.15

The proof says to "choose `x₀` such that the first term is larger than 6/ε²". This is garbled.

- If it means `‖∇U(x₀)‖/‖x₀‖ > 6/ε²`, the first term exceeds 3.
- Then the right-hand side is `> 3 − 1 − ε‖p₀‖/‖x₀‖`, which is *slightly less* than 2. That gives no strict bound.

Use 8/ε², or any constant above 6/ε², instead. Then everything holds uniformly for `‖x₀‖ > η`, because (explode) is a limit. Formalised as `lemma_5_15_core` below.

### Lemma 5.16

Two remarks on the proof:
- The coefficient of `‖∇U(x_ε)‖/‖x_ε‖` is ε², not ε²/2. The weaker bound is still valid.
- `δ` is reused for two different quantities.

The `i = 3` step and onwards invokes (5.oscillations), which is **not a hypothesis of the lemma**.

The lemma is nevertheless true under (explode) alone. By induction:
- `ε²‖∇U(x_{jε})‖ ≤ ‖x_{(j+1)ε}‖ + O(‖x_{jε}‖) ≤ C_j‖x_{(j+1)ε}‖`.
- So all earlier gradient terms in `x_{(i+1)ε} − x_{iε}` are `O(‖x_{iε}‖)`.
- Meanwhile `ε²‖∇U(x_{iε})‖/‖x_{iε}‖ → ∞`.

Hence `‖x_{(i+1)ε}‖/‖x_{iε}‖ → ∞`. The statement should also record the intermediate doublings `‖x_{iε}‖ ≥ 2‖x_{(i−1)ε}‖`, because Lemma 5.17 uses them.

### Lemma 5.17

The argument is correct. Specifically:
- `γ_L = 1 − 2Σ_{i=1}^L 3^{−i} = 3^{−L} > 0` (Lean: `gamma_L`).
- The squaring step is valid once `εγ_L‖∇U(x_{Lε})‖/2 − ‖p₀‖ ≥ 0` (Lean: `lemma_5_17_square`).
- The final step via (oscillation2) is valid.

Typos and fixes:
- "εδ_L" should be "εγ_L".
- "`M‖x_{Lε}‖ ≥ 2^L‖x₀‖`" should be "`M‖x_{Lε}‖ ≥ M2^L‖x₀‖`".
- Make the dependence on intermediate doublings explicit.

(Oscillations) is again avoidable:
- From the induction above, `‖∇U(x_{iε})‖ ≤ (C/ε²)‖x_{(i+1)ε}‖`.
- This is `o(‖∇U(x_{Lε})‖)` for every `i < L`.
- For `i = L−1` this uses (explode) at `x_{Lε}`; for smaller `i` it uses the diverging step ratios.

**Consequence:** Theorem 5.14, and hence Corollary 2.3(ii), hold for all β > 2 if (5.oscillations) is dropped. I recommend dropping it and replacing the geometric-series bound with this `o(·)` argument.

### Theorem 5.14

Given the corrected lemmas, the proof is correct. `P(‖p₀‖ ≤ ‖x₀‖^δ) → 1` holds for any δ > 0.

## Lean 4 (unverified; Mathlib)

```lean
import Mathlib

open Finset

/-- Core of Lemma 5.15 (with the corrected constant):
if (ε²/2)‖∇U(x₀)‖ ≥ 4‖x₀‖ and ε‖p₀‖ ≤ ‖x₀‖/2, then ‖x_ε‖ > 2‖x₀‖. -/
theorem lemma_5_15_core {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (x₀ g p : E) (ε : ℝ) (hε : 0 < ε) (hx : 0 < ‖x₀‖)
    (hg : 4 * ‖x₀‖ ≤ ε ^ 2 / 2 * ‖g‖) (hp : ε * ‖p‖ ≤ ‖x₀‖ / 2) :
    2 * ‖x₀‖ < ‖x₀ - (ε ^ 2 / 2) • g + ε • p‖ := by
  set v := x₀ - (ε ^ 2 / 2) • g + ε • p with hv
  have key : (ε ^ 2 / 2) • g = x₀ + ε • p - v := by rw [hv]; abel
  have h1 : ‖(ε ^ 2 / 2) • g‖ ≤ ‖x₀‖ + ‖ε • p‖ + ‖v‖ := by
    rw [key]
    calc ‖x₀ + ε • p - v‖ ≤ ‖x₀ + ε • p‖ + ‖v‖ := norm_sub_le _ _
      _ ≤ ‖x₀‖ + ‖ε • p‖ + ‖v‖ := by gcongr; exact norm_add_le _ _
  rw [norm_smul, norm_smul, Real.norm_of_nonneg (by positivity : (0:ℝ) ≤ ε ^ 2 / 2),
    Real.norm_of_nonneg hε.le] at h1
  linarith

/-- γ_L in Lemma 5.17: 1 - 2 Σ_{i=1}^L 3^{-i} = 3^{-L} > 0. -/
theorem gamma_L (L : ℕ) :
    1 - 2 * ∑ i ∈ Icc 1 L, ((1:ℝ) / 3) ^ i = ((1:ℝ) / 3) ^ L := by
  induction L with
  | zero => simp
  | succ n ih =>
    rw [sum_Icc_succ_top (by omega), pow_succ]
    linarith

/-- Squaring step of Lemma 5.17, with A = εγ_L‖∇U(x_{Lε})‖/2, P = ‖p₀‖, q = ‖p_{Lε}‖. -/
theorem lemma_5_17_square (P q A : ℝ) (hA : 0 ≤ A - P) (hq : A - P ≤ q) :
    P ^ 2 - q ^ 2 ≤ 2 * A * (P - A / 2) := by
  nlinarith [mul_nonneg (sub_nonneg.2 hq) (add_nonneg (le_trans hA hq) hA)]

/-- 2^{3/2} < 3. -/
theorem two_rpow_three_halves_lt_three : (2:ℝ) ^ ((3:ℝ) / 2) < 3 := by
  have h0 : (0:ℝ) ≤ 2 ^ ((3:ℝ) / 2) := Real.rpow_nonneg (by norm_num) _
  have hsq : ((2:ℝ) ^ ((3:ℝ) / 2)) ^ (2:ℕ) = 8 := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num),
      show (3:ℝ) / 2 * ((2:ℕ):ℝ) = ((3:ℕ):ℝ) by norm_num, Real.rpow_natCast]
    norm_num
  nlinarith [hsq]

/-- Counterexample: for U(x) = α|x|^{5/2} (β = 5/2 > 2), U'(x) ∝ x^{3/2} on x > 0,
and condition (5.oscillations) fails for every C. So Cor 2.3(ii) for β = 5/2
is not a direct consequence of Theorem 2.2(i) as stated. -/
theorem oscillations_fails_beta_five_halves (C : ℝ) :
    ∃ x y : ℝ, 0 < x ∧ C ≤ 2 * x ∧ 2 * x ≤ y ∧
      y ^ ((3:ℝ) / 2) < 3 * x ^ ((3:ℝ) / 2) := by
  have hx : 0 < max C 1 := lt_max_of_lt_right one_pos
  refine ⟨max C 1, 2 * max C 1, hx, ?_, le_rfl, ?_⟩
  · have := le_max_left C 1; linarith
  · rw [Real.mul_rpow (by norm_num) hx.le]
    have hp : 0 < (max C 1) ^ ((3:ℝ) / 2) := Real.rpow_pos_of_pos hx _
    nlinarith [two_rpow_three_halves_lt_three]
```

## Suggested edits

1. In Theorem 2.2(i) and 5.14, either drop (5.oscillations) and use the `o(·)` argument above, or restrict Corollary 2.3(ii) to β ≥ 1 + log₂3. Dropping it is preferable.
2. Make Theorem 2.2(i) explicit about fixed versus random `L`. Write (5.oscillation2) with factor 2 so that it covers all `L`.
3. In Lemma 5.15, change 6/ε² to 8/ε² and say it is the ratio `‖∇U‖/‖x₀‖` that exceeds it.
4. In Lemma 5.16, add the intermediate doublings to the statement and rename the second `δ`.
5. In Lemma 5.17, change δ_L to γ_L and fix "`M‖x_{Lε}‖ ≥ 2^L‖x₀‖`".
