# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: findings, conclusion per result, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: source location, Lean file and line, audit report per conclusion | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet** for external inputs | Empty here: there are none |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They compile, have no `sorry`, use only the three standard axioms, and the final audits confirmed this by recompiling.
- **What a human needs to check:**
  1. **Whether the statements are faithful** (hypotheses and conclusion of each Lean theorem match the paper), including the reading of `I`.
  2. **Whether the base definitions are faithful** (§3).
  3. **The author-intent items** in `AUTHOR_REPORT.md` §6.

## 1. Mandatory checks

- No external inputs, so no literature to obtain.
- `AUTHOR_REPORT.md` §4–§6
- open entries B1, B2, B3 in `verification/BLOCKERS.md`

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:** read the source location; open the Lean file at the line; read the signature **and the body of every `def` it mentions** (`Paper.<ID>.…Claim`/`Conclusion` and the `Stmt` file); compare hypotheses and conclusion; when in doubt read the gate and final audit.

| PDF | Paper location | Lean main theorem (file:line, name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 2.1 | main.tex:38-45 (the lemma and its proof) | `pv_work/L01.lean:21` `Paper.L01.L01_main` | `Conclusion` in `pv_work/L01Stmt.lean`; `V` in `Defs.lean` | `verification/audits/L01_gate.md`, `L01_final.md`, `L01_mech.md` |
| 2.2 | main.tex:47-53 | `pv_work/L02.lean:17` `Paper.L02.L02_main` (open reading) | `L02Claim` in `pv_work/L02Stmt.lean`; `IOpen`; counterexample `pv_work/L02_Counterexample1.lean` | `verification/audits/L02_gate.md`, `L02_final.md`, `L02_issue_1.md`, `L02_issue_1_audit.md`, `L02_mech.md` |
| 2.3 | main.tex:55-63 | `pv_work/P01.lean:60` `Paper.P01.P01_main` | `pv_work/P01Stmt.lean` (`SqrtConcave` def, discharged by `P01_S0` at `P01.lean:9`); `IClosed` | `verification/audits/P01_gate.md`, `P01_gate_r2.md`, `P01_final.md`, `P01_mech.md` |
| 2.4 | main.tex:65-71 | `pv_work/L03ModGaps.lean:18` `Paper.L03.L03_main_mod_gaps` (modulo gap `L03_S2_Gap`, line 13) | `pv_work/L03Stmt.lean`; counterexample `pv_work/L03_Counterexample1.lean` | `verification/audits/L03_gate.md`, `L03_issue_1.md`, `L03_issue_1_audit.md`, `L03_final.md`, `L03_mech.md` |
| 2.5 | main.tex:73-79 | `pv_work/P02.lean:23` `Paper.P02.P02_main` | `Conclusion` in `pv_work/P02Stmt.lean` | `verification/audits/P02_gate.md`, `P02_final.md`, `P02_mech.md` |
| 2.6 | main.tex:81-88 | `pv_work/P03ModGaps.lean:26` `Paper.P03.P03_main_mod_gaps` (modulo gap `P03_S1_Gap`, line 8) | `pv_work/P03Stmt.lean`; `s2` in `Defs.lean`; counterexample `pv_work/P03_Counterexample1.lean` | `verification/audits/P03_gate.md`, `P03_issue_1.md`, `P03_issue_1_audit.md`, `P03_final.md`, `P03_mech.md` |

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean:13, 16` | `IOpen = Ioo 0 1`, `IClosed = Icc 0 1` | main.tex:24 "the unit interval" (not specified) |
| `pv_work/Defs.lean:21` | `V n p = p(1-p)/n` | the variance of a proportion as used in main.tex:26-29 |
| `pv_work/Defs.lean:25, 29` | `mean`, `s2` | sample mean and variance as defined in the source (see `verification/audits/DEFS_gate.md`) |

## 4. Suggested checking order

1. The base definitions in §3, in particular the two readings of `I`.
2. Counterexample results (2.2, 2.4, 2.6): confirm the counterexample refutes the paper's original sentence, not a stronger one. For 2.6 only the proof step is refuted, not the conclusion.
3. The statements of the three unconditional results (2.1, 2.3, 2.5).

## 5. (Optional) Rerun the compilation yourself

```bash
scripts/pv_lean.sh build PVTools
scripts/pv_lean.sh check <ModuleName>
```

Probe (checks axioms and sorry):

```lean
import <ModuleName>
import PVTools
#pv_axioms <ModuleName>
#pv_walk <ModuleName>
```
