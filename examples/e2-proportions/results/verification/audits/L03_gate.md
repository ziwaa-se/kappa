# L03 statement gate (Lemma `lem:linear`, main.tex:65-71)

- Reviewer: pv-gate (independent subagent; not the drafter)
- Date: Mon Oct 12 22:18:05 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L03Stmt.lean` bea10783a5e926fbdad8ee3306654866f6a85922890dfa77d1b907f8ad71d3c0
  - `pv_work/L03Draft.lean` 7f8e97bab841c1303f133980bd081b7785003b97349f1787d8c77f66acffb15d
  - `pv_work/Defs.lean` 0259b9aa4c03c2e64066ab3240783bfdbb600dc04c0b6182dccc0d6a1e831b67
  - `pv_work/L01Stmt.lean` 3358dd01871d88e1ffaca81c5075a85cd4bb4a50ac11f5e083f5ed953ff46163
  - `pv_work/L01.lean` 2de3dbc04370c09a82be20d74fe688a38ef03b3a89a5804f671ae44a4061c44b
  - `source/main.tex` e1df515bce180ec4157cef2cf4b13feca7710c98bb24e684de4e2ea724667cb8
- Compilation: `scripts/pv_lean.sh check L03Draft` gives `exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0`. Log: `pv_work/logs/L03Draft_2.log`. `L03Stmt.olean` (22:16:47) is newer than `L03Stmt.lean` (22:16:13).
- Probes (`pv_work/probes/gate/L03/`): `gate_L03_stmtcopy.lean` (exit 0), `gate_L03_draftcopy.lean` (exit 0, 2 sorry warnings), `gate_L03_truth.lean` (exit 0, 0 sorry; log `pv_work/logs/gate_L03_truth_1.log`).

## Source quotations (read directly)

- main.tex:24: "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
- main.tex:26-29 (Definition `def:vp`): "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; for $p \in I$ this is the variance of the proportion of successes in $n$ independent trials with success probability $p$."
- main.tex:38-39 (Lemma `lem:quarter`, cited): "For every $p \in \mathbb{R}$, $p(1-p) = \frac14 - (p - \frac12)^2$. In particular $V_n(p) \le \frac{1}{4n}$."
- main.tex:65-67 (Lemma `lem:linear`): "For every $p \in I$, $V_n(p) \le \frac{p}{4n}$."
- main.tex:69-71 (proof): "By Lemma~\ref{lem:quarter}, $V_n(p) = \frac{p(1-p)}{n} \le \frac{p}{4n}$."

## Lean under review

- `Defs.IOpen := Set.Ioo 0 1`; `Defs.V n p := p * (1 - p) / (n : ℝ)` (plain defs, no hidden hypotheses, no structures/classes/variables).
- `L03Claim n p := p ∈ IOpen → V n p ≤ p / (4 * (n : ℝ))` (L03Stmt.lean:16).
- `L03_S1 (n) (hn : 1 ≤ n) (p) : Paper.L01.Conclusion n p := Paper.L01.L01_main n hn p` (Draft:10-11, already proved).
- `L03_S2 (n) (hn : 1 ≤ n) (p) (hp : p ∈ IOpen) (h : Paper.L01.Conclusion n p) : p * (1 - p) / (n : ℝ) ≤ p / (4 * (n : ℝ))` (Draft:17-19, sorry).
- `L03_main (n) (hn : 1 ≤ n) (p) : L03Claim n p` (Draft:22-23, sorry).

## Reading of $I$ (focus item)

The source never says whether $I$ is open or closed (main.tex:24). L02's gate fixed IOpen for L02 from its own proof sentence (main.tex:52). It also asked that later results not carry the open reading over silently when the closed reading is the stronger, still-true statement (L02_gate.md item 5).

For L03:
- IOpen ⊆ IClosed, so the open-reading claim is the weaker of the two. At the endpoints the closed reading adds only $V_n(0)=0\le 0$ and $V_n(1)=0\le 1/(4n)$, which are true. Neither reading is "stronger and still true": the interior failure (below) is common to both.
- The proof (main.tex:70) uses no property of $I$ at all, so the proof text does not fix a reading here.
- Choosing the open (weaker) reading cannot manufacture a paper error: any refutation of the open reading also refutes the closed one. This is the conservative choice under POLICY §1.

**Ruling: IOpen is acceptable for L03. It is consistent with L02. The ambiguity is already recorded as L02 issue 1 (DOMAIN_CLARIFICATION), and L03 adds nothing new to it.** The drafter recorded the choice in L03Stmt.lean:5-7 and in the notes.

## Item rulings

1. **Hypotheses: PASS.** $n\ge1$ (main.tex:24) becomes `hn : 1 ≤ n` on `L03_main`. "$p\in I$" becomes the antecedent `p ∈ IOpen` inside `L03Claim`. $p\in\mathbb{R}$ becomes `p : ℝ`. There are no extra premises, and nothing is hidden in Defs or in imports. The conclusion is not assumed: S2's hypothesis `h : L01.Conclusion n p` is the cited Lemma quarter (true for all $p$, proved in L01), not the target.
2. **Conclusion: PASS.** `V n p ≤ p / (4 * (n:ℝ))` is exactly $V_n(p)\le p/(4n)$. It is not weakened or strengthened, and no clause is missing.
3. **Quantifiers / constants: PASS.** The statement is pointwise "for every $p\in I$" with $n$ given by the global convention, which matches `∀ n, 1 ≤ n → ∀ p, L03Claim n p`. No constants are chosen.
4. **Domains and details: PASS.** Everything is real-valued. `n : ℕ` is cast to ℝ, with `hn` guarding the division. There are no ENNReal/toReal traps, and no measurability, finiteness or existence aspects. The open/closed question is ruled above.
5. **Step obligations: PASS (fidelity); S2 is FALSE AS STATED, which mirrors the source).**
   - S1 corresponds to main.tex:70 "By Lemma~\ref{lem:quarter}". It invokes the proved `L01_main`, which is true.
   - S2 corresponds to main.tex:70 "$\frac{p(1-p)}{n} \le \frac{p}{4n}$". It carries exactly the context available at that point ($n\ge1$, $p\in I$, and the cited lemma's conclusion), with no added premise and no repair. The first equality "$V_n(p)=p(1-p)/n$" is definitional (`Defs.V`) and needs no obligation.
   - **S2 is false as stated.** Lean proof `S2_false_as_stated` in `gate_L03_truth.lean`: witness $n=1$, $p=1/10\in(0,1)$, with `L01.Conclusion 1 (1/10)` supplied by `L01_main`. Here $0.09 > 0.025$. The obligation is not missing a premise the source states. It is false because the source step is false (for $p\in(0,1)$, $p(1-p)\le p/4 \iff p\ge 3/4$). This is the expected faithful encoding of the suspected paper issue. It is not an encoding defect.
   - S2 does not smuggle in the conclusion or a stronger intermediate claim. After unfolding `V` it is the target inequality itself, which is how the source writes the step.
   - Assembly: `assembly` in `gate_L03_truth.lean` derives `∀ n, 1 ≤ n → ∀ p, L03Claim n p` from S1 (`L01_main`) and S2 as stated. It compiles.
   - `main_false_as_stated` (same probe) shows the printed main claim is false at $n=1$, $p=1/10$ under IOpen, and hence also under IClosed.
6. **External parameters: PASS (none).** There is no `def … : Prop` tool and no consumed clause. The predecessor L01 is imported as a proved module (`pv_work/L01.lean`, final audit `L01_final.md`), not as a (p) parameter.
7. **Doubts about the source: recorded, not ruled.** main.tex:70 (and the statement at main.tex:66): the cited Lemma quarter gives only $V_n(p)\le 1/(4n)$, and the step to $p/(4n)$ fails for every $p\in(0,3/4)$. Under both readings of $I$ the printed conclusion appears false, e.g. at $n=1$, $p=1/10$. Preliminary class: **`ERROR`** (printed conclusion false), with `PAPER_ARGUMENT_GAP` for the proof step as a component. Recommend that the coordinator dispatch `pv-issue-checker` for the binding classification and counterexample file. The gate has not altered the statement to rescue the proof.

## TFAs ruled

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premises. `I := IOpen` is a representation choice, approved above (not a TFA). |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

`pv_work/probes/gate/L03/gate_L03_stmtcopy.lean` (log `pv_work/logs/gate_L03_stmtcopy_1.log`):

```
TYPE HASHES (current file, 1 declarations)
Paper.L03.L03Claim|def|th=1224325432|vh=2238774786|bi=ee
EXIT=0
```

`pv_work/probes/gate/L03/gate_L03_draftcopy.lean` (log `pv_work/logs/gate_L03_draftcopy_1.log`):

```
TYPE HASHES (current file, 3 declarations)
Paper.L03.L03_S1|thm|th=534035779|vh=-|bi=eee
Paper.L03.L03_S2|thm|th=757243603|vh=-|bi=eeeee
Paper.L03.L03_main|thm|th=4183471981|vh=-|bi=eee
EXIT=0
```

## Overall

The statement and step obligations faithfully encode main.tex:65-71 under the open reading of $I$, and that reading cannot manufacture an error here. S2 and the main claim are false as stated (Lean-checked witness $n=1$, $p=1/10$). This mirrors a suspected paper ERROR, which goes to pv-issue-checker. It is not a gate defect.

STATEMENT GATE: PASS
