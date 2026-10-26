# T02 statement gate, round 2 (amendment check)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5), amendment-check mode
- Date: Tue Oct 13 01:12:14 EDT 2026 (from `date`)
- Reference: `verification/audits/T02_gate.md` (r1, PASS_WITH_AMENDMENTS, 1 required change)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  a99991e0222d74ac2ea3ce9365e6f6b2fd6d9f52526f144d2eea59dc07af2e58 (same as r1)
  - `pv_work/T02Draft.lean` 776caa84df77d0f19b868c8c7c4c38a2d63cc00b282e955859bf8fea416cb202 (r1: 6c0fd4c2…b65c8)
- Compilation: `scripts/pv_lean.sh check T02Draft` gave `RESULT T02Draft mode=check exit=0 errors=0 sorry_warnings=14 nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_4.log`
- Snapshot probes: `pv_work/logs/gate_T02_r2_stmtcopy_1.log` (exit 0, 0 sorry), `pv_work/logs/gate_T02_r2_draftcopy_1.log` (exit 0, 14 sorry)

## Required change 1 (T02_S6b): IMPLEMENTED

- `pv_work/T02Draft.lean:106`: `theorem T02_S6b (hn : 2 ≤ n) (hiid : IIDCopies μ X Xs) …`. The binder is placed before `hiid`, as requested.
- Docstring lines 104-105 add: "The binder `hn : 2 ≤ n` is the source's induction range (:219, step for `n ≥ 3` variables; here `n + 1` copies); at `n = 0` the statement is false (gate amendment 1)." This is as requested.
- Truth as stated: with `n ≥ 2` we have `n+1 ≥ 3` copies and `1 - θ(last) > 0`, because all weights are positive and sum to 1. Conditioning on `X_last`, which is independent of the others, gives the equality (r1 analysis). The n = 0 counterexample is now excluded. TFA `hn : 2 ≤ n`: APPROVED, as announced in r1. It matches the source range at :219.
- The rest of S6b's type is unchanged.

## No other change introduced: PASS

This is determined by `#pv_type_hashes`, comparing the r1 snapshot with the r2 snapshot below:
- `T02Stmt.lean`: all 14 lines are identical (th, vh, bi). The hash of the file is also unchanged.
- `T02Draft.lean`: 13 of the 14 lines are identical. Only `T02_S6b` differs: `th` went from 746136603 to 1282479372, and `bi` went from `iceceieeeeeeee` to `iceceieeeeeeeee`, i.e. one extra explicit binder. This is exactly the amendment.
- The drafter took no optional uniformity changes (S5, S6a, S7 are unchanged).

The r1 rulings on items 1-4, 6 and 7 and on the other obligations still stand. S10b is still false as stated, and is kept as the faithful encoding of suspected issue B. Suspected issues A, B and C from r1 should still be dispatched to pv-issue-checker.

## Statement snapshot

`T02Stmt.lean` (copy `pv_work/probes/gate/T02/gate_T02_r2_stmtcopy.lean`, log `pv_work/logs/gate_T02_r2_stmtcopy_1.log`):
```
TYPE HASHES (current file, 14 declarations)
Paper.T02.Fbar|def|th=390107078|vh=3343139924|bi=ee
Paper.T02.IIDCopies.casesOn|def|th=434416582|vh=1652630351|bi=iciiiiiee
Paper.T02.IIDCopies.ident|thm|th=102015611|vh=-|bi=iciiiiee
Paper.T02.IIDCopies.indep|thm|th=3655323579|vh=-|bi=iciiiie
Paper.T02.IIDCopies.measXs|thm|th=2523711503|vh=-|bi=iciiiiee
Paper.T02.IIDCopies.meas|thm|th=4058452396|vh=-|bi=iciiiie
Paper.T02.IIDCopies.mk|ctor|th=4055493862|vh=-|bi=iciiiieeee
Paper.T02.IIDCopies.noConfusionType|def|th=4126065379|vh=65651301|bi=iiiiiieee
Paper.T02.IIDCopies.noConfusion|def|th=1892530097|vh=2957419864|bi=iiiiiiiiie
Paper.T02.IIDCopies.recOn|def|th=434416582|vh=1442461223|bi=iciiiiiee
Paper.T02.IIDCopies.rec|rec|th=53135905|vh=-|bi=iciiiiiee
Paper.T02.IIDCopies|induct|th=2293504786|vh=-|bi=iceeie
Paper.T02.StDom|def|th=180540177|vh=4122359899|bi=iceee
Paper.T02.T02_L01Consumed|def|th=3944470172|vh=1867989605|bi=
EXIT=0
```

`T02Draft.lean` (copy `pv_work/probes/gate/T02/gate_T02_r2_draftcopy.lean`, log `pv_work/logs/gate_T02_r2_draftcopy_1.log`):
```
TYPE HASHES (current file, 14 declarations)
Paper.T02.T02_S10a|thm|th=1489478117|vh=-|bi=eceeeee
Paper.T02.T02_S10b|thm|th=3341842293|vh=-|bi=eceeeee
Paper.T02.T02_S11|thm|th=134606338|vh=-|bi=eceeeee
Paper.T02.T02_S1|thm|th=2536064818|vh=-|bi=iceceeeeeeeeeeeeee
Paper.T02.T02_S2|thm|th=675241779|vh=-|bi=eceeeee
Paper.T02.T02_S3|thm|th=1086017434|vh=-|bi=eeceeeee
Paper.T02.T02_S4|thm|th=2873665920|vh=-|bi=eiceceeeeeeeeeeee
Paper.T02.T02_S5|thm|th=1446304120|vh=-|bi=iceceieeeeeeee
Paper.T02.T02_S6a|thm|th=876163804|vh=-|bi=iceceieeeeeee
Paper.T02.T02_S6b|thm|th=1282479372|vh=-|bi=iceceieeeeeeeee
Paper.T02.T02_S7|thm|th=928160013|vh=-|bi=iceceieeeeeeeee
Paper.T02.T02_S8|thm|th=3869777614|vh=-|bi=eceeeee
Paper.T02.T02_S9|thm|th=3301692871|vh=-|bi=ecee
Paper.T02.T02_main|thm|th=703880595|vh=-|bi=eicecieeeeeee
EXIT=0
```

## Overall verdict

Amendment 1 is implemented exactly. The hashes show no other change. S6b is now true as stated in the source's range.

STATEMENT GATE: PASS
