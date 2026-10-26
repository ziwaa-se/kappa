# L03 statement gate (Lemma 5.17, lem:arate_0), revised manuscript

- Reviewer: pv-gate (independent subagent, opus)
- Date: Tue Oct 13 10:54:17 EDT 2026 (from `date`)
- Source: source/geo_erg_HMC_v3.1.tex:1011-1016 (statement), 1018-1096 (proof); hypotheses (17)-(19) at 895-909; leapfrog/Prop. 4.2 at 330-336, 361-374; L02 (lem:xlower) at 960-1007.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - pv_work/L03Stmt.lean `42fcf7cd82a9d77fa1fdb0d555caea9e0415a9629257d1c70aa13018529c07c6`
  - pv_work/L03Draft.lean `dffd5c4c71e6f819147152c2e25e72d0bb3bfd11e3510aaad0b80dcd1f825d66`
  - pv_work/L02Stmt.lean (imported) `e2ad9bd64ae47f4f913ba1056de7d7370e4a9d7c75e9fc75808bc58a6b94d045`
  - pv_work/Defs.lean (imported) `e573c173018c4d76c43445dec04b28371b1c4a1b070dc9de1a4f2c14f38d3472`
- Compilation: `scripts/pv_lean.sh check L03Draft` -> `RESULT L03Draft mode=check exit=0 errors=0 sorry_warnings=16 nonstandard_axiom_lines=0 log=pv_work/logs/L03Draft_4.log`. 16 sorry = main + S1, S2, S3, S4a, S4b, S5..S14 (15 steps), as expected for a draft.
- Draft notes were read as leads only; every point below was checked against the .tex.

## Source quotations

- TEX:1011-1015: "If (eqn:explode), (eqn:oscillations) and (eqn:oscillation2) hold then for any $\delta<1$ it holds that $\lim_{\|x_0\|\to\infty,\|p_0\|\leq\|x_0\|^\delta} \alpha(x_0,x_{L\e}) = 0$."
- (17) TEX:897-899: $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$.
- (18) TEX:900-903 (revised): "there is a fixed $C<\infty$ such that whenever $\|y\|\geq 3\|x\|\geq C$ then $\|\nabla U(y)\|\geq 3\|\nabla U(x)\|$".
- (19) TEX:905-907: $\lim_{\|x\|\to\infty, \|y\|\geq 2^L\|x\|}(U(x)-U(y)-\frac12\|x\|^2) = -\infty$.
- TEX:908: "fixed integration time $T=L\e$ ... for any choice $T>0$"; TEX:336: step-size $\e>0$.
- TEX:1021: $\alpha = 1\wedge\exp(U(x_0)-U(x_{L\e})+\frac12\|p_0\|^2-\frac12\|p_{L\e}\|^2)$; TEX:366-373 Prop. 4.2 (acceptance, eqn:mprop2).
- L02 revised (TEX:960-965): $\eta$ exists s.t. for $\|x_0\|>\eta$, $\|p_0\|\le\|x_0\|^\delta$ (any fixed $\delta<1$): $\|x_{i\e}\|\ge3\|x_{(i-1)\e}\|$, $i=1..L$, "meaning" $\|x_{L\e}\|\ge3^L\|x_0\|$.
- Proof steps quoted per obligation below (TEX:1023-1095).

## 1. Hypotheses: PASS

- (17) -> `HypExplode gU` (Defs, unchanged, TEX:898). (18) -> `Paper.L03.HypOscillations3` (L03Stmt:24-25): `∃ C, ∀ x y, 3‖x‖ ≤ ‖y‖ → C ≤ 3‖x‖ → 3‖gU x‖ ≤ ‖gU y‖`; exact match of revised TEX:900-903 (the frozen `Paper.Defs.HypOscillations` is the stale `2‖x‖` form and is correctly NOT used). Text is identical to `Paper.C01.HypOscillations3` (C01Stmt:35-36); full names differ, so no redeclaration clash. (19) -> `HypOscillation2 U L` (Defs:86-90), filter = `‖x‖→∞` ⊓ region `2^L‖x‖ ≤ ‖y‖`, matching TEX:906 with the same `L` as the leapfrog length.
- `heps : 0 < eps` from TEX:336. `hL : 1 ≤ L`: TFA-1, approved (table below).
- Dropped source context: `IsGradField U gU` and `U ≥ 0` (TEX:320) are not assumed. This only weakens the hypotheses (the Lean statement implies the source statement); I checked that no step S1-S14 needs either (all steps are about the leapfrog recursion with `gU` as an arbitrary field). Acceptable.
- No hidden hypotheses: no `variable`s, structures or type classes; imported Defs/L02Stmt contain only definitions.
- No hypothesis states the conclusion or an equivalent: `hL02` is L02's conclusion (positions only), not acceptance.

## 2. Conclusion: PASS

