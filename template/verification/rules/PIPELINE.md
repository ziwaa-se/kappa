# Pipeline: the stages, outputs and acceptance criteria for each numbered result (v1.3.1)

## Stages and reasons (`stage` and `reason` in `RESULTS.json`)

Each stage allows only the reasons listed in the table below. `pv_status.py validate` checks every entry.

| `stage` | Meaning | Allowed `reason` |
|---|---|---|
| `NOT_STARTED` / `INVENTORIED` | Registered, not yet drafted | empty; `WAITING_ON_DEPENDENCY` (a predecessor has still not passed the gate at the end of a pass); `SOURCE_CHANGED` (reset after a revision) |
| `STATEMENT_DRAFTED` | Draft written, waiting for or undergoing the gate | empty |
| `GATE_PASSED` | Statement has passed the gate; also set `statement_fixed: true` | empty |
| `PROVING` | Proof in progress | empty |
| `PROVED` | Proved, waiting for the final audit | empty; `AUDIT_PENDING` |
| `FINAL_PASSED` | Final audit passed | empty |
| `ISSUE_CHECK` | From dispatching the issue ruling until the review is finished | empty |
| `STOPPED` | Stopped; **must** have a reason | `GATE_FAILED`, `TRANSLATION_BLOCKED`, `BUDGET_EXHAUSTED`, `AUDIT_FAILED`, `ISSUE_RECORDED`, `ISSUE_UNCONFIRMED` |

How the stop reasons differ:

| Reason | Meaning |
|---|---|
| `TRANSLATION_BLOCKED` | **Formalization-side obstacles** such as a missing Lean interface or a missing mathlib module |
| `BUDGET_EXHAUSTED` | A single obligation made no progress in 4 consecutive attempts in each of the two proof sessions of a pass (the second on the stronger model), or the proof sessions are used up |
| `GATE_FAILED` | The gate gave FAIL twice |
| `AUDIT_FAILED` | The final audit gave FAIL twice |
| `ISSUE_RECORDED` | A registered paper issue, confirmed by review |
| `ISSUE_UNCONFIRMED` | Neither of two reviews of the suspected issue confirmed it |

Mapping between verdicts and stages:
- UNCONDITIONAL and CONDITIONAL must be `FINAL_PASSED`.
- ISSUE is `STOPPED` + `ISSUE_RECORDED`.
- Everything else is UNFINISHED.

**Rounds: do not mix up these two:**
- **Session**: within one pass, at most 2 subagents may be started for the same role on each result, i.e. 2 drafting, 2 proving and 2 final-audit sessions. Proving one step according to a FAIR_IMPLICIT_STEP fill-in counts as one proof session; if both have already been used, it is pushed to the second pass.
- **Pass** (`round` is 1 or 2):
  - The first pass goes through all results in dependency order.
  - The second pass handles only results that are `STOPPED` with reason `TRANSLATION_BLOCKED`, `BUDGET_EXHAUSTED` or `AUDIT_FAILED`, giving each at most 1 more proof session (`pv_status.py next --second-pass`).
  - At the end of each pass, results that still cannot start because of a predecessor get `reason: WAITING_ON_DEPENDENCY`.
  - Results still unfinished after the second pass stay UNFINISHED and are not retried automatically.

## Files and naming

Result `T01` is used as the example. The second and later reports get `_r2`, `_r3`; they **do not overwrite** the previous report.

