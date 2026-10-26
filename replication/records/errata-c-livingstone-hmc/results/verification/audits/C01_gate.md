# C01 statement gate (Corollary 2.3, part (ii) only; revision-2 re-draft after the T01 re-gate)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5). Date: Tue Oct 13 11:28:35 EDT 2026 (`date`).
- Scope: part (ii) only (user-set). Part (i) (TEX:234, proof TEX:838-885) is not encoded and not reviewed.
- Previous gate: `verification/audits/rev1/C01_gate.md` (PASS) on `C01Stmt` 0e42cbb2…, `C01Draft` 85159b84…; these hashes are identical to `pv_work/superseded/rev1/C01Stmt.lean` / `C01Draft.lean`, which I used as the comparison base.
- Files reviewed (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/C01Stmt.lean` 1d3a5ff1f30817b010ce6bf52e8f1ea5a9df6ca18503210d5293908c4e180635
  - `pv_work/C01Draft.lean` 76e9955fe6fafe660bd2e0b08412492634910fa984acf89d4f03b04b54b79d82
  - `pv_work/notes/C01_draft_notes.md` db983dd3f815df942c5bb58b08a0b8d96450d774aca17bd975d168ce8c172988 (leads only)
  - imports read: `pv_work/T01Stmt.lean` 4f655659… (= hash in `T01_gate_r2.md`), `pv_work/L03Stmt.lean` 42fcf7cd…, `pv_work/T02Stmt.lean` 3413fed6…, `pv_work/Defs.lean` e573c173…; `pv_work/T01Draft.lean` (for `T01_main`).
- Compilation: `scripts/pv_lean.sh check C01Draft` gives `RESULT C01Draft mode=check exit=0 errors=0 sorry_warnings=10 nonstandard_axiom_lines=0 log=pv_work/logs/C01Draft_6.log`. 10 sorries = `C01_main` + S1a, S1b, S1c, S2, S3, S4, S5a, S5b, S6.
- Probes (all in `pv_work/probes/gate/C01/`): `gate_C01_stmtcopy.lean` (log `pv_work/logs/gate_C01_stmtcopy_3.log`, exit 0, 0 sorry), `gate_C01_draftcopy.lean` (log `gate_C01_draftcopy_3.log`, exit 0, 10 sorry), `gate_C01_r3shape.lean` (log `gate_C01_r3shape_2.log`, exit 0, 0 sorry, axioms propext/Classical.choice/Quot.sound only).

## Source quotations (read directly in source/geo_erg_HMC_v3.1.tex)

- TEX:208-219 Thm 2.2 (thm:negative): (i) `lim ‖∇U‖/‖x‖ = ∞` and (18), (19); (ii) `‖∇U(x)‖ ≤ M` for all x and `E_π[e^{s‖x‖}] = ∞` for every s>0; either rules out geometric ergodicity.
- TEX:223-227 class E(β,α); TEX:229-239 Corollary 2.3, (ii) at 238: "If β<1 or β>2, then the HMC method will not produce a geometrically ergodic chain", "under assumption A1" (230).
- TEX:895-908 thm:light: (17) at 897-899; (18) at 900-903 "a fixed C<∞ such that whenever ‖y‖ ≥ 3‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖"; (19) at 905-907 with 2^L; conclusion for fixed T = Lε.
- TEX:804-836 proof of (ii): β<1 via Thm 2.2(ii) (806); β>2: tail gradient (807-810), (17) (811-816), (18) with C>3M (817-824), (19) (825-834), "Theorem thm:light applies conditional on each fixed L" plus dominated convergence for A1 (834-836). Coordinator's ranges confirmed.

## What changed (textual diff against the gated rev1 files)

- `C01Stmt.lean`: added `import L03Stmt` and `open Paper.L03`; removed the local `def Paper.C01.HypOscillations3` (with its docstring), replaced by a plain comment. Nothing else.
- `C01Draft.lean`: added `open Paper.L03`; S4 docstring now names `Paper.L03.HypOscillations3`. Nothing else.
- In both files the identifier `HypOscillations3` now resolves to `Paper.L03.HypOscillations3` (no other `HypOscillations3` remains in scope; confirmed by the probe `consumed_from_T01Concl`, which type-checks only if C01's clause and `Paper.T01.HypPartI` use the same constant).

## Item 1. Hypotheses: PASS
Unchanged from rev1 (fingerprints of `InExpFam`, `C01_main` identical). The rev1 rulings stand: `InExpFam` matches TEX:223-226; `IsGradField`, `hπ`, `heps`, `hL` are standing conventions; dropping U ≥ 0 is EDITORIAL; no hidden or conclusion-shaped hypotheses.

## Item 2. Conclusion: PASS (scope note kept)
`C01Concl` identical (all 8 fingerprint lines unchanged). Deterministic L only; "under A1" (TEX:230, 834-836) not covered and must not be claimed. New remark: T01Stmt now also has a random-𝔏 form (`T01ConclRand`, `GeomErgodicRand` in T02Stmt), so the S6 docstring sentence "the project has no random-𝔏 kernel" is now stale (comment only, EDITORIAL; no change required for the gate). Encoding a random-𝔏 C01 would be a scope decision for the coordinator/user and would need a fresh gate.

## Item 3. Quantifiers and constants: PASS
Unchanged. The C in (18) is existential per gU (`∃ C` inside `HypOscillations3`), as at TEX:900.

## Item 4. Domains and details: PASS
Unchanged from rev1.

## Item 5. Step obligations: PASS (all true as stated)
Only S4's type changed (constant name `Paper.C01.HypOscillations3` → `Paper.L03.HypOscillations3`). The probe `old_local_eq` proves `Paper.L03.HypOscillations3 gU ↔ (∃ C, ∀ x y, 3‖x‖ ≤ ‖y‖ → C ≤ 3‖x‖ → 3‖gU x‖ ≤ ‖gU y‖)` by `Iff.rfl`, i.e. the old local text exactly, so S4's content is unchanged and the rev1 truth argument holds (C = 3·max(M,0)+1, ratio ≥ 3^{β-1} > 3 for β>2; old B02 does not recur). All other obligations are fingerprint-identical to rev1, and the rev1 truth rulings stand. Assembly unchanged: main = S1c (β<1) ∨ S6 (β>2).

## Item 6. Consumed clause `C01_T01Consumed`: PASS
- Content: (a) for d=1, all U, gU, ε>0, L≥1 with `IsGradField`, ∫π<∞: `HypExplode gU → Paper.L03.HypOscillations3 gU → HypOscillation2 U L → ¬GeomErgodic U gU eps L`; (b) same conventions, `HypPartII U gU → ¬GeomErgodic`.
- Faithful to Thm 2.2 as consumed. (a) is part (i) (TEX:213) with the **revised** (18) (TEX:900-903) and (19) as printed (TEX:905-907), same L, fixed T (TEX:908), as used at TEX:806/834. (b) is part (ii) (TEX:217), as used at TEX:806.
- Matches the re-gated T01 exactly: probe `consumed_from_T01Concl` derives `C01_T01Consumed` from `∀ U gU eps L, IsGradField → ∫π<⊤ → 0<eps → 1≤L → T01Concl U gU eps L` at d=1 (the conclusion that `T01_main` delivers under its conventions; `hd : 0 < 1` is trivial), and `T01Concl_from_consumed` gives the converse. So the clause is neither stronger nor weaker than T01's conclusion at d=1, deterministic L. This removes the rev1 caveat that clause (a) was independent of the stale `T01Stmt.HypPartI`.
- Provenance (p), predecessor T01, location `Paper.T01.T01_main` (`T01Concl.partI`/`partII`, T01Draft:17-23; T01Stmt:38-39, 42-44, 63-65), TEX:208-219. Applicability: (b) via S1a, S1b; (a) via S3, S4, S5b; conventions from the main binders. At reconnection T01_main's own parameters (`T01_T02Consumed` per instance, `Thm518`) are inherited transitively.
- Not goal-shaped (a general statement over all U, not C01's conclusion for this U). Declared in `C01Stmt.lean`, `namespace Paper.C01`, named `C01_T01Consumed`; no redeclared names (the local `HypOscillations3` is gone, so the earlier duplicate-content definition no longer exists).
- No mathlib-absence claims; no `#check` needed.

### Imported definitions (the earlier caution: imports are not locked by C01's hashes)
C01's `th/vh` hash constant names, not the content of imported constants. I therefore fingerprinted the imports directly (`gate_C01_r3shape_2.log`) and compared with earlier gates:

| Imported constant | current | earlier gate | status |
|---|---|---|---|
| `Paper.T02.GeomErgodic` | th=4031747299 vh=3856057058 | rev1/T02_gate.md:181, T02_gate_r2.md:55 | identical |
| `Paper.T02.targetMeas` | th=2842052545 vh=3780488904 | rev1/T02_gate.md:188, T02_gate_r2.md:67 | identical |
| `Paper.T01.HypPartII` | th=3957315956 vh=1173314425 | rev1/T01_gate.md:96, T01_gate_r2.md:69 | identical |
| `Paper.L03.HypOscillations3` | th=3371666640 vh=3973787725 | L03_gate.md:107 | identical (new import for C01) |
| `Paper.Defs.HypExplode` | th=3371666640 vh=1652790231 | DEFS_gate.md:76 | identical |
| `Paper.Defs.HypOscillation2` | th=2203084122 vh=3740005225 | DEFS_gate.md:77 | identical |
| `Paper.Defs.IsGradField` | th=3957315956 vh=2920123585 | DEFS_gate.md:80 | identical |
| `Paper.Defs.piDens` | th=4080827364 vh=90937034 | DEFS_gate.md:86 | identical |

Note: `vh` of `Paper.L03.HypOscillations3` (3973787725) differs from that of the removed `Paper.C01.HypOscillations3` (2544497906) although the text is identical; the `Iff.rfl` probe shows they are definitionally the same proposition. The caution remains for the future: a later change of any of these imported definitions would not show in C01's own fingerprints, so the final audit should re-compare the imported fingerprints in the table above (the `vh` of these constants still only lock one level; `GeomErgodic` depends on `hmcStep`, `tvDist`, etc., which are locked by the T02 gates).

## Item 7. Doubts about the source: no dispatch required
Unchanged from rev1: S1a, S1b (TEX:806, unwritten verifications) preliminary FAIR_IMPLICIT_STEP; TEX:834-836 random-𝔏 passage not encoded (scope), preliminary FAIR_IMPLICIT_STEP; old B02 does not recur under revised (18). No ruling on the paper.

## TFAs ruled on
| Premise | Ruling | Reason |
|---|---|---|
| (none proposed) | n/a | unchanged from rev1 |

## External parameters
| Name | Provenance | Ruling |
|---|---|---|
| `C01_T01Consumed` | (p), T01 = Thm 2.2 (TEX:208-219), location `Paper.T01.T01_main` / `T01Concl`; part (i) with revised (18) (TEX:900-903) | Approved (shown equivalent to `T01Concl` at d=1) |

## Required changes
None. (Optional, editorial: S6 docstring "the project has no random-𝔏 kernel" is stale since T02Stmt/T01Stmt now define random-𝔏 objects.)

## Fingerprint changes against the rev1 snapshot
| Declaration | rev1 | now | reason |
|---|---|---|---|
| `Paper.C01.C01_T01Consumed` | th=3944470172 vh=7859440 | th=3944470172 vh=2197237788 | body now refers to `Paper.L03.HypOscillations3` (expected) |
| `Paper.C01.HypOscillations3` | th=3371666640 vh=2544497906 | removed | replaced by the L03 constant (expected) |
| `Paper.C01.C01_S4` | th=3640951565 | th=2660159022 | goal now names `Paper.L03.HypOscillations3` (expected; content equal by `Iff.rfl`) |
| all other 18 lines (C01Concl and 7 auxiliaries, InExpFam, TailGrad, main, S1a, S1b, S1c, S2, S3, S5a, S5b, S6) | | identical | |

## Statement snapshot
Stmt copy `pv_work/probes/gate/C01/gate_C01_stmtcopy.lean` (log `pv_work/logs/gate_C01_stmtcopy_3.log`):
```
TYPE HASHES (current file, 11 declarations)
Paper.C01.C01Concl.casesOn|def|th=3193051509|vh=4189218261|bi=iiiiiiee
Paper.C01.C01Concl.mk|ctor|th=639128161|vh=-|bi=iiiiie
Paper.C01.C01Concl.noConfusionType|def|th=3488882267|vh=1443577468|bi=iiiiieee
Paper.C01.C01Concl.noConfusion|def|th=3124602264|vh=2208376827|bi=iiiiiiiie
Paper.C01.C01Concl.partII|thm|th=2894599874|vh=-|bi=iiiiiee
Paper.C01.C01Concl.recOn|def|th=3193051509|vh=1804189570|bi=iiiiiiee
Paper.C01.C01Concl.rec|rec|th=3320441646|vh=-|bi=iiiiiiee
Paper.C01.C01Concl|induct|th=864004865|vh=-|bi=eeeee
Paper.C01.C01_T01Consumed|def|th=3944470172|vh=2197237788|bi=
Paper.C01.InExpFam|def|th=1658877937|vh=365524624|bi=eee
Paper.C01.TailGrad|def|th=3334154647|vh=1193412124|bi=eeee
EXIT=0
```
Draft copy `pv_work/probes/gate/C01/gate_C01_draftcopy.lean` (log `pv_work/logs/gate_C01_draftcopy_3.log`):
```
TYPE HASHES (current file, 10 declarations)
Paper.C01.C01_S1a|thm|th=3960329011|vh=-|bi=iiiieee
Paper.C01.C01_S1b|thm|th=408516318|vh=-|bi=iiieeee
Paper.C01.C01_S1c|thm|th=227541489|vh=-|bi=iiiiiieeeeeee
Paper.C01.C01_S2|thm|th=3439575683|vh=-|bi=iiiiee
Paper.C01.C01_S3|thm|th=3964483344|vh=-|bi=iiiieee
Paper.C01.C01_S4|thm|th=2660159022|vh=-|bi=iiiieee
Paper.C01.C01_S5a|thm|th=109083080|vh=-|bi=iiieeee
Paper.C01.C01_S5b|thm|th=2451669095|vh=-|bi=iiieeee
Paper.C01.C01_S6|thm|th=1714459723|vh=-|bi=iiiiiieeeeeee
Paper.C01.C01_main|thm|th=3482317072|vh=-|bi=iiiiiieeeeee
EXIT=0
```

## Overall verdict
The redraft makes only the announced changes. `C01_T01Consumed` is faithful to Thm 2.2 (i) with the revised (18) and (ii), and is equivalent (Lean probe) to the re-gated `T01Concl` at d=1. S4 is unchanged in content. All imported definitions match their gated fingerprints. Scope: deterministic L only, "under A1" not covered.

STATEMENT GATE: PASS
