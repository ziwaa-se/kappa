#!/usr/bin/env python3
"""pv_status.py — read verification/RESULTS.json and report progress honestly (kit v1.3).

Usage (from the project root):
  python3 scripts/pv_status.py table               progress table (for screenshots)
  python3 scripts/pv_status.py validate            check every verdict against the records that must back it
  python3 scripts/pv_status.py next [--second-pass] [--all]
                                                   results that can start now, and results blocked by a prerequisite
  python3 scripts/pv_status.py reconnect           CONDITIONAL results still using a (p) predecessor clause whose
                                                   predecessor is now proved (PIPELINE stage 6b)
  python3 scripts/pv_status.py tools               external-input registry as a Markdown table
  python3 scripts/pv_status.py paths FILE.md       check that every `path` quoted in a Markdown file exists
  python3 scripts/pv_status.py supersede FILE "reason" [REPLACED_BY]
                                                   move FILE into pv_work/superseded/ and log it in its README.md
  python3 scripts/pv_status.py outputs ID          (v1.3) verdict lines of every report of ID, last EXIT= of its
                                                   logs, and its pv_work files: check a subagent's outputs cheaply
  python3 scripts/pv_status.py record ID --verdict V --stage S [--reason R] [--conditions a,b] [--lean-main ...]
                                    [--summary-en ...] [--row ...] [--audit-note ...] [...]
                                                   (v1.3) write the entry of ID in RESULTS.json (evidence paths are
                                                   filled in from the latest reports), its PAPER_VERIFICATION.md row
                                                   and header counts, and an AUDIT.md section; then validate
  python3 scripts/pv_status.py add-tool '<JSON>'   (v1.3) register or update one external input (fields of
                                                   _example_tool), then validate
  python3 scripts/pv_status.py reset ID [ID ...] --revision K
                                                   (v1.3) cascade-reset results after a revision (/pv-revise), keeping
                                                   their previous verdict and issues in 'history'
  python3 scripts/pv_status.py followup            (v1.3) what a revision changed: previous verdict and issues of each
                                                   re-checked result, and whether those issues are now resolved
  python3 scripts/pv_status.py human-check TOOL --by NAME --how TEXT
                                                   (v1.3) record that a person checked an external input; the results
                                                   using it stay CONDITIONAL and are listed as "checked by a person"
  python3 scripts/pv_status.py source-check        (v1.3) is source/ still the paper this project was set up
                                                   for? SAME / CHANGED (new version: /pv-revise) / DIFFERENT_PAPER
  python3 scripts/pv_status.py init-checklist [--force]
                                                   (v1.3) one "Unfinished" row per result and the header counts

Verdicts (verification/rules/VERDICTS.md):
  UNCONDITIONAL  the paper's proof of the whole statement is verified with no parameter and no debt
  CONDITIONAL    verified, but with visible parameters, recorded debts or unencoded parts
  ISSUE          a concrete, independently confirmed problem in this result's own statement or proof
  UNFINISHED     not decided yet; never counted as a paper error
"""
import hashlib
import json
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
STATE = ROOT / "verification" / "RESULTS.json"
BLOCKERS = ROOT / "verification" / "BLOCKERS.md"
CHECKLIST = ROOT / "verification" / "PAPER_VERIFICATION.md"
PVTOOLS = ROOT / "pv_work" / "PVTools.lean"

VERDICTS = ["UNCONDITIONAL", "CONDITIONAL", "ISSUE", "UNFINISHED"]
STAGES = ["NOT_STARTED", "INVENTORIED", "STATEMENT_DRAFTED", "GATE_PASSED", "PROVING",
          "PROVED", "FINAL_PASSED", "ISSUE_CHECK", "STOPPED"]
# Allowed reasons per stage (PIPELINE.md, stage table). Any other combination is an error.
STAGE_REASONS = {
    "NOT_STARTED": {"", "WAITING_ON_DEPENDENCY", "SOURCE_CHANGED"},
    "INVENTORIED": {"", "WAITING_ON_DEPENDENCY", "SOURCE_CHANGED"},
    "STATEMENT_DRAFTED": {""}, "GATE_PASSED": {""}, "PROVING": {""},
    "PROVED": {"", "AUDIT_PENDING"}, "FINAL_PASSED": {""}, "ISSUE_CHECK": {""},
    "STOPPED": {"GATE_FAILED", "TRANSLATION_BLOCKED", "BUDGET_EXHAUSTED", "AUDIT_FAILED",
                "ISSUE_RECORDED", "ISSUE_UNCONFIRMED"},
}
PROVENANCE = ["i", "ii", "iii", "iv", "v", "p"]
PAPER_CODES = {"ERROR", "PAPER_ARGUMENT_GAP", "PAPER_ASSUMPTION_GAP", "EXPOSITION_GAP", "DOMAIN_CLARIFICATION"}
EN = {"UNCONDITIONAL": "Verified (unconditional)", "CONDITIONAL": "Verified (conditional)",
      "ISSUE": "Issue recorded", "UNFINISHED": "Unfinished"}


def load():
    if not STATE.exists():
        sys.exit(f"missing {STATE.relative_to(ROOT)}; run /pv-setup first")
    try:
        return json.loads(STATE.read_text())
    except json.JSONDecodeError as e:
        sys.exit(f"RESULTS.json is not valid JSON: {e}")


def cell(s):
    return str(s or "").replace("|", "\\|").replace("\n", " ")


def as_list(x):
    if x is None:
        return []
    return x if isinstance(x, list) else [x]


def evidence_paths(ev, key=""):
    """Flatten evidence (str, list or nested dict) into (key, path) pairs."""
    out = []
    if isinstance(ev, dict):
        for k, v in ev.items():
            out.extend(evidence_paths(v, k))
    elif isinstance(ev, list):
        for v in ev:
            out.extend(evidence_paths(v, key))
    elif isinstance(ev, str) and ev:
        out.append((key, ev))
    return out


def exists(p):
    return isinstance(p, str) and bool(p) and (ROOT / p.split(":")[0].strip()).exists()


def verdict_line(path, prefix):
    """Value of the last line starting with `prefix` among the last 5 non-empty lines of a report."""
    if not isinstance(path, str) or not path:
        return None
    f = ROOT / path.split(":")[0]
    if not f.exists():
        return None
    lines = [l.strip().strip("*` ") for l in f.read_text(errors="replace").splitlines() if l.strip()]
    val = None
    for s in lines[-5:]:
        if s.startswith(prefix):
            val = s[len(prefix):].strip().strip("*` ")
    return val


def is_pass(v):
    return bool(v) and re.match(r"PASS(?![A-Z_])", v) is not None


