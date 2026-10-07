# Two quick inequalities: final report of the faithful LaTeX → Lean check

2026-10-01, summary by the coordinator. An independent fact check of the first draft (saved as `verification/report/work/AUTHOR_REPORT_v1.md`) found 1 Major, 3 Moderate and 5 Minor problems (full report: `verification/report/work/factcheck.md`); all Major and Moderate items, and all Minor items, have been corrected in this version.

- **This report is not a claim that the whole paper is fully verified.** Of the 2 numbered results, 1 is verified unconditionally and 1 carries a recorded issue (a confirmed counterexample to the printed statement). There are 0 external inputs in this paper, so "fully verified" is not blocked by any unverified parameter — it is blocked by the recorded issue in Lemma 2.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (there is nothing to check in it — see §3).

---

## 0. Summary table (English, for screenshots)

**2 numbered results: 1 verified unconditionally · 0 verified conditionally · 1 with recorded issues · 0 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain, written as explicit Lean parameters, never hidden assumptions. Neither applies here: L01 is unconditional (no parameters at all) and L02's recorded issue is a genuine counterexample to the printed main result (Lemma 2 itself), not merely a gap in its proof.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| Lemma 1 | `a^2+b^2 \ge 2ab` for all real `a,b` | **Verified unconditionally** | None. |
| Lemma 2 | `x^2 \ge x` for every real `x` | **Issue recorded (ERROR)** | B1: false for `0<x<1` (witness x = 0.5); confirmed by an independently reviewed Lean counterexample. |

## 1. Overall findings

1. **There is a counterexample to a main result.** Lemma 2, as printed, is false: `x = 1/2` satisfies the lemma's sole hypothesis ("for every real number `x`") but gives `x^2 = 1/4 < 1/2 = x`. This is classified `ERROR` (the printed conclusion itself is false, not merely an unjustified step) — see §4 for the full record; this is the paper's only recorded issue.
2. **Results verified unconditionally**: Lemma 1 (1 of 2). Its two-step proof (the ring identity `a^2+b^2-2ab=(a-b)^2`, then `(a-b)^2 \ge 0`) is fully checked in Lean with no external input.
3. **Results verified conditionally**: none. (There are no external inputs anywhere in this paper — see §3.)
4. **Results with an issue recorded**: Lemma 2 (1 of 2), and it has Lean evidence (a machine-checked counterexample, independently reviewed).
5. **Downstream impact**: none of this propagates. Lemma 1 and Lemma 2 are independent (neither cites or depends on the other; `source/demo.tex` contains no `\ref` to either label), so Lemma 2's issue does not threaten Lemma 1, and there is no other numbered result in this paper for it to threaten.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| Lemma 1 (`lem:square`) | **Verified unconditionally** | Both proof steps hold as printed: `a^2+b^2-2ab=(a-b)^2` (ring identity) and `(a-b)^2 \ge 0` (cited directly from mathlib's `sq_nonneg`, which has a working interface and so is not registered as an external parameter at all). Zero external parameters, axioms all standard (`propext, Classical.choice, Quot.sound`), independent final audit PASS. Equality is tight at `a=b`. Two steps the text leaves implicit — nonnegativity of a real square, and moving `2ab` across the inequality — were filled in with standard facts and classified `FAIR_IMPLICIT_STEP` (not an issue; see §7). Evidence: `verification/audits/L01_gate.md`, `verification/audits/L01_final.md`. |
| Lemma 2 (`lem:xsquare`) | **Issue recorded (ERROR)** | The printed statement "for every real number `x`, `x^2 \ge x`" is false on the open interval `(0,1)`; witness x = 0.5. The proof's stated justification ("the two factors `x` and `x-1` always have the same sign") is itself false on that same range — `x` and `x-1` have opposite signs there. The algebraic identity `x^2-x=x(x-1)` is correct. The gate independently reproduced the counterexample with its own probe before the issue process even started. Confirmed by an independently reviewed Lean counterexample (`COUNTEREXAMPLE VALID`). Evidence: `verification/BLOCKERS.md` B1, `verification/audits/L02_gate.md`, `verification/audits/L02_issue_1.md`, `verification/audits/L02_issue_1_audit.md`. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

