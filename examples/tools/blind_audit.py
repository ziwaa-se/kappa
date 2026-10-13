#!/usr/bin/env python3
"""blind_audit.py — did a run stay blind? Scans every Claude Code transcript of a project (coordinator and
subagents) for tool calls that touch forbidden locations or name forbidden terms (e.g. the answer key), and for any
network tool. Used for the kit's examples and errata cases; prints a Markdown report, exit 1 on any hit.

Usage: python3 examples/tools/blind_audit.py <project> --forbid <path> [--forbid <path> ...] [--term ANSWER_KEY ...]
       [--claude-dir ~/.claude]
"""
import argparse
import json
import re
import sys
from pathlib import Path

NETWORK_TOOLS = {"WebFetch", "WebSearch"}
NETWORK_CMD = re.compile(r"(^|[\s;&|(])(curl|wget|git\s+clone|pip3?\s+install|ssh|scp|rsync|nc)\s")


def encode(p):
    return re.sub(r"[^A-Za-z0-9]", "-", str(p))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("project")
    ap.add_argument("--forbid", action="append", default=[])
    ap.add_argument("--term", action="append", default=[])
    ap.add_argument("--claude-dir", default=str(Path.home() / ".claude"))
    a = ap.parse_args()
    proj = Path(a.project).absolute()
    dirs = {Path(a.claude_dir) / "projects" / encode(p) for p in (proj, proj.resolve())}
    files = sorted(f for d in dirs if d.is_dir() for f in d.rglob("*.jsonl"))
    needles = [str(Path(p).expanduser()) for p in a.forbid] + a.term
    calls, hits = 0, []
    for f in files:
        for line in f.read_text(errors="replace").splitlines():
            try:
                rec = json.loads(line)
            except ValueError:
                continue
            content = (rec.get("message") or {}).get("content")
            if not isinstance(content, list):
                continue
            for x in content:
                if not isinstance(x, dict) or x.get("type") != "tool_use":
                    continue
                calls += 1
                name, inp = x.get("name", ""), json.dumps(x.get("input") or {})
                why = [n for n in needles if n in inp]
                if name in NETWORK_TOOLS:
                    why.append(f"network tool {name}")
                cmd = str((x.get("input") or {}).get("command") or "")
                if name == "Bash" and NETWORK_CMD.search(cmd):
                    why.append("network command")
                if why:
                    hits.append((f.name, name, "; ".join(why), inp[:200]))
    print(f"# Blind-test audit: {proj.name}\n")
    print(f"- transcripts scanned: {len(files)}; tool calls: {calls}")
    print(f"- forbidden locations and terms: {', '.join('`' + n + '`' for n in needles) or 'none given'}; "
          f"also any WebFetch/WebSearch call and any network command\n")
    if hits:
        print("| transcript | tool | why | input (start) |\n|---|---|---|---|")
        for h in hits:
            print("| " + " | ".join(str(c).replace("|", "\\|") for c in h) + " |")
        print(f"\n**{len(hits)} tool calls touched a forbidden location or the network.**")
        return 1
    print("**No tool call touched a forbidden location, named a forbidden term or used the network.**")
    return 0


if __name__ == "__main__":
    sys.exit(main())
