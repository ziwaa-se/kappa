# T01 statement gate (Theorem thm:ks)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:07:32 EDT 2026
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` `93560a4728d397187835ecf6a558086f9efc3b63c9a28172ab764f3c29050bc3`
  - `pv_work/T01Draft.lean` `4bdceb83a3437d55e3cee32af35d2eabc052a65a8a0750053772a40bcb52b48b`
  - `pv_work/notes/T01_draft_notes.md` `2a0e363e1563af0b00b6318703fe9c7a1cf67bdc1ec972b02c774ce19ec75312` (leads only)
  - imported: `pv_work/Defs.lean` (DEFS gate PASS, `verification/audits/DEFS_gate.md`)
- Compilation: `scripts/pv_lean.sh check T01Draft` -> `exit=0 errors=0 sorry_warnings=7 nonstandard_axiom_lines=0`, log `pv_work/logs/T01Draft_2.log`.
- Snapshot probes (verbatim copies + `import PVTools` + `#pv_type_hashes_here`):
  `pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (exit=0, 0 sorry, log `pv_work/logs/gate_T01_stmtcopy_1.log`),
  `pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (exit=0, 7 sorry, log `pv_work/logs/gate_T01_draftcopy_1.log`).
- Mathlib probe: `pv_work/probes/gate/T01/gate_T01_checks.lean`, log `pv_work/logs/gate_T01_checks_1.log` (exit=1 by design: the unknown-identifier errors are the evidence).

## Source quotations

- `source/main.tex:24-27` def:edf; `:29-31` `D_n = sup_t |F_n(t) - F(t)|`, `F` the distribution function of `X_1`.
- `source/main.tex:53-58` (Theorem thm:ks): "If $X_1, X_2, \dots$ are independent and identically distributed with a continuous distribution function $F$, then $\sqrt{n}\, D_n$ converges in distribution to $\sup_{0 \le u \le 1} |B(u)|$, where $B$ is a Brownian bridge on $[0,1]$. The limit has the distribution function $K(z) = 1 - 2 \sum_{k \ge 1} (-1)^{k-1} e^{-2 k^2 z^2}$ for $z > 0$."
- `source/main.tex:60-63` (proof): "The convergence is Donsker's invariance principle for the empirical process \cite{donsker}, applied to the supremum, which is a continuous functional. The form of $K$ is due to Kolmogorov \cite{kolmogorov}."
- `source/main.tex:66-73`: Donsker, Ann. Math. Stat. 23 (1952) 277-281 ("Justification and extension of Doob's heuristic approach to the Kolmogorov--Smirnov theorems"); Kolmogorov, Giorn. Ist. Ital. Attuari 4 (1933) 83-91.
- "Brownian bridge" and "converges in distribution" are not defined in the source (standard notions).

## Mathlib evidence (own probe)

- Unknown identifiers: `ProbabilityTheory.TendstoInDistribution`, `MeasureTheory.TendstoInDistribution`, `ProbabilityTheory.IsBrownianBridge`, `ProbabilityTheory.BrownianMotion`, `ProbabilityTheory.IsBrownian`. `grep -rliE "brownian|InDistribution|Donsker|Skorokhod"` over `Mathlib/` hits only `LevyProkhorovMetric.lean` (lemma names `levyProkhorov_*_convergenceInDistribution`, about the weak topology on `ProbabilityMeasure`). So: no Brownian bridge, no Donsker, no Skorokhod space in this mathlib. Confirmed.
- Exists: `MeasureTheory.ProbabilityMeasure.tendsto_iff_forall_integral_tendsto` (weak convergence of probability measures iff `∫ f` converges for every bounded continuous `f`). The draft's `ConvInDist` is exactly this characterisation applied to the laws of `Y n` and `Z`; using it rather than the `ProbabilityMeasure` topology is a representation choice, faithful (see item 4). The drafter's remark "mathlib has no TendstoInDistribution" is correct by name; mathlib does have the weak topology, which is not needed here.
- `gaussianReal : ℝ → ℝ≥0 → Measure ℝ`, `gaussianReal_zero_var : gaussianReal μ 0 = dirac μ` (degenerate Gaussian at `u ∈ {0,1}` handled correctly).

