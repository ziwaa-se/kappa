# P05 statement gate, round 2 (amendment check for A1-A4 of `P05_gate.md`)

- Reviewer: pv-gate (independent subagent, Claude Opus 5.5); not the drafter.
- Date: Tue Oct 13 01:40:26 EDT 2026 (from `date`).
- Mode: amendment check; only the changed parts were reviewed.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P05Stmt.lean` b267a3edb81e86f520fffc6f02ef4be5448b2f8cccf1cc1d45a49be2507287f0
  - `pv_work/P05Draft.lean` 4597f72fe56e3ff3b8eb95161138a438ec8c4ab6cfea11372515b91e746f112b
  - also read: `pv_work/P04Stmt.lean` l.54-70 (`HScInt`, `IsEValueUnder`, `P04Conclusion`).
- Compilation: `scripts/pv_lean.sh check P05Draft` -> `RESULT P05Draft mode=check exit=0 errors=0 sorry_warnings=9 nonstandard_axiom_lines=0 log=pv_work/logs/P05Draft_4.log` (9 sorries = 9 draft declarations; the check also confirms that the compiled `P05Stmt.olean` carries the amended 9-argument `P05_P04Consumed`).

## Check of each required change

- **A1: implemented.** `P05Stmt.lean` l.21-23 is exactly the A1 body `∀ T : ℕ, h + 1 ≤ T → Paper.P04.P04Conclusion S h ℱ Y c p q lam T`. Docstring l.16-20: provenance (p), location P04 l.222-227 / `Paper.P04.P04_main` (`pv_work/P04.lean:556-560`), applicability via `hset`, `hS`, `hh`, and the explicit statement that the conditional bound of l.474 is NOT part of the clause and is the obligation `P05_Sbridge`. Not stronger than P04 (`P04Conclusion` = ℱ_T-measurability + `IsEValueUnder` under `HScInt .. c ..`, P04Stmt l.67-70). Approved as (p).
- **A2: implemented.** `P05_main` l.22 is `(hP04 : P05_P04Consumed S h ℱ Y c p q lam)`. Binder count unchanged (19), so no other binder was added or removed; the conclusion text is unchanged.
- **A3: implemented.**
  - `P05_Sapp` (l.40-44): hypotheses `hset`, `Q`, `hQ`; conclusion `Q ∈ HScInt S h ℱ Y c p q`. True as stated given `hset.c_mem` (c_t ∈ {0,1}, so ℋ_S ⊆ ℋ_{S;c}). FAIR_IMPLICIT_STEP, as required.
  - `P05_Snn` (l.49-55): hypotheses `hP04`, `hset`, `Q`, `hQ`, `t`, `ht`; conclusion nonnegativity everywhere and `Integrable` under `Q`. True as stated: nonnegativity is the first conjunct of `IsEValueUnder`; integrability from ℱ_t-measurability (`ℱ t ≤ m0`), nonnegativity and `∫⁻ ofReal ≤ 1 < ∞` under `Q ∈ ℋ_{S;c}` (via Sapp). Does not contain the conditional bound.
  - `P05_Sbridge` (l.62-68): conclusion `∀ᵐ ω ∂Q, condExp (ℱ t) Q (eT .. t) ω ≤ 1`; docstring cites l.236/l.474, states it is not justified by the source, expected false as stated, suspected PAPER_ARGUMENT_GAP, and that the prover must not prove it by another route. As required. **False as stated in general** (equivalent to e_t ≤ 1 Q-a.s. since e_t is ℱ_t-measurable and integrable); this is the faithful record of the suspected gap, not an encoding defect.
- **A4: implemented.** S1 (l.74-80): `hP04` removed, nothing else changed (binders 15 -> 14). S2 (l.86-95): `hP04` replaced by `h0`, `hint` exactly as specified (binders 16 -> 17). S3 (l.100-108): `hP04` replaced by `hcb` exactly as specified (binders 15 -> 15). Conclusions of S1-S3 unchanged in text.
- **Notes / register item:** not part of the Lean statement; the provenance is now (p) in the Stmt docstring. The coordinator should confirm `verification/EXTERNAL_TOOLS.md` shows (p) for `P05_P04Consumed` and the suspected issue recorded against `P05_Sbridge`.

## Other changes

None found. `P05_S0` and `P05_S4` have type hashes identical to round 1 (th=450545156, th=2133614533). The changes in the hashes of `P05_S1`, `P05_S2`, `P05_S3`, `P05_main` and `P05_P04Consumed` are fully explained by A1-A4 (removed/replaced binder, added `c` argument). `P05_Sapp`, `P05_Snn`, `P05_Sbridge` are the new obligations of A3. No new hypotheses on `P05_main`; the TFA `∀ᵐ ω ∂Q, h + 1 ≤ τ ω` is unchanged.

## Assembly

`P05_main` follows from S0, S1, Sapp, Snn, Sbridge, S2, S3, S4 (S4 with `Measurable τ` from `hτ` and `ℱ t ≤ m0`, and `IsProbabilityMeasure Q` from `HScInt`). The only unjustified step of the source is now the obligation `P05_Sbridge`, not a hypothesis.

## Rulings carried over (unchanged from round 1)

- TFAs approved: `∀ᵐ ω ∂Q, h + 1 ≤ τ ω`; integrability premise inside `HScInt` (inherited from P04); `τ : Ω → ℕ` everywhere finite (representation choice).
- External parameters / consumed clauses approved: `P05_P04Consumed`, type (p), location P04 l.222-227 / `P04_main`.
- Suspected issues (preliminary, dispatch pv-issue-checker): `source/VSIFP_02.tex:474,476` (with l.236) PAPER_ARGUMENT_GAP (obligation `P05_Sbridge`); same location for h >= 2, ERROR candidate (see `P05_gate.md` Item 7); `:236-238` DOMAIN_CLARIFICATION, `:223`/`:236` EXPOSITION_GAP / EDITORIAL.

## Statement snapshot (binding; copies `pv_work/probes/gate/P05/gate_P05_stmtcopy_r2.lean`, `gate_P05_draftcopy_r2.lean`)

`scripts/pv_lean.sh probe` stmtcopy: `RESULT gate_P05_stmtcopy_r2 mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_P05_stmtcopy_r2_1.log`
```
TYPE HASHES (current file, 1 declarations)
Paper.P05.P05_P04Consumed|def|th=609196166|vh=2825680653|bi=iieeeeeeee
```
`scripts/pv_lean.sh probe` draftcopy: `RESULT gate_P05_draftcopy_r2 mode=probe exit=0 errors=0 sorry_warnings=9 nonstandard_axiom_lines=0 log=pv_work/logs/gate_P05_draftcopy_r2_1.log`
```
TYPE HASHES (current file, 9 declarations)
Paper.P05.P05_S0|thm|th=450545156|vh=-|bi=iieeeeee
Paper.P05.P05_S1|thm|th=418463381|vh=-|bi=iieeeeeeeeeeee
Paper.P05.P05_S2|thm|th=3997211345|vh=-|bi=iieeeeeeeeeeeeeee
Paper.P05.P05_S3|thm|th=704612959|vh=-|bi=iieeeeeeeeeeeee
Paper.P05.P05_S4|thm|th=2133614533|vh=-|bi=iiecee
Paper.P05.P05_Sapp|thm|th=651924242|vh=-|bi=iieeeeeeeeeee
Paper.P05.P05_Sbridge|thm|th=864997650|vh=-|bi=iieeeeeeeeeeeeeeee
Paper.P05.P05_Snn|thm|th=674901191|vh=-|bi=iieeeeeeeeeeeeee
Paper.P05.P05_main|thm|th=710880581|vh=-|bi=iieeeeeeeeeeeeeeeee
```

## Overall verdict

All four amendments are implemented as required and no other change was introduced. Proof work may begin. `P05_Sbridge` is expected to be false as stated, so P05 is expected to end with an issue recorded, not a pass.

STATEMENT GATE: PASS
