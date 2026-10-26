# Fact check of the final report (revision 1)

- Role: pv-factcheck (independent; read-only except this file). Date: 2026-10-13.
- Checked: `verification/report/AUTHOR_REPORT.md`, `EXTERNAL_TOOLS_WORKSHEET.md`, `FILES_TO_CHECK.md`.
- Sources read directly: `source/VSIFP_02.tex` (l.60-254, 390-484, plus grep for l.314, l.600), `source/VSIFP_02.bbl`, `verification/source_baseline_v1/VSIFP_02.tex` (old l.128-199, 398-469) and `.bbl`; all current audits (`T01_final`, `T01_issue_1`, `T01_issue_1_audit`, `T01_gate` item 7, `T02_final`, `T02_issue_1`, `T02_issue_1_audit`, `T02_gate` items 6-7, `T03_final`, `T03_gate` (grep), `P04_final`, `P04_gate` items 6-7 and TFAs, `P04_gate_r2` (grep), `P05_final_r2`, `P05_reconnect_r1`, `P05_issue_1`, `P05_gate` items 1-7, `DEFS_gate` N1/N2, `rev1/P04_gate` (grep)); `RESULTS.json`, `BLOCKERS.md`, `PAPER_VERIFICATION.md`, `EXTERNAL_TOOLS.md`, `AUDIT.md`, `RESUME.md`, `DOC_ERRATA.md`, `rules/VERDICTS.md`; `work/consistency_check.md`; Lean: `P04Stmt.lean`, `T03Stmt.lean`, `T02Stmt.lean` l.28-47, declaration lines of `Defs`, `T01Stmt`, `P05Stmt`, `P05Closed_r1`, `P04`, `T01ModGaps`, `T02ModGaps`, `T03`, theorem names in both counterexample files.
- Commands run: `python3 scripts/pv_status.py followup` (matches report §0b), `python3 scripts/pv_snapshot.py hash` on both counterexample files (T01 `1b15ec0a…8427`, T02 `677c6a82…ffb9`, both equal to the hashes in the rulings and reviews).

Counts: **Major 2, Moderate 8, Minor 13.**

## Problem table

### Major

| # | Report text | What the source says | Source file:line | Suggested correction |
|---|---|---|---|---|
| MA1 | AUTHOR_REPORT §3 row 2: "`Paper.P04.P04_T01Consumed` … (p), priority A"; worksheet overview "(p) predecessor T01 (issue B1) not reconnected", #1 "type (p)" | VERDICTS: a (p) clause "counts as (iv)" if the predecessor ends ISSUE. The gate: "Since T01's verdict is pending ISSUE (VERDICTS §4.1), the clause counts as (iv) if it is not discharged"; approved as "(p) …; (iv) while T01 is pending ISSUE". The Lean docstring says "Provenance (iv) while T01 is pending ISSUE (not discharged)". T01 is now recorded ISSUE and the clause was not discharged. | `verification/rules/VERDICTS.md:134`; `verification/audits/P04_gate.md:101,128,142`; `verification/audits/rev1/P04_gate.md:78`; `pv_work/P04Stmt.lean:77` | Change the type to "(iv): consumed clause of T01, which is ISSUE (B1); not reconnected" in AUTHOR_REPORT §3 and in worksheet #1 and the overview. Priority A is unchanged. Note in §8 that the `RESULTS.json`/`EXTERNAL_TOOLS.md` registry still says `p`. |
| MA2 | AUTHOR_REPORT §5, last paragraph: "…; state the reduction via λ_t = 0 when c_t = 0 in the proof (`P04_final.md` §4)." | `P04_final.md` §4 only rules the H_S vs H_{S;c} point a FAIR_IMPLICIT_STEP ("the c-reduction is printed at l.205-209; I rule it FAIR_IMPLICIT_STEP"). It makes no suggestion to the authors. `P04_gate.md` item 7.2 is a preliminary class only. A grep of all audits for suggestions finds none on this point. | `verification/audits/P04_final.md:78`; `verification/audits/P04_gate.md:106` | The coordinator made this suggestion up. Delete it from "Presentational suggestions raised in audit records", or move it to "Observations of the coordinator" and label it as having no review behind it. The other three presentational suggestions are sourced (`P05_issue_1.md:75` (i)-(iii)). |

