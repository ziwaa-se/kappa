# L01 (Lemma 5.15, lem:xelower) — statement gate

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); not the drafter.
- Date: Mon Oct 12 22:07:48 EDT 2026 (from `date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean`  b641d506158ff99af3ae6b33800fd32a4216d840ceb5af75145fc50a7d232e9b
  - `pv_work/L01Draft.lean` c0fd4f4290314b31a3e8b847d7ec7e122db5e6829cf482d51c92e55479adac01
  - `pv_work/Defs.lean` (imported, gated in DEFS_gate.md) e573c173018c4d76c43445dec04b28371b1c4a1b070dc9de1a4f2c14f38d3472
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=7 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_2.log olean=none` (EXIT=0; 7 sorries expected in a draft).
- Snapshot probes: `pv_work/logs/gate_L01_stmtcopy_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_L01_draftcopy_1.log` (exit=0, 7 sorry).

## Source quotations (read directly)

- Statement, source/geo_erg_HMC_v3.1.tex:884-886: "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\|\leq \|x_0\|^\delta$ for some $\delta<1$, it holds that $\|x_\e\|>2\|x_0\|$."
- Proof, TEX:888-896: "Taking norms after a single leapfrog step gives $\|x_\e\| = \| x_0 - \frac{\e^2}{2}\nabla U(x_0) + \e p_0 \| \geq \frac{\e^2}{2}\|\nabla U(x_0)\| - \|x_0\| - \e\|p_0\|$. Dividing by $\|x_0\|$ gives [display (20)]. Using (\ref{eqn:explode}), we can choose an $x_0$ such that the first term on the right-hand side is larger than $6/\e^2$, and the last term can be made negligibly small as $\|p_0\| \leq \|x_0\|^\delta$ for some $\delta < 1$, which establishes the result."
- (17) eqn:explode, TEX:865-867: $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$.
- Leapfrog, TEX:330-336: $p_{t+\e/2} = p_t - \frac{\e}{2}\nabla U(x_t)$, $x_{t+\e} = x_t + \e M^{-1}p_{t+\e/2}$, ..., "for some step-size $\e>0$". $M=I$: Remark TEX:354-356.
- $U:\X\to[0,\infty)$: TEX:320. Prop 4.2 (eqn:mprop) TEX:361-374.
- Downstream use of the δ-region: TEX:879 (Thm 5.14 proof: "provided $\|p_0\|\le\|x_0\|^\delta$ for some $\delta<1$ ... $\mathbb P(\|p_0\|\le\|x_0\|^\delta)\to1$"), which only makes sense for a fixed δ.

## Item rulings

1. **Hypotheses — PASS.** (17) is `hexp : HypExplode gU` (Defs, gated: `‖gU x‖/‖x‖ → atTop` along `comap ‖·‖ atTop`). `ε>0` is `heps : 0 < eps`, printed at TEX:336 (not a TFA). No hidden hypotheses: Stmt has no `variable`, `structure` or class beyond `E d`. U does not occur in the lemma's statement or proof (only ∇U), so omitting `U`, `IsGradField`, and `U ≥ 0` (TEX:320) only generalizes (gU an arbitrary function); acceptable. `M = I` per TEX:355. `d` arbitrary: for `d = 0` both sides are vacuous (no `x0` with `‖x0‖>η≥0`), no degenerate falsity. No conclusion-shaped hypothesis.
2. **Conclusion — PASS.** `2 * ‖x0‖ < ‖xLF gU eps x0 p0 1‖` is the strict `‖x_ε‖ > 2‖x_0‖`; `xLF … 1` is `x_ε` (one leapfrog step from `(x0,p0)`). Neither weakened nor strengthened in the inequality.
3. **Quantifiers / constants — PASS (with ruling on N5).** `gU, eps` fixed before `∃ η` (η may depend on ε, gU, d: ε is a given constant of the lemma, natural). Two readings of "for all ‖x0‖>η and any ‖p0‖≤‖x0‖^δ for some δ<1":
   - `Concl` (δ existential inside, η uniform in δ): admissible literal reading; **true as stated** (for ‖x0‖ ≥ 1 the premise implies ‖p0‖ ≤ ‖x0‖, and (17) gives the claim with a bound > 3+ε on the first term).
   - `ConclFixedDelta` (δ<1 fixed first, η = η(δ)): the reading that the printed proof establishes ("negligibly small", TEX:896, holds only for fixed δ) and the one the consumer Thm 5.14 (TEX:879) uses. **True as stated.**
   Ruling: both encodings are faithful readings; the **verdict-bearing target is `L01_main_fixedDelta`**. `L01_main` (uniform) is the stronger reading, and S1-S5 do not assemble to it (see item 5). If the prover cannot obtain `Concl` along the printed route, that is a consequence of our reading choice and **must not** be recorded as a paper issue (POLICY §1: representation choices must never manufacture a paper error); the drafter's note suggestion "record EXPOSITION_GAP" is rejected. At most a DOMAIN_CLARIFICATION note (ambiguous quantifier order, N5) may be recorded, without effect on the verdict.
4. **Domains and details — PASS.** δ ranges over all reals δ<1 (printed "δ<1"; INVENTORY's δ∈(0,1) is not printed for this lemma; δ ≤ 0 only enlarges the region and stays true). `‖x0‖ ^ δ` is `Real.rpow` on a nonnegative base; at ‖x0‖=0 the rpow conventions are irrelevant because η can be taken ≥ 1 in both readings. No ENNReal/toReal, a.e., measurability, or periodicity issue. Strict `η < ‖x0‖` matches "‖x0‖>η".
5. **Step obligations — PASS for content, amendments required for the assembly claims.**
   - S1 (TEX:888-890 equality): true by unfolding `leapfrogStep`: `x' = x0 + ε(p0 − (ε/2)gU x0) = x0 − (ε²/2)gU x0 + εp0`. Faithful: the source says "after a single leapfrog step", i.e. it uses the leapfrog definition (TEX:332-333), not Prop 4.2. Deriving it from the definition is faithful; no external parameter needed (INVENTORY's "Prop 4.2 (ii)" flag for L01 is superseded for this lemma).
   - S2 (TEX:890 inequality): true (triangle inequality, ε²/2 ≥ 0, ε > 0). FAIR_IMPLICIT_STEP.
   - S3 (TEX:893-895, (20)): true for `x0 ≠ 0`.
   - S4 (TEX:896 first clause): true as stated for every B (from (17); vacuous for d=0). Faithful generalization of "larger than 6/ε²" (see item 7).
   - S5 (TEX:896 second clause): true as stated (fixed δ<1, ζ>0: ε‖p0‖/‖x0‖ ≤ ε‖x0‖^{δ−1} → 0).
   - None smuggles the conclusion. **Assembly:** S1 (via S2), S3, S4 with B = 4, S5 with ζ = 1 give `ConclFixedDelta` (ratio > 4 − 1 − 1 = 2). They do **not** give `Concl`: S5 is for fixed δ, whereas in `Concl` δ depends on p0; the uniform form needs the unprinted bound ε‖p0‖/‖x0‖ ≤ ε (‖x0‖ ≥ 1) and a larger B. The docstrings of `L01_main` ("Assembly: S1-S5") and `L01_main_fixedDelta` ("follows from `L01_main`") misdescribe this and would steer the prover off the source route → amendments A1, A2.