## Item-by-item rulings

### 1. Hypotheses — PASS
- iid: `hmeas`, `hind : iIndepFun X P`, `hid : P.map (X k) = P.map (X 0)` (identical distribution; equivalent to `IdentDistrib` given measurability). Probability space `[IsProbabilityMeasure P]` and measurability are the content of "random variables" (main.tex:29). Index shift `X 0 = X_1` as in Defs.
- Continuous `F`: `hF : Continuous (cdfOf P X)` with `cdfOf` = `t ↦ P(X_1 ≤ t)` (main.tex:30-31, 54). Faithful.
- No extra premises; no hidden `variable`s/classes. `KSConclusion` is a conclusion structure, not a hypothesis bundle. No hypothesis states the conclusion: `hDon`, `hKol` are external parameters, ruled in item 6.
- Universe: `Ω : Type` (universe 0) instead of arbitrary universe. Mild loss of generality, consistent with the tools (also `Type`), so the tools are not stronger than their use. Acceptable representation choice (not a TFA, no mathematical content).

### 2. Conclusion — PASS
- `conv` (main.tex:54-56): `√n · D_n → supAbs B` in distribution. `supAbs B ω = ⨆ u : Icc 0 1, |B u ω|`; paths are continuous on the compact `[0,1]`, so the range is bounded and `⨆` is the true sup (no real-`iSup` junk).
- `cdf` (main.tex:56-57): `Q.real {supAbs B ≤ z} = Kfun z` for `z > 0`: "the limit has distribution function K" restricted to `z > 0` exactly as printed. `Q` probability, so `Q.real` has no `toReal` truncation.
- `Kfun z = 1 - 2 ∑' k:ℕ (-1)^k exp(-2 (k+1)² z²)`: index shift `k ↦ k+1` of `∑_{k≥1} (-1)^{k-1} e^{-2k²z²}`; correct. For `z > 0` the series is absolutely summable, so `tsum` is the true sum (`tsum` junk only at `z = 0`, excluded).
- Both clauses present; neither weakened nor strengthened (see item 3 for the bridge quantifier).

### 3. Quantifiers — PASS
- "where B is a Brownian bridge" is encoded universally: for every probability space `(Ω', Q)` (in `Type`) and every `B` with `IsBrownianBridge Q B`. Since `IsBrownianBridge` fixes all finite-dimensional laws and requires continuous paths on `[0,1]`, the law of `supAbs B` is the same for every such `B` (sup over a countable dense subset of `[0,1]`), so universal and existential readings agree whenever a bridge exists. The universal reading is the stronger of the two and is what the source means.
- Non-vacuity: the encoding is satisfiable (a Brownian bridge with every path continuous exists on e.g. `Ω' = C[0,1]` or `ℝ^ℕ` in `Type`: take a continuous modification and redefine paths to `0` on the null set; this preserves measurability of coordinates and all fdd). So the universal statement is not vacuous; existence is a standard fact the theorem does not need to assert (the source presupposes it). Not a TFA and no external parameter needed; existence would only be needed if a downstream result consumed a bridge, which none does.
- No constants; nothing to order.

