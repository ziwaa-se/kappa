# Statement gate: P01 (Proposition prop:popoviciu, source/main.tex:58-63)

- Reviewer: pv-gate (independent subagent; did not draft P01)
- Date: Mon Oct 12 21:55:10 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` `ef10f60b2fb50c6ec44a1b58d044667e765d2e4287f9a43e7f7e746a1069b641`
  - `pv_work/P01Draft.lean` `cb86f94bf41dadcd471cb4304b000f392e4fc14512730dcf3733a2c93dd49429`
  - imported `pv_work/Defs.lean` (gated PASS in `verification/audits/DEFS_gate.md`)
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_2.log`
- Probes (`pv_work/probes/gate/P01/`):
  - `gate_P01_stmtcopy.lean` -> exit=0, log `pv_work/logs/gate_P01_stmtcopy_1.log`
  - `gate_P01_draftcopy.lean` -> exit=0 (2 sorry warnings, expected), log `pv_work/logs/gate_P01_draftcopy_1.log`
  - `gate_P01_check.lean` (mathlib `#check` + goal-shape equivalence proof) -> exit=0, log `pv_work/logs/gate_P01_check_2.log`
- Drafter notes `pv_work/notes/P01_draft_notes.md` read as leads only.

## Source quotations (read directly)

- main.tex:26 — "Throughout, $n \ge 1$ is an integer and $x = (x_1,\dots,x_n) \in \mathbb{R}^n$."
- main.tex:29 — $\bar x = \frac1n\sum_{i=1}^n x_i$. main.tex:33-35 — for $n\ge2$, $s^2 = \frac{1}{n-1}\sum_{i=1}^n (x_i-\bar x)^2$.
- main.tex:58-63 — "Suppose that $n \ge 2$ and that $a \le x_i \le b$ for $i = 1,\dots,n$. Then $s^2 \le \frac{n}{n-1}\cdot\frac{(b-a)^2}{4}$."
- main.tex:66-67 — "Popoviciu's inequality on variances \cite{popoviciu} states that $\frac1n\sum_{i=1}^n (x_i-\bar x)^2 \le \frac{(b-a)^2}{4}$ whenever $x_1,\dots,x_n$ lie in $[a,b]$."
- main.tex:68 — "Multiplying both sides by $\frac{n}{n-1}$ gives the claim."
- main.tex:103-106 — T. Popoviciu, Sur les équations algébriques ayant toutes leurs racines réelles, Mathematica (Cluj) 9:129–145, 1935.

## Item rulings

1. **Hypotheses — FAIL (because of `hP`, see item 6).** `hn : 2 ≤ n` ↔ l.59; `hx : ∀ i, a ≤ x i ∧ x i ≤ b` ↔ l.59 (`Fin n` index shift as in Defs); `a b : ℝ` (implicit in source, real). No hidden hypotheses (no structures, classes, `variable`s; Defs is definitions only). On "$a \le b$ never stated": it is not needed and not added. With $n \ge 2$ (indeed $n\ge1$), `hx` at any index gives $a \le b$; if $a>b$, `hx` is unsatisfiable and the statement is vacuous. No TFA needed, and the omission is not a paper issue. The one problem is the external-parameter hypothesis `hP : Popoviciu n a b x`. In its current form it is equivalent to the conclusion (item 6).
2. **Conclusion — PASS.** `sampleVar x ≤ (n:ℝ)/((n:ℝ)-1) * ((b-a)^2/4)` is l.61 exactly; real `(n:ℝ)-1` is positive under `hn`. It is neither weakened nor strengthened, and no clause is missing.
3. **Quantifiers / constants — PASS.** No constants; `n a b x` are all universally quantified, as in the source.
4. **Domains and details — PASS.** It is a finite real sample with no measure, a.e., `ℝ≥0∞`, `ofReal` or `toReal`. The closed interval $[a,b]$ is encoded as non-strict inequalities. Division by `(n:ℝ)-1` is safe under `hn`.
5. **Step obligations — PASS (all true as stated).**
   - `P01_S1` (l.66-67): `hP hx` closes it. It is true, but only because `hP` *is* the conclusion after the trivial rescaling; see item 6.
   - `P01_S2` (l.68): `sampleVar x = n/(n-1) · ((1/n)∑…)` for `n ≥ 2`, and multiplying by the positive factor gives the claim. It is true as stated (proved inside `gate_P01_check.lean` as part of the equivalence) and needs no missing premise.
   - Assembly: S1 then S2 yield `P01` (already written in the draft). No smuggling beyond the item-6 issue.
