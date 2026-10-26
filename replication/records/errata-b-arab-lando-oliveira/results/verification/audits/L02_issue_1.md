# L02 issue 1: the "if" direction of Lemma 4.10 (lem:inv-NWU) omits F_X(0)=0

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent
- Status: ruling complete; **not confirmed** until the pv-auditor counterexample review passes
- Date: Tue Oct 13 01:10:36 EDT 2026
- Reported by pv-gate (`verification/audits/L02_gate_r2.md`, line 29) and pv-prover (`pv_work/notes/L02_prover_notes.md`, lines 14-24). Parallel ruling: `verification/audits/L01_issue_1.md` (same defect pattern in Lemma 2.3).

## 1. Source quotations (read directly from `source/SuperParetoPaper-v12.tex`, sha256 88ba28de…b103294)

- F:344-352 (Def 4.9, def:superheavy): "We say that a random variable $X$ such that $F_X(0)=0$ is (1) ... super-heavy-tailed if $-\Log F_X(\frac1x)$ is subadditive; (2) \NWU\ if ..."
- F:354: "... together with being nonnegative. Note that the nonnegativity is not strictly necessary for the above definitions."
- F:358: "The following characterisation is straightforward." (No proof is printed.)
- F:359-365 (Lemma 4.10, lem:inv-NWU): "A random variable $X$ is super-heavy-tailed if and only if
  $F_X(\tfrac{x}{\theta})F_X(\tfrac{x}{1-\theta})\leq F_X(x),\ \forall x\geq0,\,\theta\in(0,1)$."
  The qualifier "such that $F_X(0)=0$" from F:346 is not printed.
- F:442 (Prop cor:fsub, the parallel ITS characterisation) prints "A random variable $X$ such that $F_X(0)=0$ is ...". F:431 (Prop cor:invNWU) does not print it (see §5, lead only).

## 2. What is consumed

- **The lemma as printed** quantifies over every random variable $X$. Its "if" direction reads: (eq:inv-NWU) ⇒ X super-heavy-tailed, which by Def 4.9 means **both** $F_X(0)=0$ **and** subadditivity of $-\Log F_X(1/x)$.
- (eq:inv-NWU) cannot yield $F_X(0)=0$: at $x=0$ it reads $F_X(0)^2\le F_X(0)$, true for every cdf; for $x>0$ it never mentions $F_X(0)$ alone.
- **Instance consumed in the gated statement**: `L02_main` (pv_work/L02Draft.lean:10-11, gate r2 hash th=352959930) is the printed biconditional, `IsSuperHeavyTailed μ ↔ InvNWUCond μ` for every probability measure μ, with no extra hypothesis. The prover stopped the reverse direction at the goal `F μ 0 = 0` (notes line 17).
- **Downstream consumption in the source**: the only later reference to Lemma 4.10 / (eq:inv-NWU) is Ex 4.13 (ex:strange, F:392): "(\ref{eq:inv-NWU}) is not [satisfied], so $R_a$ is not super-heavy-tailed". That is the contrapositive of the **"only if"** direction. Thm 4.12 (F:376-385) argues directly from Def 4.9 and does not cite the lemma. So, unlike L01 (where Thm 2.6 consumed the "if" direction), **no result in the source consumes the defective direction**.

## 3. Evidence (Lean)

File `pv_work/L02_Counterexample1.lean` (namespace `Paper.L02`, `import L02Stmt`; L02Stmt sha256 caf65f96…5256d1f, identical to the gate-reviewed hash in L02_gate_r2.md line 7).

- `PrintedIfClause : Prop := ∀ μ [IsProbabilityMeasure μ], InvNWUCond μ → IsSuperHeavyTailed μ`. This is the printed "if" direction, word for word, over the gate-approved `InvNWUCond` (F:364) and `IsSuperHeavyTailed` (F:346-349). No premise is dropped and nothing is added to the conclusion.
- Instance: μ = `Measure.dirac 0` (X = 0 a.s.).
  - `invNWUCond_dirac_zero`: (eq:inv-NWU) holds (F = 1 on [0,∞), so it reads 1·1 ≤ 1). Every printed hypothesis is satisfied.
  - `subadditive_dirac_zero`: the subadditivity conjunct of Def 4.9(1) **also holds** (−Log F(1/x) = 0 on (0,∞)). So the failure is exactly the omitted conjunct F_X(0)=0, and it does not depend on the `EReal`/`+∞` encoding of `negLogInv` or on the domain chosen for x.
  - `not_superHeavy_dirac_zero`: F(0) = 1 ≠ 0.
