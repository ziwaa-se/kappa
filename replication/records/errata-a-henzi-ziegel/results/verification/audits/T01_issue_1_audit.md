# T01 issue 1: counterexample review (pv-auditor)

- Role: pv-auditor (independent; did not draft, gate, prove or rule T01)
- Started: Mon Oct 12 22:44:01 EDT 2026 (from `date`)
- Audited: `pv_work/T01_Counterexample1.lean` (sha256 `1b15ec0a04133484be99987c6ff23b65d1a78837a303ae6b8461e659d7308427`, matches the ruling), ruling `verification/audits/T01_issue_1.md`
- Source read directly: `source/VSIFP_02.tex` l.70-106 (scoring, eq:mixture, eq:elementary), l.137-149 (H_S, e-value definition, Theorem 3.1), l.402-427 (proof).

## 1. Encoding fidelity (decisive item)

Source clause, l.419 (context l.403-418): case p < q (l.403); E an e-value under H_S with alternative H_S^c, i.e. E(y) ≥ 0 and eq:evalueCond (l.407-409); then "It follows from eq:evalueCond and eq:ratio that E(0) ∈ (0,1)". The theorem's hypotheses (l.145) are in force throughout the proof.

| Component of `PrintedClause_l419` | Source | Match |
|---|---|---|
| `IsConsistent S` (gated Defs D01: eq:scoring for all p, π ∈ [0,1]) | l.145 "consistent scoring function", l.70-74 | yes |
| `MixtureRep S ν` (gated T01Stmt: ν locally finite on (0,1), S = ∫ S_θ dν on p ∈ (0,1), y ∈ {0,1}, TFA-1 integrability approved by gate) | l.145 "mixing measure ν of S", l.94-97 | yes |
| p, q ∈ Ioo 0 1 | l.145 | yes |
| p < q (implies p ≠ q) | l.403 case assumption | yes (an extra case premise; allowed) |
| 0 < ν(Ico (min p q) (max p q)) | l.145 | yes |
| `IsEValue E (HS S p q) (Icc 0 1 \ HS S p q)` | l.142, l.145, l.407-409 | yes |
| conclusion `E 0 ∈ Ioo 0 1` | l.419 "E(0) ∈ (0,1)" | verbatim |

- No printed premise dropped; the only additional premise is the case split p < q, which the source itself makes. Conclusion not strengthened (identical open interval). The clause is universally quantified over E exactly as the proof needs it ("Let E = E(y) be an e-value ...", l.407): the proof must derive E(0) ∈ (0,1) for every such E.
- Constructed vs global objects: S, ν, p, q are the theorem's parameters; E is arbitrary within the e-values of the stated null/alternative; d_{p,q} and f are constructed from S, p, q (not appearing in the Lean clause except through `HS`, which is gated D11). No global object is fixed wrongly.
- Gated definitions used unchanged: `IsConsistent`, `IsMixingMeasure`, `mixtureScore`, `elemScore`, `HS`, `IsEValue`, `expPi`, `Erep` (Defs, DEFS gate r2 PASS) and `MixtureRep` (T01Stmt, T01 gate PASS). Re-typed independently by the auditor and checked by `Iff.rfl` (probe below).
- Scope link: `printed_of_S8Gap : T01_S8_Gap → PrintedClause_l419` shows the printed clause is a consequence of the gate-approved obligation S8, so refuting it also refutes S8 (`not_S8Gap`); the refuted clause is not stronger than what the proof consumes.

## 2. The instance satisfies every printed hypothesis

Instance: ν = δ_{1/2}, S = ∫_{[0,1]} S_θ dν = S_{1/2}, p = 1/4, q = 3/4, E = E_{p,q;1}.

