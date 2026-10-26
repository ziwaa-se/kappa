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

## B01 — L01 / 2.3 — PAPER_ASSUMPTION_GAP

- **In one sentence**: Lemma 2.3 omits the condition F_X(0)=0 that Definition 2.2 requires, so the "if" direction (inequality (eq:sub-1x) implies InvSub) is false as printed.
- **Source**: `source/SuperParetoPaper-v12.tex:130-133`, original sentence "A random variable X is InvSub if and only if (eq:sub-1x)"; compare Def 2.2 at `:124` ("X such that F_X(0)=0") and the analogous characterisation at `:442`, which prints F_X(0)=0.
- **What fails**: the statement is false as written (not merely a proof gap). X=0 a.s. satisfies (eq:sub-1x) for all x≥0, θ∈(0,1) but has F_X(0)=1, so it is not InvSub.
- **Which side is at fault**: paper side, PAPER_ASSUMPTION_GAP.
- **Evidence**: `pv_work/L01_Counterexample1.lean` (standard axioms only); ruling `verification/audits/L01_issue_1.md`; review `verification/audits/L01_issue_1_audit.md` (COUNTEREXAMPLE VALID); gate `verification/audits/L01_gate.md`.
- **Affected**: Lemma 2.3 "if" direction; Theorem 2.8 (`:171-180`) uses the "if" direction for h(X) (lead, not checked: with h(x)=max(x-1,0), F_{h(X)}(0)>0 is possible, so F_{h(X)}(0)=0 may fail).
- **Not affected**: the "only if" direction and the equivalence of subadditivity of 1-F_X(1/x) with (eq:sub-1x) (the proof at `:137` is a rewriting); Theorem 3.1 (does not use the omitted clause per the ruling).
- **Recorded suggested fix**: none recorded by the audits beyond "state F_X(0)=0 in the lemma" (ruling report).
- **Needs human check**: whether Thm 2.8's use of the "if" direction needs its own hypothesis (checked at its own gate).
- **Found by / date**: pv-drafter, pv-gate, pv-issue-checker, pv-auditor; 2026-10-12.

## B02 — P02 / 3.2 — PAPER_ARGUMENT_GAP

- **In one sentence**: the proof of Prop 3.2 takes √X, Var(√X) and Jensen's inequality for √, which require X ≥ 0, but the proposition (`:261-264`) does not assume X ≥ 0.
- **Source**: `source/SuperParetoPaper-v12.tex:263` (statement, no nonnegativity) and `:266` ("Var(√X)=Var(√Y) ... Jensen's inequality implies E(√Y) > ...").
- **What fails**: the proof has a gap as written for signed X (Lean obstruction: √ is not concave on ℝ, and the strict Jensen step fails for negative values). The conclusion is not shown false; it appears true for real X by a different argument (reasoning only, not checked in Lean).
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP (secondary DOMAIN_CLARIFICATION: meaning of "infinite mean" for signed X).
- **Evidence**: `pv_work/probes/issue/P02/issue_P02_sqrtneg.lean`; ruling `verification/audits/P02_issue_2.md`; review `verification/audits/P02_issue_2_audit.md` (REVIEW: CONFIRMED); gap `P02_TwoCase_Gap` in `pv_work/P02ModGaps.lean`.
- **Affected**: Prop 3.2 as printed. **Not affected**: Prop 3.3 (X>0 a.s., n=2, per the ruling).
- **Recorded suggested fix**: adding "nonnegative" at `:263` fixes the proof as written and covers its only use, Prop 3.3 (audit report P02_issue_2_audit.md).
- **Needs human check**: the secondary point on "infinite mean" for signed X.
- **Found by / date**: pv-prover, pv-issue-checker, pv-auditor; 2026-10-12.

## B03 — P02 / 3.2 — DOMAIN_CLARIFICATION

