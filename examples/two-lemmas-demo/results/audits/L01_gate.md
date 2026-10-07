# Statement gate — L01 (Lemma 1, `lem:square`)

- **Reviewer**: `pv-gate` (independent statement gate, Opus-class session)
- **Date**: Thu Oct  1 00:15:07 EDT 2026 (from `date`)
- **Reviewed files** (`python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean` — `9aab139358f5d69dd92ebde1c6f2821b1ce3809367557e44069757ac473ad550`
  - `pv_work/L01Draft.lean` — `3957cc2caf31fad06b6eaeaa14e5da8324dd4a555a81c3ea29841c2d39eafa11`
- **Draft notes consulted as leads only**: `pv_work/notes/L01_draft_notes.md` (not used as evidence).
- **Source read directly**: `source/demo.tex` lines 1–29 (whole file; statement 12–14, proof 16–18, preamble 1–11 checked for conventions — there are none beyond `\newtheorem{lemma}{Lemma}`, so "Lemma 1" is the lemma at line 12). No shared definition files are involved (`defs = NONE`), and `L01Stmt.lean` imports nothing.

## Compilation log (run by this reviewer)

```
$ scripts/pv_lean.sh packages
PACKAGES linked -> .../lean-env/.lake/packages; mathlib modules compiled: 2452 of 6305
linked: do NOT run 'lake build'

$ scripts/pv_lean.sh check L01Draft
RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0
  log=pv_work/logs/L01Draft_2.log olean=none
```

Real exit code: **0**. The three `sorry` warnings are exactly the three draft
obligations (`L01_S1`, `L01_S2`, `L01_main`); `olean=none` as expected for a draft.
No forbidden construct (`admit`, `axiom`, `unsafe`, `native_decide`,
`implemented_by`, `@[extern]`, `debug.skipKernelTC`) occurs in either file;
`nonstandard_axiom_lines=0`. `lake build` was not run (packages are `linked`).

## Source quotations

`source/demo.tex:12-14` (statement):

> `\begin{lemma}\label{lem:square}`
> `For all real numbers $a$ and $b$ we have $a^2 + b^2 \ge 2ab$.`
> `\end{lemma}`

`source/demo.tex:16-18` (proof):

> `\begin{proof}`
> `We have $a^2 + b^2 - 2ab = (a-b)^2 \ge 0$.`
> `\end{proof}`

`source/demo.tex:1-11` (preamble/front matter): `amsmath, amssymb, amsthm`,
`\newtheorem{lemma}{Lemma}`, title/author/date, `\begin{document}`,
`\maketitle`. **No** standing convention on constants, domains or notation is
printed anywhere in the source, so nothing extra may be read into the lemma:
`a`, `b` range over all of `ℝ`, unrestricted.

(For orientation only, out of scope here: a second lemma occupies
`source/demo.tex:20-27`.)

## Item-by-item rulings

### 1. Hypotheses — PASS

The printed hypothesis is exactly "for all real numbers $a$ and $b$".
`L01_main (a b : ℝ)` encodes this with two unrestricted real binders.

- No extra premise anywhere: `L01_main`, `L01_S1`, `L01_S2` each have the
  binders `(a b : ℝ)` and nothing else. Hence no TFA is needed and none is
  claimed.
- No hidden hypotheses: `L01Stmt.lean` declares **no** `structure`, `def`,
  `variable`, `class` or `instance` at all (confirmed by reading its full text
  and by the statement snapshot below reporting *0 declarations*);
  `L01Draft.lean` declares no `variable` and no `structure`. The only type
  classes involved are mathlib's own instances for `ℝ`, which carry no
  mathematical assumption about `a`, `b`.
- No obligation has the shape `(hB : B) : B` or an equivalent: none of the
  three theorems takes **any** `Prop`-valued hypothesis, so the conclusion
  cannot be assumed. In particular `L01_main` does **not** take `L01_S1`/
  `L01_S2` as premises; it is stated self-contained, which is strictly safer.

### 2. Conclusion — PASS

Printed conclusion: `$a^2 + b^2 \ge 2ab$`. Lean: `a ^ 2 + b ^ 2 ≥ 2 * a * b`
(`L01Draft.lean:50`). Same direction of the inequality (`\ge` kept as `≥`, not
flipped), same two sides, `2ab` read as `2 * a * b` (the only reading of
juxtaposition here; `a`, `b` are scalars, so associativity/commutativity make
the parse immaterial). Single clause in the source, single clause in Lean:
nothing weakened, nothing strengthened, no clause missing, no clause added.

### 3. Quantifiers and dependence of constants — PASS

There are no constants in this lemma, so the global convention on constants is
vacuous. The two universal quantifiers are encoded as theorem binders, which is
the standard Lean rendering of `∀ a b : ℝ`; the quantifier order is irrelevant
(both are independent universals) and the conclusion is inside both, matching
"For all real numbers $a$ and $b$ we have …".

### 4. Domains and details — PASS

- Domain: `ℝ` for both variables, unrestricted (no positivity, no nonzero, no
  periodicity question; nothing periodic/non-periodic arises).
- Equality vs. a.e. equality: not applicable (no measure space); `L01_S1` is a
  genuine pointwise identity, as printed.
- Existence/construction, finiteness, measurability, regularity: not applicable
  — the statement is a first-order inequality between real polynomials.
- Truncation traps: **none**. Everything lives in `ℝ`; there is no `ℝ≥0∞`, no
  `ENNReal.ofReal`, no `.toReal`, so no truncation can silently change the
  meaning. `0` in `L01_S2` is `(0 : ℝ)` (elaborated against `(a - b) ^ 2 : ℝ`),
  not a natural number coerced in a lossy way.
- Exponents: `^ 2` with `2 : ℕ` on a real base — the standard `Monoid.npow`,
  which is exactly `$a^2$` as printed.

### 5. Step obligations — PASS

| Step | Lean statement | Source sentence | Correspondence | True as stated? |
|---|---|---|---|---|
| `L01_S1` (`L01Draft.lean:28`) | `a ^ 2 + b ^ 2 - 2 * a * b = (a - b) ^ 2` | `demo.tex:17`, first half of the chain `a^2+b^2-2ab = (a-b)^2 \ge 0` | exact, including the direction of the rewrite | **Yes** — a ring identity valid for all reals, with no side condition; nothing can be missing from its premises because a commutative-ring identity needs none. |
| `L01_S2` (`L01Draft.lean:40`) | `(a - b) ^ 2 ≥ 0` | `demo.tex:17`, second half of the same chain (`… \ge 0`) | exact; the subject is literally the square the source writes | **Yes** — nonnegativity of a real square, for arbitrary `a, b : ℝ`; no premise is needed, hence none is missing. Verified by me to be closed by `sq_nonneg (a - b)` (see item 6). |
| `L01_main` (`L01Draft.lean:50`) | `a ^ 2 + b ^ 2 ≥ 2 * a * b` | `demo.tex:12-14` | it *is* the lemma | **Yes** — true for all reals. |

Explicitly: **no obligation is false as stated**, and no obligation is missing a
premise (none of the three needs one; this was checked by asking, for each,
whether the bare universally quantified statement is true over all of `ℝ`,
including degenerate values `a = b`, `a = 0`, `b = 0`, and negative values).

Smuggling check: neither `L01_S1` nor `L01_S2` contains the target inequality
`a^2+b^2 ≥ 2ab` nor any stronger intermediate claim. `L01_S1` is an equality
between the two sides' difference and a square; `L01_S2` is a statement about a
square alone. Neither is "the goal in disguise": from `L01_S2` alone one still
needs `L01_S1` plus `sub_nonneg`, and from `L01_S1` alone one gets nothing
about signs.

Assembly check: `L01_S1` and `L01_S2` give `a^2+b^2-2ab ≥ 0`, and
`sub_nonneg` turns this into `a^2+b^2 ≥ 2ab`, i.e. `L01_main`. So the
obligations assembled together do yield the main theorem. The final
`sub_nonneg` move is precisely what the source's one-line chain
`a^2+b^2-2ab=(a-b)^2\ge 0` intends; it is a `FAIR_IMPLICIT_STEP`, not an
unjustified addition (the source does assert the chain whose left end is the
difference, so reading off "difference ≥ 0 ⟺ inequality" is the printed
argument, not a repair).

The split of the single displayed chain into S1 + S2 is a form-only
decomposition: it neither adds nor drops source content.

### 6. External parameters — PASS (there are none, and that is the correct call)

`L01Stmt.lean` declares **no** `def Tool : Prop`, no consumed clause, no
`structure`, no `theorem`; it contains only `namespace Paper.L01` /
`end Paper.L01` plus a docstring. Consequences for each sub-check:

- Not stronger than the source's use / not goal-shaped / provenance labels /
  naming / location: vacuous — there is nothing declared. In particular no name
  is redeclared from another `Stmt` file, and the (empty) content sits in
  `namespace Paper.L01` as required.
- The drafter's docstrings in `L01Stmt.lean` and `L01Draft.lean` do refer to
  `sq_nonneg` with the parenthetical "type (v) in the provenance scheme, but
  not registered as a parameter". That wording is loose — a (v) parameter is by
  definition "a standard fact with **no** interface in the pinned mathlib"
  (`VERDICTS.md` §4.1), so a fact that *does* have an interface is not a (v)
  item that was waived, it is simply not an external input at all. This is a
  comment-only imprecision with no effect on any statement or hash; per POLICY
  §3–§4 a reviewed file must not be edited even for a comment, so I do **not**
  request a change here and raise no amendment. (Recorded for the coordinator's
  awareness only; if anyone wants it noted persistently it belongs in
  `verification/DOC_ERRATA.md`, which is not mine to pre-empt.)

**Focus question — is "cite `sq_nonneg` directly rather than declare a (v)
parameter" correct? YES.** I did not take the drafter's probe on trust and ran
my own evidence probe,
`pv_work/probes/gate/L01/gate_L01_sqnonneg.lean`
(log `pv_work/logs/gate_L01_sqnonneg_1.log`):

```
@sq_nonneg : ∀ {R : Type u_1} [inst : Semiring R] [inst_1 : LinearOrder R] [inst_2 : IsRightCancelAdd R]
  [inst_3 : ZeroLEOneClass R] [inst_4 : ExistsAddOfLE R] [inst_5 : PosMulMono R] [inst_6 : AddLeftStrictMono R] (a : R),
  0 ≤ a ^ 2
sq_nonneg : ∀ (a : ℝ), 0 ≤ a ^ 2
```

and, in the same probe, `example (a b : ℝ) : (a - b) ^ 2 ≥ 0 := sq_nonneg (a - b)`
elaborated with **no** error — i.e. the mathlib lemma closes the obligation
`L01_S2` verbatim, with `ℝ` satisfying every instance argument by the pinned
mathlib's own instances and with `Mathlib.Data.Real.Basic` (already imported by
`L01Draft.lean`) sufficing. So the interface exists, is directly applicable,
and needs no infrastructure: registering a parameter would add an unnecessary
condition to the result and would wrongly downgrade L01 from a potential
UNCONDITIONAL verdict. The drafter's call is correct.

