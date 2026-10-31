#!/usr/bin/env python3
"""pv_audit_mech.py — the mechanical checks of a final audit in one command (kit v1.3; v1.5: items 4, 7, 13).

Run by pv-auditor itself (never by the prover or the coordinator on its behalf), from the project root:

  python3 scripts/pv_audit_mech.py <ID>                      audit pv_work/<ID>.lean (or <ID>ModGaps.lean if only that is built)
  python3 scripts/pv_audit_mech.py <ID> --module <ID>ModGaps  choose the module explicitly
  options: --gate <report>      gate report holding the snapshot (default: the latest verification/audits/<ID>_gate*.md
                                whose last lines say STATEMENT GATE: PASS)
           --skip-statement      skip the fingerprint comparison (e.g. for a <X>Closed_r<k> reconnection file)
           --no-rebuild          skip the private rebuild (only when the delivered .olean is intentionally absent)

What it does (VERIFICATION_METHODS.md §1–§3, pv-auditor steps 1–5):
  1. scripts/pv_lean.sh check <module>: exit 0, no errors, no sorry warning
  2. scripts/pv_lean.sh rebuild <module> <ID>: IDENTICAL
  3. sha256 of pv_work/PVTools.lean equals lean.pvtools_sha256 in RESULTS.json
  4. fingerprints (#pv_type_hashes of <ID>Stmt and <module>) equal the gate snapshot line by line (th, vh, bi);
     for a gap file: each <ID>_S<k>_Gap has vh equal to the th of S<k> in the snapshot. (v1.5) The snapshot is the
     block between <!-- PV SNAPSHOT BEGIN --> and <!-- PV SNAPSHOT END --> when the report has one; fingerprints
     quoted elsewhere in its prose, and <X>_Gap lines anywhere, are not gated declarations
  5. the same for every Defs* module against the latest DEFS gate snapshot
  6. #pv_axioms <module>: ALL STANDARD
  7. #pv_walk <module>: no sorryAx, only propext / Classical.choice / Quot.sound in the closure. (v1.5) If the module
     walk reaches anything else, every declaration that #pv_axioms checks is walked on its own (#pv_walk_decl), and
     those walks decide: compiler auxiliaries of a computable def (internal names such as `…._cstage1`) refer to the
     core axiom `lcProof`, which no theorem reaches
  8. project constants reached by the walk, grouped by module, with the audit record that covers each module
  9. declarations of <module> that are not in the snapshot (helper lemmas): listed for the auditor to review
 10. #pv_hyp_usage of every gated theorem (and <main>_mod_gaps): USED / UNUSED per hypothesis
 11. (v1.3.1) conditions traced from the gated theorems: an external input (RESULTS.json external_tools) is a
     condition when a hypothesis that the proof USES mentions its constant; "formal only" when only UNUSED
     hypotheses mention it; inputs registered for <ID> but never reached are listed. Writes a line
     `TRACED CONDITIONS: <ids> | none` for the auditor's CONDITIONS line
 12. (v1.3.1) who last wrote the audited files, from the guard hook's log pv_work/logs/writes.jsonl: FAIL if it
     was the coordinator (it does not write proofs)
 13. (v1.5) every package of lake-manifest.json is a git checkout at the manifest's revision with no local changes
     (`git rev-parse HEAD`, `git status --porcelain`, run by this script so that the auditor needs no git rights)

Writes verification/audits/<ID>_mech.md (then _mech_r2.md, ...). Its last line is
  MECH CHECKS: PASS            or   MECH CHECKS: FAIL (<items>)
The report's header names who ran this script (role, agent, session), from the same log. Items 8–11 are never
PASS/FAIL by themselves: they are the judgement work left to the auditor (listed under
"For the auditor"). Probes go to pv_work/probes/auditor/<ID>/auditor_<ID>_mech*.lean.
"""
import argparse
import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "pv_work"
AUDITS = ROOT / "verification" / "audits"
STANDARD = {"propext", "Classical.choice", "Quot.sound"}
FP = re.compile(r"([^\s|`]+)\|(thm|def|opaque|induct|ctor|rec|axiom|quot)\|th=(\d+)\|vh=(-|\d+)\|bi=([eisc]*)")
MSG = re.compile(r"^(?P<file>.+?):(?P<line>\d+):(?P<col>\d+): (?P<sev>info|warning|error): (?P<text>.*)$")


