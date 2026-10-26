# L01 statement gate (revision 1 of the manuscript) — Lemma 5.15 (lem:xelower)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Tue Oct 13 10:41:09 EDT 2026
- Previous gate (old manuscript): `verification/audits/rev1/L01_gate.md` (not reused; this review is from scratch against `source/`).

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)
```
a3729c3d2ce0789a41b061fc86033df7e0d3d0975e2e7eaff59526db30909050  pv_work/L01Stmt.lean
f578611d10c963ce8a51a731f314a2835b90a8836abff01cab3a30f85e537c10  pv_work/L01Draft.lean
280010c74056d4a4c9db733dd0639758791380c116bb47711ed519793f20d215  pv_work/notes/L01_draft_notes.md
e573c173018c4d76c43445dec04b28371b1c4a1b070dc9de1a4f2c14f38d3472  pv_work/Defs.lean
```

## Compilation
`scripts/pv_lean.sh check L01Draft`:
`RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_8.log olean=none`
(6 sorries = S1..S6, expected for a draft; `L01_main` itself is assembled from S6 without sorry.)

## Source quotations (read directly)
- Statement, source/geo_erg_HMC_v3.1.tex:945-947: "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\|\leq \|x_0\|^\delta$ for any fixed $\delta<1$, it holds that $\|x_\e\|>3\|x_0\|$."
- Proof, TEX:949-958: TEX:951 "$\|x_\e\| = \| x_0 - \frac{\e^2}{2}\nabla U(x_0) + \e p_0 \| \geq \frac{\e^2}{2}\|\nabla U(x_0)\| - \|x_0\| - \e\|p_0\|$"; TEX:955 division by $\|x_0\|$; TEX:957 "The first term on the right-hand side tends to infinity by (17), while the last term is bounded above by $\e\|x_0\|^{\delta-1}$ and tends to zero. Hence the right-hand side is larger than $3$ for all sufficiently large $\|x_0\|$."
- (17) eqn:explode, TEX:897-899: $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$.
- Leapfrog recursion TEX:330-336 (with M = I by the Remark TEX:354-356), "for some step-size $\e>0$" (TEX:336).
- Comparison with old manuscript (`verification/source_baseline_v1/geo_erg_HMC_v3.1.tex:884-885`): old text "for some $\delta<1$ ... $\|x_\e\|>2\|x_0\|$"; new text "for any fixed $\delta<1$ ... $>3\|x_0\|$". Confirmed lines 945-947 / 949-958 in the current source.

