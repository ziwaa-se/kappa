# P01 statement gate (Proposition prop:gc)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:55:12 EDT 2026 (from `date` at session start)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` `fd398b712c1f79d0fa874425b3bb24c93ccc46c759dab177d1c91c0b809a0288`
  - `pv_work/P01Draft.lean` `c96db3cdce30588b98a5af4bd84a612d2b292bd3cc6b9bf27132fe140afbeb1a`
  - imported `pv_work/Defs.lean` `1a84ee67ce46f2b4d639eaadf6229ee14ec07a2e08973fb06923d4cc2ef915c8` (identical to the hash in `verification/audits/DEFS_gate.md`, gate PASS)
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_2.log` (the two `sorry` are the draft obligations S1 and main, as expected).
- Probes (all in `pv_work/probes/gate/P01/`):
  - `gate_P01_stmtcopy.lean` (snapshot), exit=0, log `pv_work/logs/gate_P01_stmtcopy_1.log`
  - `gate_P01_draftcopy.lean` (snapshot), exit=0, 2 sorry warnings, log `pv_work/logs/gate_P01_draftcopy_1.log`
  - `gate_P01_mathlib_search.lean` (`#check` search), exit=1 by design (14 unknown-identifier errors), log `pv_work/logs/gate_P01_mathlib_search_1.log`
  - `gate_P01_sanity.lean` (assembly + non-vacuity), exit=0, 0 sorry, log `pv_work/logs/gate_P01_sanity_5.log`
- Draft notes `pv_work/notes/P01_draft_notes.md` used only as leads.

## Source quotations

- `source/main.tex:24-27` (def:edf): "For $n \ge 1$ and $x=(x_1,\dots,x_n)\in\mathbb{R}^n$, the empirical distribution function is $F_n(t)=\frac1n\#\{i : x_i\le t\}$ for $t\in\mathbb{R}$."
- `source/main.tex:29-31`: "When $X_1, X_2, \dots$ are random variables, $F_n$ denotes the empirical distribution function of $(X_1,\dots,X_n)$, and $D_n=\sup_{t\in\mathbb{R}}|F_n(t)-F(t)|$, where $F$ is the distribution function of $X_1$."
- `source/main.tex:45-47` (prop:gc): "If $X_1, X_2, \dots$ are independent and identically distributed, then $D_n \to 0$ almost surely."
- `source/main.tex:49-51` (proof): "This is the Glivenko--Cantelli theorem." (no `\cite`; the bibliography `main.tex:65-` has only donsker and kolmogorov).

## Item-by-item rulings

1. **Hypotheses — PASS.** `IsIIDSeq` (P01Stmt.lean:16-20): `prob : IsProbabilityMeasure P` and `meas : ∀ k, Measurable (X k)` are the standard meaning of "random variables" (`main.tex:29`), and are exactly what DEFS_gate requires of consumers of `Dn` (bounded range for `⨆`, no `toReal` truncation). `indep : iIndepFun X P` is mutual independence of the whole sequence = "independent" (`main.tex:46`) in the standard sense. `ident : ∀ k, IdentDistrib (X k) (X 0) P P` = "identically distributed". Real-valued `X` matches `main.tex:30-31` (distribution function on ℝ). No extra premises; no continuity assumption (correct: prop:gc has none, unlike thm:ks). No hidden hypotheses: no `variable`s, no type classes beyond `[MeasurableSpace Ω]`; the structure fields are all listed above. No hypothesis states the conclusion: the only hypothesis besides `IsIIDSeq` is the external input `hGC`, discussed under item 6. Non-vacuity checked in Lean: `gate_P01_sanity.lean` proves `IsIIDSeq (Measure.dirac ()) (fun _ _ => 0)` without `sorry`, so the hypotheses (and the premise of `GlivenkoCantelli`) are satisfiable.
2. **Conclusion — PASS.** `∀ᵐ ω ∂P, Tendsto (fun n => Dn P X n ω) atTop (𝓝 0)` is "$D_n\to0$ almost surely". Neither weakened nor strengthened: `∀ᵐ` asks only that the failure set be contained in a null set, the standard meaning of a.s. convergence, and it does not require measurability of `Dn` (which is not automatic, cf. DEFS_gate note). The junk value of `Dn` at `n = 0` (Lean `edf` = 0 there, so `Dn = 1`) is irrelevant to a limit along `atTop`, so the source's `n ≥ 1` needs no encoding here. Single clause; nothing missing.
3. **Quantifiers / constants — PASS.** No constants. `Ω, P, X` universally quantified, as in the source. Universe: `Ω : Type u` with `GlivenkoCantelli.{u}` at the same universe; this does not restrict the statement.
4. **Domains and details — PASS.** Non-periodic, ℝ. `∀ᵐ` vs pointwise: correct (a.s.). Measurability: of `X k` encoded; of `Dn` not needed (see 2). `ℝ≥0∞`/`ℝ`: `cdfOf` uses `P.real` with `P` a probability measure, so no truncation; `⨆` over ℝ is a true supremum because the range lies in `[0,1]` (DEFS_gate item 4). Index shift `X 0 = X_1` consistent with Defs.
5. **Step obligations — PASS.**
   - `P01_S1` (main.tex:50 "This is the Glivenko--Cantelli theorem"): `GlivenkoCantelli.{u} → IsIIDSeq P X → GCConclusion P X`. True as stated (direct instantiation), corresponds exactly to the cited sentence, smuggles nothing beyond the cited theorem.
   - `P01_main`: same type as `P01_S1` with `GCConclusion` unfolded. Assembly checked in `gate_P01_sanity.lean`: `hGC Ω P X h` closes the main statement (exit=0). Not false as stated.
