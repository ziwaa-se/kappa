# L02 statement gate (Lemma 5.16, `lem:xlower`), revision 1

- Reviewer: pv-gate (independent subagent, Claude Opus 5.5); not the drafter.
- Date: Tue Oct 13 10:43:04 EDT 2026 (`date`).
- Mode: full gate of the post-revision draft (the pre-revision L02 gate is archived in `verification/audits/rev1/`).

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

```
e2ad9bd64ae47f4f913ba1056de7d7370e4a9d7c75e9fc75808bc58a6b94d045  pv_work/L02Stmt.lean
3efe5f5f58d802ac3a62c4c75bba86680f9fc892b6c71bdcd3712313658f72b3  pv_work/L02Draft.lean
a3729c3d2ce0789a41b061fc86033df7e0d3d0975e2e7eaff59526db30909050  pv_work/L01Stmt.lean   (same hash as reviewed in L01_gate.md)
e573c173018c4d76c43445dec04b28371b1c4a1b070dc9de1a4f2c14f38d3472  pv_work/Defs.lean
```

## Compilation

- `scripts/pv_lean.sh check L02Draft`: `RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=10 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_6.log`. EXIT=0; the 10 sorries are the 10 draft theorems (main + S1..S8 incl. S4a/S4b).
- Staleness check of the compiled `L02Stmt.olean` the draft imports: `pv_work/probes/gate/L02/gate_L02_oleancheck_postrev1.lean` (`#pv_type_hashes L02Stmt`), log `pv_work/logs/gate_L02_oleancheck_postrev1_1.log`, exit 0: the hashes equal those of the text copy below, so the olean corresponds to the reviewed text.

## Source quotations (read directly in `source/geo_erg_HMC_v3.1.tex`)

- Statement, TEX:960-966: "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\| \leq \|x_0\|^\delta$ for any fixed $\delta < 1$, it holds that $\|x_{i\e}\|\geq 3\|x_{(i-1)\e}\|, i = 1, \ldots, L$, (eqn:stepwise) meaning $\|x_{L\e}\| \geq 3^L\|x_0\|$."
- (17) `eqn:explode`, TEX:897-899: $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$. Content identical to the previous manuscript (`verification/source_baseline_v1/…:865-867`); only line numbers moved.
- Leapfrog recursion and $\e>0$, TEX:330-336 (with $M=I$, Remark TEX:354-356 as encoded in `Defs.lean`).
- Proof, TEX:968-1007: recurrence (971-974) for $i\ge1$; threshold $R$ with $\e^2\|\nabla U(x)\|/\|x\|\ge16/3$ for $\|x\|\ge R$ by (17) (976-981); choose $\|x_0\|\ge\max(R,\eta)$, case $i=1$ from Lemma `lem:xelower` (982-983); norm inequality and $1/3$ (984-997); $\|x_{i\e}\|\ge\|x_0\|\ge R$ (998-999); $16/3-7/3=3$ (1000-1004); induction and $3^L$ (1005-1006).
- Predecessor L01 (`lem:xelower`), TEX:945-947: $\|x_\e\|>3\|x_0\|$ for $\|x_0\|>\eta$, $\|p_0\|\le\|x_0\|^\delta$, fixed $\delta<1$, under (17).
- I confirm by reading TEX:960-1007 that neither (18) `eqn:oscillations` (TEX:900-903) nor (19) `eqn:oscillation2` (TEX:905-907) is stated as a hypothesis or invoked anywhere in the statement or proof of the revised lemma. (They first reappear in Lemma `lem:arate_0`, TEX:1012.)

## Rulings

### 1. Hypotheses: PASS
- (17) -> `hexp : HypExplode gU` (Defs:75-76; Tendsto of `‖gU x‖/‖x‖` along `comap ‖·‖ atTop` to `atTop`) — faithful.
- `heps : 0 < eps` — the source's standing convention TEX:336, not a TFA.
- `hL01 : L02_L01Consumed gU eps` — consumed clause (p), see §6.
- No (18)/(19) hypothesis: correct for the revised source (see above). The stale `HypOscillations`/`HypOscillation2` in Defs are not imported into the statement's content.
- `gU` is an arbitrary function (no `IsGradField`): this drops an unused hypothesis, which only makes the Lean theorem more general; the source proof uses nothing about $U$ beyond $\nabla U$ in the recursion and (17). Acceptable.
- No hidden hypotheses: no `variable`, `structure` or type class in L02Stmt/L02Draft; L01Stmt and Defs contain definitions only.
- No conclusion-as-hypothesis form.

