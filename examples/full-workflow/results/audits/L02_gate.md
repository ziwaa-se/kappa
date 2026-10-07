# L02 — independent statement gate (revision 1)

- **Reviewer**: `pv-gate` (independent subagent; not the drafter)
- **Date**: Wed Sep 30 20:43:17 EDT 2026 (`date`)
- **Result**: L02 = Lemma 2.3 (`lem:quot`), `source/main.tex:71-76` (statement), `source/main.tex:78-81` (proof)
- **Supersession note**: this file **replaces** the earlier `verification/audits/L02_gate.md`,
  which audited the now-superseded draft of the *old* printed hypothesis `x ≠ -1`
  (that draft now lives in `pv_work/superseded/`). The closed history of the old
  statement — the confirmed counterexample, `verification/BLOCKERS.md` B01,
  `verification/audits/L02_issue_1.md`, `L02_issue_1_audit.md` — is **not re-litigated
  here**. This report rules only on whether the new draft faithfully encodes the
  **current** (revision 1) source text.

## Reviewed files

| File | sha256 (`python3 scripts/pv_snapshot.py hash`) |
|---|---|
| `pv_work/L02Stmt.lean` | `28e672e921cf770c919979339831cd69897a111d72b11dfb7f74ad1c3c86ddea` |
| `pv_work/L02Draft.lean` | `07271edbf333ed46f3e0d7f1351d84d1d35a7d60d9363e480ec16f2106fec67d` |
| `pv_work/notes/L02_draft_notes.md` (leads only, not evidence) | `06b3b50e49561cb68a45d9a7709b5c36f3a3f6383bfb2829980ea9b96a57f878` |

Both Lean files were read in full by this reviewer; the source was read directly
with `Read` (offsets 1–55 and 55–99 of `source/main.tex`), covering the Notation
section (`main.tex:26-33`), the theorem-numbering declarations (`main.tex:4-8`,
which make `lem:quot` = Lemma 2.3), the statement, the proof and the following
Remark.

## Compilation

```
$ scripts/pv_lean.sh check L02Draft
RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_4.log olean=none
```
Real exit code: **0** (the shell reported success; the `RESULT` line's `exit=0`
agrees). 4 `sorry` warnings = S1–S4, which is the expected draft state;
`L02_main` itself contains no `sorry` and is assembled by `apply`/`rw`/`exact`,
so the assembly is machine-checked. No `admit`, `axiom`, `unsafe`,
`native_decide`, `implemented_by`, `@[extern]` or `debug.skipKernelTC` occurs in
either file (read in full).

Gate probes (gate-owned, under `pv_work/probes/gate/L02/`):

```
$ scripts/pv_lean.sh probe pv_work/probes/gate/L02/gate_L02_stmtcopy.lean
RESULT gate_L02_stmtcopy  mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_stmtcopy_2.log
$ scripts/pv_lean.sh probe pv_work/probes/gate/L02/gate_L02_draftcopy.lean
RESULT gate_L02_draftcopy mode=probe exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_draftcopy_2.log
$ scripts/pv_lean.sh probe pv_work/probes/gate/L02/gate_L02_truth.lean
RESULT gate_L02_truth     mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_truth_3.log
```

The copies differ from the originals only by the added `import PVTools` and the
trailing `#pv_type_hashes_here` (verified by `diff`: `1a2` and `48a50,51` /
`97a99,100` respectively), so the snapshot below corresponds to the text read.

## Source quotations

Statement, `source/main.tex:71-76`:

```
\begin{lemma}\label{lem:quot}
For every real number $x > -1$ we have
\[
  \frac{x^2}{1+x} \ge x - 1 .
\]
\end{lemma}
```

Proof, `source/main.tex:78-81`:

```
\begin{proof}
Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality, so the claim
is equivalent to $x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.
\end{proof}
```

Following Remark, `source/main.tex:83-85`: "Lemma~\ref{lem:quot} is used in the
companion paper only for $x \ge 0$." — a remark about downstream use, **not** a
narrowing of this lemma's hypothesis.

