# List of files for human check

## Start here

| Order | File | Purpose |
|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | Main report: findings and verdicts |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | Index: source location ↔ Lean file:line ↔ audit report |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | Worksheet for the one external input |

Lean proof bodies need not be read line by line: they compile, have no `sorry` (except `pv_work/L02.lean`, which keeps the stopped step S2 as `sorry` at l.13; for L02 the gap file `L02ModGaps.lean` is audited), use only the standard axioms, and were recompiled by an independent auditor. A human should check (1) statement fidelity, (2) base definitions, (3) the external input.

## 1. Mandatory checks

- `EXTERNAL_TOOLS_WORKSHEET.md` (`T01_L02Consumed`)
- `AUTHOR_REPORT.md` §4–§6
- open entry B1 in `verification/BLOCKERS.md`

## 2. Paper statement ↔ Lean statement

For each, read the theorem signature and every `def` it mentions (`Conclusion`, `*_L02Consumed`).

| PDF | Paper location | Lean main theorem (file:line) | Conclusion / helper definitions | Audit reports |
|---|---|---|---|---|
| Lemma 2.1 | main.tex:38-46 | `Paper.L01.L01`, `pv_work/L01.lean:35` | `risk`, `oracleRisk`, `oracleFactor`, `Setting` in `pv_work/Defs.lean` | `verification/audits/L01_gate.md`, `L01_final.md`, `L01_mech.md` |
| Lemma 2.2 | main.tex:48-56 | `Paper.L02.L02_mod_gaps`, `pv_work/L02ModGaps.lean:25` (modulo gap `L02_S3_Gap`; ISSUE; `pv_work/L02.lean` has `sorry` at l.13 and is not the audited object) | `Conclusion`, `HarmonicLeMin` in `pv_work/L02Stmt.lean:6,17`; gaps `pv_work/L02ModGaps.lean`; counterexamples `pv_work/L02_Counterexample1.lean` | `verification/audits/L02_gate.md`, `L02_issue_1.md`, `L02_issue_1_audit.md`, `L02_final.md`, `L02_mech.md` |
| Theorem 2.3 | main.tex:58-67 | `Paper.T01.T01`, `pv_work/T01.lean:48` | `Conclusion`, `T01_L02Consumed` in `pv_work/T01Stmt.lean:11,20` | `verification/audits/T01_gate.md`, `T01_final.md`, `T01_mech.md` |
| Corollary 2.4 | main.tex:69-76 | `Paper.C01.C01`, `pv_work/C01.lean:39` | `Conclusion`, `C01_L02Consumed` in `pv_work/C01Stmt.lean:9,15` (remark `C01_S4`, `C01.lean:35`) | `verification/audits/C01_gate.md`, `C01_final.md`, `C01_mech.md` |

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` | `Setting` (main.tex:25), `risk` (main.tex:29), `oracleFactor` (30-31), `oracleRisk` (32-33) | `verification/audits/DEFS_gate.md` |

## 4. Suggested checking order

1. The Level A input in the worksheet.
2. Base definitions (§3).
3. B1: confirm the counterexamples refute the printed sentence at main.tex:54-55.
4. Main theorem statements.

## 5. Rerun the compilation

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
