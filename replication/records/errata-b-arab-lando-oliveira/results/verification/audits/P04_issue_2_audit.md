# P04 issue 2: counterexample review (pv-auditor)

- Role: pv-auditor (fresh subagent, claude-opus-5-5), counterexample-review mode. Date: Tue Oct 13 02:10:05 EDT 2026
- Reviewed: ruling `verification/audits/P04_issue_2.md`; Lean `pv_work/P04_Counterexample2.lean` (sha256 5b3ca85e…62b6f, matching the ruling); `pv_work/P04Stmt.lean` (sha256 84cc56ad…adb7, matching the ruling).
- Source read directly: source/SuperParetoPaper-v12.tex:100-119 (:111 conventions, :113 F, Fbar, Λ), :261-273, :279-338 (Pareto :279, Def 4.1 :284-287, Prop 4.3 :296-299, :301, Def 4.4 :304-307, Def 4.5 :308-311, Prop 4.6 :315-321, uses :323, :337).
- Auditor probe: `pv_work/probes/auditor/P04/auditor_P04_issue2_probe.lean` (log `pv_work/logs/auditor_P04_issue2_probe_2.log`, exit 0, 0 errors, 0 sorry; every walk gives AXIOMS [propext, Classical.choice, Quot.sound], sorryAx false).

## 1. Encoding fidelity (decisive item)

| Item | Source | Lean | Judgment |
|---|---|---|---|
| Clause 2 (parenthetical) | :317 "$F_X$ is DOR (or, equivalently, $X$ is super-Pareto) iff $\mathcal P\leqc F_X$" | `PrintedClause2 := ∀ μ prob., SuperPareto μ ↔ ConvexTransformLE paretoCdf (F μ)` | Faithful. The source quantifies over every random variable X; no premise is dropped, and the conclusion is not strengthened. |
| Clause 1 | same sentence, DOR side | `PrintedClause1 := ∀ μ prob., DOR μ ↔ ConvexTransformLE …` | Faithful under the gate-approved reading R1 of DOR (real-valued Λ, so F<1). |
| Def 4.1 | :286 h increasing, convex, **nonconstant**, Y =d h(Z), F_Z = 𝒫 | `SuperPareto`: h measurable, monotone and convex on [1,∞), nonconstant on [1,∞), μ = map h of Pareto | Restricting h to [1,∞) = supp Z is harmless. Auditor check: with the source-literal version (h : ℝ→ℝ monotone, convex on ℝ, nonconstant on ℝ; `SuperParetoR`), δ₀ is still not super-Pareto (`not_SPR_d0`; a monotone convex h that is constant on [1,∞) is constant on ℝ, `const_of_const_Ici`). The clause also fails with this definition (`not_PrintedClause2R`). Measurability is automatic for monotone h. |
| Def 4.5 + :111 inverse | $F_2^{-1}\circ F_1$ convex; $v^{-1}(u)=\sup\{x: v(x)\le u\}$ | `quantile G u = sSup {x | G x ≤ u}`; convexity on `suppIn F1` | At δ₀ the set is (−∞,0) for every u∈[0,1): it is nonempty and bounded, so the real `sSup` is the true supremum (0). No junk value enters. The transform is ≡ 0 on ℝ, so it is convex on every convex domain (`le_c_d0_any`). The domain choice E3 is therefore irrelevant. |
| Pareto | :279 𝒫(x)=1−1/x, x≥1 | `paretoCdf`; `paretoMeasure` density x⁻² on (1,∞) | Correct (it is the Pareto(1) law). |
| Gate fingerprints | n/a | th/vh of `ConvexTransformLE`, `SuperPareto` in the build log equal the gate-r2 snapshot (`P04_gate_r2.md`:98, :105) | Identical. |

Global versus constructed objects: 𝒫 is a fixed global cdf, F_X is built from the parameter X, and super-Pareto and DOR are properties of X. The counterexample instantiates only X.

## 2. The instance satisfies every printed hypothesis

- Prop 4.6 (:315-318) prints no hypothesis on X. δ₀ is a (nonnegative) random variable (`consumed_of_printed`).
- No definition or convention excludes δ₀. The only standing conventions are at :111 and :113, and neither assumes non-degeneracy. A case-insensitive search for "degenerate" in the source finds nothing. Where the paper needs non-degeneracy, it prints it (:263 "$\Prob(X_1=\cdots=X_n)<1$", :286 "nonconstant"). The paper also works with discrete laws (:103, :113), and Def 4.5 is stated for arbitrary cdfs.
- Strongest contrary reading (noted for the human): in Shaked–Shanthikumar the convex transform order is usually set up for continuous laws with interval support. If Def 4.5 tacitly inherited that restriction, δ₀ would be outside its scope. The paper's own Def 4.5 ("Given two cumulative distribution functions") does not state it, so under the printed definition the instance is admissible.