### Moderate

| # | Report text | What the source says | Source file:line | Suggested correction |
|---|---|---|---|---|
| MO1 | AUTHOR_REPORT l.3: "it has passed an independent fact check"; §8: "found N problems, which have been corrected (see §9; filled in below after the check)" | At the time of writing, no fact check of this version existed. §9 holds only evidence entry points; "N" is a placeholder. | `AUTHOR_REPORT.md:3,169,172-175` | After applying this check, write the real counts ("2 Major, 8 Moderate, 13 Minor; corrected on <date>") and drop "see §9". Do not say "passed" until the corrections are applied. |
| MO2 | §8: "Corrected: … the stale P05 row of `PAPER_VERIFICATION.md` / `RESULTS.json` summary"; §0: "`verification/PAPER_VERIFICATION.md` takes precedence" | The P05 row still ends with a stray sixth cell of old ERROR-era text: "F_t)<=1 (l.474/476 … the printed conclusion fails for h>=2 (Lean counterexample, E e_tau = 5/4); h=1 believed true, unchecked." | `verification/PAPER_VERIFICATION.md:15` | Move this to "Not corrected": "the P05 row of PAPER_VERIFICATION.md still carries a stray cell with the superseded ERROR text". Otherwise the file that "takes precedence" contradicts the report. |
| MO3 | §6, "Mathematical completion (parts supported by reasoning only)": "P05, h = 1: rests on a FAIR_IMPLICIT_STEP; no separate reasoning review report exists." | The h = 1 branch is compiled in Lean with no parameter (`P05_S0`): "h = 1 unconditionally along l.200-214/l.227 (with l.400)"; the walk does not reach any T01/P04 clause. Only the class FAIR_IMPLICIT_STEP lacks a separate review. | `verification/audits/P05_final_r2.md:35,77,90` | Remove it from the "reasoning only" list. If it is kept anywhere, put it under process: "the ruling `P05_issue_1.md` (FAIR_IMPLICIT_STEP) was not separately reviewed; the filled-in step is compiled (P05_S0) and accepted in `P05_final_r2.md` §5". |
| MO4 | §3: "Debts recorded in words: TFA-1 integrability …; TFA-2 …; the case p_t = q_t …" and "External assertions not encoded: …"; §1.3: "Debts recorded in words and parts not encoded: §3" | `RESULTS.json` has `"debts": []` and `"unencoded": []` for every result. The final and reconnection audits list only the parameters as CONDITIONS. TFA-1, TFA-2 and the x/0 convention are gate-approved TFAs, i.e. formalization-side, not conditions. | `verification/RESULTS.json:45-46,92-93,150-151,192-193,270-271`; `verification/audits/P04_final.md:82,105`; `verification/audits/P04_gate.md:117-120`; `VERDICTS.md:29-35,96` | Do not call these "debts". VERDICTS §1.2 debts and `unencoded` would be further CONDITIONAL grounds, and the records have none. Rename them "Technical formalization assumptions approved by the gate (not conditions; see §7)". Rename the second list "Source assertions outside the numbered statements, not checked" (l.90 regularity, the l.103 "if" direction, l.227/l.246 Ramdas, Sections 4-5). Fix §1.3 to match. |
| MO5 | §0 row 3.1: "theorem itself holds"; §0 l.16: "while the theorems' conclusions still hold there" | T01: the necessity direction is not verified (S8, S10 are gaps; "Not verified: … the p > q case l.423"). Its truth rests on the gate's hand check and the ruling's reasoning, and `S8_corrected_range` is "suggestion only, not used in any verification". T02: "The general … truth of Theorem 3.2 at the edges and the full p > q case: reasoning, not checked in Lean". | `verification/audits/T01_final.md:100`; `T01_issue_1.md:47,67`; `T02_issue_1.md:189-190` | Use: "no counterexample to the theorem; its conclusion at the edge is supported by reviewer reasoning (T01: sufficiency compiled, necessity has gaps; T02: Lean checks only the edge instance and its mirror)". In §0 row 3.1, replace "theorem itself holds" with "theorem not refuted (necessity not compiled)". |
| MO6 | §3 row 1 and worksheet #2: "(i), priority B … attribution doubtful"; "The records and Lean docstring say '2019'; the manuscript cites 2020." Observation table: "X03 is attributed to '2019' in the records" | The old manuscript cited `Gruenwald2019` = arXiv:1906.07801 (2019), and the T03 gate and final audit checked against that text. Revision 1 switched the key to the ITA 2020 workshop version. `T03_gate.md` item 7: "Doubts about the source — none". So "2019" is stale, not a misattribution. The real check is whether "Theorem 1" of the ITA 2020 version has the same content and numbering. | `verification/source_baseline_v1/VSIFP_02.bbl:62-65`; `source/VSIFP_02.bbl:58-63`; `verification/audits/T03_gate.md:76`; `T03_final.md:57,108` | Reword: "Revision 1 changed the cited version from the 2019 arXiv preprint (on which T03 was audited) to the ITA 2020 paper; confirm that Theorem 1 of the 2020 version is the cited result (identification as the likelihood ratio plus a.s. uniqueness, Dirac W₁)". Say that priority B is the coordinator's choice, not a review finding. |
| MO7 | §4.x row "l.424 \| 'd(0) < 0 < d(1)' and passage from [0,1) to (0,1] \| FAIR_IMPLICIT_STEP \| `T02_issue_1.md` issue 3" | Issue 3 of the ruling covers (3a) "the case p > q is analogous" and (3b) the λ-range passage. The FAIR_IMPLICIT_STEP for "d(0) < 0 < d(1)" is in `T02_final.md` §5 (S2: "source gives no reason here; filled with the l.407 argument"). Item 3a is missing from the row. | `verification/audits/T02_issue_1.md:145-183`; `verification/audits/T02_final.md:74,81` | Split the row. (a) l.424 "d(0) < 0 < d(1)": FAIR_IMPLICIT_STEP, `T02_final.md` §5 (S2). (b) l.424 passage [0,1) → (0,1] for π₁ < 1, and "the case p > q is analogous" for π₁ > 0: FAIR_IMPLICIT_STEP, `T02_issue_1.md` issue 3 (3a, 3b); the edges are B2. |
| MO8 | §7: "Scope restriction … excludes the logarithmic score … no such record was found in `T01_gate.md` or `T02_gate.md` (UNVERIFIED whether deliberate)" | DEFS gate N2: "this is not an acceptable TFA. The T01/T02 gates must check … or else record the restriction as a formalization-side scope limitation". `T01_gate.md:69` does mention the log score, but only for integrability ("covered by TFA-1 … S real-valued"), not the closed-interval consistency of N2. T01, T02, P04 and P05 all assume `IsConsistent` or `IsStrictlyConsistent` over p ∈ [0,1] with real-valued S, which excludes the log score that the paper lists in Table 1 (l.178). | `verification/audits/DEFS_gate.md:87`; `verification/audits/T01_gate.md:69`; `source/VSIFP_02.tex:73,178`; `pv_work/Defs.lean:21-25` | Correct the sentence: "T01_gate.md:69 addresses the log score only for integrability; N2 is not discharged". Add the scope note to the §0/§2 rows of T01, T02, P04 and P05 ("verified for real-valued S consistent on [0,1]; the logarithmic score is outside the encoded scope"). Add a §6 item asking whether the authors' results are meant to cover the log score. |

