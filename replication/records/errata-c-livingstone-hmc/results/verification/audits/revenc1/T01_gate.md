# T01 statement gate (Theorem 2.2, thm:negative)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); date: Tue Oct 13 01:39:49 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `c46d0008e78a64880db1d6239efca316eaf0d431a7aa782b557fe19aede724aa  pv_work/T01Stmt.lean`
  - `1413a45408cb6bd3136c6aaeac3870753ed5daeedecb4d6ca24909bbd26e61e5  pv_work/T01Draft.lean`
  - `6c6d9977e1f21ba963ef6688db5c31937237091bf05024ccd4940dc12e741aa5  pv_work/notes/T01_draft_notes.md` (leads only)
- Also read: `pv_work/Defs.lean`, `pv_work/T02Stmt.lean`, `T02_main` signature (`pv_work/T02.lean:324-330`), INVENTORY lines 25, 63, 179-191, 208, 222.
- Compilation: `scripts/pv_lean.sh check T01Draft` -> `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_2.log`. EXIT=0.
- Snapshot probes: `pv_work/logs/gate_T01_stmtcopy_1.log` (exit 0, 0 sorry), `pv_work/logs/gate_T01_draftcopy_1.log` (exit 0, 4 sorry).

## Source quotations (read directly)

- TEX:208-219 (Thm 2.2): "If either of the following hold then HMC will *not* produce a geometrically ergodic Markov chain: (i) lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞ and (eqn:oscillations) and (eqn:oscillation2) are satisfied; (ii) There is an M<∞ such that ‖∇U(x)‖ ≤ M for all x ∈ X, and E_π[e^{s‖x‖}] = ∞ for every s>0." No proof follows.
- TEX:863-876 (Thm 5.14): (17) explode, (18) "fixed C<∞ such that whenever ‖y‖ ≥ 2‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖", (19) "lim_{‖x‖→∞, ‖y‖≥2^L‖x‖} (U(x)-U(y)-½‖x‖²) = -∞"; conclusion "HMC with fixed integration time T = Lε does not produce a geometrically ergodic Markov chain for any choice T>0".
- TEX:978-984 (Thm 5.18): "If ‖∇U(x)‖ < M for all x ∈ X, then a *necessary* condition for HMC to produce a geometrically ergodic Markov chain is ∫ e^{s‖x‖} π(dx) < ∞ for some s>0." Proof TEX:986-996 via Prop 3.6 (TEX:307-313), with a bound depending on a fixed L.
- Definitions: TEX:192-194 (X = R^d, π finite target, 𝔏 a distribution on Z+, TV distance); TEX:264-268 (eqn:geoerg); TEX:274-279 (MH type); TEX:320 (π ∝ e^{-U}); TEX:330-336 (leapfrog, ε>0); TEX:338-352 (Algorithm 1: ε ≥ 0, **L ~ 𝔏**); TEX:354-356 (M = I); TEX:361-374 (Prop 4.2).

## Item rulings