### 4. Domains and details — PASS
- `ConvInDist P Y Q Z := ∀ f : ℝ →ᵇ ℝ, ∫ f(Y n) dP → ∫ f(Z) dQ`. This is the standard definition (convergence of laws against bounded continuous test functions; matches `ProbabilityMeasure.tendsto_iff_forall_integral_tendsto`). Integrals are Bochner: if `Y n` were not a.e.-strongly measurable the integral would be junk `0`. Here this trap does not fire: `D_n` is measurable (obligation S1; for continuous `F`, `|F_n − F|` is right-continuous in `t`, so the sup is a countable sup), and `supAbs B` is measurable (countable sup over rationals in `[0,1]` by path continuity). `f` bounded, so integrable on probability spaces.
- `IsBrownianBridge`: measurable coordinates; every path continuous on `[0,1]`; every finite linear combination `∑ a_i B(u_i)` with `u_i ∈ [0,1]` has law `N(0, ∑ a_i a_j (min(u_i,u_j) − u_i u_j))`. By Cramér–Wold this is exactly "centered Gaussian process with covariance `min(s,t) − st` on `[0,1]` with continuous paths", the standard Brownian bridge. `Real.toNNReal` never truncates (the covariance kernel is positive semidefinite, so the quadratic form is `≥ 0`). Values of `B` outside `[0,1]` are unconstrained and unused. "Every path" instead of "a.s. continuous paths" is a harmless normalisation (modification). Source does not define the notion: standard meaning, `FAIR_IMPLICIT_STEP`/`EDITORIAL`, not a domain ambiguity in my view.
- `D_n` at `n = 0` (junk `edf = 0`, `√0 = 0`) only affects the first term of a sequence; irrelevant for convergence. `n ≥ 1` therefore need not be carried.
- `ℝ≥0∞`/`ℝ`: only `Measure.real` on probability measures; no truncation.
- Non-periodic, real line; equality vs a.e.: S3 is correctly a.e. (see item 5).

### 5. Step obligations — PASS (all true as stated; assembly closes)
| Step | Source | True as stated? | Smuggling? |
|---|---|---|---|
| S1 `Measurable (Dn P X n)` (any `P`, measurable `X`) | silent (needed for main.tex:54-55 to be meaningful) | True. `cdfOf P X` is a real function of `t` only; for any measure it is monotone right-continuous up to the point where `P{X_1 ≤ t}` becomes infinite and `0` after, so the sup over `t` reduces to a sup over `ℚ` plus at most one extra point; if unbounded, real `⨆` is constant `0`. Either way measurable. (Not used in the planned assembly; harmless.) | No |
| S2 `F∘X_k` measurable, iid, `Unif[0,1]` | silent reduction behind main.tex:61 | True (probability integral transform; needs `F` continuous, `P` probability, identical laws: all present). | No |
| S3 `∀ᵐ ω, ∀ n, D_n(X) = D_n(F∘X)` | silent reduction | True: a.s. no `X_i` lies in a (countably many) flat interval `(a,b]` of `F`, giving `{X_i ≤ x} = {F(X_i) ≤ F(x)}`; the range of `F` contains `(0,1)`; the endpoint terms `t ≤ 0`, `t ≥ 1` contribute `0` a.s.; `n = 0` both sides equal `1`. Correctly stated a.e., not pointwise (pointwise would be false). | No |
| S4 a.e.-equal sequences share limits in `ConvInDist` | silent standard fact | True (`integral_congr_ae`; no measurability needed). | No |
| S5 `conv` clause | main.tex:61-62 | True given `DonskerUniformSup` + S2 + S3 + S4. | It equals the `conv` clause, but is derived from the uniform-case tool plus the visible reduction; not assumed. |
| S6 `cdf` clause | main.tex:62 | Immediate from `KolmogorovFormula`. | See item 6. |
| T01 | main.tex:53-58 | `⟨S5 …, S6 …⟩` closes it. | — |

S2–S4 are not printed in the source; they are the standard implicit reduction "continuous `F` ⇒ reduce to uniform samples", which is what the printed continuity hypothesis is for. They are proved, not assumed, so nothing is added as a hypothesis. Classification of the omission: see item 7.

