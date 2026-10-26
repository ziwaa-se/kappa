# Fact check of the final report (pv-factcheck)

Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
Sources read: `source/main.tex` (whole); `verification/audits/{DEFS_gate, P01_gate, P01_final, L01_final, T01_gate, T01_issue_1, T01_final, T01_final_r2}.md`; `RESULTS.json`; `BLOCKERS.md`; `PAPER_VERIFICATION.md`; `AUDIT.md`; `EXTERNAL_TOOLS.md`; `RESUME.md` (grep); `VERDICTS.md` §2.2, §3, §4, §5; `pv_work/{Defs, P01Stmt, T01Stmt}.lean` (whole); declaration lines of `pv_work/{L01, P01, T01, L01Stmt}.lean`; `pv_work/notes/T01_prover_notes.md` (grep); work drafts `consistency_check.md`, `author_notes.md`, `external_tools.md`. Command run: `scripts/pv_lean.sh packages` (6305 of 6305 confirmed).

Counts: **Major 0, Moderate 2, Minor 8.**

## Problem table

| # | Severity | Report text | What the source says | Source file:line | Suggested correction |
|---|---|---|---|---|---|
| 1 | Moderate | AUTHOR_REPORT §6 line 87: "**Author intent**: whether the cited Donsker principle is meant in the uniform or the general-F form (§4.x)." Also the §4.x coordinator observation (line 71): "The ruling on the reduction recalls that Donsker 1952 and Kolmogorov 1933 treat the uniform case ... A question for the authors". | No review asks this question. The ruling shows that **both** readings, (a) uniform and (b) general-F, close with the same routine step, and that the classification does not depend on the literature recollection. It says explicitly "Human check needed: no". The recollection is also narrower than the report says: Donsker 1952 "works with the uniform reduction", while Kolmogorov 1933 "notes the distribution-freeness for continuous F". It does not say that Kolmogorov 1933 "treats the uniform case". | `verification/audits/T01_issue_1.md:24-27`, `:34`, `:85` | Remove the "Author intent" line from §6, or keep it there marked as "coordinator's question, no review behind it; the ruling holds under either reading (T01_issue_1 §2) and the reviewer says no human check is needed (§8)". In the §4.x observation, replace "treat the uniform case" with "Donsker 1952 works with the uniform reduction; Kolmogorov 1933 notes distribution-freeness for continuous F (recollection, not checked)". Add the same note that the ruling does not depend on the answer. |
| 2 | Moderate | AUTHOR_REPORT §8 line 100: "this report's compilation step found three stale records, now corrected: ..." | The compilation step's consistency check found more stale or incomplete records, and they are still uncorrected. (m1) The `EXTERNAL_TOOLS.md` section "Candidates from INVENTORY" still lists "Reduction ... (iii)", "Identification/measurability ... (iii)" and "Brownian bridge existence ... (iii)/(v)" as if they were open, and §9 of the report sends readers to this file. (M3, second half) The T01 row of PAPER_VERIFICATION.md does not say which clause each condition covers. (m4) The non-vacuity section of PAPER_VERIFICATION.md is empty. (m6) `mathlib_rev` is empty; §7 does disclose this one. | `verification/report/work/consistency_check.md:26,30-31,43-45`; `verification/EXTERNAL_TOOLS.md:40-50`; `verification/PAPER_VERIFICATION.md:13,23-25` | Change to "found three stale records, now corrected (...), and further minor stale or incomplete records that remain: the INVENTORY candidates section of EXTERNAL_TOOLS.md still lists settled (iii) candidates (none is a parameter); PAPER_VERIFICATION.md T01 row lacks the conv/cdf mapping and its non-vacuity section is empty". Alternatively, correct those records and then say so. |
| 3 | Minor | AUTHOR_REPORT §2 line 40: "the first proof session stopped at S1 ..., the second session proved it"; §8 line 101: "The first proof session of T01 stopped at S1 (budget); the second session proved it." | Pass 1 had **two** proof sessions. Session 1 stopped S1, S2 and S3. Session 2 proved S2 and S3 and stopped S1 (BUDGET_EXHAUSTED). S1 was proved in pass 2, in another proof session (opus). | `pv_work/notes/T01_prover_notes.md:1,8,19,69,112,116`; `verification/audits/T01_final.md:88`; `T01_final_r2.md:4` | "In pass 1, two proof sessions stopped at S1 (budget; T01_final.md, UNFINISHED); a pass-2 proof session proved S1." |
| 4 | Minor | AUTHOR_REPORT §0 line 15: "No issue is recorded, so there is no counterexample to any result." | An empty BLOCKERS.md shows only that no counterexample was found or recorded. The issue ruling says "no counterexample exists" for T01 only, as reasoning. For conditional results, truth also rests on the unverified parameters. | `verification/BLOCKERS.md`; `T01_issue_1.md:40` | "No issue is recorded; no counterexample was found." |
| 5 | Minor | AUTHOR_REPORT §1 item 5 line 31: "The one candidate gap, the silent reduction ..." | The drafter raised a second candidate: "Brownian bridge" undefined, as a DOMAIN_CLARIFICATION candidate. The gate rated it EDITORIAL/FAIR_IMPLICIT_STEP and dispatched no ruling. | `verification/audits/T01_gate.md:80` | "The one candidate gap sent for a ruling ...; the drafter's other candidate ('Brownian bridge' undefined, DOMAIN_CLARIFICATION) was rated EDITORIAL by the gate (T01_gate §7; see §5 item 2)." |
| 6 | Minor | AUTHOR_REPORT §5 item 3 line 79: "per the gate's recollection (not checked) ... (T01_gate §6–7)". Worksheet line 47: "Per the gate's recollection". | The gate states the attribution as a fact and does not call it a recollection. It is in §6 only; §7 does not mention K. T01_final_r2 §8 repeats it. It is unchecked against the literature (no network), so the hedge is defensible, but the label and the citation are inexact. | `verification/audits/T01_gate.md:74,94`; `T01_final_r2.md:83` | "per the gate (T01_gate §6) and the final audit (T01_final_r2 §8); not checked against the literature (no network)". |
| 7 | Minor | AUTHOR_REPORT §5 item 4 line 80: reviewer's wording in quotation marks: "Since F is continuous, F(X_i) are iid uniform on [0,1] and D_n equals a.s. the uniform-sample statistic." | The reviewer's actual wording is "Since $F$ is continuous, $F(X_1), F(X_2),\dots$ are iid uniform on $[0,1]$ and $D_n$ equals almost surely the corresponding statistic of the uniform sample, so it suffices to treat the uniform case." | `verification/audits/T01_issue_1.md:79` | Quote the reviewer's sentence verbatim, or remove the quotation marks and mark it as a paraphrase. |
| 8 | Minor | AUTHOR_REPORT §7 line 95: "Lean comment errata: `verification/DOC_ERRATA.md` (no entries recorded)." | The gate called the docstring of `DonskerUniformSup`, "(+ (ii) the continuous-functional step ... folded in)", inaccurate in classification terms. The docstring still says this, and no erratum is recorded. | `verification/audits/T01_gate.md:73,98`; `pv_work/T01Stmt.lean:57-58` | Add: "One known docstring inaccuracy is not in DOC_ERRATA.md: T01Stmt.lean:57-58 labels DonskerUniformSup '(i) + (ii)'; the gate ruled it type (i) (T01_gate §6). Formalization-side wording only." |
| 9 | Minor | FILES_TO_CHECK §2 line 32: Lemma 2.1 paper location "main.tex:34-37". | The lemma is at main.tex:35-38 and its proof at 40-43. Line 34 is blank. | `source/main.tex:35-43`; `RESULTS.json` L01 `statement_loc` | "main.tex:35-43" (statement 35-38, proof 40-43). |
| 10 | Minor | Worksheet line 88: `supAbs`, `Kfun` at "`pv_work/T01Stmt.lean` ... ~41, ~44". | `supAbs` is defined at line 37 and `Kfun` at line 41. | `pv_work/T01Stmt.lean:37,41` | "T01Stmt.lean:27, 17, 37, 41". |

