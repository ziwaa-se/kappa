# A short note on three elementary inequalities: final report of the faithful LaTeX → Lean check

2026-09-30, summary by the coordinator; it has been submitted to an independent fact check, whose report is in `verification/report/work/factcheck.md`, and corrected accordingly (§8).

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on 1 external input (Nesbitt's inequality, cited from the literature) that has not been verified in Lean.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external input).

---

## 0. Summary table (English, for screenshots)

**3 numbered results: 1 verified unconditionally · 1 verified conditionally · 1 with recorded issues · 0 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions. A recorded issue below **is** a counterexample to the result's own printed statement (not merely a gap in the written argument), and it does not propagate to the other two results.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| Lemma 2.1 | AM-GM for two reals | Verified unconditionally | none |
| Proposition 2.2 | Nesbitt-type refinement | Verified conditionally | 1 condition: Nesbitt's inequality (cited, §3) |
| Lemma 2.3 | Quotient inequality | **Issue recorded (ERROR)** | B01 — false for `x < -1`; §4.1 |

## 1. Overall findings

1. **Yes, there is a counterexample to a main result**: Lemma 2.3's printed inequality `x²/(1+x) ≥ x-1` is false for every `x < -1` (witness `x = -2`: the claim reads `-4 ≥ -3`). This is the paper's own stated domain `x ≠ -1`, not a reading the proof forces on it. The recorded issue is classified `ERROR` (the printed conclusion itself is false on part of the printed domain), with a contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP` (the proof's "multiplying both sides by `1+x`" step silently needs `1+x>0`). This is not a complete list of every detail; see §4 for the full account.
2. **Results verified unconditionally**: Lemma 2.1 (AM-GM for two reals, PDF 2.1). Both its printed clauses — the inequality and the "equality iff `a=b`" biconditional — are fully proved in Lean along the source's own one-paragraph route, with no external parameters and no gaps.
3. **Results verified conditionally**: Proposition 2.2 (PDF 2.2). The proof is checked step by step along the source's own route (cite Nesbitt's inequality → apply Lemma 2.1 to three pairs and sum → divide by the positive sum of squares → chain the two bounds), but it carries one explicit condition: Nesbitt's inequality itself, which the source cites from the literature rather than proving. No debts recorded in words, no part of the statement left unencoded.
4. **Results with an issue recorded**: Lemma 2.3 (PDF 2.3), classified `ERROR` with Lean evidence (a machine-checked counterexample). No other recorded issue exists in this project.
5. **Downstream impact**: Lemma 2.3's error does **not** propagate — Proposition 2.2 depends only on Lemma 2.1 (never cites Lemma 2.3), and Lemma 2.1 is independent of both. The one substantive condition that remains open for the paper as a whole is Proposition 2.2's dependence on Nesbitt's inequality (§3).

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| Lemma 2.1 (`lem:amgm`) | **Verified unconditionally** | `ab ≤ (a²+b²)/2` for all reals `a,b`, with equality iff `a=b`; both clauses proved, no parameters, no gaps. Lean: `pv_work/L01.lean:71 Paper.L01.L01_main`. Gate: `verification/audits/L01_gate.md`. Final audit: `verification/audits/L01_final.md`. |
| Proposition 2.2 (`prop:nesbitt`) | **Verified conditionally** | `S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²))` for `x,y,z>0`, proved along the source's route using Lemma 2.1 (unconditional) and one cited external input, Nesbitt's inequality (§3). Lean: `pv_work/P01.lean:142 Paper.P01.P01_main`. Gate: `verification/audits/P01_gate.md`. Final audit: `verification/audits/P01_final.md`. |
| Lemma 2.3 (`lem:quot`) | **Issue recorded — ERROR** | Printed claim `x²/(1+x) ≥ x-1` for all `x ≠ -1` is false for every `x < -1` (witness `x=-2`). True, and provable along the source's own proof, for every `x > -1` (which covers the companion paper's stated use range `x ≥ 0`, per the Remark at `main.tex:83-85`). Does not affect Lemma 2.1 or Proposition 2.2. See `verification/BLOCKERS.md` B01, §4.1 below. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `Paper.P01.NesbittInequality` (`pv_work/P01Stmt.lean:39-41`) | (i) | P01, step S2 / main theorem | Confirm Nesbitt's inequality `S(x,y,z) ≥ 3/2` for `x,y,z>0` is indeed Theorem 1 of A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37, as cited at `main.tex:60`. (The parameter itself is not proved anywhere in the delivered Lean chain — it remains a visible hypothesis, which is why P01 is CONDITIONAL, not UNCONDITIONAL. One reviewer, the final auditor, separately proved it true as a side probe, `verification/audits/P01_final.md`, suggestion only; the citation's attribution/numbering is still unverified — see §5 Editorial.) | not yet |

Debts recorded in words: none. External assertions not encoded: none. Three candidate external inputs considered during drafting (positivity of `x²+y²+z²`; well-definedness of `S`; the "which is obvious" algebraic step in Lemma 2.3) were all resolved as ordinary step obligations rather than parameters — the first two (in Proposition 2.2) were proved outright; the third (in Lemma 2.3) was never discharged, because Lemma 2.3 stopped at a confirmed ISSUE before its step obligations were proved — see `verification/EXTERNAL_TOOLS.md` ("Candidates from the inventory, now settled") for the record.

## 4. Substantive issues for the authors (in PDF order)

### 4.1 Lemma 2.3 (`lem:quot`), PDF 2.3 — `ERROR` (contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP`)

