import L03Stmt
import L01

namespace Paper.L03

open Paper.DEFS

/-- S1. main.tex:70, "By Lemma~\ref{lem:quarter}, V_n(p) = p(1-p)/n ..."
Role: invoke L01 (gives identity and V_n(p) ≤ 1/(4n)). Uses: L01 main theorem. -/
theorem L03_S1 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : Paper.L01.Conclusion n p :=
  Paper.L01.L01_main n hn p

/-- S2. main.tex:70, "... p(1-p)/n ≤ p/(4n)" for `p ∈ I`.
Role: the final inequality of the proof. The source cites only Lemma quarter for it.
Uses: S1 (L01). SUSPECTED: not justified by L01 (which gives V ≤ 1/(4n), not p/(4n));
the claim p(1-p) ≤ p/4 fails at p = 1/10. Recorded, not repaired. -/
theorem L03_S2 (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ IOpen)
    (h : Paper.L01.Conclusion n p) : p * (1 - p) / (n : ℝ) ≤ p / (4 * (n : ℝ)) := by
  sorry

/-- Main theorem, main.tex:65-67 (Lemma `lem:linear`). Assembled from S1, S2. -/
theorem L03_main (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : L03Claim n p := by
  sorry

end Paper.L03
