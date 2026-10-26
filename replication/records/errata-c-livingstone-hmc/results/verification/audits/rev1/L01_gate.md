# L01 (Lemma 5.15, lem:xelower) — statement gate, revision enc1

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); not the drafter, not the prover, not the issue checker.
- Date: Mon Oct 12 22:20:38 EDT 2026 (from `date`).
- Scope: re-gate after revision enc1 (Draft rewritten: the fixed-δ form is now the only main theorem). Earlier reports archived in `verification/audits/revenc1/` (`L01_gate.md`, `L01_gate_r2.md`, `L01_issue_1.md`); read for context only, rulings below are my own.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean` b641d506158ff99af3ae6b33800fd32a4216d840ceb5af75145fc50a7d232e9b (identical to the r2 hash and to `pv_work/superseded/revenc1/L01Stmt.lean`: unchanged)
  - `pv_work/L01Draft.lean` bef758ea09bc5737b4158e48da4a523b63bcf09fa8fe5dbf7691aab7a9ee8623
  - `pv_work/notes/L01_draft_notes.md` 25e418781a2d96d9df1260904289bc6c7c50430fe3c011256d6296aae6ed4c4d (leads only)
  - Shared definitions read: `pv_work/Defs.lean` l.12-81 (`E`, `leapfrogStep`, `leapfrogState`, `xLF`, `HypExplode`).
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_6.log olean=none` (EXIT=0; 6 sorries = 6 declarations, expected in a draft).
- Snapshot probes: `pv_work/logs/gate_L01_r3enc1_stmtcopy_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_L01_r3enc1_draftcopy_1.log` (exit=0, 6 sorry); copies `pv_work/probes/gate/L01/gate_L01_r3enc1_{stmtcopy,draftcopy}.lean`.

## Source quotations (read directly)

- Statement, source/geo_erg_HMC_v3.1.tex:884-886: "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\|\leq \|x_0\|^\delta$ for some $\delta<1$, it holds that $\|x_\e\|>2\|x_0\|$."
- Proof, TEX:888-897: "$\|x_\e\| = \| x_0 - \frac{\e^2}{2}\nabla U(x_0) + \e p_0 \| \geq \frac{\e^2}{2}\|\nabla U(x_0)\| - \|x_0\| - \e\|p_0\|$. Dividing by $\|x_0\|$ gives [(20)] ... Using (\ref{eqn:explode}), we can choose an $x_0$ such that the first term on the right-hand side is larger than $6/\e^2$, and the last term can be made negligibly small as $\|p_0\| \leq \|x_0\|^\delta$ for some $\delta < 1$, which establishes the result."
- (17) eqn:explode, TEX:865-867: $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$.
- Leapfrog, TEX:330-336 (with M = I, Remark TEX:354-356): $p_{t+\e/2}=p_t-\frac{\e}{2}\nabla U(x_t)$, $x_{t+\e}=x_t+\e M^{-1}p_{t+\e/2}$, ..., "for some step-size $\e>0$".
- Consumers: TEX:879 ("provided $\|p_0\|\leq\|x_0\|^\delta$ for some $\delta<1$ ... $\mathbb{P}(\|p_0\|\le\|x_0\|^\delta)\to1$" — a fixed region, δ fixed); TEX:899-901 (Lemma 5.16, same wording); TEX:939-943 (Lemma 5.17: "for any $\delta<1$ ... $\lim_{\|x_0\|\to\infty,\|p_0\|\le\|x_0\|^\delta}$" — δ explicitly fixed first).

## Item rulings

