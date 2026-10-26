# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: findings, conclusion for each item | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: source location, Lean file and line, audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the 3 external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked: they compile, have no `sorry`, use only the three standard axioms, and the independent final audits recompiled them.
- **The three things a human needs to check:**
  1. whether each Lean statement is faithful to the paper;
  2. whether the base definitions are faithful (§3);
  3. whether the external inputs are true (worksheet). No one has verified these; this is a **mandatory check**.

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md`
- `AUTHOR_REPORT.md` §4–§6
- open entries in `verification/BLOCKERS.md` (none)
- external literature to obtain yourself: a textbook Glivenko–Cantelli theorem; Donsker (1952); Kolmogorov (1933).

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:** read the source location; open the Lean file at the main theorem and read the signature **and the body of every `def` it mentions** (external parameters and conclusions are `def … : Prop`); compare hypotheses and conclusion; a hypothesis `(h… : ToolName)` is an external parameter.

| PDF | Paper location | Lean main theorem (file:line, name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| Lemma 2.1 | main.tex:35-43 | `pv_work/L01.lean:33` `Paper.L01.L01_main` | `Conclusion` (`pv_work/L01Stmt.lean:10`): `mono`, `values`; `Paper.Defs.edf` | `L01_gate.md`, `L01_final.md`, `L01_mech.md` |
| Proposition 2.2 | main.tex:45-50 | `pv_work/P01.lean:18` `Paper.P01.P01_main` (takes `GlivenkoCantelli`) | `GCConclusion` (`P01Stmt.lean:10`), `IsIIDSeq` (`:16`), `GlivenkoCantelli` (`:26`); `Paper.Defs.Dn` | `P01_gate.md`, `P01_final.md`, `P01_mech.md` |
| Theorem 2.3 | main.tex:53-63 | `pv_work/T01.lean:436` `Paper.T01.T01` (takes `DonskerUniformSup`, `KolmogorovFormula`) | `KSConclusion` (`T01Stmt.lean:46`): `conv`, `cdf`; `ConvInDist` (`:17`), `IsBrownianBridge` (`:27`), `supAbs`, `Kfun`, `DonskerUniformSup` (`:60`), `KolmogorovFormula` (`:69`); `Paper.Defs.Dn` | `T01_gate.md`, `T01_issue_1.md`, `T01_final.md` (superseded, on the gap file), `T01_final_r2.md` (current), `T01_mech*.md` |

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` | `edf` (:21), `edfRV` (:31), `cdfOf`, `Dn` (:49) | Definition 1.1 and D_n, main.tex:24-31 (gate: `verification/audits/DEFS_gate.md`) |

## 4. Suggested checking order

1. External inputs in the worksheet (B items first).
2. The base definitions in §3.
3. The statements of the main theorems, including `IsBrownianBridge` and `ConvInDist`.

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

with `<ModuleName>` one of `L01`, `P01`, `T01`.
