# P03 suspected issue 1: the identity s²(x+y) = s²(x)+s²(y) (main.tex:86)

- Role: pv-issue-checker (fresh subagent, Opus)
- Reported by: pv-gate (`verification/audits/P03_gate.md`, item 5 and 7)
- Date: Mon Oct 12 22:20:22 EDT 2026 (from `date`)
- Status: ruling complete; NOT confirmed until reviewed by `pv-auditor` (counterexample-review mode)

## 1. Source quotations (read directly from `source/main.tex`)

- main.tex:31-34 (def:svar): "For $m \ge 2$ and $u \in \mathbb{R}^m$, let $\bar u = \frac1m \sum_{i=1}^m u_i$ and
  $s^2(u) = \frac{1}{m-1} \sum_{i=1}^m (u_i - \bar u)^2$."
- main.tex:81-83 (prop:sum): "For $m \ge 2$ and $x, y \in \mathbb{R}^m$, $s^2(x + y) \le 2 s^2(x) + 2 s^2(y)$."
- main.tex:85-88 (proof, complete): "We have $s^2(x + y) = s^2(x) + s^2(y)$, and $s^2(x) + s^2(y) \le 2 s^2(x) + 2 s^2(y)$
  because both terms are nonnegative."

The sentence at main.tex:86 asserts the identity with no justification and no extra hypothesis (no independence,
orthogonality, or zero-covariance condition appears anywhere in the source). The proof cites no result.

## 2. Consumed instance

The step is used at the full generality of the proposition: arbitrary $m \ge 2$ and arbitrary $x, y \in \mathbb{R}^m$
(the proof is a two-link chain `s²(x+y) = s²(x)+s²(y) ≤ 2s²(x)+2s²(y)`, with no case split). There is no narrower
instance on which the step could be true while the general form is false (LESSONS 2 does not apply here): the
consumed instance *is* the general clause.

Encoding check (not an `ENCODING_ERROR`): `Defs.lean` encodes `mean` and `s2` exactly as main.tex:32-33, with
`m - 1` as the real number `(m:ℝ) - 1` (positive for `m ≥ 2`, no ℕ truncation); `x + y` is pointwise addition in
`Fin m → ℝ` = vector addition in ℝ^m. The witness values below are checked by hand too:
`x = (0,1)`: mean ½, s² = (¼+¼)/1 = ½; `x + x = (0,2)`: mean 1, s² = (1+1)/1 = 2. So 2 ≠ ½ + ½ = 1 under the
source's own definitions; the failure is not produced by a representation choice.

## 3. Classification: PAPER_ARGUMENT_GAP

- **What fails.** The step at main.tex:86 asserts `s²(x+y) = s²(x)+s²(y)` for all `m ≥ 2`, `x, y`. This is false:
  it fails at `m = 2`, `x = y = (0,1)`, and in fact for every `m ≥ 2` (Lean `fails_every_m`). Even the weaker
  reading with `≤` fails at the same instance (2 > 1, Lean `counterexample_le`), so the chain at main.tex:86 cannot
  be rescued by reading `=` as `≤`. The step needs a vanishing cross term (zero sample covariance of `x` and `y`),
  which is neither assumed nor justified; no justification at all is given for the identity.
- **Why not `ERROR`.** `ERROR` requires the printed conclusion (main.tex:82) to be false. The counterexample
  refutes only the intermediate sentence; at the very same witness the printed conclusion holds (with equality,
  `2 ≤ 2·½ + 2·½`, Lean `concl_at_witness`). That the conclusion holds in general is my belief from a route the
  source does not contain (see §4); this is reasoning, not checked in Lean, and is not used in any verification.
- **Why not `PAPER_ASSUMPTION_GAP`.** Adding a hypothesis (e.g. zero sample covariance) would make the step true,
  but the proposition as printed is (by the reasoning in §4) true without it; the defect is the justification,
  not a missing hypothesis of the result.
- **Why not `EXPOSITION_GAP`.** It is not an uncovered range or case: the given justification is wrong on the
  whole range (every `m ≥ 2`).
- **Why not `FAIR_IMPLICIT_STEP`.** A competent reader cannot fill in the sentence, because the sentence is false;
  closing P03 requires a different argument, which is a repair, not a routine filling.