| Output | Path | Writer |
|---|---|---|
| **Statement definition file** (no `sorry`; only `def` and `structure`, no `theorem`) | `pv_work/T01Stmt.lean` | pv-drafter |
| Statement draft (`import T01Stmt`, theorems with `sorry`) | `pv_work/T01Draft.lean` | pv-drafter |
| Drafting notes | `pv_work/notes/T01_draft_notes.md` | pv-drafter |
| Statement gate report | `verification/audits/T01_gate.md` (`_gate_r2.md` …) | pv-gate |
| Proof file | `pv_work/T01.lean` (and `.olean`) | pv-prover |
| Gap file (when there are stopped obligations) | `pv_work/T01ModGaps.lean` (and `.olean`) | pv-prover |
| Proof notes | `pv_work/notes/T01_prover_notes.md` | pv-prover |
| Final audit report | `verification/audits/T01_final.md` (`_final_r2.md` …) | pv-auditor |
| Issue ruling, counterexample | `verification/audits/T01_issue_<n>.md` (the second one is `T01_issue_<n>_r2.md`), `pv_work/T01_Counterexample<n>.lean` | pv-issue-checker |
| Counterexample review or reasoning review | `verification/audits/T01_issue_<n>_audit.md` (for the second ruling, `T01_issue_<n>_r2_audit.md`) | pv-auditor |
| Predecessor reconnection | `pv_work/T01Closed_r<k>.lean`; the audit is written to `verification/audits/T01_reconnect_r<k>.md` | pv-prover; pv-auditor |
| Mechanical audit checks | `verification/audits/T01_mech.md` (`_mech_r2.md` …), written by `scripts/pv_audit_mech.py` | pv-auditor runs it |
| Re-check after a revised upstream result whose statement did not change (v1.3.1) | `verification/audits/T01_recheck.md` (`_recheck_r2.md` …) | pv-auditor |
| Files of a result that was reset after revision `<k>` (v1.3.1) | `pv_work/superseded/rev<k>/`, `verification/audits/rev<k>/` (moved there by `pv_status.py reset`; `T01Stmt.lean` stays in place and a copy is kept) | `pv_status.py` |
| Probes | `pv_work/probes/<role>/<ID>/<role>_<ID>_<purpose>.lean` | each role writes only its own directory |
| Compilation logs | `pv_work/logs/<name>_<k>.log` | `pv_lean.sh` |
| Stale files | `pv_work/superseded/` (`python3 scripts/pv_status.py supersede …`) | **coordinator** |

**Namespace and name-clash rules:**

All Lean files for a result go in `namespace Paper.<ID>`. If a dependent result redeclares a predecessor's names, the imports clash at reconnection (this has been tested). So follow these rules:

- Definitions used in the statement, including the conclusion structure, external parameters and consumed clauses, are **declared only once, in `<ID>Stmt.lean`**. After gate PASS, the coordinator builds `<ID>Stmt.lean` immediately.
- Later files and the results that depend on it all `import <ID>Stmt` and **do not redeclare**.
- When an external parameter first appears, put it in the `Stmt` file of the result at hand; later results import it and reuse the same definition.
  - **Reuse creates a dependency.** The coordinator must add the result that owns the parameter to the reuser's `depends_on`, so that `next` waits until the owner's statement has passed the gate before releasing the reuser.
  - When two parallel drafters need **the same new** parameter, the coordinator lets only one of them declare it; the other waits to draft until the first one's gate has passed.
- A predecessor's consumed clause is named `<ID>_<PredID>Consumed`, carrying the consumer's prefix so that two consumers do not clash. It may use only names from `Defs*.lean` and the predecessor's `<PredID>Stmt.lean`, or fully unfolded content.

## Verdict lines in reports

Every report must contain its verdict line within its **last 5 lines**; the scripts validate against this.

| Report | Verdict line |
|---|---|
| gate | `STATEMENT GATE: PASS`, `STATEMENT GATE: PASS_WITH_AMENDMENTS` or `STATEMENT GATE: FAIL` |
| final audit | `FINAL AUDIT: PASS` or `FINAL AUDIT: FAIL`, then `SUGGESTED VERDICT: UNCONDITIONAL / CONDITIONAL / ISSUE / UNFINISHED`, then (v1.3.1) `CONDITIONS: <ids of external_tools, comma-separated>` or `CONDITIONS: none`: the parameters the verified theorems really use (item 11 of the mechanical report, confirmed by the auditor). `pv_status.py record` takes the result's conditions from this line |
| issue ruling | `ISSUE VERDICT: <classification code>`, followed on the next line by `THREATENS CONCLUSION: yes / no` |
| counterexample review | `COUNTEREXAMPLE VALID` or `COUNTEREXAMPLE INVALID` |
| reasoning review | `REVIEW: CONFIRMED` or `REVIEW: NOT CONFIRMED` |
| predecessor reconnection | `RECONNECT AUDIT: PASS` or `RECONNECT AUDIT: FAIL`, then (v1.3.1) `CONDITIONS: …` with the complete set after reconnection |
| re-check (v1.3.1) | `RECHECK: PASS` or `RECHECK: FAIL` |

