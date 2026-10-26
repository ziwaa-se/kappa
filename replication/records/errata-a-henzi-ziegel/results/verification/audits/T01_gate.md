# T01 statement gate (Theorem 3.1, `thm:uniqueness`)

- Reviewer: pv-gate (independent subagent; did not draft T01)
- Date: Mon Oct 12 22:14:17 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` 011685b5b1e5a9f9d221fb49cf0478b632e812be2257bd23085e5357d6b1c8f2
  - `pv_work/T01Draft.lean` ebc2cfe0bc57c84a4596f81e8df95191efd6161b8cfdee39f5c0915ada06dff8
  - `pv_work/Defs.lean` 1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c (gated in DEFS_gate_r2)
  - `pv_work/notes/T01_draft_notes.md` cdbdfdf1ed8aedc9846478896a6816527f00dc326ea4f1a6b05ba6779c365f7f (leads only)
  - `source/VSIFP_02.tex` f25f769a356f6227038989247eb86582023e96a59198eb0d84ddf41f27bf7bec
- Compilation: `scripts/pv_lean.sh check T01Draft` -> `exit=0 errors=0 sorry_warnings=11 nonstandard_axiom_lines=0`, log `pv_work/logs/T01Draft_2.log`.
- Probes (`pv_work/probes/gate/T01/`): `gate_T01_stmtcopy.lean` (exit=0, log `pv_work/logs/gate_T01_stmtcopy_1.log`), `gate_T01_draftcopy.lean` (exit=0, 11 sorry, log `pv_work/logs/gate_T01_draftcopy_1.log`), `gate_T01_S8cex.lean` (exit=0, 0 sorry, log `pv_work/logs/gate_T01_S8cex_1.log`).

## Source quotations (read directly)

- Statement, `source/VSIFP_02.tex:145-148`: "Let S be a consistent scoring function and p, q in (0,1), p != q. Assume that the mixing measure nu of S satisfies nu{[min(p,q), max(p,q))} > 0. Then a function E = E(y) is an e-value with null hypothesis H_S and alternative [0,1] \ H_S, if and only if for some lambda in (0,1], E(y) = E_{p,q;lambda}(y) = 1 + lambda (S(p,y) - S(q,y)) / |S(p,1{p>q}) - S(q,1{p>q})|."
- Consistency, l.71-74 (eq:scoring), for all p, pi in [0,1].
- Mixture, l.93-97: "under mild regularity conditions stated in [GR07, Thm 2.3], all consistent scoring functions are of the form S(p,y) = int_[0,1] S_theta(p,y) dnu(theta), where nu is a locally finite Borel measure on (0,1)"; elementary score l.98-105.
- H_S, l.139; e-value with null H and alternative H', l.142 (with E >= 0 from l.78).
- Proof l.402-427: l.403 sufficiency and E >= 1 - lambda >= 0; l.405 f; l.407 sign of d; l.409 eq:evalueCond; l.411-414 eq:ratio; l.417 rearrangement; l.419 "E(0) in (0,1)", lambda = 1 - E(0); l.421; l.423-426 "similar arguments" for p > q.

## Item 1. Hypotheses — PASS

- `hcons : IsConsistent S` = "consistent scoring function" (D01).
- `hrep : MixtureRep S ν`: the source statement speaks of "the mixing measure ν of S" (l.145), i.e. it presupposes that S has the representation eq:mixture. Taking ν and the representation as a hypothesis is therefore the statement as printed, not an extra assumption; the "mild regularity conditions" of l.93 concern only when such a ν exists, which the theorem presupposes. GR07 Thm 2.3 is not consumed, so it is correctly **not** an external parameter. The representation is required only for p in (0,1), y in {0,1}: this is weaker than the full printed representation (more S are admitted), which is fine. `hcons` is implied by `hrep` and is redundant but faithful.
- ν uniqueness: "the" mixing measure vs "some ν with MixtureRep" — harmless; on (0,1) ν is determined by S(·,0) (θ dν determined), and the theorem holds for any representing ν anyway.
- Integrability inside `MixtureRep`: TFA-1, approved (see table).
- `hp, hq, hpq, hν` match l.145 (`Ico (min p q) (max p q)` = `[min, max)`).
- No hidden hypotheses: `IsEValue`, `HS`, `Erep`, `expPi`, `IsMixingMeasure`, `mixtureScore` read in Defs.lean; no `variable`s, structures or type classes. No conclusion-shaped hypothesis in the main theorem.

## Item 2. Conclusion — PASS

`IsEValue E (HS S p q) (Icc 0 1 \ HS S p q) ↔ ∃ lam ∈ Ioc 0 1, ∀ y ∈ {0,1}, E y = Erep S p q lam y`. Both directions, λ range (0,1], alternative `[0,1] \ H_S`, denominator `|d(1{p>q})|` (`if q < p then 1 else 0`) match l.145-148. Equality only on y in {0,1} is the Defs convention (E = E(y) on the binary outcome). `IsEValue` includes E >= 0 (l.78). Checked by hand that the statement is true: E_π E_{p,q;λ} = 1 + λ f(π)/|d(k)|, giving sufficiency; for necessity, g(π) = E_π E - 1 and f are affine with the same sign pattern on [0,1] and f has an interior zero, so g = c f with c > 0, and E(k) >= 0 gives λ = c|d(k)| in (0,1].

## Item 3. Quantifiers and constants — PASS

No constants. S, ν, p, q, E universally quantified as in the source; λ existential after E.

## Item 4. Domains and details — PASS

Integral over `Icc 0 1` w.r.t. ν carried by (0,1) (IsMixingMeasure), as l.95/97. No a.e. issues, no ENNReal truncation beyond `0 < ν (...)` (an ENNReal comparison, faithful). Outcomes restricted to {0,1} consistently.

## Item 5. Step obligations — PASS (faithful), with one obligation FALSE AS STATED (S8, written as printed)

| Step | Source | Faithful | True as stated |
|---|---|---|---|
| S1 | l.403 | yes | yes (d(k) < 0 for k = 1{p>q}, other value > 0) |
| S2 | l.403 "easily verify" | yes | yes |
| S3 | l.407 | yes | yes (d(0) = -∫_[p,q) θ dν, d(1) = ∫_[p,q)(1-θ) dν; needs integrability, supplied by TFA-1) |
| S4 | l.405-407 | yes | yes (π₀ = -d0/(d1-d0)) |
| S5 | l.407-409 | yes | yes |
| S6 | l.411-414 | yes | yes (affine comparison; E(1) ≠ E(0) follows) |
| S7 | l.415-418 | yes | yes (parse `1 - ((1-E0)*d1)/d0` matches l.417) |
| S8 | l.419 | yes, as printed | **NO — false as stated** |
| S9 | l.419-421 | yes | yes (with the Ioo hypothesis) |
| S10 | l.423-426 | yes ("similar arguments") | yes |

**S8 counterexample** (compiled, `pv_work/probes/gate/T01/gate_T01_S8cex.lean`, exit=0, no sorry): d(0) = -1, d(1) = 1, E(0) = 0, E(1) = 2 (this is E_{p,q;1}). All hypotheses `hd`, `h`, `hr` hold; `E 0 ∉ Ioo 0 1`. In terms of the paper: λ = 1 (allowed by the theorem, and by l.403 a valid e-value) gives E(0) = 0, so "E(0) ∈ (0,1)" at l.419 is false; only E(0) ∈ [0,1) follows. This is written as printed, which is the correct encoding (no repair at the gate). Consequence for the prover: stop at S8 and record it; S9 is proved as stated (it is true with the Ioo hypothesis) but cannot be fed by S8 for E(0) = 0. S10 ("similar arguments") reproduces the analogous step (E(1) ∈ (0,1) for p > q), with the same defect; the prover should record that, not silently use the corrected range.

No obligation smuggles the target conclusion: S10 is an obligation (to be proved), not a hypothesis, and it is exactly the necessity direction for q < p that l.423-426 asserts. Assembly: main ⇐ S2 (sufficiency) + [p < q: S3 (with min/max reduced), S5, S6, S7, S8, S9, `Ioo ⊆ Ioc` for λ = 1 - E(0), and Erep denominator `|d(0)|` since ¬(q < p)] + [q < p: S10]. The assembly is logically sound; it is blocked only by the false S8.

## Item 6. External parameters — PASS (none)

No `def … : Prop` parameter. `MixtureRep` is a statement hypothesis encoding the printed premise "the mixing measure ν of S", declared in `T01Stmt.lean`, `namespace Paper.T01`, no name clash. No "mathlib does not have it" claims to check.

## Item 7. Doubts about the source — recorded, not ruled

- `source/VSIFP_02.tex:419`: "E(0) ∈ (0,1)" excludes E(0) = 0 (λ = 1), which the theorem's λ ∈ (0,1] includes; the correct consequence is E(0) ∈ [0,1). Conclusion of the theorem is unaffected (true). Preliminary class: `PAPER_ARGUMENT_GAP` (minor; possibly to be judged `EDITORIAL` by the issue checker). Same defect implicit at l.423 for p > q. Recommend dispatching pv-issue-checker.
- Drafter's note on log score / integrability (notes l.35): not a paper issue; covered by TFA-1 (integrand ≥ 0, S real-valued).

## TFAs ruled on

| id | premise | ruling | reason |
|---|---|---|---|
| TFA-1 | `IntegrableOn (fun θ => elemScore θ p y) (Icc 0 1) ν` for p in (0,1), y in {0,1}, inside `MixtureRep` | APPROVED | For θ in [0,1], S_θ(p,y) >= 0 and is measurable in θ, so the integral of l.95 is a Lebesgue integral in [0,∞]; the paper's S is real-valued, so it is finite, i.e. integrable. Excludes only the Bochner junk value 0, not a case the source discusses. |

## External parameters

| name | provenance | ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

`gate_T01_stmtcopy.lean` (`pv_work/logs/gate_T01_stmtcopy_1.log`):
```
TYPE HASHES (current file, 1 declarations)
Paper.T01.MixtureRep|def|th=889021459|vh=1663983606|bi=ee
```

`gate_T01_draftcopy.lean` (`pv_work/logs/gate_T01_draftcopy_1.log`):
```
TYPE HASHES (current file, 11 declarations)
Paper.T01.T01_S10|thm|th=2059191271|vh=-|bi=eeeeeeeeeeee
Paper.T01.T01_S1|thm|th=1366810051|vh=-|bi=eeeeeeeeeeeeee
Paper.T01.T01_S2|thm|th=2895650263|vh=-|bi=eeeeeeeeeeee
Paper.T01.T01_S3|thm|th=3502036374|vh=-|bi=eeeeeeeeee
Paper.T01.T01_S4|thm|th=1577209521|vh=-|bi=eeee
Paper.T01.T01_S5|thm|th=3109485430|vh=-|bi=eeeee
Paper.T01.T01_S6|thm|th=1578373896|vh=-|bi=eeeeee
Paper.T01.T01_S7|thm|th=1201098239|vh=-|bi=eeeeeee
Paper.T01.T01_S8|thm|th=4195242672|vh=-|bi=eeeeeee
Paper.T01.T01_S9|thm|th=2156561477|vh=-|bi=eeeeeeeee
Paper.T01.T01|thm|th=1029269944|vh=-|bi=eeeeeeeeeee
```

## Overall verdict

The statement is faithful; the obligations are faithful to the printed proof. S8 is false as stated because it reproduces the printed step at l.419; that step is recorded as a suspected paper issue and is not repaired. Proof work may begin, and the prover must stop at S8.

STATEMENT GATE: PASS
