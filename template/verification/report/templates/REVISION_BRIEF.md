# Revision brief

(Template, kit v1.3.1. Copy it to `verification/REVISION_BRIEF.md` when a project re-checks a revised manuscript
with material from an earlier check, or imports a check that was not made with this kit;
`autosetup/import_legacy.py` fills in sections 1–3. Every session reads this file first when it exists:
`CLAUDE.md`, "Must read before any work".)

## 1. What this round is

- Kind: <revision k of a paper checked with this kit | import of an earlier check made without this kit>
- Earlier check: <where it is, when it was made, with what>
- Current manuscript: `source/` (baseline `verification/source_baseline/`; the previous manuscript, if any, is in
  `verification/source_baseline_v<k>/`)

## 2. Mapping of results

| Earlier ID or number | Kit ID | PDF number now | Earlier verdict | Notes |
|---|---|---|---|---|

The earlier verdicts are recorded in each result's `history` (revision label below), so that the report can show a
before/after table. They are never evidence for a verdict in this round.

## 3. Reused Lean material

- Location: `pv_work/<folder>/` (read-only; listed in the deny rules of `.claude/settings.json`)
- Modules copied / rebuilt / failed: <n> / <n> / <n> (failures usually are drafts that contain `sorry`)
- Build log: `pv_work/logs/import_legacy.log`

## 4. What changed in the manuscript

(Filled in by `/pv-revise` or by the user: the changed results and definitions, with locations.)

## 5. Rules for reusing earlier material

1. A result is verified in this round only by this round's gate, proof and final audit. A module that compiled in the
   earlier check is not evidence by itself.
2. Reused modules are infrastructure: a constant from them that a proof reaches needs an individual audit record in
   this round, as for any other project constant (`pv_audit_mech.py` item 8).
3. Reused modules are never edited. A needed change is made in a new file of the result, and the old module stays as
   it is.
4. Earlier issue reports are leads for the gate and the auditors, not findings of this round; an issue is recorded only
   after this round's issue ruling and review.

## 6. Notes for this round

-
