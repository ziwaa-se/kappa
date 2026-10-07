# Working constraints (all roles must follow these; they take precedence over any other habit)

This kit does one thing only: **faithfully translate the proofs already written in the TeX into Lean, actually compile them, and decide which of the four classes each numbered result belongs to**. The four classes are defined in `VERDICTS.md`. The kit does not repair proofs for the author, and it does not search for new proofs on its own.

## 1. Fidelity

1. **Do not try new proof methods, do not repair proofs for the author, do not modify the source text, and do not quietly add substantive assumptions.**
   - Every Lean step must correspond to a specific sentence of the source; record its `file:line`.
   - Only conversions of notation, types and form of expression are allowed.
2. **Allowed expansions:**
   - steps that the source states explicitly or that are standard implicit steps;
   - technical details derivable from existing hypotheses, e.g. measurability, domains, type class instances;
   - calls to standard results already in mathlib, but record which sentence of the source each one corresponds to.
3. **Disallowed expansions:**
   - adding mathematical statements that are not in the source in order to rescue a proof;
   - switching to a different proof route;
   - dressing up a missing substantive assumption as a technical detail.
4. **Stop the target at the first logical step that cannot be matched to the source.**
   - Keep the exact Lean input, output and unsolved goal, and determine which class of issue it is (see `VERDICTS.md` §2).
   - Continue with other targets that do not depend on this step.
5. **Pure interface errors may be fixed directly**, e.g. a wrong API name or a type mismatch. Make only one transcription fix per spot, with a clear direction; if it still does not match the source after the fix, handle it as `TRANSLATION_BLOCKED`. Such fixes cannot serve as evidence of a paper error.
6. **Our own representation choices must not be used to manufacture paper errors.** Conventions given in earlier paragraphs of the source, choices of representatives, and standard implicit steps must all be adopted fairly.
7. **When checking B conditional on a predecessor result A**, record A's applicability conditions and how they are satisfied in B. A problem in A's proof does not automatically mean that B's own derivation has a problem.
8. **Independent mathematical review** (reasoning without Lean evidence) may serve only as a lead, or as evidence labeled "reasoning, not checked in Lean"; it **must not pass itself off as a Lean verdict**.
9. **Do not do auxiliary research or numerical experiments unrelated to this paper.**

## 2. Lean rules

- **Forbidden:** `sorry` (except at the draft stage), `admit`, new `axiom`, `unsafe`, `native_decide`, `implemented_by`, `@[extern]`, `set_option debug.skipKernelTC`.
- **Axioms:** a completed proof may use only `propext`, `Classical.choice`, `Quot.sound`.
- **Drafts:** drafts containing `sorry` use only `pv_lean.sh check` and **do not produce an `.olean`**. Move stale drafts to `pv_work/superseded/` and explain why in the `README.md` there.
- **The conclusion must not become a hypothesis.** Never write the target conclusion or an equivalent of it as a premise (e.g. `(hB : B) : B`).
- **Versions:** do not upgrade Lean or mathlib, do not run `lake update`, do not run `lake exe cache get` (it goes online).
- **When the `.olean` of some mathlib module is missing:**
  - First run `scripts/pv_lean.sh packages` to see whether `.lake/packages` is a link or a copy.
    - If it is a link, mathlib is **shared** with other projects; running `lake build` is **forbidden**, because it would write into those other projects. Record the result as `TRANSLATION_BLOCKED`, state which module is missing, and tell the user they can switch to a copy-based install (see the kit's `docs/MANUAL.md`).
    - If it is not a link, you may run `lake build Mathlib.<SpecificModule>` for that module only, and record it. If the permission settings forbid `lake build`, do not try to get around this; record it as `TRANSLATION_BLOCKED` and state which module is missing.
- **import:** prefer importing modules as needed; use `import Mathlib` only when the full mathlib cache has been downloaded.
- **"This interface does not exist" must have evidence**: the output of `#check` or of a search.
- **Never rely on grep to decide whether something is used.** You must use `#pv_axioms` or `#pv_walk` (see `VERIFICATION_METHODS.md`).
  - a byte grep of an `.olean` gives false positives, because docstrings are stored in the olean;
  - some shells' `grep` aliases skip binary files.

## 3. Independence and division of labor

- **Separation of roles:**
  - the drafter (pv-drafter) writes statements;
  - the statement gate reviewer (pv-gate) independently reviews statements before proving;
  - the prover (pv-prover) writes proofs;
  - the final auditor (pv-auditor) reviews independently after proving.

  Each role uses a **fresh subagent context**. **Reviewing your own work and then claiming it passed independent review is not allowed.**
- The **coordinator** (the main session) is responsible for: dispatching work, checking outputs, writing records, and reporting to the user. The coordinator **does not write proofs and does not stand in for review**.
- **Models per role (v1.3).** The judgement roles run on the strongest model: pv-gate, pv-auditor, pv-issue-checker and pv-factcheck (`opus`). pv-architect, pv-drafter, pv-compiler and the first proof session run on `sonnet`; the drafter's work is checked by the gate and the prover's by the auditor, and a stuck proof escalates to `opus` (`PIPELINE.md` stage 4). The coordinator may run on `sonnet`. Independence is unchanged: every role is still a fresh subagent.
- **Do not trust summaries.** Reviewers must read the source and the code themselves, not just the prover's or the coordinator's summary. Summaries written by the coordinator must also pass an independent fact check (`pv-factcheck`) before delivery.
- **Copy files with Read/Write, and move files away with `pv_status.py supersede`**; do not use `cp`, `mv`, `mkdir`. When a directory is needed, the script or the Write tool creates it automatically.
- **Each Lean file may have only one writer at a time.** Reviewers write only their own reports and probes under `pv_work/probes/<your-role>/<ID>/`. Stale files are moved to `pv_work/superseded/` and registered by the **coordinator**.
- **Reviewed files are not modified again**, including comments: docstrings go into the `.olean`, and a change would invalidate the "byte-for-byte identical" review record. Comments needing correction are recorded in `verification/DOC_ERRATA.md`.
- If a reviewed file really must be modified, the affected parts must be reviewed again.

## 4. Safety and environment

- **Without the user's explicit permission in chat, do not download any file and do not search online** (including literature PDFs and web pages).
  - When literature needs to be checked, put it on the human-check list.
  - A download without the user's permission is a **violation** and must be disclosed to the user.
- **Do not modify `source/`** (the source manuscript).
- **Do not modify files outside this project.**
- **Do not modify** `verification/rules/`, `pv_work/PVTools.lean`, `.claude/`, `verification/source_baseline/`. They are the rules, the review tools and the baseline, and only the user may change them. There are only two exceptions, both carried out by the coordinator with `python3 scripts/pv_snapshot.py baseline`, which only creates, never overwrites (v1.3):
  - `/pv-setup` creates the baseline (`baseline`);
  - `/pv-revise`, once every change is registered, keeps the old baseline as `source_baseline_v<k>/` and creates a new one (`baseline --new-version`).
- When a violation is found, tell the user immediately and truthfully.

## 5. How to proceed

- **The user has authorized continuous automatic progress through all numbered results**: there is no need to ask permission item by item. When a problem is found, **record it and continue**; the user will check and fix it manually.
  - Stop to ask only when a decision truly can be made only by the user and would change a large amount of subsequent work, e.g. the reading of the domain for the whole paper.
- **Order:**
  1. proceed in dependency order;
  2. within that, prioritize the **paper's numbered results** that the most other results depend on;
  3. build infrastructure only when a source step really needs it, and within budget (see `PIPELINE.md`).
- **Parallelism:** mutually independent targets may be advanced at the same time. By default, the **total** number of subagents running at once (including issue rulings and reviews) is at most 3.
- **Saving along the way:**
  - update `verification/RESUME.md` **when starting each subagent** and **after each milestone**; after a milestone, run `python3 scripts/pv_snapshot.py save`;
  - subagent reports must be **written incrementally**.

  After the usage quota runs out or work is interrupted, the user can come back and say "read verification/RESUME.md and continue", or run `/pv-resume`, to pick up where things left off.
- **Report progress to the user at every stage:** a short paragraph plus the English progress table (`python3 scripts/pv_status.py table`).
- **Wrap-up:** once every numbered result has a verdict, move to the report stage (`/pv-report`).
  - While unverified external parameters remain, **do not claim the whole paper is fully verified**.
  - Deliver faithful item-by-item conclusions; **do not force everything to green**.
