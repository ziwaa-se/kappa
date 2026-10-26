# Fact check of the final report, revision 2 (pv-factcheck)

Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.

Sources read:
- `source/main.tex`, the whole file (84 lines);
- `verification/audits/{L01,L02,T01,C01}_final.md` in full, `C01_gate.md` in full, and the other gates by grep;
- `verification/audits/rev2/L02_issue_1.md`;
- `RESULTS.json`, `BLOCKERS.md`, `AUDIT.md`, `EXTERNAL_TOOLS.md`, `DOC_ERRATA.md`, `PAPER_VERIFICATION.md`, `RESUME.md`, `VERDICTS.md` §5;
- the work drafts `consistency_check.md` and `author_notes.md`, and the archived factcheck of revision 1;
- `pv_work/Defs.lean`, `C01.lean`, `T01Stmt.lean`, `L01Stmt.lean`, plus the declaration lines of every current Lean file;
- `lean-toolchain`.

Commands run:
- `python3 scripts/pv_status.py followup`;
- `python3 scripts/pv_status.py tools`, which returned an empty registry.

COUNTS: Major 1, Moderate 4, Minor 9

## Problem table

| # | Sev. | Report text | What the source says | Source file:line | Correction |
|---|---|---|---|---|---|
| 1 | **Major** | AUTHOR_REPORT §4.x row 2 ("main.tex:70 \| θ²+σ² > 0, R(0) = θ², R(1) = σ², zero-product step \| fair implicit steps, proved in Lean \| `T01_final.md`"), and §2 row 2.3 ("R(0) = θ², R(1) = σ² and θ²+σ² > 0 proved inside Lean as fair implicit steps") | T01_final gives FAIR_IMPLICIT_STEP only for two things: deriving θ²+σ² > 0 from :25, and the "square is zero iff base is zero" step. It rules R(0) = θ², R(1) = σ² as "faithful, direct computation from :29". The source prints both equalities ("Since R(0) = θ² and R(1) = σ²", main.tex:70), so they are not implicit. The FAIR_IMPLICIT_STEP ruling for R(0)/R(1) has no review behind it, yet it is presented as a reviewer ruling. The same wording is in `EXTERNAL_TOOLS.md:42`, a coordinator note added at report time. | `verification/audits/T01_final.md:62`, `:63`, `:78`; `source/main.tex:70` | §4.x row 2: "main.tex:69-70 \| θ²+σ² > 0 derived from main.tex:25, and (c−c*)² = 0 ⇒ c = c* \| FAIR_IMPLICIT_STEP, proved in Lean \| `T01_final.md` §6". §2 row 2.3: "θ²+σ² > 0 (from main.tex:25) and the zero-product step are fair implicit steps; R(0) = θ², R(1) = σ² are printed at main.tex:70 and proved by direct computation". Fix `EXTERNAL_TOOLS.md:42` in the same way. |
| 2 | Moderate | AUTHOR_REPORT:3 "it has passed an independent fact check, whose report is in `verification/report/work/factcheck.md`" | No fact check of the revision-2 report existed when the draft was written: `report/work/` held no factcheck.md, and the only earlier one is the archived revision-1 check. This check finds 1 Major and 4 Moderate problems. | `verification/report/work/` (listing); `verification/report_archive/20261013-012513/work/factcheck.md` | After the corrections are applied: "it was independently fact-checked (`verification/report/work/factcheck.md`); the corrections listed there have been applied". |
| 3 | Moderate | AUTHOR_REPORT:111 "The independent fact check of this report's first draft found FACTCHECK_N problems, which have been corrected." | The placeholder was never filled in, and the sentence claims the corrections were made before the check ran. | this file, COUNTS line | "The independent fact check of this report's first draft found 14 problems (Major 1, Moderate 4, Minor 9); they were corrected as listed in `factcheck.md`". Write this only once that is true. |
| 4 | Moderate | AUTHOR_REPORT:110 "...the human-check list and 'Next steps' in `RESUME.md` predate the resolution of B1 (updated in RESUME at this milestone)" | RESUME.md was not updated. "Next steps" still reads "Run `/pv-run L01 L02`". The human-check list still asks to confirm the B1 fix, still lists `T01_L02Consumed`, and still says C01 "inherits B1". The same sentence also calls these records "reported but not edited", which contradicts "updated". | `verification/RESUME.md:27-29`, `:36-41` | Either update RESUME.md and move the item to "corrections made", or delete "(updated in RESUME at this milestone)". |
| 5 | Moderate | AUTHOR_REPORT §7: "the Lean version string was not printed by any kit command available in this run (UNVERIFIED here)" | The project records the toolchain and Mathlib commit: `leanprover/lean4:v4.19.0`, Mathlib `c44e0c8ee63ca166450922a373c7409c5d26b00b`. | `lean-toolchain:1`; `verification/RESULTS.json:10-11` | "Lean 4.19.0 (`lean-toolchain`), Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json` `lean`); mathlib modules compiled: 6305 of 6305." |
| 6 | Minor | WORKSHEET:27-28 and FILES_TO_CHECK:40-42 put `risk`, `oracleFactor`, `oracleRisk` at `Defs.lean:13`, `:16`, `:19` | Those lines are blank. The definitions are at lines 12, 15 and 18. `Setting` at :7 is correct. | `pv_work/Defs.lean:12`, `:15`, `:18` | Change to `Defs.lean:12`, `:15`, `:18` in both files. |
| 7 | Minor | AUTHOR_REPORT §2 row 2.4: "R(c*) ≤ R(1/2) using Lemmas 2.1 and 2.2 directly" (§1 item 5 is similar) | The main theorem uses only Lemma 2.1 (S1, S2). Lemma 2.2 enters only through the remark obligation S4 at main.tex:80. | `verification/audits/C01_final.md:57`, `:70`; `pv_work/C01.lean:33-42` | "R(c*) ≤ R(1/2) from Lemma 2.1 (S1, S2). Lemma 2.2 is used only for the remark at main.tex:80 (S4)." |
| 8 | Minor | AUTHOR_REPORT §4.x row 3: ruling "EDITORIAL / FAIR_IMPLICIT_STEP" for main.tex:80 | The final audit gives EDITORIAL for :80 (the citation to lem:min). FAIR_IMPLICIT_STEP is its ruling for :79, which uses R(c*) = ρ implicitly. "EDITORIAL / FAIR_IMPLICIT_STEP" is only the gate's preliminary label. | `verification/audits/C01_final.md:53`, `:71`; `C01_gate.md:56` | "main.tex:80: EDITORIAL (`C01_final.md` §8); main.tex:79: FAIR_IMPLICIT_STEP (`C01_final.md` §6)". |
| 9 | Minor | AUTHOR_REPORT §5 item 2 (main.tex:79-80, listed under "Editorial typos and wording suggestions") | The audit records this as a FAIR_IMPLICIT_STEP. It is not an editorial slip, and no audit records a wording suggestion for it. The report itself says "not a request". | `verification/audits/C01_final.md:53`, `:71` | Move it to §4.x as a reviewer ruling (row for main.tex:79), and keep only item 1 in §5. |
| 10 | Minor | AUTHOR_REPORT §0b: "here L01 and L02 were reset and T01 and C01 were re-checked as dependents" | T01 and C01 were also reset, by the CASCADE when L02's gated statement changed. Both were then gated again, proved again and given new final audits; this was not a mechanical re-check only. | `verification/AUDIT.md:86-89`, `:117`, `:128` | "L01 and L02 were reset by the revision. T01 and C01 were reset by the cascade, because L02's gated statement changed, and went through gate, proof and final audit again." |
| 11 | Minor | AUTHOR_REPORT §6 "Experiments and unnumbered assertions: none recorded" | Revision 2 added an unnumbered assertion at main.tex:34: "It is the risk of the oracle factor, as Lemma 2.1 shows". Its content, R(c*) = ρ, is proved in Lean as C01_S3 (L01 at c = c*). RESUME says it is "covered by L01's re-check", but L01_final's route table does not treat :34. | `source/main.tex:34`; `pv_work/C01.lean:25-30`; `verification/audits/C01_final.md:53`; `verification/RESUME.md:15` | "main.tex:34 (new in revision 2): R(c*) = ρ, proved in Lean as `Paper.C01.C01_S3`, from Lemma 2.1 at c = c*." |
| 12 | Minor | AUTHOR_REPORT §8, "Records still stale" | Some stale records go unmentioned: <br>• BLOCKERS B1 cites `source/main.tex:54-55`, a sentence that no longer exists, and `pv_work/L02ModGaps.lean`, which is now under superseded/rev2; <br>• RESULTS.json `run_scope` is `["C01"]`; <br>• `models_used` is `["sonnet"]`, although the gates and audits ran on Opus; <br>• the EXTERNAL_TOOLS.md candidate table uses old line numbers (54, 65, 75, 64); <br>• the PAPER_VERIFICATION.md C01 row is thin. | `verification/BLOCKERS.md:26`, `:30`; `RESULTS.json:15-17`, `:58-60`; `EXTERNAL_TOOLS.md:31-34`; `PAPER_VERIFICATION.md:14`; `report/work/consistency_check.md:16`, `:22-25` | Add these to "Records still stale, reported but not edited". |
| 13 | Minor | AUTHOR_REPORT §8 "Coordinator corrections made at report time" | It leaves out the settlement paragraph `EXTERNAL_TOOLS.md:42` ("added at report time, from the audits") and the obsolescence note added to DOC_ERRATA row 1. The paragraph also carries problem 1 and an old line reference (main.tex:54). | `verification/EXTERNAL_TOOLS.md:42`; `verification/DOC_ERRATA.md:13` | List both edits, and correct `EXTERNAL_TOOLS.md:42` as in problem 1. |
| 14 | Minor | AUTHOR_REPORT §3 and WORKSHEET:16 cite `audits/C01_final.md §3-4` for the removal of `C01_L02Consumed` | C01_final §3-4 says only "no consumed clauses" and never names `C01_L02Consumed`. The removal itself is recorded in the cascade line of AUDIT.md. | `verification/audits/C01_final.md:34`; `verification/AUDIT.md:128` | Cite "`AUDIT.md` (C01 cascade, 2026-10-13 01:22); `C01_final.md` §3-4 (no consumed clauses)". |

