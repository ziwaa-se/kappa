# P01 — independent statement gate (pre-proof)

- **Reviewer**: `pv-gate` (independent of the drafter; opus)
- **Date**: Wed Sep 30 20:03:34 EDT 2026 (`date`)
- **Result**: P01 = PDF 2.2, `\begin{proposition}\label{prop:nesbitt}`
- **Source read directly**: `source/main.tex` lines 10–11 (`\Rpos`), 26–33 (Notation, `S(x,y,z)`),
  37–43 (Lemma 2.1 `lem:amgm`, the predecessor L01), 52–57 (statement), 59–69 (proof),
  87–90 (bibliography). The drafter's notes were read only as leads; every ruling below rests on
  the `.tex` text and on my own compiles.

## Reviewed files and hashes

| file | sha256 (`python3 scripts/pv_snapshot.py hash`) |
|---|---|
| `pv_work/P01Stmt.lean` | `d39b457ab8bd9835b57fe81c46bdefd6c84f6c67ef5299c5586f1df83965c237` |
| `pv_work/P01Draft.lean` | `01326043d7f1d2c1e6c33c901768630ccd77017920ed29105e18aacbe74bb7cd` |

Supporting files read: `pv_work/L01Stmt.lean`, `pv_work/L01.lean` (predecessor, FINAL_PASSED,
UNCONDITIONAL; `Paper.L01.L01_main : L01Conclusion a b` with fields `ineq`, `equality_iff`),
`pv_work/notes/P01_draft_notes.md` (leads only), `verification/EXTERNAL_TOOLS.md` (EXT-1..EXT-3),
`verification/rules/VERDICTS.md` §4.

## Compilation (run by me)

| command | result | log |
|---|---|---|
| `scripts/pv_lean.sh check P01Draft` | `exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0`, **EXIT=0** | `pv_work/logs/P01Draft_2.log` |
| `scripts/pv_lean.sh probe pv_work/probes/gate/P01/gate_P01_stmtcopy.lean` | `exit=0 errors=0 sorry_warnings=0` | `pv_work/logs/gate_P01_stmtcopy_1.log` |
| `scripts/pv_lean.sh probe pv_work/probes/gate/P01/gate_P01_draftcopy.lean` | `exit=0 errors=0 sorry_warnings=6` | `pv_work/logs/gate_P01_draftcopy_1.log` |
| `scripts/pv_lean.sh probe pv_work/probes/gate/P01/gate_P01_sanity2.lean` | `exit=0 errors=0` (truncation / non-vacuity checks) | `pv_work/logs/gate_P01_sanity2_1.log` |
| `scripts/pv_lean.sh probe pv_work/probes/gate/P01/gate_P01_truth.lean` | `exit=0 errors=0` (**all six step obligations proved true as stated**) | `pv_work/logs/gate_P01_truth_1.log` |

(An earlier probe `gate_P01_sanity.lean` exited 1: *my own* trial counterexample
`¬ P01Conclusion (-1) 3 1` was wrong — the inequality does hold there (LHS 1/4, RHS −3/22).
Replaced by `gate_P01_sanity2.lean`, which uses the correct witness `x=1, y=1, z=−2`
(LHS −3, RHS −3/4). This was a probe error of mine, not a defect of the draft.)

## Source quotations

`source/main.tex:28-33` (Notation):
> Throughout, $\R$ denotes the real numbers and $\Rpos$ the positive real numbers. For real
> numbers $x,y,z$ we write
> \[ S(x,y,z) = \frac{x}{y+z} + \frac{y}{z+x} + \frac{z}{x+y} \]
> whenever the three denominators are nonzero.

`source/main.tex:52-57` (statement):
> \begin{proposition}\label{prop:nesbitt}
> For all $x,y,z \in \Rpos$ we have
> \[ S(x,y,z) \ge \frac{3\,(xy+yz+zx)}{2\,(x^2+y^2+z^2)}. \]
> \end{proposition}

`source/main.tex:59-69` (proof):
> By Nesbitt's inequality \cite[Theorem~1]{Nesbitt1903}, $S(x,y,z) \ge 3/2$ for all
> $x,y,z \in \Rpos$. Applying Lemma~\ref{lem:amgm} to the pairs $(x,y)$, $(y,z)$ and $(z,x)$
> and adding the three inequalities gives
> \[ xy + yz + zx \le x^2 + y^2 + z^2 . \]
> Since $x^2+y^2+z^2 > 0$, dividing by it yields $\frac{xy+yz+zx}{x^2+y^2+z^2} \le 1$, and hence
> $\frac{3\,(xy+yz+zx)}{2\,(x^2+y^2+z^2)} \le \frac{3}{2} \le S(x,y,z)$.

