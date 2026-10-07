# L02 — issue 1: counterexample review by `pv-auditor`

- **Reviewer:** `pv-auditor`, counterexample-review mode (independent of `pv-drafter`, `pv-gate` and
  `pv-issue-checker`; their reports were read as leads only, and every load-bearing fact below was
  re-run by me)
- **Date:** Thu Oct  1 00:24:59 EDT 2026 (from `date`)
- **Object reviewed:** `pv_work/L02_Counterexample1.lean`, ruling `verification/audits/L02_issue_1.md`
  (`ISSUE VERDICT: ERROR`, `THREATENS CONCLUSION: yes`)
- **Source clause:** `source/demo.tex:20-27` (Lemma 2, `\label{lem:xsquare}`)
- **Files I wrote:** `pv_work/probes/auditor/L02/auditor_L02_draftcopy.lean`,
  `pv_work/probes/auditor/L02/auditor_L02_ce.lean` (plus the script-made
  `pv_work/probes/auditor/L02/rebuild/`). I modified no audited file, nothing in `source/`, and
  nothing outside my probe directory. `scripts/pv_lean.sh packages` → `PACKAGES linked …; mathlib
  modules compiled: 2452 of 6305`, so `lake build` was **not** run.

## 0. Hashes of what I read (my own run of `pv_snapshot.py hash`)

```
465009ad6504041896614c3efedb9cd77030aa5dea89b506ab080656f81c50a3  source/demo.tex
229a46b673e9b99a22df7fc7ba82728cd0f9b696948ebfa78abb3fe369eb1324  pv_work/L02Stmt.lean
86c3f046e0e741b4b008d12944568daab13cc46073e516c62fbe0b4c155971fd  pv_work/L02Draft.lean
abc92f9ee6e5d42224ab1a207d963b23e7db7bc19d64c2d313e966652e445eaa  pv_work/L02_Counterexample1.lean
445fe54fd278873b57a4b2e1af82a7e7d49447d8bb4fa5c13b23cbece65197ad  pv_work/PVTools.lean
```

`source/demo.tex`, `L02Stmt.lean` and `L02Draft.lean` are the same bytes the gate (§0) and the
issue-checker (§0) ruled on, and `L02_Counterexample1.lean` is the file whose hash the
issue-checker recorded. I read the whole 29-line manuscript myself (not a summary), the whole
counterexample file, `L02Stmt.lean`, `L02Draft.lean`, the gate report and the ruling.

Private rebuild of the delivered artefact (`scripts/pv_lean.sh rebuild L02_Counterexample1 L02`):

```
REBUILD L02_Counterexample1 exit=0
delivered=6956d67a831114ef82636132469d2b54f5cf400671d853dc45b8c13693e14303
rebuilt  =6956d67a831114ef82636132469d2b54f5cf400671d853dc45b8c13693e14303 IDENTICAL
```

So the delivered `.olean` really is the compilation of the text I read.

## 1. Encoding fidelity — the decisive item: **PASS**

### 1.1 Word-for-word correspondence

| Source, verbatim | Line | Lean encoding | Ruling |
|---|---|---|---|
| "For every real number $x$ we have $x^2 \ge x$." | `demo.tex:21` | `def PrintedLemma2 : Prop := ∀ x : ℝ, x ^ 2 ≥ x` | exact: `∀ x : ℝ` = "for every real number x"; `≥` = `\ge`; exponent literal `2` |
| "so their product is nonnegative" (of the factors `x`, `x-1`, "always") | `demo.tex:25-26` | `def PrintedProductStep : Prop := ∀ x : ℝ, 0 ≤ x * (x - 1)` | exact; "always" is the source's own universal quantifier |
| "The two factors $x$ and $x-1$ always have the same sign" | `demo.tex:25` | `def PrintedSameSign : Prop := ∀ x : ℝ, (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0)` | weakest reasonable reading of "same sign" (non-strict, `0` agrees with everything) — i.e. **weaker** than the printed claim, hence safe to refute |
| "We have $x^2 - x = x(x-1)$." | `demo.tex:25` | `def PrintedIdentity : Prop := ∀ x : ℝ, x ^ 2 - x = x * (x - 1)` | exact |

### 1.2 Pinned to the gated statement by hash, not by eye

I did **not** take the hashes from the ruling. I made my own copy of `pv_work/L02Draft.lean` into
`pv_work/probes/auditor/L02/auditor_L02_draftcopy.lean` (written with Write, not `cp`; the only
changes are an added `import PVTools` and a final `#pv_type_hashes_here`) and compiled it myself:

```
RESULT auditor_L02_draftcopy mode=probe exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0
TYPE HASHES (current file, 3 declarations)
Paper.L02.L02_S1|thm|th=322974237|vh=-|bi=e
Paper.L02.L02_S2|thm|th=422374504|vh=-|bi=e
Paper.L02.L02|thm|th=1900454330|vh=-|bi=e
```

These three lines reproduce the gate snapshot (`L02_gate.md` §13) exactly. My own
`#pv_type_hashes L02_Counterexample1` run gives:

```
Paper.L02.Counterexample1.PrintedIdentity|def|th=3944470172|vh=322974237|bi=
Paper.L02.Counterexample1.PrintedLemma2|def|th=3944470172|vh=1900454330|bi=
Paper.L02.Counterexample1.PrintedProductStep|def|th=3944470172|vh=422374504|bi=
```

| Gated declaration | gate/my `th` | counterexample `def` | my `vh` | match |
|---|---|---|---|---|
| `Paper.L02.L02` (`L02Draft.lean:57`) | 1900454330 | `PrintedLemma2` | 1900454330 | **yes** |
| `Paper.L02.L02_S2` (`L02Draft.lean:49`) | 422374504 | `PrintedProductStep` | 422374504 | **yes** |
| `Paper.L02.L02_S1` (`L02Draft.lean:32`) | 322974237 | `PrintedIdentity` | 322974237 | **yes** |

In `PVTools.lean` both numbers come from the same `Expr.hash` (`th = ci.type.hash`, `vh =
value.hash`), so this compares the `def` bodies with the gated theorem **types** under one hash
function. Because a hash equality is in principle not a proof, I closed the loop a second way in
my own probe (`auditor_L02_ce.lean`, all `rfl`, exit 0):

```lean
example : PrintedLemma2 = (∀ x : ℝ, x ^ 2 ≥ x) := rfl
example : PrintedProductStep = (∀ x : ℝ, 0 ≤ x * (x - 1)) := rfl
example : PrintedIdentity = (∀ x : ℝ, x ^ 2 - x = x * (x - 1)) := rfl
example : PrintedSameSign = (∀ x : ℝ, (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0)) := rfl
example : ¬ (∀ x : ℝ, x ^ 2 ≥ x) := not_printedLemma2
```

and I read `L02Draft.lean:57` directly: `theorem L02 (x : ℝ) : x ^ 2 ≥ x`, whose type with the
explicit binder generalised is literally `∀ x : ℝ, x ^ 2 ≥ x`. So the encoding is pinned to the
gated statement by hash, by `rfl`, and by direct reading of the text.

### 1.3 Not stronger than the source clause

- No premise was **dropped**: the printed clause has exactly one hypothesis, the typing/
  quantification "x is a real number" (`demo.tex:21`), and `PrintedLemma2` keeps precisely that.
- No conclusion was **strengthened**: `≥`, not `>`; `x ^ 2` is `Monoid.npow` (ordinary square — I
  confirmed `x ^ 2 - x = x * (x - 1)` is a `ring` identity in this encoding, which excludes an
  `rpow`-style reading); honest real subtraction `x - 1`, not truncated `ℕ`/`ℝ≥0∞` subtraction
  (which would have made the step vacuously true and hidden the error).
- No restriction was **invented** anywhere: neither the gated statement nor the counterexample's
  `def`s carry `0 < x`, `x ≤ 0 ∨ 1 ≤ x`, integrality, or an instance-implicit side condition
  (`bi=` / `bi=e` in both snapshots: no hidden implicit binder).
- `PrintedSameSign` is deliberately the weak (non-strict) reading, so refuting it refutes something
  weaker than the paper asserts — the correct direction.

### 1.4 Parameters vs global objects in the source statement

The printed statement of Lemma 2 contains **no** parameter, no constant and no object constructed
earlier in the paper: `x` is the universally quantified variable, and `ℝ`, `^`, `-`, `·`, `≥` are
global standard notions. There is therefore no "the author gets to choose the constant first"
structure that could make the quantifier order favour the paper: the refuter is free to choose `x`.
This is the decisive structural point, and it holds.

## 2. The witness satisfies every printed hypothesis: **PASS**

| Check | Finding |
|---|---|
| Sole printed hypothesis | "x is a real number" (`demo.tex:21`) — a typing condition, nothing propositional |
| Witness | `x = 1/2 : ℝ`, an honest real number (`example : ∃ x : ℝ, True := ⟨1/2, trivial⟩` in my probe) |
| Excluded by a definition? | No definition section exists in the manuscript |
| Excluded by a convention / standing hypothesis? | None exists: I read all 29 lines. 1-11 preamble/title; 12-18 Lemma 1 (`a^2+b^2 ≥ 2ab`, variables `a,b`, introduces no restriction on `x`); 19-27 Lemma 2 and proof; 28-29 end of document. No "throughout this paper", no notation section, no integrality convention |
| Excluded by a competing reading of `x^2`? | No: the source's own line 25 writes `x^2 - x = x(x-1)`, which fixes the ordinary square |
| Does the lemma cite anything that could narrow the domain? | No: the proof cites nothing; nothing in the file `\ref`s `lem:xsquare` |

