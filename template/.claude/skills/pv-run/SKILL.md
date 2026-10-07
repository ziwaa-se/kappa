---
name: pv-run
description: Coordinator loop for faithful proof checking. Advances every numbered result in dependency order through draft → independent gate → proof → independent final audit, plus the issue branch and predecessor reconnection; records verdicts, snapshots progress and reports to the user after each milestone, until every result has a verdict or a recorded reason. Invoke after /pv-setup, or via /pv-resume.
disable-model-invocation: true
---

# /pv-run — Automatic progression (main session = coordinator)

Scope argument: `$ARGUMENTS`. Empty means all numbered results; you may also give a list of IDs, for example `L01 L02 T01`.

You are the **coordinator** and you do only four things: assign work, check outputs, write records, and report to the user. **You do not write proofs, and you do not stand in for the audits**. This needs care, not deep mathematics: a Sonnet-class model is enough for the coordinator (v1.3). When something needs deep analysis, it belongs to a subagent; when only the user can decide it, record it in `RESUME.md` and stop.

**Read at the start (v1.3):** `CLAUDE.md` (already loaded), this skill, `PIPELINE.md`, and `VERDICTS.md` §1 and §5. Open the other rules files only when a situation needs them; the subagents carry their own rule cards. Follow especially these parts of `PIPELINE.md`:
- the stage and reason table;
- the naming rules;
- the verdict lines;
- the suspected-issue routing table;
- the cascade reset rule.

The user has authorized continuous automatic progression: **do not ask for permission item by item**. When you find a problem, record it and then continue. Stop to ask only when a decision can be made only by the user and would change a large amount of later work (for example, how the domain is read across the whole paper).

## 0. Start

1. Run `date '+%Y-%m-%d %H:%M'`, read `verification/RESUME.md` and `RESULTS.json`, and run `python3 scripts/pv_status.py validate`.
2. **Scope.** Write the scope into `run_scope` in `RESULTS.json`; for all results write `[]`. **The scope automatically includes** all unfinished predecessor results of the results in scope, recursively. Also write the final scope into `RESUME.md`.
3. **Shared definitions.** If `defs` is empty:
   - if the paper has no definitions that need to be shared, register `{"id": "NONE"}`;
   - otherwise handle it as in stage 1: pv-drafter in shared-definitions mode → pv-gate (for the task description, see the DEFS template in §2) → you run `scripts/pv_lean.sh build Defs` → register in `defs`.

## 1. Main loop

Repeat the following steps until every result in scope has a verdict, or is UNFINISHED with its `reason` recorded:

1. **Pick work.**
   1. First run `python3 scripts/pv_status.py reconnect`; if anything needs reconnection, do that first (stage 6b).
   2. Then run `python3 scripts/pv_status.py next`: `READY` rows are results that can start; `BLOCKED` rows state which predecessor blocks them.
2. **Parallelism.** **No more than 3** subagents may run at the same time in total; issue rulings and reviews count toward this. Each Lean file may have only one writer at a time. **In an unattended (headless) session, never end your turn while subagents you started are still running**: wait for them, because they are stopped when the session ends.
3. **Before starting a subagent**, add a row to the "Running subagents" table in `RESUME.md`: role, target, files it should produce, start time. Delete the row after the subagent returns.
4. **Each pipeline** advances according to `PIPELINE.md`, with `stage` set according to the stage table:

   ```
   pv-drafter (writes <ID>Stmt.lean and <ID>Draft.lean) → pv-gate
      FAIL                   → pv-drafter (with the gate report) → pv-gate; 2 times in total; if still FAIL, set STOPPED + GATE_FAILED
      PASS_WITH_AMENDMENTS   → pv-drafter (amendment mode) → pv-gate (amendment check, writes _gate_r2.md)
      PASS                   → you set statement_fixed: true and run build <ID>Stmt
                             → pv-prover → pv-auditor (final audit) → record
   ```

   **Prover sessions and models (v1.3).** The first proof session runs on the model in the pv-prover definition (sonnet). If it reports `BUDGET_EXHAUSTED` for any obligation, start the second proof session at once with `model: "opus"` in the `Agent` call, for the stuck obligations only, and give it the first session's notes. `TRANSLATION_BLOCKED` does not escalate: a stronger model cannot supply a missing library module. The second proof session of a pass, including one after a final-audit FAIL, always runs with `model: "opus"`. Record the models used with `--models-used`.

   **When the final audit FAILs:**
   - Proof problem: return the FAIL items to pv-prover; this counts as one proof session.
   - Statement problem: hand it to pv-drafter for changes, have pv-gate review it again, then apply the "Cascade reset on statement change" of `PIPELINE.md`.
   - If the second final audit still FAILs: set `STOPPED` + `AUDIT_FAILED`.
