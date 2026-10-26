I couldn't compile any Lean here: this session has no shell and no Lean toolchain. The Lean code below is written against current Mathlib, but I haven't checked it. Lemma names and `field_simp` behaviour change between Mathlib versions, so expect some small fixes when you build it. Everything I say about the mathematics I checked by hand.

## Summary

| Result | Statement | Proof | Lean below |
|---|---|---|---|
| Thm 3.1 (uniqueness of the e-values) | Correct | Small errors | Algebraic core proved |
| Thm 3.2 (GROW) | Correct | Sign error, typo, missing edge case | Optimality proved (Gibbs inequality) |
| Thm 3.3 (all scores) | Correct, but needs `p ≠ q` | OK | Null set `H = [0,p]` and optimality proved |
| Prop 3.4 (product / averaging) | Correct if `p_t = q_t` is handled | Sketch OK, index range wrong | Not formalized |
| Prop 3.5 (optional stopping) | **False for `h ≥ 2`**; true for `h = 1` | **Invalid** | Counterexample checked by arithmetic |

## Theorem 3.1

The statement is correct. For p<q, write `A = ∫_{[p,q)} θ dν` and `N = ν[p,q)`. Then `0 < A < N`, `d(0) = −A`, `d(1) = N − A`, and the null-hypothesis boundary is `κ = A/N`. Every e-value in the family has `E(0) = 1−λ` and `E(1) = 1 + λ(1−κ)/κ`.

Problems in the proof:
1. **"It follows that E(0) ∈ (0,1)" is wrong.** E(0) = 0 is allowed; it is the case λ = 1, which the theorem itself includes. The correct range is `E(0) ∈ [0,1)`.
2. The step "(3.4) implies E_π(E) = 1 iff f(π) = 0" needs a short argument. Use continuity of the affine function g(π) = (1−π)E(0)+πE(1). If g(κ) < 1, then g < 1 slightly to the right of κ, which contradicts the alternative. This is the `heq` step in the Lean code.
3. When S(p,y) = ∞ is possible (for some ν), `d` should be defined directly as an integral over `[min(p,q), max(p,q))`, not as a difference of scores.

## Theorem 3.2

The statement is correct, including the table. I checked κ for the Brier, logarithmic and spherical scores by differentiating; all three are right. Writing the paper's λ in terms of κ gives `λ = (π₁−κ)/(1−κ)`.

Problems in the proof:
1. **Sign error:** `d_{p,q}(y) = ∫ 1{p≤θ<q}(θ − y) dν` should be `(y − θ)`. As written it gives `d(0) > 0 > d(1)`, which contradicts the line just before it. The ratios are unaffected, because flipping the sign of both cancels.
2. Typo: `1 − κ_ν{[p,q)}\}` has an extra `\}`. The theorem statement also pairs `\{` with `\big\}`.
3. **Gap at π₁ = 1** (and π₁ = 0 when p>q). Here `lim_{λ→1} g(λ) = −∞` is false: g is increasing and the maximum is at λ = 1, which is not in [0,1). The formula still gives the right answer (λ = 1, E(0) = 0), but the proof doesn't cover this case.
4. There's a shorter proof (used in the Lean below). By Gibbs' inequality, `log x ≤ x − 1`. Any valid E must satisfy `(1−κ)E(0) + κE(1) ≤ 1`, so `E_{π₁} log(E/E*) ≤ (1−κ)E(0) + κE(1) − 1 ≤ 0`. Uniqueness follows from the strict version.

## Theorem 3.3

The statement is correct, but it needs `p ≠ q`: if p = q then H = [0,1] and there is no alternative. The proof is fine.

Notice that E* is exactly the e-value of Theorem 3.2 with κ replaced by p. So the same Lean lemmas `thm31` and `grow` cover it.

## Proposition 3.4

The statement is correct, with two conditions:
- **The case `p_t = q_t` must be excluded or handled.** The hypothesis allows `(p_t,q_t) ∈ (0,1)²`, but eq. (3.1) is 0/0 when `p_t = q_t`. Set E ≡ 1 in that case.
- The proof sketch is fine. The conditioning indices should be `F_{k+hl}` for `l = 0,…,⌊(T−k)/h⌋−1`, not `1,…,⌊(T−k)/h⌋`.

