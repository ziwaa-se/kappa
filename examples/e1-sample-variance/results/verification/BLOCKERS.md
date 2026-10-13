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

## B01 — L03 / 2.5 — ERROR

- **In one sentence**: Lemma 2.5 claims s² ≤ (1/n)Σxᵢ², which is false when s² is normalised by 1/(n−1) as in Definition 2 (main.tex:35); the step "Dividing by n gives the claim" does not yield it.
- **Source**: `source/main.tex:86` (claim) and `:91`, "Dividing by n gives the claim."
- **What fails**: the conclusion is false, not only the proof. n=2, x=(1,−1): s²=2 > 1=(1/n)Σxᵢ². The step at :90 is correct (S1, S2 verified); dividing (n−1)s² ≤ Σxᵢ² by n gives ((n−1)/n)s² ≤ (1/n)Σxᵢ², not the printed claim.
- **Which side is at fault**: paper side, ERROR.
- **Evidence**: pv_work/L03_Counterexample1.lean (builds, no sorry, standard axioms); verification/audits/L03_issue_1.md; review verification/audits/L03_issue_1_audit.md (COUNTEREXAMPLE VALID); gap-file final audit verification/audits/L03_final.md.
- **Affected**: L03; C01 (its proof at :99 uses L03 and the intermediate s² ≤ 1, which also fails at this instance; C01's own conclusion is ruled on separately).  **Not affected**: L01, L02 (L03 only consumes L02).
- **Recorded suggested fix**: the ruling and audit mention replacing 1/n by 1/(n−1); this is the issue-checker's remark, not a repair made by this project.
- **Needs human check**: confirm intended normalisation of s² and the intended statement.
- **Found by / date**: pv-drafter, pv-gate, pv-prover; ruled by pv-issue-checker, reviewed by pv-auditor; 2026-10-12.

## B02 — C01 / 2.6 — PAPER_ARGUMENT_GAP

- **In one sentence**: the proof of Corollary 2.6 (main.tex:99) chains `s² ≤ (1/n)Σxᵢ² ≤ 1 ≤ 2`; the intermediate `s² ≤ 1` is false under the corollary's own hypotheses (n ≥ 2, |xᵢ| ≤ 1).
- **Source**: `source/main.tex:99`, "By Lemma lem:raw, s^2 <= (1/n) sum x_i^2 <= 1 <= 2."
- **What fails**: the proof as written, not the conclusion. n=2, x=(1,−1): s²=2 > 1, while s² ≤ 2 holds (with equality). This is separate from B01: no repair of Lemma 2.5 alone makes the printed chain true.
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP.
- **Evidence**: pv_work/probes/issue/C01/issue_C01_intermediate.lean; verification/audits/C01_issue_1.md; review verification/audits/C01_issue_1_audit.md (COUNTEREXAMPLE VALID).
- **Affected**: C01's printed proof. **Not affected**: the conclusion s² ≤ 2 (appears true by reasoning only; not Lean-checked).
- **Recorded suggested fix**: C01_issue_1_audit.md and L03_issue_1.md §7: after Fix 1 of B01, `s² ≤ (1/(n−1))Σxᵢ² ≤ n/(n−1) ≤ 2` (hand-checked, suggestion only).
- **Needs human check**: the policy point whether this counts as C01's own issue rather than only inherited from B01 (VERDICTS §1.3).
- **Found by / date**: pv-drafter/pv-gate/pv-auditor flagged; ruled by pv-issue-checker, reviewed by pv-auditor; 2026-10-13.
