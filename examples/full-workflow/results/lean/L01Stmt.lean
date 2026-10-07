import Mathlib.Data.Real.Basic

/-
Statement definitions for L01 (PDF 2.1, Lemma, label `lem:amgm`).
Source: statement source/main.tex:37-43.

  "For all real numbers a and b we have
     ab ≤ (a²+b²)/2,
   with equality if and only if a = b."

No shared `Defs*.lean` file is used (RESULTS.json defs = NONE): this lemma
needs nothing beyond ordinary real-number arithmetic. No predecessors, no
external parameters, no consumed clauses.
-/

namespace Paper.L01

/-- Conclusion of Lemma 2.1 (`lem:amgm`), source/main.tex:37-43, split into
its two printed clauses so each can be judged independently:

* `ineq`: the inequality `ab ≤ (a²+b²)/2` (main.tex:38-40).
* `equality_iff`: the equality condition "with equality if and only if a = b"
  (main.tex:42), encoded as the iff `ab = (a²+b²)/2 ↔ a = b` (both
  directions of the source's "if and only if" are recorded). -/
structure L01Conclusion (a b : ℝ) : Prop where
  ineq : a * b ≤ (a ^ 2 + b ^ 2) / 2
  equality_iff : a * b = (a ^ 2 + b ^ 2) / 2 ↔ a = b

end Paper.L01