(The same probe additionally tried `nlinarith`, which is not available under
`Mathlib.Data.Real.Basic` alone and produced the probe's `exit=1`: two errors,
both on probe line 8, `unknown tactic` / `unsolved goals`. That is an artifact
of my own probe's imports only — it concerns neither file under review, and the
`#check` lines and the `sq_nonneg (a - b)` term proof on lines 4–7 all
succeeded. It is a tactic-import matter for the prover, not a statement issue
and certainly not a paper issue.)

### 7. Doubts about the source itself — PASS (none)

Lemma 1 as printed is true for all real `a, b`, and the printed proof
(`demo.tex:17`) is a complete and correct justification: the identity is a ring
identity and the nonnegativity is standard. No missing hypothesis, no
uncovered case or range, no domain ambiguity, no citation to check. **No
suspected paper issue; no `pv-issue-checker` dispatch is recommended for L01.**

## TFAs ruled on

| TFA | Status | Reason |
|---|---|---|
| (none claimed, none present) | — | No obligation or statement carries any premise beyond the source's own "`a`, `b` real"; there is nothing to approve or reject. |

## External parameters

| Parameter | Provenance | Status | Reason |
|---|---|---|---|
| (none declared) | — | — | `L01Stmt.lean` declares nothing; snapshot confirms 0 declarations. |
| `sq_nonneg` (mathlib, **not** a parameter) | n/a — not an external input | **Approved as a direct citation** | Has a direct interface in the pinned mathlib, confirmed by my own `#check @sq_nonneg`, `#check (sq_nonneg : ∀ a : ℝ, 0 ≤ a ^ 2)` and a successful term proof `sq_nonneg (a - b) : (a - b) ^ 2 ≥ 0`. Therefore not (v) (`VERDICTS.md` §4.1 requires "no interface in the pinned mathlib") and must not be registered. |

