# P04 statement gate, amendment check r2 (Proposition 3.4, `prop:combination`)

- Reviewer: pv-gate (independent subagent; not the drafter)
- Date: Tue Oct 13 02:30:56 EDT 2026 (`date`)
- Mode: check of amendments R1-R5 of `verification/audits/P04_gate.md` (changed parts only).
- Source re-read for the changed parts: `source/VSIFP_02.tex` l.216-221 (statement), l.199-214 (h=1 sketch; one-step bound l.205-209), l.446-469 (proof; l.452 `ℱ_j` trivial for j ≤ 0), l.143-148 / l.400 (T01), l.103 (strict consistency vs ν), l.230 (τ ∈ ℕ).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):

| file | sha256 |
|---|---|
| pv_work/P04Stmt.lean | f8f6cf447fc559ee047e08a19eceb4474e4a717f7a7f2b3d6503b2e1d6ef6119 |
| pv_work/P04Draft.lean | d31c755fe489b85a2b038fe6177ae4b44df0964a514b22a31e70c3958b31f8e7 |
| pv_work/notes/P04_draft_notes.md (leads only) | 9edef0ef8aa90fcea69c65092b9329649e929df3c3bade118d75968035c03d7c |

- Compilation: `scripts/pv_lean.sh check P04Draft` -> `RESULT P04Draft mode=check exit=0 errors=0 sorry_warnings=18 nonstandard_axiom_lines=0`, log `pv_work/logs/P04Draft_8.log` (18 = 17 earlier + new S0).
- Snapshot probes (`pv_work/probes/gate/P04/`, new names `gate_P04_v2r2_*` so the earlier probes are kept):
  - `gate_P04_v2r2_stmtcopy.lean` EXIT=0, 0 sorry (log `pv_work/logs/gate_P04_v2r2_stmtcopy_1.log`)
  - `gate_P04_v2r2_draftcopy.lean` EXIT=0, 18 sorry (log `pv_work/logs/gate_P04_v2r2_draftcopy_1.log`)

## Amendment checks

| req | requirement | found | ruling |
|---|---|---|---|
| R1 | `P04_T01Consumed (S)` = one-period clause; new docstring with (p) T01 l.143-148 "if", proof l.400, pointwise applicability, `hS.1`, `hMix` (l.103), (iv) while T01 pending ISSUE | `P04Stmt.lean` l.72-83: definition is verbatim the R1 text; docstring contains every required element. Hash `th=3052518861 vh=4113823044 bi=e` is identical to the one-period clause approved in revision 0 (`verification/audits/rev1/P04_gate_r2.md` l.63) | DONE |
| R2 | add `P04_S0` after `P04_S4`; update S5/S9c docstrings | `P04Draft.lean` l.67-77: S0 inserted after S4 with exactly the R2 binders, conclusion and docstring. S5 docstring (l.86-87) and S9c docstring (l.155) now cite "the one-step bound S0" | DONE |
| R3 | `(hT01 : P04_T01Consumed S)` in main, S1, S5, S6, S7, S9b, S9c, S10, S11; other binders kept; docstrings of main and S1 updated | all nine (and S0) carry `(hT01 : P04_T01Consumed S)`; `bi` strings of these declarations have the same length as before (one binder replaced, none added or removed); main docstring l.22-25 and S1 docstring l.33-36 updated | DONE |
| R4 | `P04_S13`: insert `(hτ1 : ∀ ω, 1 ≤ τ ω)` after `hτ`; docstring note | l.205-207: inserted at the required position; docstring l.204 cites l.230 and l.452. `bi` grew by exactly one `e` | DONE |
| R5 | module doc "l.216-221"; MixingOfStrict docstring "l.103", "l.90-102"; notes updated | module doc l.4 reads l.216-221; MixingOfStrict docstring l.102-106 reads l.103 and l.90-102; notes have an amendment section (l.90-98) marking the old consumed-clause, TFA-3 and external-input sections superseded | DONE |

## No other changes (checked by `#pv_type_hashes_here`, against the pre-amendment snapshot in `P04_gate.md`)

- `P04Stmt.lean`: all 37 lines identical except `P04_T01Consumed` (the R1 change). `HSc`, `HScInt`, `Ik`, `IsEValueUnder`, `Mk`, `P04Conclusion*`, `P04_MixingOfStrict`, `SeqSetting*`, `eT`, `filtK`, `fk` are unchanged (`th`, `vh`, `bi`).
- `P04Draft.lean`: unchanged `th`/`bi` for S2, S3, S4, S8, S9a, S12, S14. Changed only where R2-R4 require: new S0; main, S1, S5, S6, S7, S9b, S9c, S10, S11 (R3 binder type); S13 (R4).
- Docstrings: read in full; no change beyond R1-R5. Non-blocking, outside R5's scope: stale line numbers remain in the docstrings of `SeqSetting` ("l.223"), `Ik` ("l.223"), `eT` ("l.224-225"), `HSc` ("l.116-118"), `P04Conclusion` ("l.226"), S1 ("l.403"). The current numbering is l.217, l.218, l.218, l.113-119, l.220 and l.400. They do not affect hashes or content. The drafter may correct them while the files are still unreviewed; afterwards they belong in `DOC_ERRATA.md`.

## Truth of the new and changed obligations

