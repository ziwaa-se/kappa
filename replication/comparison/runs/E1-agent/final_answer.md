I checked the paper's six numbered results in Lean. Four are correct as stated and proved. **Lemma 2.5 is false.** Corollary 2.6 is true, but its proof relies on Lemma 2.5 and is wrong. Samuelson's proof also has a small gap.

Everything is in `SampleVariance.lean`. It compiles with `lake env lean` with no errors and no `sorry`, and every theorem uses only Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`). In the Lean file, a sample is a function `Fin n → ℝ`, and the mean, variance and standard deviation are defined exactly as in Definitions 1.1 and 1.2.

## Result by result

**Lemma 2.1** (the deviations from the mean sum to zero). The statement and proof are correct. Proved as `lemma_2_1`.

**Lemma 2.2** (Σ(xᵢ − x̄)² = Σxᵢ² − n·x̄²). The statement and proof are correct. Proved as `lemma_2_2`.

**Proposition 2.3** (s² ≤ n/(n−1) · (b−a)²/4). The statement is correct. The proof is valid but rests on a citation to Popoviciu's inequality. I proved it from scratch as `proposition_2_3`: the sum of squared deviations is at most the sum of squares about c = (a+b)/2, and each of those terms is at most (b−a)²/4.

**Proposition 2.4** (Samuelson's inequality). The statement is correct. The proof has a gap: it sets zⱼ = (xⱼ − x̄)/s, which divides by s without handling s = 0. That case is trivial, since then every xᵢ equals x̄, but the paper should mention it. My Lean proof, `proposition_2_4`, avoids the division altogether. It applies Cauchy–Schwarz directly to dᵢ = xᵢ − x̄ to get n·dᵢ² ≤ (n−1)²s², so it covers all cases.

**Lemma 2.5** (s² ≤ (1/n)·Σxᵢ²). **False.**
- **Counterexample** (`lemma_2_5_false`): n = 2, x = (1, −1). Then x̄ = 0 and s² = 2, but (1/n)·Σxᵢ² = 1.
- **Error in the proof:** it correctly gets (n−1)s² ≤ Σxᵢ², but then divides by n instead of n−1.
- **Fix:** the correct bound is s² ≤ Σxᵢ²/(n−1), proved as `lemma_2_5_corrected`.

**Corollary 2.6** (if |xᵢ| ≤ 1 then s² ≤ 2). The statement is **true**, but the **proof is wrong**.
- The proof relies on the false Lemma 2.5.
- Its intermediate step s² ≤ 1 is itself false. The same x = (1, −1) gives s² = 2 (`corollary_2_6_proof_step_false`).
- **Correct proof** (`corollary_2_6`): s² ≤ Σxᵢ²/(n−1) ≤ n/(n−1) ≤ 2 when n ≥ 2. Proposition 2.3 with a = −1, b = 1 also gives it.
- The bound is sharp: x = (1, −1) reaches s² = 2, also checked in Lean.

## Other notes on the paper
- The abstract mentions "a bound in terms of the raw second moment". That is the false Lemma 2.5 and needs to be corrected to use n−1.
- The citation for Popoviciu's inequality (*Mathematica (Cluj)* 9, 1935) is the standard reference. With no internet access I could not check the bibliographic details.

## Summary

| Result | Statement | Proof | Lean |
|---|---|---|---|
| Lemma 2.1 | Correct | Correct | Proved |
| Lemma 2.2 | Correct | Correct | Proved |
| Proposition 2.3 | Correct | Correct (rests on the citation) | Proved from scratch |
| Proposition 2.4 (Samuelson) | Correct | Small gap: doesn't handle s = 0 | Proved, all cases |
| Lemma 2.5 | **False** | Wrong: divides by n instead of n−1 | Counterexample x = (1, −1); corrected version proved |
| Corollary 2.6 | Correct (and sharp) | **Wrong**: uses Lemma 2.5 and the false step s² ≤ 1 | Proved with a corrected argument; the false step is refuted in Lean |
