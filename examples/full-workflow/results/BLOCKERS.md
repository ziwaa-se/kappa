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

## B01 — L02 / 2.3 — ERROR — RESOLVED (2026-09-30 20:53, revision 1; re-verified in verification/audits/L02_final.md)

- **In one sentence**: Lemma 2.3's printed inequality `x²/(1+x) ≥ x-1` is false for every `x < -1` (e.g. `x = -2` gives `-4 ≥ -3`, false), though `x ≠ -1` is the only printed hypothesis.
- **Source**: `source/main.tex:71-76` (statement), original sentence "For every real number $x \neq -1$ we have $\frac{x^2}{1+x} \ge x - 1$."; proof `source/main.tex:78-81`, "Multiplying both sides by $1+x$, the claim is equivalent to $x^2 \ge (x-1)(x+1) = x^2-1$, which is obvious."
- **What fails**: the conclusion itself is false on part of the stated domain (not merely a proof gap) — "multiplying both sides by `1+x`" silently needs `1+x>0`, but `x ≠ -1` also allows `x < -1` where `1+x<0`, which reverses the inequality direction. Secondary classification: `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP` for the proof's missing sign case-split.
- **Which side is at fault**: paper side — `ERROR` (primary; printed conclusion false), contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP`.
- **Evidence**: `pv_work/L02_Counterexample1.lean` (builds, axiom-clean, witness `x = -2`); ruling `verification/audits/L02_issue_1.md` (ISSUE VERDICT: ERROR); independent confirmation `verification/audits/L02_issue_1_audit.md` (COUNTEREXAMPLE VALID).
- **Affected**: L02 only. **Not affected**: L01 (independent lemma, no dependency); P01 (depends only on L01, never cites L02). The statement is true for all `x > -1` (includes the companion-paper's stated use range `x ≥ 0`, per the unlabeled Remark at `main.tex:83-85`, which is unaffected).
- **Recorded suggested fix**: restrict the domain to `x > -1` (verified independently in `verification/audits/L02_issue_1_audit.md`, probe `auditor_L02_ce1_fix.lean`); source: L02 counterexample-review audit.
- **Needs human check**: none beyond the recorded Lean evidence — this is a reasoning+Lean-confirmed paper error, not something needing literature lookup.
- **Found by / date**: pv-drafter and pv-gate (independently, during drafting/gate), 2026-09-30; ruled by pv-issue-checker and confirmed by pv-auditor, 2026-09-30.
