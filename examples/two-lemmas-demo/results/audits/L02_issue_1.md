# L02 — issue 1: ruling by `pv-issue-checker`

- **Role:** `pv-issue-checker` (independent of `pv-drafter` and `pv-gate`; I read their notes as
  leads only and re-derived and re-compiled every statement below myself)
- **Date:** Thu Oct  1 00:22:57 EDT 2026 (from `date`)
- **Result:** L02 = printed Lemma 2, label `lem:xsquare`
- **Suspected issue reported by:** `pv-drafter` (`pv_work/notes/L02_draft_notes.md`), independently
  by `pv-gate` (`verification/audits/L02_gate.md` §9, item #1)
- **Question put to me:** is the printed conclusion of Lemma 2 itself false (class `ERROR`), given
  that it is universally quantified over all real `x` with no stated restriction?

## 0. Files read, and hashes

Source read by me directly, in full (`source/demo.tex`, 29 lines — the whole manuscript, so I saw
every convention and definition that could bear on L02):

```
465009ad6504041896614c3efedb9cd77030aa5dea89b506ab080656f81c50a3  source/demo.tex
```

This is the same hash the gate recorded (`L02_gate.md` §0), so we ruled on the same text.

Also read: `pv_work/L02Stmt.lean`, `pv_work/L02Draft.lean`, `verification/audits/L02_gate.md`,
`pv_work/probes/gate/L02/gate_L02_counterexample.lean`, `verification/INVENTORY.md` (L02 rows).

Evidence files written by me:

```
abc92f9ee6e5d42224ab1a207d963b23e7db7bc19d64c2d313e966652e445eaa  pv_work/L02_Counterexample1.lean
6956d67a831114ef82636132469d2b54f5cf400671d853dc45b8c13693e14303  pv_work/L02_Counterexample1.olean
eef0467f83bfd39c1e51a20e79d9741c00c0428073dc97631efe13de67d74911  pv_work/probes/issue/L02/issue_L02_axioms.lean
```

I modified no draft, no proof file, no reviewed file, and nothing in `source/`.
`scripts/pv_lean.sh packages` printed `PACKAGES linked -> …; mathlib modules compiled: 2452 of
6305`, so **`lake build` was not run**.

## 1. What the source says (verbatim)

Statement, `source/demo.tex:20-22`:

```
20	\begin{lemma}\label{lem:xsquare}
21	For every real number $x$ we have $x^2 \ge x$.
22	\end{lemma}
```

Proof, `source/demo.tex:24-27`:

```
24	\begin{proof}
25	We have $x^2 - x = x(x-1)$. The two factors $x$ and $x-1$ always have the same
26	sign, so their product is nonnegative, and hence $x^2 \ge x$.
27	\end{proof}
```

**Cited results: none.** The proof cites nothing and refers to no earlier lemma; Lemma 1
(`source/demo.tex:12-18`, `$a^2+b^2 \ge 2ab$`) is not used and `INVENTORY.md:39` records
`depends_on = —` for L02.

**Conventions and definitions bearing on the quantifier: none.** I checked the whole file myself:
lines 1-11 are preamble/title, 12-18 are Lemma 1 and its proof, 19-27 are L02, 28-29 close the
document. There is no definition section, no notation section, no standing hypothesis, no ambient
"throughout this paper let …". So the quantifier on line 21 is unrestricted over `ℝ`, and there is
no convention elsewhere that a fair reader could use to narrow it (e.g. to integers, or to `x ≥ 1`).
This is the decisive point for the ruling: the hypothesis set of the printed clause is exactly
"`x` is a real number".

## 2. The consumed instance

The step actually needs, and the lemma actually asserts, the inequality at **every** real `x`; the
concrete instance that breaks it is

- **witness `x = 1/2`** (generally: every `x` with `0 < x < 1`).

At `x = 1/2`:

| Quantity | Value | Printed claim about it | Verdict |
|---|---|---|---|
| `x` | `1/2 > 0` | first factor | positive |
| `x - 1` | `-1/2 < 0` | second factor, "same sign" as `x` (line 25) | **negative — opposite sign** |
| `x(x-1)` | `-1/4` | "their product is nonnegative" (line 26) | **negative** |
| `x^2` vs `x` | `1/4` vs `1/2` | `x^2 \ge x` (line 21) | **`1/4 < 1/2`, fails** |

The witness satisfies the lemma's sole printed hypothesis (it is a real number) and is excluded by
no definition or convention of the source (§1). So this is a refutation of the printed clause, not
of some stronger statement of our own.

Scope, stated neither too broadly nor too narrowly: the printed inequality fails **exactly** on the
open interval `(0,1)` and holds on `x ≤ 0` and on `x ≥ 1`. This is machine-checked as
`failure_region : x ^ 2 < x ↔ (0 < x ∧ x < 1)`.

## 3. Classification: `ERROR`

The **printed conclusion itself** is false, with a counterexample satisfying all printed hypotheses
(`VERDICTS.md` §2.1, row `ERROR`). It is also true that the printed justification is false, but the
primary class is fixed by the strongest thing that fails, and here that is the conclusion.

Why not the neighbouring classes:

- **not `PAPER_ARGUMENT_GAP`.** That class is for "the justification given does not hold, the
  conclusion may still be true". Here the conclusion is *not* true: `¬ (∀ x : ℝ, x ^ 2 ≥ x)` is
  proved. A ruling of `PAPER_ARGUMENT_GAP` alone would understate the defect and would be exactly
  the confusion `VERDICTS.md` §3.2 forbids, in the opposite direction. (The failure of the
  "same sign" justification, `source/demo.tex:25-26`, is a genuine second defect; it is recorded
  here as part of the same `ERROR` because, as the source writes it, the step and the conclusion
  fail at the same witness and the step is logically equivalent to the conclusion — see the
  `printedProductStep_implies_printedLemma2` lemma, and `printedIdentity_true`, which localises the
  failure in the sign step rather than in the algebra. If the coordinator prefers a separate record,
  the sign sentence on its own is `ERROR` as well, since it is a printed assertion that is false.)
- **not `PAPER_ASSUMPTION_GAP`.** That class is for a step that cannot be derived because a needed
  hypothesis is unprinted, in an otherwise sound argument whose conclusion stands. One could argue
  the authors "meant" `x ≤ 0 ∨ 1 ≤ x`, but an unprinted hypothesis that excludes a whole open
  interval on which the printed statement is false is not a missing side condition: it changes the
  theorem. The printed universal statement is false as printed, so `ERROR` governs.
- **not `EXPOSITION_GAP`.** That class presupposes the conclusion is true and only some range or
  case lacks an argument. The uncovered range `(0,1)` is not merely unargued, it is where the claim
  is **false**; there are no constants here that could absorb anything.
- **not `DOMAIN_CLARIFICATION`.** There is only one possible reading of "for every real number `x`";
  I checked the entire manuscript for a competing reading (integers, a restricted range, a
  non-standard `x^2`) and found none. The exponent is the ordinary square: `x ^ 2 - x = x * (x - 1)`
  is a `ring` identity in the encoding (`printedIdentity_true`), which rules out a `Real.rpow`-style
  reading with different domain behaviour.
- **not `FAIR_IMPLICIT_STEP`.** Nothing here is a routine gap a reader fills in; a reader cannot
  fill in a false claim.
- **not `ENCODING_ERROR`** (our side). The encoding is pinned to the gated statement mechanically,
  not by eye: `PrintedLemma2` has `vh=1900454330`, which equals the `th=1900454330` of
  `Paper.L02.L02` in the gate snapshot (`L02_gate.md` §13); `PrintedProductStep` has
  `vh=422374504 = th` of `Paper.L02.L02_S2`; `PrintedIdentity` has `vh=322974237 = th` of
  `Paper.L02.L02_S1`. All three gated types are therefore reproduced bit-for-bit by my `def`s, with
  no added or dropped premise. Additionally `printedLemma2_eq_gated_statement` and
  `printedProductStep_eq_gated_S2` close the loop by `rfl`.
- **not `TRANSLATION_BLOCKED`.** Everything needed compiles at exit 0; the evidence is a positively
  proved negation, not a failure to compile.

## 4. Does it threaten the conclusion?

- **The final conclusion of L02 itself: yes, it fails.** The printed conclusion of Lemma 2 is the
  inequality itself, and it is false on `(0,1)`. L02 cannot be verified; it is an ISSUE with class
  `ERROR`. No part of the printed lemma survives unconditionally except the trivial algebraic
  identity of `demo.tex:25` (`printedIdentity_true`) and the restricted ranges `x ≤ 0`, `x ≥ 1`
  (which are **not** what the paper prints).
- **Downstream results: none are affected.** The manuscript has exactly two numbered results
  (`INVENTORY.md:38-39`). Nothing cites `lem:xsquare`: I checked the whole source text and
  `\ref{lem:xsquare}`/`\label{lem:xsquare}` occurs only at the lemma itself (line 20); L01's proof
  (`demo.tex:16-18`) uses only `(a-b)^2 \ge 0`. `INVENTORY.md` records `depends_on = —` for both
  results.
  - **Unaffected:** **L01** (Lemma 1, `$a^2+b^2 \ge 2ab$`, `demo.tex:12-18`) — it neither uses L02
    nor shares any step with it; its verdict is untouched by this issue. Nothing else exists in the
    paper to be affected.

## 5. Evidence (Lean)

- Counterexample module: `pv_work/L02_Counterexample1.lean`
  - compiled: `scripts/pv_lean.sh build L02_Counterexample1` →
    `RESULT L02_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0
    nonstandard_axiom_lines=0 log=pv_work/logs/L02_Counterexample1_1.log
    olean=pv_work/L02_Counterexample1.olean`
  - **real exit code: 0**, `errors=0`, `sorry_warnings=0`.
- Axiom / walk / hash probe: `pv_work/probes/issue/L02/issue_L02_axioms.lean`
  - `scripts/pv_lean.sh probe …` → `RESULT issue_L02_axioms mode=probe exit=0 errors=0
    sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/issue_L02_axioms_1.log`
  - `#pv_axioms L02_Counterexample1: ALL STANDARD (17 declarations checked)`
  - `WALK module L02_Counterexample1 stopping []: 17 roots, 5221 constants reached` /
    `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`
  - type hashes (verbatim, the three lines that matter):
    ```
    Paper.L02.Counterexample1.PrintedIdentity|def|th=3944470172|vh=322974237|bi=
    Paper.L02.Counterexample1.PrintedLemma2|def|th=3944470172|vh=1900454330|bi=
    Paper.L02.Counterexample1.PrintedProductStep|def|th=3944470172|vh=422374504|bi=
    ```
    matching the gate snapshot's `L02_S1 th=322974237`, `L02 th=1900454330`,
    `L02_S2 th=422374504`.

What is proved there (all machine-checked, no `sorry`, standard axioms only):

| Declaration | Statement | Role |
|---|---|---|
| `PrintedLemma2` | `∀ x : ℝ, x ^ 2 ≥ x` | printed clause, `demo.tex:21`, encoded verbatim |
| `PrintedProductStep` | `∀ x : ℝ, 0 ≤ x * (x - 1)` | printed step, `demo.tex:25-26` |
| `PrintedSameSign` | `∀ x : ℝ, (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0)` | printed justification, `demo.tex:25` ("same sign"), in its weakest reading |
| `PrintedIdentity` | `∀ x : ℝ, x ^ 2 - x = x * (x - 1)` | printed identity, `demo.tex:25` |
| `witness_in_range` | `(0 : ℝ) < 1/2 ∧ (1/2 : ℝ) < 1` | the witness is a real number in the failing range; no printed hypothesis excludes it |
| `printed_fails_at_half` | `¬ ((1/2 : ℝ) ^ 2 ≥ (1/2 : ℝ))` | failure at the witness |
| **`not_printedLemma2`** | `¬ PrintedLemma2` | **the printed conclusion of Lemma 2 is false** |
| `not_printedProductStep` | `¬ PrintedProductStep` | the printed step is false |
| `not_printedSameSign` | `¬ PrintedSameSign` | the printed justification is false |
| `printedIdentity_true` | `PrintedIdentity` | the algebra is fine; the failure is localised in the sign step |
| `printedSameSign_implies_printedProductStep` | `PrintedSameSign → PrintedProductStep` | the justification is what the step rests on |
| `printedProductStep_implies_printedLemma2` | `PrintedProductStep → PrintedLemma2` | the step is what the conclusion rests on (`demo.tex:26`, "and hence") — so the refutation hits the printed conclusion itself, not merely an auxiliary claim (`consumed_of_printed`-style scope lemma) |
| `printedLemma2_eq_gated_statement` | `PrintedLemma2 = (∀ x : ℝ, x ^ 2 ≥ x)` by `rfl` | encoding equals the gated main statement |
| `printedProductStep_eq_gated_S2` | `PrintedProductStep = (∀ x : ℝ, 0 ≤ x * (x - 1))` by `rfl` | encoding equals the gated obligation `L02_S2` |
| `failure_region` | `x ^ 2 < x ↔ (0 < x ∧ x < 1)` | exact scope of the failure |

Independence from the gate's probe: my file shares no code with
`pv_work/probes/gate/L02/gate_L02_counterexample.lean`, imports nothing from it, and adds the
scope lemmas, the hash pinning and the exact failure region, which the gate's probe does not have.
I also re-did the arithmetic by hand: `x = 1/2 ⇒ x^2 = 1/4`, `x^2 - x = -1/4`, `x(x-1) = (1/2)(-1/2)
= -1/4`.

## 6. Suggestion to the authors (minimal change)

**Constructed by the reviewer, not in the source, suggestion only, not used in any verification.**

Restrict the quantifier to the complement of `(0,1)`. Concretely, replace `source/demo.tex:21` by

> For every real number $x$ with $x \le 0$ or $x \ge 1$ we have $x^2 \ge x$.

and leave the proof sentence (`demo.tex:25-26`) unchanged.

I checked myself that this really suffices, and that it repairs the *justification* too, so that the
printed one-sentence proof becomes correct as written (this is the pitfall of a "fix" that does not
in fact rescue the result):

- `suggested_restriction_gives_conclusion : (x ≤ 0 ∨ 1 ≤ x) → x ^ 2 ≥ x` — the restricted
  conclusion holds;
- `suggested_restriction_gives_same_sign : (x ≤ 0 ∨ 1 ≤ x) → (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0)`
  — under the restriction the two factors really do have the same sign, which is the only thing the
  printed proof asserts, so no new argument is needed in the text.

Both are in `pv_work/L02_Counterexample1.lean` §6 and are included in the exit-0 compile and the
`ALL STANDARD` axiom check. By `failure_region` the restriction is also the *weakest* one that
works, so it is minimal. (An equally minimal alternative is to keep the universal quantifier and
weaken the conclusion to `x^2 \ge x - 1/4`; I did not check that variant in Lean, so I do not
recommend it on this evidence.)

## 7. Parts not checked

- I did not attempt to prove or disprove anything about L01; that is a separate result (and this
  issue does not touch it).
- I did not check the alternative suggested fix `x^2 \ge x - 1/4` in Lean (§6); it is mentioned
  only as a remark.
- I did not rule on whether the sign sentence (`demo.tex:25-26`) should additionally be recorded as
  its own separately numbered issue; §3 explains why it belongs to this `ERROR`, and the
  coordinator may split it if it prefers.
- No human mathematical check is needed for this ruling: there is no cited literature and no
  external input involved; the whole ruling rests on arithmetic that the Lean kernel checked.
  Independent review by `pv-auditor` in **counterexample-review** mode is still required before
  this is treated as confirmed.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes
