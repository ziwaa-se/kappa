# L02 (Lemma 5.16, lem:xlower) — suspected issue 1: proof invokes (18), statement assumes only (17)

- Checker: pv-issue-checker (independent subagent, claude-opus-5-5). Started: Mon Oct 12 22:46:53 EDT 2026 (`date`).
- Reported by: pv-gate (`verification/audits/L02_gate.md`, `L02_gate_r2.md`), pv-prover (`pv_work/notes/L02_prover_notes.md` l.33-42).
- Status: complete; awaiting independent pv-auditor review (not confirmed).

## 1. Source quotations (read directly)

- Statement, `source/geo_erg_HMC_v3.1.tex:899-901`:
  "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any
  $\|p_0\| \leq \|x_0\|^\delta$ for some $\delta < 1$, it holds that $\|x_{L\e}\| \geq 2^L\|x_0\|$."
  Only (17) = eqn:explode (TEX:865-867) is assumed.
- Proof, TEX:930-933: "The second and last terms on the right hand side can be made arbitrarily small by choosing
  $\|x_0\|$ large enough.  Envoking (\ref{eqn:oscillations}) gives
  $\frac{\|\nabla U(x_0)\|}{2\|\nabla U(x_\e)\|} \leq \frac{1}{6}$".
- (18) = eqn:oscillations, TEX:868-871: "there is a fixed $C<\infty$ such that whenever $\|y\|\geq 2\|x\|\geq C$ then
  $\|\nabla U(y)\| \geq 3\|\nabla U(x)\|$". It is a hypothesis of Theorem 5.14 (thm:light, TEX:863-876) and of
  Lemma 5.17 (lem:arate_0, TEX:940), not of Lemma 5.16.
- TEX:934: "An entirely analogous argument can be used to show that $\|x_{i\e}\|\geq 2\|x_{(i-1)\e}\|$ for any fixed $i$,
  establishing the result."
- Context, TEX:879: "Lemmas \ref{lem:xelower} and \ref{lem:xlower} below establish that in this case
  $\|x_{L\e}\|\geq 2^L\|x_0\|$" ("this case" = the hypotheses (17),(18),(19) of Theorem 5.14).
- Contrast: Lemma 5.17 (TEX:940) explicitly lists "(17), (18) and (19)"; Lemma 5.16 deliberately lists only (17).
  No earlier convention in the source says that the lemmas of §5 inherit the hypotheses of Theorem 5.14.

## 2. Consumed instance

- Verdict-bearing gated statement: `Paper.L02.L02_main_fixedDelta`
  (`L02_L01Consumed gU eps → 0 < eps → HypExplode gU → ConclFixedDelta gU eps L`), fixed-δ reading, gate
  `L02_gate.md`/`L02_gate_r2.md` (th=397542044). Its ∀-closure is `L02_main_fixedDelta_Gap`
  (`pv_work/L02ModGaps.lean:616`, vh=397542044, identical).
- What the step at TEX:930-933 consumes: the bound `‖∇U(x_0)‖ / (2‖∇U(x_ε)‖) ≤ 1/6` for the single pair
  `(x_0, x_ε)` with `‖x_ε‖ ≥ 2‖x_0‖` (L01) and `‖x_0‖` large (S8b). For i ≥ 4 (TEX:934) the analogous step needs the
  middle terms `ε²‖∇U(x_j)‖/‖x_{(i-1)ε}‖`, j < i-1, bounded; the prover realised this with (18) on consecutive pairs
  (`gen`, `L02ModGaps.lean:495`).
- Auxiliary variant with (18) added: `L02_main_fixedDelta_osc` (`L02ModGaps.lean:607`), fully proved in the gap file
  (prover notes; final audit pending, not checked by me).

## 3. Is the printed statement true under (17) alone?  Yes (Lean, reviewer-constructed)

File: `pv_work/probes/issue/L02/issue_L02_positive.lean`.
**CONSTRUCTED BY THE REVIEWER, NOT IN THE SOURCE; classification evidence only, NOT used in any verification of L02.**

