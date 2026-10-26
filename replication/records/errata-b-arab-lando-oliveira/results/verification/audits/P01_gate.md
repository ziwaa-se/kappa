# P01 statement gate (Proposition 2.5, `prop:ITS-dens`)

- Reviewer: pv-gate (independent subagent, Claude Opus), first gate report
- Date: Mon Oct 12 22:04:02 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` d4e4b58a1d46ecfb82ea8abee5f9be5aad6dd9ed769acd7a5f873d96a0d60908
  - `pv_work/P01Draft.lean` 3cb073504701b01f50d49d760ac4724e62404c276af5df0ed0d0f5c8ea003591
  - `pv_work/notes/P01_draft_notes.md` 5a68efed9fb11ec1fb4bfe0b06f4bf7eac06bd495f675a5c38978eb4e0e3fb69 (leads only)
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_2.log`.
- Probes (`pv_work/probes/gate/P01/`): `gate_P01_stmtcopy.lean` (exit 0, log `pv_work/logs/gate_P01_stmtcopy_1.log`), `gate_P01_draftcopy.lean` (exit 0, 8 sorry warnings, log `pv_work/logs/gate_P01_draftcopy_1.log`), `gate_P01_probe.lean` (exit 1: the 4 errors are exactly the expected failed `#check`s at lines 8-11; the S4 counterexample `example` compiles with no error, log `pv_work/logs/gate_P01_probe_1.log`).

## Source quotations (read directly)

- `source/SuperParetoPaper-v12.tex:111`: "increasing" = non-decreasing, "decreasing" = non-increasing; "a function v is said to be subadditive if v(x+y) <= v(x)+v(y), for every x,y in the domain of v ... a function v defined in [0,+infty) is said to be star-shaped if v(0)=0 and v(x)/x is increasing. If v(x)/x is decreasing, v is called anti-star-shaped."
- `:113`: F_X, Fbar_X = 1 - F_X; "In general, we shall not be assuming the existence of densities."
- `:117`, `:119`: stochastic order; results depend only on the cdf.
- `:121`: "F^-_{1/X}(x) = 1 - F_X(1/x) is generally referred to as the inverted distribution of X".
- `:124`: "We say that a random variable X such that F_X(0)=0 is ITS ... if F^-_{1/X} is subadditive."
- `:147`: "It is well-known that, for nonnegative functions, concavity implies subadditivity."
- `:150` (statement): "Assume the nonnegative random variable X has density f_X such that its hazard rate r_X(x)=f_X(x)/Fbar_X(x) <= 1/x, for x>0. Then X is ITS."
- `:153` (proof): "the derivative of (1/x)(1-F_X(1/x)) has the same sign as (1/x) f_X(1/x) + F_X(1/x) - 1, which, according to the assumption, is easily seen to be negative. It follows that 1-F_X(1/x) is anti-star-shaped, as it vanishes at zero, therefore, it is subadditive."

## Item 1 — Hypotheses: PASS

- "nonnegative random variable X": law `μ`, `[IsProbabilityMeasure μ]`, `hnn : μ (Iio 0) = 0`. Faithful (`:119`: only the law matters).
- "has density f_X": `f : ℝ → ℝ≥0∞`, `hf : Measurable f`, `hdens : μ = volume.withDensity f`. Measurability is part of the definition of a density; not an extra premise.
- "r_X(x) <= 1/x for x>0": `hhaz : ∀ x>0, hazard μ f x ≤ 1/x`, pointwise for the given version `f` (literal reading; the "exists a density such that" of the source is equivalent to the universally quantified `f` as hypothesis). Lean division makes the hypothesis vacuous where `Fbar = 0` and `toReal` makes it vacuous where `f = ∞`: both weaken the hypothesis (theorem stronger), and I checked the theorem stays true (see Item 5, S4/S5: under the hypotheses `Fbar > 0` on `(0,∞)` anyway, since `(log Fbar)' >= -1/s` a.e. forces `Fbar(t) >= Fbar(a) a/t`).
- No hidden hypotheses: no `variable`s, no structures, no type classes beyond the probability instance; the imported `P01Stmt` defs carry no assumptions.
- Extra premise `hX04`: see Item 6 (rejected as an external parameter).
- No hypothesis states the conclusion or an equivalent.

