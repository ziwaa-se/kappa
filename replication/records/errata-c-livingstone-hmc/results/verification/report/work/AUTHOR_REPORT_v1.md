# On the Geometric Ergodicity of Hamiltonian Monte Carlo (geo_erg_HMC_v3.1.tex, revision 1): final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator; it has passed an independent fact check, whose report is in verification/report/work/factcheck.md.

- **This report is not a claim that the whole paper is fully verified.** The scope is six results set by the user; the verified ones still depend on 8 live external parameters (11 registered, 3 discharged by reconnection) that have not been verified in Lean, one result is unfinished, and parts of the paper are not encoded.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).

---

## 0. Summary table (English, for screenshots)

**6 numbered results: 3 verified unconditionally · 2 verified conditionally · 0 with recorded issues · 1 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions (exceptions recorded in words: the provenance debts of §3). No issue is recorded against the paper in the current revision. The one stop (T01) is on the formalization side, not a counterexample to anything.

| PDF no.* | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.2 | Theorem: negative results for HMC | **Unfinished** | Deterministic-L Theorem 2.2 (both parts) and random-L part (ii) are verified in a gap file, but random-L part (i) is stopped by a formalization-side encoding error (not a paper issue). Not a pass of Theorem 2.2. |
| 2.3 | Corollary: exponential family HMC | Verified (conditional), part (ii) only | `C01_T01Consumed` (predecessor T01 unfinished, not reconnected); through it `T02_Prop35`, `T02_GaussFacts`, `T01_Thm518`. Part (i) and random L under A1 are not encoded. |
| 5.14 | Theorem: light tails not geometrically ergodic | Verified (conditional) | `T02_Prop35`, `T02_GaussFacts` (fixed L); `T02_Prop35Rand` (random-L clause only) |
| 5.15 | Lemma: first step norm growth | Verified (unconditional) | none |
| 5.16 | Lemma: L steps multiply norm | Verified (unconditional) | none (after reconnection to L01) |
| 5.17 | Lemma: acceptance rate tends to zero | Verified (unconditional) | none (after reconnection to L02 and L01) |

\* PDF numbers are those recorded before the revision; the PDF is no longer in `source/`, so they are UNVERIFIED after the revision (§8).

No result has had every condition checked by a person.

## 0b. What the revision changed

From `python3 scripts/pv_status.py followup`. Results that were not reset keep their verdicts (none were kept unchanged other than by re-check: all six were re-run).

