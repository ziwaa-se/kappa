# P03 statement gate (Proposition 3.3, prop:mean-fsub)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Tue Oct 13 01:39:52 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P03Stmt.lean` a35ef3be4b2a2e58166e8b4ecf34c130c33618baa6b1a9f884adb3228d2ef0d6
  - `pv_work/P03Draft.lean` 8b38bba669fce0756a51616879585292d64872c37fa6bc2370eb16a17b5513c6
  - `pv_work/notes/P03_draft_notes.md` f909fdd11ec758aca541886e05c0fc211d0bd64cbd7d00d09464760c9a9c2ac7 (leads only)
- Also read: `pv_work/T02Stmt.lean`, `pv_work/P02Stmt.lean`, `pv_work/L01Stmt.lean`, the signatures of `T02_main` (`pv_work/T02.lean:135-140`) and `P02_main` (`pv_work/P02.lean:12-20`), `verification/audits/T02_issue_1.md` (ruling lines).
- Compilation: `scripts/pv_lean.sh check P03Draft` → `exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0`, log `pv_work/logs/P03Draft_2.log`.

## Source quotations

- Statement, `source/SuperParetoPaper-v12.tex:270-273`: "If $X$ is \ITS, then $\Mexp X$ is infinite."
- Proof, :269: "As a consequence of Theorem~\ref{thm:main} and Proposition~\ref{prop:inf-mean}, the following result is immediate."
- Theorem 3.1, :186-189: "If $X$ is \ITS, then the stochastic dominance (eq:main-st) holds." (eq:main-st), :95-99: $n$ i.i.d. copies, weights $\theta_i\ge0$ summing to 1, $X\leqst\theta_1X_1+\dots+\theta_nX_n$. The $n=2$ case is proved separately at :191-217.
- Proposition 3.2, :262-264: "Let $X_1,\ldots,X_n$ be independent random variables such that $\Prob(X_1=\cdots=X_n)<1$, and $\theta_1,\ldots,\theta_n>0$ such that $\theta_1+\cdots+\theta_n=1$. If (eq:main-st) holds, then $X$ has infinite mean."
- Def 2.1, :115-118 (stochastic dominance via survival functions, all $x\in\mathbb R$). Def 2.2, :122-125 (ITS requires $F_X(0)=0$; $F^-_{1/X}$ subadditive).

## Item rulings

1. **Hypotheses — PASS.** `IsInvSub (μ.map X)` encodes Def 2.2 (including $F_X(0)=0$), shared with T02/L01. `Measurable X` and a probability space are the standard meaning of "random variable"; not a TFA. No hidden hypotheses in structures/classes/variables (`IIDCopies` is used only inside obligations/clauses, not as a hypothesis of `P03_main`). No goal-shaped hypothesis. `hL01`, `hT02`, `hP02` are (p) parameters (item 6).
2. **Conclusion — PASS.** `InfiniteMean μ X = ¬Integrable X μ`. Because `IsInvSub` gives $F_X(0)=0$, $X>0$ a.s. (S3), so for measurable $X$ this is exactly $\Mexp X=\infty$. Neither weakened nor strengthened. Restriction to real-valued $X$ (Example 2.7 has mass at $+\infty$, where the conclusion is trivial) narrows the encoded scope; this is a recorded encoding choice (INVENTORY X14), acceptable and to be stated in the final verdict scope.
3. **Quantifiers / constants — PASS.** No constants; all objects universally quantified as in the source. `Ω : Type` (universe 0) in the main theorem and in both clauses, consistent with `T02_main`/`P02_main`; the product space `Ω × Ω : Type` stays in that universe.
4. **Domains and details — PASS.** Def 2.1 over all real $x$ in both `StDom`s; `cdf` of `μ.map X` is meaningful since `hX` makes it a probability measure; no `ENNReal.ofReal`/`toReal` trap (`StDom` compares `ℝ≥0∞` measures directly, like the source's survival functions). Existence of i.i.d. copies is constructed (S1), not assumed.
5. **Step obligations — PASS.** Each checked for truth as stated:
   - S1 (IID copies on `μ.prod μ`): true (coordinates of a product of probability measures are independent with law `μ.map X`). Source silent; fair implicit step (standard enlargement), no new mathematics.
   - S2 (nondegeneracy $\mu\otimes\mu(X\circ\mathrm{fst}=X\circ\mathrm{snd})<1$): true as stated. Reason (mine): if $X=c$ a.s., $F_X(0)=0$ forces $c>0$, and $v(y)=1-F_X(1/y)=\mathbf 1_{y>1/c}$ violates subadditivity at $x=y\in(1/(2c),1/c]$; a non-Dirac law gives $P(X_1=X_2)=\sum_a p_a^2<1$. Not justified in the source; correctly left as an obligation, not filled in. Preliminary class below (item 7).
   - S3 ($X>0$ a.s.): true from $F_X(0)=\mu(X\le0)=0$. It is not consumed by the chain (P02's clause has no nonnegativity premise); it documents the reading of "infinite mean". Harmless.
   - S4 (dominance for the S1 copies): true given `hL01`, `hT02` (needs law of `X∘fst` under `μ.prod μ` equals `μ.map X`, a provable encoding step). Labelled correctly with "consequence of Theorem 3.1".
   - S5 (`T02.StDom ↔ P02.StDom`): true, both bodies are identical (`Iff.rfl` level). Encoding only.
   - S6: true given the clauses and S1, S2, S4, S5 (the `if`-inside vs `if`-outside forms differ only by `apply_ite`).
   - S7: true (`fst` is measure preserving from `μ.prod μ` to `μ` for probability `μ`; integrability depends only on the law).
   - No obligation smuggles the target: none states `InfiniteMean μ X` except S7, whose hypothesis is the product-space version (not equivalent "for free"; it is the transfer step). Assembly S1→S4(+S5)→S6(with S2)→S7 yields `P03_main`.
6. **External parameters — PASS.** See table. Both clauses are **instances** of the predecessor main statements (n=2, θ=(1/2,1/2)): `P03_T02Consumed` is `T02_main` with `hθ : 0 ≤ 1/2`, `hsum : 1/2+1/2=1` discharged and the same `T02_L01Consumed` antecedent; `P03_P02Consumed` is `P02_main` with `0 < 1/2` and the sum discharged, same remaining hypotheses (measurability, `iIndepFun`, `IdentDistrib`, nondegeneracy, dominance). Hence neither is stronger than the source's use. Not goal-shaped (P02's clause concludes infinite mean only from dominance + nondegeneracy, exactly P02's printed content; the InvSub-to-infinite-mean link is not assumed anywhere). Both declared only in `P03Stmt.lean`, namespace `Paper.P03`, named `P03_<Pred>Consumed`; no other `.lean` file declares these names (grep of `pv_work` for location only). `T02_L01Consumed` is reused by name from `T02Stmt`, not redeclared — correct. No "mathlib lacks X" claim is made.
   - Specialisation judgement: the source's "immediate" combination applies Theorem 3.1 and Proposition 3.2 for some common choice of $n$ and positive weights; picking $n=2$, $\theta=1/2$ (which satisfies both P02's $\theta_i>0$ and T02's $\theta_i\ge0$) is a faithful instance and the weakest consumed clauses that support the argument. Accepted.
   - Note (non-blocking): the `T02` clause at $n=2$ rests on the source's base case :191-217, not on the induction step where T02's suspected gap S10b (T02_issue_1, PAPER_ARGUMENT_GAP; Theorem 3.1's conclusion not refuted) lies. The S4 docstring's remark about S10b is therefore over-cautious; the dependency on T02's final verdict stands either way since the clause is located at `T02_main`.
7. **Doubts about the source — recorded, not ruled.** The proof at :269 does not verify P02's hypotheses for an ITS $X$: nondegeneracy $\Prob(X_1=X_2)<1$ (S2), existence of i.i.d. copies (S1/S7), and nonnegativity / finite real values (S3, Ex. 2.7). Preliminary class for S2: `FAIR_IMPLICIT_STEP` or `EXPOSITION_GAP` (the fact is true and short, but nowhere stated); S1/S7/S3: `FAIR_IMPLICIT_STEP`. Recommend the coordinator dispatch `pv-issue-checker` for S2 only if the prover cannot close it along a one-line argument from Def 2.2; I make no ruling.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premise beyond measurability/probability space. |

## External parameters

| Name | Provenance | Location in predecessor | Applicability here | Ruling |
|---|---|---|---|---|
| `Paper.P03.P03_T02Consumed` | (p) T02 | `T02_main` (`pv_work/T02.lean:135`), source :186-189 (n=2 case :191-217) | `IsInvSub (μ.map X)` is P03's hypothesis; copies from S1; law transfer in S4 | Approved |
| `Paper.P03.P03_P02Consumed` | (p) P02 | `P02_main` (`pv_work/P02.lean:12`), source :262-264 | independence/ident. distribution from S1, nondegeneracy from S2, dominance from S4+S5 | Approved |
| `Paper.T02.T02_L01Consumed` (reused) | (p) L01 via T02 | L01 "only if" direction, source :128-135 | antecedent of `P03_T02Consumed` | Approved (reuse, not redeclared) |

## Required changes

None.

## Statement snapshot

Copies: `pv_work/probes/gate/P03/gate_P03_stmtcopy.lean` (log `pv_work/logs/gate_P03_stmtcopy_1.log`, exit=0, 0 sorry) and `pv_work/probes/gate/P03/gate_P03_draftcopy.lean` (log `pv_work/logs/gate_P03_draftcopy_1.log`, exit=0, 8 sorry).

```
TYPE HASHES (current file, 2 declarations)
Paper.P03.P03_P02Consumed|def|th=3944470172|vh=2588172109|bi=
Paper.P03.P03_T02Consumed|def|th=3944470172|vh=1242237423|bi=
EXIT=0
```

```
TYPE HASHES (current file, 8 declarations)
Paper.P03.P03_S1|thm|th=2492840789|vh=-|bi=icecee
Paper.P03.P03_S2|thm|th=3568785231|vh=-|bi=iceceee
Paper.P03.P03_S3|thm|th=3686737044|vh=-|bi=iceceee
Paper.P03.P03_S4|thm|th=3068055133|vh=-|bi=eeiceceee
Paper.P03.P03_S5|thm|th=3773111502|vh=-|bi=iceee
Paper.P03.P03_S6|thm|th=485858279|vh=-|bi=eeeiceceee
Paper.P03.P03_S7|thm|th=2947578998|vh=-|bi=iceceee
Paper.P03.P03_main|thm|th=1014712332|vh=-|bi=eeeiceceee
EXIT=0
```

## Overall verdict

Faithful statement; two (p) clauses are faithful n=2, θ=1/2 instances of the predecessors; unaddressed hypotheses (S1, S2, S3, S7) remain obligations; all obligations true as stated.

STATEMENT GATE: PASS