- **S0** (new): true as stated. `Erep = 1 + g·d` with `g = λ_t/|D_t| ≥ 0` ℱ_t-measurable and `d = S(p_t,Y_{t+h}) − S(q_t,Y_{t+h})` integrable (`HScInt`). `λ_t = c_t λ_t` (`lam_zero`), so `c_t·E_Q[d|ℱ_t] ≤ 0` a.s. gives `∫_A (g∧n) d ≤ 0` for `A ∈ ℱ_t`. `Erep ≥ 0` (consistency), and Fatou along `n` gives `∫⁻_A ofReal(Erep) ≤ Q A`. The cases `p_t = q_t` (Lean division by 0, `Erep = 1`) and `c_t = 0` (`Erep = 1`) give `Q A`. It is a step of the source (l.205-209, at lag h for l.452), not the target conclusion; the extra binders `hT01`, `hMix`, `hrep`, `hh` are harmless.
- **S13** (after R4): with `τ ≥ 1` the counterexample of `gate_P04_s13cex.lean` (τ = 0) no longer applies. True as ruled in `P04_gate.md` item 5 (`f_k(τ) ≤ t ⇔ τ ≤ ⌊(t−k)/h⌋h+k`; for index ≤ 0 the set is empty because `f_k(τ) ≥ τ ≥ 1` and `f_k(τ) ≡ k mod h` with `f_k(τ) ≥ k`). TFA `τ ≥ 1` APPROVED (l.230, l.452).
- **R3 steps** (main, S1, S5-S7, S9b-S11): only the type of `hT01` changed. S1 is true from consistency alone (and also via the one-period clause with `hMix`). The others are true given S0/S1 as ruled before.
- Assembly unchanged: main follows from S3 together with S7 (h = 1) or S11 (h > 1); S5 and S9c now rest on S0.

## External parameters (final)

| name | provenance | ruling |
|---|---|---|
| `P04_T01Consumed S` (one-period) | (p) T01 l.143-148 "if" direction, proof l.400; (iv) while T01 is pending ISSUE; dischargeable by `Paper.T01.T01_S2` (coordinator's decision) | APPROVED |
| `P04_MixingOfStrict S` | (ii) l.103, (iii) in P04 | APPROVED (unchanged hash) |

TFAs: TFA-1 `HScInt`, TFA-2 `(ν, hrep)`, `p = q ⇒ Erep = 1`, and `τ ≥ 1` in S13 are APPROVED. TFA-3 is moot.

Notes for the coordinator:
- `P05Stmt` imports `P04Stmt` and must be rebuilt. Its components (`P04Conclusion`, `SeqSetting`, `eT`, `HScInt`) have unchanged hashes.
- P05's use of S13 must supply `τ ≥ 1`.
- The suspected issues of `P04_gate.md` item 7 still stand (l.452 supermartingale unargued; `ℋ_S` vs `ℋ_{S;c}`; `p_t = q_t`). They have not been re-ruled here.

## Statement snapshot (r2)

`pv_work/logs/gate_P04_v2r2_stmtcopy_1.log`:
```
TYPE HASHES (current file, 37 declarations)
Paper.P04.HScInt|def|th=4049409469|vh=4086871767|bi=iieeeeeee
Paper.P04.HSc|def|th=4049409469|vh=4068097418|bi=iieeeeeee
Paper.P04.Ik|def|th=2688782768|vh=1188971402|bi=eee
Paper.P04.IsEValueUnder|def|th=991135443|vh=3738125688|bi=iiee
Paper.P04.Mk|def|th=3661733293|vh=2458480867|bi=ieeeeeeeee
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
Paper.P04.filtK|def|th=2857920538|vh=3732874505|bi=iieeee
Paper.P04.fk|def|th=3512939730|vh=180150542|bi=eee
```

`pv_work/logs/gate_P04_v2r2_draftcopy_1.log`:
```
TYPE HASHES (current file, 18 declarations)
Paper.P04.P04_S0|thm|th=3022192586|vh=-|bi=iieeeeeeeeeeeeeeeeeeee
Paper.P04.P04_S10|thm|th=366264087|vh=-|bi=iieeeeeeeeeeeeeeeeeeeee
Paper.P04.P04_S11|thm|th=3885796934|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S12|thm|th=2384155120|vh=-|bi=eeee
Paper.P04.P04_S13|thm|th=4063404219|vh=-|bi=iieeeeeeeee
Paper.P04.P04_S14|thm|th=3901520671|vh=-|bi=ieeeeeeeeee
Paper.P04.P04_S1|thm|th=2678738617|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S2|thm|th=1825503320|vh=-|bi=iieeeeeeeeeee
Paper.P04.P04_S3|thm|th=3849468069|vh=-|bi=iieeeeeeeeeeeee
Paper.P04.P04_S4|thm|th=1386535428|vh=-|bi=iieeeeeeeeeeee
Paper.P04.P04_S5|thm|th=622082612|vh=-|bi=iieeeeeeeeeeeeeeeeee
Paper.P04.P04_S6|thm|th=123320827|vh=-|bi=iieeeeeeeeeeeeeeeeee
Paper.P04.P04_S7|thm|th=1792835576|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S8|thm|th=125539248|vh=-|bi=ieeeeeeee
Paper.P04.P04_S9a|thm|th=1085402202|vh=-|bi=iieeeeeeeeeeeeee
Paper.P04.P04_S9b|thm|th=1023887362|vh=-|bi=iieeeeeeeeeeeeeeeeeee
Paper.P04.P04_S9c|thm|th=3314833876|vh=-|bi=iieeeeeeeeeeeeeeeeeeeeee
Paper.P04.P04_main|thm|th=576819490|vh=-|bi=iieeeeeeeeeeeeeeeee
```

## Overall verdict

All of R1-R5 are implemented, and there are no other statement changes. No obligation is false as stated. Proof work may begin.

STATEMENT GATE: PASS