Other notes:
- The text calls it a "lemma" and refers to "Lemma \ref{prop:combination}" in several places, but it is a Proposition.
- The h=1 derivation before it puts `Y_{T+1}` into the product, while the Proposition uses `Y_{l+h} ≤ T`.

## Proposition 3.5 — false for h ≥ 2

**The proof is invalid.** `e_t` is `F_t`-measurable, so `E(e_t | F_t) = e_t`. The assumption "`E(e_t|F_t) ≤ 1` a.s." therefore says `e_t ≤ 1`, which is false. Replacing it with `F_{t−1}` doesn't help either, because `1(τ=t)` is not `F_{t−1}`-measurable.

**For h ≥ 2 the statement is false.** For h ≥ 2, the h products are supermartingales only on the sub-filtrations `F_{k+hj}`. A stopping time with respect to `F_t` can use `F_{t+1}`-information about a bet that has already been placed.

**Counterexample (h = 2):**
- Brier score, `p_t ≡ 1/4`, `q_t ≡ 3/4`, so κ = 1/2.
- `λ_t ≡ 1`, `c_t ≡ 1`, so `E(0) = 0` and `E(1) = 2`.
- `Y_1 = Y_2 = 0`, `Y_3 ~ Bern(1/2)`, `Y_4 = Y_3`, and `Y_t` for t ≥ 5 i.i.d. Bern(1/2); natural filtration.

For every t, `E[d(Y_{t+2}) | F_t] = 0`, so Q ∈ H_S. Here `e_3 = (E(Y_3)+1)/2` and `e_4 = (E(Y_3)+E(Y_4))/2`. Take `τ = 3 + Y_3`, which is a stopping time. Then `E[e_3] = E[e_4] = 1`, but **`E[e_τ] = ½·2 + ½·½ = 5/4 > 1`**. Any positive dependence between `Y_{t+1}` and `Y_{t+2}` produces a similar violation.

**Correct version (all h):** set `λ'_l = λ_l·1{l < τ}`. This is adapted, so Prop 3.4 makes every `e'_T` an e-value. `e'_T` is constant for `T ≥ τ+h−1`, so Fatou gives `E[e'_{τ+h−1}] ≤ 1`. For h=1, `e'_τ = e_τ`, so the Proposition holds as stated when h=1.

This is what your text after the Proposition and Appendix B actually do: they freeze the bets and accept a random outcome. I checked the Appendix B argument and it is correct. So the fix is to restate Prop 3.5 in this form and replace its proof.

## Lean 4 code

