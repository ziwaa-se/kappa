# Fact check of the final report (pv-factcheck)

- Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
- Against: `source/SuperParetoPaper-v12.tex` (read directly, :85-464), all rulings, reviews and final audits in `verification/audits/`, `RESULTS.json`, `BLOCKERS.md`, `EXTERNAL_TOOLS.md`, `RESUME.md`, `VERDICTS.md` §4, the Lean statement, counterexample and gap files in `pv_work/` (declarations located with grep; nothing was compiled).
- Read-only: no other file was changed.

**Counts: Major 1, Moderate 9, Minor 13.**

## 1. Problem table

| # | Sev. | Report text | What the source/records say | Source `file:line` | Correction |
|---|---|---|---|---|---|
| 1 | **Major** | FILES_TO_CHECK §2, L01 row: "`pv_work/L01.lean:120` `Paper.L01.main` (statement, ISSUE)" | `pv_work/L01.lean` does not exist. The pointer is the template placeholder `_example_result.lean_main`. L01 has no `lean_main` field. The gated statement is the draft `L01_main` in `L01Draft.lean`, which contains `sorry` and has no `.olean`. | `RESULTS.json:793` (placeholder); `RESULTS.json:26-61` (L01, no `lean_main`); `pv_work/L01Draft.lean:32` | "`pv_work/L01Draft.lean:32` `Paper.L01.L01_main` (gated statement, draft with `sorry`, no `.olean`); evidence: `pv_work/L01_Counterexample1.lean:54` `L01_if_counterexample`, `:73` `L01_main_as_printed_false`" |
| 2 | Moderate | AUTHOR_REPORT:3 "it has passed an independent fact check" | This check had not been done when the sentence was written, and it found problems that need correction. §8 also refers to "the paragraph appended below after the check", which does not exist. | this file | "An independent fact check was run (`verification/report/work/factcheck.md`). Its corrections are applied as listed in §8." Write the paragraph in §8 only after the corrections are made. |
| 3 | Moderate | AUTHOR_REPORT:5 "The paper still depends on 7 external inputs (6 registered, 1 unregistered and refutable)" | `T03_T01Consumed` is refuted in Lean and no verdict uses it. T03 is ISSUE with `conditions: []`. The worksheet itself says "Used by: none for any verdict". So the paper does not depend on it. | `RESULTS.json:352`; `pv_work/T03_Counterexample2.lean:168`; `T03_issue_2.md:30,48` | "…depends on 6 registered external inputs not verified in Lean. A seventh Lean parameter, `T03_T01Consumed`, is refuted and no verdict uses it." |
| 4 | Moderate | AUTHOR_REPORT §3 debts "readings R2, R3 of concavity (P04) by reasoning only"; §4.5 "other readings of concavity (R2, R3) reasoning only"; §6 "P04 readings R2, R3" under "reasoning only, no Lean" | The counterexample review checked R2 and R3 in Lean, and added R4 also checked in Lean: "The R2 and R3 claims of the ruling are confirmed and now checked in Lean". Probe: `pv_work/probes/auditor/P04/auditor_P04_issue2_probe.lean` (exit 0, standard axioms). Only the ruling's own §6 marked them unchecked. | `P04_issue_2_audit.md:6,37-46`; `BLOCKERS.md:101` | "Readings R2, R3 (and R4) were checked in Lean by the counterexample review's probe (`P04_issue_2_audit.md` §4); the δ₀ counterexample fails a clause of the first sentence of :317 under every reading." Remove R2/R3 from §3 debts and §6. |
| 5 | Moderate | AUTHOR_REPORT §4.5 "Needs a human: whether Def 4.5 is tacitly limited to continuous laws"; §6 "B07 (continuous laws only?)" | Two recorded human-check items are left out: (a) the choice between PAPER_ASSUMPTION_GAP and ERROR (both reviewers call ERROR admissible); (b) the domain on which concavity of Λ and 1/F̄ is meant, and the undefined "increasing odds rate" (DOMAIN_CLARIFICATION, not ruled). | `P04_issue_2_audit.md:57,69`; `P04_issue_2.md:74`; `BLOCKERS.md:102,106`; `P04_final.md:82`; `RESUME.md:39` | Add to §4.5 and §6: "ASSUMPTION_GAP vs ERROR (both admissible); domain of concavity of Λ_X and 1/F̄_X at :301/:306/:310 and meaning of 'increasing odds rate' unstated (DOMAIN_CLARIFICATION, not ruled)". |
| 6 | Moderate | AUTHOR_REPORT §2 T01 row "Subadditivity half verified in gap file" | In `T01ModGaps.lean` the assembled subadditivity conclusion goes through `hGap_0 : T01_S0_Gap`, which feeds S3 and is false (h = −x). So it is established only "modulo S0 and the external tools". A route without S0 exists only in the issue-checker's probe (`T01_main_mod_S2_src`), and that ruling has had no review. What is verified non-vacuously is the individual steps S1, S3–S6. | `T01_final.md:46,96`; `T01_issue_1.md:87`; `T01_issue_2.md:37-44`; `pv_work/T01ModGaps.lean:192` | "Steps S1, S3–S6 verified in the gap file. The assembled subadditivity half depends there on the false encoding gap S0 (ENCODING_ERROR). A source-strength route without S0 exists only in an unreviewed probe (`T01_issue_2.md` §4)." |
| 7 | Moderate | AUTHOR_REPORT §3 "Type" column "(p)" for `T01_L01Consumed`, `T02_L01Consumed`, `P03_T02Consumed`, `P03_P02Consumed`; the legend defines (p) as "a predecessor clause not yet reconnected"; the worksheet also types them (p) | VERDICTS: "if the predecessor ends up ISSUE or UNFINISHED, it counts as (iv)". L01, T02 and P02 are ISSUE. `T01Stmt.lean` says so too: "counts as (iv) since L01 is ISSUE". | `verification/rules/VERDICTS.md:134`; `pv_work/T01Stmt.lean:30`; `pv_work/T03Stmt.lean:23` | Type each as "(p) → counts as (iv) (predecessor ISSUE)" in the report §3 and worksheet. Priority A is unchanged. |
| 8 | Moderate | AUTHOR_REPORT §4.9 row ":434, :445 … FAIR_IMPLICIT_STEP"; §0/§2 P06 UNCONDITIONAL with no caveat | For P06 the gate asked for a `pv-issue-checker` dispatch on the F⁻→F passage at :445. The dispatch never happened: there is no `P06_issue_*.md`. The final auditor classified the step himself and wrote that "a ruling of EXPOSITION_GAP would change the suggested verdict to ISSUE". | `P06_gate.md:76`; `P06_final.md:69` | Add to §4.9 and §6: "P06 :445 F⁻→F classification rests on the final audit alone. The gate's requested issue-checker ruling was not run; an EXPOSITION_GAP ruling would make P06 ISSUE." |
| 9 | Moderate | FILES_TO_CHECK §2: `pv_work/T02.lean:135` `T02_main`, `pv_work/P02.lean:12` `P02_main`, `pv_work/L02.lean:101` `L02_main`, `pv_work/P05.lean:312` `P05_main` are listed without qualification | These four files contain `sorry` (T02 4, P02 2, L02 1, P05 1) and have no `.olean`. `P05_main` and `L02_main` state results refuted in Lean. Only the T01 and T03 rows carry a `sorry` warning. | `grep -c sorry` on the files; `pv_work/` listing (no `T02.olean`, `P02.olean`, `L02.olean`, `P05.olean`); `P05_issue_1_audit.md:77`; `L02_issue_1_audit.md:50` | Append "(draft with `sorry`, no `.olean`; statement as printed is refuted)" for L02 and P05, and "(draft with `sorry`, no `.olean`)" for T02 and P02. |
| 10 | Moderate | FILES_TO_CHECK §3 "Base definitions" and the worksheet notation table: P06 not listed except "i-sb order" | `P06Stmt.lean` declares its own `IsInvSub`, `paretoCdf` and `SubadditiveOn`, separately from L01Stmt and P04Stmt. The UNCONDITIONAL P06 verdict rests on this `Paper.P06.IsInvSub`, which a human must compare with Def 2.2. | `pv_work/P06Stmt.lean:9,35,40-42` | Add a row: "`pv_work/P06Stmt.lean` | own `IsInvSub` (Def 2.2), `paretoCdf` (:279), `genInv`/`recipE`/`isbOrder` (Def 5.1) | compare `IsInvSub` with Def 2.2 :124 and with `L01Stmt.IsInvSub`". |
| 11 | Minor | FILES_TO_CHECK §3 L01Stmt "`F`, `Fbar`, `IsInvSub`, `SubCond` | Def 2.1, Def 2.2 (:111, :124)"; L02Stmt "inverted distribution"; T02Stmt `StDom` "(eq:main-st), :95"; worksheet: "`Fbar` … defined in `pv_work/L01Stmt.lean`" | L01Stmt has `F`, `invDist`, `SubadditiveOn`, `IsInvSub`, `SubCond` and no `Fbar`. `Fbar` is at T02Stmt:15, P01Stmt:18, P04Stmt:17. The inverted distribution `invDist` is in L01Stmt:14; L02Stmt has `negLogInv`, `SubadditiveOnE`, `IsSuperHeavyTailed`, `InvNWUCond`. `StDom` is Def 2.1 (:115-118). | `pv_work/L01Stmt.lean:10-27`; `pv_work/T02Stmt.lean:10-15`; `pv_work/L02Stmt.lean:10-22` | Correct the rows as described; Def 2.1 is at :115-118, not :111. |
| 12 | Minor | FILES_TO_CHECK §2: `T01ModGaps.lean:1`, `T02ModGaps.lean:1`, `P02ModGaps.lean:1`, `L02ModGaps.lean:1` | The theorems are at T01ModGaps:192, T02ModGaps:654, P02ModGaps:26, L02ModGaps:104. The `:1` is copied from `RESULTS.json` `lean_main`. | grep of the files | Use the actual lines. |
| 13 | Minor | FILES_TO_CHECK §2 "Paper location" column (from memory) | Exact ranges from `RESULTS.json` and the .tex: L01 :128-138 (not 128-137); **P01 :148-154** (140-146 is Example 2.4); T01 :169-181; T02 :186-257; P02 :261-267; **P03 :269-273** (the given 267-270 leaves out the statement text at :271-272); P04 :315-321; T03 :332-338; L02 :358-366; T04 :376-386 correct; P05 :429-436; P06 :440-446. | `RESULTS.json` `statement_loc`/`proof_loc`; .tex | Replace the column with these ranges and drop "approximate". |
| 14 | Minor | AUTHOR_REPORT §7 "Mathlib … (commit not recorded here)" | The commit is recorded: `mathlib_rev c44e0c8ee63ca166450922a373c7409c5d26b00b`. | `RESULTS.json:11` | "Mathlib commit c44e0c8e… (`RESULTS.json`)" |
| 15 | Minor | AUTHOR_REPORT §7 "Thm 3.1 is proved only for n=2 modulo gaps" | The n=2 case (S1–S4) uses no gap; it is verified conditional on `T02_L01Consumed`. The gaps are S5/S6a, S10b and zero weights, all in the n≥3 step. | `T02_final.md:28,81` | "Thm 3.1: the n=2 case is verified conditional on `T02_L01Consumed`; the n≥3 step has gaps S5/S6a, S10b and zero weights." |
| 16 | Minor | AUTHOR_REPORT §1.1 "Both share one mechanism: a continuous star-shaped map can make F_{h(X)}(0)>0" | B09 has two independent mechanisms: an atom at 0 (instance A, same as B05) and a shift (instance B, X=Z+1, F_X(0)=0 but not subadditive). | `T03_issue_1.md:62-64` | "B05 and B09's first instance share one mechanism…; B09's second instance (X=Z+1) fails subadditivity, so 'positive' does not repair Thm 4.8." |
| 17 | Minor | AUTHOR_REPORT §0 and §1.1 "counterexamples to a main result / main results" | The paper's main result is Thm 3.1 (section "Main result", :183-188). Thms 2.8 and 4.8 are a closure property and an inclusion theorem. | tex:168,183,331 | "counterexamples to a theorem as printed" |
| 18 | Minor | AUTHOR_REPORT §5 #9 ":349, :358 -Log F_X(1/x) undefined …" | :358 is "The following characterisation is straightforward." and contains no −Log. The expression occurs at :349 (and :381, :434). L02_gate records this as a candidate DOMAIN_CLARIFICATION. | tex:349,358; `L02_gate.md:42-43` | ":349 (Def 4.9; also :381, :434)" |
| 19 | Minor | AUTHOR_REPORT §5 #6 conventions 1/0=+∞ … unstated: no source given | Sourced in the audits. | `P05_final.md:77,90`; `P06_final.md:82`; `P05_gate.md:53` | Add the citation `P05_final.md` §6, `P06_final.md` §8. |
| 20 | Minor | AUTHOR_REPORT §4.2 fix "(or 'P(h(X)≤0)=0')" | The review adds a caveat: this alternative removes S2 but not S0 (it does not force monotonicity). Only "h(x)>0 for x>0" removes both. | `T01_issue_1_audit.md:62-63` | Append: "(the alternative does not make h increasing; see `T01_issue_1_audit.md` §6)". |
| 21 | Minor | AUTHOR_REPORT §4.7 "Our record `BLOCKERS.md` B04 repeats the alternative without this caveat" | The L02 final audit's status line repeats the same alternative ("or drop it from Def 4.9") without the caveat. | `L02_final.md:75` | "`BLOCKERS.md` B04 and `L02_final.md` §8 repeat the alternative without this caveat." |
| 22 | Minor | Worksheet "(i) items are B because the Lean form is a reformulation of the cited statement" | Priority B is for "(i) whose attribution or numbering is doubtful"; the other (i) items are D. `T01_X02Tool` qualifies (doubtful scope of Lemma 4.1). For `P04_X01Tool` the reason should be stated as a doubtful match: the encoded form adds F<1 and a concavity domain. | `VERDICTS.md:166-168`; `T01_issue_2.md:61` | State per item: X02 "B: scope of Lemma 4.1 (h increasing?) doubtful"; X01 "B: whether Prop 1 states the F<1/domain form is doubtful". |
| 23 | Minor | AUTHOR_REPORT §4.6 "Affected: the claim at :107 (reasoning)"; §2 P04 row "All clauses verified for non-degenerate X" | The ruling also lists :331. For P04, clause 2 (the super-Pareto parenthetical) is verified only conditional on `P04_X01Tool`. | `T03_issue_1.md:70`; `P04_final.md:87,91` | ":107 and :331"; P04 row: "…for non-degenerate X (the parenthetical conditional on `P04_X01Tool`)". |

