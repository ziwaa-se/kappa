# Statement gate r2 (amendment check): DEFS (`pv_work/Defs.lean`)

- Reviewer: pv-gate (independent subagent; did not draft these files)
- Date: Mon Oct 12 22:11:16 EDT 2026 (from `date`)
- Mode: amendment check against `verification/audits/DEFS_gate.md` (A1, A2); only changed parts reviewed.
- Reviewed file: `pv_work/Defs.lean`, sha256 `1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c` (`python3 scripts/pv_snapshot.py hash`); previous gate reviewed `3a2ea062...b8d091`.
- Compilation: `scripts/pv_lean.sh check Defs` -> `RESULT Defs mode=check exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/Defs_6.log`
- `pv_work/Defs.olean` timestamp (22:08) matches `Defs.lean` (22:08), so downstream imports see the amended file.
- Snapshot probe: `pv_work/probes/gate/DEFS/gate_DEFS_stmtcopy_r2.lean` (Read/Write copy of the current `Defs.lean` plus `import PVTools` and `#pv_type_hashes_here`) -> exit=0, errors=0, log `pv_work/logs/gate_DEFS_stmtcopy_r2_1.log`.

## A1 (`IsGrowLambda`, `Real.log 0` encoding) — IMPLEMENTED
`pv_work/Defs.lean` l.74-84 now contain `GrowFinite` and `IsGrowLambda` exactly as prescribed in DEFS_gate.md l.68-80 (text compared line by line; docstrings identical as well). Sanity check of the fix on the r1 counterexample (Brier, p=3/5, q=2/5, π₁=1/4): at λ=1, `Erep … 1 1 = 1 + (0.16-0.36)/0.2 = 0`, and π₁ ≠ 0, so `GrowFinite` fails at λ=1; λ=1 can no longer be the maximizer nor a competitor, removing the manufactured paper ERROR. The type of `IsGrowLambda` is unchanged (th=2282638952, bi=eeeee); only its value hash changed (vh 2908407024 -> 2939730787), as expected.

## A2 (drafter notes, false A01 compact-support claim) — IMPLEMENTED
`pv_work/notes/DEFS_draft_notes.md` l.6 no longer claims compact support; it now states that S_θ(p,0) and S_θ(p,1) are not compactly supported in (0,1), gives the θ^{-3} example, and records binding note N1 (IntegrableOn hypothesis). l.7 records the amendment log. Satisfactory.

## No other changes
Type-hash comparison with the r1 snapshot (DEFS_gate.md l.93-109): all 14 other declarations (`EGrowAll`, `EGrow`, `Erep`, `HAll`, `HS`, `IsConsistent`, `IsEValue`, `IsMixingMeasure`, `IsStrictlyConsistent`, `elemScore`, `expPi`, `growthRate`, `kappa`, `mixtureScore`) have identical th, vh and bi. Exactly one declaration was added (`GrowFinite`) and one changed in value (`IsGrowLambda`). No other change introduced.

## Binding notes N1-N4 of DEFS_gate.md remain in force for downstream gates.

## Statement snapshot (`#pv_type_hashes_here`, log `pv_work/logs/gate_DEFS_stmtcopy_r2_1.log`)
```
TYPE HASHES (current file, 16 declarations)
Paper.EGrowAll|def|th=3210013240|vh=205874597|bi=eee
Paper.EGrow|def|th=627210607|vh=1762649830|bi=eeeee
Paper.Erep|def|th=734155656|vh=2349602610|bi=eeeee
Paper.GrowFinite|def|th=2282638952|vh=2170676579|bi=eeeee
Paper.HAll|def|th=3190247120|vh=2880622674|bi=ee
Paper.HS|def|th=3099366798|vh=178991639|bi=eee
Paper.IsConsistent|def|th=3052518861|vh=2544694784|bi=e
Paper.IsEValue|def|th=917420136|vh=3209617066|bi=eee
Paper.IsGrowLambda|def|th=2282638952|vh=2939730787|bi=eeeee
Paper.IsMixingMeasure|def|th=3905129696|vh=830576263|bi=e
Paper.IsStrictlyConsistent|def|th=3052518861|vh=3921778172|bi=e
Paper.elemScore|def|th=3210013240|vh=1165710149|bi=eee
Paper.expPi|def|th=45857692|vh=4121383521|bi=ee
Paper.growthRate|def|th=734155656|vh=3036279142|bi=eeeee
Paper.kappa|def|th=262648148|vh=1721998326|bi=eee
Paper.mixtureScore|def|th=262648148|vh=2898287802|bi=eee
```

## Overall verdict
Both required changes implemented; no other change introduced.

STATEMENT GATE: PASS