- **In one sentence**: "If (eq:main-st) holds" at `:263` can mean the given n and weights, or a property of X for every n and weights; the step "it is enough to prove the case n=2" (`:266`) is justified only under the second reading.
- **Source**: `source/SuperParetoPaper-v12.tex:95-98`, `:263`, `:266`.
- **What fails**: under the fixed-instance reading (the gated encoding) the n=2 reduction has no argument and n≥3 is uncovered (EXPOSITION_GAP); under the other reading it is a fair implicit step. The conclusion is true under both readings for X ≥ 0.
- **Which side is at fault**: paper side, DOMAIN_CLARIFICATION.
- **Evidence**: reasoning, not checked in Lean (probe `pv_work/probes/issue/P02/issue_P02_njensen.lean` supports only the n-term Jensen step); rulings `verification/audits/P02_issue_1.md`, `P02_issue_1_r2.md`; reviews `P02_issue_1_audit.md` (NOT CONFIRMED), `P02_issue_1_r2_audit.md` (CONFIRMED); gap `P02_S1_Gap`.
- **Affected**: Prop 3.2 (n≥3 under the fixed reading). **Not affected**: Prop 3.3 (uses n=2 only).
- **Recorded suggested fix**: none beyond stating which reading is meant.
- **Needs human check**: which reading the authors intend.
- **Found by / date**: pv-prover, pv-gate, pv-issue-checker, pv-auditor; 2026-10-12.

## B04 — L02 / 4.10 — PAPER_ASSUMPTION_GAP

