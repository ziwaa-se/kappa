import Mathlib.Data.Real.Basic

/-!
# L02 — statement definitions (Lemma 2.3, `lem:quot`), revision 1

Source (current, revision 1): statement `source/main.tex:71-76`, proof
`source/main.tex:78-81`. No shared `Defs*.lean` is used (RESULTS.json
`defs` field is `NONE` for this manuscript; the lemma is pure
real-number arithmetic and needs no notation beyond `ℝ`).

**Revision note**: this is a fresh draft after a source revision. The
previous (superseded) draft in `pv_work/superseded/L02Stmt.lean` /
`L02Draft.lean` encoded the *old* hypothesis `x ≠ -1`, which was
confirmed false for `x < -1` (see `verification/BLOCKERS.md` B01,
`verification/audits/L02_issue_1.md`,
`verification/audits/L02_issue_1_audit.md` — closed history, not
re-litigated here). The current source narrows the domain to `x > -1`
and the proof now explicitly states the sign fact `1+x > 0` before
multiplying. This file drafts only the current text.

The printed statement is a single inequality over `ℝ` (no "with
equality iff" clause, no auxiliary notation like `S(x,y,z)` from the
Notation section), so **no conclusion structure is needed**: the main
theorem in `L02Draft.lean` states the inequality directly.

No external parameters are declared here:

* the "which is obvious" algebraic step (`x² ≥ (x-1)(x+1) = x²-1`,
  main.tex:80, candidate EXT-4 in `verification/INVENTORY.md` §6) is
  trivial `ℝ`-algebra that this project expects to discharge directly
  (e.g. by `ring`/`nlinarith`) — it is not "content the source cites or
  silently uses but this project does not prove," so it is written as
  a step obligation in `L02Draft.lean`, not as an opaque `Tool : Prop`;
* the sign fact "`x > -1` implies `1 + x > 0`" (main.tex:79, "Since
  `1+x > 0`") is likewise trivial `ℝ`-order arithmetic, stated as a
  step obligation, not an external parameter — the former silent-sign
  gap (old EXT-5) is now an explicit (if terse) premise of the proof's
  own chain, closing that gap per the revision.

There are no predecessor results (L02 has no `depends_on` entries in
`verification/INVENTORY.md` §3) and no already-declared external
parameters to reuse, so this file declares nothing beyond the
namespace.
-/

namespace Paper.L02

end Paper.L02