6. **External parameters — PASS (none).** No `def … : Prop` tool in L01Stmt.lean; `Concl`/`ConclFixedDelta` are statement definitions in `namespace Paper.L01`, no redeclared names. No "mathlib lacks X" claim to check.
7. **Doubts about the source — recorded, preliminary only.**
   - TEX:896 "the first term ... larger than 6/ε²": the first term of (20) is (ε²/2)‖∇U‖/‖x0‖; 6/ε² fits ‖∇U‖/‖x0‖ (first term > 3). With first term > 3 and "negligible" last term the ratio is > 2 − small; the conclusion needs the slack (any larger bound is available from (17)). Preliminary: EDITORIAL / FAIR_IMPLICIT_STEP (the step "choose large enough" is fully available from (17)). No dispatch needed unless the prover hits a real obstruction.
   - TEX:885 quantifier order (N5): preliminary DOMAIN_CLARIFICATION at most; both readings true. Not a dispatch candidate on its own.
   - TEX:896 "we can choose an x0 such that" (should be "for all x0 with ‖x0‖ large"): EDITORIAL wording, (17) gives the uniform statement.

## TFAs ruled on

| Premise | Ruling | Reason |
|---|---|---|
| `heps : 0 < eps` | not a TFA (printed) | TEX:336 "step-size ε>0" |
| `hx : x0 ≠ 0` in S3 | approved (step-local) | division by ‖x0‖ in TEX:893; in the assembly ‖x0‖>η≥0 |
| none other | — | — |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | Prop 4.2 not needed: S1 follows from `leapfrogStep` (TEX:888 refers to the leapfrog step itself) |

