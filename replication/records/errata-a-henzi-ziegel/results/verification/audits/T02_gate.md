# T02 statement gate (Theorem 3.2, `thm:grow`)

- Reviewer: pv-gate (independent subagent; did not draft T02)
- Date: Mon Oct 12 22:20:59 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean` 83889dc3948f23de9c5686f4d94616c20b4e55122becebcb687059da41946fc2
  - `pv_work/T02Draft.lean` 7cb70c1e65c026d57daa7a4d9a2471fb867fb078bc5ced852049fcad2f3bf5a5
  - `pv_work/notes/T02_draft_notes.md` 487d6dfad060ef1a0e8002f8efa66bdb9a04253716a5a5d50561ff12b1888a31 (leads only)
  - `pv_work/Defs.lean` 1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c (gated, DEFS_gate_r2)
  - `pv_work/T01Stmt.lean` 011685b5b1e5a9f9d221fb49cf0478b632e812be2257bd23085e5357d6b1c8f2 (gated, T01_gate)
  - `source/VSIFP_02.tex` f25f769a356f6227038989247eb86582023e96a59198eb0d84ddf41f27bf7bec
- Compilation: `scripts/pv_lean.sh check T02Draft` -> `exit=0 errors=0 sorry_warnings=18 nonstandard_axiom_lines=0`, log `pv_work/logs/T02Draft_2.log`.
- Snapshot probes: `pv_work/probes/gate/T02/gate_T02_stmtcopy.lean` (exit=0, 0 sorry, log `pv_work/logs/gate_T02_stmtcopy_1.log`); `gate_T02_draftcopy.lean` (exit=0, 18 sorry, log `pv_work/logs/gate_T02_draftcopy_1.log`).

- Counterexample probe: `pv_work/probes/gate/T02/gate_T02_cex.lean` -> `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/gate_T02_cex_1.log`; `#print axioms` of `S3a_false`, `S3b_false`, `S8_false`, `S11_false`: `[propext, Classical.choice, Quot.sound]` only.

## Source quotations (read directly)

- Statement, `source/VSIFP_02.tex:153-172`: "Under the assumptions of Theorem 3.1, for any π₁ ∉ H_S, E_{π₁}{log(E_{p,q;λ})} is maximal in λ if and only if λ = (1−π₁) + π₁ (S(p,1)−S(q,1))/(S(p,0)−S(q,0)) for p > q, π₁ + (1−π₁)(S(p,0)−S(q,0))/(S(p,1)−S(q,1)) for p < q. The corresponding e-value equals E^{π₁}_{p,q}(y) = (1−π₁)/(1−κ_ν{[min,max)}) for y = 0, π₁/κ_ν{[min,max)} for y = 1, where for 0 ≤ a < b ≤ 1, κ_ν{[a,b)} = ∫_{[a,b)} θ dν(θ) / ν{[a,b)}."
- Assumptions of Theorem 3.1, l.145: S consistent, p, q ∈ (0,1), p ≠ q, mixing measure ν with ν{[min,max)} > 0; family E_{p,q;λ}, λ ∈ (0,1], eq:representation l.146-148.
- H_S l.139 (π ∈ [0,1]); e-value notion l.142; GROW notion l.151 (maximise E_P log E).
- Consistency l.71-74; mixture l.93-97; elementary score l.98-105: S_θ(p,0) = θ·1{p>θ}, S_θ(p,1) = (1−θ)·1{p≤θ}.
- Proof l.429-463: l.430 "All e-values for the given null hypothesis are of the form (6)"; l.431-434 g(λ); l.435 sign d(0)<0<d(1), continuity, g(0)=0, lim_{λ→1} g = −∞, "a maximum is attained at some λ ∈ [0,1)"; l.436-439 h, g, g'; l.442 critical point; l.446-448 λ₀ > 0; l.449-453 E(0), E(1); l.454 "d(y) = ∫ 1{p ≤ θ < q}(θ − y) dν(θ)"; l.456, l.460 κ identities and "> 1/π₁"; l.462 "The case p > q is analogous."

