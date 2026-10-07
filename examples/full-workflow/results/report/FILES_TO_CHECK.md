# List of files for human check

## Start here: what the three files are for, and the reading order

| Order | File | Purpose | How to read it |
|---|---|---|---|
| 1 | `verification/report/AUTHOR_REPORT.md` | **Main report**: what was found, the conclusion for each item, what to tell the authors | Read §0–§3 in full; §4–§6 are to-dos; §7–§8 are background |
| 2 | `verification/report/FILES_TO_CHECK.md` (this file) | **Index**: for each conclusion, the source location, the Lean file and line number, and the audit report | Look here when checking a particular item |
| 3 | `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` | **Worksheet**: item-by-item check of the external inputs | Tick each item against the literature |

## What does **not** need to be read line by line by a human

- **Lean proof bodies.** They are machine-checked by the Lean kernel: they compile, have no `sorry`, use only the three standard axioms (`propext`, `Classical.choice`, `Quot.sound`), and the independent final audit confirmed each one by recompiling and re-checking statement fingerprints.
- **The three things a human needs to check:**
  1. **Whether the statements are faithful**: whether the hypotheses and conclusion of each Lean theorem are exactly what the paper says (see §2 below).
  2. **Whether the base definitions are faithful**: this project declares no shared `Defs*.lean` file (see §3 below) — the three results use only elementary per-statement notation.
  3. **Whether the external inputs are true**: see `EXTERNAL_TOOLS_WORKSHEET.md`. `NesbittInequality` is not proved inside the audited chain (an auditor's own side probe found it true, as a suggestion only — see the worksheet); this is a **mandatory check** (already given a first human check — see the worksheet).

## 1. Mandatory checks (external inputs)

- `EXTERNAL_TOOLS_WORKSHEET.md` — Level B item #1, `Paper.P01.NesbittInequality`.
- `AUTHOR_REPORT.md` §4–§6.
- Open entries in `verification/BLOCKERS.md`: **none** — the project's only entry, B01, is marked `RESOLVED`.
- External literature you need to obtain yourself: A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37 (or a standard reference proof of Nesbitt's inequality).

## 2. Item-by-item review: "paper statement ↔ Lean statement"

**Procedure:**
1. Open the paper location and read the source.
2. Open the Lean file, jump to the main theorem's line, and read the **theorem signature** (from `theorem … :` to `:= by`), **as well as the content of every `def` mentioned in the signature**. External parameters and conclusions are often written as `def … : Prop := …`; the signature shows only the name, and the real mathematical content is in the body of the `def`.
3. Compare the hypotheses and the conclusion one by one; a hypothesis of the form `(h… : ToolName)` is an external parameter.
4. When in doubt, read the gate report and the final audit report.

| PDF | Paper location | Lean main theorem (file:line, theorem name) | Conclusion structure / helper definitions | Audit reports |
|---|---|---|---|---|
| 2.1 (Lemma, `lem:amgm`) | Statement `source/main.tex:37-43`; proof `source/main.tex:45-50` | `pv_work/L01.lean:71 Paper.L01.L01_main (a b : ℝ) : L01Conclusion a b` | `L01Conclusion a b` is a `structure` (`pv_work/L01Stmt.lean:25-27`) with two fields: `ineq : a*b ≤ (a^2+b^2)/2` and `equality_iff : a*b = (a^2+b^2)/2 ↔ a = b`. No external parameters. | gate `verification/audits/L01_gate.md`; final `verification/audits/L01_final.md`; mechanical `verification/audits/L01_mech.md` |
| 2.2 (Proposition, `prop:nesbitt`) | Statement `source/main.tex:52-57`; proof `source/main.tex:59-69` | `pv_work/P01.lean:142 Paper.P01.P01_main (hN : NesbittInequality) (x y z : ℝ) (hx : 0<x) (hy : 0<y) (hz : 0<z) : P01Conclusion x y z` | `P01Conclusion` (`pv_work/P01Stmt.lean:49-51`) is a plain `Prop` (one clause, `S(x,y,z)` inlined). `NesbittInequality` (`pv_work/P01Stmt.lean:39-41`) is the one external parameter — see the worksheet. Imports the proved module `L01` (`Paper.L01.L01_main`), applied to the pairs $(x,y),(y,z),(z,x)$. | gate `verification/audits/P01_gate.md`; final `verification/audits/P01_final.md`; mechanical `verification/audits/P01_mech.md` |
| 2.3 (Lemma, `lem:quot`) | Statement `source/main.tex:71-76` (revision 1: "$x>-1$"); proof `source/main.tex:78-81` (revision 1: sign fact stated explicitly) | `pv_work/L02.lean:92 Paper.L02.L02_main (x : ℝ) (hx : x > -1) : x^2/(1+x) ≥ x-1` | No helper `def`/`structure`: the conclusion is the bare inequality. No external parameters. `pv_work/L02Stmt.lean` declares no names at all (0 declarations — confirmed in both the gate and final audit). | gate `verification/audits/L02_gate.md` (supersedes the pre-revision `L02_gate.md`, whose audited draft now lives in `pv_work/superseded/`); final `verification/audits/L02_final.md`; mechanical `verification/audits/L02_mech.md`; closed-history issue `verification/audits/L02_issue_1.md` and its independent review `verification/audits/L02_issue_1_audit.md` (pre-revision counterexample, see `AUTHOR_REPORT.md` §4.1) |

Where it uses a predecessor's statement `def`s: Proposition 2.2's Lean main theorem uses `Paper.L01.L01Conclusion.ineq` from `pv_work/L01Stmt.lean` (the `L01Conclusion` structure, see the row above) — no other result's `Stmt.lean` is consumed anywhere.

## 3. Base definitions

| File | What it defines | Compare with the paper |
|---|---|---|
| *(none)* | This project declares no shared `pv_work/Defs*.lean` file. `verification/RESULTS.json`'s `defs` entry is `{"id": "NONE"}`, with the note: "No shared Lean definitions file is needed: this note's only shared notation ($\R$, $\Rpos$, $S(x,y,z)$) is elementary enough to inline per-statement" (confirmed in `verification/INVENTORY.md` §4; confirmed by L01's gate, which records that L01 uses no notation from the Notation section at all, and by P01's gate, which rules the inlining of $S$ a pure notation choice). | $\R$ → Lean `ℝ`; $\Rpos$ → a positivity hypothesis `0 < x` on `x : ℝ` (never a separate subtype); $S(x,y,z)$ → inlined verbatim as `x/(y+z) + y/(z+x) + z/(x+y)` in `pv_work/P01Stmt.lean:49-51` (the only result that uses it). |

## 4. Suggested checking order

1. Level B external input in the worksheet (`Paper.P01.NesbittInequality`) — already given a first human check; a second, independent check is still worthwhile given the citation-numbering question in §5 of `AUTHOR_REPORT.md`.
2. The base definitions in §3 above (brief: there is no shared `Defs` file to check beyond the inlining note).
3. The closed-history counterexample for Lemma 2.3: confirm `pv_work/L02_Counterexample1.lean` refutes the paper's *original* sentence (the pre-revision "$x \neq -1$" text, now superseded) and not some stronger proposition — see `verification/audits/L02_issue_1_audit.md`.
4. The statements of the three main theorems (§2 above), in PDF order: Lemma 2.1 → Proposition 2.2 → Lemma 2.3.

## 5. (Optional) Rerun the compilation yourself

```bash
scripts/pv_lean.sh build PVTools
scripts/pv_lean.sh check L01
scripts/pv_lean.sh check P01
scripts/pv_lean.sh check L02
```

Probe (checks axioms and sorry) — repeat for each of `L01`, `P01`, `L02`:

```lean
import L01   -- or P01, or L02
import PVTools
#pv_axioms L01
#pv_walk L01
```

Environment used throughout this project: toolchain leanprover/lean4 v4.19.0, mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b`, linked (not rebuilt) with 2452 of 6305 modules compiled — sufficient for every module these three results need (no `TRANSLATION_BLOCKED` occurred anywhere in the project).