5. **Suspected issues.** When any role reports a suspected paper issue:
   1. set the result to `stage: ISSUE_CHECK` and dispatch pv-issue-checker;
   2. decide the next step from the "Handling suspected issues" table of `PIPELINE.md`, based on `ISSUE VERDICT:` and on the verdict line of the review;
   3. set a confirmed issue to `STOPPED` + `ISSUE_RECORDED`; if neither of two reviews confirms it, set `STOPPED` + `ISSUE_UNCONFIRMED`.

   When there is a gap file, run the final audit on the gap file as usual, to confirm the part other than the gaps.
6. **Check outputs.** Check after every subagent returns; do not simply trust its reply. Run `python3 scripts/pv_status.py outputs <ID>`: in one call it prints the verdict lines of every report of `<ID>`, the last `EXIT=` line of each of its logs, and its files. Check:
   - whether the files exist;
   - whether the last `EXIT=` matches the reply;
   - whether the required verdict line is within the last 5 lines of the report.

   **Do not read whole reports** unless a verdict line is missing, contradicts the reply, or you need a specific section to decide the next step (for example the "Required changes" of a gate report); then read only that section. Record any mismatch truthfully, and have that agent correct it.
7. Update the records per §3, take a snapshot, and report per §4.
8. **End of a pass.**
   - For results still blocked by a predecessor, set `reason: WAITING_ON_DEPENDENCY`.
   - Then run `python3 scripts/pv_status.py next --second-pass`, give each listed result 1 proof session, and set its `round` to 2.
   - Results still not finished after the second pass stay UNFINISHED, with the reason recorded.

## 2. Task description templates

The role rules are in each subagent's definition; the task description contains only **information specific to this target**. Start subagents with the `Agent` tool, with `subagent_type` set to the role name.

**pv-drafter:**
```
Target <ID> (PDF <number> <kind>, label <label>).
Source: statement <file:line-line>; proof <file:line-line>; related definitions/conventions <file:line …>.
Predecessors: <ID…>. For those already FINAL_PASSED, import <module> directly; for those not yet proved, import <PredID>Stmt and write the consumed clause as <ID>_<PredID>Consumed: <state which sentence is used>.
Already-declared external parameters that can be reused: <name and the Stmt file it is in> (their owning results have been added to this result's depends_on). Parameters being declared by other drafters, which this result must not declare: <…>. Other external-input candidates: <from INVENTORY.md>. Points to note: <…>.
Outputs: pv_work/<ID>Stmt.lean, pv_work/<ID>Draft.lean (namespace Paper.<ID>), pv_work/notes/<ID>_draft_notes.md.
Stmt may be built; Draft is only checked. No network, no downloads.
```
Amendment mode: `Make the "Required changes" in verification/audits/<ID>_gate<…>.md one by one; make no other changes.`

**DEFS (shared definitions):**
- pv-drafter: `Shared-definitions mode: write pv_work/Defs.lean; source definition locations <file:line …>. Write only definitions; only check.`
- pv-gate: `Review whether the shared definitions pv_work/Defs.lean agree with the source <file:line …>; take a #pv_type_hashes_here snapshot; write the report to verification/audits/DEFS_gate.md.`

