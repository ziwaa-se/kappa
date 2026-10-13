# P01 final audit (Proposition prop:gc, source/main.tex:45-51)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), Mon Oct 12 22:14:15 EDT 2026 (`date`).
- Audited object: `pv_work/P01.lean` (sha256 21d3b8f0b3b265615472d8249ad4d03d606b650a30f4dc923aec6144fb883924, rebuilt IDENTICAL). No ModGaps file, no Closed file.
- Read in full: `source/main.tex` (whole file, 76 lines), `pv_work/P01.lean`, `pv_work/P01Stmt.lean`, `pv_work/Defs.lean`, `verification/audits/P01_gate.md`, `pv_work/notes/P01_prover_notes.md`, `verification/EXTERNAL_TOOLS.md`, RESULTS.json entry P01, VERDICTS.md §1, §2, §4.
- Mechanical report: `verification/audits/P01_mech.md` (run by me), `MECH CHECKS: PASS`.
- Probe: `pv_work/probes/auditor/P01/auditor_P01_nonvac.lean`, `scripts/pv_lean.sh probe` exit=0 errors=0 sorry=0, log `pv_work/logs/auditor_P01_nonvac_3.log`.

## 1. Mechanical checks (from P01_mech.md)

| # | Check | Result |
|---|---|---|
| 1 | compile `P01` | PASS (exit 0, 0 sorry) |
| 2 | private rebuild sha256 | PASS IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | gated fingerprints (15) vs P01_gate.md | PASS identical |
| 5 | Defs vs DEFS_gate.md | PASS identical |
| 6 | `#pv_axioms P01` | PASS, ALL STANDARD |
| 7 | `#pv_walk P01` | PASS, no sorryAx; propext, Classical.choice, Quot.sound |
| 10 | `#pv_hyp_usage` | no UNUSED; WARNINGs only on the auto-generated structure projections `IsIIDSeq.ident/meas` (irrelevant) |
| 11 | TRACED CONDITIONS | `none` -- **incorrect, see §4**: an artefact of the parameter not being registered |

## 2. Gap files

None (no gaps). Not applicable.

## 3. Axioms and sorry

Only the three standard axioms; no `sorryAx` in the closure (items 6-7). The non-vacuity witness `iid_witness` also uses only `[propext, Classical.choice, Quot.sound]`.

## 4. Per-theorem conditionality

`#pv_hyp_usage` (re-run in my probe, log `auditor_P01_nonvac_3.log`):

| Theorem | hGC (`GlivenkoCantelli.{u}`) | Where actually used |
|---|---|---|
| `P01_S1` | USED | proof term is `hGC Ω P X h`: the whole step S1 (main.tex:50) is the application of the parameter |
| `P01_main` | USED | passed to `P01_S1`; actually used there |

No further walk needed: the proof term of S1 is literally the application of `hGC`.

**Records problem (not a Lean problem).** `Paper.P01.GlivenkoCantelli` is an external input approved by the gate (provenance (i), named at main.tex:50, no `\cite`), but it is **not registered** in `external_tools` of RESULTS.json nor in the EXTERNAL_TOOLS.md registry (`python3 scripts/pv_status.py tools` prints an empty table; it appears only under "Candidates from INVENTORY"). That is why the script reports `TRACED CONDITIONS: none`. I correct it: P01 really uses this parameter, so P01 is **CONDITIONAL**, never UNCONDITIONAL. The coordinator must register it before recording; I name it `GlivenkoCantelli` in the CONDITIONS line below (proposed id = Lean short name). Suggested registry entry: Lean `Paper.P01.GlivenkoCantelli` (pv_work/P01Stmt.lean:26-28); meaning "for every probability space and every i.i.d. real sequence, sup_t |F_n(t) - F(t)| -> 0 a.s."; type (i) (named, no `\cite`; arguably (ii)); source main.tex:50; used by P01 step S1; mathlib evidence: gate probe `pv_work/probes/gate/P01/gate_P01_mathlib_search.lean`; human check: compare the encoding with a textbook statement (i.i.d., real-valued, arbitrary F, a.s. uniform convergence). Human-check priority D (or B, since there is no `\cite`).

## 5. Infrastructure audit (no prior individual records; all audited here)

