# L03 issue 1: Lemma `lem:linear` (main.tex:65-71), ruling by pv-issue-checker

- Date: 2026-10-12 22:22:24 EDT
- Reported by: pv-gate (`verification/audits/L03_gate.md`, item on S2; probe `pv_work/probes/gate/L03/gate_L03_truth.lean`)
- Status: **ruling by the issue checker. NOT yet confirmed.** It needs a pv-auditor counterexample review.

## 1. Source text (read directly)

- main.tex:24: "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval." (Open or closed is not stated.)
- main.tex:27 (Definition `def:vp`): "$V_n(p) = p(1-p)/n$".
- main.tex:39 (Lemma `lem:quarter`, cited result L01): "For every $p \in \mathbb{R}$, $p(1-p) = \frac14 - (p - \frac12)^2$. In particular $V_n(p) \le \frac{1}{4n}$."
- main.tex:66 (statement of L03): "For every $p \in I$, $V_n(p) \le \frac{p}{4n}$."
- main.tex:70 (the entire proof): "By Lemma~\ref{lem:quarter}, $V_n(p) = \frac{p(1-p)}{n} \le \frac{p}{4n}$."

## 2. Consumed instance

L03 has no downstream consumer in the paper (INVENTORY.md:17,21: L03 sits at dependency level 1, and no result cites `lem:linear`). So the clause that matters is the printed general clause itself. Counterexample instance: $n = 1$, $p = 1/10$. This instance is in $(0,1)$ and in $[0,1]$, so it satisfies every printed hypothesis under both readings of $I$.

$V_1(1/10) = 9/100 = 0.09$, while $p/(4n) = 1/40 = 0.025$, and $0.09 > 0.025$.

## 3. Classification

**Primary: `ERROR`**, because the printed conclusion main.tex:66 is false.
- It fails under the open reading `I = (0,1)`, which is the gated reading (`L03Stmt.lean:16`), and also under the closed reading `I = [0,1]`. The same witness works for both.
- It fails for **every** $n \ge 1$ at $p = 1/10$ (`fails_every_n`). So no reading of $n$ rescues it.
- The failure set is large. On $(0,1)$ the inequality holds iff $p \ge 3/4$ (`open_iff`), so it fails on all of $(0, 3/4)$. This is the reviewer's computation and is used only to describe the scope of the failure.

**Secondary, subsumed: the step main.tex:70 is also a `PAPER_ARGUMENT_GAP`.**
- The cited Lemma L01 gives $p(1-p) \le 1/4$, so $V_n(p) \le 1/(4n)$.
- To pass from $1/(4n)$ to $p/(4n)$ one would need $1 \le p$, which is false on $I$ apart from $p = 1$ in the closed reading.
- `step_fails_with_L01` shows this directly: at the witness, L01's full conclusion holds (from the audited `L01_main`) and $p \in I$ holds, yet the step's inequality fails.
- Because the target conclusion itself is false, the issue is recorded as `ERROR`. The argument-gap aspect is noted, not counted separately.

Why the neighbouring classes do not apply:
- **Not `PAPER_ARGUMENT_GAP` as primary.** That class requires that the conclusion may still be true. Here the conclusion is refuted outright.
- **Not `DOMAIN_CLARIFICATION`.** The open/closed ambiguity of $I$ (already L02 issue 1) is irrelevant here. The clause fails under both readings, and `closed_implies_open` shows that refuting the open clause is the weaker, safe direction.
- **Not `PAPER_ASSUMPTION_GAP`.** A missing hypothesis on $n$ cannot help, because the failure holds for every $n \ge 1$. Restricting to $p \ge 3/4$ would be a substantive change of the lemma, not an omitted standing assumption.
- **Not `EXPOSITION_GAP`.** The failure is not a boundary range that constants could absorb. It covers the open set $(0, 3/4)$, and there is no constant in the statement.
- **Not `ENCODING_ERROR`.**
  - `V` (Defs.lean:21) is main.tex:27 verbatim.
  - `PrintedClauseOpen`/`PrintedClauseClosed` are main.tex:66 verbatim, with $n \ge 1$ from main.tex:24.
  - `gated_eq_printed` (`Iff.rfl`) shows that the gated statement is the printed open clause.
  - The witness is plain rational arithmetic, with no casts or truncation involved ($n$ is cast to ℝ; the division is real).
