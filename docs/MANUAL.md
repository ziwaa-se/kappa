# KAPPA v1.5.0: reference manual

> **Start with** [`GUIDE_EN.md`](GUIDE_EN.md), the complete workflow on one page. It covers setup, including the guided setup with [`CLAUDE_START_HERE.md`](../CLAUDE_START_HERE.md), the prompts to send, what you get, re-checking after corrections, recording conditions you checked, and upgrading. This manual is the detailed reference.

**What this kit does:** The paper's LaTeX already contains written proofs. The kit translates these proofs **faithfully** into Lean 4, actually compiles them, and gives each numbered result (theorem, proposition, lemma, corollary) a verdict:

| Verdict | Meaning |
|---|---|
| **Verified unconditionally** | The source proof passes Lean completely, with no unproved external input |
| **Verified conditionally** | The source proof passes Lean step by step, but depends on results the paper cites or does not prove. All of these results are written as **explicit hypotheses** and handed to you for human check |
| **Issue recorded** | A problem in the paper was found, for example a counterexample, a step that does not follow, a missing condition, an exposition gap, or a domain ambiguity; the record states **which side is at fault** |
| **Unfinished** | No conclusion yet. **Never counted as a paper error** |

**What it does not do:**
- It does not repair proofs on the authors' behalf;
- it does not look for new proof methods;
- it does not modify the source manuscript.

**Scope.** This version only verifies proofs that are already written. A mode that, after an issue is found, proposes a correction and verifies it in Lean (with attempt and time limits, reported separately from the verdict on the paper as written) is planned but **not included**; see the README's Roadmap.

It is driven by Claude Code. You can use it in the **Code** tab of the Claude desktop app, or in a terminal with the `claude` command:
- the main session acts as coordinator;
- drafting, review, proving, final audit and other work are each handed to **subagents with independent contexts**;
- all progress is written to files, so work can continue after your usage limit runs out.

---

## 1. What is in the kit

```
kappa/
├── README.md                    overview
├── CLAUDE_START_HERE.md         guided setup: instructions that a new Claude chat follows
├── CHANGELOG.md                 version history
├── install.sh                   installs the template into a new paper project (or --upgrade an existing one)
├── autosetup/                   scripts used by the guided setup (doctor, shared Lean environment, new project, ...),
│                                and import_legacy.py (importing an earlier check, section 4)
├── lean-pins/                   the tested Lean/Mathlib versions (used by install.sh --pinned)
├── docs/                        GUIDE_EN, QUICKSTART, CHEATSHEET, this MANUAL, diagrams/, lean-demo/
├── examples/full-workflow/      every verdict, a revision and a human check: the real output of one run
├── examples/two-lemmas-demo/    a two-lemma demo paper with the real output of a run
├── bench/                       benchmark: a 3-result test paper with a planted error, the answer key,
│                                the runner, the comparison script and the measured results (see section 9)
├── tests/                       offline tests of the scripts (no model, no network); Lean integration tests
│                                run when PV_TEST_LEAN_ENV names a Lean environment (tests/README.md)
└── template/                    content installed into a new project
    ├── CLAUDE.md                core rules Claude reads automatically at every start
    ├── .claude/agents/          definitions of the 8 subagents (roles)
    ├── .claude/skills/          6 slash commands: /pv-setup /pv-run /pv-status /pv-resume /pv-report /pv-revise
    ├── .claude/settings.example.json   suggested permission settings and the guard hook, written for this project's
    │                                    path by install.sh (inactive until you copy it; see section 2, step 4)
    ├── verification/rules/      full rules: POLICY, VERDICTS, PIPELINE, VERIFICATION_METHODS, LESSONS
    ├── verification/            templates for persistent records (RESULTS.json, checklist, issue records, resume pointer, etc.)
    ├── verification/report/templates/   templates for the final report, the external-input worksheet, the list of files to check,
    │                                    and the revision brief (REVISION_BRIEF.md, section 4)
    ├── pv_work/PVTools.lean     Lean commands for auditing: axiom check, constant walk, statement hash
    ├── scripts/                 pv_lean.sh (compile), pv_status.py (progress table, validation, record keeping), pv_snapshot.py (snapshots),
    │                            pv_audit_mech.py (mechanical audit checks), pv_drive.sh and pv_drive_status.py (unattended driver),
    │                            pv_usage.py (token use), pv_guard.py (who may write what), pv_settings.py (the suggested permissions)
    └── source/                  where the paper's LaTeX goes
```

---

