import Defs

namespace Paper.P03

open Paper.DEFS

/-- main.tex:81-83 (prop:sum): for `m ≥ 2` and `x y ∈ ℝ^m`, `s²(x+y) ≤ 2 s²(x) + 2 s²(y)`.
The hypothesis `2 ≤ m` is part of the statement `P03Concl`'s use in the theorem. -/
def P03Concl {m : ℕ} (x y : Fin m → ℝ) : Prop :=
  s2 (x + y) ≤ 2 * s2 x + 2 * s2 y

end Paper.P03
