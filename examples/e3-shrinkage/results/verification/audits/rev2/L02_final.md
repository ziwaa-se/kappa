# Final audit: L02 (Lemma lem:min, source/main.tex:48-56)

- Auditor: pv-auditor (claude-opus-5-5), Mon Oct 12 22:13:58 EDT 2026 (from `date`)
- Audited object: `pv_work/L02ModGaps.lean` (gap file), sha256 `01fd3622d15f08a8d4b5bef18ad1cd71ff08dfbb73a70d149a80ec53dcade0e6`; companion `pv_work/L02.lean` (sha256 `094cb54a…bbea8`, `sorry` in S2); `pv_work/L02Stmt.lean` sha256 `8c2d7440…885a` = gate.
- Source read directly: main.tex:25 (standing assumption), 32-33 (ρ), 48-56 (statement and proof).
- Read in full: `L02ModGaps.lean`, `L02.lean`, `L02Stmt.lean`, `L02Draft.lean`, `Defs.lean`, prover notes, gate report, issue ruling `L02_issue_1.md`.

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py L02 --module L02ModGaps`, run by me)

Report `verification/audits/L02_mech.md`: `MECH CHECKS: PASS (2 manual checks listed above)`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L02ModGaps` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs gate (8 gated decls) | PASS |
| 4b | gap definitions | MANUAL, resolved in §2 below |
| 5 | Defs vs DEFS_gate | PASS |
| 6 | `#pv_axioms` | ALL STANDARD |
| 7 | `#pv_walk`: sorryAx | not reached; axioms propext, Classical.choice, Quot.sound |
| 11 | traced conditions | none |
| 12 | last writers | pv-prover / pv-drafter, PASS |

## 2. Gap file, §2b exact-statement method

Probe `pv_work/probes/auditor/L02/auditor_L02_gapcheck.lean` (sha256 `54976308…3cc2`), `scripts/pv_lean.sh probe` → `exit=0 errors=0 sorry_warnings=3` (the three redeclared statements), log `pv_work/logs/auditor_L02_gapcheck_1.log`.

| Check | Result |
|---|---|
| `L02_S2` redeclared verbatim (from gated draft), th | 2070248410 = snapshot |
| `L02_S3` redeclared verbatim, th | 530875162 = snapshot |
| `L02` redeclared verbatim, th | 143933708 = snapshot |
| `example : L02_S2_Gap = type_of% @L02_S2 := rfl` | compiles |
| `example : L02_S3_Gap = type_of% @L02_S3 := rfl` | compiles (vh≠th explained by the `_proof_1` numeral exception) |
| `example (g3 : L02_S3_Gap) : type_of% @L02 := L02_mod_gaps g3` | compiles |
| `L02.lean` vs gap file | S1, S4 identical text; S2 = `sorry` (only sorry, l.12, log `pv_work/logs/L02_2.log`); S3 proved from S2 (gap-dependent, replaced by `L02_S3_Gap`); main = `le_trans S3 S4`, identical to `L02_mod_gaps` with S3 as hypothesis. Matches. |

`L02_S2_Gap` is declared but not a premise of `L02_mod_gaps`: correct, since S2 enters the main theorem only through S3 (L02.lean:20). Not an issue.

## 3. Hypothesis usage (step 4)

| Theorem | Hypothesis | Usage |
|---|---|---|
| `L02_mod_gaps` | `hGap_3 : L02_S3_Gap` | USED (gap, not a condition) |
| `L02_mod_gaps` | θ, σ, `h : Setting` | USED |
| `L02_S1`, `L02_S4` | `h : Setting` | UNUSED (standing assumption l.25 carried by the gated statement; the identities hold without it; not an external parameter, no action) |

No external parameters. TRACED CONDITIONS: none, confirmed.

## 4. Infrastructure (item 8; item 9 empty)

| Constant | Record | Status |
|---|---|---|
| `Paper.Setting`, `Paper.Setting.mk`, `Paper.oracleRisk` | DEFS_gate.md (named, PASS) | definitions only |
| `Paper.L02.Conclusion`, `HarmonicLeMin`, `harmonicMean` | L02_gate.md (named, PASS) | definitions only |
| `Paper.L02.harmonicMean._proof_1` | auto-generated numeral proof for `harmonicMean` | covered by L02_gate |

No theorem from another result is consumed; no helper lemmas outside the snapshot.

## 5. Route fidelity (main.tex:53-55)

| Source sentence | Lean | Ruling |
|---|---|---|
| l.53 "ρ is half the harmonic mean 2θ²σ²/(θ²+σ²)" | `L02_S1`: `unfold; ring` | faithful |
| l.54 "harmonic mean of two positive numbers is at most the smaller" | `L02_S2` = `HarmonicLeMin`, STOPPED (false: a=1,b=4, HM=8/5>1) | gap `L02_S2_Gap`; not repaired |
| l.54-55 "so ρ ≤ ½ min{θ²,σ²}" | `L02_S3` from S2 at (θ²,σ²) + S1 (L02.lean); gap `L02_S3_Gap` in gap file (false: θ=1,σ=2, ρ=4/5>1/2) | faithful; depends on stopped S2 |
| l.55 "½ min ≤ min" | `L02_S4`: min ≥ 0 by `sq_nonneg`, `linarith` | faithful |
| chain | `le_trans S3 S4` | source route; no alternative route, no stronger result |

FAIR_IMPLICIT_STEP: (a) θ², σ² > 0 from l.25 (`positivity` on `theta_ne`, `sigma_pos`) to apply l.54 "positive numbers"; (b) min{θ²,σ²} ≥ 0 for "½ min ≤ min" (`le_min` + `sq_nonneg`).

I confirm independently the two falsities by arithmetic: 2·1·4/5 = 8/5 > 1 = min(1,4); ρ(1,2) = 4/5 > 1/2 = ½·min(1,4). The lemma's conclusion itself is true (HM ≤ 2·min), so the issue is in the argument only. Ruling `L02_issue_1.md` (PAPER_ARGUMENT_GAP) has counterexample review `L02_issue_1_audit.md` ending `COUNTEREXAMPLE VALID`.

## 6. Non-vacuity

In the probe: `Setting 1 2` and `Setting (-3) (1/2)` constructed (θ² ≠ σ², negative θ); `L02_S1` and `L02_S4` instantiated at these witnesses; all compile.

## 7. Status for the authors

Verified: ρ = ½·HM(θ²,σ²) (l.53) and ½ min ≤ min (l.55); the gap file is exactly "S3 gap → L02 statement", clean axioms, no external parameters.
Not verified: the source route stops at l.54, whose claim "HM ≤ min" is false (it is ≥ min), and the printed bound ρ ≤ ½ min (l.55) is false whenever θ² ≠ σ².
Assessment: PAPER_ARGUMENT_GAP; the printed conclusion ρ ≤ min{θ²,σ²} is true, so downstream uses of it (T01, C01) are not threatened in content.

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: none
