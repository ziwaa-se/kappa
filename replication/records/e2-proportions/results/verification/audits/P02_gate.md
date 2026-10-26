# P02 statement gate

- Reviewer: pv-gate (independent subagent, new session)
- Date: Mon Oct 12 22:17:43 EDT 2026
- Result: P02 = Proposition `prop:uniform`, source/main.tex:73-75 (statement), 77-79 (proof)

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

```
5d0ef1fca5efb27952dcdf44baae0f7fd57285a89d4b0a32f6e7146088d39e44  pv_work/P02Stmt.lean
b716598f308b25eccfd01ef6494a01fd9e2cd86519ee1bc055d31738f4b17061  pv_work/P02Draft.lean
a1b73435f532aaa6ab81b1a105e094bd8ad198122f6f3dc1ccae14c33868dfee  pv_work/notes/P02_draft_notes.md
0259b9aa4c03c2e64066ab3240783bfdbb600dc04c0b6182dccc0d6a1e831b67  pv_work/Defs.lean
3358dd01871d88e1ffaca81c5075a85cd4bb4a50ac11f5e083f5ed953ff46163  pv_work/L01Stmt.lean
```

Also read: `pv_work/L01.lean` (headers of `L01_S1`, `L01_S2`, `L01_main`).

## Compilation

- `scripts/pv_lean.sh check P02Draft`: `RESULT P02Draft mode=check exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/P02Draft_2.log olean=none`. EXIT=0; the 3 `sorry` warnings are the three draft obligations (expected for a draft).

## Source quotations (read directly)

- main.tex:24: "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
- main.tex:26-28 (def:vp): "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; ..."
- main.tex:38-39 (lem:quarter, = L01): "For every $p \in \mathbb{R}$, $p(1-p) = \frac14 - (p - \frac12)^2$. In particular $V_n(p) \le \frac{1}{4n}$."
- main.tex:73-74 (prop:uniform): "There is a constant $C$ such that $V_n(p) \le C/n$ for every $n \ge 1$ and every $p \in \mathbb{R}$."
- main.tex:77-78 (proof): "By Lemma~\ref{lem:quarter}, $C = \frac14$ works."

## Shared definitions

- `Paper.DEFS.V n p := p * (1 - p) / (n : ℝ)` (Defs.lean:21) matches main.tex:27 exactly; `n ≥ 1` is not built in and is carried as a hypothesis, as documented. No division-by-zero trap is relevant since every use here has `1 ≤ n`.
- `IOpen`/`IClosed` are not used by P02 (the source says `p ∈ ℝ`), so the open/closed ambiguity of `I` does not affect this result.

## Item rulings

1. **Hypotheses — PASS.** Source hypotheses: `n ≥ 1` integer (line 24, line 74), `p ∈ ℝ`. Encoded as `∀ n : ℕ, 1 ≤ n → ∀ p : ℝ`. No extra premises, no structures/type classes/variables hiding hypotheses; `Conclusion` takes no arguments. No conclusion-as-hypothesis form.
2. **Conclusion — PASS.** `∃ C : ℝ, ∀ n, 1 ≤ n → ∀ p, V n p ≤ C / (n : ℝ)` is exactly "there is a constant C with V_n(p) ≤ C/n for all n ≥ 1, all real p". Neither weakened nor strengthened; `C : ℝ` (source puts no restriction on C).
3. **Quantifiers / constants — PASS.** `∃ C` precedes `∀ n ∀ p`, matching "a constant C such that ... for every n ... every p" (uniformity in n and p is the content of the proposition). C depends on nothing.
4. **Domains and details — PASS.** p ranges over all of ℝ (not I), matching line 74; n over naturals ≥ 1 (cast to ℝ, no truncation issue: `(n:ℝ) ≥ 1 > 0`). No ENNReal/toReal, a.e., measurability or finiteness aspects.
5. **Step obligations — PASS.**
   - `P02_S1 (n) (hn : 1 ≤ n) (p) : V n p ≤ 1 / (4 * (n:ℝ))` — corresponds to "By Lemma lem:quarter" (line 78); it is literally `L01.Conclusion.bound`, available from `Paper.L01.L01_main n hn p` (L01 is imported, FINAL_PASSED). True as stated: p(1-p) ≤ 1/4 and n > 0. No missing premise.
   - `P02_S2 : ∃ C, C = 1/4 ∧ ∀ n, 1 ≤ n → ∀ p, V n p ≤ C / n` — corresponds to "C = 1/4 works" (line 78). It is a witness-explicit form of the conclusion, which is exactly what the source sentence asserts, so it does not smuggle anything beyond the source's own claim; it follows from S1 by `1/(4n) = (1/4)/n` (FAIR_IMPLICIT_STEP, trivial algebra). True as stated.
   - Assembly: `P02_main` follows from S2 by dropping the `C = 1/4` conjunct. The obligations assembled yield the main theorem.
6. **External parameters — PASS (none).** No `def ... : Prop` tool, no consumed clause. The predecessor L01 is FINAL_PASSED and imported directly as a proved module, so no (p) clause is needed. No names redeclared; everything in `namespace Paper.P02`.
7. **Doubts about the source — PASS (none).** The proof is a direct application of lem:quarter, which holds for every real p (lines 38-39), so the claim "for every p ∈ ℝ" is covered. No suspected paper issue.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | no extra premises |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

Statement copy `pv_work/probes/gate/P02/gate_P02_stmtcopy.lean` (log `pv_work/logs/gate_P02_stmtcopy_1.log`, EXIT=0):

```
TYPE HASHES (current file, 1 declarations)
Paper.P02.Conclusion|def|th=3944470172|vh=2472539567|bi=
EXIT=0
```

Draft copy `pv_work/probes/gate/P02/gate_P02_draftcopy.lean` (log `pv_work/logs/gate_P02_draftcopy_1.log`, EXIT=0, 3 sorry warnings):

```
TYPE HASHES (current file, 3 declarations)
Paper.P02.P02_S1|thm|th=1657993538|vh=-|bi=eee
Paper.P02.P02_S2|thm|th=1167378340|vh=-|bi=
Paper.P02.P02_main|thm|th=23622697|vh=-|bi=
EXIT=0
```

## Overall verdict

Statement faithful to main.tex:73-75; obligations mirror the one-line proof at main.tex:78 and are true as stated; no TFAs, no external parameters, no suspected issues.

STATEMENT GATE: PASS
