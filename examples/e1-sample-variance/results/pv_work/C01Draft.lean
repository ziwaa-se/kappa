import C01Stmt

namespace Paper.C01

/-- S1. source/main.tex:99 "By Lemma lem:raw, `s^2 ≤ (1/n) ∑ x_i^2`".
Role: first link of the chain. Uses the consumed clause `C01_L03Consumed` (L03, printed
Lemma 2.5, main.tex:85-86) with `n ≥ 2` from the corollary's hypothesis (main.tex:95). -/
theorem C01_S1 (hL : C01_L03Consumed) {n : ℕ} (hn : 2 ≤ n) (x : Sample n) :
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 := by
  sorry

/-- S2. source/main.tex:99 "`(1/n) ∑ x_i^2 ≤ 1`".
Role: second link; uses `|x_i| ≤ 1` (main.tex:95), hence `x_i^2 ≤ 1`, and `n ≥ 2` (so `n > 0`).
The source gives no further justification (implicit step). Independent of S1. -/
theorem C01_S2 {n : ℕ} (hn : 2 ≤ n) (x : Sample n) (hx : ∀ i, |x i| ≤ 1) :
    (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 ≤ 1 := by
  sorry

/-- S3. source/main.tex:99 "`1 ≤ 2`". Last link. -/
theorem C01_S3 : (1 : ℝ) ≤ 2 := by
  sorry

/-- Main statement, main.tex:94-96. Assembly: S1, S2, S3 chained. -/
theorem C01_main (hL : C01_L03Consumed) {n : ℕ} (hn : 2 ≤ n) (x : Sample n)
    (hx : ∀ i, |x i| ≤ 1) : Conclusion x := by
  sorry

end Paper.C01
