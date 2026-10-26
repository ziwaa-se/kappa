# Statement gate: P01 (Proposition prop:concave, main.tex:55-63)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Mon Oct 12 22:08:04 EDT 2026
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` `0eefd13be5c59d4b9d3f69ac20cc6365944c3e8297efcf4dd3a6011366674343`
  - `pv_work/P01Draft.lean` `4728c6bd810e8e685468b10c76a07c66bd70c882528970a99053324bbd668c90`
  - imported: `pv_work/Defs.lean` (gated, `verification/audits/DEFS_gate.md`)
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_2.log` (3 sorries = S1, S2, S3, as expected for a draft).
- Gate probes (all under `pv_work/probes/gate/P01/`):
  - `gate_P01_mathlib.lean` -> exit=0, log `pv_work/logs/gate_P01_mathlib_2.log` (mathlib evidence for SqrtConcave, see item 6)
  - `gate_P01_stmtcopy.lean` -> exit=0, log `pv_work/logs/gate_P01_stmtcopy_1.log`
  - `gate_P01_draftcopy.lean` -> exit=0 (3 sorry warnings), log `pv_work/logs/gate_P01_draftcopy_1.log`
- Draft notes `pv_work/notes/P01_draft_notes.md` read as leads only.

## Source quotations

- main.tex:24 — "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
- main.tex:26-28 (def:vp) — "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; for $p \in I$ this is the variance of the proportion of successes in $n$ independent trials with success probability $p$."
- main.tex:55-58 (prop:concave) — "For all $p, q \in I$, $\sqrt{V_n\bigl(\tfrac{p+q}{2}\bigr)} \ge \frac12 \Bigl(\sqrt{V_n(p)} + \sqrt{V_n(q)}\Bigr)$."
- main.tex:60-63 (proof) — "It is well known that the function $p \mapsto \sqrt{p(1-p)}$ is concave on $I$. The claim is the inequality defining concavity at the midpoint of $p$ and $q$, divided by $\sqrt{n}$."
- Other uses of $I$: main.tex:48, 52 (lem:positive, whose proof "both $p$ and $1-p$ are positive" needs the open reading), 66.

## Item rulings

1. **Hypotheses. PASS.** Source hypotheses: $n \ge 1$ integer (main.tex:24) -> `n : ℕ`, `hn : 1 ≤ n`; $p, q \in I$ -> `p ∈ IClosed → q ∈ IClosed →` inside `P01Claim`. The only other premise is the external parameter `SqrtConcave` (item 6). No `variable`, structure or type class hides hypotheses; `Defs` contains only definitions. No conclusion-as-hypothesis form: `SqrtConcave` is concavity of the unscaled function on the whole interval, the fact the source itself invokes, not the midpoint inequality for $V_n$.
2. **Conclusion. PASS.** `(1/2)*(√(V n p) + √(V n q)) ≤ √(V n ((p+q)/2))` is main.tex:57 with sides flipped; `V` matches main.tex:27. Nothing weakened or missing.
3. **Quantifiers / constants. PASS.** `P01_main : SqrtConcave → ∀ n, 1 ≤ n → ∀ p q, P01Claim n p q`; no constants involved.
4. **Domains and details. PASS.**
   - Reading of $I$ (main.tex:24 ambiguous, DEFS gate item 4): `IClosed = Set.Icc 0 1`. For the **conclusion** this is the stronger reading (the open-interval claim follows by `IOpen ⊆ IClosed`). For the **parameter** it is also the stronger reading, but it is applied consistently: the source's "concave on $I$" (line 61) and "for all $p, q \in I$" (line 56) use the same $I$, and the Lean file uses `IClosed` in both places. Moreover the closed-interval `SqrtConcave` is a theorem of mathlib (probe, item 6), so the closed reading cannot manufacture a paper error or hide a false hypothesis. The closed reading is FAITHFUL.
   - Note for the coordinator: L02 uses `IOpen` while P01 uses `IClosed`; each choice is recorded in its own Stmt file, as DEFS_gate requires. P01 is insensitive to the choice (true under both).
   - `n = 0` trap: excluded by `hn`. `Real.sqrt` of negatives: on $[0,1]$, $p(1-p) \ge 0$, so no clipping is in play in the claim; in S2 clipping is harmless (both sides 0 when $x(1-x) < 0$).
   - No measure, a.e., ENNReal or finiteness issues.
5. **Step obligations. PASS.** All true as stated; checked individually:
   - S1 (main.tex:61-62, midpoint concavity): `SqrtConcave` with `a = b = 1/2` at `p, q ∈ [0,1]` gives exactly the stated inequality ($\frac12 p + \frac12 q = \frac{p+q}2$). True. Not stronger than the source's step.
   - S2 (main.tex:62, "divided by $\sqrt n$"): `√(x(1-x)/n) = √(x(1-x))/√n` for all real `x`, `n ≥ 1`. True for all real `x` (`Real.sqrt_div'`-type identity needs only `0 ≤ n`). Pure normalization, no smuggling.
   - S3 (main.tex:61-62): divide S1 by `√n > 0` and rewrite with S2 -> `P01Claim n p q`. True; uses S1, S2 only.
   - `P01_main` is assembled from S3 (already compiles without sorry beyond S3). Assembly yields the main theorem.