`source/main.tex:37-43` (L01, used at main.tex:61): $ab \le \frac{a^2+b^2}{2}$ for all real $a,b$,
with equality iff $a=b$. `pv_work/L01Stmt.lean:25-27` encodes exactly this as
`L01Conclusion.ineq : a * b ≤ (a ^ 2 + b ^ 2) / 2` and `.equality_iff`.

`source/main.tex:88-89` (bibliography): "A.~M. Nesbitt, Problem 15114, *Educational Times*
**55** (1903), 37."

---

## Item-by-item rulings

### 1. Hypotheses — PASS

- Printed domain `x,y,z \in \Rpos` (main.tex:53), with `\Rpos = \mathbb{R}_{>0}` (main.tex:11, 28),
  is encoded in `P01_main` as `(x y z : ℝ) (hx : 0 < x) (hy : 0 < y) (hz : 0 < z)`. Exact, neither
  weaker nor stronger; the standard `ℝ` + positivity encoding, consistent with the rest of the
  project (`NesbittInequality` uses the same shape).
- No hidden hypotheses: `P01Conclusion` is a plain `def … : Prop` over `ℝ`, no `structure` fields,
  no `variable`s, no type classes beyond `Mathlib.Data.Real.Basic`'s `ℝ`. `P01Stmt.lean` declares
  nothing else.
- **The only premise beyond the printed domain is `hN : NesbittInequality`**, the source's own
  citation (main.tex:60), handled as an external parameter in item 6 — not as a TFA.
- **No conclusion-as-hypothesis.** `hN` is `S(x,y,z) ≥ 3/2`, which is *not* `P01Conclusion` nor an
  equivalent of it (the two right-hand sides differ: `3(xy+yz+zx)/(2(x²+y²+z²)) ≤ 3/2` with
  equality only when `x=y=z`). See item 6 for the goal-shape ruling.
- The positivity hypotheses are not decorative: `gate_P01_sanity2.lean` proves
  `¬ P01Conclusion 1 1 (-2)`, so the encoded conclusion is not a tautology over all reals.

### 2. Conclusion — PASS (faithful transcription, S inlined exactly)

`pv_work/P01Stmt.lean:49-51`:
```
def P01Conclusion (x y z : ℝ) : Prop :=
  x / (y + z) + y / (z + x) + z / (x + y) ≥
    (3 * (x * y + y * z + z * x)) / (2 * (x ^ 2 + y ^ 2 + z ^ 2))
```
Term-by-term against main.tex:55 and main.tex:31:
`S(x,y,z)` ↦ `x/(y+z) + y/(z+x) + z/(x+y)` — the three fractions in the Notation section's order
and with its exact denominators (`y+z`, `z+x`, `x+y`, not e.g. `x+z`); `≥` ↦ `≥`; numerator
`3(xy+yz+zx)` ↦ `3 * (x*y + y*z + z*x)`; denominator `2(x²+y²+z²)` ↦ `2 * (x^2+y^2+z^2)`. The
parenthesisation keeps `3·(…)` over `2·(…)` as one quotient, as printed. Not weakened, not
strengthened; the proposition has a single printed clause and no "moreover", so a plain `Prop`
(not a `structure`) is right — nothing is missing.

Inlining `S` instead of a shared `def S` is a pure notation choice, allowed by POLICY §1
(conversions of notation/form); it cannot manufacture a paper error because the inlined text is
character-for-character the Notation definition.

### 3. Quantifiers and dependence of constants — PASS

