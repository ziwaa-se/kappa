# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: findings, conclusion per result | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: source location, Lean file and line, audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies**: machine-checked (compile, no `sorry`, only the three standard axioms; final audits recompiled them).
- **What a human needs to check:** (1) whether the statements are faithful; (2) whether the base definitions are faithful (§3); (3) whether the external inputs are true (worksheet; mandatory, nobody has verified them).

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md`
- `AUTHOR_REPORT.md` §4–§6
- `verification/BLOCKERS.md` (B01, B02 are RESOLVED by the revision; the file is partly stale, see AUTHOR_REPORT §8)
- Literature to obtain yourself: Roberts and Tweedie 1996 (Prop 3.5), Jarner and Tweedie 2003 (Prop 3.6).

## 2. Item-by-item review: "paper statement ↔ Lean statement"

Read the theorem signature **and the body of every `def` it mentions**; a hypothesis `(h… : ToolName)` is an external parameter. Line numbers below come from `grep` of the files as they stand; where `RESULTS.json` differs, use the theorem name.

| PDF | Paper location | Lean main theorem (file, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 2.2 | TEX:208-219 | `pv_work/T01.lean:43` `Paper.T01.T01_main` (deterministic L); random-L gap version `pv_work/T01ModGaps.lean:22` `Paper.T01.T01_main_randL_mod_gaps` (gap def at :13; `RESULTS.json` `lean_main` names it wrongly as `T01_main_mod_gaps`) | `T01Concl`, `HypPartI`, `HypPartII`, `Thm518`, `T01_T02Consumed` in `pv_work/T01Stmt.lean` | `T01_gate.md`, `T01_gate_r2.md`, `T01_issue_1.md`, `T01_final.md` |
| 2.3 | TEX:234 (ii: 238), proof 806, 834 | `pv_work/C01.lean:394` `Paper.C01.C01_main` (part (ii) only) | `C01Concl`, `C01_T01Consumed` in `pv_work/C01Stmt.lean` | `C01_gate.md`, `C01_final.md` |
| 5.14 | TEX:895-941 | `pv_work/T02Closed_r1.lean:18` `Paper.T02.main_closed` (fixed L), `:31` `main_randL_closed`; earlier `pv_work/T02.lean` `Paper.T02.T02_main` | `Prop35`, `GaussFacts`, `Prop35Rand`, `A1Law`, `GeomErgodic*` in `pv_work/T02Stmt.lean` | `T02_gate.md`, `T02_gate_r2.md`, `T02_final.md`, `T02_reconnect_r1.md` |
| 5.15 | TEX:945-947 | `pv_work/L01.lean:88` `Paper.L01.L01_main` | `Concl` in `pv_work/L01Stmt.lean` | `L01_gate.md`, `L01_final.md` |
| 5.16 | TEX:960-1007 | `pv_work/L02Closed_r1.lean:13` `Paper.L02.main_closed` | `Concl` in `pv_work/L02Stmt.lean` | `L02_gate.md`, `L02_final.md`, `L02_reconnect_r1.md` |
| 5.17 | TEX:1011-1100 | `pv_work/L03Closed_r1.lean:14` `Paper.L03.main_closed` | `Concl`, `HypOscillations3` in `pv_work/L03Stmt.lean` | `L03_gate.md`, `L03_final.md`, `L03_reconnect_r1.md` |

All reports are in `verification/audits/`. Pre-revision records are under `verification/audits/rev1/` and `revenc1/` and are historical.

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` (audit: `DEFS_gate.md`) | shared hypotheses `HypExplode`, `HypOscillation2`, `HypOscillations`; `GeomErgodic`, `hmcStep`, `rejProb`, `targetMeas`, `tvDist`, `gaussMeas` are in `pv_work/T02Stmt.lean:31-72` | Sections 3-4 (TEX:274-374), (17)-(19). Note `HypOscillations` (`2‖x‖`) is stale vs revised (18); revised form is `Paper.L03.HypOscillations3` |
| `pv_work/*Stmt.lean` | Per-result statements and consumed clauses | the paper statement at the locations above |

## 4. Suggested checking order

1. Worksheet Level A, then B (`C01_T01Consumed`, `T02_Prop35`).
2. Base definitions (§3).
3. Statements of the main theorems (§2).
4. The T01 formalization-side stop (AUTHOR_REPORT §4.1) and the open author-intent questions (§6).

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
