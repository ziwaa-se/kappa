# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: source location, Lean file and line, audit report for each conclusion | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet** for external inputs | Empty: there are none |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked: they compile, have no `sorry`, use only the three standard axioms, and the independent final audits recompiled them.
- **What a human needs to check:** (1) that each Lean statement is faithful to the paper; (2) that the base definitions in §3 are faithful. There are no external inputs to check.

## 1. Mandatory checks

- None for external inputs (`EXTERNAL_TOOLS_WORKSHEET.md` is empty).
- `AUTHOR_REPORT.md` §5-§6 (one editorial slip).
- Open entries in `verification/BLOCKERS.md`: none (B1 resolved).

## 2. Item-by-item review: "paper statement ↔ Lean statement"

For each result read the theorem signature and the `def`/`structure` it mentions in the `<ID>Stmt.lean` file, and compare with the source.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 2.1 | main.tex:39-41 (proof 43-52) | `pv_work/L01.lean:64`, `Paper.L01.L01` | no new statement defs (`pv_work/L01Stmt.lean`); uses `Defs.lean` | `verification/audits/L01_gate.md`, `verification/audits/L01_final.md`, `verification/audits/L01_mech.md` |
| 2.2 | main.tex:54-56 (proof 58-61) | `pv_work/L02.lean:31`, `Paper.L02.L02_main` | `Paper.L02.Conclusion` in `pv_work/L02Stmt.lean:7` | `verification/audits/L02_gate.md`, `verification/audits/L02_final.md`, `verification/audits/L02_mech.md` |
| 2.3 | main.tex:63-66 (proof 68-72) | `pv_work/T01.lean:47`, `Paper.T01.T01_main` | `Paper.T01.Conclusion` (structure with `ge`, `eq_iff`, `le_min`) in `pv_work/T01Stmt.lean:10` | `verification/audits/T01_gate.md`, `verification/audits/T01_final.md`, `verification/audits/T01_mech.md` |
| 2.4 | main.tex:74-76 (proof 78-81) | `pv_work/C01.lean:38`, `Paper.C01.C01` | `Paper.C01.Conclusion` in `pv_work/C01Stmt.lean:9` | `verification/audits/C01_gate.md`, `verification/audits/C01_final.md`, `verification/audits/C01_mech.md` |

Audits of the earlier revision are in `verification/audits/rev2/` (the directory name is the archive of the pre-revision-2 state; the rewritten-proof audits are the files listed above).

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean:7` | `Setting θ σ` (θ ≠ 0, 0 < σ) | main.tex:25 |
| `pv_work/Defs.lean:12` | `risk` | main.tex:28-29 |
| `pv_work/Defs.lean:15` | `oracleFactor` | main.tex:30-31 |
| `pv_work/Defs.lean:18` | `oracleRisk` | main.tex:32-33 |

Gate report: `verification/audits/DEFS_gate.md`.

## 4. Suggested checking order

1. The base definitions in §3.
2. The statements of the four main theorems (§2).
3. The editorial slip at main.tex:80.

## 5. (Optional) Rerun the compilation yourself

```bash
scripts/pv_lean.sh build PVTools
scripts/pv_lean.sh check C01
```

Probe (checks axioms and sorry):

```lean
import C01
import PVTools
#pv_axioms Paper.C01.C01
#pv_walk Paper.C01.C01
```