No constants occur in P01 (no `C`, no ε). The universal quantifier over `x,y,z` is realised by
`P01_main`'s binders; `NesbittInequality` quantifies `∀ x y z : ℝ` *inside* the parameter, so the
cited result is available at every positive triple, exactly as main.tex:60 states it ("for all
$x,y,z \in \Rpos$") — the parameter does not depend on the particular `x,y,z` of the theorem, which
is the correct order.

### 4. Domains and details — PASS

- **No ℕ-division / truncation trap.** Every quotient and `3 / 2` elaborates in `ℝ`; checked by
  probe (`(3:ℝ)/2 = 1.5`, and `P01Conclusion 1 1 1` holds with both sides `3/2`). No `ℝ≥0∞`,
  `ENNReal.ofReal` or `toReal` anywhere; no measure theory, no periodicity, no a.e. notions.
- **Division by zero**: Lean's `/` is total, so the Notation proviso "whenever the three
  denominators are nonzero" is not automatic from the type. It is discharged on this domain by
  obligation S1 (`0 < y+z ∧ 0 < z+x ∧ 0 < x+y`), which is the faithful way to record the proviso;
  on the proposition's domain the Lean expression and the paper's `S(x,y,z)` denote the same real
  number, so no representation artefact is introduced.
- **Existence/finiteness/measurability/regularity**: not applicable to this result.
- **Non-vacuity** (pre-checked here, confirming the final audit will have witnesses):
  `P01Conclusion 1 1 1` and `P01Conclusion 2 1 1` both proved in `gate_P01_sanity2.lean`.

### 5. Step obligations S1–S6 — PASS; **all six are true as stated**

I restated each obligation verbatim in `pv_work/probes/gate/P01/gate_P01_truth.lean` and proved
each independently (`exit=0`). None is false as stated, and none is missing a premise.

| step | draft type | source sentence | labelled correctly? | true as stated? | smuggling? |
|---|---|---|---|---|---|
| S1 `P01_S1` | `0<x,0<y,0<z → 0<y+z ∧ 0<z+x ∧ 0<x+y` | Notation proviso main.tex:33 + domain main.tex:53 | yes (background convention, not a proof sentence; docstring says so) | yes (`linarith`) | no |
| S2 `P01_S2` | `hN → 0<x,0<y,0<z → S ≥ 3/2` | main.tex:60 first sentence | yes | yes, given `hN` — it is literally `hN x y z hx hy hz` | no (it is the cited clause, see item 6) |
| S3 `P01_S3` | `∀ x y z : ℝ, x*y+y*z+z*x ≤ x^2+y^2+z^2` | main.tex:61-65 display | yes | yes, **proved from `(Paper.L01.L01_main x y).ineq`, `(… y z).ineq`, `(… z x).ineq` + `linarith`** | no |
| S4 `P01_S4` | `0<x,0<y,0<z → 0 < x^2+y^2+z^2` | main.tex:66 "Since $x^2+y^2+z^2>0$" | yes | yes (`positivity`) | no |
| S5 `P01_S5` | `(x*y+y*z+z*x)/(x^2+y^2+z^2) ≤ 1` with positivity | main.tex:66-67 | yes | yes (from S3, S4) | no |
| S6 `P01_S6` | `3*(…)/(2*(x^2+y^2+z^2)) ≤ 3/2` with positivity | main.tex:67-68, first `≤` of the closing display | yes | yes | no — it is the first link of the printed chain, not the conclusion |

Remarks:
- **S3's hypothesis-freeness is correct, not a strengthening.** L01 holds for all reals
  (main.tex:38), so the summed inequality needs no positivity; stating S3 for all reals matches the
  strength of the source's own step. (The three instances sum to
  `(x²+y²)/2+(y²+z²)/2+(z²+x²)/2 = x²+y²+z²`, exactly the display at main.tex:64.)
- **S3 matches "to the pairs $(x,y)$, $(y,z)$ and $(z,x)$"**: my probe applies `L01_main` to exactly
  those three ordered pairs — the same pairs, in the same order, as main.tex:61-62 — and adds the
  three inequalities, which is what "adding the three inequalities" means. The use is of L01's
  `ineq` field only; the `equality_iff` field is not used, and the source does not use it here
  either.
- S1 is recorded but not consumed by `P01_main`'s chain (Lean's `/` is total). That is harmless and
  faithful: it discharges a convention, and `P01_main` does not depend on it, so it cannot weaken
  the result.
- **Assembly (item 5, last bullet, and focus question 5) — PASS.** `P01_main` (lines 129-134) does
  `have h6 := P01_S6 …; have h2 := P01_S2 hN …; unfold P01Conclusion; linarith [h6, h2]`, i.e.
  `3(xy+yz+zx)/(2(x²+y²+z²)) ≤ 3/2 ≤ S(x,y,z)` — character-for-character the closing display at
  main.tex:67-68, chained by transitivity in the same direction. The six obligations assembled do
  yield the main theorem: `P01_main` contains **no `sorry`** (the 6 `sorry_warnings` are exactly
  S1–S6), so the assembly is already machine-checked; the remaining work is only to discharge
  S1–S6, all of which I verified are provable along the source route.

### 6. External parameters — PASS

