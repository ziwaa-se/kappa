# Fact check of the revision-1 report (pv-factcheck)

Checked: `verification/report/AUTHOR_REPORT.md`, `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`, `verification/report/FILES_TO_CHECK.md`.
Against: `source/SuperParetoPaper-v12.tex` (current numbering, read :90-439), every audit file cited by the report (`T02_gate.md`, `T02_final.md`, `T02_issue_1*.md`, `P03_final.md`, `P03_recheck.md`, `P03_reconnect_r1.md`, `L01_issue_1*.md`, `L02_final.md`, `L02_issue_1*.md`, `T01_final.md`, `T01_issue_1*.md`, `T01_issue_2.md`, `T03_issue_1*.md`, `T03_issue_2*.md`, `P04_final.md`, `P04_issue_2*.md`, `P04_issue_1.md` §6-7, `P05_final.md`, `P05_issue_1*.md`, `P06_final.md`, `P01_final.md`, `T04_final.md`, `T04_gate.md` items 4-7, `P02_final.md`, `P02_issue_1_r2.md`, `P02_issue_2*.md`, item 7 of the gates of L01, L02, P02, P05, P06, P01, `rev1/T02_gate.md`), `BLOCKERS.md`, `RESULTS.json`, `EXTERNAL_TOOLS.md`, `AUDIT.md` (revision mapping), `DOC_ERRATA.md`, `RESUME.md`, `PAPER_VERIFICATION.md`, `INVENTORY.md` (H12, H14), `report/work/consistency_check.md`, and the Lean files by `grep` (declaration lines only).
Baseline-to-current mapping used: baseline <= 216 unchanged, baseline >= 258 → old - 23 (`AUDIT.md:273`).

Counts: **Major 1, Moderate 3, Minor 13.**

## Problem table