## Item 2 — Conclusion: PASS

`InvSub μ := F μ 0 = 0 ∧ SubadditiveOnPos (invDist μ)` encodes Def 2.2 (`:124`) including the `F_X(0)=0` side condition. Domain `(0,∞)` for `F^-_{1/X}`: for X >= 0 with F_X(0)=0, `P(1/X < x) = 1 - F_X(1/x)` exactly for `x>0`, and `P(1/X<x)=0` for `x<=0`; subadditivity on all of ℝ (or `[0,∞)`) is then equivalent to subadditivity on `(0,∞)` (cases with a nonpositive argument are trivial by monotonicity and nonnegativity). Consistent with `Paper.L01.IsInvSub` (same content) and with Lemma 2.3 (`:133`, `x >= 0`). Not weakened, not strengthened.

## Item 3 — Quantifiers / constants: PASS

No constants. `f` is universally quantified as a hypothesis, which matches "has density f_X such that ...".

## Item 4 — Domains and details: PASS

- non-periodic, on ℝ; pointwise hazard bound for the given version (a.e. would be a weaker hypothesis; the literal reading is pointwise, acceptable).
- `F_X(0)=0`: follows from `hnn` plus absence of atoms (`withDensity` of Lebesgue); obligation S1, true.
- `ℝ≥0∞`/`ℝ`: `cdf` real-valued in [0,1]; `(f x).toReal` only truncates on `{f = ∞}`, a null set, and only weakens `hhaz`. No `ofReal` traps.
- `F(∞)=1` ("vanishes at zero"): see S6 below.

## Item 5 — Step obligations: FAIL (one obligation false as stated)

| Obligation | Source | True as stated? | Remarks |
|---|---|---|---|
| S1 `F μ 0 = 0` | `:124` (implicit) | true | from `hnn` + no atom |
| S2 a.e. `HasDerivAt (F μ) (f u).toReal u` | `:153` (silent) | true | Lebesgue differentiation (f integrable since `μ` is a probability) |
| S3 derivative of `(1/t)(1-F(1/t))` | `:153` "same sign as" | true | checked: `-(1/x^2)(1-F(1/x)) + (1/x)(d/x^2) = x^{-2}((1/x)d + F(1/x) - 1)` |
| S4 pointwise `(1/x) f(1/x).toReal + F(1/x) - 1 ≤ 0` from `hhaz` only | `:153` "easily seen to be negative" | **FALSE as stated** | see below |
| S5 `AntitoneOn (invDist μ x / x) (Ioi 0)` | `:153` "It follows that ... anti-star-shaped" | true | with s=1/x: `s Fbar(s)` is locally AC on `(0,∞)` with derivative `Fbar - s f >= 0` a.e. (on `{Fbar=0}`, f=0 a.e.); no use of `hnn` needed |
| S6 `AntiStarShaped (vExt μ)` from S5 | `:153` "as it vanishes at zero" | true | but trivially so: `vExt 0 = 0` holds by definition; the limit `1 - F(1/x) -> 0` (x -> 0+) is not represented (recommendation N1) |
| S7 `SubadditiveOnPos (invDist μ)` from S6 + X04 | `:153` "therefore, it is subadditive" | true | after removing X04 still true (Item 6) |
| main | `:150` | true | |

**S4 is false as stated (LESSONS 10 pattern).** Its only hypothesis is `hhaz`; `μ` and `f` are otherwise arbitrary. Where `Fbar μ (1/x) = 0`, `hazard = f/0 = 0` makes `hhaz` vacuous, but the conclusion requires `f(1/x) = 0`. Lean-checked counterexample in `pv_work/probes/gate/P01/gate_P01_probe.lean` (lines 15-37, compiles): `μ = dirac 0`, `f ≡ 1`, `x = 1` gives `1 ≤ 0`. Even with the density context added, the pointwise version at `x` is true only through the non-source argument that `Fbar > 0` on `(0,∞)`; the source's step ("according to the assumption") is the pointwise bound where `r_X` is defined, plus `f = 0` a.e. where `Fbar = 0`. Required change R2 below.

