# On the Geometric Ergodicity of Hamiltonian Monte Carlo (`source/geo_erg_HMC_v3.1.tex`): final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator; an independent fact check was run and its corrections applied (report in `verification/report/work/factcheck.md`, first draft in `verification/report/work/AUTHOR_REPORT_v1.md`; see §8).

- **This report is not a claim that the whole paper is verified.** Only six results were in scope (Thm 2.2, Cor 2.3 part (ii) only, Thm 5.14, Lemmas 5.15-5.17). Everything else, including Cor 2.3(i), was not examined. The in-scope results carry 6 visible parameters that are not proved in Lean (5 for the verified results), and are verified for a fixed (deterministic) integration length L only.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).

---

## 0. Summary table (English, for screenshots)

**6 numbered results: 1 verified unconditionally · 3 verified conditionally · 2 with recorded issues · 0 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions. Neither recorded issue is a counterexample to a main result: both are gaps in an argument, and the printed conclusions are not shown false.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.2 | Theorem: negative results for HMC | Verified (conditional) | Parts (i) and (ii) read as Thm 5.14 and Thm 5.18 (the paper gives no proof of 2.2). Conditions: `T02_L02Consumed` (predecessor L02 carries issue B01), `T02_Prop35`, `T02_GaussFacts`, `T01_Thm518`. Fixed L only. |
| 2.3 | Corollary: exponential-family HMC | Issue recorded (B02) | Part (ii) only. The appeal to Thm 2.2 at TEX:806 fails for 2<β<log₂6 (hypothesis (18) is false there). Part (i) not encoded. The rest of (ii) is conditional on `T02_L02Consumed` (B01), `T02_Prop35`, `T02_GaussFacts`, `T01_Thm518`. |
| 5.14 | Theorem: light tails, not geometrically ergodic | Verified (conditional) | `T02_L02Consumed` (B01), `T02_Prop35`, `T02_GaussFacts` |
| 5.15 | Lemma: first step doubles the norm | Verified (unconditional) | none (fixed-δ reading) |
| 5.16 | Lemma: L steps multiply the norm by 2^L | Issue recorded (B01) | proof uses (18) (TEX:930) but the lemma assumes only (17); conclusion still true under (17). The gap file also carries the condition `L02_L01Consumed`. |
| 5.17 | Lemma: acceptance rate tends to zero | Verified (conditional) | `L03_L02Consumed` (B01) |

No result has a condition that a person has checked (all "Checked by a person" entries are "not yet"), so none of the conditional results is upgraded.

## 1. Overall findings