```lean
import Mathlib

namespace EProb

/-! ## Theorem 3.3: elementary scores and the null set `H = [0,p]` (case p < q) -/

noncomputable def Sθ (θ p y : ℝ) : ℝ :=
  (θ - y) * ((if θ < p then 1 else 0) - (if θ < y then 1 else 0))

/-- expected elementary score when `P(Y=1) = r` -/
noncomputable def ESθ (θ p r : ℝ) : ℝ := (1 - r) * Sθ θ p 0 + r * Sθ θ p 1

theorem nullH_of_lt {p q r : ℝ} (hp0 : 0 < p) (hpq : p < q) (hq1 : q < 1) :
    (∀ θ, 0 ≤ θ → θ ≤ 1 → ESθ θ p r ≤ ESθ θ q r) ↔ r ≤ p := by
  have hp1 : p < 1 := hpq.trans hq1
  constructor
  · intro h
    have h' := h p hp0.le hp1.le
    simp [ESθ, Sθ, hpq, hp1, not_lt.mpr hp0.le] at h'
    nlinarith
  · intro hr θ hθ0 hθ1
    simp only [ESθ, Sθ]
    split_ifs <;> nlinarith

/-! ## Reduction (p < q): A = ∫_{[p,q)} θ dν, N = ν[p,q), d(0) = -A, d(1) = N - A -/

theorem reduction {A N r : ℝ} (hA : 0 < A) (hAN : A < N) :
    ((1 - r) * (-A) + r * (N - A) ≤ 0 ↔ r ≤ A / N) ∧
    (N - A) / |(-A)| = (1 - A / N) / (A / N) ∧
    -- the paper's λ for p<q equals (r - κ)/(1 - κ)
    r + (1 - r) * ((-A) / (N - A)) = (r - A / N) / (1 - A / N) := by
  have hN : 0 < N := hA.trans hAN
  have hA' : A ≠ 0 := hA.ne'
  have hN' : N ≠ 0 := hN.ne'
  have hNA : N - A ≠ 0 := (sub_pos.mpr hAN).ne'
  refine ⟨?_, ?_, ?_⟩
  · rw [le_div_iff₀ hN]
    constructor <;> intro h <;> nlinarith
  · rw [abs_neg, abs_of_pos hA]
    field_simp <;> ring
  · field_simp <;> ring

/-! ## Theorem 3.1 (after reduction, boundary κ ∈ (0,1)) -/

theorem thm31 {κ E0 E1 : ℝ} (hκ0 : 0 < κ) (hκ1 : κ < 1) (hE0 : 0 ≤ E0) (hE1 : 0 ≤ E1) :
    (∀ r : ℝ, 0 ≤ r → r ≤ 1 → ((1 - r) * E0 + r * E1 ≤ 1 ↔ r ≤ κ)) ↔
    ∃ l : ℝ, 0 < l ∧ l ≤ 1 ∧ E0 = 1 - l ∧ E1 = 1 + l * (1 - κ) / κ := by
  constructor
  · intro h
    have hk : (1 - κ) * E0 + κ * E1 ≤ 1 := (h κ hκ0.le hκ1.le).mpr le_rfl
    have h1 : 1 < E1 := by
      by_contra hc
      push_neg at hc
      have := (h 1 zero_le_one le_rfl).mp (by linarith)
      linarith
    -- the boundary is attained with equality (the step missing in the paper)
    have heq : (1 - κ) * E0 + κ * E1 = 1 := by
      by_contra hne
      obtain ⟨g, hg⟩ : ∃ g : ℝ, g = (1 - κ) * E0 + κ * E1 := ⟨_, rfl⟩
      rw [← hg] at hk hne
      have hlt : g < 1 := lt_of_le_of_ne hk hne
      have hden : 0 < E1 - g := by linarith
      obtain ⟨t, ht⟩ : ∃ t : ℝ, t = (1 - g) / (2 * (E1 - g)) := ⟨_, rfl⟩
      have ht0 : 0 < t := by rw [ht]; exact div_pos (by linarith) (by linarith)
      have htg : t * (E1 - g) = (1 - g) / 2 := by
        rw [ht, div_mul_eq_mul_div,
          div_eq_div_iff (mul_pos two_pos hden).ne' two_ne_zero]
        ring
      have ht1 : t < 1 := by
        by_contra hc
        push_neg at hc
        nlinarith [mul_nonneg (sub_nonneg.mpr hc) hden.le]
      have hval : (1 - (κ + t * (1 - κ))) * E0 + (κ + t * (1 - κ)) * E1
          = g + (1 - g) / 2 := by
        linear_combination htg + (t - 1) * hg
      have hle := (h (κ + t * (1 - κ))
        (by nlinarith [mul_pos ht0 (sub_pos.mpr hκ1)])
        (by nlinarith [mul_pos (sub_pos.mpr ht1) (sub_pos.mpr hκ1)])).mp
        (by linarith [hval])
      nlinarith [mul_pos ht0 (sub_pos.mpr hκ1)]
    have hE0lt : E0 < 1 := by
      by_contra hc
      push_neg at hc
      nlinarith [mul_le_mul_of_nonneg_left hc (sub_pos.mpr hκ1).le,
        mul_lt_mul_of_pos_left h1 hκ0]
    -- note E0 = 0 (λ = 1) is allowed: the paper's "E(0) ∈ (0,1)" is wrong
    refine ⟨1 - E0, by linarith, by linarith, by ring, ?_⟩
    have hfrac : (1 - E0) * (1 - κ) / κ = E1 - 1 := by
      rw [div_eq_iff hκ0.ne']
      linear_combination (-1 : ℝ) * heq
    linarith
  · rintro ⟨l, hl0, hl1, rfl, rfl⟩ r hr0 hr1
    have hκ' : κ ≠ 0 := hκ0.ne'
    have key : κ * ((1 - r) * (1 - l) + r * (1 + l * (1 - κ) / κ) - 1) = l * (r - κ) := by
      field_simp <;> ring
    constructor
    · intro h
      by_contra hc
      push_neg at hc
      nlinarith [mul_pos hl0 (sub_pos.mpr hc), mul_nonneg hκ0.le (sub_nonneg.mpr h)]
    · intro h
      by_contra hc
      push_neg at hc
      nlinarith [mul_pos hκ0 (sub_pos.mpr hc), mul_nonneg hl0.le (sub_nonneg.mpr h)]

/-! ## Theorems 3.2 / 3.3: growth-rate optimality via Gibbs' inequality.
Any valid E satisfies (1-κ)E(0) + κE(1) ≤ 1 (validity at r = κ; κ = p for Thm 3.3). -/

theorem grow {κ r E0 E1 : ℝ} (hκ0 : 0 < κ) (hκ1 : κ < 1) (hr0 : 0 < r) (hr1 : r < 1)
    (hE0 : 0 < E0) (hE1 : 0 < E1) (hval : (1 - κ) * E0 + κ * E1 ≤ 1) :
    (1 - r) * Real.log E0 + r * Real.log E1 ≤
      (1 - r) * Real.log ((1 - r) / (1 - κ)) + r * Real.log (r / κ) := by
  have hr' : (1 : ℝ) - r ≠ 0 := (sub_pos.mpr hr1).ne'
  have hκ' : (1 : ℝ) - κ ≠ 0 := (sub_pos.mpr hκ1).ne'
  have hκ'' : κ ≠ 0 := hκ0.ne'
  have hr'' : r ≠ 0 := hr0.ne'
  have ha : 0 < (1 - r) / (1 - κ) := div_pos (sub_pos.mpr hr1) (sub_pos.mpr hκ1)
  have hb : 0 < r / κ := div_pos hr0 hκ0
  have h1 := Real.log_le_sub_one_of_pos (div_pos hE0 ha)
  have h2 := Real.log_le_sub_one_of_pos (div_pos hE1 hb)
  rw [Real.log_div hE0.ne' ha.ne'] at h1
  rw [Real.log_div hE1.ne' hb.ne'] at h2
  have e1 : (1 - r) * (E0 / ((1 - r) / (1 - κ)) - 1) = (1 - κ) * E0 - (1 - r) := by
    field_simp <;> ring
  have e2 : r * (E1 / (r / κ) - 1) = κ * E1 - r := by
    field_simp <;> ring
  nlinarith [mul_le_mul_of_nonneg_left h1 (sub_pos.mpr hr1).le,
    mul_le_mul_of_nonneg_left h2 hr0.le]

/-- the optimiser E* = ((1-r)/(1-κ), r/κ) lies in the family of Thm 3.1 with λ = (r-κ)/(1-κ) -/
theorem grow_in_family {κ r : ℝ} (hκ0 : 0 < κ) (hκ1 : κ < 1) :
    (1 - r) / (1 - κ) = 1 - (r - κ) / (1 - κ) ∧
    r / κ = 1 + (r - κ) / (1 - κ) * (1 - κ) / κ := by
  have h1 : (1 : ℝ) - κ ≠ 0 := (sub_pos.mpr hκ1).ne'
  have h2 : κ ≠ 0 := hκ0.ne'
  constructor <;> field_simp <;> ring

/-! ## Counterexample to Proposition 3.5 (h = 2)
Brier, p ≡ 1/4, q ≡ 3/4, λ ≡ 1; Y₃ ~ Bern(1/2), Y₄ = Y₃; τ = 3 + Y₃. -/

noncomputable def brier (p y : ℝ) : ℝ := (p - y) ^ 2
noncomputable def dC (y : ℝ) : ℝ := brier (1/4) y - brier (3/4) y
noncomputable def EC (y : ℝ) : ℝ := 1 + 1 * dC y / |dC 0|   -- eq. (3.1), p < q, λ = 1

lemma dC0 : dC 0 = -1/2 := by norm_num [dC, brier]
lemma dC1 : dC 1 = 1/2 := by norm_num [dC, brier]
lemma EC0 : EC 0 = 0 := by
  rw [EC, dC0, abs_of_neg (by norm_num : (-1/2 : ℝ) < 0)]; norm_num
lemma EC1 : EC 1 = 2 := by
  rw [EC, dC1, dC0, abs_of_neg (by norm_num : (-1/2 : ℝ) < 0)]; norm_num

/-- the null holds: conditional probability 1/2 = κ gives zero expected score difference -/
lemma null_ok : (1/2 : ℝ) * dC 0 + (1/2) * dC 1 = 0 := by rw [dC0, dC1]; norm_num

/-- fixed times are fine: E[e₃] = E[e₄] = 1 -/
lemma fixed_ok :
    (1/2 : ℝ) * ((EC 1 + 1) / 2) + (1/2) * ((EC 0 + 1) / 2) = 1 ∧
    (1/2 : ℝ) * ((EC 1 + EC 1) / 2) + (1/2) * ((EC 0 + EC 0) / 2) = 1 := by
  rw [EC0, EC1]; norm_num

/-- but E[e_τ] = 5/4 > 1 -/
theorem prop35_false :
    (1/2 : ℝ) * ((EC 1 + EC 1) / 2) + (1/2) * ((EC 0 + 1) / 2) = 5/4 := by
  rw [EC0, EC1]; norm_num

end EProb
```