**Falsification, re-derived by me by hand:** at `x = 1/2`, `x^2 = 1/4` and `x = 1/2`, so
`x^2 - x = 1/4 - 1/2 = -1/4 < 0`, i.e. `x^2 < x`; and `x(x-1) = (1/2)·(-1/2) = -1/4 < 0`, while the
two factors are `1/2 > 0` and `-1/2 < 0`, of **opposite** sign.

**Falsification, re-derived by me in Lean by a different route** than the issue-checker's `norm_num`
(my `auditor_L02_ce.lean`, exit 0, no `sorry`): compute the numerals with `ring` first, `rw` them
into the hypothesis, then close with `linarith` —

| My `example` | Content |
|---|---|
| `((1:ℝ)/2)^2 = 1/4` | by `ring` |
| `¬ (((1:ℝ)/2)^2 ≥ (1:ℝ)/2)` | via `ring` + `linarith` |
| `¬ (∀ x : ℝ, x ^ 2 ≥ x)` | **the printed conclusion is false**, my own proof |
| `((1:ℝ)/2) * ((1:ℝ)/2 - 1) = -(1/4)` | by `ring` |
| `¬ (∀ x : ℝ, 0 ≤ x * (x - 1))` | the printed step is false, my own proof |
| `(0:ℝ) < 1/2 ∧ ((1:ℝ)/2 - 1) < 0` | opposite signs: the printed justification is false |
| `(2:ℝ)^2 ≥ 2 ∧ (-1:ℝ)^2 ≥ -1` | non-vacuity: the inequality does hold somewhere, so the refutation is about the universal quantifier, not an empty domain |

So the refutation does not depend on the issue-checker's tactic calls.

## 3. The counterexample itself is proved: **PASS**