`Concl U gU eps L δ := Tendsto (accProb ... q.1 q.2) (tailMomFilter d δ) (𝓝 0)`. `tailMomFilter` = `comap ‖q.1‖ atTop ⊓ 𝓟{‖q.2‖ ≤ ‖q.1‖^δ}`; Tendsto along it is exactly "for every neighbourhood there is R with all (x0,p0), ‖x0‖ ≥ R, in the region", i.e. the uniform limit used at TEX:913-915 and 1094-1095. `accProb` (Defs:61-64) is Prop. 4.2's form `1 ∧ π(x_L)/π(x_0) exp(...)` with `π = e^{-U}`, equal to TEX:1021 (S1). Neither weakened nor strengthened; single clause.

## 3. Quantifiers and constants: PASS

`U, gU, eps, L` fixed, then `∀ δ < 1`, then the limit (η depends on δ, ε, L, gU, U), as in TEX:1012 ("for any δ<1"). C of (18) is existential inside the hypothesis, fixed before x0 (TEX:900 "fixed C"). Consumed clause gives η per δ, consistent.

## 4. Domains and details: PASS

`E d` = Euclidean ℝ^d (TEX:192-194). `‖x0‖^δ` is `Real.rpow` with `‖x0‖>0` on the relevant set. No a.e./measurability issues (pointwise statement). No ENNReal. d = 0 makes the filter ⊥ (trivially true), harmless.

## 5. Step obligations: PASS (all true as stated, each checked)

| Step | Source | True as stated? | Comment |
|---|---|---|---|
| S1 | 1019-1022 | yes | exp(-U xL)/exp(-U x0)·exp(B) = exp(U x0 - U xL + B). |
| S2 | 371-373 (eqn:mprop2), used 1030-1036 | yes (needs L≥1, present) | p_{n+1} = p_n - (ε/2)g(x_n) - (ε/2)g(x_{n+1}); telescoping. Derived from Defs, not an input. |
| S3 | 1030-1036 first line | yes | reverse triangle; `heps` gives |ε| = ε. |
| S4a | 1023-1024 | yes | L02 stepwise (1≤i≤L) reindexed to i<L; ‖x_i‖ ≥ ‖x0‖ by iteration, take η ≥ max(η_L02, C/3). |
| S4b | 1025-1029 (eqn:gradgeometric) | yes | (18) applied to pairs (x_j, x_{j+1}), j=i..L-1, iterated: factor (1/3)^{L-i}. Hypotheses supplied by `h`, not goal-shaped. |
| S5 | 1036-1040 | yes | Σ_{i=1}^{L-1}‖g_i‖ ≤ Σ_{k=1}^{L-1}3^{-k}G (reindex i ↦ L-i) and (1/2)‖g_0‖ ≤ (1/2)3^{-L}G ≤ 3^{-L}G; G ≥ 0, ε>0. |
| S6 | 1041-1047 | yes | Σ_{i=1}^L 3^{-i} = (1-3^{-L})/2; holds for all L, ε, G. |
| S7 | 1049-1051 | yes | ‖gU x_L‖ ≥ M‖x_L‖ ≥ M3^L‖x0‖ (17 + L02), ‖p0‖ ≤ ‖x0‖^δ ≤ ‖x0‖ for ‖x0‖≥1. |
| S8 | 1052-1065 | yes | 0 < a-b ≤ P ⇒ (a-b)² ≤ P², expansion with a = εγG/2. |
| S9 | 1066-1075 | yes | rearrangement of S8. |
| S10 | 1076-1083 | yes | as S7 with factor 2‖x0‖; ‖p0‖ ≤ ‖x0‖ for ‖x0‖ ≥ 1, δ<1. |
| S11 | 1084-1085 | yes | c := εγG/4 ≥ 2a ≥ 0; 4c(b-c) ≤ 4c(a-c) ≤ -2c² ≤ -8a² ≤ -a². (heps, hγ unused but harmless.) |
| S12 | 1086-1091 | yes | arithmetic. |
| S13 | 1092-1093 | yes | q ↦ (q.1, x_L) maps tailMomFilter into the (19) filter: ‖q.1‖→∞ kept, eventually 2^L‖x0‖ ≤ 3^L‖x0‖ ≤ ‖x_L‖ (L02). |
| S14 | 1093-1095 | yes | eventual bound (hbound, eventually in tailMomFilter) + S1 + S12 + h13 ⇒ exponent → -∞ ⇒ min 1 exp → 0. `hbound` is an intermediate, not the conclusion. |