## 3. The counterexample is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh build P04_Counterexample2` (run by me) | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/P04_Counterexample2_2.log` |
| `#pv_walk_decl` on `not_PrintedClause2`, `not_PrintedClause1`, `consumed_of_printed`, `le_c_d0_any` | all four: [propext, Classical.choice, Quot.sound], sorryAx false |
| `#print axioms` on both main theorems | [propext, Classical.choice, Quot.sound] |
| Project constants reached | only P04Stmt **definitions** (F, quantile, paretoCdf, paretoMeasure, suppIn, ConvexTransformLE, SuperPareto, plus DOR, Lam, Fbar for clause 1), all gate-approved (r2). No earlier theorem is used, and P04_X01Tool is not reached. |
| Lemma content (read in full) | `F_d0`, `quantile_d0`, `transform_d0`, `supp_pareto`, `le_c_d0`, `pareto_Icc_pos`, `not_SP_d0`, `not_DOR_d0`: genuine proofs with no hypotheses. None assumes the conclusion. |

## 4. Readings R2 and R3 (unchecked in the ruling; checked here)

| Reading of "Λ_X concave" (:306) | δ₀ DOR? | Lean evidence (auditor probe) | Which clause fails |
|---|---|---|---|
| R1 real-valued, F<1 (encoding) | no | `not_DOR_d0` | clause 1 and clause 2 |
| R2 extended-valued, hypograph convex | no | `R2_hypograph_not_convex`: the hypograph (−∞,0)×(−∞,0] ∪ [0,∞)×ℝ is not convex (the midpoint of (−1,0) and (0,2) lies outside it) | clause 1 and clause 2 |
| R3 concave on {0<F<1} = ∅ | yes (vacuously) | `R3_d0`, `R3_parenthetical_fails` | the parenthetical (DOR ⟺ super-Pareto) and clause 2 |
| R4 (added by me) concave on the finite domain {F<1} = (−∞,0), where Λ ≡ 0 | yes | `R4_d0` | the parenthetical and clause 2 |

The R2 and R3 claims of the ruling are confirmed and now checked in Lean. Clause 2 (super-Pareto ⟺ 𝒫 ≤c F_X) involves neither DOR nor the domain choice, so it fails under every reading. Under every reading, at least one equivalence in the first sentence of :317 is false at δ₀.

## 5. Scope

- Refuted: the first sentence of :317. Clause 2 is refuted under every reading. Clause 1 is refuted under R1 and R2. Under R3 and R4, the parenthetical "equivalently" is refuted instead.
- Not refuted: the second sentence of :317 (increasing odds rate ⟺ F_X ≤c 𝒫; `P04_S3` holds without non-degeneracy). Prop 4.6 for every non-degenerate X is not refuted: clause 1 is `P04_S4` (unconditional), and clause 2 is `P04_main`, which is conditional on `P04_X01Tool` (`P04_final.md`: PASS, CONDITIONAL).
- Downstream: `prop:conv` has no `\ref` in the source. The informal uses at :323 (Fréchet H, which is non-degenerate; super-Pareto X, which is non-degenerate by :286) and :337 (super-Pareto X) never involve a degenerate law. The ruling's "none affected" holds.

## 6. Classification

- The counterexample satisfies every printed hypothesis. By the letter of VERDICTS §2.1, that also meets the evidence standard for `ERROR`.
- `PAPER_ASSUMPTION_GAP` (the hypothesis "X non-degenerate" is missing, and an example shows the statement is false without it) is an equally admissible description. It matches the precedent rulings L01_issue_1 and L02_issue_1 for the same pattern. I confirm it as the primary class, and agree with the ruling that ERROR is a legitimate alternative for the human to choose. Either way, the result is ISSUE (paper side).
- Not EXPOSITION_GAP: the conclusion is false on the uncovered case, not just unargued.
- Not DOMAIN_CLARIFICATION: no reading of the concavity or convexity domain rescues clause 2 (§4). The only rescue is a tacit continuity or non-degeneracy restriction on Def 4.5, which the paper does not print (§2).
- Not ENCODING_ERROR: the failure survives the source-literal h on ℝ (`not_PrintedClause2R`) and every domain choice (`le_c_d0_any`).
- Not PAPER_ARGUMENT_GAP: the proof's identity at :320 is valid wherever $\Fbar_X>0$ and X is non-degenerate. The failure is one of scope.

## 7. Suggested fix

"Let X be non-degenerate" before :317. I checked that it suffices. Clause 1 then holds unconditionally (`P04_S4` under `hnd : ∀ c, μ ≠ δ_c`). Clause 2 holds given Prop 4.3, which the paper quotes from superPareto2024 (`P04_main` under `P04_X01Tool`), so this part of the sufficiency check depends on that cited result. Clause 3 does not need the hypothesis. The fix is no stronger than needed: `hnd` exactly excludes Dirac laws.

## 8. Human check

Brief: confirm that the authors do not intend Def 4.5 to be restricted, in the Shaked–Shanthikumar manner, to continuous laws (this would make the issue DOMAIN_CLARIFICATION), and choose between PAPER_ASSUMPTION_GAP and ERROR.

COUNTEREXAMPLE VALID — δ₀ satisfies every printed hypothesis of Prop 4.6 and refutes "X super-Pareto iff 𝒫 ≤c F_X" (:317) under the source's own Def 4.1, Def 4.5 and :111 inverse, under every reading of the domain and of concavity; the Lean compiles cleanly with standard axioms only.