## Checked and found correct

**AUTHOR_REPORT header and §0**
- Not a claim of full verification. The 3 external inputs, 2 of the 3 results conditional, and the counts 1/2/0/0 agree with `RESULTS.json`, `PAPER_VERIFICATION.md:3`, `AUDIT.md:10-12` and VERDICTS §5.
- Verdicts agree with the final audits: L01 UNCONDITIONAL, CONDITIONS none (`L01_final.md:64-65`); P01 CONDITIONAL on GlivenkoCantelli (`P01_final.md:87-88`); T01 CONDITIONAL on DonskerUniformSup and KolmogorovFormula (`T01_final_r2.md:86-87`).
- Conditions are neither too many nor too few. The clause mapping (conv to Donsker, cdf to Kolmogorov) matches `T01_final_r2.md` §4.
- "No condition has been checked by a person yet" agrees with the `EXTERNAL_TOOLS.md` registry ("not yet").

**§1**
- BLOCKERS.md has no entries.
- All three parameters are type (i), and none is an axiom (mech `#pv_axioms` PASS in all finals).
- The P01 goal-shape caveat follows `P01_final.md` §6 and `P01_gate` item 6. The proof of P01 is a bare citation (main.tex:50).
- KolmogorovFormula equals the cdf clause (`T01_gate.md:74`).
- The FAIR_IMPLICIT_STEP ruling, and its proof in S2–S4 and S1, match `T01_issue_1.md` and `T01_final_r2.md` §3.
- `depends_on` is empty for all three results.

