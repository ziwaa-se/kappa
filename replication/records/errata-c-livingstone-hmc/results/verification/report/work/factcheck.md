# Fact check of the final report (pv-factcheck)

Date: 2026-10-13. Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
Sources used: `source/geo_erg_HMC_v3.1.tex` (and `.bbl`), post-revision audits in `verification/audits/*.md` (not `rev1/`, `revenc1/`), `RESULTS.json`, `PAPER_VERIFICATION.md`, `BLOCKERS.md`, `INVENTORY.md`, `RESUME.md`, Lean files under `pv_work/`, `python3 scripts/pv_status.py followup` and `validate` (output: two WARNs for L02/L03, then VALID).

Counts: **Major 1, Moderate 12, Minor 12.**

## 1. Problem table

| # | Sev. | Report text | What the source says | Source file:line | Correction |
|---|---|---|---|---|---|
| 1 | **Major** | AUTHOR_REPORT §4.1 "Recorded suggestion": "...; or drop the random-L extension, which was added beyond the deterministic-L scope." | The only recorded fix is in the ruling: drop `A1Law` from `Prop35Rand`, add `T02_main_randL'`, restate `T01Rand_T02Consumed`, re-gate, re-audit. The "drop the random-L extension" alternative appears only in the coordinator's `RESUME.md`. Its premise is also contradicted by the records: the user's scope is six results, with C01 limited to part (ii) and no "deterministic-L" restriction (INVENTORY §0). The T01 gate *required* the random-𝔏 statement because "Leaving random 𝔏 out would make any final verdict on T01 a partial pass of the item" (Required change R1). | `T01_issue_1.md:48-52`; `RESUME.md:56,65`; `INVENTORY.md:7-22`; `T01_gate.md:47,94,191` | Delete the "or drop the random-L extension..." clause. Keep only the ruling's fix (`T01_issue_1.md` §6). If the alternative is mentioned at all, put it under "observations of the coordinator", stating that it contradicts `T01_gate.md` §2/R1 and would leave Thm 2.2 a partial pass. |
| 2 | Moderate | §0 row 2.2: "Deterministic-L Theorem 2.2 (both parts) and random-L part (ii) are verified in a gap file" (no conditions listed) | These parts are verified only *conditionally*. Final audit: "CONDITIONS: T01_T02Consumed, T01_Thm518, T01_Thm518Rand". `T01_main` is in `T01.lean`; the gap file holds only the random-L theorem. | `T01_final.md:108,114`; `pv_work/T01.lean:43`; `pv_work/T01ModGaps.lean:22` | "...are verified conditionally (on `T01_T02Consumed`, `T01_Thm518`; random-L (ii) on `T01_Thm518Rand`) in `T01.lean` / `T01ModGaps.lean`..." |
| 3 | Moderate | §1.5 (also echoed in `external_tools.md`): "although the clause equals the fully proved deterministic `T01_main`" | `T01_main` is conditional on `T01_T02Consumed` (S1) and `Thm518` (S3), and belongs to an UNFINISHED result. C01_final: T01's conditions are "inherited only at reconnection with T01". | `T01_final.md:52-55`; `C01_final.md:47` | "...equals the conclusion of `T01_main` at d=1 (gate probes), which is itself conditional on `T01_T02Consumed` and `T01_Thm518`." |
| 4 | Moderate | §0 "The one stop (T01) is on the formalization side, not a counterexample to anything"; §1.1 "The only recorded issue is formalization-side"; §4.1 heading "(formalization side, NOT a paper issue)" | The ruling is self-declared "not confirmed until pv-auditor review" and has no review file. The gate classed X2 as "Preliminary EXPOSITION_GAP". The final audit calls it "suspected EXPOSITION_GAP / PAPER_ASSUMPTION_GAP" and says the support "requires A1". §4.1 discloses this further down, but the summary sections present the classification as settled. | `T01_issue_1.md:3,61`; `T01_gate.md:69`; `T01_final.md:85,109` | In §0, §1.1 and the §4.1 heading add: "per an issue-checker ruling not yet independently reviewed; gate and final audit had described X2 as a suspected EXPOSITION_GAP/PAPER_ASSUMPTION_GAP". |
| 5 | Moderate | §0b row 2.3: Before = "Unfinished"; "B02 (earlier, before this check's revision)" | The pre-revision verdict of C01 was ISSUE (B02, `baseline_before` v1, 02:38). The "UNFINISHED / GATE_PASSED" entry (11:26, note "the gated statement of T01 changed") is a cascade reset in the middle of this re-check. `followup` prints the latest history entry. | `RESULTS.json:476-532` | Before = "Recorded issue (B02)". Add a note: the `followup` script shows "Unfinished" because of the 11:26 cascade reset. |
| 6 | Moderate | §0 "never hidden assumptions (exceptions recorded in words: the provenance debts of §3)"; §1.3 and §3 "Debts recorded in words: P1-P5" | `RESULTS.json` `debts` is `[]` for every result. P1-P5 were compiled by pv-compiler from human-check notes. Most of them sit *inside* explicit parameters (P1→`Prop35`, P2→`Thm518Rand`, P3→`Thm518`) or are an approved TFA (P5). P4 is the unruled X3. None is a registered provenance debt in the VERDICTS §1.2 sense. | `RESULTS.json` (`"debts": []` for all six); `report/work/external_tools.md:118-126`; `VERDICTS.md:34` | Rename them "human-check notes P1-P5 (compiled; not registered debts)". Remove "exceptions ... hidden" from §0. |
| 7 | Moderate | §1.6 "Not encoded: Cor 2.3 part (i) ... and the random-L-under-A1 passage (TEX:834-836); both outside the scope set by the user." | Only part (i) is outside the user's scope. The A1 passage is "not covered" (C01 gate: encoding it "would be a scope decision for the coordinator/user"). Cor 2.3 as printed is stated "under assumption A1" (TEX:230). | `INVENTORY.md:14,22`; `RESULTS.json:467`; `C01_gate.md:31`; TEX:230 | "Part (i) is outside the user's scope. The random-𝔏-under-A1 reading (TEX:230, 834-836) was not encoded (not a user decision). The encoded C01 covers deterministic L only." |
| 8 | Moderate | §7 "Scope restrictions: deterministic L (𝔏=δ_L) for T01 and C01" | T01 includes a random-𝔏 main theorem (`T01_main_randL_mod_gaps`; part (ii) verified, part (i) gap), as the gate required (R1). | `T01_gate.md:94,191`; `pv_work/T01ModGaps.lean:22` | "deterministic L for C01; T01 covers deterministic L and random 𝔏 (random part (i) stopped)". |
| 9 | Moderate | §3 row 1 "attribution doubtful"; worksheet priority B for `T02_Prop35`; §4.x observation "T01's registry provenance ... changes the human-check priority from C to B/D" | The label (ii) follows a binding user instruction: "all out-of-scope numbered results are type (ii)"; "(ii) per user instruction". The source's attribution to Roberts–Tweedie 1996 is clear (TEX:298, `.bbl:542-543`). No record questions the attribution itself. The parameter belongs to T02, not T01. | `INVENTORY.md:28,179,183`; TEX:298 | Drop "attribution doubtful". State "(ii) per user instruction; source cites Roberts–Tweedie (TEX:298)". Keep the priority question as a coordinator observation only, with T01→T02. |
| 10 | Moderate | §8 "Violations: none recorded." and §4.1 "stage code STOPPED/TRANSLATION_BLOCKED (closest allowed code)" | PIPELINE handles an `ENCODING_ERROR` ruling by `reset <ID> --revision enc<n>`, redraft and re-gate. `TRANSLATION_BLOCKED` means a missing interface or a technical difficulty. Instead T01 was set STOPPED/TRANSLATION_BLOCKED and sent to a second-pass proof session. "Closest allowed code" is the coordinator's wording. | `PIPELINE.md:220-221`; `VERDICTS.md:94-95`; `RESUME.md:56,64-65` | In §8 list the process deviation: "ENCODING_ERROR not handled per PIPELINE (no enc2 reset/re-gate); recorded as TRANSLATION_BLOCKED instead". |
| 11 | Moderate | AUTHOR_REPORT line 3: "it has passed an independent fact check"; §8 "(to be completed with the fact-check outcome)" | This check found 1 Major and 12 Moderate items. | this file | Replace with the actual outcome after the corrections are made. |
| 12 | Moderate | FILES_TO_CHECK §2 T01 row: "gap version `pv_work/T01ModGaps.lean:1` `Paper.T01.T01_main_mod_gaps` (includes random L, ...)" | No such theorem exists. The file declares `T01_main_randL_partI_Gap` (line 13) and `T01_main_randL_mod_gaps` (line 22), random 𝔏 only. `RESULTS.json` `lean_main` carries the same wrong name. | `pv_work/T01ModGaps.lean:13,22`; `RESULTS.json:423` | "`pv_work/T01ModGaps.lean:22` `Paper.T01.T01_main_randL_mod_gaps` (random 𝔏 only; gap def at :13)". Also note that RESULTS `lean_main` is wrong. |
| 13 | Moderate | FILES_TO_CHECK §3: `Defs.lean` defines "... rejection probability, HMC kernel, `GeomErgodic` ..."; worksheet notation table puts `targetMeas`, `rejProb`, `hmcStep`, `GeomErgodic` in `pv_work/Defs*.lean` | `Defs.lean` has none of these. `targetMeas`, `rejProb`, `hmcStep`, `hmcPow`, `tvDist`, `GeomErgodic`, `gaussMeas` are in `T02Stmt.lean:31-72` (audited individually in `T02_final.md` §4). | `pv_work/Defs.lean:16-86`; `pv_work/T02Stmt.lean:31,36,43,49,64,69` | Move these to a `T02Stmt.lean` row in §3 (base definitions to check: also `tvDist`, `gaussMeas`). Fix the worksheet table the same way. |
| 14 | Minor | §0 "depend on 8 live external parameters" | `T01Rand_T02Consumed` is "not a condition" (reached only through the gap). The union of `conditions` in RESULTS has 7 ids. | `T01_final.md:46,55`; `RESULTS.json` | "7 live conditions (plus `T01Rand_T02Consumed`, reached only through a gap)". |
| 15 | Minor | §3 rows 1-2: "T01 (i), C01 transitively"; §0 C01 "through it T02_Prop35, T02_GaussFacts, T01_Thm518" | These are not Lean conditions of T01/C01. They are "inherited only at reconnection". | `C01_final.md:47`; `T01Stmt.lean:50-51` | Add "(would be inherited at reconnection)". |
| 16 | Minor | §2 C01: "S1, S3-S6 verified" | S2 (tail gradient, TEX:807-810) is also verified ("faithful"). | `C01_final.md:80` | "S1a-c, S2-S6 verified". |
| 17 | Minor | §0/§2 C01 row | VERDICTS §1.2: a result with unencoded parts "must state 'cannot be reported as fully verified'". | `VERDICTS.md:45` | Add that phrase to the C01 row. |
| 18 | Minor | §4.x row TEX:932: "FAIR_IMPLICIT_STEP (F2, F3)" | F3 (TEX:932, 936) is "possible DOMAIN_CLARIFICATION, low priority"; applicability is left to the parameter. | `T02_final.md:126` | Add the caveat and TEX:936. |
| 19 | Minor | §4.x row TEX:935 "Ruled by `T01_issue_1.md` §3" | That ruling is unreviewed. | `T01_issue_1.md:3` | Add "(issue-checker ruling, unreviewed)". |
| 20 | Minor | §5 #7 listed among "editorial typos" | The records say compatible, no change needed. | `author_notes.md` C3; TEX:906, 965, 1092 | Move it to a "no change needed" note. |
| 21 | Minor | §5 omits T02 gate item 7.2 | "TEX:908 vs 934-940: the theorem is stated for fixed T = Lε, the proof asserts the random-L case too. Preliminary EDITORIAL." | `T02_gate.md:130-131` | Add it as an editorial item. |
| 22 | Minor | §7 "Mathlib ... (commit not recorded here)" | RESULTS records `mathlib_rev` `c44e0c8ee63ca166450922a373c7409c5d26b00b`. | `RESULTS.json:11` | Quote the commit. |
| 23 | Minor | §7 "Corrections on the formalization side: enc1 reset of T01 ..." | L01 also had an enc1 reset (uniform-in-δ reading retired). | `RESULTS.json:61-79,97` | Add L01 enc1. |
| 24 | Minor | FILES_TO_CHECK §2 L01 row "`Concl`/`ConclFixedDelta` in `L01Stmt.lean`"; note "RESULTS.json line numbers for `T01.lean` (`:53`) differ" | `L01Stmt.lean` has only `Concl` (:17). `:53` occurs only in a `history` entry. The current `lean_main` is the wrong `T01ModGaps.lean:1` (see #12). | `pv_work/L01Stmt.lean:17`; `RESULTS.json:407,423` | Drop `ConclFixedDelta` and reword the note. |
| 25 | Minor | Worksheet #2: "registry says (ii) 'as instructed'" | The "as instructed" wording is in INVENTORY and the T02Stmt docstring, not in the registry. | `INVENTORY.md:28`; `T02Stmt.lean:16,74` | Cite INVENTORY. |

## 2. Checked and found correct

**Verdict table (§0, §2) against the audits and RESULTS:**
- L01: UNCONDITIONAL. `L01_final.md` gives "CONDITIONS: none". TEX:946 `‖x_ε‖>3‖x_0‖` and the fixed-δ reading are correct.
- L02: UNCONDITIONAL. `L02_final.md` suggests CONDITIONAL on `L02_L01Consumed`; `L02_reconnect_r1.md` gives "RECONNECT AUDIT: PASS / CONDITIONS: none"; `L01_final.md` has no conditions. `validate` WARN confirmed, with exactly the stated cause.
- L03: UNCONDITIONAL. `L03_final.md` suggests CONDITIONAL on `L03_L02Consumed`; `L03_reconnect_r1.md` gives PASS / none. Correct by PIPELINE stage 6b step 3.
- T02: CONDITIONAL. Conditions `T02_Prop35`, `T02_GaussFacts`, `T02_Prop35Rand` equal `T02_reconnect_r1.md:77` and RESULTS. The per-theorem split (`main_closed` vs `main_randL_closed`) matches §6 of that audit.
- T01: UNFINISHED. Conditions equal `T01_final.md:114` and RESULTS. "A partial pass is not a pass" is stated.
- C01: CONDITIONAL on `C01_T01Consumed`, equal to `C01_final.md:110`. Part (i) and the A1 passage are disclosed as unencoded. The (iv)/priority A treatment follows VERDICTS §4.1 and PIPELINE 6b step 5.
- The header counts 3/2/0/1 match RESULTS, PAPER_VERIFICATION and AUDIT. No full-verification claim is made.

**Overall conclusion:** "no counterexample to a main result" holds. No paper-side issue is open: B01 and B02 are RESOLVED in `BLOCKERS.md`. Checked in the .tex: the revised L02 proof (TEX:968-1007) does not invoke (18); revised (18) at TEX:900-903 uses `3‖x‖`; TEX:817-824 verifies it for every β>2.

**§3 / worksheet:**
- Every quoted Lean definition matches the file verbatim: `C01_T01Consumed` (C01Stmt.lean:43), `Prop35` (T02Stmt.lean:82), `Prop35Rand` (:146, `A1Law` at :149), `GaussFacts` (:92), `Thm518` (T01Stmt.lean:29), `Thm518Rand` (:69), `T01_T02Consumed` (:54).
- `T01Rand_T02Consumed` is at T01Stmt.lean:84-87. The bib entry is at `.bbl:542-543`.
- Checked TEX locations: 208-219, 283-289, 298-303, 307-313, 917-921, 934-940, 1103-1121, 1118.

**§4.1:**
- Quoted correctly from `T01_issue_1.md`: the classification, "THREATENS CONCLUSION: no", the "not affected" list (§4), the A1 clauses not consumed (§2), the absence of an issue audit file, and the optional TEX:935 wording.
- The probe `pv_work/probes/issue/T01/T01_issue1_noA1.lean` exists. Its log `pv_work/logs/T01_issue1_noA1_2.log` shows EXIT=0 and only standard axioms for the three probe theorems. As the report says, the probe was not reviewed by a second role.

**§4.x reviewer rows:** each cited report contains the ruling: `T01_final.md` §5 S2, `T02_final.md` F2/F3, `C01_final.md` §5 S1a/S1b, `L03_final.md` §5/§7, and `T01_gate.md:68-70` (X3, N9 preliminary; never ruled). The TEX:1112 `\e`/η remark is correctly labelled as unreviewed.

**§5 editorial items 1-6 and 8:** the line numbers and content match the .tex (911, 917-921, 946, 961, 978, 982, 987-996, 393, 217, 1104, 935, 1112, 309) and the cited audits (`T02_final` F1, `L02_final` FIS 1-2, `T02_gate` 7.4, `T01_issue_1` §6).

**§6:** every D-item has a source in `author_notes.md` (D1-D17) or the audits. No recorded human-check item is missing: the open decisions in RESUME:22 are covered by D7, D8, D9 and D9b.

**§7/§8:**
- TFA lists match the gate TFA tables.
- The tool under-tracing is described accurately (`T02_final` §1, `T01_final` §3, `C01_final` §3).
- The guard-block statement matches RESUME:85.
- The descriptions of the stale records (BLOCKERS, EXTERNAL_TOOLS, RESUME, AUDIT duplicates) match `consistency_check.md`.

**FILES_TO_CHECK line numbers:** `T01.lean:43`, `C01.lean:394`, `T02Closed_r1.lean:18/:31`, `L01.lean:88`, `L02Closed_r1.lean:13` and `L03Closed_r1.lean:14` are all correct.

## 3. Could not be checked

- The PDF numbering after the revision: no PDF is in `source/`. The report already marks it UNVERIFIED.
- The "6305 of 6305" module count was taken from RESULTS. I did not re-run `pv_lean.sh packages`.
- The mathematical correctness of the ENCODING_ERROR ruling itself: this is beyond a fact check, and it is on the human-check list as D9b.
- The contents of Roberts–Tweedie 1996 and Jarner–Tweedie 2003: no network access.