- `theorem Paper.L02.IssueCheck1.gap_holds : L02_main_fixedDelta_Gap` — i.e. the verdict-bearing statement holds with
  hypotheses (17) + the consumed L01 clause only, no (18).
- Argument: leapfrog second difference `x_{k+2} = 2x_{k+1} - x_k - ε²∇U(x_{k+1})` (unfolding `leapfrogStep`; same identity as
  the prover's `xLF_rec`), so `‖x_{k+2}‖ ≥ ε²‖∇U(x_{k+1})‖ - 2‖x_{k+1}‖ - ‖x_k‖`; (17) at `x_{k+1}` (whose norm is
  ≥ 2^{k+1}‖x_0‖ > R) gives `ε²‖∇U(x_{k+1})‖ ≥ 5‖x_{k+1}‖`; with `‖x_k‖ ≤ ‖x_{k+1}‖/2` this yields `‖x_{k+2}‖ ≥ 2.5‖x_{k+1}‖`.
  Induction on k with base L01. The same induction also gives the intermediate bounds `‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖`
  for every i ≤ L (statement `key`), under (17) alone.
- Compilation: `scripts/pv_lean.sh probe pv_work/probes/issue/L02/issue_L02_positive.lean` →
  `RESULT issue_L02_positive mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/issue_L02_positive_2.log`
  (first attempt `_1.log` exit=1, a `rw` pattern error, fixed).
- Axioms: `#print axioms` → `[propext, Classical.choice, Quot.sound]`; `#pv_walk_decl` → "AXIOMS in closure: [propext,
  Classical.choice, Quot.sound]; sorryAx reached: false" (log l.1-3).
- Scope check (`consumed_of_printed` role): the theorem's type is literally `L02_main_fixedDelta_Gap`; walk log l.18:
  `Paper.L02.L02_main_fixedDelta_Gap ... vh=397542044`, equal to the gated `L02_main_fixedDelta` th=397542044. Neither
  weaker nor stronger than the gated statement. No hypothesis beyond (17), `0 < ε`, the L01 clause.
- The specific inequality printed at TEX:932 also holds under (17)+L01 (prover's observation, confirmed by reasoning,
  not checked in Lean separately): by TEX:914 `ε²‖∇U(x_0)‖ ≤ 2‖x_ε‖ + 2‖x_0‖ + 2ε‖p_0‖ ≤ 4‖x_ε‖` for large ‖x_0‖, and by
  (17) at x_ε, `‖∇U(x_ε)‖ ≥ M‖x_ε‖` with M arbitrary, so the ratio tends to 0. The source does not say this.

## 4. Is the cited justification available under (17) alone?  No

(18) is not a consequence of (17). Example (reasoning, not checked in Lean): d = 1, `U(x) = ∫_0^x t³(2 + sin t) dt`
(C^∞), `∇U(x) = x³(2 + sin x)`. (17): `|∇U(x)|/|x| ≥ x² → ∞`. (18) fails for every C: take `x = π/2 + 2πk > max(C, 80)`
(so `∇U(x) = 3x³`) and the least `y ≥ 2x` with `sin y = -1` (so `y ≤ 2x + 2π`, `∇U(y) = y³ ≤ (2x+2π)³`);
then `3|∇U(x)| = 9x³ > (2x + 2π)³ ≥ |∇U(y)|` since `9^{1/3} ≈ 2.080` and `0.080·x > 2π` for x > 80, while
`|y| ≥ 2|x| ≥ C`. Hence "Envoking (18)" is an appeal to a hypothesis that Lemma 5.16 does not have and that (17) does
not supply.

## 5. Classification

**PAPER_ARGUMENT_GAP** (TEX:930-933, with the same dependency inherited by the "entirely analogous" step at TEX:934).
- The given justification (an appeal to (18)) is not available under the printed hypotheses of Lemma 5.16 (§4), and
  the source gives no other reason for the bound at TEX:932 → the printed justification fails.
- Not `ERROR`: the printed conclusion holds under the printed hypotheses (§3, Lean, EXIT 0, standard axioms).
- Not `PAPER_ASSUMPTION_GAP`: (18) is not needed for the statement (§3); adding it is one possible repair, not a
  missing necessary hypothesis.