def sh(args):
    p = subprocess.run(args, cwd=str(ROOT), stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                       universal_newlines=True)   # Python 3.6-compatible (clusters often have old python3)
    return p.returncode, p.stdout + p.stderr


def result_fields(out):
    m = re.search(r"^RESULT .*$", out, flags=re.M)
    return dict(re.findall(r"(\w+)=(\S+)", m.group(0))) if m else {}


def verdict_line(path, prefix):
    lines = [l.strip().strip("*` ") for l in path.read_text(errors="replace").splitlines() if l.strip()]
    val = None
    for s in lines[-5:]:
        if s.startswith(prefix):
            val = s[len(prefix):].strip().strip("*` ")
    return val


def rnum(p, stem):
    m = re.fullmatch(re.escape(stem) + r"(?:_r(\d+))?\.md", p.name)
    return int(m.group(1) or 1) if m else None


def latest_pass(stem, prefix):
    """Latest verification/audits/<stem>[_r<k>].md whose verdict line starts with PASS."""
    cands = [(rnum(p, stem), p) for p in AUDITS.glob(stem + "*.md") if rnum(p, stem)]
    for _, p in sorted(cands, reverse=True):
        v = verdict_line(p, prefix)
        if v and re.match(r"PASS(?![A-Z_])", v):
            return p
    return None


SNAP_BLOCK = re.compile(r"<!--\s*PV SNAPSHOT BEGIN\s*-->(.*?)<!--\s*PV SNAPSHOT END\s*-->", re.S)


def snapshot(path):
    """Gated declarations of a gate report. (v1.5) Only the snapshot block counts when the report has one, since a
    report may quote other fingerprints in its prose. A <X>_Gap definition is never gated: the prover writes gap
    files after the gate, so a gate report only quotes them (e.g. in a ruling)."""
    text = path.read_text(errors="replace")
    blocks = SNAP_BLOCK.findall(text)
    snap = {}
    for m in FP.finditer("\n".join(blocks) if blocks else text):
        name, kind, th, vh, bi = m.groups()
        if not name.endswith("_Gap"):
            snap[name] = (kind, th, vh, bi)
    return snap


def parse_probe(text):
    """Parse the output of a PVTools probe. Lean prints info messages as plain lines (no file:line prefix);
    warnings and errors carry a `file:line:col: severity:` prefix."""
    out = {"fps": {}, "axiom_bad": [], "axioms_ok": None, "walk_axioms": None, "sorry": None, "reached": [],
           "hyp": {}, "errors": [], "walks": {}, "walk_ax": {}}
    cur_mod = cur_hyp = cur_walk = None
    lines = text.splitlines()
    for n, raw in enumerate(lines):
        if raw.startswith("EXIT="):
            break
        line = raw
        m = MSG.match(raw)
        if m:
            if m.group("sev") == "error":
                out["errors"].append("\n".join(lines[n:n + 8])[:800])
                cur_mod = cur_hyp = None
                continue
            line = m.group("text")
        fm = FP.fullmatch(line.strip())
        if cur_mod and fm:
            out["fps"].setdefault(cur_mod, {})[fm.group(1)] = fm.groups()[1:]
            continue
        cur_mod = None
        if cur_hyp and (line.startswith("HYP|") or line.startswith("WARNING")):
            out["hyp"][cur_hyp].append(line)
            continue
        cur_hyp = None
        if line.startswith("TYPE HASHES "):
            cur_mod = line.split()[2]
        elif line.startswith("HYPOTHESIS USAGE "):
            cur_hyp = line.split()[2]
            out["hyp"][cur_hyp] = []
        elif line.startswith("NONSTANDARD|"):
            out["axiom_bad"].append(line)
        elif line.startswith("#pv_axioms "):
            out["axioms_ok"] = "ALL STANDARD" in line
            if not out["axioms_ok"]:
                out["axiom_bad"].append(line)
        elif line.startswith("AXIOMS in closure:"):
            am = re.match(r"AXIOMS in closure: \[(.*)\]; sorryAx reached: (\w+)", line)
            if am:
                out["walk_axioms"] = [x.strip() for x in am.group(1).split(",") if x.strip()]
                out["sorry"] = am.group(2) == "true"
                if cur_walk:
                    out["walk_ax"][cur_walk] = (out["walk_axioms"], out["sorry"])
        elif line.startswith("WALK "):
            wm = re.match(r"WALK (?:declaration|module) (\S+)", line)
            cur_walk = wm.group(1) if wm else None
            if cur_walk:
                out["walks"].setdefault(cur_walk, [])
        elif line.startswith("REACHED|"):
            out["reached"].append(line.split("|"))
            if cur_walk:
                out["walks"][cur_walk].append(line.split("|"))
    return out