| Constant | Module | Judgement |
|---|---|---|
| `Paper.Defs.edf` | Defs | `(1/n) * #{i : x i ≤ t}` = def:edf (main.tex:24-26). n=0 junk value 0, outside source scope. PASS |
| `Paper.Defs.edfRV` | Defs | EDF of `(X 0 ω, …, X (n-1) ω)` = source `(X_1,…,X_n)` (main.tex:29-30), index shift documented. PASS |
| `Paper.Defs.cdfOf` | Defs | `P.real {X 0 ≤ t}` = distribution function of X_1 (main.tex:30-31), standard right-continuous reading. PASS |
| `Paper.Defs.Dn` | Defs | `⨆ t, |F_n - F|` (main.tex:30). Range is in [0,1] when P is a probability measure (also for n=0), so the real `⨆` is the true sup; no junk under P01's hypotheses. PASS |
| `Paper.P01.GCConclusion` | P01Stmt | `∀ᵐ ω ∂P, Dn → 0` = "D_n → 0 a.s." (main.tex:46). Definition only. PASS |
| `Paper.P01.IsIIDSeq`, `.mk` | P01Stmt | probability measure, measurable, `iIndepFun` (mutual independence), identically distributed with `X 0` = "i.i.d. random variables" (main.tex:46). No extra premise. PASS |
| `Paper.P01.GlivenkoCantelli` | P01Stmt | External input; true classical theorem, not stronger than the literature (no continuity of F needed in G-C), non-vacuous premise (witness below). PASS as a parameter, with the goal-shape remark in §6 |
| Helpers `P01_S1`, `P01_main` (item 9) | P01 | both are gated draft obligations (fingerprints identical to the gate's draft snapshot); one-line instantiations, no new mathematics. PASS |

All four Defs constants are definitions; none contain theorems or smuggle a conclusion. No other project constants in the closure.

## 6. Route fidelity and the goal-shaped parameter

| Source sentence | Lean | Ruling |
|---|---|---|
| main.tex:50 "This is the Glivenko--Cantelli theorem." | `P01_S1 := hGC Ω P X h` | faithful: the source's entire proof is an appeal to the named theorem; Lean instantiates it |
| main.tex:45-47 statement | `P01_main := P01_S1 …` (GCConclusion unfolds by `rfl`) | faithful |

No route change, no stronger result used, no FAIR_IMPLICIT_STEP filled in (there are no implicit steps; universe of Ω matches the parameter's universe).

**My judgement on VERDICTS §4.2 "goal-shaped".** Literally, the parameter `GlivenkoCantelli` *does* contain this result's conclusion (it is the proposition, universally quantified), so the letter of §4.2 is not met. I nevertheless agree with the gate that it is acceptable here, for these reasons: (a) the purpose of §4.2 is to stop the formalization from assuming what the paper argues; here the paper argues nothing -- its proof (main.tex:50) is solely the attribution to a named classical theorem, so any other encoding would invent a proof the source does not give (forbidden by POLICY §1); (b) §4.2 itself requires "do not re-prove external theory that the source only cites", which is exactly this case; (c) the parameter is no stronger than the literature theorem nor than the source's use. The consequence must be stated plainly in every report: **the Lean check of P01 has no mathematical content beyond confirming that the printed proposition is an instance of the encoded Glivenko-Cantelli statement**; the entire mathematical content lies in the human check of the parameter. P01 must be reported as CONDITIONAL on G-C and never as "verified" without that qualifier. This is a rules-interpretation point for the coordinator, not a paper issue. (Optional note, not a requirement: mathlib's `ProbabilityTheory.strong_law_ae` would allow discharging the parameter later; VERDICTS §4.2 does not ask for it.)

## 7. Non-vacuity

`pv_work/probes/auditor/P01/auditor_P01_nonvac.lean` (exit 0, no sorry, axioms standard):
- `iid_witness (μ) [IsProbabilityMeasure μ] : IsIIDSeq (Measure.infinitePi (fun _ => μ)) (fun k ω => ω k)` -- i.i.d. coordinates with an **arbitrary** law, proved via `infinitePi_pi`.
- Instances at `gaussianReal 0 1` (nontrivial) and `dirac 0` (degenerate).
- `P01_main hGC _ _ _ (iid_witness _)` applied to the Gaussian witness compiles.
The hypothesis class is therefore satisfiable by genuinely random sequences; the statement is not vacuous.

## 8. Status for the authors

Verified: Proposition 2.2 (prop:gc) is, as printed, an exact instance of the Glivenko-Cantelli theorem as encoded; the Lean proof is that instantiation and nothing more. It depends entirely on the unproved external input Glivenko-Cantelli (human check required). Source: statement true and correctly attributed; missing `\cite` for G-C is EDITORIAL only; no errors or gaps.

## FAIL items

none (the audited Lean artefacts pass). Records action required (not a FAIL of the proof): register `GlivenkoCantelli` in `external_tools` / EXTERNAL_TOOLS.md before recording; do not record UNCONDITIONAL on the basis of the script's `TRACED CONDITIONS: none`.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: GlivenkoCantelli
