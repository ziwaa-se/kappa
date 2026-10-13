#!/usr/bin/env python3
"""pv_drive_status.py — the decisions of the unattended driver, kept out of bash so that they can be tested (kit v1.3.1).

Used by scripts/pv_drive.sh; can also be run by hand from the project root:

  python3 scripts/pv_drive_status.py classify SESSION.json [--err SESSION.err]
        why did a headless session end? Prints one tab-separated line: KIND, WAIT_S, RESET_AT, MESSAGE
        KIND: ok | usage_limit | limit_in_agents | budget | error | no_json
        WAIT_S: seconds to wait before the next session (usage limits only; else 0)
  python3 scripts/pv_drive_status.py progress
        a fingerprint of everything that counts as progress in RESULTS.json (verdicts, stages, reasons, rounds,
        conditions, lean_main, evidence, reconnections); the driver compares it before and after a session
  python3 scripts/pv_drive_status.py denials SESSION.json [--claude-dir DIR]
        permission denials in that session's transcripts (coordinator and subagents). Prints
        DENIALS <n> STANDARD_FORM_DENIED <m>, then the most frequent denied commands. m > 0 means that commands in
        the kit's standard form were refused, i.e. the permission rules did not apply
  python3 scripts/pv_drive_status.py write --reason R --session K [--wait S] [--reset-at T] [--message M] [--restarts N]
        write pv_work/logs/drive_status.json, the driver's machine-readable exit status
  python3 scripts/pv_drive_status.py show
        print the last status

Status reasons (drive_status.json "reason", and the driver's exit code):
  done 0 · done_report 0 · running (while working) · waiting_usage_limit (while asleep, --auto-resume) ·
  usage_limit 3 · no_progress 4 · validate_failed 5 · max_sessions 6 · permissions 7 · report_incomplete 8 ·
  setup_failed 1 · max_restarts 9
Environment: PV_RESUME_MARGIN_S (default 300) is added after a parsed reset time; PV_RESUME_FALLBACK_S (default 1800)
is the wait when no reset time can be read.
"""
import json
import os
import re
import sys
from datetime import datetime, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
STATUS = ROOT / "pv_work" / "logs" / "drive_status.json"
EXIT_CODES = {"done": 0, "done_report": 0, "setup_failed": 1, "usage_limit": 3, "no_progress": 4,
              "validate_failed": 5, "max_sessions": 6, "permissions": 7, "report_incomplete": 8, "max_restarts": 9,
              "running": 0, "waiting_usage_limit": 0}

# A usage limit as Claude Code words it, e.g. "You've hit your session limit · resets 3:45pm",
# "... weekly limit · resets Oct 14, 9am (Europe/Berlin)". Matched only when the session itself failed (is_error),
# because a normal session's summary may well mention a usage limit.
LIMIT = re.compile(r"hit your [a-z ]*limit|(session|usage|weekly|daily) limit (reached|exceeded)|limit reached|"
                   r"rate[ _-]limit", re.I)
RESET = re.compile(r"resets\s+(?:at\s+)?(?:(?P<mon>[A-Z][a-z]{2})[a-z]*\.?\s+(?P<day>\d{1,2})(?:st|nd|rd|th)?,?\s+"
                   r"(?:at\s+)?)?(?P<h>\d{1,2})(?::(?P<m>\d{2}))?\s*(?P<ap>[ap]\.?m\.?)\s*(?:\((?P<tz>[^)]+)\))?", re.I)
AGENT_LIMIT = re.compile(r"(terminated early|stopped|failed)[^.\n]{0,80}(usage|session|weekly|rate)[ -]limit|"
                         r"(usage|session|weekly)[ -]limit[^.\n]{0,80}(agent|subagent)", re.I)
MONTHS = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]


def env_int(name, default):
    try:
        return int(os.environ.get(name, default))
    except ValueError:
        return default


