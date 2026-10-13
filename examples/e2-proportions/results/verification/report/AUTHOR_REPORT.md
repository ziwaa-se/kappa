# Variance bounds for proportions and sums: final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator; it has passed an independent fact check, whose report is in verification/report/work/factcheck.md.

- **This report is not a claim that the whole paper is fully verified.** No external inputs remain, but 3 of the 6 numbered results carry recorded issues.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (empty: no external inputs).

---

## 0. Summary table (English, for screenshots)

**6 numbered results: 3 verified unconditionally · 0 verified conditionally · 3 with recorded issues · 0 unfinished.**

"Verified conditionally" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain, as explicit Lean parameters. None occurs in this paper. Recorded issues: Lemma 2.4 is a counterexample to the printed statement (false as printed); Lemma 2.2 is false under one reading of an undefined symbol; Proposition 2.6 has a false proof step but its conclusion is not refuted.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.1 | Lemma: quarter bound | Verified (unconditional) | none |
| 2.2 | Lemma: positivity of variance | Issue recorded | B1, DOMAIN_CLARIFICATION: `I` is "the unit interval", open or closed not stated; true on (0,1), false at p=0,1 on [0,1] |
| 2.3 | Proposition: midpoint concavity of √ | Verified (unconditional) | none (proved for I=[0,1], hence also for (0,1); "well known" concavity proved from mathlib) |
| 2.4 | Lemma: linear bound | Issue recorded | B3, ERROR: false as printed (n=1, p=1/10); step main.tex:70 does not follow from Lemma 2.1 |
| 2.5 | Proposition: uniform bound in n | Verified (unconditional) | none (C = 1/4) |
| 2.6 | Proposition: sample variance of sum | Issue recorded | B2, PAPER_ARGUMENT_GAP: main.tex:86 identity false (missing cross term); conclusion not refuted |

No result has conditions, so none has been checked by a person.

## 1. Overall findings