---

## Stage 0: inventory (`/pv-setup`, pv-architect)

- **Outputs**: `verification/INVENTORY.md` and `results` in `RESULTS.json`.
- **Preparation done at the same time:**
  - `source/` is copied to `verification/source_baseline/`, for comparison by `/pv-revise`;
  - the sha256 of `PVTools.lean` is recorded in `lean.pvtools_sha256` in `RESULTS.json`. If the review tools are changed, validate reports an error.
- **Acceptance**:
  - validate prints VALID;
  - the dependency graph is acyclic;
  - every numbered result is registered;
  - definitions and assumptions are listed separately and do not count as numbered results.

## Stage 1: shared definitions (`DEFS`)

1. If the paper has no definitions that need to be shared, register `{"id": "NONE"}` in `defs` and skip this stage.
2. pv-drafter writes `pv_work/Defs.lean`: definitions only, no theorems, each definition with its source location.
3. pv-gate reviews it and writes the report to `verification/audits/DEFS_gate.md`, including a `#pv_type_hashes_here` snapshot.
4. After gate PASS, the coordinator runs `scripts/pv_lean.sh build Defs` and registers `id`, `file`, `gate`, `built` in `defs`.
5. Definitions have no proofs and need no separate final audit. But **every final audit must rerun `#pv_type_hashes` on `Defs*`** and compare it with the DEFS gate snapshot.
6. When new definitions are needed later, write a new file `Defs2.lean` etc., which also goes through the gate. `Defs*.lean` files that have passed the gate are not modified again.

## Stage 2: statement drafting (pv-drafter)

- **`<ID>Stmt.lean`**: every `def` and `structure` used in the statement, including the conclusion structure, external parameters `def Tool : Prop`, and consumed clauses `def <ID>_<PredID>Consumed : Prop`. Requirements:
  - no `sorry`, no theorems;
  - each item carries its source location, provenance type and search evidence;
  - external parameters already declared in another `Stmt` file are imported directly, not redeclared.
- **`<ID>Draft.lean`**:
  - `import <ID>Stmt`;
  - the main theorem matches the source clause by clause;
  - step obligations S1…Sk are written as `theorem … := by sorry`, each with the source `file:line`, the original sentence, and its role.
- **Predecessor results:**
  - If the predecessor is already `FINAL_PASSED`, `import` its module and call its main theorem.
  - Otherwise import only `<PredID>Stmt`, and write the consumed clause as a (p) parameter. The notes state where the clause is located in the predecessor, and how its applicability conditions are satisfied in this result.
- **Use `build` for `<ID>Stmt.lean`** (it contains no `sorry`, and the draft imports its `.olean`); **only `check` `<ID>Draft.lean`**. Then write the drafting notes.

## Stage 3: statement gate (pv-gate)

- Item-by-item review; see the `pv-gate` definition. The review covers both `<ID>Stmt.lean` and `<ID>Draft.lean`.
- **Snapshot**: run `#pv_type_hashes_here` separately on a **copy** of each of the two files, and put the output in the report. Copies are used so that the snapshot corresponds to the text the gate actually read, not to an `.olean` compiled earlier.
- Verdicts:
  - **PASS**: the coordinator sets `statement_fixed: true` and reruns `build <ID>Stmt`, so that the `.olean` matches the text the gate read.
  - **PASS_WITH_AMENDMENTS**: pv-drafter makes the changes item by item as the report specifies; pv-gate checks them, takes a new snapshot, and writes `_gate_r2.md`, whose last line is PASS. **Proving may start only after PASS.**
  - **FAIL**: return it to the drafter, for at most 2 sessions. If it still FAILs, set `STOPPED` + `GATE_FAILED`.

