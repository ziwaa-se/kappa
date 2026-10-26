# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: source location, Lean file and line, audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies** of results with a final audit PASS (P01, P03, P04, T04, P06, and the gap files): they compile, have no `sorry`, use only the three standard axioms, and were recompiled by the independent final audit.
- **The three things a human needs to check:** (1) whether the statements are faithful; (2) whether the base definitions are faithful (§3); (3) whether the external inputs are true (worksheet; mandatory, not yet done).
- **Caution:** for T01, T02, L02, P05 the `lean_main` theorem is a gap-file theorem that is *vacuous* (its gap hypotheses are refutable); T03's main theorem is a draft with `sorry` (no `.olean`); P02's gap file has gap hypotheses `P02_S1_Gap`, `P02_TwoCase_Gap`; L01 has a statement and a counterexample only. The evidence for those results is the counterexample file plus the per-step verified obligations.

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md`
- `AUTHOR_REPORT.md` §4–§6
- open entries B01–B10 in `verification/BLOCKERS.md`
- literature you must obtain yourself: ineq-order2024 (Lemma 4.1), superPareto2024 (Prop 1)

## 2. Item-by-item review: "paper statement ↔ Lean statement"

Read the theorem signature and the content of every `def` it mentions (parameters are `def … : Prop`).

| PDF | Paper location | Lean main theorem (file:line, name) | Definitions used (statement file) | Audit reports |
|---|---|---|---|---|
| 2.3 L01 | :128-138 | `pv_work/L01Draft.lean:32` `Paper.L01.L01_main` (gated statement, draft with `sorry`, no `.olean`); evidence `pv_work/L01_Counterexample1.lean:54` `L01_if_counterexample`, `:73` `L01_main_as_printed_false` | `L01Stmt.lean` | `L01_gate.md`, `L01_issue_1.md`, `L01_issue_1_audit.md` |
| 2.5 P01 | :148-154 | `pv_work/P01.lean:298` `Paper.P01.P01_main` | `P01Stmt.lean` | `P01_gate.md`, `P01_gate_r2.md`, `P01_final.md`, `P01_mech.md` |
| 2.8 T01 | :169-181 | `pv_work/T01ModGaps.lean:192` `Paper.T01.T01_main_mod_gaps` (vacuous); `pv_work/T01.lean:208` `Paper.T01.T01_main` (draft with `sorry`, no `.olean`); counterexample `pv_work/T01_Counterexample1.lean` | `T01Stmt.lean` | `T01_gate.md`, `T01_gate_r2.md`, `T01_final.md`, `T01_issue_1.md`, `T01_issue_1_audit.md`, `T01_issue_2.md` |
| 3.1 T02 | :186-257 | `pv_work/T02ModGaps.lean:654` `Paper.T02.T02_main_mod_gaps` (uninformative); `pv_work/T02.lean:135` `Paper.T02.T02_main` (draft with `sorry`, no `.olean`); counterexample `pv_work/T02_Counterexample1.lean` | `T02Stmt.lean` | `T02_gate.md`, `T02_gate_r2.md`, `T02_final.md`, `T02_issue_1.md`, `T02_issue_1_audit.md` |
| 3.2 P02 | :261-267 | `pv_work/P02ModGaps.lean:26` `Paper.P02.P02_main_mod_gaps`; `pv_work/P02.lean:12` `Paper.P02.P02_main` (draft with `sorry`, no `.olean`) | `P02Stmt.lean` | `P02_gate.md`, `P02_gate_r2.md`, `P02_final.md`, `P02_issue_1.md`, `P02_issue_1_audit.md`, `P02_issue_1_r2.md`, `P02_issue_1_r2_audit.md`, `P02_issue_2.md`, `P02_issue_2_audit.md` |
| 3.3 P03 | :269-273 | `pv_work/P03.lean:228` `Paper.P03.P03_main` | `P03Stmt.lean` (parameters at :17, :32) | `P03_gate.md`, `P03_final.md`, `P03_issue_1.md` |
| 4.6 P04 | :315-321 | `pv_work/P04.lean:509` `Paper.P04.P04_main`; counterexample `pv_work/P04_Counterexample2.lean` | `P04Stmt.lean` (parameter at :64) | `P04_gate.md`, `P04_gate_r2.md`, `P04_final.md`, `P04_issue_1.md`, `P04_issue_2.md`, `P04_issue_2_audit.md` |
| 4.8 T03 | :332-338 | `pv_work/T03Draft.lean:61` `Paper.T03.T03_main` (draft, `sorry`); counterexamples `pv_work/T03_Counterexample1.lean`, `T03_Counterexample2.lean` | `T03Stmt.lean` | `T03_gate.md`, `T03_issue_1.md`, `T03_issue_1_audit.md`, `T03_issue_2.md`, `T03_issue_2_audit.md` |
| 4.10 L02 | :358-366 | `pv_work/L02ModGaps.lean:104` `Paper.L02.L02_main_mod_gaps` (vacuous); `pv_work/L02.lean:101` `Paper.L02.L02_main` (draft with `sorry`, no `.olean`; statement as printed is refuted); counterexample `pv_work/L02_Counterexample1.lean` | `L02Stmt.lean` | `L02_gate.md`, `L02_gate_r2.md`, `L02_final.md`, `L02_issue_1.md`, `L02_issue_1_audit.md` |
| 4.12 T04 | :376-386 | `pv_work/T04.lean:70` `Paper.T04.T04_main` | `T04Stmt.lean` (definitions of L01/L02 reused) | `T04_gate.md`, `T04_gate_r2.md`, `T04_final.md`, `T04_mech.md` |
| 5.2 P05 | :429-436 | `pv_work/P05ModGaps.lean:311` `Paper.P05.P05_main_mod_gaps` (vacuous); `pv_work/P05.lean:312` `Paper.P05.P05_main` (draft with `sorry`, no `.olean`; statement as printed is refuted); counterexample `pv_work/P05_Counterexample1.lean` | `P05Stmt.lean` | `P05_gate.md`, `P05_final.md`, `P05_issue_1.md`, `P05_issue_1_audit.md` |
| 5.3 P06 | :440-446 | `pv_work/P06.lean:216` `Paper.P06.P06_main` | `P06Stmt.lean` | `P06_gate.md`, `P06_final.md`, `P06_mech.md` |

(Audit reports are in `verification/audits/`. Source ranges are the statement and proof ranges recorded in `RESULTS.json`.)

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/L01Stmt.lean` | `F`, `invDist` (:14), `SubadditiveOn`, `IsInvSub`, `SubCond` (no `Fbar`) | Def 2.2 (:124), eq:sub-1x |
| `pv_work/L02Stmt.lean` | `negLogInv`, `SubadditiveOnE`, `IsSuperHeavyTailed`, `InvNWUCond` | Def 4.9 (:346) |
| `pv_work/T01Stmt.lean` | `StarShaped`, `AntiStarShaped`, `ginv` | :174 |
| `pv_work/T02Stmt.lean` | `Fbar` (:15), `IIDCopies`, `StDom` | Def 2.1 (:115-118), (eq:main-st) |
| `pv_work/P06Stmt.lean` | its own `IsInvSub` (:35), `paretoCdf`, `genInv`/`recipE`/`isbOrder`, separate from L01Stmt and P04Stmt; the P06 UNCONDITIONAL verdict rests on it | compare `IsInvSub` with Def 2.2 (:124) and `L01Stmt.IsInvSub`; `paretoCdf` with :279; Def 5.1 (:424) |
| `pv_work/P04Stmt.lean` | `SuperPareto`, `suppIn`, DOR, convex transform order | Defs 4.1, 4.4, 4.5 |
| `pv_work/P05Stmt.lean`, `P06Stmt.lean` | i-sb order | Def 5.1 (:424) |

## 4. Suggested checking order

1. Level A external inputs in the worksheet.
2. The base definitions in §3.
3. Counterexample results: confirm each refutes the paper's original sentence, not a stronger proposition.
4. The statements of the main theorems.

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
