# P04 statement gate (Proposition 4.6, prop:conv)

- Reviewer: pv-gate (fresh subagent, claude-opus-5-5)
- Date: Tue Oct 13 01:41:19 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P04Stmt.lean` 3b78c2109b311d23d4231242a67503a2baf4e5b2796395ae9486d94a1fe43e3a
  - `pv_work/P04Draft.lean` bc9ab74befac673c3c12502255038ed506a393d0f80d4c0408f441ce58674a01
  - `pv_work/notes/P04_draft_notes.md` 5cbbfe25433f8f6006deec8b286705ab8faaec8d0173a8489d26f1a2f2d407bd (leads only)
- Compilation: `scripts/pv_lean.sh check P04Draft` -> `exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0`, log `pv_work/logs/P04Draft_2.log`.
- Snapshot probes: `pv_work/logs/gate_P04_stmtcopy_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_P04_draftcopy_1.log` (exit=0, 5 sorry).

## Source quotations (read directly)

- :111 "``increasing'' and ``decreasing'' are taken as ``non-decreasing'' and ``non-increasing'' ... the generalised inverse of an increasing function $v$ is denoted as $v^{-1}(u)=\sup\{x\in\mathbb{R}:\,v(x)\leq u\}$."
- :113 $F_X$, $\Fbar_X=1-F_X$, odds $\Lambda_X=F_X/\Fbar_X$.
- :279 $\mathcal{P}(x)=1-\frac1x$, $x\ge1$.
- :286 super-Pareto: $Y\stackrel{d}{=}h(Z)$, $F_Z=\mathcal{P}$, $h$ increasing, convex, nonconstant.
- :296-299 (Prop 1 of superPareto2024): $X$ super-Pareto iff $1/\Fbar_X$ concave.
- :301 $\Lambda_X=1/\Fbar_X-1$; concavity of $\Lambda_X$ iff decreasing odds rate (side derivatives).
- :306 DOR: $\Lambda_X$ concave. :310 $F_1\leqc F_2$ iff $F_2^{-1}\circ F_1$ convex.
- :317 "$F_X$ is DOR (or, equivalently, $X$ is super-Pareto) iff $\mathcal{P}\leqc F_X$. Analogously $F_X$ has increasing odds rate iff $F_X\leqc\mathcal{P}$."
- :320 proof: $\mathcal{P}^{-1}(u)=\frac1{1-u}$, $\mathcal{P}^{-1}\circ F_X=1/\Fbar_X=\Lambda_X+1$, "so the result follows immediately".

## Item 1. Hypotheses: FAIL

- `IsProbabilityMeasure μ` only; matches "random variable X" (law on ℝ). No hidden hypotheses in structures/classes/variables. No conclusion-as-hypothesis.
- But the main theorem carries `hX01 : P04_X01Tool`, and `P04_X01Tool` is **false as stated** (see item 6). A false hypothesis makes `P04_main` vacuously provable. FAIL.
- A non-degeneracy premise (μ not a Dirac mass) will be needed after amendment A2 (see TFA table); currently absent.

## Item 2. Conclusion: PASS (shape) / see items 4-5 for content

Three clauses (DOR <-> P <=c F; SuperPareto <-> P <=c F; IOR <-> F <=c P) match :317; none missing, the parenthetical "equivalently" encoded as its own iff. Fine in shape.

## Item 3. Quantifiers/constants: PASS

No constants; μ universally quantified per theorem. Fine.

## Item 4. Domains and details: FAIL

(a) **Generalised inverse contradicts the source's own definition.** `quantile G u := sInf {x | u ≤ G x}` (P04Stmt.lean:36), with docstring claiming "The source (:310) writes F_2^{-1} without saying which inverse". False: :111 fixes $v^{-1}(u)=\sup\{x: v(x)\le u\}$ (right-continuous version). The draft notes E2 repeat the wrong claim. The two versions differ at flat parts of $F_X$, i.e. exactly where S4 is delicate. ENCODING_ERROR; must be amended (A1).

(b) **Domain `suppIn = {0 < G < 1}` manufactures counterexamples.** The source leaves the domain of concavity of $\Lambda_X$ / $1/\Fbar_X$ implicit (DOMAIN_CLARIFICATION candidate). The drafter is right that the whole line is impossible (Pareto's $\Lambda=\max(0,x-1)$ is not concave). But `suppIn` silently drops the points where $\Fbar_X=0$, where the source's $\Lambda_X$, $1/\Fbar_X$ are $+\infty$; a real-valued concave function cannot accommodate that, so the source's notion implicitly requires $\Fbar_X>0$ on the support. With `suppIn`, every law whose support is bounded above with an atom at the top becomes "DOR". Counterexample (hand computation), μ = ½δ₀ + ½δ₁:
   - `F μ` = 0 on (-∞,0), ½ on [0,1), 1 on [1,∞); `suppIn (F μ)` = [0,1); `Lam μ` = 1 there, so `DOR μ` holds (constant is concave), and the RHS of `P04_X01Tool` holds (`1/Fbar` = 2).
   - `suppIn paretoCdf` = (1,∞); `x ↦ quantile (F μ) (paretoCdf x)` = 0 on (1,2], 1 on (2,∞) (same with the :111 sup-inverse). Not convex (points 1.5, 3, midpoint 2.25). So `ConvexTransformLE paretoCdf (F μ)` is false.
   - μ is not `SuperPareto`: h convex and monotone on [1,∞) is continuous on (1,∞), so h(Z) can have an atom only at its minimum (initial flat piece), never two atoms.
   Hence S4 and P04_X01Tool are false as stated; clause 1 of `P04_main` is false at this μ (the theorem is only "provable" because hX01 is false). This is our representation choice manufacturing a paper error (POLICY §1) — must be amended (A2).
   Also μ = δ₀: `suppIn` = ∅, so `DOR` and the X01 RHS hold vacuously, but δ₀ is not super-Pareto (h nonconstant) — a second counterexample to `P04_X01Tool`.

(c) Other details PASS: `F` = `ProbabilityTheory.cdf` (correct for probability measures); `Lam` uses real division but only on `suppIn` where `Fbar > 0` (no truncation trap there); no ENNReal/toReal traps except `paretoMeasure` density `ENNReal.ofReal (1/x^2)` on x>1 (nonnegative, fine); `SuperPareto`: "increasing" read non-strict matches :111; `Measurable h` and restriction to `Ici 1` are harmless (Z ∈ (1,∞) a.s.; h may be redefined off Ici 1); nonconstancy on `Ici 1` is equivalent to nonconstancy on (1,∞) given monotone+convex. `IOR` := Λ convex on `suppIn`: acceptable reading of "increasing odds rate" by analogy with :301 (bounded supports are natural for IOR, e.g. uniform; keep `suppIn` there).

## Item 5. Step obligations: FAIL

| Step | Source | True as stated? | Smuggling? | Ruling |
|---|---|---|---|---|
| S1 | :320 P^{-1}(u)=1/(1-u) | True for u∈(0,1) (with sInf; also with :111 sSup: {x | P x ≤ u} = (-∞,1/(1-u)]) | no | PASS (re-state after A1) |
| S2 | :320 P^{-1}∘F = 1/Fbar = Λ+1 | True on `suppIn` | no | PASS |
| S3 | :320 -> :317 clause 3 | True (both sides are convexity of the same function on the same set, by S2) | no | PASS |
| S4 | :320 "follows immediately", clause 1 | **FALSE as stated** (μ = ½δ₀+½δ₁, item 4b) | no; correctly kept as an unfilled gap obligation | FAIL — re-state after A1/A2/A3 |
| S5 | :317 parenthetical via X01 + :301 | True relative to X01 (Λ = 1/Fbar − 1 on `suppIn`) | no | PASS (re-state after A2) |
| assembly | | `P04_main` follows from S3,S4,S5 (term already compiles) | | PASS |

S4 being a gap obligation (the source never states that the inverse of a concave increasing function is convex, nor treats $F_X^{-1}\circ\mathcal{P}$ vs $\mathcal{P}^{-1}\circ F_X$) is correct and must stay an obligation, not be filled in. Sketch (not a proof, not a ruling): after A1–A3, S4 appears true — P <=c F with F^{-1}∘P convex, increasing, bounded would force a Dirac; otherwise F<1 everywhere, F^{-1}∘P is constant then convex strictly increasing, and its inverse 1/Fbar is concave.

## Item 6. External parameters: FAIL

`P04_X01Tool` (provenance (i), Prop 1 of superPareto2024, cited :296-299): provenance correct, declared only in `P04Stmt.lean`, in `namespace Paper.P04`, name not declared elsewhere (grep of pv_work: only P04 files), not goal-shaped (it is the cited characterisation, used only for the parenthetical). Not stronger than the source's use in form. **But false as stated** (μ = δ₀ and μ = ½δ₀+½δ₁, item 4b), because of the `suppIn` domain. Rejected in current form; acceptable after A2. "mathlib does not have it": paper-specific class, no evidence needed beyond that. Human check remains: domain/strictness conventions of the original Prop 1.

## Item 7. Doubts about the source (preliminary only; not ruled here)

- :320 / :317 clause 1 — proof computes only $\mathcal{P}^{-1}\circ F_X$ (the transform for $F_X\leqc\mathcal{P}$); clause 1 needs convexity of $F_X^{-1}\circ\mathcal{P}$, i.e. the unstated concave-increasing/convex-inverse duality with generalised inverses (atoms, flat parts). Preliminary: PAPER_ARGUMENT_GAP or FAIR_IMPLICIT_STEP. Dispatch pv-issue-checker.
- :317 clause 1 at degenerate X (Dirac): $\mathcal{P}\leqc\delta_c$ holds (constant transform), while δ_c is not super-Pareto and its Λ is not a real concave function. Preliminary: EXPOSITION_GAP (degenerate case not discussed). Dispatch pv-issue-checker (or treat via the TFA below).
- :306/:317/:298 domain of concavity of Λ, 1/Fbar unstated. Preliminary: DOMAIN_CLARIFICATION.

## TFA table

| TFA | Status | Reason |
|---|---|---|
| `IsProbabilityMeasure μ` | approved | "random variable" |
| (to be added, A3) `hnd : ∀ c : ℝ, μ ≠ Measure.dirac c` on S4, S5, P04_main | approved in advance as TFA | excludes only the degenerate case not discussed by the source (definition :286 requires h nonconstant); not the conclusion |

## External parameter table

| Name | Provenance | Status |
|---|---|---|
| `P04_X01Tool` | (i) Prop 1, superPareto2024 (:296-299) | **rejected as stated** (false); approve after A2 |

## Required changes (FAIL; redraft and resubmit for a full gate)

- **A1** `pv_work/P04Stmt.lean:34-36`: replace by the :111 inverse,
  `noncomputable def quantile (G : ℝ → ℝ) (u : ℝ) : ℝ := sSup {x | G x ≤ u}` and fix the docstring (cite :111, remove "source silent"); correct notes E2.
- **A2** Require $\Fbar_X>0$ everywhere wherever concavity of Λ or 1/Fbar is asserted (the source's Λ, 1/Fbar are real-valued concave on the support):
  - `P04Stmt.lean:44`: `def DOR (μ : Measure ℝ) : Prop := (∀ x, F μ x < 1) ∧ ConcaveOn ℝ (suppIn (F μ)) (Lam μ)`;
  - `P04Stmt.lean:61`: `(SuperPareto μ ↔ ((∀ x, F μ x < 1) ∧ ConcaveOn ℝ (suppIn (F μ)) (fun x => 1 / Fbar μ x)))`;
  - update docstrings (domain choice E3 with this rationale). Leave `IOR` and `ConvexTransformLE` domains unchanged.
  (An equivalent drafter-chosen encoding is acceptable if it excludes the bounded-support/top-atom counterexample; justify it in the notes.)
- **A3** `P04Draft.lean:30, 35, 39`: add TFA hypothesis `(hnd : ∀ c : ℝ, μ ≠ Measure.dirac c)` to S4, S5 (if needed) and `P04_main`; record it in the notes as a TFA.
- **A4** Keep S4 as an unfilled gap obligation (its docstring is correct); re-state S1/S2 docstrings for the sSup inverse. After the changes, the drafter should argue in the notes that S4 and X01 are no longer false at δ₀, ½δ₀+½δ₁.

## Statement snapshot (of the reviewed, un-amended text; superseded after redraft)

Stmt copy (`pv_work/logs/gate_P04_stmtcopy_1.log`):
```
TYPE HASHES (current file, 12 declarations)
Paper.P04.ConvexTransformLE|def|th=3790785477|vh=4142033147|bi=ee
Paper.P04.DOR|def|th=3905129696|vh=1538504169|bi=e
Paper.P04.Fbar|def|th=390107078|vh=3188116820|bi=ee
Paper.P04.F|def|th=390107078|vh=2204204658|bi=ee
Paper.P04.IOR|def|th=3905129696|vh=709822800|bi=e
Paper.P04.Lam|def|th=390107078|vh=1060973009|bi=ee
Paper.P04.P04_X01Tool|def|th=3944470172|vh=3630329123|bi=
Paper.P04.SuperPareto|def|th=3905129696|vh=2740489307|bi=e
Paper.P04.paretoCdf|def|th=3468892319|vh=1828619286|bi=e
Paper.P04.paretoMeasure|def|th=3087119417|vh=1064029993|bi=
Paper.P04.quantile|def|th=2287483187|vh=3546470970|bi=ee
Paper.P04.suppIn|def|th=3181325001|vh=2959148679|bi=e
```
Draft copy (`pv_work/logs/gate_P04_draftcopy_1.log`):
```
TYPE HASHES (current file, 6 declarations)
Paper.P04.P04_S1|thm|th=2222932460|vh=-|bi=eee
Paper.P04.P04_S2|thm|th=3130489372|vh=-|bi=ecee
Paper.P04.P04_S3|thm|th=644444803|vh=-|bi=ec
Paper.P04.P04_S4|thm|th=3042769146|vh=-|bi=ec
Paper.P04.P04_S5|thm|th=119823538|vh=-|bi=eec
Paper.P04.P04_main|thm|th=58348898|vh=-|bi=eec
```

## Overall verdict

FAIL: (1) `quantile` contradicts the source's generalised-inverse definition at :111; (2) external parameter `P04_X01Tool` is false as stated (δ₀; ½δ₀+½δ₁), making `P04_main` vacuous; (3) obligation S4 is false as stated (½δ₀+½δ₁) due to the `suppIn` domain choice — a formalization-side manufactured counterexample, not a paper error. Redraft per A1–A4 and resubmit for a full gate.

STATEMENT GATE: FAIL