### 6. External parameters — PASS
- `DonskerUniformSup` (provenance (i), `\cite{donsker}`, main.tex:61-62). For iid `Unif[0,1]` samples, `√n sup_t |G_n(t) − F_U(t)| → sup|B|` in distribution.
  - Not stronger than the source's use: the source invokes Donsker's principle for the empirical process of a general continuous `F`; the tool covers only uniform samples (weaker), and the general case is obtained via the visible, proved obligations S2–S4. True as stated (classical Kolmogorov–Smirnov limit in the uniform case; `Dn` measurable, `U` outside `[0,1]` only on a null set).
  - Goal-shaped? It is the uniform special case of the `conv` clause, not the clause itself. Folding the continuous-mapping step ("applied to the supremum, which is a continuous functional", main.tex:61-62) into the tool is acceptable: (a) the process-level statement needs weak convergence in `D[0,1]`/Skorokhod or `ℓ∞`, absent from mathlib (probe above), so a process-level parameter would be TRANSLATION_BLOCKED material anyway; (b) the cited paper itself (Donsker 1952, whose title is the justification of the Kolmogorov–Smirnov theorems) treats exactly the uniform empirical process and deduces the limit laws of the KS-type functionals, so the folded statement is within the cited content; (c) the step folded in is correct (sup is continuous on `D[0,1]` for the Skorokhod and uniform topologies), so folding hides no source gap. The continuous-mapping step and the reduction need **not** be separate visible parameters: the reduction is proved (S2–S4), the continuous-mapping step is covered by the citation.
  - Provenance label: the docstring's "(+ (ii) … folded in)" is inaccurate in classification terms. The step is not "asserted without proof" in a sense that needs its own label; register the tool in `EXTERNAL_TOOLS.md` as type (i), noting that the sup-functional step is covered by the cited Donsker 1952. Non-blocking (docstring/registry wording; no change to `th`/`vh`).
