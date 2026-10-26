# P04 issue 2: Proposition 4.6 (prop:conv) at a degenerate (Dirac) X

- Role: pv-issue-checker (fresh subagent, claude-opus-5-5). Started: Tue Oct 13 02:04:29 EDT 2026
- Raised by: pv-gate (`verification/audits/P04_gate_r2.md` item 7, second bullet; TFA table row `hnd`), pv-auditor (`verification/audits/P04_final.md`:81, probe `pv_work/probes/auditor/P04/auditor_P04_nonvac.lean`:38-46).

## 1. What the source says (read directly)

- source/SuperParetoPaper-v12.tex:315-318 (Prop 4.6): "$F_X$ is \DOR\ (or, equivalently, $X$ is super-Pareto) if and only if $\mathcal{P}\leqc F_X$. Analogously $F_X$ has increasing odds rate if and only if $F_X\leqc\mathcal{P}$." No hypothesis on X is printed.
- :320 (proof): "$\mathcal{P}^{-1}\circ F_X=\frac1{\Fbar_X}=\Lambda_X+1$, so the result follows immediately."
- :284-287 (Def 4.1, super-Pareto): "$Y\stackrel{d}{=}h(Z)$, where $F_Z=\mathcal{P}$ and $h$ is an increasing, convex and **nonconstant** function."
- :296-299 (Prop 4.3, quoted from superPareto2024): super-Pareto iff $1/\Fbar_X$ concave.
- :301: $\Lambda_X=F_X/\Fbar_X=1/\Fbar_X-1$. :304-307 (Def 4.4): DOR iff $\Lambda_X$ concave.
- :308-311 (Def 4.5): "Given two cumulative distribution functions $F_1$ and $F_2$, ... $F_1\leqc F_2$, if $F_2^{-1}\circ F_1$ is convex."
- :111 (standing conventions): "increasing" means non-decreasing, and the generalised inverse is $v^{-1}(u)=\sup\{x: v(x)\le u\}$. The paper states **no** standing non-degeneracy convention: `grep -i degenerate|throughout|we assume` finds only :111. Where the paper wants non-degeneracy, it prints it: :263 (Prop 4.2, "$\Prob(X_1=\cdots=X_n)<1$") and :286 ("nonconstant" h). Def 4.5 is stated for arbitrary cdfs with the generalised inverse of :111, and the paper uses atomic/discrete laws elsewhere (:165).

## 2. Consumed instance

The Dirac law X = c (Lean: c = 0, a nonnegative random variable). Prop 4.6 has no printed premise other than "X is a random variable", so δ₀ satisfies every printed hypothesis.
- Def 4.5 transform for $F_1=\mathcal P$, $F_2=F_{\delta_0}$: for every $u\in[0,1)$, $\{x: F_{\delta_0}(x)\le u\}=(-\infty,0)$, so $F_{\delta_0}^{-1}(u)=0$. Since $0\le\mathcal P<1$ everywhere, $F_{\delta_0}^{-1}\circ\mathcal P\equiv 0$ on all of ℝ. It is constant, hence convex on **every** convex domain. So $\mathcal P\leqc\delta_0$ holds under any choice of the unstated domain.
- δ₀ is **not super-Pareto** by :286. If $h$ is increasing, convex and nonconstant on the support $[1,\infty)$ of Z, then h(Z) is not a.s. constant. (In Lean: if h(Z)=0 a.s., then by monotonicity h = 0 on (1,∞), and by monotonicity plus convexity h(1) = 0, so h is constant.) This uses only Def 4.1 and does not depend on any reading of "concave".
- δ₀ is **not DOR** under the gate-approved real-valued reading (gate r2 A2): $\Fbar_{\delta_0}(0)=0$, so $\Lambda$ takes the value $+\infty$.

## 3. Which clauses break, and under which readings

