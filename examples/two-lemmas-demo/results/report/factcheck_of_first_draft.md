# Independent fact check of the final report (`pv-factcheck`, read-only)

- **Role**: `pv-factcheck` (independent of the coordinator and of `pv-compiler`; nothing in the
  report was taken on trust)
- **Date**: 2026-10-01
- **Objects checked**: `verification/report/AUTHOR_REPORT.md`,
  `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`
- **Sources used, in priority order**: `source/demo.tex` (read in full, 29 lines);
  `verification/audits/` (all six files: `L01_gate.md`, `L01_final.md`, `L01_mech.md`,
  `L02_gate.md`, `L02_issue_1.md`, `L02_issue_1_audit.md`); `verification/PAPER_VERIFICATION.md`,
  `BLOCKERS.md`, `RESULTS.json`, `AUDIT.md`, `EXTERNAL_TOOLS.md`, `DOC_ERRATA.md`, `INVENTORY.md`,
  `RESUME.md`, `rules/VERDICTS.md`; the drafts under `verification/report/work/`
  (`consistency_check.md`, `author_notes.md`, `external_tools.md`) as secondary material.
  Lean declaration line numbers were read from `pv_work/L01.lean`, `pv_work/L02Draft.lean`,
  `pv_work/L02_Counterexample1.lean` directly.
- **I wrote only this file.** No network, no downloads, no change to any other file.

---

## 1. Problem table