Assembly: S4a (with C from `hosc`) → S4b → S5; S3 (via S2) + S5 + S6 give ‖p_L‖ ≥ (εγ/2)G - ‖p0‖; S7 positivity → S8 → S9; S10 → S11 ⇒ hbound (eventually, η = max of the S4a/S7/S10 η's); S13 + S14 ⇒ Concl. The obligations together yield `L03_main`. No smuggled conclusion; no obligation stronger than its source sentence.

Implicit steps asked about:
- TEX:1036-1040 reindexing (i ↦ L-i) and absorbing the (ε/2)‖∇U(x_0)‖ term into the i = L term (½·3^{-L} ≤ 3^{-L}): FAIR_IMPLICIT_STEP (S5 is true and follows directly from eqn:gradgeometric). Not an issue.
- TEX:1076-1085: `‖p0‖ ≤ ‖x0‖` needs ‖x0‖ ≥ 1 (with δ<1), which "sufficiently large" covers; the bound ≤ -‖x0‖² holds with slack (≤ -8‖x0‖²). FAIR_IMPLICIT_STEP. Not an issue.

## 6. External parameters / consumed clause: PASS

`L03_L02Consumed gU eps L := ∀ δ < 1, Paper.L02.Concl gU eps L δ` (L03Stmt:39-40). It is exactly the conclusion of the revised two-clause L02 statement: `Paper.L02.Concl` (L02Stmt:25-28) = stepwise bound (TEX:963) ∧ `3^L‖x0‖ ≤ ‖x_L‖` (TEX:965), and `Paper.L02.L02_main` (pv_work/L02.lean:150-152) concludes `∀ δ<1, Concl gU eps L δ` under `L02_L01Consumed`, `0 < eps`, `HypExplode gU` for arbitrary L. Not stronger than what L02 states; not goal-shaped (positions only; acceptance not mentioned). Provenance (p), location TEX:960-966 / `Paper.L02.L02_main`, applicability: (17) and ε>0 are hypotheses of L03_main; same ε, L, gU. Used at TEX:1023-1025, 1050, 1076, 1092 (both clauses used: stepwise in S4a, 3^L bound in S7/S10/S13). Declared only in L03Stmt, in `namespace Paper.L03`, named `<ID>_<PredID>Consumed`. No other external parameters (Prop. 4.2 derived from Defs in S1/S2, correctly not an input). `HypOscillations3` is a hypothesis definition of the source's (18), not an external parameter.

## 7. Doubts about the source: none

No suspected paper issue. Implicit steps above are FAIR_IMPLICIT_STEP. L=0 is excluded by context (TEX:908 T=Lε>0 with ε>0), so not a paper issue.

## TFA table

| id | premise | ruling | reason |
|---|---|---|---|
| TFA-1 | `hL : 1 ≤ L` | APPROVED | Derivable from context: TEX:908 "T = Lε ... T>0" with ε>0 (TEX:336) gives L ≥ 1; L is a number of leapfrog steps. L = 0 is degenerate (α ≡ 1, conclusion false) and not discussed. Not conclusion-shaped. |

## External parameters table

| name | kind | provenance | ruling |
|---|---|---|---|
| `L03_L02Consumed` | consumed clause | (p), L02 = lem:xlower TEX:960-966, `Paper.L02.L02_main` | APPROVED |

## Coordinator note (non-blocking)

`Paper.L03.HypOscillations3` and `Paper.C01.HypOscillations3` have identical text; at C01/T02 reconnection the two must be shown equal (they should be definitionally equal; a `vh` comparison or `Iff.rfl` will confirm). No change required for L03.

## Required changes

none

## Statement snapshot

Copies: pv_work/probes/gate/L03/gate_L03_stmtcopy.lean (probe exit=0, log pv_work/logs/gate_L03_stmtcopy_2.log), pv_work/probes/gate/L03/gate_L03_draftcopy.lean (probe exit=0, 16 sorry, log pv_work/logs/gate_L03_draftcopy_2.log).

L03Stmt copy:
```
TYPE HASHES (current file, 3 declarations)
Paper.L03.Concl|def|th=291002308|vh=4051237846|bi=ieeeee
Paper.L03.HypOscillations3|def|th=3371666640|vh=3973787725|bi=ie
Paper.L03.L03_L02Consumed|def|th=1855146743|vh=44850359|bi=ieee
```

L03Draft copy:
```
TYPE HASHES (current file, 16 declarations)
Paper.L03.L03_S10|thm|th=2663832734|vh=-|bi=ieeeeeeee
Paper.L03.L03_S11|thm|th=28058804|vh=-|bi=eeeeeeeeee
Paper.L03.L03_S12|thm|th=3424578911|vh=-|bi=ieeeeeee
Paper.L03.L03_S13|thm|th=3301787647|vh=-|bi=ieeeeeeee
Paper.L03.L03_S14|thm|th=2223645147|vh=-|bi=ieeeeeee
Paper.L03.L03_S1|thm|th=746365136|vh=-|bi=ieeeeee
Paper.L03.L03_S2|thm|th=3090615228|vh=-|bi=ieeeeee
Paper.L03.L03_S3|thm|th=3920446577|vh=-|bi=ieeeeeee
Paper.L03.L03_S4a|thm|th=1936849995|vh=-|bi=ieeeeeee
Paper.L03.L03_S4b|thm|th=1672008965|vh=-|bi=ieeeeeeeeee
Paper.L03.L03_S5|thm|th=3508153762|vh=-|bi=ieeeeeeee
Paper.L03.L03_S6|thm|th=3607101082|vh=-|bi=eee
Paper.L03.L03_S7|thm|th=2572651745|vh=-|bi=ieeeeeeee
Paper.L03.L03_S8|thm|th=1462414293|vh=-|bi=eeeeeee
Paper.L03.L03_S9|thm|th=2007435786|vh=-|bi=eeeeee
Paper.L03.L03_main|thm|th=101449377|vh=-|bi=ieeeeeeeeeeee
```

STATEMENT GATE: PASS
