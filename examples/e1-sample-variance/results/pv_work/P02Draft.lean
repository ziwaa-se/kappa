import P02Stmt
import L01

namespace Paper.P02

/-- source/main.tex:76 "By Lemma 2.1, ∑_j z_j = 0" (L01 used: `Paper.L01.L01_main`, the main
theorem of L01 in `L01.lean`).  Role: first fact about the normalised deviations.
Uses L01.  -/
theorem P02_S1 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) : ∑ j, z x j = 0 := by
  sorry

/-- source/main.tex:76-77 "by the definition of s², ∑_j z_j² = n - 1".
NOTE: this needs `s ≠ 0` (division by s at line 76); the source never treats `s = 0`, so the
hypothesis `hs` is recorded here as the point the source does not justify.  Do not repair.
Role: second fact about z.  Uses the definition of s². -/
theorem P02_S2 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) :
    ∑ j, (z x j) ^ 2 = (n : ℝ) - 1 := by
  sorry

/-- source/main.tex:77 "Fix i. Then z_i = -∑_{j≠i} z_j".  Uses S1. -/
theorem P02_S3 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (i : Fin n) :
    z x i = - ∑ j ∈ Finset.univ.erase i, z x j := by
  sorry

/-- source/main.tex:77-80 "by the Cauchy-Schwarz inequality z_i² ≤ (n-1) ∑_{j≠i} z_j²"
(first inequality of the display; the sum over `j ≠ i` has `n-1` terms).  Uses S3. -/
theorem P02_S4 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (i : Fin n) :
    (z x i) ^ 2 ≤ ((n : ℝ) - 1) * ∑ j ∈ Finset.univ.erase i, (z x j) ^ 2 := by
  sorry

/-- source/main.tex:80 equality of the display: `(n-1) ∑_{j≠i} z_j² = (n-1)(n-1-z_i²)`.
Uses S2 (hence `s ≠ 0`, untreated in the source). -/
theorem P02_S5 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    ((n : ℝ) - 1) * ∑ j ∈ Finset.univ.erase i, (z x j) ^ 2
      = ((n : ℝ) - 1) * ((n : ℝ) - 1 - (z x i) ^ 2) := by
  sorry

/-- source/main.tex:82 "Hence n z_i² ≤ (n-1)²".  Uses S4, S5. -/
theorem P02_S6 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    (n : ℝ) * (z x i) ^ 2 ≤ ((n : ℝ) - 1) ^ 2 := by
  sorry

/-- source/main.tex:82 "that is, |z_i| ≤ (n-1)/√n".  Uses S6. -/
theorem P02_S7 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    |z x i| ≤ ((n : ℝ) - 1) / Real.sqrt (n : ℝ) := by
  sorry

/-- source/main.tex:82 "Multiplying by s gives the claim" (`|x_i - x̄| = |z_i| s`, needs `s ≠ 0`
and `s ≥ 0`).  Uses S7. -/
theorem P02_S8 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    |x i - sampleMean x| ≤ ((n : ℝ) - 1) / Real.sqrt (n : ℝ) * sampleStd x := by
  sorry

/-- source/main.tex:71-73 Proposition prop:samuelson (n ≥ 2, all i).  The source proof
only covers `s ≠ 0`; the case `s = 0` is untreated.  The plan is to assemble S1-S8. -/
theorem P02_main (n : ℕ) (hn : 2 ≤ n) (x : Sample n) : Conclusion x := by
  sorry

end Paper.P02
