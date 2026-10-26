# P05 issue 1: Prop cor:invNWU (F:431) omits F_X(0)=0 in the direction "order ⇒ super-heavy-tailed"

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent
- Status: ruling complete; **not confirmed** until the pv-auditor counterexample review passes
- Date: Tue Oct 13 02:23:56 EDT 2026 (from `date`)
- Reported by pv-gate (`verification/audits/P05_gate.md`, item 7.1) and pv-prover (`pv_work/notes/P05_prover_notes.md`, "Stopped: P05_main"). Parallel rulings: `verification/audits/L02_issue_1.md`, `verification/audits/L01_issue_1.md` (same defect pattern).

## 1. Source quotations (read directly, `source/SuperParetoPaper-v12.tex`)

- F:344-349 (Def 4.9): "We say that a random variable $X$ such that $F_X(0)=0$ is (1) ... super-heavy-tailed if $-\Log F_X(\frac1x)$ is subadditive".
- F:354: "... together with being nonnegative. Note that the nonnegativity is not strictly necessary for the above definitions."
- F:111: generalised inverse $v^{-1}(u)=\sup\{x: v(x)\le u\}$; subadditive means $v(x+y)\le v(x)+v(y)$ for every $x,y$ in the domain of $v$. F:113: $F_X^-(x)=\Prob(X<x)$. F:142: $\mathcal H(x)=e^{-1/x}$, $x>0$.
- F:422-425 (Def 5.1): "$F_1\leq_{i-sb}F_2$, if $\frac{1}{F_2^{-1}(F_1^-(\frac1x))}$ is subadditive." No condition on $F_1(0)$.
- F:426: "... For the same reason, it is also clear that the inverted-subadditive order rules out distributions whose supports strictly include the origin."
- F:429-432 (Prop cor:invNWU): "A random variable $X$ is super-heavy-tailed if and only if $F_X\leq_{i-sb}\mathcal{H}$."
- F:433-436 (proof): "Note that $\mathcal{H}^{-1}(p)=-\frac1{\Log p}$, so $\frac{1}{\mathcal{H}^{-1}(F_X(\frac1x))}=-\Log(F_X(\frac1x))$."
- F:442 (Prop cor:fsub, the next, parallel result): "A random variable $X$ **such that $F_X(0)=0$** is \ITS\ if and only if $F_X\leq_{i-sb}\mathcal{P}$." The qualifier is printed there, not at F:431.
- F:448: "by transitivity ..., Propositions cor:invNWU and cor:fsub, together with $\mathcal H\le_{i-sb}\mathcal P$, provide an alternative proof of Theorem thm:inv-nwu-fsub."

## 2. What is consumed

