import P04Stmt

/-!
# P05 statement definitions (source/VSIFP_02.tex:235-240, Proposition 3.5 `prop:stopping`)

Proof: l.473-478.  Only definitions here, no theorems.  Reuses `Paper.P04.{SeqSetting, eT, HScInt}`
(P04Stmt) and does not redeclare anything from it.
-/

open MeasureTheory

namespace Paper.P05

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- (p) Consumed clause of P04: the conclusion of P04 (source l.222-227, `Paper.P04.P04_main`,
`pv_work/P04.lean:556-560`) for every `T ≥ h+1`: `e_T` is `ℱ_T`-measurable and an e-value under
`ℋ_{S;c}`.  Applicability: P04's hypotheses (l.223) are P05's `hset`, `hS`, `hh` (l.236).
The conditional bound `E(e_t | F_t) ≤ 1` of the general lemma at l.474 is NOT part of this clause
(P04 gives only `E e_t ≤ 1`); it is the obligation `P05_Sbridge` in the draft. -/
def P05_P04Consumed (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) : Prop :=
  ∀ T : ℕ, h + 1 ≤ T → Paper.P04.P04Conclusion S h ℱ Y c p q lam T

end Paper.P05
