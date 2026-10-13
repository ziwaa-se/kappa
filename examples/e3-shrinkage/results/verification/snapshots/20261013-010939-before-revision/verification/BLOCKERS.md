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

## B1 — L02 / 2.2 — PAPER_ARGUMENT_GAP

- **In one sentence**: The proof of Lemma 2.2 justifies ρ ≤ min{θ²,σ²} by two false claims, "harmonic mean ≤ the smaller" and "ρ ≤ ½ min"; the lemma's conclusion itself is true.
- **Source**: `source/main.tex:54-55`, original sentence "The harmonic mean of two positive numbers is at most the smaller of them, so ρ ≤ ½ min{θ², σ²} ≤ min{θ², σ²}."
- **What fails**: The proof has a wrong step (the conclusion is not false). Harmonic mean 2ab/(a+b) ≥ min (e.g. a=1,b=4 gives 8/5 > 1); ρ ≤ ½ min fails whenever θ² ≠ σ² (θ=1, σ=2 gives ρ=4/5 > 1/2).
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP.
- **Evidence**: `pv_work/L02_Counterexample1.lean`, `verification/audits/L02_issue_1.md`, `verification/audits/L02_issue_1_audit.md` (COUNTEREXAMPLE VALID), `verification/audits/L02_final.md`.
- **Affected**: the proof of L02 as printed (S2, S3 stopped as gaps in `pv_work/L02ModGaps.lean`). **Not affected**: the conclusion of L02 (true); T01 and C01 use only that conclusion.
- **Recorded suggested fix**: per `L02_issue_1.md`: "at most twice the smaller", then drop the ½ min step.
- **Needs human check**: that the suggested fix matches the authors' intent.
- **Found by / date**: pv-drafter, pv-gate; ruled by pv-issue-checker, reviewed by pv-auditor; 2026-10-12.