1. **A counterexample to a printed statement exists for Lemma 2.4** (B3, paper-side ERROR; Lean-checked). Proposition 2.6's printed conclusion is *not* refuted; only its proof step is false (paper-side PAPER_ARGUMENT_GAP). Lemma 2.2 depends on an undefined convention (paper-side DOMAIN_CLARIFICATION). This is the complete list of issues; details in §4.
2. **Verified unconditionally:** Lemma 2.1, Proposition 2.3, Proposition 2.5.
3. **Verified conditionally:** none. There are 0 external parameters.
4. **Issues recorded:** 2.2, 2.4, 2.6. All three have Lean evidence (counterexample files and gap files). For 2.4 and 2.6 the steps that are not in doubt are verified modulo the false step (gap files).
5. **Downstream impact:** none. The only `\ref` in the source are to Lemma 2.1 (main.tex:70, :78); nothing cites 2.2, 2.3, 2.4 or 2.6. Lemma 2.1 stays verified, so its uses are unaffected.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 2.1 | UNCONDITIONAL | `Paper.L01.L01_main` (`pv_work/L01.lean:21`). Only hypothesis `1 ≤ n` (main.tex:24). `L01_final.md`. |
| 2.2 | ISSUE (B1) | `Paper.L02.L02_main` (`pv_work/L02.lean:17`) proves the lemma under the open reading `I=(0,1)`; the final audit says PASS/UNCONDITIONAL for that reading (`L02_final.md`), but the closed reading is refuted at p=0 (`pv_work/L02_Counterexample1.lean`). Verdict ISSUE because the source does not fix the reading. |
| 2.3 | UNCONDITIONAL | `Paper.P01.P01_main` (`pv_work/P01.lean:60`), verified with I=[0,1] (stronger reading; the open reading follows). Concavity of p ↦ √(p(1-p)) (main.tex:61, "well known") proved as step `P01_S0` from mathlib, so it is not a parameter. `P01_final.md`. |
| 2.4 | ISSUE (B3) | Gap theorem `Paper.L03.L03_main_mod_gaps` (`pv_work/L03ModGaps.lean:18`), taking the false step as hypothesis `L03_S2_Gap`. `L03_final.md`. |
| 2.5 | UNCONDITIONAL | `Paper.P02.P02_main` (`pv_work/P02.lean:23`), C = 1/4 via Lemma 2.1; sharp (every working C is ≥ 1/4). `P02_final.md`. |
| 2.6 | ISSUE (B2) | Gap theorem `Paper.P03.P03_main_mod_gaps` (`pv_work/P03ModGaps.lean:26`), taking the false step as hypothesis `P03_S1_Gap`. `P03_final.md`. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md` (no entries)

**There are no external parameters** (`"external_tools": []` in RESULTS.json; the registry in `EXTERNAL_TOOLS.md` is empty; every audit reports "CONDITIONS: none").

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| – | none | – | – | – | – |

Debts recorded in words: none. External assertions not encoded: none. Two uncited facts were encoded and proved, not assumed: the "well known" concavity at main.tex:61 (`P01_S0`) and the nonnegativity of s² at main.tex:86-87 (private helper `s2_nonneg`). The gap hypotheses `L03_S2_Gap` and `P03_S1_Gap` are not external inputs; they appear under §4.2 and §4.3.

## 4. Substantive issues for the authors (in PDF order)

This is the complete list of substantive issues recorded.

### 4.1 Lemma 2.2 (main.tex:24, :47-53): which interval is `I`? (B1, DOMAIN_CLARIFICATION, paper side)

- **What fails.** main.tex:24 says only "`I` denotes the unit interval". Under `I=[0,1]`, V_n(0)=V_n(1)=0, so "for every p ∈ I, V_n(p) > 0" (main.tex:48) is false at both endpoints for every n ≥ 1. The proof sentence "both p and 1-p are positive" (main.tex:52) fits only `I ⊆ (0,1)`. Under `I=(0,1)` lemma and proof are correct.
- **Lean evidence.** `pv_work/L02.lean:17` (open reading, standard axioms; `L02_final.md` PASS). `pv_work/L02_Counterexample1.lean` refutes the closed reading at n=1, p=0. Ruling `L02_issue_1.md` (conclusion threatened: no); review `L02_issue_1_audit.md` (COUNTEREXAMPLE VALID).
- **Not affected.** No result cites Lemma 2.2. Lemma 2.1 and Proposition 2.6 do not use `I`; Proposition 2.5 is stated for all real p; Proposition 2.3 holds under both readings (`P01_final.md` §6); Lemma 2.4 fails under both (§4.2).
- **Recorded suggestions** (`L02_issue_1.md` §6, `L02_issue_1_audit.md` §6): state at main.tex:24 which interval is meant, or write Lemma 2.2 as "for every p ∈ (0,1)". The audit judges the second sufficient; fixing `I=[0,1]` at main.tex:24 would not.
- **Note on the reading used.** Verification used the open reading for 2.2 and 2.4 and the closed reading for 2.3 (stronger, so also covers the open one); the outcomes above hold per reading.

### 4.2 Lemma 2.4 (main.tex:66, :70): false as printed (B3, ERROR, paper side)

- **What fails.** The printed conclusion V_n(p) ≤ p/(4n) is false: n=1, p=1/10 gives V_1(1/10) = 9/100 > 1/40. It fails for every n ≥ 1 at p=1/10; on (0,1) it holds exactly for p ≥ 3/4. The same under the open and closed readings. The step at main.tex:70 ("By Lemma 2.1, V_n(p) = p(1-p)/n ≤ p/(4n)") does not follow: Lemma 2.1 gives only V_n(p) ≤ 1/(4n).
- **Lean evidence.** `pv_work/L03_Counterexample1.lean` (`counterexample_open`, `counterexample_closed`, `gated_statement_false`, `step_fails_with_L01`, `fails_every_n`, `open_iff`). Gap file `pv_work/L03ModGaps.lean` (`L03_S2_Gap` line 13, `L03_main_mod_gaps` line 18): the citation of Lemma 2.1 and the assembly are verified modulo the false step. `L03_issue_1.md` (conclusion threatened: yes), `L03_issue_1_audit.md` (COUNTEREXAMPLE VALID), `L03_final.md` (PASS modulo gap).
- **Not affected.** Lemma 2.1 and all other results; nothing cites Lemma 2.4.
- **Recorded suggestions** (`L03_issue_1.md` §6; confirmed by hand in `L03_issue_1_audit.md` §5; not Lean-checked, not adopted): (a) replace p/(4n) by p/n, citing p(1-p) ≤ p rather than Lemma 2.1; (b) keep p/(4n) and restrict to p ∈ [3/4,1]; (c) delete the lemma, since nothing uses it. The intended bound cannot be determined from the source.

### 4.3 Proposition 2.6 (main.tex:86): first proof step false (B2, PAPER_ARGUMENT_GAP, paper side)

- **What fails.** The proof states s²(x+y) = s²(x)+s²(y). This omits the cross term 2·cov(x,y) and is false for every m ≥ 2 (e.g. m=2, x=y=(0,1): s²(x+y)=2, s²(x)+s²(y)=1). Reading "=" as "≤" fails at the same instance. The second link s²(x)+s²(y) ≤ 2s²(x)+2s²(y), because both terms are nonnegative (main.tex:86-87), is correct. The printed conclusion (main.tex:82) is **not refuted**: it holds at the witness with equality (2 ≤ 2). That it holds in general is reasoning only, not checked in Lean.
- **Lean evidence.** `pv_work/P03_Counterexample1.lean` (`counterexample`, `counterexample_le`, `fails_every_m`, `concl_at_witness`, `step2_holds`). Gap file `pv_work/P03ModGaps.lean` (`P03_S1_Gap` line 8, `P03_main_mod_gaps` line 26). `P03_issue_1.md` (conclusion threatened: no), `P03_issue_1_audit.md` (COUNTEREXAMPLE VALID), `P03_final.md`.
- **Not affected.** All other results; the second link inside 2.6.
- **Recorded suggestion** (`P03_issue_1.md` §6, `P03_issue_1_audit.md` §5; paper check only, not Lean-checked, suggestion only): use s²(x+y) = s²(x)+s²(y)+2c(x,y) with c the sample covariance, then 2c ≤ s²(x)+s²(y) from 2ab ≤ a²+b² on centred coordinates. Assuming c(x,y)=0 would validate the printed proof but weaken the proposition.

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by (report path) |
|---|---|---|---|
| main.tex:61 | Is the "well known" concavity of p ↦ √(p(1-p)) an external input? | Fair implicit step; proved from mathlib as `P01_S0`, no parameter | `verification/audits/P01_gate.md` (item 7), `P01_gate_r2.md`, `P01_final.md` §6 |
| main.tex:86-87 | Is nonnegativity of s² an unjustified step? | Fair implicit step; proved as `s2_nonneg` | `verification/audits/P03_final.md` §4 |
| main.tex:24 | Open vs closed `I` | DOMAIN_CLARIFICATION (see §4.1) | `verification/audits/L02_issue_1.md`, `L02_issue_1_audit.md` |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| Nothing in the source cites Lemmas 2.2, 2.3, 2.4 or Proposition 2.6; only `lem:quarter` is referenced (main.tex:70, :78). | Reading `source/main.tex`; `verification/report/work/consistency_check.md` "Unverified items" |
| Proposition 2.5 repeats "for every n ≥ 1" (main.tex:74) although n ≥ 1 is a global convention at main.tex:24; no audit flagged it as a defect. | `source/main.tex:24, 74`; `P02_final.md` ("no errors, gaps or ambiguities found") |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| – | – | No editorial slips recorded in any audit; none found when quotations were compared with `main.tex`. |
| P1 | main.tex:61 | The "well known" concavity is classified FAIR_IMPLICIT_STEP / editorial by `P01_gate.md` item 7; no fix is recorded. |
| P2 | main.tex:24 | State which interval `I` is (`L02_issue_1.md` §6). Caveat from `L02_issue_1_audit.md` §6: stating `I=[0,1]` leaves Lemma 2.2 false; the sufficient fix is to restrict Lemma 2.2 to p ∈ (0,1). |

## 6. Human-check list

**Literature and citations**: none required; the paper cites no external source.
**Mathematical completion (parts supported by reasoning only)**:
1. Proposition 2.6's printed conclusion s²(x+y) ≤ 2s²(x)+2s²(y) is believed true by a termwise argument; reasoning only (`P03_issue_1.md` §4, §7; `P03_final.md` §7). No verdict relies on it.
2. Suggested fixes for Lemma 2.4 (a)/(b) (paper check only, `L03_issue_1_audit.md` §5) and the covariance fix for Proposition 2.6 (`P03_issue_1_audit.md` §5).
3. A half-open reading of `I` fails at the included endpoint (reasoning only, `L02_issue_1.md` §8).
**Author intent**:
1. Which interval is `I` (B1)?
2. Which bound was intended in Lemma 2.4 (B3)?
3. Intended justification of the first step of Proposition 2.6 (B2).
4. Confirm that no result relies on a reading of `I` different from the one the authors intend (verification used the open reading for 2.2 and 2.4, closed for 2.3; `L02_gate.md` focus ruling item 5).
**Experiments and unnumbered assertions**: none.

## 7. Limits on the formalization side (not paper issues)

- No external parameters, but the paper is not claimed fully verified because of the three issues.
- Lean environment: toolchain leanprover/lean4:v4.19.0 (RESULTS.json); the Mathlib commit is not recorded (`mathlib_rev` is empty in RESULTS.json). Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`), so "not available in Mathlib" checks covered all of Mathlib.
- Technical formalization assumptions (TFA): none recorded. Representation choices approved by the gates (not TFAs): `IOpen`/`IClosed` (`pv_work/Defs.lean:13, 16`), `V` (`:21`), `mean`/`s2` (`:25, 29`); see `verification/audits/DEFS_gate.md` and `L02_gate.md`.
- Scope restrictions: none recorded.
- Corrections on the formalization side: P01's first statement draft treated concavity as an external parameter; the gate's second round (`P01_gate_r2.md`) replaced it by a proved step.
- Lean comment errata: `verification/DOC_ERRATA.md`.

## 8. Process disclosure

- Violations: none recorded.
- Coordinator errors found and corrected: the final-report compilation found stale or narrow record text (B1's "not affected" and "suggested fix" lines, B3's list of fixes, the unsettled "candidates" table in `EXTERNAL_TOOLS.md`); all were corrected in `BLOCKERS.md` and `EXTERNAL_TOOLS.md` before this report. Verdict-line formats in the P03 and L03 audits were corrected by the auditor at the coordinator's request so that `validate` accepts them; no content changed (RESUME.md).
- Unverified by the compiler: `RESULTS.json` `models_used` for L03, P02, P03 lists only sonnet although the gates, auditors and issue checkers for them are opus roles; the field is treated as the prover model only (UNVERIFIED).
- The independent fact check of this report's first draft found 11 problems (1 Major, 3 Moderate, 7 Minor), which have been corrected (first draft kept at `verification/report/work/AUTHOR_REPORT_v1.md`).
- Permission denials and guard refusals: not tabulated in this unattended run.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
- `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md`
