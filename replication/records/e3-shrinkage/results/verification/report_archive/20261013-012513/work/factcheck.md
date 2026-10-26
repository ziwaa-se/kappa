# Fact check of the final report (pv-factcheck)

Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
Sources read: `source/main.tex` (whole file; `wc -l` = 78), all `verification/audits/*_gate.md`, `*_final.md`, `L02_issue_1.md`, `L02_issue_1_audit.md`, `DEFS_gate.md` (grep), `RESULTS.json`, `PAPER_VERIFICATION.md`, `BLOCKERS.md`, `AUDIT.md`, `EXTERNAL_TOOLS.md`, `DOC_ERRATA.md`, `RESUME.md`, `VERDICTS.md`, working drafts `consistency_check.md`, `author_notes.md`; Lean files checked by grep for declaration lines and `sorry`.

COUNTS: Major 1, Moderate 5, Minor 10

## Problem table

| # | Sev. | Report text | What the source says | Source file:line | Correction |
|---|---|---|---|---|---|
| 1 | **Major** | AUTHOR_REPORT §4.x row 2: "main.tex:65 \| "θ²+σ²>0" and R(0)=θ², R(1)=σ² stated without derivation \| FAIR_IMPLICIT_STEP (proved in Lean) \| `T01_final.md` §6" | T01_final §6 rules FAIR_IMPLICIT_STEP only for θ²+σ²>0 from σ>0 and for (c−c*)²=0 ⇒ c=c*. R(0)=θ², R(1)=σ² are ruled "faithful computation" of sentences the source prints, not FAIR_IMPLICIT_STEPs and not boundary cases. The R(0)/R(1) part of the row has no review behind it; it comes from the compiler draft (author_notes B-3) and the coordinator's settlement note (EXTERNAL_TOOLS.md:43). | `verification/audits/T01_final.md:64-65` (R(0), R(1): "faithful computation"), `:70-71` (the two FAIR_IMPLICIT_STEPs); `T01_gate.md:40-41` | Restrict the row to "main.tex:64-65, θ²+σ²>0 derived from σ>0 (main.tex:25): FAIR_IMPLICIT_STEP, `T01_final.md` §6 (line 70)". Drop R(0)=θ², R(1)=σ² from the table. If kept anywhere, put it under "observations of the coordinator", based on `T01_final.md:64-65` ("faithful computation"). |
| 2 | Moderate | AUTHOR_REPORT line 3: "it has passed an independent fact check, whose report is in …factcheck.md" | This check finds 1 Major and 5 Moderate problems, so the draft has not passed. | this file | Write "fact-checked; corrections applied per factcheck.md" only after the corrections are made. Until then: "independent fact check: see factcheck.md". |
| 3 | Moderate | AUTHOR_REPORT line 53: "Debts recorded in words: `C01_L02Consumed` …"; §1 item 3: "No debts recorded in words beyond the C01 remark below" | VERDICTS §1.1 item 4: UNCONDITIONAL requires "no provenance debt recorded in words". The auditor rules `C01_L02Consumed` "not a condition of C01", "remark only", because the main theorem's closure does not reach it. Calling it a provenance debt makes the C01 row contradict its own UNCONDITIONAL verdict. EXTERNAL_TOOLS.md:37-41 has the same label. | `verification/rules/VERDICTS.md:25`; `verification/audits/C01_final.md:44`, `:80` | Relabel it "Remark-only parameter (not a condition and not a provenance debt of C01): `C01_L02Consumed` (`pv_work/C01Stmt.lean:15`), used only by `C01_S4` (`pv_work/C01.lean:35`), the remark at main.tex:75-76 (`C01_final.md` §4)". In §1 item 3, write "No provenance debts recorded in words." |
| 4 | Moderate | AUTHOR_REPORT §5 "Editorial typos and wording suggestions", items 2 and 3 (θ²+σ²>0, R(0)/R(1) "left implicit"; nonvanishing of θ²+σ² "left implicit") | The audits rule these FAIR_IMPLICIT_STEPs, which are not issues and need no author action, or faithful computations. The audits record no wording suggestion for them. L01: "Source: correct as printed; no errors, gaps or ambiguities found." T01: "no error or gap; editorial only" (that remark concerns only the Lean docstring, which is on the formalization side). Listing these as author-facing typos or wording suggestions has no source. | `verification/audits/L01_final.md:59`; `T01_final.md:85`, `:70`; `VERDICTS.md:87` | Keep only item 1 (main.tex:75, EDITORIAL, `C01_final.md:78`). Move items 2 and 3 to a line such as "Fair implicit steps filled in Lean (no action needed): main.tex:44-45 (`L01_final.md:51`), main.tex:64-65 (`T01_final.md:70`)", or delete them. |
| 5 | Moderate | AUTHOR_REPORT §7: "the Mathlib commit is not recorded in the project files" | `RESULTS.json` records `"mathlib_rev": "c44e0c8ee63ca166450922a373c7409c5d26b00b"` and `"toolchain": "leanprover/lean4:v4.19.0"`. | `verification/RESULTS.json:10-11` | Replace with "Lean 4.19.0, Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json` `lean`)". |
| 6 | Moderate | FILES_TO_CHECK.md:26: L02 main theorem "`Paper.L02.L02`, `pv_work/L02.lean:31`". FILES_TO_CHECK.md:11: "Lean proof bodies … compile, have no `sorry`" | `pv_work/L02.lean:13` is `sorry` (S2), and `L02` depends on it. The audited object is the gap file `pv_work/L02ModGaps.lean` with main theorem `L02_mod_gaps` at line 25. | `pv_work/L02.lean:12-13`; `pv_work/L02ModGaps.lean:25`; `verification/audits/L02_final.md:4`, `:37` | Row 2.2: "`Paper.L02.L02_mod_gaps`, `pv_work/L02ModGaps.lean:25` (modulo gap `L02_S3_Gap`; `pv_work/L02.lean` contains `sorry` at l.13 and is not the audited object)". Line 11: add "except `pv_work/L02.lean`, which keeps the stopped step S2 as `sorry`; for L02 the gap file `L02ModGaps.lean` is audited". |
| 7 | Minor | AUTHOR_REPORT §3 table and worksheet line 14: type "(p), priority A" | VERDICTS §4.1: a (p) clause "if the predecessor ends up ISSUE or UNFINISHED, it counts as (iv)". Priority A is correct either way (VERDICTS:164). The records (RESULTS.json:192, EXTERNAL_TOOLS.md:10) also say p. | `verification/rules/VERDICTS.md:132`, `:134`, `:164` | "(iv) (predecessor L02, issue B1; gated as (p)), priority A". The same correction applies to the records. |
| 8 | Minor | AUTHOR_REPORT line 15: "it is a false step inside the proof of Lemma 2.2" | The proof makes two false assertions: (A) at l.54 and (B) at l.55. | `verification/audits/L02_issue_1.md:23-24` | "two false assertions inside the proof of Lemma 2.2 (main.tex:54-55)". |
| 9 | Minor | AUTHOR_REPORT §4.x row 1: ruled by "`C01_gate.md` item 7; `C01_final.md` §6" | C01_final §6 rules the sentence "faithful". The EDITORIAL ruling is in §8. The gate item 7 citation is correct ("FAIR_IMPLICIT_STEP / at most EDITORIAL"). | `verification/audits/C01_final.md:66`, `:78`; `C01_gate.md:42` | Cite "`C01_gate.md` item 7; `C01_final.md` §8". |
| 10 | Minor | FILES_TO_CHECK.md:25 "main.tex:37-45" (Lemma 2.1); :26 "main.tex:48-55" (Lemma 2.2) | Lemma 2.1 is at l.38-46, Lemma 2.2 at l.48-56. | `source/main.tex:38-46`, `:48-56`; `RESULTS.json:33-34`, `:69-70` | "main.tex:38-46" and "main.tex:48-56". |
| 11 | Minor | AUTHOR_REPORT §6 human-check list | Two recorded items are missing. (a) The ruling recommends a human note that the proof prints a false inequality (B), which a reader may want to flag as a misstatement. (b) The faithfulness of `L02.Conclusion` and the other Lean statements rests on gate review, not on Lean evidence (author_notes D6). | `verification/audits/L02_issue_1.md:72`; `L02_issue_1_audit.md:54`; `report/work/author_notes.md:45`, `:48` | Add both to "Mathematical completion" or "Author intent". |
| 12 | Minor | AUTHOR_REPORT §1 item 5: "Theorem 2.3 and Corollary 2.4 remain valid as statements" | The truth of L02's conclusion rests on sanity proofs (`conclusion_true`, gate probe), which are not the source route and, by VERDICTS §3.4, never enter a verdict. The ruling says "unaffected as to content". | `verification/audits/L02_issue_1.md:43-44`; `VERDICTS.md:116` | "the content of Theorem 2.3 and Corollary 2.4 is not threatened (`L02_issue_1.md` §5, `L02_issue_1_audit.md` §4)". |
| 13 | Minor | AUTHOR_REPORT §2 T01: "L02 is ISSUE, so no reconnection is possible" | A (iv) clause is reconnected if a revision resolves the issue and the lemma is verified. | `verification/rules/VERDICTS.md:132` | "no reconnection unless a revision resolves B1". |
| 14 | Minor | AUTHOR_REPORT §4.x coordinator observation: "it could be dropped or cite Lemma 2.1" | VERDICTS §3.3 says a suggested fix may come only from auditors or reviewers. The observation is labelled correctly and follows from `C01_gate.md` item 7 and `C01_final.md` §8 ("not needed"; R(c*)=ρ "comes from lem:square"), but the fix wording is the coordinator's own. | `verification/rules/VERDICTS.md:114`; `C01_final.md:78`; `C01_gate.md:42` | State only the facts ("not needed for the corollary; R(c*)=ρ follows from Lemma 2.1 at c=c*"), or keep the sentence explicitly as the coordinator's own suggestion, as now. Acceptable as is if the coordinator prefers. |
| 15 | Minor | AUTHOR_REPORT §4.x lists only three FAIR_IMPLICIT_STEP rows | Other recorded FAIR_IMPLICIT_STEPs are left out: T01 (c−c*)²=0 ⇒ c=c*; C01 S1 (Lemma 2.1 at two points, then subtraction) and S2 (≥0); L02 θ²,σ²>0 and min ≥ 0. | `verification/audits/T01_final.md:71`; `C01_final.md:63-64`; `L02_final.md:71` | Add them, or note that "the table lists only the source-visible boundary cases". |
| 16 | Minor | AUTHOR_REPORT §8, list of record errors "not corrected" | Some record slips are not mentioned. `AUDIT.md:11,40,49` and `RESULTS.json:96` give `pv_work/L02ModGaps.lean:1` for `L02_mod_gaps`, which is actually at line 25. `AUDIT.md` has no entry for the counterexample review `L02_issue_1_audit.md`. `RESULTS.json` L02 `evidence.issues` omits that review. | `verification/AUDIT.md:11`; `RESULTS.json:87-88`, `:96`; `pv_work/L02ModGaps.lean:25` | Add these to "Minor, not corrected". |

