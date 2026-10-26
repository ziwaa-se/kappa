# P05 statement gate, amendment check r2 (Proposition 3.5, `prop:stopping`)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5), amendment-check mode
- Date: Tue Oct 13 10:46:55 EDT 2026
- Scope: only the amendments A1 and A2 required by `verification/audits/P05_gate.md`, and whether anything else changed.

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

| file | sha256 |
|---|---|
| pv_work/P05Stmt.lean | c7d6badc0ed5362f3eefbc394770da6266078d48912f538c012c39aa16d4b365 |
| pv_work/P05Draft.lean | c1bf0f293000c08987610407c50cf5faa81e28efbf99ebb2a58b8de73ededfe3 |
| pv_work/P04Stmt.lean (imported, unchanged) | f8f6cf447fc559ee047e08a19eceb4474e4a717f7a7f2b3d6503b2e1d6ef6119 |

## Compilation

- `scripts/pv_lean.sh check P05Draft`: `RESULT P05Draft mode=check exit=0 errors=0 sorry_warnings=10 nonstandard_axiom_lines=0 log=pv_work/logs/P05Draft_8.log`.
- Stmt copy probe: exit=0, sorry_warnings=0 (`pv_work/logs/gate_P05_stmtcopy_rev2_r2_1.log`).
- Draft copy probe: exit=0, sorry_warnings=10 (`pv_work/logs/gate_P05_draftcopy_rev2_r2_1.log`).

## A1 (clause stated for ℋ_S, l.452): IMPLEMENTED

- `P05Stmt.lean` l.46: `∀ Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q, ∀ k ∈ Finset.Icc 1 h, ∀ τ' : Ω → ℕ,` as required.
- Docstring l.37-38 updated: "Stated for `ℋ_S` as at l.452 (`HScInt` with `c ≡ 1`); it is derivable from `P04_S10` by instantiating `c := 1`".
- `P05Draft.lean` S7 docstring (l.88-89) no longer cites S2. S2 is kept, with its docstring updated to say it is no longer used by S7. Its type hash is unchanged.
- Derivability check: `P04_S10` (`pv_work/P04Draft.lean` l.170-177) with `c := fun _ _ => 1` gives the clause body for `Q ∈ HScInt S h ℱ Y 1 p q`. Its premise `SeqSetting ℱ Y 1 p q lam` follows from `SeqSetting ℱ Y c p q lam` (only `c_adapted`, `c_mem`, `lam_zero` involve c, and they are trivial for c ≡ 1; see P05_gate item 6). So the clause is not stronger than its source location.

## A2 (applicability condition `hrep`): IMPLEMENTED

- `P05Stmt.lean` l.43: `(ν : Measure ℝ)` added after `S`. l.45: premise `T01.MixtureRep S ν →` added before `SeqSetting …`. This matches the `(ν) (hrep : T01.MixtureRep S ν)` binders of `P04_S10`. Docstring l.38-41 records that `hrep` is supplied by `P05_main`.
- `P05Draft.lean`: `(ν : Measure ℝ) (hrep : T01.MixtureRep S ν)` added after `S` in `P05_main` (l.20), `P05_S7` (l.90), `P05_S8` (l.103). `hP04 : P05_P04Consumed S ν h ℱ Y c p q lam` in all three. S0 and S6 were left without ν (optional, allowed).
- `hrep` in `P05_main` is TFA-2 of P04 ("under the assumptions of Proposition 3.4", l.230; l.90-103 convention), already approved there. It is not goal-shaped. The clause's applicability conditions (`hrep`, `hset`, `hS`, `1 < h` in the h > 1 branch) can now all be met inside `P05_main`/`P05_S7`.
- I did not re-read the notes file for the external-inputs table update. That is a documentation item and does not affect the statement.

## No other changes (decided by `#pv_type_hashes`, compared with the snapshot in `P05_gate.md`)