1. **No counterexample to a main result was found.** Two paper-side issues (both `PAPER_ARGUMENT_GAP`) were recorded: B01 (Lemma 5.16) and B02 (Cor 2.3(ii)). This is not a complete list of observations; see §4-§5.
2. **Verified unconditionally:** Lemma 5.15 (PDF 5.15), in the reading where η may depend on δ (the reading actually used by Lemma 5.17).
3. **Verified conditionally:** Lemma 5.17, Theorem 5.14, Theorem 2.2, each on the visible parameters in §3. Exceptions: Thm 2.2 and Thm 5.14 are formalized for deterministic L (not the random time law 𝔏 of assumption A1); the quantifiers over ε and L are read as "for every ε>0, L≥1".
4. **Issue recorded:** Lemma 5.16 (Lean evidence: a proved auxiliary version with (18) as a premise, and a Lean probe that the conclusion still holds under (17)) and Cor 2.3(ii) (Lean evidence: `osc_fails` and `osc_holds`, a Lean-proved counterexample to hypothesis (18) on the class E(β,α) for 2<β<log₂6).
5. **Downstream impact:** B01 does not make Theorem 5.14 false, since that theorem assumes (18) itself (TEX:868-871). But L03, T02, T01 and C01 all consume the clause "conclusion of Lemma 5.16" (`L03_L02Consumed` / `T02_L02Consumed`) as a visible parameter whose predecessor carries B01 and which was **not reconnected** (the auditor probe `aud_L02cons` derives it under (17)+(18), but the reconnection file `T02Closed_r1` was never produced). B02 affects only Cor 2.3(ii) on 2<β<log₂6.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 2.2 (T01) | CONDITIONAL | No proof in the paper (X3, exposition gap). (i) = Thm 5.14, via `T02_main` under (17)-(19); (ii) = Thm 5.18 (`T01_Thm518`, external). A first final audit failed (F1: the unconditional premise `hL02` is false for every bounded gradient, which made clause (ii) vacuous; ENCODING_ERROR, formalization side), fixed by redraft, re-gate and re-proof; second audit PASS. Per clause: (i) needs `T02_L02Consumed`, `T02_Prop35`, `T02_GaussFacts`; (ii) needs only `T01_Thm518`. Fixed L only. |
| 2.3 (C01) | ISSUE (B02) | Part (ii) only. Obligations S1, S3, S4, S5 verified (S3 = (19) for β>2, S4/S5 = the β<1 branch). S2 (appeal to (18) for β>2) is a gap (`C01_S2_Gap`). Conditions: those of T01 plus B01 through `T02_L02Consumed`. Part (i) not encoded. |
| 5.14 (T02) | CONDITIONAL | Verified under (17)-(19) with `T02_L02Consumed`, `T02_Prop35`, `T02_GaussFacts`. The passage from α→0 on a high-probability region to esssup r = 1 (TEX:879, X1) is a fair implicit step. |
| 5.15 (L01) | UNCONDITIONAL | Fixed-δ reading. The uniform-in-δ reading was an encoding choice that was retired (enc1); both readings are true (archived ruling `verification/audits/revenc1/`, not re-read by the compiler). |
| 5.16 (L02) | ISSUE (B01) | See §4.1. The consumed clause of L01 (`L02_L01Consumed`) is also a condition of the gap file; it is dischargeable from the unconditional L01. |
| 5.17 (L03) | CONDITIONAL | On `L03_L02Consumed` (B01). Editorial/exposition notes only: TEX:953-957 (re-indexing), TEX:966-970 ("for any M"). |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `L02_L01Consumed` (`pv_work/L02Stmt.lean:34`) | (p), predecessor L01 (unconditional) | L02 (gap file; steps S4, S8a, S8b, S10) | L01's fixed-δ reading is the intended reading of Lemma 5.15 | not yet |
| 2 | `L03_L02Consumed` (`pv_work/L03Stmt.lean:25`) | (p), counted as (iv) because predecessor L02 is ISSUE (**B01**) and not reconnected (`VERDICTS.md` §4; `L03_gate`) | L03 (S4a, S9, S11) | Lemma 5.16's conclusion, including the per-step doubling (b) that the paper proves at TEX:934 but does not print | not yet |
| 3 | `T02_L02Consumed` (`pv_work/T02Stmt.lean:101`) | (p), counted as (iv) because predecessor L02 is ISSUE (**B01**) and not reconnected (`T02_gate`) | T02 (S2); T01 clause (i); C01 β>2 branch | same as #2; reconnection was available but not executed | not yet |
| 4 | `T02_Prop35` (`pv_work/T02Stmt.lean:78`) | (ii) | T02 (S8); T01 clause (i); C01 β>2 branch | Roberts-Tweedie Prop 3.5 (TEX:300-303) applies to HMC although its acceptance depends on p_0; Prop 3.3 conditions (TEX:283-289) | not yet |
| 5 | `T02_GaussFacts` (`pv_work/T02Stmt.lean:88`) | (v) | T02 (S4-S6); T01 clause (i); C01 β>2 branch | standard Gaussian concentration, TEX:879 | not yet |
| 6 | `T01_Thm518` (`pv_work/T01Stmt.lean:25`) | (ii) | T01 clause (ii); C01 β<1 branch | Thm 5.18 (TEX:978-984), proof via Prop 3.6 (TEX:307-313, `jarner2003necessary`); `<M` vs `≤M`; fixed L | not yet |

Notes. #4 is an explicitly cited result (natural type (i)); it is registered as (ii) per project instruction (INVENTORY.md:28, 179), which gives it the more conservative priority C. Parameter #1 is not carried by any downstream result. The registry in `RESULTS.json` shows `T02_Prop35` and `T02_GaussFacts` as used only by T02 while the walks show T01 (clause (i)) and C01 as consumers. The registry text of #3 mentions only part (a) of the clause. Candidate E2 (Prop 4.2) in `EXTERNAL_TOOLS.md` is stale: the audits derive Prop 4.2 from the definitions (`L02_final` §5), so it is not an input. Evidence that "mathlib does not have it" for #4 and #5 is a `grep` and a project instruction, not `#check` evidence (compiler check Mo8); priorities are unchanged.

