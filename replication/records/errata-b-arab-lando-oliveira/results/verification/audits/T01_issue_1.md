# T01 issue 1: F_{h(X)}(0)=0 is never established in Theorem 2.8 (thm:inclusion); the theorem as printed is false

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent
- Status: ruling complete. **Not confirmed** until the pv-auditor counterexample review passes.
- Date: Tue Oct 13 01:18:02 EDT 2026 (from `date`)
- Dispatched by the coordinator. Reported by pv-gate (`verification/audits/T01_gate.md` item 7, `T01_gate_r2.md` "Unchanged from round 1") and pv-prover (`pv_work/notes/T01_prover_notes.md`, obligation S2).

## 1. Source quotations (read directly from `source/SuperParetoPaper-v12.tex`)

- F:111: "a function $v$ defined in $[0,+\infty)$ is said to be star-shaped if $v(0)=0$ and $\frac{v(x)}x$ is increasing." ("increasing" means non-decreasing, same line.)
- F:122-124 (Def 2.2): "We say that a random variable $X$ such that $F_X(0)=0$ is \ITS\ ... if $F_{\frac1X}^-$ is subadditive."
- F:128-134 (Lemma 2.3): "A random variable $X$ is \ITS\ if and only if (eq:sub-1x) $F_X(\tfrac{x}{\theta})+F_X(\tfrac{x}{1-\theta})\leq F_X(x)+1$, for all $x\geq0$, $\theta\in(0,1)$." The missing qualifier in the "if" direction is the already-recorded issue L01_issue_1 (B01).
- F:169-172 (Theorem 2.8, thm:inclusion): "Let $X$ be \ITS\ and $h$ a continuous star-shaped function. Then $h(X)$ is \ITS."
- F:174-180 (proof): "as $h$ is continuous, $F_{h(X)}(x)=F_X(h^{-1}(x))$ ... using (eq:sub-1x) for the last inequality, thus, taking into account Lemma~\ref{lem:ITS-carac}, the proof is concluded." The proof never mentions $F_{h(X)}(0)$, and neither the theorem nor its proof puts any condition on $h$ beyond continuity and star-shapedness.
- F:286 (super-Pareto definition): "A random variable $Y$ is super-Pareto if $Y\stackrel{d}{=}h(Z)$, where $F_Z=\mathcal{P}$ and $h$ is an increasing, convex and nonconstant function."
- F:332-337 (Theorem 4.8, cor:inclusion = T03): "If $X$ is nonnegative super-Pareto then $X$ is \ITS." The proof writes $X\stackrel d=h(Y)$, $F_Y(x)=\frac{x}{x+1}$, with "$h$ increasing convex and $h(0)=0$, hence $h$ is star-shaped", and concludes "by applying Theorem~\ref{thm:inclusion}". A search of the source for "inclusion" finds that this is the only other use of thm:inclusion.

## 2. What is consumed

- **Step under ruling (S2, `pv_work/T01Draft.lean:24-25`, `T01_S2_Gap` in `pv_work/T01ModGaps.lean:110-112`):** $F_{h(X)}(0)=0$ for every ITS $X$ and every continuous star-shaped $h$. The source consumes it silently at F:180. Def 2.2 requires it as the first conjunct of "$h(X)$ is ITS". Whichever form of L01 is used (as printed, or corrected per B01), the last step needs it:
  - with L01 as printed, the "if" direction "delivers" ITS without it, but that direction is false (B01);
  - with L01 corrected per B01's suggested fix, the "if" direction has $F_{h(X)}(0)=0$ as a premise, and the source never supplies it.
- **Instance consumed:** arbitrary continuous star-shaped $h$, exactly as printed. The source does not specialise $h$ further. Its only downstream consumer, T03 (F:337), uses $h$ increasing convex with $h(0)=0$, and such an $h$ may vanish on an interval $[0,a]$ (see §5). So LESSONS 2 (a general form false while the instance used is true) gives no rescue, either at T01 or at its consumer.

## 3. Evidence (Lean)

File: `pv_work/T01_Counterexample1.lean`, namespace `Paper.T01.Issue1`, `import T01ModGaps`. The imported files are unchanged from the gate-reviewed versions: `T01Stmt.lean` 3859de1a…a441b and `L01Stmt.lean` 3e9b3f0c…d03ad57e, the same hashes as in `T01_gate_r2.md`.