### 2. Conclusion: PASS
`Concl gU eps L δ` has both printed clauses: (a) stepwise `∀ i, 1 ≤ i → i ≤ L → 3‖x_{i-1}‖ ≤ ‖x_i‖` = eqn:stepwise TEX:963 (non-strict, as printed); (b) `(3:ℝ)^L * ‖x0‖ ≤ ‖x_L‖` = "meaning $\|x_{L\e}\|\ge3^L\|x_0\|$" TEX:965. 3^L reading: natural power of 3, factor on `‖x0‖`, non-strict — exactly the printed inequality. Keeping (b) as a separate conjunct is faithful to "meaning" (it is a consequence of (a), proved in S8, as the proof says at 1005-1006). Neither weakened nor strengthened. Natural-number subtraction `i - 1` is harmless since `1 ≤ i`.

### 3. Quantifiers / constants: PASS
Order: `gU, eps, L` (theorem arguments), then `∀ δ < 1`, then `∃ η`, then `∀ x0 p0`. "for any fixed δ<1" read as δ fixed before η, same convention as the gate-passed `Paper.L01.Concl`; a δ-uniform η is not what the proof gives (η comes from L01 for the fixed δ) and is not a reasonable reading. η may depend on ε, L, ∇U, δ — consistent with the proof (R depends on ε, ∇U; η of L01 on δ, ε, ∇U). Strict `η < ‖x0‖` matches TEX:961.

### 4. Domains and details: PASS
`E d = EuclideanSpace ℝ (Fin d)` with Euclidean norm (TEX:192-194). Non-periodic, pointwise statements, no measure theory, no ℝ≥0∞. `‖x0‖ ^ δ` is `Real.rpow`, fine for `‖x0‖ > η ≥ …` (the prover will choose η ≥ 0). d = 0 makes everything vacuous/true, not a distortion. L = 0 makes the statement trivially true; the source has L ≥ 1 implicitly — no distortion.

### 5. Step obligations: PASS (all true as stated; I checked each, including for missing premises)
| Step | Source | True as stated? | Remark |
|---|---|---|---|
| S1 | 969-975 | Yes | Checked by hand from `leapfrogStep`: for i ≥ 1, p_i = ph_{i-1} − (ε/2)∇U(x_i), ph_i = ph_{i-1} − ε∇U(x_i), x_{i+1} = x_i + ε ph_{i-1} − ε²∇U(x_i), and ε ph_{i-1} = x_i − x_{i-1}. `hi : 1 ≤ i` is needed and present. No ε>0 needed. |
| S2 | 976-981 | Yes | Needs ε ≠ 0 (present via `heps`). ∃R lets the prover pick R > 0, so Lean's `/0 = 0` at x = 0 does not falsify it. For d = 0 the filter is ⊥ and any R > 0 works vacuously. |
| S3 | 982-983 | Yes | Immediate from `hL01 δ hδ` (strict ⇒ non-strict; `xLF … 0 = x0` by definition). |
| S4a | 984-993 | Yes | Triangle inequality on S1, divided by `‖x_i‖ > 0` (premise `hx`, present). |
| S4b | 993-996 | Yes | `hind` and `hx` give ratio ≤ 1/3. |
| S5 | 998-999 | Yes | 3a ≤ b with a ≥ 0 gives a ≤ b; induction from j = 1..i; trivial for i = 0. |
| S6 | 1000-1004 | Yes | From h: ‖x_i‖ ≥ 3^i‖x0‖ > 0 and ≥ R; hR gives ε²‖∇U(x_i)‖ ≥ (16/3)‖x_i‖; then ‖x_{i+1}‖ ≥ (16/3 − 2 − 1/3)‖x_i‖ = 3‖x_i‖. Premises `hx0`, `hRx`, `hi` are all needed and present. |
| S7 | 1005 | Yes | Base `hbase` + S6 by strong induction up to L. |
| S8 | 1005-1006 | Yes | Telescoping; trivial for L = 0. |
| main | 960-966 | — | Assembles: η' := max(η_S3, R, 0) gives ‖x0‖ > 0, ‖x0‖ ≥ R, base case; S7 for (a), S8 for (b). The obligations together yield the main theorem. |

No obligation smuggles in the target conclusion or a stronger intermediate conclusion; S6/S7 have the stepwise bound only up to i as hypothesis, matching the induction hypothesis of TEX:983-984 (plus "the preceding steps of the induction", 998).

