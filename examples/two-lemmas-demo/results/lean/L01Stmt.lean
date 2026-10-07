/-!
# L01Stmt — statement-level definitions for Lemma 1 (`lem:square`)

Source: `source/demo.tex:12-14` (statement), `source/demo.tex:16-18` (proof).

> For all real numbers $a$ and $b$ we have $a^2 + b^2 \ge 2ab$.

This result needs **no** auxiliary `structure` (the conclusion is a single
clause: one inequality on two universally quantified reals), **no**
external-input `def Tool : Prop` parameter, and **no** consumed predecessor
clause (`depends_on` is empty per `verification/INVENTORY.md`).

The one substantive fact the source's proof silently uses — that a real
square is nonnegative, i.e. `(a - b) ^ 2 ≥ 0` — has a *direct* mathlib
interface (`sq_nonneg`), confirmed by `#check` in
`pv_work/probes/drafter/L01/drafter_L01_check.lean` (see
`pv_work/notes/L01_draft_notes.md` for the exact evidence). Per
`VERDICTS.md` §4.2 ("do not spend tokens building infrastructure to save
one parameter" / a standard fact is registered as a (v) parameter only "if
proving it would need a lot of infrastructure"), this fact is cited
directly in the proof obligations of `L01Draft.lean` and is **not**
registered as a visible parameter here.

Hence this file contains no `def`/`structure`/`theorem` at all; it exists
only so that `L01Draft.lean` has a module to `import`, per the file-naming
convention.
-/

namespace Paper.L01

end Paper.L01