def blockers():
    """{id: dict(open, result, codes)} from BLOCKERS.md headings '## Bnn — <ID> / <no.> — <CODE> ...'."""
    if not BLOCKERS.exists():
        return {}
    text = re.sub(r"<!--.*?-->", "", BLOCKERS.read_text(), flags=re.S)
    out = {}
    for m in re.finditer(r"^##\s+(B\d+)\b(.*)$", text, flags=re.M):
        rest = m.group(2)
        rid = re.match(r"\s*[—–-]+\s*([A-Za-z][A-Za-z0-9_-]*)", rest)
        out[m.group(1)] = {
            "open": re.search(r"(?<!UN)RESOLVED", rest.upper()) is None,
            "result": rid.group(1) if rid else None,
            "codes": set(re.findall(r"\b[A-Z][A-Z_]{3,}\b", rest)) & PAPER_CODES,
        }
    return out


def reason_text(r):
    parts = []
    for key, en in [("conditions", "conditions"), ("debts", "debts"), ("unencoded", "not encoded"),
                    ("issues", "issues"), ("gaps", "gaps"), ("upstream_issues", "upstream issues")]:
        if r.get(key):
            parts.append(en + ": " + ", ".join(map(str, as_list(r[key]))))
    if r.get("verdict") == "UNFINISHED" and (r.get("reason") or r.get("partial")):
        parts.append("stopped: " + " ".join(x for x in [r.get("reason", ""), r.get("partial", "")] if x))
    return "; ".join(parts)


def all_checked(data, r):
    """True when r is CONDITIONAL only through registered external inputs that a person has checked."""
    tools = {t.get("id"): t for t in data.get("external_tools", []) if isinstance(t, dict)}
    conds = as_list(r.get("conditions"))
    return (r.get("verdict") == "CONDITIONAL" and bool(conds) and not r.get("debts") and not r.get("unencoded")
            and all(isinstance(tools.get(c, {}).get("human_checked"), dict) for c in conds))


def table(data):
    res = data.get("results", [])
    names = EN
    counts = {v: sum(1 for r in res if r.get("verdict") == v) for v in VERDICTS}
    checked = sum(1 for r in res if all_checked(data, r))
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    title = data.get("paper", {}).get("title", "")
    print(f"## Verification progress — {title} ({stamp})\n")
    print(f"**{len(res)} numbered results: " + " · ".join(f"{counts[v]} {names[v].lower()}" for v in VERDICTS) + ".**\n")
    if checked:
        print(f"Of the results verified conditionally, {checked} {'has' if checked == 1 else 'have'} every condition checked by a person "
              f"(still conditional: the conditions are not checked in Lean).\n")
    print("| No. | ID | Result | Verdict | Stage | Conditions / issues / where stopped |")
    print("|---|---|---|---|---|---|")
    for r in res:
        v = r.get("verdict", "UNFINISHED")
        extra = r.get("summary_en") or reason_text(r)
        vname = names.get(v, v)
        if all_checked(data, r):
            vname += "; conditions checked by a person"
        hist = r.get("history") if isinstance(r.get("history"), list) else []
        if hist:
            h = hist[-1]
            extra = f"(before revision {h.get('revision')}: {names.get(h.get('verdict'), h.get('verdict'))}) " + (extra or "")
        what = " ".join(x for x in [r.get("kind", ""), r.get("title", "")] if x)
        stage = r.get("stage")
        print(f"| {cell(r.get('pdf_number'))} | {cell(r.get('id'))} | {cell(what)} | {vname} | "
              f"{cell(stage)} | {cell(extra)} |")