## Stage 4: proof (pv-prover)

- Copy the draft to `pv_work/<ID>.lean` using Read/Write, not `cp`. **Gated declarations are never changed.**
- Prove strictly along the source route. Private helper lemmas may be used only for technical conversions.
- **Infrastructure budget**: when the auxiliary material for a single step clearly goes beyond technical conversion (a body of general theory that is not in the source, or more than about 150 lines of auxiliary code for a single step), stop and report; the gate decides whether to turn it into a (v) parameter. Turning it into a parameter changes the statement, so it must be re-gated.
- **Steps with insufficient support in the source:**
  - Do not look for an alternative proof; the obligation keeps its `sorry` in `<ID>.lean`; report the suspected issue.
  - Also write a **gap file** `pv_work/<ID>ModGaps.lean`. It is a copy of `<ID>.lean` with only three kinds of change allowed:
    1. Each stopped obligation `S<k>` is replaced by `def <ID>_S<k>_Gap : Prop := <full ∀-closure of the type of S<k>>`. The closure must include variables introduced by `variable` and auto-bound implicit arguments.
    2. Any other obligation `S<j>` whose proof directly or indirectly **uses a stopped obligation** gets a `(hGap_k : <ID>_S<k>_Gap)` premise in front, and is listed as "gap-dependent" in the proof notes.
    3. The main theorem is renamed `<main_theorem_name>_mod_gaps`, with the needed Gap premises added in front.
  - The gap file must be built, so that the final audit can review everything except the gaps.
- **Budget** (v1.3):
  - Within one proof session, if a single obligation makes no progress in **4** consecutive "edit → compile" cycles, stop that obligation and record `BUDGET_EXHAUSTED` with the stuck goal and the directions tried.
  - The first proof session runs on the model in the pv-prover definition (sonnet). The coordinator gives `BUDGET_EXHAUSTED` obligations a second session on the stronger model (`model: "opus"` in the `Agent` call), which starts from the first session's notes and has another 4 cycles per obligation. An obligation still stuck after that is written as a gap and the result is recorded `BUDGET_EXHAUSTED`.
  - If a library interface is missing, record `TRANSLATION_BLOCKED`; this never escalates to a stronger model.
  - At most **2** proof sessions per result per pass; the second one always runs on the stronger model.
- **On completion**:
  - `pv_lean.sh build <ID>` or `build <ID>ModGaps` exits with code 0;
  - the axiom check and fingerprint comparison have been done;
  - the proof notes are written.

## Stage 5: independent final audit (pv-auditor)

Item-by-item check; see the `pv-auditor` definition. Items 1–4 and 8, and the first level of 5, are run by the auditor itself with one command, `python3 scripts/pv_audit_mech.py <ID>` (v1.3), which writes `verification/audits/<ID>_mech.md`; the auditor's own work is the judgement that remains.
1. compile independently; privately rebuild with `pv_lean.sh rebuild` and compare;
2. fingerprints match the gate snapshot, covering `<ID>Stmt`, the main file and `Defs*`;
3. axioms and `sorryAx`;
4. per-theorem conditionality;
5. item-by-item review of infrastructure;
6. route fidelity;
7. non-vacuity;
8. the sha256 of `PVTools.lean` matches the record;
9. verdict lines.

**How to check the "exact statement"**, tested in practice by the re-review; see `VERIFICATION_METHODS.md` §2b:
- **Gap file**: in a probe, copy the gated version of the main theorem verbatim (`by sorry`); first confirm that its `th` equals the gate snapshot, then check with `example (g… : …_Gap) : type_of% @<copied_main_theorem> := <main_theorem>_mod_gaps g…`. Check each "gap-dependent" obligation the same way.
- **Reconnection file**: X's main theorem puts its (p) parameters first; `main_closed` puts the conditions of each predecessor first. Then check `example (predecessor_conditions…) : type_of% @<X>.main = (<X>_<P>Consumed → type_of% (<X>.main_closed predecessor_conditions…)) := rfl`. If the predecessor is unconditional, there are no arguments.