## Item 1. Hypotheses — PASS

- l.154 "Under the assumptions of Theorem 3.1": `hcons`, `hrep : T01.MixtureRep S ν`, `hp`, `hq`, `hpq`, `hν` are verbatim the hypotheses of `T01` (compared with `pv_work/T01Draft.lean:10-12`, which the T01 gate passed, including TFA-1 integrability inside `MixtureRep`). No new TFA.
- l.154 "for any π₁ ∉ H_S": `hπ : π₁ ∈ Icc 0 1 \ HS S p q`. π₁ is a probability (l.91, l.151 "alternative π₁"), and the alternative of Thm 3.1 is `[0,1] \ H_S` (l.145); `π₁ ∈ [0,1]` is notation, not an extra premise.
- Hidden hypotheses: none. `Conclusion` is a structure in the *conclusion*; `growLambda` a pure definition; no `variable`s/instances in `T02Stmt.lean`. The `variable`/`include` block of the draft applies only to steps; the main theorem `T02` lists its hypotheses explicitly.
- No conclusion-shaped hypothesis: `hT01 : T02_T01Consumed` is the e-value characterisation of Thm 3.1 (about arbitrary E), not about GROW λ or E^{π₁}.

## Item 2. Conclusion — PASS

- `grow_iff : ∀ lam, IsGrowLambda S p q π₁ lam ↔ lam = growLambda S p q π₁` = "maximal in λ iff λ = …" (l.154-160): an iff, so existence and uniqueness of the maximiser are both asserted, as printed.
- `growLambda`: `q < p` branch = l.157, else (= p < q, since p ≠ q) = l.158; checked symbol by symbol.
- `evalue`: `Erep S p q (growLambda …) y = EGrow ν p q π₁ y` for y ∈ {0,1} = l.161-167; `EGrow` uses `kappa ν (min p q) (max p q)` = κ_ν{[min,max)}.
- `IsGrowLambda` (Defs, gated A1) maximises over the family λ ∈ (0,1] of Thm 3.1 with `GrowFinite` replacing the −∞ values; this is the reading of "maximal in λ" for the family E_{p,q;λ} of eq:representation.
- Truth as stated (hand check): p < q, d0 = −A, d1 = N − A with N = ν[p,q), A = ∫_{[p,q)} θ dν, 0 < A < N. π₁ ∉ H_S ⟺ π₁ > κ = A/N. λ₀ = π₁ + (1−π₁)d0/d1 ∈ (0,1], with λ₀ = 1 iff π₁ = 1. For π₁ < 1, λ = 1 fails `GrowFinite` (E(0) = 0), g is strictly concave on [0,1), unique maximiser λ₀. For π₁ = 1, g(λ) = log(1+λ|h|) is strictly increasing on (0,1], unique maximiser 1 = λ₀. E(0) = (1−π₁)N/(N−A) = (1−π₁)/(1−κ), E(1) = π₁N/A = π₁/κ. Case p > q checked symmetrically (d0 = A, d1 = −(N−A), λ₀ = (1−π₁)+π₁ d1/d0, edge π₁ = 0 gives λ₀ = 1, E(0) = (1−π₁)/(1−κ), E(1) = π₁/κ). The Lean conclusion is true as stated, including the edge cases.

## Item 3. Quantifiers and constants — PASS

No constants. S, ν, p, q, π₁ universally quantified; λ is the bound variable of the iff; `growLambda` depends only on S, p, q, π₁, as printed.

## Item 4. Domains and details — PASS

- κ domain (l.168-171, "0 ≤ a < b ≤ 1"): used only at a = min p q > 0, b = max p q < 1. `(ν (Ico a b)).toReal`: ν(Ico a b) ≤ ν(Icc a b) < ∞ by `IsMixingMeasure` (compact ⊂ (0,1)), and > 0 by `hν`, so no ENNReal truncation; ∫_{Ico a b} θ dν is a genuine integral (bounded integrand, finite measure). No junk division.
- Log: `growthRate` uses `Real.log`; the −∞ values are excluded via `GrowFinite` in `IsGrowLambda` (Defs gate A1), so `Real.log 0 = 0` cannot manufacture a maximiser.
- Outcomes restricted to y ∈ {0,1}; equality pointwise on {0,1}; no a.e. issues; no periodicity; finiteness as above.
- A09 (λ range): the theorem ranges over (0,1] (family of Thm 3.1); the proof's "[0,1)" (l.435) is kept in S3a/S3b/S8 as printed, and the bridge is S9. Faithful.

