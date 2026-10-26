# Fact check of the final report (pv-factcheck)

- Role: pv-factcheck (independent, read-only). Date: 2026-10-13.
- Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
- Sources read directly: `source/main.tex` (whole file), `source/main.aux` (labels), every file in `verification/audits/` that bears on a verdict (`*_final.md`, `*_issue_*.md`, `C01_gate.md`, `P01_gate.md`, `P01_gate_r2.md`, `DEFS_gate.md`), `BLOCKERS.md`, `RESULTS.json`, `PAPER_VERIFICATION.md`, `AUDIT.md`, `EXTERNAL_TOOLS.md`, `RESUME.md`, `DOC_ERRATA.md`, `INVENTORY.md` (grep), `VERDICTS.md` §1.3, §2-§5, the three working drafts in `report/work/`, `pv_work/logs/writes.jsonl` (grep), `pv_work/logs/auditor_P01_nonvac_2.log`, the `file:line` of every Lean declaration cited.

**Counts: Major 1, Moderate 3, Minor 9.**

## Problem table

| # | Sev. | Report text | What the source says | Source `file:line` | Suggested correction |
|---|---|---|---|---|---|
| 1 | **Major** | AUTHOR_REPORT.md:96 (§5 #2): "Give a theorem number or a better reference for the finite-sample Popoviciu inequality (observation of `P01_gate.md` item 6)." | The gate makes no such suggestion. It says the reverse: "The bibliographic item is the standard attribution of Popoviciu's inequality on variances; at most `EDITORIAL`, not an issue." No audit record contains a "theorem number or better reference" suggestion. The remark "no theorem number; title concerns algebraic equations" comes from the architect's inventory and the registry's `human_check` text, not from a review. | `verification/audits/P01_gate.md:38`; `verification/INVENTORY.md:15,43`; `verification/RESULTS.json:271` | Delete §5 #2 as a suggestion. If the observation is kept, put it under "observations of the coordinator" with "based on INVENTORY.md:43 / RESULTS.json:271 (no review behind it)", and add that the gate calls the citation the standard attribution, at most EDITORIAL. Under VERDICTS §3.3 the coordinator may not draft suggested fixes. |
| 2 | Moderate | AUTHOR_REPORT.md:82 (§4.x row 2): question "Cited paper's title concerns algebraic equations; no theorem number", ruling "Content faithful; at most editorial", ruled by `P01_gate.md` item 6. Also WORKSHEET:16, :46: "(i), attribution doubtful", "doubtful attribution". | The gate rules "Provenance (i) is correct ... the bibliographic item is the standard attribution ... at most EDITORIAL". It does not raise the title or the missing theorem number. That framing is from INVENTORY.md:43 (pv-architect). The ruling cited therefore leaves out the gate's main point, that the citation is the standard one, and the report presents the "doubt" as reviewed. | `P01_gate.md:38`; `INVENTORY.md:43` | §4.x row 2: change the ruling to "Provenance (i) correct; the citation is the standard attribution; at most EDITORIAL (P01_gate.md item 6)". Attribute the question about title and theorem number to INVENTORY.md:43. Worksheet: replace "attribution doubtful" with "no theorem number given (INVENTORY.md:43); gate calls the citation the standard attribution (P01_gate.md:38)". Priority B can stay on the "numbering" limb of VERDICTS §4.1 if this is said explicitly. |
| 3 | Moderate | AUTHOR_REPORT.md:3: "it has passed an independent fact check, whose report is in `verification/report/work/factcheck.md`"; :117: "The independent fact check of this report's first draft found N problems, which have been corrected". | When this check started, no `factcheck.md` existed. "N" is an unfilled placeholder. The report claims a check it had not yet passed and corrections it had not yet made. | `verification/report/work/` (contained only author_notes.md, consistency_check.md, external_tools.md) | Fill these in only after the corrections in this file have been applied: ":117 The independent fact check found 1 Major, 3 Moderate, 9 Minor problems; corrected as listed in factcheck.md". Until then, :3 should say "fact check pending". |
| 4 | Moderate | AUTHOR_REPORT.md:115: "Coordinator errors: none known. The previous session recorded C01 as CONDITIONAL although its final audit recommended an own-issue ruling ..." | The second sentence describes a coordinator error. The gate and the final audit both said to send C01 to pv-issue-checker. The coordinator recorded C01 as settled and set the next step to `/pv-report` without dispatching the ruling. The compiler classified this as Major (M1). | `C01_gate.md:62`; `C01_final.md:72`; `RESUME.md:8-9`; `report/work/consistency_check.md:7-12` | ":115 Coordinator errors: one. The previous session recorded C01 as complete (CONDITIONAL) without dispatching the issue ruling that C01_gate.md item 7 and C01_final.md §7 recommended. Found by the compiler (consistency_check M1); corrected in this report phase (C01_issue_1.md, C01_issue_1_audit.md, C01 → ISSUE, B02)." |
| 5 | Minor | AUTHOR_REPORT.md:64: "false under Definition 2.2 (1/(n−1) normalisation, :35)"; FILES_TO_CHECK.md:43: "main.tex:26-36 (Section 1, Definitions 2.1 and 2.2)". | Definitions share the theorem counter within Section 1: def:mean = 1.1, def:var = 1.2. def:var spans :32-38 (s = √s² at :37). | `source/main.aux:4-5`; `source/main.tex:28-38` | "Definition 1.2 (:35)"; "main.tex:26-38 (Section 1, Definitions 1.1 and 1.2)". |
| 6 | Minor | FILES_TO_CHECK.md:32-35: rows 2.1/2.2 give "main.tex (Lemma, ...)" with no lines; 2.3 "main.tex:66-68"; 2.4 "main.tex:72-82". | 2.1 statement and proof :42-48; 2.2 :50-56; 2.3 :58-69; 2.4 :71-83. | `RESULTS.json:35-36,68-69,101-102,137-138`; `main.tex` | Use the full statement and proof ranges: 42-48, 50-56, 58-69, 71-83. |
| 7 | Minor | AUTHOR_REPORT.md:74 (§4.2): "Recorded suggestion (suggestion only, hand-checked by the reviewers): after Fix 1 of B01 ... ≤ n/(n−1) ≤ 2." No source cited. | The suggestion has a source: C01_issue_1.md §6 and C01_issue_1_audit.md §6, also L03_issue_1.md §7. C01_issue_1.md §6 also records an alternative ("keep the conclusion and remove the intermediate ≤ 1"), which the report omits. | `C01_issue_1.md:79-84`; `C01_issue_1_audit.md:58-61`; `L03_issue_1.md:74` | Add "(`C01_issue_1.md` §6, `C01_issue_1_audit.md` §6; constructed by the reviewer, not Lean-checked)", and mention the alternative. |
| 8 | Minor | AUTHOR_REPORT.md:69-75 (§4.2) and §1 item 5: no "Not affected" or downstream statement for B02. | VERDICTS §1.3 and §3.3 require downstream impact. C01_issue_1.md §4 gives: downstream none (no result cites cor:unit); unaffected L01, L02, P01, P02, C01 links 2 and 3, B01 unchanged. | `C01_issue_1.md:49-57`; `C01_issue_1_audit.md:42` | Add to §4.2: "Not affected: Lemmas 2.1, 2.2, Props 2.3, 2.4; links 2 and 3 of :99. Downstream: none (no result cites Corollary 2.6)." |
| 9 | Minor | AUTHOR_REPORT.md:84-88: "Observations of the coordinator (no review behind them)", row 1: s² ≤ 2 via (n−1)s² ≤ n. | This reasoning *is* in the reviews: C01_final.md §6 (auditor), C01_issue_1.md §3.2 (issue-checker), and C01_issue_1_audit.md §5 ("I agree with it by hand"). It is reviewer-constructed reasoning (VERDICTS §3.4), not a coordinator observation. Row 2 (Popoviciu provable) is likewise an auditor statement (P01_final.md §6). | `C01_final.md:67`; `C01_issue_1.md:42`; `C01_issue_1_audit.md:56`; `P01_final.md:65-69` | Move both rows to the "ruled by the reviewers" table (ruling: "reviewer reasoning, suggestion only, not Lean-checked, not used in any verdict"), or retitle the second table "statements by reviewers outside a ruling". Row 2 can add: the probe log `pv_work/logs/auditor_P01_nonvac_2.log:1-2,27` shows `popoviciu_holds` with standard axioms only, no sorryAx, EXIT=0. |
| 10 | Minor | AUTHOR_REPORT.md:108-109 (§7): "Lean and Mathlib versions were not read in this run"; "`n ≥ 1` is not built into the definitions but is a hypothesis of each statement". | The toolchain is recorded: `leanprover/lean4:v4.19.0` (RESULTS.json `lean.toolchain`; project `lean-toolchain`). DEFS_gate item 1: neither the global n ≥ 1 nor the n ≥ 2 domain of def:var is built in, and statements carry `1 ≤ n` where needed and `2 ≤ n` wherever sampleVar or sampleStd appears. Not every step obligation carries a hypothesis on n (e.g. `L02_S1`, `L03_S2`). | `RESULTS.json:10`; `lean-toolchain:1`; `DEFS_gate.md:19,41` | "Lean toolchain v4.19.0 (mathlib rev not recorded)". "Neither n ≥ 1 nor the n ≥ 2 domain of Definition 1.2 is built into the definitions; every main theorem carries 1 ≤ n or 2 ≤ n as needed (DEFS_gate.md item 1)." |
| 11 | Minor | AUTHOR_REPORT.md:116 (§8): the list of record inconsistencies "not corrected in the records". | The list is incomplete. Not mentioned: (a) `RESULTS.json` C01 `evidence.issues` lists only `C01_issue_1.md`, not `C01_issue_1_audit.md`; (b) `RESUME.md` is stale (C01 "CONDITIONAL", last updated 2026-10-12); (c) `RESULTS.json`/`EXTERNAL_TOOLS.md` record `C01_L03Consumed` as type "p" only, not marked (iv) or refuted, although C01_final §7 asks for that (compiler Mo1). The report itself states (p)/(iv)/refuted correctly. | `RESULTS.json:238-243,277`; `RESUME.md:7-8`; `EXTERNAL_TOOLS.md:11`; `C01_final.md:74` | Add (a)-(c) to the list. |
| 12 | Minor | AUTHOR_REPORT.md:114: "Violations: none known. During this report phase the coordinator's attempt to append the final verdict line to an auditor's review file was blocked ..." | `writes.jsonl:326-327`: the coordinator ran a write to `C01_issue_1_audit.md` and the hook refused it ("the coordinator does not write review reports (POLICY §3)"). It is an attempted violation, blocked, not "none". | `pv_work/logs/writes.jsonl:326-328` | "Violations: one attempted, blocked by the guard hook (POLICY §3): ..." |
| 13 | Minor | (omission, §8) | C01_issue_1.md:6: the coordinator's task named the probe path `pv_work/probes/issue-checker/C01/`, which is outside the checker's allowed path; the checker used `probes/issue/C01/`. A small instruction slip by the coordinator, not disclosed. | `C01_issue_1.md:6` | Optional one line in §8 under coordinator errors. |

## Checked and found correct

### AUTHOR_REPORT §0 and §1 (summary, overall findings)
- Counts 3/1/2/0 = 6. They equal RESULTS.json, PAPER_VERIFICATION.md:3 and AUDIT.md:10-15.
- C01 → ISSUE (B02) agrees with BLOCKERS.md:35-45, RESULTS.json:224-257 (`verdict: ISSUE`, `issues: [B02]`, `upstream_issues: [B01]`), C01_issue_1.md:96-97 (PAPER_ARGUMENT_GAP, does not threaten the conclusion) and C01_issue_1_audit.md:71 (COUNTEREXAMPLE VALID). This meets the VERDICTS §1.3 confirmation requirement. The supersession of C01_final's CONDITIONAL is stated correctly (C01_final.md:72 anticipates it).
- "B02 refutes an intermediate step, not its conclusion": correct, gap and falsity kept apart (VERDICTS §3.2).
- The B01 ERROR counterexample n=2, x=(1,−1) was checked by hand against main.tex:35,86 (s²=2, RHS=1). The C01 intermediate s² ≤ 1 fails, and s² ≤ 2 holds with equality.
- No blanket "no counterexamples" claim. The "not fully verified" disclaimer is present (VERDICTS §5).
- Downstream for B01: L01, L02, P01, P02 do not cite lem:raw (main.tex checked; L03_issue_1.md:46-48).
- "A theorem conditional on a false hypothesis carries no information": C01_final.md:65.

### §2 Verdict per result
- L01 and L02: UNCONDITIONAL, CONDITIONS none (L01_final.md:71-73, L02_final.md:69-71).
- P01: CONDITIONAL, Popoviciu, S1 at :66-67, S2 at :68 (P01_final.md:31-38,77-79).
- P02: UNCONDITIONAL. s=0 at :76 is FAIR_IMPLICIT_STEP (P02_issue_1.md:64, P02_final.md:73-85,108-110).
- L03: ISSUE, S1 and S2 verified, S3 stopped (L03_final.md:66-73,86-88; L03_issue_1.md:83; L03_issue_1_audit.md:82).
- C01: as above.

### §3 External parameters
- Exactly 2 parameters. Lean `file:line` checked: `C01_L03Consumed` at C01Stmt.lean:14 and `Popoviciu` at P01Stmt.lean:11.
- Provenance: (p) counting as (iv), refuted, per VERDICTS §4.1, C01_gate.md:57,74 and C01_final.md:74. Popoviciu is (i).
- Users: C01 S1 and P01 S1 (C01_final.md:31-38; P01_final.md:31-38).
- The conditions of each result equal the CONDITIONS: line of its final audit and RESULTS.json (P01: Popoviciu; C01: C01_L03Consumed; others none).
- Debts none and unencoded none: RESULTS.json shows `[]` for all six results.

### §4.1 (B01)
- Location :86/:91, class ERROR and evidence files all exist: `pv_work/L03_Counterexample1.lean`, its `.olean`, and both logs.
- Ruling and review verdicts match their files.
- The "not affected" list is correct.
- Fix 1 and Fix 2 are sourced (L03_issue_1.md:72-75; L03_issue_1_audit.md:61-65). Both remove the problem; hand-checked by me too: :90 divided by n−1, and :90 divided by n.

### §4.2 (B02)
- The "no repair of Lemma 2.5 alone" claim is sourced (C01_issue_1.md:33-34; C01_issue_1_audit.md:52-54).
- The probe file exists at `pv_work/probes/issue/C01/issue_C01_intermediate.lean`. Logs `_1`, `_2` exist, and the auditor recompiled it (C01_issue_1_audit.md:33).
- `C01_main` is at C01.lean:26.
- The policy point is sourced (C01_issue_1.md §8).
- The suggested chain is correct: Σxᵢ² ≤ n, and n/(n−1) ≤ 2 ⇔ n ≥ 2.

### §4.x row 1, §5 #1
- P02 s=0: ruling and human call (P02_issue_1.md:21-28,60). The editorial sentence matches P02_issue_1.md:56 and P02_final.md:97.
- main.tex:72 has no s>0 hypothesis, and :76 divides by s.

### §6 Human-check list
- Every item has a source: L03_issue_1.md:79-81; C01_issue_1.md:86-94; P02_issue_1.md:60; RESULTS.json:271.
- No recorded item is missing. L01_final, L02_final, DEFS_gate and the gates have no author-facing items beyond those listed.

### §8, §9
- The fact that the coordinator's write was blocked and the auditor then edited the file is confirmed (writes.jsonl:326-328).
- The two listed inconsistencies are real: RESULTS.json:193-195 and AUDIT.md lack L03_issue_1_audit.md and P02_issue_1.md; L03_final.md:84 is stale.

### Worksheet
- Lean definitions are quoted verbatim and match C01Stmt.lean:14-16 and P01Stmt.lean:11-13 (P01_gate_r2.md:17-19).
- Priority A for the (iv) clause is correct.
- The note on discharging Popoviciu is sourced (P01_gate.md:41 "optionally ... discharge"; P01_final.md §6).

### FILES_TO_CHECK
- Every Lean `file:line` checked: L01.lean:21, L02.lean:23, P01.lean:29, P02.lean:105, L03ModGaps.lean:30, L03_Counterexample1.lean:52, C01.lean:26, L01Stmt:6, L02Stmt:7, P02Stmt:12, L03Stmt:7, C01Stmt:6,14, P01Stmt:11.
- The audit file lists exist.
- Open blockers B01 and B02 are listed. BLOCKERS.md has no other open entries.

## Could not be checked
- The exact content of the auditor's format-only edit to `C01_issue_1_audit.md` (writes.jsonl:328). The final file is consistent, but there is no diff of the edit.
- The page numbers in PAPER_VERIFICATION.md (PDF not read; main.aux gives page 1 for 2.1-2.4 and page 2 for 2.5-2.6, which is consistent).
- Lean builds were not rerun (read-only role). Compile results are taken from the logs.
- The mathlib revision (not recorded in RESULTS.json).
