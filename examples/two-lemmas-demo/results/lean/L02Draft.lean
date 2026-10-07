import L02Stmt
import Mathlib.Tactic.Linarith

/-!
# L02Draft — statement draft for Lemma 2 (`lem:xsquare`)

Source statement: `source/demo.tex:20-22`.
> For every real number $x$ we have $x^2 \ge x$.

Source proof: `source/demo.tex:24-27`.
> We have $x^2 - x = x(x-1)$. The two factors $x$ and $x-1$ always have the same
> sign, so their product is nonnegative, and hence $x^2 \ge x$.

No shared definitions are used (`defs = NONE` in `verification/INVENTORY.md`), and L02 has no
predecessor results.

**Drafter's note (see `pv_work/notes/L02_draft_notes.md` for full detail):** the key proof step
`L02_S2` below is suspected to be FALSE as printed (counterexample `x = 1/2`), and consequently the
main theorem itself is suspected to be false on `0 < x < 1` for the same value. This draft states
the theorem and the proof steps exactly as printed, with no invented hypothesis restricting `x`;
it does not repair or weaken the statement. The `sorry`s are left for the prover / issue-checker
to resolve via the suspected-issue process, not to be discharged by finding a different proof.
-/

namespace Paper.L02

/-- **S1** (`source/demo.tex:25`, first clause of the proof sentence):
"We have $x^2 - x = x(x-1)$."

Role: the algebraic rewriting of $x^2 - x$ used to reduce the goal to a statement about the sign
of the product $x(x-1)$. Purely algebraic; uses no earlier step or external input. -/
theorem L02_S1 (x : ℝ) : x ^ 2 - x = x * (x - 1) := by sorry

/-- **S2** (`source/demo.tex:25-26`, second clause of the proof sentence):
"The two factors $x$ and $x-1$ always have the same sign, so their product is nonnegative."

Role: the one substantive step of the proof — it is used, together with S1, to conclude
$x^2 - x \ge 0$. Formalized exactly as the printed sign-and-product claim resolves to: the product
$x \cdot (x-1)$ is nonnegative, for every real $x$.

Uses no earlier step and no external input: the source gives no citation and no case split here,
stating the "same sign" claim as a flat, case-free assertion about all real $x$.

**Suspected issue (recorded here, not patched):** this statement appears to be FALSE. For
`x = 1/2`, `x = 0.5 ≥ 0` and `x - 1 = -0.5 < 0`, i.e. the two factors have *opposite*, not the
same, sign, and `x * (x - 1) = -0.25 < 0`. See `pv_work/notes/L02_draft_notes.md` for the
candidate verdict class. This `sorry` should be routed to the suspected-issue process rather than
attempted by the prover. -/
theorem L02_S2 (x : ℝ) : 0 ≤ x * (x - 1) := by sorry

/-- **Main theorem**, assembled from S1 and S2, matching the printed conclusion "$x^2 \ge x$"
(`source/demo.tex:21-22`, consequence drawn in `source/demo.tex:26`, "and hence $x^2 \ge x$").

No additional hypothesis on `x` is added beyond "real number", matching the universally
quantified statement as printed. (If S2 is false, as suspected, this main theorem is expected to
inherit the same counterexample `x = 1/2`: `(1/2)^2 = 1/4 < 1/2`.) -/
theorem L02 (x : ℝ) : x ^ 2 ≥ x := by
  have h1 := L02_S1 x
  have h2 := L02_S2 x
  linarith [h1, h2]

end Paper.L02
