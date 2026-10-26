# Lean comment errata (comments only; no verdict is changed)

Audited Lean files are **no longer modified**: docstrings go into the `.olean`, and a change would invalidate the "byte-for-byte identical" audit record.
Outdated or inaccurate comments are recorded here, and **this table takes precedence**.

If the user authorizes a change, proceed as follows:
1. change only comments;
2. with comments removed, the proof is byte-for-byte identical to the audited version;
3. rebuild the `.olean` (including everything downstream), and refresh the hashes in the audit records.

| # | File (location) | Current text (summary) | Should be | Source |
|---|---|---|---|---|
| 1 | `pv_work/P01.lean` (docstring of S5) | "Uses: S2, S3, S4" | S5 consumes S2 through `ae_haz` (S4 stated before the change of variable); S3, S4 are proved but not consumed by `P01_main` | `verification/audits/P01_final.md:56` |
| 2 | `pv_work/T02Stmt.lean` (docstring of `T02_L01Consumed`) | "using (eq:sub-1x)" (source :201 and :256) | after manuscript revision 1 the second use is at source :231-233 ("taking into account (eq:sub-1x)"); :256 no longer exists | `verification/audits/T02_gate.md` (item 6) |
| 3 | `pv_work/T02.lean:228` (docstring of `T02_S4`) and `pv_work/T02Draft.lean:60` (copy) | "the case `x < 0` is not written; EXPOSITION_GAP candidate, recorded only" | the case `x < 0` is a FAIR_IMPLICIT_STEP (as ruled by the gate and the final audit: Definition 2.1 asks all real x, and for x < 0 the claim follows from F_X(0)=0); comment only, no rebuild needed | `verification/audits/T02_final.md` section 6 |