def reset_wait(text, now=None):
    """(seconds to wait, reset time as text) for a usage-limit message; (fallback, '') if no time can be read."""
    margin, fallback = env_int("PV_RESUME_MARGIN_S", 300), env_int("PV_RESUME_FALLBACK_S", 1800)
    m = RESET.search(text or "")
    if not m:
        return fallback, ""
    h, mi = int(m.group("h")), int(m.group("m") or 0)
    if not (1 <= h <= 12 and 0 <= mi < 60):
        return fallback, ""
    h = h % 12 + (12 if m.group("ap").lower().startswith("p") else 0)
    tzname = (m.group("tz") or "").strip()
    zone = None
    if tzname:
        try:
            from zoneinfo import ZoneInfo   # Python 3.9+
            zone = ZoneInfo(tzname)
        except Exception:
            return fallback, ""             # a named zone we cannot convert: do not guess the offset
    if now is None:
        now = datetime.now(zone) if zone else datetime.now()
    reset = now.replace(hour=h, minute=mi, second=0, microsecond=0)
    if m.group("mon"):
        mon = m.group("mon")[:3].lower()
        if mon not in MONTHS:
            return fallback, ""
        try:
            reset = reset.replace(month=MONTHS.index(mon) + 1, day=int(m.group("day")))
        except ValueError:
            return fallback, ""
        if reset <= now - timedelta(days=1):
            reset = reset.replace(year=reset.year + 1)
    elif reset <= now:
        reset += timedelta(days=1)
    wait = int((reset - now).total_seconds()) + margin
    if wait <= 0 or wait > 8 * 86400:
        return fallback, ""
    return wait, reset.strftime("%Y-%m-%d %H:%M") + (f" ({tzname})" if tzname else "")


def classify(json_path, err_path=None):
    """(kind, wait_s, reset_at, message) for one finished headless session."""
    err = ""
    if err_path and Path(err_path).exists():
        err = Path(err_path).read_text(errors="replace")
    try:
        d = json.loads(Path(json_path).read_text())
        if not isinstance(d, dict):
            raise ValueError("not an object")
    except Exception:
        if LIMIT.search(err):
            w, at = reset_wait(err)
            return "usage_limit", w, at, first_line(err)
        return "no_json", 0, "", first_line(err) or "no JSON result"
    text = " ".join(str(x) for x in [d.get("result", ""), " ".join(map(str, d.get("errors") or []))] if x)
    is_error = bool(d.get("is_error")) or str(d.get("subtype", "")).startswith("error")
    if str(d.get("subtype")) == "error_max_budget_usd" or d.get("terminal_reason") == "budget_exhausted":
        return "budget", 0, "", first_line(text) or "per-session budget reached"
    if is_error and (LIMIT.search(text) or LIMIT.search(err)):
        w, at = reset_wait(text + " " + err)
        return "usage_limit", w, at, first_line(text or err)
    if is_error:
        return "error", 0, "", first_line(text or err)
    if AGENT_LIMIT.search(text):
        w, at = reset_wait(text)
        return "limit_in_agents", w, at, first_line(text)
    return "ok", 0, "", first_line(text)


def first_line(s):
    s = " ".join(str(s or "").split())
    return s[:200]


def progress():
    """Everything a session can change that counts as progress (PENDING #4: reconnections count too)."""
    d = json.loads((ROOT / "verification" / "RESULTS.json").read_text())
    keys = ("stage", "reason", "verdict", "round", "statement_fixed", "lean_main", "evidence", "gaps", "issues",
            "partial", "recheck", "depends_on")
    rows = []
    for r in d.get("results", []):
        if not isinstance(r, dict):
            continue
        row = {k: r.get(k) for k in keys}
        row["id"] = r.get("id")
        row["conditions"] = sorted(map(str, r.get("conditions") or []))
        rows.append(row)
    tools = sorted(str(t.get("id")) + ":" + str(t.get("status", "")) for t in d.get("external_tools", [])
                   if isinstance(t, dict))
    return json.dumps({"results": rows, "tools": tools, "defs": d.get("defs", [])}, sort_keys=True)


# --- permission denials ---------------------------------------------------------------------------------------
DENIED = ("has been denied", "requested permissions", "haven't granted", "not been granted")


def encode(path):
    return re.sub(r"[^A-Za-z0-9]", "-", str(path))


def transcripts(session_id, claude_dir):
    """The main transcript and the subagent transcripts of one session. Session ids are unique, so the project
    folder is found by the id (the folder name depends on how the path was spelled, e.g. /var or /private/var)."""
    base = Path(claude_dir) / "projects"
    out = []
    dirs = [base / encode(r) for r in (str(ROOT), os.path.realpath(str(ROOT)))]
    dirs += [p.parent for p in base.glob(f"*/{session_id}.jsonl")] + [p.parent for p in base.glob(f"*/{session_id}")]
    for d in dict.fromkeys(dirs):
        if (d / f"{session_id}.jsonl").exists():
            out.append(d / f"{session_id}.jsonl")
        sub = d / session_id / "subagents"
        if sub.is_dir():
            out.extend(sorted(sub.glob("*.jsonl")))
    return sorted(set(out))


def allow_prefixes():
    """Literal prefixes of the Bash allow rules in .claude/settings.json, e.g. 'scripts/pv_lean.sh '."""
    try:
        rules = json.loads((ROOT / ".claude" / "settings.json").read_text()).get("permissions", {}).get("allow", [])
    except Exception:
        return []
    out = []
    for r in rules:
        m = re.fullmatch(r"Bash\((.*)\)", r)
        if m and m.group(1).endswith("*") and "*" not in m.group(1)[:-1]:
            out.append(m.group(1)[:-1])
    return out