### Minor

| # | Report text | What the source says | Source file:line | Suggested correction |
|---|---|---|---|---|
| MI1 | §4.x row 1 location "l.227 and l.400" | The proof restricts to h > 1 at l.447; the ruling cites l.227, l.200-214 and l.447. l.400 is the Theorem 3.1 proof (used only for nonnegativity). | `P05_issue_1.md:11-14,31`; `source/VSIFP_02.tex:447` | Change to "l.227 and l.447". |
| MI2 | §4.x row "l.220/l.232 vs l.452/l.466" | l.232 is P05's statement and itself says H_S, so there is no mismatch there. The gate cites ":452, 466 versus :220". | `P04_gate.md:106`; `source/VSIFP_02.tex:232` | Change to "l.220 vs l.452, l.466". |
| MI3 | §1.5: "B1 and B2 do not propagate by the issue rulings (`T01_issue_1.md` §4)" | B2's non-propagation is recorded in the T02 ruling ("T01, T03, P04, P05 (no numbered result depends on T02)"). | `T02_issue_1.md:88-90`; `T02_issue_1_audit.md:70` | Add `T02_issue_1.md` issue 1 ("Unaffected") as the source for B2. |
| MI4 | §4.2 gives only "Not affected" | Affected: S3a, S3b, S8, S9 (via S8), S15 and the assembly of the main theorem. | `T02_issue_1.md:86-87`; `BLOCKERS.md:33` | Add "Affected: S3a, S3b, S8, S9 (via S8), S15 (mirror), at the edge only". |
| MI5 | Worksheet #1 "Used by: P04 (S1 nonnegativity, `pt_bound`, S5–S8, S9b, …)"; #3 "(S1, `pt_bound`, S5–S8, main)" | `#pv_hyp_usage`: USED at S1, S0 (`pt_bound`), S5-S7, S9b, S9c, S10, S11, main. S8 is `rfl`. hMix is used at the same two sites as hT01. | `P04_final.md:33-36,73` | Change to "S0 (`pt_bound`), S1, S5–S7, S9b, S9c, S10, S11, main" in both items. |
| MI6 | Worksheet notation table: "`T01.MixtureRep`, `Erep` → T01Stmt.lean"; "`EGrowAll`, `GrowIs`, `expPi` → T03Stmt.lean". FILES_TO_CHECK §3: "T01Stmt.lean \| MixtureRep, Erep" | `Erep`, `expPi` and `EGrowAll` are in `Defs.lean`. `T01Stmt` defines only `MixtureRep`, and `T03Stmt` defines `LogFinite`, `IsGrowEValue`, `GrowIs`, `GruenwaldThm1`. | `pv_work/Defs.lean:18,61,92`; `pv_work/T01Stmt.lean:19`; `pv_work/T03Stmt.lean:16-42` | Move `Erep`, `expPi` and `EGrowAll` to the Defs row. Add `mixtureScore`, `elemScore`, `kappa`, `growthRate`, `EGrow` to FILES_TO_CHECK §3 Defs row. |
| MI7 | FILES_TO_CHECK §3: "consistency and strict consistency (l.73–103), H_S (l.135–139), e-value (Section 3 intro)" | Consistency is at l.69-73 and strict consistency at l.73 and l.103. H_S is defined at l.132 (l.135-139 is the interval remark). The e-value is defined at l.77 and, with null and alternative, at l.141. | `source/VSIFP_02.tex:69-73,77,103,132,141` | Use "l.69–73, l.103", "H_S l.131–133 (interval form l.135–139)", "e-value l.77, l.141". |
| MI8 | FILES_TO_CHECK P05 row, audit reports | It omits `P05_gate.md` (round 1, item 7, the source of both P05 boundary points) and `P05_final.md` (first final audit of the current text, the gap-file version). The P04 row lists its round-1 gate. | `verification/audits/P05_gate.md:89-94`; `AUDIT.md` (P05 entries) | Add "(earlier rounds: `P05_gate.md`, `P05_final.md`)". |
| MI9 | §8 list of record inconsistencies "Not corrected" | The compiler also found: `mathlib_search` fields are expectations, not `#check` evidence (CLAUDE.md rule 2), and `PAPER_VERIFICATION.md` has empty "Unnumbered assertions" and "Non-vacuity" sections. | `work/consistency_check.md:77,85`; `verification/EXTERNAL_TOOLS.md:10-12` | Add both to the disclosed list. |
| MI10 | §4.x table, as a list of fair implicit steps | Notable rulings are missing: l.452 "nonnegative supermartingale … therefore E(M_τ) ≤ 1" (no argument for h > 1; FAIR_IMPLICIT_STEP, gate 7.1 and final audit), and l.400 "easily verify … null hypothesis" (FAIR_IMPLICIT_STEP). | `P04_final.md:74-75`; `P04_gate.md:105`; `T01_final.md:81` | Add both rows, or say that the table is a selection. |
| MI11 | §4.3 recorded fix: "… and in l.437 replace the middle expression by ν{[p,q)} / (ν{[p,q)} − ∫ θ dν)" | The final audit disagrees with the ruling's reason: "the printed l.456 chain is a true chain of real numbers. Only l.454 is wrong." So the second replacement is optional, not needed. | `T02_final.md:109`; `T02_issue_1.md:135-137` | Add "(the final audit notes the printed middle expression is numerically correct, −N/(−N+A) = N/(N−A); this part of the fix is cosmetic)". |
| MI12 | §6 Author intent: "Whether `e_{τ+h−1}` in Proposition 3.5 means the random-index evaluation `e_{τ(ω)+h−1}(ω)`" | No current audit raises this; the P05 gate accepts the encoding with no doubt. The item comes from old B3 / RESUME, about the old statement `e_τ`. | `P05_gate.md:45-49`; `BLOCKERS.md:42`; `RESUME.md:56` | Either drop it, or label it "carried over from the previous manuscript's B3; not raised for the current statement". |
| MI13 | Worksheet #3 and §3 row 3: "(ii)" only | The gate and the Lean docstring say "(ii) l.103, asserted without proof; used silently (iii) in P04". | `P04_gate.md:97,129`; `pv_work/P04Stmt.lean:102` | Add "used silently in P04 (gate: (iii) at the point of use)". |

## Checked and found correct

**§0 / §2 verdict table.**
- The counts (0/3/2/0) match `RESULTS.json` and `PAPER_VERIFICATION.md:3`.
- Each verdict matches its final audit:
  - T01 ISSUE (`T01_final` PASS, plus `T01_issue_1_audit` COUNTEREXAMPLE VALID);
  - T02 ISSUE (`T02_final` PASS, plus `T02_issue_1_audit` COUNTEREXAMPLE VALID);
  - T03 CONDITIONAL, CONDITIONS X03;
  - P04 CONDITIONAL, CONDITIONS P04_T01Consumed, P04_MixingOfStrict;
  - P05 CONDITIONAL after reconnection, CONDITIONS the same two.
- The conditions equal the `CONDITIONS:` lines and `RESULTS.json`: none too many, none too few. Gaps are not counted as conditions.
- Lean main theorems exist at the cited lines: `T01ModGaps.lean:308`, `T02ModGaps.lean:385`, `T03.lean:145`, `P04.lean:912`, `P05Closed_r1.lean:32`.
- The h = 1 branch of P05 is parameter-free (`P05_final_r2.md` §3).

**§0b.** Matches `pv_status.py followup` exactly. B3 is RESOLVED in `BLOCKERS.md:37,45-46`, and l.471-476 is commented out in the `.tex`.