## Checked and found correct

**Header and §0**
- The counts 4/0/0/0 equal the rows of RESULTS.json, PAPER_VERIFICATION.md:3 and the AUDIT.md index, and they sum to 4 (VERDICTS §5).
- Every final audit ends "FINAL AUDIT: PASS / SUGGESTED VERDICT: UNCONDITIONAL / CONDITIONS: none":
  - `L01_final.md:67-69`;
  - `L02_final.md:64-66`;
  - `T01_final.md:80-82`;
  - `C01_final.md:75-77`.
- The RESULTS.json `conditions`, `debts`, `unencoded`, `issues` and `external_tools` fields are all empty, and `pv_status.py tools` prints an empty table.
- The "Scope of the claim" sentence is allowed, because no parameter remains (VERDICTS §5), and it is qualified by the encodings of D01-D04.

**§0b**
- The before/after verdicts and B1 "resolved" agree with the `pv_status.py followup` output and with RESULTS.json history:
  - L01 UNCONDITIONAL;
  - L02 ISSUE, with B1;
  - T01 CONDITIONAL on `T01_L02Consumed`;
  - C01 UNCONDITIONAL.
- The L02 proof was rewritten at main.tex:58-61 (`AUDIT.md:79`).

**§1**
- No counterexample to any current result exists. No open BLOCKERS entry remains (B1 is marked RESOLVED, `BLOCKERS.md:23`).
- B1's conclusion was true (`rev2/L02_issue_1.md:26`, `:76`).
- The new proof is correct (`L02_final.md:59`).
- T01 and C01 import L01 and L02 directly (`T01_final.md:30-35`, `C01_final.md:43-45`, `C01.lean:2-3`).