Assembly: main = S1 ∧ S7(S6(S5(S2,S3,S4))). With R1 and R2 applied, the assembled obligations yield `P01_main`. No obligation smuggles the conclusion or a stronger intermediate.

## Item 6 — External parameters: FAIL (X04 rejected as a parameter)

`AntiStarShapedSubadditive` (X04, provenance (v)), `P01Stmt.lean:46-51`.

- Not stronger than the source's use (adds nonnegativity, concludes only for x,y>0): OK. Not goal-shaped: OK. True: OK. Namespace `Paper.P01`, declared only in `P01Stmt.lean`, no name clash with `L01Stmt.lean` / `P02Stmt.lean`: OK.
- Mathlib evidence (my own): `#check @StarConvex.subadditive`, `@ConcaveOn.subadditive`, `@ConcaveOn.le_add` -> unknown constant; `AntitoneOn.subadditive` -> no such field; `Subadditive : (ℕ → ℝ) → Prop` (Fekete, sequences only); `Convex_subadditive_le` is about convexity of sublevel sets of subadditive functions. Grep `anti.?star|starshaped|star_shaped|subadditive` over `Mathlib/` finds no anti-star-shaped notion. So "no mathlib interface" is correct.
- **Ruling: provable infrastructure, not an external parameter.** VERDICTS §4.2 admits a (v) parameter for a silently used standard fact only "if proving it would need a lot of infrastructure". Here it needs none: for x,y>0, `v(x+y) = x·(v(x+y)/(x+y)) + y·(v(x+y)/(x+y)) ≤ x·(v x/x) + y·(v y/y) = v x + v y` by antitonicity of `v t / t` on `(0,∞)` alone (neither nonnegativity nor `v 0 = 0` is even needed). It is also the paper's own proof step at `:153` ("therefore, it is subadditive"), i.e. part of what is being checked, and keeping it would make P01 CONDITIONAL for no reason. Proving it by the standard argument is a FAIR_IMPLICIT_STEP, not a change of route. Required change R1.

## Item 7 — Doubts about the source (preliminary only; not ruled here)

| # | Location | Preliminary class | Note |
|---|---|---|---|
| D1 | `:153` | FAIR_IMPLICIT_STEP (possible EXPOSITION_GAP) | "the derivative of ..." presumes differentiability; with a density (`:113` says densities not generally assumed, but here one is) F is only a.e. differentiable; passing from a.e. sign to monotonicity needs absolute continuity, which holds since F has a density. Recommend pv-issue-checker only to confirm the class. |
| D2 | `:150` | FAIR_IMPLICIT_STEP | `r_X` undefined where `Fbar_X = 0`; under the hypothesis `Fbar > 0` on `(0,∞)` anyway, and `f=0` a.e. on `{Fbar=0}`; no paper issue expected. |
| D3 | `:153` "negative" | EDITORIAL | only `<= 0` follows; `<= 0` suffices. |
| D4 | `:153` "vanishes at zero" | FAIR_IMPLICIT_STEP | `F(∞)=1`; and anti-star-shapedness refers to the extension `v(0)=0`. |
| D5 | `:124` vs proof | FAIR_IMPLICIT_STEP | `F_X(0)=0` not verified in the proof; follows from nonnegativity + density. |

None of these is ruled here; D1 may be dispatched to pv-issue-checker (low priority).

## TFAs ruled on

| Premise | Ruling | Reason |
|---|---|---|
| (none proposed; `hf : Measurable f` and `IsProbabilityMeasure` are definitional, not TFAs) | — | — |

## External parameters

| Name | Type | Ruling |
|---|---|---|
| `Paper.P01.AntiStarShapedSubadditive` (X04) | (v) | **Rejected** as a parameter: elementary, no infrastructure needed, and it is the paper's own step at `:153`; must be proved (R1). Mathlib-absence evidence itself is correct. |

## Required changes

