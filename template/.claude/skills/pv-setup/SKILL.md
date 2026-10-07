---
name: pv-setup
description: Initialize a faithful proof-checking project — check the Lean environment, inventory the manuscript with pv-architect, create RESULTS.json, the verdict checklist and the resume file, and report the plan. Run once per paper, before /pv-run.
disable-model-invocation: true
---

# /pv-setup — Initialization

Argument `$ARGUMENTS`: the path of the main `.tex` file, for example `source/main.tex`. If it is empty, look under `source/` for files containing `\documentclass`; if there are several, ask the user which one to use.

Follow `CLAUDE.md` and `verification/rules/`.

## 1. Check the environment (no network)

0. **One paper, one project.** If `verification/RESULTS.json` already lists results, this project has been set up before: **stop**. Run `python3 scripts/pv_status.py source-check` and tell the user what it says.
   - Same paper, new version → `/pv-revise`.
   - Unfinished run → `/pv-resume`.
   - A different paper → a new project made with `install.sh <new folder>`; the files of the other paper go back out of this `source/`.

   Never inventory a second paper into a used project: its records and audits would mix.
1. Run `date '+%Y-%m-%d %H:%M'`.
2. Confirm that the following files and directories exist: `lean-toolchain`, `lakefile.toml` (or `lakefile.lean`), `.lake/packages/mathlib`.
3. Run `scripts/pv_lean.sh build PVTools`; it must give `exit=0`.
   - If it fails, **do not download anything on your own**. Tell the user why it failed, point them to section 2, "Step 1 / Step 2" of the kit's `docs/MANUAL.md`, and then stop.
4. Run `scripts/pv_lean.sh packages`, and write the result (linked or copied, and the number of compiled modules) into `lean.packages` in `RESULTS.json`.
   - If it is `linked` and far from all modules are compiled, tell the user: when a missing module is encountered, the steps concerned will be recorded as `TRANSLATION_BLOCKED`; to avoid this, they can switch to the copy installation described in the kit's `docs/MANUAL.md`, or complete the linked environment with `lake exe cache get` there.
5. Run `python3 scripts/pv_snapshot.py hash pv_work/PVTools.lean`, and write the sha256 into `lean.pvtools_sha256` in `RESULTS.json`. From then on, validate reports an error as soon as the audit tooling is changed.
6. Confirm that there are `.tex` files under `source/`. If there are `.aux` files or a PDF, note them; they help to determine the PDF numbers.
7. Run `python3 scripts/pv_snapshot.py baseline`: it copies `source/` to `verification/source_baseline/`, the baseline for later `/pv-revise` comparisons. It never overwrites an existing baseline, and it needs no approval (v1.3; before, `cp -R` needed approval and was refused in unattended runs).

## 2. Inventory

Start the subagent `pv-architect` with the following task description:

```
Inventory the source manuscript. Main file <path>. Complete verification/INVENTORY.md and verification/RESULTS.json as specified in the pv-architect definition.
No network, no downloads; do not modify source/.
```

When it returns, you check:
- run `python3 scripts/pv_status.py validate`; it must be VALID;
- pick 2–3 results at random, and open the `.tex` yourself to check that the statement and proof locations are correct;
- no example entries are left over in `results` and `external_tools`;
- the number of numbered results matches the table in INVENTORY;
- definitions and assumptions have not been treated as numbered results.

If anything is wrong, have pv-architect correct it.

## 3. Create the records

1. `verification/PAPER_VERIFICATION.md`: run `python3 scripts/pv_status.py init-checklist`. It creates one row for each numbered result, with the verdict "Unfinished", the PDF number, the page (from the `.aux`, if present) and the source location, and sets the header counts to the actual numbers, for example "**26 numbered results: 0 verified unconditionally, 0 verified conditionally, 0 with recorded issues, 26 unfinished**". validate checks this line.
2. `verification/EXTERNAL_TOOLS.md`: list the candidate external inputs from INVENTORY as "candidates". They are settled only during drafting and the gate, and only once settled are they registered in `external_tools` in `RESULTS.json`.
3. `defs`: if the inventory shows that the paper has no definitions that need to be shared, register `{"id": "NONE"}`.
4. `verification/RESUME.md`: write the current position ("Inventory complete") and the next step ("/pv-run").
5. Run `python3 scripts/pv_snapshot.py save --label setup`.

## 4. Report to the user

- the total number of numbered results (counted by kind), the number of unnumbered claims, the number of levels in the dependency graph;
- the progress table (`python3 scripts/pv_status.py table`), all Unfinished at this point;
- the candidate external inputs, listed by type (i)–(v), pointing out type (iii) in particular, i.e. those that the source never states;
- notational ambiguities: ask the user to decide only on readings that affect the whole paper; for the others, write "to be ruled on by the gate according to the source";
- the suggested order of progression (`python3 scripts/pv_status.py next`);
- remind the user: to run unattended, first read section 2, "Step 4: Set permissions" of the kit's `docs/MANUAL.md`;
- tell the user: once everything is confirmed to be correct, run `/pv-run`; from then on it proceeds automatically all the way.
