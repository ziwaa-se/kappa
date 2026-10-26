# Final audit: T01 (Theorem 2.2, thm:negative, TEX:208-219)

Auditor: pv-auditor (session 13bf576d), 2026-10-13 11:34. Audited objects: `pv_work/T01.lean`, `pv_work/T01ModGaps.lean`. Source read directly: TEX:200-221, Thm 5.14 TEX:893-941, Thm 5.18 TEX:1100-1121. Gate: `verification/audits/T01_gate_r2.md` (STATEMENT GATE: PASS). Probe: `pv_work/probes/auditor/T01/final_T01_probe.lean`, log `pv_work/logs/final_T01_probe_1.log` (exit 0, 0 errors, 0 sorry, standard axioms).

## 1. Mechanical checks (run by me)

| Run | Report | Result |
|---|---|---|
| `pv_audit_mech.py T01 --module T01ModGaps` | `verification/audits/T01_mech.md` | items 1-3, 5-7, 12 PASS; item 4 FAIL: S1, S2, S3, SR1, SR3, main "missing" |
| `pv_audit_mech.py T01` | `verification/audits/T01_mech_r2.md` | items 1-3, 5-7, 12 PASS; item 4 FAIL: only `T01_main_randL` "missing" |

Item 4 is resolved by combining the two runs; I did not accept it on trust:
- Run 1 lists as missing the six declarations that live in the imported module `T01.lean`.
- Run 2 finds those six fingerprint-identical to the gate snapshot.
- The only declaration missing from both is `T01_main_randL`. It was renamed `T01_main_randL_mod_gaps` because of the gap, and I checked it by the §2b `example` method (section 2).

So all 32 gated declarations are accounted for. The two FAILs are an artefact of splitting the result into two modules, not a statement change. I record that here openly instead of silently overriding it.

Other mechanical results:
- Rebuild sha256 IDENTICAL for both modules.
- PVTools hash OK.
- Defs identical to DEFS_gate.
- `#pv_axioms`: ALL STANDARD for both modules.
- `#pv_walk`: `sorryAx` not reached.
- No helpers outside the snapshot.

## 2. Gap file (§2b)

| Check | Result |
|---|---|
| `T01_main_randL_mod_gaps hGap` has exactly the gated type of `T01_main_randL` (copy from T01Draft:57-62) | PASS (probe `example`, compiles) |
| The gated statement implies `T01_main_randL_partI_Gap` (via `.partI`), so the gap is no stronger than the stopped field | PASS (probe `example`) |
| `T01.lean` = gap file minus the stopped obligation | PASS: S1, S2, S3, main, SR1, SR3 are in `T01.lean`, unchanged against the snapshot. `T01_main_randL` exists only as `_mod_gaps`. No other gap-dependent obligation |
| Gap is the field `partI` of `T01ConclRand`, not an `S<k>`, so there is no `th` to compare | noted. The two `example`s above replace that comparison |

## 3. Per-theorem conditionality (`#pv_hyp_usage`, `#pv_walk_decl`)

**`T01_main` (deterministic L):** all 12 binders are USED.
- `hT02 : T01_T02Consumed` is used in S1 (part (i)), where it is applied directly: TEX:213 = Thm 5.14.
- `hE3 : Thm518` is used in S3 (part (ii)), where it is destructured at `obtain ⟨s, hs, hfin⟩ := hE3 …`.
- Positive control: `#pv_walk_decl T01_S3` reaches `Paper.T01.Thm518` via `[T01_S3]`.
- `T01_main` reaches `T01_T02Consumed` via `[T01_main, T01_S1]` and `Thm518` via `[T01_main, T01_S3]`.

**`T01_main_randL_mod_gaps` (random 𝔏):** all binders are USED at the first level, but the uses differ.
- `hGap` gives `partI` (the stopped item).
- `hT02R : T01Rand_T02Consumed` is only passed to `hGap` (proof term `hGap U gU eps Lmeas hT02R hE3R …`). It therefore enters only through the gap, and does not support any proved part.
- `hE3R : Thm518Rand` gives `partII` via `T01_SR3`. SR3 `#pv_hyp_usage` shows `hE3R` USED and destructured. Positive control: the walk of `T01_SR3` reaches `Thm518Rand`.
- `T01_SR1` (uses `hT02R` and `hA1`) is proved, but it is not in the closure of the main theorem (by design, see X2).

**Correction to the script's `TRACED CONDITIONS`.** The script reported `T01_Thm518` and `T01_Thm518Rand` as "not reached". That is wrong: the registry ids `T01_Thm518`/`T01_Thm518Rand` do not match the Lean names `Paper.T01.Thm518`/`Thm518Rand`, and the walk above shows that both are reached and used.

| Theorem | Real conditions (step / clause) |
|---|---|
| `T01_main` | `T01_T02Consumed` → S1 / clause (i); `T01_Thm518` → S3 / clause (ii) |
| `T01_main_randL` | partII: `T01_Thm518Rand` → SR3 / clause (ii). partI: **gap** (X2). `T01Rand_T02Consumed` is reached only through the gap |

## 4. Infrastructure (item 8)