def validate(data):
    errs, warns = [], []
    raw = data.get("results", [])
    for i, r in enumerate(raw):
        if not isinstance(r, dict) or not r.get("id"):
            errs.append(f"results[{i}] has no id")
    res = [r for r in raw if isinstance(r, dict) and r.get("id")]
    ids = [r["id"] for r in res]
    if len(ids) != len(set(ids)):
        errs.append("duplicate result ids")
    byid = {r["id"]: r for r in res}
    tool_list = data.get("external_tools", [])
    for i, t in enumerate(tool_list):
        if not isinstance(t, dict) or not t.get("id"):
            errs.append(f"external_tools[{i}] must be an object with an id")
    tool_list = [t for t in tool_list if isinstance(t, dict) and t.get("id")]
    tool_ids = [t.get("id") for t in tool_list]
    for t in sorted(set(x for x in tool_ids if tool_ids.count(x) > 1)):
        errs.append(f"duplicate external_tools id {t} (name (p) clauses <ID>_<PredID>Consumed)")
    tools = {t.get("id"): t for t in tool_list}
    for t in tools.values():
        if t.get("provenance") not in PROVENANCE:
            errs.append(f"tool {t.get('id')}: provenance must be one of {PROVENANCE} "
                        f"(gap hypotheses go in the result's 'gaps' field, not here)")
        if t.get("provenance") == "p" and t.get("predecessor") not in byid:
            errs.append(f"tool {t.get('id')}: provenance p needs 'predecessor' = an existing result id")
    bl = blockers()
    lean = data.get("lean", {}) or {}
    if lean.get("pvtools_sha256") and not PVTOOLS.exists():
        errs.append("pv_work/PVTools.lean is missing (the audit tool must not be removed)")
    elif lean.get("pvtools_sha256"):
        if hashlib.sha256(PVTOOLS.read_bytes()).hexdigest() != lean["pvtools_sha256"]:
            errs.append("pv_work/PVTools.lean changed since /pv-setup recorded its sha256 (the audit tool must not change)")
    for d in data.get("defs", []):
        if d.get("id") == "NONE":
            continue
        gv = verdict_line(d.get("gate", ""), "STATEMENT GATE:")
        if not is_pass(gv):
            errs.append(f"defs {d.get('id')}: gate report missing or its verdict line is not PASS ({gv})")
        if d.get("built") and not exists(str(d.get("file", "")).replace(".lean", ".olean")):
            errs.append(f"defs {d.get('id')}: marked built but no .olean")
    for r in res:
        rid, v, st = r["id"], r.get("verdict"), r.get("stage")
        reason = r.get("reason", "")
        if v not in VERDICTS:
            errs.append(f"{rid}: verdict {v!r} is not one of {VERDICTS}")
        if st not in STAGES:
            errs.append(f"{rid}: stage {st!r} is not one of {STAGES}")
        elif reason not in STAGE_REASONS[st]:
            errs.append(f"{rid}: reason {reason!r} is not allowed with stage {st} (allowed: {sorted(STAGE_REASONS[st])})")
        if r.get("round", 1) not in (1, 2):
            errs.append(f"{rid}: round must be 1 or 2")
        deps = r.get("depends_on", [])
        if not isinstance(deps, list):
            errs.append(f"{rid}: depends_on must be a list")
            deps = []
        for d in deps:
            if d not in byid:
                errs.append(f"{rid}: unknown dependency {d}")
        ev = r.get("evidence", {})
        if not isinstance(ev, dict):
            errs.append(f"{rid}: evidence must be an object")
            ev = {}
        for key in ("gate", "final", "reconnect"):
            if key in ev and ev[key] and not isinstance(ev[key], str):
                errs.append(f"{rid}: evidence.{key} must be one path string (the latest report)")
        for key, p in evidence_paths(ev):
            if not exists(p):
                errs.append(f"{rid}: evidence[{key}] missing on disk: {p}")
            elif "verification/audits/" in p and not Path(p.split(":")[0]).name.startswith(f"{rid}_"):
                errs.append(f"{rid}: evidence[{key}] {p} is not one of {rid}'s reports")
        lm = r.get("lean_main", "")
        if not isinstance(lm, str):
            errs.append(f"{rid}: lean_main must be a string")
            lm = ""
        lm_file = lm.split()[0] if lm else ""
        for key in ("conditions", "gaps", "issues", "upstream_issues", "debts", "unencoded"):
            if any(not isinstance(x, str) for x in as_list(r.get(key))):
                errs.append(f"{rid}: every entry of '{key}' must be a string")
        conds = [c for c in as_list(r.get("conditions")) if isinstance(c, str)]
        for c in conds:
            if c not in tools:
                errs.append(f"{rid}: condition {c} is not registered in external_tools")
        gaps = [g for g in as_list(r.get("gaps")) if isinstance(g, str)]
        issues = [b for b in as_list(r.get("issues")) if isinstance(b, str)]
        for b in as_list(r.get("upstream_issues")):
            if isinstance(b, str) and b not in bl:
                errs.append(f"{rid}: upstream issue {b} has no '## {b}' heading in verification/BLOCKERS.md")
        own_open = [b for b in issues if b in bl and bl[b]["open"] and bl[b]["codes"] and bl[b]["result"] == rid]
        for b in issues:
            if b not in bl:
                errs.append(f"{rid}: issue {b} has no '## {b}' heading in verification/BLOCKERS.md")
            elif bl[b]["result"] != rid:
                errs.append(f"{rid}: issue {b} belongs to {bl[b]['result']}; list a predecessor's issue under 'upstream_issues'")
        if v in ("UNCONDITIONAL", "CONDITIONAL"):
            if st != "FINAL_PASSED":
                errs.append(f"{rid}: verdict {v} requires stage FINAL_PASSED (is {st})")
            if r.get("statement_fixed") is not True:
                errs.append(f"{rid}: verdict {v} requires statement_fixed: true")
            gv = verdict_line(ev.get("gate"), "STATEMENT GATE:")
            fv = verdict_line(ev.get("final"), "FINAL AUDIT:")
            if not is_pass(gv):
                errs.append(f"{rid}: evidence.gate must end with 'STATEMENT GATE: PASS' (found {gv})")
            if not is_pass(fv):
                errs.append(f"{rid}: evidence.final must end with 'FINAL AUDIT: PASS' (found {fv})")
            sv = verdict_line(ev.get("final"), "SUGGESTED VERDICT:")
            if sv and sv.split()[0] != v:
                warns.append(f"{rid}: recorded verdict {v} but the final audit suggests {sv}")
            if not lm:
                errs.append(f"{rid}: verdict {v} requires lean_main (file:line theorem-name)")
            elif not exists(lm_file):
                errs.append(f"{rid}: lean_main file missing: {lm}")
            if "ModGaps" in lm or "_mod_gaps" in lm:
                errs.append(f"{rid}: lean_main is a gap-file theorem; the verdict must be ISSUE or UNFINISHED")
            if "Closed" in lm_file and not is_pass(verdict_line(ev.get("reconnect"), "RECONNECT AUDIT:")):
                errs.append(f"{rid}: lean_main is a Closed file but evidence.reconnect does not end with 'RECONNECT AUDIT: PASS'")
            if gaps:
                errs.append(f"{rid}: has gap hypotheses {gaps}; the verdict must be ISSUE or UNFINISHED")
            if own_open:
                errs.append(f"{rid}: verdict {v} but open paper-side issues {own_open}; use ISSUE")
            for d in deps:
                dv = byid.get(d, {}).get("verdict")
                if v == "UNCONDITIONAL" and dv in ("CONDITIONAL", "ISSUE", "UNFINISHED"):
                    warns.append(f"{rid}: UNCONDITIONAL but dependency {d} is {dv}; confirm only its unconditional part is used")
        if ev.get("reconnect") and not is_pass(verdict_line(ev.get("reconnect"), "RECONNECT AUDIT:")):
            errs.append(f"{rid}: evidence.reconnect does not end with 'RECONNECT AUDIT: PASS'")
        if v == "UNCONDITIONAL" and (conds or r.get("debts") or r.get("unencoded")):
            errs.append(f"{rid}: UNCONDITIONAL but lists conditions/debts/unencoded parts; use CONDITIONAL")
        if v == "CONDITIONAL" and not (conds or r.get("debts") or r.get("unencoded")):
            errs.append(f"{rid}: CONDITIONAL needs a condition, a recorded debt or an unencoded part")
        if v == "ISSUE" and not (st == "STOPPED" and reason == "ISSUE_RECORDED"):
            errs.append(f"{rid}: verdict ISSUE requires stage STOPPED with reason ISSUE_RECORDED")
        if reason == "ISSUE_RECORDED" and v != "ISSUE":
            errs.append(f"{rid}: reason ISSUE_RECORDED requires verdict ISSUE")
        if v == "ISSUE":
            if not own_open:
                errs.append(f"{rid}: ISSUE needs an open blocker of this result with a paper-side code {sorted(PAPER_CODES)}")
            confirmed = False
            for rep in as_list(ev.get("issues")):
                iv = verdict_line(rep, "ISSUE VERDICT:")
                aud = rep.replace(".md", "_audit.md") if isinstance(rep, str) else ""
                cx = (verdict_line(aud, "COUNTEREXAMPLE") or "").split()
                rv = (verdict_line(aud, "REVIEW:") or "").split()
                ok = (cx[:1] == ["VALID"]) or (rv[:1] == ["CONFIRMED"])
                if iv and iv.split()[0] in PAPER_CODES and ok:
                    confirmed = True
            if not confirmed:
                errs.append(f"{rid}: ISSUE needs evidence.issues with a paper-side 'ISSUE VERDICT:' and a matching "
                            f"_audit.md ending 'COUNTEREXAMPLE VALID' or 'REVIEW: CONFIRMED'")
        if v == "UNFINISHED" and st not in ("NOT_STARTED", "INVENTORIED") and not (reason or r.get("partial")):
            warns.append(f"{rid}: UNFINISHED after work started; record 'reason' and 'partial'")
        if v == "CONDITIONAL":
            for c in conds:
                t = tools.get(c, {})
                if t.get("provenance") == "p":
                    pred = byid.get(t.get("predecessor"), {})
                    if pred.get("stage") == "FINAL_PASSED" and pred.get("verdict") in ("UNCONDITIONAL", "CONDITIONAL"):
                        warns.append(f"{rid}: predecessor clause {c} can now be reconnected to {pred.get('id')} (stage 6b)")
    seen, stack = set(), set()

    def visit(n):
        if n in stack:
            errs.append(f"dependency cycle through {n}")
            return
        if n in seen or n not in byid:
            return
        stack.add(n)
        deps_n = byid[n].get("depends_on", [])
        for d in deps_n if isinstance(deps_n, list) else []:
            visit(d)
        stack.discard(n)
        seen.add(n)

    for n in list(byid):
        visit(n)
    if CHECKLIST.exists():
        text = CHECKLIST.read_text()
        m = re.search(r"\*\*(\d+) numbered results: (\d+) verified unconditionally, (\d+) verified conditionally, "
                      r"(\d+) with recorded issues, (\d+) unfinished", text)
        want = [len(res)] + [sum(1 for r in res if r.get("verdict") == x) for x in VERDICTS]
        if not m:
            (errs if res else warns).append(
                "PAPER_VERIFICATION.md header count line not found (expected '**N numbered results: a verified "
                "unconditionally, b verified conditionally, c with recorded issues, d unfinished')")
        elif [int(x) for x in m.groups()] != want:
            errs.append(f"PAPER_VERIFICATION.md header counts {list(map(int, m.groups()))} != RESULTS.json {want}")
    st, det = source_state(data)
    if st == "CHANGED" and not any(isinstance(r, dict) and r.get("reason") == "SOURCE_CHANGED" for r in res):
        warns.append(f"source/ differs from verification/source_baseline/ ({len(det)} files): for a new version of the "
                     f"same paper run /pv-revise; a different paper needs a new project (pv_status.py source-check)")
    elif st == "DIFFERENT_PAPER":
        warns.append("source/ seems to hold a DIFFERENT paper than the one this project was set up for; never check "
                     "two papers in one project (python3 scripts/pv_status.py source-check)")
    for w in warns:
        print("WARN", w)
    for e in errs:
        print("ERROR", e)
    print("VALID" if not errs else f"INVALID ({len(errs)} errors)")
    return 0 if not errs else 1