6. **External parameters. PASS for faithfulness; FAIL for the mathlib evidence (amendment required).**
   - `SqrtConcave := ConcaveOn ℝ IClosed (fun p => √(p*(1-p)))`: exactly main.tex:61 under the closed reading; not stronger than the source's use (the source uses concavity on $I$ at arbitrary $p,q\in I$; Lean uses it at the midpoint only); not goal-shaped (it is the paper's own invoked fact, not an estimate first appearing in this proof); declared only in `P01Stmt.lean`, in `namespace Paper.P01`; no name collision with `Defs`, `L01Stmt`, `L02Stmt` (grep of those files, no hit).
   - Provenance (ii) "asserted without proof" is correct for "It is well known" with no citation.
   - **Mathlib evidence: insufficient and wrong.** The notes (P01_draft_notes.md:29) state that no `#check` was done and that "composition with the concave quadratic does not give concavity directly". This is false. Gate `#check` evidence (log `pv_work/logs/gate_P01_mathlib_2.log`):
     - `ConcaveOn.comp : ConcaveOn 𝕜 (f '' s) g → ConcaveOn 𝕜 s f → MonotoneOn g (f '' s) → ConcaveOn 𝕜 s (g ∘ f)` (Mathlib/Analysis/Convex/Function.lean:141)
     - `Real.strictConcaveOn_sqrt : StrictConcaveOn ℝ (Set.Ici 0) fun x => √x` (Mathlib/Analysis/Convex/SpecificFunctions/Pow.lean:87)
     - `Real.sqrt_le_sqrt : x ≤ y → √x ≤ √y`
     - The gate proved `theorem gate_probe_sqrtConcave : SqrtConcave` in ~15 lines (concavity of `√` on `Ici 0`, monotonicity of `√`, `nlinarith` for concavity of `p(1-p)`): exit=0, `#pv_walk_decl`: `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`.
     - Hence `SqrtConcave` has a cheap mathlib derivation; it is not a (v)-type gap, and keeping it as a visible parameter would make P01 CONDITIONAL for no reason of substance.
7. **Doubts about the source. None for P01.** "Well known" without a proof or reference (main.tex:61) is a true standard fact with a short derivation: at most `FAIR_IMPLICIT_STEP`/`EDITORIAL`, not a paper issue. The "divided by $\sqrt n$" step is fair implicit. The open/closed ambiguity of $I$ (already flagged at DEFS_gate as preliminary `DOMAIN_CLARIFICATION`, relevant to L02) does not affect P01. No dispatch of pv-issue-checker needed for P01.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none proposed) | — | `1 ≤ n` is the printed convention main.tex:24; `IClosed` is a reading of the printed $I$, not an extra premise. |

## External parameters

| Name | Provenance | Ruling | Reason |
|---|---|---|---|
| `SqrtConcave` (`P01Stmt.lean:16-17`) | (ii), main.tex:61 | Approved as a faithful statement of the source's fact; **evidence entry rejected** | Statement faithful, not stronger, not goal-shaped, correctly placed. The "mathlib does not have it" evidence is wrong: the gate derived it from mathlib without sorry (above). |

## Required changes

1. **(Mandatory)** `pv_work/notes/P01_draft_notes.md:29` (and the `SqrtConcave` entry when it is registered in `verification/EXTERNAL_TOOLS.md` / `RESULTS.json`): replace the `mathlib_search` text with the gate's evidence: `ConcaveOn.comp` (Function.lean:141), `Real.strictConcaveOn_sqrt` (Pow.lean:87), `Real.sqrt_le_sqrt`; `SqrtConcave` is derivable from mathlib without sorry (probe `pv_work/probes/gate/P01/gate_P01_mathlib.lean`, log `pv_work/logs/gate_P01_mathlib_2.log`). Remove the claim that composition "does not give concavity directly".
2. **(Coordinator decision; gate recommends option A)**
   - **Option A (recommended):** discharge the parameter. In `pv_work/P01Draft.lean` add before S1 a step `theorem P01_S0 : SqrtConcave := by sorry` with docstring citing main.tex:61 ("well known"; supplied from mathlib `Real.strictConcaveOn_sqrt`), and delete the binder `(h : SqrtConcave)` from `P01_S1` (line 11), `P01_S3` (line 24) and `P01_main` (line 29), using `P01_S0` instead. `def SqrtConcave` may stay in `P01Stmt.lean` but must then be relabeled as the statement of S0, not as an external input, and not registered in `external_tools`.
   - **Option B:** keep `SqrtConcave` as a (ii) parameter unchanged, with change 1 applied, and state in EXTERNAL_TOOLS.md that it has a short mathlib derivation (human-check priority C).
   Under either option the r2 check covers only the changed lines; under option A the `th` hashes of `P01_S1`, `P01_S3`, `P01_main` will change by design.

## Statement snapshot

From `pv_work/logs/gate_P01_stmtcopy_1.log` (copy of `P01Stmt.lean` + `import PVTools` + `#pv_type_hashes_here`), verbatim:

```
TYPE HASHES (current file, 2 declarations)
Paper.P01.P01Claim|def|th=1771785297|vh=3019997781|bi=eee
Paper.P01.SqrtConcave|def|th=3944470172|vh=182622040|bi=
EXIT=0
```

From `pv_work/logs/gate_P01_draftcopy_1.log` (copy of `P01Draft.lean` + `import PVTools` + `#pv_type_hashes_here`), verbatim:

```
TYPE HASHES (current file, 4 declarations)
Paper.P01.P01_S1|thm|th=2929267155|vh=-|bi=eeeee
Paper.P01.P01_S2|thm|th=3541686319|vh=-|bi=eee
Paper.P01.P01_S3|thm|th=450999015|vh=-|bi=eeeee
Paper.P01.P01_main|thm|th=450999015|vh=-|bi=eeeee
EXIT=0
```

## Overall verdict

Statement, step obligations and the closed-interval reading are faithful to main.tex:55-63. The external parameter `SqrtConcave` is a faithful (ii) statement, but its "mathlib does not have it" evidence is wrong (the gate derived it from mathlib); the evidence must be corrected and the coordinator should decide whether to discharge it (recommended) or keep it.

STATEMENT GATE: PASS_WITH_AMENDMENTS