DECL = re.compile(r"^\s*(?:@\[[^\]]*\]\s*)?(?:(?:private|protected|noncomputable|partial|nonrec)\s+)*"
                  r"(theorem|lemma|def|abbrev|instance|structure|inductive|class|opaque|axiom)\s+([^\s:(\[{]+)", re.M)


def declares_something(lean_file):
    """Whether a Lean file declares any constant. `#pv_type_hashes M` stops with an error on a module that declares
    nothing, which is legitimate for a <ID>Stmt file of a result without definitions or external parameters."""
    try:
        text = re.sub(r"/-.*?-/", "", lean_file.read_text(errors="replace"), flags=re.S)
    except Exception:
        return True
    return bool(DECL.search(text))


def write_log():
    """Records of the guard hook (scripts/pv_guard.py), oldest first; [] when the hook is not installed."""
    f = WORK / "logs" / "writes.jsonl"
    out = []
    if f.exists():
        for line in f.read_text(errors="replace").splitlines():
            try:
                out.append(json.loads(line))
            except ValueError:
                pass
    return out


def who_ran(rid, log):
    """The role that called pv_audit_mech.py for rid most recently, from the guard hook's log."""
    for rec in reversed(log):
        cmd = rec.get("command", "")
        if rec.get("script") == "pv_audit_mech.py" and re.search(rf"pv_audit_mech\.py\s+{re.escape(rid)}(\s|$)", cmd):
            return rec
    return None


def last_writer(rel, log):
    for rec in reversed(log):
        if rec.get("path") == rel and not rec.get("refused"):
            return rec
    return None


IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_.']*")


def trace_conditions(rid, state, targets, walks, hyps):
    """Item 11: (conditions, formal only, reached but unclassified, registered but not reached) as sorted id lists."""
    tools = {t["id"]: t for t in state.get("external_tools", []) if isinstance(t, dict) and t.get("id")}
    const = {}
    for tid, t in tools.items():
        parts = str(t.get("lean", "")).split()
        const[tid] = parts[1] if len(parts) > 1 else tid
    cond, formal, loose = set(), set(), set()
    for name in targets:
        reached = {p[2] for p in walks.get(name, []) if len(p) > 2}
        used_ids, unused_ids = set(), set()
        for l in hyps.get(name, []):
            u = l.split("|")
            if len(u) > 4 and u[0] == "HYP":
                (used_ids if u[3] == "USED" else unused_ids).update(IDENT.findall(u[4]))
        for tid, c in const.items():
            short = c.split(".")[-1]
            hit = lambda ids: c in ids or any(i.endswith("." + short) or i == short for i in ids)
            if hit(used_ids):
                cond.add(tid)
            elif hit(unused_ids):
                formal.add(tid)
            elif c in reached:
                loose.add(tid)
    r = next((x for x in state.get("results", []) if isinstance(x, dict) and x.get("id") == rid), {})
    registered = set(map(str, r.get("conditions") or []))
    for tid, t in tools.items():
        if any(str(cn).split(" ")[0] == rid for cn in (t.get("consumers") or [])):
            registered.add(tid)
    formal -= cond
    loose -= cond | formal
    missing = registered - cond - formal - loose
    return sorted(cond), sorted(formal), sorted(loose), sorted(missing)