### 6. External parameters: PASS
Only `L02_L01Consumed gU eps := ∀ δ < 1, Paper.L01.Concl gU eps δ`, provenance (p).
- Location in predecessor: L01 = Lemma 5.15, TEX:945-947, Lean `Paper.L01.Concl` (L01Stmt.lean:17-19), main theorem `Paper.L01.L01_main` (`∀ δ<1, Concl gU eps δ` under `0 < eps` and `HypExplode gU`), L01 statement gate PASS (`verification/audits/L01_gate.md`, same L01Stmt hash).
- Applicability here: L01's hypotheses (ε > 0, (17)) are exactly `heps`, `hexp`, which L02_main also assumes; same `gU`, `eps`. Use at TEX:982-983 ("Lemma lem:xelower applies"). The clause is exactly L01's conclusion, not stronger; not goal-shaped (it is the base case only).
- Naming/location: declared only in `L02Stmt.lean`, in `namespace Paper.L02`, named `<ID>_<PredID>Consumed`; no other Stmt file declares it (searched `pv_work`; occurrences only in L02 files, probes, logs, `superseded/`). `Concl` is also a name in `Paper.L01`, but in a different namespace — no redeclaration.
- No "mathlib lacks X" claim made; none to check.

### 7. Doubts about the source: none requiring dispatch
- Division by ‖x_{iε}‖ and by ‖x‖ in (gradthreshold) without stating nonvanishing: FAIR_IMPLICIT_STEP (‖x_{iε}‖ ≥ ‖x_0‖ > 0 once η ≥ 0; R can be taken positive). Not an issue.
- TEX:982 "‖x_0‖ ≥ max(R,η)" against L01's strict "‖x_0‖ > η", and reuse of the symbol η for L01's and L02's constant: EDITORIAL (take η' larger). Not an issue.
- The old pre-revision gap (use of (18) not assumed) is not present in the revised text; I make no ruling about the earlier issue record.

Documentation note (not a gate condition, for `verification/DOC_ERRATA.md` by the coordinator): `Defs.lean` docstrings cite old line numbers (e.g. HypExplode "TEX:865-867", now 897-899; HypOscillations "2‖x‖" and HypOscillation2 describe the pre-revision (18)/(19)). Not used by L02.

## TFAs ruled on

| Premise | Where | Ruling | Reason |
|---|---|---|---|
| `hx : 0 < ‖x_i‖` | S4a, S4b | Approved (FAIR_IMPLICIT_STEP) | The source divides by ‖x_{iε}‖; derivable from ‖x_i‖ ≥ ‖x_0‖ > η' ≥ 0. Inside steps only. |
| `hx0 : 0 < ‖x0‖` | S6, S7 | Approved (FAIR_IMPLICIT_STEP) | Derivable in the main theorem by choosing η' ≥ 0; excludes only x_0 = 0, which the large-‖x_0‖ statement never concerns. |
| main theorem | — | No extra premise | `heps` is the source convention TEX:336. |

## External parameters

| Name | Type | Ruling |
|---|---|---|
| `Paper.L02.L02_L01Consumed` | (p), from L01 = Lemma 5.15 TEX:945-947 (`Paper.L01.Concl`), used at TEX:982-983 | Approved |

## Required changes

None.

## Statement snapshot

Copies (the previously named `gate_L02_stmtcopy.lean`/`gate_L02_draftcopy.lean` in this directory are pre-revision evidence of the archived gate and were not overwritten):
`pv_work/probes/gate/L02/gate_L02_stmtcopy_postrev1.lean` (log `pv_work/logs/gate_L02_stmtcopy_postrev1_1.log`, exit 0, 0 sorry) and
`pv_work/probes/gate/L02/gate_L02_draftcopy_postrev1.lean` (log `pv_work/logs/gate_L02_draftcopy_postrev1_1.log`, exit 0, 10 sorry).

L02Stmt copy:
```
TYPE HASHES (current file, 2 declarations)
Paper.L02.Concl|def|th=2681478247|vh=2974810005|bi=ieeee
Paper.L02.L02_L01Consumed|def|th=922123888|vh=4054971085|bi=iee
EXIT=0
```

L02Draft copy:
```
TYPE HASHES (current file, 10 declarations)
Paper.L02.L02_S1|thm|th=3896543934|vh=-|bi=ieeeeee
Paper.L02.L02_S2|thm|th=2363939114|vh=-|bi=ieeee
Paper.L02.L02_S3|thm|th=4102947040|vh=-|bi=ieeeee
Paper.L02.L02_S4a|thm|th=2264665807|vh=-|bi=ieeeeeee
Paper.L02.L02_S4b|thm|th=2324056906|vh=-|bi=ieeeeeee
Paper.L02.L02_S5|thm|th=1414513616|vh=-|bi=ieeeeee
Paper.L02.L02_S6|thm|th=914684241|vh=-|bi=ieeeeeeeeeee
Paper.L02.L02_S7|thm|th=4030812281|vh=-|bi=ieeeeeeeeeeeee
Paper.L02.L02_S8|thm|th=1601247910|vh=-|bi=ieeeeee
Paper.L02.L02_main|thm|th=2231646710|vh=-|bi=ieeeeeeee
EXIT=0
```

STATEMENT GATE: PASS
