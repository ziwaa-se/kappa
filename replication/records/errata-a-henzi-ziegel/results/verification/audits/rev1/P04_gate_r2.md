# P04 statement gate, amendment check r2 (Proposition 3.4, `prop:combination`)

- Reviewer: pv-gate (independent subagent; not the drafter)
- Date: Tue Oct 13 01:23:29 EDT 2026 (`date`)
- Mode: amendment check of R1, R2 from `verification/audits/P04_gate.md`; only the changed parts were reviewed.
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):

| file | sha256 (r2) | sha256 (r1 gate) |
|---|---|---|
| pv_work/P04Stmt.lean | 75fea7ffaf4ec7eb338e88eb8ad209126e94e0354a9dfc748a052248c0b38069 | 5dbc28a2…2eae5c |
| pv_work/P04Draft.lean | 4444ef60c0a1b47a932ce255d5ffa2aa131ab8c4188b9fd45f60012b6924091c | c27da516…775fa |
| pv_work/Defs.lean (imported) | 1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c | unchanged |
| pv_work/T01Stmt.lean (imported) | 011685b5b1e5a9f9d221fb49cf0478b632e812be2257bd23085e5357d6b1c8f2 | unchanged |

- Compilation: `scripts/pv_lean.sh check P04Draft` -> `exit=0 errors=0 sorry_warnings=9 nonstandard_axiom_lines=0`, log `pv_work/logs/P04Draft_4.log`.
- Snapshot probes: `pv_work/probes/gate/P04/gate_P04_r2_stmtcopy.lean` EXIT=0, 0 sorry (log `pv_work/logs/gate_P04_r2_stmtcopy_1.log`); `pv_work/probes/gate/P04/gate_P04_r2_draftcopy.lean` EXIT=0, 9 sorry (log `pv_work/logs/gate_P04_r2_draftcopy_1.log`).

## R1: implemented. PASS

- `P04Stmt.lean` l.90-92: `P04_MixingOfStrict S := ∀ ν : Measure ℝ, T01.MixtureRep S ν → IsStrictlyConsistent S → ∀ a b : ℝ, 0 < a → a < b → b < 1 → 0 < ν (Set.Ico a b)`, matching the R1 text. Docstring l.85-89 gives provenance (ii) l.106, used silently (iii) in P04, and calls the mixture representation the convention of l.93-97, not a parameter. ✓
- The parameter is now the "only if" direction of l.106 with `ν` given, so it is no longer stronger than the source. The r1 counterexample (`(p-y)^2 - 5`) no longer applies: that score has no `MixtureRep`, so the premise is false. It is true (r1 item 6 argument) and not goal-shaped. Approved as (ii)/(iii).
- Binders `(ν : Measure ℝ) (hrep : T01.MixtureRep S ν)` were inserted right after `(S : ℝ → ℝ → ℝ)` in `P04_main` (l.17), `P04_S1` (l.28), `P04_S5` (l.65), `P04_S6` (l.75), `P04_S7` (l.90) and `P04_S8` (l.105); `hMix` is kept in all of them. ✓ The binder strings grew by exactly 2 in each (S1 16→18, S5/S6/S7 19→21, S8 17→19, main 17→19). The docstrings of S1/S5 now say "with `ν` from `hrep`". ✓
- TFA-2 (`ν`, `hrep` as the l.93-97 convention): approved as in r1.

## R2: implemented. PASS

- `P04Draft.lean` l.54: `(hS : IsStrictlyConsistent S)` added after `(hset : SeqSetting ℱ Y c p q lam)` in `P04_S4`; binder string 14→15. ✓ With `hS`, S4 is true as stated (r1 item 5 argument).

## No other changes: PASS (checked by hashes, not by eye)

- Stmt: all 34 declarations have the same `th`/`vh`/`bi` as the r1 snapshot except `P04_MixingOfStrict`, where `vh` changed 2443578863 → 2636801367 (the R1 change; `th` and `bi` unchanged).
- Draft: `P04_S2` (th=1825503320) and `P04_S3` (th=3849468069) are identical to r1. `P04_S1`, `P04_S4`–`P04_S8` and `P04_main` changed only by the binders above; their conclusions are textually unchanged.
- Assembly is unchanged: `main` follows from S3 and S8, and both have the same hypotheses as `main`.

## External parameters (r2 status)

| name | type | ruling |
|---|---|---|
| `P04_T01Consumed` | (p) T01 l.144-149/l.403. This counts as (iv) because T01 is ISSUE; it can be discharged by `Paper.T01.T01_S2` (probe `gate_P04_t01link.lean`) | APPROVED (unchanged, vh=4113823044) |
| `P04_MixingOfStrict` (R1 form) | (ii) l.106, used silently (iii) in P04 | APPROVED |