## Item 1. Hypotheses — PASS
- (17) ↦ `h : HypExplode gU` (Defs; `Tendsto (‖gU x‖/‖x‖) (comap norm atTop) atTop`), faithful (DEFS gate).
- `heps : 0 < eps`: printed at TEX:336 ("step-size ε>0"); not an extra premise. It is needed: at ε = 0, x_ε = x_0 and the conclusion fails. (Algorithm 1, TEX:342, writes ε ≥ 0; the lemma's own context, the leapfrog definition, has ε > 0.)
- No `variable`s, structures or type classes beyond `d : ℕ`; `gU` is an arbitrary map (not tied to a U via `IsGradField`), which only makes the statement more general; harmless since the proof uses only values of ∇U.
- No conclusion-shaped hypothesis.

## Item 2. Conclusion — PASS
`Concl gU eps δ := ∃ η, ∀ x0 p0, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → 3‖x0‖ < ‖xLF gU eps x0 p0 1‖`. Strict inequality and factor 3 as in TEX:946. `xLF … 1` is x_ε (one leapfrog step); I unfolded `leapfrogStep` myself: x' = x0 + ε(p0 − (ε/2)gU x0) = x0 − (ε²/2)gU x0 + εp0, matching TEX:951. `‖x0‖^δ` is `Real.rpow` with base ≥ 0; fine for all real δ.

## Item 3. Quantifiers / dependence of constants — PASS
Main: `∀ eps>0, HypExplode → ∀ δ<1, ∃ η, …`. η may depend on d, gU, ε, δ, not on x0, p0. The source says "for any fixed δ<1", and the proof (TEX:957, "tends to zero" for ε‖x0‖^{δ−1}) is a fixed-δ argument; downstream (TEX:911 "Fix any δ<1") also fixes δ first. The fixed-δ reading is faithful.
Remark (not a required change): the draft notes claim the uniform-in-δ reading is "false/unsupported". That is incorrect: for ‖x0‖ > 1 and δ < 1, ‖p0‖ ≤ ‖x0‖^δ ≤ ‖x0‖, so ‖x_ε‖ ≥ ‖x0‖((ε²/2)‖∇U(x0)‖/‖x0‖ − 1 − ε), which exceeds 3‖x0‖ eventually by (17), uniformly in δ. The uniform reading is therefore also true, but the source text and proof are the fixed-δ argument, so the weaker, faithful encoding is the right one. No paper issue either way.

## Item 4. Domains and details — PASS
R^d Euclidean (`E d`), no periodicity; pointwise statement (no a.e.); η existence only; no ENNReal/toReal. Degenerate d = 0: `HypExplode` vacuous and `Concl` vacuously true with η = 0; the source does not discuss d = 0, and the statement is true there, so no problem. Division by ‖x0‖ = 0 only occurs outside the tail (S3 carries `x0 ≠ 0`).

## Item 5. Step obligations — PASS (all true as stated)
| Step | Source | True as stated? | Remarks |
|---|---|---|---|
| S1 | TEX:951 (equality) | yes, by unfolding `leapfrogStep` (ε·ε/2 = ε²/2) | no hypotheses needed |
| S2 | TEX:951 (inequality) | yes: ‖x0 − a + b‖ ≥ ‖a‖ − ‖x0‖ − ‖b‖, ‖ε•p0‖ = ε‖p0‖ uses ε > 0 | |
| S3 | TEX:955 | yes (x0 ≠ 0 ⇒ ‖x0‖ > 0, divide S2) | |
| S4 | TEX:957 "tends to zero" | yes (δ−1 < 0, ε > 0) | The "bounded above by ε‖x0‖^{δ−1}" half mentioned in the docstring is not part of S4's type; it is left to S6. EDITORIAL only. |
| S5 | TEX:957 first term → ∞ by (17) | yes, from `HypExplode` and ε²/2 > 0; vacuous at d = 0 | |
| S6 | TEX:957 "Hence … larger than 3" | yes (combine S3–S5 with the bound ‖p0‖/‖x0‖ ≤ ‖x0‖^{δ−1}) | same type as the conclusion, as the final step of the proof; uses only the lemma's hypotheses |
Assembly: `L01_main` follows from S6 directly (compiled without sorry in its own body). No smuggled stronger intermediate claim.

## Item 6. External parameters — PASS (none)
No `def … : Prop` tool; Prop 4.2 is not needed since the L = 1 formula follows from the definition. Nothing declared outside `namespace Paper.L01`; no redeclared names.

## Item 7. Doubts about the source — none for L01
No suspected paper issue in TEX:945-958.

## TFA table
| Premise | Ruling | Reason |
|---|---|---|
| `0 < eps` | not a TFA (printed, TEX:336) | approved as a source hypothesis |
| `x0 ≠ 0` in S3 | internal step premise, not a hypothesis of the main theorem | approved (holds in the tail ‖x0‖ > η ≥ 0 chosen by the prover) |

## External parameters table
None.

## Note on Defs / DEFS_gate scope (requested by coordinator)
Compared `source/` with `verification/source_baseline_v1/`:
- (18) eqn:oscillations: old TEX:868 "whenever ‖y‖ ≥ 2‖x‖ ≥ C"; new TEX:900 "whenever ‖y‖ ≥ 3‖x‖ ≥ C" (conclusion ‖∇U(y)‖ ≥ 3‖∇U(x)‖ unchanged, TEX:902). `Paper.Defs.HypOscillations` (Defs.lean:80-81) still encodes `2‖x‖ ≤ ‖y‖`, `C ≤ 2‖x‖`. It is **stale** w.r.t. the revised source. The DEFS gate (`verification/audits/DEFS_gate.md`, quoting old TEX:868-871) ruled on the old text, so its ruling on `HypOscillations` does **not** cover the revised manuscript: DEFS_gate scope is affected for this definition (consumers L02/L03/T02 must not rely on it as faithful to TEX:900; a new definition in a new Defs file plus a gate is needed).
- (19) eqn:oscillation2: the revised source TEX:906 still reads `‖y‖ ≥ 2^L‖x‖` (identical to old TEX:874). `HypOscillation2` (2^L) is therefore **faithful to the printed text**; it is not stale. The drafter's observation is instead that L02 now concludes ‖x_{Lε}‖ ≥ 3^L‖x0‖ (TEX:965) while (19) is stated with 2^L; since 3^L‖x0‖ ≥ 2^L‖x0‖ this is compatible (the region in (19) contains the region reached) and is a matter for the T02 gate, not a Defs defect.
- Docstring line references in Defs.lean (e.g. TEX:865-867, 868-871, 874) are old numbering; comment errata go to `verification/DOC_ERRATA.md` (not edited by this gate).
- L01 uses only `E`, `leapfrogStep`/`leapfrogState`/`xLF` and `HypExplode`; these are unchanged in meaning by the revision ((17) at TEX:897-899 identical; leapfrog TEX:330-336). L01 is not affected.

## Required changes
None.

## Statement snapshot
`pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (`pv_work/logs/gate_L01_stmtcopy_2.log`):
```
TYPE HASHES (current file, 1 declarations)
Paper.L01.Concl|def|th=4268608173|vh=2240327948|bi=ieee
```
`pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (`pv_work/logs/gate_L01_draftcopy_2.log`):
```
TYPE HASHES (current file, 7 declarations)
Paper.L01.L01_S1|thm|th=4288029101|vh=-|bi=ieeee
Paper.L01.L01_S2|thm|th=550043121|vh=-|bi=ieeeee
Paper.L01.L01_S3|thm|th=718125916|vh=-|bi=ieeeeee
Paper.L01.L01_S4|thm|th=4219512448|vh=-|bi=eeeeee
Paper.L01.L01_S5|thm|th=2586431750|vh=-|bi=ieeeee
Paper.L01.L01_S6|thm|th=3401643150|vh=-|bi=ieeeeee
Paper.L01.L01_main|thm|th=1377851445|vh=-|bi=ieeeeee
```

STATEMENT GATE: PASS