def next_ready(data, second_pass=False, use_all=False):
    res = [r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")]
    byid = {r["id"]: r for r in res}
    scope = set(data.get("run_scope", []) or []) if not use_all else set()
    dependents = {r["id"]: 0 for r in res}
    for r in res:
        for d in r.get("depends_on", []) if isinstance(r.get("depends_on"), list) else []:
            if d in dependents:
                dependents[d] += 1
    ready, blocked = [], []
    for r in res:
        if scope and r["id"] not in scope:
            continue
        if r.get("verdict") != "UNFINISHED":
            continue
        if second_pass:
            if not (r.get("stage") == "STOPPED" and r.get("reason") in
                    ("TRANSLATION_BLOCKED", "BUDGET_EXHAUSTED", "AUDIT_FAILED") and int(r.get("round", 1)) < 2):
                continue
        elif r.get("stage") not in ("NOT_STARTED", "INVENTORIED"):
            continue
        # A result can start once every prerequisite's statement is fixed (its gate passed): the prerequisite's exact
        # consumed clause then enters as a visible (p) parameter if the prerequisite is still unproved.
        deps = r.get("depends_on", []) if isinstance(r.get("depends_on"), list) else []
        waiting = [d for d in deps if d in byid and not byid[d].get("statement_fixed")]
        (blocked if waiting else ready).append((r, waiting))
    ready.sort(key=lambda x: (-dependents[x[0]["id"]], str(x[0].get("pdf_number", ""))))
    for r, _ in ready:
        print(f"READY\t{r['id']}\t{r.get('pdf_number')}\tstage={r.get('stage')}\tdependents={dependents[r['id']]}")
    for r, waiting in blocked:
        notes = []
        for d in waiting:
            dd = byid[d]
            tag = f"{d}({dd.get('stage')}" + (f"/{dd.get('reason')}" if dd.get("reason") else "")
            tag += ", outside run_scope)" if scope and d not in scope else ")"
            notes.append(tag)
        print(f"BLOCKED\t{r['id']}\t{r.get('pdf_number')}\tblocked by {', '.join(notes)}")
    if not ready and not blocked:
        print("nothing to start (all decided or in progress)")


def reconnect(data):
    byid = {r["id"]: r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")}
    tools = {t.get("id"): t for t in data.get("external_tools", [])}
    found = False
    for r in byid.values():
        if not (r.get("verdict") == "CONDITIONAL" and r.get("stage") == "FINAL_PASSED"):
            continue
        for c in as_list(r.get("conditions")):
            t = tools.get(c, {})
            if t.get("provenance") == "p":
                pred = byid.get(t.get("predecessor"), {})
                if pred.get("stage") == "FINAL_PASSED" and pred.get("verdict") in ("UNCONDITIONAL", "CONDITIONAL"):
                    print(f"{r['id']}\tuses {c}\tpredecessor {pred['id']} is {pred['verdict']}: reconnect (stage 6b)")
                    found = True
    if not found:
        print("no pending reconnections")


def tools_table(data):
    print("| ID | Lean | Meaning | Type | Source location | Used by | Human check | Checked by a person |")
    print("|---|---|---|---|---|---|---|---|")
    for t in data.get("external_tools", []):
        prov = str(t.get("provenance", "")) + (f" (predecessor {t['predecessor']})" if t.get("predecessor") else "")
        print(f"| {cell(t.get('id'))} | {cell(t.get('lean'))} | {cell(t.get('meaning'))} | {cell(prov)} | "
              f"{cell(t.get('source_loc'))} | {cell(', '.join(map(str, as_list(t.get('consumers')))))} | "
              f"{cell(t.get('human_check'))} | {cell(checked_text(t))} |")


def paths(md):
    f = Path(md) if Path(md).is_absolute() else ROOT / md
    if not f.exists():
        sys.exit(f"no such file: {md}")
    missing, checked = [], 0
    for tok in re.findall(r"`([^`\s]+)`", f.read_text()):
        p = tok.split(":")[0]
        if "/" not in p or any(ch in p for ch in "<>*{}$") or p.startswith(("http", "#")):
            continue
        if p.startswith("/") and p.count("/") == 1:   # a slash command such as /pv-run
            continue
        checked += 1
        target = Path(p) if p.startswith("/") else ROOT / p
        if not target.exists():
            missing.append(tok)
    for m in sorted(set(missing)):
        print("MISSING", m)
    print(f"checked {checked} path references; {len(set(missing))} missing")
    return 0 if not missing else 1


def supersede(src, reason, replaced_by=""):
    s = (Path(src) if Path(src).is_absolute() else ROOT / src).resolve()
    work = (ROOT / "pv_work").resolve()
    if work not in s.parents or s == PVTOOLS.resolve() or (work / "superseded") in s.parents or not s.is_file():
        sys.exit(f"refused: supersede only moves files under pv_work/ (not PVTools.lean, not superseded/): {src}")
    dest_dir = ROOT / "pv_work" / "superseded"
    dest_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    dest = dest_dir / s.name
    k = 2
    while dest.exists():
        dest = dest_dir / f"{s.stem}_{k}{s.suffix}"
        k += 1
    shutil.move(str(s), str(dest))
    readme = dest_dir / "README.md"
    if not readme.exists():
        readme.write_text("# pv_work/superseded\n\n| File | Date | Reason | Replaced by |\n|---|---|---|---|\n")
    with open(readme, "a") as fh:
        fh.write(f"| {dest.name} | {stamp} | {cell(reason)} | {cell(replaced_by)} |\n")
    print(f"moved {src} -> {dest.relative_to(ROOT)}; logged in pv_work/superseded/README.md")


# ---------------------------------------------------------------------------------------------------------------
# v1.3 bookkeeping helpers: they only do formatting, counting and file lookup. Every judgement (verdict, conditions,
# issue codes, summaries) is still passed in by the coordinator.

VERDICT_PREFIXES = ["STATEMENT GATE:", "FINAL AUDIT:", "SUGGESTED VERDICT:", "ISSUE VERDICT:", "THREATENS CONCLUSION:",
                    "COUNTEREXAMPLE", "REVIEW:", "RECONNECT AUDIT:", "MECH CHECKS:"]
CHECK_EN = {"UNCONDITIONAL": "Verified unconditionally", "CONDITIONAL": "Verified conditionally",
            "ISSUE": "Recorded issue", "UNFINISHED": "Unfinished"}
AUDITS = ROOT / "verification" / "audits"


def now():
    return datetime.now().strftime("%Y-%m-%d %H:%M")


def report_rank(p):
    m = re.search(r"_r(\d+)(?:_audit)?\.md$", p.name)
    return int(m.group(1)) if m else 1


def latest_report(rid, kind, pass_prefix=None):
    """Latest verification/audits/<rid>_<kind>[_r<k>].md; with pass_prefix, the latest whose verdict is PASS."""
    cands = [p for p in AUDITS.glob(f"{rid}_{kind}*.md") if re.fullmatch(rf"{re.escape(rid)}_{kind}(?:_r\d+)?\.md", p.name)]
    for p in sorted(cands, key=report_rank, reverse=True):
        rel = str(p.relative_to(ROOT))
        if pass_prefix is None or is_pass(verdict_line(rel, pass_prefix)):
            return rel
    return ""


def outputs(rid):
    """Everything the coordinator needs to check after a subagent returns, without reading whole reports."""
    print(f"## Outputs of {rid} ({now()})")
    for p in sorted(AUDITS.glob(f"{rid}_*.md"), key=lambda q: (q.name.split("_r")[0], report_rank(q))):
        found = []
        for pre in VERDICT_PREFIXES:
            v = verdict_line(str(p.relative_to(ROOT)), pre)
            if v is not None:
                found.append(f"{pre} {v}")
        print(f"REPORT\t{p.relative_to(ROOT)}\t{' | '.join(found) if found else 'NO VERDICT LINE IN LAST 5 LINES'}")
    logs = {}
    for p in (ROOT / "pv_work" / "logs").glob("*.log"):
        m = re.fullmatch(r"(.+)_(\d+)\.log", p.name)
        if m and (m.group(1) == rid or m.group(1).startswith(rid) or f"_{rid}_" in m.group(1)):
            k = int(m.group(2))
            if k > logs.get(m.group(1), (0, None))[0]:
                logs[m.group(1)] = (k, p)
    for base, (k, p) in sorted(logs.items()):
        last = (p.read_text(errors="replace").strip().splitlines() or [""])[-1]
        print(f"LOG\t{p.relative_to(ROOT)}\t{last}")
    for p in sorted((ROOT / "pv_work").glob(f"{rid}*")):
        if p.is_file():
            print(f"FILE\t{p.relative_to(ROOT)}\t{p.stat().st_size} bytes")
    for p in sorted((ROOT / "pv_work" / "notes").glob(f"{rid}_*")):
        print(f"NOTES\t{p.relative_to(ROOT)}\t{p.stat().st_size} bytes")


def header_line(data):
    res = [r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")]
    c = {v: sum(1 for r in res if r.get("verdict") == v) for v in VERDICTS}
    return (f"**{len(res)} numbered results: {c['UNCONDITIONAL']} verified unconditionally, {c['CONDITIONAL']} verified "
            f"conditionally, {c['ISSUE']} with recorded issues, {c['UNFINISHED']} unfinished ({now()}).**")


def set_header(data):
    if not CHECKLIST.exists():
        return
    text = CHECKLIST.read_text()
    new, n = re.subn(r"^\*\*\d+ numbered results: .*?\*\*\s*$", header_line(data), text, count=1, flags=re.M)
    CHECKLIST.write_text(new if n else header_line(data) + "\n\n" + text)


def upsert_row(rid, verdict, text, pdf="", page=""):
    """Replace (or append) the row of rid in the first table of PAPER_VERIFICATION.md (the 'PDF no.' table)."""
    lines = CHECKLIST.read_text().splitlines()
    head = next((i for i, l in enumerate(lines) if l.startswith("|") and "PDF" in l), None)
    if head is None:
        sys.exit("PAPER_VERIFICATION.md has no '| PDF no. | ...' table")
    i = head + 2
    row_idx = None
    while i < len(lines) and lines[i].startswith("|"):
        cells = [c.strip() for c in lines[i].strip().strip("|").split("|")]
        if len(cells) >= 5 and cells[2] == rid:
            row_idx = i
        i += 1
    if row_idx is not None:
        cells = [c.strip() for c in lines[row_idx].strip().strip("|").split("|")]
        cells[3], cells[4] = CHECK_EN.get(verdict, verdict), cell(text)
        lines[row_idx] = "| " + " | ".join(cells) + " |"
    else:
        lines.insert(i, f"| {cell(pdf)} | {cell(page)} | {rid} | {CHECK_EN.get(verdict, verdict)} | {cell(text)} |")
    CHECKLIST.write_text("\n".join(lines) + "\n")


def aux_pages():
    pages = {}
    for aux in (ROOT / "source").rglob("*.aux"):
        for m in re.finditer(r"\\newlabel\{([^}]*)\}\{\{([^}]*)\}\{([^}]*)\}", aux.read_text(errors="replace")):
            pages[m.group(1)] = m.group(3)
    return pages


def init_checklist(data, force=False):
    """Create one 'Unfinished' row per numbered result (replacing the template's example row) and the header."""
    text = CHECKLIST.read_text()
    ids = {r.get("id") for r in data.get("results", []) if isinstance(r, dict) and r.get("id")}
    existing = [l for l in text.splitlines() if l.startswith("|") and not l.startswith("| Example")
                and len(l.split("|")) > 4 and l.split("|")[3].strip() in ids]
    if existing and not force:
        sys.exit("PAPER_VERIFICATION.md already has result rows; use --force to rebuild them")
    pages = aux_pages()
    rows = []
    for r in data.get("results", []):
        if isinstance(r, dict) and r.get("id"):
            where = "; ".join(x for x in [f"statement {r.get('statement_loc', '')}" if r.get("statement_loc") else "",
                                          f"proof {r.get('proof_loc', '')}" if r.get("proof_loc") else ""] if x)
            rows.append(f"| {cell((r.get('kind', '') + ' ' + str(r.get('pdf_number', ''))).strip())} | "
                        f"{cell(pages.get(r.get('label', ''), ''))} | {r['id']} | Unfinished | Not started. {cell(where)} |")
    lines = [l for l in text.splitlines() if not l.startswith("| Example")]
    if force:
        lines = [l for l in lines if not (l.startswith("|") and len(l.split("|")) > 4 and l.split("|")[3].strip() in ids)]
    at = next((i + 1 for i, l in enumerate(lines) if l.startswith("|---") and i > 0 and "PDF" in lines[i - 1]), len(lines))
    lines[at:at] = rows
    CHECKLIST.write_text("\n".join(lines) + "\n")
    set_header(data)
    print(f"PAPER_VERIFICATION.md: {len(rows)} rows, header updated")


def sha(p):
    f = ROOT / p
    return hashlib.sha256(f.read_bytes()).hexdigest() if f.is_file() else "missing"


def record(rid, argv):
    import argparse
    ap = argparse.ArgumentParser(prog=f"pv_status.py record {rid}")
    ap.add_argument("--verdict", choices=VERDICTS)
    ap.add_argument("--stage", choices=STAGES)
    ap.add_argument("--reason")
    ap.add_argument("--round", type=int)
    ap.add_argument("--statement-fixed", choices=["true", "false"])
    for k in ("conditions", "gaps", "issues", "upstream-issues", "debts", "unencoded", "models-used"):
        ap.add_argument("--" + k, help="comma-separated; '' clears")
    ap.add_argument("--partial")
    ap.add_argument("--lean-main")
    ap.add_argument("--summary-en")
    ap.add_argument("--tier", choices=["easy", "medium", "hard"])
    for k in ("gate", "final", "reconnect", "issues-evidence"):
        ap.add_argument("--evidence-" + k if k != "issues-evidence" else "--evidence-issues")
    ap.add_argument("--row", help="text of the PAPER_VERIFICATION.md row (default: summary_en)")
    ap.add_argument("--audit-note", help="key points for the AUDIT.md section (reviewer, FAIL items, assessment)")
    ap.add_argument("--resolve", help="comma-separated B numbers that this new verdict resolves (after a revision); "
                                      "their headings get '— RESOLVED (date, …; re-verified in <final report>)'")
    a = ap.parse_args(argv)
    data = load()
    byid = {r.get("id"): r for r in data.get("results", []) if isinstance(r, dict)}
    if rid not in byid:
        sys.exit(f"unknown result id {rid}")
    r = byid[rid]
    for field, val in [("verdict", a.verdict), ("stage", a.stage), ("reason", a.reason), ("round", a.round),
                       ("partial", a.partial), ("lean_main", a.lean_main), ("summary_en", a.summary_en),
                       ("tier", a.tier)]:
        if val is not None:
            r[field] = val
    if a.statement_fixed is not None:
        r["statement_fixed"] = a.statement_fixed == "true"
    if a.stage is not None and a.reason is None and r.get("reason", "") not in STAGE_REASONS.get(a.stage, {""}):
        r["reason"] = ""   # e.g. SOURCE_CHANGED from a reset does not apply once the result is re-verified
    for k in ("conditions", "gaps", "issues", "upstream-issues", "debts", "unencoded", "models-used"):
        val = getattr(a, k.replace("-", "_"))
        if val is not None:
            r[k.replace("-", "_")] = [x.strip() for x in val.split(",") if x.strip()]
    ev = r.get("evidence") if isinstance(r.get("evidence"), dict) else {}
    ev["gate"] = a.evidence_gate or ev.get("gate") or latest_report(rid, "gate", "STATEMENT GATE:")
    ev["final"] = a.evidence_final or ev.get("final") or latest_report(rid, "final")
    if a.evidence_reconnect is not None:
        ev["reconnect"] = a.evidence_reconnect
    if a.evidence_issues is not None:
        ev["issues"] = [x.strip() for x in a.evidence_issues.split(",") if x.strip()]
    r["evidence"] = {k: v for k, v in ev.items() if v not in ("", None, [])}
    r["updated"] = now()
    if a.resolve:
        if r.get("verdict") not in ("UNCONDITIONAL", "CONDITIONAL") or not r["evidence"].get("final"):
            sys.exit("--resolve needs a verified verdict (UNCONDITIONAL or CONDITIONAL) with a final audit report")
        before = ((r.get("history") or [{}])[-1].get("evidence") or {}).get("final")
        if before and before == r["evidence"]["final"]:
            sys.exit(f"--resolve refused: {before} is the final audit from before the revision; an issue is resolved "
                     f"only by a new final audit of the revised statement")
        text = BLOCKERS.read_text()
        rev = (r.get("history") or [{}])[-1].get("revision", "?")
        for b in [x.strip() for x in a.resolve.split(",") if x.strip()]:
            text, found = edit_heading(text, b, lambda h: re.sub(r"\s*—\s*RECHECK \(revision [^)]*\)\s*$", "", h).rstrip()
                                       + f" — RESOLVED ({now()}, revision {rev}; re-verified in {r['evidence']['final']})")
            if not found:
                sys.exit(f"no '## {b}' heading in BLOCKERS.md")
        BLOCKERS.write_text(text)
    STATE.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    set_header(data)
    upsert_row(rid, r.get("verdict", "UNFINISHED"), a.row or r.get("summary_en", ""), 
               f"{r.get('kind', '')} {r.get('pdf_number', '')}".strip(), aux_pages().get(r.get("label", ""), ""))
    # AUDIT.md: one section per recording, with the verdict lines and sha256 of the evidence (no judgement added)
    audit = ROOT / "verification" / "AUDIT.md"
    sec = [f"\n## {rid} ({r.get('pdf_number', '')}) — {r.get('verdict')} / {r.get('stage')}"
           f"{'/' + r['reason'] if r.get('reason') else ''} — {r['updated']} (recorded with pv_status.py record)"]
    for key, path in evidence_paths(r["evidence"]):
        vals = [f"{p} {verdict_line(path, p)}" for p in VERDICT_PREFIXES if verdict_line(path, p) is not None]
        sec.append(f"- {key}: `{path}` — {'; '.join(vals) or 'no verdict line'} — sha256 {sha(path.split(':')[0])[:16]}…")
    lm = r.get("lean_main", "")
    if lm:
        f = lm.split()[0].split(":")[0]
        sec.append(f"- Lean: `{lm}` — sha256 {sha(f)[:16]}…, .olean {sha(f.replace('.lean', '.olean'))[:16]}…")
    for k in ("conditions", "gaps", "issues", "upstream_issues", "debts", "unencoded", "models_used"):
        if r.get(k):
            sec.append(f"- {k}: {', '.join(map(str, as_list(r[k])))}")
    if a.audit_note:
        sec.append(f"- Key points: {a.audit_note}")
    with audit.open("a") as fh:
        fh.write("\n".join(sec) + "\n")
    print(f"recorded {rid}: verdict={r.get('verdict')} stage={r.get('stage')} reason={r.get('reason', '')} "
          f"evidence={r['evidence']}")
    return validate(load())


def edit_heading(text, b, fn):
    """Apply fn to the '## <b> …' heading line that is not inside an HTML comment. Returns (text, found)."""
    comments = [(m.start(), m.end()) for m in re.finditer(r"<!--.*?-->", text, flags=re.S)]
    for m in re.finditer(rf"^##\s+{re.escape(b)}\b[^\n]*$", text, flags=re.M):
        if not any(a <= m.start() < z for a, z in comments):
            return text[:m.start()] + fn(m.group(0)) + text[m.end():], True
    return text, False


def checked_text(t):
    h = t.get("human_checked")
    return f"{h.get('by', '?')}, {h.get('date', '?')}: {h.get('how', '')}" if isinstance(h, dict) else "not yet"


def human_check(tool_id, argv):
    """Record that a person checked one external input (who, when, how). It stays a condition of every result."""
    import argparse
    ap = argparse.ArgumentParser(prog=f"pv_status.py human-check {tool_id}")
    ap.add_argument("--by", required=True, help="who checked it")
    ap.add_argument("--how", required=True, help="what was checked, against which source (book, paper, theorem number)")
    ap.add_argument("--date", default=None)
    ap.add_argument("--undo", action="store_true", help="remove the record")
    a = ap.parse_args(argv)
    data = load()
    tools = [t for t in data.get("external_tools", []) if isinstance(t, dict)]
    t = next((x for x in tools if x.get("id") == tool_id), None)
    if t is None:
        sys.exit(f"unknown external input {tool_id}; see python3 scripts/pv_status.py tools")
    if a.undo:
        t.pop("human_checked", None)
    else:
        if t.get("provenance") == "p":
            print("NOTE: a (p) clause is normally closed by reconnection to its predecessor (PIPELINE stage 6b), "
                  "not by a human check; recording it anyway.")
        t["human_checked"] = {"by": a.by, "date": a.date or now(), "how": a.how}
    STATE.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    users = [r["id"] for r in data.get("results", []) if tool_id in as_list(r.get("conditions"))]
    done = [r["id"] for r in data.get("results", []) if all_checked(data, r)]
    print(f"{'removed' if a.undo else 'recorded'} human check of {tool_id}; used by: {', '.join(users) or 'none'}")
    print(f"results whose every condition is now checked by a person: {', '.join(done) or 'none'} "
          f"(they stay CONDITIONAL; the report lists them separately)")
    return validate(load())


def reset(ids, argv):
    """Reset results after a change of the source or of a gated statement (PIPELINE 'Cascade reset'), keeping the
    previous state in the result's 'history' so that the next report can show what the revision changed."""
    import argparse
    ap = argparse.ArgumentParser(prog="pv_status.py reset ID [ID ...]")
    ap.add_argument("--revision", required=True, help="revision label, e.g. 2 or 2026-10-01")
    ap.add_argument("--reason", default="SOURCE_CHANGED", choices=["SOURCE_CHANGED", ""],
                    help="SOURCE_CHANGED after /pv-revise; '' after an ENCODING_ERROR fix")
    a = ap.parse_args(argv)
    data = load()
    byid = {r.get("id"): r for r in data.get("results", []) if isinstance(r, dict)}
    unknown = [i for i in ids if i not in byid]
    if unknown:
        sys.exit(f"unknown result ids {unknown}")
    bl = blockers()
    text = BLOCKERS.read_text() if BLOCKERS.exists() else ""
    for rid in ids:
        r = byid[rid]
        keep = {k: r.get(k) for k in ("verdict", "stage", "reason", "conditions", "gaps", "issues", "upstream_issues",
                                      "debts", "unencoded", "partial", "lean_main", "evidence", "summary_en")}
        keep.update(revision=str(a.revision), date=now())
        r.setdefault("history", []).append(keep)
        r.update(statement_fixed=False, stage="INVENTORIED", reason=a.reason, verdict="UNFINISHED", conditions=[],
                 gaps=[], issues=[], upstream_issues=[], evidence={}, lean_main="", partial="", summary_en="")
        for b in as_list(keep.get("issues")):
            if b in bl and bl[b]["open"]:
                text, _ = edit_heading(text, b, lambda h: h.rstrip() + f" — RECHECK (revision {a.revision})")
        upsert_row(rid, "UNFINISHED", f"Reset after revision {a.revision} (was {CHECK_EN.get(keep['verdict'], keep['verdict'])}"
                   + (f"; issues {', '.join(keep['issues'])} to be re-checked" if keep.get("issues") else "") + ").")
    if BLOCKERS.exists():
        BLOCKERS.write_text(text)
    STATE.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    set_header(data)
    # Cascade hint: results that depend on a reset result, directly or not (PIPELINE "Cascade reset").
    dependents, frontier = set(), set(ids)
    while frontier:
        nxt = {r["id"] for r in data.get("results", []) if isinstance(r, dict) and r.get("id") not in ids
               and set(as_list(r.get("depends_on"))) & frontier and r.get("id") not in dependents}
        dependents |= nxt
        frontier = nxt
    print(f"reset {', '.join(ids)} (revision {a.revision}); their previous verdicts are kept in 'history'")
    if dependents:
        print(f"CASCADE CHECK: {', '.join(sorted(dependents))} depend on them. Reset those that import a changed module, "
              f"use a (p) clause of it, or have a Closed file referring to it (PIPELINE 'Cascade reset').")
    return validate(load())


def followup(data):
    """What a revision changed: previous verdict and issues of each re-checked result, and where they stand now."""
    rows = [r for r in data.get("results", []) if isinstance(r, dict) and r.get("history")]
    if not rows:
        print("no result has been reset after a revision")
        return
    bl = blockers()
    print("| No. | ID | Before (revision) | Now | Issues found before | Status of those issues |")
    print("|---|---|---|---|---|---|")
    for r in rows:
        h = r["history"][-1]
        issues = as_list(h.get("issues"))
        st = []
        for b in issues:
            if b not in bl:
                st.append(f"{b}: not in BLOCKERS.md")
            elif not bl[b]["open"]:
                st.append(f"{b}: resolved")
            elif r.get("verdict") == "UNFINISHED":
                st.append(f"{b}: re-check pending")
            elif b in as_list(r.get("issues")):
                st.append(f"{b}: still present")
            else:
                st.append(f"{b}: new verdict {r.get('verdict')}, but {b} is still open: close it with record --resolve")
        print(f"| {cell(r.get('pdf_number'))} | {r['id']} | {CHECK_EN.get(h.get('verdict'), h.get('verdict'))} "
              f"(revision {cell(h.get('revision'))}) | {CHECK_EN.get(r.get('verdict'), r.get('verdict'))} | "
              f"{cell(', '.join(issues) or '—')} | {cell('; '.join(st) or '—')} |")


def title_of(tex):
    try:
        m = re.search(r"\\title\s*(?:\[[^\]]*\])?\s*\{((?:[^{}]|\{[^{}]*\})*)\}", Path(tex).read_text(errors="replace"))
    except Exception:
        return ""
    return re.sub(r"\s+", " ", m.group(1)).strip() if m else ""


def source_state(data=None):
    """Compare source/ with verification/source_baseline/. Returns (status, details):
    NO_BASELINE, SAME, CHANGED (a new version of the same paper?) or DIFFERENT_PAPER (title changed or main file gone)."""
    src, base = ROOT / "source", ROOT / "verification" / "source_baseline"
    if not base.is_dir():
        return "NO_BASELINE", []
    def listing(d):
        return {str(p.relative_to(d)): hashlib.sha256(p.read_bytes()).hexdigest()
                for p in d.rglob("*") if p.is_file() and p.name != ".DS_Store"}
    a, b = listing(base), listing(src)
    changed = sorted(k for k in set(a) | set(b) if a.get(k) != b.get(k))
    if not changed:
        return "SAME", []
    main = ((data or {}).get("paper") or {}).get("main_tex", "") if data else ""
    rel = main[len("source/"):] if main.startswith("source/") else main
    if rel and rel in a and rel not in b:
        return "DIFFERENT_PAPER", [f"the main file {main} is no longer in source/"] + changed[:10]
    t_old, t_new = title_of(base / rel) if rel else "", title_of(src / rel) if rel else ""
    if t_old and t_new and t_old != t_new:
        return "DIFFERENT_PAPER", [f"title was: {t_old}", f"title is now: {t_new}"] + changed[:10]
    return "CHANGED", changed


def source_check(data):
    st, det = source_state(data)
    msg = {
        "NO_BASELINE": "no verification/source_baseline/ yet (it is made by /pv-setup)",
        "SAME": "source/ is identical to the baseline: same paper, same version",
        "CHANGED": "source/ differs from the baseline. If this is a NEW VERSION of the same paper, run /pv-revise. "
                   "If it is a DIFFERENT paper, put it back and make a new project for the other paper.",
        "DIFFERENT_PAPER": "source/ seems to hold a DIFFERENT PAPER. Never check two papers in one project: restore the "
                           "original files, and make a new project for the new paper (install.sh <new folder>).",
    }[st]
    print(f"SOURCE {st}: {msg}")
    for d in det[:12]:
        print(f"  {d}")
    return 0 if st in ("SAME", "NO_BASELINE") else 1


def add_tool(raw):
    """Register (or update, by id) one external input in RESULTS.json external_tools, then validate."""
    try:
        t = json.loads(raw)
    except json.JSONDecodeError as e:
        sys.exit(f"not a JSON object: {e}")
    if not isinstance(t, dict) or not t.get("id"):
        sys.exit("the JSON object needs at least an 'id'")
    missing = [k for k in ("lean", "meaning", "provenance", "source_loc") if not t.get(k)]
    if missing:
        sys.exit(f"missing fields {missing} (see _example_tool in RESULTS.json)")
    if str(t["provenance"]).strip("()") not in PROVENANCE:
        sys.exit(f"provenance must be one of {PROVENANCE}; gap hypotheses are not registered here")
    t["provenance"] = str(t["provenance"]).strip("()")
    data = load()
    tools = [x for x in data.get("external_tools", []) if not (isinstance(x, dict) and x.get("id") == t["id"])]
    tools.append(t)
    data["external_tools"] = tools
    STATE.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    print(f"registered external input {t['id']} ({t['provenance']})")
    return validate(load())


def main():
    a = sys.argv[1:]
    cmd = a[0] if a else "table"
    if cmd == "supersede":
        if len(a) < 3:
            sys.exit('usage: pv_status.py supersede FILE "reason" [REPLACED_BY]')
        supersede(a[1], a[2], a[3] if len(a) > 3 else "")
        return
    if cmd == "paths":
        if len(a) < 2:
            sys.exit("usage: pv_status.py paths FILE.md")
        sys.exit(paths(a[1]))
    if cmd == "outputs":
        if len(a) < 2:
            sys.exit("usage: pv_status.py outputs ID")
        outputs(a[1])
        return
    if cmd == "human-check":
        if len(a) < 2:
            sys.exit('usage: pv_status.py human-check TOOL_ID --by "name" --how "what was checked against what" [--undo]')
        sys.exit(human_check(a[1], a[2:]))
    if cmd == "reset":
        rest = a[1:]
        k = next((i for i, x in enumerate(rest) if x.startswith("--")), len(rest))
        if k == 0:
            sys.exit("usage: pv_status.py reset ID [ID ...] --revision K [--reason SOURCE_CHANGED|'']")
        sys.exit(reset(rest[:k], rest[k:]))
    if cmd == "add-tool":
        if len(a) < 2:
            sys.exit("usage: pv_status.py add-tool '<JSON object with the fields of _example_tool>'")
        sys.exit(add_tool(a[1]))
    if cmd == "record":
        if len(a) < 2:
            sys.exit("usage: pv_status.py record ID --verdict ... (see --help)")
        sys.exit(record(a[1], a[2:]))
    data = load()
    if cmd == "source-check":
        sys.exit(source_check(data))
    if cmd == "followup":
        followup(data)
        return
    if cmd == "init-checklist":
        init_checklist(data, force="--force" in a)
        return
    if cmd == "table":
        table(data)
    elif cmd == "validate":
        sys.exit(validate(data))
    elif cmd == "next":
        next_ready(data, second_pass="--second-pass" in a, use_all="--all" in a)
    elif cmd == "reconnect":
        reconnect(data)
    elif cmd == "tools":
        tools_table(data)
    else:
        print(__doc__)
        sys.exit(2)


if __name__ == "__main__":
    main()
