import Defs
import L01
import L03Stmt

/-!
L03 suspected issue 1 (pv-issue-checker): Lemma `lem:linear` (main.tex:65-67), proof main.tex:69-71.

Printed clause (main.tex:66): "For every `p ∈ I`, `V_n(p) ≤ p/(4n)`", `n ≥ 1` integer (main.tex:24),
`V_n(p) = p(1-p)/n` (main.tex:27).

Contents:
* `PrintedClauseOpen` / `PrintedClauseClosed`: main.tex:66 verbatim, `I` read as `(0,1)` / `[0,1]`.
* `counterexample_open`, `counterexample_closed`: witness `n = 1`, `p = 1/10`.
* `gated_statement_false`: the gated statement `∀ n, 1 ≤ n → ∀ p, L03Claim n p`
  (pv_work/L03Stmt.lean:16) is false; `gated_eq_printed` shows it is the printed open clause.
* `closed_implies_open`: scope lemma (closed clause is the stronger one).
* `step_fails_with_L01`: at the witness, the cited Lemma L01 (`L01_main`) holds in full, yet the
  step main.tex:70 `p(1-p)/n ≤ p/(4n)` fails: L01 cannot justify the step.
* `fails_every_n`: the witness `p = 1/10` refutes the clause for every `n ≥ 1`.
* `open_iff`: scope description, on `(0,1)` the inequality holds iff `3/4 ≤ p`
  (reviewer's computation, used only to describe the failure set, not to verify anything).
-/

namespace Paper.L03.Issue1

open Paper.DEFS

/-- main.tex:66 verbatim, `I = (0,1)`. -/
def PrintedClauseOpen : Prop :=
  ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, p ∈ IOpen → V n p ≤ p / (4 * (n : ℝ))

/-- main.tex:66 verbatim, `I = [0,1]`. -/
def PrintedClauseClosed : Prop :=
  ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, p ∈ IClosed → V n p ≤ p / (4 * (n : ℝ))

theorem tenth_mem_open : (1 / 10 : ℝ) ∈ IOpen := by
  unfold IOpen; constructor <;> norm_num

theorem tenth_mem_closed : (1 / 10 : ℝ) ∈ IClosed := by
  unfold IClosed; constructor <;> norm_num

/-- `V_1(1/10) = 9/100 > 1/40 = (1/10)/(4·1)`. -/
theorem witness_fails : ¬ (V 1 (1 / 10) ≤ (1 / 10 : ℝ) / (4 * ((1 : ℕ) : ℝ))) := by
  unfold V; norm_num

theorem counterexample_open : ¬ PrintedClauseOpen := fun h =>
  witness_fails (h 1 le_rfl (1 / 10) tenth_mem_open)

theorem counterexample_closed : ¬ PrintedClauseClosed := fun h =>
  witness_fails (h 1 le_rfl (1 / 10) tenth_mem_closed)

/-- The gated statement is exactly the printed open clause. -/
theorem gated_eq_printed :
    (∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, L03Claim n p) ↔ PrintedClauseOpen := Iff.rfl

theorem gated_statement_false : ¬ (∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, L03Claim n p) :=
  counterexample_open

/-- Scope: `IOpen ⊆ IClosed`, so the closed clause implies the open one. -/
theorem closed_implies_open : PrintedClauseClosed → PrintedClauseOpen := by
  intro h n hn p hp
  apply h n hn p
  unfold IOpen at hp; unfold IClosed
  exact ⟨le_of_lt hp.1, le_of_lt hp.2⟩

/-- The step main.tex:70: the cited Lemma L01 holds at the witness (both clauses, from the audited
`L01_main`), together with `p ∈ I`, yet `p(1-p)/n ≤ p/(4n)` fails. -/
theorem step_fails_with_L01 :
    Paper.L01.Conclusion 1 (1 / 10) ∧ (1 / 10 : ℝ) ∈ IOpen ∧
      ¬ ((1 / 10 : ℝ) * (1 - 1 / 10) / ((1 : ℕ) : ℝ) ≤ (1 / 10 : ℝ) / (4 * ((1 : ℕ) : ℝ))) := by
  refine ⟨Paper.L01.L01_main 1 le_rfl (1 / 10), tenth_mem_open, ?_⟩
  norm_num

/-- The witness `p = 1/10` refutes the clause for every `n ≥ 1`. -/
theorem fails_every_n (n : ℕ) (hn : 1 ≤ n) :
    ¬ (V n (1 / 10) ≤ (1 / 10 : ℝ) / (4 * (n : ℝ))) := by
  have hpos : (0 : ℝ) < n := by exact_mod_cast hn
  unfold V
  rw [div_le_div_iff₀ hpos (by positivity)]
  intro h
  nlinarith

/-- Scope description: on `(0,1)`, `V_n(p) ≤ p/(4n)` holds iff `3/4 ≤ p`. -/
theorem open_iff (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ IOpen) :
    V n p ≤ p / (4 * (n : ℝ)) ↔ 3 / 4 ≤ p := by
  have hpos : (0 : ℝ) < n := by exact_mod_cast hn
  unfold IOpen at hp
  obtain ⟨h0, h1⟩ := hp
  unfold V
  rw [div_le_div_iff₀ hpos (by positivity)]
  constructor
  · intro h
    by_contra hc
    push_neg at hc
    have : 0 < p * (3 / 4 - p) * n := by
      apply mul_pos (mul_pos h0 (by linarith)) hpos
    nlinarith
  · intro h
    have : 0 ≤ p * (p - 3 / 4) * n := by
      apply mul_nonneg (mul_nonneg h0.le (by linarith)) hpos.le
    nlinarith

end Paper.L03.Issue1