- **Why not `ENCODING_ERROR`.** See the encoding check in §2.
- **Second link** (main.tex:86-87, `s²(x)+s²(y) ≤ 2s²(x)+2s²(y)` "because both terms are nonnegative") is correct
  as printed; nonnegativity of `s²` for `m ≥ 2` is a FAIR_IMPLICIT_STEP from def:svar (Lean `s2_nonneg`,
  `step2_holds`, following the source's stated reason).

## 4. Does it threaten the conclusion?

- **Final conclusion of P03 (main.tex:82):** not threatened, in the sense that it is not refuted: it holds at the
  witness (Lean), and I believe it holds in general by a termwise inequality on centred coordinates
  (`(a+b)² ≤ 2a² + 2b²`, applied to `a = x_i - x̄`, `b = y_i - ȳ`, using `\overline{x+y} = x̄ + ȳ`).
  **That route is constructed by the reviewer, not in the source; reasoning, not checked in Lean; it is not
  supplied as a fix and not used in any verification.** The source proof of P03, however, does not go through:
  P03 cannot be verified along the source route (the prover must stop at S1).
- **Downstream results:** none. `verification/INVENTORY.md:19-21` lists P03 with no dependents (level 0, nothing
  at level 1 depends on it).
- **Unaffected:** L01, L02, L03, P01, P02 (they neither use P03 nor `s²`); within P03, the second link (S2) is
  unaffected and correct.

THREATENS CONCLUSION: answered "no" (the printed conclusion is not shown false; only the proof is broken).

## 5. Lean evidence

- File: `pv_work/P03_Counterexample1.lean`, sha256 `ab687a84825ea720afd19a2d1f29f05338eb3c1dd4f155391a708656d561ccef`.
- Compilation: `scripts/pv_lean.sh build P03_Counterexample1` ->
  `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/P03_Counterexample1_1.log`,
  olean `pv_work/P03_Counterexample1.olean`.
- Axiom check: probe `pv_work/probes/issue/P03/issue_P03_axioms.lean` (`#pv_axioms`, `#pv_walk`) ->
  `exit=0`, log `pv_work/logs/issue_P03_axioms_1.log`: "#pv_axioms P03_Counterexample1: ALL STANDARD
  (19 declarations checked)"; walk: "AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false".
- Declarations (namespace `Paper.P03.Issue1`):
  - `PrintedStepS1 : Prop := ∀ m : ℕ, 2 ≤ m → ∀ x y : Fin m → ℝ, s2 (x + y) = s2 x + s2 y` — main.tex:86 under
    the hypotheses of main.tex:82; no premise dropped, conclusion not strengthened.
  - `counterexample : ¬ PrintedStepS1` — instance `m = 2` (`le_rfl : 2 ≤ 2`), `x = y = w = ![0,1]`;
    `s2_w : s2 w = 1/2`, `s2_ww : s2 (w + w) = 2`.
  - `PrintedStepS1_le`, `eq_implies_le`, `counterexample_le` — the `≤` reading is also false.
  - `consumed_of_printed` — the printed clause gives exactly the draft obligation `P03_S1`
    (`pv_work/P03Draft.lean:11-12`) at every consumed instance: the refutation hits precisely the consumed step.
  - `fails_every_m : ∀ m ≥ 2, ∃ x y, s2 (x+y) ≠ s2 x + s2 y` (witness `x = y = e₀`, via `s2_add_self : s2 (x+x) = 4 s2 x`).
  - `concl_at_witness : P03Concl w w` — the printed conclusion holds at the witness (scope: the step, not the result, is refuted).
  - `s2_nonneg`, `step2_holds` — second link, along the source's stated reason.
- The draft `pv_work/P03Draft.lean` and `P03Stmt.lean` were not modified.

## 6. Suggestion to the authors (minimal)

Delete the false identity at main.tex:86 and give a correct justification of
`s²(x+y) ≤ 2s²(x) + 2s²(y)`; for example, the identity holds with the cross term,
`s²(x+y) = s²(x) + s²(y) + 2·c(x,y)` with `c` the sample covariance, after which the bound needs
`2c(x,y) ≤ s²(x)+s²(y)`. *Constructed by the reviewer, not in the source, suggestion only, not used in any
verification.* Checked by me only on paper (reasoning, not checked in Lean): `2c ≤ s²(x)+s²(y)` follows from
`2ab ≤ a²+b²` termwise on centred coordinates, so the suggestion suffices. The alternative of adding the
hypothesis "c(x,y) = 0" would also make the printed proof valid, but would needlessly weaken the proposition.

## 7. Not checked

- The general truth of the printed conclusion (main.tex:82) is not checked in Lean (by design: proving it would
  supply a non-source route). It is reasoning only.
- The suggested fix in §6 is reasoning, not checked in Lean.

## 8. Human check

Recommended (light): an author should confirm that the intended argument was the termwise/covariance bound and
replace the sentence at main.tex:86. Not needed to confirm the counterexample, which is Lean-checked (pending
independent `pv-auditor` counterexample review).

## BLOCKERS entry (proposed)

P03 issue 1 — PAPER_ARGUMENT_GAP — main.tex:86 "s²(x+y) = s²(x)+s²(y)" is false (m=2, x=y=(0,1): 2 ≠ 1; fails for
every m ≥ 2; ≤ reading also fails); printed conclusion main.tex:82 not refuted (holds at witness); no downstream
results; evidence `pv_work/P03_Counterexample1.lean` (exit 0, ALL STANDARD); pending pv-auditor review.

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no
