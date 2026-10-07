---
name: pv-report
description: Produce the final deliverables after all numbered results have verdicts — compile the record (pv-compiler), fix inconsistencies, write the author report with an English summary table, the external-input worksheet, the files-to-check index and the doc errata, then run an independent fact-check (pv-factcheck) and apply its corrections.
disable-model-invocation: true
---

# /pv-report — Final report

Follow `CLAUDE.md` and `verification/rules/`. The report templates are in `verification/report/templates/`.

## 1. Prerequisites

- Run `python3 scripts/pv_status.py validate`; it must be VALID.
- If some results are still UNFINISHED, report them truthfully, and state in the report "The following results are unfinished". Do not force verdicts just to produce the report.

## 2. Compilation (subagent pv-compiler, read-only)

```
Compile the material for the final report; write the outputs to verification/report/work/: external_tools.md, author_notes.md, consistency_check.md.
No network, no downloads.
```

When it returns, for each contradiction in `consistency_check.md`, **verify it yourself first**, then correct the corresponding records (RESULTS.json, PAPER_VERIFICATION.md, BLOCKERS.md, etc.). After correcting, run validate again.

## 3. Write the reports

Write the following files from the templates:

1. `verification/report/AUTHOR_REPORT.md`:
   - §0 English summary table, assembled from the content of `pv_status.py table`, with a one-sentence definition of "verified conditionally". If `pv_status.py table` reports results whose every condition was checked by a person, say so under the table, with the one-sentence reminder that they are still conditional;
   - if any result has a `history` (the paper was revised, `/pv-revise`): a section **"What the revision changed"** right after §0, built from `python3 scripts/pv_status.py followup`. For each re-checked result give the verdict before and after, and for each earlier issue whether it is resolved, still present or awaiting re-check; results that were not reset keep their verdicts, so say that too;
   - §1 overall conclusion;
   - §2 verdicts, result by result;
   - §3 all external dependencies, with the "Checked by a person" column of `python3 scripts/pv_status.py tools` (who, when, against what; "not yet" otherwise);
   - §4 substantive issues for the authors (cite only suggestions already present in the audit records);
   - §5 editorial slips and presentational suggestions;
   - §6 human-check list;
   - §7 formalization-side limits;
   - §8 process disclosure (violations, coordinator errors, corrected items);
   - §9 evidence entry points.
2. `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`: for each parameter, give the priority (per the table in `VERDICTS.md` §4: A for (iv), and for (p) whose predecessor has an issue and could not be reconnected; A′ for (iii); B for (i) with doubtful attribution; C for (ii); D for the remaining (i); E for (v)), the **Lean definition quoted verbatim**, the source location, the mathematical meaning, the check points and a checkbox. Gap hypotheses (g) are not external inputs; list them under the corresponding issue in §4 of the report.
3. `verification/report/FILES_TO_CHECK.md`: the division of roles among the three files; for each result, the correspondence "source location ↔ Lean main theorem file:line ↔ audit report" (write the full name of the main theorem, and list the `<ID>Stmt.lean` where the `def`s it uses are located); the basic definition files; and the commands to rerun the compilation.
4. `verification/DOC_ERRATA.md`: the outdated comments recorded in the audits. Audited files are not changed.

## 4. Independent fact-check (subagent pv-factcheck)

```
Check verification/report/AUTHOR_REPORT.md (and EXTERNAL_TOOLS_WORKSHEET.md, FILES_TO_CHECK.md).
Output: verification/report/work/factcheck.md. No network, no downloads.
```

When it returns, deal with every Major and Moderate item one by one, and correct Minor items as far as possible:
- before correcting, save the first draft as `verification/report/work/AUTHOR_REPORT_v1.md`;
- keep the fact-check report at `verification/report/work/factcheck.md`, and link it in §9 of the report;
- state in §8 of the report "An independent fact-check of the first draft found N problems, which have been corrected".
- After the fact-check and the corrections are complete, run `python3 scripts/pv_status.py paths <report>` once on each of the three reports; there must be no MISSING.

## 5. Delivery

- Run `python3 scripts/pv_snapshot.py save --label report`.
- Tell the user:
  - the four counts and the English summary table;
  - the most substantive issues;
  - the grade-A external inputs that need a human check;
  - the reading order of the three main files: AUTHOR_REPORT → FILES_TO_CHECK → EXTERNAL_TOOLS_WORKSHEET;
  - while external parameters remain, **do not claim that the whole paper is fully verified**.
