# A short note on three elementary inequalities: final report of the faithful LaTeX → Lean check

2026-09-30, summary by the coordinator; it has passed an independent fact check, whose report is in `verification/report/work/factcheck.md`, and whose Major and Moderate findings against the first draft are corrected throughout (see §8).

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on 1 external input (Nesbitt's inequality) that has not been verified in Lean.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).

---

## 0. Summary table (English, for screenshots)

**3 numbered results: 2 verified unconditionally · 1 verified conditionally · 0 with recorded issues · 0 unfinished.**

"Verified conditionally" means that the paper's own proof was checked step by step in Lean, but the proof relies on one cited or unproved input that this project did not itself prove. That input is written as an explicit Lean hypothesis of the main theorem, never as a hidden assumption. No exceptions are recorded in words beyond that one input. No recorded issue exists in the current text (one existed in the project's history and was resolved by a source revision; see §0b).

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.1 | Lemma (AM-GM for two reals, `lem:amgm`) | Verified unconditionally | None. |
| 2.2 | Proposition (Nesbitt-type refinement, `prop:nesbitt`) | Verified conditionally | 1 condition: `P01_NesbittInequality` (Nesbitt's inequality, cited as `\cite[Theorem~1]{Nesbitt1903}`, used at the proof's first step). |
| 2.3 | Lemma (quotient inequality, `lem:quot`) | Verified unconditionally | None (see §0b: this lemma was revised after an issue was found in the original text). |

Of the results verified conditionally, 1 (Proposition 2.2) has its one condition checked by a person (Test Reader (benchmark), 2026-09-30 20:56, against Nesbitt, *Problem 15114*, *Educational Times* 55 (1903), and the standard rearrangement-inequality proof). It remains **conditional**, because the condition is not checked in Lean — a human literature check is a different kind of evidence from a Lean kernel proof, and does not by itself upgrade the verdict (`VERDICTS.md` §1.2).

## 0b. What the revision changed

The source manuscript was revised once (revision 1, 2026-09-30 20:38). From `python3 scripts/pv_status.py followup`:

| PDF no. | ID | Before (revision) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|---|
| 2.3 | L02 | Recorded issue | Verified unconditionally | B01 | B01: resolved |

Details:

- **What was wrong.** The original text of Lemma 2.3 stated "For every real number $x \neq -1$ we have $\frac{x^2}{1+x} \ge x - 1$." This is false for every $x < -1$ (e.g. $x = -2$ gives $-4 \ge -3$, false): the proof's step "multiplying both sides by $1+x$" silently needs $1+x>0$, which $x \neq -1$ does not guarantee. This was recorded as issue **B01** (classification: paper-side `ERROR`, with a contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP` for the proof's missing sign case-split), confirmed by a machine-checked Lean counterexample at $x=-2$ and independently re-confirmed by a second reviewer.
- **What changed.** Revision 1 narrowed the domain to "For every real number $x > -1$" (the recorded minimal fix — the issue ruling states nothing else needs to change) and, in its own words, added the justifying clause "Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality…" before performing the step — the ruling had offered this as an optional, not required, improvement to make the use of the hypothesis visible.
- **Re-verification.** The revised Lemma 2.3 was independently re-gated, re-proved and re-audited from scratch. The final audit confirms the revision removes exactly the $x<-1$ region that made the old text false, that the sign fact is now printed and discharged (not silently assumed), and that the lemma is **UNCONDITIONAL** as now printed, with no external input and no gap.
- **Downstream impact.** Neither Lemma 2.1 nor Proposition 2.2 was affected at any point: Lemma 2.1 is independent, and Proposition 2.2 depends only on Lemma 2.1 and the cited Nesbitt inequality, never on Lemma 2.3. Their verdicts and records are unchanged by the revision.
- B01's heading in `verification/BLOCKERS.md` is marked `RESOLVED`; the pre-revision `ISSUE` verdict is preserved as history in `verification/RESULTS.json` (`results[2].history[0]`), not deleted.

## 1. Overall findings

