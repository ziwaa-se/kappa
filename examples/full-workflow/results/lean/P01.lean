import P01Stmt
import L01
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Algebra.Order.Field.Basic

/-
Proof for P01 (PDF 2.2, Proposition, label `prop:nesbitt`).
Statement source: source/main.tex:52-57. Proof source: source/main.tex:59-69.

  Proof (main.tex:59-69):
  "By Nesbitt's inequality [Theorem 1], S(x,y,z) ≥ 3/2 for all x,y,z ∈ ℝ_{>0}.
   Applying Lemma 2.1 to the pairs (x,y), (y,z) and (z,x) and adding the
   three inequalities gives
     xy + yz + zx ≤ x^2 + y^2 + z^2 .
   Since x^2+y^2+z^2 > 0, dividing by it yields
   (xy+yz+zx)/(x^2+y^2+z^2) ≤ 1, and hence
   3(xy+yz+zx)/(2(x^2+y^2+z^2)) ≤ 3/2 ≤ S(x,y,z)."

Predecessor L01 is FINAL_PASSED (UNCONDITIONAL): its module `Paper.L01` is
imported directly above, and its main theorem `Paper.L01.L01_main` is
called in S3 below (not redeclared).

One external input is declared in `P01Stmt.lean`: `NesbittInequality`
(EXT-1, provenance (i), cited `\cite[Theorem~1]{Nesbitt1903}` at
main.tex:60). It is threaded through as an explicit hypothesis of the
main theorem and of S2, never as an axiom.

EXT-2 (positivity of x^2+y^2+z^2, main.tex:66) and EXT-3 (well-definedness
of S, i.e. positivity of the three denominators of S, Notation section
main.tex:26-33 combined with the domain main.tex:53) are both proved here
as ordinary step obligations (S1, S4), not declared as external
parameters, per the task instructions: both are immediate consequences of
`0 < x, 0 < y, 0 < z` and carry no independent mathematical content beyond
that positivity.

No candidate TFAs beyond `NesbittInequality` itself (see
pv_work/notes/P01_draft_notes.md for the full comparison table).
-/

namespace Paper.P01

