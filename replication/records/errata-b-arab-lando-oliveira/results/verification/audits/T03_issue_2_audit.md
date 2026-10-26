# T03 issue 2 audit: counterexample review (step at :337, "h(0)=0")

- Role: pv-auditor (Claude Opus 5.5), independent subagent; counterexample-review mode. Tue Oct 13 02:29:34 EDT 2026 (`date`).
- Reviewed: ruling `verification/audits/T03_issue_2.md`; Lean `pv_work/T03_Counterexample2.lean` (sha256 71bf06d5…8c8091f), read in full; imports `T03_Counterexample1` (audited in `T03_issue_1_audit.md`), `P04_Counterexample2` (sha256 5b3ca85e…62b6f, = `P04_issue_2_audit.md`, which names `pareto_Icc_pos`), `T01_Counterexample1` (sha256 1c16f7ae…f06408f4, = `T01_issue_1_audit.md`, which names `h0_cont`, `h0_star`).
- Source read directly: `source/SuperParetoPaper-v12.tex` (= gate hash) :111, :121-124, :279, :284-287, :308-311, :332-338, :426.

## 1. Encoding fidelity (decisive item)

Source :337: "Given the shift invariance of the convex transform order, X being super-Pareto is equivalent to X =d h(Y), where h is increasing convex and h(0)=0, hence h is star-shaped", with Y=Z-1, F_Z=𝒫.

| Check | Result |
|---|---|
| `PrintedStep337` | for every nonnegative super-Pareto law μ, ∃ g monotone and convex on [0,∞), g 0 = 0, μ = law of g(Y). This is the forward direction only (the only one the proof uses). h is required only on [0,∞), the support of Y. It is weaker than the printed "equivalent", never stronger |
| Global vs constructed objects | `lawY` = `paretoMeasure.map (·-1)`, gated (T03Stmt:21, fingerprint th=3087119417 vh=1427334908 = T03_gate); h is existentially chosen per X, as in the source |
| Hypotheses kept | "nonnegative" (:334) is kept as a premise (extra premise relative to the bare sentence, so the clause is weaker) |
| Null-set artefact? | no. Y has no atom at 0, but convexity on [0,∞) with g(0)=0 forces g(y) ≤ y·g(1) near 0, so the value at 0 constrains the law. The Lean proof uses exactly this; the non-a.e.-measurable branch is handled (map = 0 contradicts probability) |
| Draft obligation | probe `pv_work/probes/auditor/T03/T03_cx_audit_probe.lean`: `GatedS3b` (T03Draft.lean:32-34 copied verbatim) `= DraftS3b` by `rfl`; and S3a ∧ S3b ⇒ `PrintedStep337` (example compiles), so refuting `PrintedStep337` also refutes gated S3b given the true S3a |
| `not_T03_T01Consumed` target | `T03_T01Consumed` fingerprint in walk (th=3944470172 vh=4166300400) = T03_gate. Refuted with g=max(y-1,0) (`h0`, audited in T01_issue_1_audit). This confirms gate item 6 in Lean |

## 2. The instance satisfies every printed hypothesis

X = Z (law `paretoMeasure`): super-Pareto with h = id (Def 4.1: increasing, convex, nonconstant; `sp_Z`), and nonnegative (Z ≥ 1, `nonneg_Z`). By hand: any admissible g must agree a.e. on (0,∞) with y ↦ y+1 (quantile matching), and then g(0)=0 together with convexity gives y+1 ≤ 2y near 0+, a contradiction. No definition in the source excludes Z; the source itself treats Z as the reference super-Pareto/ITS law (:279).

## 3. The counterexample is proved

| Check | Result |
|---|---|
| Compile (auditor run) | `scripts/pv_lean.sh check T03_Counterexample2` → `RESULT … exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T03_Counterexample2_4.log` |
| Axioms (log :133-136; walks :2, :32, :57, :99) | `not_PrintedStep337`, `not_DraftS3b`, `not_T03_T01Consumed`, `consumed_of_printed`: `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false` |
| Earlier theorems used | `Paper.P04.Issue2.pareto_Icc_pos` (PASS record `P04_issue_2_audit.md:35`, file hash unchanged); `Paper.T01.Issue1.h0`, `h0_cont`, `h0_star` (PASS record `T01_issue_1_audit.md:27-28`, file hash unchanged); `T03_Counterexample1` helpers (`pm_eq`, `Iic_one`, `F_P_*`, `F_map_pre`; covered by `T03_issue_1_audit.md`). Gated definitions `L01Stmt`, `P04Stmt`, `T01Stmt` (`StarShaped` vh=2775174033 = T01_gate_r2:42), `T03Stmt`: fingerprints identical to gate records |
| Probe | `pv_work/logs/T03_cx_audit_probe_1.log`: `RESULT … exit=0 errors=0`; `gatedMain_exfalso`, `gatedBody_false` use standard axioms only |
| Non-vacuity | X=Z satisfies all hypotheses and the conclusion of Thm 4.8 (`consumed_of_printed`, `isInvSub_Z`); `isInvSub_lawY` proves S5 |

## 4. Scope

- Refutes: the step "h(0)=0" at :337 (forward direction, for nonnegative super-Pareto X), and the gated obligation S3b. By reasoning it fails for every X with positive essential infimum, since g(0+) = ess inf X. The cited "shift invariance of ≤_c" gives only the reparametrisation h(Z) = g(Y) with g(y)=h(y+1); it does not determine g(0). The authors' remark at :426 confirms that shifts matter here.
- Does not refute: S3a (true, gate), S3c, S5 (proved here), or Thm 4.8 at X=Z (true there). The falsity of Thm 4.8 itself is recorded once, in issue 1 (instance B, where both the step and the conclusion fail).
- `not_T03_T01Consumed` is a formalization-side consequence of T01_issue_1 (consumed clause false). It is not a new paper issue of T03, but it means T03 cannot be CONDITIONAL on that clause (no ex-falso use; probe `gatedMain_exfalso` shows why this matters).
- Classification PAPER_ARGUMENT_GAP for the step: confirmed. The justification given fails and the intermediate claim is false. Since the paper's conclusion is already ERROR under issue 1, the "threatens conclusion: yes" label is correct.

## 5. Suggested fix

Restricting to "F_X(0)=0 and F_X(x)>0 for x>0" gives h(1)=0, so g(0)=0 holds directly from Def 4.1 (monotone and convex force h(1)=h(1+)=ess inf X=0). Then the rest of :337 goes through with the T01 repair (h>0 on (0,∞)), since g>0 on (0,∞). Checked by reasoning (see `T03_issue_1_audit.md` §5); it looks sufficient. Suggestion only, not evidence.

Reason: X = Z (Pareto(1), nonnegative super-Pareto under the gated Def 4.1 encoding) admits no increasing convex g on [0,∞) with g(0)=0 and X =d g(Y); `¬ PrintedStep337` and `¬ DraftS3b` (= gated S3b, by `rfl`) compile with standard axioms only, using only audited earlier lemmas.
COUNTEREXAMPLE VALID