| Reading of "Λ_X concave" (:306) | δ₀ DOR? | Clause 1: DOR ⟺ 𝒫≤c F_X | Parenthetical: DOR ⟺ super-Pareto | Clause 2: super-Pareto ⟺ 𝒫≤c F_X |
|---|---|---|---|---|
| R1: real-valued, F<1 required (encoding, gate A2) | no | **fails** (Lean) | holds | **fails** (Lean) |
| R2: extended-valued, hypograph convex | no: hypograph (−∞,0)×(−∞,0] ∪ [0,∞)×ℝ is not convex | **fails** (reasoning, not checked in Lean) | holds | **fails** |
| R3: concavity only on {0<F<1} (= ∅ for δ₀), no F<1 | yes, vacuously | holds | **fails** | **fails** |

So under every reading, at least one equivalence in the first sentence of :317 is false at δ₀. Clause 2 ("X super-Pareto iff 𝒫 ≤c F_X") is false under every reading. Its two sides use only Def 4.1 and Def 4.5, and the latter is robust (`le_c_d0_any`).

Clause 3 ("increasing odds rate iff F_X ≤c 𝒫") is **not** broken. In the encoding, both sides are vacuous at δ₀ (suppIn F_{δ₀} = ∅), and `P04_S3` holds for every probability law without `hnd`.

## 4. Classification: PAPER_ASSUMPTION_GAP (missing hypothesis: X non-degenerate)

- The missing hypothesis is "X is non-degenerate (not a.s. constant)". It cannot be derived from anything printed: Prop 4.6 has no hypotheses, and the Lean counterexample satisfies all of them.
- Why not ERROR (borderline, stated openly): the counterexample satisfies every printed hypothesis, so it meets the ERROR evidence standard for the clause as printed. But the defect is a single omitted non-degeneracy qualifier. The paper's own Def 4.1 builds that qualifier into "super-Pareto" (:286), and the paper prints it elsewhere (:263). The argument at :320 (the identity plus the standard inverse duality, issue 1) is correct for every non-degenerate law: this is proved in Lean (`P04_S4` and `P04_main` under `hnd`). For consistency with the earlier rulings `L01_issue_1` and `L02_issue_1`, which handled the same pattern (one omitted qualifier, statement false only on the excluded laws), the primary class is PAPER_ASSUMPTION_GAP. A human may legitimately prefer ERROR (§8).
- Why not EXPOSITION_GAP: the conclusion is **false** on the uncovered case, not merely unargued.
- Why not DOMAIN_CLARIFICATION: no reading of the domain of concavity or convexity rescues the statement (§3 table: clause 2 fails under R1–R3, and 𝒫 ≤c δ₀ holds on every domain). The only reading that rescues it is a standing "random variables are non-degenerate" convention. The paper has no such convention (§1: :111 is the only standing-convention passage, and :263 and :286 print non-degeneracy explicitly when it is wanted).
- Why not PAPER_ARGUMENT_GAP: the proof's steps are valid for what they argue. At δ₀ the identity $\mathcal P^{-1}\circ F_X=1/\Fbar_X$ involves $1/0$, but that only reflects the statement's scope.
- Why not ENCODING_ERROR: clause 2 fails using only Def 4.1 ("nonconstant") and the fact that the Def 4.5 transform is constant. Neither depends on our representation choices (domain `suppIn`, the F<1 conjunct). The encoding of `SuperPareto` takes h on [1,∞) with h measurable; the argument applies verbatim to h on ℝ, and every increasing h is measurable. Our choices do not manufacture the failure.

## 5. Does it threaten the conclusion?

