import Mathlib.Data.Real.Basic

/-!
# L02 — statement definitions (Lemma 2.3, `lem:quot`)

Source: `source/main.tex:71-76` (statement), proof `source/main.tex:78-81`.
No shared `Defs*.lean` is used (RESULTS.json `defs` field is `NONE` for
this manuscript; the lemma is pure real-number arithmetic and needs no
notation beyond `ℝ`).

The printed statement is a single inequality over `ℝ` (no "with equality
iff" clause, no auxiliary notation like `S(x,y,z)` from the Notation
section), so **no conclusion structure is needed**: the main theorem in
`L02Draft.lean` states the inequality directly.

No external parameters are declared here:

* the "which is obvious" algebraic step (`x² ≥ (x-1)(x+1) = x²-1`,
  main.tex:80, candidate EXT-4 in `verification/INVENTORY.md` §6) is
  trivial `ℝ`-algebra that this project expects to discharge directly
  (e.g. by `ring`/`nlinarith`) — it is not "content the source cites or
  silently uses but this project does not prove," so it is written as
  a step obligation in `L02Draft.lean`, not as an opaque `Tool : Prop`;
* the sign-of-`(1+x)` gap in the multiplication step (candidate EXT-5)
  is a suspected **paper-side** issue (argument gap, and in fact the
  printed conclusion appears false for `x < -1`, e.g. `x = -2`, see
  `pv_work/notes/L02_draft_notes.md`), not an external input to encode
  as a parameter — per task instructions it is left as a faithfully
  stated, unprovable step obligation (`sorry`) for the gate/coordinator
  to route to `pv-issue-checker`, not patched or narrowed here.

There are no predecessor results (L02 has no `depends_on` entries in
`verification/INVENTORY.md` §3) and no already-declared external
parameters to reuse, so this file declares nothing beyond the
namespace.
-/

namespace Paper.L02

end Paper.L02
