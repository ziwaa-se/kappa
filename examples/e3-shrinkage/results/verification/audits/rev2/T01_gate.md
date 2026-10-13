# Statement gate: T01 (Theorem thm:oracle, source/main.tex:58-67)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:13:48 EDT 2026 (from `date`)
- Read directly: `source/main.tex:1-79` (convention l.25, Definition l.27-34, lem:square l.38-46, lem:min l.48-56, thm:oracle l.58-67); `pv_work/T01Stmt.lean`, `pv_work/T01Draft.lean`, `pv_work/Defs.lean`, `pv_work/L02Stmt.lean`, `pv_work/L01Stmt.lean`, `pv_work/L01.lean` in full; `verification/audits/L01_final.md`, `L02_gate.md` (verdict/Conclusion lines), `L02_issue_1*.md` (verdict lines). Draft notes were read as leads only.

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

| File | sha256 |
|---|---|
| pv_work/T01Stmt.lean | 8aea38f557e6b03fe8c6aa6cb5585a255607be2d14ced0ba400e019bae5fb00d |
| pv_work/T01Draft.lean | 6561f5e1ac346dd0056ff4419634c3f0b25985eb0f653a4666c2ecf9f58f479b |
| pv_work/Defs.lean | 1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31 (= DEFS-gated) |
| pv_work/L02Stmt.lean | 8c2d7440f6f332f279823bc14e8e9730ff05ebbe68b58f6e4acec79fb5c6885a (= L02-gated) |
| pv_work/L01.lean | 31f03f3296fbbe1b88e357aae33ee390ef56930671c7dfbed8275ecd8eea6629 |
| pv_work/L01.olean | d278d7ba34a76a77c205bbf70e7d43b9f8a5d931a4eff571b9d99218330ed25b (= delivered/rebuilt hash in L01_mech.md, FINAL AUDIT: PASS) |

## Compilation

`scripts/pv_lean.sh check T01Draft`: `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_2.log`. The 5 sorries are S1-S5, which is expected for a draft.

## Source quotations

- main.tex:25 "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:29 "$R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$"; :31 "$c^\ast = \theta^2 / (\theta^2 + \sigma^2)$"; :33 "$\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$".
- main.tex:39 (lem:square) "For every $c$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$."
- main.tex:49 (lem:min) "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:59-60 (thm:oracle) "For every $c \in \mathbb{R}$, $R(c) \ge \rho$, with equality if and only if $c = c^\ast$. Moreover, $\rho \le \min\{R(0), R(1)\}$."
- main.tex:64-66 (proof) "By Lemma lem:square, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2 \ge 0$, with equality if and only if $c = c^\ast$, because $\theta^2 + \sigma^2 > 0$. Since $R(0) = \theta^2$ and $R(1) = \sigma^2$, Lemma lem:min gives $\rho \le \min\{R(0), R(1)\}$."

## Item rulings

1. **Hypotheses: PASS.** The only hypothesis is `h : Setting θ σ` (Defs D04, two fields `θ ≠ 0`, `0 < σ`), which is l.25 verbatim and DEFS-gated. There are no `variable`s, type classes or hidden structure fields. The only other binder is `hL02 : T01_L02Consumed`, a (p) consumed clause (item 6), not a TFA. No extra premises. No hypothesis states the conclusion or an equivalent of it. `hL02` gives ρ ≤ min{θ², σ²}, which is the cited lemma's own printed conclusion and is exactly the premise the source invokes at l.66 (see item 6).
2. **Conclusion: PASS.** `Conclusion` has three fields that match l.59-60 clause by clause: `ge` (∀c, ρ ≤ R(c)), `eq_iff` (∀c, R(c) = ρ ↔ c = c*; "equality" means R(c) = ρ), and `le_min` (ρ ≤ min (R 0) (R 1)). Nothing is weakened, strengthened or missing.
3. **Quantifiers / constants: PASS.** θ and σ are fixed with `Setting`, and c is universally quantified inside each clause, which matches "for every c" under the fixed θ, σ of l.25. The theorem has no existential constants.
4. **Domains / details: PASS.** Everything is in ℝ. There are no ENNReal truncations, measurability or a.e. issues. Division by θ²+σ² is safe under `Setting`, and the definitions are DEFS-gated.
5. **Step obligations: PASS.** Each obligation was checked for truth as stated:
   - S1 (l.64) `Setting → ρ ≤ R(c)`: TRUE, by L01 and θ²+σ² > 0.
   - S2 (l.64-65) `Setting → (R(c) = ρ ↔ c = c*)`: TRUE. θ²+σ² > 0 follows from σ > 0, which is the reason the source itself gives.
   - S3 (l.65) `R(0) = θ²`: TRUE unconditionally (0·σ² + 1·θ²). This is a direct computation that the source asserts.
   - S4 (l.65) `R(1) = σ²`: TRUE unconditionally.
   - S5 (l.65-66) `T01_L02Consumed → Setting → ρ ≤ min(R 0, R 1)`: TRUE. It is hL02 at (θ, σ, h) rewritten with S3/S4. It does not smuggle in anything beyond what l.66 states.
   - Assembly: `T01 := ⟨S1, S2, S5⟩` compiles and gives `Conclusion`. S3 and S4 are meant for use inside S5's proof, as the source uses them. No obligation states a stronger intermediate claim.