1. **Hypotheses — PASS.** (17) = `hexp : HypExplode gU`; `HypExplode` (Defs l.75-76) is `Tendsto (‖gU x‖/‖x‖) (comap ‖·‖ atTop) atTop`, a faithful rendering of the limit "as ‖x‖ → ∞". `heps : 0 < eps` is printed (TEX:336). No `U`/`IsGradField` premise: the statement and proof involve only ∇U, so passing `gU` as an arbitrary function is a generalisation (fewer premises), not an extra premise. No hidden hypotheses: no `variable`, structure or class premises in either file; `E d` is `EuclideanSpace ℝ (Fin d)` (TEX:192-194). No conclusion-shaped hypothesis.
2. **Conclusion — PASS.** `2 * ‖x0‖ < ‖xLF gU eps x0 p0 1‖` is "‖x_ε‖ > 2‖x_0‖" (strict, as printed); `xLF … 1` is the x-component after one leapfrog step (Defs l.34-49). No clause missing.
3. **Quantifiers / constants — PASS (central question of this re-gate).** Main theorem `L01_main_fixedDelta : ConclFixedDelta gU eps` = `∀ δ < 1, ∃ η, ∀ x0 p0, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → …`, with `gU, eps` (and `d`) fixed before η.
   - TEX:885 is grammatically ambiguous: "for some δ<1" may sit inside the "for any p0" (η uniform in δ, = `Concl`) or name a δ that is given with the lemma (η = η(δ)). The fixed-δ reading is a faithful reading: (a) the printed proof only justifies it — "negligibly small as ‖p0‖ ≤ ‖x0‖^δ for some δ<1" (TEX:896) is a limit statement for a fixed exponent; (b) every consumer uses a fixed δ (TEX:879, 940 "for any δ<1", and L02's own proof); (c) Lemma 5.17's explicit "for any δ<1" (TEX:940) is the paper's own disambiguation of the identical phrase in the same chain.
   - It is the weaker of the two readings, so it cannot manufacture a paper error, and it is not a weakening that hides one: the archived issue ruling (`revenc1/L01_issue_1.md`, probe (B)) found the uniform reading true as well, so nothing about the paper's correctness depends on the choice. Choosing the weaker reading is legitimate here precisely because it is what the source proves and consumes (POLICY §1: conventions fixed by the source's own usage are adopted fairly).
   - η depending on ε is correct: ε is a fixed parameter of the method (TEX:336), chosen before the lemma. η depending on `gU` and `d` is the usual implicit dependence on the data.