No suggested fix in §4 was made up by the coordinator. Each one traces to an audit record (see §2 below).

## 2. Checked and found correct

**§0 summary table.**
- Counts: 3/1/8/0 with 12 results.
- Every verdict equals `RESULTS.json`.
- The conditions of T01, T02, P03 and P04 equal the `CONDITIONS:` lines: `T01_final.md:108`, `T02_final.md:91`, `P03_final.md:105`, `P04_final.md:91`.
- P01, T04, P06, L02, P02 and P05 have `CONDITIONS: none`.
- T03 has no final audit and `conditions: []`.
- The issue-to-result mapping B01–B10 matches `BLOCKERS.md`.
- The descriptions of B01, B04, B05, B07, B08 and B09 as Lean counterexamples, and of B02, B03, B06 and B10 as argument gaps or readings, match the rulings and reviews: all are VALID or CONFIRMED.

**§1.** Items 2–5 are correct:
- T04 cites neither lemma: tex:381 refers to "after Definition 4.9", per `T04_final.md:36,46`.
- No numbered result consumes T03: `T03_issue_1.md:69`.
- B06 does not threaten Thm 3.1: `T02_issue_1.md:82`.
- The gap theorems are vacuous or uninformative: `T01_final.md:96`, `T02_final.md:31`, `L02_final.md:35`, `P05_final.md:33`.

