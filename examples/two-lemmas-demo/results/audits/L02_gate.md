# L02 — independent statement gate

- **Reviewer:** `pv-gate` (independent of `pv-drafter`; no self-review)
- **Date:** Thu Oct  1 00:15:24 EDT 2026 (from `date`)
- **Result reviewed:** L02 = PDF Lemma 2, `\label{lem:xsquare}`
- **Mode:** first-round statement gate (round 1)

## 0. Files reviewed and hashes

`python3 scripts/pv_snapshot.py hash`:

```
229a46b673e9b99a22df7fc7ba82728cd0f9b696948ebfa78abb3fe369eb1324  pv_work/L02Stmt.lean
86c3f046e0e741b4b008d12944568daab13cc46073e516c62fbe0b4c155971fd  pv_work/L02Draft.lean
465009ad6504041896614c3efedb9cd77030aa5dea89b506ab080656f81c50a3  source/demo.tex
```

Read in full by the reviewer: `source/demo.tex` (whole file, 29 lines — statement, proof,
and all preceding conventions/definitions of the manuscript), `pv_work/L02Stmt.lean`,
`pv_work/L02Draft.lean`, `pv_work/notes/L02_draft_notes.md` (notes treated as leads only, not as
evidence; every ruling below rests on the `.tex` text and on my own probes).

Imports of the reviewed files: `L02Stmt.lean` imports only `Mathlib.Data.Real.Basic`;
`L02Draft.lean` imports `L02Stmt` and `Mathlib.Tactic.Linarith`. There are no shared `Defs*`
modules and no predecessor `Stmt` module in the import graph (consistent with `defs = NONE` and no
`depends_on` for L02), so there is nowhere for a hidden hypothesis to hide: `L02Stmt.lean` contains
no declaration at all (confirmed mechanically — see §8, "0 declarations").

## 1. Compilation log (run by me, not taken from the drafter)

```
$ scripts/pv_lean.sh packages
PACKAGES linked -> .../lean-env/.lake/packages; mathlib modules compiled: 2452 of 6305
linked: do NOT run 'lake build' (it would write into the other project)

$ scripts/pv_lean.sh check L02Draft
RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0 \
  log=pv_work/logs/L02Draft_2.log olean=none
```

**Real exit code: 0.** `errors=0`, `sorry_warnings=2` (the two step obligations `L02_S1`, `L02_S2`,
as expected for a draft), `nonstandard_axiom_lines=0`, no `.olean` produced (correct: a draft with
`sorry` must not produce one). Log: `pv_work/logs/L02Draft_2.log`. `lake build` was **not** run
(packages are `linked`).

## 2. Source quotations (authoritative text)

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

Relevant conventions/definitions: **none**. The manuscript (`source/demo.tex:1-29`) has no
definition section, no notation section, no standing convention on constants, and no standing
hypothesis or ambient assumption of any kind. Lines 1-11 are preamble/title; lines 12-18 are the
unrelated Lemma 1 (`a^2+b^2 \ge 2ab`) and its proof, which L02 does not use and which introduces
no convention restricting the variable `x`. So the quantifier "For every real number $x$"
(line 21) is unrestricted, over all of ℝ, with nothing elsewhere in the source narrowing it. This
matters: there is no earlier convention that could be fairly read as supplying a hidden
restriction such as `x ≥ 1` or "integer x".

## 3. Item 1 — Hypotheses: **PASS**

The source's only hypothesis is the typing/quantification "For every real number $x$"
(`demo.tex:21`). The Lean main theorem is

```lean
theorem L02 (x : ℝ) : x ^ 2 ≥ x
```

- Encoded: `(x : ℝ)` is exactly "for every real number `x`". Generalising the explicit binder gives
  `∀ x : ℝ, x ^ 2 ≥ x`, the printed universal claim.
- **Extra premises: none.** There is no side condition, no `0 < x`, no `x ≤ 0 ∨ 1 ≤ x`, no
  integrality assumption, no `Fact`/`Nontrivial`-style class argument. The binder annotation
  snapshot `bi=e` (all binders explicit) confirms there is no hidden instance-implicit argument.
