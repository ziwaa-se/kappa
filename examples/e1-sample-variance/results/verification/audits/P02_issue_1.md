# P02 issue 1 — ruling (pv-issue-checker)

Result: Proposition prop:samuelson (source/main.tex:71-83), ID P02.
Reported by: pv-drafter, pv-gate, pv-prover. Suspected issue: the proof divides by s (main.tex:76) and does not treat s = 0.

## 1. Source text (read directly)

- main.tex:72 (statement): "Suppose that $n \ge 2$. Then $|x_i - \bar x| \le \frac{n-1}{\sqrt{n}} \, s$ for every $i = 1, \dots, n$."
- main.tex:76 (proof, first sentence): "Let $z_j = (x_j - \bar x)/s$ for $j = 1, \dots, n$."
- main.tex:76-77: "by the definition of $s^2$, $\sum_{j=1}^n z_j^2 = n - 1$."
- main.tex:82: "Multiplying by $s$ gives the claim."
- Definitions used: main.tex:33-35 "$s^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar x)^2$" (n >= 2); main.tex:37 "$s = \sqrt{s^2} \ge 0$".
- Nowhere in main.tex:71-83 is s > 0 assumed or the case s = 0 mentioned. The statement (line 72) has no hypothesis excluding s = 0, so s = 0 (all x_i equal) is in scope.

## 2. Consumed instance

- The proof route (lines 76-82) uses z_j only when s > 0; at s = 0 the definition at line 76 is undefined (in Lean `z = 0` by x/0 = 0, and S2 "∑ z_j² = n-1" is then false; this is why S2, S5-S8 carry `hs : sampleStd x ≠ 0` in pv_work/P02ModGaps.lean). That hypothesis is a correct reading of the proof route, not an encoding defect.
- What is missing is exactly `P02_S0_Gap` (pv_work/P02ModGaps.lean:103-104): for n >= 2, every x with s = 0 satisfies the conclusion |x_i - x̄| <= (n-1)/√n · s for all i. `P02_main_mod_gaps` consumes nothing else (S1-S8 are gap-free per the prover notes).
- In this case the printed conclusion is 0 <= 0: the statement itself is true at s = 0, so no counterexample exists and no clause of the statement is false.

## 3. Classification: FAIR_IMPLICIT_STEP

Reasons:
- The uncovered case is the degenerate one of a normalisation argument ("divide by s"), and it closes in one line from the source's own definitions (main.tex:35, 37): s = 0 ⇒ s² = 0 ⇒ (since 1/(n-1) > 0 for n >= 2) ∑(x_i - x̄)² = 0 ⇒ every x_i = x̄ ⇒ LHS = 0 = RHS. No idea, tool, or hypothesis beyond the printed definitions is needed. Tacitly omitting the trivial s = 0 case when normalising by s is a standard convention a competent reader fills in routinely.
- Not ERROR: the printed conclusion holds at s = 0 (checked in Lean, §5).
- Not PAPER_ASSUMPTION_GAP: no hypothesis is missing; the statement is true without "s > 0".
- Not PAPER_ARGUMENT_GAP: the justification given (normalise, Cauchy-Schwarz, rescale) is valid on every instance where it is applied (s > 0, Lean S1-S8 compile); the only failure is a degenerate case left implicit, and for that case nothing in the given argument is wrong, it is merely not invoked.
- Not EXPOSITION_GAP (the nearest neighbour): EXPOSITION_GAP is for a range or case whose treatment cannot be supplied routinely ("why the constants cannot absorb it"). Here the case is absorbed trivially (both sides are 0) by the source's definitions. A strict human reader could still prefer to log it as a minor EXPOSITION_GAP; this is the one point flagged for human check (§8). Either way it does not threaten the conclusion.
- Not DOMAIN_CLARIFICATION: there is only one reading; line 72 has no restriction and s = 0 is plainly in scope.
- Not ENCODING_ERROR: the `hs` hypotheses in S2, S5-S8 reflect the source route faithfully; the Lean convention x/0 = 0 does not manufacture the gap (at s = 0 the source's z_j is undefined anyway).

## 4. Does it threaten the conclusion?

- Final conclusion of P02: no. It holds at s = 0 (both sides 0) and, by S1-S8, at s ≠ 0.
- Downstream results: none affected. Per main.tex, no later result (lem:raw line 85-92, cor:unit line 94-100) cites prop:samuelson. Unaffected: L01 (lem:centred), lem:shortcut, prop:popoviciu, lem:raw, cor:unit.

## 5. Evidence (Lean, positive)

- File: pv_work/probes/issue/P02/issue_P02_s0fill.lean (imports P02Stmt, PVTools only; does not touch the reviewed P02 files).
- `Paper.P02.Issue1.S0Case` is literally the statement of `P02_S0_Gap`; `s0_case : S0Case` proves it using only the definitions sampleVar/sampleStd (main.tex:35, 37); `s0_case_is_gap_statement` confirms by `rfl` it is the same proposition `P02_main_mod_gaps` takes as `hGap_0`.
- Compile: `scripts/pv_lean.sh probe pv_work/probes/issue/P02/issue_P02_s0fill.lean` → RESULT exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0, log pv_work/logs/issue_P02_s0fill_2.log (EXIT=0). (Run 1, log _1, failed only because `#pv_axioms` takes a module name, not a declaration; replaced by `#pv_walk_decl`.)
- Axiom check: `#pv_walk_decl Paper.P02.Issue1.s0_case` → "AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false"; `#print axioms` agrees.

## 6. Exact fill-in for the prover (FAIR_IMPLICIT_STEP)

Close the `sampleStd x = 0` branch of the main theorem (equivalently discharge `P02_S0_Gap`) as follows, each step citing the source:
1. main.tex:35 with n >= 2: sampleVar x >= 0 (1/(n-1) > 0 times a sum of squares).
2. main.tex:37: sampleStd x = √(sampleVar x); with step 1, `Real.sq_sqrt` gives sampleStd² = sampleVar, so s = 0 ⇒ sampleVar x = 0.
3. main.tex:35: sampleVar x = (1/(n-1)) · ∑(x_j - x̄)² = 0 and 1/(n-1) ≠ 0 ⇒ ∑_j (x_j - x̄)² = 0 (`mul_eq_zero`).
4. `Finset.sum_eq_zero_iff_of_nonneg` (terms are squares) ⇒ (x_i - x̄)² = 0 ⇒ x_i - x̄ = 0 (`pow_eq_zero_iff`).
5. Rewrite the goal: |0| <= (n-1)/√n · 0, i.e. 0 <= 0 (`abs_zero`, `mul_zero`).
The probe proof `s0_case` follows exactly these five steps and may be used as the template. The proof must stay a case split (`by_cases hs : sampleStd x = 0`), as in `P02_main_mod_gaps`; the s ≠ 0 branch remains S8.

## 7. Suggestion to the authors (minimal)

Add one sentence before line 76: "If s = 0 then all x_i equal \bar x and both sides vanish; so assume s > 0." (Editorial; the result is correct as printed.)

## 8. Not checked / human check

- Human check suggested only on the label: FAIR_IMPLICIT_STEP (this ruling) vs a minor EXPOSITION_GAP. Mathematical content is fully checked in Lean.
- Not re-checked here: S1-S8 themselves (the prover's file; to be covered by pv-auditor's final audit).
- No paper issue is claimed, so no counterexample or reasoning review is required. Once the prover closes the s = 0 branch per §6, pv-auditor's final audit of P02 covers it.

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no
