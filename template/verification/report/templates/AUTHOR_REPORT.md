# <Paper title>: final report of the faithful LaTeX → Lean check

YYYY-MM-DD, summary by the coordinator; it has passed an independent fact check, whose report is in verification/report/work/factcheck.md.

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on N external inputs that have not been verified in Lean.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).

---

## 0. Summary table (English, for screenshots)

**N numbered results: a verified unconditionally · b verified conditionally · c with recorded issues · d unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions (exceptions recorded in words: …). A recorded issue is/is not a counterexample to a main result (state which).

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|

(Only if some results have every condition checked by a person:) Of the results verified conditionally, k have every condition checked by a person (who, when and how: §3). They remain conditional, because the conditions are not checked in Lean.

## 0b. What the revision changed (only after `/pv-revise`)

From `python3 scripts/pv_status.py followup`. Results that were not reset keep their verdicts.

| PDF no. | Before (revision) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|

## 1. Overall findings

1. Whether there is a counterexample to a main result; the categories of recorded issues (grouped by which side is at fault, stating "this is not a complete list; see §4 for all of them").
2. Results verified unconditionally.
3. Results verified conditionally (exceptions: debts recorded in words; parts not encoded).
4. Results with an issue recorded, and which of them have Lean evidence.
5. Downstream impact: which issues do not propagate, and which remain substantive conditions.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|

Debts recorded in words: ...  External assertions not encoded: ...

## 4. Substantive issues for the authors (in PDF order)

Each entry states:
- the classification, and which side is at fault;
- the source location;
- what fails;
- the Lean evidence, or "reasoning, not checked in Lean";
- the scope that is not affected;
- recorded suggestions (with their source; for arguments constructed by the reviewers themselves, note "suggestion only").

### 4.1 …

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|

## 6. Human-check list

**Literature and citations**: …
**Mathematical completion (parts supported by reasoning only)**: …
**Author intent**: …
**Experiments and unnumbered assertions**: …

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Technical formalization assumptions (TFA) approved by the gate: …
- Scope restrictions: …
- Corrections on the formalization side (e.g. revisions pre-approved after something the gate missed): …
- Lean comment errata: `verification/DOC_ERRATA.md`.

## 8. Process disclosure

- Violations (if any): …
- Coordinator errors found and corrected by subagents: …
- The independent fact check of this report's first draft found N problems (x Major, y Moderate, z Minor), which have been corrected.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