4. **Domains and details — PASS.** Non-periodic ℝ^d; pointwise, not a.e.; `‖x0‖ ^ δ` is `Real.rpow` with base ≥ 0 (for ‖x0‖ > η ≥ 0 the base is positive, so the rpow conventions at 0 play no role in the main theorem's content, and η may always be enlarged); no ℝ≥0∞ conversions; d = 0 harmless (vacuous).
5. **Step obligations — PASS.** Each checked for truth as stated:
   - S1 (TEX:890): unfold `leapfrogStep`: `x0 + eps • (p0 - (eps/2) • gU x0) = x0 - (eps^2/2) • gU x0 + eps • p0`. True, no premise needed.
   - S2 (TEX:890): reverse triangle inequality `‖b‖ - ‖a‖ - ‖c‖ ≤ ‖a + b + c‖` with `‖eps • p0‖ = eps‖p0‖`, `‖(eps^2/2) • g‖ = (eps^2/2)‖g‖` using `eps > 0`. True.
   - S3 (TEX:893-895): division of S2 by `‖x0‖ > 0`, premise `hx : x0 ≠ 0` present. True.
   - S4 (TEX:896, first clause): from `HypExplode`, for any B the set {‖gU x‖/‖x‖ > 2B/eps²} is in `comap ‖·‖ atTop`, hence contains {‖x‖ ≥ R}; with `eps > 0` this gives η₁. True. The "6/ε²" wording slip (TEX:896) is avoided by quantifying over all B — a faithful rendering of "can be made larger than", not a route change.
   - S5 (TEX:896, second clause): for ‖x0‖ > max(η₂,0), `‖p0‖/‖x0‖ ≤ ‖x0‖^(δ-1) → 0` since δ-1 < 0. True for fixed δ (premises `δ < 1`, `ζ > 0`, `eps > 0` present).
   - Assembly: η = max(η₁(B=4), η₂(δ, ζ=1), 0): by S3, ratio `> 4 - 1 - 1 = 2` (S4 strict, S5 strict); multiply by ‖x0‖ > 0. The obligations assemble to `ConclFixedDelta`. No obligation smuggles the conclusion or a stronger intermediate.
6. **External parameters — PASS (none).** S1 derives the one-step formula from `Defs`, so Prop. 4.2 is not an input. No `def … : Prop` tool in either file besides the two conclusion predicates.
7. **Doubts about the source — PASS (no dispatch).**
   - TEX:896 "first term … larger than 6/ε²": wording slip (the bound belongs to ‖∇U‖/‖x0‖); preliminary `EDITORIAL`. No dispatch.
   - TEX:885 quantifier order: preliminary `EDITORIAL` at most (both readings true; already ruled `ENCODING_ERROR`-side for the old uniform target in `revenc1/L01_issue_1.md`). No dispatch.

## Is the unused `Paper.L01.Concl` harmless? — Yes

- It is a `def … : Prop` with no proof obligation attached in the Draft; nothing in `pv_work/*.lean` uses it (grep for occurrences only, as a lead; L02Stmt l.16 mentions it in a docstring; L02's consumed clause l.34-35 is `Paper.L01.ConclFixedDelta gU eps`; L02 has its own `Paper.L02.Concl`). A dead definition cannot weaken or strengthen any theorem.
- Its content is locked by `vh` (unchanged), so it cannot drift.
- Keeping `L01Stmt.lean` byte-identical is the right call: any edit (even a docstring) changes the `.olean` and would invalidate the gated `L02Stmt`.
- Non-blocking remark: the docstrings in `L01Stmt.lean` (l.15 "Literal reading", l.22 "Alternative (weaker) reading") now describe the roles inversely to the verdict-bearing choice. Not to be fixed in the file (it would change the `.olean`); the coordinator may record it in `verification/DOC_ERRATA.md`. The final auditor and report must name `L01_main_fixedDelta` / `ConclFixedDelta` as the verdict-bearing statement and `Concl` as an unused alternative reading, not an open gap.

## TFA table

| Premise | Where | Ruling | Reason |
|---|---|---|---|
| `hx : x0 ≠ 0` | S3 (step-local) | approved | needed to divide (TEX:893 "dividing by ‖x0‖"); holds for ‖x0‖ > η ≥ 0 in the assembly |
| `heps : 0 < eps` | main, S2-S5 | not a TFA (printed, TEX:336) | — |

## External parameters

None.

## Comparison with the archived r2 snapshot (`revenc1/L01_gate_r2.md` l.33-51)

- `Paper.L01.ConclFixedDelta|def|th=922123888|vh=197406444|bi=iee` — identical.
- `Paper.L01.Concl|def|th=922123888|vh=1830260882|bi=iee` — identical.
- `L01_S1`..`L01_S5`, `L01_main_fixedDelta`: th and bi identical line by line to r2.
- `Paper.L01.L01_main` (th=795169561): removed from the Draft (intended change of enc1; it was the non-bearing uniform-reading target).
- Conclusion: the type consumed by L02 (`ConclFixedDelta`, th and vh) is unchanged; L02's gate is not affected.

## Required changes

None.

## Statement snapshot (verbatim TYPE HASHES)

From `pv_work/logs/gate_L01_r3enc1_stmtcopy_1.log` (copy of L01Stmt.lean):
```
TYPE HASHES (current file, 2 declarations)
Paper.L01.ConclFixedDelta|def|th=922123888|vh=197406444|bi=iee
Paper.L01.Concl|def|th=922123888|vh=1830260882|bi=iee
EXIT=0
```
From `pv_work/logs/gate_L01_r3enc1_draftcopy_1.log` (copy of L01Draft.lean):
```
TYPE HASHES (current file, 6 declarations)
Paper.L01.L01_S1|thm|th=4288029101|vh=-|bi=ieeee
Paper.L01.L01_S2|thm|th=550043121|vh=-|bi=ieeeee
Paper.L01.L01_S3|thm|th=718125916|vh=-|bi=ieeeeee
Paper.L01.L01_S4|thm|th=2586431750|vh=-|bi=ieeeee
Paper.L01.L01_S5|thm|th=3043808301|vh=-|bi=ieeeeee
Paper.L01.L01_main_fixedDelta|thm|th=2678561996|vh=-|bi=ieeee
EXIT=0
```

## Overall verdict

The fixed-δ main theorem is a faithful reading of TEX:884-886 (it is the reading the printed proof establishes and every consumer uses); all obligations true as stated and assemble to it; no external parameters; `Concl` is dead and harmless; consumed type unchanged. Verdict-bearing target: `L01_main_fixedDelta`.

STATEMENT GATE: PASS