## Stage 6: recording (coordinator)

Update the following files, then run validate (must be VALID), take a snapshot, and report to the user. `python3 scripts/pv_status.py record` writes the `RESULTS.json` entry, the `PAPER_VERIFICATION.md` row and header counts and an `AUDIT.md` section, and `add-tool` registers external inputs (v1.3); the verdict and every other judgement stay with the coordinator:
- `RESULTS.json`: stage, reason, pass number, verdict, conditions, gaps `gaps`, issues, upstream issues `upstream_issues`, not-encoded parts, evidence, `lean_main`;
- `PAPER_VERIFICATION.md`: the row for this result, and the header counts;
- `BLOCKERS.md`;
- `EXTERNAL_TOOLS.md` and `external_tools`: external parameters and (p) consumed clauses; **gaps are not registered**;
- `AUDIT.md`;
- `RESUME.md`.

## Stage 6b: predecessor reconnection

(v1.3.1) The same applies to a (iv) clause with a `predecessor`, once a revision has resolved that predecessor's issue and it is verified: `python3 scripts/pv_status.py reconnect` lists both kinds.

After a predecessor result P becomes `FINAL_PASSED` (UNCONDITIONAL or CONDITIONAL), for each result X that is still conditional on `<X>_<P>Consumed` and is itself `FINAL_PASSED` + CONDITIONAL (listed by `pv_status.py reconnect`):

1. pv-prover writes `pv_work/<X>Closed_r<k>.lean`:
   - one reconnection covers **all predecessors that can currently be reconnected**; when more predecessors are proved later, write `r<k+1>`.
   - in it, `theorem <X>_<P>Consumed_holds (P_conditions…) : <X>_<P>Consumed` is derived from P's main theorem;
   - `theorem main_closed (predecessor_conditions…) (other_X_conditions…) : <statement_of_X>` is assembled from X's main theorem and the theorems above.
2. pv-auditor reviews it and writes `<X>_reconnect_r<k>.md`, covering:
   - confirmation that the statements match, using the `rfl` method of §5;
   - the axiom check;
   - the full set of conditions after reconnection.
3. The coordinator updates X:
   - conditions become "X's other conditions ∪ P's conditions";
   - `lean_main` points to `main_closed`;
   - `evidence.reconnect` points to the audit report;
   - if all conditions have disappeared, X becomes UNCONDITIONAL.
4. **`RECONNECT AUDIT: FAIL`**: give pv-prover one fix session; if it still FAILs, X keeps its original (p) conditions, and the reason is recorded.
5. **P ends up ISSUE or UNFINISHED**: X keeps its (p) conditions; the report treats them as (iv) and lists them in the class most in need of human check. If X itself is ISSUE, no reconnection is done.

## Handling suspected issues: the next step depends on the classification

When pv-issue-checker is dispatched, set the result to `stage: ISSUE_CHECK`. Then continue according to the `ISSUE VERDICT:` it gives:

| Ruling | Next step |
|---|---|
| Paper-side class, **with Lean evidence** | pv-auditor counterexample review |
| Paper-side class, **reasoning only** | pv-auditor reasoning review |
| Review gives `COUNTEREXAMPLE VALID` or `REVIEW: CONFIRMED` | Register the paper-side issue in `BLOCKERS.md`, set the result to `STOPPED` + `ISSUE_RECORDED`, verdict ISSUE. If the gap file has already passed the final audit, point `evidence.final` to that final audit report, and state in `partial` which clauses, apart from the gaps, are verified |
| Review gives `COUNTEREXAMPLE INVALID` or `REVIEW: NOT CONFIRMED` | Return it, with the review report, to pv-issue-checker, **once**. If still unconfirmed: set `STOPPED` + `ISSUE_UNCONFIRMED`, verdict UNFINISHED; put the suspected issue on the human-check list, labeled "reasoning, unconfirmed"; **do not** register it as a paper-side issue |
| `FAIR_IMPLICIT_STEP` | Return to pv-prover to prove the step using the stated fill-in; the gap then disappears; then run the final audit as usual |
| `ENCODING_ERROR` | Run `python3 scripts/pv_status.py reset <ID> --revision enc<n> --reason ''` (v1.3.1: it keeps the old gate snapshot for the comparison and marks the dependents), return to **pv-drafter** to fix the statement, have **pv-gate** review it again, and record the pass with `record <ID> --stage GATE_PASSED --statement-fixed true`: the "cascade reset on statement change" below then decides for the dependents |
| `TRANSLATION_BLOCKED` | Set `STOPPED` + `TRANSLATION_BLOCKED`, and leave it for the second pass |