- **R1** (X04). In `pv_work/P01Stmt.lean` delete lines 46-51 (`AntiStarShapedSubadditive` and its docstring). In `pv_work/P01Draft.lean` delete the binder `(hX04 : AntiStarShapedSubadditive)` from `P01_main` (line 11) and from `P01_S7` (line 71), so that S7 reads `theorem P01_S7 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h6 : AntiStarShaped (vExt μ)) : SubadditiveOnPos (invDist μ)`; update S7's docstring ("Uses: S6; standard anti-star-shaped ⇒ subadditive argument, proved in place"). Remove X04 from the notes' external-input table (and from `EXTERNAL_TOOLS.md`/`RESULTS.json` if already registered — coordinator).
- **R2** (S4, false as stated). Replace `P01_S4` (Draft lines 47-50) by the a.e. version in the density context:
  ```lean
  theorem P01_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
      (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
      (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
      ∀ᵐ x ∂(volume : Measure ℝ), 0 < x →
        (1 / x) * (f (1 / x)).toReal + F μ (1 / x) - 1 ≤ 0
  ```
  (docstring: source `:153`; on `{Fbar > 0}` it is the hazard bound; on `{Fbar = 0}` `f = 0` a.e. since `μ` puts no mass there — implicit step D2.) This is true and is what S5 consumes together with S2, S3.

Non-blocking recommendations:
- **N1** (S6 fidelity). Either add `theorem P01_S6a (μ : Measure ℝ) [IsProbabilityMeasure μ] : Filter.Tendsto (invDist μ) (nhdsWithin 0 (Ioi 0)) (nhds 0)` labelled `:153` "as it vanishes at zero", or reword S6's docstring to say that `v(0)=0` is fixed by the representation `vExt` and the limit is not used. Not needed for the assembly.
- **N2**. `[IsProbabilityMeasure μ]` in S6 and S7 is unused; harmless.

## Statement snapshot (of the reviewed, pre-amendment text)

`pv_work/probes/gate/P01/gate_P01_stmtcopy.lean` (log `pv_work/logs/gate_P01_stmtcopy_1.log`):
```
TYPE HASHES (current file, 9 declarations)
Paper.P01.AntiStarShapedSubadditive|def|th=3944470172|vh=3953804906|bi=
Paper.P01.AntiStarShaped|def|th=4254974927|vh=810757625|bi=e
Paper.P01.Fbar|def|th=390107078|vh=3618553444|bi=ee
Paper.P01.F|def|th=390107078|vh=2204204658|bi=ee
Paper.P01.InvSub|def|th=3905129696|vh=244172552|bi=e
Paper.P01.SubadditiveOnPos|def|th=4254974927|vh=4121237076|bi=e
Paper.P01.hazard|def|th=3114261911|vh=311329179|bi=eee
Paper.P01.invDist|def|th=390107078|vh=4282577196|bi=ee
Paper.P01.vExt|def|th=390107078|vh=2525779558|bi=ee
EXIT=0
```

`pv_work/probes/gate/P01/gate_P01_draftcopy.lean` (log `pv_work/logs/gate_P01_draftcopy_1.log`):
```
TYPE HASHES (current file, 8 declarations)
Paper.P01.P01_S1|thm|th=285931251|vh=-|bi=eceee
Paper.P01.P01_S2|thm|th=1943743511|vh=-|bi=eceee
Paper.P01.P01_S3|thm|th=480467246|vh=-|bi=eeeee
Paper.P01.P01_S4|thm|th=2605240013|vh=-|bi=eeeee
Paper.P01.P01_S5|thm|th=3868911127|vh=-|bi=eceeee
Paper.P01.P01_S6|thm|th=2949884150|vh=-|bi=ece
Paper.P01.P01_S7|thm|th=1556209570|vh=-|bi=eece
Paper.P01.P01_main|thm|th=2455383967|vh=-|bi=eeceeeee
EXIT=0
```
This snapshot is superseded after R1/R2; the r2 check must produce the new snapshot.

## Overall verdict

Statement of `P01_main` (apart from the `hX04` binder) is faithful; required changes R1 (X04 is provable, not a parameter) and R2 (S4 false as stated) must be made before proof work; then an amendment check (`P01_gate_r2.md`).

STATEMENT GATE: PASS_WITH_AMENDMENTS
