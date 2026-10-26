# L02 statement gate (Lemma `lem:positive`)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:54:57 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean` 3af409f67c3e4629496e6d41a50c71e653dcb611c6ae63a24970eb6ee68cf1b7
  - `pv_work/L02Draft.lean` a611b9e2896c2a197dae4de7ac9a75721e026a2f79a59a4ff923eeafc5add827
  - `pv_work/Defs.lean` (imported) 0259b9aa4c03c2e64066ab3240783bfdbb600dc04c0b6182dccc0d6a1e831b67
- Compilation: `scripts/pv_lean.sh check L02Draft` -> `exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_2.log olean=none` (3 sorries expected in a draft: S1, S2, main).
- Drafter notes `pv_work/notes/L02_draft_notes.md` read as leads only; every ruling below is from the source text.

## Source quotations (read directly)

- main.tex:24: "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
- main.tex:26-28 (Def `def:vp`): "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; for $p \in I$ this is the variance of the proportion of successes in $n$ independent trials with success probability $p$."
- main.tex:47-49 (Lemma `lem:positive`): "For every $p \in I$, $V_n(p) > 0$."
- main.tex:51-53 (proof): "For $p \in I$ both $p$ and $1 - p$ are positive, and $n > 0$."
- Other uses of $I$: main.tex:56, 61 (Prop `prop:concave`, "concave on $I$"), main.tex:66 (Lemma `lem:linear`).

## Lean encoding reviewed

- `Defs.IOpen := Set.Ioo 0 1`, `Defs.IClosed := Set.Icc 0 1`, `Defs.V n p := p * (1 - p) / (n : ℝ)` (no hidden hypotheses; plain defs, no structures/classes/variables).
- `L02Claim n p := p ∈ IOpen → 0 < V n p`.
- `L02_main (n : ℕ) (hn : 1 ≤ n) (p : ℝ) : L02Claim n p`.
- `L02_S1 (p) (hp : p ∈ IOpen) : 0 < p ∧ 0 < 1 - p`; `L02_S2 (n) (hn : 1 ≤ n) : (0:ℝ) < n`.

## Focus ruling: reading of $I$

1. The source never says whether "the unit interval" is open or closed (main.tex:24). The usual default meaning of "the unit interval" is $[0,1]$, and main.tex:27-28 (variance for success probability $p$) is naturally read with $p\in[0,1]$ allowed. Under the closed reading the lemma is false: $V_n(0) = V_n(1) = 0$ for every $n \ge 1$.
2. The paper's own proof (main.tex:52) states "For $p \in I$ both $p$ and $1-p$ are positive". That holds exactly when $I \subseteq (0,1)$. So the author's proof uses $I = (0,1)$. Reading $I$ as open adopts the source's own stated property of $I$. It does not repair the proof or add a premise the source lacks.
3. Under POLICY §1, our representation choices must not manufacture a paper error. Of the two readings, only the open one makes both the statement and the printed proof coherent. **Ruling: `IOpen` is the faithful choice for L02. Item PASS.**
4. The ambiguity is still real and must be recorded, not hidden. The paper uses one symbol $I$ throughout. Elsewhere the natural reading is closed (main.tex:27-28), and L02 is false under it. **Preliminary classification: `DOMAIN_CLARIFICATION`** (main.tex:24, $I$ undefined as open/closed). Under the closed reading it would be an `ERROR` at $p\in\{0,1\}$. That alternative should be stated in the issue file with the explicit witness $p=0$, $n=1$, $V_1(0)=0$. It should not be the gate's ruling, because the source's own proof fixes the open reading for this lemma. Recommend that the coordinator dispatch `pv-issue-checker`. It should rule on the final class and may build the Lean counterexample for the `IClosed` variant.
5. Consistency note for the coordinator (not a change to L02): later results that use $I$ (main.tex:55-63, 65-71) must each state which reading they use. If they use `IClosed`, the paper is using one symbol with two meanings, and the DOMAIN_CLARIFICATION record should cite that too. The L02 open reading must not be carried over silently to results where the closed reading is the stronger, still-true statement.

## Item-by-item rulings

1. **Hypotheses: PASS.** $n \ge 1$ (main.tex:24) is `hn : 1 ≤ n`. $p \in I$ is `p ∈ IOpen` (see the focus ruling). $p \in \mathbb{R}$ is `p : ℝ`. There are no extra premises, and the conclusion is not used as a hypothesis. Defs has no hidden hypotheses.
2. **Conclusion: PASS.** The conclusion $V_n(p) > 0$ is `0 < V n p`, with no weakening, no strengthening and no missing clause.
3. **Quantifiers: PASS.** The statement holds for all $n \ge 1$ and all $p$, as in the source. There are no constants.
4. **Domains and details: PASS.** `n : ℕ` is cast to ℝ, and division by `(n:ℝ)` is safe since `hn`. Real-valued, no `ENNReal`/`toReal` traps. No measurability, finiteness or existence aspects. The open/closed question is handled in the focus ruling.
5. **Step obligations: PASS.**
   - S1 corresponds to main.tex:52 "both $p$ and $1-p$ are positive". It is true for `p ∈ Set.Ioo 0 1` and does not smuggle in the conclusion.
   - S2 corresponds to main.tex:52 "$n > 0$" together with main.tex:24. It is true.
   - Assembly: $p(1-p)/n > 0$ follows from the positivity of the factors and the denominator (FAIR_IMPLICIT_STEP). S1 and S2 together yield `L02_main`.
   - No obligation is false as stated.
6. **External parameters: PASS (none).** There are no `def … : Prop` tools, no consumed clauses and no predecessors. Namespace `Paper.L02`, no redeclared names.
7. **Doubts about the source: recorded.** main.tex:24 / 47-49 is ambiguous about the domain of $I$. Preliminary class `DOMAIN_CLARIFICATION`; the closed reading gives an `ERROR` alternative. Dispatch `pv-issue-checker`. The gate does not rule on paper correctness and the statement was not altered to rescue the proof.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | - | no extra premises proposed |

Representation choice (not a TFA): `I := IOpen` for L02. Approved for the reasons above, conditional on the ambiguity being recorded as a suspected issue.

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | - |

## Required changes

None to the Lean files. Process requirement for the coordinator: record the suspected issue (main.tex:24 / 47-49, DOMAIN_CLARIFICATION, preliminary) and dispatch `pv-issue-checker`. Do not report L02 as clean UNCONDITIONAL without mentioning the domain ambiguity.

## Statement snapshot

Copies: `pv_work/probes/gate/L02/gate_L02_stmtcopy.lean` (probe exit=0, sorry_warnings=0, log `pv_work/logs/gate_L02_stmtcopy_1.log`), `pv_work/probes/gate/L02/gate_L02_draftcopy.lean` (probe exit=0, sorry_warnings=3, log `pv_work/logs/gate_L02_draftcopy_1.log`).

`L02Stmt` copy:
```
TYPE HASHES (current file, 1 declarations)
Paper.L02.L02Claim|def|th=1224325432|vh=145004741|bi=ee
EXIT=0
```

`L02Draft` copy:
```
TYPE HASHES (current file, 3 declarations)
Paper.L02.L02_S1|thm|th=618443327|vh=-|bi=ee
Paper.L02.L02_S2|thm|th=3284042729|vh=-|bi=ee
Paper.L02.L02_main|thm|th=2541145649|vh=-|bi=eee
EXIT=0
```

## Overall verdict

The statement is faithful to the source under the open reading of $I$, which the source's own proof fixes. There are no TFAs and no external parameters. The domain ambiguity is forwarded as a suspected issue (preliminary DOMAIN_CLARIFICATION).

STATEMENT GATE: PASS