**§2**
- Rows 2.1 and 2.2 match `L01_final.md:30`, `:64` and `L02_final.md:47-50`, `:58-59`.
- The "in the same way" step needs θ² > 0 (`L02_final.md:49`; `L02_gate.md:33`).
- Row 2.4's editorial slip at main.tex:80 is confirmed against the .tex.

**§3**
- `T01_L02Consumed` and `C01_L02Consumed` are absent from the current `pv_work` Lean files (grep).
- `T01_final.md:42` says the record should drop `T01_L02Consumed`.
- `Setting` encodes main.tex:25 (`Defs.lean:7-9`).

**§4.x**
- Row 1 (main.tex:60, FAIR_IMPLICIT_STEP, θ ≠ 0 from :25) matches `L02_final.md:49`.
- The coordinator observation is correctly labelled as such and rests on `BLOCKERS.md:23`, `:31` and `rev2/L02_issue_1.md:65`. It does not invent a fix.

**§5 item 1**
- The .tex at main.tex:80 reads "By Lemma~\ref{lem:min}, moreover, $R(c^\ast) = \rho \le \min\{\theta^2, \sigma^2\}$".
- main.tex:34 reads "It is the risk of the oracle factor, as Lemma~\ref{lem:square} shows".
- The slip matches `C01_final.md:71` and `C01_gate.md:56`.

