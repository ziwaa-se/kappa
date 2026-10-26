# P05 issue 1: counterexample review (Proposition 3.5, `prop:stopping`)

- Role: pv-auditor (independent subagent, Claude Opus 5.5); not the drafter, gate, prover or issue checker.
- Date: Tue Oct 13 01:52:24 EDT 2026 (from `date`).
- Reviewed: ruling `verification/audits/P05_issue_1.md`; counterexample `pv_work/P05_Counterexample1.lean` (sha256 `7a2501858d82102e72f3d3ad77cfb90178f5fababcda732909df8d6e8ddcfa11`, recomputed with `pv_snapshot.py hash`: matches the ruling).
- Read directly: `source/VSIFP_02.tex` l.70-149 (scores, H_{S;c}, E_{p,q;λ}), l.200-252 (sequential setting, P04, P05, l.242 discussion), l.440-495 (proofs of P04, P05, Appendix on h>1); `pv_work/P05Stmt.lean`, `pv_work/P04Stmt.lean`, the relevant definitions in `pv_work/Defs.lean` (`expPi`, `IsConsistent`, `IsStrictlyConsistent`, `Erep`), `P05_main` in `pv_work/P05Draft.lean`; `P05_gate_r2.md` (P05_main th=710880581, STATEMENT GATE: PASS).

## Own checks run

| Check | Result |
|---|---|
| Probe `pv_work/probes/auditor/P05/aud_P05_issue1.lean` (`pv_lean.sh probe`) | exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 (log `pv_work/logs/aud_P05_issue1_1.log`) |
| `#pv_axioms P05_Counterexample1` | ALL STANDARD (55 declarations checked) |
| `#print axioms` `not_printed`, `not_Sbridge`, `hP040`, `lintegral_stopped`, `F0`, `Q0` | [propext, Classical.choice, Quot.sound] each |
| Probe `aud_P05_issue1_walk.lean`: `#pv_walk_decl not_printed`, `not_Sbridge` | AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false (log `pv_work/logs/aud_P05_issue1_walk_1.log`) |
| `#pv_walk P05_Counterexample1` (module level) | sorryAx reached: false. The module-level closure also lists `lcProof`, `Paper.P05.Issue1.F0._elambda_1`, `npowRec._at.Real.commRing._spec_2`: compiler-generated auxiliaries of the module's code generation, not reached from any theorem (the declaration walks and `#print axioms` above are standard). No `axiom`/`sorry`/`native_decide`/`implemented_by`/`extern`/`unsafe`/`admit` token in the file's text. Not an issue for the evidence. |
| `Iff.rfl`: `PrintedClause` unfolds to the binder list of the gated `P05_main` (at `Ω : Type`) | compiles |
| Independent restatement: `hS0 ∧ hset0 ∧ hP040 ∧ htau0 ∧ hQ0` against the gated predicates | compiles |
| `example : ¬ (type of P05_main at Ω : Type)` via `printed_of_main_shape` + `not_printed` | compiles; `#pv_hyp_usage printed_of_main_shape`: `Hmain` USED |
| Earlier theorems used | none: only gated definitions of `Defs`, `P04Stmt`, `P05Stmt` and the structure projection `P04Conclusion.measurable` (gated, DEFS_gate/P04_gate/P05_gate_r2). No unaudited theorem is consumed. |

## 1. Encoding fidelity (decisive item)

