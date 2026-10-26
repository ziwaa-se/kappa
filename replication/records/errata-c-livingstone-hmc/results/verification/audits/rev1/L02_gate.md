# L02 (Lemma 5.16, lem:xlower) — statement gate

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); not the drafter.
- Date: Mon Oct 12 22:19:14 EDT 2026 (from `date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean`  a4fe112ea5c426154e33465dbdd15806722fe9db4319b414de802b8ad005f294
  - `pv_work/L02Draft.lean` 5037688a2ab9b8ecb59ac48a0d43ed9812c6cec3503e1bd3879e8871d227ee9c
  - `pv_work/notes/L02_draft_notes.md` 38e6f4f355e1235242f9da2adfb3f81c4a6a4c25543fc449c6d626cc505dc4df (leads only)
  - also read: `pv_work/Defs.lean`, `pv_work/L01Stmt.lean`, `pv_work/L01Draft.lean`, `verification/audits/L01_gate_r2.md`, INVENTORY entries X5, N2, N5, N6, N8.
- Compilation: `scripts/pv_lean.sh check L02Draft` -> `RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=16 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_2.log olean=none` (EXIT=0; 16 sorries = 16 declarations, expected in a draft).
- Snapshot probes: `pv_work/logs/gate_L02_stmtcopy_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_L02_draftcopy_1.log` (exit=0, 16 sorry); copies `pv_work/probes/gate/L02/gate_L02_{stmtcopy,draftcopy}.lean` (verbatim copies plus `import PVTools` and `#pv_type_hashes_here`).

## Source quotations (read directly)

- Statement, TEX:899-901: "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\| \leq \|x_0\|^\delta$ for some $\delta < 1$, it holds that $\|x_{L\e}\| \geq 2^L\|x_0\|$."
- Proof TEX:903-935, in particular: TEX:906 `x_{2ε} = x_ε - ε²∇U(x_ε) - (ε²/2)∇U(x_0) + εp_0`; TEX:910 ratio bound; TEX:912 "Showing the right-hand side is ≥ 2 amounts to upper bounding the middle term"; TEX:914 (eqn:inter21); TEX:920, 924, 928; TEX:930 "The second and last terms ... can be made arbitrarily small ... Envoking (\ref{eqn:oscillations}) gives"; TEX:932 `‖∇U(x_0)‖/(2‖∇U(x_ε)‖) ≤ 1/6`; TEX:934 "which therefore shows that ‖x_{3ε}‖ ≥ 2‖x_{2ε}‖. An entirely analogous argument can be used to show that ‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖ for any fixed i, establishing the result."
- (17) eqn:explode TEX:865-867; (18) eqn:oscillations TEX:868-871 ("fixed C<∞ such that whenever ‖y‖ ≥ 2‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖"); (19) TEX:873-875. These are hypotheses of Theorem 5.14 (TEX:863-877), not of Lemma 5.16.
- Leapfrog TEX:330-336 (step-size ε>0), M=I TEX:354-356, Prop 4.2 (eqn:mprop) TEX:361-374.
- Predecessor L01 = Lemma 5.15, TEX:884-886.

## Item rulings

### 1. Hypotheses — PASS
- Printed hypothesis (17) -> `hexp : HypExplode gU` (Defs encoding approved in DEFS gate). `heps : 0 < eps` from TEX:336 ("step-size ε>0"): context, not an extra premise. `L : ℕ` fixed (TEX:876 "fixed integration time T=Lε", N8).
- `hL01 : L02_L01Consumed gU eps`: consumed clause (p), see item 6.
- No IsGradField: `gU` is an arbitrary map. This only generalizes the statement; the printed proof never uses that `gU` is a gradient, and the statement remains true for arbitrary `gU` (see item 7 sketch). Acceptable.
- No hidden hypotheses in structures/classes/variables; `Defs` adds none.
- No conclusion-as-hypothesis form: `hL01` is L01's first-step bound (for `L=1` it coincides with L02's conclusion up to `>`/`≥`, which is legitimate because L=1 of Lemma 5.16 *is* Lemma 5.15).
- Focus (a), `hosc : HypOscillations gU` in `L02_main_fixedDelta_osc`: **rejected as a TFA**. (18) is neither derivable from (17)/ε>0 nor does it exclude only degenerate cases; the printed statement deliberately says "If (17) holds". It therefore cannot make `L02_main_fixedDelta_osc` the statement of Lemma 5.16. See ruling (a) below.

