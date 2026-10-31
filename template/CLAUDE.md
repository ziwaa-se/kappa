# Faithful checking of TeX source proofs (KAPPA)

This project translates the **already-written proofs** in `source/` faithfully into Lean 4, actually compiles them, and gives each numbered result one of four verdicts:

- **Verified unconditionally (UNCONDITIONAL)**: the source proof passes completely, with no external parameters.
- **Verified conditionally (CONDITIONAL)**: the source proof passes, but depends on visible parameters (cited literature results, facts the source does not prove, predecessor clauses).
- **Issue recorded (ISSUE)**: there is a counterexample, a step that does not follow, a missing condition, an exposition gap, or a domain ambiguity.
- **Unfinished (UNFINISHED)**: no conclusion yet; **never counted as a paper error**.

Do not repair proofs, do not look for new proof methods, do not change the source.

## Must read before any work

The rules in `verification/rules/` are binding for everyone. To save tokens (v1.3), each subagent carries a **rule card** with the excerpts its role needs and opens the rules files only when a situation calls for them. The coordinator reads:

1. `verification/rules/PIPELINE.md`: the stages each result goes through, their outputs and acceptance criteria.
2. `verification/rules/VERDICTS.md` §1 and §5: the four verdicts and the reporting rules.
3. `verification/RESUME.md`: **the current position**. Do not rely on chat memory.
4. `verification/REVISION_BRIEF.md`, **if it exists** (v1.3.1): what a revision or an imported earlier check changes about this project (ID mapping, reused modules, what may be reused and what must be redone). It takes precedence over habits, not over the rules.

and, when needed, `POLICY.md` (working constraints), the rest of `VERDICTS.md` (issue classification, external parameters), `VERIFICATION_METHODS.md` (commands) and `LESSONS.md` (known pitfalls).

## The ten most important rules

1. **Faithfulness.** Every Lean step corresponds to a `file:line` in the source. When the source gives no justification for a step, stop and record it; do not fill it in yourself.
2. **External results are written as visible parameters.**
   - Content that the source cites or silently uses but that this project does not prove is written as `def Tool : Prop`, used as an explicit hypothesis, and registered in `verification/EXTERNAL_TOOLS.md`;
   - never written as an `axiom`;
   - "mathlib does not have it" must come with `#check` evidence.
3. **Three "is not"s:**
   - a compilation failure is not a paper error;
   - a partial pass is not a pass of the whole item;
   - a conditional theorem is not an unconditional theorem.
4. **Axioms and drafts.** Only `propext`, `Classical.choice`, `Quot.sound` are allowed. Forbidden: `sorry` (except in drafts), `admit`, `axiom`, `unsafe`, `native_decide`, `implemented_by`, `@[extern]`, `debug.skipKernelTC`. Drafts with `sorry` do not produce an `.olean`.
5. **Independent review.** A statement must first pass the independent gate (`pv-gate`) before it is proved; after the proof is complete it goes through the independent final audit (`pv-auditor`). Each role is a new subagent; **self-review is not allowed**.
6. **Each issue must state which side is at fault:**
   - paper side: `ERROR`, `PAPER_ARGUMENT_GAP` (the proof is written wrong), `PAPER_ASSUMPTION_GAP` (a condition is missing), `EXPOSITION_GAP`, `DOMAIN_CLARIFICATION`;
   - formalization side: `ENCODING_ERROR`, `TRANSLATION_BLOCKED`. Formalization-side problems never count as paper problems.
7. **No network, no downloads**, unless the user explicitly permits it in chat; this covers Python, shell and Lean code too. Do not modify `source/`, and do not modify files outside the project. Run the kit's scripts exactly as `scripts/pv_lean.sh …` or `python3 scripts/<script>.py …` from the project root, one command per call (`POLICY.md` §4); unattended runs refuse other spellings.
8. **Automatic progress.** The user has authorized continuous progress through all numbered results. When a problem is found, record it and continue; the user checks and fixes it by hand. At every milestone, update `RESUME.md`, take a snapshot, and report to the user with an English progress table. Wait for subagents through their completion notifications, never with timers or `sleep` (v1.3.1).
9. **Do not use grep to judge** "whether sorry or some theorem is used"; use `#pv_axioms` / `#pv_walk`. Get timestamps with `date`.
10. **Summaries written by the coordinator must pass an independent fact check before delivery.** While external parameters remain, do not claim full verification of the whole paper.

## Roles (`.claude/agents/`)

