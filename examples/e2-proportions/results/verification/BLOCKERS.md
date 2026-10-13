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

## B1 — L02 / 2.2 — DOMAIN_CLARIFICATION

- **In one sentence**: the source never says whether the unit interval I is open or closed; Lemma 2.2 is true (and Lean-proved) on (0,1) and false at p=0 and p=1 on [0,1].
- **Source**: `source/main.tex:24` "I denotes the unit interval"; `main.tex:47-53` "For every p ∈ I, V_n(p) > 0" with proof "both p and 1-p are positive".
- **What fails**: under the closed reading V_n(0)=V_n(1)=0 for every n ≥ 1, so the printed conclusion is false; the proof's sentence only fits the open reading. Not a gap in the proof under the open reading.
- **Which side is at fault**: paper side (DOMAIN_CLARIFICATION)
- **Evidence**: `pv_work/L02_Counterexample1.lean` (closed reading), `pv_work/L02.lean` (open reading proof); `verification/audits/L02_issue_1.md`, `verification/audits/L02_issue_1_audit.md` (COUNTEREXAMPLE VALID), `verification/audits/L02_final.md` (PASS under IOpen).
- **Affected**: L02 only as stated. **Not affected**: no other result consumes L02 (no dependents); L01 and P03 do not use I; P01 is verified under both readings (`P01_final.md` §6); L03 is false under both readings (B3); P02 is stated for all real p.
- **Recorded suggested fix**: `L02_issue_1.md` §6 and `L02_issue_1_audit.md` §6: state at main.tex:24 which interval is meant, or write Lemma 2.2 as "for every p ∈ (0,1)" (the audit judges the latter sufficient; fixing I = [0,1] at main.tex:24 would not suffice).
- **Needs human check**: yes — which interval main.tex:24 means.
- **Found by / date**: pv-drafter / pv-gate, ruled by pv-issue-checker, reviewed by pv-auditor; 2026-10-12.

## B2 — P03 / 2.6 — PAPER_ARGUMENT_GAP

- **In one sentence**: the proof's first step "s²(x+y) = s²(x) + s²(y)" omits the cross term 2·cov(x,y) and is false for every m ≥ 2; the printed proposition is not refuted.
- **Source**: `source/main.tex:86` "We have $s^2(x+y)=s^2(x)+s^2(y)$"; statement `main.tex:81-83`.
- **What fails**: the proof has a gap (false identity); the conclusion s²(x+y) ≤ 2s²(x)+2s²(y) is not shown false (it holds at the witness, 2 ≤ 2; that it holds in general is reasoning only, not checked in Lean and not offered as a fix).
- **Which side is at fault**: paper side (PAPER_ARGUMENT_GAP)
- **Evidence**: `pv_work/P03_Counterexample1.lean` (m=2, x=y=(0,1)); `verification/audits/P03_issue_1.md`, `verification/audits/P03_issue_1_audit.md` (COUNTEREXAMPLE VALID); gap file `pv_work/P03ModGaps.lean`, `verification/audits/P03_final.md` (PASS modulo the gap).
- **Affected**: P03 as proved along the source route. **Not affected**: no other result depends on P03.
- **Recorded suggested fix**: the audit notes a covariance-based argument (checked on paper only, not in Lean).
- **Needs human check**: authors to supply a correct justification of the first step.
- **Found by / date**: pv-drafter / pv-gate, ruled by pv-issue-checker, reviewed by pv-auditor; 2026-10-12.

## B3 — L03 / 2.4 — ERROR

- **In one sentence**: Lemma 2.4 (V_n(p) ≤ p/(4n) for p ∈ I) is false as printed; the proof's step does not follow from Lemma 2.1, which gives only V_n(p) ≤ 1/(4n).
- **Source**: `source/main.tex:66` "For every p ∈ I, V_n(p) ≤ p/(4n)"; `main.tex:70` "By Lemma quarter, V_n(p) = p(1-p)/n ≤ p/(4n)".
- **What fails**: the conclusion is false: n=1, p=1/10 gives 9/100 > 1/40 (any n ≥ 1; on (0,1) it holds only for p ≥ 3/4); same under the open and closed readings of I. The step p(1-p) ≤ p/4 is also unjustified (PAPER_ARGUMENT_GAP aspect).
- **Which side is at fault**: paper side (ERROR)
- **Evidence**: `pv_work/L03_Counterexample1.lean`; `verification/audits/L03_issue_1.md`, `verification/audits/L03_issue_1_audit.md` (COUNTEREXAMPLE VALID); gap file `pv_work/L03ModGaps.lean`, `verification/audits/L03_final.md` (PASS modulo the gap S2).
- **Affected**: L03. **Not affected**: no result depends on L03; L01 is used in S1 and stays verified.
- **Recorded suggested fix**: `L03_issue_1.md` §6 and `L03_issue_1_audit.md` §5 record three by-hand options: (a) replace p/(4n) by p/n, (b) restrict to p ∈ [3/4,1], (c) delete the lemma (nothing uses it); not Lean-checked, not adopted.
- **Needs human check**: authors to decide the intended statement.
- **Found by / date**: pv-drafter / pv-gate, ruled by pv-issue-checker, reviewed by pv-auditor; 2026-10-12.
