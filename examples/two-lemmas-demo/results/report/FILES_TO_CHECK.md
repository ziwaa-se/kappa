# List of files for human check — "Two quick inequalities"

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: for each conclusion, the source location, the Lean file and line number, and the audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external inputs | Nothing to tick in this paper — see §1 below |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked by the Lean kernel: they compile, have no `sorry`, use only the three standard axioms, and the independent final audit confirmed them by recompiling. This applies to `pv_work/L01.lean` in full, and to `pv_work/L02_Counterexample1.lean` in full (the counterexample, not a "proof" of Lemma 2 — Lemma 2 itself is not proved, because it is false).
- **The three things a human needs to check:**
  1. **Whether the statements are faithful**: whether the hypotheses and conclusion of each Lean theorem are exactly what the paper says. See §2 below.
  2. **Whether the base definitions are faithful**: see §3 — not applicable here, this paper declares no shared definitions (`defs: [{"id": "NONE"}]`).
  3. **Whether the external inputs are true**: see the worksheet. **Not applicable here** — this paper has zero external inputs (see `EXTERNAL_TOOLS_WORKSHEET.md`).

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md` — empty; nothing mandatory here for this paper.
- `AUTHOR_REPORT.md` §4–§6 — one substantive issue (B1, Lemma 2), already fully adjudicated with Lean evidence; the only open item is the authors' own choice of amendment (§6, "Author intent"), not a verification check.
- open entries in `verification/BLOCKERS.md` — one open entry, B1 (Lemma 2 / `ERROR`), marked "Needs human check: no."
- external literature you need to obtain yourself: none — `source/demo.tex` cites no external literature.

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature** (from `theorem … :` to `:= by`), **as well as the content of every `def` mentioned in the signature**. External parameters and conclusions are often written as `def … : Prop := …`; the signature shows only the name, and the real mathematical content is in the body of the `def`.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter. (None occur in this paper.)
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| Lemma 1 | `source/demo.tex:12-18` | `pv_work/L01.lean:52`, `Paper.L01.L01_main (a b : ℝ) : a ^ 2 + b ^ 2 ≥ 2 * a * b` | No conclusion structure (single-clause statement). Step lemmas: `L01_S1` (line 30, the ring identity) and `L01_S2` (line 42, `(a-b)^2 ≥ 0`, citing mathlib's `sq_nonneg` directly). No `def`s in `pv_work/L01Stmt.lean` (0 declarations). | `verification/audits/L01_gate.md` (PASS); `verification/audits/L01_final.md` (PASS, suggested UNCONDITIONAL). |
| Lemma 2 | `source/demo.tex:20-27` | *Not proved* — `pv_work/L02Draft.lean:57`, `Paper.L02.L02 (x : ℝ) : x ^ 2 ≥ x`, remains `sorry` (correctly: the statement is false). The **counterexample** is `pv_work/L02_Counterexample1.lean:77`, `Paper.L02.Counterexample1.not_printedLemma2 : ¬ PrintedLemma2`, where `PrintedLemma2` (line 44) is proved identical to the gated main theorem's type by `rfl` (line 129, `printedLemma2_eq_gated_statement`). Supporting: `witness_in_range` (line 69), `printed_fails_at_half` (line 74), `failure_region` (line 142, gives the exact scope `0<x<1`). No `def`s in `pv_work/L02Stmt.lean` (0 declarations) — the printed definitions used (`PrintedLemma2` etc.) live in the counterexample file itself. | `verification/audits/L02_gate.md` (PASS); `verification/audits/L02_issue_1.md` (ISSUE VERDICT: ERROR); `verification/audits/L02_issue_1_audit.md` (COUNTEREXAMPLE VALID). |

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| *(none)* | This paper declares no shared definitions (`verification/INVENTORY.md` §4, `RESULTS.json` `defs: [{"id": "NONE"}]`). Both lemmas use only ordinary universally-quantified real numbers with no domain restriction. | Not applicable. |

## 4. Suggested checking order

1. Level A external inputs in the worksheet — none exist; skip.
2. The base definitions in §3 — none exist; skip.
3. **Counterexample result**: confirm that `pv_work/L02_Counterexample1.lean`'s `not_printedLemma2` refutes the paper's original sentence (`source/demo.tex:21-22`, "for every real number `x`, `x^2 \ge x`"), not a stronger proposition — check line 129 (`printedLemma2_eq_gated_statement`, by `rfl`) shows `PrintedLemma2` is *exactly* the gated main theorem's type, and check `witness_in_range`/`printed_fails_at_half` (lines 69, 74) show the witness x = 0.5 is a genuine real number satisfying the printed hypothesis.
4. The statement of Lemma 1's main theorem (`pv_work/L01.lean:52`) against `source/demo.tex:12-14` — a one-line comparison: both say "for all real `a,b`, `a^2+b^2 \ge 2ab`," with no added or dropped hypothesis.

## 5. (Optional) Rerun the compilation yourself

```bash
scripts/pv_lean.sh build PVTools
scripts/pv_lean.sh build L01
scripts/pv_lean.sh build L02_Counterexample1
```

Probe (checks axioms and sorry):

```lean
import L01
import PVTools
#pv_axioms L01
#pv_walk L01
```

```lean
import L02_Counterexample1
import PVTools
#pv_axioms L02_Counterexample1
#pv_walk L02_Counterexample1
```