1. **Hypotheses: PASS.** Part (i) `HypPartI = HypExplode ∧ HypOscillations ∧ HypOscillation2 U L` is exactly the triple of hypotheses `hexp hosc hosc2` of `T02_main` (T02.lean:329), and the Defs encodings match TEX:865-875 (checked: (18) `2‖x‖ ≤ ‖y‖ → C ≤ 2‖x‖ → 3‖gU x‖ ≤ ‖gU y‖`; (19) filter `‖x‖→∞` inside `2^L‖x‖ ≤ ‖y‖`, `atBot`). Part (ii): `∃ M : ℝ, ∀ x, ‖gU x‖ ≤ M` (M real = M<∞) and `∀ s>0, ∫⁻ ofReal(exp(s‖x‖)) ∂targetMeas U = ⊤` (expectation of a nonnegative function; no truncation issue since the integrand is positive real). Extra premises are only the standing conventions (TFA-A below), no hidden premises in structures/classes/variables. No conclusion-as-hypothesis: `T01Concl` is the conclusion; `Thm518` is not equivalent to T01(ii) (it requires the strict bound and is a separately printed theorem; S2 is needed).
2. **Conclusion: PASS, with a scope statement required (amendment A1).** Each clause gives `¬ GeomErgodic U gU eps L`, `GeomErgodic` reused from T02 (eqn:geoerg). Nothing missing. However the HMC kernel `hmcStep` has a deterministic number of leapfrog steps `L`, i.e. it covers Algorithm 1 only for 𝔏 = δ_L. Thm 2.2 says "HMC" (Algorithm 1, L ~ 𝔏, TEX:342-343). For part (i) this is forced by the statement itself ((19) contains a single L; Thm 5.14 says "fixed integration time"). For part (ii) the printed statement (and Thm 5.18) is not restricted to fixed L, so the Lean clause is a *specialisation* (weaker than printed for random 𝔏). This is acceptable as a faithful formalization of the source proofs (both written for fixed L) but must be stated visibly (INVENTORY X2); the draft notes and docstrings currently do not mention it.
3. **Quantifiers / constants: PASS.** `eps, L` are arguments of `T01_main`, i.e. universally quantified (every ε>0, L≥1), matching "for any choice T>0" (TEX:876) and the unrestricted Thm 5.18; this is the strongest reading of the unquantified Thm 2.2 (N9), not a weakening. `M` in (ii) is existential before `x`, as printed; `s` universal, as printed. The `L` in (19) equals the chain's `L` (only sensible reading, as in T02).
4. **Domains and details: PASS.** X = R^d (`E d`), d ≥ 1; π normalised (`targetMeas`), equality-type statements only; no a.e. vs everywhere issue in the new definitions; `ofReal` of a positive real only.
5. **Step obligations: PASS.** S1 has exactly the signature of `T02_main` with the three hypotheses bundled -> true (T02 FINAL_PASSED), matches TEX:213 via X3. S2 (`≤ M` ⇒ `< M+1`) is true and a fair implicit step bridging TEX:217 and TEX:979 (not a TFA, correctly a visible step). S3: `Thm518` + S2 gives `∃ s>0, ∫ < ⊤`, contradicting HypPartII's `∀ s>0, ∫ = ⊤`; true as stated, all premises of `Thm518` (0<d, IsGradField, hπ, 0<eps, 1≤L) are hypotheses of S3. Assembly: `T01Concl.mk (S1 …) (S3 …)` gives the main theorem. No obligation smuggles the conclusion. None is false as stated.
6. **External parameters: PASS.** `Thm518` (see table). Not stronger than TEX:978-984: same strict hypothesis `‖∇U‖ < M` ∀x, same conclusion, plus extra premises (d≥1, differentiability, finite π, ε>0, L≥1) and restriction to deterministic L — all weakenings. Not goal-shaped (its conclusion is an exponential-moment existence, not `¬ GeomErgodic` under T01's hypotheses). Provenance (ii) follows the project instruction "all out-of-scope numbered results are type (ii)" (INVENTORY:179, 185; Thm 5.18 out of scope, INVENTORY:208); E4 (Prop 3.6) transitively inside. Declared only in `T01Stmt.lean`, `namespace Paper.T01`; no name clash (grep over `pv_work` finds `Thm518`, `HypPartI`, `HypPartII`, `T01Concl` declared only in T01Stmt.lean). `Prop35`, `GaussFacts`, `T02_L02Consumed` are reused from T02Stmt, not redeclared: acceptable because T01 consumes them only as the parameters of `T02_main`; the (p) clause keeps its T02 name and its L02 location/applicability as documented in T02Stmt.lean:93-100. "mathlib does not have it": not applicable (paper-specific theorem).
   Truth sanity check: with the uniform gradient bound, the proof's displacement bound + Gaussian tails give uniform tightness, the hypothesis of Prop 3.6; the specialised statement is plausibly true and in any case is the printed theorem.
7. **Doubts about the source: recorded, preliminary only.**
   - X3 (TEX:208-219): Thm 2.2 has no proof and never references Thms 5.14/5.18; the identification is flagged in the notes and docstrings, not silently assumed. Preliminary: EXPOSITION_GAP (minor) or EDITORIAL. Dispatch pv-issue-checker.
   - X2 (TEX:209, 217 vs 342-343, 876, 986-996): Thm 2.2 is stated for "HMC" (Algorithm 1 with L ~ 𝔏), while both supporting proofs treat a fixed L. Preliminary: EXPOSITION_GAP for random 𝔏 (for part (ii) the extension looks routine; for part (i) (19) presupposes fixed L). Dispatch pv-issue-checker.
   - N9 (unquantified ε, L): preliminary DOMAIN_CLARIFICATION / EDITORIAL; the encoding uses the universal reading.
   - TEX:217 `≤ M` vs TEX:979 `< M`: FAIR_IMPLICIT_STEP (S2), not an issue.

## TFAs ruled on

| TFA | Content | Ruling | Reason |
|---|---|---|---|
| TFA-A | `0<d`, `IsGradField U gU`, `∫⁻ e^{-U} < ⊤`, `0<eps`, `1≤L` | approved | standing conventions TEX:192 (π finite), 320, 324 (U differentiable; ∇U used in the statement), 336 (ε>0), 192 (𝔏 on Z+); d=0, ε=0, L=0 are degenerate cases the source does not discuss (d=0 would even make (i) vacuously-hypothesised and false for the trivial chain). Same as T02 TFA-1/2. |
| TFA-B | universal reading of unquantified ε, L | approved | quantifier reading, the strongest available; consistent with TEX:876 and 978-984 |

## External parameters

| Name | Provenance | Source | Ruling |
|---|---|---|---|
| `Paper.T01.Thm518` (E3) | (ii) (project instruction; out-of-scope numbered result Thm 5.18, proof uses E4 = Prop 3.6) | TEX:978-984 (proof 986-996) | approved (not stronger: extra premises + fixed-L specialisation) |
| `Paper.T02.Prop35`, `Paper.T02.GaussFacts`, `Paper.T02.T02_L02Consumed` | (ii), (v), (p) — reused, audited in T02 | — | reuse approved, no redeclaration |

## Required changes (documentation only; no type/value change expected, the snapshot below must stay identical)

- **A1.** `pv_work/T01Stmt.lean`, docstring of `T01Concl` (lines 40-41): append a sentence: "Scope: `hmcStep` has a deterministic number `L` of leapfrog steps, i.e. Algorithm 1 with 𝔏 = δ_L only; the printed statement concerns HMC with L ~ 𝔏 (TEX:342-343); the passage to random 𝔏 (INVENTORY X2) is not covered." Likewise in the `Thm518` docstring (lines 18-23) add "specialised to deterministic L (𝔏 = δ_L), a weakening of the printed statement."
- **A2.** `pv_work/T01Draft.lean`, docstring of `T01_main` (lines 10-15): add "Covers 𝔏 = δ_L only (X2)."
- **A3.** `pv_work/notes/T01_draft_notes.md`: under "Encoding choices" add the fixed-L scope (X2) and under "Suspected paper issues" add X2 (Thm 2.2 stated for HMC with L ~ 𝔏, supporting proofs for fixed L; EXPOSITION_GAP, preliminary).

## Statement snapshot

Stmt copy (`pv_work/probes/gate/T01/gate_T01_stmtcopy.lean`, log `pv_work/logs/gate_T01_stmtcopy_1.log`):
```
TYPE HASHES (current file, 12 declarations)
Paper.T01.HypPartII|def|th=3957315956|vh=1173314425|bi=iee
Paper.T01.HypPartI|def|th=1151819367|vh=3393636548|bi=ieee
Paper.T01.T01Concl.casesOn|def|th=1373956722|vh=1243287819|bi=iiiiiiee
Paper.T01.T01Concl.mk|ctor|th=3893591694|vh=-|bi=iiiiiee
Paper.T01.T01Concl.noConfusionType|def|th=1533223712|vh=2188585157|bi=iiiiieee
Paper.T01.T01Concl.noConfusion|def|th=4150213738|vh=1585562462|bi=iiiiiiiie
Paper.T01.T01Concl.partII|thm|th=2740704371|vh=-|bi=iiiiiee
Paper.T01.T01Concl.partI|thm|th=2679091220|vh=-|bi=iiiiiee
Paper.T01.T01Concl.recOn|def|th=1373956722|vh=697509788|bi=iiiiiiee
Paper.T01.T01Concl.rec|rec|th=2963399103|vh=-|bi=iiiiiiee
Paper.T01.T01Concl|induct|th=4031747299|vh=-|bi=ieeee
Paper.T01.Thm518|def|th=3944470172|vh=3970237549|bi=
EXIT=0
```

Draft copy (`pv_work/probes/gate/T01/gate_T01_draftcopy.lean`, log `pv_work/logs/gate_T01_draftcopy_1.log`):
```
TYPE HASHES (current file, 4 declarations)
Paper.T01.T01_S1|thm|th=3069413807|vh=-|bi=ieeeeeeeeeeeee
Paper.T01.T01_S2|thm|th=3202775329|vh=-|bi=iee
Paper.T01.T01_S3|thm|th=4061819840|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_main|thm|th=1845210232|vh=-|bi=ieeeeeeeeeeeee
EXIT=0
```

## Overall verdict

Statement faithful to TEX:208-219 under the fixed-L scope; Thm518 not stronger than TEX:978-984; S2 a fair implicit step; X3 flagged. Three documentation amendments (A1-A3) required so that the fixed-L scope (X2) is visible.

STATEMENT GATE: PASS_WITH_AMENDMENTS