6. **External parameters — FAIL (goal-shaped).** `Popoviciu n a b x` is specialised to the very sample of the theorem: `(∀ i, a ≤ x i ∧ x i ≤ b) → (1/n)∑(x_i-x̄)² ≤ (b-a)²/4`. Under `2 ≤ n`, the probe `gate_P01_check.lean` proves (exit 0) that
   `Popoviciu n a b x ↔ ((∀ i, a ≤ x i ∧ x i ≤ b) → sampleVar x ≤ n/(n-1) * ((b-a)^2/4))`.
   So the hypothesis `hP` is the conclusion of P01 (given `hx`) up to a positive scalar. That is exactly the "conclusion or an equivalent as a hypothesis" form that the rule card says to reject. A conditional verdict on this form would carry no content. Other aspects:
   - Provenance (i) is correct: l.66-67 cite \cite{popoviciu}, bib l.103-106. The bibliographic item is the standard attribution of Popoviciu's inequality on variances; at most `EDITORIAL`, not an issue.
   - Content is faithful: the population-variance form $\frac1n\sum(x_i-\bar x)^2 \le (b-a)^2/4$, exactly as printed at l.67.
   - Naming and location are correct: declared only in `P01Stmt.lean`, in `namespace Paper.P01`. `L01Stmt`/`L02Stmt` declare only `Conclusion`, so there is no clash.
   - Mathlib evidence holds up: `#check @ProbabilityTheory.variance_le_sq_of_bounded` exists, but in a measure-theoretic form (`IsProbabilityMeasure μ`, `∀ᵐ ω, X ω ∈ Icc a b`, `AEMeasurable X μ` ⊢ `variance X μ ≤ ((b-a)/2)^2`). There is no `Fin n` sample interface, so keeping a type-(i) parameter is acceptable. Optionally, the prover may discharge it from this lemma via the uniform measure on `Fin n`, which would remove the parameter.
   - Fix: state the parameter as the cited theorem itself, a closed `Prop` quantified over all samples, as l.66-67 print it ("whenever $x_1,\dots,x_n$ lie in $[a,b]$"). That form is a genuine, independent statement and is true: it is the standard Popoviciu inequality, and also vacuous for $a>b$. It matches what the source invokes, so it is not stronger than the source's use.
7. **Doubts about the source — none for P01.** The l.66-67 citation and the l.68 rescaling are both sound. Missing $a\le b$ is not an issue (item 1). The candidate `ERROR` at main.tex:86 (L-raw) noted in DEFS_gate is outside P01.

## TFAs ruled on

| Item | Ruling | Reason |
|---|---|---|
| (none proposed; `a ≤ b` deliberately not added) | — | `a ≤ b` follows from `hx` and `n ≥ 1`; no premise needed. |

## External parameters

| Name | Provenance | Ruling | Reason |
|---|---|---|---|
| `Paper.P01.Popoviciu (n a b x)` (current) | (i), main.tex:66-67, bib :103-106 | **Rejected** | Goal-shaped: equivalent under `2 ≤ n` to `hx →` conclusion of P01 (probe proof). |
| `Paper.P01.Popoviciu : Prop` (amended form below) | (i) | Approved once implemented | Faithful statement of the cited inequality, independent of the theorem's sample, true. |

## Required changes

1. `pv_work/P01Stmt.lean` lines 11-13: replace the definition with a closed proposition (adjust the docstring's "Specialized to the given…" sentence accordingly):
   ```lean
   def Popoviciu : Prop :=
     ∀ (n : ℕ) (a b : ℝ) (x : Sample n), 1 ≤ n → (∀ i, a ≤ x i ∧ x i ≤ b) →
       (1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4
   ```
   (`1 ≤ n` reflects the l.26 convention; it is harmless and makes the parameter weaker.)
2. `pv_work/P01Draft.lean` line 9 (`P01_S1`) and line 24 (`P01`): change `(hP : Popoviciu n a b x)` to `(hP : Popoviciu)`. No other change. The proof of `P01` (lines 26-27) can stay as is.

## Statement snapshot

From `pv_work/logs/gate_P01_stmtcopy_1.log` (verbatim):
```
TYPE HASHES (current file, 1 declarations)
Paper.P01.Popoviciu|def|th=1469046615|vh=291211332|bi=eeee
EXIT=0
```
From `pv_work/logs/gate_P01_draftcopy_1.log` (verbatim):
```
TYPE HASHES (current file, 3 declarations)
Paper.P01.P01_S1|thm|th=1502367251|vh=-|bi=eeeeeee
Paper.P01.P01_S2|thm|th=2016942701|vh=-|bi=eeeeee
Paper.P01.P01|thm|th=116657803|vh=-|bi=eeeeeee
EXIT=0
```
(This snapshot is of the pre-amendment files; the r2 check will record the new snapshot.)

## Overall verdict

Hypotheses, conclusion, domains and steps are faithful. The external parameter `Popoviciu` must be restated as the closed cited theorem (2 changes above).

STATEMENT GATE: PASS_WITH_AMENDMENTS