- Not `EXPOSITION_GAP`: no range/case is uncovered; the problem is the reason given for a step.
- Not `FAIR_IMPLICIT_STEP`: the source explicitly cites (18), which is outside the lemma's hypotheses, and no stated
  convention makes the §5 lemmas inherit Theorem 5.14's hypotheses (Lemma 5.17 lists (18) explicitly; 5.16 does not).
  The context sentence TEX:879 ("in this case") makes the intended reading plausible, which is why the fix is minimal,
  but a reader cannot verify the lemma as printed from the printed proof without supplying a different argument.
- Not `ENCODING_ERROR`: `HypExplode`/`HypOscillations`/`xLF` encode TEX:865-871 and TEX:330-336 directly (gated); the
  dependency on (18) is visible in the source text itself.
- TEX:934 "entirely analogous" for i ≥ 4: in my judgement not a separate paper issue. Given (18), the prover closed it
  along the i = 3 pattern (`gen`: one-step identity, (18) on consecutive pairs, (17) at x_{(i-1)ε}); whether `gen` is a
  faithful extension is for the final audit. Under (17) alone it inherits the same (18) dependency recorded here.

## 6. Does it threaten the conclusion?

- Conclusion of L02 (printed statement): **no** — true under (17) alone (§3), and also proved along the printed route
  once (18) is available (`L02_main_fixedDelta_osc`, final audit pending).
- Verdict consequence for L02: the verdict-bearing `L02_main_fixedDelta` stops at the source's justification
  (TEX:930); the reviewer-constructed proof in §3 must NOT be used to mark it verified. Recorded issue:
  PAPER_ARGUMENT_GAP, non-threatening.

## 7. Downstream

- Affected: none in their conclusions.
- Unaffected:
  - L03 (Lemma 5.17, TEX:940) assumes (17),(18),(19), so its use of Lemma 5.16 is in a setting where the printed route
    is valid (`L02_main_fixedDelta_osc`); moreover the intermediate bounds `‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖` it uses
    (INVENTORY X5) hold under (17) alone (§3, `key`). X5's other point (L03 uses bounds that are only in L02's proof,
    not in its statement) is a separate matter, not ruled here.
  - T02 (Theorem 5.14) assumes (17),(18),(19): unaffected.
  - T01 (Theorem 2.2 (i) = T02) and C01: unaffected.
  - L01: not involved (its proof uses only (17)).

## 8. Suggestion to the authors (minimal)

- Option A (preferred, minimal): state Lemma 5.16 as "If (17) and (18) hold then ..." (TEX:900), matching TEX:879 and
  Lemma 5.17. Sufficiency: the printed route then goes through (`L02_main_fixedDelta_osc`, proved by the prover in
  `pv_work/L02ModGaps.lean:607`, build exit 0 per prover notes; final audit pending — I did not re-audit it).
- Option B: keep the statement and replace "Envoking (18)" by a bound from (17) and eqn:inter21 (TEX:913-915), e.g.
  `ε²‖∇U(x_0)‖ ≤ 4‖x_ε‖` (from TEX:914) and `‖∇U(x_ε)‖/‖x_ε‖ → ∞`. Constructed by the reviewer, not in the source,
  suggestion only, not used in any verification.

## 9. Not checked

- The (17)⇏(18) example in §4 (reasoning, not checked in Lean).
- The TEX:932 inequality under (17) alone as a separate Lean statement (only implied by §3 reasoning).
- Fidelity of the prover's `gen` / `L02_main_fixedDelta_osc` (final audit's job).
- The uniform-in-δ reading `L02_main` (not verdict-bearing); the §3 proof addresses only the fixed-δ reading.

## 10. Review status

Not confirmed: needs pv-auditor review — counterexample/positive-probe review mode for
`pv_work/probes/issue/L02/issue_L02_positive.lean`, reasoning review for §4 and §5. Human check: recommended only for
the classification boundary PAPER_ARGUMENT_GAP vs FAIR_IMPLICIT_STEP (context TEX:879).


ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no