6. **External parameters — PASS (with flag).** `GlivenkoCantelli.{u}` (P01Stmt.lean:26-28).
   - Faithful to the classical theorem: for every probability space and every i.i.d. real sequence (no continuity of $F$ required), $\sup_t|F_n(t)-F(t)|\to0$ a.s. This is the classical Glivenko–Cantelli theorem, true; the encoding uses the same `Dn` as the proposition, so it is neither stronger than the literature nor than the source's use (the source uses it in exactly this generality; quantifying over all `Ω : Type u` is the theorem's own generality, not a strengthening).
   - Not vacuous: its premise `IsIIDSeq` is satisfiable (probe), and its conclusion is a substantive a.s. statement, not provable trivially from junk values (under `prob`, `Dn` is the genuine supremum).
   - Goal-shape: the parameter *is* the proposition's conclusion universally quantified. VERDICTS §4.2 forbids parameters containing "this result's conclusion"; that rule targets formalization-introduced content. Here the source itself identifies the result with a named external theorem and gives no other argument (`main.tex:50`), so there is no faithful encoding other than this one; any decomposition would invent a proof the source does not give. Approved on that basis, with the explicit consequence: P01 can be at most CONDITIONAL, and the Lean check certifies only that the proposition as printed is an instance of the named theorem as encoded. The human check must confirm the encoding against a textbook statement of Glivenko–Cantelli (i.i.d., real-valued, arbitrary $F$, a.s. uniform convergence). Coordinator: if this reading of §4.2 is disputed, escalate; it is a rules-interpretation point, not a paper issue.
   - Provenance: (i), "cited by name, no `\cite`", source_loc `main.tex:50`. Acceptable; the absence of a bibliography entry is at most EDITORIAL. (Labelling it (ii) would change nothing in the treatment.)
   - Naming/location: declared only in `P01Stmt.lean`, in `namespace Paper.P01`; names `GCConclusion`, `IsIIDSeq`, `GlivenkoCantelli` do not occur in `L01Stmt.lean` or `T01Stmt.lean` (read in full). No (p) parameters.
   - "mathlib does not have it": the drafter's evidence was grep only. Gate evidence: (a) `gate_P01_mathlib_search.lean`: `#check` fails with `unknown identifier` for `ProbabilityTheory.glivenko_cantelli`, `ProbabilityTheory.glivenkoCantelli`, `ProbabilityTheory.tendsto_sup_abs_empiricalCDF`, `ProbabilityTheory.empiricalCDF`, `ProbabilityTheory.ecdf`, `ProbabilityTheory.empiricalMeasure`, `MeasureTheory.empiricalMeasure`, `glivenko_cantelli`, `GlivenkoCantelli`, `empiricalCDF`, `ecdf`, `ProbabilityTheory.Glivenko`, `open ProbabilityTheory in glivenko_cantelli_ae`, `open MeasureTheory in empirical_cdf`; neighbours `ProbabilityTheory.cdf`, `ProbabilityTheory.strong_law_ae`, `iIndepFun`, `IdentDistrib` do resolve. (b) case-insensitive `grep -rniE "glivenko|empirical|ecdf"` over `.lake/packages/mathlib/Mathlib`: the only hits are the substring `cdf`/`CDF` in `Probability/CDF.lean` and `preCDF`/`condCDF` in `Probability/Kernel/Disintegration/CondCDF.lean`, and "Empirically" in a RootSystem docstring; no Glivenko–Cantelli or empirical-CDF development. Evidence accepted.
   - Note (not required): mathlib has the strong law `ProbabilityTheory.strong_law_ae`, so the classical proof (SLLN at finitely many quantiles + monotonicity) could in principle discharge this parameter later; VERDICTS §4.2 says not to re-prove cited theory, so this is optional for the coordinator.
7. **Doubts about the source — none.** The statement is the classical theorem and is true. Missing `\cite` for Glivenko–Cantelli: EDITORIAL, not an issue. No dispatch of pv-issue-checker needed.

## TFAs ruled on

| Item | Ruling | Reason |
|---|---|---|
| none proposed | — | `prob`, `meas` are the meaning of "random variables", not extra premises |

## External parameters

| Name | Ruling | Provenance |
|---|---|---|
| `Paper.P01.GlivenkoCantelli` (P01Stmt.lean:26-28) | approved (flag: equals the cited theorem, which is the proposition itself; result at most CONDITIONAL; human check of the statement against the literature required) | (i), named only, main.tex:50, no `\cite` |

## Required changes

none

## Statement snapshot

Stmt copy (`pv_work/probes/gate/P01/gate_P01_stmtcopy.lean`, log `pv_work/logs/gate_P01_stmtcopy_1.log`):

```
TYPE HASHES (current file, 13 declarations)
Paper.P01.GCConclusion|def|th=2952115693|vh=4201125603|bi=icee
Paper.P01.GlivenkoCantelli|def|th=3944470172|vh=3716023181|bi=
Paper.P01.IsIIDSeq.casesOn|def|th=3011887410|vh=3650340092|bi=iciiiee
Paper.P01.IsIIDSeq.ident|thm|th=923172615|vh=-|bi=iciiee
Paper.P01.IsIIDSeq.indep|thm|th=547111927|vh=-|bi=iciie
Paper.P01.IsIIDSeq.meas|thm|th=2995437847|vh=-|bi=iciiee
Paper.P01.IsIIDSeq.mk|ctor|th=722617489|vh=-|bi=iciieeee
Paper.P01.IsIIDSeq.noConfusionType|def|th=2471320380|vh=3007878406|bi=iiiieee
Paper.P01.IsIIDSeq.noConfusion|def|th=1818434174|vh=3388153797|bi=iiiiiiie
Paper.P01.IsIIDSeq.prob|thm|th=594888100|vh=-|bi=iciie
Paper.P01.IsIIDSeq.recOn|def|th=3011887410|vh=3731874415|bi=iciiiee
Paper.P01.IsIIDSeq.rec|rec|th=1114318911|vh=-|bi=iciiiee
Paper.P01.IsIIDSeq|induct|th=2952115693|vh=-|bi=icee
```

Draft copy (`pv_work/probes/gate/P01/gate_P01_draftcopy.lean`, log `pv_work/logs/gate_P01_draftcopy_1.log`):

```
TYPE HASHES (current file, 2 declarations)
Paper.P01.P01_S1|thm|th=2071245090|vh=-|bi=eeceee
Paper.P01.P01_main|thm|th=1344600473|vh=-|bi=eeceee
```

## Overall verdict

The statement faithfully encodes `source/main.tex:45-47` under the DEFS conventions; the only external input is the named Glivenko–Cantelli theorem, encoded faithfully and non-vacuously, so P01 can be at most CONDITIONAL.

STATEMENT GATE: PASS