- Stmt: all `IsStopTime.*` lines and `P05Conclusion` are identical. Only `P05_P04Consumed` changed (th 609196166 → 1961053678, vh 2235679019 → 2517837916, bi gains one `e` for ν).
- Draft: `P05_S0`–`P05_S6` are identical. Only `P05_S7`, `P05_S8` and `P05_main` changed, each gaining exactly the two explicit binders ν and hrep (bi +2 `e`), as A2 requires.
- The conclusion `P05Conclusion` is unchanged, and so is the main theorem's conclusion.

## Rulings carried over

The item 1–7 rulings, TFA table and item-7 suspected issues of `P05_gate.md` stand. Items 1 and 6 now PASS.

| TFA / parameter | ruling |
|---|---|
| `IsStopTime.pos` (τ ≥ 1) | APPROVED |
| `HScInt` (inherited TFA-1) | APPROVED (inherited) |
| `(ν, hrep)` (inherited TFA-2 of P04) | APPROVED |
| `P05_P04Consumed` (p), P04 proof l.452 = `P04_S10` with c := 1, h > 1; applicability via `hrep`, `hset`, `hS`, `1 < h` of `P05_main` | APPROVED |

Suspected issues for pv-issue-checker are still open (from `P05_gate.md` item 7): the h = 1 case (l.227/l.447, EXPOSITION_GAP candidate) and the l.214 indexing (EDITORIAL/EXPOSITION_GAP candidate).

## Statement snapshot (copies `pv_work/probes/gate/P05/gate_P05_stmtcopy_rev2_r2.lean`, `gate_P05_draftcopy_rev2_r2.lean`)

Stmt copy (`pv_work/logs/gate_P05_stmtcopy_rev2_r2_1.log`):
```
TYPE HASHES (current file, 11 declarations)
Paper.P05.IsStopTime.casesOn|def|th=684456660|vh=3754682799|bi=iiiiiee
Paper.P05.IsStopTime.le_meas|thm|th=3381446121|vh=-|bi=iiiiee
Paper.P05.IsStopTime.mk|ctor|th=351244110|vh=-|bi=iiiiee
Paper.P05.IsStopTime.noConfusionType|def|th=1932249251|vh=245851765|bi=iiiieee
Paper.P05.IsStopTime.noConfusion|def|th=3747551284|vh=1109229026|bi=iiiiiiie
Paper.P05.IsStopTime.pos|thm|th=447953783|vh=-|bi=iiiiee
Paper.P05.IsStopTime.recOn|def|th=684456660|vh=1201850754|bi=iiiiiee
Paper.P05.IsStopTime.rec|rec|th=3308248231|vh=-|bi=iiiiiee
Paper.P05.IsStopTime|induct|th=1866782038|vh=-|bi=iiee
Paper.P05.P05Conclusion|def|th=3968915205|vh=3232930259|bi=iieeeeeeee
Paper.P05.P05_P04Consumed|def|th=1961053678|vh=2517837916|bi=iieeeeeeeee
```

Draft copy (`pv_work/logs/gate_P05_draftcopy_rev2_r2_1.log`):
```
TYPE HASHES (current file, 10 declarations)
Paper.P05.P05_S0|thm|th=1557197759|vh=-|bi=iieeeeeeeeeee
Paper.P05.P05_S1|thm|th=125539248|vh=-|bi=ieeeeeeee
Paper.P05.P05_S2|thm|th=1605119062|vh=-|bi=iieeeeeeeee
Paper.P05.P05_S3|thm|th=2384155120|vh=-|bi=eeee
Paper.P05.P05_S4|thm|th=1463795132|vh=-|bi=iieeeeeeee
Paper.P05.P05_S5|thm|th=3901520671|vh=-|bi=ieeeeeeeeee
Paper.P05.P05_S6|thm|th=3176615292|vh=-|bi=iieeeeeeeeeeeeeee
Paper.P05.P05_S7|thm|th=2283042784|vh=-|bi=iieeeeeeeeeeeeeeeeeeee
Paper.P05.P05_S8|thm|th=1754797784|vh=-|bi=iieeeeeeeeeeeeeeee
Paper.P05.P05_main|thm|th=800987792|vh=-|bi=iieeeeeeeeeeeeeeee
```

This is the binding snapshot for the final audit.

STATEMENT GATE: PASS