## Checked and found correct

**§0 summary table**
- The counts 2/1/1/0 equal the rows and RESULTS.json and sum to 4 (VERDICTS §5).
- Each verdict matches its final audit:
  - L01 UNCONDITIONAL, CONDITIONS none (`L01_final.md:66-67`);
  - L02 ISSUE, CONDITIONS none (`L02_final.md:86-87`);
  - T01 CONDITIONAL, CONDITIONS T01_L02Consumed (`T01_final.md:88-89`);
  - C01 UNCONDITIONAL, CONDITIONS none (`C01_final.md:83-84`).
- The conditions listed equal the `CONDITIONS:` lines and RESULTS.json `conditions`.
- "No result has a condition checked by a person" agrees with EXTERNAL_TOOLS.md:10 ("not yet").
- Line 5 does not claim full verification (VERDICTS §5).

**§1**
- There is no counterexample to any numbered statement: the counterexamples target proof clauses (A) and (B) only (`L02_issue_1_audit.md:51-52`).
- C01's main claim uses only Lemma 2.1 (`C01_final.md:41`, `:77`).
- T01 clauses 1-2 take no parameter. Clause 3 / S5 uses `T01_L02Consumed` (`T01_final.md:42`). Clause locations main.tex:59 and 59-60 are correct.