- **Source**: statement `source/main.tex:71-76`; proof `source/main.tex:78-81`.
- **What fails**: the printed conclusion "$\frac{x^2}{1+x} \ge x-1$" is false for every `x < -1`, which the printed hypothesis `x ≠ -1` does not exclude. Witness `x = -2`: `x²/(1+x) = 4/(-1) = -4` and `x-1 = -3`, so the printed claim reads `-4 ≥ -3`, which is false. The proof's step "multiplying both sides by `1+x`" (`main.tex:79`) only preserves the inequality's direction when `1+x > 0`; the source gives no case split, and the hypothesis `x ≠ -1` does not secure this. The closing "obvious" algebraic fact `x² ≥ (x-1)(x+1) = x²-1` is itself true for all `x` — the problem is entirely the sign step, not the algebra.
- **Lean evidence**: `pv_work/L02_Counterexample1.lean` (builds clean, axiom-clean: only `propext`, `Classical.choice`, `Quot.sound`, no `sorryAx`). The refuted proposition is identical (by `rfl`) to the gate-reviewed statement of Lemma 2.3, so this is a genuine refutation of the paper's own printed claim, not an artifact of a stronger encoding. Independently confirmed by a second reviewer who re-derived the refutation from scratch. Reports: `verification/audits/L02_issue_1.md`, `verification/audits/L02_issue_1_audit.md`.
- **Scope not affected**: Lemma 2.1 (independent, no dependency) and Proposition 2.2 (depends only on Lemma 2.1, never cites Lemma 2.3). The claim **is** true, and provable along the source's own one-sentence proof with no other change, for every `x > -1` — this includes the `x ≥ 0` range that the paper's own (unlabeled) Remark at `main.tex:83-85` says a companion paper actually uses.
- **Recorded suggested fix** (from the audit records): restrict the printed domain at `main.tex:72` from "every real number `x ≠ -1`" to "every real number `x > -1`" (equivalently, `1+x>0`). Nothing else in the statement or proof needs to change. This is optimal — the claim fails at every `x < -1`, so no larger subset of `ℝ \ {-1}` would work — and it keeps the Remark's `x ≥ 0` usage range inside the fixed domain.

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | `source/main.tex:60` citation vs. `main.tex:87-90` bibliography | The in-text citation reads "Nesbitt's inequality [Theorem 1]", but the bibliography entry is "A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37" — a 19th-century problem-column item, which does not naturally carry a numbered "Theorem 1". This is a citation-precision matter, not a mathematical gap: the cited mathematical content (`S(x,y,z) ≥ 3/2` for positive reals) was separately proved true in Lean by the final auditor as a side probe (suggestion only, not part of the delivered proof — the parameter itself stays unproved in the delivered chain, which is why P01 is CONDITIONAL). Flagged at Priority B on the human-check worksheet (§3). |
| 2 | `source/main.tex:79-80` (Lemma 2.3 proof), optional wording only | Once the domain is restricted per §4.1, optionally add three words — "multiplying both sides by the **positive** number `1+x`" — to make the use of the (now-explicit) hypothesis visible to the reader. This is a suggestion only, additional to the domain fix, not a substitute for it. |

No Lean comment errata were found in any audited file (`verification/DOC_ERRATA.md` is empty).

## 6. Human-check list

**Literature and citations**: confirm the Nesbitt citation (§3, item 1; §5, item 1) — both its mathematical content (already proved true in Lean, for the record) and its attribution/numbering as "Theorem 1" of a problem-column item.