Exactly one `def … : Prop`, declared **only** in `P01Stmt.lean`, **inside `namespace Paper.P01`**
(lines 25/53), and no name already used in another `Stmt` file is redeclared (`L01Stmt.lean`
declares only `Paper.L01.L01Conclusion`; `L02Stmt.lean` declares no conclusion object). No
consumed-clause `(p)` parameter exists or is needed: L01 is FINAL_PASSED/UNCONDITIONAL, so
`P01Draft.lean:2` imports the proved module `L01` and calls `Paper.L01.L01_main` — **`L01Conclusion`
is not redeclared anywhere in P01's files** (focus question 3: PASS).

`pv_work/P01Stmt.lean:39-41`
```
def NesbittInequality : Prop :=
  ∀ x y z : ℝ, 0 < x → 0 < y → 0 < z →
    x / (y + z) + y / (z + x) + z / (x + y) ≥ 3 / 2
```

- **Not stronger than the source's use.** main.tex:60 asserts, on the strength of
  `\cite[Theorem~1]{Nesbitt1903}`, precisely "$S(x,y,z) \ge 3/2$ for all $x,y,z \in \Rpos$". The
  `def` is that sentence verbatim, with `S` inlined per main.tex:31 and `\Rpos` as positivity
  premises. It is not the full literature statement's strength plus extras, and it adds no
  conclusion of P01's own.
- **Not goal-shaped** (VERDICTS §4.2). It does not contain `P01Conclusion` and is not an
  intermediate estimate that *first appears in P01's proof*: it is a named classical theorem with a
  bibliography entry (main.tex:88-89), i.e. content the project does not prove, which rule 2 of
  `CLAUDE.md` requires to be a visible parameter. I note explicitly, for the record, that it is
  *logically stronger* than P01's conclusion (since `3(xy+yz+zx)/(2(x²+y²+z²)) ≤ 3/2` always holds
  on the domain), so once `hN` is granted the rest of P01 is elementary. **That is the paper's own
  proof architecture** (main.tex:59-68 does exactly this), not a formalization defect — but it means
  P01 can at best be **CONDITIONAL**, with the mathematical weight resting on the citation.
- **Provenance (i)** is correct: explicitly cited, with `\cite` location main.tex:60 and
  bibliography main.tex:87-90. Already registered as EXT-1 in `verification/EXTERNAL_TOOLS.md:24`
  with the same provenance.
- **"mathlib does not have it" evidence.** The draft notes make **no** claim that mathlib lacks
  Nesbitt's inequality, so LESSONS 1 is not violated. I attempted to search
  `.lake/packages/mathlib` myself for `nesbitt` (grep and a Python walk) and was **blocked by the
  permission system** (`.lake` is not readable from this role), so I record no claim either way.
  This does not block the gate: VERDICTS §4.2 says "Do not re-prove external theory that the source
  only cites without giving a proof. Write it as a parameter and leave it to human check", which is
  what the draft does. *Non-blocking recommendation*: if the prover can cheaply `#check` a mathlib
  Nesbitt lemma (or derive it from a mathlib AM-HM/Cauchy–Schwarz interface **without** building new
  infrastructure), the result could become UNCONDITIONAL; if it tries and fails, the names searched
  must be recorded.
- Human-check item: that "Theorem 1" of Nesbitt, *Problem 15114*, Educational Times 55 (1903), 37
  really states $S\ge 3/2$ for positive reals (worksheet priority D, and priority B for the
  numbering, see item 7).

**EXT-2 / EXT-3 are correctly *not* parameters (focus question 4: PASS).** `0 < x²+y²+z²`
(main.tex:66) and positivity of the three denominators are immediate consequences of
`0<x, 0<y, 0<z` — one `positivity` / three `linarith` calls, as my truth probe shows. Making them
visible parameters would overstate the paper's debts and would be exactly the "unnecessary
parameter for a trivial fact" that VERDICTS §4.2 warns against (its bullets reserve parameters for
facts needing real infrastructure). Keeping them as obligations S4/S1, each with its own
`file:line` docstring, is the faithful treatment. *Bookkeeping note for the coordinator (not a
gate condition)*: `verification/EXTERNAL_TOOLS.md:25-26` still lists EXT-2 and EXT-3 as candidate
inputs; after P01 is proved, only EXT-1 should remain in P01's `external_tools`.

### 7. Doubts about the source itself — none that block the gate

- The route is sound and each printed step follows: Nesbitt (cited) + L01 summed over the three
  pairs + division by `x²+y²+z²>0` + transitivity. I found no false step and no missing hypothesis;
  the printed conclusion is true (and my probes confirm instances, including the equality case
  `x=y=z`).
