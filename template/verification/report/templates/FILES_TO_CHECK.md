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
- open entries in `verification/BLOCKERS.md`
- external literature you need to obtain yourself: ...

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature** (from `theorem … :` to `:= by`), **as well as the content of every `def` mentioned in the signature**. External parameters and conclusions are often written as `def … : Prop := …`; the signature shows only the name, and the real mathematical content is in the body of the `def`.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter.
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|

## 4. Suggested checking order

1. Level A external inputs in the worksheet.
2. The base definitions in §3.
3. Counterexample results: confirm that the counterexample refutes the paper's original sentence, not a stronger proposition.
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
