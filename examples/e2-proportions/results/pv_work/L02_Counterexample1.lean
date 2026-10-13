import Defs
import L02

/-!
L02 suspected issue 1 (pv-issue-checker): reading of the unit interval `I`
(main.tex:24, open/closed not stated) in Lemma `lem:positive` (main.tex:47-49,
proof main.tex:51-53).

Contents:
* `PrintedClauseClosed`: main.tex:48 verbatim under the CLOSED reading `IClosed`;
  refuted at `n = 1`, `p = 0` (`counterexample`) and at `p = 1` (`counterexample_one`).
* `ProofSentenceClosed`: main.tex:52 "for p ∈ I both p and 1-p are positive" under the
  closed reading; refuted at `p = 0`. Shows the source's own proof sentence pins `I ⊆ (0,1)`.
* `PrintedClauseOpen`: main.tex:48 under the OPEN reading `IOpen`; proved from the
  audited `L02_main` (no new argument).
* `closed_implies_open` (consumed_of_printed-style scope lemma): the closed clause implies
  the open one, so the refutation hits only the closed reading.
* `closed_fails_exactly_at_endpoints`: on `IClosed`, positivity holds iff `p ∈ IOpen`.
-/

namespace Paper.L02.Issue1

open Paper.DEFS

/-- main.tex:48, "For every `p ∈ I`, `V_n(p) > 0`", with `n ≥ 1` an integer (main.tex:24),
encoded verbatim with `I` read as the CLOSED unit interval `[0,1]` (`IClosed`). -/
def PrintedClauseClosed : Prop :=
  ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, p ∈ IClosed → 0 < V n p

/-- The same clause with `I` read as the OPEN unit interval `(0,1)` (`IOpen`). -/
def PrintedClauseOpen : Prop :=
  ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, p ∈ IOpen → 0 < V n p

/-- main.tex:52, "For `p ∈ I` both `p` and `1 - p` are positive", closed reading. -/
def ProofSentenceClosed : Prop :=
  ∀ p : ℝ, p ∈ IClosed → 0 < p ∧ 0 < 1 - p

/-- Instance `p = 0` satisfies the printed hypothesis `p ∈ I` under the closed reading. -/
theorem zero_mem_closed : (0 : ℝ) ∈ IClosed := by
  unfold IClosed
  exact ⟨le_refl 0, zero_le_one⟩

theorem one_mem_closed : (1 : ℝ) ∈ IClosed := by
  unfold IClosed
  exact ⟨zero_le_one, le_refl 1⟩

theorem V_zero (n : ℕ) : V n 0 = 0 := by
  unfold V
  simp

theorem V_one (n : ℕ) : V n 1 = 0 := by
  unfold V
  simp

/-- Counterexample: `n = 1` (satisfies `n ≥ 1`), `p = 0 ∈ [0,1]`, `V_1(0) = 0`, not `> 0`. -/
theorem counterexample : ¬ PrintedClauseClosed := by
  intro h
  have := h 1 (le_refl 1) 0 zero_mem_closed
  rw [V_zero] at this
  exact lt_irrefl 0 this

/-- Second witness at the other endpoint: `n = 1`, `p = 1`. -/
theorem counterexample_one : ¬ PrintedClauseClosed := by
  intro h
  have := h 1 (le_refl 1) 1 one_mem_closed
  rw [V_one] at this
  exact lt_irrefl 0 this

/-- The proof sentence main.tex:52 is itself false under the closed reading (`p = 0`). -/
theorem proof_sentence_closed_false : ¬ ProofSentenceClosed := by
  intro h
  have := (h 0 zero_mem_closed).1
  exact lt_irrefl 0 this

/-- Scope lemma: `IOpen ⊆ IClosed`, so the closed clause is the stronger one; refuting it
says nothing against the open clause. -/
theorem closed_implies_open : PrintedClauseClosed → PrintedClauseOpen := by
  intro h n hn p hp
  apply h n hn p
  unfold IOpen at hp
  unfold IClosed
  exact ⟨le_of_lt hp.1, le_of_lt hp.2⟩

/-- Open reading holds: it is exactly the audited `L02_main`. -/
theorem open_holds : PrintedClauseOpen := by
  intro n hn p hp
  exact Paper.L02.L02_main n hn p hp

/-- Under the closed reading, the conclusion fails exactly at the endpoints `{0,1}`. -/
theorem closed_fails_exactly_at_endpoints (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ IClosed) :
    0 < V n p ↔ p ∈ IOpen := by
  constructor
  · intro hV
    unfold IClosed at hp
    obtain ⟨h0, h1⟩ := hp
    unfold IOpen
    refine ⟨lt_of_le_of_ne h0 ?_, lt_of_le_of_ne h1 ?_⟩
    · intro e
      rw [← e, V_zero] at hV
      exact lt_irrefl 0 hV
    · intro e
      rw [e, V_one] at hV
      exact lt_irrefl 0 hV
  · intro h
    exact Paper.L02.L02_main n hn p h

end Paper.L02.Issue1