**There are none.** `RESULTS.json`'s `external_tools` array is empty, both `pv_work/L01Stmt.lean` and `pv_work/L02Stmt.lean` are machine-confirmed to declare 0 constants, and `verification/EXTERNAL_TOOLS.md`'s registry table has no rows. The source cites no external literature (`\cite` occurs nowhere in `source/demo.tex`).

Two *candidates* were considered during drafting and resolved before reaching the gate, neither becoming a registered parameter (full detail in `verification/EXTERNAL_TOOLS.md` "Candidates from inventory" and `verification/report/work/external_tools.md`):

| # | Candidate | Type as flagged | Resolution |
|---|---|---|---|
| 1 | `sq_nonneg` (a real square is `\ge 0`), used in Lemma 1's proof | (v) as flagged by inventory | **Not a (v) item at all**: (v) requires "no interface in the pinned mathlib" (`VERDICTS.md` §4.1), but `sq_nonneg` has a direct interface (confirmed by `#check`, independently by both pv-gate and pv-auditor). Cited directly in the proof term instead of being declared as a parameter. |
| 2 | "Same sign ⇒ nonnegative product" step, used in Lemma 2's proof | (iii) as flagged by inventory | **Not registered as a parameter**: it is the proof's own single substantive step, not content imported from outside, so it was encoded as an internal step obligation of L02's own proof. That step turned out to be false — this is issue B1 (§4), not an external-tool problem. |

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| *(no rows)* | — | — | — | — | — |

Debts recorded in words: none. External assertions not encoded: none.

## 4. Substantive issues for the authors (in PDF order)

### 4.1 — B1 — Lemma 2 (`lem:xsquare`, PDF "Lemma 2") — paper side, `ERROR`