- The printed proposition quantifies over every random variable $X$. Its "if" direction: $F_X\le_{i-sb}\mathcal H$ ⇒ $X$ super-heavy-tailed, i.e. (Def 4.9) **both** $F_X(0)=0$ **and** $-\Log F_X(1/x)$ subadditive.
- The proof (F:434) only identifies the two functions; it establishes (with the unprinted F/F^- bridge, prover's S3) the equivalence of the order with the **subadditivity conjunct**. Nothing in Def 5.1 or the proof yields $F_X(0)=0$: for $x>0$ the order function only sees $F_X^-$ on $(0,\infty)$, and $F_X^-(t)$ for $t>0$ includes the mass at 0.
- Gated instance: `P05_main` (pv_work/P05Draft.lean:36, gate th=2049719506), `∀ μ, P05Conclusion μ`, with `P05Conclusion μ := IsSuperHeavyTailed μ ↔ InvSubLE (F μ) Hcdf` (pv_work/P05Stmt.lean, sha256 b5c0badc…a72b, identical to the gate snapshot). The prover stopped at goal `F μ 0 = 0` from `InvSubLE (F μ) Hcdf`.
- Consumed instance for the counterexample: μ = `Measure.dirac 0` (X = 0 a.s.).

## 3. Evidence (Lean)

File `pv_work/P05_Counterexample1.lean` (namespace `Paper.P05`, `import P05Stmt`; only gate-approved definitions used, none redefined).

- `PrintedIfClause : Prop := ∀ μ [IsProbabilityMeasure μ], InvSubLE (F μ) Hcdf → IsSuperHeavyTailed μ` — the printed "if" direction word for word; an extra premise (probability measure) is added, none dropped, conclusion unchanged.
- Instance μ = `dirac 0`:
  - `leftVer_dirac0_pos`: $F^-(t)=P(X<t)=1$ for $t>0$; `genInv_H_one`: $\mathcal H^{-1}(1)=+\infty$; hence `invSubFn_dirac0_pos`: the order function is $1/(+\infty)=0$ on $(0,\infty)$.
  - `invSubLE_dirac0`: $F_X\le_{i-sb}\mathcal H$ holds (0 ≤ 0+0). Every printed hypothesis is satisfied.
  - `invSub_dirac0_punctured` (domain robustness): with `leftVer_dirac0_neg` ($F^-(t)=0$ for $t<0$), `genInv_H_zero`, `invSubFn_dirac0_neg` (value $+\infty$ on $(-\infty,0)$), the order function is also subadditive for all $x,y,x+y\neq0$. So the instance satisfies the order under **both** domain readings of F:111/F:424 ($(0,\infty)$ as gated, and $\mathbb R\setminus\{0\}$); the failure is not manufactured by our domain choice (gate item 4).
  - `subadditive_negLogInv_dirac0`: the subadditivity conjunct of Def 4.9(1) also holds; the failure is exactly the omitted conjunct, independent of the EReal conventions.
  - `not_superHeavy_dirac0`: $F_X(0)=1\neq0$.
- `P05_if_counterexample : ¬ PrintedIfClause`.
- Scope: `printedIf_of_printedIff` (printed biconditional ⇒ `PrintedIfClause`); `P05_as_printed_false : ¬ ∀ μ [IsProbabilityMeasure μ], P05Conclusion μ`; `P05_main_gap_false : ¬ ∀ μ, P05Conclusion μ` (the gated `P05_main` universally quantified, which is exactly the prover's `P05_main_Gap`; so `P05_main_mod_gaps` is vacuous, as the prover noted).
- Compilation: `scripts/pv_lean.sh check P05_Counterexample1` → exit=0 errors=0 sorry_warnings=0 (log pv_work/logs/P05_Counterexample1_2.log; first attempt _1 failed on a cast, fixed). `scripts/pv_lean.sh build P05_Counterexample1` → `RESULT ... mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/P05_Counterexample1_3.log olean=pv_work/P05_Counterexample1.olean`.
- Axiom check: probe `pv_work/probes/issue/P05/P05_issue1_axioms.lean`, `scripts/pv_lean.sh probe …` → exit=0; log `pv_work/logs/P05_issue1_axioms_1.log` line 20: "#pv_axioms P05_Counterexample1: ALL STANDARD (19 declarations checked)"; lines 21-24: `P05_if_counterexample`, `P05_as_printed_false`, `P05_main_gap_false`, `invSub_dirac0_punctured` depend on [propext, Classical.choice, Quot.sound] only.
- Hashes (sha256): `P05_Counterexample1.lean` 441c152a8dc40443a05e8c11a4d96f587f677f8928dd72b163beb226293b4135; `.olean` 77db7eed0f0d539bf060cc43c8879ee8ea42082bc96d05f0f43bbfee40b24be4; probe d7582c636a88eca7abd5209edc9fba2e539a7707d4be198926c85cbe913ab7b3; P05Stmt b5c0badc472d23cdb60f66e3845088f050a803a30c72cb65898db075da0ad72b (= gate).
- Non-degenerate instance (reasoning, not checked in Lean): $F = p\,\mathbf 1_{[0,\infty)} + q\,G$ with $p\in(0,1)$, $q=1-p$, $G(x)=e^{-1/x}$ (Fréchet). For $x>0$, $F^-(1/x)=p+q e^{-x}$; with $a=e^{-x}$, $b=e^{-y}$: $(p+qa)(p+qb)\le p+qab \iff pq(1-a)(1-b)\ge0$, true, so $-\Log F^-(1/x)$ is subadditive and the order holds, while $F(0)=p>0$. The failure is not confined to degenerate laws.

## 4. Classification

**PAPER_ASSUMPTION_GAP.** Missing hypothesis: "such that $F_X(0)=0$" in Prop cor:invNWU (F:431).

- Not FAIR_IMPLICIT_STEP / ENCODING_ERROR: $F_X(0)=0$ cannot be derived from the order (Lean counterexample satisfying the order under both domain readings, and the subadditivity conjunct too). Def 4.9 is encoded with its printed presupposition F:346 literally (accepted at the L02 gate and reused unchanged).
- Not DOMAIN_CLARIFICATION (closest neighbour, considered explicitly):
  - F:426 as a standing restriction does **not** rescue the statement: at most it says the order forces $P(X<0)=0$ (under the $\mathbb R\setminus\{0\}$ reading). X = 0 a.s. has support $\{0\}$, which does not "strictly include the origin", and it satisfies the order under that reading too (`invSub_dirac0_punctured`). Nonnegativity is weaker than $F_X(0)=0$.
  - F:346 as a standing restriction for Section 5 would make the proposition true, but (i) F:354 disclaims a nonnegativity convention, (ii) the immediately following parallel Prop cor:fsub (F:442) prints the qualifier explicitly, showing the authors print it when intended, (iii) F:431 opens with a fresh "A random variable $X$". Same reasoning as the confirmed-pattern L02 ruling. Flagged for human check (§8).
- Not ERROR (borderline, stated openly): the counterexample meets the ERROR standard for the clause as printed, but the defect is a single omitted qualifier that the paper's own definition states, and the substantive equivalence (order ⇔ subadditivity of $-\Log F_X(1/x)$) is correct (prover's S1-S3). Consistent with L01/L02 rulings.
- Not EXPOSITION_GAP: the conclusion is false on the uncovered case; no constant can absorb it.
- Not PAPER_ARGUMENT_GAP: the printed argument is fine for what it addresses; the defect is in the hypothesis set.

## 5. Does it threaten the conclusion?

- **P05 as printed: yes.** The "if" direction, hence the printed biconditional, is false (`P05_as_printed_false`). Unaffected: the "only if" direction (super-heavy-tailed ⇒ $F_X\le_{i-sb}\mathcal H$) and the equivalence for laws with $F_X(0)=0$ (prover reports S1-S3 proved and the forward direction assembled in `pv_work/P05.lean`; not re-audited by me).
- **Downstream: not affected.**
  - F:448 (alternative proof of Thm thm:inv-nwu-fsub): uses only SHT ⇒ $F_X\le_{i-sb}\mathcal H$ (the "only if" direction), then transitivity and the "if" direction of cor:fsub, whose hypothesis $F_X(0)=0$ is supplied by SHT itself. Unaffected.
  - Prop cor:fsub (P06, F:442): does not cite cor:invNWU. Unaffected.
  - No other reference to `cor:invNWU` in the source (grep of labels: only F:430, F:448).

## 6. Suggestion to the authors (minimal)

Replace "A random variable $X$ is super-heavy-tailed if and only if" at F:431 with "A random variable $X$ such that $F_X(0)=0$ is super-heavy-tailed if and only if", mirroring F:442. Sufficiency: with $F_X(0)=0$ added, IsSuperHeavyTailed reduces to its subadditivity conjunct, and the equivalence of that conjunct with the order is exactly the prover's S2+S3 assembly (`key` in `pv_work/P05.lean:314-326`), whose only remaining `sorry` is the `F μ 0 = 0` goal that the new hypothesis closes. (Assembly not re-audited by me.)

## 7. Not checked

- The corrected proposition is not compiled here (prover's job).
- The mixture instance in §3 is reasoning, not checked in Lean.
- The F vs F^- bridge (S3) is not re-audited here; the gate ruled it a FAIR_IMPLICIT_STEP candidate and the prover proved it.

## 8. Needs human check

Yes, briefly: whether the authors intended F:346's "such that $F_X(0)=0$" as a standing convention extending to Section 5 (which would make this DOMAIN_CLARIFICATION). Evidence against: F:354, F:442 printing the qualifier for the parallel result, the fresh quantifier at F:431. F:426 does not resolve it (§4).

ISSUE VERDICT: PAPER_ASSUMPTION_GAP
THREATENS CONCLUSION: yes
