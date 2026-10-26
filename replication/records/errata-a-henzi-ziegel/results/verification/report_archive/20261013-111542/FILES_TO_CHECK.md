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
- open entries in `verification/BLOCKERS.md` (B1, B2, B3)
- external literature you need to obtain yourself: Grünwald, de Heide, Koolen (2019), Theorem 1 (X03); Theorem 2.3 of `Gneiting2007` = Gneiting, Balabdaoui and Raftery (2007), as resolved by the .bbl (l.93; the records say "Gneiting and Raftery 2007", a different paper; l.106 has no citation).

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature** (from `theorem … :` to `:= by`), **as well as the content of every `def` mentioned in the signature**. External parameters and gap hypotheses are written as `def … : Prop := …`; the signature shows only the name, and the real mathematical content is in the body of the `def`.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter, and one named `…_Gap` is a gap hypothesis (an unproved step of the paper's proof, not an external input).
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 3.1 T01 | `source/VSIFP_02.tex:144-149` (proof l.402-427) | `pv_work/T01ModGaps.lean:308` `Paper.T01.T01_mod_gaps` (gaps `T01_S8_Gap`, `T01_S10_Gap`); statement defs in `pv_work/T01Stmt.lean` (`MixtureRep` at :19) | Characterization of e-values for H_S as E_{p,q;λ}; counterexample `pv_work/T01_Counterexample1.lean` | `verification/audits/T01_gate.md`, `T01_final.md`, `T01_issue_1.md`, `T01_issue_1_audit.md`, `T01_mech.md` |
| 3.2 T02 | `source/VSIFP_02.tex:153-172` (proof l.429-463) | `pv_work/T02ModGaps.lean:385` `Paper.T02.T02_mod_gaps` (gaps S3a, S3b, S8, S11, S15; premise `T02_T01Consumed` at `T02Stmt.lean:40`); defs in `pv_work/T02Stmt.lean`, `Defs.lean` (`GrowFinite` :76, `IsGrowLambda` :81) | GROW e-value for score dominance; counterexample `pv_work/T02_Counterexample1.lean` | `verification/audits/T02_gate.md`, `T02_final.md`, `T02_issue_1.md`, `T02_issue_1_audit.md`, `T02_mech.md` |
| 3.3 T03 | `source/VSIFP_02.tex:190-198` (proof l.465-467) | `pv_work/T03.lean:145` `Paper.T03.T03_main` (parameter `X03 : GruenwaldThm1`, `T03Stmt.lean:42`); defs `GrowIs` (`T03Stmt.lean:32`), `EGrowAll` (`Defs.lean:92`) | GROW e-value equals the likelihood ratio | `verification/audits/T03_gate.md`, `T03_final.md`, `T03_mech.md` |
| 3.4 P04 | `source/VSIFP_02.tex:222-227` (subsection from l.204; proof l.469-471) | `pv_work/P04.lean:556` `Paper.P04.P04_main` (parameters `P04_T01Consumed` `P04Stmt.lean:78`, `P04_MixingOfStrict` `:90`); defs `HScInt` (:54), `P04Conclusion` (:67) | e_T is ℱ_T-measurable and an e-value under ℋ_{S;c} | `verification/audits/P04_gate.md`, `P04_gate_r2.md`, `P04_final.md`, `P04_issue_1.md`, `P04_mech.md` |
| 3.5 P05 | `source/VSIFP_02.tex:235-240` (proof l.473-478) | `pv_work/P05ModGaps.lean:135` `Paper.P05.P05_main_mod_gaps` (gap `P05_Sbridge_Gap`; parameter `P05_P04Consumed` `P05Stmt.lean:21`); counterexample `pv_work/P05_Counterexample1.lean` | E_Q e_τ ≤ 1 for a stopping time τ | `verification/audits/P05_gate.md`, `P05_gate_r2.md`, `P05_final.md`, `P05_issue_1.md`, `P05_issue_1_audit.md`, `P05_mech.md` |

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| `pv_work/Defs.lean` | `expPi`, `IsConsistent`, `IsStrictlyConsistent`, `elemScore`, `mixtureScore`, `IsMixingMeasure`, `HS`, `HAll`, `IsEValue`, `Erep`, `kappa`, `growthRate`, `GrowFinite`, `IsGrowLambda`, `EGrow`, `EGrowAll` | Scoring-function notions and H_S (l.60-110), e-value (6) (l.144-149), GROW (l.150-160); gates `verification/audits/DEFS_gate.md`, `DEFS_gate_r2.md` (note N2 on the logarithmic score) |
| `pv_work/T01Stmt.lean` | `MixtureRep` | Mixture representation convention, l.93-97 |
| `pv_work/T02Stmt.lean` | `growLambda` (:19), `Conclusion` (:28), `T02_T01Consumed` | Theorem 3.2 statement structure |
| `pv_work/T03Stmt.lean` | `LogFinite` (:16), `IsGrowEValue` (:24), `GrowIs` (:32), `GruenwaldThm1` | GROW with uniqueness; Theorem 1 of Gruenwald2019 |
| `pv_work/P04Stmt.lean` | `SeqSetting` (:19), `Ik` (:34), `HSc` (:45), `HScInt` (:54), `IsEValueUnder` (:62), `P04Conclusion` (:67), `eT` | ℋ_{S;c}, sequential e-value (l.204-227) |

## 4. Suggested checking order

1. Level A external inputs in the worksheet.
2. The base definitions in §3.
3. Counterexample results: confirm that the counterexample refutes the paper's original sentence, not a stronger proposition (for P05, reading A of `e_τ`).
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