- `PrintedThm28 : Prop := ∀ μ [IsProbabilityMeasure μ] (h : ℝ → ℝ), IsInvSub μ → Continuous h → StarShaped h → IsInvSub (μ.map h)`. This encodes Theorem 2.8 (F:171) word for word over the gate-approved `StarShaped` (F:111) and `IsInvSub` (Def 2.2, F:124), and has the same shape as the gated `T01_main` minus its two tool parameters. Requiring continuity on all of ℝ, instead of on $[0,\infty)$ only, is a stronger hypothesis, so this clause is **weaker** than the printed one, which is allowed. It drops no printed hypothesis and strengthens no conclusion.
- Instance. This is not the gate's Fréchet instance; it uses a law that is simpler to handle in Lean (the source's own $Y$ from F:337).
  - $X$ has cdf $g_0(x)=x^+/(1+x^+)$. In Lean, μ0 is `StieltjesFunction.measure` of $g_0$, and `F_μ0` proves `F μ0 = g0` through Mathlib's `cdf_measure_stieltjesFunction`.
    - `isInvSub_μ0` proves that $X$ is ITS: $F_X(0)=0$, and $1-F_X(1/x)=x/(1+x)$ is subadditive on $(0,\infty)$. This is a direct Lean proof that relies on no claim of the paper.
  - $h(x)=\max(x-1,0)$:
    - `h0_cont` proves continuity, and `h0_star` proves star-shapedness ($h(0)=0$, and $h(x)/x$ is non-decreasing on $(0,\infty)$).
    - Beyond the printed hypotheses, `h0_mono` and `h0_convex` show that $h$ is also increasing and convex. So the separate monotonicity issue S0 plays no role in this counterexample.
  - `F_map_zero` proves $F_{h(X)}(0)=P(X\le1)=1/2$, and `not_isInvSub_map` concludes that $h(X)$ is not ITS.
- Results:
  - `T01_counterexample : ¬ PrintedThm28`: Theorem 2.8 as printed is false.
  - `not_T01_S2_Gap : ¬ T01_S2_Gap`: S2 is false, refuted against the prover's own gap definition. The walk shows `T01_S2_Gap` vh=193369578, which equals the gate-snapshot th of `T01_S2`.
  - `S2_of_printed : PrintedThm28 → T01_S2_Gap` (consumed_of_printed): S2 is a direct consequence of the printed theorem.
  - Scope, `subadditive_map`: the subadditivity conjunct of Def 2.2 **does** hold for $h(X)$ here ($1-F_{h(X)}(1/x)=x/(1+2x)$). So the failure lies exactly in the $F_{h(X)}(0)=0$ conjunct, and in nothing else.
- Compilation:
  - `scripts/pv_lean.sh build T01_Counterexample1` printed `RESULT T01_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T01_Counterexample1_4.log olean=pv_work/T01_Counterexample1.olean`.
  - Earlier `check` runs `_1` and `_2` failed only on `field_simp`/`ring` tactic leftovers; run `_3` passed.
- Axiom check:
  - Probe `pv_work/probes/issue/T01/issue_T01_axioms.lean`, run with `scripts/pv_lean.sh probe …`, gave `exit=0` (log `pv_work/logs/issue_T01_axioms_1.log`).
  - `#pv_axioms T01_Counterexample1: ALL STANDARD (31 declarations checked)`.
  - `#pv_walk_decl` on both `T01_counterexample` and `not_T01_S2_Gap` reports "AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false". The only modules reached are L01Stmt, T01Stmt, (T01ModGaps for `T01_S2_Gap`) and the counterexample file itself.
  - `#print axioms` on the four main results gives [propext, Classical.choice, Quot.sound].
- Hashes (sha256): `T01_Counterexample1.lean` 1c16f7aedc7992451867b2bdaee18f19aaeeb03e70628716d3e3cb08f06408f4; `T01_Counterexample1.olean` cb3b572762859ac15e2ad3f095e9d47276a563b6ae024e19ba8c6131f44ffe01; probe 559f1c6ba48c1fadd78cc1382327a82559b0dc337caa5c040b0058df1e6b0bd8; `T01ModGaps.lean` e47f76e8540634f77f6797ee11df08297b775ef3332a2f531ad398545c439a52; source 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294.
- Gate's Fréchet instance (reasoning, not checked in Lean): with $X\sim$ Fréchet(1), which is ITS by Ex 2.4 (F:142-143), and the same $h$, $F_{h(X)}(0)=P(X\le1)=e^{-1}>0$. This agrees with the Lean instance.

