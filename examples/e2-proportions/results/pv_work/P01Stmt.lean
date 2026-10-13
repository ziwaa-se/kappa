import Defs

/-!
P01 statement definitions (main.tex:55-58, Proposition `prop:concave`).
Reading of `I` (unstated, main.tex:24): CLOSED unit interval `IClosed`. The claim for the
open interval follows from the closed one (IOpen ⊆ IClosed), so this is the stronger reading.
-/

namespace Paper.P01

open Paper.DEFS

/-- Statement of step obligation `P01_S0` (NOT an external input; derivable from mathlib).
main.tex:61 "It is well known that the function `p ↦ √(p(1-p))` is concave on `I`."
Stated on the closed unit interval (`I` is unspecified in the source). -/
def SqrtConcave : Prop :=
  ConcaveOn ℝ IClosed (fun p : ℝ => Real.sqrt (p * (1 - p)))

/-- main.tex:56-57: `√(V_n((p+q)/2)) ≥ (1/2)(√(V_n p) + √(V_n q))`, for `p q ∈ I`. -/
def P01Claim (n : ℕ) (p q : ℝ) : Prop :=
  p ∈ IClosed → q ∈ IClosed →
    (1 / 2) * (Real.sqrt (V n p) + Real.sqrt (V n q)) ≤ Real.sqrt (V n ((p + q) / 2))

end Paper.P01