## 2. First use

### Step 0: What you need once

- **macOS or Linux** with `git` and `python3` (both are preinstalled on macOS; if `git` is missing, macOS offers to install the command-line tools the first time you type `git`).
- **Lean's installer, elan.** In a terminal:

```bash
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
```

  Then open a new terminal window. You do not need to pick a Lean version; the project pins it.
- **Claude Code**: the Claude desktop app (Code tab) or the `claude` command in a terminal, on a plan that includes Claude Code.

### Step 1: Create a project for this paper

**One paper, one project.** For a revised version of the same paper, keep using its project (see `/pv-revise`).

**On a fresh machine (recommended):** install the kit with the tested Lean/Mathlib pins, then download Mathlib once.

```bash
~/proofcheck/kappa/install.sh ~/proofcheck/papers/mypaper-check --pinned
```

```bash
cd ~/proofcheck/papers/mypaper-check && lake exe cache get
```

```bash
scripts/pv_lean.sh build PVTools
```

- `--pinned` copies the kit into the new folder (including the hidden `.claude/`) and writes `lean-toolchain` (Lean 4.19.0), `lake-manifest.json` and `lakefile.toml` (Mathlib `c44e0c8e`), the exact versions the kit was tested on.
- `lake exe cache get` needs the internet. It fetches Lean 4.19.0, Mathlib and Mathlib's prebuilt files: a few GB, typically 5–20 minutes. If it reports that no cache exists for this revision, run `lake build` instead (much slower).
- The last command is the environment check; it must end with `exit=0`.

**If you already have a Lean project on Mathlib `c44e0c8e`** (for example an earlier paper), reuse its Mathlib instead of downloading:

```bash
~/proofcheck/kappa/install.sh ~/proofcheck/papers/mypaper-check --lean-from "/path/to/existing/project"
```

This copies that project's `.lake/packages` (about 2.7 GB, no network) and runs the environment check itself. Add `--link-packages` to link instead of copy (instant, but the two projects then share Mathlib, so the kit never compiles missing Mathlib modules; steps that need one are recorded as `TRANSLATION_BLOCKED`).

**Updating an existing project to a new version of the kit** (after `git pull`, or a new download). Installing a new version over an existing project normally changes nothing, because existing files are never overwritten. Use `--upgrade` instead:

```bash
~/proofcheck/kappa/install.sh ~/proofcheck/papers/mypaper-check --upgrade
```

- Close Claude Code in that project first, and continue afterwards with `/pv-resume`.
- It replaces only the kit's own files: `CLAUDE.md`, `.claude/agents`, `.claude/skills`, `scripts/`, `verification/rules/` and the report templates. The old versions go to `kit_backup/<date>/`.
- It never touches the paper, the records, the audits, the Lean files, `PVTools.lean` or your `settings.json`. It lists any new permission entries for you to add yourself.
- It notes the upgrade in `verification/AUDIT.md` and runs `validate`. `cat KIT_VERSION` shows which version a project has.
- It never changes Lean or Mathlib. A project keeps its versions to the end; use a new version's Lean pins only for new projects.

### Step 2 (optional): use a newer Lean/Mathlib instead

The kit was tested only on Lean 4.19.0 + Mathlib `c44e0c8e`. To use the latest versions, create a Mathlib project yourself and install the kit into it:

```bash
cd ~/proofcheck/papers && lake new mypaper-check math && cd mypaper-check && lake exe cache get
```

```bash
~/proofcheck/kappa/install.sh ~/proofcheck/papers/mypaper-check && scripts/pv_lean.sh build PVTools
```

If `PVTools` fails to compile on a newer Lean, give the error message to Claude; only `pv_work/PVTools.lean` is affected. A newer Mathlib may ship new dependency packages; add their names to `libRoots` in that file.

### Step 3: Add the paper

Put the LaTeX into the new project's `source/`:
- the main file;
- all files brought in by `\input`/`\include`;
- macro files.

Keep the original relative paths. If you have the **`.aux`** and **PDF** produced by compilation, put them in too; they are used to match the PDF numbering exactly.

If the paper is on arXiv, you can instead fetch its LaTeX source (v1.5): `python3 <kit>/autosetup/fetch_arxiv.py <arXiv id> <project>`. This downloads, so run it yourself; the agents never do. It writes into `source/`, never overwrites a file, and refuses archives with unsafe paths or links. arXiv's source has no compiled PDF and usually no `.aux`; add them if you have them.

### Step 4: Set permissions (optional, but recommended before initialization)

During automatic progress, Claude may ask for confirmation every time it runs a command or writes a file. When you are away from the computer, it stops there and waits for you.

The kit comes with suggested permission settings, `.claude/settings.example.json`, **inactive by default**. `install.sh` writes it for this project's own folder. Its contents:
- **Allow**:
  - this kit's scripts: compile, private rebuild and comparison, packages check, progress table and record keeping, snapshot, moving stale files away, the mechanical audit checks (`pv_audit_mech.py`), the token report (`pv_usage.py`) and the driver's status (`pv_drive_status.py`);
  - each of them in every spelling agents use (v1.3.1): `scripts/pv_lean.sh …`, `./scripts/pv_lean.sh …`, `bash scripts/pv_lean.sh …` and the absolute path of this project. Claude Code matches a rule against the command exactly as written, so a rule for one spelling does not allow the others;
  - `date`, `tail`, `diff`;
  - writing files under `pv_work/` and `verification/`.
- **Deny**:
  - network and package managers: WebFetch, WebSearch, `curl`, `wget`, `git clone`, `pip install`, `ssh`, `scp`, `rsync`, `elan`;
  - `lake update`, `lake exe …`, `lake build`;
  - modifying `source/`, the rule files `verification/rules/`, the audit tool `pv_work/PVTools.lean`, the source manuscript baseline, `.claude/` and `scripts/`.
- **Hook** (v1.3.1): before every write and every shell command, `scripts/pv_guard.py` checks who is acting. Nobody writes outside the project; the coordinator writes no Lean file and no review report; the reviewing roles change no file they review. Every write and every kit command is logged with its role in `pv_work/logs/writes.jsonl`, which the mechanical audit report uses to name who ran it and who last wrote the audited file.

The copying, moving and directory creation that the subagents need have all been changed to go through these scripts or Read/Write, so there is no need to allow `cp`, `mv` or `mkdir`. Every other command is refused in unattended runs; the role cards tell each agent the exact spelling to use.

After you have read the contents and agree with them, run the command below **yourself** in the new project directory to enable it:

```bash
cp .claude/settings.example.json .claude/settings.json
```

Notes:
- If it does not take effect after you enable it, close and reopen the session for this project.
- **Trust.** Claude Code ignores a folder's own `.claude/settings.json` until the folder has been opened interactively once and trusted. The driver therefore passes the file explicitly with `--settings`. In a test with Claude Code 2.1.296 (2026-10-12), rules passed this way applied to the coordinator and to subagents in a folder that had never been trusted, although Claude Code still printed "Ignoring … permissions.allow entries … this workspace has not been trusted". If kit commands are refused anyway, the driver stops with exit status 7 and says so; then open the folder once in Claude Code and accept the trust dialog.
- **After moving the project folder**, run `python3 scripts/pv_settings.py expand` and copy the file again: the absolute-path rules name the old folder.
- **After `install.sh --upgrade`**, `python3 scripts/pv_settings.py check` lists the suggested rules and hooks your `settings.json` lacks. Your file is never changed for you.
- **Working by hand in the project** (outside the kit's roles): the guard treats the main session as the coordinator. `PV_GUARD=warn` logs instead of refusing; `PV_GUARD=off` turns it off for that session.
- **With a copy install, if you allow compiling missing mathlib modules**, remove `"Bash(lake build *)"` from `deny`. A `deny` rule cannot be approved even from a confirmation prompt.
- **With a link install**, the Mathlib sources lie outside the project. The suggested file lists their folder under `additionalDirectories` (v1.3.1), so that agents can read and search them for "is X in Mathlib?" evidence, and denies editing them; the guard hook refuses writes outside the project as well. Every install denies edits under `.lake/`.
- You can also leave this setting disabled. In that case, approve each confirmation as it appears, or choose a more permissive permission mode in the Claude app. **The "no network" rule and the guard are enforced by the system only after this setting is enabled**; without it, only the written constraints in each role definition apply.

### Step 5: Open the project and initialize

Open this new project directory in the Code tab of the Claude desktop app (or run `claude` in that directory), and enter:

```
/pv-setup source/main.tex
```

It does the following:
- checks the environment;
- has a subagent take an inventory of the whole paper: the location and dependencies of each numbered result, the external literature cited in proofs, facts that "the proof silently uses but the paper never states", and notation ambiguities;
- sets up the record files;
- gives you an English progress table and a plan for proceeding.

**At this point, please take a look at:**
- whether the number of numbered results is right;
- which candidate external inputs there are;
- whether there are global notation readings you need to decide.

### Step 6: Start automatic progress

```
/pv-run
```

From then on it **keeps going automatically all the way**, without needing you to approve each judgment, provided you have set permissions as in step 4 or chosen a permissive permission mode.

- **Flow:** It proceeds in dependency order. Each result goes through, in turn: draft the statement → independent gate review → proof following the source → independent final audit → record. When a suspected paper issue comes up, it is passed to a dedicated subagent for a ruling; if a Lean counterexample can be constructed, it is constructed and sent for independent review.
- **Reporting:** Each completed step is reported to you in one or two sentences. Each time a result gets a verdict, an **English progress table** is attached, which you can screenshot and share directly.
- **When problems come up:** They are recorded and work continues; you check and fix them by hand later.

To do only part of the work, you can specify a scope:

```
/pv-run L01 L02 T01
```

---

## 3. Common operations while running

| What you want to do | Enter |
|---|---|
| See progress (English table, for screenshots) | `/pv-status` |
| Come back and continue after the usage limit ran out or the window closed | `/pv-resume`, or just say "Read verification/RESUME.md and continue" |
| See the progress table directly in a terminal | `python3 scripts/pv_status.py table` |
| The source manuscript has a new version | Put the new LaTeX into `source/`, then `/pv-revise` |
| Save a snapshot by hand | `python3 scripts/pv_snapshot.py save --label my-note` |
| See every result, its verdict and its dependencies as a graph (v1.5) | `python3 scripts/pv_graph.py`, then open `verification/report/VERIFICATION_GRAPH.html` in a browser |
| A one-page summary to pass on (v1.5) | `python3 scripts/pv_summary.py` writes `verification/report/CHECK_SUMMARY.md` |
| Package the Lean proofs as a standalone Lean project (v1.5) | `python3 scripts/pv_export.py` writes `export/lean/`; inside it, `lake exe cache get && lake build` |
| See where the tokens went (by role, model and result) | `python3 scripts/pv_usage.py` |
| Run unattended from a terminal, in short fresh sessions (v1.3) | `scripts/pv_drive.sh` (see below) |

- **What happens when the usage limit runs out?** Running subagents stop. All reports are saved as they are written, and `RESUME.md` is updated at every milestone, so no work is lost. In the desktop app, run `/pv-resume` when you come back: it checks half-finished work, continues it where possible, and restarts it otherwise. The interactive session does **not** continue by itself after the reset; the driver below does.
- **Saving tokens (v1.3).**
  - Choose **Sonnet** for the main session in the model picker: the coordinator only dispatches, checks and records. The reviewing roles still run on Opus by their own definitions.
  - Every step of a long session re-reads its whole history. In the desktop app, after every few verdicts, type `/clear` and then `/pv-resume`: nothing is lost, because all state is in files.
  - Or run it from a terminal with the driver, which does this for you: each batch of up to 3 results gets a fresh session.

### Running unattended with the driver (v1.3.1)

```bash
cd ~/proofcheck/papers/mypaper-check && scripts/pv_drive.sh --setup source/main.tex --auto-resume --report
```

- `--auto-resume`: when the account's usage limit is reached, the driver reads the reset time from Claude Code's message ("resets 3:45pm", with a time zone or a date when given), sleeps until then plus 5 minutes (30 minutes when no time can be read), and continues. Waits do not count toward `--max-sessions`; after `PV_MAX_RESTARTS` waits (default 20) it gives up.
- `--report`: when every result has a verdict, the driver archives any earlier report under `verification/report_archive/<date>/` and runs `/pv-report` in a fresh session.
- Leave out `--setup` if `/pv-setup` has already been run; `--report-only` remakes only the report.
- `autosetup/start_unattended.sh <project>` starts the same command in the background (tmux, or `nohup`), with `--auto-resume --report` by default.
- Environment variables: `PV_COORD_MODEL` (default `sonnet`), `PV_BATCH` (3), `PV_BUDGET_USD` (a per-session safety cap, default 30; a hard result can raise the cap for its own sessions with `"session_budget_usd": 60` in `RESULTS.json`), `PV_MAX_RESTARTS` (20).
- **Why it stopped.** The last line of its output names the reason, and `pv_work/logs/drive_status.json` records it (`python3 scripts/pv_drive_status.py show`):

  | Exit status | Reason | What to do |
  |---:|---|---|
  | 0 | `done` / `done_report`: every result has a verdict or a recorded reason | read the table or the report |
  | 3 | `usage_limit` (without `--auto-resume`) | run the driver again after the reset time it names |
  | 4 | `no_progress`: a session changed no record | read the last session's JSON and `RESUME.md` |
  | 5 | `validate_failed` | read `pv_work/logs/drive/validate.txt` |
  | 6 | `max_sessions` | run the driver again |
  | 7 | `permissions`: kit commands in their standard form were refused | trust the folder once (step 4) and run again |
  | 8 | `report_incomplete` | look at the report session's JSON; `--report-only` retries |
  | 9 | `max_restarts` | many usage-limit waits; run again later |
  | 1 | `setup_failed` | read the setup session's JSON |

- After each session the driver also counts the permission denials in that session's transcripts (coordinator and subagents) and prints them; `python3 scripts/pv_drive_status.py denials pv_work/logs/drive/session_<k>.json` lists the commands.

### Operations notes for long runs (v1.3.1)

1. **Keep the computer awake.** With `--auto-resume` on macOS the driver runs `caffeinate -i` for as long as it runs, which prevents idle sleep. **Closing the lid still puts a laptop to sleep**; keep it open (or use an external display setup that keeps it awake). On Linux, use your desktop's inhibit setting or a server.
2. **Closing the chat window is fine.** The driver runs as its own process (`nohup` or tmux via `start_unattended.sh`); only a chat that is *monitoring* it needs to stay open.
3. **Trust the folder once** before the first unattended run if possible (step 4); the driver stops with exit status 7 if kit commands are refused.
4. **Editing the driver while it runs** no longer affects the running driver (v1.3.1 reads the whole script before running it). Still, do not edit the other scripts during a run: a session may be using them.
5. **The report session** waits up to 3 hours for its background subagents (`CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS`, set by the driver); start reports with the driver (`--report`, `--report-only`) so that this is never forgotten.
6. **Before a new revision round**, the driver's `--report` archives the earlier report; with `/pv-report` by hand, copy `verification/report/` away first.

---

## 4. After every result has a verdict

```
/pv-report
```

It generates three files in `verification/report/`. Read them in this order:

| Order | File | Purpose |
|---|---|---|
| 1 | `AUTHOR_REPORT.md` | **Main report**: an English summary table at the top; the body contains the conclusion for each result, all external dependencies, questions and suggestions for the authors, typos, and the human-check list |
| 2 | `FILES_TO_CHECK.md` | **Index**: for each result, "paper location ↔ Lean main theorem file:line ↔ audit report", plus the base definition files |
| 3 | `EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: for each external input, the verbatim Lean definition, check points and check boxes, sorted by risk |

Before delivery the report goes through an **independent fact check**, because summaries written by the coordinator have contained errors before.

Two more files are made at the end from the records alone, with fixed wording and without a model (v1.5), so they need no fact check:

| File | Purpose |
|---|---|
| `VERIFICATION_GRAPH.html` | The whole check at a glance, in a browser: every result colored by its verdict, with its dependencies; select one to see its conditions, issues and Lean theorem |
| `CHECK_SUMMARY.md` | One page to pass on, to co-authors or anyone who did not run the check: what was checked, the verdicts, the issues, the conditions, and what was not checked |

Both can be remade at any time, also during a run, with `python3 scripts/pv_graph.py` and `python3 scripts/pv_summary.py`.

**Sharing the Lean proofs.** `python3 scripts/pv_export.py` copies, unchanged, the Lean file of every result with a verdict, the counterexamples named in `BLOCKERS.md` and everything they import into `export/lean/` (`--out DIR` for another place). The folder is a Lake project pinned to the check's Lean and Mathlib, with `SHA256SUMS`, a README listing each result's verdict and theorem, and `Axioms.lean`, which prints the axioms each main theorem uses. Anyone can build it with `lake exe cache get && lake build`, without the kit or a model.

**You need to check only three things by hand:**
1. **Whether the external inputs are true.** This is mandatory; no one has verified them.
2. Whether the **base definitions** match the paper.
3. Whether the **Lean statement** of each result is exactly what the paper says.

You do **not** need to read the Lean proof bodies line by line: they are machine-checked by the Lean kernel, and the independent final audit confirms them by recompiling.

### When a person has checked a condition (v1.3)

If you check a condition, for example a cited theorem against the book it comes from, tell Claude in the project who checked which condition and against what. The coordinator then records it with `python3 scripts/pv_status.py human-check <ID> --by … --how …`.
- The result **stays "verified conditionally"**: the Lean proof still assumes the condition, and a person's check is different evidence from the Lean kernel's.
- The progress table and the report mark it "conditions checked by a person", with who, when and how.
- Only a Lean proof of the condition itself can turn it into "verified unconditionally".

### When a condition can be proved after all (v1.5)

Sometimes a condition turns out to be provable after its result was verified: you found the Mathlib lemma that gives it, or its Mathlib module was in the source but not compiled (the search note then says `in source, not built: <Module>`, and `scripts/pv_lean.sh module <Module>` shows how much would have to be built). Tell Claude which condition and why, or build the module yourself (`lake build <Module>` in the folder that owns `.lake/packages`; agents never build library modules). The coordinator records it with `python3 scripts/pv_status.py provable <ID> --why …`; `pv_status.py reconnect` then lists the results that use it, and `/pv-run` (or the driver) proves the condition and connects the proof, as in the reconnection of predecessor results (`PIPELINE.md` stage 6b). The condition is then recorded as proved in Lean, and a result left with no condition becomes "verified unconditionally".

### After you correct the paper (v1.3.1)

Put the corrected LaTeX (and the new PDF and `.aux`) into `source/`, replacing the old files, then run `/pv-revise`, and afterwards `/pv-run` (or the driver) for the results it resets.
- **What is reset.** Only the results whose statement, proof or used definitions changed. A definition counts as changed only if its own lines changed: each shared definition has an ID and an exact line range (`source_defs`), each result lists the definitions it uses (`uses_defs`), and `python3 scripts/pv_status.py defs-changed` compares them between the baseline and `source/`. If the new version renames the main file but keeps its title, `source-check` reports "main file renamed" (since v1.3.2) and `/pv-revise` records the new name with `pv_status.py set-main`.
- **What happens to the results that depend on them** (`PIPELINE.md`, "Cascade reset on statement change"). They are marked "re-check pending" and keep their verdicts for the moment. When a reset result passes its gate again, the kit compares the fingerprints of its new statement with the old ones. If they are identical, its dependents are only rebuilt and get a mechanical re-check (`RECHECK` rows of `pv_status.py next`; report `<ID>_recheck.md`); if they differ, the dependents are reset in turn, one level at a time. Since v1.3.2 a definition that the new statement file no longer contains does not count as a change when the dependents' Lean files never mention it (an auxiliary of a rewritten proof). Before v1.3.1 every result that imported a changed one was reset, and so, transitively, were results whose inputs had not changed at all.
- **Old files.** `reset` moves the old proof files and review reports of a reset result to `pv_work/superseded/rev<k>/` and `verification/audits/rev<k>/`, so that the current files are the only ones in place; its history points to the archived copies.
- **"Is this passage unchanged?"** `/pv-revise` makes `source/` the new baseline at its last step. Reviewers who need to confirm that some text did not change compare against the previous manuscript, which `reset` records in each result's history (`baseline_before`, e.g. `verification/source_baseline_v1/`).
- An earlier issue is marked resolved only when the re-check gives the result a verified verdict with a new final audit.
- `python3 scripts/pv_status.py followup` and the next `/pv-report` show each re-checked result before and after. Results that are new in the revision are registered with `reset <ID> --revision <k> --new` (v1.5) and shown as new.
- (v1.5) Once the records change after a report, `validate` warns that the report is out of date. Update it with `/pv-report` from the start: it refuses to stamp a report whose compiled records were not made again.

### Importing an earlier check that was not made with the kit (v1.3.1)

If a paper was checked before with other tools (an earlier workflow, a hand formalization) and you want the kit to re-check a revised version while reusing that Lean material:
1. Make a new project and run `/pv-setup` as usual.
2. Run, yourself, outside Claude Code: `python3 autosetup/import_legacy.py <project> <folder of the old Lean modules> --label prev-<date> [--verdicts old_verdicts.tsv] [--write-settings]`. It copies the modules into `pv_work/` under their own module paths (refusing any name clash), rebuilds them in import order with the project's Lean, makes them read-only, adds deny rules for them (with `--write-settings`; otherwise it prints them), records the earlier verdicts in each result's history (for the report's before/after table), and creates `verification/REVISION_BRIEF.md`.
3. Fill in sections 1, 2 and 4 of the brief: the mapping from old numbers to kit IDs, and what changed. Every session reads the brief first.
4. Start the check. Reused modules are infrastructure: a reused constant that a proof reaches needs its own audit record in this round, and an earlier verdict is never evidence.

## 5. How to read verdicts and issues

### What does "verified conditionally" mean?

"If these cited results are correct, then the paper's derivation is correct step by step and has compiled in Lean."

What is not verified is not the theorem's own hypotheses (for example "ρ is in a Hölder class"), but the **external results used in the proof**. From lowest to highest risk:
- theorems from well-known literature;
- standard facts the paper asserts but does not prove;
- technical steps the paper never writes out;
- **clauses of the paper's own lemmas whose proofs have problems**: this category most needs your check.

### Each issue states "which side is at fault"

| What you want to know | Classification code |
|---|---|
| The conclusion itself is false (there is a counterexample) | `ERROR` |
| **Where the existing proof is wrong** (the justification of a step fails) | `PAPER_ARGUMENT_GAP` |
| **A condition is missing, so the result cannot be derived** | `PAPER_ASSUMPTION_GAP` |
| The conclusion is true, but the source does not cover some range | `EXPOSITION_GAP` |
| The domain or notation is ambiguous | `DOMAIN_CLARIFICATION` |
| **A mistake made when writing the proof in Lean** (a problem on our side) | `ENCODING_ERROR`; not counted as a paper issue |
| It cannot be written in Lean (missing interface, technical difficulty) | `TRANSLATION_BLOCKED`; the result is recorded as unfinished |

Full definitions: `template/verification/rules/VERDICTS.md`.

---

## 6. What you can adjust

| What to adjust | Where to change it |
|---|---|
| The prover's attempt limits (default: stop after 4 consecutive attempts without progress on a single step in a session; a second session on Opus for stuck steps; at most 2 proof sessions per result per pass; at most 2 passes over all results) | `verification/rules/PIPELINE.md` (the beginning and stage 4), `.claude/agents/pv-prover.md`, `.claude/skills/pv-run/SKILL.md`; change all three together |
| Number of subagents running at the same time (default 3) | `.claude/skills/pv-run/SKILL.md` §1, and `POLICY.md` §5 |
| Which model a role uses | `model:` in the header of the corresponding `.claude/agents/<role>.md` (`inherit`, `opus`, `sonnet`, `haiku`, `fable`) |
| The session cap for one hard result (v1.3.1) | `"session_budget_usd"` in that result's entry in `RESULTS.json`; the driver uses the largest cap of a batch |
| The guard hook (v1.3.1) | `PV_GUARD=warn` (log only) or `PV_GUARD=off`; the rules are in `scripts/pv_guard.py` |
| The rules themselves | `verification/rules/*.md`. Think carefully before changing them; they are binding on all roles. Since v1.3 each agent in `.claude/agents/` carries a **rule card** of excerpts, each tagged with its source section (for example `POLICY §1`): when you change a rule, update the cards that cite it |

---

## 7. FAQ

**Why so many subagents? Does that use a lot of tokens?**

Independent review must use a different context; otherwise it is self-review. In the test runs:
- independent review caught errors in drafting and in proofs;
- the fact check found 9 to 14 problems in each first draft of the final report, all corrected before delivery (see `examples/`).

Ways to save tokens:
- work in batches with `/pv-run <ID…>`;
- or change the `model` of every role other than the final audit to a cheaper model.

**Can it go online to look up literature?**

The rules **forbid downloading and network access**. After you enable the permission settings in step 4, this is enforced by the system. A download without permission counts as a violation and is disclosed in the report. All literature that needs checking is listed in the human-check list. If you are willing to let it go online to check a specific source, say so explicitly in chat.

**What if the paper gets a new version?**

Put the new LaTeX into `source/`, then run `/pv-revise`. It does the following:
- compares the new manuscript with the baseline saved during `/pv-setup`;
- resets only the results whose statement, proof or used definitions changed;
- updates all line numbers;
- keeps all other verdicts.

Then re-check those results with `/pv-run <reset ID…>`.

**Why does `pv_usage.py` show a different cost from Claude Code's own figure?**

There are two estimates, both at list prices. Claude Code reports `total_cost_usd` for each headless session; `pv_usage.py` reads every transcript, so it also covers interactive sessions and sessions outside the driver, and it splits the cost by role, model and result. For the same sessions the token counts are identical. Since v1.3.1, `pv_usage.py` ends with a per-model comparison against Claude Code's figures for the driver's sessions. A model whose two costs differ has an out-of-date price in `PRICES` (in v1.3, Sonnet 5.5 cache reads were priced like Sonnet 5's, which overstated the cost of runs on Sonnet 5.5; the published benchmark ran on Sonnet 5 and Opus 5 and is not affected). Neither figure is a bill on a subscription plan; both indicate how fast the usage limit is used.

**What if a comment in an audited file is wrong?**

Record it in `verification/DOC_ERRATA.md`; do not edit the file directly. Changing a comment changes the `.olean` and invalidates the "byte-for-byte identical" audit record. If you authorize the change, follow the three-step procedure at the top of that file.

**A result shows "unfinished". Does that mean the paper has a problem?**

No. Unfinished only means no conclusion has been reached yet. The reason is stated, for example a missing Lean interface, the attempt budget exceeded, or waiting on a predecessor.

**Can I work without the slash commands?**

Yes. You can simply say it in natural language, for example "start automatic progress", "Read verification/RESUME.md and continue", or "show progress". `CLAUDE.md` requires Claude, in that case, to read the corresponding command file and follow it. Slash commands are the most reliable and are less likely to skip steps.

---

## 8. Known limitations

- `PVTools.lean` has only been tested on Lean 4.19.0 + mathlib `c44e0c8e…`.
- **"Not in Mathlib" is only as good as the local Mathlib.** If fewer than all Mathlib modules are compiled (`scripts/pv_lean.sh packages`, `autosetup/lean_env.sh <base> --check`), a step can stop as `TRANSLATION_BLOCKED` for a module that exists but is not built (since v1.5 the search note then says `in source, not built: <Module>`, and the condition can be proved later; see "When a condition can be proved after all"). Use a complete environment (`lean_env.sh --download`); the report states the count. On macOS 26 and later, `lake exe cache get` fails with Lean 4.19.0's bundled linker; `lean_env.sh --download` relinks the cache tool with the system compiler (v1.3.1).
- The guard hook and the Lean IO check are safeguards against mistakes, not a sandbox: they rely on Claude Code naming the calling subagent, and the IO check is a text scan of the file being compiled.
- Conditions traced by `pv_audit_mech.py` (item 11) read hypothesis types as printed (cut at 100 characters) and bundled hypotheses; ambiguous cases are listed for the auditor rather than decided.
- The statement fingerprint has three parts: the type hash, the `def` content hash, and the binder annotations (explicit or implicit). Names of bound variables are not included. When hashes differ, read the `#print` output of both sides before drawing a conclusion.
- `#pv_hyp_usage` only checks whether a hypothesis appears in the proof term. When a hypothesis is passed to a helper lemma, check that lemma as well to confirm whether the hypothesis is actually used.
- The kit cannot judge for you whether theorems from external literature are true; that is exactly the human-check part.
- This version only does "faithful checking of existing proofs". "Automatically attempting to fill in proofs (with a limit on attempts or time)" is a separate version and is not yet available.

---

## 9. Efficiency in v1.3, and what it was measured to save

**What changed** (details in [`CHANGELOG.md`](../CHANGELOG.md), section v1.3). The checks are the same as before; the work is organized differently:
- Each role runs on a model suited to it. The gate, the auditor, the issue-checker and the fact-check stay on Opus. The architect, drafter, compiler, the first proving session and the coordinator can run on Sonnet. A stuck proof escalates to Opus.
- Each subagent carries a short **rule card** instead of reading all the rules files at start-up.
- The auditor's mechanical checks are one script (`pv_audit_mech.py`), and record keeping is one command (`pv_status.py record`).
- Subagents reply in at most 12 lines, and compile errors are summarized.
- `pv_drive.sh` runs unattended in fresh short sessions, so the coordinator's context stays small.

**Measured** on `bench/paper` (3 results, one with a planted error; two runs per kit; list prices):

| | v1.2.1 | v1.3 |
|---|---:|---:|
| Cost for the 3 verdicts | $71.15, $65.04 | $17.73, $13.68 (**−77%** on average) |
| Tokens | 73.2 M, 64.1 M | 31.2 M, 21.9 M (−61%) |
| Run time | 84, 83 min | 51, 30 min (−51%) |
| Verdicts correct / planted error caught / false alarms | 3/3, yes, 0 (both runs) | 3/3, yes, 0 (both runs) |

On the same model (Opus in both kits), the reviewing tasks cost 2.4–2.7× less. That part of the saving comes from the rule cards and the audit script, not from cheaper models. Interruptions, other differences between runs and limits are in `bench/results/COMPARISON.md`.

To see where your own run's tokens go: `python3 scripts/pv_usage.py`.
