# T01 statement gate, amendment check r2

- Reviewer: pv-gate (independent subagent, claude-opus-5-5). Date: Tue Oct 13 11:22:29 EDT 2026 (`date`).
- Mode: check amendments of `verification/audits/T01_gate.md` (R1 required; R2 optional, editorial).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` 4f655659978e1547b243bc2f155ed0689a644ea3ed7dd1059b76bad3f094d072
  - `pv_work/T01Draft.lean` eb91475a37b9d91f4bd6babf363f8f2cb4345c5c1c6b2d1e932f0821d49654ad
- Both files read in full; draft notes `pv_work/notes/T01_draft_notes.md`:78-84 (amendment log) read as leads only.

## Compilation

- `scripts/pv_lean.sh check T01Draft`: `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=7 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_10.log`. 7 sorries = bodies of `T01_main`, `T01_S1`, `T01_S2`, `T01_S3`, `T01_main_randL`, `T01_SR1`, `T01_SR3`.
- Snapshot probes: `pv_work/logs/gate_T01_stmtcopy_4.log` (exit 0, 0 sorry), `pv_work/logs/gate_T01_draftcopy_4.log` (exit 0, 7 sorry).
- Truth probe `pv_work/probes/gate/T01/gate_T01_r2check.lean`, log `pv_work/logs/gate_T01_r2check_1.log`: exit 0, 0 sorry, standard axioms only. Proves `SR1_true` and `SR3_true` (the exact types of `T01_SR1`, `T01_SR3`) and `partII_assembly` (`T01ConclRand.partII` from SR3 with the binders of `T01_main_randL`).

## Check of R1

| Item required in R1 | Implemented | Remark |
|---|---|---|
| Existing declarations of both files unchanged | yes | all 17 first-round snapshot lines identical (table below); existing texts unchanged, including docstrings (R2 not done, allowed) |
| `Thm518Rand` in `T01Stmt.lean` before `end Paper.T01` | yes | T01Stmt:67-75, text identical to `T01_gate.md`:98-106 and to the pre-compiled shape probe `gate_T01_R1shape.lean`:13-19; no `A1Law` |
| `HypPartIRand` | yes | T01Stmt:77-80, identical to gate:108-111 |
| `T01Rand_T02Consumed` | yes | T01Stmt:82-87, identical to gate:113-118; shape probe `consumed_from_T02_main_randL` (gate round 1) shows it is exactly what `T02_main_randL` delivers; `randConsumed_free_on_partII` shows part (ii) is not made vacuous |
| `T01ConclRand` | yes | T01Stmt:89-93, identical to gate:120-124 |
| `T01_main_randL` with no `A1Law` binder | yes | T01Draft:57-63, binders identical to gate:130-136; docstring states the X2 stop for non-A1 laws as required |
| `T01_SR1` (premises `hA1`, `h : HypPartIRand`, from `hT02R`) | yes | T01Draft:67-73; true as stated (probe `SR1_true`) |
| `T01_SR3` (contrapositive of `Thm518Rand` with S2) | yes | T01Draft:77-84; true as stated (probe `SR3_true`); no missing premise |
| Notes: registration of `Thm518Rand` (ii) and `T01Rand_T02Consumed` (p, location, applicability) | yes | notes:83-84 |

No other change was introduced: the only differences from round 1 are the four new Stmt declarations (with auxiliaries of `T01ConclRand`) and the three new Draft theorems. All new declarations are in `namespace Paper.T01`; external parameter and consumed clause are in `T01Stmt.lean`; no name is redeclared (the build would fail otherwise; `Paper.T02` defines `GeomErgodicRand`, `A1Law`, `Prop35Rand`, not these names).

Expected and correct: `T01_main_randL.partI` is not derivable from `hT02R` alone (needs `A1Law`, not a premise); this is the recorded stop point X2, not a defect of the statement.

## Fingerprint comparison with the first-round snapshot (`T01_gate.md`:161-186)

| Declaration | round 1 | r2 | status |
|---|---|---|---|
| `Paper.T01.HypPartII` | th=3957315956 vh=1173314425 bi=iee | same | identical |
| `Paper.T01.HypPartI` | th=1151819367 vh=1055139947 bi=ieee | same | identical |
| `Paper.T01.T01Concl.casesOn` | th=1373956722 vh=1243287819 bi=iiiiiiee | same | identical |
| `Paper.T01.T01Concl.mk` | th=3893591694 bi=iiiiiee | same | identical |
| `Paper.T01.T01Concl.noConfusionType` | th=1533223712 vh=2188585157 bi=iiiiieee | same | identical |
| `Paper.T01.T01Concl.noConfusion` | th=4150213738 vh=1585562462 bi=iiiiiiiie | same | identical |
| `Paper.T01.T01Concl.partII` | th=2740704371 bi=iiiiiee | same | identical |
| `Paper.T01.T01Concl.partI` | th=2679091220 bi=iiiiiee | same | identical |
| `Paper.T01.T01Concl.recOn` | th=1373956722 vh=697509788 bi=iiiiiiee | same | identical |
| `Paper.T01.T01Concl.rec` | th=2963399103 bi=iiiiiiee | same | identical |
| `Paper.T01.T01Concl` | th=4031747299 bi=ieeee | same | identical |
| `Paper.T01.T01_T02Consumed` | th=4031747299 vh=1497662525 bi=ieeee | same | identical |
| `Paper.T01.Thm518` | th=3944470172 vh=3970237549 bi= | same | identical |
| `Paper.T01.T01_S1` | th=478559951 bi=ieeeeeeeeeee | same | identical |
| `Paper.T01.T01_S2` | th=3202775329 bi=iee | same | identical |
| `Paper.T01.T01_S3` | th=4061819840 bi=ieeeeeeeeeee | same | identical |
| `Paper.T01.T01_main` | th=150518589 bi=ieeeeeeeeeee | same | identical |

All 17 previously gated declarations are fingerprint-identical. New: `HypPartIRand`, `T01ConclRand` (+9 auxiliaries), `T01Rand_T02Consumed`, `Thm518Rand`, `T01_main_randL`, `T01_SR1`, `T01_SR3`.

## Rulings on the new declarations

- TFAs: TFA-C (`IsProbabilityMeasure Lmeas`, `Lmeas {0} = 0`) and TFA-D ((19) for every charged `l ≥ 1`) used exactly as approved in advance; `A1Law` appears only in the consumed clause and in `T01_SR1`, never in `T01_main_randL` (rejected TFA respected).
- External parameters: `Thm518Rand` (ii), Thm 5.18 TEX:1103-1109, approved; `T01Rand_T02Consumed` (p), T02 `T02_main_randL` (T02Draft:117-125), TEX:934-940, approved. Both in the exact form approved in round 1.
- False-as-stated obligations: none (SR1, SR3 proved in the probe from their premises).

## Statement snapshot

Copy `pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (log `pv_work/logs/gate_T01_stmtcopy_4.log`):
```
TYPE HASHES (current file, 25 declarations)
Paper.T01.HypPartII|def|th=3957315956|vh=1173314425|bi=iee
Paper.T01.HypPartIRand|def|th=823404741|vh=1574643224|bi=ieee
Paper.T01.HypPartI|def|th=1151819367|vh=1055139947|bi=ieee
Paper.T01.T01Concl.casesOn|def|th=1373956722|vh=1243287819|bi=iiiiiiee
Paper.T01.T01Concl.mk|ctor|th=3893591694|vh=-|bi=iiiiiee
Paper.T01.T01Concl.noConfusionType|def|th=1533223712|vh=2188585157|bi=iiiiieee
Paper.T01.T01Concl.noConfusion|def|th=4150213738|vh=1585562462|bi=iiiiiiiie
Paper.T01.T01Concl.partII|thm|th=2740704371|vh=-|bi=iiiiiee
Paper.T01.T01Concl.partI|thm|th=2679091220|vh=-|bi=iiiiiee
Paper.T01.T01Concl.recOn|def|th=1373956722|vh=697509788|bi=iiiiiiee
Paper.T01.T01Concl.rec|rec|th=2963399103|vh=-|bi=iiiiiiee
Paper.T01.T01ConclRand.casesOn|def|th=3743130198|vh=2928329089|bi=iiiiiiee
Paper.T01.T01ConclRand.mk|ctor|th=2353086176|vh=-|bi=iiiiiee
Paper.T01.T01ConclRand.noConfusionType|def|th=2831151145|vh=1947083815|bi=iiiiieee
Paper.T01.T01ConclRand.noConfusion|def|th=1036252804|vh=2031452056|bi=iiiiiiiie
Paper.T01.T01ConclRand.partII|thm|th=796414839|vh=-|bi=iiiiiee
Paper.T01.T01ConclRand.partI|thm|th=44590705|vh=-|bi=iiiiiee
Paper.T01.T01ConclRand.recOn|def|th=3743130198|vh=1798264537|bi=iiiiiiee
Paper.T01.T01ConclRand.rec|rec|th=3022034765|vh=-|bi=iiiiiiee
Paper.T01.T01ConclRand|induct|th=180574848|vh=-|bi=ieeee
Paper.T01.T01Concl|induct|th=4031747299|vh=-|bi=ieeee
Paper.T01.T01Rand_T02Consumed|def|th=180574848|vh=2835615527|bi=ieeee
Paper.T01.T01_T02Consumed|def|th=4031747299|vh=1497662525|bi=ieeee
Paper.T01.Thm518Rand|def|th=3944470172|vh=1649898800|bi=
Paper.T01.Thm518|def|th=3944470172|vh=3970237549|bi=
```

Copy `pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (log `pv_work/logs/gate_T01_draftcopy_4.log`):
```
TYPE HASHES (current file, 7 declarations)
Paper.T01.T01_S1|thm|th=478559951|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_S2|thm|th=3202775329|vh=-|bi=iee
Paper.T01.T01_S3|thm|th=4061819840|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_SR1|thm|th=3538440518|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_SR3|thm|th=1737550652|vh=-|bi=ieeeeeeeeeeee
Paper.T01.T01_main_randL|thm|th=4244311900|vh=-|bi=ieeeeeeeeeeee
Paper.T01.T01_main|thm|th=150518589|vh=-|bi=ieeeeeeeeeee
```

## Suspected issues (unchanged from round 1, preliminary, no ruling)

X3 (TEX:208-219, EXPOSITION_GAP), X2 (TEX:209 vs 934-940, 1103-1121, EXPOSITION_GAP), N9 (DOMAIN_CLARIFICATION, adopted as TFA-B): recommend dispatch of pv-issue-checker for X3 and X2.

## Overall verdict

R1 is implemented exactly as required, no other change was made, all 17 previously gated declarations are fingerprint-identical, and the new obligations are true as stated.

STATEMENT GATE: PASS