| Hypothesis | Check (auditor's own hand computation; Lean lemma) |
|---|---|
| S consistent (eq:scoring, l.72-74) | S_{1/2} is an elementary score, consistent for all p, π ∈ [0,1]: E_π S(p,Y) − E_π S(π,Y) ≥ 0 case by case (`S0_cons`) |
| ν is the mixing measure of S (l.94-97) | δ_{1/2} is a finite Borel measure carried by (0,1), so locally finite on (0,1); S0 is *defined* as `mixtureScore ν0` (`rfl` in probe); integrability trivial for a Dirac measure (`S0_rep`, `ν0_mixing`) |
| p, q ∈ (0,1), p ≠ q, p < q | 1/4, 3/4 |
| ν{[1/4, 3/4)} > 0 | = 1 (`ν0_pos`) |
| E e-value, null H_S, alternative [0,1]\H_S | d(0) = S(1/4,0) − S(3/4,0) = 0 − 1/2, d(1) = 1/2 − 0; f(π) = π − 1/2, H_S = [0,1/2]. E(0) = 1 + (−1/2)/(1/2) = 0, E(1) = 2; E ≥ 0; E_π E = 2π ≤ 1 ⟺ π ≤ 1/2. Proved twice: by the ruling via `T01_S2` (`E0_evalue`) and **independently by the auditor directly from the definitions, without `T01_S2`** (probe) |

- Nothing in the source excludes the instance. E ≥ 0 is the only sign requirement on e-values (l.78, l.407), so E(0) = 0 is admissible; Theorem 3.1 explicitly admits λ = 1 (l.145, "λ ∈ (0,1]"), and l.403 itself notes E(1{p>q}) = 1 − λ ≥ 0, which is 0 for λ = 1. "Consistent" (not strictly consistent) is all that is required (l.145); δ_{1/2} also meets "locally finite Borel measure on (0,1)" (l.97). The condition ν{[min, max)} > 0 is the only condition on ν in the theorem.
- So "E(0) ∈ (0,1)" fails at an e-value that the proof must cover: E(0) = 0.

## 3. The counterexample itself is proved

| Check | Result |
|---|---|
| File hash | `1b15ec0a…8427` = hash quoted in the ruling (`python3 scripts/pv_snapshot.py hash`) |
| Private rebuild `T01ModGaps` | `REBUILD … exit=0 … IDENTICAL` (sha256 `6b937424…191f`) |
| Private rebuild `T01_Counterexample1` | `REBUILD … exit=0 … IDENTICAL` (sha256 `bf8f2a43…580f`); log has one linter style warning only, no `sorry` |
| `#pv_axioms T01_Counterexample1` | ALL STANDARD (24 declarations) |
| `#pv_axioms T01ModGaps` | ALL STANDARD (15 declarations) |
| `#pv_walk T01_Counterexample1` | 29 roots; closure axioms `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false` |
| Gated fingerprints | Defs (`Erep`, `HS`, `IsConsistent`, `IsEValue`, `IsMixingMeasure`, `elemScore`, `expPi`, `mixtureScore`) identical to `DEFS_gate_r2.md`; `MixtureRep` identical to `T01_gate.md`; `T01_S1`–`S7`, `S9` `th` identical to the gate draft snapshot; `T01_S8_Gap` `vh=4195242672` = gate `T01_S8 th`; `T01_S10_Gap` `vh=2059191271` = gate `T01_S10 th` |

Probe: `pv_work/probes/auditor/T01/auditor_T01_cex1.lean` (logs `pv_work/logs/auditor_T01_cex1_1.log` for axioms/walk/hashes, later runs for the auditor's own `example`s; see below).

Infrastructure used (no T01 final audit exists yet, so audited here on the spot):

| Constant (T01ModGaps) | Used by | On-the-spot review |
|---|---|---|
| `T01_S2` (+ `T01_S1`, `cfacts`, `dsign`, `key`, `pos_int`, `erep_eq`, `cmem`, `cc`) | `E0_evalue`, `mirror_evalue` | Statements true (sufficiency of l.403, sign facts of l.407); proofs read in full; standard axioms; gate-matching statement. In any case the decisive fact `IsEValue E0 …` is re-proved by the auditor **without** `T01_S2` |
| `T01_S3`, `T01_S5`, `T01_S6` | `printed_of_S8Gap` only (scope check) | Statements gate-matched; proofs read; true; standard axioms |
| `T01_S8_Gap` (def) | `printed_of_S8Gap`, `not_S8Gap` | A `Prop`, never assumed by the refutation; statement = gated S8 |

The main refutation `not_PrintedClause_l419` does not assume `T01_S8_Gap` or `T01_S10_Gap`; it applies the clause to the instance and gets `0 < 0`.

## 4. Scope

- Refuted: the intermediate claim "E(0) ∈ (0,1)" at l.419 (case p < q), and the gated obligation S8 (`not_S8Gap`). By `mirror_E1_zero`/`mirror_evalue` (p = 3/4, q = 1/4, λ = 1, E(1) = 0), the mirrored claim "E(1) ∈ (0,1)" implicit in "Similar arguments" (l.423) also fails. The same defect, in two places.
- Not refuted: Theorem 3.1 (l.145-148), either direction; the instance lies inside the theorem's family (`E0_in_family`, λ = 1 ∈ (0,1]). The conclusion displayed at l.421 and at l.424-426 is not refuted. Downstream uses of eq:representation (Theorem 3.2 proof l.430, l.174, l.206-229) consume the statement only and are not affected.
- The issue is about the boundary λ = 1 only. For every e-value with E(0) > 0, the printed step holds.
- Classification of the ruling, `PAPER_ARGUMENT_GAP` (minor): I agree. The printed justification asserts a false intermediate fact, while the theorem is true. It is not `ERROR` (the printed result is true). It is not `ENCODING_ERROR` (gated definitions are used unchanged, and the instance is a genuine instance of the paper's setting). An `EDITORIAL` reading (a slip of one bracket) is possible, but the claim as printed is false and the reader must change it, not merely fill it in; this is the ruling's call and I confirm it.

## 5. Suggested fix

l.419: "E(0) ∈ [0,1)", hence λ = 1 − E(0) ∈ (0,1]; the mirror for p > q reads "E(1) ∈ [0,1)". Check:
- E(0) ≥ 0: definition of e-value (l.78, l.407).
- E(0) ≤ 1: eq:evalueCond at π = 0, since f(0) = d(0) < 0.
- E(0) ≠ 1: if E(0) = 1, the right side of eq:ratio is 0 (E(1) ≠ E(0), as E(1) > 1 from eq:evalueCond at π = 1), while the left side d(0)/(d(1) − d(0)) < 0.
- The rest goes through: l.421 is pure algebra from l.417 and λ = 1 − E(0). It does not use E(0) > 0. Reading the proof of `T01_S9`, I see no use of its hypothesis `h0`. This was not confirmed with `#pv_hyp_usage`, and it is not decisive for this review.

`S8_corrected_range` compiles with standard axioms and covers exactly the hypotheses of S8. The fix is sufficient. It is constructed by the reviewer, so it is a suggestion only and not evidence.

## 6. Auditor's own Lean checks

Probe `pv_work/probes/auditor/T01/auditor_T01_cex1.lean` compiled with exit=0, errors=0, sorry_warnings=0 and nonstandard_axiom_lines=0 (log `pv_work/logs/auditor_T01_cex1_4.log`; logs _1 to _3 were failed attempts of my own tactic scripts in the auditor `example`s, not of the audited file). It contains:
- `PrintedClause_l419 ↔ <auditor's independent re-typing of l.419 in context>` by `Iff.rfl`.
- All printed hypotheses for the instance, assembled in one `example`.
- `ν0 = dirac (1/2)`, `S0 = mixtureScore ν0` and `E0 = Erep S0 (1/4) (3/4) 1`, each by `rfl`.
- The auditor's own computation: S0 values, E0(0) = 0 and E0(1) = 2.
- `IsEValue E0 (HS S0 …) (Icc 0 1 \ HS S0 …)` proved directly from the definitions (E_π E0 = 2π, f(π) = π − 1/2), **independent of `T01_S2`**.
- Re-runs of `#pv_axioms` (both modules ALL STANDARD), `#pv_walk` (sorryAx reached: false) and `#pv_type_hashes`.

Finished: Mon Oct 12 22:50:00 EDT 2026.

## Summary

The encoding is faithful: the printed premises are all present, the only extra premise is the source's own case split p < q, and the conclusion is the printed one. The instance satisfies every printed hypothesis, and no definition or convention in the source excludes it. The proof is clean: rebuilds IDENTICAL, standard axioms only, no `sorry`, and the gated definitions are unchanged. The scope is stated correctly: the l.419 step (and its mirror in l.423) is refuted, and Theorem 3.1 is not. The suggested fix [0,1) is sufficient.

E = E_{1/4,3/4;1} with S = S_{1/2} (ν = δ_{1/2}) is an e-value satisfying all hypotheses of l.145 with p < q, and E(0) = 0, so it falsifies "E(0) ∈ (0,1)" at source/VSIFP_02.tex:419 (and the mirrored step at l.423), but not Theorem 3.1.

COUNTEREXAMPLE VALID
