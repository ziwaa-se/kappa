# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: for each conclusion, the source location, the Lean file and line number, and the audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked by the Lean kernel: they compile, have no `sorry`, use only the three standard axioms, and the independent final audit confirmed them by recompiling.
- **The three things a human needs to check:**
  1. **Whether the statements are faithful**: whether the hypotheses and conclusion of each Lean theorem are exactly what the paper says.
  2. **Whether the base definitions are faithful**: see §3.
  3. **Whether the external inputs are true**: see the worksheet. No one has verified these; this is a **mandatory check**.

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md`
- `AUTHOR_REPORT.md` §4–§6
- open entries in `verification/BLOCKERS.md` (B01, B02, with the Corrections section at the end)
- external literature you need to obtain yourself: Roberts and Tweedie 1996 (`roberts1996geometric`, Prop 3.3/3.5); Jarner and Tweedie 2003 (`jarner2003necessary`, Prop 3.6); Roberts and Tweedie 1996 MALA (`roberts1996exponential`, for the C01 question).

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature** (from `theorem … :` to `:= by`), **as well as the content of every `def` mentioned in the signature**. External parameters and conclusions are often written as `def … : Prop := …`; the signature shows only the name, and the real mathematical content is in the body of the `def`.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter.
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 2.2 | TEX:208-219 | `pv_work/T01.lean:53`, `Paper.T01.T01_main` | `Paper.T01.HypPartI`, `HypPartII` at `pv_work/T01Stmt.lean:33,37`; parameters `Thm518` (`T01Stmt.lean:25`), `T02_L02Consumed`, `Prop35`, `GaussFacts` (`T02Stmt.lean:101,78,88`) | `verification/audits/T01_gate.md`, `T01_final_r2.md`, `T01_mech.md` (same folder; first final audit failed, F1; superseded) |
| 2.3 (ii) | TEX:229-239, proof TEX:806 | audited theorem: `pv_work/C01ModGaps.lean:227`, `C01_main_mod_gaps` (premise `C01_S2_Gap`); `pv_work/C01.lean:253` `Paper.C01.C01_main` has `sorry` at S2 (draft form, no `.olean`; `C01_final.md`); counterexample `pv_work/C01_Counterexample1.lean` | defs in `pv_work/C01Stmt.lean` | `verification/audits/C01_gate.md`, `C01_issue_1.md`, `C01_issue_1_audit.md`, `C01_final.md`, `C01_mech.md` |
| 5.14 | TEX:865-880 | `pv_work/T02.lean:324`, `Paper.T02.T02_main` | HMC kernel, `GeomErgodic`, `rejProb`, `gaussMeas`, `targetMeas` in `pv_work/T02Stmt.lean:27-65`; parameters at `:78, 88, 101` | `verification/audits/T02_gate.md`, `T02_gate_r2.md`, `T02_final.md`, `T02_mech.md` |
| 5.15 | TEX:884-897 | `pv_work/L01.lean:76`, `Paper.L01.L01_main_fixedDelta` | `Paper.L01.ConclFixedDelta` at `pv_work/L01Stmt.lean:24` (the verdict-bearing statement; docstrings l.15, 22 are swapped, see `DOC_ERRATA.md`) | `verification/audits/L01_gate.md`, `L01_final.md`, `L01_mech.md` |
| 5.16 | TEX:899-934 | gap file `pv_work/L02ModGaps.lean:607`, `Paper.L02.L02_main_fixedDelta_osc` (proved with (18) as premise); stopped gap `L02_main_fixedDelta_Gap` (`L02ModGaps.lean:616`), `L02_main_fixedDelta_mod_gaps` (`:626`) | `Paper.L02.ConclFixedDelta` at `pv_work/L02Stmt.lean:25`; condition `L02_L01Consumed` (`:34`) | `verification/audits/L02_gate.md`, `L02_gate_r2.md`, `L02_issue_1.md`, `L02_issue_1_audit.md`, `L02_final.md`, `L02_mech.md` |
| 5.17 | TEX:936-971 | `pv_work/L03.lean:330`, `Paper.L03.L03_main` | condition `L03_L02Consumed` (`pv_work/L03Stmt.lean:25`) | `verification/audits/L03_gate.md`, `L03_final.md`, `L03_mech.md` |

The theorem names and lines were read from `grep` on the files; the TEX ranges are those quoted in the audits, and the PDF numbers were not independently verified (`RESULTS.json` `numbering_basis`).

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` | `E d`, `piDens`, `H`, `IsGradField`, `leapfrogStep`, `leapfrogState`, `xLF`, `pLF`, `accProb`, `tailMomFilter`, `HypExplode` (17), `HypOscillations` (18), `HypOscillation2` (19) | leapfrog scheme and Hamiltonian (TEX:274-279, 359-374); hypotheses at TEX:865-871; gated by `verification/audits/DEFS_gate.md` |
| `pv_work/T02Stmt.lean:27-65` | `gaussMeas`, `targetMeas`, `rejProb`, `hmcStep`, `GeomErgodic` | HMC kernel and geometric ergodicity (TEX:163-167, 274-278) |

## 4. Suggested checking order

1. Level A external inputs in the worksheet (#2, #3).
2. The base definitions in §3.
3. Counterexample results: confirm that `osc_fails` refutes hypothesis (18) on E(β,α) for 2<β<log₂6, which is what TEX:806 needs, and not a stronger proposition. Note it is not a counterexample to Cor 2.3(ii) itself.
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

Modules to try: `Defs`, `L01`, `L02ModGaps`, `L03`, `T02`, `T01`, `C01`, `C01ModGaps`, `C01_Counterexample1` (dependency order; after rebuilding a module, rebuild every module that imports it).
