import Mathlib.Data.Real.Basic

/-!
# L02Stmt — statement definitions for Lemma 2 (`lem:xsquare`)

Source: `source/demo.tex:20-22` (statement), `source/demo.tex:24-27` (proof).

The printed statement is a single unstructured clause ("For every real number $x$ we have
$x^2 \ge x$."), so no conclusion `structure` is needed to separate clauses: the theorem in
`L02Draft.lean` states it directly as `∀ x : ℝ, x ^ 2 ≥ x`.

No predecessor results (`depends_on` is empty in `verification/INVENTORY.md` for L02), so no
`Consumed` clause is declared here.

No external parameter is declared in this file. The candidate external input flagged by the
inventory (the "same factors always have the same sign, hence nonnegative product" step,
`source/demo.tex:25-26`) is the one substantive internal step of *this* proof, not a fact cited
from outside the source or taken from elsewhere in the paper; it is therefore drafted as a step
obligation (`L02_S2`) in `L02Draft.lean`, to be judged/proved/refuted on its own, rather than
smuggled in here as an assumed-true `Prop` parameter of the main theorem (see the draft notes for
why: on inspection the claim is false for `0 < x < 1`, and granting it as a hypothesis would hide
a suspected paper error behind what looks like a routine external-input declaration).

Hence this file currently has no `def`/`structure` content beyond the namespace; it exists so
that `L02Draft.lean` has a module to `import`, per the file-naming convention of the rule card.
-/

namespace Paper.L02

end Paper.L02