## Cascade reset on statement change

`ENCODING_ERROR` fixes, revisions of the source manuscript (`/pv-revise`) and similar cases all use the same rule (v1.3.1).

**Why one level at a time.** A result consumes only the *statements* of the results it imports: their definitions and main theorems. If a result D is re-proved but its gated statement stays the same, every result Q that imports D still consumes exactly what it consumed before. Q's proof stays valid; only its compiled module must be rebuilt against the new D. So a reset spreads to the next level only through a statement that really changed, and the decision is made by comparing gate snapshots, not by guessing from the text.

1. **Reset the changed results.** For each result P whose statement, proof or used definition changed: `python3 scripts/pv_status.py reset P [P …] --revision <k>`. This keeps P's previous verdict, issues and evidence in its `history`, sets `stage: INVENTORIED` (with `reason: SOURCE_CHANGED` for a revision), clears `conditions`, `gaps`, `issues`, `upstream_issues`, `evidence`, `lean_main` and `partial`, sets the verdict to UNFINISHED, and moves P's old proof files and review reports to `pv_work/superseded/rev<k>/` and `verification/audits/rev<k>/` (`PStmt.lean` stays in place for the drafter, and a copy is kept).
2. **Mark, do not yet reset, the direct dependents.** The same command marks every result that consumes P directly (it imports P's module or `<P>Stmt`, uses a `<X>_<P>Consumed` clause, or has a `Closed` file referring to P) with `recheck: pending`. Their verdicts stand until the decision in step 3; the table and the report show them as awaiting a re-check.
3. **Decide when P passes its gate again.** Record the gate pass with `python3 scripts/pv_status.py record P --stage GATE_PASSED --statement-fixed true`. The script compares the fingerprints of P's definitions and main theorem in the new gate snapshot with the snapshot from before the reset:
   - **unchanged:** each waiting dependent keeps its verdict and gets `recheck: rebuild`. Once P is proved again (`FINAL_PASSED`), `pv_status.py next` lists it as `RECHECK`: rebuild its modules in dependency order, then pv-auditor runs the mechanical checks in re-check mode and writes `<ID>_recheck.md` ending `RECHECK: PASS` or `RECHECK: FAIL`. Record a pass with `record <ID> --recheck-passed`; after a fail, reset the result.
   - **changed:** the waiting dependents are reset as in step 1, and their own direct dependents are marked in turn.
   If the gate pass was recorded another way, run `python3 scripts/pv_status.py cascade P` to make the same decision. `reset --cascade-now` resets the dependents at once, without waiting for the comparison.
4. **Order.** Redraft, re-gate, re-prove and re-audit in dependency order. When a module is rebuilt, its downstream modules must be rebuilt too (a rebuild changes no verdict by itself).

A shared definition that changed is a changed statement for every result that uses it (`uses_defs`, see `/pv-revise`).

## Final stage (`/pv-report`)

1. **Compilation**: pv-compiler compiles, read-only.
2. **Correct the records**: the coordinator first verifies things itself, then corrects the records.
3. **Write the reports**: write the three reports from the templates, and update `DOC_ERRATA.md`.
4. **Fact check**: pv-factcheck checks independently, and the coordinator makes the corrections. The first draft before correction is saved as `verification/report/work/AUTHOR_REPORT_v1.md`.
5. **Path check**: after the fact check, run `python3 scripts/pv_status.py paths …` on the three reports; there must be no MISSING.