## Required changes (docstrings only; no change to any type, so the snapshot below remains valid)

- **A1.** `pv_work/L01Draft.lean` line 15, replace the docstring
  `/-- Weaker quantifier reading (N5); follows from `L01_main` (not a separate source claim). -/`
  with
  `/-- Fixed-δ reading (N5) of TEX:884-886, the verdict-bearing form: the reading established by the printed proof (TEX:888-897) and used at TEX:879. Assembly: S1-S3, S4 (B = 4), S5 (ζ = 1); to be proved without `L01_main`. -/`
- **A2.** `pv_work/L01Draft.lean` line 10, replace `Assembly: S1-S5. -/` with
  `Uniform-in-δ reading (stronger). S1-S5 assemble only to `ConclFixedDelta`; the uniform form additionally needs ε‖p0‖/‖x0‖ ≤ ε, not printed in the source. Not obtaining it along the source route is a reading-choice matter, not a paper issue. -/`
- **A3.** `pv_work/notes/L01_draft_notes.md` line 25-26: delete "record EXPOSITION_GAP and"; state that `L01_main_fixedDelta` is the verdict-bearing theorem and `lean_main` should point to it unless `L01_main` is also proved along the source route.

## Statement snapshot (verbatim TYPE HASHES)

From `pv_work/logs/gate_L01_stmtcopy_1.log` (copy of L01Stmt.lean):
```
TYPE HASHES (current file, 2 declarations)
Paper.L01.ConclFixedDelta|def|th=922123888|vh=197406444|bi=iee
Paper.L01.Concl|def|th=922123888|vh=1830260882|bi=iee
EXIT=0
```
From `pv_work/logs/gate_L01_draftcopy_1.log` (copy of L01Draft.lean):
```
TYPE HASHES (current file, 7 declarations)
Paper.L01.L01_S1|thm|th=4288029101|vh=-|bi=ieeee
Paper.L01.L01_S2|thm|th=550043121|vh=-|bi=ieeeee
Paper.L01.L01_S3|thm|th=718125916|vh=-|bi=ieeeeee
Paper.L01.L01_S4|thm|th=2586431750|vh=-|bi=ieeeee
Paper.L01.L01_S5|thm|th=3043808301|vh=-|bi=ieeeeee
Paper.L01.L01_main_fixedDelta|thm|th=2678561996|vh=-|bi=ieeee
Paper.L01.L01_main|thm|th=795169561|vh=-|bi=ieeee
EXIT=0
```

## Overall verdict

Hypotheses, conclusion, domains, external parameters PASS; all obligations true as stated; amendments A1-A3 fix the assembly descriptions so that the verdict rests on the fixed-δ form proved along the printed route.

STATEMENT GATE: PASS_WITH_AMENDMENTS
