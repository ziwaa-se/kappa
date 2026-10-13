#!/usr/bin/env python3
"""pv_guard.py — PreToolUse hook: who may write what (kit v1.3.1).

Claude Code runs this before every Write, Edit, MultiEdit, NotebookEdit and Bash call (the "hooks" entry of
.claude/settings.example.json). The hook input names the calling subagent (`agent_type`, e.g. "pv-prover"); the
main session, the coordinator, has none. Rules (POLICY §3–§4):

  1. Nobody writes outside the project: Write/Edit targets, and Bash output redirections or `tee`.
  2. The coordinator writes no Lean file under pv_work/ and no review report under verification/audits/: it does
     not write proofs and does not stand in for a review.
  3. The reviewing roles (pv-gate, pv-auditor, pv-compiler, pv-factcheck) write no Lean file outside their own
     probe folder pv_work/probes/<role>/: they never change what they review.

Every write and every call of a kit script is appended to pv_work/logs/writes.jsonl (time, role, agent id, session,
tool, path or command), so that pv_audit_mech.py can name who ran it and who last wrote an audited file.

PV_GUARD=warn logs refusals without refusing; PV_GUARD=off disables the hook (for a person working by hand).
A failure inside this hook never blocks a tool call: it is logged to pv_work/logs/guard_errors.log.
"""
import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path

REVIEWERS = {"pv-gate", "pv-auditor", "pv-compiler", "pv-factcheck"}
PROBE_DIR = {"pv-gate": "gate", "pv-auditor": "auditor", "pv-compiler": "compiler", "pv-factcheck": "factcheck",
             "pv-issue-checker": "issue-checker", "pv-prover": "prover", "pv-drafter": "drafter",
             "pv-architect": "architect"}
KIT_SCRIPT = re.compile(r"scripts/(pv_[a-z_]+\.(?:py|sh))")


def root_dir(d):
    return Path(os.environ.get("CLAUDE_PROJECT_DIR") or d.get("cwd") or os.getcwd()).resolve()


def resolve(path, root, cwd):
    p = Path(os.path.expanduser(path))
    if not p.is_absolute():
        p = Path(cwd) / p
    try:
        return Path(os.path.realpath(str(p)))
    except Exception:
        return p


def inside(p, root):
    return p == root or root in p.parents


def redirect_targets(cmd):
    """Files a Bash command writes through `>`, `>>` or `tee` (a rough reading; quotes are honoured)."""
    out = []
    for m in re.finditer(r"(?<![0-9&])>>?\s*([^\s;&|()<>]+)|(?:^|[|;&]\s*)tee\s+(?:-a\s+)?([^\s;&|()<>]+)", cmd):
        t = (m.group(1) or m.group(2) or "").strip("'\"")
        if t and t not in ("/dev/null", "/dev/stderr", "/dev/stdout") and not t.startswith("&"):
            out.append(t)
    return out


def decide(role, rel, outside_project):
    """None if allowed, else the reason for refusing a write to `rel` (a path relative to the project root)."""
    who = role or "the coordinator"
    if outside_project:
        return (f"{who} may not write outside the project (POLICY §4): use a path relative to the project root, "
                f"e.g. pv_work/notes/ or pv_work/logs/")
    lean = rel.startswith("pv_work/") and rel.endswith(".lean")
    if not role:
        if lean:
            return ("the coordinator does not write proofs or statements (POLICY §3): give the change to pv-prover "
                    "or pv-drafter")
        if rel.startswith("verification/audits/"):
            return "the coordinator does not write review reports (POLICY §3): they are written by the reviewing roles"
        return None
    if role in REVIEWERS and lean and not rel.startswith(f"pv_work/probes/{PROBE_DIR[role]}/"):
        return (f"{role} never modifies the files it reviews (POLICY §3): write probes under "
                f"pv_work/probes/{PROBE_DIR[role]}/<ID>/")
    return None


def log(root, rec):
    logs = root / "pv_work" / "logs"
    logs.mkdir(parents=True, exist_ok=True)
    with open(str(logs / "writes.jsonl"), "a") as fh:
        fh.write(json.dumps(rec) + "\n")


def main():
    mode = os.environ.get("PV_GUARD", "on")
    if mode == "off":
        return 0
    d = json.load(sys.stdin)
    root = root_dir(d)
    cwd = d.get("cwd") or str(root)
    tool = d.get("tool_name", "")
    inp = d.get("tool_input") or {}
    role = d.get("agent_type") or ""
    base = {"time": datetime.now().strftime("%Y-%m-%d %H:%M:%S"), "role": role or "coordinator",
            "agent_id": d.get("agent_id") or "", "session": d.get("session_id") or "", "tool": tool}
    targets = []
    if tool in ("Write", "Edit", "MultiEdit", "NotebookEdit"):
        targets = [inp.get("file_path") or inp.get("notebook_path") or ""]
    elif tool == "Bash":
        cmd = str(inp.get("command") or "")
        targets = redirect_targets(cmd)
        m = KIT_SCRIPT.search(cmd)
        if m:
            log(root, dict(base, command=cmd[:300], script=m.group(1)))
    refusal = None
    for t in [t for t in targets if t]:
        p = resolve(t, root, cwd)
        out = not inside(p, root)
        rel = str(p) if out else str(p.relative_to(root))
        why = decide(role, rel, out)
        if why:
            log(root, dict(base, path=rel, **{"warn" if mode == "warn" else "refused": why}))
        elif tool != "Bash" or rel.endswith(".lean"):
            log(root, dict(base, path=rel))
        refusal = refusal or why
    if refusal and mode != "warn":
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny",
                                                 "permissionDecisionReason": "pv_guard: " + refusal}}))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:   # never block a tool call because of a bug here
        try:
            root = Path(os.environ.get("CLAUDE_PROJECT_DIR") or os.getcwd())
            (root / "pv_work" / "logs").mkdir(parents=True, exist_ok=True)
            with open(str(root / "pv_work" / "logs" / "guard_errors.log"), "a") as fh:
                fh.write(f"{datetime.now():%Y-%m-%d %H:%M:%S} {type(e).__name__}: {e}\n")
        except Exception:
            pass
        sys.exit(0)