**pv-gate:**
```
Review the statement of <ID>: pv_work/<ID>Stmt.lean and pv_work/<ID>Draft.lean (draft notes pv_work/notes/<ID>_draft_notes.md).
Source: statement <file:line>; proof <file:line>; related definitions <file:line>. Read the source yourself.
Focus: <TFAs or doubts raised by the drafter>.
Output: verification/audits/<ID>_gate.md (the k-th time, write _gate_rk.md), containing the snapshots of both files. Do not modify the draft. No network, no downloads.
```
Amendment-check mode: `Check the amendments to <ID> made according to <previous gate report>, looking only at the changed parts; redo the snapshot and write it to <ID>_gate_r<k>.md.`

**pv-prover:**
```
Prove <ID>. Last gate report: verification/audits/<ID>_gate<…>.md (last line is PASS).
Source proof <file:line-line>. Proof session <1|2> of this pass; overall pass <1|2>.
Outputs: pv_work/<ID>.lean (and .olean); if any obligation stops, also pv_work/<ID>ModGaps.lean; notes pv_work/notes/<ID>_prover_notes.md.
No network, no downloads.
```
Reconnection mode: `Reconnect predecessors <P…> for X: write pv_work/<X>Closed_r<k>.lean (PIPELINE stage 6b). Main theorems of the predecessors: <pv_work/P.lean:line name…>; parameters used by X: <X>_<P>Consumed….`

**pv-auditor:**
```
Final audit of <ID>: <pv_work/<ID>.lean or <ID>ModGaps.lean> (notes pv_work/notes/<ID>_prover_notes.md; gate snapshot in <gate report>; DEFS snapshot in verification/audits/DEFS_gate*.md).
Source <file:line-line>. Infrastructure that already has individual audit records: <report paths>; audit the rest one by one.
Output: verification/audits/<ID>_final.md (the k-th time, write _final_rk.md). Do not modify the audited files. No network, no downloads.
```
There are three further modes; for their output paths and verdict lines, see `PIPELINE.md`:
- counterexample review: give the counterexample file, the ruling report and the source location;
- reasoning review: give the ruling report and the source location;
- reconnection audit: give `<X>Closed_r<k>.lean`, and the gate snapshots of X and of each predecessor.

**pv-issue-checker:**
```
Rule on suspected issue <n> of <ID>: <who reported it; original sentence file:line; current goal or question>.
Consumed instance: <the concrete parameters, kernel or order actually used>.
Output: verification/audits/<ID>_issue_<n>.md; if one can be constructed, write pv_work/<ID>_Counterexample<n>.lean. No network, no downloads.
```
Second time (after a review did not confirm): `Attached is the review report <…_audit.md>; rule again, addressing the problems it points out.`

## 3. Records to update after each milestone

**Use the scripts (v1.3).** One command writes the result's entry in `RESULTS.json`, fills in the latest gate and final report paths, rewrites its row and the header counts in `PAPER_VERIFICATION.md`, appends an `AUDIT.md` section with the verdict lines and sha256 of the evidence, and runs validate:

```
python3 scripts/pv_status.py record <ID> --verdict <V> --stage <S> [--reason <R>] [--statement-fixed true] \
    [--conditions A,B] [--gaps …] [--issues B3] [--upstream-issues …] [--debts "…"] [--unencoded "…"] [--partial "…"] \
    [--lean-main "pv_work/<ID>.lean:<line> <full name>"] [--models-used sonnet,opus] \
    [--summary-en "…"] [--row "text of the checklist row"] [--audit-note "reviewer, FAIL items, assessment"]
python3 scripts/pv_status.py add-tool '<JSON object with the fields of _example_tool>'    # each external input, once
```

The judgements (verdict, conditions, codes, summaries) are yours, as below; the scripts only write, count and look up paths.

**After a revision** (the result has a `history` entry, see `/pv-revise`): if the re-run gives it a verified verdict and the earlier issue is gone in the new statement and proof, add `--resolve <B…>` to `record`. The script marks those issues `RESOLVED`, citing the new final audit, and refuses if the final audit is still the one from before the revision. If the problem is still there, keep the issue open (update its line numbers) and record ISSUE as usual. Edit files by hand only for what the scripts do not cover (`BLOCKERS.md`, `EXTERNAL_TOOLS.md` prose, `RESUME.md`).