- **Not `FAIR_IMPLICIT_STEP`.** No routine filling exists, because the target is false.

## 4. Does it threaten the conclusion?

- **The result under check (L03): yes.** The printed conclusion of Lemma `lem:linear` is false.
- **Downstream: none affected.** No numbered result uses L03 (INVENTORY.md:17,21).

Unaffected results:
- L01 (`lem:quarter`), which is the cited lemma; it is correct and audited. This issue does not touch it.
- L02, P01 (`prop:concave`), P02 (`prop:uniform`; it uses L01, not L03) and P03 (`prop:sum`). Each has its own issues or verdicts, independent of this one.

## 5. Evidence (Lean)

- File `pv_work/L03_Counterexample1.lean` (sha256 `584c6d2ac4a2f4e3ef6c224153813703679d39f7f77cb2badba6da18f242a440`). It imports Defs, L01 and L03Stmt.
  - `PrintedClauseOpen`, `PrintedClauseClosed`: main.tex:66 encoded verbatim under each reading of $I$.
  - `counterexample_open : ¬ PrintedClauseOpen` and `counterexample_closed : ¬ PrintedClauseClosed`, witness $n=1$, $p=1/10$.
  - `gated_eq_printed`, `gated_statement_false : ¬ (∀ n, 1 ≤ n → ∀ p, L03Claim n p)`, which refutes the gated statement.
  - `closed_implies_open`: scope lemma.
  - `step_fails_with_L01`: L01 holds at the witness and the step at main.tex:70 fails there.
  - `fails_every_n`: for every $n \ge 1$, $p = 1/10$ fails.
  - `open_iff`: on $(0,1)$, the inequality holds iff $3/4 \le p$. Describes scope only.
- Compilation: `scripts/pv_lean.sh build L03_Counterexample1` gave `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/L03_Counterexample1_1.log`, olean `pv_work/L03_Counterexample1.olean`.
- Axiom check: probe `pv_work/probes/issue/L03/issue_L03_axioms.lean`, run as `scripts/pv_lean.sh probe …`, gave exit=0, log `pv_work/logs/issue_L03_axioms_1.log`:
  - `#pv_axioms L03_Counterexample1: ALL STANDARD (13 declarations checked)`
  - `#pv_walk`: `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`
  - `#pv_hyp_usage`: all binders USED in `fails_every_n` and `open_iff`.
- Independent corroboration: the gate's own probe `gate_L03_truth.lean` (`main_false_as_stated`, `S2_false_as_stated`) reaches the same result. It was written by a different role.

## 6. Suggestion to the authors (minimal)

These suggestions were constructed by the reviewer. They are not in the source, are suggestions only, and are not used in any verification.
- (a) Probably intended: replace $\frac{p}{4n}$ by $\frac{p}{n}$. The bound $V_n(p) \le p/n$ holds since $p(1-p) \le p \iff p^2 \ge 0$, which is true for every real $p$. However, the proof must then cite this elementary fact, not Lemma `lem:quarter`, because L01 does not yield it. Checked by hand only (reasoning, not checked in Lean).
- (b) Alternatively, keep $\frac{p}{4n}$ but restrict to $p \in [3/4, 1]$, as `open_iff` shows for the open part. The justification at main.tex:70 would still need replacing, because L01 alone does not give it.
- (c) Or delete the lemma. Nothing in the paper uses it.

## 7. Not checked

- Fix (a) is not checked in Lean.
- Which bound the authors intended is not determinable from the source.
- Nothing else is open.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes
