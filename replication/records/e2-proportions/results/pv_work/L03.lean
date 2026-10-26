import L03Stmt
import L01

namespace Paper.L03

open Paper.DEFS

/-- S1. main.tex:70, "By Lemma~\ref{lem:quarter}, V_n(p) = p(1-p)/n ..." -/
theorem L03_S1 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : Paper.L01.Conclusion n p :=
  Paper.L01.L01_main n hn p

/-- S2. main.tex:70, "... p(1-p)/n ≤ p/(4n)" for `p ∈ I`.
Stopped: suspected ERROR (false at n=1, p=1/10); not repaired. -/
theorem L03_S2 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ IOpen)
    (h : Paper.L01.Conclusion n p) : p * (1 - p) / (n : ℝ) ≤ p / (4 * (n : ℝ)) := by
  sorry

/-- Main theorem, main.tex:65-67 (Lemma `lem:linear`). -/
theorem L03_main (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : L03Claim n p := by
  intro hp
  have h := L03_S1 n hn p
  -- main.tex:70: V_n(p) = p(1-p)/n (definition of V) ≤ p/(4n)
  exact L03_S2 n hn p hp h

end Paper.L03
