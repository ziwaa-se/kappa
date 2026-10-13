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
   **Renamed main file (v1.3.2).** If `python3 scripts/pv_status.py source-check` reports "main file renamed: A -> B" (the new version has a new file name and the same title), run `python3 scripts/pv_status.py set-main B`, compare the old file with the new one (`diff -u verification/source_baseline/<A> source/<B>`), and in step 4 change every `file:line` reference from A to B. A missing main file with a different title is a different paper: stop.
3. **Find the affected objects.** For each numbered result and each shared definition, decide which case applies:
   - (a) the statement changed;
   - (b) the proof changed;
   - (c) a definition or convention it refers to changed;
   - (d) the number or the `\label` changed;
   - (e) only the line numbers shifted; the content did not change.

   When unsure, dispatch pv-architect with the task description "only determine which results these changes affect". Register numbered results that are **new** in the new version, in the inventory format.

   **Case (c) by definition, not by paragraph (v1.3.1).** Run `python3 scripts/pv_status.py defs-changed`. It compares each shared definition registered in `source_defs` (its own exact line range) between the baseline and `source/`, and lists the results that use it (`uses_defs`). A result is case (c) only if a definition it uses is `CHANGED` or not found; an unchanged formula in the same paragraph as a changed one does not make its users case (c). Projects set up before v1.3.1 have no `source_defs`: decide from the diff, and consider registering the definitions now (pv-architect, "only register source_defs and uses_defs").
4. **Update locations.** In `RESULTS.json` (including the `loc` of `source_defs`; `defs-changed` prints the new location of each unchanged definition), `INVENTORY.md`, `PAPER_VERIFICATION.md` and the `source_loc` of `external_tools`, update every shifted `file:line` and number, covering cases (d) and (e). Audit reports are historical records and are **not changed**; append a "Revision mapping" paragraph to `AUDIT.md` listing the correspondence between old and new line numbers.
5. **Reset** (v1.3.1, `PIPELINE.md` "Cascade reset on statement change").
   - Cases (a), (b), (c): reset **only these results**, with `python3 scripts/pv_status.py reset <ID> [<ID> …] --revision <k>`. It keeps each result's previous verdict, issues and evidence in its `history` (with `baseline_before`, the folder that will hold the previous manuscript), clears the fields the rule lists, archives the old proof files and reports under `rev<k>/`, marks the result's open issues in `BLOCKERS.md` as `— RECHECK (revision <k>)`, and marks the results that consume them directly as `recheck: pending`.
   - **Do not reset the dependents by hand.** When a reset result passes its gate again, `record <ID> --stage GATE_PASSED --statement-fixed true` compares its new statement with the old one: unchanged, the dependents keep their verdicts and only get a rebuild and a mechanical re-check; changed, they are reset in turn.
   - A shared definition changed: write it as a new file `Defs<k>.lean` and gate it again; reset the results that use it (case (c)).
   - Only (d), (e): the verdict is kept.
6. **Records.** For the issues in `BLOCKERS.md` related to the changes:
   - **Do not mark an issue resolved now.** A changed sentence is not yet a verified one. An issue is resolved only when the re-run gives the result a verified verdict with a new final audit; `/pv-run` then records it with `record --resolve <B…>`.
   - Issues of results that were not reset: update their line numbers only.

   Then update `RESUME.md`, listing the reset results, run validate, and take a snapshot.
7. **Save the new baseline.** Run `python3 scripts/pv_snapshot.py baseline --new-version`: it keeps the old baseline as `verification/source_baseline_v<k>/` and copies `source/` as the new `verification/source_baseline/`. **Do this step only after confirming that all changes have been registered.** From now on the previous manuscript is `verification/source_baseline_v<k>/` (the `baseline_before` that `reset` recorded); write that into `RESUME.md`, so that reviewers who check "is this passage unchanged?" compare against it and not against the refreshed baseline.
   If a report from before the revision exists, the driver's `--report` mode archives it under `verification/report_archive/` before writing the new one.
8. **Report to the user:** which results were reset, which verdicts were kept, and which earlier issues are now waiting for re-checking. Then recommend running `/pv-run <reset IDs…>`; the scope automatically includes their unfinished predecessor results. After that run, `python3 scripts/pv_status.py followup` shows, for each re-checked result, its verdict before and after and whether each earlier issue is resolved.