**§2**: the per-result descriptions match the audits.
- main.tex:25, 53, 54-55, 75-76 are checked against the .tex.
- "½ min ≤ min is fine" matches `L02_final.md:68`.

**§3**
- `T01_L02Consumed` is at `pv_work/T01Stmt.lean:20`, and the worksheet's verbatim quote matches lines 20-21.
- `C01_L02Consumed` is at `pv_work/C01Stmt.lean:15`.
- "Used by T01 step S5, clause le_min" is correct.
- "Lean-proved independently in a gate probe" is correct: `pv_work/probes/gate/L02/gate_L02_falsity.lean:35`, log EXIT=0, `L02_gate.md:36`.
- "External assertions not encoded: none" is correct.

**§4.1**
- The source sentence is quoted verbatim (main.tex:54-55).
- Arithmetic re-checked:
  - 2·1·4/5 = 8/5 > 1;
  - ρ(1,2) = 4/5 > 1/2;
  - HM ≥ min, with equality iff a=b, so (B) fails exactly when θ²≠σ²;
  - HM ≤ 2·min since 2ab/(a+b) ≤ 2a ⟺ b ≤ a+b, so the suggested fix yields ρ ≤ min.
- The Lean evidence files exist:
  - `pv_work/L02_Counterexample1.lean` contains `counterexampleA` (l.26), `counterexampleB` (l.37), `fix_harmonicMean_le_two_min` (l.91) and `fix_chain` (l.100);
  - the gaps `L02_S2_Gap`, `L02_S3_Gap` are in `pv_work/L02ModGaps.lean:12,15`.
