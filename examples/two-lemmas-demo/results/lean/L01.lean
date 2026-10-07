import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import L01Stmt

/-!
# L01 — proof of Lemma 1 (`lem:square`)

Source statement: `source/demo.tex:12-14`.
Source proof: `source/demo.tex:16-18`.

> For all real numbers $a$ and $b$ we have $a^2 + b^2 \ge 2ab$.
> Proof. We have $a^2 + b^2 - 2ab = (a-b)^2 \ge 0$.

No predecessors, no external-input parameters (see `L01Stmt.lean` and
`pv_work/notes/L01_draft_notes.md` for why `sq_nonneg` is cited directly
rather than declared as a visible parameter), no candidate TFAs: the
statement is encoded with exactly the source's hypotheses (`a b : ℝ`, no
restriction) and exactly the source's conclusion.
-/

namespace Paper.L01

/-- **S1** (`source/demo.tex:16-17`): "We have
$a^2 + b^2 - 2ab = (a-b)^2$."
Role: the algebraic rewrite that is the first half of the proof's single
displayed chain `a^2+b^2-2ab = (a-b)^2 \ge 0`. Pure ring identity on `ℝ`,
no case split, no external input.
Uses: none (self-contained ring arithmetic). -/
theorem L01_S1 (a b : ℝ) : a ^ 2 + b ^ 2 - 2 * a * b = (a - b) ^ 2 := by
  ring

/-- **S2** (`source/demo.tex:17`): "$(a-b)^2 \ge 0$."
Role: the second half of the proof's displayed chain — nonnegativity of a
real square. The source gives no justification beyond writing it down;
this is the elementary, silently-used fact flagged in
`verification/INVENTORY.md` §5 as `sq_nonneg`. It has a direct mathlib
interface (`sq_nonneg`, confirmed by `#check`, see draft notes), so it is
cited directly here rather than introduced as a visible parameter.
Uses: the mathlib lemma `sq_nonneg` (type (v) in the provenance scheme,
but not registered as a parameter — see notes). -/
theorem L01_S2 (a b : ℝ) : (a - b) ^ 2 ≥ 0 := by
  exact sq_nonneg (a - b)

/-- **Main theorem** (`source/demo.tex:12-14`, Lemma 1, label `lem:square`):
"For all real numbers $a$ and $b$ we have $a^2 + b^2 \ge 2ab$."

Proof plan, assembled from S1 and S2 exactly as the one-sentence source
proof (`source/demo.tex:16-18`) does: rewrite `a^2+b^2-2ab` as `(a-b)^2`
(S1), note `(a-b)^2 \ge 0` (S2), and conclude `a^2+b^2-2ab \ge 0`, i.e.
`a^2+b^2 \ge 2ab`. -/
theorem L01_main (a b : ℝ) : a ^ 2 + b ^ 2 ≥ 2 * a * b := by
  have h1 : a ^ 2 + b ^ 2 - 2 * a * b = (a - b) ^ 2 := L01_S1 a b
  have h2 : (a - b) ^ 2 ≥ 0 := L01_S2 a b
  have h3 : a ^ 2 + b ^ 2 - 2 * a * b ≥ 0 := by rw [h1]; exact h2
  linarith

end Paper.L01