Suspected issues 1-3 from r1 (l.470 σ-field index shift; l.223/147 `p_t = q_t`; l.93 additive terms) remain open for pv-issue-checker. They are not affected by the amendments.

## Statement snapshot (r2, supersedes r1)

`pv_work/logs/gate_P04_r2_stmtcopy_1.log`:
```
TYPE HASHES (current file, 34 declarations)
Paper.P04.HScInt|def|th=4049409469|vh=4086871767|bi=iieeeeeee
Paper.P04.HSc|def|th=4049409469|vh=4068097418|bi=iieeeeeee
Paper.P04.Ik|def|th=2688782768|vh=1188971402|bi=eee
Paper.P04.IsEValueUnder|def|th=991135443|vh=3738125688|bi=iiee
Paper.P04.P04Conclusion.casesOn|def|th=2675418763|vh=1507955123|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion.evalue|thm|th=4035352186|vh=-|bi=iiiiiiiiiiie
Paper.P04.P04Conclusion.measurable|thm|th=4135999659|vh=-|bi=iiiiiiiiiiie
Paper.P04.P04Conclusion.mk|ctor|th=2848929677|vh=-|bi=iiiiiiiiiiiee
Paper.P04.P04Conclusion.noConfusionType|def|th=29438603|vh=2860735649|bi=iiiiiiiiiiieee
Paper.P04.P04Conclusion.noConfusion|def|th=3611900954|vh=4253560742|bi=iiiiiiiiiiiiiie
Paper.P04.P04Conclusion.recOn|def|th=2675418763|vh=1945409720|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion.rec|rec|th=2364683867|vh=-|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion|induct|th=2076968018|vh=-|bi=iieeeeeeeee
Paper.P04.P04_MixingOfStrict|def|th=3052518861|vh=2636801367|bi=e
Paper.P04.P04_T01Consumed|def|th=3052518861|vh=4113823044|bi=e
Paper.P04.SeqSetting.Y_adapted|thm|th=1845958995|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.Y_mem|thm|th=2839112627|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.c_adapted|thm|th=2580291967|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.c_mem|thm|th=405650024|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.casesOn|def|th=2469678534|vh=2258885665|bi=iiiiiiiiiee
Paper.P04.SeqSetting.lam_adapted|thm|th=295661739|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.lam_mem|thm|th=2343973461|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.lam_zero|thm|th=1211223059|vh=-|bi=iiiiiiiieeee
Paper.P04.SeqSetting.mk|ctor|th=588935457|vh=-|bi=iiiiiiiieeeeeeeeeee
Paper.P04.SeqSetting.noConfusionType|def|th=3681074281|vh=2499496481|bi=iiiiiiiieee
Paper.P04.SeqSetting.noConfusion|def|th=2508541176|vh=145876914|bi=iiiiiiiiiiie
Paper.P04.SeqSetting.p_adapted|thm|th=2626217022|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.p_mem|thm|th=791283169|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.q_adapted|thm|th=1779977113|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.q_mem|thm|th=1757075794|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.recOn|def|th=2469678534|vh=2691199307|bi=iiiiiiiiiee
Paper.P04.SeqSetting.rec|rec|th=29311890|vh=-|bi=iiiiiiiiiee
Paper.P04.SeqSetting|induct|th=15571848|vh=-|bi=iieeeeee
Paper.P04.eT|def|th=4241663065|vh=662740667|bi=ieeeeeeee
EXIT=0
```

`pv_work/logs/gate_P04_r2_draftcopy_1.log`:
```
TYPE HASHES (current file, 9 declarations)
Paper.P04.P04_S1|thm|th=786900598|vh=-|bi=iieeeeeeeeeeeeeeee
Paper.P04.P04_S2|thm|th=1825503320|vh=-|bi=iieeeeeeeeeee
Paper.P04.P04_S3|thm|th=3849468069|vh=-|bi=iieeeeeeeeeeeee
Paper.P04.P04_S4|thm|th=3938378210|vh=-|bi=iieeeeeeeeeeeee
Paper.P04.P04_S5|thm|th=22095930|vh=-|bi=iieeeeeeeeeeeeeeeeeee
Paper.P04.P04_S6|thm|th=1408459685|vh=-|bi=iieeeeeeeeeeeeeeeeeee
Paper.P04.P04_S7|thm|th=3713368585|vh=-|bi=iieeeeeeeeeeeeeeeeeee
Paper.P04.P04_S8|thm|th=3458240155|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_main|thm|th=576819490|vh=-|bi=iieeeeeeeeeeeeeeeee
EXIT=0
```

## Overall verdict

R1 and R2 are implemented exactly as specified, and the hash comparison shows no other change. Proof work may begin.

STATEMENT GATE: PASS
