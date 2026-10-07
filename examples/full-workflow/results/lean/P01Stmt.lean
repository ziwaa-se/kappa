import Mathlib.Data.Real.Basic

/-
Statement definitions for P01 (PDF 2.2, Proposition, label `prop:nesbitt`).
Source: statement source/main.tex:52-57.

  "For all x,y,z ∈ ℝ_{>0} we have
     S(x,y,z) ≥ 3(xy+yz+zx) / (2(x²+y²+z²))."

where S(x,y,z) = x/(y+z) + y/(z+x) + z/(x+y), defined source/main.tex:26-33
("Notation" section), "whenever the three denominators are nonzero".

No shared `Defs*.lean` file is used (RESULTS.json defs = NONE). `S` is
inlined directly (as the literal sum of the three fractions) rather than
given a separate named definition, since it is used only once, in P01's
own statement, and giving it a name would add no clarity here.

Predecessor: L01 (Lemma 2.1, `lem:amgm`) is FINAL_PASSED (UNCONDITIONAL,
no conditions); its module `Paper.L01` is imported directly in P01Draft.lean
(not here, since nothing in this statement file needs it) and its main
theorem `Paper.L01.L01_main` is called in the draft/proof, not redeclared
here.
-/

namespace Paper.P01

/-- The external input EXT-1: Nesbitt's inequality, cited
`\cite[Theorem~1]{Nesbitt1903}` at source/main.tex:60: "By Nesbitt's
inequality [Theorem 1], S(x,y,z) ≥ 3/2 for all x,y,z ∈ ℝ_{>0}."

Provenance (i): external result cited by the source, with an explicit
citation location and theorem number (Nesbitt1903, Theorem 1;
bibliography source/main.tex:87-90). Specialized exactly as the source
uses it: S(x,y,z) ≥ 3/2 for positive reals x, y, z, with S written out as
the literal sum of the three fractions (matching the Notation section's
definition, source/main.tex:26-33). Not made goal-shaped: this is exactly
the clause the source attributes to the citation, no more (it is not the
final conclusion of P01, which also needs L01's AM-GM step). -/
def NesbittInequality : Prop :=
  ∀ x y z : ℝ, 0 < x → 0 < y → 0 < z →
    x / (y + z) + y / (z + x) + z / (x + y) ≥ 3 / 2

/-- Conclusion of Proposition 2.2 (`prop:nesbitt`), source/main.tex:52-57:
"For all x,y,z ∈ ℝ_{>0} we have S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²))."
A single clause (the proposition has only one printed inequality, no
"moreover"/equality-condition clause as L01 did), so a plain `Prop`
(rather than a `structure`) is faithful here. `S(x,y,z)` is inlined as the
literal sum of the three fractions, matching source/main.tex:26-33. -/
def P01Conclusion (x y z : ℝ) : Prop :=
  x / (y + z) + y / (z + x) + z / (x + y) ≥
    (3 * (x * y + y * z + z * x)) / (2 * (x ^ 2 + y ^ 2 + z ^ 2))

end Paper.P01