**§2.** The L01, P01, T02, P02, P03, T03, L02, T04, P05 and P06 rows agree with the final audits and rulings. T01 is the exception (row 6) and P04 has a minor omission (row 23).

**§3 external parameters.**
- Names, files and lines are correct, and the Lean texts in the worksheet are verbatim:
  - `T01Stmt.lean:26,36`;
  - `T02Stmt.lean:33-34`;
  - `P03Stmt.lean:17,32`;
  - `P04Stmt.lean:64-67`;
  - `T03Stmt.lean:30-32`.
- Users and source locations match `RESULTS.json` external_tools and `EXTERNAL_TOOLS.md:14-15`.
- The registry now says "only if" for `T02_L01Consumed`, so the observation that it was corrected holds.
- The worksheet's P04_X01Tool history is correct: the first encoding was rejected at δ₀ and ½δ₀+½δ₁, and the encoding was approved in gate r2, item 6 (`P04_gate.md:66,85`; `P04_gate_r2.md:67`).

**§4 substantive issues.**
- Line references match the .tex: :124, :130-133, :137, :171/:174/:180, :254-256, :263/:266, :150/:159/:334/:354, :317/:286, :332-337/:426, :346/:361-364, :431/:442.
- The arithmetic in the report is correct:
  - δ₀ satisfies eq:sub-1x;
  - F_{h(X)}(0)=1/2;
  - B06 at x=0 gives 2>1, and the factorisation (1−a)(b+d−a) is right;
  - for Z+1 at x=y=1/4, the value 1 > 2/3 is right.