### Ruling (a): verdict-bearing object
- **Verdict-bearing: `L02_main_fixedDelta`** (printed hypotheses (17), ε>0, consumed L01 clause; fixed-δ reading, same convention as L01 gate r2).
- `L02_main` (uniform-in-δ) is retained as the stronger literal reading, not verdict-bearing (same treatment as `L01_main`).
- `L02_main_fixedDelta_osc` is approved only as an **auxiliary, non-verdict-bearing** declaration recording what the printed proof route establishes once (18) — a hypothesis of Theorem 5.14, the only consumer context (L03 and T02 both assume (18)) — is available. Its docstring must stop calling `hosc` a "candidate TFA" (amendment A2).
- Consequence for the prover: along the source route, `L02_main_fixedDelta` reaches S8b (TEX:930), which invokes (18), not a hypothesis of the lemma. Per POLICY §1 the prover must stop the verdict-bearing target there, record it, and may complete `L02_main_fixedDelta_osc` (everything else does not depend on that stop). The prover must **not** rescue `L02_main_fixedDelta` by replacing the TEX:930 justification with a different argument.
- Whether this is a PAPER_ASSUMPTION_GAP is **not** ruled here; see item 7 (my preliminary class is PAPER_ARGUMENT_GAP, because the printed statement appears true under (17) alone).

### 2. Conclusion — PASS
`2^L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖` is exactly `‖x_{Lε}‖ ≥ 2^L‖x_0‖`; `xLF` is the leapfrog `x`-trajectory (TEX:331-335, M=I). Not weakened or strengthened; single clause.

### 3. Quantifiers / constants (focus (d), N5) — PASS
- `Concl`: `∃ η, ∀ x0 p0, η<‖x0‖ → (∃ δ<1, ‖p0‖ ≤ ‖x0‖^δ) → …` = literal reading of TEX:900, η independent of δ, p0.
- `ConclFixedDelta`: `∀ δ<1, ∃ η, …` (η may depend on δ). This is the reading the printed proof supports: its step "ε‖p_0‖/‖x_ε‖ negligible" and (22) "δ' arbitrarily small by choosing ‖x_0‖ large" are fixed-δ arguments; and Theorem 5.14's proof (TEX:879) uses one fixed δ. Consistent with L01 gate r2 (verdict-bearing `L01_main_fixedDelta`).
- `gU, eps, L, d` are fixed before η in both readings: matches the source (η depends on ε and L implicitly; TEX:876 "fixed integration time").
- N2: the second δ of TEX:914-916 is correctly renamed `δ'` in S3/S6.

### 4. Domains and details — PASS
- `E d = EuclideanSpace ℝ (Fin d)`, Euclidean norm (TEX:192-194). `d=0`: conclusion vacuous for η≥0; harmless.
- `‖x0‖ ^ δ` is `Real.rpow` with real δ<1 (negative δ allowed, as in source "some δ<1"). At `‖x0‖=0` the conclusion is trivially true; irrelevant for η large.
- `L=0`: conclusion `‖x0‖ ≤ ‖x0‖`, true; harmless.
- No ENNReal/toReal, measurability or a.e. issues. Division-by-zero conventions: in S2, S5, S7 explicit nonzero premises (`hx`, `hg`) are step-local TFAs; in S3, S6, S8a, S8b the divisors are nonzero for large ‖x0‖ under (17) (or the Lean `/0 = 0` makes the inequality hold anyway); none of them makes an obligation false.

