# Fact check of the final report (pv-factcheck)

- Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
- Sources read directly: `source/main.tex` (all 90 lines); all `verification/audits/*_final.md`, `*_issue_1.md`, `*_issue_1_audit.md`, `DEFS_gate.md`, `L02_gate.md`, `P01_gate.md`, `P01_gate_r2.md`, item 7 of `L01/L03/P02/P03_gate.md`; `BLOCKERS.md`, `RESULTS.json`, `PAPER_VERIFICATION.md`, `AUDIT.md`, `EXTERNAL_TOOLS.md`, `DOC_ERRATA.md`, `RESUME.md`, `VERDICTS.md` §1–§2; all `pv_work/*.lean` sources (Defs, Stmt, main, ModGaps, Counterexample declarations); work drafts `consistency_check.md`, `author_notes.md`.
- No commands run other than read/grep/ls. No network.

**Counts: Major 1, Moderate 3, Minor 7.**

## 1. Problem table

| # | Sev. | Report text | What the source says | Source file:line | Suggested correction |
|---|---|---|---|---|---|
| F1 | **Major** | AUTHOR_REPORT.md:105, §5 row P1: "Optional presentational suggestion: add a one-line argument or citation for 'well known' concavity (gate item 7 classified it as a fair implicit step; not a recorded fix)." | No audit record suggests adding an argument or citation. The gate only classifies main.tex:61 as "at most `FAIR_IMPLICIT_STEP`/`EDITORIAL`, not a paper issue"; r2 repeats that; the final audit calls it a fair implicit step. The compiler draft itself says "this is not a recorded fix of the gate". | `audits/P01_gate.md:48`; `P01_gate_r2.md:25`; `P01_final.md:53,70`; `report/work/author_notes.md:51` | Suggestion made up by the coordinator. Delete row P1 from §5. If you keep it, move it to "Observations of the coordinator (no review behind them)" as: "main.tex:61 gives no argument or reference for the 'well known' concavity; the reviewers classified it as FAIR_IMPLICIT_STEP/EDITORIAL and recorded no fix (based on `P01_gate.md` item 7, `P01_final.md` §6)." |
| F2 | Moderate | AUTHOR_REPORT.md:106, §5 row P2: "Say whether `I` is open or closed and use one meaning throughout (`L02_issue_1.md` §6; `L02_gate.md` item 5)." Also §6 Author intent 4 (line 119): "Confirm one reading of `I` for the whole paper". | The ruling's fix is to state the interval at :24 **or** to restrict only Lemma 2.2 to (0,1). If `I` means [0,1] elsewhere, it prefers restricting only `lem:positive`. The audit adds that stating [0,1] at :24 is **not** sufficient, because Lemma 2.2 becomes false. P2 as written invites the authors to pick [0,1] throughout, which the audit says leaves 2.2 false. It also contradicts the preferred local fix. "item 5" of `L02_gate.md` is the step-obligations item; the consistency note is focus-ruling item 5. | `audits/L02_issue_1.md:78-80`; `L02_issue_1_audit.md:55-56`; `L02_gate.md:33` (focus ruling 5) vs `:41` (item 5) | Replace P2 with: "main.tex:24: state which interval `I` is. If `I`=[0,1] is intended, Lemma 2.2 must be restated for p∈(0,1); stating [0,1] at :24 alone leaves Lemma 2.2 false (`L02_issue_1.md` §6, `L02_issue_1_audit.md` §6)." Or delete P2, since it duplicates §4.1. Cite "`L02_gate.md` focus ruling item 5". Reword §6 Author intent 4 to: "Confirm which reading of `I` each of 2.2, 2.3, 2.4 is meant under (verification used open for 2.2/2.4, closed for 2.3; `L02_gate.md` focus ruling 5)." |
| F3 | Moderate | AUTHOR_REPORT.md:3: "it has passed an independent fact check, whose report is in …factcheck.md"; AUTHOR_REPORT.md:136: "The independent fact check of this report's first draft found N problems, which have been corrected. (Filled in after the fact check.)" | This fact check found 11 problems (1 Major, 3 Moderate, 7 Minor). The draft has not yet passed it. | this file | After the corrections are made, set line 136 to "found 11 problems (1 Major, 3 Moderate, 7 Minor), which have been corrected" and remove the placeholder. Until then, line 3 must not say "has passed". |
| F4 | Moderate | AUTHOR_REPORT.md:126, §7: "Technical formalization assumptions approved by the gates: the two readings of `I` are encoded as `IOpen`… `IClosed`…; `V`…; `s2`… See `DEFS_gate.md`." | The gates record **no** TFAs. The `I` choice is explicitly "Representation choice (not a TFA)". In VERDICTS, TFA is a defined formalization-side class. | `audits/DEFS_gate.md:30-32` ("TFAs ruled on: None"); `L02_gate.md:49-55`; `P01_gate.md:50-54`, `P01_gate_r2.md:29`; `VERDICTS.md:96` | Write: "TFAs: none (all gates). Representation choices approved by the gates (not TFAs): `IOpen = Set.Ioo 0 1`, `IClosed = Set.Icc 0 1` (`Defs.lean:13, 16`); `V` (`Defs.lean:21`); `mean`, `s2` on `Fin m → ℝ` with real `(m:ℝ)-1` (`Defs.lean:25, 29`)." |
| F5 | Minor | AUTHOR_REPORT.md:15: "Lemma 2.4 is a counterexample to the printed statement (false as printed)" | Lemma 2.4 is the refuted statement; it is not itself a counterexample. | `audits/L03_issue_1_audit.md:66` | "Lemma 2.4 is false as printed (Lean counterexample n=1, p=1/10)". |
| F6 | Minor | AUTHOR_REPORT.md:90, §4.x row main.tex:86-87: "Fair implicit step; proved as `s2_nonneg` — `P03_final.md` §4" | `P03_final.md` §4 calls `s2_nonneg` "a technical fill-in". The FAIR_IMPLICIT_STEP ruling is in §5 (route fidelity), and in the issue ruling §3. | `audits/P03_final.md:48` (§4), `:57` (§5); `P03_issue_1.md:51-53` | Cite "`P03_final.md` §5 (and §4); `P03_issue_1.md` §3". |
| F7 | Minor | AUTHOR_REPORT.md:128, §7: "the gate's second round (`P01_gate_r2.md`) replaced it by a proved step." | The first-round gate found the "not in mathlib" evidence wrong and recommended option A (discharge as step S0). The draft was amended accordingly. r2 only confirmed that the amendment was implemented. | `audits/P01_gate.md:39-47, 64-67`; `P01_gate_r2.md:16-19` | "The first-round gate (`P01_gate.md` item 6) found the mathlib evidence wrong and recommended discharging it; the draft was amended to proved step `P01_S0`, confirmed by `P01_gate_r2.md`." |
| F8 | Minor | AUTHOR_REPORT.md:33, §1 item 4: "All three have Lean evidence (counterexample files and gap files)." | L02 has no gap file. Its evidence is a full proof under the open reading plus a counterexample under the closed reading. | `audits/L02_final.md:42-44` | "All three have Lean counterexample files; 2.4 and 2.6 also have gap files; 2.2 is fully proved under the open reading." |
| F9 | Minor | AUTHOR_REPORT.md:106 (P2) and `author_notes.md:52` cite "`L02_gate.md` item 5" | See F2: the content is in focus-ruling item 5, not item 5 of the item-by-item rulings. | `audits/L02_gate.md:33` vs `:41` | "`L02_gate.md` focus ruling, item 5". |
| F10 | Minor | FILES_TO_CHECK.md:13: "Lean proof bodies. They compile, have no `sorry`…" | True for the listed main files. But `pv_work/L03.lean:16` and `pv_work/P03.lean:10` contain `sorry`: they are unbuilt drafts superseded by the gap files. A reader browsing `pv_work/` will see them. | `pv_work/L03.lean:16`, `pv_work/P03.lean:10`; `audits/L03_final.md:38`, `P03_final.md:36` | Add: "(`pv_work/L03.lean` and `pv_work/P03.lean` are drafts with `sorry` for the false step; they are not built and not evidence. Use the `…ModGaps.lean` files.)" |
| F11 | Minor | AUTHOR_REPORT.md:125: "Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`)" | The record I can check is `RESULTS.json` `lean.packages`: "linked; mathlib modules compiled: 6305 of 6305". I did not run the command. | `verification/RESULTS.json:12` | Cite `RESULTS.json` (`lean.packages`) as the source. |