If L01 is proved as drafted, it is on track for **UNCONDITIONAL** (no visible
parameters), subject to the final audit.

## Required changes

**None.**

## Statement snapshot

Taken on copies that I wrote from the exact text I read, each with
`import PVTools` added after the imports and `#pv_type_hashes_here` at the end
(the draft copy keeps `import L01Stmt` and so uses the drafter's
`L01Stmt.olean`):

- copy of `L01Stmt.lean` → `pv_work/probes/gate/L01/gate_L01_stmtcopy.lean`
  `RESULT gate_L01_stmtcopy mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L01_stmtcopy_1.log`
  (contains no `sorry`, as required)
- copy of `L01Draft.lean` → `pv_work/probes/gate/L01/gate_L01_draftcopy.lean`
  `RESULT gate_L01_draftcopy mode=probe exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L01_draftcopy_1.log`
  (contains `sorry`, as required for a draft)

`TYPE HASHES` output, verbatim.

From `pv_work/logs/gate_L01_stmtcopy_1.log`:

```
TYPE HASHES (current file, 0 declarations)
```

From `pv_work/logs/gate_L01_draftcopy_1.log`:

```
TYPE HASHES (current file, 3 declarations)
Paper.L01.L01_S1|thm|th=1311506106|vh=-|bi=ee
Paper.L01.L01_S2|thm|th=1002552111|vh=-|bi=ee
Paper.L01.L01_main|thm|th=86406052|vh=-|bi=ee
```

(`vh=-` for all three because they are `theorem`s, not `def`s; `bi=ee` records
the two explicit binders `(a b : ℝ)` of each. The `L01Stmt` snapshot having 0
declarations is itself the machine-checked confirmation of item 6: there is no
external parameter and no hidden `structure`/`variable` to smuggle a
hypothesis. In the final audit, `#pv_type_hashes L01` must reproduce these
lines for the proved module, compared line by line.)

Whether the statements changed must be decided by comparing these hashes, not
by eye.

STATEMENT GATE: PASS