| # | Sev. | Report text | What the source says | Source file:line | Correction |
|---|---|---|---|---|---|
| 1 | **Major** | AUTHOR_REPORT §5, last paragraph ("Presentational suggestions from the audits"): ":362 state the convention Log 0 = -∞ (`T04_gate.md` item 7.1)" | T04_gate item 7.1 is a ruling, not a suggestion to the authors: "preliminary FAIR_IMPLICIT_STEP (covered by the source chain under the definition's log 0=-∞ convention). Not a suspected issue." T04_final §6 lists only the :383 (baseline) wording slip as editorial, and §4 says the Log 0 branch "is dead code under `h`". No audit asks the authors to state the convention. The location is also wrong: baseline F:381 maps to current :358, not :362. | `verification/audits/T04_gate.md:61`; `verification/audits/T04_final.md:55, :72` | The coordinator made this suggestion up. Delete it from "Presentational suggestions from the audits". Or move it to "Observations of the coordinator" at :358, based on "T04_gate.md items 5 and 7.1 rule the zero case FAIR_IMPLICIT_STEP under the Log 0 = -∞ convention; T04_final.md §4: the branch is dead under the hypothesis". |
| 2 | Moderate | AUTHOR_REPORT header, line 5: "The paper still depends on 6 registered external inputs that have not been verified in Lean" | Six parameters are registered, but `P03_T02Consumed` is **proved** from `T02_main` (`P03_T02Consumed_holds`) and is no longer a condition of any result. The report's own §3 says this: "5 conditions of results (rows 1-5), plus the discharged `P03_T02Consumed`". | `verification/audits/P03_reconnect_r1.md:25, :38`; `verification/EXTERNAL_TOOLS.md:12` ("not a condition of any result") | Change to: "The paper still depends on 5 external inputs that have not been verified in Lean (conditions of T01, T02, P03, P04; a sixth registered parameter, `P03_T02Consumed`, is now proved from `T02_main`; a seventh Lean parameter, `T03_T01Consumed`, is refuted and unregistered)". |
| 3 | Moderate | AUTHOR_REPORT §0b: "zero weights, n=1, x<0 and weight renormalisation were ruled fair implicit steps (`T02_issue_1.md`, review CONFIRMED in `T02_issue_1_audit.md`)"; §4.3: "Zero weights, n=1, x<0 and the normalisation of the induction weights θᵢ/(1-θₙ) were ruled fair implicit steps (`T02_issue_1.md`, FAIR_IMPLICIT_STEP, review CONFIRMED)" | `T02_issue_1.md` rules only the zero-weights reduction, with n=1 as a special case, and it explicitly excludes x<0: "The `x<0` case (gate item D) is not part of this issue". The gate and the final audit classified x<0 and the IH normalisation as FAIR_IMPLICIT_STEP. No issue-checker ruling or review exists for them. | `verification/audits/T02_issue_1.md:115-116`; `verification/audits/T02_gate.md:93-94`; `verification/audits/T02_final.md:87-88` | In both places, write: "zero weights and n=1 were ruled FAIR_IMPLICIT_STEP (`T02_issue_1.md`, review CONFIRMED in `T02_issue_1_audit.md`); x<0 and the normalisation θᵢ/(1-θₙ) were classified FAIR_IMPLICIT_STEP by the gate (`T02_gate.md` item 7 D and the normalisation bullet) and the final audit (`T02_final.md` §6), with no separate issue-checker ruling". |
| 4 | Moderate | AUTHOR_REPORT §5 item 9: ":326, :335 (also :358, :411) \| -Log F_X(1/x) undefined where F_X(1/x)=0, domain unspecified (`L02_gate.md` item 7.2)", listed as an editorial typo or wording item | The gate recorded this as a doubt about the source with a preliminary paper-side class: "Preliminary: DOMAIN_CLARIFICATION / EXPOSITION_GAP (minor). May be folded into the checker's task." `L02_issue_1.md` does not rule on it, and no other record does. The report silently downgrades an unruled preliminary DOMAIN_CLARIFICATION/EXPOSITION_GAP to "editorial". | `verification/audits/L02_gate.md:64` | Keep the item, and add: "unruled; the gate's preliminary class is DOMAIN_CLARIFICATION / EXPOSITION_GAP (minor); the encoding uses -Log 0 = +∞ (`L02_final.md` §4), and the T04 zero case is FAIR_IMPLICIT_STEP under that convention (`T04_gate.md` item 5)". Also list it under §6 "Author intent". No verdict changes: L02 is already ISSUE. |
| 5 | Minor | AUTHOR_REPORT §4.9, observations table, row 4: "'ITS laws have no atoms' in the earlier T02 gate reasoning ... \| `T02_gate.md` item 4, :165" | The reasoning (G(0+)=1-F(+∞)=0 forces continuity; Ex 2.7 has atoms) is in the **pre-revision** gate. The current `T02_gate.md` item 4 only says that the atom lines are gone. The point is also a gate finding, not an observation with no review behind it. | `verification/audits/rev1/T02_gate.md:45, :93`; `verification/audits/T02_gate.md:46` | Cite `verification/audits/rev1/T02_gate.md` items 4 and 7 A. Optionally move the row to the "ruled by a gate or an audit" table. |
| 6 | Minor | AUTHOR_REPORT §5, presentational: ":240, :243 introduce X and state i.i.d. (`P02_gate.md` item 1)" | The point is item **7.1** of the P02 gate, recorded with "Preliminary: EXPOSITION_GAP (or DOMAIN_CLARIFICATION); low severity". It was not ruled. | `verification/audits/P02_gate.md:62` | Cite `P02_gate.md` item 7.1 and add "(gate's preliminary class EXPOSITION_GAP, low severity; not ruled)". |
| 7 | Minor | AUTHOR_REPORT §2, P06 row: "The same holds for P05's identical step and for P01's a.e. derivative step." | P01: the gate recommended an issue-checker ruling "at low priority" that was not run, so "the same" fits. P05: the gate said "Dispatch pv-issue-checker only if the prover cannot close it", and the prover closed it, so no ruling was requested. Also, an EXPOSITION_GAP ruling could not change P05, which is already ISSUE. | `verification/audits/P01_gate.md:76, :82`; `verification/audits/P05_gate.md:77` | Write: "The same holds for P01's a.e. derivative step (gate D1 recommended a low-priority ruling, not run). P05's identical step was also classified by the final audit alone (no ruling requested; P05 is ISSUE anyway)." |
| 8 | Minor | AUTHOR_REPORT §0b: "the proof of Theorem 3.1 was rewritten (baseline :190-257 became :190-234 ...)" and "The statements of all numbered results are unchanged (`T02_gate.md`: `T02_main` fingerprint identical ...)" | The gate's diff shows that the changes are "**only** at :219-233 (old :219-256)", with the base case :190-217 unchanged. The fingerprint covers only `T02_main`. The evidence that the other statements are unchanged is the same diff line. (The wording ":190-257 → :190-234" follows `AUDIT.md:273` and is not wrong, only coarser.) | `verification/audits/T02_gate.md:10` | Write: "the induction step of Theorem 3.1 was rewritten (baseline :219-256 → :219-233; base case :190-217 unchanged) ... statements unchanged (`T02_gate.md` revision check: the diff touches only :219-233; `T02_main` fingerprint identical)". |
| 9 | Minor | AUTHOR_REPORT §4.6, "Affected: the claim at :107" | Both the ruling and its review also name the prose at baseline :331 (= current :308, "Finally, we relate the super-Pareto class with the ITS family"). | `verification/audits/T03_issue_1.md:70`; `verification/audits/T03_issue_1_audit.md:46` | Write "Affected: the claims at :107 and :308". |
| 10 | Minor | AUTHOR_REPORT §4.5 / §6 (B07 human checks) | P04_final §8 also records "'increasing odds rate' undefined (gate item 7, third bullet): preliminary DOMAIN_CLARIFICATION, not ruled". The report keeps only the domain-of-concavity half of that bullet. | `verification/audits/P04_final.md:82` | Add "and 'increasing odds rate' (:294) is undefined (preliminary DOMAIN_CLARIFICATION, not ruled)" to §4.5 "Needs a human" and to §6. |
| 11 | Minor | AUTHOR_REPORT §4.4 "Not affected: the n=2 part (verified for nonnegative X)" | The final audit asks the report to carry an extra fact: "Remark for the report: the n=2 case proved here holds without independence." | `verification/audits/P02_final.md:44, :78` | Optional: add "(independence is not used)". |
| 12 | Minor | EXTERNAL_TOOLS_WORKSHEET #1: "Suggested checking route (`T02_final.md` §4): true for x>0 by subadditivity at θ/x, (1-θ)/x; at x=0 the condition reads F(0) ≤ 1" | `T02_final.md` §4 is a usage trace and contains no such sketch. The sketch is in the gate. | `verification/audits/T02_gate.md:76` | Cite `T02_gate.md` item 6. |
| 13 | Minor | EXTERNAL_TOOLS_WORKSHEET, notation table: "`F`, `Fbar`, `IsInvSub`, `SubCond` \| `pv_work/L01Stmt.lean`" | `L01Stmt.lean` has no `Fbar`. `Fbar` is at `T02Stmt.lean:15` and `P04Stmt.lean:17`, as the worksheet's own line 9 and FILES_TO_CHECK §3 ("no `Fbar`") say. | `pv_work/T02Stmt.lean:15`; `pv_work/P04Stmt.lean:17` | Remove `Fbar` from the L01Stmt row and add it to the T02Stmt and P04Stmt rows. |
| 14 | Minor | EXTERNAL_TOOLS_WORKSHEET, notation table: "`SuperPareto`, `suppIn` \| `pv_work/P04Stmt.lean` \| Def 4.4 and support domain" | Super-Pareto is Definition 4.1 (:261-264). Def 4.4 is DOR (:281-284), and `P04Stmt.lean:44` calls DOR "Definition 4.4". | `source/SuperParetoPaper-v12.tex:261-264, :281-284` | Write "Def 4.1". |
| 15 | Minor | FILES_TO_CHECK §3: "`pv_work/P06Stmt.lean` \| its own `IsInvSub` (:35)" | `P06Stmt.lean:35` is `paretoCdf`. `def IsInvSub` is at line 40. | `pv_work/P06Stmt.lean:35, :40` | Write ":40". |
| 16 | Minor | AUTHOR_REPORT §5, presentational: ":174 state the scope of Lemma 4.1 of ineq-order2024 (`T01_issue_2.md`)" | The ruling makes this conditional: "if Lemma 4.1 ... itself requires monotone h ... at most a citation-scope remark (EDITORIAL) would remain. That needs a human check of the cited paper." Its only unconditional editorial suggestion is "As F_X is increasing", which is already §5 item 3. | `verification/audits/T01_issue_2.md:61, :82` | Write: "only if Lemma 4.1 of ineq-order2024 turns out to assume h increasing (human check), state its scope at :174". |
| 17 | Minor | AUTHOR_REPORT §4.9, "Ruled by a gate or an audit" table, row ":174 S0 ... `T01_issue_2.md`" | `T01_issue_2.md` is an issue-checker ruling marked "Not confirmed until a pv-auditor review passes", and no review exists. The row says "no counterexample review", but the table heading presents it as a finding. | `verification/audits/T01_issue_2.md:4` | Change the heading to "Ruled by a gate, an audit or an issue-checker", or mark the row "unreviewed ruling". |

