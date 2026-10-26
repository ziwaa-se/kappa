# DEFS statement gate (shared definitions)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:45:04 EDT 2026
- Reviewed file: `pv_work/Defs.lean`, sha256 `1a84ee67ce46f2b4d639eaadf6229ee14ec07a2e08973fb06923d4cc2ef915c8`
- Compilation: `scripts/pv_lean.sh check Defs` -> `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/Defs_2.log`
- Snapshot probe: `pv_work/probes/gate/DEFS/gate_DEFS_defscopy.lean` (verbatim copy of Defs.lean + `import PVTools` + `#pv_type_hashes_here`), exit=0, log `pv_work/logs/gate_DEFS_defscopy_1.log`
- Draft notes `pv_work/notes/DEFS_draft_notes.md` used only as leads; every ruling below is from the source text and the Lean file.

## Source quotations

- `source/main.tex:24-27` (Definition def:edf): "For $n \ge 1$ and $x = (x_1,\dots,x_n)\in\mathbb{R}^n$, the empirical distribution function is $F_n(t) = \frac1n \#\{ i : x_i \le t \}$ for $t\in\mathbb{R}$."
- `source/main.tex:29-31`: "When $X_1, X_2, \dots$ are random variables, $F_n$ denotes the empirical distribution function of $(X_1,\dots,X_n)$, and $D_n = \sup_{t\in\mathbb{R}} |F_n(t) - F(t)|$, where $F$ is the distribution function of $X_1$."

## Item-by-item rulings

1. **Hypotheses — PASS.** D01 omits `n ≥ 1` from the definition; for `n = 0` the value is `(1/0)*0 = 0`, a junk value outside the source's domain. This is a definition, not a theorem, so no premise is lost: consumers must carry `1 ≤ n` where the source uses it (to be checked at each result's gate). Probability measure and measurability of `X k` are likewise not built in; they are hypotheses of the consuming results (Prop. gc / Thm. ks state i.i.d., which consumers must encode). No hidden hypotheses: no structures, classes or `variable`s beyond `[MeasurableSpace Ω]`, which is required to state a measure.
2. **Conclusion / content — PASS.** `edf x t = (1/n) * #{i : Fin n | x i ≤ t}` matches `main.tex:26` exactly (non-strict `≤`, normalisation `1/n`, count over all n indices). `edfRV X n ω = edf (fun i : Fin n => X i ω)` matches `main.tex:29-30` with index shift `X 0 = X_1`, ..., `X (n-1) = X_n`; the sample `(X_1,…,X_n)` is exactly the first n terms, so the shift is a pure notational conversion. `cdfOf P X t = P.real {X 0 ≤ t}` is the distribution function of `X_1` (`main.tex:30-31`). `Dn = ⨆ t, |edfRV X n ω t - cdfOf P X t|` matches `main.tex:30`.
3. **Quantifiers / dependence — PASS.** `Dn` depends on `P, X, n, ω` as in the source (`D_n` is a random variable depending on the sample and on `F`, which depends on the law of `X_1`). No constants involved.
4. **Domains and details — PASS.**
   - `ℝ`-valued throughout; no `ENNReal`/`toReal` truncation trap: `Measure.real` is `(P s).toReal`, and for a probability measure `P s ≤ 1 < ∞`, so no truncation occurs. For a non-finite `P` values could truncate to 0, but the source only uses `F` for a distribution of a random variable (probability space); consumers must assume `IsProbabilityMeasure P`.
   - Real `⨆` truncation: Lean's `iSup` over `ℝ` returns `0` for unbounded ranges. With `P` a probability measure, `cdfOf ∈ [0,1]` (even for non-measurable sets, `P.real s ≤ 1`), and `edf ∈ [0,1]` for every `n` (it is 0 for `n = 0`), so the range `{|F_n(t) - F(t)|}` lies in `[0,1]`, is nonempty and bounded above; `⨆` is then the true supremum. Matches the source under the source's standing assumptions.
   - `cdfOf` uses `{X 0 ≤ t}` (right-continuous convention, `P(X_1 ≤ t)`), the standard meaning of "distribution function" and consistent with the `≤` of `main.tex:26`. The source does not spell this out; this is a standard convention, `FAIR_IMPLICIT_STEP`/`EDITORIAL`, not an issue.
   - Measurability: not encoded in definitions; `P.real` is defined for all sets (outer measure), so the definition is total; consumers must add measurability where the source's "random variables" requires it.
5. **Step obligations — N/A (PASS).** The file contains only definitions, no obligations and no theorems.
6. **External parameters — N/A (PASS).** None declared.
7. **Doubts about the source — none.** The unstated `≤` vs `<` reading of "distribution function" is standard; no paper issue suspected.

## TFAs ruled on

| Item | Ruling | Reason |
|---|---|---|
| none (definitions only) | — | `n ≥ 1`, probability measure and measurability are left to consumers; this is a representation choice, not a premise. |

## External parameters

| Name | Ruling | Provenance |
|---|---|---|
| none | — | — |

## Notes for downstream gates (not required changes)

- Every consumer of `edf`/`edfRV`/`Dn` must carry `1 ≤ n` (or `NeZero n`) where the source has `n ≥ 1`, and `IsProbabilityMeasure P` plus measurability of `X k`; otherwise junk values (`edf = 0` at `n = 0`, `⨆ = 0` on unbounded ranges, `toReal` truncation for infinite measures) could make statements vacuous or false.
- `Dn` is not automatically measurable as a function of `ω` (uncountable supremum); a consumer statement about `Dn → 0` a.s. or convergence in distribution must not silently need measurability the source does not provide (the source's results are stated for the classical i.i.d. case where this holds by right-continuity; flag at the PROP/THM gate if it becomes an issue).

## Required changes

none

## Statement snapshot

```
TYPE HASHES (current file, 4 declarations)
Paper.Defs.Dn|def|th=3440131190|vh=2791060692|bi=iceeee
Paper.Defs.cdfOf|def|th=1445834484|vh=3996147789|bi=iceee
Paper.Defs.edfRV|def|th=3081055092|vh=1623011663|bi=ieeee
Paper.Defs.edf|def|th=2665670918|vh=3752896497|bi=iee
```

## Overall verdict

The four definitions in `pv_work/Defs.lean` faithfully encode `source/main.tex:24-31`; junk-value cases lie outside the source's domain and must be excluded by consumers' hypotheses.

STATEMENT GATE: PASS