My own compile and probe (not the issue-checker's numbers):

| Check | My result |
|---|---|
| `scripts/pv_lean.sh rebuild L02_Counterexample1 L02` | `exit=0`, delivered vs rebuilt `.olean` **IDENTICAL** |
| `scripts/pv_lean.sh probe auditor_L02_ce.lean` | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` |
| `#pv_axioms L02_Counterexample1` | `ALL STANDARD (17 declarations checked)`; every line `OK|…|[propext, Classical.choice, Quot.sound]` |
| `#pv_walk L02_Counterexample1` | `17 roots, 5221 constants reached`; `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false` |
| Project modules reached by the walk | only `MODULE|L02_Counterexample1|17` — **no in-project dependency at all** (not even `L02Stmt` or `L01`), so there is no earlier theorem needing an individual audit record |
| Forbidden constructs | none: no `axiom`, `sorry`, `admit`, `unsafe`, `native_decide`, `implemented_by`, `@[extern]`, `skipKernelTC` in the file I read; mechanically, `sorryAx reached: false` and all axioms standard |
| Self-reference trap | the file assumes nothing: `not_printedLemma2` has no hypothesis, so the conclusion is not assumed |

## 4. Scope: what is and is not refuted

| Clause | Status |
|---|---|
| `demo.tex:21` "For every real number $x$ we have $x^2 \ge x$" | **REFUTED** (false; fails exactly on the open interval `(0,1)`, by `failure_region`, which I re-checked by applying it in my probe) |
| `demo.tex:25-26` "their product is nonnegative" | **REFUTED** for the printed universal reading |
| `demo.tex:25` "the two factors always have the same sign" | **REFUTED** even in its weakest (non-strict) reading |
| `demo.tex:25` "We have $x^2 - x = x(x-1)$" | **NOT refuted** — true (`ring`); the defect is localised in the sign claim, not in the algebra |
| The inequality restricted to `x ≤ 0`, or to `1 ≤ x` | **NOT refuted** — both hold (verified in my probe); but neither is what the paper prints |
| L01 (`demo.tex:12-18`, `a^2+b^2 ≥ 2ab`) | **NOT affected** — a separate result; its proof uses only `(a-b)^2 ≥ 0`, shares no step with L02, and does not cite it |
| Downstream uses of Lemma 2 | **none exist**: I searched the whole 29-line source myself; `lem:xsquare` occurs only in the `\label` on line 20, and there is no `\ref` to it anywhere. The manuscript has exactly two numbered results |

So the issue's scope is stated neither too broadly nor too narrowly in the ruling: it is one
printed universal statement that is false, with the failure region identified exactly, and no
downstream contamination.

## 5. Classification review

`ERROR` is correct: the **printed conclusion itself** is false, with a witness satisfying every
printed hypothesis (`VERDICTS.md` §2, row `ERROR`). I independently confirm the ruling's exclusions:
not `PAPER_ARGUMENT_GAP` (that class leaves the conclusion possibly true; here `¬(∀ x : ℝ, x^2 ≥ x)`
is proved); not `PAPER_ASSUMPTION_GAP` (the unprinted condition would delete an open interval on
which the printed claim is false — it changes the theorem rather than supplying a side condition);
not `EXPOSITION_GAP` (the uncovered range is where the claim is false, not merely unargued); not
`DOMAIN_CLARIFICATION` (one possible reading only, and the source's own line 25 fixes the square);
not `FAIR_IMPLICIT_STEP`; not `ENCODING_ERROR` (§1) and not `TRANSLATION_BLOCKED` (everything
compiles at exit 0 — the evidence is a positively proved negation, never a compile failure).
`THREATENS CONCLUSION: yes` is correct: the refuted clause *is* the lemma's conclusion.

## 6. The suggested fix

The ruling's suggestion (restrict to `x ≤ 0` or `x ≥ 1`, leave the proof sentence unchanged) is the
reviewer's own construction, a suggestion to the authors only, and no verdict rests on it. I still
checked it myself, since a proposed fix can be wrong:

| Check I ran | Result |
|---|---|
| `(x ≤ 0 ∨ 1 ≤ x) → x ^ 2 ≥ x` | holds (my own `nlinarith` proof) |
| `(x ≤ 0 ∨ 1 ≤ x) → (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0)` | holds, so the printed one-sentence justification becomes correct as written |
| Minimality | `failure_region : x^2 < x ↔ (0 < x ∧ x < 1)` (applied in my probe) shows the restriction is the complement of the exact failure set, hence weakest |

So the fix does remove the problem. The ruling's second variant (keep `∀ x` and weaken to
`x^2 ≥ x - 1/4`) is **not** Lean-checked by anyone, including me; it is correctly flagged there as
an unverified remark, and nothing depends on it.

## 7. Checks I could not complete / remarks

- A line-by-line `diff` of my `L02Draft` copy against the original could not be run (the Bash
  invocations needed for it were denied by the permission system). This does not weaken the
  conclusion: the copy's compiled fingerprints reproduce the gate snapshot exactly, and the
  statement text I compared was read by me from `pv_work/L02Draft.lean` itself; docstring text
  cannot affect a type hash.
- No human mathematical check is required: no cited literature, no external parameter — the whole
  ruling rests on arithmetic the Lean kernel checked, plus the reading of a 29-line source.
- Record consequence: L02 is an **ISSUE / `ERROR`**; the counterexample file may be cited as
  evidence. L01 is untouched.

## 8. Item summary

| Item | Subject | Ruling |
|---|---|---|
| 1 | Encoding fidelity; pinned to the gated statement by hash *and* `rfl`; not stronger | **PASS** |
| 2 | Witness satisfies every printed hypothesis; nothing in the source excludes it | **PASS** |
| 3 | Counterexample compiles (rebuild IDENTICAL), standard axioms only, no `sorryAx`, no unaudited in-project dependency | **PASS** |
| 4 | Scope correctly delimited (what is refuted, what is not) | **PASS** |
| 5 | Classification `ERROR`, `THREATENS CONCLUSION: yes` | **confirmed** |
| 6 | Suggested fix really removes the problem (and is minimal) | **PASS** (suggestion only) |

**Status for the authors.** Printed Lemma 2 (`demo.tex:21`, "for every real number $x$, $x^2 \ge x$")
is false: at $x=1/2$, $x^2=1/4<1/2$; it fails exactly on $0<x<1$, and the proof's claim that $x$ and
$x-1$ "always have the same sign" is false there too (the identity $x^2-x=x(x-1)$ is fine).
Restricting to $x\le 0$ or $x\ge 1$ makes both the statement and the printed one-sentence proof
correct as written; Lemma 1 is unaffected and nothing in the paper cites Lemma 2.

COUNTEREXAMPLE VALID — the encoding is pinned to the gated statement (`vh`/`th` match on all three
clauses, plus `rfl`), the witness `x = 1/2` satisfies the sole printed hypothesis (being a real
number) and falsifies the printed conclusion, and the Lean evidence rebuilds identically with
`propext, Classical.choice, Quot.sound` only and `sorryAx reached: false`.