Relevant conventions: `main.tex:10-11` (`\R`, `\Rpos`), `main.tex:26-33`
(Notation: `\R` = the reals; `S(x,y,z)` — not used by this lemma). No shared
`Defs*.lean` applies; the lemma is plain `ℝ` arithmetic, as the drafter's
`L02Stmt.lean` header claims and as the source text confirms independently.

## Rulings, items 1–7

### 1. Hypotheses — **PASS**

- Printed hypotheses: `x` is a real number; `x > -1`. Encoded as
  `(x : ℝ) (hx : x > -1)` in `L02_main` (`L02Draft.lean:89`). The literal `-1`
  elaborates at type `ℝ` (forced by `x : ℝ`); the domain is **exactly** `x > -1`,
  not `x ≠ -1`, not `x ≥ 0`, not `1 + x > 0` substituted at statement level.
- **Extra premises: none.** `hx` is the sole hypothesis of `L02_main` and of
  S1/S2; S3/S4 carry only `(x : ℝ)`.
- **Hidden hypotheses: none.** `L02Stmt.lean` declares nothing at all (only the
  `namespace Paper.L02` / `end` pair) — no `structure`, no `variable`, no
  `class`, no instance, no `def`. The only import is `Mathlib.Data.Real.Basic`.
  `L02Draft.lean` imports only `L02Stmt` and introduces no `variable` block.
- No hypothesis of the form `(hB : B) : B`: the conclusion
  `x ^ 2 / (1 + x) ≥ x - 1` appears nowhere as a hypothesis of any declaration.
  (It appears as the *left side of an iff* in S2, which is the source's own
  "the claim is equivalent to …"; see item 5.)

### 2. Conclusion — **PASS**

Printed: `\frac{x^2}{1+x} \ge x - 1`. Lean (`L02Draft.lean:89`):
`x ^ 2 / (1 + x) ≥ x - 1`. Clause-for-clause identical: same numerator `x^2`,
same denominator `1 + x` (in the printed order), same direction `≥`, same
right-hand side `x - 1`. The printed lemma has **no** second clause (no
"with equality iff", unlike Lemma 2.1 at `main.tex:42`), so nothing is missing
and nothing is added. Neither weakened (the domain is the full printed `x > -1`,
not the `x ≥ 0` of the Remark) nor strengthened.

Division convention: Lean's `/` is total with `a / 0 = 0`; on the stated domain
`1 + x > 0 ≠ 0`, so the junk value is never reached and the encoding cannot
manufacture or hide a paper error here.

### 3. Quantifiers and dependence of constants — **PASS**