| Subagent (model, v1.3) | What it does | Where it writes |
|---|---|---|
| `pv-architect` (sonnet) | Inventory of the whole paper: numbered results, dependencies, definitions, external citations | `verification/INVENTORY.md`, first draft of `RESULTS.json` |
| `pv-drafter` (sonnet) | Drafts statement definitions and step obligations (with `sorry`), and shared definitions | `pv_work/<ID>Stmt.lean`, `pv_work/<ID>Draft.lean`, `pv_work/notes/`, `probes/drafter/<ID>/` |
| `pv-gate` (opus) | Independent statement review before proving | `verification/audits/<ID>_gate.md` |
| `pv-prover` (sonnet; second session opus) | Proves along the source route, within a budget; writes gap files and reconnection files | `pv_work/<ID>.lean`, `<ID>ModGaps.lean`, `<ID>Closed_r<k>.lean`, `pv_work/notes/`, `probes/prover/<ID>/` |
| `pv-auditor` (opus) | Independent final audit after proving, infrastructure audit, counterexample audit | `verification/audits/<ID>_final.md` etc. |
| `pv-issue-checker` (opus) | Bounded ruling on suspected paper issues; constructs Lean counterexamples | `verification/audits/<ID>_issue_<n>.md` |
| `pv-compiler` (sonnet) | Compiles material for the final report (read-only) | `verification/report/work/` |
| `pv-factcheck` (opus) | Independent fact check of the report (read-only) | `verification/report/work/factcheck.md` |

**The main session is the coordinator**: it assigns work, checks outputs (`python3 scripts/pv_status.py outputs <ID>` shows the real `EXIT=` and verdict lines), writes the record files (`pv_status.py record`), and reports to the user. The main session does not write proofs and does not substitute for review. A Sonnet-class model is enough for it.

## Common commands (`/` skills)

- `/pv-setup`: initialize; inventory the whole paper and build the checklist.
- `/pv-run`: proceed automatically in dependency order until every result has a verdict.
- `/pv-status`: English progress table.
- `/pv-resume`: continue after an interruption or after the usage limit ran out.
- `/pv-report`: final report, external-input check worksheet, list of files for human check, plus the fact check.
- `/pv-revise`: after a new version of the source manuscript, reset only the affected results.
- **When the user says they checked a condition** (an external input), record exactly what they stated: `python3 scripts/pv_status.py human-check <ID> --by "<who>" --how "<against what>"`. Never infer a check the user did not state. The result stays CONDITIONAL (`VERDICTS.md` §1.2).
- **When the user says a condition can be proved now** (v1.5; e.g. they found the Mathlib lemma, or built the Mathlib module that its search note calls `in source, not built`), record it: `python3 scripts/pv_status.py provable <ID> --why "<what they said>"`. `pv_status.py reconnect` then lists the results that use it (`PIPELINE.md` stage 6b). Never build library modules yourself.
- **After a revision**, `python3 scripts/pv_status.py followup` shows each re-checked result's verdict before and after, and the status of its earlier issues.
- `scripts/pv_drive.sh` (outside Claude Code, in a terminal): runs `/pv-run` unattended in fresh short sessions, which keeps the coordinator's context small. `python3 scripts/pv_usage.py` shows where the tokens went.

**When the user makes the same request in natural language** (e.g. "start", "continue", "read verification/RESUME.md and continue", "show progress", "make the report", "the manuscript changed"), read the corresponding `.claude/skills/<name>/SKILL.md` with the Read tool, then carry out its steps yourself. These skills are marked for user invocation only, so the Skill tool refuses to start them; reading the file and following it when the user asks is the intended way, not a workaround.

**Permissions:** during automatic progress, every command may trigger a confirmation prompt. The user can enable the suggested permissions in `.claude/settings.example.json` themselves (see the kit's `docs/MANUAL.md`, section 2, step 4). **Do not** modify permission settings on the user's behalf.

## Directories

```
source/            source manuscript (read-only)
pv_work/           Lean workspace (each result in namespace Paper.<ID>): Defs*.lean, <ID>Stmt.lean, <ID>Draft.lean, <ID>.lean,
                   <ID>ModGaps.lean, <ID>Closed_r<k>.lean, PVTools.lean (audit tool, do not modify),
                   probes/<role>/<ID>/, logs/, notes/, superseded/
verification/      persistent records: RESULTS.json, PAPER_VERIFICATION.md, BLOCKERS.md, AUDIT.md, EXTERNAL_TOOLS.md,
                   DOC_ERRATA.md, INVENTORY.md, RESUME.md, audits/, report/, rules/, snapshots/, source_baseline/
scripts/           pv_lean.sh (compile), pv_status.py (status, progress table, record keeping), pv_snapshot.py (snapshots and hashes),
                   pv_audit_mech.py (mechanical audit checks), pv_drive.sh (unattended driver), pv_usage.py (token use),
                   pv_graph.py (verification graph), pv_summary.py (one-page summary), pv_export.py (standalone Lean project)
```