**§1.**
- The issues are paper side, B1 and B2 are PAPER_ARGUMENT_GAP, and the sign slip is ruled PAPER_ARGUMENT_GAP (issue 2).
- The counterexample files exist, their hashes match, the cited theorem names exist, and the reviews say COUNTEREXAMPLE VALID.
- P04_T01Consumed is the sufficiency direction, and B1 is in the necessity direction (`P04Stmt.lean:72-83`, `T01_issue_1.md` §4).
- `T01_S2` is at `T01ModGaps.lean:162`, gap-free, with an individual PASS (`T01_final.md` §9).
- No counterexample to the conclusion of any current numbered result.

**§3.**
- Lean line numbers match the files: X03 `T03Stmt.lean:42`, `P04Stmt.lean:78`, `P04Stmt.lean:107`, `P05Stmt.lean:43`, `T02Stmt.lean:40`.
- The verbatim Lean quotations in the worksheet match the files.
- The users are as stated: P04, P05 (h > 1), and T03 S5 only.
- The `.bbl` facts hold: `Gneiting2007` is Gneiting–Balabdaoui–Raftery at `.bbl:52`, `Gneiting2007a` is Gneiting–Raftery at `.bbl:42`, and `Gruenwald2020` is at `.bbl:58-63`.
- `P05_P04Consumed` is reconnected (`P05_reconnect_r1.md`).
- `T02_T01Consumed` is in neither registry, and its unused or gap-only status matches `T02_final.md` §3.