1. **No counterexample stands against any current result.** One counterexample was found and confirmed against the *original* text of Lemma 2.3 (B01, above); it no longer applies to the current, revised text, which is verified true. No other recorded issue exists anywhere in the project (0 open issues).
2. **Results verified unconditionally (2 of 3):** Lemma 2.1 (AM-GM for two reals, PDF 2.1) and Lemma 2.3 (quotient inequality, PDF 2.3, as revised). Both are fully machine-checked along the paper's own proof route, with no external input, no gap, and only the three standard Lean axioms (`propext`, `Classical.choice`, `Quot.sound`).
3. **Results verified conditionally (1 of 3):** Proposition 2.2 (Nesbitt-type refinement, PDF 2.2). The arithmetic chain of its own proof (summing Lemma 2.1 over three pairs, dividing by $x^2+y^2+z^2>0$) is fully unconditional; the only condition is the first proof sentence's appeal to the cited Nesbitt inequality. No debt is recorded in words and no part of the statement is left unencoded.
4. **Results with an issue recorded: none in the current text.** The one issue found during this project's work (B01, against the pre-revision text of Lemma 2.3) has Lean evidence (a machine-checked counterexample) and is now resolved by a source revision; see §0b and §4.
5. **Downstream impact.** The resolved issue (B01) never propagated: no other result depended on the affected clause. The one substantive condition that remains open for a human (Proposition 2.2's citation of Nesbitt's inequality) is a genuine mathematical dependency on literature this project does not reprove, not a formalization artifact.

## 2. Verdict for each result

| PDF | Verdict | Key points | Evidence |
|---|---|---|---|
| 2.1 Lemma (AM-GM, `lem:amgm`) | **Verified unconditionally** | $ab \le \frac{a^2+b^2}{2}$ for all real $a,b$, with equality iff $a=b$ — both clauses proved, along the printed square-completion argument. No external input, no gap. Main theorem: `pv_work/L01.lean:71 Paper.L01.L01_main`. | `verification/audits/L01_gate.md`, `L01_final.md`, `L01_mech.md` |
| 2.2 Proposition (Nesbitt-type refinement, `prop:nesbitt`) | **Verified conditionally** | $S(x,y,z) \ge \frac{3(xy+yz+zx)}{2(x^2+y^2+z^2)}$ for $x,y,z>0$ — proved exactly along the printed route (cited Nesbitt bound, then Lemma 2.1 summed over the three pairs, then division by $x^2+y^2+z^2>0$). One condition: `P01_NesbittInequality`, used only at the first proof sentence. Main theorem: `pv_work/P01.lean:142 Paper.P01.P01_main`. | `verification/audits/P01_gate.md`, `P01_final.md`, `P01_mech.md` |
| 2.3 Lemma (quotient inequality, `lem:quot`) | **Verified unconditionally** | $\frac{x^2}{1+x} \ge x-1$ for every real $x > -1$ — proved along the printed route (sign fact $1+x>0$, clearing the denominator, $(x-1)(x+1)=x^2-1$, $x^2 \ge x^2-1$). As printed after revision 1; see §0b for the pre-revision issue (B01, resolved). No external input, no gap. Main theorem: `pv_work/L02.lean:92 Paper.L02.L02_main`. | `verification/audits/L02_gate.md`, `L02_final.md`, `L02_mech.md` |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; none exist in this project.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `Paper.P01.NesbittInequality` (`pv_work/P01Stmt.lean:39-41`) | (i) | Proposition 2.2, step S2 (`main.tex:60`) | Confirm that $S(x,y,z) \ge 3/2$ for all $x,y,z>0$ is indeed "Theorem 1" of A. M. Nesbitt, *Problem 15114*, *Educational Times* 55 (1903), 37, as cited — a 19th-century problem-column item whose attribution/numbering is worth a second look. | Test Reader (benchmark), 2026-09-30 20:56, against Nesbitt, *Problem 15114*, *Educational Times* 55 (1903), and the standard proof by the rearrangement inequality. **Still conditional** (see §0, this is a human check, not a Lean proof). |