| Module / constants | Record | Judgement |
|---|---|---|
| `Defs` (13) | DEFS_gate.md; `IsGradField` individually PASS in T02_final.md | covered |
| `L03Stmt.HypOscillations3` | L03_final.md | covered |
| `T02Stmt` (`GeomErgodic(Rand)`, `hmcStep(Rand)`, `hmcPow(Rand)`, `A1Law`, `gaussMeas`, `targetMeas`) | T02_final.md | covered |
| `T01Stmt`: `HypPartI`, `HypPartII`, `T01Concl`, `HypPartIRand`, `T01ConclRand`, `T01_T02Consumed`, `T01Rand_T02Consumed`, `Thm518`, `Thm518Rand` | gate only; **audited here** | PASS, details below |
| `T01`: `T01_S1`, `T01_S2`, `T01_S3`, `T01_SR1`, `T01_SR3`, `T01_main` | **audited here** | PASS, details below |

Judgements on the `T01Stmt` definitions:
- **`HypPartI`** = (17) ∧ (18) revised (TEX:900-903) ∧ (19) with the same L. This matches TEX:213, which cites the labels of Thm 5.14.
- **`HypPartII`** = `∃M, ‖∇U‖≤M` ∧ `∀s>0, E_π e^{s‖x‖}=∞`. This is TEX:217 word for word.
- **`Thm518`** is TEX:1104-1108 specialised to fixed L, for every ε and L ≥ 1. This is weaker than the printed theorem and has no conclusion smuggled in.
- **`Thm518Rand`** is the random-𝔏 reading. The source proof (TEX:1111-1121) covers only fixed L, so this is an external input with human check (already registered).
- **The consumed clauses** are implications on the clause hypotheses, so they do not make part (ii) vacuous. Probe §4 shows that `T01_T02Consumed` follows from `T02_main` given T02's own parameters.
- **`T01_S1`–`T01_main`:** each has standard axioms and is a one- or two-line term.

## 5. Route fidelity

The source gives no proof of Thm 2.2. Its route is the identification (i) = Thm 5.14 and (ii) = Thm 5.18 (§5).

| Step | Source | Lean | Classification |
|---|---|---|---|
| S1 | TEX:213 ≡ Thm 5.14 TEX:895-908 (same labels (17)-(19); "any choice T>0") | `hT02 …` | identification not printed: X3, a separate issue item, not a proof defect. The hypotheses coincide literally |
| S2 | TEX:217 `≤M` vs TEX:1104 `<M` | `M+1`, linarith | FAIR_IMPLICIT_STEP (filled in with M+1) |
| S3 | TEX:217 with TEX:1104-1108, read contrapositively | `hE3 …`, then `rw [hinf s hs]`, then `lt_irrefl` | faithful. The step from "necessary condition" to the contrapositive is a FAIR_IMPLICIT_STEP |
| SR3 | the same, for random 𝔏 | `hE3R`, S2 | faithful, relative to `Thm518Rand` |
| partI (rand) | TEX:209 states no law; TEX:934-940 says only "as in Assumption A1" | **stopped** (gap) | X2, suspected EXPOSITION_GAP / PAPER_ASSUMPTION_GAP. Being ruled in `T01_issue_1.md` |

The route was not changed. No stronger result was used, no private helpers exist, and no gap was dressed up as a technical detail: `A1Law` was not added to `T01_main_randL`, which respects the gate.

## 6. Non-vacuity (probe §5)

Witness: d=1, U=‖x‖⁴/4, ∇U=‖x‖²x, ε=1, L=2. The witness lemmas are copied from the T02 final probe.
- `nonvac_main : Prop35 → GaussFacts → Thm518 → ¬GeomErgodic (UW 1) (gW 1) 1 2`. All concrete premises of `T01_main` are met, and the hypothesis of clause (i) holds; the consumed clause is discharged by `T02_main`.
- `nonvac_randL_partII`: 𝔏=(δ₁+δ₂)/2 meets `IsProbabilityMeasure` and `𝔏{0}=0`, and `T01_SR3` applies.
- Both have axioms propext, Classical.choice, Quot.sound.
- Not constructed: a concrete `HypPartII` witness (e.g. Cauchy). That is a statement about how meaningful the clause is, not about vacuity of the theorem premises.

## 7. Records to correct

- In `EXTERNAL_TOOLS.md`:
  - `T01_Thm518`: the location is stale (T01Stmt.lean:25, actual 29), and the check text cites TEX:978-984/986-996 instead of TEX:1103-1109/1111-1121. Its "used by" column says "not a condition of any result"; it should say: T01_main S3.
  - `T01_Thm518Rand`: should say used by T01 rand-L partII (SR3).
  - `T01_T02Consumed`: should say used by T01_main S1.
  - `T01Rand_T02Consumed`: should say reached only through the X2 gap, so not a condition.
- Script tracing misses these ids because the registry id does not equal the Lean name.

## 8. Status for the authors

- Verified: Thm 2.2 for deterministic L, both parts, relative to Thm 5.14 (T02 clause) and Thm 5.18 (external input), and part (ii) for random 𝔏, relative to the random-L reading of Thm 5.18.
- Not verified: part (i) for a general law 𝔏, stopped at X2. TEX:209 states no condition on 𝔏, and the only support (TEX:934-940) requires A1.
- Source: (i)/(ii) are never explicitly identified with Thms 5.14/5.18 (X3). The mismatch of `≤M` versus `<M` is harmless.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNFINISHED
CONDITIONS: T01_T02Consumed, T01_Thm518, T01_Thm518Rand
