# End-to-end test of the guide (2026-09-30)

**What was tested:** the workflow in `GUIDE_EN.md`, on `bench/paper`, in a fresh v1.3 project. Each prompt was sent **verbatim from the guide**, each in a new session, with a Sonnet main session, as section 4A recommends:

1. 8.1, start: setup, every result checked, then the report;
2. the author corrects Lemma 2.3 (`x ≠ −1` → `x > −1`, and adds "Since 1+x > 0 …") and replaces `source/`, including a new PDF and `.aux`. Then 8.3, the revision prompt;
3. 8.4, human check: a person checked the cited Nesbitt inequality;
4. 8.5, report.

The run's token report is `usage_W2-v13-workflow.md`.

## Results

| Step | Prompt | Outcome | Cost (list price) |
|---|---|---|---:|
| 1 | 8.1 | The baseline was made automatically. All 3 verdicts are as expected: 2.1 UNCONDITIONAL; 2.2 CONDITIONAL on Nesbitt (i); 2.3 ISSUE `ERROR` with a reviewed Lean counterexample. The 3 report files were written, and the independent fact-check found 14 problems in the first draft (1 Major: the draft claimed two reviewers had proved Nesbitt's inequality, when only one side probe had), all corrected. 34 path references, 0 missing; `validate` VALID | $21.20 |
| 2 | 8.3 | `/pv-revise` found that only Lemma 2.3 changed and reset only it, with `pv_status.py reset`. Its previous verdict was kept in `history`, and B01 was marked RECHECK. 2.1 and 2.2 kept their verdicts. 2.3 was redrafted, gated, proved and audited: **UNCONDITIONAL**. B01 was closed with `record --resolve`, citing the new final audit. `followup`: "2.3: Recorded issue → Verified unconditionally; B01: resolved". The old baseline was archived and a new one made | $5.06 |
| 3 | 8.4 | Recorded with `pv_status.py human-check` (who, when, against what). 2.2 **stays CONDITIONAL**; the table shows "Verified (conditional); conditions checked by a person" | $0.15 |
| 4 | 8.5 (revised, see below) | The report was regenerated with section 0b "What the revision changed" (before/after table, what was wrong, what changed, re-verification, no downstream impact) and the "Checked by a person" column. The fact-check found 14 problems, all corrected; paths 0 missing | $7.29 |
| | | **Final state:** 2 verified unconditionally, 1 verified conditionally (its condition checked by a person), 0 issues, 0 unfinished | **$33.70** |

## Problems found by this test, and fixed

1. **The source baseline needed an approval that an unattended run cannot give.** Found in a first attempt of this test, which was then cut short by the account's usage limit. `/pv-setup` used `cp -R`, which an unattended session refuses. It now uses `pv_snapshot.py baseline` (allowed, never overwrites). In this run the baseline was made automatically.
2. **The first wording of the report prompt was refused.** "Follow .claude/skills/pv-report/SKILL.md …" made the model try the Skill tool. The skills are user-invocable only, so the tool refused, and the model then declined to follow the file by hand (`session_4_report_refused.json`). The same wording had worked in prompts 8.1 and 8.3. Fixes:
   - `CLAUDE.md` now says that reading the SKILL.md and carrying out its steps is the intended way;
   - the 8.5 prompt now says "Read … and carry out its steps yourself";
   - the project was brought up to date with `install.sh --upgrade` (2 files replaced, VALID). The revised prompt then worked.
3. **Archived baselines were numbered from v2.** The first archived baseline (the original manuscript) is now `source_baseline_v1/`.

## Not covered by this test

- Slash commands typed in the desktop app (`/pv-status`, `/pv-resume`, …) are Claude Code's standard way to start the same skills. This headless test sent prompts, not keystrokes.
- A revision that changes a result other results depend on (a cascade reset). `reset` lists dependents for the coordinator, but this paper's revision touched only an independent lemma.