def package_checks():
    """Item 13: (status, detail). FAIL when a package is missing, is at another revision than lake-manifest.json, or
    has local changes; NOT RECORDED when there is no manifest or a package is not a git checkout."""
    try:
        pkgs = json.loads((ROOT / "lake-manifest.json").read_text()).get("packages", [])
    except Exception:
        return "NOT RECORDED", "no readable lake-manifest.json"
    bad, unknown, ok = [], [], 0
    for pk in pkgs:
        name, rev = pk.get("name"), pk.get("rev")
        if pk.get("type", "git") != "git" or not name:
            continue
        d = ROOT / ".lake" / "packages" / name
        if not d.is_dir():
            bad.append(f"{name}: missing")
            continue
        ec, head = sh(["git", "-C", str(d), "rev-parse", "HEAD"])
        if ec:
            unknown.append(f"{name}: not a git checkout ({head.strip()[:80]})")
            continue
        ec, st = sh(["git", "-C", str(d), "status", "--porcelain"])
        changed = [l for l in st.splitlines() if l.strip()]
        if head.strip() != rev:
            bad.append(f"{name}: HEAD {head.strip()[:12]} but manifest {str(rev)[:12]}")
        elif ec or changed:
            bad.append(f"{name}: {len(changed)} local changes, e.g. `{changed[0][3:].strip() if changed else st.strip()[:80]}`")
        else:
            ok += 1
    if bad:
        return "FAIL", "; ".join(bad + unknown)
    if unknown:
        return "NOT RECORDED", "; ".join(unknown)
    return "PASS", f"{ok} packages at the manifest revisions, no local changes"


