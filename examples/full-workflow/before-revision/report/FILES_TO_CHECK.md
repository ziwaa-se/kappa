# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: for each conclusion, the source location, the Lean file and line number, and the audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external input | Tick the item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** Lemma 2.1 and Proposition 2.2 are fully proved: they compile, have no `sorry`, use only the three standard axioms, and the independent final audit confirmed each by recompiling. Lemma 2.3's draft (`pv_work/L02Draft.lean`) still has three `sorry`s (`L02_S1` line 51, `L02_S2` line 64, `L02_S3` line 74) — only `L02_S1` is the confirmed-false, faithfully-stated step (the paper issue itself, not a gap to fill); `L02_S2`/`L02_S3` (the "obvious" algebra) were never reached because the proof stopped at `L02_S1`, though both are independently confirmed true inside `pv_work/L02_Counterexample1.lean`.
- **The three things a human needs to check:**
  1. **Whether the statements are faithful**: whether the hypotheses and conclusion of each Lean theorem are exactly what the paper says.
  2. **Whether the base definitions are faithful**: see §3.
  3. **Whether the external input is true**: see the worksheet. No one has verified it; this is a **mandatory check**.

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md` — 1 item (Nesbitt's inequality, Priority B)
- `AUTHOR_REPORT.md` §4–§6
- open entry in `verification/BLOCKERS.md`: B01 (Lemma 2.3, ERROR)
- external literature you need to obtain yourself: A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37 (for the worksheet item above)

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature** (from `theorem … :` to `:= by`), **as well as the content of every `def` mentioned in the signature**. External parameters and conclusions are often written as `def … : Prop := …`; the signature shows only the name, and the real mathematical content is in the body of the `def`.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter.
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| Lemma 2.1 | `source/main.tex:37-43` (statement), `:45-50` (proof) | `pv_work/L01.lean:71`, `Paper.L01.L01_main (a b : ℝ) : L01Conclusion a b` | `pv_work/L01Stmt.lean:25`, `structure L01Conclusion (a b : ℝ) : Prop` with fields `ineq : a*b ≤ (a²+b²)/2` and `equality_iff : a*b = (a²+b²)/2 ↔ a = b` | gate `verification/audits/L01_gate.md`; final `verification/audits/L01_final.md` |
| Proposition 2.2 | `source/main.tex:52-57` (statement), `:59-69` (proof) | `pv_work/P01.lean:142`, `Paper.P01.P01_main (hN : NesbittInequality) (x y z : ℝ) (hx : 0<x) (hy : 0<y) (hz : 0<z) : P01Conclusion x y z` | `pv_work/P01Stmt.lean:39` `def NesbittInequality : Prop` (the one external parameter, §3 of the report); `pv_work/P01Stmt.lean:49` `def P01Conclusion (x y z : ℝ) : Prop := S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²))` (S inlined); predecessor `Paper.L01.L01_main` imported directly (not redeclared) | gate `verification/audits/P01_gate.md`; final `verification/audits/P01_final.md` |
| Lemma 2.3 | `source/main.tex:71-76` (statement), `:78-81` (proof) | Gated statement (not proved — **issue recorded**): `pv_work/L02Draft.lean:87`, `Paper.L02.L02_main (x : ℝ) (hx : x ≠ -1) : x^2/(1+x) ≥ x - 1`. Refutation: `pv_work/L02_Counterexample1.lean:76`, `Paper.L02.Issue1.counterexample : ¬ PrintedClause` (witness `x=-2`) | none (single printed inequality, no shared structure) | gate `verification/audits/L02_gate.md`; issue ruling `verification/audits/L02_issue_1.md`; issue confirmation `verification/audits/L02_issue_1_audit.md` |

## 3. Base definitions

No shared `Defs*.lean` file exists in this project (`RESULTS.json` `defs` = `NONE`): every notion used (`ℝ`, ordinary `+ - * / ^ ≤ ↔`, and `S(x,y,z)` inlined as the literal sum of three fractions) is either a bare mathlib type/operation or is defined once, inline, inside the one `Stmt` file that needs it.

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/L01Stmt.lean` | `structure L01Conclusion (a b : ℝ) : Prop` — the two printed clauses of Lemma 2.1, bundled so each can be judged independently | `source/main.tex:38-42` |
| `pv_work/P01Stmt.lean` | `def NesbittInequality : Prop` (external parameter, §3) and `def P01Conclusion (x y z : ℝ) : Prop` (Proposition 2.2's single printed inequality, with `S(x,y,z)` inlined exactly as `source/main.tex:26-33` defines it) | `source/main.tex:26-33` (Notation), `:53-56` (statement) |
| `pv_work/L02Stmt.lean` | nothing beyond the namespace (Lemma 2.3's statement is a single inequality, stated directly in the draft/gate files, no separate conclusion structure needed) | `source/main.tex:72-75` |

## 4. Suggested checking order

1. The Level B external input in the worksheet (Nesbitt's inequality attribution) — the only mandatory check in this project.
2. The base definitions in §3 (quick: there are only two non-trivial ones, `L01Conclusion` and `P01Conclusion`/`NesbittInequality`).
3. The counterexample result for Lemma 2.3: confirm `pv_work/L02_Counterexample1.lean`'s refuted proposition (`PrintedClause`) matches the paper's printed sentence exactly, not a stronger one — the audit records already did this (`L02_issue_1_audit.md`, an `rfl` identity check against the gate snapshot), so this is a spot-check, not new work.
4. The statements of the two proved main theorems (Lemma 2.1, Proposition 2.2) against §2's table.

## 5. (Optional) Rerun the compilation yourself

```bash
scripts/pv_lean.sh build PVTools
scripts/pv_lean.sh build L01Stmt && scripts/pv_lean.sh build L01
scripts/pv_lean.sh build P01Stmt && scripts/pv_lean.sh build P01
scripts/pv_lean.sh build L02Stmt && scripts/pv_lean.sh check L02Draft
scripts/pv_lean.sh build L02_Counterexample1
```

Probe (checks axioms and sorry) — substitute each module name:

```lean
import L01
import PVTools
#pv_axioms Paper.L01.L01_main
#pv_walk Paper.L01.L01_main
```

Note on this project's environment: the mathlib package directory is **linked**, not copied, and only partially built (2452 of 6305 modules). The umbrella imports `import Mathlib` and `import Mathlib.Tactic` do not resolve here; every delivered file instead imports specific, already-built modules (e.g. `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Linarith`). This did not block any proof in this project, but if you rerun the build in a differently-provisioned environment, these specific imports should still resolve (they are a subset of what any full mathlib install provides).