**What the code does not cover:**
- The measure-theoretic link `d(0) = −∫_{[p,q)}θ dν`, `d(1) = ∫_{[p,q)}(1−θ) dν` is done by hand above; the code starts from it.
- The p>q cases are symmetric and not written out.
- Prop 3.4 and the h=1 case of Prop 3.5 aren't formalized. Doing them properly needs `MeasureTheory.condExp` and supermartingale optional stopping, and I wouldn't trust a version I couldn't compile.
- `grow` assumes `E(0), E(1) > 0`, because Lean defines `log 0 = 0`.

## Other errors in the paper

**Substantive:**
- **Table 3:** the caption gives the condition as `min(p_t,q_t) ≥ 0.5`, but the text uses `c_t = 1{max(p_t,q_t) ≥ 0.5}`. One of them is wrong.
- **"p-values and e-values largely lead to the same conclusions" is overstated.** In several cells the e-value is strong or decisive while the Diebold–Mariano p-value is not significant:
  - BRU lag 1, HCLR/HCLR₋: E > 100, p = 0.07
  - BRU lag 3, IDR/HCLR₋: E ≈ 540, p = 0.19
  - LHR lag 1, IDR/HCLR₋: E = 15.0, p = 0.13
  - LHR lag 3, IDR/HCLR₋: E = 40.9, p = 0.14
  - ZRH lag 3, IDR/HCLR₋: E = 31.9, p = 0.44

  This is surprising given your power argument, so it deserves a comment (for example, that the two tests have different null hypotheses).
