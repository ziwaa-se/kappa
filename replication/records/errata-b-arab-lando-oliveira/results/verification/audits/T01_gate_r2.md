# T01 statement gate, round 2 (amendment check for A1, A2 of `T01_gate.md`)

- Reviewer: pv-gate (Claude Opus 5.5), independent subagent; not the drafter.
- Date: Tue Oct 13 01:11:14 EDT 2026 (from `date`).
- Mode: amendment check. Only the changed parts were reviewed. Earlier rulings on items 1-7 stand except where noted.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` 3859de1a3200a724829c43e07819ea315eabfab9e4361bb48889ddbb974a441b
  - `pv_work/T01Draft.lean` 20335dacd7b66b7584e8abc003432cd87c9f6b21df2176c06791da662588331e
  - `pv_work/T01Stmt.olean` 5e78f8dbfb41a47e6d8f0a0eeda9fa8d2f9ef78245e8fc59b65bbf66f6651fa7
  - `pv_work/L01Stmt.lean` (imported, unchanged) 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e
- Compilation: `scripts/pv_lean.sh check T01Draft` -> `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_5.log olean=none`.
- Gate probes (`pv_work/probes/gate/T01/`):
  - `gate_T01_stmtcopy_r2.lean`: exit=0, 0 sorry, log `pv_work/logs/gate_T01_stmtcopy_r2_1.log`
  - `gate_T01_draftcopy_r2.lean`: exit=0, 8 sorry, log `pv_work/logs/gate_T01_draftcopy_r2_1.log`
  - `gate_T01_consumed_false.lean` re-run against the amended Stmt: exit=1, log `pv_work/logs/gate_T01_consumed_false_2.log`. The round-1 refutation `¬ T01_L01Consumed` (Dirac at 0) no longer type-checks, because the `←` half now asks for `F (dirac 0) 0 = 0` (the error message shows exactly this expected type). This failure is the intended outcome.

## A1: implemented. PASS
- `T01Stmt.lean:36-38` now reads `∀ μ, IsProbabilityMeasure μ → (IsInvSub μ → SubCond μ) ∧ (F μ 0 = 0 → SubCond μ → IsInvSub μ)`. This is verbatim the text required in round 1.
- Docstring (`T01Stmt.lean:30-35`): provenance (p), counted as (iv) because L01 is ISSUE (L01_issue_1). It gives the L01 location (F:128-134), the added premise from Def 2.2 F:124, and the applicability (`→` applies to μ; `←` applies to `μ.map h`, with its premise supplied by S2, a recorded gap). This is as required.
- Truth/satisfiability: the clause specialises L01 and is weaker than the printed lemma. Under `F μ 0 = 0`, `IsInvSub μ` reduces to subadditivity of `1 − F(1/x)` on (0,∞). For a, b > 0, take x = 1/(a+b) and θ = a/(a+b). Then x/θ = 1/a and x/(1−θ) = 1/b, so `SubCond` (x ≥ 0) is a rewriting of that subadditivity, as F:137 says. Both halves are therefore true as stated, in agreement with the L01 gate's hand check (S1∘S2) and `L01_issue_1.md` §"suggested fix". The hypothesis is not refutable, so `T01_main` is no longer vacuous. It is not goal-shaped: it is about arbitrary μ, and its `←` premise `F μ 0 = 0` is exactly the unestablished S2, so the paper's gap stays visible at S2.
- Naming/location: `Paper.T01.T01_L01Consumed`, declared in `T01Stmt.lean`; the name is unchanged from round 1.

## A2: implemented. PASS
- `T01Draft.lean:17-20`: `T01_S1` now has `(hbdd : BddAbove {y : ℝ | 0 ≤ y ∧ h y ≤ x})` right after `(hx : 0 ≤ x)`, as required. The docstring (lines 14-16) states that it excludes only the source's h^{-1}(x)=+∞ case (junk `sSup`).
- Truth as stated: as argued in round 1, item 5, for x ≥ 0 the sublevel set is downward closed (star-shaped), closed (continuous) and now bounded, so it equals [0, r] with r = ginv h x. Since μ(Iic 0) = 0 (from `hX`), both sides equal μ(Iic r). S1 is therefore true and no longer false merely because of the encoding.
- TFA status: unchanged from the round-1 TFA table. `hbdd` is an obligation-local encoding premise. The assembly must discharge it from S2 + `hs` (FAIR_IMPLICIT_STEP; the prover must label it as such).

## Other changes: only the optional docstring
- The type hashes (below) were compared line by line with the round-1 snapshot. Only `T01_L01Consumed` (vh 2484386763 -> 1472069470) and `T01_S1` (th 1327734917 -> 2720827082, bi `eceeeeee` -> `eceeeeeee`, i.e. one more explicit binder) changed. All other declarations have identical th/vh/bi. `T01_main` is unchanged (th=1280967929, bi=eeeceeee).
- Text diff against the round-1 copies: the `T01_main` docstring now says "L01 (`←`), whose premise `F μ 0 = 0` is fed by S2". This is the optional change suggested in round 1, it is comment-only, and its th is unchanged. No other text differs.

## Unchanged from round 1 (for the coordinator)
- False-as-stated obligations recorded as paper-side gaps (not encoding problems): `T01_S0` (h = −x) and `T01_S2` (h = max(x−1,0), X Fréchet(1)). These were the suspected issues already listed in `T01_gate.md` item 7, both with dispatch to pv-issue-checker recommended. The gate does not rule on them.
- External parameters: `T01_X02Tool` (i), approved; `T01_L01Consumed` (p, counts as (iv)), now approved.

## Statement snapshot (`#pv_type_hashes_here` on the r2 gate copies, verbatim)

`pv_work/logs/gate_T01_stmtcopy_r2_1.log`:
```
TYPE HASHES (current file, 5 declarations)
Paper.T01.AntiStarShaped|def|th=4254974927|vh=1666840368|bi=e
Paper.T01.StarShaped|def|th=4254974927|vh=2775174033|bi=e
Paper.T01.T01_L01Consumed|def|th=3944470172|vh=1472069470|bi=
Paper.T01.T01_X02Tool|def|th=3944470172|vh=4251682764|bi=
Paper.T01.ginv|def|th=2287483187|vh=2419902270|bi=ee
EXIT=0
```

`pv_work/logs/gate_T01_draftcopy_r2_1.log`:
```
TYPE HASHES (current file, 8 declarations)
Paper.T01.T01_S0|thm|th=2863022550|vh=-|bi=eee
Paper.T01.T01_S1|thm|th=2720827082|vh=-|bi=eceeeeeee
Paper.T01.T01_S2|thm|th=193369578|vh=-|bi=eceeee
Paper.T01.T01_S3|thm|th=656790863|vh=-|bi=eeeee
Paper.T01.T01_S4|thm|th=1203755882|vh=-|bi=eeeeee
Paper.T01.T01_S5|thm|th=4211601353|vh=-|bi=eceeeee
Paper.T01.T01_S6|thm|th=274719269|vh=-|bi=eceeeee
Paper.T01.T01_main|thm|th=1280967929|vh=-|bi=eeeceeee
EXIT=0
```

STATEMENT GATE: PASS
