# Statement gate: L02 (Lemma lem:min, source/main.tex:48-56)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:07:14 EDT 2026 (from `date`)
- Reviewed files (sha256 from `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean` `8c2d7440f6f332f279823bc14e8e9730ff05ebbe68b58f6e4acec79fb5c6885a`
  - `pv_work/L02Draft.lean` `9a1f02291f364725802b8568cf2fa995f230994de0d66fa4796443732cd7e48b`
- Imported files also read: `pv_work/Defs.lean` (gated PASS in `verification/audits/DEFS_gate.md`), `pv_work/L01Stmt.lean` (declares nothing in `Paper.L01`; no name clash).
- Draft notes `pv_work/notes/L02_draft_notes.md` read as leads only; every claim below was checked against the source and by compilation.
- Compilation: `scripts/pv_lean.sh check L02Draft` -> `RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_2.log olean=none` (5 sorries = S1-S4 + main, as expected for a draft).
- Probes (`pv_work/probes/gate/L02/`):
  - `gate_L02_stmtcopy.lean` -> exit=0, log `pv_work/logs/gate_L02_stmtcopy_1.log`
  - `gate_L02_draftcopy.lean` -> exit=0, sorry_warnings=5, log `pv_work/logs/gate_L02_draftcopy_1.log`
  - `gate_L02_falsity.lean` (truth check of the obligations) -> exit=0, errors=0, sorry_warnings=0, log `pv_work/logs/gate_L02_falsity_1.log`

## Source quotations (read directly)

- main.tex:25: "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:32-33: "The oracle risk is $\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$."
- main.tex:48-50 (statement): "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:53-55 (proof): "The number $\rho$ is half the harmonic mean $2\theta^2\sigma^2 / (\theta^2 + \sigma^2)$ of $\theta^2$ and $\sigma^2$. The harmonic mean of two positive numbers is at most the smaller of them, so $\rho \le \frac12 \min\{\theta^2, \sigma^2\} \le \min\{\theta^2, \sigma^2\}$."
- No convention on constants in the source; no other definitions used.

## Item-by-item rulings

1. **Hypotheses: PASS.** The only hypothesis is `(h : Setting θ σ)` = θ ≠ 0 ∧ 0 < σ (main.tex:25). No extra premises, no type classes, no `variable`s, no hidden structure fields. No hypothesis restates the conclusion.
2. **Conclusion: PASS.** `Conclusion θ σ := oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2)` is main.tex:49 verbatim; one clause, neither weakened nor strengthened.
3. **Quantifiers / constants: PASS.** θ σ universally quantified explicitly (`bi=eee` on `L02`); no constants.
4. **Domains and details: PASS.** All real-valued; total division harmless since θ²+σ² > 0 under `Setting`; no ENNReal/toReal, a.e., measurability or existence issues.
5. **Step obligations: PASS (faithful), with two obligations FALSE AS STATED, reported not repaired.**
   - S1 (main.tex:53) `oracleRisk θ σ = (1/2) * harmonicMean (θ^2) (σ^2)`, with `harmonicMean a b := 2*a*b/(a+b)` taken from the formula printed at l.53. Faithful; TRUE (proved in probe by `unfold; ring`).
   - S2 (main.tex:54) `HarmonicLeMin : ∀ a b, 0<a → 0<b → harmonicMean a b ≤ min a b`. This is the printed sentence word for word ("two positive numbers", "at most the smaller of them"). Faithful. **FALSE AS STATED**: a = 1, b = 4 gives HM = 8/5 > 1 (probe proves `¬ HarmonicLeMin`). The harmonic mean actually lies between min and max.
   - S3 (main.tex:54-55) `oracleRisk θ σ ≤ (1/2) * min (θ^2) (σ^2)` under `Setting`. This is the printed first inequality of the chain, and it is what S1+S2 would give. Faithful. **FALSE AS STATED**: θ = 1, σ = 2 gives ρ = 4/5 > 1/2 (probe proves the negation of the universally quantified S3).
   - S4 (main.tex:55) `(1/2) * min ≤ min` under `Setting`. Faithful; TRUE (min ≥ 0).
   - Assembly: S3 + S4 give `Conclusion` by `le_trans`; S1 + S2 (with θ² > 0, σ² > 0 from `Setting`) give S3. The chain is the source's chain. No obligation smuggles in the target or a stronger intermediate claim beyond what the source itself prints (S3 is stronger than the target, but it is literally printed at l.55).
   - The target `Conclusion` itself is TRUE (sanity check in probe via `div_le_iff₀` + `nlinarith`; this is not along the source route and is not a proof of L02 for verdict purposes).
6. **External parameters: PASS (none).** `HarmonicLeMin` is a `def … : Prop` in `L02Stmt.lean`, in `namespace Paper.L02`, but it is used only as the *type of obligation S2*, not as a hypothesis of any theorem; it is therefore not an external parameter and needs no registration in `EXTERNAL_TOOLS.md`. Its content is locked by `vh` in the snapshot. Its docstring label "Provenance (ii)" is informational only. It must **not** later be turned into a hypothesis of `L02`: as a hypothesis it would be a false premise making the conditional theorem vacuous. No names redeclared (`Conclusion`, `harmonicMean`, `HarmonicLeMin` are new in `Paper.L02`; `L01Stmt` declares nothing).
7. **Doubts about the source:** see "Suspected paper issues". Preliminary only; no ruling here.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | - | No extra premises. |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | `HarmonicLeMin` is an obligation type, not a hypothesis (see item 6). |

## False-as-stated obligations

- `Paper.L02.L02_S2` (`HarmonicLeMin`), main.tex:54: counterexample a=1, b=4.
- `Paper.L02.L02_S3`, main.tex:55 first inequality: counterexample θ=1, σ=2.

Both are faithful encodings of the printed wording and must stay as they are (POLICY §1: no repair). The prover should stop at S2 and record it; S4 is independent and provable.

## Suspected paper issues (preliminary; dispatch pv-issue-checker)

- main.tex:54-55: "The harmonic mean of two positive numbers is at most the smaller of them, so ρ ≤ ½ min{θ²,σ²}". Both the general claim and the derived bound ρ ≤ ½ min are false (counterexamples above), while the lemma's conclusion ρ ≤ min{θ²,σ²} is true. Preliminary class: `PAPER_ARGUMENT_GAP` (justification fails, printed conclusion of the lemma holds). The issue-checker may consider whether the false intermediate inequality printed in the proof warrants a different class; not ruled on here. Note: main.tex:75 (cor:half) cites Lemma lem:min only for ρ ≤ min, so downstream results should consume only the true conclusion.

## Required changes

None.

## Statement snapshot

From `pv_work/logs/gate_L02_stmtcopy_1.log` (verbatim):

```
TYPE HASHES (current file, 3 declarations)
Paper.L02.Conclusion|def|th=1185911348|vh=2072270411|bi=ee
Paper.L02.HarmonicLeMin|def|th=3944470172|vh=2930808381|bi=
Paper.L02.harmonicMean|def|th=2687296866|vh=3280496900|bi=ee
EXIT=0
```

From `pv_work/logs/gate_L02_draftcopy_1.log` (verbatim):

```
TYPE HASHES (current file, 5 declarations)
Paper.L02.L02_S1|thm|th=668092350|vh=-|bi=eee
Paper.L02.L02_S2|thm|th=2070248410|vh=-|bi=
Paper.L02.L02_S3|thm|th=530875162|vh=-|bi=eee
Paper.L02.L02_S4|thm|th=1649255899|vh=-|bi=eee
Paper.L02.L02|thm|th=143933708|vh=-|bi=eee
EXIT=0
```

## Overall verdict

Statement and conclusion are faithful to main.tex:25, 32-33, 48-50; obligations S1-S4 encode the printed proof wording faithfully, with S2 and S3 false as stated (reported, not repaired); no TFAs, no external parameters, no amendments.

STATEMENT GATE: PASS