def standard_form(cmd, prefixes):
    """A single simple command that one of the allow rules matches as written (no ; && | ( ) $ ` or redirection)."""
    if not cmd or re.search(r"[;&|()<>`$\n]", cmd):
        return False
    return any(cmd.startswith(p) for p in prefixes)


def denials(session_json, claude_dir=None):
    claude_dir = claude_dir or os.environ.get("PV_CLAUDE_DIR") or str(Path.home() / ".claude")
    try:
        d = json.loads(Path(session_json).read_text())
        sid = d.get("session_id", "")
        listed = d.get("permission_denials") or []
    except Exception:
        return 0, 0, []
    prefixes = allow_prefixes()
    seen, cmds = set(), {}
    std = 0
    for f in transcripts(sid, claude_dir) if sid else []:
        uses = {}
        for line in f.read_text(errors="replace").splitlines():
            try:
                rec = json.loads(line)
            except Exception:
                continue
            content = (rec.get("message") or {}).get("content")
            if not isinstance(content, list):
                continue
            for x in content:
                if not isinstance(x, dict):
                    continue
                if x.get("type") == "tool_use":
                    inp = x.get("input") or {}
                    uses[x.get("id")] = (x.get("name", "?"), str(inp.get("command") or inp.get("file_path") or ""))
                elif x.get("type") == "tool_result" and x.get("tool_use_id") not in seen:
                    t = x.get("content")
                    t = t if isinstance(t, str) else json.dumps(t)
                    if not any(s in t for s in DENIED):
                        continue
                    seen.add(x.get("tool_use_id"))
                    name, cmd = uses.get(x.get("tool_use_id"), ("?", ""))
                    if name == "Bash" and standard_form(cmd.strip(), prefixes):
                        std += 1
                    key = f"{name}: {cmd.strip()[:100]}"
                    cmds[key] = cmds.get(key, 0) + 1
    for x in listed:   # main-session denials reported in the JSON result, if not already seen in a transcript
        if isinstance(x, dict) and x.get("tool_use_id") not in seen:
            seen.add(x.get("tool_use_id"))
            inp = x.get("tool_input") or {}
            key = f"{x.get('tool_name', '?')}: {str(inp.get('command') or inp.get('file_path') or '')[:100]}"
            cmds[key] = cmds.get(key, 0) + 1
    top = sorted(cmds.items(), key=lambda kv: -kv[1])[:8]
    return len(seen), std, top


def write(argv):
    import argparse
    ap = argparse.ArgumentParser(prog="pv_drive_status.py write")
    ap.add_argument("--reason", required=True, choices=sorted(EXIT_CODES))
    ap.add_argument("--session", type=int, default=0)
    ap.add_argument("--wait", type=int, default=0)
    ap.add_argument("--reset-at", default="")
    ap.add_argument("--message", default="")
    ap.add_argument("--restarts", type=int, default=0)
    a = ap.parse_args(argv)
    try:
        ver = (ROOT / "KIT_VERSION").read_text().strip()
    except Exception:
        ver = ""
    rec = {"reason": a.reason, "exit_code": EXIT_CODES[a.reason], "session": a.session, "wait_s": a.wait,
           "reset_at": a.reset_at, "restarts": a.restarts, "message": a.message,
           "time": datetime.now().strftime("%Y-%m-%d %H:%M:%S"), "kit_version": ver}
    STATUS.parent.mkdir(parents=True, exist_ok=True)
    tmp = STATUS.with_suffix(".tmp")
    tmp.write_text(json.dumps(rec, indent=2) + "\n")
    os.replace(str(tmp), str(STATUS))
    return 0


def main():
    a = sys.argv[1:]
    cmd = a[0] if a else ""
    if cmd == "classify" and len(a) >= 2:
        err = a[a.index("--err") + 1] if "--err" in a else None
        kind, wait, at, msg = classify(a[1], err)
        print("\t".join([kind, str(wait), at or "-", msg.replace("\t", " ") or "-"]))
        return 0
    if cmd == "progress":
        print(progress())
        return 0
    if cmd == "denials" and len(a) >= 2:
        cd = a[a.index("--claude-dir") + 1] if "--claude-dir" in a else None
        n, std, top = denials(a[1], cd)
        print(f"DENIALS {n} STANDARD_FORM_DENIED {std}")
        for k, v in top:
            print(f"  {v:3d}  {k}")
        return 0
    if cmd == "write":
        return write(a[1:])
    if cmd == "show":
        print(STATUS.read_text() if STATUS.exists() else "no drive_status.json yet")
        return 0
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main())
