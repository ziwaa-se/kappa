# Statement gate: DEFS (shared definitions `pv_work/Defs.lean`)

- Reviewer: pv-gate (independent subagent; did not draft these files)
- Date: Mon Oct 12 21:54:56 EDT 2026 (from `date`)
- Reviewed file: `pv_work/Defs.lean`, sha256 `3a2ea06265d3aa25dd611adddf682811adc076eb876ea0e5cffad7a003b8d091` (`python3 scripts/pv_snapshot.py hash`)
- Compilation: `scripts/pv_lean.sh check Defs` -> `RESULT Defs mode=check exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/Defs_4.log`
- Snapshot probe: `pv_work/probes/gate/DEFS/gate_DEFS_stmtcopy.lean` -> exit=0, log `pv_work/logs/gate_DEFS_stmtcopy_1.log`
- Counterexample probe: `pv_work/probes/gate/DEFS/gate_DEFS_logzero.lean` -> exit=0, errors=0, nonstandard_axiom_lines=0, log `pv_work/logs/gate_DEFS_logzero_2.log`
- Draft notes `pv_work/notes/DEFS_draft_notes.md` were read as leads only; every ruling below is from the source text.

## Source quotations

- l.70-74: "A scoring function $S=S(p,y)$ maps a forecast probability $p$ and an observation $y$ to a numerical score ... $\mathbb{E}_\pi\{S(\pi,Y)\}\le\mathbb{E}_\pi\{S(p,Y)\}$ for all $p,\pi\in[0,1]$, where $\mathbb{E}_\pi$ denotes the expected value under the assumption that $Y=1$ with probability $\pi$ ... strictly consistent if equality ... only holds for $p=\pi$. Well-known examples are the Brier score $(y-p)^2$ and the logarithmic score $-\log(|1-y-p|)$."
- l.91: $\mathbb{E}_\pi$ for the probability $\pi\in[0,1]$ of a binary event.
- l.93-97: "all consistent scoring functions are of the form $S(p,y)=\int_{[0,1]}S_\theta(p,y)\,d\nu(\theta)$, where $\nu$ is a locally finite Borel measure on $(0,1)$".
- l.98-105: $S_\theta(p,y)=(\theta-y)\{1(p>\theta)-1(y>\theta)\}$ = $\theta$ ($y=0,p>\theta$), $1-\theta$ ($y=1,p\le\theta$), $0$ otherwise.
- l.137: one-period setting, $p,q$ fixed numbers in $(0,1)$.
- l.139-140: $H_S=[\pi\in[0,1]:\mathbb{E}_\pi\{S(p,Y)-S(q,Y)\}\le0]$, $H=[\pi\in[0,1]:\sup_{\theta\in[0,1]}\mathbb{E}_\pi\{S_\theta(p,Y)-S_\theta(q,Y)\}\le0]$.
- l.142: for disjoint $H,H'$, $E$ has null $H$ and alternative $H'$ if $\mathbb{E}_P(E)\le1$ on $H$, $\mathbb{E}_Q(E)>1$ on $H'$; l.78: an e-value is a random variable $E\ge0$.
- l.145-148: $E_{p,q;\lambda}(y)=1+\lambda\,\frac{S(p,y)-S(q,y)}{|S(p,1\{p>q\})-S(q,1\{p>q\})|}$, $\lambda\in(0,1]$.
- l.151, 154: GROW: $E$ maximizes $\mathbb{E}_P\{\log(E)\}$; Theorem 2: "$\mathbb{E}_{\pi_1}\{\log(E_{p,q;\lambda})\}$ is maximal in $\lambda$ iff $\lambda=\dots$" (l.156-159).
- l.163-171: $E^{\pi_1}_{p,q}$ and $\kappa_\nu\{[a,b)\}=\int_{[a,b)}\theta\,d\nu/\nu\{[a,b)\}$ for $0\le a<b\le1$.
- l.193-196: $E^{\pi_1*}_{p,q}(y)=(1-\pi_1)/(1-p)$ ($y=0$), $\pi_1/p$ ($y=1$).

