# Statement gate: DEFS (shared definitions `pv_work/Defs.lean`)

- Reviewer: pv-gate (independent subagent; did not draft these definitions)
- Date: Mon Oct 12 21:45:04 EDT 2026 (from `date`)
- Reviewed file: `pv_work/Defs.lean`, sha256 `e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e`
- Compilation: `scripts/pv_lean.sh check Defs` -> `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/Defs_2.log`
- Hash probe: `pv_work/probes/gate/DEFS/gate_DEFS_defscopy.lean` (verbatim copy + `import PVTools` + `#pv_type_hashes_here`), exit=0, log `pv_work/logs/gate_DEFS_defscopy_1.log`
- Drafter notes `pv_work/notes/Defs_draft_notes.md` read as leads only.

## Source quotations (read directly)

- main.tex:26 — "Throughout, $n \ge 1$ is an integer and $x = (x_1, \dots, x_n) \in \mathbb{R}^n$."
- main.tex:28-30 (def:mean) — "The sample mean of $x$ is $\bar x = \frac{1}{n} \sum_{i=1}^n x_i$."
- main.tex:32-38 (def:var) — "For $n \ge 2$, the sample variance of $x$ is $s^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar x)^2$, and the sample standard deviation is $s = \sqrt{s^2} \ge 0$."
- Every later use of $s^2$ or $s$ (main.tex:59, 72, 86, 95) is under the hypothesis $n \ge 2$ (checked by search).

## Item rulings

1. **Hypotheses — PASS.** The global $n \ge 1$ (l.26) and the $n \ge 2$ domain of def:var (l.33) are not built into the definitions; they are total functions. This is a representation choice, acceptable provided every statement using `sampleMean` carries `1 ≤ n` (where needed) and every statement using `sampleVar`/`sampleStd` carries `2 ≤ n`. Since the source uses $s^2$ only under $n \ge 2$, no junk value (n=0: mean 0; n=1: `1/0 = 0`, so var 0) can manufacture or hide a paper error, provided statement gates enforce these hypotheses. No hidden hypotheses: no structures, classes or `variable`s; only `import Mathlib`.
2. **Conclusion/content — PASS.** `sampleMean x = (1/(n:ℝ)) * ∑ i, x i` matches l.29. `sampleVar x = (1/((n:ℝ)-1)) * ∑ i, (x i - sampleMean x)^2` matches l.35; the real subtraction `(n:ℝ) - 1` avoids ℕ truncation (and for n ≥ 2 equals `((n-1 : ℕ) : ℝ)`). `sampleStd = Real.sqrt (sampleVar x)` matches l.37; "$\ge 0$" is a property, provided by `Real.sqrt_nonneg`, not a definitional clause.
3. **Quantifiers/constants — PASS (N/A).** No constants.
4. **Domains and details — PASS.** `Fin n → ℝ` with `i : Fin n` ↔ $x_{i+1}$ is a faithful encoding of $\mathbb{R}^n$; finite sums over `Finset.univ`; no `ℝ≥0∞`/`toReal`/`ofReal`; `Real.sqrt` of a negative argument would truncate to 0, but `sampleVar ≥ 0` whenever n ≥ 2 (sum of squares times positive factor), so no truncation trap under the source's hypotheses. `Sample` is an `abbrev`, so it unfolds transparently.
5. **Step obligations — PASS (N/A).** File contains definitions only; no obligations.
6. **External parameters — PASS (N/A).** None declared.
7. **Doubts about the source — none in the definitions.** Observed in passing (outside this gate's scope, for the coordinator): main.tex:86 claims $s^2 \le \frac1n\sum x_i^2$, while the proof at l.90 only gives $(n-1)s^2 \le \sum x_i^2$, i.e. $s^2 \le \frac1{n-1}\sum x_i^2$. Candidate counterexample $n=2$, $x=(1,-1)$: $s^2 = 2$, $\frac1n\sum x_i^2 = 1$. Preliminary class `ERROR` for main.tex:86 (and consequently `PAPER_ARGUMENT_GAP` for the proof at main.tex:99, whose conclusion at l.95 may still be true). Recommend dispatching pv-issue-checker when those results are processed.

## TFAs ruled on

| Item | Ruling | Reason |
|---|---|---|
| (none) | — | Definitions carry no premises. |

## External parameters

| Name | Ruling | Provenance |
|---|---|---|
| (none) | — | — |

## Required changes

None. Standing requirement for later gates: statements must assume `1 ≤ n` where they use the l.26 convention in an essential way, and `2 ≤ n` wherever `sampleVar`/`sampleStd` appear.

## Statement snapshot (verbatim from `pv_work/logs/gate_DEFS_defscopy_1.log`)

```
TYPE HASHES (current file, 4 declarations)
Paper.Sample|def|th=3972626760|vh=3387071827|bi=e
Paper.sampleMean|def|th=724507745|vh=3325886827|bi=ie
Paper.sampleStd|def|th=724507745|vh=3700056340|bi=ie
Paper.sampleVar|def|th=724507745|vh=2993315478|bi=ie
EXIT=0
```

## Overall verdict

The four definitions are faithful to main.tex:26, 28-30, 32-38.

STATEMENT GATE: PASS