- Every cited Lean evidence file exists, and its named theorems exist:
  - `L01_Counterexample1.lean:54,73`;
  - `T01_Counterexample1.lean:173,178`;
  - `T02_Counterexample1.lean:32,41,63`;
  - `P04_Counterexample2.lean:184,188`;
  - `T03_Counterexample1/2.lean`;
  - `L02_Counterexample1.lean`;
  - `P05_Counterexample1.lean`;
  - `pv_work/probes/issue/P02/issue_P02_sqrtneg.lean`.
- Each passed review (VALID or CONFIRMED).
- Every recorded fix has a source, and the report quotes it correctly:
  - `L01_issue_1.md` §6;
  - `T01_issue_1.md` §6;
  - `T02_issue_1.md` §7;
  - `P02_issue_2.md` §6;
  - `P02_issue_1_r2.md` §5;
  - `P04_issue_2.md` §7;
  - `T03_issue_1.md` §6 and `T03_issue_2.md` §6;
  - `L02_issue_1.md` §6;
  - `P05_issue_1.md` §6.
- The B04 caveat is correctly sourced to `L02_issue_1_audit.md:58` and `P05_issue_1_audit.md:56`.
- The "not affected" lists match the rulings.

**§4.9 attribution.** Each "ruled by the reviewers" row cites a report that contains the ruling:
- `P03_issue_1.md` §3 and `P03_final.md:77-82`;
- `P04_issue_1.md:92` and `P04_final.md:65-70`;
- `T04_final.md:55`;
- `P05_final.md:78` and `P06_final.md:63,69`;
- `T02_issue_1.md:143`.

