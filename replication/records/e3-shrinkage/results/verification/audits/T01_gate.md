# Statement gate: T01 (Theorem thm:oracle, source/main.tex:63-66; proof 68-72), revision re-draft

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Tue Oct 13 01:16:15 EDT 2026 (from `date`)
- Read directly: `source/main.tex:1-84` (convention l.25, Definition l.27-35, lem:square l.39-52, lem:min l.54-61, thm:oracle l.63-72); `pv_work/T01Stmt.lean`, `pv_work/T01Draft.lean`, `pv_work/Defs.lean`, `pv_work/L01Stmt.lean`, `pv_work/L01.lean`, `pv_work/L02Stmt.lean`, `pv_work/L02.lean` in full; `verification/source_baseline_v1/main.tex:58-67`; previous gate `verification/audits/rev2/T01_gate.md`; verdict lines of `verification/audits/L01_final.md`, `L02_final.md`, `L01_mech.md`, `L02_mech.md`; RESULTS.json entries for L01, L02, T01. Draft notes read as leads only.

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

| File | sha256 |
|---|---|
| pv_work/T01Stmt.lean | a64ad4ae55d7d4fa0cfcdaf6cd6956123feb1587871eab0aa2516fa3de061363 |
| pv_work/T01Draft.lean | bd9ff516293f2cced05a7deb56f4bc3adcee2f3245f0c3fadd24ddb92635f1f0 |
| pv_work/Defs.lean | 1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31 (unchanged, = DEFS-gated / rev2 gate) |
| pv_work/L01Stmt.lean | 456d4367a87aaead1e652bd2f7bde0e259271aac77ffac71f0594c6593a259d9 |
| pv_work/L02Stmt.lean | 0706aacdcaba4be9c94d0a42b8e97882f31759972436f03b4c66b9b10cb272c1 |
| pv_work/L01.olean | a464e835c09f889d8c50f004c73a949d8c1a6caf8a9de6dcdd448df822e91b1d (= delivered = rebuilt in `L01_mech.md`) |
| pv_work/L02.olean | 06f8f111e16359a17368de17a9906197bf929b443f9203c1f34968e5f36e09b2 (= delivered = rebuilt in `L02_mech.md`) |

## Compilation

`scripts/pv_lean.sh check T01Draft`: `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_4.log olean=none`. The 3 sorries are S1-S3 (expected for a draft); `T01_main` itself is sorry-free assembly.

## Source quotations

- main.tex:25 "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:29 "$R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$"; :31 "$c^\ast = \theta^2 / (\theta^2 + \sigma^2)$"; :33 "$\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$".
- main.tex:40 (lem:square) "For every $c \in \mathbb{R}$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$."
- main.tex:55 (lem:min) "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:64-65 (thm:oracle) "For every $c \in \mathbb{R}$, $R(c) \ge \rho$, with equality if and only if $c = c^\ast$. Moreover, $\rho \le \min\{R(0), R(1)\}$."
- main.tex:69-71 (proof) "By Lemma~\ref{lem:square}, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2 \ge 0$, with equality if and only if $c = c^\ast$, because $\theta^2 + \sigma^2 > 0$. Since $R(0) = \theta^2$ and $R(1) = \sigma^2$, Lemma~\ref{lem:min} gives $\rho \le \min\{R(0), R(1)\}$."

Revision check: T01's history names `baseline_before: verification/source_baseline_v2`, which does not exist in the project (only `source_baseline/` and `source_baseline_v1/`). I compared with `verification/source_baseline_v1/main.tex:58-67`: the theorem (l.59-60) and proof (l.64-66) are character-identical to current l.64-65 and l.69-71; only line numbers moved (+5). Recommend the coordinator correct the `baseline_before` entry (record-keeping only; no effect on this gate).

## Item rulings

1. **Hypotheses: PASS.** `T01_main (θ σ : ℝ) (h : Setting θ σ)`. `Setting` (Defs D04) is l.25 verbatim (`θ ≠ 0`, `0 < σ`), DEFS-gated, unchanged hash. No `variable`s, type classes or hidden fields; `Conclusion` contains no premises. The former consumed-clause binder `hL02 : T01_L02Consumed` is gone, and no other premise replaced it. No hypothesis states the conclusion.
2. **Conclusion: PASS.** `Conclusion` fields `ge` (∀c, ρ ≤ R c), `eq_iff` (∀c, R c = ρ ↔ c = c*), `le_min` (ρ ≤ min (R 0) (R 1)) match l.64-65 clause by clause. Content unchanged from the rev2 gated statement: all ten `Paper.T01.Conclusion*` lines of `#pv_type_hashes_here` (th/vh/bi) are identical to those in `verification/audits/rev2/T01_gate.md` (compared line by line, not by eye; see snapshot). The only removed declaration is `T01_L02Consumed`.
3. **Quantifiers / constants: PASS.** θ, σ fixed with `Setting`; c universally quantified inside the clauses. No existential constants.
4. **Domains / details: PASS.** All in ℝ; no ENNReal/toReal, a.e., measurability issues. Definitions DEFS-gated.
5. **Step obligations: PASS** (each checked for truth as stated).
   - S1 (l.69) `Setting → ρ ≤ R c ∧ (R c = ρ ↔ c = c*)`: TRUE, from `Paper.L01.L01` (R c − ρ = (θ²+σ²)(c−c*)²) and θ²+σ² > 0 (from `Setting`), exactly the source's reasoning. Merging the ≥ and the equality case into one obligation matches the single sentence l.69-70.
   - S2 (l.70) `R 0 = θ² ∧ R 1 = σ²`: TRUE unconditionally (direct computation from l.29, stated in the source).
   - S3 (l.70-71) `Setting → ρ ≤ min (R 0) (R 1)`: TRUE, from `Paper.L02.L02_main θ σ h.theta_ne h.sigma_pos : oracleRisk ≤ min (θ²) (σ²)` rewritten with S2. Not a stronger intermediate claim; it is clause 3 obtained by the source's one-step route.
   - Assembly: `T01_main := ⟨(S1 ·).1, (S1 ·).2, S3⟩` compiles (exit 0) and yields `Conclusion`. S2 feeds S3 as in l.70.
6. **External parameters / consumed clauses: PASS (none).** No `def … : Prop` parameter remains in `T01Stmt.lean`. Legitimacy of the imports:
   - `T01Draft.lean` imports the **final** modules `L01` and `L02` (not drafts). `L01.olean` and `L02.olean` sha256 equal the delivered = rebuilt hashes in `L01_mech.md` / `L02_mech.md`; `L01_final.md` and `L02_final.md` (dated Tue Oct 13 01:14, i.e. this revision) end `FINAL AUDIT: PASS` / `SUGGESTED VERDICT: UNCONDITIONAL`; RESULTS.json records both `FINAL_PASSED`, `UNCONDITIONAL`, with no conditions. So consuming them as proved theorems instead of a (p) clause is correct, and T01 will inherit no condition from them.
   - The consumed theorems match the source's uses: `Paper.L01.L01` has hypotheses only `Setting θ σ`, conclusion = l.40; `Paper.L02.L02_main` has hypotheses `θ ≠ 0`, `0 < σ` (= the fields of `Setting`), conclusion `Paper.L02.Conclusion θ σ := ρ ≤ min (θ²) (σ²)` = l.55. Applicability at T01's (θ, σ) holds via `h`.
   - `T01Stmt.lean` imports only `Defs`; the statement depends on nothing from L01/L02. Names: no redeclaration (`Paper.T01.Conclusion` is distinct from `Paper.L02.Conclusion`; inside `namespace Paper.T01`, `Conclusion` resolves to the T01 structure, confirmed by the 3-field anonymous constructor compiling). All T01 declarations are in `namespace Paper.T01`.
   - The final audit must confirm with `#pv_axioms` that `T01_main` depends on L01/L02 only through sorry-free, standard-axiom theorems; the gate cannot check that on a draft.
7. **Doubts about the source: none.** The printed proof l.69-71 is sound given lem:square and lem:min as stated; both lemmas are now final-passed unconditionally. The former L02 issue (B1, revision 2) concerned L02's old proof only and is not in the current L02 record. No dispatch needed.

## TFAs ruled

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premises. θ²+σ² > 0 is printed at l.70 and derived from `Setting` inside S1. |

## External parameters / consumed clauses

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | `T01_L02Consumed` removed; L01 and L02 consumed as final-passed UNCONDITIONAL modules (hashes verified above). |

## Required changes

None.

Non-blocking remarks (no change required): (a) the main theorem was renamed from `Paper.T01.T01` (rev2) to `Paper.T01.T01_main`; the coordinator should update `lean_main` accordingly when recording. (b) RESULTS.json `baseline_before` for T01 names a non-existent `verification/source_baseline_v2` (see above).

## Statement snapshot

Copies: `pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (probe exit=0, 0 sorry, log `pv_work/logs/gate_T01_stmtcopy_2.log`) and `pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (probe exit=0, 3 sorry, log `pv_work/logs/gate_T01_draftcopy_2.log`). Both copies are the reviewed files verbatim plus `import PVTools` and `#pv_type_hashes_here`.

T01Stmt copy:
```
TYPE HASHES (current file, 10 declarations)
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
```

T01Draft copy:
```
TYPE HASHES (current file, 4 declarations)
Paper.T01.T01_S1|thm|th=2274156465|vh=-|bi=eeee
Paper.T01.T01_S2|thm|th=2630739230|vh=-|bi=ee
Paper.T01.T01_S3|thm|th=3599759756|vh=-|bi=eee
Paper.T01.T01_main|thm|th=2978291362|vh=-|bi=eee
```

## Overall verdict

The statement is faithful to main.tex:63-66 and unchanged in content from the rev2 gate (identical `Conclusion` hashes); the consumed clause is correctly removed because L01 and L02 are imported as final-passed unconditional modules whose olean hashes match their audits. Obligations S1-S3 are true as stated and assemble to the theorem. Proof work may begin.

STATEMENT GATE: PASS