## 2. Checked and found correct

**§0 Summary table / header**
- Counts 3/0/3/0 match `RESULTS.json`, `PAPER_VERIFICATION.md:3`, `AUDIT.md:10-15`.
- The verdict of each row matches `RESULTS.json` and the final audits:
  - L01, P01, P02: UNCONDITIONAL, CONDITIONS: none.
  - L02: ISSUE. The final audit suggests UNCONDITIONAL only for the open reading and defers to the issue ruling (`L02_final.md:79`). ISSUE follows VERDICTS §1.3.
  - L03, P03: ISSUE.
- Issue classes match the rulings: DOMAIN_CLARIFICATION (`L02_issue_1.md:94`), ERROR (`L03_issue_1.md:85`), PAPER_ARGUMENT_GAP (`P03_issue_1.md:120`). All three were confirmed COUNTEREXAMPLE VALID.
- "Not fully verified" is stated (line 5); VERDICTS §5 is respected.
- No overstatement: 2.6 is described as "conclusion not refuted", not as false.

**§1 Overall findings**
- The downstream claim is correct. The only `\ref` in main.tex are `lem:quarter` at :70 and :78, which I checked in the source.
- Lemma 2.1 stays verified.

**§2 Verdict table**
- All Lean `file:line` references were verified in the source files:
  - `L01.lean:21` `L01_main`
  - `L02.lean:17` `L02_main`
  - `P01.lean:60` `P01_main`, with `P01_S0` at `P01.lean:9`
  - `L03ModGaps.lean:18` `L03_main_mod_gaps`, with `L03_S2_Gap` at :13
  - `P02.lean:23` `P02_main`
  - `P03ModGaps.lean:26` `P03_main_mod_gaps`, with `P03_S1_Gap` at :8