| # | Severity | Report text (verbatim / located) | What the source says | Source `file:line` | Suggested correction |
|---|---|---|---|---|---|
| P1 | **Major** | §4.1, last bullet ("Needs human check"): "which amendment the authors prefer (restrict the domain as above, **restate for integers only — for which `x^2 \ge x` holds for all integers** — or something else)" | The integer amendment appears in **no audit record**. The only places it occurs are coordinator-written records: `BLOCKERS.md` B1 "Needs human check" ("or restrict to integers, for which $x^2\ge x$ holds for all integers") and `RESUME.md`'s human-check list. `L02_issue_1.md` mentions integers only to *reject* them as a possible reading ("there is no convention elsewhere that a fair reader could use to narrow it (e.g. to integers …)"), and its §6 records exactly two ideas: the `x ≤ 0 ∨ x ≥ 1` restriction (Lean-checked) and `x^2 ≥ x - 1/4` (explicitly **not** checked). `pv-compiler` had already flagged the integer option as "**not** Lean-checked by anyone and not part of the recorded suggested fix". `VERDICTS.md` §3.3 allows a recorded suggested fix only from auditors/reviewers: "the coordinator must not draft its own". | `verification/BLOCKERS.md:32`; `verification/RESUME.md:71-72`; `verification/audits/L02_issue_1.md:65`, `:201-225`; `verification/report/work/author_notes.md:96-102`; `verification/rules/VERDICTS.md:114` | Either delete the integer option, or keep it only with the compiler's caveat and an explicit provenance label, e.g. "(coordinator remark; it appears in no audit record and was not checked in Lean by anyone)". The same label should be added to `BLOCKERS.md:32`, which is where the unsourced suggestion entered the records. |
| P2 | **Moderate** | Line 3: "it has passed an independent fact check, whose report is in …/factcheck.md"; §8 third bullet: "The independent fact check of this report's first draft found **N** problems, which have been corrected — see … (filled in after the fact-check pass)." | The fact check had not been run when this text was written (this file is it), and `N` is an unfilled placeholder shipped in the delivered report. No record anywhere supports a passed fact check of this draft. | `verification/report/AUTHOR_REPORT.md:3`, `:98` (placeholder text); `verification/RESUME.md:28-31` (the fact check is the step *after* the coordinator writes the reports) | Replace `N` with the counts from this file (Major 1, Moderate 3, Minor 5), state which were corrected, and keep line 3's "has passed an independent fact check" only after the corrections are made. |
| P3 | **Moderate** | §8 second bullet: "Coordinator errors found and corrected during compilation:" followed by exactly two items ((a) malformed `PAPER_VERIFICATION.md` cell, (b) stale `lean_main` for L02). | `consistency_check.md` recorded **five** items, and three further ones were also coordinator record defects that have since been corrected: **Mo2** — the gate-deferred `sq_nonneg` docstring item had never been carried into `DOC_ERRATA.md` (it is now row 1 there, which is what §7's last bullet relies on); **Mi1** — `AUDIT.md` held two duplicate L02 entries (now squashed, as `AUDIT.md` itself notes); **Mi2** — L01's `lean_main` read `pv_work/L01.lean:L01 …` and now reads `pv_work/L01.lean:52 …`. `AUDIT.md`'s own correction note also credits all of it to "M1/Mo1", although the L01 `lean_main` fix was Mi2. | `verification/report/work/consistency_check.md:56-71` (Mo2), `:77-94` (Mi1), `:96-109` (Mi2); `verification/DOC_ERRATA.md:13`; `verification/RESULTS.json:51`; `verification/AUDIT.md:28-31`, `:40-43` | List all corrected record defects (or say "two substantive plus three minor record items — Mo2, Mi1, Mi2 — all corrected"), so the disclosure matches the compiler's own list. |
| P4 | **Moderate** | §7 ("Limits on the formalization side") lists five bullets, none of which mentions any check that could not be completed. | The counterexample review records one check it could not run: "A line-by-line `diff` of my `L02Draft` copy against the original could not be run (the Bash invocations needed for it were denied by the permission system)", with the reviewer's reasoning for why the conclusion still stands. | `verification/audits/L02_issue_1_audit.md:211-216` | Add one bullet to §7: the L02 draft-copy `diff` could not be run (permission denial); the comparison was completed instead by compiled type-hash/`rfl` identity, so no conclusion rests on the missing diff. |
| P5 | Minor | §8: "(a) wrote a malformed `PAPER_VERIFICATION.md` evidence cell …, and (b) recorded a stale/nonexistent Lean declaration name in L02's `lean_main` … Both were caught by pv-compiler's `consistency_check.md` (items **M1, Mo1**)" | The mapping is reversed: **M1** is the stale/nonexistent `lean_main` for L02 (item (b)); **Mo1** is the garbled `PAPER_VERIFICATION.md` row (item (a)). | `verification/report/work/consistency_check.md:11` (M1), `:35` (Mo1) | Write "(items Mo1 and M1 respectively)". |
| P6 | Minor | §7, bullets 3-5: the formalization-side limits list contains no mechanical-check item. | The final audit records one FAIL line and a kit-side suggested fix: `MECH CHECKS: FAIL (probe)` in `L01_mech.md`, caused solely by `#pv_type_hashes L01Stmt` erroring on the intentionally empty `Stmt` module; the auditor completed the check by hand (0 = 0 declarations) and suggested the kit treat an empty `Stmt` module as 0 declarations. It is explicitly "a suggested fix for the kit, not for this result". | `verification/audits/L01_final.md:7`, `:40-45`, `:120-122`; `verification/audits/L01_mech.md` (last line) | Add one bullet to §7: the single mechanical-audit FAIL is a `pv_audit_mech.py` artifact on an empty `Stmt` module, resolved by hand with result PASS; a kit-side fix is recorded for the maintainers. |
| P7 | Minor | §2, L01 cell: "Both proof steps hold as printed … independent final audit PASS"; §6: "every substantive claim … is backed by machine-checked Lean evidence". | The final audit records two `FAIR_IMPLICIT_STEP`s for L01 and how each was filled in: (A) *why* `(a-b)^2 ≥ 0` (mathlib `sq_nonneg`), and (B) passing from "`a^2+b^2-2ab ≥ 0`" to the printed "`a^2+b^2 ≥ 2ab`" (`linarith`/`sub_nonneg`). Both are judged fair, and `FAIR_IMPLICIT_STEP` is a "not an issue" code, so no verdict changes — but the report never mentions that the printed proof leaves two steps implicit. | `verification/audits/L01_final.md:95-101`; `verification/audits/L01_gate.md:126-132`; `verification/rules/VERDICTS.md:87` | Add half a line to §2's L01 cell or to §7: "two steps the text leaves implicit (nonnegativity of a real square; moving `2ab` across the inequality) were filled in with standard facts and classified `FAIR_IMPLICIT_STEP` — not issues". |
| P8 | Minor | §2, L02 cell, "Evidence: `verification/BLOCKERS.md` B1, `verification/audits/L02_issue_1.md`, `verification/audits/L02_issue_1_audit.md`." | `RESULTS.json` lists `verification/audits/L02_gate.md` as L02's gate evidence, and that gate independently reproduced the counterexample with its own probe before the issue process started (`¬(∀ x : ℝ, x^2 ≥ x)` and `¬(∀ x : ℝ, 0 ≤ x(x-1))`, probes (b),(d)). The L01 row does cite its gate; the L02 row omits it. | `verification/RESULTS.json:75-81`; `verification/audits/L02_gate.md:178-195` | Add `verification/audits/L02_gate.md` to the L02 evidence list (as §4.1 already does for the hash pinning). |
| P9 | Minor (record side, not report text) | §4.1: "Recorded suggested fix (source: `verification/audits/L02_issue_1.md` §6, constructed by pv-issue-checker …)" — this is **correct**. | The report is right and `BLOCKERS.md` is wrong: B1's "Recorded suggested fix" attributes the fix to "`verification/audits/L02_issue_1_audit.md` (auditor-constructed)", whereas the fix was constructed in `L02_issue_1.md` §6 by `pv-issue-checker` and only *re-checked* by `pv-auditor` in `L02_issue_1_audit.md` §6. | `verification/BLOCKERS.md:31` vs `verification/audits/L02_issue_1.md:201-225` and `verification/audits/L02_issue_1_audit.md:194-208` | No change to the report; correct the attribution in `BLOCKERS.md:31` so the record matches the audits. |

Counts: **Major 1, Moderate 3, Minor 5.**

No problem was found in any verdict class, in any issue classification, or in the downstream-impact
claims (see §2).

---

## 2. Checked and found correct, by section

### `AUTHOR_REPORT.md` — header and §0 (summary table)

- "not a claim that the whole paper is fully verified" — required by `VERDICTS.md` §5 and present.
- Counts "2 numbered results: 1 unconditional · 0 conditional · 1 issue · 0 unfinished" sum to 2 and
  equal the per-row verdicts; identical to `PAPER_VERIFICATION.md:3` and to `RESULTS.json`
  (`L01.verdict = UNCONDITIONAL`, `L02.verdict = ISSUE`). `VERDICTS.md` §5 header-count rule satisfied.
- Verdict wording: "Verified unconditionally" for L01 and "Issue recorded (ERROR)" for L02 are the
  classes recorded in `RESULTS.json`, `AUDIT.md` (`UNCONDITIONAL / FINAL_PASSED`;
  `ISSUE / STOPPED/ISSUE_RECORDED`) and `PAPER_VERIFICATION.md`. Nothing conditional is called
  "verified", and the counterexample is correctly called a Lean counterexample (it is one).
- Conditions column: "None" for L01 is right (`conditions: []`, `debts: []`, `unencoded: []`,
  0 declarations in `L01Stmt.lean`); "B1 … witness `x=1/2`" for L02 matches `BLOCKERS.md` B1.
  Neither too many nor too few conditions.
- Statement of what "conditionally verified" means agrees with `VERDICTS.md` §1.2.

### §1 (overall findings)

- "`x = 1/2` satisfies the lemma's sole hypothesis … `x^2 = 1/4 < 1/2 = x`" — verified against
  `source/demo.tex:21` and `L02_issue_1_audit.md` §2; the sole printed hypothesis really is the
  typing condition.
- `ERROR` rather than a gap: matches `VERDICTS.md` §2.1 row `ERROR`, `L02_issue_1.md` §3 and
  `L02_issue_1_audit.md` §5 ("`ERROR` is correct").
- "this is the paper's only recorded issue" — `BLOCKERS.md` has exactly one entry (B1), and no other
  audit file records an issue; `L01_gate.md` §7 "No suspected paper issue", `L01_final.md` §8 "No
  error, no gap, no ambiguity and no editorial slip".
- Downstream impact: I checked `source/demo.tex` myself — `\ref` occurs **nowhere** in the file, and
  `lem:xsquare` / `lem:square` occur only in their own `\label`s (lines 20 and 12). `INVENTORY.md`
  §3 records `depends_on = —` for both. The "none of this propagates" claim is correct and is not a
  blanket "no counterexamples" claim (the report states the one counterexample plainly).

### §2 (per-result verdicts)

- L01: ring identity + `(a-b)^2 ≥ 0`, `sq_nonneg` cited directly and correctly **not** registered as
  a parameter (`L01_gate.md` §6 and "External parameters" table; `L01_final.md` §5 row 1;
  `VERDICTS.md` §4.1 — (v) requires *no* interface). Zero parameters, standard axioms only, final
  audit PASS, equality tight at `a=b` (`L01_final.md` §7). All confirmed.
- L02: the quoted printed justification and its failure on `(0,1)`, the correctness of the identity
  `x^2-x = x(x-1)`, and `COUNTEREXAMPLE VALID` all match `L02_issue_1.md` §§1-3, §5 and
  `L02_issue_1_audit.md` §§1-5, §8.

### §3 (external dependencies) and `EXTERNAL_TOOLS_WORKSHEET.md`

- "There are none": `RESULTS.json."external_tools" = []`; `EXTERNAL_TOOLS.md` registry table has no
  rows (nor do its "debt in words" and "assertions not encoded" tables); both `L01Stmt.lean` and
  `L02Stmt.lean` are machine-confirmed at **0 declarations** (`L01_gate.md` §13 / `L01_final.md`
  item 4; `L02_gate.md` §8, §13); no `\cite` anywhere in `source/demo.tex` (verified by my own read).
  The empty parameter table (no rows) is therefore correct, and so is the worksheet's "nothing to
  check" in every priority level A–E.
- Provenance-type legend in §3 reproduces `VERDICTS.md` §4.1 (i)-(v),(p) correctly, including the
  rule that gap hypotheses are not external inputs (none exist: no `<ID>ModGaps.lean` was produced).
- Candidate table: candidate 1 `sq_nonneg`, flagged (v), used by L01, `source/demo.tex:17`;
  candidate 2 the same-sign step, flagged (iii), `source/demo.tex:25-26`, used by L02 — both match
  `INVENTORY.md` §5 and `EXTERNAL_TOOLS.md` "Candidates from inventory" verbatim, and both
  resolutions match `L01_gate.md` §6 and `L02_gate.md` §7.3/§8 (the gate "independently endorsed"
  encoding the step as an internal obligation). The claim that neither became a registered parameter
  is correct.

### §4 (substantive issue B1)

- Classification `ERROR`, paper side; every exclusion listed in the report (`PAPER_ARGUMENT_GAP`,
  `PAPER_ASSUMPTION_GAP`, `EXPOSITION_GAP`, `DOMAIN_CLARIFICATION`, `ENCODING_ERROR`,
  `TRANSLATION_BLOCKED`) is argued in `L02_issue_1.md` §3 and independently confirmed in
  `L02_issue_1_audit.md` §5. Agrees with `VERDICTS.md` §2.
- Source locations: statement `source/demo.tex:20-22` (line 21 is the sentence quoted),
  proof `24-27`, key sentence `25-26` — all verified character-by-character against the `.tex`
  (`BLOCKERS.md` writes `21-22` for the statement; both are defensible and `RESULTS.json`/
  `INVENTORY.md` use `20-22`, which the report follows).
- Scope "fails exactly on `(0,1)`, holds on `x ≤ 0` and `x ≥ 1`": `failure_region` in
  `pv_work/L02_Counterexample1.lean:142`, confirmed in `L02_issue_1_audit.md` §4.
- Lean evidence: `pv_work/L02_Counterexample1.lean` exists and every declaration the report names
  exists at the stated place — `PrintedLemma2` (:44), `not_printedLemma2` (:77),
  `not_printedProductStep` (:83), `not_printedSameSign` (:90), `printedIdentity_true` (:102),
  `printedLemma2_eq_gated_statement … := rfl` (:129), `failure_region` (:142),
  `suggested_restriction_gives_conclusion` (:159), `suggested_restriction_gives_same_sign` (:166).
  Exit 0, no `sorry`, `#pv_axioms ALL STANDARD`, `#pv_walk … sorryAx reached: false`, axioms
  `[propext, Classical.choice, Quot.sound]`, rebuild IDENTICAL, type hashes equal to the gate
  snapshot — all as recorded in `L02_issue_1.md` §5 and re-run independently in
  `L02_issue_1_audit.md` §§0-3. The cited evidence files exist and both passed audit
  (`ISSUE VERDICT: ERROR`; `COUNTEREXAMPLE VALID`).
- "Not affected: Lemma 1" holds: no shared step, no citation in either direction, no other numbered
  result (`L02_issue_1.md` §4, `L02_issue_1_audit.md` §4, my own read of the source).
- Recorded suggested fix: sourced correctly to `L02_issue_1.md` §6 (constructed by the
  issue-checker, suggestion only, never used in any verification) and re-checked by `pv-auditor`
  §6; it really does solve the problem — both the restricted conclusion and the printed "same sign"
  justification become true, and by `failure_region` the restriction is the weakest one that works.
  The `x^2 ≥ x - 1/4` variant is correctly labelled an unverified remark that nobody Lean-checked
  (`L02_issue_1.md:224-225`, `L02_issue_1_audit.md:206-208`).
- "Needs human check: no mathematical check remains" matches `BLOCKERS.md` B1 and
  `L02_issue_1_audit.md` §7.

### §5 (editorial slips) and §6 (human-check list)

- "no typo, no inconsistent notation, no mismatched cross-reference" in the 29-line source: the file
  is indeed 29 lines; no audit record contains an `EDITORIAL` item; `L01_final.md` §8 states no
  editorial slip; `pv-compiler`'s own line-by-line read found none (`author_notes.md` (B)).
- No literature item (no `\cite`), no type (i)/(ii) input — correct.
- "Experiments and unnumbered assertions: none (`INVENTORY.md` §6)" — §6 of `INVENTORY.md` indeed
  reads "None." Nothing recorded was left out of the human-check list: `RESUME.md`'s "Human-check
  to-do list" says "None required" apart from the authorial amendment choice, which the report
  carries (subject to P1 on how the integer variant is worded). No `pv_status.py human-check` entry
  exists anywhere, and the report correctly claims none.

### §7 (formalization-side limits)

- No external parameters, so nothing is "pending a parameter check" — correct.
- TFAs: none — `L01_gate.md` "TFAs ruled on" (none claimed/present) and `L02_gate.md` §10 (none
  offered, none found; and `x ≤ 0 ∨ 1 ≤ x` would *not* have been approvable).
- Scope restrictions: none; both encodings are exactly as printed (`L02_gate.md` §3, §12;
  `L02_issue_1_audit.md` §1.3 "No restriction was invented anywhere").
- No `ENCODING_ERROR` for either result; both gates "PASS, no amendments" (`L01_gate.md` "Required
  changes: None"; `L02_gate.md` §12 "None").
- `DOC_ERRATA.md` really does contain exactly one row, and its content is the `sq_nonneg`
  provenance-type docstring imprecision in `L01Stmt.lean`/`L01Draft.lean`, sourced to
  `L01_gate.md` §6 — the report's description is accurate. (The row was added only after
  `consistency_check.md` Mo1/Mo2; see P3.)

### §8 (process disclosure) — the part that checks out

- The substance of the two disclosed coordinator errors is accurate: `consistency_check.md` M1 shows
  the old `lean_main` value `Paper.L02.L02_Counterexample1_x_half`, and I confirmed no such
  declaration exists in `pv_work/L02_Counterexample1.lean`; the file's namespace is
  `Paper.L02.Counterexample1` (line 33) and `RESULTS.json:83` now reads
  `pv_work/L02_Counterexample1.lean Paper.L02.Counterexample1.not_printedLemma2`, which does exist
  (line 77). `consistency_check.md` Mo1 shows the garbled `PAPER_VERIFICATION.md` rows; the current
  `PAPER_VERIFICATION.md:11-12` rows are clean free text.
- "`verification/AUDIT.md` records the correction" — true: both result sections carry the
  parenthetical note at `AUDIT.md:28-31` and `:40-43` (timestamped 00:34-00:35, citing
  `consistency_check.md` M1/Mo1).
- "Neither error affected any verdict, any Lean file, or any audit conclusion" — correct: the
  verdicts, hashes and audit files are unchanged, and `consistency_check.md` says the same.
- "Violations: none" — I found no POLICY violation recorded in any audit file; no `axiom`, `sorry`,
  `native_decide` etc. in the delivered modules (`nonstandard_axiom_lines=0`, `sorryAx reached:
  false`), `lake build` not run anywhere, and `source/` unmodified (same `demo.tex` sha256
  `465009ad…` in the gate, the ruling and the counterexample review).

### `FILES_TO_CHECK.md`

- Every `file:line` I spot-checked is right: `pv_work/L01.lean:52` `L01_main`, `:30` `L01_S1`,
  `:42` `L01_S2`; `pv_work/L02Draft.lean:57` `theorem L02 (x : ℝ) : x ^ 2 ≥ x` (still `sorry`);
  `pv_work/L02_Counterexample1.lean:77` `not_printedLemma2`, `:44` `PrintedLemma2`, `:69`
  `witness_in_range`, `:74` `printed_fails_at_half`, `:129`
  `printedLemma2_eq_gated_statement`, `:142` `failure_region`.
- "0 declarations" for both `Stmt` files, "no shared definitions (`defs: [{"id": "NONE"}]`)", "one
  open entry in `BLOCKERS.md`, Needs human check: no", "no external literature to obtain" — all
  match the records.
- The caution that Lemma 2 is *not* proved and that `L02_Counterexample1.lean` is a counterexample
  rather than a proof is correct and well put; the reading order and the rerun commands match the
  file layout (`PVTools.lean`, `L01.lean`, `L02_Counterexample1.lean` all exist).

### `EXTERNAL_TOOLS_WORKSHEET.md`

- "Nothing to check" in every level, empty priority table, empty notation table — consistent with
  zero registered parameters and with `VERDICTS.md` §4's priority scheme (A/A′/B/C/D/E), which is
  reproduced correctly. The two candidate paragraphs match `EXTERNAL_TOOLS.md` and `INVENTORY.md`
  §5, and the worksheet correctly routes the L02 same-sign step to B1 as a paper issue rather than
  an external-input check.

---

## 3. Could not be checked

- **No Lean compilation was re-run by me.** This role is read-only and does not compile; all exit
  codes, `#pv_axioms` / `#pv_walk` / type-hash and rebuild results quoted in the report were checked
  against the audit records (which do report running them independently) and against the declaration
  text in `pv_work/`, not re-executed. The `.olean` hashes were likewise not recomputed.
- **The timestamps** in the report ("2026-10-01") and in the records were not verified with `date`
  beyond the session date given to me; they are internally consistent across `AUDIT.md`,
  `RESUME.md`, `RESULTS.json` and the audit headers.
- **`source/demo.pdf` and `source/demo.aux`** were not opened; the PDF numbering (Lemma 1 / Lemma 2)
  was taken from `INVENTORY.md` §2, which quotes the `\newlabel` entries, and is consistent with the
  `.tex` ordering of the two `lemma` environments.
- **Content of the probe files** under `pv_work/probes/` was not read line by line; the probe
  outcomes were taken from the audit reports that produced them.