**§6**
- The paper cites nothing (no `\cite` in main.tex).
- The main.tex:80 attribution item has a source (`author_notes.md:27`). C01_S3 exists (`C01.lean:25`).
- No author-intent item is open, since B1 is resolved.

**§7**
- The D01-D04 lines match `RESULTS.json:289-312`, and `DEFS_gate.md` exists.
- mathlib modules compiled: 6305 of 6305 (`RESULTS.json:12`).
- No TFAs were approved (`C01_gate.md:42-46`; L01, L02 and T01 gates).
- The DOC_ERRATA rows match `DOC_ERRATA.md:13-14`.

**§8**
- `baseline_before` points to the missing `source_baseline_v2`: confirmed (`RESULTS.json:215`, `:280`; the directory listing has no v2).
- B1's evidence paths have moved to `verification/audits/rev2/` and `pv_work/superseded/rev2/`: confirmed by the directory listing.
- AUDIT.md records no violations.

**FILES_TO_CHECK**
- Main theorem lines are correct: `L01.lean:64`, `L02.lean:31`, `T01.lean:47`, `C01.lean:38`.
- Statement definition lines are correct: `L02Stmt.lean:7`, `T01Stmt.lean:10`, `C01Stmt.lean:9`.
- Source ranges for all four results are correct, and the audit files listed exist.
- `pv_lean.sh` has `build`, `check` and `packages` modes.

**WORKSHEET**
- The registry is empty (`pv_status.py tools`).
- The notation table meanings match `Defs.lean`, apart from the line numbers (problem 6).

**Mathematics**
- The expansion at main.tex:48 was re-checked by hand: (c*+d)²σ² + (1−c*−d)²θ² = (θ⁴σ² + σ⁴θ²)/s² + 2d(θ²σ²/s − σ²θ²/s) + s·d².
- main.tex:59-60 holds under θ ≠ 0, σ > 0.

## Could not be checked

- Hashes and `.olean` sha256 values quoted in the audits were not recomputed. Compile logs were not re-read.
- The report-time edits that the coordinator says were made to RESULTS.json and EXTERNAL_TOOLS.md were checked only in their current state, not against earlier snapshots.
- Permission denials and guard refusals were not tabulated by the run.