- The review passed: COUNTEREXAMPLE VALID (`L02_issue_1_audit.md:69`) and FINAL AUDIT PASS (`L02_final.md:85`).
- Classification PAPER_ARGUMENT_GAP agrees with `L02_issue_1.md:75`, `L02_issue_1_audit.md:54` and BLOCKERS B1.
- The "Not affected" list holds (`L02_issue_1.md:41-45`).
- The suggested fix is sourced (`L02_issue_1.md:65`, `L02_issue_1_audit.md:59`), is labelled a suggestion, and solves the problem.

**§4.x**: row 3 (main.tex:44-45, `L01_final.md:51`) is correct. Row 1 is correct apart from the section number (item 9).

**§5 item 1** is correct against main.tex:75 and `C01_final.md:78`.

**§6**
- "Paper cites no external results" is correct: there is no `\cite` in main.tex.
- `T01_L02Consumed`, the B1 fix intent and the C01 remark have sources: `L02_issue_1.md:71`, BLOCKERS B1, `C01_final.md:78`.
- The statistical interpretation item has a source: `DEFS_gate.md:22`.

**§7**
- Lean 4.19.0 and 6305/6305 match RESULTS.json:10,12.
- `Setting` is at `pv_work/Defs.lean:7`.
- The DOC_ERRATA row matches `DOC_ERRATA.md:13` and `T01Stmt.lean:17`.
- The dupNamespace warning is recorded (`L01_final.md:63`).

**§8**
- C01 `models_used` = ["sonnet"] (RESULTS.json:182-184), while the gate and the audit ran on Opus (`C01_gate.md:3`, `C01_final.md:3`).
- T01 and C01 have no `upstream_issues` field.
- The source has 78 lines (`wc -l`); `C01_final.md:6` and others say 1-79.
- The C01_mech timestamp and the hang are recorded at `C01_final.md:24`.
- Violations: none in AUDIT.md.

**Worksheet**
- Priority A is correct.
- The checking route is sourced from `L02_issue_1.md` §7.
- Line numbers `Defs.lean:12,15,18` and `L02Stmt.lean:6` are correct.

**FILES_TO_CHECK**: these line numbers are correct: `L01.lean:35`, `T01.lean:48`, `T01Stmt.lean:11,20`, `C01.lean:39`, `C01.lean:35` (S4), `C01Stmt.lean:9,15`, `L02Stmt.lean:6,17`.

**Omissions vs BLOCKERS**: the only open entry, B1, is reported with the correct severity.

## Could not be checked

- The sha256 and .olean hashes quoted in the audits were not recomputed.
- Compile logs other than `L02_Counterexample1_2.log` and `gate_L02_falsity_1.log` were not re-read.
- The "corrected at report time" claims in §8 (that the earlier rows of `PAPER_VERIFICATION.md` were thin, etc.) were checked only against `consistency_check.md`, not against the earlier snapshot files.
- Permission denials and guard refusals were not counted by the run, so they cannot be checked.