## 4. Classification: ERROR (on Theorem 2.8 as printed)

- **Why ERROR.** VERDICTS §2.1: "The printed conclusion itself is false; there is a counterexample satisfying all printed hypotheses." The Lean counterexample meets this exactly: $X$ is ITS, $h$ is continuous and star-shaped (and even increasing and convex), and $h(X)$ is not ITS. This is not merely "the proof has a gap" (VERDICTS §3.2). The theorem itself fails.
- **Why not PAPER_ARGUMENT_GAP.** That class requires that "the conclusion itself may still be true", and here it is false.
- **Why not PAPER_ASSUMPTION_GAP (the nearest neighbour; stated openly).**
  - The defect could be repaired by adding a hypothesis on $h$ (§6), and the failure lies only in the $F(0)=0$ conjunct. That is the pattern under which B01 was ruled PAPER_ASSUMPTION_GAP.
  - B01 was borderline because the omitted qualifier is printed in the paper's own Def 2.2 (F:124), so the lemma is true under a "standing restriction" reading.
  - No such reading exists here. Nothing in the paper restricts $h$ beyond continuity and star-shapedness. The missing condition (e.g. $h>0$ on $(0,\infty)$) appears nowhere in the source. The paper's own consumer (T03, F:337) explicitly admits $h$ vanishing near 0 ("increasing convex and $h(0)=0$").
  - The printed conclusion is simply false on a natural class of instances. ERROR is therefore the accurate primary class.
  - If the auditor or a human prefers consistency with B01, PAPER_ASSUMPTION_GAP is the fallback. The evidence supports it equally, since its minimum evidence (missing hypothesis plus an example showing the step false without it) is also met.
- **Why not EXPOSITION_GAP.** The conclusion is false on the uncovered case, not merely unargued.
- **Why not DOMAIN_CLARIFICATION.**
  - $h$ is used only on $[0,\infty)$, because $F_X(0)=0$ makes $X>0$ a.s.
  - The ITS definition fixes $F_{h(X)}(0)=0$ unambiguously.
  - Reading the domain of $1-F(1/x)$ as $(0,\infty)$, $[0,\infty)$ or ℝ does not affect the $F(0)=0$ conjunct.
- **Why not ENCODING_ERROR.**
  - The failing conjunct is Def 2.2's literal presupposition (F:124).
  - Our `StarShaped` matches F:111, and the instance is star-shaped under any reading of "increasing" (it is even strictly increasing on $(1,\infty)$ and non-decreasing everywhere).
  - Continuity on ℝ is stronger than printed.
  - No representation choice manufactures the failure: $F_{h(X)}(0)=P(h(X)\le0)=P(X\le1)$ holds under any cdf convention.
- **Why not FAIR_IMPLICIT_STEP.** S2 is refuted in Lean, so it cannot be "filled in".

### Distinct from B01 (L01_issue_1)? Yes.

- B01 concerns **Lemma 2.3's statement**: its "if" direction omits "such that $F_X(0)=0$". Its fix (add the qualifier) makes L01 true.
- This issue concerns **Theorem 2.8's statement**. It survives B01's fix:
  - with corrected L01, the last step of T01 needs $F_{h(X)}(0)=0$ as a premise, and that premise is false for the instance above;
  - the Lean refutation `T01_counterexample` does not use L01 at all, only Def 2.2.
- The two are linked: B01 is why the printed proof of T01 *looks* complete (the false "if" direction hides the missing check). But T01's defect is a separate and stronger failure: a false theorem, not a false lemma used inside a proof.
- L01_issue_1 §5 already flagged this ("Adding the qualifier to L01 therefore does not by itself repair Thm 2.6") as a lead for T01. This ruling confirms that lead with Lean evidence.
- Separate from S0 as well. S0, "every function considered is increasing" (F:180), is a different suspected issue and is not ruled here. The counterexample uses an increasing $h$, so it is independent of S0.

## 5. Does it threaten the conclusion?

