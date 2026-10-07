# Changelog

## Planned

Not yet available; see the README's [Roadmap](README.md#roadmap). This version only verifies proofs that are already written.

- **Repair mode:** after an issue is confirmed, propose a correction, verify it in Lean within attempt and time limits, pass it through the gate and the final audit, and report it separately from the verdict on the paper as written.
- **Completing unfinished steps:** an optional, longer proof search for steps stopped by formalization difficulty.
- **Closing conditions automatically** when a cited result is available in Mathlib.

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
