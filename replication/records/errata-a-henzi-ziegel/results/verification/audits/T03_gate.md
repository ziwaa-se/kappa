# Statement gate: T03 (Theorem 3.3, `thm:allscores`)

- Reviewer: pv-gate (independent subagent, model claude-opus-5-5)
- Date: Mon Oct 12 22:14:28 EDT 2026 (from `date`)
- Reviewed files (sha256 from `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T03Stmt.lean` df9492be24425eae1f642fd7252e9db1b47da3cdb97c82e25fcef55d9b32b5f1
  - `pv_work/T03Draft.lean` 500f7c850707af0025fa4a32e2dda62587c5bfb69071dde191d0b141c9b4237c
  - `pv_work/Defs.lean` (imported, gated in DEFS_gate_r2.md) 1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c
  - `pv_work/notes/T03_draft_notes.md` (leads only) 7a8cff0552f3d85368598375515d8fa32720d6aa6d639cbd270c9e6bc2ebe127
- Compilation: `scripts/pv_lean.sh check T03Draft` -> `RESULT T03Draft mode=check exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0 log=pv_work/logs/T03Draft_2.log olean=none` (6 sorries = S1-S5 + main, expected for a draft).
- Snapshot probes: `pv_work/probes/gate/T03/gate_T03_stmtcopy.lean` (exit=0, errors=0, sorry=0, log `pv_work/logs/gate_T03_stmtcopy_1.log`), `pv_work/probes/gate/T03/gate_T03_draftcopy.lean` (exit=0, errors=0, sorry=6, log `pv_work/logs/gate_T03_draftcopy_1.log`). Copies made with Read/Write; text identical to the reviewed files apart from the added `import PVTools` and `#pv_type_hashes_here`.

## Source quotations (read directly)

- `source/VSIFP_02.tex:190-198`: "Let $p,q \in (0,1)$. Then the GROW e-value with null hypothesis $H$ and alternative hypothesis that $Y = 1$ with probability $\pi_1 \not\in H$ is given by $E^{\pi_1*}_{p,q}(y) = (1-\pi_1)/(1-p)$, $y=0$; $\pi_1/p$, $y=1$."
- Proof `source/VSIFP_02.tex:465-467`: "A direct computation shows that $H = [0, p]$ if $p < q$ and $H = [p, 1]$ if $p > q$, and that $\mathbb{E}_{\pi}\{E^{\pi_1*}_{p,q}(Y)\} \leq 1$ for all $\pi \in H$ and $\mathbb{E}_{\pi}\{E^{\pi_1*}_{p,q}(Y)\} > 1$ for $\pi \not\in H$. The result then follows by Theorem 1 of \cite{Gruenwald2019}, with $W_1$ being the Dirac measure of the point $\{\pi_1\}$."
- `:140`: $H = [\pi \in [0,1]: \sup_{\theta\in[0,1]} \mathbb{E}_\pi\{S_\theta(p,Y)-S_\theta(q,Y)\} \le 0]$ (Defs `HAll`, D12, gated).
- `:98-104`: elementary score $S_\theta(p,y) = (\theta-y)\{1(p>\theta)-1(y>\theta)\}$ (Defs `elemScore`).
- `:78`: an e-value is $E \ge 0$ with $\mathbb{E}(E)\le 1$ under the null. `:142`: e-value with null $H$ and alternative $H'$: $\mathbb{E}_P E \le 1$ on $H$, $\mathbb{E}_Q E > 1$ on $H'$ (Defs `IsEValue`).
- `:151`: "If an e-value maximizes $\mathbb{E}_{\mathbb{P}}\{\log(E)\}$ under a measure $\mathbb{P}$ representing an alternative hypothesis, it is called growth rate optimal or simply GROW \citep{Gruenwald2019}."
- `:188`: "For the test of the null hypothesis $H$, applying \citet[Theorem 1]{Gruenwald2019} shows that the GROW e-value is the likelihood ratio."
- `:200-201`: (commented line 200 ignored) "the GROW e-value for testing the point null hypothesis $\{p\}$ against the alternative $\pi_1$ is exactly the likelihood ratio ... $H$ equals $[0,p]$ if $p<q$ or $[p,1]$ if $p>q$."
- `:74`, `:91`: $\mathbb{E}_\pi$ is expectation with $Y=1$ w.p. $\pi\in[0,1]$ (Defs `expPi`).

## Item 1: Hypotheses — PASS

- `p, q ∈ (0,1)`: `hp`, `hq` (`Set.Ioo 0 1`). `p ≠ q` not assumed, as in the source. For `p = q`, `HAll p p = [0,1]` (all differences vanish) so `h2 : π₁ ∉ HAll p q` together with `h1` is unsatisfiable: the theorem is vacuous there, which matches the source (no alternative outside $H$ exists).
- `π₁ ∈ [0,1]` (`h1`): part of the meaning of "Y = 1 with probability π₁" (l.74, 91). Not an extra premise.
- `π₁ ∉ H` (`h2`): printed hypothesis.
- No hidden hypotheses: `T03Stmt` has no `variable`, `structure`, or type class; `Defs` has none either. The only extra explicit hypothesis is the external parameter `X03 : GruenwaldThm1` (item 6). No hypothesis states the conclusion or an equivalent (`GrowIs …` appears only as conclusion; X03 is universally quantified over arbitrary `H, p₀` and requires the two substantive facts S3, S4).

## Item 2: Conclusion — PASS

`GrowIs (HAll p q) π₁ (EGrowAll p π₁)`:
- `EGrowAll p π₁` (Defs D18) is exactly the printed $E^{\pi_1*}_{p,q}$ (l.193-196); only values at y ∈ {0,1} matter.
- `IsGrowEValue H π₁ E`: E is an e-value with null H and alternative {π₁} (l.142, l.191 "alternative hypothesis that Y=1 w.p. π₁"), its log-growth is finite (`LogFinite`), and it maximizes `expPi π₁ (log ∘ E')` over all e-values `E'` with null H (`IsEValue E' H ∅`) of finite log-growth. This is the l.151 definition. Restricting competitors to `LogFinite` is harmless and is the correct encoding of the `-∞` value (same convention the DEFS gate imposed via `GrowFinite`, DEFS_gate A1): a competitor with `E'(y) = 0` at an outcome of positive probability has growth `-∞` in the source, whereas `Real.log 0 = 0` would otherwise give it a spurious finite value. Competitors are required to satisfy only the null bound, not the alternative bound; this matches the GROW optimisation class of Grünwald et al. and is not a strengthening of what the maximizer must beat beyond the source (the l.151 phrase "an e-value" ranges over e-values for the null). Either reading gives the same maximizer here (see check below).
- Uniqueness conjunct (definite article "the GROW e-value ... is given by", l.191): every GROW e-value agrees with E* at each outcome of positive π₁-probability. Requiring only π₁-a.s. agreement is correct: for π₁ = 1 (resp. 0), the value at y = 0 (resp. 1) does not enter the growth and is not determined; demanding pointwise equality there would manufacture a false statement. Including the uniqueness clause is the faithful reading of "the"; it is not a strengthening beyond the printed text.
- Truth check (done by me, not from notes). p<q: H=[0,p], π₁∈(p,1]. Constraints of the null include π=0 (E0 ≤ 1) and π=p ((1-p)E0+pE1 ≤ 1). Maximizing (1-π₁)log E0 + π₁ log E1 under the single constraint at π=p gives E0=(1-π₁)/(1-p) ≤ 1, E1=π₁/p; this is feasible for all π∈[0,p] since E_π E* is affine in π, equals 1 at π=p and has slope (π₁-p)/(p(1-p)) > 0. Strict concavity gives uniqueness for π₁∈(0,1); for π₁=1, E1 ≤ (1-(1-p)E0)/p ≤ 1/p forces E1 = 1/p = E*(1). E_{π₁}E* > 1 holds. p>q symmetric (H=[p,1], π₁∈[0,p), π₁=0 handled analogously). So the encoded conclusion is true as stated; no paper error is manufactured.

## Item 3: Quantifiers and constants — PASS

All of `p, q, π₁` are universally quantified; no constants are chosen. X03 is a hypothesis quantified internally over all `H, π₁, p₀`, so it is independent of `p, q, π₁` of the theorem. No global constant convention is relevant.

## Item 4: Domains and details — PASS

- Outcome domain: functions `ℝ → ℝ`, only values at 0, 1 used by `expPi`, `IsEValue`, `LogFinite`, `GrowIs`; values elsewhere are irrelevant and never constrained. OK.
- π-domain: `HAll ⊆ [0,1]` by definition; S4 and X03 quantify the alternative bound over `π ∈ [0,1] \ H`, matching "π ∉ H" with π a probability.
- a.s. vs pointwise: handled correctly in `GrowIs` (item 2).
- `ℝ≥0∞`/`toReal` traps: none (no measures used in T03). `Real.log` at 0 / negatives: competitors are nonnegative by `IsEValue`; zero values only possible at a null outcome, where they are multiplied by 0 in `expPi`. OK.
- Existence: the conclusion asserts E* itself is GROW (existence is explicit).

## Item 5: Step obligations — PASS

| Step | Source | True as stated? | Smuggling? |
|---|---|---|---|
| S1 `HAll p q = Icc 0 p` (p<q) | l.466, l.201 | True: for θ∈[p,q), E_π diff = π−θ; other θ give 0; so π ≤ θ ∀θ∈[p,q) iff π ≤ p | no |
| S2 `HAll p q = Icc p 1` (q<p) | l.466, l.201 | True: for θ∈[q,p), E_π diff = θ−π; π ≥ θ ∀θ<p iff π ≥ p (sup not attained, inequality still gives π ≥ p) | no |
| S3 `∀ π ∈ HAll, E_π E* ≤ 1` | l.466 | True (affine, =1 at p, sign of slope fixed by h2 via S1/S2; p=q vacuous since h1,h2 contradictory) | no |
| S4 `∀ π ∈ [0,1] \ HAll, 1 < E_π E*` | l.466 | True (same computation) | no |
| S5 X03 + S3 + S4 ⇒ GrowIs | l.466, l.188 | True: direct instantiation of X03 with `H = HAll p q`, `p₀ = p`; `HAll ⊆ [0,1]` holds by definition | no (X03 is the cited theorem, item 6) |
| main | l.190-198 | assembled from S3, S4 (via S1, S2) and S5 | — |

The obligations assemble to the main theorem. Each obligation corresponds to a clause of l.466. S1-S4 are the source's "direct computation" (no computation printed; drafter labels it X08 — a FAIR_IMPLICIT_STEP candidate, to be filled by the prover by a routine computation, not a paper issue).

## Item 6: External parameters — PASS

`Paper.T03.GruenwaldThm1` (X03), provenance (i), cited at l.188 and l.466.
- Form: for any `H ⊆ [0,1]`, `π₁ ∈ [0,1] \ H`, `p₀ ∈ (0,1)`: if the Bernoulli likelihood ratio `EGrowAll p₀ π₁` has `E_π ≤ 1` on `H` and `> 1` on `[0,1] \ H`, then it is the (π₁-a.s. unique) GROW e-value for null `H` against `π₁`.
- Faithfulness to the cited theorem: Theorem 1 of Grünwald–de Heide–Koolen states that, for a Dirac/prior alternative W₁, the GROW e-variable is the likelihood ratio of P_{W₁} against the reverse information projection of P_{W₁} on the (convex hull of the) null. The source's use (l.466) is: once the LR against Bern(p) is shown to be an e-value for H (S3), Thm 1 identifies it as GROW. X03 states this specialisation, with the extra premise S4 (`> 1` off H) which the source also verifies; extra premises only weaken it. It does not require `p₀ ∈ H` explicitly, but S3+S4-type premises force `H = [0,p₀]` or `[p₀,1]` (E_π E is affine, = 1 at π = p₀, and π₁ = p₀ makes the premises contradictory), so p₀ ∈ H follows.
- Not stronger than needed / truth: I verified that X03 is true as stated (premises force H to be the half-interval with endpoint p₀; then the Kelly/KKT computation of item 2 applies, including uniqueness). Hence it cannot introduce a false consequence.
- Uniqueness clause: whether GHK Thm 1 itself states essential uniqueness of the GROW e-variable must be confirmed by the human check against the cited paper (no network here). Since the clause is mathematically true in this Bernoulli setting, this affects only provenance accounting, not truth. Record in EXTERNAL_TOOLS.md human_check: "confirm GHK 2019 Thm 1 covers (a) GROW identification of the LR when it is an e-value for H, (b) a.s. uniqueness".
- Not goal-shaped: it is quantified over arbitrary `H`, `p₀`, not tied to `HAll`, and requires the two substantive facts that the source itself verifies; the source proof is literally "verify S3, S4, apply Thm 1". Acceptable.
- Observation (non-blocking): X03 is elementary in this Bernoulli setting and could in principle be proved; per POLICY §1 the cited result is still kept as a visible parameter. The "mathlib does not have it" claim is not relevant (GROW is a notion defined in this project, not a mathlib notion); no `#check` evidence needed.
- Naming/location: declared only in `pv_work/T03Stmt.lean`, in `namespace Paper.T03`; grep of `pv_work/` shows no other declaration of `GruenwaldThm1`, `IsGrowEValue`, `GrowIs`, `LogFinite`. Not a (p) parameter, so no `<ID>_<PredID>Consumed` naming applies.

## Item 7: Doubts about the source — none

No suspected paper issue. The only unjustified step is the "direct computation" (S1-S4), which I verified is routine and true: preliminary FAIR_IMPLICIT_STEP, not an issue. Line 200 is a TeX comment and was ignored.

## TFA table

| Candidate | Ruling | Reason |
|---|---|---|
| `π₁ ∈ [0,1]` | not a TFA (part of the hypothesis meaning) | "Y=1 with probability π₁", l.74/91 |
| `LogFinite` restriction of competitors | encoding convention, approved | correct encoding of `log 0 = -∞` (DEFS_gate A1) |

No TFAs proper.

## External parameter table

| Name | Provenance | Ruling |
|---|---|---|
| `Paper.T03.GruenwaldThm1` (X03) | (i) GHK 2019 Thm 1, l.188, l.466 | APPROVED (true as stated; not stronger than the source's use; human check to confirm uniqueness is covered by the cited theorem) |

## Required changes

None.

## Statement snapshot

`gate_T03_stmtcopy.lean` (log `pv_work/logs/gate_T03_stmtcopy_1.log`):
```
TYPE HASHES (current file, 4 declarations)
Paper.T03.GrowIs|def|th=1102745104|vh=221266290|bi=eee
Paper.T03.GruenwaldThm1|def|th=3944470172|vh=2160414597|bi=
Paper.T03.IsGrowEValue|def|th=1102745104|vh=3727335943|bi=eee
Paper.T03.LogFinite|def|th=3879693295|vh=1552851041|bi=ee
EXIT=0
```

`gate_T03_draftcopy.lean` (log `pv_work/logs/gate_T03_draftcopy_1.log`):
```
TYPE HASHES (current file, 6 declarations)
Paper.T03.T03_S1|thm|th=4113369414|vh=-|bi=eeeee
Paper.T03.T03_S2|thm|th=3661244883|vh=-|bi=eeeee
Paper.T03.T03_S3|thm|th=2313757401|vh=-|bi=eeeeeeeee
Paper.T03.T03_S4|thm|th=3351218906|vh=-|bi=eeeeeeeeee
Paper.T03.T03_S5|thm|th=3820614380|vh=-|bi=eeeeeeeeee
Paper.T03.T03_main|thm|th=437386253|vh=-|bi=eeeeeeee
EXIT=0
```

## Overall verdict

All items 1-7 PASS; no required changes; X03 approved as provenance (i).

STATEMENT GATE: PASS