## Item 5. Step obligations — PASS (faithful), with FOUR obligations FALSE AS STATED (S3a, S3b, S8 at π₁ = 1; S11 always)

| Step | Source | Faithful | True as stated |
|---|---|---|---|
| S1 | l.430-434 | yes (`hD` premise is S2's output, not goal-shaped) | yes |
| S2 | l.435 | yes | yes (d0 = −A < 0 < N − A = d1) |
| S3a | l.435 | yes, as printed | **NO** at π₁ = 1 (limit is log(1−h), finite) |
| S3b | l.435 | yes, as printed | **NO** at π₁ = 1 (g strictly increasing on [0,1), sup not attained) |
| S4 | l.435-439 | yes | yes (on [0,1): E(0) = 1−λ > 0, E(1) = 1−λh > 0; derivative correct) |
| S5 | l.440-443 | yes | yes (h < 0, l0 ∈ [0,1): denominators positive; algebra gives l0 = π₁ + (1−π₁)/h) |
| S6 | l.444-447 | yes | yes ((1−π₁)d0 + π₁d1 = d1·(π₁ + (1−π₁)/h), d1 > 0) |
| S7 | l.448 | yes | yes |
| S8 | SILENT (needed between l.435/442/448 and the conclusion) | yes, records the unstated step on the printed route [0,1) | **NO** at π₁ = 1 (λ₀ = 1, first conjunct `1 < 1`); true for π₁ < 1 |
| S9 | l.430, 435 (A09 bridge), first clause for p < q | yes | yes (see Item 2) |
| S10 | l.449-453 | yes | yes |
| S11 | l.454 | yes, as printed | **NO** — sign error: correct is d(y) = ∫1{p≤θ<q}(y−θ)dν; at y = 0 LHS = −A < 0 < A = RHS whenever the hypotheses hold |
| S12 | l.455-457 | yes (stated on d itself, sign-insensitive) | yes (N/(N−A) = 1/(1−κ)) |
| S13a | l.459-460 | yes | yes (N/A = 1/κ) |
| S13b | l.460 | yes | yes (π₁ > κ > 0) |
| S14 | l.461-462 | yes | yes |
| S15 | l.462 "analogous" | yes (whole p > q case, as T01 S10 precedent) | yes (checked by hand, Item 2) |

**Counterexample (compiled, no sorry, standard axioms only)**, `pv_work/probes/gate/T02/gate_T02_cex.lean`: ν = δ_{1/2}, S(p,y) = S_{1/2}(p,y), p = 1/4, q = 3/4, π₁ = 1. The probe proves `IsConsistent S`, `T01.MixtureRep S ν` (incl. integrability), `p,q ∈ (0,1)`, `p ≠ q`, `0 < ν[1/4,3/4)`, `1 ∈ [0,1] \ H_S`, `p < q`; here d0 = −1/2, d1 = 1/2, g(λ) = log(1+λ). It then proves the negations of the obligations, each universally quantified in the draft's binder order: `S3a_false`, `S3b_false`, `S8_false`, `S11_false`.

Consequences for the prover: S3a/S3b/S8 can only be proved under π₁ < 1 (they are not; the prover must record the failure at S3a for π₁ = 1, not add `π₁ < 1`); S11 must be recorded as false and not used (S12/S13a are stated on d directly and do not depend on S11's sign, so the κ identities are provable from `hrep` without S11, but the source's route to them passes through l.454 — the prover should record that the cited formula is wrong and that S12/S13a need the correct sign, not silently substitute it as the paper's step). Smuggling: no obligation contains the target conclusion as a hypothesis; S9/S14/S15 are obligations, not premises. Assembly: p < q: S9 (first clause) + S14 (second clause); q < p: S15; `p ≠ q` gives the trichotomy. Logically sound; blocked at π₁ = 1 by S3a/S3b/S8 and at S11 by the sign error.

## Item 6. External parameters — PASS

`T02_T01Consumed` (provenance (p)):
- Content: exactly the `→` direction of `Paper.T01.T01` (`pv_work/T01Draft.lean:10-14`), same hypotheses, same conclusion `∃ lam ∈ Ioc 0 1, ∀ y ∈ {0,1}, E y = Erep S p q lam y`, quantified over S, ν, p, q, E. It is the exact sentence used at l.430 ("All e-values for the given null hypothesis are of the form (6)"); not stronger than T01 (it is a strict consequence of T01's statement, which the T01 gate found true by hand), so not stronger than the use.
- Not goal-shaped (it says nothing about log-growth, λ₀ or κ).
- Location in predecessor: T01, l.144-149 (statement), "only if" direction, proof l.405-426. Applicability: T02's hypotheses are literally T01's (l.154), instantiated at the same S, ν, p, q. Note: T01's *proof* has a recorded defect (l.419, T01 gate S8), its statement is unaffected.
- Declared only in `T02Stmt.lean`, `namespace Paper.T02`, name `T02_T01Consumed` follows `<ID>_<PredID>Consumed`; grep over `pv_work` finds no other declaration of this name, of `growLambda` or of `Conclusion` in another Stmt file.
- Used or unused: it is a visible explicit hypothesis of `T02`, `T02_S9`, `T02_S15`. The Lean conclusion is about the family E_{p,q;λ} only (as is the printed statement l.154-167), so the clause is not logically needed; the prover/auditor must decide with `#pv_hyp_usage` (not by eye). If unused, the verdict must not be reported as conditional on T01 merely because the parameter is present.
- No "mathlib does not have it" claim (paper's own result).

## Item 7. Doubts about the source — recorded, not ruled

1. `source/VSIFP_02.tex:435` — "lim_{λ→1} g(λ) = −∞, so a maximum is attained at some λ ∈ [0,1)" fails for π₁ = 1 when p < q (π₁ = 1 ∉ H_S since d(1) > 0), and symmetrically for π₁ = 0 when p > q; λ₀ = 1 there and l.448 only shows λ₀ > 0. The theorem's conclusion remains true at these edge values (Item 2). Preliminary class: `PAPER_ARGUMENT_GAP` (case not covered by the given justification; possibly `EXPOSITION_GAP`). Compiled witness: `gate_T02_cex.lean`. Recommend dispatching pv-issue-checker.
2. `source/VSIFP_02.tex:454` — printed d_{p,q}(y) = ∫1{p≤θ<q}(θ−y)dν has the wrong sign; from l.98-105, d(y) = ∫1{p≤θ<q}(y−θ)dν (contradicts d(0) < 0 at l.435). l.456 is computed consistently with the wrong sign, and the ratios at l.456/460 are sign-invariant, so the final formula is unaffected. Preliminary class: `PAPER_ARGUMENT_GAP` (minor; possibly `EDITORIAL`). Compiled witness: `S11_false`. Recommend dispatching pv-issue-checker.
3. Silent step S8 (λ₀ < 1, maximum not at 0, uniqueness): for π₁ < 1 a standard strict-concavity argument (likely `FAIR_IMPLICIT_STEP`); at π₁ = 1 it is part of issue 1. Not a separate issue.
4. l.462 "The case p > q is analogous": checked by hand, true; drafter's notes item 5 not a paper issue as far as the gate can see.
5. l.456 stray `\}`: `EDITORIAL`.

## TFAs ruled on

| id | premise | ruling | reason |
|---|---|---|---|
| (none new) | — | — | Hypotheses are T01's (TFA-1 inherited via `MixtureRep`, approved in T01 gate); `π₁ ∈ [0,1]` is notation. |

## External parameters

| name | provenance | ruling |
|---|---|---|
| `Paper.T02.T02_T01Consumed` | (p), T01 l.144-149 "only if" direction; applicability: identical hypotheses (l.154) | APPROVED (usage to be decided by `#pv_hyp_usage`) |

## Required changes

None. The four false-as-stated obligations (S3a, S3b, S8, S11) are faithful encodings of printed (or silently required) steps and must stay as they are; the prover records the failures.

## Statement snapshot

`gate_T02_stmtcopy.lean` (`pv_work/logs/gate_T02_stmtcopy_1.log`):
```
TYPE HASHES (current file, 11 declarations)
Paper.T02.Conclusion.casesOn|def|th=4172177218|vh=3986814362|bi=iiiiiiee
Paper.T02.Conclusion.evalue|thm|th=844893269|vh=-|bi=iiiiieee
Paper.T02.Conclusion.grow_iff|thm|th=1907422297|vh=-|bi=iiiiiee
Paper.T02.Conclusion.mk|ctor|th=2684892096|vh=-|bi=iiiiiee
Paper.T02.Conclusion.noConfusionType|def|th=3729421279|vh=3088651444|bi=iiiiieee
Paper.T02.Conclusion.noConfusion|def|th=2054055164|vh=3181903530|bi=iiiiiiiie
Paper.T02.Conclusion.recOn|def|th=4172177218|vh=2069104762|bi=iiiiiiee
Paper.T02.Conclusion.rec|rec|th=2169576532|vh=-|bi=iiiiiiee
Paper.T02.Conclusion|induct|th=354930018|vh=-|bi=eeeee
Paper.T02.T02_T01Consumed|def|th=3944470172|vh=3775110705|bi=
Paper.T02.growLambda|def|th=2505869512|vh=3597442934|bi=eeee
```

`gate_T02_draftcopy.lean` (`pv_work/logs/gate_T02_draftcopy_1.log`):
```
TYPE HASHES (current file, 18 declarations)
Paper.T02.T02_S10|thm|th=213802703|vh=-|bi=eeeeeeeeeeeee
Paper.T02.T02_S11|thm|th=1679423657|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02_S12|thm|th=1741795830|vh=-|bi=eeeeeeeeeeeee
Paper.T02.T02_S13a|thm|th=4232840846|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02_S13b|thm|th=899594411|vh=-|bi=eeeeeeeeeeeee
Paper.T02.T02_S14|thm|th=3521707852|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02_S15|thm|th=1769765856|vh=-|bi=eeeeeeeeeeeeee
Paper.T02.T02_S1|thm|th=2204667332|vh=-|bi=eeeeeeeeeeeeee
Paper.T02.T02_S2|thm|th=73419719|vh=-|bi=eeeeeeeeeeeee
Paper.T02.T02_S3a|thm|th=2448909884|vh=-|bi=eeeeeeeeeeeee
Paper.T02.T02_S3b|thm|th=4046222703|vh=-|bi=eeeeeeeeeeeee
Paper.T02.T02_S4|thm|th=2515101225|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02_S5|thm|th=1126454576|vh=-|bi=eeeeeeeeeeeeeeeee
Paper.T02.T02_S6|thm|th=3404791811|vh=-|bi=eeeeeeeeeeeeeeee
Paper.T02.T02_S7|thm|th=379828196|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02_S8|thm|th=2498024117|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02_S9|thm|th=429470870|vh=-|bi=eeeeeeeeeeeeeee
Paper.T02.T02|thm|th=4146251959|vh=-|bi=eeeeeeeeeeeee
```

## Overall verdict

The statement of Theorem 3.2 is faithful and true as stated (including π₁ = 1 / π₁ = 0 edges); the consumed clause is the exact l.430 sentence and approved. The obligations faithfully encode the printed route; S3a, S3b, S8 (at π₁ = 1) and S11 (sign at l.454) are false as stated, with a compiled counterexample, and are recorded as suspected paper issues, not repaired. Proof work may begin; the prover must stop at those steps.

STATEMENT GATE: PASS
