I checked all four numbered results in Lean, in `Check.lean`. It compiles with `lake env lean Check.lean` with no errors and no `sorry`. All four statements are true and proved in Lean. Lemma 2.2's proof is wrong, though.

## Results

**Lemma 2.1** (R(c) − ρ = (θ²+σ²)(c − c\*)²): the statement and proof are both correct. Lean proves it with `field_simp; ring` (`lem_square`).

**Lemma 2.2** (ρ ≤ min{θ², σ²}): the statement is correct (`lem_min`). The proof is wrong:
- It says "the harmonic mean of two positive numbers is at most the smaller of them." That is false. The harmonic mean always lies between the two numbers, so it is *at least* the smaller one. For example, H(1, 4) = 8/5 > 1. The Lean counterexample refutes the general claim.
- It also concludes ρ ≤ ½·min{θ², σ²}, which is false. With θ = 1 and σ = 2, ρ = 4/5 > 1/2 = ½·min{1, 4}. This is a second Lean counterexample.
- Two fixes work:
  - Use the correct bound H ≤ 2·min{a, b} (proved in Lean), which gives ρ = H/2 ≤ min.
  - Or argue directly: ρ = θ² · σ²/(θ²+σ²) ≤ θ², and the same with θ and σ swapped.

**Theorem 2.3** (R(c) ≥ ρ, with equality iff c = c\*, and ρ ≤ min{R(0), R(1)}): the statement is correct (`thm_oracle`). The proof is valid as written, since it only cites the statements of Lemmas 2.1 and 2.2, both of which are true. It still inherits the gap in Lemma 2.2's proof until that is fixed.

**Corollary 2.4** (R(c\*) ≤ R(1/2)): the statement and proof are correct (`cor_half`, which follows from Theorem 2.3). The proof's second sentence ("moreover, R(c\*) = ρ ≤ min{θ², σ²}") plays no part in the argument and could be cut.

## Other notes
- The standing assumption θ ≠ 0 is never used. Everything holds for θ = 0 as long as σ > 0, and the Lean proofs assume only σ > 0.

## Summary

| Result | Statement | Proof |
|---|---|---|
| Lemma 2.1 | ✅ True (Lean) | ✅ Correct |
| Lemma 2.2 | ✅ True (Lean) | ❌ Wrong: false claim about the harmonic mean and a false intermediate bound ρ ≤ ½·min (Lean counterexamples) |
| Theorem 2.3 | ✅ True (Lean) | ✅ Valid; relies on Lemma 2.2, whose proof needs fixing |
| Corollary 2.4 | ✅ True (Lean) | ✅ Correct (second sentence unnecessary) |
