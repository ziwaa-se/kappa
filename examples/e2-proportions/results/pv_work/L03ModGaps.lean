import L03Stmt
import L01

namespace Paper.L03

open Paper.DEFS

/-- S1. main.tex:70, "By Lemma~\ref{lem:quarter}, V_n(p) = p(1-p)/n ..." -/
theorem L03_S1 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : Paper.L01.Conclusion n p :=
  Paper.L01.L01_main n hn p

/-- Gap for S2 (main.tex:70): confirmed ERROR, false at n=1, p=1/10. -/
def L03_S2_Gap : Prop :=
  ∀ (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ IOpen)
    (h : Paper.L01.Conclusion n p),p * (1 - p) / (n : ℝ) ≤ p / (4 * (n : ℝ))

/-- Main theorem, main.tex:65-67, modulo the gap. -/
theorem L03_main_mod_gaps (hGap_2 : L03_S2_Gap) (n : ℕ) (hn : 1 ≤ n) (p : ℝ) :
    L03Claim n p := by
  intro hp
  have h := L03_S1 n hn p
  exact hGap_2 n hn p hp h

end Paper.L03
