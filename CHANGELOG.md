# Changelog

## Planned

Not yet available; see the README's [Roadmap](README.md#roadmap). This version only verifies proofs that are already written.

- **Version 2: other language models** through their APIs, besides Claude Code, so that the kit can be used without a Claude subscription.
- **Version 2: fully local checks** with a model running on your own machine, so that an unpublished manuscript never leaves it.
- **Repair mode:** after an issue is confirmed, propose a correction, verify it in Lean within attempt and time limits, pass it through the gate and the final audit, and report it separately from the verdict on the paper as written.
- **Completing unfinished steps:** an optional, longer proof search for steps stopped by formalization difficulty.
- **Closing conditions automatically** when a cited result is available in Mathlib.

## v1.5.0 (2026-10-30)

Thank you to everyone who has tried the kit and sent us feedback since its release. This version takes up the first
suggestions; more will follow.

- **Verification graph** (`scripts/pv_graph.py`): `verification/report/VERIFICATION_GRAPH.html`, one self-contained
  page that opens offline in any browser. Every numbered result is a box colored by its verdict, with arrows for its
  dependencies; selecting one shows its place in the paper, its Lean theorem, its conditions (with a person's check),
  its issues and what it uses. Below the graph, the same content as a table.
- **Check summary** (`scripts/pv_summary.py`): `verification/report/CHECK_SUMMARY.md`, one page for readers who did
  not run the check, such as co-authors: what was checked, every verdict, the issues, the conditions, what was not
  checked, and where the evidence is.
- Both are made from the records alone (RESULTS.json, BLOCKERS.md), with fixed wording and without a language model,
  so they need no fact check. `/pv-report` and the unattended driver make them at the end; they can be remade at any
  time.
- **Standalone Lean project** (`scripts/pv_export.py`): copies the Lean files of every result with a verdict, the
  counterexamples and everything they import into `export/lean/`, with a lakefile pinned to the check's Lean and
  Mathlib, checksums, a README with each result's verdict and theorem, and `Axioms.lean`. Anyone can then run
  `lake exe cache get && lake build` without the kit or a model. Tested by building the exports of two example runs.
- `autosetup/fetch_arxiv.py <id> <project>`: puts the LaTeX source of an arXiv paper into the project's `source/`,
  for you to run before a check (agents never download). It never overwrites a file and refuses archives with unsafe
  paths or links.
- The permission file allows the three new scripts. For an existing project: `install.sh <project> --upgrade`, then
  add the new rules to `.claude/settings.json` (`python3 scripts/pv_settings.py check` lists them).
- Tests for the four scripts, and for the driver making the graph and the summary after the report.

### Fixes

- **A stop on the infrastructure budget goes to the gate.** When the prover stops a step because it needs more
  helper material than the budget allows, it now reports `INFRASTRUCTURE_RULING`. `pv_status.py next` lists the
  result as `RULING`, and the coordinator and the unattended driver ask the gate for a ruling before any further
  proof session: extend the budget for that step, turn the fact into an external input, or decline (at most two
  rulings per result). Before, the stop was recorded as `BUDGET_EXHAUSTED`, nobody asked the gate, and the driver
  stopped with "no progress".
- **The axiom walk no longer fails on compiler auxiliaries.** For a computable `def`, Lean adds compiler auxiliaries
  (`…._cstage1`) that refer to the core axiom `lcProof`, which no theorem reaches. When the module walk of
  `pv_audit_mech.py` (item 7) reaches a non-standard axiom, it now walks every declaration on its own and fails only
  if one of them reaches it. `PVTools.lean` is unchanged.
- **Only the snapshot block of a gate report is gated.** The gate writes its snapshot between
  `<!-- PV SNAPSHOT BEGIN -->` and `<!-- PV SNAPSHOT END -->`. Fingerprints quoted elsewhere in the report, and gap
  definitions anywhere, no longer count as gated declarations: a quoted gap definition made the fingerprint check
  fail once the gap was proved. Reports without the markers are read as before.
- **Conditions that become provable later.** Stage 6b of `PIPELINE.md` gains a variant for discharging an external
  input: once a person marks it with `pv_status.py provable <ID> --why …`, or once the Mathlib module that its search
  found in the source but not built has been built, `pv_status.py reconnect` lists the results that use it. After the
  reconnection, the input is recorded as proved in Lean (`proved_in`), the other results that use it are listed for
  connection, and the summary lists it. `validate` no longer warns that the final audit suggests CONDITIONAL after a
  reconnection removed the last condition, for predecessor clauses as well.
- **Library modules in the source but not built.** `scripts/pv_lean.sh module <Module>` says whether a module is
  built, in the source but not built (with the modules it imports that are not built either), or absent. The
  drafter and the gate then write `in source, not built: <Module>` in the input's search note, and the coordinator
  asks the user to build that module; agents never build library modules.
- **The Lake packages are checked.** A new item 13 of `pv_audit_mech.py` confirms that every package is the git
  checkout of its `lake-manifest.json` revision with no local changes. The script runs git itself, so the auditor
  needs no git permission.
- **Results new in a revision.** `pv_status.py reset <ID> --revision <k> --new` gives them the reason
  `NEW_IN_REVISION`; the progress table and the "What the revision changed" table show them as new.
- **A report older than the records is detected.** `/pv-report` ends with `pv_status.py report-stamp`, which records
  the `RESULTS.json` the report was made from. `validate` warns once the records change after it, and the stamp is
  refused when the report was updated without compiling the records again.
- The conditions for each verdict and `PVTools.lean` are unchanged, so earlier records stay valid. The fixes change
  `PIPELINE.md`, `VERDICTS.md` §4.2 (registering external inputs), the rule cards of the drafter, gate, prover and
  auditor, and the pv-run, pv-report and pv-revise skills; `install.sh <project> --upgrade` brings them to an existing
  project. No new permission rule is needed for them.
- Tests for each fix: `tests/test_mech_offline.py`, and additions to `test_status.py`, `test_drive.py` and (with
  Lean) `test_lean_integration.py`.

## v1.4.0 (2026-10-25)

- **New name: KAPPA** (Kit of Agents for Proof-checking Papers with a proof Assistant). Versions up to 1.3.4 were
  released as the TeX Proof-Check Kit. The repository is now https://github.com/ziwaa-se/kappa; GitHub redirects the
  old address.
- Only the name changed: the README, the guides and the heading of the project's `CLAUDE.md`. Scripts, rules, agent
  definitions, commands (`/pv-*`, `scripts/pv_*`) and `PVTools.lean` are unchanged, so existing projects need no
  upgrade. The example papers, prompts and benchmark records keep the old name where it was part of a run's input.

## v1.3.4 (2026-10-20)

- **Fix:** the check of `lean_main` added in v1.3.3 did not recognize a theorem declared with explicit universe
  parameters (`theorem P01_main.{u} …`), so `validate` reported such a record as invalid and `record` refused it. The
  check now accepts `name.{…}`. Found when the replication materials were run with v1.3.3; a test covers it.

## v1.3.3 (2026-10-17)

- **A recorded main theorem must exist.** `validate` checks that the theorem named in `lean_main` (`file:line name`) is
  declared in that file, and `record` refuses a verified verdict whose `--lean-main` names a theorem that does not
  exist; a declaration found at another line is a warning. In an example run on v1.3.1, three records named a
  placeholder theorem (`Paper.L01.main`) while the audits had checked the real ones, and the report's file index
  pointed readers to it.
- `examples/tools/replay.py`: the exit status depends only on the rebuilds and the mechanical checks; the result of
  the current validator is still printed (a newer kit may check more than the version that made the run).
- Tests for both.

## v1.3.2 (2026-10-13)

Fixes for five problems found while running the examples and the published case studies on v1.3.1.

- **The driver waits out a usage limit that interrupts the report.** When agents of the report session hit the
  limit and the report is missing, `pv_drive.sh --report` sleeps until the reset and makes the report again, instead
  of stopping with `report_incomplete` (in v1.3.1 the report-mode loop treated `limit_in_agents` as progress).
- **The driver repairs records left half-written by an interrupted session.** If `validate` is not VALID at the
  start of a loop iteration, the driver runs one resume session (the reconcile steps of `/pv-resume`) and validates
  again; it stops with `validate_failed` only if the records are still not VALID.
- **A renamed main file is a new version, not a different paper.** `source-check` recognises a new `.tex` file with
  the same title as the missing main file (arXiv `paper_v2.tex` → `paper_v3.tex`) and reports CHANGED with "main file
  renamed"; `defs-changed` follows the rename; new command `pv_status.py set-main source/<file>.tex`; `/pv-revise`
  says what to do.
- **Asserted facts stay inputs.** A fact the paper asserts as known ("well known", "classical", "standard") is an
  input of provenance (ii), or (i) if cited, even when Mathlib proves it; it is no longer discharged as a
  `FAIR_IMPLICIT_STEP` (VERDICTS §4.1, and the drafter, gate, auditor and issue-checker cards). The report notes when
  Mathlib proves it.
- **The cascade ignores auxiliary definitions a rewritten proof no longer needs.** A definition that disappears from
  a re-gated statement file does not count as a changed statement when the dependents' Lean files never mention it,
  so the dependents are rebuilt instead of redone. Changed definitions still count.
- Tests for all five (driver scenarios with the fake `claude`, record keeping, renamed main files).

### Example tools

- `examples/tools/score.py` scores a finished run against an answer key written before the run (JSON; agrees / accepted alternative / found with another class / differs / missing).
  A (p) clause whose predecessor ended as an issue counts as (iv), as the rules treat it in the report.
- `examples/tools/sanitize.py` also copies the records of earlier revisions (archived audits and reports, superseded
  Lean files, the records kept before each revision), the driver's log, and the end time of each session.
- Four new examples with answer keys fixed before their runs, and the complete records of those runs (v1.3.1):
  `examples/e1-sample-variance`, `e2-proportions`, `e3-shrinkage` (with a revision round) and `e4-edf`.

## v1.3.1 (2026-10-12)

Fixes and improvements from using v1.3 on longer, unattended runs and on revisions. Each problem was first reproduced on v1.3, then fixed and covered by a test (`tests/`, new in this version). Projects made with v1.3 upgrade with `install.sh <project> --upgrade`; then copy the new `settings.example.json` over `settings.json` if you agree with it (MANUAL, section 2, step 4).

**Measured** on `bench/` with the October 2026 models (two runs per version, `bench/results/COMPARISON_2026-10.md`): both v1.3.1 runs gave the answer key's three verdicts ($4.21 and $3.78); one of two v1.3 runs ended with two results unfinished because the gate's own commands were refused, the failure mode that v1.3.1 removes.

### Unattended runs

- **Auto-resume.** `scripts/pv_drive.sh --auto-resume` waits out the account's usage limit: it reads the reset time from Claude Code's message (with a time zone or a date when given), sleeps until then plus 5 minutes (30 minutes when no time can be read) and continues. In v1.3 the driver stopped at the first usage limit, because the failed session changed no record. Waits do not count toward `--max-sessions`; `PV_MAX_RESTARTS` (default 20) limits them. On macOS the driver keeps the machine awake with `caffeinate -i` while it runs.
- **Exit status.** The driver writes `pv_work/logs/drive_status.json` (reason, session, reset time) and returns a distinct exit code for each reason (MANUAL, section 3); the reason is always the last line of its output. In v1.3 a normal finish was followed by the progress table, so a tool that read the last lines could take it for a failure.
- **Reconnections are progress.** A session that only reconnected predecessors (stage 6b) changed no verdict, and the v1.3 driver stopped as if nothing had happened. Progress now covers conditions, `lean_main`, evidence, re-checks and dependencies.
- **Report mode.** `--report` runs `/pv-report` when every result has a verdict, after archiving any earlier report under `verification/report_archive/`; `--report-only` remakes the report. The waiting time for background agents is set for it, as for every driver session.
- **Session budget per result.** `"session_budget_usd"` in a result's entry raises the per-session cap for the sessions that work on it.
- **Editing the driver during a run** no longer affects the running driver: the script is one function that bash reads completely before running it.
- `autosetup/start_unattended.sh` starts the driver with `--auto-resume --report` by default (`--no-auto-resume`, `--no-report`), and refuses to start a second driver in the same project.
- The coordinator waits for background agents through their completion notifications, never with timers (`CLAUDE.md`, `pv-run`): a timer that fires after the agents have returned wakes the session for nothing.

### Permissions and safety

- **Every spelling of the kit's commands.** Claude Code matches a permission rule against the command exactly as written, so `Bash(scripts/pv_lean.sh *)` did not allow `/abs/path/scripts/pv_lean.sh …`, `./scripts/pv_lean.sh …` or `bash scripts/pv_lean.sh …`, and agents use all of them. `install.sh` now writes `settings.example.json` for the project's own path with every spelling (`scripts/pv_settings.py expand`; `check` lists what an existing `settings.json` lacks). Every role card states the one spelling to use, without `cd`, pipes, heredocs, redirection or `; echo "EXIT=$?"` (`POLICY.md` §4).
- **Refused kit commands stop the driver.** After each session the driver counts the permission denials in that session's transcripts (coordinator and subagents). If commands in their standard form were refused, the rules did not apply, and it stops with exit status 7 and the remedy (trust the folder once). A test with Claude Code 2.1.296 confirmed that rules passed with `--settings` apply in a folder that was never trusted, although Claude Code prints a warning that it ignores the folder's own allow rules.
- **Guard hook** (`scripts/pv_guard.py`, a PreToolUse hook in `settings.example.json`). Nobody writes outside the project (also through shell redirections); the coordinator writes no Lean file and no review report; the reviewing roles change nothing they review. Every write and every kit command is logged with its role in `pv_work/logs/writes.jsonl`. `PV_GUARD=warn|off` for work by hand.
- **Reading the Mathlib sources.** Agents search them for evidence that a result is or is not in Mathlib, but with linked packages they lie outside the project, so the searches were refused. The suggested file now lists the packages folder under `additionalDirectories` and denies editing it; every project also denies edits under `.lake/`.
- **No network from any program.** `pv_lean.sh` refuses Lean files that use `IO`, `run_cmd` or `initialize`, so Lean code cannot run programs or reach the network. The allow rule for `lake env lean` was removed (it bypassed `pv_lean.sh`); the deny list now also covers `git clone`, `pip`, `ssh`, `scp`, `rsync`, `elan`, `lake exe` and edits to `scripts/`.

### Revisions

- **The cascade goes one level at a time, and only through a changed statement.** In v1.3, `/pv-revise` reset every result that imported a changed one, and in practice every result below it, although a result consumes only the statements it imports. Now `reset` marks the direct dependents "re-check pending" and they keep their verdicts. When a reset result passes its gate again, `record … --statement-fixed true` compares its new gate snapshot with the old one: identical definitions and main theorem mean its dependents are only rebuilt and re-checked mechanically by the auditor (`RECHECK` in `pv_status.py next`, report `<ID>_recheck.md`); a changed statement resets them in turn. `pv_status.py cascade <ID>` makes the same decision by hand. `PIPELINE.md`, "Cascade reset on statement change", explains why.
- **Definitions by ID.** The architect gives every shared definition an ID and its exact lines (`source_defs`), and every result lists the definitions it uses (`uses_defs`). `pv_status.py defs-changed` compares each definition between the baseline and the new version, so an unchanged formula next to a changed one no longer makes its users "affected".
- **Old files are archived.** `reset` moves a reset result's old proof files and review reports to `pv_work/superseded/rev<k>/` and `verification/audits/rev<k>/` (its statement file stays and is copied), and its history points to the archived copies. `pv_status.py set-deps` changes dependencies without editing `RESULTS.json` by hand.
- **The previous manuscript is recorded.** `/pv-revise` refreshes the baseline at its last step, so a check of "is this passage unchanged?" against `verification/source_baseline/` always said yes. `reset` now records the folder that holds the previous manuscript (`baseline_before`), and the gate and the auditor compare against it.
- **A resolved issue frees its dependents.** A result that used a clause of a lemma with a recorded issue carries a (iv) condition. When a revision fixes that lemma and it is verified, `pv_status.py reconnect` now lists the clause for reconnection, as for a (p) clause; before, a dependent that kept its verdict also kept the stale condition.
- **Importing an earlier check** not made with the kit: `autosetup/import_legacy.py` copies its Lean modules, rebuilds them in import order, makes them read-only, adds deny rules for them, records the earlier verdicts in history, and starts `verification/REVISION_BRIEF.md` (a new template), which every session reads first. MANUAL, section 4.

### Records and reports

- **Conditions come from the audit.** A final (or reconnection) audit now ends with `CONDITIONS: <ids>` or `CONDITIONS: none`. `record` takes the result's conditions from that line and refuses different ones unless a reason is given; `validate` compares the two. In v1.3 the coordinator copied the conditions by hand, and a copy could miss one.
- **Conditions are traced mechanically.** `pv_audit_mech.py` item 11 walks each gated theorem and reads its hypothesis usage: an external input is a condition only when a hypothesis that the proof uses mentions it. Inputs mentioned only by unused hypotheses ("formal only") and inputs registered for the result but never reached are listed for the auditor.
- **Who ran it, who wrote it.** The mechanical report names the role, agent and session that ran it (from the guard's log), and item 12 names the last writer of the audited files; a proof last written by the coordinator fails. In v1.3 the header always said "run by the auditor".
- **Current evidence index.** `record`, `reset` and `add-tool` regenerate a current-evidence table at the top of `AUDIT.md` and the registry table in `EXTERNAL_TOOLS.md` (`pv_status.py refresh-records`), so that these files always point to the current reports. A verified verdict clears an old `partial` note.
- **External inputs.** A (p) clause removed by a reconnection is marked as reconnected and can no longer be listed as a condition. `add-tool` refuses a second registration of the same Lean constant and flags an input that looks like the same fact as an earlier one (same citation, or nearly the same meaning), so that a person checks it once.
- **Report template.** Boundary cases ruled by the reviewers and the coordinator's own observations are in separate tables, and every observation names what it rests on; the fact-check checks this. The report states the Lean and Mathlib versions and how many Mathlib modules were compiled.

### Cost accounting

- `pv_usage.py` priced Sonnet 5.5 cache reads at the Sonnet 5 rate ($0.20 instead of $0.10 per million tokens), which overstated the cost of runs on Sonnet 5.5. Token counts were always right; the published benchmark ran on Sonnet 5 and Opus 5 and is not affected. The report now ends with a per-model comparison with the cost that Claude Code reports for the same headless sessions, so that an outdated price shows at once.

### Setup

- `autosetup/lean_env.sh --download` works on macOS 26 and later, where the Mathlib cache tool linked by Lean 4.19.0's bundled linker does not load ("`__DATA_CONST` segment missing `SG_READ_ONLY` flag"): it relinks the tool with the system compiler and retries.
- `bench/run_bench.sh` uses `--auto-resume` and records the kit and Claude Code versions.

### Re-checking a run without a model

- `examples/tools/replay.py <run> --lean-env <env>` rebuilds a finished run's Lean files in a fresh project at the pinned versions, reruns the mechanical audit for every verified result, rebuilds every counterexample, compares with the archived reports and runs `validate`, with no language model involved (about a minute for the benchmark paper). `examples/tools/sanitize.py` copies a run's records for publication without local paths, user names or e-mail addresses; `examples/tools/blind_audit.py` checks from the transcripts that a run never touched an answer key or the network.

### Tests

- `tests/`: offline tests of the driver (against a scripted stand-in for `claude`), the permission file, the guard hook, the record keeping, the cascade, the cost accounting and the import tool; with `PV_TEST_LEAN_ENV`, integration tests of the mechanical audit and the import on real Lean files. `python3 -m unittest discover -s tests`; GitHub Actions runs the offline tests on Linux and macOS.

## v1.3 (2026-09-30 to 2026-10-06)

### Efficiency

Measured on `bench/` (two runs per version, identical and correct verdicts in all four): about 77% lower cost, 61% fewer tokens and 51% less time than v1.2.1. Details in [bench/results/COMPARISON.md](bench/results/COMPARISON.md).

- **A model per role.** The gate, the auditor, the issue-checker and the fact-check run on Opus. The architect, the drafter, the compiler and the first proof session run on Sonnet; a stuck proof gets a second session on Opus. The coordinator can run on Sonnet.
- **Rule cards.** Each agent carries the excerpts of the rules its role needs, each tagged with its source section. Agents no longer read all the rules at start-up. `scripts/pv_cards_check.py` checks that every cited section still exists.
- **Mechanical audit as a script.** `scripts/pv_audit_mech.py` runs the auditor's mechanical checks in one command: compile, private rebuild, statement fingerprints, axioms, `sorry` walk, hypothesis usage, unaudited constants. The judgement stays with the auditor.
- **Record keeping as commands.** `pv_status.py record`, `outputs`, `add-tool` and `init-checklist` do the record keeping.
- **Shorter outputs.** Subagent replies are at most 12 lines, and compile errors are summarized.
- **New scripts.** `scripts/pv_drive.sh` runs unattended in fresh short sessions; `scripts/pv_usage.py` shows token use by role, model and result.

### Workflow

- **Guided setup.** [`CLAUDE_START_HERE.md`](CLAUDE_START_HERE.md) and `autosetup/` let one sentence to a new Claude chat do the setup:
  - check the machine;
  - set up one shared Lean environment;
  - make a new folder per paper (a folder is never reused for another paper);
  - copy and check the paper's files;
  - write the start prompt.
- **Re-checking after a revision.** `/pv-revise` keeps each reset result's previous verdict (`pv_status.py reset`). Earlier issues are closed only by a new final audit (`record --resolve`), and `pv_status.py followup` and the report show before and after.
- **Conditions checked by a person.** `pv_status.py human-check` records who checked which condition, when and against what. The result stays CONDITIONAL.
- **One paper, one project.** `pv_status.py source-check` detects a changed or different paper in `source/`; `validate`, `/pv-setup` and `/pv-resume` warn or stop.
- **Upgrades.** `install.sh --upgrade` updates an existing project's kit files, with backups; projects carry a `KIT_VERSION`.
- **Documentation.** A complete guide with tested prompt templates, a section on VS Code connected to a cluster, a one-page cheat sheet, and two examples with real output: a short demo, and a full workflow covering every verdict, a revision and a human check.
- **Portability.** The scripts run on Linux and Python 3.6+.

### Fixes found while testing v1.3

- **Permissions in unattended sessions.** Headless `claude -p` sessions ignore a folder's own permission file until the folder has been trusted interactively. The driver therefore passes it with `--settings`.
- **Background subagents.** Headless sessions stop background subagents 600 s after their last turn. The driver waits longer, and the coordinator does not end its turn while its agents run.
- **Gap-definition hashes.** Lean names auxiliary proofs after their declaration (for example a real numeral `2`), so a renamed copy of an identical statement can hash differently. The gap-file check now redeclares statements under their original names (`VERIFICATION_METHODS.md` §2b).
- **Source baseline.** It is made by a script that needs no approval, so unattended setups no longer fail at that step.
- **User-only skills.** A natural-language request to follow a skill could be refused, because the skills are user-invocable only. `CLAUDE.md` and the prompt templates now say to read the skill file and carry out its steps.
- **Empty statement files.** `pv_audit_mech.py` no longer reports a false failure for a statement file that declares nothing. An auditor caught this one in the example run.

## v1.2.1 (2026-09-22): after the final independent check

- Reconnecting to a predecessor that has conditions of its own: the predecessor's conditions come first, and the `rfl` check passes them as parameters (tested).
- One account of who compiles `<ID>Stmt` and which version the gate snapshots.
- Worksheet priorities unified (A, A′, B, C, D, E).
- Verdict lines tolerate trailing text; second reviews are named `_r2`.
- `validate` checks more record combinations; `supersede` can move only files under `pv_work/`.

## v1.2 (2026-09-22): after a second independent review

- Refused builds report `EXIT=3` everywhere.
- Gap files may add the gap hypothesis to obligations that depend on it, with a matching audit method.
- Exact-statement checks for gap files and reconnections: copy, compare fingerprints, then `example` / `rfl`.
- Every result lives in `namespace Paper.<ID>`; statement definitions are declared once, in `<ID>Stmt.lean`.
- Gaps are recorded separately from external inputs; a result with gaps is ISSUE or UNFINISHED.
- Next steps after a negative review (`COUNTEREXAMPLE INVALID`, `REVIEW: NOT CONFIRMED`, `RECONNECT AUDIT: FAIL`).
- A cascading reset after any statement change; `validate` closes several loopholes.

## v1.1 (2026-09-22): after the first independent review

- Statement fingerprints include the content of definitions (`vh`) and binder annotations (`bi`).
- Predecessor clauses (p) and reconnection (stage 6b).
- Gap files (`<ID>ModGaps.lean`), so that a stopped step does not block auditing the rest.
- A table of next steps for each issue class; a review mode for reasoning-only rulings.
- One table of stages and reasons; a second pass for stuck results.
- `/pv-revise` for new versions of the paper; an example permission file.

## v1.0 (2026-09-22)

First version:
- four verdicts with an issue classification by whose fault it is;
- 8 agents (architect, drafter, gate, prover, auditor, issue-checker, compiler, fact-check) and 6 skills;
- `PVTools.lean` audit commands;
- the record files and the scripts to check them.