- **In one sentence**: Lemma 4.10 omits the condition F_X(0)=0 that Definition 4.9 requires, so the "if" direction (eq:inv-NWU implies super-heavy-tailed) is false as printed.
- **Source**: `source/SuperParetoPaper-v12.tex:361-364` (statement) against `:346` (Def 4.9, "such that F_X(0)=0"); compare `:442`.
- **What fails**: the statement is false as written, not merely a proof gap. X=0 a.s. (Dirac at 0) satisfies (eq:inv-NWU) for all x≥0, θ∈(0,1) but has F_X(0)=1. The lemma has no proof in the source (`:358`).
- **Which side is at fault**: paper side, PAPER_ASSUMPTION_GAP (strong alternative: DOMAIN_CLARIFICATION if a standing convention F_X(0)=0 was intended; `:354` arguably supports dropping the qualifier from the definition).
- **Evidence**: `pv_work/L02_Counterexample1.lean` (standard axioms only); ruling `verification/audits/L02_issue_1.md`; review `verification/audits/L02_issue_1_audit.md` (COUNTEREXAMPLE VALID); gate `verification/audits/L02_gate_r2.md`; gap `L02_main_Gap` in `pv_work/L02ModGaps.lean` (false, so the gap file's main theorem is vacuous).
- **Affected**: Lemma 4.10 "if" direction. **Not affected**: S1-S3 and the "only if" direction (proved); Ex 4.13 (`:392`) uses only "only if".
- **Recorded suggested fix**: add the qualifier F_X(0)=0 to the lemma, or drop it from the definition (audit L02_issue_1_audit.md). CAVEAT (report-stage correction, P05_issue_1_audit.md §2, §5): dropping it from Def 4.9 is NOT sufficient paper-wide, because Thm 4.12 (UNCONDITIONAL) takes F_X(0)=0 from Def 4.9 and would fail at delta_0.
- **Needs human check**: whether a standing convention F_X(0)=0 was intended (then DOMAIN_CLARIFICATION).
- **Found by / date**: pv-drafter, pv-gate, pv-prover, pv-issue-checker, pv-auditor; 2026-10-13.

## B05 — T01 / 2.8 — ERROR

- **In one sentence**: Theorem 2.8 is false as printed: a star-shaped h can vanish on [0,a], so h(X) can have F_{h(X)}(0)>0 and is then not InvSub; the proof never shows F_{h(X)}(0)=0.
- **Source**: `source/SuperParetoPaper-v12.tex:171` (statement) and `:180` ("taking into account Lemma 2.3"); `:174`.
- **What fails**: the conclusion is false for a concrete instance. X with cdf x/(1+x) (InvSub, proved in Lean) and h(x)=max(x-1,0) (continuous, star-shaped, increasing, convex) give F_{h(X)}(0)=1/2. Distinct from B01: it remains after B01's fix, and the Lean refutation does not use L01.
- **Which side is at fault**: paper side, ERROR (nearest alternative PAPER_ASSUMPTION_GAP; the human may choose).
- **Evidence**: `pv_work/T01_Counterexample1.lean` (standard axioms only); ruling `verification/audits/T01_issue_1.md`; review `verification/audits/T01_issue_1_audit.md` (COUNTEREXAMPLE VALID); gap `T01_S2_Gap` in `pv_work/T01ModGaps.lean` (false, so the gap file's main theorem is vacuous); final audit `verification/audits/T01_final.md` (PASS on the rest).
- **Affected**: Theorem 2.8 as printed; T03 (`:334-337`) appears false by the same mechanism (reasoning only, needs its own ruling).
- **Not affected**: the subadditivity half of the conclusion (verified in Lean per the ruling); Theorem 3.1 does not use Theorem 2.8.
- **Recorded suggested fix**: ruling suggests adding "h>0 on (0,∞)" (the checker's own unchecked suggestion; not in the source).
- **Needs human check**: classification (ERROR vs PAPER_ASSUMPTION_GAP). Also, FORMALIZATION-SIDE note, not a paper issue: obligation S0 ("every function considered is increasing", `:174`) was ruled ENCODING_ERROR in `verification/audits/T01_issue_2.md` (the tool `T01_X02Tool` was encoded for increasing h only; the source states Lemma 4.1 for star-shaped h). The gap file still carries `T01_S0_Gap`. A re-encoding of the tool was not done in this run because it cannot change the ISSUE verdict, which rests on S2/B05; whether the cited Lemma 4.1 needs h increasing should be checked against the cited paper. The issue_2 ruling has not had a counterexample review.
- **Found by / date**: pv-drafter, pv-gate, pv-prover, pv-issue-checker, pv-auditor; 2026-10-13.

## B06 — T02 / 3.1 — PAPER_ARGUMENT_GAP — RESOLVED (2026-10-13 11:24, revision 1; re-verified in verification/audits/T02_final.md)

> HISTORICAL (baseline manuscript v1; line numbers are baseline). The step text at old :256 was removed by the revision. The original ruling and review are in `verification/audits/rev1/T02_issue_1.md` and `rev1/T02_issue_1_audit.md`; the counterexample is in `pv_work/superseded/rev1/`. The current `audits/T02_issue_1*.md` concern zero weights (FAIR_IMPLICIT_STEP). The old unconfirmed suspicions (atoms :222-223, zero weights) are moot.

- **In one sentence**: the first inequality at `:256`, P ≥ F̄(x/θₙ)+F̄(x/(1−θₙ)), is false, and the reason printed for it does not follow; the final bound P ≥ F̄(x) still follows from `:254` and (eq:sub-1x).
- **Source**: `source/SuperParetoPaper-v12.tex:254-256` (dropped term is nonpositive, so dropping it gives an upper bound, not the claimed lower bound).
- **What fails**: the proof step is wrong as written; the conclusion of Theorem 3.1 is not shown false and is not threatened by this item. The intermediate claim fails at x=0 for every ITS law, and for Pareto(1), θ≡1/3, x=1/2 the right side is 5/3 > 1.
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP.
- **Evidence**: `pv_work/T02_Counterexample1.lean` (standard axioms only; uses `T02_L01Consumed` only for the induction-hypothesis premise, which holds at the witness per the auditor's probe); ruling `verification/audits/T02_issue_1.md`; review `verification/audits/T02_issue_1_audit.md` (COUNTEREXAMPLE VALID); gap `T02_S10b_Gap` in `pv_work/T02ModGaps.lean` (likely refutable; do not cite the gap file's main theorem as evidence for this step).
- **Affected**: the step at `:256`. **Not affected**: Theorem 3.1's conclusion (follows from `:254` plus (eq:sub-1x), per the ruling's own argument, not in the source).
- **Recorded suggested fix**: none in the source; ruling notes the final bound follows from `:254` and (eq:sub-1x) (suggestion only, by the issue-checker).
- **Needs human check**: also unconfirmed suspicions, not registered as issues: `:222-223` (S5/S6a, atoms; for real-valued ITS laws, which have no atoms, these are true in the encoding), and `:95` vs `:219` (zero weights / n=1 not covered, EXPOSITION_GAP).
- **Found by / date**: pv-drafter, pv-gate, pv-prover, pv-issue-checker, pv-auditor; 2026-10-13.

## B07 — P04 / 4.6 — PAPER_ASSUMPTION_GAP

- **In one sentence**: Proposition 4.6 omits the hypothesis that X is non-degenerate, so its first sentence ("F_X is DOR (equivalently super-Pareto) iff 𝒫 ≤c F_X") is false for X a.s. constant.
- **Source**: `source/SuperParetoPaper-v12.tex:315-318` (statement); definitions `:284-312` (super-Pareto requires a nonconstant h, `:286`).
- **What fails**: for X = δ₀ (any δ_c), 𝒫 ≤c F_X holds (the transform is constant), but δ_c is not super-Pareto/DOR. The paper has no standing non-degeneracy convention. The counterexample holds under every reading of the domain and of concavity checked (R2, R3, R4). The second sentence (F_X ≤c 𝒫) and the downstream uses (`:323`, `:337`) are not affected.
- **Which side is at fault**: paper side, PAPER_ASSUMPTION_GAP (ERROR is an admissible alternative).
- **Evidence**: `pv_work/P04_Counterexample2.lean` (standard axioms only); ruling `verification/audits/P04_issue_2.md`; review `verification/audits/P04_issue_2_audit.md` (COUNTEREXAMPLE VALID); gate `verification/audits/P04_gate_r2.md`; final audit `verification/audits/P04_final.md` (PASS for the statement with the gate-approved TFA `hnd`: μ not a Dirac mass).
- **Affected**: Proposition 4.6 as printed (clauses with the Dirac law). **Not affected**: all clauses for non-degenerate X (verified in `pv_work/P04.lean`, conditional on P04_X01Tool for the "super-Pareto" parenthetical). The step at `:320` (concavity to convexity of the inverse) was ruled FAIR_IMPLICIT_STEP (`P04_issue_1.md`).
- **Recorded suggested fix**: add "X non-degenerate" to the proposition (this is exactly the TFA `hnd`; suggestion only).
- **Needs human check**: whether Def 4.5 is tacitly limited to continuous laws (then DOMAIN_CLARIFICATION); ASSUMPTION_GAP vs ERROR; the domain on which concavity of Λ and 1/F̄ is meant (DOMAIN_CLARIFICATION, not ruled).
- **Found by / date**: pv-drafter, pv-gate, pv-prover, pv-issue-checker, pv-auditor; 2026-10-13.

## B08 — P05 / 5.2 — PAPER_ASSUMPTION_GAP

- **In one sentence**: Proposition 5.2 ("X is super-heavy-tailed iff F_X ≤_{i-sb} ℋ") omits the qualifier F_X(0)=0, so the "if" direction is false for X = 0 a.s.
- **Source**: `source/SuperParetoPaper-v12.tex:431` (statement), `:434` (proof); Def 4.9 at `:346` requires F_X(0)=0; the parallel Proposition 5.3 prints the qualifier at `:442`; remark `:426`.
- **What fails**: X = δ₀ satisfies F_X ≤_{i-sb} ℋ under both domain readings checked ((0,∞) and ℝ∖{0}), but F_X(0)=1, so it is not super-heavy-tailed. The remark at `:426` does not exclude it. Only the "if" direction fails; the "only if" direction and its use at `:448` are not affected.
- **Which side is at fault**: paper side, PAPER_ASSUMPTION_GAP (DOMAIN_CLARIFICATION if `:346` is meant as a standing convention).
- **Evidence**: `pv_work/P05_Counterexample1.lean` (standard axioms only); ruling `verification/audits/P05_issue_1.md`; review `verification/audits/P05_issue_1_audit.md` (COUNTEREXAMPLE VALID); gate `verification/audits/P05_gate.md`; final audit on the gap file `verification/audits/P05_final.md` (PASS: S1–S3 verified; `P05_main_mod_gaps` is vacuous).
- **Affected**: Proposition 5.2 as printed ("if" direction). **Not affected**: S1–S3 (the F⁻ to F step at `:434` is a FAIR_IMPLICIT_STEP).
- **Recorded suggested fix**: add "such that F_X(0)=0" to the statement, as at `:442` (suggestion only).
- **Needs human check**: whether `:346` is a standing convention (then DOMAIN_CLARIFICATION).
- **Found by / date**: pv-drafter, pv-gate, pv-prover, pv-issue-checker, pv-auditor; 2026-10-13.

## B09 — T03 / 4.8 — ERROR

- **In one sentence**: Theorem 4.8 ("nonnegative super-Pareto implies InvSub") is false as printed: nonnegative super-Pareto laws can have an atom at 0 or lack subadditivity.
- **Source**: `source/SuperParetoPaper-v12.tex:332-335` (statement); Def 2.2 (requires F_X(0)=0); Def 4.1 `:283-286`.
- **What fails**: X = max(Z−2,0) (Z Pareto) is nonnegative super-Pareto with F_X(0)=1/2, so not InvSub. X = Z+1 has F_X(0)=0 and still violates the subadditivity condition (at 1/4, 1/4), so adding "positive" does not repair the statement. Same mechanism as B05 (Thm 2.8).
- **Which side is at fault**: paper side, ERROR (the gate and drafter had proposed PAPER_ASSUMPTION_GAP; the ruling is ERROR because the natural repair also fails).
- **Evidence**: `pv_work/T03_Counterexample1.lean` (standard axioms only); ruling `verification/audits/T03_issue_1.md`; review `verification/audits/T03_issue_1_audit.md` (COUNTEREXAMPLE VALID); gate `verification/audits/T03_gate.md`. The consumed clause `T03_T01Consumed` is itself refutable, so T03 cannot be CONDITIONAL on it.
- **Affected**: Theorem 4.8 as printed; the inclusion claim at `:107` (reasoning). No numbered result depends on T03.
- **Recorded suggested fix** (reasoning only, not checked in Lean): F_X(0)=0 and F_X(x)>0 for x>0.
- **Needs human check**: ERROR vs PAPER_ASSUMPTION_GAP; relation to B05.
- **Found by / date**: pv-drafter, pv-gate, pv-issue-checker, pv-auditor; 2026-10-13.

## B10 — T03 / 4.8 — PAPER_ARGUMENT_GAP

- **In one sentence**: The proof of Theorem 4.8 asserts "h is increasing convex and h(0)=0" (`:337`), but h(0)=0 is false in general.
- **Source**: `source/SuperParetoPaper-v12.tex:337`.
- **What fails**: for X = Z (Pareto itself, which is ITS) the representing map is h(y)=y+1 with h(0)=1, so the printed step "h(0)=0, hence star-shaped" is false; the gated obligation T03_S3b is refuted in Lean.
- **Which side is at fault**: paper side, PAPER_ARGUMENT_GAP (the conclusion is threatened for the route, see B09).
- **Evidence**: `pv_work/T03_Counterexample2.lean` (standard axioms only); ruling `verification/audits/T03_issue_2.md`; review `verification/audits/T03_issue_2_audit.md` (COUNTEREXAMPLE VALID).
- **Affected**: the route at `:337` of Theorem 4.8.
- **Needs human check**: none beyond B09.
- **Found by / date**: pv-gate, pv-issue-checker, pv-auditor; 2026-10-13.