**§2**
- Lean main-theorem locations are correct: `L01.lean:33 L01_main`, `P01.lean:18 P01_main`, `T01.lean:436 T01`.
- The gate and final audit files and their PASS lines are correct.

**§3 (external-parameter table)**
- Lean `file:line` values are correct: `P01Stmt.lean:26`, `T01Stmt.lean:60`, `T01Stmt.lean:69`.
- Provenance (i) and the source lines main.tex:50/61/62 are correct. main.tex:50 has no `\cite`, which is correct.
- Users and steps (S1; S5 conv; S6 cdf) are correct. They match `RESULTS.json` `external_tools` and `T01.lean:422`.
- Debts and unencoded parts: none, which is correct.

**§4 and §4.x**
- "No paper-side issue confirmed" is correct.
- Attribution of the reviewer-ruled rows:
  - Row 1 cites `T01_issue_1.md` (§3 ruling, §6 measurability), confirmed in `T01_final.md` §5 and `T01_final_r2.md` §3. All three reports contain the ruling.
  - Row 2 cites `P01_gate.md` item 6 and `P01_final.md` §6. Both contain the acceptance.
- The observation row is correctly labelled as the coordinator's own (see problem 1 for its content).
- No suggested fix is made up: the only suggestion (§5 item 4) comes from `T01_issue_1.md` §7 and is repeated in `T01_final_r2.md` §8.

**§5**
- Item 1: main.tex:50 has no `\cite`, and the bibliography at 65-74 has only donsker and kolmogorov (P01_gate items 6–7). Correct.
- Item 2: "Brownian bridge" appears at main.tex:55-56, undefined (T01_gate §7). Correct.
- Item 5: main.tex:29-31 and 54-55; DEFS_gate item 4 and T01_issue_1 §6. Correct.

**§6**
- Priorities B/B/D agree with VERDICTS §4 (B means (i) with doubtful attribution: GC has no `\cite`, Kolmogorov has the attribution nuance) and with `P01_final.md:42`.
- There are no A, A′, C or E items. Correct.
- The reasoning-only items cite T01_gate items 1, 3, 4. Correct.

**§7**
- The toolchain is v4.19.0 (`lean-toolchain`). Correct.
- `mathlib_rev` is empty. Correct.
- `scripts/pv_lean.sh packages` prints "6305 of 6305", confirmed by my own run.
- The remarks on `Omega : Type` and on `n = 0` follow T01_gate items 1 and 4.

**§8**
- The three stated corrections were actually made: the `EXTERNAL_TOOLS.md` registry (regenerated 01:11) says T01_S1 is proved; `AUDIT.md:90-91` has the correction note; the P01 row of `PAPER_VERIFICATION.md:12` has the caveat.

**Worksheet**
- The Lean definitions of GlivenkoCantelli, DonskerUniformSup and KolmogorovFormula are verbatim. GCConclusion is at line 10 and IsIIDSeq at line 16, and their fields are correct.
- The Kfun index shift is correct.
- Priorities and the "Used by" entries are correct.
- Defs line numbers 21, 31 and 49 are correct; T01Stmt line numbers 17 and 27 are correct.

**FILES_TO_CHECK**
- Lean lines and names are correct for P01 and T01, and for `L01Stmt.lean:10`, `T01Stmt.lean:46`, the `P01Stmt` lines and the `Defs` lines.
- Audit file lists are correct, and T01_final.md is correctly marked as superseded.
- Source ranges are correct for P01 (45-50) and T01 (53-63).
- "Definition 1.1" matches the numbering scheme (`[section]` counter).

## Could not be checked

- §8 "Violations: none recorded" and "Permission denials: not tabulated": I found no record that lists violations, so I could not confirm or refute these.
- The truth of the literature attributions (Donsker 1952, Kolmogorov 1933, Doob 1949): no network.
- I did not recompile any Lean module myself. The compile and axiom facts are taken from the mech and final audit reports.