- `KolmogorovFormula` (provenance (i), `\cite{kolmogorov}`, main.tex:62). Equals the `cdf` clause; unavoidable, because the source's entire proof of that clause is this citation, and the parameter is exactly as strong as the source's use (`z > 0` only). Not a hidden gap. Note for the human check of this input: Kolmogorov 1933 proves `P(√n D_n ≤ z) → K(z)`; the identification of `K` as the law of `sup|B|` is the Doob 1949 / Donsker 1952 formulation (equivalently, Kolmogorov's limit combined with the `conv` clause and continuity of `K`). This is an attribution nuance, `EDITORIAL`, not a paper issue.
- Naming/location: both in `T01Stmt.lean`, `namespace Paper.T01`, no (p) consumed clauses (no predecessor used: P01 Glivenko–Cantelli is not consumed), no name clash with `Defs`, `L01Stmt`, `P01Stmt`.
- Shared helper definitions `ConvInDist`, `IsBrownianBridge`, `supAbs`, `Kfun` live in `T01Stmt.lean`; fine as long as no later result redeclares them.

### 7. Doubts about the source — preliminary only
- main.tex:61 — the reduction of a general continuous `F` to uniform samples (or, equivalently, `sup_t |B(F(t))| = sup_u |B(u)|` for continuous `F`) is not mentioned. Drafter: `EXPOSITION_GAP` candidate. My preliminary class: `FAIR_IMPLICIT_STEP` (standard textbook step; the printed continuity hypothesis exists precisely for it; Donsker 1952 itself states the reduction). Recommend the coordinator dispatch `pv-issue-checker` for a bounded ruling since the drafter raised it; the gate does not rule.
- main.tex:55-56 — "Brownian bridge" undefined. Drafter: `DOMAIN_CLARIFICATION`. My preliminary class: `EDITORIAL`/`FAIR_IMPLICIT_STEP` (unique standard meaning). No dispatch needed in my view; coordinator's call.
- No suspected `ERROR`; the statement is the classical Kolmogorov–Smirnov theorem.

## TFAs ruled on

| Item | Ruling | Reason |
|---|---|---|
| none proposed | — | `IsProbabilityMeasure P`, `Measurable (X k)` are the meaning of "random variables" (main.tex:29), not extra premises. `Ω : Type` is a representation choice. |

## External parameters

| Name | Ruling | Provenance | Notes |
|---|---|---|---|
| `Paper.T01.DonskerUniformSup` | approved | (i) `\cite{donsker}`, main.tex:61-62 | Uniform case only (weaker than the source's use); sup-functional step covered by the citation; register as (i), not "(i)+(ii)". |
| `Paper.T01.KolmogorovFormula` | approved | (i) `\cite{kolmogorov}`, main.tex:62 | Equals the `cdf` clause, whose source proof is this citation alone. Human check: bridge form is Doob/Donsker; Kolmogorov 1933 gives the limit of `P(√n D_n ≤ z)`. |

## Required changes

none (blocking). Non-blocking recommendation: when registering `DonskerUniformSup` in `verification/EXTERNAL_TOOLS.md`, record provenance as (i) with the note above; the Stmt docstring may be left as is (changing it now would need a new snapshot).

## Statement snapshot

`pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (log `pv_work/logs/gate_T01_stmtcopy_1.log`):

```
TYPE HASHES (current file, 15 declarations)
Paper.T01.ConvInDist|def|th=1410053113|vh=2138578313|bi=iicceeee
Paper.T01.DonskerUniformSup|def|th=3944470172|vh=682554806|bi=
Paper.T01.IsBrownianBridge|def|th=2415334394|vh=2670757772|bi=icee
Paper.T01.KSConclusion.casesOn|def|th=3203754544|vh=3390532978|bi=iciiiee
Paper.T01.KSConclusion.cdf|thm|th=1644673969|vh=-|bi=iciieececeeee
Paper.T01.KSConclusion.conv|thm|th=2880116105|vh=-|bi=iciieececee
Paper.T01.KSConclusion.mk|ctor|th=579299213|vh=-|bi=iciiee
Paper.T01.KSConclusion.noConfusionType|def|th=970117976|vh=758126966|bi=iiiieee
Paper.T01.KSConclusion.noConfusion|def|th=218919680|vh=3477106885|bi=iiiiiiie
Paper.T01.KSConclusion.recOn|def|th=3203754544|vh=2472699891|bi=iciiiee
Paper.T01.KSConclusion.rec|rec|th=4134065387|vh=-|bi=iciiiee
Paper.T01.KSConclusion|induct|th=2952115693|vh=-|bi=icee
Paper.T01.Kfun|def|th=3468892319|vh=3706699595|bi=e
Paper.T01.KolmogorovFormula|def|th=3944470172|vh=2789316998|bi=
Paper.T01.supAbs|def|th=1904166228|vh=835423947|bi=iee
```

`pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (log `pv_work/logs/gate_T01_draftcopy_1.log`):

```
TYPE HASHES (current file, 7 declarations)
Paper.T01.T01_S1|thm|th=253117068|vh=-|bi=iceeee
Paper.T01.T01_S2|thm|th=366503298|vh=-|bi=iceceeeee
Paper.T01.T01_S3|thm|th=2652757787|vh=-|bi=iceceeee
Paper.T01.T01_S4|thm|th=62494611|vh=-|bi=iicceeeeeee
Paper.T01.T01_S5|thm|th=1291308738|vh=-|bi=eiceceeeeeececee
Paper.T01.T01_S6|thm|th=4203296192|vh=-|bi=eececeeee
Paper.T01.T01|thm|th=2870806094|vh=-|bi=eeiceceeeee
```

## Overall verdict

The statement and obligations faithfully encode main.tex:53-58 with the proof route of main.tex:60-63; the two cited results are visible type-(i) parameters, not stronger than the source's use; the silent uniform reduction is proved, not assumed. The result can be at most CONDITIONAL.

STATEMENT GATE: PASS
