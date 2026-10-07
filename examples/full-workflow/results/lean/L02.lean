import L02Stmt
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Algebra.Order.Field.Basic

/-!
# L02 — proof (Lemma 2.3, `lem:quot`), revision 1

Source statement: `source/main.tex:71-76` (current, revision 1).
Source proof: `source/main.tex:78-81` (current, revision 1).

> For every real number `x > -1` we have `x²/(1+x) ≥ x - 1`.
>
> Proof. Since `1+x > 0`, multiplying both sides by `1+x` preserves the
> inequality, so the claim is equivalent to `x² ≥ (x-1)(x+1) = x²-1`,
> which is obvious.

This file proves the four step obligations drafted in `L02Draft.lean`
and assembles them into `L02_main`, strictly following the source's
own route: sign fact (S1), clearing the denominator via the
equivalence (S2, using `le_div_iff₀` per the gate reviewer's note that
`le_div_iff` does not exist in the pinned mathlib), the algebraic
identity (S3), and the final trivial inequality (S4).
-/

namespace Paper.L02

/-- **S1** (main.tex:79, first clause: "Since `1+x > 0`"):
the sign fact that justifies the multiplication step.

Role: records, as its own obligation, the trivial order fact used to
license multiplying the inequality by `1+x` without reversing it. The
source states this as a one-clause justification ("Since `1+x>0`"),
immediate from the hypothesis `x > -1`.

Uses: nothing but the hypothesis `x > -1`; no earlier step. -/
theorem L02_S1 (x : ℝ) (hx : x > -1) : (1 : ℝ) + x > 0 := by
  linarith

/-- **S2** (main.tex:79, second clause: "multiplying both sides by
`1+x` preserves the inequality, so the claim is equivalent to
`x² ≥ (x-1)(x+1)`"):

Role: records the claimed equivalence between the original inequality
and the cleared-denominator inequality, licensed by S1 (`1+x > 0`),
exactly as the source states it.

Uses: S1 (the sign fact `1 + x > 0`); no other earlier step. -/
theorem L02_S2 (x : ℝ) (hx : x > -1) :
    x ^ 2 / (1 + x) ≥ x - 1 ↔ x ^ 2 ≥ (x - 1) * (x + 1) := by
  have h1 := L02_S1 x hx
  rw [ge_iff_le, le_div_iff₀ h1]
  constructor
  · intro h; nlinarith
  · intro h; nlinarith

/-- **S3** (main.tex:80, third clause: "`(x-1)(x+1) = x²-1`"):

Role: the algebraic expansion used to rewrite the cleared-denominator
inequality's right-hand side.

Uses: nothing but ordinary `ℝ`-algebra; no earlier step. -/
theorem L02_S3 (x : ℝ) : (x - 1) * (x + 1) = x ^ 2 - 1 := by
  ring

/-- **S4** (main.tex:80, fourth clause: "`x² ≥ x²-1`, which is
obvious"):

Role: the final trivial inequality that closes the cleared-denominator
form of the claim. This is the "which is obvious" assertion flagged as
candidate external input EXT-4 in `verification/INVENTORY.md` §6; it
is trivial `ℝ`-algebra, dischargeable directly, so no opaque external
parameter is declared for it.

Uses: nothing but ordinary `ℝ`-algebra; no earlier step. -/
theorem L02_S4 (x : ℝ) : x ^ 2 ≥ x ^ 2 - 1 := by
  linarith

/-- **Main theorem** (Lemma 2.3, `lem:quot`, main.tex:71-76, current
revision): "For every real number `x > -1` we have
`x²/(1+x) ≥ x - 1`."

Stated exactly as printed in the current source, over the domain
`x > -1` (not narrowed further to `x ≥ 0`, which is only how the
companion paper mentioned in the unregistered Remark at
main.tex:83-85 happens to use it — that Remark is not part of this
lemma's statement).

Assembled from S1–S4: S1 gives the sign fact; S2 (using S1) reduces
the goal to the cleared-denominator inequality; S3 rewrites its
right-hand side; S4 closes it. -/
theorem L02_main (x : ℝ) (hx : x > -1) : x ^ 2 / (1 + x) ≥ x - 1 := by
  have h2 := L02_S2 x hx
  have h3 := L02_S3 x
  have h4 := L02_S4 x
  apply h2.mpr
  rw [h3]
  exact h4

end Paper.L02