- `L02_if_counterexample : ¬ PrintedIfClause`.
- Scope lemmas: `printedIf_of_printedIff` (the printed biconditional implies `PrintedIfClause`); `L02_main_as_printed_false : ¬ (∀ μ [IsProbabilityMeasure μ], IsSuperHeavyTailed μ ↔ InvNWUCond μ)`, i.e. the gated `L02_main`, universally quantified, is refuted; `prover_gap_false`: the prover's `L02_main_Gap` is false, so `L02_main_mod_gaps` is vacuous (as the prover noted).
- Compilation: `scripts/pv_lean.sh build L02_Counterexample1` gave `RESULT L02_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L02_Counterexample1_1.log olean=pv_work/L02_Counterexample1.olean`.
- Axiom check: probe `pv_work/probes/issue/L02/L02_issue1_axioms.lean`, run with `scripts/pv_lean.sh probe …`, gave exit=0. Log `pv_work/logs/L02_issue1_axioms_1.log` line 11: "#pv_axioms L02_Counterexample1: ALL STANDARD (10 declarations checked)"; lines 12-14: `L02_if_counterexample`, `L02_main_as_printed_false` and `prover_gap_false` depend on [propext, Classical.choice, Quot.sound] only.
- Hashes (sha256): `L02_Counterexample1.lean` a13f445eb2837cc6516105ed526f95d2aad22a80a3bf9e66762964273c8d0d1c; `L02_Counterexample1.olean` e4f7e1b1aaabeecd87e75f2776fb7a218a77043e0369aeee6882cd0094599f51; probe f802cd1e6a327b949b8667d84822c9e20de92fdff7466ae9d8ebba07a62330c4.
- Non-degenerate instances (reasoning, not checked in Lean): (a) any law supported in (−∞,0], e.g. δ_{−1}, works identically. (b) The mixture F = p + (1−p)G on [0,∞), p ∈ (0,1), G a super-heavy-tailed cdf with G(0)=0 (e.g. Fréchet G(x)=e^{−1/x}, where −Log G(1/x) = x is additive). With q = 1−p, a = G(x/θ), b = G(x/(1−θ)), c = G(x) ≥ ab, one gets (p+qa)(p+qb) ≤ p + qc ⇐ p(a+b−1)q ≤ pq·ab ⇔ (1−a)(1−b) ≥ 0. So (eq:inv-NWU) holds while F(0) = p > 0. The failure is not restricted to degenerate laws.

## 4. Classification

**PAPER_ASSUMPTION_GAP.** Missing hypothesis: "such that $F_X(0)=0$" in Lemma 4.10 (F:361).

- Not FAIR_IMPLICIT_STEP or ENCODING_ERROR: F_X(0)=0 cannot be derived from (eq:inv-NWU) (Lean counterexample). The encoding of Def 4.9 includes its printed presupposition F:346 literally, and the counterexample also satisfies the subadditivity conjunct, so no representation choice (EReal, domain (0,∞), Lean `1/0=0`) manufactures the failure.
- Not ERROR (borderline, stated openly): the counterexample meets the ERROR evidence standard for the clause as printed, but the defect is one omitted qualifier that the paper's own definition (F:346) states, and the substantive equivalence (subadditivity of −Log F(1/x) ⇔ (eq:inv-NWU)) is correct (gate S1, S3; proved by the prover in L02ModGaps). VERDICTS §2 places "a hypothesis not printed, with an example showing the step fails without it" under PAPER_ASSUMPTION_GAP. This matches the L01 ruling.
- Not DOMAIN_CLARIFICATION (the closest neighbour; weaker here than in L01): reading F:346's "X such that F_X(0)=0" as a standing restriction for the subsection makes the lemma true. Arguments against: (i) F:354 explicitly disclaims a nonnegativity convention; (ii) at F:442 the paper prints the qualifier when it intends it for the parallel characterisation; (iii) the lemma opens with "A random variable $X$", a fresh universal quantifier. Unlike L01, no downstream use forces the broad reading (§2), so a human may reasonably prefer DOMAIN_CLARIFICATION; flagged for human check (§8).
- Not EXPOSITION_GAP: the conclusion is false on the uncovered case, and no constant can absorb it.
- Not PAPER_ARGUMENT_GAP: no argument is printed ("straightforward", F:358); the problem is the statement's hypothesis set.

## 5. Does it threaten the conclusion?

- **L02 as printed: yes.** The "if" direction, hence the printed biconditional, is false (Lean: `L02_main_as_printed_false`). The "only if" direction (super-heavy-tailed ⇒ (eq:inv-NWU)) and the equivalence for laws with F_X(0)=0 are not affected; the prover's notes record the forward direction proved (S1+S2) and S3 proved.
- **Downstream: not affected.**
  - Ex 4.13 (ex:strange, F:392) uses only the "only if" direction (contrapositive). Unaffected.
  - Thm 4.12 (thm:inv-nwu-fsub, F:376-385) does not cite Lemma 4.10. Unaffected by this issue (its own proof to be checked by its own pipeline).
  - Thm 4.11 (thn:ChenShneer, F:370-373), Prop cor:invNWU (F:429-436), Prop cor:fsub (F:442): do not cite Lemma 4.10. Unaffected by this issue.
  - Lead only, not ruled here: Prop cor:invNWU (F:431) also says "A random variable $X$ is super-heavy-tailed iff $F_X\le_{i-sb}\mathcal H$" without the qualifier; whether ≤_{i-sb} forces F_X(0)=0 depends on the encoding of F_1^- and the remark at F:426 ("rules out distributions whose supports strictly include the origin"). Its own gate should check this.

## 6. Suggestion to the authors (minimal)

Replace "A random variable $X$ is super-heavy-tailed if and only if" at F:361 with "A random variable $X$ such that $F_X(0)=0$ is super-heavy-tailed if and only if", mirroring F:442. Sufficiency check: under F_X(0)=0 the definition reduces to the subadditivity conjunct, and the equivalence with (eq:inv-NWU) is the gate's S1/S3 (S1, S3 compiled in `pv_work/L02ModGaps.lean` per the prover notes; S2 covers x = 0 using F(0)=0). So the fix suffices for L02. No downstream result needs a further fix.

## 7. Not checked

- The corrected lemma is not assembled in Lean here (prover's job; S1-S3 are reported proved in L02ModGaps, not re-audited by me).
- The non-degenerate instances in §3 are reasoning, not checked in Lean.
- The cor:invNWU lead (§5) is not ruled.

## 8. Needs human check

Yes, briefly: whether the authors intended F:346's "such that F_X(0)=0" as a standing convention for subsection 4.2 (which would make this DOMAIN_CLARIFICATION). Evidence against: F:354, F:442, and the fresh quantifier at F:361.

ISSUE VERDICT: PAPER_ASSUMPTION_GAP
THREATENS CONCLUSION: yes
