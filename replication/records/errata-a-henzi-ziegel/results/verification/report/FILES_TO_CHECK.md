# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: for each conclusion, the source location, the Lean file and line number, and the audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked by the Lean kernel; the independent final audits recompiled them and checked axioms and `sorry` with `#pv_axioms` / `#pv_walk`. For T01 and T02 the gap files contain explicit gap hypotheses instead of the failing steps.
- **The three things a human needs to check:**
  1. **Whether the statements are faithful**: whether the hypotheses and conclusion of each Lean theorem are exactly what the paper says.
  2. **Whether the base definitions are faithful**: see §3.
  3. **Whether the external inputs are true**: see the worksheet. No one has verified these; this is a **mandatory check**.

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md`
- `AUTHOR_REPORT.md` §4–§6
- open entries in `verification/BLOCKERS.md` (B1, B2; B3 is resolved)
- external literature you need to obtain yourself: Grünwald, de Heide, Koolen (2020), "Safe testing" (ITA); Gneiting, Balabdaoui, Raftery (2007) and/or Gneiting and Raftery (2007), Theorem 2.3; Ramdas et al. (2020), §3.

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature**, **as well as the content of every `def` mentioned in the signature**. External parameters and conclusions are often `def … : Prop := …`; the signature shows only the name.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter.
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 3.1 (T01) | statement l.143–148, proof l.399–416 | `pv_work/T01ModGaps.lean:308` `Paper.T01.T01_mod_gaps` | statement and defs in `pv_work/T01Stmt.lean`; gap hypotheses `T01_S8_Gap`, `T01_S10_Gap`; counterexample `pv_work/T01_Counterexample1.lean` | `verification/audits/T01_gate.md`, `T01_final.md`, `T01_issue_1.md`, `T01_issue_1_audit.md`, `T01_mech.md` |
| 3.2 (T02) | statement l.152–167, proof l.418–440 | `pv_work/T02ModGaps.lean:385` `Paper.T02.T02_mod_gaps` | statement and defs in `pv_work/T02Stmt.lean` (incl. unused `T02_T01Consumed`, l.40); gaps `T02_S3a_Gap`, `T02_S3b_Gap`, `T02_S8_Gap`, `T02_S11_Gap`, `T02_S15_Gap`; counterexample `pv_work/T02_Counterexample1.lean` | `verification/audits/T02_gate.md`, `T02_final.md`, `T02_issue_1.md`, `T02_issue_1_audit.md`, `T02_mech.md` |
| 3.3 (T03) | statement l.185–193, proof l.442–444 | `pv_work/T03.lean:145` `Paper.T03.T03_main` | statement and defs in `pv_work/T03Stmt.lean`; parameter `GruenwaldThm1` (l.42) | `verification/audits/T03_gate.md`, `T03_final.md`, `T03_mech.md` |
| 3.4 (P04) | statement l.216–221, proof l.446–469 | `pv_work/P04.lean:912` `Paper.P04.P04_main` | statement and defs in `pv_work/P04Stmt.lean`; parameters `P04_T01Consumed` (l.78), `P04_MixingOfStrict` (l.107) | `verification/audits/P04_gate_r2.md`, `P04_final.md`, `P04_mech.md` (earlier round: `P04_gate.md`) |
| 3.5 (P05) | statement l.229–234, proof inside that of 3.4 (l.446–469) | `pv_work/P05Closed_r1.lean:32` `Paper.P05.main_closed` (h = 1 branch in `pv_work/P05.lean`) | statement and defs in `pv_work/P05Stmt.lean` (parameter `P05_P04Consumed`, l.43, discharged by the reconnection); obsolete `pv_work/P05ModGaps.lean` is not used | `verification/audits/P05_gate_r2.md` (earlier rounds: `P05_gate.md`, `P05_final.md`), `P05_final_r2.md`, `P05_reconnect_r1.md`, `P05_issue_1.md`, `P05_mech_r2.md`, `P05_mech_r3.md` |

Audits of T01–T03 quote the previous manuscript's line numbers (mapping in `verification/AUDIT.md`, "Revision mapping"). Earlier-round reports for the previous manuscript are under `verification/audits/rev1/`.

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` | `IsConsistent`, `IsStrictlyConsistent`, `IsMixingMeasure`, `HS`, `HAll`, `IsEValue`, `GrowFinite`, `IsGrowLambda` | consistency (l.69–73), strict consistency (l.73, l.103), H_S (l.131–133; interval form l.135–139), e-value (l.77, l.141); note `IsConsistent` is over real-valued S on [0,1], excluding the logarithmic score (`DEFS_gate.md` N2). Gate: `verification/audits/DEFS_gate_r2.md` |
| `pv_work/Defs.lean` (also) | `Erep`, `expPi`, `EGrowAll` and related score/mixture definitions (`mixtureScore`, `elemScore`, `kappa`, `growthRate`, `EGrow`) | E_{p,q;λ} (Equation (6)), likelihood ratio, l.96–102 |
| `pv_work/T01Stmt.lean` | `MixtureRep` | mixture representation (l.90–102) |

## 4. Suggested checking order

1. Level A external input in the worksheet.
2. The base definitions in §3.
3. Counterexample results (T01, T02): confirm the counterexample refutes the paper's printed sentence (l.412, l.424), not a stronger proposition.
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
