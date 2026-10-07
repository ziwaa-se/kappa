---
name: pv-revise
description: Handle a revised manuscript — compare source/ with the baseline copy, find which numbered results and definitions are affected, update every file:line reference, apply the chain-reset rule to affected results only, and keep valid verdicts. Use after replacing files in source/ with a new version of the paper.
disable-model-invocation: true
---

# /pv-revise — Handling a revised source manuscript

Use this after the user has put the new LaTeX version into `source/`. During `/pv-setup`, the source manuscript was copied to `verification/source_baseline/`.

Follow `CLAUDE.md` and `verification/rules/`, especially "Cascade reset on statement change" in `PIPELINE.md`.

1. Run `date`, then take a snapshot: `python3 scripts/pv_snapshot.py save --label before-revision`. The snapshot includes the `.tex` files, so the source text cited by the old audit reports can still be found.
2. **Compare.** Run `diff -ruN verification/source_baseline source`, and list the added, deleted and modified files and line ranges.
3. **Find the affected objects.** For each numbered result and each shared definition, decide which case applies:
   - (a) the statement changed;
   - (b) the proof changed;
   - (c) a definition or convention it refers to changed;
   - (d) the number or the `\label` changed;
   - (e) only the line numbers shifted; the content did not change.

   When unsure, dispatch pv-architect with the task description "only determine which results these changes affect". Register numbered results that are **new** in the new version, in the inventory format.
4. **Update locations.** In `RESULTS.json`, `INVENTORY.md`, `PAPER_VERIFICATION.md` and the `source_loc` of `external_tools`, update every shifted `file:line` and number, covering cases (d) and (e). Audit reports are historical records and are **not changed**; append a "Revision mapping" paragraph to `AUDIT.md` listing the correspondence between old and new line numbers.
5. **Reset.**
   - Cases (a), (b), (c): apply the "Cascade reset on statement change" to that result, with `reason` set to `SOURCE_CHANGED`. This rule also resets the results that import it, the results conditioned on its (p) clauses, and the results that have a `Closed` file referring to it, and clears the conditions, evidence and `lean_main` of those results.
   - Do the reset with `python3 scripts/pv_status.py reset <ID> [<ID> …] --revision <k>` (v1.3). It keeps each result's previous verdict, issues and evidence in its `history`, clears the fields above, marks the result's open issues in `BLOCKERS.md` as `— RECHECK (revision <k>)`, and lists the dependents to consider for the cascade.
   - A shared definition changed: write it as a new file `Defs<k>.lean` and gate it again; apply the cascade reset to the results that use the old definition.
   - Only (d), (e): the verdict is kept.
6. **Records.** For the issues in `BLOCKERS.md` related to the changes:
   - **Do not mark an issue resolved now.** A changed sentence is not yet a verified one. An issue is resolved only when the re-run gives the result a verified verdict with a new final audit; `/pv-run` then records it with `record --resolve <B…>`.
   - Issues of results that were not reset: update their line numbers only.

   Then update `RESUME.md`, listing the reset results, run validate, and take a snapshot.
7. **Save the new baseline.** Run `python3 scripts/pv_snapshot.py baseline --new-version`: it keeps the old baseline as `verification/source_baseline_v<k>/` and copies `source/` as the new `verification/source_baseline/`. **Do this step only after confirming that all changes have been registered.**
8. **Report to the user:** which results were reset, which verdicts were kept, and which earlier issues are now waiting for re-checking. Then recommend running `/pv-run <reset IDs…>`; the scope automatically includes their unfinished predecessor results. After that run, `python3 scripts/pv_status.py followup` shows, for each re-checked result, its verdict before and after and whether each earlier issue is resolved.