/-- S1 (EXT-3: well-definedness of `S`, Notation section source/main.tex:26-33,
"whenever the three denominators are nonzero", combined with the domain
`x,y,z ∈ ℝ_{>0}` of the proposition's statement, main.tex:53).

Role: records that the three denominators of `S(x,y,z)` used throughout the
proof are positive (in particular nonzero), discharging the Notation
section's proviso on this proposition's domain. This fact is never restated
inside the proof body (main.tex:59-69) itself; it is silently relied upon
whenever `S(x,y,z)` is written down or manipulated.

Uses: nothing but `hx, hy, hz` (ordinary real-number positivity, immediate
from `0 < x, 0 < y, 0 < z`). Not used further in the purely arithmetic
chain S2–S6 below, since Lean's `/` is a total function and `S(x,y,z)` is
supplied directly as a hypothesis value via `NesbittInequality` in S2; this
step is recorded to discharge the silent well-definedness convention
faithfully, matching EXT-3 in verification/INVENTORY.md §6. -/
theorem P01_S1 (x y z : ℝ) (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) :
    0 < y + z ∧ 0 < z + x ∧ 0 < x + y := by
  refine ⟨?_, ?_, ?_⟩ <;> linarith

/-- S2 (main.tex:60, first sentence: "By Nesbitt's inequality
[Theorem 1], S(x,y,z) ≥ 3/2 for all x,y,z ∈ ℝ_{>0}.").

Role: instantiates the cited external result `NesbittInequality` at the
particular `x, y, z` of this proof, giving `S(x,y,z) ≥ 3/2`.

Uses: the external input `NesbittInequality` (EXT-1) and the positivity
hypotheses `hx, hy, hz`; no earlier step. -/
theorem P01_S2 (hN : NesbittInequality) (x y z : ℝ)
    (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) :
    x / (y + z) + y / (z + x) + z / (x + y) ≥ 3 / 2 := by
  exact hN x y z hx hy hz

/-- S3 (main.tex:61-65: "Applying Lemma 2.1 to the pairs (x,y), (y,z) and
(z,x) and adding the three inequalities gives xy + yz + zx ≤ x^2+y^2+z^2.").

Role: derives the key algebraic inequality by applying L01's `ineq` clause
(`Paper.L01.L01_main`) to the three pairs `(x,y)`, `(y,z)`, `(z,x)` and
summing the three resulting inequalities
`xy ≤ (x^2+y^2)/2`, `yz ≤ (y^2+z^2)/2`, `zx ≤ (z^2+x^2)/2`.

Uses: `Paper.L01.L01_main` (predecessor, FINAL_PASSED), applied three
times; no positivity hypotheses are needed for this purely algebraic step
(L01 holds for all real `a, b`), matching the source, which does not
invoke positivity of `x,y,z` at this particular step either. -/
theorem P01_S3 (x y z : ℝ) :
    x * y + y * z + z * x ≤ x ^ 2 + y ^ 2 + z ^ 2 := by
  have hxy := (Paper.L01.L01_main x y).ineq
  have hyz := (Paper.L01.L01_main y z).ineq
  have hzx := (Paper.L01.L01_main z x).ineq
  linarith [hxy, hyz, hzx]

/-- S4 (EXT-2, main.tex:66, "Since x^2+y^2+z^2 > 0, ...").

Role: records the positivity fact needed to divide by `x^2+y^2+z^2` in S5.

Uses: nothing but `hx, hy, hz` (each of `x^2, y^2, z^2` is positive since
`x, y, z` are positive, so their sum is positive); no earlier step. -/
theorem P01_S4 (x y z : ℝ) (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) :
    0 < x ^ 2 + y ^ 2 + z ^ 2 := by
  positivity

/-- S5 (main.tex:66-67: "... dividing by it yields
(xy+yz+zx)/(x^2+y^2+z^2) ≤ 1.").

Role: divides the inequality of S3 by the positive quantity of S4 to
obtain the ratio bound.

Uses: S3, S4. -/
theorem P01_S5 (x y z : ℝ) (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) :
    (x * y + y * z + z * x) / (x ^ 2 + y ^ 2 + z ^ 2) ≤ 1 := by
  have h3 := P01_S3 x y z
  have h4 := P01_S4 x y z hx hy hz
  rw [div_le_one h4]
  linarith [h3]

/-- S6 (main.tex:67-68, first inequality of the closing display:
"3(xy+yz+zx)/(2(x^2+y^2+z^2)) ≤ 3/2 ...").

Role: multiplies the ratio bound of S5 by `3/2` to obtain the bound on the
proposition's right-hand side, `3(xy+yz+zx)/(2(x^2+y^2+z^2)) ≤ 3/2`.

Uses: S5 (and S4, for the positivity needed to manipulate the doubled
denominator `2(x^2+y^2+z^2)`). -/
theorem P01_S6 (x y z : ℝ) (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) :
    (3 * (x * y + y * z + z * x)) / (2 * (x ^ 2 + y ^ 2 + z ^ 2)) ≤ 3 / 2 := by
  have h5 := P01_S5 x y z hx hy hz
  have h4 := P01_S4 x y z hx hy hz
  rw [div_le_iff₀ (by linarith : (0:ℝ) < 2 * (x ^ 2 + y ^ 2 + z ^ 2))]
  rw [div_le_one h4] at h5
  linarith [h5]

/-- Main theorem for P01 (PDF 2.2, `prop:nesbitt`), source/main.tex:52-57.

Assembled from S6 (`3(xy+yz+zx)/(2(x^2+y^2+z^2)) ≤ 3/2`) and S2
(`3/2 ≤ S(x,y,z)`, up to direction of `≥`), chained by transitivity, which
is exactly the closing display of the source proof (main.tex:67-68):
"3(xy+yz+zx)/(2(x^2+y^2+z^2)) ≤ 3/2 ≤ S(x,y,z)". S1, S3, S4, S5 are used
only indirectly, via S6's dependency chain. -/
theorem P01_main (hN : NesbittInequality) (x y z : ℝ)
    (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) : P01Conclusion x y z := by
  have h6 := P01_S6 x y z hx hy hz
  have h2 := P01_S2 hN x y z hx hy hz
  unfold P01Conclusion
  linarith [h6, h2]

end Paper.P01