Debts recorded in words: none. External assertions not encoded: none. (Four further candidates were considered during drafting, per `verification/INVENTORY.md` §6: $x^2+y^2+z^2>0$ and the well-definedness of $S(x,y,z)$ on positive reals became ordinary step obligations of Proposition 2.2 (`P01_S4`, `P01_S1`), since they are immediate consequences of positivity; the "which is obvious" algebra of Lemma 2.3 (`main.tex:80`) became step obligations `L02_S2`/`L02_S3`; and the sign of $1+x$ needed for Lemma 2.3's multiply-through step turned out not to be an external input at all but the paper-side error B01 — see §4.1 — now resolved by revision 1 and discharged as step obligation `L02_S1`.)

## 4. Substantive issues for the authors (in PDF order)

### 4.1 — B01 — Lemma 2.3 (PDF 2.3) — **RESOLVED by source revision 1**

- **Classification**: paper side, primary `ERROR` (the printed conclusion was false on part of the printed domain); secondary, contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP` (the proof's multiply-through step silently needed $1+x>0$, which was not printed).
- **Source location (pre-revision text)**: statement `source/main.tex:71-76` ("For every real number $x \neq -1$ we have $\frac{x^2}{1+x} \ge x - 1$."); proof `source/main.tex:78-81` ("Multiplying both sides by $1+x$, the claim is equivalent to $x^2 \ge (x-1)(x+1) = x^2-1$, which is obvious.").
- **What failed**: the printed inequality is false for every real $x < -1$ — e.g. $x=-2$ gives $x^2/(1+x) = -4$ and $x-1=-3$, so the printed claim reads $-4 \ge -3$, false. The break is exactly the unstated step "multiplying both sides by $1+x$", which reverses direction when $1+x<0$ (i.e. $x<-1$), a region the printed hypothesis $x \neq -1$ did not exclude.
- **Lean evidence**: `pv_work/L02_Counterexample1.lean` (builds, axiom-clean, witness $x=-2$); ruling `verification/audits/L02_issue_1.md` (ISSUE VERDICT: ERROR), independently confirmed in `verification/audits/L02_issue_1_audit.md` (COUNTEREXAMPLE VALID).
- **Scope not affected**: Lemma 2.1 (no dependency) and Proposition 2.2 (depends only on Lemma 2.1 and the cited Nesbitt inequality, never on Lemma 2.3). The statement was always true for $x > -1$ (which includes the companion paper's stated use range $x \ge 0$ per the unlabeled Remark at `main.tex:83-85`).
- **Recorded suggested fix** (source: `verification/audits/L02_issue_1.md` §6): restrict the domain to $x > -1$ (equivalently, $1+x>0$); nothing else in the proof needs to change. An alternative restriction to $x \ge 0$ was noted as also sufficient but "discards true content", left as an editorial choice.
- **Resolution**: the authors' revision 1 adopted the recorded minimal fix (the domain change) and, in its own words, the ruling's optional suggestion to make the sign hypothesis visible in the proof — the statement now reads "For every real number $x > -1$" and the proof states "Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality…" before performing the step. Re-verified end to end (fresh gate → fresh proof → independent final audit, `verification/audits/L02_final.md`, FINAL AUDIT: PASS, SUGGESTED VERDICT: UNCONDITIONAL).
- **Needs human check**: none beyond the recorded Lean evidence — a reasoning + Lean-confirmed paper error, not a literature question.

No other substantive issue is recorded for any result in this project.

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | `source/main.tex:60` (citation) vs. `source/main.tex:87-89` (bibliography) | `\cite[Theorem~1]{Nesbitt1903}` cites "Theorem 1", but the bibliography entry is "A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37" — a problem-column item, which does not naturally carry a numbered "Theorem 1". Citation-precision only, not a mathematical gap; classified `EDITORIAL`, independently agreed by both the statement gate and the final audit of Proposition 2.2. Does not affect the verdict. This is the same item listed as the human-check point for `P01_NesbittInequality` in §3/§6 — listed here separately because it is a textual/citation matter distinct from the mathematical content check. |

## 6. Human-check list

**Literature and citations**: confirm Nesbitt's inequality $S(x,y,z) \ge 3/2$ for $x,y,z>0$ is indeed "Theorem 1" of A. M. Nesbitt, *Problem 15114*, *Educational Times* 55 (1903), 37, as cited at `main.tex:60` (Priority B: type (i), doubtful attribution/numbering of a 19th-century problem-column item). `NesbittInequality` is **not** proved inside the verification chain and remains an explicit Lean hypothesis of `P01_main`, so Proposition 2.2 stays CONDITIONAL. A reviewer's side probe (`verification/audits/P01_final.md` §6, suggestion only, not part of the audited proof) found the mathematical content true, so the human check is primarily about the citation's attribution/numbering — but it remains mandatory, because no proof of it is connected to the paper's chain. **Status: already checked** by a person (Test Reader (benchmark), 2026-09-30 20:56); Proposition 2.2 remains CONDITIONAL regardless, per §0/§3.

**Mathematical completion (parts supported by reasoning only)**: none. Every step obligation of all three results is proved in Lean inside the audited modules (`pv_work/L01.lean`, `P01.lean`, `L02.lean`); each statement was approved in advance by an independent gate (which also re-proved obligations in its own probes: all six for Proposition 2.2, S1–S4 for Lemma 2.3, S3 and S4 for Lemma 2.1), and each finished module was re-compiled, fingerprint-checked and walked for axioms/`sorry` by an independent final audit. No result rests on reasoning alone.

**Author intent**: a closed-history item only — the pre-revision audit of Lemma 2.3 could not verify the companion paper's actual usage range (the Remark at `main.tex:83-85` claims $x \ge 0$; the companion paper is not in `source/`) and flagged the choice between restricting to $x>-1$ vs. $x\ge0$ as editorial. **Now moot**: revision 1 adopted $x>-1$, the full true region (a superset of $x\ge0$), independently verified; no companion-paper check is needed under the current text.

**Experiments and unnumbered assertions**: none recorded; `verification/PAPER_VERIFICATION.md` lists no unnumbered assertions requiring separate evidence.

**Notation (recorded only; no verdict depends on it)**: the note never states a domain convention for $S(x,y,z)$ beyond "whenever the three denominators are nonzero" (`main.tex:33`), and never spells out $0 \notin \Rpos$ (`main.tex:11,28`). The standard readings were adopted and neither bites (Proposition 2.2's printed domain makes all three denominators positive); the authors may wish to state both explicitly (recorded as N1/N2 in `verification/INVENTORY.md` §"Notational ambiguities").

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified (the one Nesbitt-inequality condition on Proposition 2.2), so full verification of the whole paper is not claimed. Mathlib was never searched for Nesbitt's inequality: the gate's own attempt was blocked by the permission system, so no claim is made that mathlib lacks it. The gate noted, non-bindingly, that a cheap mathlib interface would make Proposition 2.2 UNCONDITIONAL — not attempted in this run.
- Technical formalization assumptions (TFA) approved by the gate: none were proposed or needed for any of the three results (each gate's TFA table is empty — the Lean hypotheses are exactly the printed domains, no technical premise was added).
- Scope restrictions: none beyond the printed domains of each result.
- Corrections on the formalization side: none — no gate or audit found an encoding error or a translation-blocked step in any result; the one correction made during this project (Lemma 2.3) was a correction to the *source*, not to the formalization, following the authors' own revision.
- Lean comment errata: `verification/DOC_ERRATA.md` has no entries — no audit of any of the three results found an outdated or inaccurate Lean comment.

## 8. Process disclosure

- Violations: none recorded during this project — no self-review, no undisclosed network/download use, no modification of `source/` (the one change to `source/` was the authors' own revision 1, correctly attributed in §0b).
- Coordinator errors found and corrected by subagents: an earlier pass of this report (prior to the revision) was compiled on 2026-09-30, and the pre-revision `/pv-report` run's own fact-check found and corrected 14 problems (1 Major, 7 Moderate, 6 Minor) in that earlier draft, all before this current, post-revision draft was written. During this round's compilation, the independent compiler flagged six items: (1) the three top-level report files (this report, the worksheet, the files-to-check index) were stale, still describing Lemma 2.3 as an open issue after the revision resolved it — addressed by writing this fresh round; (2) `verification/EXTERNAL_TOOLS.md`'s "settled candidates" table still carried the same stale wording — the coordinator verified this directly against `verification/BLOCKERS.md` and `verification/RESULTS.json` and corrected it; (3) `verification/report/work/` still held a pre-revision mirror set (an earlier `AUTHOR_REPORT_v1.md` and `factcheck.md`) which should not be relied on, now superseded by this round's own outputs in that same directory; (4) a stale bookkeeping field (`RESULTS.json`'s `run_scope`, left pointing at the revision's reset scope) was cleared; (5) `verification/AUDIT.md` records a kit upgrade at 2026-09-30 20:57, after all three verdicts were recorded, with the version string "1.3 -> 1.3" — worth a human look before treating `kit_backup/20260930-205723/` as a meaningful rollback point; no verdict is affected; (6) `verification/audits/L02_mech.md` ends with the bare line "MECH CHECKS: FAIL (probe)" — the independent final audit adjudicates this in its own §1/§10 as a script artifact on a declaration-free `L02Stmt.lean` module (0 declarations, matching the gate's own snapshot), not a defect of the audited work, so it is not counted as an issue. The coordinator also fixed a stale `pv_work/L02.lean` line number (`:69` → the correct `:92`) in `RESULTS.json` and `AUDIT.md`, caught by the independent fact-check below.
- An independent fact-check of this report's first draft found 1 Major, 5 Moderate and 8 Minor problems (`verification/report/work/factcheck.md`), which have been corrected: the Major item was an over-attribution (claiming the final audits re-proved every step obligation, when in fact the prover proved them and the final audits re-compiled/fingerprint-checked/walked-for-axioms without re-deriving); the Moderate items concerned an over-absolute claim about Nesbitt's inequality never being proved anywhere in Lean (a reviewer side-probe did prove it, as a suggestion only, not part of the audited chain), this section's own premature "has passed" wording and placeholder, an undercount of the external-input candidates considered during drafting (two were named where four exist), the omission of two recorded notational ambiguities (now added to §6), and an incomplete account of the compiler's six findings in this section. Minor items (a wrong Lean line number, a reordered binder list, imprecise wording about `gaps`/`DOC_ERRATA`, missing mathlib-search and mechanical-audit citations, and an imprecise "exactly the minimal fix" characterization) are corrected throughout.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