The coordinator's observations are labelled as such, and each states its basis.

**§5.**
- Items 1–5, 7 and 8 match the .tex and their sources.
- The :385 location and the "records cite :383" note are correct.
- Item 7 (:143, θ∈[0,1]) is not in any audit, as the report says.
- The presentational suggestions all have sources:
  - `P01_final.md:58`;
  - `P03_issue_1.md` §7;
  - `P04_issue_1.md:84`;
  - `P02_gate.md:62`;
  - `P05_final.md:78` and `P06_final.md:69`;
  - `T01_issue_2.md:61,82`.

**§6.** Every listed item has a source, apart from the omissions in rows 4, 5 and 8.

**§7/§8.**
- Toolchain v4.19.0 and 6305/6305 modules are correct.
- The T03 colon episode is recorded at `RESUME.md:12`.
- The consistency-check counts (2/9/10) are correct (`consistency_check.md:7`).
- The stale records named in §8 are confirmed.

**Overall claims.**
- There is no "fully verified" claim, and the parameters are disclosed (VERDICTS §5).
- I checked the downstream statements against the .tex myself:
  - `thm:inclusion` is used only at :337;
  - `cor:inclusion` is not referenced again;
  - Lemma 4.10 is used only at :392;
  - Prop 5.2 is used only at :448.

## 3. Could not be checked

- Lean facts (compilation, axioms, the hashes in the audits) were taken from the audit reports and not re-run. I compiled nothing.
- The contents of ineq-order2024 (Lemma 4.1) and superPareto2024 (Prop 1) are not available (no network).
- Whether `T02_S4` and `P03_T02Consumed` have matching shapes (the coordinator's observation, Mo8) was not compared.
- I did not check the PDF numbering beyond the shared-counter reasoning (no `.aux`).
