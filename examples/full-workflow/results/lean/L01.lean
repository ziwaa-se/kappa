import L01Stmt
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-
Proof for L01 (PDF 2.1, Lemma, label `lem:amgm`).
Statement source: source/main.tex:37-43. Proof source: source/main.tex:45-50.

  Proof (main.tex:45-50):
  "Since (a-b)^2 ≥ 0, expanding the square gives a^2 - 2ab + b^2 ≥ 0,
   that is, 2ab ≤ a^2 + b^2.  Dividing by 2 gives the inequality.
   Moreover, equality holds if and only if (a-b)^2 = 0, that is, if and only
   if a = b."

No predecessors, no external inputs. Imports `Mathlib.Tactic.Linarith` and
`Mathlib.Tactic.Ring` specifically (not the umbrella `Mathlib.Tactic`), per
the gate's environment note: this mathlib package directory is linked and
only partially built, and the umbrella modules fail to load here while these
two narrower modules load fine.
-/

namespace Paper.L01

/-- S1. Source main.tex:46, first clause: "Since (a-b)^2 ≥ 0, ...".
Role: records the starting fact of the proof, the nonnegativity of a real
square, from which S2 is derived by expansion.
Uses: nothing beyond ordinary real algebra (`sq_nonneg`-style fact, proved
directly here by `nlinarith` from `(a - b) * (a - b) ≥ 0`, itself a square of
a real number). -/
theorem L01_S1 (a b : ℝ) : (a - b) ^ 2 ≥ 0 := by
  nlinarith [sq_nonneg (a - b)]

/-- S2. Source main.tex:46, second/third clause: "expanding the square gives
a^2 - 2ab + b^2 ≥ 0, that is, 2ab ≤ a^2 + b^2."
Role: expands `(a-b)^2` and rearranges to the doubled inequality.
Uses: S1 (the expansion `(a-b)^2 = a^2 - 2*a*b + b^2` together with S1 gives
`a^2 - 2*a*b + b^2 ≥ 0`, which rearranges to `2*(a*b) ≤ a^2 + b^2`). -/
theorem L01_S2 (a b : ℝ) : 2 * (a * b) ≤ a ^ 2 + b ^ 2 := by
  nlinarith [L01_S1 a b]

/-- S3. Source main.tex:47: "Dividing by 2 gives the inequality."
Role: produces the stated inequality `ab ≤ (a²+b²)/2` (the `ineq` clause of
`L01Conclusion`) by dividing S2 by 2.
Uses: S2. -/
theorem L01_S3 (a b : ℝ) : a * b ≤ (a ^ 2 + b ^ 2) / 2 := by
  linarith [L01_S2 a b]

/-- S4. Source main.tex:48-49: "Moreover, equality holds if and only if
(a-b)^2 = 0, that is, if and only if a = b."
Role: produces the equality clause `equality_iff` of `L01Conclusion`.
Uses: the algebraic identity `a*b = (a^2+b^2)/2 ↔ (a-b)^2 = 0` (rearranging
the same expansion used in S2, now as an equation) together with the standard
fact that a real square vanishes iff its base does, `(a-b)^2 = 0 ↔ a - b = 0
↔ a = b`. Not an external input: elementary real-number algebra at the same
level as the lemma's own statement. -/
theorem L01_S4 (a b : ℝ) : a * b = (a ^ 2 + b ^ 2) / 2 ↔ a = b := by
  constructor
  · intro h
    have hsq : (a - b) ^ 2 = 0 := by nlinarith [h]
    have hzero : a - b = 0 := by
      have := sq_eq_zero_iff.mp hsq
      exact this
    linarith [hzero]
  · intro h
    subst h
    ring

/-- Main theorem for L01 (PDF 2.1, `lem:amgm`), source/main.tex:37-43.
Assembled from S3 (the `ineq` clause) and S4 (the `equality_iff` clause);
no other inputs. -/
theorem L01_main (a b : ℝ) : L01Conclusion a b :=
  ⟨L01_S3 a b, L01_S4 a b⟩

end Paper.L01
