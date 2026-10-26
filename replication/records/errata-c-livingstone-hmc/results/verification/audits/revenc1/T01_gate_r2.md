# T01 statement gate, round 2 (amendment check for T01_gate.md A1-A3)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); date: Tue Oct 13 01:41:45 EDT 2026
- Mode: amendment check. I looked only at the changed parts and checked that nothing else changed.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `31c0d3fbc36637a8158bc1763420cdf85c0c5f8222951c8d7761b5b7c2e7fa76  pv_work/T01Stmt.lean`
  - `1178a4c938622fd5f55594424a8bb92990fd0714f220ae4b470ffd08233e85c1  pv_work/T01Draft.lean`
  - `6841da59975dbacf3e161375adde3780aaa359fcc99c7f4d6b4659bf4737f620  pv_work/notes/T01_draft_notes.md`
- Compilation: `scripts/pv_lean.sh check T01Draft` -> `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_4.log`. EXIT=0.
- Snapshot probes: `pv_work/logs/gate_T01_stmtcopy_r2_1.log` (exit 0, 0 sorry), `pv_work/logs/gate_T01_draftcopy_r2_1.log` (exit 0, 4 sorry).

## Amendment checks

| Amendment | Required | Found | Ruling |
|---|---|---|---|
| A1 | Scope sentence in the `T01Concl` docstring; "specialised to deterministic L (𝔏 = δ_L), a weakening of the printed statement" in the `Thm518` docstring | T01Stmt.lean:43-45 (`T01Concl` Scope paragraph, word for word as required); T01Stmt.lean:24 (`Thm518` Scope line) | implemented |
| A2 | "Covers 𝔏 = δ_L only (X2)." in the `T01_main` docstring | T01Draft.lean:15 | implemented |
| A3 | Notes: fixed-L scope under "Encoding choices"; X2 under "Suspected paper issues" | notes:18 (Encoding choices), notes:42 (Suspected paper issues, EXPOSITION_GAP preliminary) | implemented |

**Other changes:** none to any declaration. I compared the current files line by line with the r1 copies (`pv_work/probes/gate/T01/gate_T01_stmtcopy.lean`, `gate_T01_draftcopy.lean`). The only differences are the added docstring text above. I did not rely on that visual comparison: the type hashes below are identical to the r1 snapshot on every line (all `th`, `vh`, `bi`, for 12 + 4 declarations), so no statement, definition body (including `Thm518`'s locked `vh`) or binder changed. The notes also gained an "Amendment log" section, which is documentation only.

All r1 rulings (items 1-7, TFA-A and TFA-B approved, `Thm518` approved as provenance (ii), suspected issues X2, X3 and N9 to be sent to pv-issue-checker) still stand unchanged.

## Statement snapshot

Stmt copy (`pv_work/probes/gate/T01/gate_T01_stmtcopy_r2.lean`, log `pv_work/logs/gate_T01_stmtcopy_r2_1.log`):
```
TYPE HASHES (current file, 12 declarations)
Paper.T01.HypPartII|def|th=3957315956|vh=1173314425|bi=iee
Paper.T01.HypPartI|def|th=1151819367|vh=3393636548|bi=ieee
Paper.T01.T01Concl.casesOn|def|th=1373956722|vh=1243287819|bi=iiiiiiee
Paper.T01.T01Concl.mk|ctor|th=3893591694|vh=-|bi=iiiiiee
Paper.T01.T01Concl.noConfusionType|def|th=1533223712|vh=2188585157|bi=iiiiieee
Paper.T01.T01Concl.noConfusion|def|th=4150213738|vh=1585562462|bi=iiiiiiiie
Paper.T01.T01Concl.partII|thm|th=2740704371|vh=-|bi=iiiiiee
Paper.T01.T01Concl.partI|thm|th=2679091220|vh=-|bi=iiiiiee
Paper.T01.T01Concl.recOn|def|th=1373956722|vh=697509788|bi=iiiiiiee
Paper.T01.T01Concl.rec|rec|th=2963399103|vh=-|bi=iiiiiiee
Paper.T01.T01Concl|induct|th=4031747299|vh=-|bi=ieeee
Paper.T01.Thm518|def|th=3944470172|vh=3970237549|bi=
EXIT=0
```

Draft copy (`pv_work/probes/gate/T01/gate_T01_draftcopy_r2.lean`, log `pv_work/logs/gate_T01_draftcopy_r2_1.log`):
```
TYPE HASHES (current file, 4 declarations)
Paper.T01.T01_S1|thm|th=3069413807|vh=-|bi=ieeeeeeeeeeeee
Paper.T01.T01_S2|thm|th=3202775329|vh=-|bi=iee
Paper.T01.T01_S3|thm|th=4061819840|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_main|thm|th=1845210232|vh=-|bi=ieeeeeeeeeeeee
EXIT=0
```

## Overall verdict

A1-A3 are implemented, and no other declaration changed (the hashes match r1). Proof work may begin.

STATEMENT GATE: PASS
