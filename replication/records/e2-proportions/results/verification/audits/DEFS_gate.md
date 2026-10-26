# Statement gate: DEFS (shared definitions)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Mon Oct 12 21:45:04 EDT 2026
- Reviewed file: `pv_work/Defs.lean`, sha256 `0259b9aa4c03c2e64066ab3240783bfdbb600dc04c0b6182dccc0d6a1e831b67`
- Compilation: `scripts/pv_lean.sh check Defs` -> `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/Defs_2.log`
- Snapshot probe: `pv_work/probes/gate/DEFS/gate_DEFS_defscopy.lean` (verbatim copy of Defs.lean + `import PVTools` + `#pv_type_hashes_here`), `exit=0`, log `pv_work/logs/gate_DEFS_defscopy_1.log`
- Draft notes `pv_work/notes/DEFS_draft_notes.md` read as leads only; all rulings below are from the source text.

## Source quotations

- main.tex:24 — "Throughout, $n \ge 1$ is an integer and $I$ denotes the unit interval."
- main.tex:26-28 (def:vp) — "For $p \in \mathbb{R}$, let $V_n(p) = p(1-p)/n$; for $p \in I$ this is the variance of the proportion of successes in $n$ independent trials with success probability $p$."
- main.tex:31-33 (def:svar) — "For $m \ge 2$ and $u \in \mathbb{R}^m$, let $\bar u = \frac1m \sum_{i=1}^m u_i$ and $s^2(u) = \frac{1}{m-1} \sum_{i=1}^m (u_i - \bar u)^2$."
- Uses of $I$: main.tex:27, 48, 52, 56, 66.

## Item rulings

1. **Hypotheses / hidden assumptions.** PASS. No `variable`, structure or type class carries hidden hypotheses. `n ≥ 1` (main.tex:24) and `m ≥ 2` (main.tex:32) are not built into the definitions; they must appear as explicit hypotheses in each result statement (to be checked at each result's gate). Leaving them out of the defs is a sound representation choice: the defs only define total functions, and the junk values (`n = 0`: `/0 = 0`; `m = 1`: `1/0 = 0`; `m = 0`) are never in scope when the hypotheses are present.
2. **Content.** PASS.
   - `V n p = p * (1 - p) / (n : ℝ)` matches main.tex:27 exactly, domain `p ∈ ℝ` as printed. `n : ℕ` versus "integer": with `n ≥ 1` these coincide.
   - `mean u = (1/(m:ℝ)) * ∑ i, u i` matches main.tex:32; `Fin m → ℝ` faithfully represents $\mathbb{R}^m$ (indices 0..m-1 vs 1..m is notation only).
   - `s2 u = (1/((m:ℝ) - 1)) * ∑ i, (u i - mean u)^2` matches main.tex:33; the subtraction is in ℝ, so there is no ℕ truncation trap.
3. **Quantifiers / constants.** PASS (no constants in definitions).
4. **Domains.** PASS with a recorded ambiguity. The source does not say whether $I$ is $[0,1]$ or $(0,1)$ (main.tex:24). The draft provides both `IOpen := Set.Ioo 0 1` and `IClosed := Set.Icc 0 1` and defers the choice to each result. This is acceptable for shared definitions, provided each result gate checks that its choice is recorded and does not manufacture a paper error. Observation from the source: main.tex:27-28 ("success probability $p$") naturally includes 0 and 1 (closed reading), while main.tex:52 ("both $p$ and $1-p$ are positive") only holds on the open interval; Lemma lem:positive (main.tex:48) is false for the closed reading at $p = 0, 1$.
5. **Step obligations.** N/A (definitions only, no obligations).
6. **External parameters.** N/A (none declared). Namespace `Paper.DEFS`, no name collisions observed.
7. **Doubts about the source.** Suspected issue (preliminary, not ruled here): main.tex:24 together with main.tex:48/52 — the meaning of "unit interval" is undetermined; under the closed reading suggested by main.tex:27-28, lem:positive is false at $p\in\{0,1\}$. Preliminary class `DOMAIN_CLARIFICATION` (possibly `PAPER_ASSUMPTION_GAP` for lem:positive under the closed reading). Recommend the coordinator dispatch `pv-issue-checker` when lem:positive is processed.

## TFAs ruled on

None (no premises in definitions).

## External parameters

None.

## Required changes

None.

## Statement snapshot (verbatim from `pv_work/logs/gate_DEFS_defscopy_1.log`)

```
TYPE HASHES (current file, 5 declarations)
Paper.DEFS.IClosed|def|th=1707065593|vh=3517529939|bi=
Paper.DEFS.IOpen|def|th=1707065593|vh=3179713877|bi=
Paper.DEFS.V|def|th=869665623|vh=2666805293|bi=ee
Paper.DEFS.mean|def|th=1210414734|vh=911562101|bi=ie
Paper.DEFS.s2|def|th=1210414734|vh=2090720030|bi=ie
EXIT=0
```

## Overall verdict

Definitions are faithful to main.tex:24-34. The open/closed ambiguity of $I$ is correctly left explicit rather than resolved silently; each result gate must check the choice.

STATEMENT GATE: PASS