**§4.1.**
- l.412 text "E(0) ∈ (0,1)" is verified in the `.tex`; λ ∈ (0,1] is at l.144.
- The mirror is at l.412-415, and the old numbering (419/423) is right.
- The instance and values are right (E 0 = 0, E 1 = 2).
- The classification is right.
- The fix is sourced (`T01_issue_1.md` §6, `T01_issue_1_audit.md` §5) and sufficient (`S8_corrected_range` compiles, per the review).

**§4.2.**
- The l.424 text is verified.
- The counterexample instance and the theorem names (`counterexample_l435_lim/_max`, `conclusion_holds_at_instance`) exist.
- The fix is sourced (`T02_issue_1.md:92-96`) and was checked by the reviewer (`T02_issue_1_audit.md` §6).
- The old numbering (435/462) is right.

**§4.3.**
- l.435 prints (θ − y); from l.96-101 the correct integrand is (y − θ). Verified by hand: for p < q, d(0) = −∫θ and d(1) = ∫(1−θ).
- The classification wording, including the downgrade note and the fact that the review covers issue 1 only, matches the records.
- The theorem names exist.

**§4.x.**
- Rows l.214 (EDITORIAL, `P05_issue_1.md` §3/§7(ii)), l.217 vs l.146 (`P04_final.md` §4), l.220 (`P04_gate.md` item 7.5) and l.443 (`T03_final.md` §6) all cite reports that contain the ruling.
- All three "observations of the coordinator" are factually right and correctly labelled as having no review behind them.

**§5 editorial items.** Each was verified against the `.tex`:
- l.214, F_{t+1} indexing;
- l.437, stray `\}`;
- l.454, ℓ vs k;
- l.460, "k ∈ {1,…,k}";
- l.466 and l.468, M for e;
- l.452, `\tau[k]`;
- l.139, "In the case q > p" with [q,p);
- l.164, `\big\}`;
- l.150, "at time if $T$ the";
- l.314 and l.600, missing "than"; l.600, "tests tests".

The items found only by the compiler (6-10) are labelled as such.

**§7.**
- Toolchain v4.19.0 and mathlib c44e0c8e, with 6305/6305 modules (`RESULTS.json:10-12`).
- The TFA list matches `P04_gate.md` TFAs and `P05_gate.md` (τ ≥ 1).
- The DOC_ERRATA row matches.
- `T03Stmt.lean:36-41` and `T02Stmt.lean:33-36` still quote old lines (verified).
- `P05ModGaps.lean` is obsolete (`P05_final_r2.md` §1, §8).

**§8.**
- The carry-over decision for T01-T03 is as recorded (`RESUME.md:66-69`). I compared the old and new `.tex` for the three statements and proofs: they are mathematically the same.
  - The κ definition moved out of Theorem 3.2 and its range changed from 0 ≤ a < b ≤ 1 to 0 < a < b < 1, which is immaterial for p, q ∈ (0,1).
  - The citation key changed (see MO6).
- The guard-hook episode is recorded (`RESUME.md:28,34`).

**Worksheet and file index.**
- The priority order is A, B, C.
- The Lean quotes are verbatim.
- The source lines of P04_T01Consumed (l.143-148, proof l.400) and P04_MixingOfStrict (l.103, l.90) are right.
- The statement and proof ranges of all five results are right.
- The open blockers are B1 and B2.

## Could not be checked

- The content of Grünwald–de Heide–Koolen (ITA 2020) Theorem 1, and of Theorem 2.3 in either Gneiting 2007 paper, and Ramdas et al. (2020) §3. There is no network.
- PDF numbering (Theorem 3.1–Proposition 3.5) against the rendered PDF. I relied on `RESULTS.json` `numbering_basis`.
- Lean compilation, axioms and the mathlib module count. I did not re-run them; the audit records were taken as given.
- Whether the earlier fact check under `report_archive/` applied to items that persist here.
