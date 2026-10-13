# P03 issue 1: counterexample review (pv-auditor)

- Reviewer: pv-auditor (fresh subagent, Opus); date Mon Oct 12 22:22:51 EDT 2026 (from `date`)
- Audited: `pv_work/P03_Counterexample1.lean` (sha256 `ab687a84825ea720afd19a2d1f29f05338eb3c1dd4f155391a708656d561ccef`, matches the ruling), ruling `verification/audits/P03_issue_1.md`, gate `verification/audits/P03_gate.md`
- Source read directly: main.tex:1-34 (setting, def:svar), main.tex:81-88 (prop:sum and proof)
- Not modified: any audited file. Probe: `pv_work/probes/auditor/P03/aud_P03_cex1.lean`

## Mechanical checks (run by me)

| Check | Command / evidence | Result |
|---|---|---|
| File hashes | `pv_snapshot.py hash`: P03_Counterexample1, P03Stmt `6a4717b3…`, P03Draft `4f2d0249…`, Defs `0259b9aa…` | all equal to ruling / gate |
| Compile | `pv_lean.sh check P03_Counterexample1` (log `pv_work/logs/P03_Counterexample1_2.log`) | exit=0 errors=0 sorry=0 nonstd=0 |
| Private rebuild | `pv_lean.sh rebuild P03_Counterexample1 P03` | IDENTICAL (`a9444980…`) |
| S1 fingerprint | probe copies `P03_S1` verbatim; `#pv_type_hashes_here` -> `Paper.P03.P03_S1|thm|th=827841601|bi=eeee` | equals gate snapshot (P03_gate.md:67) |
| PrintedStepS1 = S1 | probe `example : PrintedStepS1 = (∀ m (hm : 2 ≤ m) (x y : Fin m → ℝ), s2 (x+y) = s2 x + s2 y) := rfl` and `example : ¬(that) := counterexample` | compiles |
| Other fingerprints | walk: `P03Concl` th=2798614588 vh=3065402787 (= gate); `DEFS.mean` vh=911562101, `DEFS.s2` vh=2090720030 (= DEFS_gate.md:49-50) | match |
| Axioms | `#pv_axioms P03_Counterexample1`: ALL STANDARD (19 decls); `#print axioms` on `counterexample`, `fails_every_m`, `concl_at_witness`: [propext, Classical.choice, Quot.sound] | PASS |
| sorry walk | `#pv_walk`: closure axioms standard, `sorryAx reached: false` | PASS |
| Project constants reached | `DEFS.mean`, `DEFS.s2` (DEFS gate PASS, definitions only), `P03Concl` (P03 gate PASS, definition); no earlier theorem used | PASS |

Probe log: `pv_work/logs/aud_P03_cex1_1.log` (the one `sorry` warning is the probe's own copy of the draft obligation S1, used only to fingerprint its type; not in the counterexample's closure).

## 1. Encoding fidelity (decisive)

- main.tex:86: "We have $s^2(x+y) = s^2(x)+s^2(y)$", inside the proof of prop:sum whose hypotheses are "$m \ge 2$ and $x,y \in \mathbb{R}^m$" (main.tex:82). `PrintedStepS1 := ∀ m : ℕ, 2 ≤ m → ∀ x y : Fin m → ℝ, s2 (x+y) = s2 x + s2 y`: word for word, same hypotheses; no premise dropped, conclusion not strengthened. It is definitionally the universal closure of the gated `P03_S1` (rfl check above, fingerprint identical).
- Constructed vs global objects: `m`, `x`, `y` are parameters of the proposition; `s2`, the mean and `+` are global, fixed by def:svar (main.tex:31-33) and vector addition. `Defs.s2` uses `(m:ℝ) - 1`, no ℕ truncation; matches main.tex:33. No representation choice manufactures the failure.

## 2. Instance satisfies all printed hypotheses

`m = 2` (`le_rfl : 2 ≤ 2`), `x = y = (0,1) ∈ ℝ²`. The only standing conventions (main.tex:24: `n ≥ 1`, `I` the unit interval) concern other objects; nothing in the source restricts the data vectors (no centring, independence, orthogonality or zero-covariance assumption anywhere). Hand check under the source's definitions: `x̄ = 1/2`, `s²(x) = (1/4+1/4)/1 = 1/2`; `x+y = (0,2)`, mean 1, `s²(x+y) = (1+1)/1 = 2 ≠ 1 = s²(x)+s²(y)`.

## 3. Counterexample proved

Compiles cleanly, standard axioms only, no `sorryAx`, rebuild IDENTICAL; it uses no earlier theorem (only gated definitions), so no theorem audit records are needed. `fails_every_m` (all `m ≥ 2`, `x = y = e₀`) and `counterexample_le` (the `≤` reading) also check.

## 4. Scope

- Refutes: the sentence main.tex:86 (step S1), in full generality and for every `m ≥ 2`; also its `≤` weakening, so the source chain cannot be rescued by reading `=` as `≤`.
- Does not refute: the printed conclusion main.tex:82 (it holds at the witness, `concl_at_witness`, with equality); the second link S2 (main.tex:86-87, true, `step2_holds`).
- Downstream: the ruling says no result depends on P03 (INVENTORY.md:19-21); I did not re-derive the dependency graph beyond this citation.
- Classification `PAPER_ARGUMENT_GAP` (not `ERROR`) is consistent with this scope: a step of the given justification is false; the printed conclusion is not shown false. Consequence for P03: the source route stops at S1, so P03 cannot be verified along the source route (ISSUE).

## 5. Suggested fix

Ruling §6: `s²(x+y) = s²(x)+s²(y)+2c(x,y)` with `c` the sample covariance (true, using `mean(x+y) = x̄+ȳ`), and `2c ≤ s²(x)+s²(y)` from `2ab ≤ a²+b²` on centred coordinates, giving the printed bound. I checked this on paper: it is correct and sufficient (reasoning only, not Lean-checked; reviewer-constructed, a suggestion to the authors, not evidence). The alternative "assume `c = 0`" would also validate the printed proof but weakens the proposition, as the ruling notes.

## Status for the authors

The proof sentence main.tex:86 is false (m=2, x=y=(0,1): 2 ≠ 1; fails for every m ≥ 2); Lean-checked, standard axioms. The proposition at main.tex:82 itself is not refuted. This is a gap in the argument (PAPER_ARGUMENT_GAP), not an error in the statement.

COUNTEREXAMPLE VALID (PrintedStepS1 is exactly the gated S1 (rfl and fingerprint th=827841601), the instance m=2, x=y=(0,1) satisfies every printed hypothesis, and the refutation compiles with standard axioms only and no sorry.)