| Printed (source) | `PrintedClause` | Assessment |
|---|---|---|
| l.236 "under the assumptions of Lemma prop:combination": l.223 data in {0,1}²×(0,1)²×[0,1], adapted, λ_t=0 if c_t=0 | `Paper.P04.SeqSetting` (all eleven fields) | Faithful (P04 gate). |
| l.223 "S strictly consistent" (D02, l.74) | `IsStrictlyConsistent S` = consistency + equality only at p=π | Faithful. |
| lag h ≥ 1 (l.111) | `1 ≤ h`, h universally quantified | Faithful; P05 places no restriction on h. |
| l.236 τ ∈ ℕ a.s. finite stopping time | `τ : Ω → ℕ` (finite everywhere), `IsStoppingTime ℱ τ` | Everywhere-finite is stronger than a.s. finite: extra premise, weakens the clause. Allowed. |
| l.238 Q ∈ H_S (c ≡ 1, l.122) | `Q ∈ HScInt S h ℱ Y (fun _ _ => 1) p q` | Faithful; integrability of the score difference is an extra premise (weakens). |
| l.238 E_Q(e_τ) ≤ 1, e_T from l.224 | `∫⁻ ofReal (eT … (τ ω) ω) ∂Q ≤ 1` | Reading A, `e_τ(ω) = e_{τ(ω)}(ω)`; the lower integral equals E_Q e_τ for e_τ ≥ 0 (gate). Not stronger than printed. |
| — | `P05_P04Consumed` (P04's conclusion), `∀ᵐ ω, h+1 ≤ τ ω` | Extra premises only (weaken the clause); both discharged unconditionally for the instance. |

Conclusion: `PrintedClause` is the printed statement with only extra premises; nothing is missing and the conclusion is not strengthened. It is literally the gated `P05_main` type at `Ω : Type` (checked by `Iff.rfl` and `printed_of_main_shape`), so the refutation applies to the gated statement. No ENCODING_ERROR found.

Objects: S, h, the filtration, (Y,c,p,q,λ), τ and Q are all universally quantified parameters in the source; the only constructed object is e_T (l.224) and H_S (l.116-122), both built from the parameters. The instance uses them as such.

## 2. The instance satisfies every printed hypothesis (checked by hand and in Lean)

Instance (h=2): Ω = Bool, Q uniform, Y_3=Y_4=1{b}, other Y_t=0; ℱ_t trivial for t≤2, full for t≥3; Brier S(p,y)=(y−p)² (l.74); p_t=1/4, q_t=3/4, c_t=1; λ_2=1, other λ_t=0; τ=3 on {b=false}, 4 on {b=true}.

| Hypothesis | Hand check | Lean |
|---|---|---|
| Ranges, adaptedness, λ_t=0 if c_t=0 | Y_3,Y_4 are ℱ_3-, ℱ_4-measurable (full σ-field); all other data constant; λ_2=1 ∈ [0,1] | `hset0` |
| S strictly consistent | Brier (l.74 example; ν density 2 > 0, Table 1) | `hS0` |
| E_{p,q;λ} (l.147) | p<q so 1{p>q}=0; |S(p,0)−S(q,0)| = 1/2; S(p,y)−S(q,y) = y−1/2; E_{1/4,3/4;1}(y)=2y; λ=0 gives 1 | `Erep_one`, `Erep_lam0`; `Defs.Erep` uses `if q < p then 1 else 0` = 1{p>q} |
| e_T (l.224, h=2) | I_1(3)={1}, I_2(3)=∅ → e_3=1; I_1(4)={1}, I_2(4)={2} → e_4=(1+2Y_4)/2; same for T≥4 | `eT_eq`, `eT_three` |
| Q ∈ H_S (l.118, c≡1) | E[Y_{t+2}−1/2 | ℱ_t] = 0 for t=1,2 (trivial ℱ_t, Q{b}=1/2); = −1/2 for other t (Y_{t+2}=0); "≤ 0" holds | `hQ0` (also t=0, an extra constraint) |
| τ a.s. finite stopping time | {τ≤t}=∅ for t≤2; ℱ_t full for t≥3 | `htau0`; also τ ≥ h+1=3 (`htau0_ge`), so the τ<h+1 reading question does not arise |
| P04's conclusion holds (not a P04 failure) | For any Q' ∈ H_S, E_{Q'}Y_4 ≤ 1/2, so E e_T = 1/2 + E Y_4 ≤ 1 for T≥4; e_3 = 1 | `hP040`, for every Q' ∈ ℋ_{S;c} |
| Violation | E_Q e_τ = ½·1 + ½·(3/2) = 5/4 > 1 | `lintegral_stopped`, `not_printed` |

No source definition excludes the instance: p_t ≠ q_t, values in (0,1), Y binary, λ ∈ [0,1] (P04 allows λ=0 and λ=1), filtration and stopping time are ordinary. Q lies on the boundary of H_S at t=1,2, which l.118 ("≤ 0") admits; the ruling's strict-interior variant Q{b}=π<1/2 gives 1+π/2 > 1 (my hand check agrees; not Lean-checked). The general-h≥2 variant (E e_τ = 1 + 1/(2h)) also checks by hand (e_{h+1}=1, e_{h+2}=(h−1+2Y_{h+2})/h); not Lean-checked.

## 3. The counterexample itself is proved

Compiles with exit=0, no `sorry`, axioms exactly the three standard ones in the declaration closures of `not_printed` and `not_Sbridge`; no earlier theorem consumed (section "Own checks").

## 4. Reading ambiguities (noted as requested)

| Point | Assessment |
|---|---|
| e_τ when τ < h+1 (l.223 defines e_T only for T ≥ h+1) | Irrelevant here: the instance has τ ≥ 3 = h+1 everywhere, and the Lean clause even assumes it. The ruling's FAIR_IMPLICIT_STEP (printed formula gives e_T=1 for T≤h) is consistent with `Paper.P04.Ik`. |
| H_S (l.238) vs H_{S;c} (l.226) | Irrelevant here: c ≡ 1, so H_S = H_{S;c} (l.122). DOMAIN_CLARIFICATION (minor) as in the ruling is a fair label. |
| Meaning of e_τ: reading A (e_{τ(ω)}(ω)) vs reading B (l.242 "stopped e-value", λ zeroed from τ on and evaluated after Y_{τ+h−1}) | Reading A is fixed by l.233 ("T is replaced by a stopping time τ") and by the first equality of the proof at l.476 (E e_τ = Σ_t E{e_t 1(τ=t)}). The l.242 discussion already says that for h>1 the stopped e-value "depends on the unknown, future observations ... so it is random", i.e. the authors note the phenomenon but do not restrict Proposition 3.5 or redefine e_τ. Under reading B the instance gives E = ½·½ + ½·(3/2) = 1 (stopped values 1/2 on {b=false}, 3/2 on {b=true}; no violation, as the ruling notes). The counterexample therefore refutes the statement in its printed reading (A) only; the ruling's "Required human check" on the intended reading is appropriate and I endorse keeping it. |

## 5. Scope

- Refuted: the printed conclusion E_Q(e_τ) ≤ 1 of Proposition 3.5 (l.235-240) for lag h = 2 (Lean), hence the gated `P05_main`; for every h ≥ 2 by the same construction (hand-checked reasoning, not Lean).
- Not refuted: P04 (`hP040` shows P04's conclusion holds on the instance); the general lemma at l.474-476 (true under its own premise); the h = 1 case; the reading-B statement; the Appendix claim l.489-495 (a deterministic lower bound, not an expectation bound).
- Also Lean-confirmed: the bridge step "E(e_t | ℱ_t) ≤ 1" required by l.474 fails for P04's e_t, because e_t is ℱ_t-measurable (`condExp_self_of_P04`, general h) and e_4 = 3/2 on a set of mass 1/2 (`not_Sbridge`). That is, the printed justification does not apply to P04's e_t for any lag.
- Not checked by me (per task): the h = 1 claims of the ruling (§4.2, conclusion true, PAPER_ARGUMENT_GAP); downstream claims l.252, l.292 (listed in the ruling as reasoning only).

## 6. Classification

- h ≥ 2: **ERROR** confirmed. Every printed hypothesis holds, the printed conclusion fails, and the instance does not exploit any encoding choice (c ≡ 1, τ ≥ h+1, integrable, everywhere-finite τ). Not a P04 failure (P04's clause holds on the instance), so the error belongs to P05 itself.
- h = 1 PAPER_ARGUMENT_GAP: not ruled on here (unchecked); only the failure of the bridge premise (`not_Sbridge`-type argument, general) is Lean-supported.
- Primary verdict ERROR, THREATENS CONCLUSION: yes: confirmed, subject to the reading-A human check above.

## 7. Suggested fix

- Fix 1 (h = 1 only, λ'_t = λ_t 1{t<τ}, then Fatou): the hand check holds: {t<τ} = {τ≤t}^c ∈ ℱ_t, λ' satisfies l.223 (λ'=0 where c=0), and for h=1 the e-value built with λ' at time T equals e_{τ∧T}. It rests on P04 (itself CONDITIONAL per `P04_final.md`). Plausible; not Lean-checked.
- Fix 2 (h ≥ 2, evaluate e'_{τ+h−1}): l ∈ I_k(T) iff l ≡ k (mod h) and l + h ≤ T, so for T ≥ τ+h−1 every l ≤ τ−1 is included and factors with l ≥ τ equal 1; hence e'_T = e'_{τ+h−1} and Fatou gives the bound from P04. Plausible; on the instance it gives exactly 1. Not Lean-checked. Both are suggestions to the authors only.

COUNTEREXAMPLE VALID
