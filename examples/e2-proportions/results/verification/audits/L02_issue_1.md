# L02 suspected issue 1: open/closed reading of the unit interval $I$

- Checker: pv-issue-checker (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:08:25 EDT 2026 (from `date`)
- Reported by: pv-drafter (`pv_work/notes/L02_draft_notes.md`) and pv-gate (`verification/audits/L02_gate.md`, focus ruling, item 7)
- Status: ruling complete; NOT confirmed until pv-auditor counterexample review passes

## 1. Source quotations (read directly from `source/main.tex`, whole file read, 90 lines)

- main.tex:24: "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
  The source nowhere states whether $I$ is $[0,1]$ or $(0,1)$.
- main.tex:26-28 (Definition `def:vp`): "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; for $p \in I$ this is the variance of the proportion of successes in $n$ independent trials with success probability $p$."
- main.tex:47-49 (Lemma `lem:positive`): "For every $p \in I$, $V_n(p) > 0$."
- main.tex:51-53 (proof): "For $p \in I$ both $p$ and $1 - p$ are positive, and $n > 0$."
- Other uses of $I$: main.tex:56 and :61 (Prop `prop:concave`, "concave on $I$"), main.tex:66 (Lemma `lem:linear`).
- `lem:positive` is cited by no other result: the only `\ref`s in the source are to `lem:quarter` (main.tex:70, :78).

## 2. Consumed instance

- No downstream result consumes `lem:positive`, so the only thing to judge is the printed clause itself: for all integers $n \ge 1$ and all $p \in I$, $p(1-p)/n > 0$.
- The two candidate readings are `Defs.IOpen = Set.Ioo 0 1` and `Defs.IClosed = Set.Icc 0 1` (`pv_work/Defs.lean:13,16`). The gated statement `L02Claim` (`pv_work/L02Stmt.lean:14`) uses `IOpen`.
- Under the closed reading, the conclusion fails exactly at $p \in \{0,1\}$, where $V_n(0) = V_n(1) = 0$. Everywhere else in $[0,1]$ it holds (Lean, `closed_fails_exactly_at_endpoints`).

## 3. Classification: `DOMAIN_CLARIFICATION`

The two readings and the result under each:

| Reading of $I$ (main.tex:24) | Lemma main.tex:48 | Proof sentence main.tex:52 | Lean |
|---|---|---|---|
| open $(0,1)$ | true | true | `open_holds` (= audited `L02_main`) |
| closed $[0,1]$ | false at $p=0$ and at $p=1$, for every $n\ge1$ | false at $p=0$ | `counterexample`, `counterexample_one`, `proof_sentence_closed_false` |

Why this is `DOMAIN_CLARIFICATION`:
- The defect is that a symbol is under-specified (main.tex:24). The result is true under one reading and false under the other.
- Each reading has textual support:
  - Closed: "the unit interval" conventionally means $[0,1]$. Also, main.tex:27-28 presents $I$ as the range of success probabilities, which ordinarily includes 0 and 1.
  - Open: the proof's own sentence at main.tex:52 asserts "for $p\in I$ both $p$ and $1-p$ are positive". That sentence holds iff $I \subseteq (0,1)$, so the author is evidently working with $(0,1)$ in this lemma.

Why it is not a neighbouring class:
- **Not `ERROR`.** `ERROR` requires the printed conclusion to be false. Here the printed conclusion is false only under one of two readings, and the source's own proof text fixes the other reading for this lemma. Choosing the closed reading would mean our representation manufactures a paper error (POLICY §1).
- **Not `PAPER_ASSUMPTION_GAP`.** Under the open reading no hypothesis is missing. Under the closed reading, the "missing hypothesis" $p\notin\{0,1\}$ is just the open reading again. The defect is what $I$ denotes, not a forgotten assumption.
- **Not `EXPOSITION_GAP`.** Under the open reading no range is left uncovered. Under the closed reading the endpoints are not merely uncovered: the conclusion is false there ($0 > 0$ fails). No constant can absorb that.
- **Not `PAPER_ARGUMENT_GAP`.** Under the open reading the given justification (positive factors, positive denominator) is complete. The prover closed it with the steps as written (`pv_work/L02.lean`).
- **Not `FAIR_IMPLICIT_STEP` / `EDITORIAL`.** The two readings give opposite truth values, so a reader cannot routinely resolve it. It should be recorded.
- **Not formalization side.** Both encodings are verbatim in `Defs.lean`, and neither builds in extra content.

## 4. Does it threaten the conclusion?

- **The result under check (L02, main.tex:47-49): no**, under the reading fixed by the source's own proof (main.tex:52). There the conclusion holds and is Lean-verified (`L02_main`, re-exported as `open_holds`).
- **Under the closed reading, yes.** The printed conclusion is then false at $p\in\{0,1\}$ for every $n\ge1$ (witness $n=1$, $p=0$: $V_1(0)=0$). This is what the coordinator asked about. The verdict line below reflects the source-fixed reading; the closed-reading failure is the reason the issue is recorded.
- **Downstream results.** None are affected, because `lem:positive` is not cited anywhere.
  - Unaffected: `lem:quarter` (main.tex:38-45), `prop:concave` (main.tex:55-63), `lem:linear` (main.tex:65-71), `prop:uniform` (main.tex:73-79) and `prop:sum` (main.tex:81-88).
  - `prop:concave` and `lem:linear` do use the same symbol $I$, so the clarification must be applied consistently to them. Their own truth under each reading is not ruled on here.

## 5. Evidence (Lean)

- File: `pv_work/L02_Counterexample1.lean`, sha256 `8395f348ef8352f58316892f5a1fb3c7d961c864154303c532a2755feeacf449` (`python3 scripts/pv_snapshot.py hash`).
- Build: `scripts/pv_lean.sh build L02_Counterexample1` → `RESULT L02_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L02_Counterexample1_1.log olean=pv_work/L02_Counterexample1.olean`.
- Axioms and walk: probe `pv_work/probes/issue/L02/issue_L02_axioms.lean` → `RESULT issue_L02_axioms mode=probe exit=0 …`, log `pv_work/logs/issue_L02_axioms_1.log`.
  - `#pv_axioms L02_Counterexample1: ALL STANDARD (13 declarations checked)`.
  - `#pv_walk`: axioms in the closure `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false`.
  - `#pv_hyp_usage closed_fails_exactly_at_endpoints`: all 4 binders are USED.
- Declarations:
  - `PrintedClauseClosed := ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, p ∈ IClosed → 0 < V n p`. This is main.tex:48 with main.tex:24's $n\ge1$, word for word, under the closed reading. It has no missing premise and no strengthened conclusion. (vh=616552339)
  - `counterexample : ¬ PrintedClauseClosed`. Instance $n=1$, $p=0$. It satisfies the printed hypotheses $1\le n$ and $p\in[0,1]$ (`zero_mem_closed`), and no definition in the source excludes it: `def:vp` is stated for all $p\in\mathbb{R}$.
  - `counterexample_one`: the same at $p=1$.
  - `ProofSentenceClosed` and `proof_sentence_closed_false`: under the closed reading, main.tex:52 is itself false.
  - `closed_implies_open` (scope lemma, `consumed_of_printed` style): the closed clause implies the open clause. So the refutation hits only the stronger, closed reading and says nothing against the open one.
  - `open_holds : PrintedClauseOpen`. Proved by calling the audited `Paper.L02.L02_main`, with no new argument.
  - `closed_fails_exactly_at_endpoints`: for $n\ge1$ and $p\in[0,1]$, $0<V_n(p) \iff p\in(0,1)$.
- Review points for pv-auditor (VERIFICATION_METHODS §5):
  1. `PrintedClauseClosed` is not stronger than the source.
  2. The instance satisfies every printed hypothesis.
  3. No source definition excludes $p=0$.

## 6. Suggestion to the authors (minimal)

- At main.tex:24, state which interval is meant. Alternatively, write Lemma `lem:positive` (main.tex:48) as "for every $p\in(0,1)$".
- Either change makes the lemma exactly `PrintedClauseOpen`, which is proved (`open_holds`).
- If $I$ is meant to be $[0,1]$ elsewhere (main.tex:27-28, :56, :66), the second option (restrict only `lem:positive`) avoids changing the other results. The effect of a global redefinition on those results is not checked here.

## 7. Side observation (outside this ruling, not checked in Lean, forwarded only)

- While reading the source I noticed something about `lem:linear` (main.tex:66, "$V_n(p) \le p/(4n)$" for $p\in I$). For $p>0$ the claim is equivalent to $1-p \le 1/4$, i.e. $p\ge 3/4$. At $p=1/10$, for example: $p(1-p)=0.09 > 0.025 = p/4$.
- So the claim appears to be false under either reading of $I$. The justification at main.tex:70 ("By Lemma lem:quarter") also does not give it: lem:quarter gives $\le 1/(4n)$, not $\le p/(4n)$.
- Reasoning, not checked in Lean. This is not part of this issue. Recommend that the coordinator dispatch a separate ruling for `lem:linear`.

## 8. Not checked

- The truth of `prop:concave` and `lem:linear` under each reading of $I$ (beyond the side observation in §7).
- Any reading of $I$ other than $[0,1]$ and $(0,1)$ (e.g. half-open). Under a half-open reading the lemma fails at the included endpoint for the same reason ($V_n(0)=V_n(1)=0$). That is reasoning, not checked in Lean.
- Human check needed: **yes**. The authors must say which interval main.tex:24 means, because the conventional default ($[0,1]$) makes this lemma false.

ISSUE VERDICT: DOMAIN_CLARIFICATION
THREATENS CONCLUSION: no
