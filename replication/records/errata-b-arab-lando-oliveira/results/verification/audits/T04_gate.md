# T04 statement gate (Theorem 4.12, thm:inv-nwu-fsub)

- Reviewer: pv-gate (independent subagent, Claude Opus), first gate round
- Date: Tue Oct 13 01:40:15 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T04Stmt.lean` 707930e6d8070e6f318678c0e06c5d3d473cf4065fd8f005159d936e00216522
  - `pv_work/T04Draft.lean` bcbaf4f0db0077d63496e140ed8d5415695f6382e7d47733e3abf980ab988e94
  - `pv_work/L02Stmt.lean` (imported) caf65f96097f30510613ecbaae09a9c88816a2a2da4b1ac2edc1d2a5b5256d1f
  - `pv_work/L01Stmt.lean` (imported) 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e
  - `pv_work/notes/T04_draft_notes.md` (leads only) f4c27d3c861875300c76e5702853f95902957069b5ae72014d5b83f3c36564f9
- Compilation: `scripts/pv_lean.sh check T04Draft` -> `RESULT T04Draft mode=check exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0 log=pv_work/logs/T04Draft_2.log`. EXIT=0 (6 sorries: main + S1-S5, expected for a draft).

## Source quotations (read directly)

- F:111: "a function $v$ is said to be subadditive if $v(x+y)\leq v(x)+v(y)$, for every $x,y$ in the domain of $v$. The function $v$ is called superadditive if the inequality is reversed."
- F:113: $F_X$, $\Fbar_X=1-F_X$; $F_X^-(x)=\Prob(X<x)$. F:119: random variables and their cdfs are identified.
- F:121: "$F_{\frac1X}^-(x)=1-F_X(\frac1x)$ is generally referred to as the inverted distribution of $X$".
- F:122-125 (Def 2.2): "We say that a random variable $X$ such that $F_X(0)=0$ is \ITS ... if $F_{\frac1X}^-$ is subadditive."
- F:344-349 (Def 4.9(1)): "We say that a random variable $X$ such that $F_X(0)=0$ is ... super-heavy-tailed if $-\Log F_X(\frac1x)$ is subadditive".
- F:356: "Note that, in the general case, $F_X(\frac1x)=1-F_{\frac1X}^-(x)$."
- F:376-379 (Thm 4.12): "If $X$ is super-heavy-tailed, then $X$ is \ITS."
- F:381-385 (proof): "$X$ being super-heavy-tailed means that $\Log(1-F_{\frac1X}^-(x))=\Log F_X(\frac1x)$ is superadditive, that is $\Log F_X(\frac{1}{x+y})\geq\Log F_X(\frac1x)+\Log F_X(\frac1y)$, which implies that $F_X(\tfrac{1}{x+y})\geq\exp(\Log F_X(\tfrac1x)+\Log F_X(\tfrac1y))\geq F_X(\tfrac1x)+F_X(\tfrac1y)-1$, as the exponential is superadditive. Finally, going to the complementary sets, this last inequality is just $\Fbar_X(\frac{1}{x+y})\leq\Fbar_X(\frac1x)+\Fbar_X(\frac1y)$, that is, $\Fbar_X(\frac1x)$ is subadditive, that is, $X$ is \ITS."

## Reused definitions (checked against the source)

- `Paper.L01.IsInvSub μ := F μ 0 = 0 ∧ SubadditiveOn (invDist (F μ)) (Ioi 0)`, `invDist G x = 1 - G (1/x)`: matches F:121-124 (including the qualifier $F_X(0)=0$). Domain (0,∞) gate-approved in L01_gate (equivalent to other readings under F(0)=0).
- `Paper.L02.IsSuperHeavyTailed μ := F μ 0 = 0 ∧ SubadditiveOnE (negLogInv μ) (Ioi 0)` with `negLogInv μ x = ⊤` if `F μ (1/x) = 0`, else `-Real.log (F μ (1/x))` in EReal: matches F:346-349, with the standard convention $-\log 0=+\infty$ (gate-approved in L02_gate/L02_gate_r2; never ⊥, so EReal addition is honest).
- B01 / B04 (BLOCKERS) concern the printed *lemmas* L01 and L02 omitting $F_X(0)=0$, not the definitions. Both definitions carry $F_X(0)=0$ exactly as F:124 and F:346 print it. T04 uses only the definitions, never Lemma 2.3 or Lemma 4.10, so neither issue propagates to T04; the hypothesis $F_X(0)=0$ of the target is supplied by the source's own Def 4.9 (`h.1`). Recorded as handled; no action.
- Names are imported, not redeclared; `T04Stmt.lean` declares nothing in `namespace Paper.T04`.

## Item 1. Hypotheses — PASS
`T04_main (μ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ) : IsInvSub μ`. The only source hypothesis is "X super-heavy-tailed" (F:378), encoded. `IsProbabilityMeasure` just says μ is the law of a random variable (F:119). No extra premises, no hidden `variable`s/classes, no conclusion-shaped hypothesis.

## Item 2. Conclusion — PASS
`IsInvSub μ` is exactly "X is ITS" (both conjuncts). Not weakened or strengthened.

## Item 3. Quantifiers / constants — PASS
No constants. Subadditivity quantifies ∀x,y in the domain (F:111).

## Item 4. Domains and details — PASS
Domain (0,∞) on both sides (consistent with L01/L02 gates); Lean `1/0=0` never reached. No a.e./measurability/ENNReal-truncation traps: `F` is `ProbabilityTheory.cdf`, real-valued in [0,1]. Log 0 handled in the definition by the EReal convention; the obligations use `Real.log` only under positivity hypotheses (so the junk value `Real.log 0 = 0` never enters).

## Item 5. Step obligations — FAIL as a set (each one true; assembly incomplete) -> amendment A1

Truth as stated (each checked by hand):
- S1 (F:381): with F(1/x),F(1/y)>0 the RHS of the EReal subadditivity is finite, so `negLogInv(x+y) ≠ ⊤`, hence F(1/(x+y))>0 and the real inequality follows by negation. TRUE. The extra conjunct `0 < F(1/(x+y))` is a technical precondition for `Real.log`, derivable, not a smuggled conclusion.
- S2 (F:381-382): exp monotone + `exp ∘ log = id` on positives. TRUE. Faithful.
- S3 (F:383): $e^a+e^b-1\le e^{a+b}$ for $a,b\le0$ ⟺ $(1-e^a)(1-e^b)\ge0$. TRUE. This is the inequality actually used; the source's phrase "the exponential is superadditive" literally means $e^{a+b}\ge e^a+e^b$, false at a=b=0; the intended reading is superadditivity of $t\mapsto e^t-1$ on $(-\infty,0]$. Preliminary: EDITORIAL / FAIR_IMPLICIT_STEP, not an issue. S3 encodes it fairly.
- S4 (F:382-383): S3 with a = log F(1/x) ≤ 0 (F ≤ 1), b likewise. TRUE (no x,y>0 needed).
- S5 (F:384-385): `hchain` for all x,y>0 is literally `invDist` subadditivity rewritten ("going to the complementary sets"), plus `h.1` for F(0)=0. TRUE. `hchain` is the previous step's output (the source's "this last inequality"), not a TFA; it is the conclusion's second conjunct up to a rewriting, but that rewriting *is* the source step S5 encodes, so it is acceptable for a step obligation.

Assembly: `T04_main` needs `hchain` for all x,y>0. S2+S4 deliver it only when F(1/x)>0 and F(1/y)>0. The drafter deliberately left the case F(1/x)=0 or F(1/y)=0 uncovered, calling it untreated by the source (X19). I do not accept that reading:
- The definition is encoded with the convention $\log 0=-\infty$ (`negLogInv = ⊤`); without it Def 4.9 is meaningless for every X with support bounded away from 0, and that convention is what makes the source's definition well-defined at all.
- Under that same convention the source's printed chain covers the zero case verbatim: $\Log F_X(\frac1x)=-\infty$, so the first inequality is trivial, $\exp(-\infty)=0$, and the "exponential superadditive" step at $a=-\infty$ reads $0\ge F_X(\frac1y)-1 = F_X(\frac1x)+F_X(\frac1y)-1$, which holds.
- Stating S1/S2/S4 with `Real.log` only on positives is a representation choice of ours. Leaving the zero case as an uncovered case would let that choice manufacture an EXPOSITION_GAP (POLICY §1: "our own representation choices must never manufacture a paper error"). Ruling: the zero case is a FAIR_IMPLICIT_STEP of the source's chain under the convention adopted for Def 4.9. It needs its own obligation so that S1-S5 assemble to `T04_main`.

## Item 6. External parameters — PASS (none)
No `def … : Prop` tools, no consumed clauses. X08 (S3) is elementary and is an obligation to prove, not a parameter; no "mathlib lacks it" claim is made, so there is no evidence to check. No predecessor results are consumed (only definitions).

## Item 7. Doubts about the source — recorded, no dispatch required
1. F:381 / X19 (Log 0): see item 5; preliminary FAIR_IMPLICIT_STEP (covered by the source chain under the definition's $\log 0=-\infty$ convention). Not a suspected issue. If the coordinator disagrees with this ruling, the alternative would be a minor EXPOSITION_GAP to be sent to pv-issue-checker; the gate does not rule on paper correctness.
2. F:383 "exponential is superadditive": preliminary EDITORIAL (imprecise wording for $e^t-1$ superadditive on $(-\infty,0]$). Not an issue.
3. F:381 "As noted after Definition 4.9": F:356 states $F_X(\frac1x)=1-F^-_{\frac1X}(x)$ in general, and $\Log$ superadditive ⟺ $-\Log$ subadditive is immediate. FAIR_IMPLICIT_STEP.

## TFAs ruled on
| Name | Ruling | Reason |
|---|---|---|
| (none proposed) | — | — |
| S1 extra conjunct `0 < F μ (1/(x+y))` (not a premise) | accepted | technical precondition for `Real.log`, derived from `h` |

## External parameters
None.

## Required changes
- **A1** (`pv_work/T04Draft.lean`, insert after `T04_S4`, before `T04_S5`): add the obligation
  ```lean
  /-- S4z. Source F:381-383, the same chain in the case `F_X(1/x)=0` or `F_X(1/y)=0`, read with
  the convention `Log 0 = -∞`, `exp(-∞) = 0` adopted for Def 4.9 (`negLogInv`, L02Stmt):
  the right-hand side is `F_X(1/y)-1 ≤ 0` (or symmetric) `≤ F_X(1/(x+y))`. FAIR_IMPLICIT_STEP. -/
  theorem T04_S4z (μ : Measure ℝ) [IsProbabilityMeasure μ]
      {x y : ℝ} (hx : 0 < x) (hy : 0 < y) (h0 : F μ (1 / x) = 0 ∨ F μ (1 / y) = 0) :
      F μ (1 / x) + F μ (1 / y) - 1 ≤ F μ (1 / (x + y)) := by
    sorry
  ```
  (The statement elaborates: probe `pv_work/probes/gate/T04/gate_T04_amendprobe.lean`, exit 0.)
- **A2** (docstrings only, no type change): in `T04_S1` replace the sentence "The case `F_X(1/x)=0` or `F_X(1/y)=0` (`Log 0`) is NOT treated by the source (INVENTORY X19) and is deliberately not stated." by "The case `F_X(1/x)=0` or `F_X(1/y)=0` is covered by S4z (convention `Log 0 = -∞`)."; in `T04_S5` replace "The sub-case of zero `F_X(1/x)` or `F_X(1/y)` is not covered by S1-S4 (X19); the source gives no justification for it." by "`hchain` is supplied by S2+S4 when `F_X(1/x),F_X(1/y)>0` and by S4z otherwise." Update notes item "Suspected paper issues 1" and the line "`T04_main` is not literally assembled from S1-S5" accordingly.
- No other changes. The type hashes of `T04_main`, S1-S5 must remain as below.

## Statement snapshot
Copies: `pv_work/probes/gate/T04/gate_T04_stmtcopy.lean` (probe exit 0, log `pv_work/logs/gate_T04_stmtcopy_1.log`), `pv_work/probes/gate/T04/gate_T04_draftcopy.lean` (probe exit 0, 6 sorries, log `pv_work/logs/gate_T04_draftcopy_1.log`).

T04Stmt copy:
```
TYPE HASHES (current file, 0 declarations)
EXIT=0
```
T04Draft copy:
```
TYPE HASHES (current file, 6 declarations)
Paper.T04.T04_S1|thm|th=1510204608|vh=-|bi=eceiieeee
Paper.T04.T04_S2|thm|th=3418143244|vh=-|bi=eceiieeee
Paper.T04.T04_S3|thm|th=2649797432|vh=-|bi=iiee
Paper.T04.T04_S4|thm|th=497200072|vh=-|bi=eciiee
Paper.T04.T04_S5|thm|th=3290591031|vh=-|bi=ecee
Paper.T04.T04_main|thm|th=362827318|vh=-|bi=ece
EXIT=0
```

## Overall verdict
Statement, hypotheses, conclusion, and reused definitions are faithful. All obligations are true as stated. One amendment (A1, plus docstrings A2) is needed so that the obligations cover the source's chain in the F(1/x)=0 case and assemble to `T04_main`.

STATEMENT GATE: PASS_WITH_AMENDMENTS