- **One editorial remark (`EDITORIAL`, VERDICTS §2.2 — not an issue, no `pv-issue-checker`
  dispatch needed):** main.tex:60 cites `\cite[Theorem~1]{Nesbitt1903}`, but the bibliography entry
  (main.tex:88-89) is a *problem column* item ("Problem 15114, Educational Times 55 (1903), 37"),
  which does not naturally carry a numbered "Theorem 1". This is a citation-precision matter, not a
  mathematical gap; it belongs on the human-check worksheet at priority B ("(i) whose attribution or
  numbering is doubtful"), not in `PAPER_VERIFICATION.md` as a paper error.
- Everything the proof silently uses (EXT-2, EXT-3) is both trivial and true on the stated domain,
  so there is no `PAPER_ASSUMPTION_GAP` candidate here.

---

## TFAs ruled on

| candidate TFA | ruling | reason |
|---|---|---|
| *(none offered, and none needed)* | — | The only premises of `P01_main` beyond the external parameter are `0<x, 0<y, 0<z`, which **are** the printed domain `x,y,z\in\Rpos` (main.tex:53), not additions. No extra premise is introduced in any of S1–S6 either (S3 even drops positivity, faithfully). Nothing to approve or reject. |

## External parameters

| Lean name | location | meaning | provenance | ruling |
|---|---|---|---|---|
| `Paper.P01.NesbittInequality` | `pv_work/P01Stmt.lean:39-41` | for all positive reals `x,y,z`: `x/(y+z)+y/(z+x)+z/(x+y) ≥ 3/2` | **(i)** cited result, `\cite[Theorem~1]{Nesbitt1903}`, main.tex:60; bibliography main.tex:87-90 | **APPROVED** — exactly the clause main.tex:60 attributes to the citation; not stronger; not goal-shaped (does not contain P01's conclusion, not an estimate first appearing in P01's proof); declared only in `P01Stmt.lean`, in `namespace Paper.P01`; no name collision. Forces P01 to be at most CONDITIONAL. |

No `(p)` consumed clause (`P01_L01Consumed`) exists — correct, since L01 is FINAL_PASSED and its
module is imported.

## Required changes

**None.**

## Statement snapshot

`#pv_type_hashes_here` on copies of the two reviewed files (copies made with Read/Write, with
`import PVTools` added and the command appended; the stmt copy contains no `sorry`, the draft copy
contains `sorry`, and the draft copy keeps `import P01Stmt`, using the drafter's `P01Stmt.olean`).

From `pv_work/logs/gate_P01_stmtcopy_1.log` (probe of
`pv_work/probes/gate/P01/gate_P01_stmtcopy.lean`), verbatim:

```
TYPE HASHES (current file, 2 declarations)
Paper.P01.NesbittInequality|def|th=3944470172|vh=2317600716|bi=
Paper.P01.P01Conclusion|def|th=3084956081|vh=790660802|bi=eee
EXIT=0
```

From `pv_work/logs/gate_P01_draftcopy_1.log` (probe of
`pv_work/probes/gate/P01/gate_P01_draftcopy.lean`), verbatim:

```
TYPE HASHES (current file, 7 declarations)
Paper.P01.P01_S1|thm|th=3328341825|vh=-|bi=eeeeee
Paper.P01.P01_S2|thm|th=490188029|vh=-|bi=eeeeeee
Paper.P01.P01_S3|thm|th=270464369|vh=-|bi=eee
Paper.P01.P01_S4|thm|th=3131007749|vh=-|bi=eeeeee
Paper.P01.P01_S5|thm|th=79124916|vh=-|bi=eeeeee
Paper.P01.P01_S6|thm|th=2605564061|vh=-|bi=eeeeee
Paper.P01.P01_main|thm|th=1996214978|vh=-|bi=eeeeeee
EXIT=0
```

The final audit must reproduce these lines with `#pv_type_hashes P01` (and for the statement
objects, with `#pv_type_hashes P01Stmt`), compared line by line, including `vh` for the two `def`s
(the content of the external parameter is locked by `vh=2317600716`).

## Overall

Items 1–7 all PASS; one approved external parameter (provenance (i)); no TFAs; no false
obligations; no required changes; one editorial citation remark for the human-check worksheet.
Proof work may begin: the prover must discharge S1–S6 along the source route (S3 via
`Paper.L01.L01_main` on `(x,y)`, `(y,z)`, `(z,x)`), and must not change any snapshotted type.

STATEMENT GATE: PASS