- **Theorem 2.8 (T01):** **yes**. The printed conclusion "$h(X)$ is ITS" is false (Lean: `T01_counterexample`). What survives, from the T01 prover's work plus `subadditive_map`, is only the subadditivity half: "$h(X)$ satisfies (eq:sub-1x)". That half is established in `T01ModGaps.lean` modulo S0 and the external tools only. Its status must be decided in T01's own pipeline, not here.
- **Downstream: affected.** T03 (Theorem 4.8, cor:inclusion, F:332-337) consumes Theorem 2.8 for $h$ increasing convex with $h(0)=0$. Lead for T03's pipeline (reasoning, not checked in Lean apart from the parts noted):
  - $X=\max(Z-2,0)$ with $F_Z=\mathcal P$ is $h(Z)$ for $h(z)=\max(z-2,0)$, which is increasing, convex and nonconstant. So $X$ is super-Pareto per F:286, and it is nonnegative.
  - Equivalently, $X=h_0(Y)$ with $Y=Z-1$ and $F_Y(x)=x/(x+1)$, which is exactly the instance `μ0.map h0` of §3.
  - Lean shows $F_X(0)=1/2$ for that law (`F_map_zero`), so $X$ is not ITS.
  - The identification of μ0 with the law of $Z-1$, and super-Pareto membership, are reasoning, not checked in Lean.
  - T03 as printed therefore appears false too, by the same mechanism. T03 needs its own ruling.
- **Unaffected** (none of these uses Theorem 2.8, based on a source search for "inclusion", which finds only F:170, F:333, F:337 and unrelated prose at F:70 and F:404):
  - Thm 3.1 (thm:main, F:186-201);
  - L01's "only if" direction;
  - Prop 2.5 (F:148-154);
  - Examples 2.4, 2.6, 2.7 (F:140-166);
  - Prop cor:fsub (F:442).
  Each of these still has to be checked against its own proof by its own pipeline.

## 6. Suggestion to the authors (minimal)

Add to Theorem 2.8 (F:171) the hypothesis "$h(x)>0$ for $x>0$". The alternative "$P(h(X)\le 0)=0$" is stated for the authors' choice and is equally minimal. T03 (F:337) would then need its own adjustment (e.g. $h$ strictly increasing). That adjustment is not drafted here.

*Constructed by the reviewer, not in the source, suggestion only, not used in any verification.* Sufficiency check (reasoning, not checked in Lean):
- (a) $F_{h(X)}(0)=P(X\le0)+P(X>0,\ h(X)\le0)=0+0$, so S2 holds.
- (b) Incidentally, $h>0$ on $(0,\infty)$ together with star-shapedness gives monotonicity: for $0<x<y$, $h(y)=y\cdot\frac{h(y)}{y}\ge y\cdot\frac{h(x)}{x}\ge h(x)$, because $h(x)>0$ and $y/x>1$. So the same hypothesis would also discharge S0.
- The rest of the source route is S1, S3-S6, the L01 "only if" direction for $X$, and the corrected L01 "if" direction for $h(X)$. The prover assembled exactly this in `T01_main_mod_gaps` (`pv_work/T01ModGaps.lean:192`), conditional on `T01_X02Tool` (Lemma 4.1 of ineq-order2024) and `T01_L01Consumed`. So with S0 and S2 discharged, the theorem would follow along the source's route, conditionally on those parameters.
- The fix is sufficient for T01. Note the LESSONS 3 check: a weaker-looking condition such as "$h$ non-degenerate", "$h$ nonconstant" or "$h$ increasing and convex" does **not** suffice, as the Lean instance (increasing, convex, nonconstant) shows.

## 7. Not checked

- Fréchet variant of the counterexample: reasoning, not checked in Lean (the Lean instance uses $F(x)=x/(1+x)$).
- Sufficiency of the suggested fix (§6): reasoning, not checked in Lean.
- T03 lead (§5): super-Pareto membership and the identification of μ0 with the law of $Z-1$ are reasoning only.
- S0 (monotonicity) is not ruled here.

## 8. Needs human check

Yes, briefly:
- (i) Choose between ERROR and PAPER_ASSUMPTION_GAP if the project wants B01-style consistency (§4 argues for ERROR).
- (ii) Confirm that the authors did not intend an unstated restriction such as $h>0$ on $(0,\infty)$ or $h$ strictly increasing. Nothing in F:111, F:171 or F:337 indicates one, and F:337 contradicts it.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes
