# L02 issue 1: counterexample review (pv-auditor)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:12:57 EDT 2026 (from `date`)
- Reviewed: ruling `verification/audits/L02_issue_1.md`; counterexample `pv_work/L02_Counterexample1.lean`
  (sha256 `8395f348ef8352f58316892f5a1fb3c7d961c864154303c532a2755feeacf449`, matches the ruling, checked with `python3 scripts/pv_snapshot.py hash`)
- Source read directly: `source/main.tex` whole file (90 lines), in particular :24, :26-29, :47-53.
- Auditor probe: `pv_work/probes/auditor/L02/auditor_L02_issue1.lean`, log `pv_work/logs/auditor_L02_issue1_1.log`.

## 1. Encoding fidelity (decisive item)

| Check | Result |
|---|---|
| Source clause main.tex:48 (+ :24 "$n\ge1$ is an integer") | "For every $p\in I$, $V_n(p)>0$" |
| `PrintedClauseClosed` = `∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, p ∈ IClosed → 0 < V n p` | word for word under the closed reading |
| `IClosed = Set.Icc 0 1`, `IOpen = Set.Ioo 0 1`, `V n p = p*(1-p)/n` | confirmed by `rfl` in auditor probe; `Defs` has gate record `DEFS_gate.md` |
| Independent re-encoding (`0 ≤ p ∧ p ≤ 1 → 0 < p*(1-p)/n`) `Iff.rfl` with `PrintedClauseClosed` | compiles |
| Not stronger than source | same premises ($n\ge1$, $p\in I$), same conclusion ($>0$); no premise dropped, conclusion not strengthened |
| `n : ℕ` with `1 ≤ n` vs "integer $n\ge1$" | faithful type conversion |
| Parameter vs global objects | $n$ is the global convention of :24, $p$ is bound by the lemma; $I$ is a global symbol (:24), $V_n$ is defined for all $p\in\mathbb R$ (:27) |
| `PrintedClauseOpen` equals the gated statement `∀ n, 1 ≤ n → ∀ p, L02Claim n p` | `Iff.rfl` in auditor probe |

## 2. The instance satisfies every printed hypothesis

- Instance $n=1$, $p=0$ (and $p=1$): $1\ge1$; $0\in[0,1]$ (`zero_mem_closed`), $1\in[0,1]$ (`one_mem_closed`).
- No definition in the source excludes it: `def:vp` (:27) defines $V_n(p)$ for every $p\in\mathbb R$; :24 does not specify the endpoints; nothing else in the text defines $I$.
- Under the closed reading $V_1(0)=0\not>0$. I re-proved this independently with `norm_num` against the raw formula (auditor probe), without the checker's lemmas.

## 3. The counterexample itself is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh build L02_Counterexample1` (auditor rerun) | exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 |
| `#pv_axioms L02_Counterexample1` | ALL STANDARD (13 declarations) |
| `#pv_walk_decl …counterexample` / `…counterexample_one` | axioms `[propext, Classical.choice, Quot.sound]`, sorryAx false; project constants reached: only `Defs.IClosed`, `Defs.V` (gate PASS in `DEFS_gate.md`) and the file's own lemmas. No earlier theorem used |
| `#pv_walk_decl …open_holds` | clean axioms, no sorryAx; reaches `L02_main`, `L02_S1`, `L02_S2` (module `L02`) |
| `#pv_hyp_usage closed_fails_exactly_at_endpoints` | all 4 binders USED |

Correction to the ruling: it calls `L02_main` "audited". Currently `L02` only has `L02_mech.md` (MECH CHECKS: PASS) and its gate. It has **no** `L02_final.md` yet. This does not affect the counterexample, whose closure does not reach module `L02`. It does mean that `open_holds` and the reverse direction of `closed_fails_exactly_at_endpoints` rest on a theorem that has not had its final audit. The open-reading claim is elementary (a product and a quotient of positives) and I find it credible, but until the L02 final audit passes it is not covered by an individual PASS record.

## 4. Scope

- **Refuted:** only `PrintedClauseClosed`, i.e. main.tex:48 under $I=[0,1]$, at $p\in\{0,1\}$ for every $n\ge1$. Also refuted under that reading: the proof sentence main.tex:52 (`proof_sentence_closed_false`).
- **Not refuted:** the open reading (`closed_implies_open` confirms the closed clause is the stronger one). The open reading is proved (`open_holds`, subject to the caveat in §3).
- **Downstream:** I confirm from the source that the only `\ref`s are to `lem:quarter` (:70, :78). `lem:positive` is consumed by nothing, so no downstream result is affected. The ruling is right that `prop:concave` and `lem:linear` use the same symbol $I$, so the chosen reading must be applied consistently to them.

## 5. Classification and "threatens conclusion"

- **`DOMAIN_CLARIFICATION`: confirmed.** The statement is true under $(0,1)$ and false under $[0,1]$, and both readings have textual support. $[0,1]$ is the conventional meaning of "unit interval" and the natural range of a success probability (:27-28). $(0,1)$ is pinned by the proof's own sentence (:52), which holds iff $I\subseteq(0,1)$. `ERROR` would require choosing the reading that manufactures the error (POLICY §1). `PAPER_ASSUMPTION_GAP` and `EXPOSITION_GAP` do not fit, for the reasons the ruling gives, which I checked.
- **"THREATENS CONCLUSION: no": confirmed, with its stated qualification.** The answer is no under the reading fixed by the source's own proof. Under the conventional closed reading the conclusion is false at the endpoints. The ruling states this explicitly (§4) and flags it for a human check, which I agree with.
- Half-open readings (ruling §8): it is correct by the same arithmetic that the lemma fails at the included endpoint. This is reasoning only, which is acceptable as stated.

## 6. Suggested fix

- "Write lem:positive as for every $p\in(0,1)$": this turns the clause into exactly `PrintedClauseOpen`, which is proved. **Sufficient.**
- "State the interval at :24": this is sufficient for this lemma only if the stated interval is $(0,1)$. If the authors state $[0,1]$, the lemma becomes false, so that case needs the local restriction. The ruling's wording ("state which interval is meant") should be read with this caveat. Its preference for restricting only `lem:positive` is correct.

## 7. Side observation (ruling §7, outside this review)

- I checked the ruling's arithmetic: $p(1-p)\le p/4$ with $p=1/10$ gives $0.09\le0.025$, which is false. So `lem:linear` (:66) looks false on any reading of $I$ that contains $1/10$.
- This is credible but is reasoning only. It needs its own ruling.

## 8. Not checked

- The full final audit of L02 (`L02_main`), which is not part of this review.

COUNTEREXAMPLE VALID (PrintedClauseClosed is a faithful, not-stronger encoding of main.tex:48 under I=[0,1]; instance n=1, p=0 satisfies all printed hypotheses; clean, sorry-free proof using only gated Defs; refutes only the closed reading, so DOMAIN_CLARIFICATION / threatens conclusion: no is correct)
