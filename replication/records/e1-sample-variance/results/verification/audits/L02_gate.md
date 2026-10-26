# L02 statement gate

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:58:52 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean` 33bc8f135f6c692d4e2b97744bad9c46cb6752122c2c23e79c173fa1343fb8d9
  - `pv_work/L02Draft.lean` ba36d5aa035a18d14d60dd474fa23c6dffc8dcd3b690aeacaa6fa9dcdc64b78a
  - `pv_work/Defs.lean` (imported) e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e (DEFS gate: `verification/audits/DEFS_gate.md`, STATEMENT GATE: PASS)
  - `source/main.tex` 1cbdd1aa5b3d8616c3f4505b9062441d71b2f7e2644e20af8eaa1f4aed5a3250
- Compilation: `scripts/pv_lean.sh check L02Draft` -> `exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0`, log `pv_work/logs/L02Draft_2.log`, olean=none (draft with sorry, as expected).
- Draft notes `pv_work/notes/L02_draft_notes.md` used only as leads.

## Source quotations (read directly)

- main.tex:26: "Throughout, $n \ge 1$ is an integer and $x = (x_1, \dots, x_n) \in \mathbb{R}^n$."
- main.tex:29 (def:mean): "$\bar x = \frac{1}{n} \sum_{i=1}^n x_i$."
- main.tex:50-52 (Lemma lem:shortcut): "$\sum_{i=1}^n (x_i - \bar x)^2 = \sum_{i=1}^n x_i^2 - n \bar x^2$."
- main.tex:54-56 (proof): "Expanding the square and using $\sum_{i=1}^n x_i = n \bar x$, we obtain the claim."
- def:var (main.tex:32-37) is not used by L02.

## Item rulings

1. **Hypotheses: PASS.** The only hypothesis is the global convention `n ≥ 1` (main.tex:26), encoded as `hn : 1 ≤ n` in `L02_main`. `x : Sample n = Fin n → ℝ` (Defs, DEFS-gated) encodes `x ∈ ℝ^n`. No extra premises; no hidden hypotheses in structures/classes/variables (none used; `Defs` contains only definitions). No conclusion-as-hypothesis.
2. **Conclusion: PASS.** `Conclusion x` is literally `∑ i, (x i - x̄)^2 = ∑ i, (x i)^2 - (n:ℝ) * x̄^2`, matching main.tex:51 (`n \bar x^2` read as `n (\bar x)^2`, the standard reading). Neither weakened nor strengthened; single clause.
3. **Quantifiers/constants: PASS.** Universally quantified over `n` and `x`; no constants involved.
4. **Domains and details: PASS.** Finite index set `Fin n` (index shift `i ↦ x_{i+1}` is notation only). Exact equality in ℝ. `n` cast `(n : ℝ)`, real subtraction: no ℕ-truncation, no `ENNReal`/`toReal`. `sampleMean` for `n = 0` gives 0, but `hn` excludes this case anyway (and the identity holds there too).
5. **Step obligations: PASS.** All three checked for truth as stated.
   - `L02_S1` (main.tex:55 "Expanding the square"): `∑ (x_i - m)^2 = ∑ x_i^2 - 2 m ∑ x_i + n m^2`; true for every `n` (sum of the constant `m^2` over `Fin n` is `n m^2`). Corresponds to the cited sentence; no smuggled conclusion.
   - `L02_S2` (main.tex:55 "using ∑ x_i = n x̄", from def:mean main.tex:29): `∑ x_i = n * ((1/n) ∑ x_i)`; true since `hn` gives `(n:ℝ) ≠ 0`. Fair implicit step from the definition.
   - `L02_main` (assembly, "we obtain the claim"): substituting S2 into S1 gives `∑x_i^2 - 2 n m^2 + n m^2 = ∑x_i^2 - n m^2`. S1 + S2 assemble to the main theorem.
6. **External parameters: PASS (none).** No `def Tool : Prop`, no consumed clauses; no predecessor used (L01 not needed; the source proof of L02 does not cite it).
7. **Doubts about the source: PASS (none).** The proof is a standard algebraic identity; no suspected paper issue.

## TFAs ruled on

| Premise | Ruling | Reason |
|---|---|---|
| (none) | - | `hn : 1 ≤ n` is the printed global hypothesis main.tex:26, not a TFA |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | - |

## Required changes

None.

## Statement snapshot

Statement copy `pv_work/probes/gate/L02/gate_L02_stmtcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, log `pv_work/logs/gate_L02_stmtcopy_1.log`):

```
TYPE HASHES (current file, 1 declarations)
Paper.L02.Conclusion|def|th=3418533756|vh=1598427906|bi=ie
EXIT=0
```

Draft copy `pv_work/probes/gate/L02/gate_L02_draftcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, 3 sorry warnings, log `pv_work/logs/gate_L02_draftcopy_1.log`):

```
TYPE HASHES (current file, 3 declarations)
Paper.L02.L02_S1|thm|th=2343660355|vh=-|bi=ie
Paper.L02.L02_S2|thm|th=3237641512|vh=-|bi=iee
Paper.L02.L02_main|thm|th=28637440|vh=-|bi=iee
EXIT=0
```

## Overall verdict

The statement and step obligations are faithful to main.tex:50-56; proof work may begin.

STATEMENT GATE: PASS