- The L01 hypothesis is only `1 ≤ n` (`L01.lean:21`).
- P02 sharpness: confirmed by the non-vacuity probe (`P02_final.md:52`).
- P01 holds under both readings (`P01_final.md:60, 69`).

**§3 External dependencies / Worksheet**
- `"external_tools": []` (`RESULTS.json:261`). The registry is empty (`EXTERNAL_TOOLS.md:8-10`). The candidates table is marked settled (`EXTERNAL_TOOLS.md:27-29`).
- Every final audit reports `CONDITIONS: none`.
- Gap hypotheses are correctly kept out of the external inputs (VERDICTS §1.2).
- Worksheet:
  - Lean names and lines are correct, and the printed steps quote main.tex:70 and :86 correctly.
  - The refutation witnesses are correct: n=1, p=1/10 (`L03_issue_1_audit.md:66`); m=2, x=y=(0,1) (`P03_issue_1_audit.md:52`).
  - "says nothing about the printed claims" agrees with `L03_final.md:68` and `P03_final.md:62`.

**Defs.lean line numbers** (report §7, worksheet, FILES_TO_CHECK §3)
- `IOpen` :13 and `IClosed` :16: correct.
- `V` :21: correct.
- `mean` :25 and `s2` :29: correct.
- The definitions' contents match the descriptions. `s2` uses the real number `(m:ℝ) - 1`.