1. `verification/RESULTS.json` (the entry for this result):
   - `stage`, `reason`: per the stage table of `PIPELINE.md`;
   - `statement_fixed`, `round`, `verdict`;
   - `conditions`: the IDs of the external parameters and (p) clauses; each must first be registered in `external_tools`, with the fields of `_example_tool`; IDs must not repeat;
   - `gaps`: gap IDs, **not** registered in `external_tools`;
   - `issues`: this result's own B numbers; `upstream_issues`: the B numbers of predecessor results;
   - `debts`, `unencoded`, `partial`;
   - `lean_main`: `pv_work/<file>.lean:<line> <full theorem name>`;
   - `evidence`: one path each for `gate`, `final`, `reconnect` (the latest one); `issues` may be a list;
   - `summary_en` (one sentence);
   - `updated` (obtained with `date`).

   **Verdicts follow `VERDICTS.md` §1**; the final audit only gives a suggestion:
   - if this result itself has a confirmed, unclosed paper-side issue, record ISSUE;
   - otherwise, if it has conditions, debts or parts not encoded, record CONDITIONAL;
   - only if it has none of these, record UNCONDITIONAL;
   - a result with gaps can only be ISSUE or UNFINISHED.
2. `verification/PAPER_VERIFICATION.md`: the row for this result, and the **header counts**. validate checks the header counts.
3. `verification/BLOCKERS.md`:
   - write a new issue from the template as `## B<n> — <ID> / <PDF number> — <main class code>`; the ID in the heading must be the ID of **this result**;
   - for a resolved issue, add `— RESOLVED (date)` to the heading; do not delete the original text;
   - unconfirmed suspected issues are not registered here; write them into the "Human-check to-do list" in `RESUME.md`.
4. `verification/EXTERNAL_TOOLS.md`: write the detailed explanations. Generate the table with `python3 scripts/pv_status.py tools`.
5. `verification/AUDIT.md`: append a paragraph containing the reviewer, date, output sha256, verdict line and key points.
6. `verification/RESUME.md`: current position, running subagents, next step, scope, human-check to-do list.
7. Run `python3 scripts/pv_status.py validate` (`record` already does), which **must be VALID**, then run `python3 scripts/pv_snapshot.py save --label <ID>`.
8. **File changes.** Move obsolete files away with `python3 scripts/pv_status.py supersede <file> "<reason>" [<replacement>]`. After a module is rebuilt, the `pv_work` modules that depend on it must be rebuilt too. When a gated statement changes, apply the "Cascade reset on statement change" of `PIPELINE.md`.

## 4. Reporting to the user (at every stage)

- **After each subagent returns**: one or two sentences saying who finished what, what the result was, and what comes next.
- **After each result gets a verdict**: one paragraph, with the **progress table** (`python3 scripts/pv_status.py table`), so that it can be screenshotted and shared.
- **When a paper issue is found**: state the result number, the location of the original sentence, the classification, and whether it threatens the conclusion.

The user may leave at any time, and the usage quota may run out at any time, so keep `RESUME.md` up to date at all times.

## 5. Keeping the coordinator's context small (v1.3)

Every step of a long session re-reads the whole history, so a long coordinator session gets more expensive with every result.
- Unattended runs: prefer `scripts/pv_drive.sh`, which starts a fresh headless session for each batch of at most 3 ready results (the kit's docs/MANUAL.md, section 3).
- Interactive runs: after every 3 verdicts, make sure `RESUME.md` is current and tell the user they can type `/clear` and then `/pv-resume` to continue in a fresh context at no loss.

## 6. Interruption and resumption

- When a subagent is interrupted by the usage quota or a rate limit, first check its output files (all reports are written incrementally). If it can continue, use SendMessage to have it continue from where it stopped; if not, start a new agent and give it the path of the partial output.
- Do not redo work that has already passed.

## 7. Finish

When every result in scope has a verdict, or is UNFINISHED with the reason recorded:
- update `RESUME.md`;
- take a snapshot `--label all-verdicts`;
- report to the user: the four counts, the progress table, the main issues, the human-check to-do list, and recommend running `/pv-report`.
