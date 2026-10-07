import L02Stmt

/-!
# L02 — statement draft (Lemma 2.3, `lem:quot`)

Source statement: `source/main.tex:71-76`.
Source proof: `source/main.tex:78-81`.

> For every real number `x ≠ -1` we have `x²/(1+x) ≥ x - 1`.
>
> Proof. Multiplying both sides by `1+x`, the claim is equivalent to
> `x² ≥ (x-1)(x+1) = x²-1`, which is obvious.

**Suspected issue, flagged for the gate/coordinator (do not patch):** the
proof's step "multiplying both sides by `1+x`" (S1 below) implicitly
needs `1+x > 0` to preserve the inequality's direction, but the
lemma's stated domain `x ≠ -1` also includes `x < -1`, where `1+x < 0`.
Concretely, at `x = -2` (which satisfies `x ≠ -1`): `x²/(1+x) = 4/(-1)
= -4` and `x - 1 = -3`, and `-4 ≥ -3` is **false**. So the printed
conclusion itself appears false on part of its stated domain, not just
the given argument — this looks like a candidate `ERROR` (printed
conclusion false), with the proof's silent sign assumption as a
contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP`. See
`pv_work/notes/L02_draft_notes.md` for detail; this draft states the
lemma and its proof step exactly as printed, without narrowing the
domain or adding a case split, per task instructions.
-/

namespace Paper.L02

/-- **S1** (main.tex:79, first clause of the proof sentence):
"Multiplying both sides by `1+x`, the claim is equivalent to
`x² ≥ (x-1)(x+1)`."

Role: records the claimed equivalence between the original inequality
and the cleared-denominator inequality, exactly as the source states it
— as a single step, for every `x ≠ -1`, with no case split on the sign
of `1+x`.

Uses: nothing but the hypothesis `x ≠ -1` (so that `1+x ≠ 0` and
division makes sense); no earlier step.

**This step is drafted faithfully as printed even though it is not an
unconditional equivalence**: multiplying an inequality by `1+x`
reverses direction when `1+x < 0` (i.e. `x < -1`), a case the source
does not address. See the suspected-issue note above and in
`pv_work/notes/L02_draft_notes.md`. Left as `sorry` for the prover /
`pv-issue-checker`, not fixed here. -/
theorem L02_S1 (x : ℝ) (hx : x ≠ -1) :
    x ^ 2 / (1 + x) ≥ x - 1 ↔ x ^ 2 ≥ (x - 1) * (x + 1) := by
  sorry

/-- **S2** (main.tex:80, second clause): "`(x-1)(x+1) = x²-1`."

Role: the algebraic expansion used to rewrite the cleared-denominator
inequality's right-hand side.

Uses: nothing but ordinary `ℝ`-algebra; no earlier step. Candidate
external input EXT-4 in `verification/INVENTORY.md` §6 ("which is
obvious") covers this together with S3; both are trivial and expected
to be dischargeable directly by the prover (e.g. `ring`), so no opaque
external parameter is declared for them. -/
theorem L02_S2 (x : ℝ) : (x - 1) * (x + 1) = x ^ 2 - 1 := by
  sorry

/-- **S3** (main.tex:80, third clause): "`x² ≥ x² - 1`, which is
obvious."

Role: the final trivial inequality that closes the cleared-denominator
form of the claim.

Uses: nothing but ordinary `ℝ`-algebra; no earlier step. -/
theorem L02_S3 (x : ℝ) : x ^ 2 ≥ x ^ 2 - 1 := by
  sorry

/-- **Main theorem** (Lemma 2.3, `lem:quot`, main.tex:71-76): "For every
real number `x ≠ -1` we have `x²/(1+x) ≥ x - 1`."

Stated exactly as printed, over the full domain `x ≠ -1` (not narrowed
to `x ≥ 0`, which is only how the companion paper mentioned in the
unregistered Remark at main.tex:83-85 happens to use it — that Remark
is not part of this lemma's statement).

Assembled from S1–S3: apply S1 to reduce the goal to the
cleared-denominator inequality, rewrite via S2, and close with S3.
This assembly is only as sound as S1, which is the flagged step above. -/
theorem L02_main (x : ℝ) (hx : x ≠ -1) : x ^ 2 / (1 + x) ≥ x - 1 := by
  have h1 := L02_S1 x hx
  have h2 := L02_S2 x
  have h3 := L02_S3 x
  apply h1.mpr
  rw [h2]
  exact h3

end Paper.L02