**FILES_TO_CHECK §2 source line ranges** (all against main.tex)
- 2.1 → 38-45 (lemma 38-40, proof 42-45)
- 2.2 → 47-53
- 2.3 → 55-63
- 2.4 → 65-71
- 2.5 → 73-79
- 2.6 → 81-88

All correct. The Lean file:line, the helper definitions and the audit file lists are also correct, and every listed audit file exists.

**§4 Substantive issues**
- **§4.1 (B1).**
  - The text agrees with the issue ruling, its review and `BLOCKERS.md:23-33`.
  - Arithmetic checked: V_n(0)=V_n(1)=0.
  - The "not affected" list agrees with `BLOCKERS.md:30`, `P01_final.md` §6 and B3.
  - The suggested fix and its caveat are sourced (`L02_issue_1.md:78`, `L02_issue_1_audit.md:55-56`).
  - Lean declarations exist (`counterexample`, `counterexample_one`, etc. in `L02_Counterexample1.lean`).
- **§4.2 (B3).**
  - Arithmetic checked: 9/100 > 1/40. For p>0 the claim is equivalent to p ≥ 3/4.
  - All six declaration names exist in `L03_Counterexample1.lean` (lines 46, 49, 56, 68, 75, 84).
  - Fixes (a)/(b)/(c) are sourced (`L03_issue_1.md:72-77`, `L03_issue_1_audit.md:55-60`).
  - Statuses are correct: "not Lean-checked, not adopted"; "intended bound cannot be determined" (`L03_issue_1.md:82`).
- **§4.3 (B2).**
  - Arithmetic checked: s²((0,2))=2, s²((0,1))=1/2, and 2 ≤ 2 holds.
  - Declarations exist (`P03_Counterexample1.lean` lines 50, 57, 74, 115, 145).
  - The covariance fix and the "c=0 weakens" remark are sourced (`P03_issue_1.md:94-100`, `P03_issue_1_audit.md:46`).
  - It is correctly labelled reasoning only.
- **§4.x reviewer-ruling rows.** Rows 1 and 3 cite reports that contain the stated rulings. For row 2, see F6.
- **Coordinator observations.** Both are labelled as having no review behind them and state their basis. Row 1 also agrees with `L02_issue_1_audit.md:45` and `L03_issue_1_audit.md:53`.

**§6 Human-check list**
- Every item has a source: `L02_issue_1.md:91-92`; `P03_issue_1.md` §4, §7, §8; `L03_issue_1.md:82`; `L03_issue_1_audit.md` §5; `P03_issue_1_audit.md` §5.
- No recorded human-check item is missing.
- For author intent 4, see F2.

**§7–§8 Formalization limits and process disclosure**
- The toolchain matches `RESULTS.json`, and `mathlib_rev` is empty.
- Corrections recorded in BLOCKERS are now present:
  - B1 "not affected" and fix lines (`BLOCKERS.md:30-31`)
  - B3 three fixes (`BLOCKERS.md:55`)
  - EXTERNAL_TOOLS candidates settled
- DOC_ERRATA has the P01 notes entry.
- The `models_used` remark matches `RESULTS.json`.
- The verdict-line correction is disclosed as in `RESUME.md:41`.

**Omissions**
- All open entries in BLOCKERS (B1, B2, B3) are covered with correct severity.
- No "Status for the authors" content of any final audit is missing.
- The gates for L01, P02 and P03 report no further doubts about the source; L03's doubt is covered by B3.

## 3. Could not be checked

- "No content changed" when the auditor rewrote the verdict lines of the P03/L03 audits (`RESUME.md:41`). There is no earlier version to compare against.
- The output of `scripts/pv_lean.sh packages` (6305 of 6305). The command was not run; only `RESULTS.json` was checked.
- Whether the current `.lean`/`.olean` files still match the hashes in the audit records. I did not re-hash them.
- `RESULTS.json` `models_used` semantics (UNVERIFIED in the report as well).