## Item-by-item rulings

### 1. Hypotheses hidden in definitions — PASS
No `variable`, class or structure. `IsMixingMeasure` = carried by (0,1) + finite on compacts inside (0,1): faithful to "locally finite Borel measure on (0,1)" (l.97); `Measure ℝ` is Borel. `IsEValue` omits the disjointness precondition of l.142; this makes the predicate defined in more cases, harmless (in all uses $H'=[0,1]\setminus H$). Nonnegativity only at $y\in\{0,1\}$ is faithful ($E$ is a function of $Y\in\{0,1\}$).

### 2. Content of each definition — FAIL for `IsGrowLambda` only (see A1); PASS otherwise
- `expPi`, `IsConsistent`, `IsStrictlyConsistent`, `HS`: faithful to l.72-74, 91, 139.
- `elemScore`: `θ < p` = $1(p>\theta)$, `θ < y` = $1(y>\theta)$; matches l.99 literally.
- `HAll` (focus point): `∀ θ ∈ [0,1], f θ ≤ 0` vs `sup_θ f θ ≤ 0`. For $y\in\{0,1\}$, $|S_\theta|\le1$, so the set $\{f(\theta)\}$ is nonempty and bounded by 2; `csSup_le_iff` gives the equivalence (and with sup in the extended reals it is literally equivalent). PASS.
- `mixtureScore`: integral over `Icc 0 1` with ν null off (0,1) = integral over (0,1), as printed. Bochner integral: see binding note N1.
- `Erep` (focus point): `1 + lam * (Sp - Sq) / |…|` parses as `1 + (lam*(Sp-Sq))/|…|`, same value as l.147; `if q < p then 1 else 0` = $1\{p>q\}$. Total division gives a junk value 1 only when the denominator is 0; under the T01 hypotheses ($p\ne q$, $\nu[\min,\max)>0$, plus N1) the denominator is $\int_{[\min,\max)}(1-\theta)d\nu>0$ (p>q) or $\int\theta\,d\nu>0$ (p<q). PASS.
- `kappa` (focus point): for $a,b\in(0,1)$, $[a,b)\subset[a,b]$ compact in (0,1), so $\nu[a,b)<\infty$ and `toReal` is exact; $\int_{[a,b)}\theta\,d\nu$ finite. Division by zero only if $\nu[a,b)=0$, excluded by the T01/T02 hypothesis. If $b=1$ (allowed by l.168) `toReal ∞ = 0` would be a truncation trap, but κ is only applied at $p,q\in(0,1)$ (l.164-165). PASS, with note N3.
- `EGrow`, `EGrowAll`: faithful for $y\in\{0,1\}$ (`else` branch = $y=1$). PASS, note N4.
- `growthRate` / `IsGrowLambda` (focus point, λ range): the range $(0,1]$ is the family of Theorem 1 (l.145), as Theorem 2 maximizes over that family; the range choice is PASS (A09 concerns the proof, not this definition). **But the encoding of $\log$ is wrong**: `Real.log 0 = 0` (and `Real.log x = log|x|` for x<0). At $\lambda=1$, $E_{p,q;1}(1\{p>q\})=1-1=0$, so the paper's $\mathbb{E}_{\pi_1}\log E_{p,q;1}=-\infty$ whenever $\pi_1$ gives that outcome positive probability, whereas Lean assigns it the finite value $(1-\pi_1)\log E(0)$ (p>q), which dominates every $\lambda<1$. Consequence: Lean `IsGrowLambda` holds at $\lambda=1$ and fails at the paper's maximizer. Machine-checked: `gate_probe_not_grow_half` proves `¬ IsGrowLambda (fun p y => (p-y)^2) (3/5) (2/5) (1/4) (1/2)` (Brier, $\kappa=1/2$, $\pi_1=1/4\notin H_S=[1/2,1]$; paper's formula l.157 gives $\lambda=3/4-1/4=1/2$). This is an `ENCODING_ERROR` that would manufacture a false "paper ERROR" in Theorem 2. FAIL -> amendment A1.

### 3. Quantifiers / constants — PASS
No constants. `IsConsistent` quantifies $p,\pi\in[0,1]$ as l.74; `HAll` quantifies $\theta\in[0,1]$ as l.140 (including the degenerate θ=0,1 as printed).

### 4. Domains and details — PASS with binding notes
- Equality vs a.e.: none involved. Measurability: ν is Borel; integrands are measurable step functions.
- Truncation traps: `kappa` `toReal` (N3), Bochner integral of non-integrable function = 0 (N1), `Real.log` of 0 (A1, FAIL).
- **The drafter's note A01 claim is false**: "for p,q in (0,1) the integrand is supported in a compact subinterval, so the integral is genuine". $S_\theta(p,0)=\theta\,1\{\theta<p\}$ is supported on $(0,p)$ and $S_\theta(p,1)=(1-\theta)1\{\theta\ge p\}$ on $[p,1)$, neither compact in (0,1). Example: $d\nu=\theta^{-3}d\theta$ is locally finite on (0,1) (l.97) but $\int_{(0,p)}\theta\,d\nu=\infty$ for every $p>0$, so `mixtureScore ν p 0 = 0` (Bochner junk) while the printed integral is $+\infty$. Only the *differences* $S_\theta(p,y)-S_\theta(q,y)$ are supported on the compact $[\min,\max]$; the Lean definitions take the two integrals separately. See N1.

### 5. Step obligations — not applicable (definitions only, no obligations).

### 6. External parameters — none declared. Not applicable.

### 7. Doubts about the source — none found in these lines. The `IsGrowLambda` defect is formalization-side (`ENCODING_ERROR`), not a paper issue.

## TFA table
| Item | Ruling | Reason |
|---|---|---|
| `IsEValue` without disjointness of H,H' | approved | weakens the predicate's precondition only; all uses have disjoint H,H' |
| `HAll` as ∀θ instead of sup | approved (equivalence, not an extra premise) | bounded nonempty set; `csSup_le_iff` |
| Erep/kappa total division | approved conditional on N1, N3 | denominators nonzero under T01/T02 hypotheses |

## External parameters table
None.

## Required changes

**A1 (blocking; `pv_work/Defs.lean` l.74-77).** Replace the `IsGrowLambda` block by a version in which a λ for which some outcome of positive probability has $E_{p,q;\lambda}(y)\le0$ (paper value $-\infty$) can neither be the maximizer nor be compared with real arithmetic:

```lean
/-- `E_{π₁} log E_{p,q;λ}` is finite, i.e. `E_{p,q;λ}(y) > 0` for each outcome `y` of positive
probability under `π₁`; otherwise the paper's value is `-∞` (`Real.log 0 = 0` must not be used). -/
def GrowFinite (S : ℝ → ℝ → ℝ) (p q π₁ lam : ℝ) : Prop :=
  (π₁ ≠ 1 → 0 < Erep S p q lam 0) ∧ (π₁ ≠ 0 → 0 < Erep S p q lam 1)

/-- D15 (l.151, 154).  `lam ∈ (0,1]` maximizes `λ ↦ E_{π₁} log E_{p,q;λ}` over `λ ∈ (0,1]`,
values `-∞` handled via `GrowFinite` (the family of T01; see ambiguity A09). -/
def IsGrowLambda (S : ℝ → ℝ → ℝ) (p q π₁ lam : ℝ) : Prop :=
  lam ∈ Set.Ioc (0:ℝ) 1 ∧ GrowFinite S p q π₁ lam ∧
    ∀ l ∈ Set.Ioc (0:ℝ) 1, GrowFinite S p q π₁ l →
      growthRate S p q π₁ l ≤ growthRate S p q π₁ lam
```
(Convention: an outcome of probability 0 does not contribute, i.e. $0\cdot\log 0=0$ as in measure-theoretic expectation. This differs from the paper's extended-real reading only when every λ has value $-\infty$, which cannot occur under the T01 hypotheses since small λ give $E>0$.) Downstream statements must assume $\pi_1\in[0,1]$.

**A2 (drafter notes, `pv_work/notes/DEFS_draft_notes.md` l.6).** Delete the false claim "for p,q in (0,1) the integrand is supported in a compact subinterval, so the integral is genuine" and replace it by the statement of N1 below, so that later roles are not misled.

## Binding notes for downstream gates (no change to Defs required)
- **N1 (integrability).** Any statement using `mixtureScore ν` at $(p,y)$ must carry `IntegrableOn (fun θ => elemScore θ p y) (Set.Icc 0 1) ν` for the forecasts used and $y\in\{0,1\}$ (TFA: derivable from l.70 "maps ... to a numerical score", i.e. S is real-valued; e.g. it holds for Brier, logarithmic, spherical at $p\in(0,1)$). Without it, Bochner junk 0 can make Lean statements false.
- **N2 (scope of `IsConsistent`).** With `S : ℝ → ℝ → ℝ`, `IsConsistent S` (p,π over the closed [0,1]) cannot hold for the logarithmic score, which is infinite at $p\in\{0,1\}$ but explicitly treated by the source (l.74, Table l.183). A downstream theorem assuming `IsConsistent S` therefore silently excludes a case the source discusses; this is not an acceptable TFA. The T01/T02 gates must check that the theorem's hypotheses do not require real-valued consistency at $p\in\{0,1\}$ (e.g. only use the mixture representation at $p,q\in(0,1)$), or else record the restriction as a formalization-side scope limitation (never as a paper issue).
- **N3 (`kappa`).** Use only with $0<a<b<1$ and $\nu[a,b)>0$.
- **N4 (`EGrow`, `EGrowAll`, `IsEValue`).** Comparisons of e-values as functions must be restricted to $y\in\{0,1\}$.

## Statement snapshot (`#pv_type_hashes_here` on `pv_work/probes/gate/DEFS/gate_DEFS_stmtcopy.lean`, log `pv_work/logs/gate_DEFS_stmtcopy_1.log`)
```
TYPE HASHES (current file, 15 declarations)
Paper.EGrowAll|def|th=3210013240|vh=205874597|bi=eee
Paper.EGrow|def|th=627210607|vh=1762649830|bi=eeeee
Paper.Erep|def|th=734155656|vh=2349602610|bi=eeeee
Paper.HAll|def|th=3190247120|vh=2880622674|bi=ee
Paper.HS|def|th=3099366798|vh=178991639|bi=eee
Paper.IsConsistent|def|th=3052518861|vh=2544694784|bi=e
Paper.IsEValue|def|th=917420136|vh=3209617066|bi=eee
Paper.IsGrowLambda|def|th=2282638952|vh=2908407024|bi=eeeee
Paper.IsMixingMeasure|def|th=3905129696|vh=830576263|bi=e
Paper.IsStrictlyConsistent|def|th=3052518861|vh=3921778172|bi=e
Paper.elemScore|def|th=3210013240|vh=1165710149|bi=eee
Paper.expPi|def|th=45857692|vh=4121383521|bi=ee
Paper.growthRate|def|th=734155656|vh=3036279142|bi=eeeee
Paper.kappa|def|th=262648148|vh=1721998326|bi=eee
Paper.mixtureScore|def|th=262648148|vh=2898287802|bi=eee
```
(This snapshot is of the pre-amendment file; `IsGrowLambda` will change and `GrowFinite` will be added. All other 14 lines must be unchanged in the r2 check.)

## Overall verdict
Proof work on results that use `IsGrowLambda` (Theorem 2) must not begin before A1; all other definitions pass.

STATEMENT GATE: PASS_WITH_AMENDMENTS
