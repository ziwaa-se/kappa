# L01 statement gate (Lemma `lem:quarter`)

- Reviewer: pv-gate (independent subagent, fresh session)
- Date: Mon Oct 12 21:58:52 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean`  3358dd01871d88e1ffaca81c5075a85cd4bb4a50ac11f5e083f5ed953ff46163
  - `pv_work/L01Draft.lean` a40efa905e656ed3ca679943025001908edd932b18ef94baf8232912d8de9a43
  - `pv_work/Defs.lean` (imported, shared; DEFS gate PASS) 0259b9aa4c03c2e64066ab3240783bfdbb600dc04c0b6182dccc0d6a1e831b67
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0`, log `pv_work/logs/L01Draft_2.log` (2 sorries = S1, S2, expected in a draft).
- Draft notes `pv_work/notes/L01_draft_notes.md` were used only as leads.

## Source quotations (read directly)

- main.tex:24 "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
- main.tex:26-28 (def:vp) "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; ..."
- main.tex:38-39 (lem:quarter) "For every $p \in \mathbb{R}$, $p(1-p) = \frac14 - (p - \frac12)^2$. In particular $V_n(p) \le \frac{1}{4n}$."
- main.tex:43-44 (proof) "Expanding, $\frac14 - (p - \frac12)^2 = \frac14 - p^2 + p - \frac14 = p(1-p)$. Since $(p - \frac12)^2 \ge 0$ and $n > 0$, the bound follows."

## Rulings

1. **Hypotheses: PASS.** Source hypotheses: `n` integer with `n ≥ 1` (line 24, global convention), `p ∈ ℝ` (line 38). Lean: `(n : ℕ) (hn : 1 ≤ n) (p : ℝ)`. `ℕ` with `1 ≤ n` is exactly the integers `≥ 1`. No extra premises. `Conclusion` is a plain structure of two Prop fields, no hidden type-class or `variable` hypotheses. `V` in Defs is `p*(1-p)/(n:ℝ)`, faithful to line 27 (no truncation; `n` cast to ℝ). No conclusion-as-hypothesis.
2. **Conclusion: PASS.** Both clauses present: `identity : p*(1-p) = 1/4 - (p-1/2)^2` (line 39, first clause, for all real p), `bound : V n p ≤ 1/(4*(n:ℝ))` (line 39, second clause, "in particular", same p ∈ ℝ). Neither weakened nor strengthened. `1/(4n)` read as `1/(4·n)` in ℝ, correct.
3. **Quantifiers/constants: PASS.** No constants. Order n, hn, p; both universally quantified; matches source.
4. **Domains/details: PASS.** Domain of p is all of ℝ as printed (I is not used, correctly no IOpen/IClosed). Real-valued throughout; no ENNReal, no a.e., no measurability. Division by `(n:ℝ)` is safe given `hn`.
5. **Step obligations: PASS.**
   - `L01_S1 (p : ℝ)`: identity; matches line 43; true for all real p (polynomial identity).
   - `L01_S2 (n) (hn : 1 ≤ n) (p)`: `V n p ≤ 1/(4n)`; matches lines 43-44; true as stated (p(1-p) ≤ 1/4 for all real p, and n ≥ 1 > 0). Checked for missing premises: none needed beyond `hn` (positivity of n, the source's "n > 0" from line 24, FAIR_IMPLICIT_STEP). Does not smuggle anything stronger than the target clause; it is the clause itself, which is what the proof sentence establishes. Note: S2's docstring says "Uses S1" but S1 is not a hypothesis of S2; the prover may call `L01_S1` inside the proof, which is fine.
   - Assembly: `L01_main` = `⟨L01_S1 p, L01_S2 n hn p⟩` compiles; obligations together give the main theorem.
6. **External parameters: PASS (none).** No `def Tool : Prop`, no consumed clauses, no predecessors. Nothing needed: identity and bound are elementary.
7. **Doubts about the source: PASS.** None found. "n > 0" from n ≥ 1 is FAIR_IMPLICIT_STEP (not an issue).

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | - | no extra premises; `hn : 1 ≤ n` is the source's own convention (line 24), not a TFA |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | - |

## Required changes

None.

## Statement snapshot

`pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, log `pv_work/logs/gate_L01_stmtcopy_1.log`):

```
TYPE HASHES (current file, 9 declarations)
Paper.L01.Conclusion.bound|thm|th=2089935486|vh=-|bi=iie
Paper.L01.Conclusion.casesOn|def|th=3293930383|vh=3139214440|bi=iiiee
Paper.L01.Conclusion.identity|thm|th=1348454080|vh=-|bi=iie
Paper.L01.Conclusion.mk|ctor|th=1514541450|vh=-|bi=iiee
Paper.L01.Conclusion.noConfusionType|def|th=3585865348|vh=293613762|bi=iieee
Paper.L01.Conclusion.noConfusion|def|th=4005061032|vh=3339884299|bi=iiiiie
Paper.L01.Conclusion.recOn|def|th=3293930383|vh=3609147854|bi=iiiee
Paper.L01.Conclusion.rec|rec|th=38616851|vh=-|bi=iiiee
Paper.L01.Conclusion|induct|th=1224325432|vh=-|bi=ee
```

`pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, 2 sorry warnings, log `pv_work/logs/gate_L01_draftcopy_1.log`):

```
TYPE HASHES (current file, 3 declarations)
Paper.L01.L01_S1|thm|th=4212869160|vh=-|bi=e
Paper.L01.L01_S2|thm|th=1657993538|vh=-|bi=eee
Paper.L01.L01_main|thm|th=534035779|vh=-|bi=eee
```

## Overall verdict

The statement is faithful to main.tex:38-40 with the convention of main.tex:24; obligations are true as stated and assemble to the main theorem; no external parameters.

STATEMENT GATE: PASS