### 5. Step obligations — PASS (all true as stated), with amendment A3 on S10's route description
Truth checked individually (sketches; ε>0 throughout):
| Step | Source | True as stated? | Note |
|---|---|---|---|
| S1 | TEX:906 | yes | `p_{3ε/2} = p0 - (ε/2)g0 - εg1`, so `x2 = x1 + εp0 - (ε²/2)g0 - ε²g1`. |
| S1_general | TEX:364 (Prop 4.2) | yes | checked L=0,1,2 and the induction pattern; derivable from `leapfrogStep`, so Prop 4.2 is correctly not an external parameter. |
| S2 | TEX:910 | yes | from S1: ‖x2‖ ≥ ε²‖g1‖ - ‖x1‖ - (ε²/2)‖g0‖ - ε‖p0‖ ≥ printed form (ε²/2 ≤ ε² on g1; printed weaker coefficient, EDITORIAL). |
| S3 | TEX:913-916 (22) | yes | first conjunct = 2×(L01 S2); second: (2‖x0‖+2ε‖p0‖)/(ε²‖g0‖) → 0 by (17) and ‖p0‖ ≤ ‖x0‖^δ ≤ ‖x0‖ (‖x0‖≥1). |
| S4 | TEX:912 (+924 usage) | yes | middle term ≤ 1/(1-δ') by S3, last term ≤ ε‖x0‖^δ/(2‖x0‖) → 0, first term → ∞ by (17) at x1 (‖x1‖>2‖x0‖ from L01). Conclusion not printed but used at TEX:924: FAIR_IMPLICIT_STEP. |
| S5 | TEX:920 | yes | `x3 = x2 + εp0 - (ε²/2)g0 - ε²g1 - ε²g2`; printed ε²/2 on g2 is weaker. |
| S6 | TEX:922-925 | yes | from S4 and S3. |
| S7 | TEX:927-929 | yes | S1 divided by ε²‖g1‖>0. |
| S8a | TEX:930 (1st sentence) | yes | (17) at x1, ‖x1‖ > 2‖x0‖, ‖p0‖ ≤ ‖x0‖ < ‖x1‖/2. |
| S8b | TEX:930-933 | yes | (18) with x=x0, y=x1 (L01: ‖x1‖ > 2‖x0‖; take η ≥ C/2) gives 3‖g0‖ ≤ ‖g1‖; if g1=0 then g0=0 and 0 ≤ 1/6. Correctly carries `hosc` and not `hexp`. |
| S9 | TEX:934 (1st clause) | yes | assembly of S5–S8 + (17) at x2. |
| S10 | TEX:934 ("entirely analogous") | yes | see focus (c) below. |
| S11 | TEX:934 ("establishing the result") | yes | telescoping; `h10` is S10's shape, not the conclusion. |
- No obligation smuggles the target: S10 is a stronger intermediate statement, but it is the intermediate claim the source itself prints (TEX:934).
- Assembly: S10 (with i=1 from hL01, i=2 S4, i=3 S9) + S11 yields `ConclFixedDelta gU eps L` **under `hosc`**, i.e. `L02_main_fixedDelta_osc`. They do not assemble to the verdict-bearing `L02_main_fixedDelta` (S8b, S9, S10 need `hosc`): this is the correct, faithful outcome — the gap is the paper's, recorded at S8b, not repaired.
- Focus (c), S10: one obligation for "for any fixed i" with η uniform over `1 ≤ i ≤ L` (finite max, fine since L is fixed). It is faithful to TEX:934 and true. I verified that the printed pattern does extend with (18): applied to consecutive pairs (x_{(j-1)ε}, x_{jε}) it gives ‖∇U(x_{jε})‖ ≥ 3‖∇U(x_{(j-1)ε})‖, hence Σ_{k<j}‖∇U(x_{kε})‖ ≤ ‖∇U(x_{jε})‖/2, so every middle term of the generalized S5 is bounded and the first term → ∞ by (17). Because the source gives only the pattern, the S10 docstring must state that pattern as the required route (amendment A3), so that the prover does not substitute a different route (e.g. the Verlet recursion with (17) alone).

### 6. External parameters / consumed clause (focus (b)) — PASS
- `L02_L01Consumed gU eps := Paper.L01.ConclFixedDelta gU eps`, provenance (p), predecessor L01 (Lemma 5.15, TEX:884-886), Lean location `Paper.L01.ConclFixedDelta`, supplied by `Paper.L01.L01_main_fixedDelta gU eps heps hexp` (the L01 verdict-bearing theorem).
- Applicability: L01 needs exactly (17) and ε>0, both hypotheses of every L02 declaration that consumes the clause (S4, S6, S8a, S9, S10 and the mains carry `heps`, `hexp`; S8b carries `heps` but not `hexp` — on reconnection hexp is available in the main theorems, so this is fine). It is standard and correct for a (p) clause to be a bare Prop without hexp/eps>0 inside: the clause's own premises are discharged at reconnection, and the clause is not stronger than what L01 delivers under L02's hypotheses.
- Is it the clause used? Yes: (i) TEX:930-932 applies (18) to the pair (x0, x_ε), which needs ‖x_ε‖ ≥ 2‖x0‖ ≥ C: exactly L01; (ii) the "first term large" steps (S4, S8a) need ‖x_ε‖ → ∞, given by L01; (iii) the i=1 case of TEX:934 "‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖" is L01. The source re-derives L01's S2 inline at TEX:914 (S3 here), which is done without the clause — correctly. Fixed-δ form matches L02's fixed-δ use. L01's `>` is stronger than the `≥` needed: fine.
- Not goal-shaped for L02 (for L≥2 it is a different, weaker statement). Declared only in `L02Stmt.lean`, `namespace Paper.L02`, name `L02_L01Consumed` follows `<ID>_<PredID>Consumed`; no name clash with `L01Stmt` (`Concl`, `ConclFixedDelta` are in `Paper.L01` vs `Paper.L02`, distinct full names).
- No other external parameter. Prop 4.2 not declared: S1/S1_general derivable from `leapfrogStep` (no mathlib claim involved).
- Registry note for coordinator: `verification/EXTERNAL_TOOLS.md` entry for `L02_L01Consumed` (p) should exist; not checked by the gate.

### 7. Doubts about the source — preliminary only, not ruled
1. **TEX:899-901 vs TEX:930** (X5): the proof invokes (18), which Lemma 5.16 does not assume. Preliminary class: **PAPER_ARGUMENT_GAP** (the printed justification uses an unassumed hypothesis). I do not expect ERROR or PAPER_ASSUMPTION_GAP: sketch suggesting the printed (17)-only, fixed-δ statement is true — for i ≥ 1 the leapfrog gives `x_{(i+1)ε} = 2x_{iε} - x_{(i-1)ε} - ε²∇U(x_{iε})` (no p0 term), so with ‖x_{(i-1)ε}‖ ≤ ‖x_{iε}‖/2 and (17) at x_{iε} (‖∇U(x_{iε})‖ ≥ (9/2ε²)‖x_{iε}‖ for ‖x_{iε}‖ large), ‖x_{(i+1)ε}‖ ≥ 2‖x_{iε}‖; base case L01. This is a gate observation, not a ruling and not a route for the prover. Impact likely limited: both consumers (L03, T02) assume (18). **Dispatch pv-issue-checker.**
2. **TEX:934** "entirely analogous argument … for any fixed i": preliminary **FAIR_IMPLICIT_STEP** (the pattern extends with (18) via geometric decay, see item 5), at most EXPOSITION_GAP. Low priority; may be folded into the dispatch of 1.
3. TEX:910, 920: coefficient ε²/2 on ∇U(x_ε), ∇U(x_{2ε}) where the identity gives ε²: printed inequalities remain valid: EDITORIAL. No dispatch.
4. TEX:912/924: ‖x_{2ε}‖ ≥ 2‖x_ε‖ never stated, used at TEX:924; "first term large" via (17) at x_ε not mentioned: FAIR_IMPLICIT_STEP. No dispatch.
5. TEX:914 (N6): checked; `2‖x_ε‖ ≥ ε²‖∇U(x_0)‖ - 2‖x_0‖ - 2ε‖p_0‖` is consistent; no issue.

## TFA table
| Premise | Where | Ruling | Reason |
|---|---|---|---|
| `heps : 0 < eps` | all | context, approved | TEX:336 "step-size ε>0" |
| `hx : xLF … 1 ≠ 0` | S2 | approved (step-local) | division by ‖x_ε‖ at TEX:910 |
| `hx : xLF … 2 ≠ 0` | S5 | approved (step-local) | division at TEX:920 |
| `hg : gU (xLF … 1) ≠ 0` | S7 | approved (step-local) | division at TEX:928 |
| `hδ' : 0 < δ'` | S3, S6 | approved | TEX:916 "δ>0" |
| `hosc : HypOscillations gU` | `L02_main_fixedDelta_osc`, S8b, S9, S10 | **rejected as TFA**; allowed only as the printed proof's own use (S8b–S10) and in the auxiliary non-verdict-bearing `_osc` theorem | (18) not derivable from the lemma's hypotheses; excludes non-degenerate cases; recorded as a paper issue candidate (item 7.1) |

## External parameters table
| Name | Type | Ruling |
|---|---|---|
| `L02_L01Consumed` | (p), L01 TEX:884-886, `Paper.L01.ConclFixedDelta`, applicable via (17) and ε>0 | approved |

## Required changes (docstrings only; no statement change expected, hashes must stay identical)
- **A1** `pv_work/L02Draft.lean` l.18, docstring of `L02_main_fixedDelta`: replace by
  `/-- Fixed-`δ` reading (N5) of the statement AS PRINTED (hypothesis (17) only): the VERDICT-BEARING form (gate L02).  Along the source route it stops at S8b (TEX:930 invokes (18), not a hypothesis of the lemma): record the stop, do not replace the TEX:930 justification. -/`
- **A2** `pv_work/L02Draft.lean` l.24-28, docstring of `L02_main_fixedDelta_osc`: replace by
  `/-- AUXILIARY, NOT verdict-bearing (gate L02): Lemma 5.16 with hypothesis (18) (`HypOscillations`, TEX:868-871, a hypothesis of Thm 5.14) added.  `hosc` is NOT a TFA; this records that the printed proof route (which invokes (18) at TEX:930) establishes the conclusion under (17)+(18).  Assembly: S10 + S11. -/`
- **A3** `pv_work/L02Draft.lean` l.146-149, docstring of `L02_S10`: append the route:
  `Required route (gate L02): i=1 from hL01, i=2 = S4, i=3 = S9; for i ≥ 4 the pattern of S5–S9 with i in place of 3: the one-step identity x_{iε} = x_{(i-1)ε} + εp_0 - (ε²/2)∇U(x_0) - ε²Σ_{j=1}^{i-1}∇U(x_{jε}) (from S1'), middle terms bounded by lower-bounding their reciprocals as in S6–S8, (18) applied to consecutive pairs (x_{(j-1)ε}, x_{jε}), and the first term made large by (17) at x_{(i-1)ε}.  A different route is not the source route. -/`
- (Non-binding, notes are the drafter's) notes l.18 and l.32: replace "candidate TFA"/"PAPER_ASSUMPTION_GAP" wording by the gate rulings above.

## Statement snapshot (verbatim TYPE HASHES)

From `pv_work/logs/gate_L02_stmtcopy_1.log` (copy of L02Stmt.lean):
```
TYPE HASHES (current file, 3 declarations)
Paper.L02.ConclFixedDelta|def|th=1855146743|vh=342785589|bi=ieee
Paper.L02.Concl|def|th=1855146743|vh=4272201556|bi=ieee
Paper.L02.L02_L01Consumed|def|th=922123888|vh=4177531171|bi=iee
EXIT=0
```
From `pv_work/logs/gate_L02_draftcopy_1.log` (copy of L02Draft.lean):
```
TYPE HASHES (current file, 16 declarations)
Paper.L02.L02_S10|thm|th=2504945767|vh=-|bi=ieeeeeeeee
Paper.L02.L02_S11|thm|th=2543577539|vh=-|bi=ieeeeeeeeeee
Paper.L02.L02_S1_general|thm|th=3818633226|vh=-|bi=ieeeee
Paper.L02.L02_S1|thm|th=2823882939|vh=-|bi=ieeee
Paper.L02.L02_S2|thm|th=3952422445|vh=-|bi=ieeeeee
Paper.L02.L02_S3|thm|th=1987123589|vh=-|bi=ieeeeeeee
Paper.L02.L02_S4|thm|th=46405899|vh=-|bi=ieeeeeee
Paper.L02.L02_S5|thm|th=606143364|vh=-|bi=ieeeeee
Paper.L02.L02_S6|thm|th=2783452467|vh=-|bi=ieeeeeeeee
Paper.L02.L02_S7|thm|th=997402863|vh=-|bi=ieeeeee
Paper.L02.L02_S8a|thm|th=394698109|vh=-|bi=ieeeeeeeee
Paper.L02.L02_S8b|thm|th=3417155813|vh=-|bi=ieeeeeee
Paper.L02.L02_S9|thm|th=2975002559|vh=-|bi=ieeeeeeee
Paper.L02.L02_main_fixedDelta_osc|thm|th=1639984634|vh=-|bi=ieeeeeee
Paper.L02.L02_main_fixedDelta|thm|th=397542044|vh=-|bi=ieeeeee
Paper.L02.L02_main|thm|th=3808770304|vh=-|bi=ieeeeee
EXIT=0
```

## Overall verdict

Statements, step obligations and the consumed clause are faithful and true as stated; verdict-bearing target `L02_main_fixedDelta`; `hosc` rejected as TFA, `L02_main_fixedDelta_osc` auxiliary only; three docstring amendments (A1–A3) required, then an amendment check (r2).

STATEMENT GATE: PASS_WITH_AMENDMENTS
