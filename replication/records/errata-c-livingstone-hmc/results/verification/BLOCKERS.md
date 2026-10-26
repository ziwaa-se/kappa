# Issue records (Blockers)

An entry counts as open until its heading is marked `— RESOLVED (date)`. For the classification see `verification/rules/VERDICTS.md` §2.
Do not delete old entries; write corrections in a new section below, and note "see below" on the old heading.

<!-- Entry format (copy to use):

## B01 — <ID> / <PDF no.> — <main code>

- **In one sentence**: ...
- **Source**: `source/…:line`, original sentence "..."
- **What fails**: ... (distinguish "the proof has a gap" from "the conclusion is false")
- **Which side is at fault**: paper side (ERROR / PAPER_ARGUMENT_GAP / PAPER_ASSUMPTION_GAP / EXPOSITION_GAP / DOMAIN_CLARIFICATION)
  or formalization side (ENCODING_ERROR / TRANSLATION_BLOCKED)
- **Evidence**: paths of the Lean file and the audit report; or "reasoning, not checked in Lean"
- **Affected**: ...  **Not affected**: ... (with reasons)
- **Recorded suggested fix**: ... (source: which audit report; if none, write "none")
- **Needs human check**: ...
- **Found by / date**: ...

-->

## B01 — L02 / 5.16 — PAPER_ARGUMENT_GAP — RESOLVED (2026-10-13 10:54, revision 1; re-verified in verification/audits/L02_final.md) — RESOLVED (2026-10-13 10:58, revision 1; re-verified in verification/audits/L02_final.md) — RESOLVED (2026-10-13 10:58, revision 1; re-verified in verification/audits/L02_final.md)

- **In one sentence**: the proof of Lemma 5.16 invokes (18) (eqn:oscillations) at TEX:930-933, but the lemma assumes only (17) (eqn:explode).
- **Source**: `source/geo_erg_HMC_v3.1.tex:930-933`, "Envoking (\ref{eqn:oscillations}) gives ||∇U(x_0)||/(2||∇U(x_ε)||) ≤ 1/6"; statement TEX:899-901 "If (\ref{eqn:explode}) holds then ...".
- **What fails**: the proof has a gap relative to the printed hypotheses; the printed conclusion is still true under (17) alone (Lean positive probe `pv_work/probes/issue/L02/issue_L02_positive.lean`, recompiled by the auditor), so the conclusion is not threatened. (17) does not imply (18) (reasoning example U' = x^3(2+sin x), not checked in Lean).
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP.
- **Evidence**: `verification/audits/L02_issue_1.md`, review `verification/audits/L02_issue_1_audit.md` (REVIEW: CONFIRMED), final audit `verification/audits/L02_final.md`; Lean `pv_work/L02ModGaps.lean` (gap `L02_main_fixedDelta_Gap`; auxiliary `L02_main_fixedDelta_osc:607` proved with (18) as premise).
- **Affected**: L02 as printed. **Not affected**: Theorem 5.14 (assumes (17),(18),(19)), T01, C01, L01; L03 consumes L02 under (17),(18).
- **Recorded suggested fix**: state Lemma 5.16 as "If (17) and (18) hold" (L02_issue_1.md §8 Option A).
- **Needs human check**: boundary PAPER_ARGUMENT_GAP vs FAIR_IMPLICIT_STEP given context TEX:879.
- **Found by / date**: pv-gate / pv-prover; ruled by pv-issue-checker, confirmed by pv-auditor, 2026-10-13.

## B02 — C01 / 2.3 — PAPER_ARGUMENT_GAP — RESOLVED (2026-10-13 11:43, revision 1; re-verified in verification/audits/C01_final.md) — RESOLVED (2026-10-13 11:43, revision 1; re-verified in verification/audits/C01_final.md)

- **In one sentence**: Cor 2.3(ii) for β>2 is justified at TEX:806 only by "a direct consequence of Theorem 2.2", but hypothesis (18) of Thm 2.2(i) (‖y‖≥2‖x‖≥C ⇒ ‖∇U(y)‖≥3‖∇U(x)‖) is false for every member of E(β,α) with 2<β<log₂6≈2.585.
- **Source**: `source/geo_erg_HMC_v3.1.tex:806` "Part (ii) is a direct consequence of Theorem \ref{thm:negative}"; Thm 2.2(i) TEX:208-219; (18) TEX:868-871; class E(β,α) TEX:223-226, 229-239.
- **What fails**: the printed justification fails on that range (for y=2x the gradient ratio is 2^{β-1}<3). This is a gap in the argument, not a refutation: the conclusion of Cor 2.3(ii) for 2<β<log₂6 is not established by Thm 2.2 as printed, and not shown false. (18) holds for β≥log₂6; the β<1 branch and (17)/(19) are fair implicit steps.
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP.
- **Evidence**: Lean `pv_work/C01_Counterexample1.lean` (`osc_fails`, `osc_holds`, `not_S2Printed`; standard axioms), `verification/audits/C01_issue_1.md`, review `verification/audits/C01_issue_1_audit.md` (COUNTEREXAMPLE VALID), final audit `verification/audits/C01_final.md`; gap `C01_S2_Gap` in `pv_work/C01ModGaps.lean`.
- **Affected**: C01 part (ii) for 2<β<log₂6. **Not affected**: Thm 2.2 itself, T01, T02; C01 (ii) for β<1 and β≥log₂6 (modulo the other conditions).
- **Recorded suggested fix**: none (the auditors did not propose one).
- **Needs human check**: whether another route in the paper covers 2<β<log₂6; also X2 (random 𝔏 under A1 vs fixed L) as recorded under T01.
- **Found by / date**: pv-gate / pv-drafter; ruled by pv-issue-checker, confirmed by pv-auditor, 2026-10-13.

## Corrections (2026-10-13, /pv-report consistency check)

- **B02, "Recorded suggested fix: none" is wrong (see above).** The audit records contain two options: (1) restrict the appeal to Thm 2.2(i) at TEX:806 to β ≥ log₂6 (verified sufficient for the (18) part by `osc_holds`; a scope restriction, so (ii) on 2<β<log₂6 would then need another argument) (`C01_issue_1.md` §8 item 1, `C01_issue_1_audit.md` §5 option 1); (2) replace "2" in (18) by "some fixed k ≥ 2" (reviewer-constructed, not in the source, unverified, human check needed) (`C01_issue_1.md` §8 item 2, `C01_issue_1_audit.md` §5 option 2).
- **B01, downstream clause.** L03 (`L03_L02Consumed`), T02 (`T02_L02Consumed`), T01 and C01 (through T02) are CONDITIONAL on a clause whose predecessor L02 carries B01 and which is not reconnected; the `upstream_issues` field in RESULTS.json is empty for L03, T01, C01 and lists B01 only for T02. The report states B01 for all four.
