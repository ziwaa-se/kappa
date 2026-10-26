# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: findings, verdict per result, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: source location, Lean file and line, audit report per conclusion | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked: they compile, have no `sorry`, use only the three standard axioms, and the independent final audits recompiled them.
- **The three things a human needs to check:**
  1. whether the statements are faithful (hypotheses and conclusion of each Lean theorem);
  2. whether the base definitions are faithful (§3);
  3. whether the external inputs are true (the worksheet; mandatory, nobody has verified them).

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md`
- `AUTHOR_REPORT.md` §4–§6
- open entries in `verification/BLOCKERS.md` (B01, B02)
- external literature to obtain yourself: Popoviciu, *Sur les équations algébriques ayant toutes leurs racines réelles*, Mathematica (Cluj) 9:129–145, 1935.

## 2. Item-by-item review: "paper statement ↔ Lean statement"

Procedure: read the source location; open the Lean file at the main theorem line, read the signature and every `def` it mentions (parameters such as `Popoviciu` are `def … : Prop` whose bodies hold the content); compare hypotheses and conclusion; a hypothesis `(h… : ToolName)` is an external parameter; when in doubt read the gate and final audit.

| PDF | Paper location | Lean main theorem (file:line, name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 2.1 | main.tex:42-48 | `pv_work/L01.lean:21`, `Paper.L01.L01_main`; `Conclusion` in `pv_work/L01Stmt.lean:6` | none | `verification/audits/L01_gate.md`, `L01_final.md`, `L01_mech.md` |
| 2.2 | main.tex:50-56 | `pv_work/L02.lean:23`, `Paper.L02.L02_main`; `Conclusion` in `pv_work/L02Stmt.lean:7` | none | `verification/audits/L02_gate.md`, `L02_final.md`, `L02_mech.md` |
| 2.3 | main.tex:58-69 | `pv_work/P01.lean:29`, `Paper.P01.P01`; `Popoviciu` in `pv_work/P01Stmt.lean:11` | takes `(h : Popoviciu)` | `verification/audits/P01_gate.md`, `P01_gate_r2.md`, `P01_final.md`, `P01_mech.md` |
| 2.4 | main.tex:71-83 | `pv_work/P02.lean:105`, `Paper.P02.P02_main`; `Conclusion` in `pv_work/P02Stmt.lean:12` | none; s=0 case proved in the file | `verification/audits/P02_gate.md`, `P02_issue_1.md`, `P02_final.md`, `P02_mech.md` |
| 2.5 | main.tex:85-92 | `pv_work/L03ModGaps.lean:30`, `Paper.L03.L03_main_mod_gaps` (takes `L03_S3_Gap`, refuted); counterexample `pv_work/L03_Counterexample1.lean:52` `counterexample`; `Conclusion` in `pv_work/L03Stmt.lean:7` | ISSUE | `verification/audits/L03_gate.md`, `L03_issue_1.md`, `L03_issue_1_audit.md`, `L03_final.md`, `L03_mech.md` |
| 2.6 | main.tex:94-100 | `pv_work/C01.lean:26`, `Paper.C01.C01_main` (takes `C01_L03Consumed`, refuted); intermediate counterexample `pv_work/probes/issue/C01/issue_C01_intermediate.lean`; `Conclusion`, `C01_L03Consumed` in `pv_work/C01Stmt.lean:6,14` | ISSUE | `verification/audits/C01_gate.md`, `C01_final.md`, `C01_issue_1.md`, `C01_issue_1_audit.md`, `C01_mech.md` |

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` | `Sample n` (= `Fin n → ℝ`), `sampleMean`, `sampleVar` (1/(n−1)), `sampleStd` | main.tex:26-38 (Section 1, Definitions 1.1 and 1.2); gate: `verification/audits/DEFS_gate.md` |

## 4. Suggested checking order

1. Level A/B external inputs in the worksheet.
2. The base definitions in §3.
3. Counterexample results (2.5, 2.6): confirm they refute the paper's printed sentences (main.tex:86, :99), not stronger propositions.
4. The statements of the main theorems.

## 5. Rerun the compilation yourself

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