6. **External parameters / consumed clause: PASS.** There is exactly one, `Paper.T01.T01_L02Consumed : Prop := ∀ θ σ, Setting θ σ → Paper.L02.Conclusion θ σ`.
   - Content: `Paper.L02.Conclusion θ σ := oracleRisk θ σ ≤ min (θ^2) (σ^2)`, from the L02-gated `L02Stmt.lean` (hash unchanged; the L02 gate snapshot has `Paper.L02.Conclusion|def|th=1185911348|vh=2072270411`). This is l.49 verbatim. The `Setting` premise is the standing assumption under which lem:min is stated (l.25 "Throughout"). So the clause is exactly the statement of lem:min and does not include its proof (the L02 issue, PAPER_ARGUMENT_GAP, concerns only l.53-55).
   - Not stronger than the source's use: l.66 applies lem:min at the theorem's own (θ, σ). Quantifying over all (θ, σ) with `Setting` is precisely the lemma as printed under l.25, and adds nothing. Applicability conditions are met because `h : Setting θ σ` is the same standing assumption.
   - Goal-shape: after S3/S4 it is equivalent to the target's third clause, but this is the source's own route (l.66 derives clause 3 from lem:min in one step). It is the predecessor's printed conclusion, not the target written as a premise. It does not cover clauses 1-2 of the target. Accepted.
   - Provenance: (p), correct. Predecessor is L02, location main.tex:48-50 (statement l.49), consumed at main.tex:66. L02 is not final-passed (its verdict is ISSUE on the proof, while its conclusion is true per `L02_issue_1.md`), so a (p) clause is the correct mechanism.
   - Naming and location: declared only in `T01Stmt.lean`, in `namespace Paper.T01`, named `<ID>_<PredID>Consumed`. No name is redeclared (`Paper.T01.Conclusion` differs from `Paper.L02.Conclusion`; a workspace search found no other `T01_L02Consumed`). The `vh` lock is in the snapshot below.
   - Truth: the clause is true (L02 issue ruling), so the conditional theorem is not vacuous.
   - L01 as final-passed import: `T01Draft.lean` imports the final module `L01` (not `L01Draft`/`L01Stmt` only), and `pv_work/L01.olean` sha256 = d278d7ba…, identical to the audited delivered/rebuilt hash. `L01_final.md`: FINAL AUDIT: PASS, UNCONDITIONAL. Its theorem `Paper.L01.L01 (θ σ) (h : Setting θ σ) (c) : risk − oracleRisk = (θ²+σ²)(c − c*)²` is exactly what S1/S2 need. Using it directly, rather than as a (p) clause, is correct. `T01Stmt.lean` does not import L01, which is fine because no statement depends on it.
   - "mathlib does not have it": not applicable (paper lemma).
7. **Doubts about the source: none for T01.** T01's printed proof (l.64-66) is sound given lem:square and lem:min as stated. The L02 proof issue (l.54-55, already ruled PAPER_ARGUMENT_GAP in `L02_issue_1.md`) does not affect the consumed clause. How T01's dependence on L02 enters T01's verdict is for the coordinator (VERDICTS §1). No new dispatch is needed.

## TFAs ruled

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premises. θ²+σ² > 0 is printed at l.65 and follows from `Setting`, so it is not a premise. |

## External parameters / consumed clauses

| Name | Provenance | Ruling |
|---|---|---|
| `Paper.T01.T01_L02Consumed` | (p) L02, main.tex:48-50 (l.49), consumed at main.tex:66, applicability via the same `Setting θ σ` | APPROVED |

## Required changes

None.

Non-blocking editorial remark (no change required): the docstring of `T01_L02Consumed` says "used at main.tex:66-67". The use is at l.65-66; l.67 is `\end{proof}`.

## Statement snapshot

Copies: `pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (probe exit=0, 0 sorry, log `pv_work/logs/gate_T01_stmtcopy_1.log`) and `pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (probe exit=0, 5 sorry, log `pv_work/logs/gate_T01_draftcopy_1.log`).

T01Stmt copy:
```
TYPE HASHES (current file, 11 declarations)
Paper.T01.Conclusion.casesOn|def|th=21883378|vh=3783144566|bi=iiiee
Paper.T01.Conclusion.eq_iff|thm|th=3032293842|vh=-|bi=iiee
Paper.T01.Conclusion.ge|thm|th=497955768|vh=-|bi=iiee
Paper.T01.Conclusion.le_min|thm|th=997630560|vh=-|bi=iie
Paper.T01.Conclusion.mk|ctor|th=230111841|vh=-|bi=iieee
Paper.T01.Conclusion.noConfusionType|def|th=2085781658|vh=643766196|bi=iieee
Paper.T01.Conclusion.noConfusion|def|th=3062243473|vh=1831328515|bi=iiiiie
Paper.T01.Conclusion.recOn|def|th=21883378|vh=2539933680|bi=iiiee
Paper.T01.Conclusion.rec|rec|th=2809065970|vh=-|bi=iiiee
Paper.T01.Conclusion|induct|th=1185911348|vh=-|bi=ee
Paper.T01.T01_L02Consumed|def|th=3944470172|vh=143933708|bi=
```

T01Draft copy:
```
TYPE HASHES (current file, 6 declarations)
Paper.T01.T01_S1|thm|th=1499751178|vh=-|bi=eeee
Paper.T01.T01_S2|thm|th=659539489|vh=-|bi=eeee
Paper.T01.T01_S3|thm|th=993956933|vh=-|bi=ee
Paper.T01.T01_S4|thm|th=2522310948|vh=-|bi=ee
Paper.T01.T01_S5|thm|th=1354182115|vh=-|bi=eeee
Paper.T01.T01|thm|th=513874863|vh=-|bi=eeee
```

## Overall verdict

The statement is faithful to main.tex:58-61. Obligations S1-S5 are true as stated and assemble to the theorem. The (p) clause is exactly lem:min's printed statement under the standing assumption, and L01 is consumed as a final-passed module. Proof work may begin.

STATEMENT GATE: PASS