## Checked and found correct

**Header and §0 (summary table).**
- 12 results: 3 UNCONDITIONAL (P01, T04, P06), 2 CONDITIONAL (T02, P03), 7 ISSUE (L01, T01, P02, P04, T03, L02, P05), 0 unfinished. Matches `RESULTS.json` verdicts and `PAPER_VERIFICATION.md:3`.
- Each verdict agrees with the final, reconnection or issue records:
  - T01, L02, P05, P02 final audits: SUGGESTED ISSUE.
  - P04: the final audit says CONDITIONAL, but B07 (`P04_issue_2_audit.md`, VALID) takes precedence.
  - T03: no final audit; two VALID reviews.
  - L01: gate plus VALID review.
- The conditions in each row equal the CONDITIONS lines:
  - T01: `T01_X02Tool, T01_L01Consumed` (`T01_final.md:108`).
  - T02: `T02_L01Consumed` (`T02_final.md:111`).
  - P03: `T02_L01Consumed, P03_P02Consumed` (`P03_reconnect_r1.md:50`).
  - P04: `P04_X01Tool` (`P04_final.md:91`).
  - P01, T04, P06: none.
- Line numbers checked in the `.tex`:
  - :153 says "negative".
  - :124 has the F_X(0)=0 qualifier.
  - :219-233 is the new induction step.
  - :314 says "h(0)=0".
  - :358 has the Log 0 chain, and :362 says "as the exponential is superadditive".
  - :411 and :422 are the F_X/F_X^- passages.