- **Rounding inconsistency between Table 2 and Table S1:** FRA lag 4 (5.9e−05) and ZRH lag 2 (5.0e−05), both HCLR/HCLR₋, are shown as `0.0001`. Elsewhere you write `<10^{-4}` for such values.
- **Section 5.3 is garbled:** "with only 9% or 27% of the data, respectively" doesn't say which airports these are, and the 85% for Zurich doesn't say which hypothesis.
- **Section 5.1 has a broken sentence:** "While the stochastic ordering assumption of IDR is certainly reasonable in this application" is left over from the commented-out text.
- **Supplement:** "close to μ = 0.05" should be μ = 0.5.
- **Section 4.1:** you cite Prop 3.4 for the average `e_t = (1/k)Σ_j e_{t;ξ_j}`. That also needs the fact that averages of e-values (and of supermartingales, for stopping) are again e-values.

**LaTeX:**
- In Table 1, `\label{tab:scores}` comes before `\caption`, so `Table \ref{tab:scores}` prints the wrong number.
- Appendix B: `E_{p_s,q_s;λ_s}(Y_{t+s}) ≡ 1` should be `Y_{s+h}`.
- Prop 3.5 says `Q ∈ H_S`; it should be `H_{S;c}`.

**Typos:** "on on GitHub", "are are therefore", "tests tests" (twice), "lower Brier score the HCLR" (missing "than", twice), "e-vales", "a almost surely", "the $1/E$ is", "at time if $T$ the initial capital", "forecasts dominance tests" (abstract).