**Mathematical completion (parts supported by reasoning only)**: none — every substantive claim in this report (the Lemma 2.3 counterexample, the restricted-domain fix, Lemma 2.1, Proposition 2.2's proof route) is backed by a compiled, axiom-checked Lean proof, not reasoning alone.

**Author intent**: whether to restrict Lemma 2.3's domain to the optimal `x > -1`, or to the narrower `x ≥ 0` matching the Remark's stated companion-paper usage, is an editorial choice for the authors, not a correctness question (both are true and provable).

**Experiments and unnumbered assertions**: not applicable — this is a 2-page pure-mathematics note with no experimental section and no unnumbered claims (`verification/INVENTORY.md` §7 found none meeting the task's criteria). One unlabeled Remark (`main.tex:83-85`) describes a companion paper not included in `source/`; its claimed usage range (`x ≥ 0`) could not be verified beyond the sentence itself, since the companion paper is not available — if any actual use there falls in `x < -1`, that use would also be broken by B01.

**Notational ambiguities (recorded only; no numbered result's domain was actually affected)**: `verification/INVENTORY.md` §4 flags two points that never needed a ruling in practice — **N1**, `S(x,y,z)` is defined (`main.tex:26-33`) only "whenever the three denominators are nonzero," leaving its domain as a partial function on `ℝ³` implicit for general real triples (harmless here, since Proposition 2.2's domain `x,y,z∈\Rpos` makes the denominators automatically positive); and **N2**, `\Rpos` ("the positive real numbers," `main.tex:11,28`) is never explicitly stated to exclude `0` (the standard reading, and the one Proposition 2.2's division steps require, was adopted throughout). Neither affected any verdict.

## 7. Limits on the formalization side (not paper issues)

- One external parameter remains unverified in Lean (Nesbitt's inequality, §3), so full verification of the whole paper is not claimed.
- No technical formalization assumptions (TFA) were approved by any gate in this project — every candidate silently-used fact was instead classified as an ordinary step obligation. The two in Proposition 2.2 (positivity of `x²+y²+z²`; well-definedness of `S`) were proved outright. The one in Lemma 2.3 (the "obvious" algebraic step, `L02_S2`/`L02_S3`) was never discharged — it is still `sorry`, because Lemma 2.3's proof stopped at a confirmed ISSUE (the unrelated sign-of-`1+x` step, `L02_S1`) before reaching it; the "obvious" fact's truth is nonetheless independently confirmed inside `pv_work/L02_Counterexample1.lean`.
- No scope restrictions were needed: all three results are formalized over their full printed domains (Lemma 2.3's printed domain `x ≠ -1` is kept in full — it is the printed claim itself that is false on part of it, which is why it is recorded as a paper-side ISSUE rather than narrowed).
- No formalization-side corrections were needed in this project (no `ENCODING_ERROR`, no `TRANSLATION_BLOCKED`): the mathlib installation, though only partially built (2452/6305 modules, linked not copied), happened to contain every interface this project's proofs needed.
- Lean comment errata: `verification/DOC_ERRATA.md` (empty — none found).

## 8. Process disclosure

- Violations: none. No network access or downloads were used; `source/` was not modified; every proof follows the source's own route; no `sorry` remains in any delivered (non-draft) file; axioms are limited to `propext`, `Classical.choice`, `Quot.sound` throughout.
- Coordinator errors found and corrected during this run: (1) `PAPER_VERIFICATION.md`'s per-result detail cells had accumulated stale draft-stage text alongside the final verdict text, because the coordinator's own `--row` arguments to `pv_status.py record` included embedded `|` characters that corrupted the table's cell-splitting on re-edit; all three rows were rewritten with plain text and re-validated. (2) `verification/AUDIT.md` carried a duplicate back-to-back entry for the same L02 milestone, a byproduct of a first `record` call that failed validation (missing `--evidence-issues`) before a corrected second call succeeded; the incomplete duplicate was removed. (3) `RESULTS.json`'s `lean_main` pointer for L02 named the bare `Paper.L02` namespace rather than the actual `Paper.L02.Issue1` sub-namespace used by the counterexample file; corrected to `pv_work/L02_Counterexample1.lean:76 Paper.L02.Issue1.counterexample`. None of these three affected any recorded verdict, condition, or issue classification.
- Considered and left as-is (not a defect): `verification/report/work/consistency_check.md` flagged that `RESULTS.json`'s `models_used` for L01 and P01 lists only `["sonnet"]`, while their gate/final-audit reports self-identify as running on Opus. This field tracks which model(s) the **prover** used across its (up to two) sessions per `PIPELINE.md`'s "Prover sessions and models" rule — `pv-gate` and `pv-auditor` always run on Opus by fixed role definition (`CLAUDE.md`'s role table), so recording that constant fact per-result would be redundant, not corrective; `["sonnet"]` correctly means the prover needed only its first session, no escalation.
- The independent fact check of this report's first draft (`verification/report/work/AUTHOR_REPORT_v1.md`) found 14 problems (1 Major, 7 Moderate, 6 Minor), which have been corrected in this version. The Major finding was an overstated claim that Nesbitt's inequality had been "proved true in Lean by both the gate and the auditor" — in fact only the final auditor did so, as a side probe/suggestion, not part of the delivered proof chain; the parameter itself remains unproved (hence P01 stays CONDITIONAL). See `verification/report/work/factcheck.md` for the full list.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