- **Hidden hypotheses: none.** There is no `structure`, no `variable` command, and no `def` in
  either reviewed file (`L02Stmt.lean` declares nothing; verified mechanically by
  `#pv_type_hashes_here` reporting `0 declarations`, §8). `ℝ` is mathlib's `Real` with its standard
  instances, which carry no extra assumption. `Mathlib.Tactic.Linarith` is a tactic import only.
- The forbidden shape `(hB : B) : B` does not occur: the main theorem has no propositional
  hypothesis whatsoever, so it cannot assume its conclusion or an equivalent.

This is the important check for this item: the drafter did **not** manufacture a domain
restriction to make the printed claim true. Had `x ≤ 0 ∨ 1 ≤ x` been added, that would have been
an invented hypothesis rescuing the paper (POLICY §1) and an automatic FAIL. It was not added.

## 4. Item 2 — Conclusion: **PASS**

Printed conclusion: `$x^2 \ge x$`. Lean conclusion: `x ^ 2 ≥ x`.

- Not weakened: no `ε`, no "for almost every", no restriction of the inequality to a subrange, no
  replacement of `≥` by a weaker relation, no `≥ x - c` slack.
- Not strengthened: `≥` matches `\ge` (not `>`); the exponent is the literal `2`.
- `x ^ 2` with `x : ℝ` and the numeral `2 : ℕ` is `Monoid.npow`, i.e. `x * x` — the standard reading
  of `$x^2$` for a real base and integer exponent; I confirmed in my probe that
  `x ^ 2 - x = x * (x - 1)` is a `ring` identity in this encoding (probe item (f)), so the power is
  the intended one and not, e.g., `Real.rpow` with a different domain behaviour.
- No clause is missing: the statement is a single unstructured inequality, so no conclusion
  `structure` or conjunction is needed. The decision in `L02Stmt.lean` not to introduce a
  `structure` is correct and loses nothing.
- No ℝ≥0∞/ℝ truncation trap: everything is in ℝ throughout; no `ENNReal.ofReal`/`toReal` appears,
  and the subtraction `x - 1` is honest real subtraction (not truncated `ℕ`/`ℝ≥0∞` subtraction),
  which matters because truncated subtraction would have silently made S2 *true* and hidden the
  paper's error. I checked this: in `L02_S1`/`L02_S2` the ambient type is `ℝ`, so `x - 1` is
  negative for `x < 1`, as the source intends.

## 5. Item 3 — Quantifiers and dependence of constants: **PASS**

There are no constants in this result, hence no choice-order question and no global
constant convention to honour (the source states none anywhere, §2). The single quantifier
`∀ x : ℝ` is in the only possible position, outermost, matching `demo.tex:21`. The step
obligations use the same outermost `∀ x : ℝ` and so are applied at the same `x` as the goal — I
confirmed the assembly instantiates both at the *same* `x` (`L02_S1 x`, `L02_S2 x`), not at
different points, which would have been an unfaithful (and vacuous) assembly.

## 6. Item 4 — Domains and details: **PASS**

| Aspect | Source | Lean | Ruling |
|---|---|---|---|
| Domain of `x` | all real numbers, `demo.tex:21` | `(x : ℝ)` | faithful; unrestricted |
| Periodic vs non-periodic | n/a | n/a | n/a |
| `=` vs a.e. `=` | genuine pointwise identity `demo.tex:25` | `x ^ 2 - x = x * (x - 1)` pointwise | faithful |
| Existence vs construction | n/a (no existential) | n/a | n/a |
| Finiteness | n/a | n/a | n/a |
| Measurability / regularity | n/a | n/a | n/a |
| ℝ≥0∞ / ℝ truncation | pure ℝ | pure ℝ; no `ofReal`/`toReal`; honest `x - 1` | faithful, §4 |
| Inequality direction | `\ge` | `≥` | faithful |

## 7. Item 5 — Step obligations

### 7.1 Correspondence to the labelled source sentences

