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

## B1 — L02 / Lemma 2 — ERROR

- **In one sentence**: Lemma 2 as printed ("for every real number $x$ we have $x^2 \ge x$") is false on the open interval $0<x<1$.
- **Source**: `source/demo.tex:21-22`, "For every real number $x$ we have $x^2 \ge x$"; the proof's key step is `source/demo.tex:25-26`, "The two factors $x$ and $x-1$ always have the same sign, so their product is nonnegative."
- **What fails**: the conclusion itself is false, not merely a proof gap. Witness $x = \tfrac12$: $x \ge 0$ but $x-1 = -\tfrac12 < 0$, so the two factors have *opposite* signs (refuting the "always have the same sign" claim), their product $x(x-1) = -\tfrac14 < 0$ (refuting "nonnegative"), and $x^2 = \tfrac14 < \tfrac12 = x$ (refuting $x^2 \ge x$ itself). The algebraic identity $x^2-x = x(x-1)$ (`demo.tex:25`) is correct; only the sign claim and, consequently, the conclusion are false, and only on $0<x<1$. Outside that range ($x \le 0$ or $x \ge 1$) both the sign claim and $x^2 \ge x$ hold.
- **Which side is at fault**: paper side — `ERROR`.
- **Evidence**: Lean counterexample `pv_work/L02_Counterexample1.lean` (builds, exit=0; axioms all standard, `sorryAx reached: false`); issue ruling `verification/audits/L02_issue_1.md` (`ISSUE VERDICT: ERROR`, `THREATENS CONCLUSION: yes`); independent counterexample review `verification/audits/L02_issue_1_audit.md` (`COUNTEREXAMPLE VALID`), which confirmed the encoding is pinned to the gate-reviewed statement (type-hash match) and is not stronger than the printed hypotheses.
- **Affected**: L02 only. **Not affected**: L01 (`a^2+b^2 \ge 2ab`), which is independent, verified unconditionally, and is not cited by or dependent on L02 — no result in this paper cites Lemma 2.
- **Recorded suggested fix**: from `verification/audits/L02_issue_1.md` §6 (constructed by pv-issue-checker, suggestion only, never used in any verification; re-checked and confirmed in Lean by pv-auditor, `verification/audits/L02_issue_1_audit.md` §6): restricting the statement to $x \le 0$ or $x \ge 1$ makes both the conclusion and the printed "same sign" justification correct, verified in Lean; the identity step needs no change.
- **Needs human check**: no — fully confirmed by an independent Lean-checked counterexample review; nothing further for a human to adjudicate mathematically. The author may wish to decide how to amend the statement (e.g. the $x\le0 \lor x\ge1$ restriction above), but that choice is for the author, not a verification task. (A restatement for integers only was considered in chat/record discussion but appears in no audit record and was not checked in Lean by anyone — it is not a recorded suggested fix.)
- **Found by / date**: pv-drafter (suspected) → pv-gate (independently reproduced) → pv-issue-checker (ruled ERROR) → pv-auditor (independent counterexample review, CONFIRMED), 2026-10-01.