- The B05 instance is correct by hand: P(X≤1)=1/2 for cdf x/(1+x).
- B09 instance B is correct by hand: 1-F(2)=1 and 1-F(4)=1/3.
- "No human check recorded" is correct: the registry shows "not yet" throughout.

**§0b.**
- B06 is resolved. The header is marked RESOLVED (`BLOCKERS.md:85`), and the body is marked historical (`BLOCKERS.md:87`), as §8 says.
- P03: RECHECK PASS and RECONNECT AUDIT PASS. `P03Closed_r1.lean:14 main_closed` exists.
- The verdicts of the other results were kept (`RESUME.md:8`).
- The rev1 files exist in `verification/audits/rev1/`.

**§1.**
- Items 1-7 checked against the audits:
  - shared mechanism of B05 and B09 instance A (`T03_issue_1.md` §4);
  - Lean evidence lists;
  - B02 obstruction only; B03 reasoning only;
  - downstream statements: T04 does not cite L02 (`L02_issue_1.md` §5); T02 uses only "only if" (`L01_issue_1.md` §2); no consumer of T03 (`T03_issue_1.md` §5);
  - the vacuous gap theorems (`T01_final.md` §7, `L02_issue_1_audit.md` §4, `P05_issue_1_audit.md` §4).

**§2.**
- All rows agree with the cited audits:
  - P01: Tonelli/FTC rendering (`P01_final.md` §4).
  - T02: `T02.lean:611` (grep confirmed).
  - P04: hnd, X01 for the parenthetical only.
  - P06: gate item 7.1 dispatch not run (`P06_gate.md:76`); EXPOSITION_GAP would make ISSUE (`P06_final.md:69`).

**§3.**
- Provenance types, users and Lean `file:line` agree with `RESULTS.json` and `EXTERNAL_TOOLS.md`. Checked by grep:
  - `T01Stmt.lean:26, 36`;
  - `T02Stmt.lean:33`;
  - `P03Stmt.lean:17, 32`;
  - `P04Stmt.lean:64`;
  - `T03Stmt.lean:30`;
  - `not_T03_T01Consumed` at `T03_Counterexample2.lean:168`.
- `T03_T01Consumed` is unregistered and refutable (`T03_issue_2.md` §3; review `T03_issue_2_audit.md` §1).
- The six registry entries are as stated.

**§4.1-4.8.**
- The `file:line` citations map correctly to current lines:
  - :130-133, :137, :171, :174, :180;
  - :240, :243, :246;
  - :294, :297, :309-315;
  - :338-342, :323, :335;
  - :408, :403, :419, :425;
  - :107, :150, :159, :311, :331.
- Classifications agree with BLOCKERS and the rulings: PAPER_ASSUMPTION_GAP for B01, B04, B07, B08; ERROR for B05, B09; PAPER_ARGUMENT_GAP for B02, B10; DOMAIN_CLARIFICATION for B03.
- Every cited evidence file exists, and its review is VALID or CONFIRMED (grep of the audit verdict lines).
- Every recorded fix has a source, and the source's sufficiency remarks are reported accurately:
  - L01: `L01_issue_1.md` §6.
  - B05: `T01_issue_1.md` §6, `T01_issue_1_audit.md` §6, including "removes S2 but not S0".
  - T02: `T02_issue_1.md` §8, `T02_issue_1_audit.md`.
  - B02: `P02_issue_2.md` §6, `P02_issue_2_audit.md` §5.
  - B03: `P02_issue_1_r2.md` §5.
  - B07: `P04_issue_2.md` §7.
  - B09/B10: `T03_issue_1.md` §6, `T03_issue_2.md` §6.
  - B04: `L02_issue_1.md` §6, with the caveat sourced from `P05_issue_1_audit.md` §2 and §5.
  - B08: `P05_issue_1.md` §6.