Debts recorded in words: none. External assertions not encoded: Cor 2.3(i) (TEX:234, proof TEX:806-853); the random time law 𝔏 under A1 (TEX:393); Prop 3.3 and Prop 3.6 (they enter only through #4 and #6).

## 4. Substantive issues for the authors (in PDF order)

### 4.1 B02: Corollary 2.3(ii), TEX:806: PAPER_ARGUMENT_GAP (paper side)

- **Source**: proof of Cor 2.3(ii), TEX:806, "Part (ii) is a direct consequence of Theorem 2.2"; Cor TEX:229-239, class E(β,α) TEX:223-226, Thm 2.2(i) TEX:213, hypothesis (18) TEX:868-871.
- **What fails**: for β>2, Thm 2.2(i) needs (18). For every member of E(β,α) with 2<β<log₂6≈2.585, (18) is false (for y=2x the gradient ratio is 2^(β-1)<3). So TEX:806 does not justify (ii) on that range. This is a gap in the argument, not a refutation: the conclusion is neither proved nor shown false there.
- **Lean evidence**: `pv_work/C01_Counterexample1.lean` (`osc_fails` for all members of the class, `osc_holds` for β≥log₂6 with C=2R+1, witness `not_S2Printed` at β=5/2, α=1); standard axioms; review COUNTEREXAMPLE VALID (`C01_issue_1.md`, `C01_issue_1_audit.md`, `C01_final.md`).
- **Not affected**: Thm 2.2 and Thm 5.14 as conditional statements; Lemmas 5.15-5.17; Cor 2.3(ii) for β<1 (proved modulo `T01_Thm518` only) and, as far as (18) is concerned, for β≥log₂6. (17) and (19) hold for every β>2 (fair implicit steps; S1, S3 proved in Lean).
- **Recorded suggestions** (`C01_issue_1.md` §8, `C01_issue_1_audit.md` §5; note that `BLOCKERS.md` B02 originally said "none", corrected in its Corrections section): (1) restrict the appeal to Thm 2.2(i) to β≥log₂6 and either state (ii) only for β<1 or β≥log₂6 or give a separate argument for 2<β<log₂6 (a scope restriction); (2) replace "2" in (18) by "some fixed k≥2" (E(β,α), β>2 then satisfies it with k=3^(1/(β-1))); suggestion only, constructed by the reviewer, not in the source, not checked in Lean, and it would require re-running Lemmas 5.15-5.17 with ratio k.
- **Human check**: whether another route in the paper covers 2<β<log₂6 (the source has none; TEX:245 only says the results are analogous to the MALA results of `roberts1996exponential`).

### 4.2 B01: Lemma 5.16, TEX:899-901, 930-934: PAPER_ARGUMENT_GAP (paper side)

- **What fails**: the lemma assumes only (17) (TEX:899-901), but the proof at TEX:930 ("Envoking (18) gives ‖∇U(x_0)‖/(2‖∇U(x_ε)‖) ≤ 1/6") uses (18), and the general step TEX:934 ("entirely analogous", not written out; filled as FAIR_IMPLICIT_STEP in Lean, `L02_final` §5, §8) inherits that. (17) does not imply (18) (example U'(x)=x³(2+sin x); by reasoning only, not checked in Lean).
- **What does not fail**: the printed conclusion is still true under (17) alone (Lean positive probe `pv_work/probes/issue/L02/issue_L02_positive.lean`, recompiled by the auditor, standard axioms). THREATENS CONCLUSION: no. Review: CONFIRMED (`L02_issue_1.md`, `L02_issue_1_audit.md`).
- **Lean evidence**: gap file `pv_work/L02ModGaps.lean` (gap `L02_main_fixedDelta_Gap`; `L02_main_fixedDelta_osc` at line 607 proves the conclusion with (18) as an explicit premise); `L02_final.md` PASS, suggested verdict ISSUE.
- **Not affected**: Thm 5.14 (assumes (18) itself), Lemma 5.15, Lemma 5.17 (lists (17)-(19) at TEX:940). But L03, T02, T01, C01 carry the clause as a condition (§3 #2, #3).
- **Recorded suggestion** (`L02_issue_1.md` §8, endorsed by `L02_issue_1_audit.md` §5): state Lemma 5.16 as "If (17) and (18) hold then ...". Alternative (reviewer-constructed, suggestion only, not in the source): replace the use of (18) by an argument from (17) and the inequality at TEX:913-915.
- **Human check**: whether TEX:879 "in this case" and TEX:882 "in this scenario" make "(17)-(19) in force" an acceptable implicit convention (which would turn B01 into a `FAIR_IMPLICIT_STEP`); the auditor did not adopt that reading.

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by |
|---|---|---|---|
| TEX:879 (X1) | passage from α→0 on a high-probability region to esssup r = 1 | FAIR_IMPLICIT_STEP | `verification/audits/T02_final.md` §6 |
| TEX:217 vs 979 | Thm 2.2(ii) says ‖∇U‖≤M, Thm 5.18 says <M | FAIR_IMPLICIT_STEP (M→M+1) | `T01_final_r2.md` §5 |
| TEX:896 | constant 6/ε² and "negligibly small" | FAIR_IMPLICIT_STEP (filled in explicitly in Lean) | `L01_final.md` §6 |
| TEX:966-970 | passage to ‖p_0‖²−‖p_{Lε}‖² ≤ −‖x_0‖² | FAIR_IMPLICIT_STEP (routine algebra) | `L03_final.md` §5 |
| TEX:953-957, 934 | per-step doubling is proved at 934 but not in Lemma 5.16's statement | auditor's provisional assessment, EXPOSITION_GAP low severity; not confirmed by an issue-checker | `L03_gate.md` item 7, `L03_final.md` §6A, §8 |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| X3 (Thm 2.2 has no proof or pointer), X2 (Thm 2.2 stated for random 𝔏 under A1, verified for fixed L) and N9 (ε, L unquantified in Thm 2.2, 5.14, read as every ε>0, L≥1) are preliminary gate classifications (EXPOSITION_GAP / EXPOSITION_GAP / DOMAIN_CLARIFICATION or EDITORIAL), **never ruled** by an issue-checker. | `T01_gate.md:69` ("no gate ruling"), `C01_gate.md:83,87`, `T02_gate.md` item 7.3, `verification/audits/revenc1/T01_gate.md:29`, `RESUME.md:48` |
| The T01 and C01 gates say X2/X3/N9 were "already dispatched", but no `T01_issue_*.md` ruling exists and `RESUME.md` says they were not dispatched. The rows above are therefore gate-level classifications only. | `T01_gate.md` §7, `C01_gate.md` item 7.3, `ls verification/audits/`, `RESUME.md` |
| The `T02_L02Consumed` clause is dischargeable according to the auditor probe, but this was not carried out; so T02, T01, C01 stay CONDITIONAL by choice of procedure, not necessarily by necessity. | `T02_final.md` §4, `AUDIT.md` (reconnection column "—") |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | TEX:806 | "Part (ii) is a direct consequence of Theorem 2.2" runs straight into "For part (i)" with no full stop (coordinator/compiler observation from the .tex, not in an audit record). |
| 2 | TEX:879 | "envoked" → "invoked" (`T02_final` §8). |
| 3 | TEX:885 | quantifier order "for all ‖x_0‖>η and any ‖p_0‖≤‖x_0‖^δ for some δ<1" is ambiguous; both readings are true; resolved by Lemma 5.17's "for any δ<1" (TEX:940). EDITORIAL at most DOMAIN_CLARIFICATION (`L01_final` §8). |
| 4 | TEX:896 | "the first term ... is larger than 6/ε²": as printed it does not give ratio >2 for large ε; even read as a bound on ‖∇U(x_0)‖/‖x_0‖ it gives only ratio > 2 − (negligible). Harmless, since (17) allows any constant (`L01_final` §8). |
| 5 | TEX:930 | "Envoking" (spelling; substance in §4.2). |
| 6 | TEX:954 | the step from line 953 silently re-indexes i→L−i, absorbs the ‖∇U(x_0)‖ term and changes the sum range; the aggregate inequality is correct (`L03_final` §5, `L03_gate` item 7). |
| 7 | TEX:960 | δ_L is undefined (equals γ_L) (`L03_final` §5). |
| 8 | TEX:966 | "for any M<∞": the displayed chain fails for M<1; M=1 suffices (`L03_final` §6B). |
| 9 | TEX:970 | "envoking" (spelling; coordinator/compiler observation). |

Presentational suggestion raised in the audits: state the per-step doubling in Lemma 5.16's statement (`L03_final` §6A, §8). Observations only (no audit proposes a fix): Theorem 2.2 has no proof or pointer (X3); it is unclear whether 𝔏 or fixed L is meant (X2); the HMC acceptance depends on p_0 when Prop 3.5 is applied (`T02_final` §6).

## 6. Human-check list

**Literature and citations**: (1) Prop 3.5 (TEX:300-303, `roberts1996geometric`) applies to the HMC kernel; Prop 3.3 conditions (TEX:283-289). (2) Thm 5.18 (TEX:978-984), its proof via Prop 3.6 (`jarner2003necessary`), `<M` vs `≤M`, fixed L. (3) The Gaussian tail fact at TEX:879. (4) The MALA result `roberts1996exponential` for 2<β<log₂6, L=1 (TEX:245; nobody checked it).

**Mathematical completion (parts supported by reasoning only)**: (5) (17) does not imply (18) (the example U'=x³(2+sin x)). (6) That the clause `T02_L02Consumed` / `L03_L02Consumed` can be reconnected under (17)+(18): probe exists, reconnection file does not. (7) Option 2 of B02 (ratio k). (8) The L03 candidates TEX:953-957 and TEX:966-970 (classed by gate and auditor, not by an issue-checker). (8b) X1, TEX:879: the passage from α→0 on the high-probability region to esssup r = 1 (ruled a fair implicit step by the auditor; on the `RESUME.md` human-check list).

**Author intent**: (9) Are (17)-(19) intended to be in force for Lemmas 5.15/5.16 (TEX:879, 882)? (10) Is the quantifier order at TEX:885 fixed-δ (verified) or uniform in δ? (11) Is there another argument for Cor 2.3(ii) on 2<β<log₂6? (12) Is Thm 2.2 meant for random 𝔏 under A1, and what justifies it beyond fixed L? (13) The intended constant at TEX:896.

**Experiments and unnumbered assertions**: (14) Cor 2.3(i) (TEX:234, proof TEX:806-853) was not encoded and is entirely unverified.

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean v4.19.0 (`verification/RESUME.md`); Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json` `lean.mathlib_rev`). Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`), so "not in Mathlib" claims were checked against the full library, but see below on evidence kind.
- Technical formalization assumptions approved by the gates: d>0, `IsGradField`, finite mass, ε>0, L≥1, "for every ε, L" for unquantified ε, L (`T01_gate` TFA-A/B, `T02_gate` TFA-1..4, L03 `hL`).
- Scope restrictions: deterministic L only; Cor 2.3(i) not encoded; Prop 3.3/3.6 not encoded; the numbering (2.2, 2.3, 5.14-5.17) was read from the PDF page images plus counter inference (no `.aux` file), and was not independently verified by the compiler.
- Corrections on the formalization side: the first T01 final audit failed (F1, ENCODING_ERROR, formalization side) and was fixed by redraft; the L01 uniform-δ encoding was retired (enc1).
- Evidence for "not in Mathlib" for `T02_GaussFacts` is a `grep` in the gate (`T02_gate.md:108-112`) and for `T02_Prop35` a project instruction, rather than `#check` probes (compiler check Mo8).
- Lean comment errata: `verification/DOC_ERRATA.md`.

## 8. Process disclosure

- Violations: none recorded.
- Coordinator errors found and corrected: `BLOCKERS.md` B02 wrongly recorded "suggested fix: none" (corrected by an appended section; §4.1 here gives the options). RESULTS.json `upstream_issues` is empty for L03, T01 and C01 although they carry the B01 clause; this report states it (§0, §3), the registry was not edited. `RESUME.md` had a stale header, which is updated at the end of this session.
- Other record inconsistencies found by the compiler and not changed (all minor or moderate, none affects a verdict): stale registration requests in older audit reports; stale mech reports (TRACED CONDITIONS superseded by the final audits); `models_used` entries for L02, L03, T02; duplicate `AUDIT.md` entries; the `PAPER_VERIFICATION.md` rows are one-line summaries; `EXTERNAL_TOOLS.md` candidate list is stale. Details: `verification/report/work/consistency_check.md`.
- An independent fact-check of the first draft found 17 problems (2 Major, 6 Moderate, 9 Minor), which have been corrected (first draft saved as `verification/report/work/AUTHOR_REPORT_v1.md`). The two Major ones were rows wrongly presented as reviewer rulings (X3/X2/N9) and presentational suggestions that no audit had made.
- Permission denials and guard refusals: a coordinator edit to `C01_issue_1_audit.md` was blocked by the guard (correctly) and the auditor reformatted its own verdict line. No denial count was extracted.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report), `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md`
