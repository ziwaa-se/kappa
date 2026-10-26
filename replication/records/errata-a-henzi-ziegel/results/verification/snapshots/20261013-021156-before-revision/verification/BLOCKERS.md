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

## B1 — T01 / Theorem 3.1 — PAPER_ARGUMENT_GAP
- **Location**: source/VSIFP_02.tex:419 ("E(0) ∈ (0,1)") and its mirror under l.423 ("similar arguments", p>q).
- **Problem**: false at λ=1, where E(0)=0 (the theorem allows λ∈(0,1]). Counterexample: ν=δ_{1/2}, p=1/4, q=3/4, E=E_{p,q;1} (pv_work/T01_Counterexample1.lean, review COUNTEREXAMPLE VALID in verification/audits/T01_issue_1_audit.md). Correct range [0,1) suffices.
- **Threatens conclusion**: no; Theorem 3.1 is true; downstream results unaffected.
- **Evidence**: verification/audits/T01_issue_1.md, T01_final.md; gap file pv_work/T01ModGaps.lean (gaps T01_S8_Gap, T01_S10_Gap).
- **Found by / date**: pv-gate, pv-prover, pv-issue-checker, 2026-10-12.

## B2 — T02 / Theorem 3.2 — PAPER_ARGUMENT_GAP
- **Location**: source/VSIFP_02.tex:435 (claim lim g = -∞ and a maximiser in [0,1)) and its mirror under l.462 ("analogous", p>q). Side note: l.454 has a sign error with no effect on the result (recorded in T02_final.md).
- **Problem**: false at π₁=1 (p<q) and π₁=0 (p>q). Counterexample: δ_{1/2}, p=1/4, q=3/4 (pv_work/T02_Counterexample1.lean; review COUNTEREXAMPLE VALID in verification/audits/T02_issue_1_audit.md). The printed λ=1 and e-values still hold there.
- **Threatens conclusion**: no. Affected obligations S3a, S3b, S8, S9, S15 at the edge cases only.
- **Evidence**: verification/audits/T02_issue_1.md, T02_issue_1_audit.md, T02_final.md; gap file pv_work/T02ModGaps.lean.
- **Found by / date**: pv-prover, pv-issue-checker, pv-auditor, 2026-10-13.

## B3 — P05 / Proposition 3.5 — ERROR
- **Location**: source/VSIFP_02.tex:474,476 (proof applies E(e_t | F_t) ≤ 1 a.s.) with statement :235-240.
- **Problem**: P04 gives only E e_t ≤ 1, and e_t is F_t-measurable, so E(e_t|F_t) ≤ 1 would mean e_t ≤ 1 a.s., false in general. For h ≥ 2 the printed conclusion E(e_τ) ≤ 1 is itself false: Lean counterexample at h=2 with E e_τ = 5/4, satisfying all printed hypotheses and P04's conclusion (pv_work/P05_Counterexample1.lean; COUNTEREXAMPLE VALID in verification/audits/P05_issue_1_audit.md). The paper's own remark at l.242 says the stopped e-value is random for h>1. For h=1 the conclusion is believed true (via l.242 with λ_t 1{t<τ} and Fatou) but that is reasoning only, not checked in Lean; the printed proof is a PAPER_ARGUMENT_GAP there.
- **Threatens conclusion**: yes for h ≥ 2 (read literally, e_τ = e_{τ(ω)}(ω)); h=1 conclusion not threatened.
- **Evidence**: verification/audits/P05_issue_1.md, P05_issue_1_audit.md, P05_final.md; gap file pv_work/P05ModGaps.lean (gap P05_Sbridge_Gap).
- **Needs human check**: that e_τ means e_{τ(ω)}(ω) (l.233, l.476); the h=1 repair is reasoning only. Minor: H_S vs H_{S;c} (l.236-238, DOMAIN_CLARIFICATION); τ<h+1 (FAIR_IMPLICIT_STEP).
- **Found by / date**: pv-drafter, pv-gate, pv-prover, pv-issue-checker, pv-auditor, 2026-10-13.