The source universally quantifies over a single real `x` ("For every real number
$x > -1$"); Lean universally quantifies over `(x : ℝ)` with `hx` depending on
`x`. There are no constants, no existential quantifiers, hence no
constant-dependence convention to check. Every step obligation that needs `x`
quantifies it locally in the same way (`∀ x`, then `hx` where used), so no
obligation accidentally fixes `x` or smuggles in uniformity.

### 4. Domains and details — **PASS**

- Domain: `ℝ`, non-periodic, no measure-theoretic content; nothing to convert.
- Equality vs. a.e. equality: not applicable (pointwise statement about one real).
- Existence/construction, finiteness, measurability, regularity: not applicable.
- `ℝ≥0∞` truncation traps (`ENNReal.ofReal`, `toReal`): none — everything is in
  `ℝ`, so no truncation can silently repair the inequality. In particular the
  right-hand side `x - 1` is genuinely negative for `x < 1` and is *not* clipped
  at `0`, which matters: a `ℝ≥0`-style encoding would have trivialised the lemma
  on most of the domain. The draft avoids that.
- `x ^ 2` for `x^2` and `/` for the quotient are pure notation conversions.

### 5. Step obligations — **PASS** (all four true as stated; machine-checked)

Mapping against the two clauses of `main.tex:79-80`:

| Obligation | Lean (file:line) | Source clause | Ruling |
|---|---|---|---|
| S1 | `L02Draft.lean:36` `(x : ℝ) (hx : x > -1) : (1:ℝ) + x > 0` | `main.tex:79` "Since $1+x > 0$" | Faithful. The revised proof *asserts* this sign fact; making it an obligation discharged from `hx` is exactly the content of that clause. |
| S2 | `L02Draft.lean:48-49` `(x : ℝ) (hx : x > -1) : x^2/(1+x) ≥ x-1 ↔ x^2 ≥ (x-1)*(x+1)` | `main.tex:79-80` "multiplying both sides by $1+x$ preserves the inequality, so the claim is equivalent to $x^2 \ge (x-1)(x+1)$" | Faithful, including the `↔` (the source says "equivalent to", not merely "it suffices"). The right-hand side is written `(x-1)*(x+1)` exactly as printed (the source multiplies by `1+x` and prints the product as `(x-1)(x+1)`; the reordering `1+x → x+1` is commutativity of `ℝ`, a notation-level conversion). `hx` is threaded in so the step can cite S1 as its licence, matching "Since $1+x>0$, …". |
| S3 | `L02Draft.lean:59` `(x-1)*(x+1) = x^2 - 1` | `main.tex:80` "$(x-1)(x+1) = x^2 - 1$" | Faithful; the source prints this equality inside the chain. |
| S4 | `L02Draft.lean:73` `x^2 ≥ x^2 - 1` | `main.tex:80` "$x^2 \ge x^2-1$, which is obvious" | Faithful; this is precisely the assertion the source calls obvious. |

**Truth as stated** — checked by this reviewer in Lean, not by eye
(`pv_work/probes/gate/L02/gate_L02_truth.lean`, probe `exit=0`): S1 (`linarith`
from `hx`), S2 (`le_div_iff₀` with `0 < 1 + x` from `hx`, then `nlinarith` in both
directions), S3 (`ring`), S4 (`linarith`), and the main statement itself on the
printed domain. **None is false as stated.**

Necessity of the premise was checked explicitly, because that is the previous
round's failure mode: the same probe proves
`¬ ((-2:ℝ)^2/(1+(-2)) ≥ (-2)-1 ↔ (-2)^2 ≥ ((-2)-1)*((-2)+1))` by `norm_num`, i.e.
S2 **would be false without `hx`** (at `x = -2` the left side is `-4 ≥ -3`, false,
while the right side is `4 ≥ 3`, true). The premise `hx` is present in S2, so the
obligation is sound; this is exactly the gap the superseded draft left open, and
it is closed here. S1 likewise genuinely needs `hx` and has it. S3 and S4 are
unconditional over `ℝ`, so their missing `hx` is correct, not an omission.

**No smuggling.** No obligation is the target conclusion or a stronger
intermediate: S2 is an equivalence whose `mpr` direction is used, and the
antecedent `x^2 ≥ (x-1)*(x+1)` is then supplied *independently* from S3 + S4, so
there is no circularity and no "conclusion as hypothesis". No obligation is
stronger than the source sentence it encodes (S2 is exactly the printed
equivalence; S4 is exactly the printed trivial inequality).

**Assembly.** `L02_main` (`L02Draft.lean:89-95`) is `apply h2.mpr; rw [h3]; exact h4`
with `h2 = L02_S2 x hx`, `h3 = L02_S3 x`, `h4 = L02_S4 x`; the file type-checks
with the only `sorry`s inside S1–S4, so the Lean kernel confirms that S1–S4
(S1 feeding S2) do yield the main theorem. Nothing beyond the four obligations is
needed, and no obligation is unused in substance (S1 is consumed inside S2, as
the source consumes "Since $1+x>0$" inside the multiplication step).

### 6. External parameters — **PASS** (there are none, and none is required)

`L02Stmt.lean` declares no `def … : Prop`, so there is nothing to rule on with
respect to strength, goal-shape, provenance labels, naming or namespace, and no
name is redeclared from another `Stmt` file (it declares no names at all). I
confirm independently that this is the correct choice under `VERDICTS.md` §4:
an external input is "mathematical content that the source uses but that **this
project does not prove in Lean**" (§4 opening), with the (v) route reserved for
standard facts that "would need a lot of infrastructure" (§4.2 last bullet).

- The candidate EXT-4 ("which is obvious", `main.tex:80`) decomposes into S3
  (a `ring` identity) and S4 (`x^2 ≥ x^2 - 1`), both of which I discharged in
  the gate probe in one tactic each. No infrastructure is needed, so writing an
  opaque `Tool : Prop` here would hide, not expose, content — and would be
  goal-adjacent for S4. Correctly a step obligation.
- The sign clause ("Since $1+x > 0$", `main.tex:79`) is S1, discharged by
  `linarith` from `hx`. It is also no longer a *silent* use (the old (iii)-style
  EXT-5 candidate): the revised text prints it. Correctly a step obligation.
- No "mathlib does not have X" claim is made anywhere in the draft or notes, so
  no `#check` evidence is owed. (I nevertheless ran `#check` while building the
  probe: `le_div_iff₀` and `div_le_iff₀` exist in the pinned mathlib,
  `pv_work/logs/gate_L02_names_1.log`; `le_div_iff` does not. That is a proving
  detail for `pv-prover`, not a statement issue.)
- No predecessors: L02 has no `depends_on` entries, and the proof text cites no
  earlier result of the paper (contrast `main.tex:60-62`, where Proposition 2.2
  cites Nesbitt and Lemma 2.1). So no `(p)` consumed clause is due, and the
  absence of `L02_<PredID>Consumed` is correct.

### 7. Doubts about the source itself — **none**

Against the **current** text I find no suspected paper issue, and I do not rely
on the drafter's claim to that effect:

- the printed statement is true on the printed domain (machine-checked above);
- every clause of the printed proof is true as printed, and the clauses chain
  into the conclusion with no step the source leaves unjustified: the sign fact
  is now printed, and it is exactly what licenses the multiplication;
- the terseness of "which is obvious" is a `FAIR_IMPLICIT_STEP` at most (not an
  issue; `VERDICTS.md` §2.2), and here it is not even deferred — it is encoded
  and dischargeable;
- the Remark at `main.tex:83-85` is not part of the lemma and creates no
  ambiguity about the domain.

No `pv-issue-checker` dispatch is recommended for L02 revision 1. (The B01
`ERROR` against the *old* `x ≠ -1` statement remains closed history and is not
reopened or re-ruled here.)

## TFAs ruled on

| TFA | Ruling | Reason |
|---|---|---|
| — (none proposed, none needed) | n/a | `hx : x > -1` is the printed hypothesis itself, not a technical addition; no other premise appears anywhere in `L02Stmt.lean` or `L02Draft.lean`. |

## External parameters ruled on

| Parameter | Provenance | Ruling |
|---|---|---|
| — (none declared) | n/a | Correct: both candidate items (EXT-4 "which is obvious"; the sign clause) are trivial `ℝ` facts proved in-project as step obligations, so they are not external inputs under `VERDICTS.md` §4. External-input count for L02 = **0**. |

## Required changes

**None.**

## Statement snapshot

`pv_work/probes/gate/L02/gate_L02_stmtcopy.lean` (verbatim from
`pv_work/logs/gate_L02_stmtcopy_2.log`):

```
TYPE HASHES (current file, 0 declarations)
```

`pv_work/probes/gate/L02/gate_L02_draftcopy.lean` (verbatim from
`pv_work/logs/gate_L02_draftcopy_2.log`):

```
TYPE HASHES (current file, 5 declarations)
Paper.L02.L02_S1|thm|th=399946927|vh=-|bi=ee
Paper.L02.L02_S2|thm|th=2050626304|vh=-|bi=ee
Paper.L02.L02_S3|thm|th=2900165390|vh=-|bi=e
Paper.L02.L02_S4|thm|th=2894931473|vh=-|bi=e
Paper.L02.L02_main|thm|th=2848314126|vh=-|bi=ee
```

The final audit must reproduce these five lines with `#pv_type_hashes L02` and
compare line by line. `L02Stmt.lean` contributes no declarations, so any
declaration appearing there later is itself a snapshot deviation.

STATEMENT GATE: PASS