| Obligation | Lean statement | Source clause | Correspondence |
|---|---|---|---|
| `L02_S1` | `(x : ℝ) : x ^ 2 - x = x * (x - 1)` | `demo.tex:25`, "We have $x^2 - x = x(x-1)$." | exact transcription of the printed identity, same side order |
| `L02_S2` | `(x : ℝ) : 0 ≤ x * (x - 1)` | `demo.tex:25-26`, "The two factors $x$ and $x-1$ always have the same sign, so their product is nonnegative" | the operative asserted conclusion of the clause ("their product is nonnegative", for every real `x`, case-free as printed) |

Both labels are correct: S1 is the first clause, S2 the second. The source's sentence is case-free —
it contains no split into `x ≤ 0` / `0 ≤ x ≤ 1` / `x ≥ 1`, and no citation — so encoding S2 as a
flat universally quantified claim over all `x : ℝ` is the faithful reading, not a strengthening
introduced by the formalizer. I verified this by reading `demo.tex:24-27` directly: the word
"always" (line 25) is the source's own universal quantifier over the factors' sign, so the flat
form is in fact what the paper prints.

One encoding remark (not a defect): the clause contains a justification ("the two factors … have
the same sign") and the assertion it supports ("so their product is nonnegative"). `L02_S2`
encodes the assertion. That is the standard and correct choice — the assertion is what the rest of
the proof consumes — and it does not understate the paper's claim. I separately checked the
justification itself (probe item (e) below): at `x = 1/2` the factors are `1/2 > 0` and
`-1/2 < 0`, i.e. of *opposite* sign, so the printed justification is false at the same point. This
is a fact for `pv-issue-checker` to weigh when choosing between `ERROR` and `PAPER_ARGUMENT_GAP`;
it is not a reason to change the encoding.

### 7.2 Truth as stated — I checked each obligation myself

I did **not** take the drafter's arithmetic on trust. Probe
`pv_work/probes/gate/L02/gate_L02_counterexample.lean` (compiled by me:
`RESULT gate_L02_counterexample mode=probe exit=1 errors=2` on the first run, caused solely by
`ring` not being available under the probe's initial imports; after adding
`import Mathlib.Tactic.Ring`: `RESULT gate_L02_counterexample mode=probe exit=0 errors=0
sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_counterexample_2.log`). All
nine `example`s below are therefore machine-checked, with no `sorry` and no nonstandard axiom. The
probe is a scratch file under my own probe directory; it is imported by nothing and touches no
reviewed file.

| Probe item | Statement proved | Meaning |
|---|---|---|
| (a) | `¬ (0 ≤ (1/2 : ℝ) * ((1/2 : ℝ) - 1))` | the S2 product is strictly negative at `x = 1/2` |
| (b) | `¬ (∀ x : ℝ, 0 ≤ x * (x - 1))` | **`L02_S2` is false as stated** |
| (c) | `¬ ((1/2 : ℝ) ^ 2 ≥ (1/2 : ℝ))` | the printed inequality fails at `x = 1/2` |
| (d) | `¬ (∀ x : ℝ, x ^ 2 ≥ x)` | **the main theorem `L02` is false as stated** |
| (e) | `(0 : ℝ) < 1/2 ∧ ((1/2 : ℝ) - 1) < 0` | the two factors have opposite signs at `x = 1/2`, contradicting "always have the same sign" |
| (f) | `∀ x : ℝ, x ^ 2 - x = x * (x - 1)` (by `ring`) | **`L02_S1` is true** — the falsity is localized in S2, not in the algebra |
| (g) | `x ≤ 0 → x ^ 2 ≥ x` and `1 ≤ x → x ^ 2 ≥ x` | the printed claim does hold on `x ≤ 0` and on `x ≥ 1`; only `0 < x < 1` fails |

Arithmetic, checked by hand as well as by machine: at `x = 1/2`, `x^2 = 1/4` and `x = 1/2`, so
`x^2 - x = 1/4 - 1/2 = -1/4 < 0`; and `x(x-1) = (1/2)(-1/2) = -1/4 < 0`. Both the drafter's
counterexample and the sign analysis are **correct**.

**Explicit ruling on truth as stated:**
- `L02_S1` — **TRUE as stated** (pure ring identity).
- `L02_S2` — **FALSE as stated**, witness `x = 1/2`; machine-confirmed, probe item (b).
- `L02` (main theorem) — **FALSE as stated**, witness `x = 1/2`; machine-confirmed, probe item (d).

I record this in the strongest terms […]: here the falsity is not a near-miss or a
degenerate edge case but a failure on the whole open interval `(0,1)`.

**This does not make the statement unfaithful, and it is not a FAIL of the gate.** The gate's job
is faithfulness to the printed text, and the printed text is what has been encoded. A faithful
encoding of a false printed claim *must* be false. The correct disposition is exactly the one the
drafter chose: state it as printed, leave `sorry`, and route it to the suspected-issue process.

### 7.3 Does S2 smuggle in the conclusion? **PASS**

Via the (true) identity S1, `0 ≤ x * (x - 1)` is logically equivalent to `x ^ 2 ≥ x`, so S2 is
*as strong as* the goal. I considered whether this is a smuggling violation and conclude it is not:

- S2 is a **step obligation** (a `theorem` with `sorry`, which must itself be discharged), not a
  hypothesis of the main theorem and not a `def Tool : Prop` parameter. Nothing is granted for
  free; the `sorry` count of 2 shows both S1 and S2 remain open debts.
- Its strength is a property of the **source's own proof**, which really does reduce the lemma to
  this single assertion in one sentence. Encoding a one-step proof means the one step carries the
  whole weight. Weakening S2 to something strictly weaker than the printed sentence would have
  been the unfaithful move.
- The prohibition on goal-shaped statements bites on external parameters and on assumed
  hypotheses. `L02Stmt.lean` declares **no** external parameter, so nothing goal-shaped is being
  assumed. The drafter explicitly declined to turn the sign step into a `def … : Prop` external
  input; I independently agree this was required here: granting a false, goal-equivalent claim as
  a "silently used standard fact" would have dressed a substantive paper error up as a technical
  detail (POLICY §1) and would have produced a bogus CONDITIONAL verdict.

### 7.4 Do the obligations assemble to the main theorem? **PASS**

The main theorem's body is `have h1 := L02_S1 x; have h2 := L02_S2 x; linarith [h1, h2]`, which
compiles with no error and no `sorry` of its own (total `sorry_warnings=2`, accounted for entirely
by S1 and S2). So S1 ∧ S2 ⊢ L02 is machine-verified: the two obligations, assembled, do yield the
printed conclusion, and they are the *only* debts. There is no hidden third step and no appeal to
an unlisted fact. This also mirrors the source's own "and hence $x^2 \ge x$" (`demo.tex:26`), which
is pure logical glue.

## 8. Item 6 — External parameters: **PASS (vacuously)**

`L02Stmt.lean` declares **no** `def … : Prop`, no `structure`, no `Consumed` clause — the file's
body between `namespace Paper.L02` and `end Paper.L02` is empty. Confirmed mechanically, not by
eye: the snapshot of the statement copy reports `TYPE HASHES (current file, 0 declarations)`.
`L02Draft.lean` likewise declares no external parameter (its snapshot lists exactly the three
theorems `L02_S1`, `L02_S2`, `L02`, all `thm` with `vh=-`).

Consequences for every sub-check of item 6: there is nothing to be stronger than the source's use,
nothing goal-shaped, no provenance type (i)–(v)/(p) to classify, no `<ID>_<PredID>Consumed` to
name, no redeclared name from another `Stmt` file, and no "mathlib does not have X" claim to
substantiate. Everything that does exist is inside `namespace Paper.L02`, as required.

Note on the inventory's candidate external input: `verification/INVENTORY.md` flagged the
same-sign/nonnegative-product step as a possible external input of type (iii). The drafter instead
made it the step obligation `L02_S2`. **I independently endorse that decision** on fidelity
grounds: the step is the one substantive internal step of *this* proof, not a result cited from
outside or imported from elsewhere in the paper, so it belongs as an obligation to be discharged,
not as an assumption to be granted (see §7.3).

The import probing recorded in the draft notes (`import Mathlib` / `Mathlib.Tactic` not built in
the linked cache; `Mathlib.Data.Real.Basic` and `Mathlib.Tactic.Linarith` built) is a
formalization-side fact about which `.olean`s exist here, consistent with
`mathlib modules compiled: 2452 of 6305` from my own `packages` run. It is not a content claim
about mathlib, and no verdict rests on it. My own probe independently needed
`import Mathlib.Tactic.Ring` added, which compiled fine — further evidence that the relevant
modules are present and that no `TRANSLATION_BLOCKED` situation exists for L02.

## 9. Item 7 — Doubts about the source itself (preliminary only)

I give preliminary classifications only; the gate does **not** rule on whether the paper is wrong,
and I have not modified the statement to rescue the proof.

| # | Source location | Printed text | Preliminary class | Basis |
|---|---|---|---|---|
| 1 | `source/demo.tex:21-22` | "For every real number $x$ we have $x^2 \ge x$." | **`ERROR`** (the printed conclusion is false) | machine-checked `¬ (∀ x : ℝ, x ^ 2 ≥ x)`, witness `x = 1/2`, probe (c),(d) |
| 2 | `source/demo.tex:25-26` | "The two factors $x$ and $x-1$ always have the same sign, so their product is nonnegative" | **`ERROR`** primarily (a printed assertion that is false), with `PAPER_ARGUMENT_GAP` as the alternative reading if one treats the sentence purely as the justification of #1 | machine-checked `¬ (∀ x : ℝ, 0 ≤ x * (x - 1))` (probe (b)) and opposite signs at `x = 1/2` (probe (e)) |

Not `PAPER_ASSUMPTION_GAP`/`EXPOSITION_GAP` in my preliminary view, because the failure is not a
missing side condition in an otherwise sound argument nor an uncovered sub-case of a true claim:
the printed universal conclusion is itself false on the whole interval `(0,1)` (probe (g) shows
the claim survives only on `x ≤ 0` and `x ≥ 1`). An issue-checker may reasonably argue that the
author intended one of those ranges, which would make a missing hypothesis part of the story; that
determination is theirs, not mine.

Not a formalization-side class: there is no `ENCODING_ERROR` (the encoding is faithful, §3–§7) and
no `TRANSLATION_BLOCKED` (everything needed compiles, exit 0). The `sorry`s here are *not* a
compilation failure being mistaken for a paper error — `scripts/pv_lean.sh check L02Draft` exits 0;
the evidence for the suspected error is a positively proved negation, not a failure to prove.

**Recommendation to the coordinator: dispatch `pv-issue-checker` for L02.** The route for this
result is the suspected-issue process, **not** the ordinary prover: `L02_S2` and `L02` are false as
stated, so prover budget spent trying to discharge them would be wasted, and any "success" would
necessarily involve changing the statement — which is forbidden.

## 10. TFAs ruled on

| TFA | Status | Reason |
|---|---|---|
| — (none offered, none found) | n/a | The main theorem has no extra premise beyond "`x` is a real number", which is exactly the printed hypothesis. No TFA is needed, and none is present, so there is nothing to approve or reject. |

For the record, a premise such as `x ≤ 0 ∨ 1 ≤ x` would **not** have been approvable as a TFA: it
is not derivable from the context (the source's context places no restriction on `x`, §2) and it
excludes the interval `(0,1)`, which is not a degenerate case but precisely the range where the
paper's claim fails. Such a premise would have manufactured a true statement out of a false printed
one, and the correct verdict would have been FAIL. The drafter did not add it.

## 11. External parameters ruled on

| Name | Provenance | Status | Reason |
|---|---|---|---|
| — (none declared) | n/a | n/a | `L02Stmt.lean` declares 0 declarations (mechanically confirmed, §8); `L02Draft.lean` declares only the three theorems. Nothing to approve. |

Consequence for the eventual verdict: if L02 were to be proved, it would be a candidate for
UNCONDITIONAL (no external parameters). As matters stand it is headed for the issue process.

## 12. Required changes

**None.** The statement and the step obligations are faithful to `source/demo.tex:20-27` as
printed. No line needs changing. In particular, `L02Draft.lean:57`
(`theorem L02 (x : ℝ) : x ^ 2 ≥ x`) and `L02Draft.lean:49`
(`theorem L02_S2 (x : ℝ) : 0 ≤ x * (x - 1)`) must be left exactly as they are: amending either one
to make it true would be the forbidden repair of a source statement.

## 13. Statement snapshot

Produced on **copies** of the two reviewed files, written with Read/Write into
`pv_work/probes/gate/L02/` (no `cp`), each copy carrying an added `import PVTools` after the
existing imports and a final `#pv_type_hashes_here`; the draft copy keeps `import L02Stmt` and so
uses the `L02Stmt.olean` compiled by the drafter. Both copies are byte-identical to the reviewed
files apart from those two added lines, so these hashes correspond to the text I actually read.

Copy of `pv_work/L02Stmt.lean` → `pv_work/probes/gate/L02/gate_L02_stmtcopy.lean`:

```
RESULT gate_L02_stmtcopy mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_stmtcopy_1.log olean=none
```

`TYPE HASHES` output, verbatim from `pv_work/logs/gate_L02_stmtcopy_1.log`:

```
TYPE HASHES (current file, 0 declarations)
EXIT=0
```

Copy of `pv_work/L02Draft.lean` → `pv_work/probes/gate/L02/gate_L02_draftcopy.lean`:

```
RESULT gate_L02_draftcopy mode=probe exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_draftcopy_1.log olean=none
```

`TYPE HASHES` output, verbatim from `pv_work/logs/gate_L02_draftcopy_1.log`:

```
TYPE HASHES (current file, 3 declarations)
Paper.L02.L02_S1|thm|th=322974237|vh=-|bi=e
Paper.L02.L02_S2|thm|th=422374504|vh=-|bi=e
Paper.L02.L02|thm|th=1900454330|vh=-|bi=e
EXIT=0
```

Reading of the snapshot: three `thm` declarations, all with `vh=-` (no `def` content, hence no
external parameter or consumed clause whose body would need locking) and `bi=e` (all binders
explicit, hence no hidden instance/implicit hypothesis). The final audit must reproduce these three
lines exactly, by `#pv_type_hashes L02`, compared line by line — any change in `th` means the
statement changed, and that judgement is to be made from these hashes, not by eye.

## 14. Ruling summary

| Item | Subject | Ruling |
|---|---|---|
| 1 | Hypotheses (no extras, no hidden ones, no assumed conclusion) | **PASS** |
| 2 | Conclusion (not weakened, not strengthened, no missing clause) | **PASS** |
| 3 | Quantifiers and dependence of constants | **PASS** |
| 4 | Domains and details | **PASS** |
| 5 | Step obligations (labelling, truth-as-stated recorded, no smuggling, assembly) | **PASS** |
| 6 | External parameters | **PASS** (none declared) |
| 7 | Doubts about the source (preliminary classification given, issue-checker recommended) | **PASS** |

Answers to the three questions put to this gate:
(a) `theorem L02 (x : ℝ) : x ^ 2 ≥ x` **is** a faithful, unweakened, unstrengthened encoding of
printed Lemma 2, with **no invented restriction on `x`** — confirmed.
(b) S1 and S2 **do** faithfully match the two clauses of the one-sentence proof — confirmed.
(c) The suspected counterexample **is real**: I re-derived the arithmetic by hand and
machine-checked `¬ (∀ x : ℝ, 0 ≤ x * (x - 1))` and `¬ (∀ x : ℝ, x ^ 2 ≥ x)` myself at `x = 1/2`.

Because the statement is faithful, the gate passes it, so that L02 proceeds to the
**suspected-issue process** (`pv-issue-checker`) rather than to the ordinary prover. Passing this
gate certifies faithfulness of the statement only; it is emphatically **not** a claim that the
statement is true — on the contrary, §7.2 records that the main theorem and `L02_S2` are false as
stated.

STATEMENT GATE: PASS