- **Classification**: paper side, **`ERROR`** — the printed conclusion itself is false for a value satisfying all printed hypotheses. (Ruled out: `PAPER_ARGUMENT_GAP`, `PAPER_ASSUMPTION_GAP`, `EXPOSITION_GAP`, `DOMAIN_CLARIFICATION` — these would apply if the conclusion were still true but the *argument* had a gap; here the conclusion is false, not just under-justified. Also ruled out: `ENCODING_ERROR`, `TRANSLATION_BLOCKED` — the formalization is a faithful, unweakened, unstrengthened transcription of the printed statement, confirmed independently by the gate and by the counterexample's own type-hash match to the gated statement.)
- **Source location**: statement `source/demo.tex:20-22` — "For every real number $x$ we have $x^2 \ge x$." Proof `source/demo.tex:24-27`; the key sentence is at lines 25-26: "The two factors $x$ and $x-1$ always have the same sign, so their product is nonnegative, and hence $x^2 \ge x$."
- **What fails**: for every real `x` with `0 < x < 1`, the statement is false. Witness `x = 1/2`: `x = 1/2 \ge 0` and `x - 1 = -1/2 < 0` — the two factors have *opposite* signs, refuting line 25-26's claim; their product `x(x-1) = -1/4 < 0`, refuting "nonnegative"; and `x^2 = 1/4 < 1/2 = x`, refuting the printed conclusion `x^2 \ge x` itself. The algebraic identity `x^2-x=x(x-1)` (first half of line 25) is correct — only the sign claim, and consequently the conclusion, are false, and only on `(0,1)`. Outside that range (`x \le 0` or `x \ge 1`) both the sign claim and the conclusion hold.
- **Lean evidence**: `pv_work/L02_Counterexample1.lean` (not "reasoning, not checked in Lean" — this is machine-checked). Builds with exit code 0, no `sorry`; `#pv_axioms` reports `ALL STANDARD`; `#pv_walk` reports `sorryAx reached: false` with only `propext, Classical.choice, Quot.sound`. Key declarations: `not_printedLemma2 : ¬ PrintedLemma2` (refutes the exact gated main theorem — `printedLemma2_eq_gated_statement : PrintedLemma2 = (∀ x : ℝ, x ^ 2 ≥ x)` proves this by `rfl`), `not_printedProductStep`, `not_printedSameSign`, `printedIdentity_true` (confirms the algebra step is fine), `failure_region : x^2 < x ↔ (0<x ∧ x<1)` (gives the exact scope of failure). The encoding's type hashes match the gate-reviewed statement exactly (`verification/audits/L02_gate.md`); the counterexample review (`verification/audits/L02_issue_1_audit.md`) independently re-derived all of this rather than trusting the issue-checker's report, and concluded **`COUNTEREXAMPLE VALID`**.
- **Affected**: Lemma 2 only.
- **Not affected**: Lemma 1 (`a^2+b^2 \ge 2ab`). Its proof shares no step with Lemma 2's, it is not cited by Lemma 2 and does not cite Lemma 2 (`\label{lem:xsquare}` has no matching `\ref` anywhere in the 29-line source), and no other numbered result exists in this 2-lemma paper.
- **Recorded suggested fix** (source: `verification/audits/L02_issue_1.md` §6, constructed by pv-issue-checker as a suggestion only — never used in any verification step — and independently re-checked in Lean by pv-auditor, `verification/audits/L02_issue_1_audit.md` §6, both PASS): restrict the quantifier to the complement of `(0,1)`, i.e. replace line 21 by "For every real number $x$ with $x \le 0$ or $x \ge 1$ we have $x^2 \ge x$," leaving the proof sentence (lines 25-26) unchanged — this also repairs the printed "same sign" justification itself, verified in Lean (`suggested_restriction_gives_conclusion`, `suggested_restriction_gives_same_sign`). A second idea — keeping the universal quantifier and weakening the conclusion to `x^2 \ge x - 1/4` — is recorded only as an **unverified remark**, explicitly not checked in Lean by anyone, and is not a usable suggested fix.
- **Needs human check**: no mathematical check remains — this is fully confirmed by an independently reviewed Lean counterexample. The only open question is authorial: which amendment the authors prefer, which is for them to decide, not a verification task. (One option is the `x\le0 \lor x\ge1` restriction above. A restatement for integers only was raised in the coordinator's working records but appears in no audit report and was not checked in Lean by anyone — it is a coordinator remark, not a recorded suggested fix, and is reported here only so the reader knows it was considered and not verified.)

No other substantive issue is recorded anywhere in this project. Lemma 1 has none (`verification/audits/L01_gate.md`: "No suspected paper issue"; `verification/audits/L01_final.md`: "No error, no gap, no ambiguity and no editorial slip found in the source for this lemma").

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| *(none)* | — | `source/demo.tex` was read in full (29 lines): no typo, no inconsistent notation, no mismatched cross-reference found. |

## 6. Human-check list

**Literature and citations**: none needed — `source/demo.tex` contains no `\cite` of any kind, and there is no type (i) or (ii) external input anywhere in this project.
**Mathematical completion (parts supported by reasoning only)**: none — every substantive claim (Lemma 1's full proof; Lemma 2's counterexample) is backed by machine-checked Lean evidence with standard axioms only, independently rebuilt and compared.
**Author intent**: one item — which amendment to Lemma 2 the authors prefer (see §4.1's last bullet). The mathematical question itself is closed.
**Experiments and unnumbered assertions**: none exist in this paper (`verification/INVENTORY.md` §6).

## 7. Limits on the formalization side (not paper issues)

- There are no external parameters in this project, so nothing here is "unverified pending a parameter check" — the one open item (Lemma 2) is a paper-side issue, already fully adjudicated with Lean evidence.
- Technical formalization assumptions (TFA) approved by the gate: none recorded for either result.
- Scope restrictions: none — both lemmas were encoded exactly as printed, with no added or weakened hypothesis.
- Two steps of Lemma 1's proof that the text leaves implicit were filled in and classified `FAIR_IMPLICIT_STEP` (not an issue, `VERDICTS.md` §2.2): nonnegativity of a real square (`sq_nonneg`), and passing from `a^2+b^2-2ab \ge 0` to the printed `a^2+b^2 \ge 2ab`. Recorded in `verification/audits/L01_final.md` and `L01_gate.md`.
- Corrections on the formalization side: none — no `ENCODING_ERROR` was found for either result; both gates passed on the first review (PASS, no amendments).
- One mechanical-audit check could not run as designed: `scripts/pv_audit_mech.py`'s `#pv_type_hashes` check errored on `L01Stmt.lean`, which is intentionally empty (0 declarations) — a kit-tooling artifact, not a paper or Lean defect. The auditor completed the same check by hand (identical file hash, `#pv_type_hashes_here` confirms 0 declarations) with result PASS, and recorded a suggested fix for the kit's maintainers (`verification/audits/L01_mech.md`, `L01_final.md`).
- One comparison in the counterexample review could not be run as designed: a line-by-line text `diff` of the auditor's own `L02Draft.lean` copy against the original was blocked by the session's permission system. The auditor completed the comparison instead by compiled type-hash and `rfl` identity against the gate snapshot (`verification/audits/L02_issue_1_audit.md`), which is the stronger of the two checks, so no conclusion in this report rests on the missing `diff`.
- Lean comment errata: `verification/DOC_ERRATA.md` records one comment-only imprecision (a docstring in `pv_work/L01Stmt.lean`/`L01Draft.lean` mischaracterizes `sq_nonneg`'s provenance type), with no effect on any statement, hash, or verdict.

## 8. Process disclosure

- Violations: none.
- Coordinator errors found and corrected during compilation: pv-compiler's `verification/report/work/consistency_check.md` found five record-keeping defects, all since corrected:
  1. **M1** (Major) — `RESULTS.json`'s `lean_main` for L02 named a nonexistent declaration (`L02_Counterexample1_x_half`); corrected to `Paper.L02.Counterexample1.not_printedLemma2`, which exists.
  2. **Mo1** (Moderate) — `PAPER_VERIFICATION.md`'s per-result evidence cells were garbled/self-duplicating (the coordinator had passed the whole table row to `--row` instead of just the cell text); rewritten as clean free text.
  3. **Mo2** (Moderate) — a gate-deferred docstring imprecision (`sq_nonneg`'s provenance-type wording) had never been carried into `DOC_ERRATA.md`; added as row 1 there.
  4. **Mi1** (Minor) — `AUDIT.md` held two duplicate L02 log entries from repeated `record` invocations; squashed to one.
  5. **Mi2** (Minor) — L01's `lean_main` read `pv_work/L01.lean:L01 …` (literal `:L01` where a line number belongs); corrected to `pv_work/L01.lean:52 …`.

  None of the five affected any verdict, any Lean file, or any audit conclusion — all were stale or malformed cross-references in the machine-readable records only.
- The independent fact check of this report's first draft (`verification/report/work/AUTHOR_REPORT_v1.md`) found 9 problems — 1 Major, 3 Moderate, 5 Minor (full report: `verification/report/work/factcheck.md`) — which have been corrected in this version:
  - Major/Moderate: an unsourced "restate for integers only" suggestion in §4.1 and `BLOCKERS.md` that appeared in no audit record (removed/relabeled as a coordinator remark, never Lean-checked); this report's own line 3 and this section shipping an unfilled placeholder instead of the real fact-check counts (fixed); this section originally listing only 2 of the 5 corrected record items above (expanded to all 5); §7 omitting the one check the counterexample reviewer could not run (the `L02Draft.lean` text `diff`, blocked by permissions; added above).
  - Minor: the M1/Mo1 labels were swapped in an earlier draft of this disclosure (fixed, see the numbered list above); §7 omitted the `pv_audit_mech.py` artifact on the empty `L01Stmt` module (added above); §2/§7 omitted L01's two `FAIR_IMPLICIT_STEP`s (added above); §2's L02 evidence list omitted `L02_gate.md` (added above); `BLOCKERS.md` B1 misattributed the suggested fix to the auditor rather than the issue-checker (corrected in the record).

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