| PDF no. | Before (revision 1 of the check) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|
| 5.15 | Verified unconditionally | Verified unconditionally | — | — |
| 5.16 | Recorded issue | Verified unconditionally | B01 | resolved: the revised proof (TEX:968-1007) no longer cites (18) |
| 5.17 | Verified conditionally | Verified unconditionally | — | — |
| 5.14 | Verified conditionally | Verified conditionally | — | — |
| 2.2 | Verified conditionally | Unfinished | — | — |
| 2.3 | Unfinished | Verified conditionally | B02 (earlier, before this check's revision) | resolved: revised (18) uses `3‖x‖` (TEX:900-903) and holds for every β>2 |

"Resolved" means the revised text removes the cause, not that the printed pre-revision proof was repaired. T01 went from conditional to unfinished because the revised check added the random-L reading of Thm 2.2 (see §4.1); this is a change in the formalization scope, not a finding about the paper.

## 1. Overall findings

1. **No counterexample to a main result.** No paper-side issue is open. The only recorded issue is formalization-side (ENCODING_ERROR, T01).
2. **Verified unconditionally:** Lemmas 5.15, 5.16, 5.17 (L02 and L03 by reconnection; see the verdict note in §2).
3. **Verified conditionally:** Theorem 5.14 (fixed L on Prop 3.5 and Gaussian facts) and Corollary 2.3(ii) (on the Theorem 2.2 clause). Debts recorded in words: applicability of Prop 3.5 to a kernel whose acceptance depends on `p_0` (P1); Theorem 5.18 for random L is unproved in the source (P2); Prop 3.6 underlies Thm 5.18 (P3); the identification of Thm 2.2 (i)/(ii) with Thms 5.14/5.18 is not printed (P4).
4. **Unfinished:** Theorem 2.2 (random-L part (i)). UNFINISHED is never counted as a paper error.
5. **Downstream impact:** the old issues B01 and B02 no longer propagate. C01's condition `C01_T01Consumed` is a predecessor clause whose predecessor is unfinished; by `VERDICTS.md` §4.1 it then counts as type (iv), priority A, although the clause equals the fully proved deterministic `T01_main`. No reconnect audit exists (human decision D12).
6. Not encoded: Corollary 2.3 part (i) (TEX:838-885) and the random-L-under-A1 passage (TEX:834-836); both outside the scope set by the user.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 5.15 (L01) | UNCONDITIONAL | `L01_final.md`: conditions none; first step gives `‖x_ε‖>3‖x_0‖` (TEX:946), fixed-δ reading. |
| 5.16 (L02) | UNCONDITIONAL | `L02_final.md` suggests CONDITIONAL on `L02_L01Consumed`; `L02_reconnect_r1.md` (RECONNECT AUDIT: PASS, conditions none) discharges it against UNCONDITIONAL L01. `validate` prints a WARN because it compares only with the final audit. |
| 5.17 (L03) | UNCONDITIONAL | Same pattern: `L03_final.md` suggests CONDITIONAL on `L03_L02Consumed`; `L03_reconnect_r1.md` PASS, conditions none. |
| 5.14 (T02) | CONDITIONAL | Final audit PASS. `main_closed` (fixed L) uses `T02_Prop35`, `T02_GaussFacts`; `main_randL_closed` uses `T02_Prop35Rand`, `T02_GaussFacts` (`T02_reconnect_r1.md` §6). The fixed-L theorem printed at TEX:895-909 does not need `Prop35Rand`; the registry lists the three together. |
| 2.2 (T01) | UNFINISHED | `T01_main` (deterministic L, both parts) and random-L part (ii) verified in `T01.lean` / `T01ModGaps.lean` (final audit PASS on the gap file, conditions `T01_T02Consumed`, `T01_Thm518`, `T01_Thm518Rand`); random-L part (i) stopped (§4.1). A partial pass is not a pass of the theorem. |
| 2.3 (C01) | CONDITIONAL, part (ii) only | S1, S3-S6 verified; condition `C01_T01Consumed`. The `PAPER_VERIFICATION.md` row omits that T01 is unfinished and the inherited conditions; this report is the corrected statement. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person |
|---|---|---|---|---|---|
| 1 | `T02_Prop35` | (ii) registry; attribution doubtful, source cites Roberts–Tweedie (type (i), TEX:298) | T02 fixed L (S9); T01 (i), C01 transitively | Applies to the HMC kernel whose acceptance depends on `p_0`; Prop 3.3 irreducibility | not yet |
| 2 | `T02_GaussFacts` | (v) | T02; T01, C01 transitively | Standard Gaussian facts | not yet |
| 3 | `T02_Prop35Rand` | (ii) | T02 random-L clause only | Applicability to the 𝔏-mixture kernel; carries an `A1Law` antecedent not in the print (formalization side) | not yet |
| 4 | `T01_Thm518` | (ii) by project convention (proved at TEX:1111-1121 for fixed L, out of scope) | T01 part (ii); C01 only through T01 | Proof TEX:1111-1121, Prop 3.6; `≤M` vs `<M` | not yet |
| 5 | `T01_Thm518Rand` | (ii) | T01 random-L part (ii) | Source proves only fixed L | not yet |
| 6 | `T01_T02Consumed` | (p), predecessor T02 final but not reconnected | T01 part (i) | Inherits `T02_Prop35`, `T02_GaussFacts` | not yet |
| 7 | `T01Rand_T02Consumed` | (p), reached only through the gap | T01 random-L (i), not a condition of any result | none for the paper | not yet |
| 8 | `C01_T01Consumed` | (p), predecessor T01 unfinished: counts as (iv), priority A | C01 (S1c, S6) | Equals deterministic `T01_main` (gate probe); decide reconnection | not yet |
| 9-11 | `L02_L01Consumed`, `L03_L02Consumed`, `T02_L03Consumed` | (p), reconnected | no longer conditions | — | — |

Debts recorded in words: P1-P5 (see `external_tools.md` §4 in `verification/report/work/`): P1 applicability of Prop 3.5; P2 Thm 5.18 random L; P3 Prop 3.6; P4 identification of Thm 2.2 with Thms 5.14/5.18; P5 (19) and Lemma 5.17 needed for each charged `l`. External assertions not encoded: Cor 2.3(i); Cor 2.3 under A1 (TEX:834-836); Thm 2.2(i) for general random 𝔏; Prop 3.3.

## 4. Substantive issues for the authors (in PDF order)

No paper-side issue is open. B01 and B02 are resolved by the revision (§0b).

### 4.1 Theorem 2.2 (i), random 𝔏: ENCODING_ERROR (formalization side, NOT a paper issue)

- **Classification:** ENCODING_ERROR, formalization side; stage code `STOPPED/TRANSLATION_BLOCKED` (closest allowed code). Ruling: `verification/audits/T01_issue_1.md`, "THREATENS CONCLUSION: no".
- **Source:** TEX:208-219 (Thm 2.2 names no A1), TEX:934-940, TEX:300-303 (Prop 3.5 has no A1 premise).
- **What fails:** `Prop35Rand` (`pv_work/T02Stmt.lean:146-151`) was given an `A1Law` antecedent that printed Prop 3.5 does not have; hence `T01Rand_T02Consumed` (`T01Stmt.lean:84-87`) carries it, while `T01_main_randL` correctly does not, so `partI` cannot be derived: gap `T01_main_randL_partI_Gap` (`T01ModGaps.lean`). The argument at TEX:936-940 consumes neither clause of A1.
- **Lean evidence:** probe `pv_work/probes/issue/T01/T01_issue1_noA1.lean`, `exit=0`, standard axioms only.
- **Review status:** the ruling states "not confirmed until pv-auditor review"; no `T01_issue_1_audit.md` exists. The classification is therefore UNVERIFIED by a second role, although `RESULTS.json` and `AUDIT.md` record it as settled.
- **Not affected:** `T01_main` (deterministic L), random-L part (ii), all of T02, L01-L03.
- **Recorded suggestion (formalization side, not a change to the paper):** drop the `A1Law` antecedent from `Prop35Rand` (`T01_issue_1.md` §6), re-gate, re-prove, re-audit, reconnect; or drop the random-L extension, which was added beyond the deterministic-L scope. Not done in the unattended run.

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by |
|---|---|---|---|
| TEX:935 | "as in Assumption A1": descriptive or restrictive? | Result holds under both readings; wording only (EDITORIAL) | `verification/audits/T01_issue_1.md` §3 |
| TEX:217 vs 1104 | `‖∇U‖ ≤ M` vs `< M` | FAIR_IMPLICIT_STEP (bridged by M+1) | `T01_final.md` §5 S2 |
| TEX:932 | `r(x_0)→1` implies `esssup r = 1`; MH-type identification with `p_0`-dependent α | FAIR_IMPLICIT_STEP (F2, F3) | `T02_final.md` |
| TEX:806 | β<1 / ‖∇U‖≤M verifications not written | FAIR_IMPLICIT_STEP | `C01_final.md` §5 |
| TEX:1036-1040, 1023-1024, 1076-1083 | reindexing, monotonicity of `‖x_{iε}‖`, `‖x_0‖≥1` | FAIR_IMPLICIT_STEP | `L03_final.md` §5 |
| TEX:208-219 (X3), unquantified ε, L (N9) | Thm 2.2 has no proof pointer; quantifiers | preliminary EXPOSITION_GAP / DOMAIN_CLARIFICATION in the gate; **never ruled** by an issue-checker | `T01_gate.md` (no ruling) |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| T01's registry provenance for Prop 3.5 is (ii) while TEX:298 cites Roberts–Tweedie 1996 (type (i)); this changes the human-check priority from C to B/D | `external_tools.md` §1.1, `INVENTORY.md` item 4 |
| `T01_Thm518` is labelled (ii) but the source proves it for fixed L (TEX:1111-1121); it is a numbered result outside the user's scope | `external_tools.md` §1.4 |
| TEX:1112 reuses `\e` (step size) as a tolerance; Prop 3.6 uses `η`. Not in any audit | pv-compiler remark only |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | TEX:911, 917-921 | "Fix any δ<1": the display `μ_G(‖p_0‖>‖x_0‖^δ)→0` is false for δ≤0; one δ∈(0,1) is needed (`T02_final.md` F1) |
| 2 | TEX:982 vs 946, 961 | "‖x_0‖ ≥ max(R,η)" but Lemma 5.15 needs strict `‖x_0‖>η`; η denotes two constants (`L02_final.md`) |
| 3 | TEX:978, 987-992 | divisions by `‖x‖`, `‖x_{iε}‖` leave non-vanishing implicit |
| 4 | TEX:393 | Assumption A1 sentence garbled; positivity of `s` and quantifier order implicit (`T02_gate.md` 7.4) |
| 5 | TEX:217 vs 1104 | `≤M` vs `<M` |
| 6 | TEX:935 | "as in Assumption A1" over-specifies; optional wording "(as in Section 5, independent of the current position)" |
| 7 | TEX:906 vs 965 | (19) uses `2^L`, Lemma 5.16 gives `3^L`; compatible (no change needed) |
| 8 | TEX:1112 | `\e` reused as tolerance (coordinator observation, see §4.x) |

## 6. Human-check list

**Literature and citations**: Prop 3.5 attribution and applicability to the `p_0`-dependent acceptance (D1); `T02_Prop35Rand` for the mixture kernel (D2); Prop 3.3 conditions (D3); Thm 5.18 proof and Prop 3.6, `≤M`/`<M` (D4); Thm 5.18 for random L unproved (D5); Gaussian facts (D6).
**Mathematical completion (reasoning only)**: `GeomErgodic` encoding equivalences (∀x vs π-a.e., `tvDist` factor 2) and "true as encoded" for Prop 3.5 (D14); acceptance of reconnection-based UNCONDITIONAL verdicts for L02, L03 (D17); independent review of the T01 ENCODING_ERROR ruling (D9b).
**Author intent**: is Thm 2.2 (i)=Thm 5.14, (ii)=Thm 5.18 (D7, X3)? ε, L quantification (D8, N9); A1 wording (D9); does ℤ_+ include L=0 (D10); intended δ range (D11); priority and reconnection of `C01_T01Consumed` (D12); C01 scope (D13); A1 quantifiers (D15).
**Experiments and unnumbered assertions**: none. PDF numbering after the revision (D16).

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean v4.19.0, Mathlib linked from the shared `lean-env` (commit not recorded here); Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`), so "not available in Mathlib" checks covered all of Mathlib.
- Technical formalization assumptions (TFA) approved by the gates: `0<d`, `IsGradField U gU`, `∫e^{-U}<∞`, `0<ε`, `1≤L`, (19) for each charged `l≥1`; for random L, 𝔏 a probability law with `𝔏{0}=0` (TFA-1..6 of `T02_gate.md`, TFA-A..D of `T01_gate.md`, TFA-1 of `L03_gate.md`).
- Scope restrictions: deterministic L (𝔏=δ_L) for T01 and C01; C01 is part (ii) only; Cor 2.3(i) and the A1 random-L passage are not encoded; Prop 3.3, 3.5, 3.6, 4.2, Thm 5.18 are not registered numbered results.
- Corrections on the formalization side: enc1 reset of T01 (unconditional L02 clause was vacuous for part (ii)); T01 random-L enc2 fix pending (§4.1). `Defs.HypOscillations` (`2‖x‖`) is stale relative to revised (18), which lives in `Paper.L03.HypOscillations3`.
- The mechanical audit script under-traces conditions for T02/T01/C01; the auditors corrected this by hand (`T02_final.md` §1, `T01_final.md` §3).
- Lean comment errata: `verification/DOC_ERRATA.md`.

## 8. Process disclosure

- Violations: none recorded. A coordinator edit to an audit file was blocked by the guard, correctly (earlier session).
- Coordinator errors found and corrected: the earlier-session report/records described the pre-revision manuscript; records now stale (see `verification/report/work/consistency_check.md`): `BLOCKERS.md` partly stale after the revision (headings repeat RESOLVED, evidence paths moved to `audits/rev1/` and `pv_work/superseded/rev1/`), `EXTERNAL_TOOLS.md` line numbers and "used by" fields stale (§3 uses the final-audit values), `RESUME.md` header lines stale, `AUDIT.md` has duplicate entries. These records were left unedited; this report and `consistency_check.md` state the correct values.
- Unresolved record inconsistency: T01's `RESULTS.json` stage code reads TRANSLATION_BLOCKED while the ruling reads ENCODING_ERROR (both formalization side); the `T01_final.md` text still calls the stop a possible exposition/assumption gap "requiring A1".
- PDF numbering of all results is unverified after the revision (PDF absent from `source/`).
- The independent fact check of this report's first draft: see below (to be completed with the fact-check outcome).
- Permission denials and guard refusals: no count was compiled in this unattended session.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md`
- `verification/report/work/factcheck.md` (independent fact-check report)
