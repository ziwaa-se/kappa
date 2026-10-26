import L03Stmt
import L02

namespace Paper.L03

/-- S1. source/main.tex:90 "By Lemma lem:shortcut, `(n-1) s^2 = ∑ x_i^2 - n x̄^2`".
Role: first display of the proof. Uses Lemma 2.2 (`Paper.L02.L02_main`) and the
definition of `s^2` (main.tex:35); `n ≥ 2` so `n - 1 ≠ 0`. -/
theorem L03_S1 {n : ℕ} (hn : 2 ≤ n) (x : Sample n) :
    ((n : ℝ) - 1) * sampleVar x = ∑ i, (x i) ^ 2 - (n : ℝ) * (sampleMean x) ^ 2 := by
  sorry

/-- S2. source/main.tex:90 "`∑ x_i^2 - n x̄^2 ≤ ∑ x_i^2`" (since `n x̄^2 ≥ 0`).
Role: second half of the display. Independent of S1. -/
theorem L03_S2 {n : ℕ} (x : Sample n) :
    ∑ i, (x i) ^ 2 - (n : ℝ) * (sampleMean x) ^ 2 ≤ ∑ i, (x i) ^ 2 := by
  sorry

/-- S3. source/main.tex:91 "Dividing by `n` gives the claim." Stated exactly as the source
writes it: from `(n-1) s^2 ≤ ∑ x_i^2` conclude `s^2 ≤ (1/n) ∑ x_i^2`. NOTE: division by `n`
literally gives `(n-1)/n * s^2 ≤ (1/n) ∑ x_i^2`, not the claim; the obligation as
stated is likely FALSE (e.g. `n = 2`, `x = (1,-1)`: `s^2 = 2 > 1`). Not repaired.
Uses the conclusion of S1 and S2 (combined: `(n-1) s^2 ≤ ∑ x_i^2`). -/
theorem L03_S3 {n : ℕ} (hn : 2 ≤ n) (x : Sample n)
    (h : ((n : ℝ) - 1) * sampleVar x ≤ ∑ i, (x i) ^ 2) :
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 := by
  sorry

/-- Main statement, main.tex:85-87 (with `n ≥ 2`). Assembly: S1, S2 give the hypothesis of S3. -/
theorem L03_main {n : ℕ} (hn : 2 ≤ n) (x : Sample n) : Conclusion x := by
  sorry

end Paper.L03