- **P04 as printed: yes.** The first sentence of :317 (clause 2 under every reading; clause 1 under R1 and R2) is false for degenerate X.
- **For non-degenerate X: no.** Clause 1 is `P04_S4` (proved under `hnd`). Clause 2 is `P04_S5`/`P04_main`, conditional on the external input X01. Clause 3 is `P04_S3`, which holds without `hnd`. All of these are in `pv_work/P04.lean`, final-audited in `P04_final.md`.
- **Downstream:** none affected. The only uses of prop:conv are at :323 (Fréchet H ≤c 𝒫 via clause 3, where H is non-degenerate, plus the transitivity H ≤c 𝒫 ≤c F_X for super-Pareto X, which is non-degenerate by :286) and the super-Pareto discussion around Thm 4.7 (:332-338, applied to super-Pareto X, which is non-degenerate). No result consumes Prop 4.6 at a degenerate law.
- **Unaffected:** P04 clause 3 (`P04_S3`), `P04_S1`, `P04_S2`, `P04_S4`/`P04_S5`/`P04_main` (all carry `hnd`), and all other results.

## 6. Evidence (Lean)

File: `pv_work/P04_Counterexample2.lean` (sha256 5b3ca85ebb1c270c9160f70cb1cd420368d503a18489456b3e98704a50962b6f). It imports `P04Stmt` (sha256 84cc56ad…adb7, the gate-r2 version) and `PVTools`.
- `PrintedClause2 : Prop := ∀ μ, IsProbabilityMeasure μ → (SuperPareto μ ↔ ConvexTransformLE paretoCdf (F μ))` (:317 parenthetical, word for word in the encoding). `theorem not_PrintedClause2 : ¬ PrintedClause2`.
- `PrintedClause1 : Prop := ∀ μ, IsProbabilityMeasure μ → (DOR μ ↔ ConvexTransformLE paretoCdf (F μ))`. `theorem not_PrintedClause1 : ¬ PrintedClause1` (reading R1).
- Ingredients:
  - `transform_d0`: F_{δ₀}⁻¹∘𝒫 ≡ 0 on ℝ;
  - `le_c_d0`: 𝒫 ≤c δ₀;
  - `le_c_d0_any`: convexity on every convex domain (robustness);
  - `not_SP_d0`: δ₀ not super-Pareto, using `pareto_Icc_pos`, i.e. the Pareto law charges every [a,b] ⊂ (1,∞);
  - `not_DOR_d0`.
- `consumed_of_printed`: δ₀ is a probability measure (the only printed premise), it is nonnegative (δ₀(−∞,0) = 0), and it is exactly what the TFA `hnd` excludes. The counterexample is no stronger than the printed clause: it uses a concrete instance of the printed universal and makes no extra assumption.
- Compile: `scripts/pv_lean.sh build P04_Counterexample2` → `RESULT P04_Counterexample2 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/P04_Counterexample2_1.log olean=pv_work/P04_Counterexample2.olean`.
- Axiom check: `#pv_walk_decl` on `not_PrintedClause2`, `not_PrintedClause1`, `consumed_of_printed` and `le_c_d0_any` gives "AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false" for all four. `#print axioms` on both main theorems gives [propext, Classical.choice, Quot.sound]. No external parameter (X01) is involved: the theorems have no hypotheses.
- Not checked in Lean: readings R2 and R3 of §3 (reasoning only).

## 7. Suggestion to the authors (minimal)

At :317, write "Let $X$ be a non-degenerate random variable. Then $F_X$ is \DOR\ ...", or equivalently exclude a.s. constant X. Sufficiency check (LESSONS 3): the Lean results `P04_S4`, `P04_S3` and `P04_main` (under X01) are proved with exactly the hypothesis `hnd : ∀ c, μ ≠ δ_c`, which is precisely "non-degenerate". So the fix suffices, and no weaker-looking condition is needed. Clause 3 does not need it, but adding it there is harmless.

## 8. Not checked / human check

- Readings R2 and R3 (§3) are reasoning only.
- The classification PAPER_ASSUMPTION_GAP versus ERROR is borderline (§4). A human should briefly confirm that the authors did not intend a tacit "non-degenerate" convention. The evidence against one is :111, :263, :286 and the general cdfs in Def 4.5 and :165. **Human check needed: yes (brief).**
- Independent review by pv-auditor (counterexample-review mode): pending. **Not confirmed until that review passes.**

ISSUE VERDICT: PAPER_ASSUMPTION_GAP
THREATENS CONCLUSION: yes