def run_probe(rid, tag, body):
    d = WORK / "probes" / "auditor" / rid
    d.mkdir(parents=True, exist_ok=True)
    f = d / f"auditor_{rid}_{tag}.lean"
    f.write_text(body)
    ec, out = sh(["scripts/pv_lean.sh", "probe", str(f.relative_to(ROOT))])
    r = result_fields(out)
    log = (ROOT / r["log"]).read_text(errors="replace") if r.get("log") else ""
    parsed = parse_probe(log)
    if not r.get("log"):
        parsed["errors"].append(out[:800])
    return ec, r, parsed, f.relative_to(ROOT)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("id")
    ap.add_argument("--module")
    ap.add_argument("--gate")
    ap.add_argument("--skip-statement", action="store_true")
    ap.add_argument("--no-rebuild", action="store_true")
    a = ap.parse_args()
    rid = a.id
    mod = a.module or (rid if (WORK / f"{rid}.olean").exists() else
                       f"{rid}ModGaps" if (WORK / f"{rid}ModGaps.olean").exists() else rid)
    gapmode = mod.endswith("ModGaps")
    fails, manual, lines = [], [], []
    add = lines.append
    stamp = datetime.now().strftime("%Y-%m-%d %H:%M")

    # 1. compile check
    ec, out = sh(["scripts/pv_lean.sh", "check", mod])
    r = result_fields(out)
    ok = ec == 0 and r.get("errors") == "0" and r.get("sorry_warnings") == "0"
    if not ok:
        fails.append("compile")
    add(f"| 1 | check `{mod}` | {'PASS' if ok else 'FAIL'} | exit={r.get('exit')} errors={r.get('errors')} "
        f"sorry_warnings={r.get('sorry_warnings')} log `{r.get('log')}` |")
    if r.get("errors") not in (None, "0"):
        first = re.search(r"FIRST ERRORS.*", out, flags=re.S)
        if first:
            manual.append("compile errors:\n```\n" + first.group(0)[:3000] + "\n```")

    # 2. private rebuild
    if a.no_rebuild:
        add("| 2 | private rebuild | SKIPPED | --no-rebuild given |")
        manual.append("the private rebuild was skipped (--no-rebuild); say why in the final report")
    else:
        ec, out = sh(["scripts/pv_lean.sh", "rebuild", mod, rid])
        rb = re.search(r"^REBUILD .*$", out, flags=re.M)
        ok = ec == 0 and rb is not None and "IDENTICAL" in rb.group(0)
        if not ok:
            fails.append("rebuild")
        add(f"| 2 | private rebuild + sha256 | {'PASS' if ok else 'FAIL'} | "
            f"{(rb.group(0) if rb else out.strip().splitlines()[-1] if out.strip() else 'no output')[:300]} |")

    # 3. PVTools unchanged
    state = json.loads((ROOT / "verification" / "RESULTS.json").read_text())
    want = (state.get("lean") or {}).get("pvtools_sha256")
    have = hashlib.sha256((WORK / "PVTools.lean").read_bytes()).hexdigest()
    ok = bool(want) and want == have
    if want and not ok:
        fails.append("pvtools")
    add(f"| 3 | PVTools.lean sha256 | {'PASS' if ok else ('FAIL' if want else 'NOT RECORDED')} | {have[:16]}… |")

    # probe 1: fingerprints, axioms, walk
    defs = [d.get("file", "").split("/")[-1].replace(".lean", "") for d in state.get("defs", [])
            if isinstance(d, dict) and d.get("id") not in (None, "NONE") and d.get("file")]
    stmt = f"{rid}Stmt" if (WORK / f"{rid}Stmt.lean").exists() else None
    if stmt and not declares_something(WORK / f"{stmt}.lean"):
        add(f"| 4a | `{stmt}` fingerprints | PASS | `pv_work/{stmt}.lean` declares nothing (0 declarations); "
            f"any gated declaration expected there is still checked in item 4 |")
        stmt = None
    # Every built Defs* module is imported explicitly: the result under audit may not import it, but its
    # fingerprints must still match the DEFS gate snapshot (PIPELINE stage 1).
    missing_defs = [dm for dm in defs if not (WORK / f"{dm}.olean").exists()]
    defs = [dm for dm in defs if dm not in missing_defs]
    for dm in missing_defs:
        fails.append("defs")
        add(f"| 5 | `{dm}` | FAIL | registered in RESULTS.json defs but pv_work/{dm}.olean does not exist |")
    mods_hash = ([stmt] if stmt else []) + [mod] + defs
    body = f"import {mod}\n" + "".join(f"import {dm}\n" for dm in defs) + "import PVTools\n" + \
        "".join(f"#pv_type_hashes {m}\n" for m in mods_hash) + f"#pv_axioms {mod}\n#pv_walk {mod}\n"
    ec1, r1, P, probe1 = run_probe(rid, "mech1", body)
    fps, axioms_ok, axiom_bad = P["fps"], P["axioms_ok"], P["axiom_bad"]
    walk_axioms, sorry_reached, reached = P["walk_axioms"], P["sorry"], P["reached"]
    if P["errors"]:
        fails.append("probe")
        manual.append(f"probe `{probe1}` had errors (log `{r1.get('log')}`):\n```\n" +
                      "\n".join(e for e in P["errors"][:3]) + "\n```")

    # 4-5. statement fingerprints
    final = {}
    for mname in ([stmt] if stmt else []) + [mod]:
        final.update(fps.get(mname, {}))
    new_decls = []
    gate_path = Path(a.gate) if a.gate else latest_pass(f"{rid}_gate", "STATEMENT GATE:")
    gated_thms = []
    if a.skip_statement:
        add("| 4 | statement fingerprints vs gate snapshot | SKIPPED | --skip-statement |")
    elif not gate_path or not gate_path.exists():
        fails.append("statement")
        add("| 4 | statement fingerprints vs gate snapshot | FAIL | no gate report ending in STATEMENT GATE: PASS found |")
    else:
        snap = snapshot(gate_path)
        # Gated declarations are this result's own (namespace Paper.<ID>, PIPELINE "Files and naming"). A gate report
        # may also quote fingerprints of Defs or of predecessors: Defs are compared in item 5, predecessors are
        # covered by their own audits (item 8).
        own = {n: v for n, v in snap.items() if n.startswith(f"Paper.{rid}.")}
        others = sorted(set(snap) - set(own))
        if own:
            snap = own
        bad, gapchecks, notes = [], [], []
        for name, (kind, th, vh, bi) in sorted(snap.items()):
            if kind == "thm":
                gated_thms.append(name)
            got = final.get(name)
            if got == (kind, th, vh, bi):
                continue
            if got is None and gapmode and kind == "thm":
                g = final.get(name + "_Gap")
                if g is not None:
                    if g[0] != "def":
                        bad.append(f"{name}_Gap is not a def")
                    elif g[2] == th:
                        gapchecks.append(f"`{name}_Gap`: vh = snapshot th of `{name}`")
                    else:
                        gapchecks.append(f"`{name}_Gap`: vh ≠ snapshot th of `{name}`: manual check")
                        notes.append(f"`{name}_Gap`: its vh differs from the snapshot th of `{name}`. Auxiliary proof "
                                     f"constants are named after their declaration (a real numeral `2 : ℝ` becomes "
                                     f"`instOfNatAtLeastTwo … {name}_Gap._proof_1`), so identical statements can hash "
                                     f"differently. Decide with the §2b probe: import `{mod}`, redeclare `{name}` "
                                     f"verbatim under its original full name, confirm its th equals the snapshot, then "
                                     f"`example : {name}_Gap = type_of% @{name} := rfl`.")
                    continue
                if (name + "_mod_gaps") in final:
                    notes.append(f"`{name}` renamed to `{name}_mod_gaps`: do the §2b copy-and-`example` check")
                    continue
            if got is not None and gapmode and kind == "thm":
                notes.append(f"`{name}` changed in the gap file (gap-dependent?): check it with the §2b method")
                continue
            bad.append(f"{name} ({'missing' if got is None else 'changed: ' + '|'.join(got)})")
        if not snap:
            bad.append("the gate report contains no fingerprint lines")
        if bad:
            fails.append("statement")
        add(f"| 4 | statement fingerprints vs `{gate_path.relative_to(ROOT) if gate_path.is_absolute() else gate_path}` "
            f"({len(snap)} gated declarations) | {'FAIL' if bad else 'PASS'} | "
            f"{'; '.join(bad)[:900] if bad else 'all gated th/vh/bi identical'}"
            f"{f'; {len(others)} quoted lines of other modules not compared here (Defs: item 5; predecessors: item 8)' if own and others else ''} |")
        if gapchecks:
            add(f"| 4b | gap definitions | {'MANUAL' if any('manual' in g for g in gapchecks) else 'PASS'} | {'; '.join(gapchecks)} |")
        manual.extend(notes)
        short = {n.split(".")[-1] for n in snap}
        src = (WORK / f"{mod}.lean").read_text(errors="replace") if (WORK / f"{mod}.lean").exists() else ""
        new_decls = sorted({f"{k} {n}" for k, n in DECL.findall(src)
                            if n.split(".")[-1] not in short and not n.endswith("_Gap") and not n.endswith("_mod_gaps")})
    for dm in defs:
        dgate = latest_pass("DEFS_gate", "STATEMENT GATE:")
        if not dgate:
            fails.append("defs")
            add(f"| 5 | `{dm}` vs DEFS gate snapshot | FAIL | no DEFS gate report ending in PASS |")
            continue
        dsnap = snapshot(dgate)
        cur = fps.get(dm, {})
        bad = [n for n, v in dsnap.items() if n in cur and cur[n] != v] + [n for n in dsnap if n not in cur and dm == "Defs"]
        if bad:
            fails.append("defs")
        add(f"| 5 | `{dm}` vs `{dgate.relative_to(ROOT)}` | {'FAIL' if bad else 'PASS'} | "
            f"{', '.join(bad)[:600] if bad else 'identical'} |")

    # 6-7. axioms and sorry
    ok = axioms_ok is True and not axiom_bad
    if not ok:
        fails.append("axioms")
    add(f"| 6 | `#pv_axioms {mod}` | {'PASS' if ok else 'FAIL'} | "
        f"{'ALL STANDARD' if ok else '; '.join(axiom_bad)[:600] or 'no ALL STANDARD line'} |")
    ok = sorry_reached is False and walk_axioms is not None and set(walk_axioms) <= STANDARD
    detail = f"sorryAx reached: {sorry_reached}; axioms: {walk_axioms}"
    decls = sorted(fps.get(mod, {}))
    if not ok and walk_axioms is not None and decls:
        # v1.5: the module walk also starts from compiler auxiliaries (internal names); walk each declaration that
        # #pv_axioms checks on its own and let those walks decide
        body = f"import {mod}\nimport PVTools\n" + "".join(f"#pv_walk_decl {n}\n" for n in decls)
        _, r3, P3, probe3 = run_probe(rid, "mech3", body)
        per = P3["walk_ax"]
        dirty = [n for n in decls if n not in per or per[n][1] or not set(per[n][0]) <= STANDARD]
        if P3["errors"]:
            manual.append(f"per-declaration walk probe `{probe3}` had errors (log `{r3.get('log')}`):\n```\n" +
                          "\n".join(P3["errors"][:2]) + "\n```")
        elif not dirty:
            ok = True
            extra = sorted(set(walk_axioms) - STANDARD) + (["sorryAx"] if sorry_reached else [])
            detail = (f"module walk: {detail}. {', '.join(extra)} is reached only from internal names (compiler "
                      f"auxiliaries such as `…._cstage1` of a computable def); each of the {len(decls)} declarations "
                      f"walked on its own (`{probe3}`) reaches only standard axioms and no sorryAx")
        else:
            detail += "; walked on their own, these declarations reach it: " + ", ".join(
                f"`{n}` {per.get(n, (['no walk output'], None))[0]}" for n in dirty[:6])
    if not ok:
        fails.append("walk")
    add(f"| 7 | `#pv_walk {mod}`: sorryAx and closure axioms | {'PASS' if ok else 'FAIL'} | {detail[:900]} |")

    # 8. project constants reached, by module, with the record that covers each module
    by_mod = {}
    for parts in reached:
        if len(parts) >= 4:
            by_mod.setdefault(parts[1], []).append(parts[2])
    cover = []
    for m, names in sorted(by_mod.items()):
        rec = None
        base = m[:-4] if m.endswith("Stmt") else m
        if m.startswith("Defs"):
            rec = latest_pass("DEFS_gate", "STATEMENT GATE:")
        elif m.endswith("Stmt"):
            rec = latest_pass(f"{base}_gate", "STATEMENT GATE:")
        else:
            rec = latest_pass(f"{m}_final", "FINAL AUDIT:") or latest_pass(f"{m}_reconnect", "RECONNECT AUDIT:")
        tag = f"`{rec.relative_to(ROOT)}`" if rec else "**NO RECORD: audit these constants individually**"
        cover.append(f"| `{m}` | {len(names)} | {tag} | {', '.join('`' + n + '`' for n in sorted(names)[:12])}"
                     f"{' …' if len(names) > 12 else ''} |")
        if not rec:
            manual.append(f"module `{m}` reached without an audit record: audit its {len(names)} constants one by one")

    # 10. hypothesis usage of gated theorems (probe 2)
    hyp_targets = [n for n in gated_thms if n in final] + [n for n in fps.get(mod, {}) if n.endswith("_mod_gaps")]
    hyp_rows = []
    walks2 = {}
    if hyp_targets:
        body = f"import {mod}\nimport PVTools\n" + "".join(f"#pv_hyp_usage {n}\n#pv_walk_decl {n}\n" for n in hyp_targets)
        ec2, r2, P2, probe2 = run_probe(rid, "mech2", body)
        for name, hl in P2["hyp"].items():
            used = [l.split("|") for l in hl if l.startswith("HYP|")]
            warn = [l for l in hl if l.startswith("WARNING")]
            unused = [u[2] + ": " + u[4][:60] for u in used if len(u) > 4 and u[3] == "UNUSED"]
            hyp_rows.append(f"| `{name}` | {len(used)} | {', '.join(unused) if unused else '—'} | "
                            f"{warn[0][:120] if warn else ''} |")
        for e in P2["errors"][:2]:
            manual.append("hypothesis-usage probe error: " + e[:300])
        walks2 = P2["walks"]

    # 11. conditions traced from the gated theorems (PENDING #16, #24)
    cond, formal, loose, missing = trace_conditions(rid, state, hyp_targets, walks2, P2["hyp"] if hyp_targets else {})
    traced = ", ".join(cond) if cond else "none"
    detail = [f"conditions: {traced}"]
    if formal:
        detail.append("formal only (UNUSED hypotheses): " + ", ".join(formal))
        manual.append(f"external inputs mentioned only by UNUSED hypotheses ({', '.join(formal)}): they are not conditions "
                      f"of the proof; report them, and list them as formal-only, not under CONDITIONS")
    if loose:
        detail.append("reached but not in a hypothesis: " + ", ".join(loose))
        manual.append(f"external inputs reached by the walk but not visible in a hypothesis type ({', '.join(loose)}): "
                      f"decide by hand (a bundled hypothesis, or a type cut off at 100 characters)")
    if missing:
        detail.append("registered for this result but not reached: " + ", ".join(missing))
        manual.append(f"external inputs registered for {rid} but not reached by any gated theorem ({', '.join(missing)}): "
                      f"they are not conditions; say so in the report so that the records are corrected")
    add(f"| 11 | conditions traced from the gated theorems | INFO | {'; '.join(detail)[:900]} |")

    # 12. who last wrote the audited files (PENDING #19)
    log = write_log()
    for rel in [f"pv_work/{mod}.lean"] + ([f"pv_work/{stmt}.lean"] if stmt else []):
        w = last_writer(rel, log)
        if not log:
            add(f"| 12 | last writer of `{rel}` | NOT RECORDED | no guard hook log (pv_work/logs/writes.jsonl) |")
        elif w is None:
            add(f"| 12 | last writer of `{rel}` | NOT RECORDED | no write of this file in the guard hook log |")
        elif w.get("role") == "coordinator":
            fails.append("writer")
            add(f"| 12 | last writer of `{rel}` | FAIL | the coordinator, {w.get('time')} (it does not write proofs, POLICY §3) |")
        else:
            add(f"| 12 | last writer of `{rel}` | PASS | {w.get('role')} (agent {str(w.get('agent_id'))[:8]}), {w.get('time')} |")

    # 13. the Lake packages are the pinned checkouts (v1.5)
    pst, pdet = package_checks()
    if pst == "FAIL":
        fails.append("packages")
    add(f"| 13 | Lake packages at the lake-manifest.json revisions, unmodified | {pst} | {pdet[:900]} |")

    # report
    AUDITS.mkdir(parents=True, exist_ok=True)
    k, out_path = 1, AUDITS / f"{rid}_mech.md"
    while out_path.exists():
        k += 1
        out_path = AUDITS / f"{rid}_mech_r{k}.md"
    verdict = ("PASS" + (f" ({len(manual)} manual checks listed above)" if manual else "")) if not fails else \
        "FAIL (" + ", ".join(dict.fromkeys(fails)) + ")"
    ran = who_ran(rid, log)
    by = (f"{ran.get('role')} (agent {str(ran.get('agent_id'))[:8] or '-'}, session {str(ran.get('session'))[:8]})"
          if ran else "not recorded (no guard hook log entry for this call)")
    rep = [f"# Mechanical audit checks — {rid} (`{mod}`)", "",
           f"Run by: {by}, with `python3 scripts/pv_audit_mech.py {' '.join(sys.argv[1:])}` on {stamp}. "
           f"Probes: `{probe1}`" + (f", `{probe2}`" if hyp_targets else "") + ".", "",
           "| # | Check | Result | Detail |", "|---|---|---|---|", *lines, "",
           "## Project constants reached (item 8)", "",
           "| Module | Constants | Audit record covering the module | Names |", "|---|---:|---|---|",
           *(cover or ["| — | 0 | — | — |"]), "",
           f"## Declarations in `pv_work/{mod}.lean` that are not in the gate snapshot (item 9: helpers to review)", "",
           "Read from the source file, so private helpers are included.", "",
           (", ".join(f"`{n}`" for n in new_decls) if new_decls else "None."), "",
           "## Hypothesis usage of gated theorems (item 10)", "",
           "| Theorem | Hypotheses | UNUSED | Warning |", "|---|---:|---|---|", *(hyp_rows or ["| — | — | — | — |"]), "",
           "## Conditions traced (item 11)", "",
           f"TRACED CONDITIONS: {traced}", "",
           "## For the auditor (judgement not done by this script)", "",
           *(f"- {m}" for m in manual),
           "- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)",
           "- review each helper listed under item 9: technical conversion only, no new mathematics",
           "- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness", "",
           f"MECH CHECKS: {verdict}"]
    out_path.write_text("\n".join(rep) + "\n")
    print(f"MECH {rid} module={mod} report={out_path.relative_to(ROOT)}")
    for l in lines:
        cells = [c.strip() for c in l.strip("|").split("|")]
        print(f"  {cells[0]:>2} {cells[2]:<12} {cells[1][:70]}")
    print(f"  project modules reached: {len(by_mod)}; helpers not in snapshot: {len(new_decls)}; "
          f"items for the auditor: {len(manual) + 3}")
    print(f"MECH CHECKS: {verdict}")
    sys.exit(0 if not fails else 1)


if __name__ == "__main__":
    main()
