# Human-check worksheet for external inputs

**There are no external inputs.** All four results (Lemma 2.1, Lemma 2.2, Theorem 2.3, Corollary 2.4) are verified unconditionally, and `python3 scripts/pv_status.py tools` reports an empty registry.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| – | 0 | none | – | – |

Gap hypotheses are not external inputs. There are none either: no result has an open issue.

## Previously registered, now removed

- `T01_L02Consumed` (type (p), predecessor L02, main.tex:54-56): a clause of Lemma 2.2 that Theorem 2.3 used as a parameter while Lemma 2.2 had issue B1. After revision 2, Lemma 2.2 is verified unconditionally and T01 imports it directly, so the parameter no longer exists (`verification/audits/T01_final.md` §4). Nothing to check.
- `C01_L02Consumed` (debt in words): removed in the same way (`verification/AUDIT.md` C01 cascade entry of 2026-10-13 01:22; `verification/audits/C01_final.md` §3-4: no consumed clauses).

## What a person should still compare

The base definitions are the only encoded content that a person must confirm (see `FILES_TO_CHECK.md` §3): D01 risk, D02 oracle factor, D03 oracle risk and D04 standing assumption against main.tex:25-33.

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `Paper.risk θ σ c` | `pv_work/Defs.lean:12` | R(c) = c²σ² + (1−c)²θ² |
| `Paper.oracleFactor θ σ` | `pv_work/Defs.lean:15` | c* = θ²/(θ²+σ²) |
| `Paper.oracleRisk θ σ` | `pv_work/Defs.lean:18` | ρ = θ²σ²/(θ²+σ²) |
| `Paper.Setting θ σ` | `pv_work/Defs.lean:7` | θ ≠ 0 ∧ 0 < σ |