- The "not affected" lists hold against the rulings' unaffected lists.

**§4.9 (findings table).**
- Rows :246, :297, :358, :411/:422, :191/:219 cite records that contain those rulings: `P03_issue_1.md` with the review in `P03_final.md` §6; `P04_issue_1.md` accepted in `P04_final.md` §6; `T04_final.md` §4; `P05_final.md` §6 and `P06_final.md` §6; `T02_issue_1.md` with `T02_issue_1_audit.md`.
- The point-mass fact is correct by hand: at x=c/2, θ=1/2 we get 2 ≤ 1.

**§4.9 (observations).**
- The Example 4.13 and 4.16 arithmetic is correct: 2·(1+1/(e²-1)) ≈ 2.31, and V(1)=1+e⁻¹. INVENTORY H12 and H14 say "not checked".
- The T04 depends_on row is backed by consistency check Mo5.
- The P03 S3 row is backed by `P03_final.md` §4.

**§5.**
- Items 1-8 and 10-11 have the stated sources and line numbers: P01_final §4; T04_final §4 (:359-360, :362); T01_issue_2 §7; P05_final §6, §8; P06_final §6; L01_gate item 7.2.
- Item 7 is correctly marked compiler only: :143 has θ∈[0,1] while Lemma 2.3 has (0,1).
- The count "8 from audit records" is right.
- Presentational suggestions with a valid source:
  - :153 (P01_final §4);
  - :246 (P03_issue_1 §7);
  - :297 (P04_issue_1 §6);
  - :411/:422 (P06_final §6);
  - :191 zero-weight sentence (T02_issue_1 §8; T02_final §8 "optional sentence at :191").

**§6.**
- Each item has a source.
- Every open item in BLOCKERS (B01-B05, B07-B10) is represented.
- The human-check items of the rulings are represented: L01 §8, L02 §8 with the audit's second opinion, P04_issue_2 §8 and its audit §8, T01_issue_1 §8 (i)(ii), P02 rulings, T01_issue_2 §9. The exception is row 10 above.

**§7.**
- Lean v4.19.0, the Mathlib revision and 6305/6305 match `RESULTS.json`.
- No `#check` evidence for the (i) tools is correct: T01_gate says "research lemma"; P04_gate_r2 says "no search needed".
- `T02ModGaps.lean` is still in `pv_work/`.
- None of the listed drafts has an `.olean` (directory listing).
- `DOC_ERRATA.md` has three entries.

**§8.**
- The BLOCKERS corrections are present.
- The listed uncorrected inconsistencies exist in `RESUME.md`, `PAPER_VERIFICATION.md`, `EXTERNAL_TOOLS.md` and `RESULTS.json`.
- `REVISION_BRIEF.md` is absent.
- `source/` has no PDF or `.aux`.
- The list is not exhaustive (consistency check Mo8 and Mo10 are not repeated), but the report refers to the full list.

**FILES_TO_CHECK.**
- All main-theorem `file:line` entries confirmed by grep except row 15 above:
  - L01Draft:32; P01:298; T01ModGaps:192; T01:208; T02:611;
  - P02ModGaps:26; P02:12; P03Closed_r1:14; P03:228; P04:509;
  - T03Draft:61; L02ModGaps:104; L02:101; T04:70;
  - P05ModGaps:311; P05:312; P06:216.
- Source ranges match `RESULTS.json`.

**Worksheet.**
- The Lean definitions quoted verbatim match the declared lines.
- The priority assignment follows `T03_gate.md` item 6 and the registry.
- P04_X01Tool: "T03 carries a binder but does not use it" (`T03_gate.md:63`).

## Could not be checked

- That the cited Lean files compile and have the stated axioms. I ran no Lean (read-only role). These facts are taken from the audit reports.
- The literature claims: Lemma 4.1 of ineq-order2024 and Prop 1 of superPareto2024 (no network).
- PDF numbering after Prop 4.3: no PDF or `.aux` in `source/`.
- Whether `pv_status.py tools` lists exactly six entries. I did not run it; the `RESULTS.json` `external_tools` array has six.
