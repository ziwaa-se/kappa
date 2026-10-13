#!/usr/bin/env python3
"""pv_usage.py — where did the tokens go? Token and cost attribution for a kit run (kit v1.3).

Reads the Claude Code transcripts of this project (main sessions = coordinator, subagent transcripts = roles)
and sums the `usage` of every model response, attributed to role, result ID and model.

Usage (from the project root, or pass --project):
  python3 scripts/pv_usage.py                    table by role, by model and by result ID
  python3 scripts/pv_usage.py --json             the same as JSON (used by bench/compare.py)
  python3 scripts/pv_usage.py --csv usage.csv    one row per transcript
  options: --project DIR (default: this project), --since 2026-09-30T10:00 (UTC, ISO), --claude-dir DIR

Where the transcripts are: ~/.claude/projects/<project path with every non-alphanumeric character replaced by '-'>/
  <session>.jsonl                          a main session (the coordinator)
  <session>/subagents/agent-<id>.jsonl     a subagent; agent-<id>.meta.json names its type (pv-prover, ...)

Cost is an ESTIMATE at list API prices (PRICES below, per million tokens; check them against the current price
list). On a subscription plan the same weighting roughly tracks how fast the usage limit is consumed. A response is
counted once even though the transcript repeats it for every content block (deduplicated by message id).

Two figures (v1.3.1). Claude Code reports its own estimate per headless session (`total_cost_usd`, and `costUSD` per
model). This script reads every transcript, so it also covers interactive sessions and sessions outside the driver.
When the driver's session files exist (pv_work/logs/drive/, bench_logs/), the report ends with a per-model comparison
of the two for the same sessions. Token counts agree; a model whose costs differ has an out-of-date row in PRICES.
"""
import argparse
import csv
import json
import re
import sys
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

# $ per million tokens: input, output, cache write (5 min), cache write (1 h), cache read. Longest prefix wins.
PRICES = {
    "claude-fable-5-1": (10.0, 50.0, 12.5, 20.0, 0.25),
    "claude-fable-5": (10.0, 50.0, 12.5, 20.0, 1.0),
    "claude-opus-5-5": (4.0, 20.0, 5.0, 8.0, 0.20),
    "claude-opus-5": (5.0, 25.0, 6.25, 10.0, 0.50),
    "claude-opus-4": (5.0, 25.0, 6.25, 10.0, 0.50),
    "claude-sonnet-5-5": (2.0, 10.0, 2.5, 4.0, 0.10),   # v1.3.1: cache reads at 0.10, as the CLI's costUSD shows
    "claude-sonnet-5": (2.0, 10.0, 2.5, 4.0, 0.20),
    "claude-sonnet-4": (3.0, 15.0, 3.75, 6.0, 0.30),
    "claude-haiku-4-5": (1.0, 5.0, 1.25, 2.0, 0.10),
}
ROLES = ["coordinator", "pv-architect", "pv-drafter", "pv-gate", "pv-prover", "pv-auditor",
         "pv-issue-checker", "pv-compiler", "pv-factcheck"]


def price(model):
    best = None
    for k in PRICES:
        if model.startswith(k) and (best is None or len(k) > len(best)):
            best = k
    return PRICES.get(best)


def encode(path):
    return re.sub(r"[^A-Za-z0-9]", "-", str(path))


def parse_ts(s):
    """ISO timestamps such as 2026-09-30T20:41:23.123Z (written without datetime.fromisoformat, for Python 3.6)."""
    m = re.match(r"(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2})(?:\.(\d+))?)?", s or "")
    if not m:
        return None
    y, mo, d, h, mi = (int(m.group(i)) for i in range(1, 6))
    sec = int(m.group(6) or 0)
    us = int((m.group(7) or "0")[:6].ljust(6, "0"))
    return datetime(y, mo, d, h, mi, sec, us, tzinfo=timezone.utc)


def first_prompt(lines):
    for d in lines:
        if d.get("type") == "user":
            c = d.get("message", {}).get("content")
            if isinstance(c, str):
                return c
            if isinstance(c, list):
                return " ".join(x.get("text", "") for x in c if isinstance(x, dict) and x.get("type") == "text")
    return ""


def read_transcript(path, since=None):
    """Return (per-response usage list, first timestamp, last timestamp, first prompt)."""
    lines = []
    for raw in path.open(errors="replace"):
        try:
            lines.append(json.loads(raw))
        except json.JSONDecodeError:
            continue
    best = {}
    t0 = t1 = None
    for d in lines:
        ts = parse_ts(d.get("timestamp", "")) if d.get("timestamp") else None
        if ts and since and ts < since:
            continue
        if ts:
            t0 = ts if t0 is None or ts < t0 else t0
            t1 = ts if t1 is None or ts > t1 else t1
        if d.get("type") != "assistant":
            continue
        m = d.get("message", {})
        u = m.get("usage") or {}
        model = m.get("model", "")
        if not u or model.startswith("<"):
            continue
        key = m.get("id") or d.get("requestId") or d.get("uuid")
        prev = best.get(key)
        if prev is None or u.get("output_tokens", 0) >= prev[1].get("output_tokens", 0):
            best[key] = (model, u)
    return list(best.values()), t0, t1, first_prompt(lines)


def cost_of(model, u):
    p = price(model)
    if not p:
        return 0.0
    cc = u.get("cache_creation") or {}
    w5, w1 = cc.get("ephemeral_5m_input_tokens"), cc.get("ephemeral_1h_input_tokens")
    if w5 is None and w1 is None:
        w5, w1 = u.get("cache_creation_input_tokens", 0), 0
    return (u.get("input_tokens", 0) * p[0] + u.get("output_tokens", 0) * p[1] + (w5 or 0) * p[2]
            + (w1 or 0) * p[3] + u.get("cache_read_input_tokens", 0) * p[4]) / 1e6


def result_id(desc, prompt, ids):
    """The result an agent worked on: the first ID named in its task description, else in its prompt."""
    pats = [re.escape(i) for i in sorted(ids, key=len, reverse=True)] + [r"DEFS", r"[A-Z]{1,2}\d{2}"]
    rx = re.compile(r"(?<![A-Za-z0-9])(" + "|".join(pats) + r")(?![0-9])")
    for text in (desc, prompt):
        m = rx.search(text or "")
        if m:
            return m.group(1)
    return "-"


def collect(project, claude_dir, since):
    pdir = claude_dir / "projects" / encode(project)
    if not pdir.is_dir():
        sys.exit(f"no transcripts at {pdir}")
    ids = []
    state = project / "verification" / "RESULTS.json"
    if state.exists():
        try:
            ids = [r["id"] for r in json.loads(state.read_text()).get("results", []) if isinstance(r, dict) and r.get("id")]
        except Exception:
            pass
    rows = []
    for main in sorted(pdir.glob("*.jsonl")):
        items = [("coordinator", main, main.stem, "")]
        sub = pdir / main.stem / "subagents"
        for f in sorted(sub.glob("agent-*.jsonl")) if sub.is_dir() else []:
            meta = {}
            mf = f.with_suffix(".meta.json")
            if mf.exists():
                try:
                    meta = json.loads(mf.read_text())
                except Exception:
                    pass
            items.append((meta.get("agentType") or "unknown", f, main.stem, meta.get("description", "")))
        for role, f, session, desc in items:
            usages, t0, t1, prompt = read_transcript(f, since)
            if not usages:
                continue
            agg = defaultdict(float)
            models = defaultdict(float)
            for model, u in usages:
                c = cost_of(model, u)
                agg["input"] += u.get("input_tokens", 0)
                agg["output"] += u.get("output_tokens", 0)
                agg["cache_write"] += u.get("cache_creation_input_tokens", 0)
                agg["cache_read"] += u.get("cache_read_input_tokens", 0)
                agg["cost"] += c
                models[model] += c
            rows.append({
                "role": role, "session": session, "file": str(f), "description": desc,
                "cost_by_model": {m: round(c, 6) for m, c in models.items()},
                "result": "-" if role in ("coordinator", "pv-architect", "pv-compiler", "pv-factcheck")
                          else result_id(desc, prompt[:3000], ids),
                "model": max(models, key=models.get) if models else "",
                "responses": len(usages), "input": int(agg["input"]), "output": int(agg["output"]),
                "cache_write": int(agg["cache_write"]), "cache_read": int(agg["cache_read"]),
                "cost_usd": round(agg["cost"], 4),
                "start": t0.isoformat() if t0 else "", "end": t1.isoformat() if t1 else "",
                "minutes": round((t1 - t0).total_seconds() / 60, 1) if t0 and t1 else 0.0,
            })
    return rows


def group(rows, key):
    out = defaultdict(lambda: defaultdict(float))
    for r in rows:
        g = out[r[key]]
        g["agents"] += 1
        for k in ("responses", "input", "output", "cache_write", "cache_read", "cost_usd", "minutes"):
            g[k] += r[k]
    return out


def fmt(n):
    return f"{n/1e6:.2f}M" if n >= 1e6 else (f"{n/1e3:.0f}k" if n >= 1e3 else f"{int(n)}")


def table(title, groups, order=None):
    keys = [k for k in (order or []) if k in groups] + sorted(k for k in groups if k not in (order or []))
    tot = defaultdict(float)
    print(f"\n### {title}\n")
    print("| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |")
    print("|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
    allc = sum(g["cost_usd"] for g in groups.values()) or 1
    for k in keys:
        g = groups[k]
        for f in g:
            tot[f] += g[f]
        print(f"| {k} | {int(g['agents'])} | {int(g['responses'])} | {fmt(g['input'])} | {fmt(g['cache_write'])} | "
              f"{fmt(g['cache_read'])} | {fmt(g['output'])} | ${g['cost_usd']:.2f} | {100*g['cost_usd']/allc:.0f}% | "
              f"{g['minutes']:.0f} |")
    print(f"| **total** | {int(tot['agents'])} | {int(tot['responses'])} | {fmt(tot['input'])} | {fmt(tot['cache_write'])} | "
          f"{fmt(tot['cache_read'])} | {fmt(tot['output'])} | **${tot['cost_usd']:.2f}** | 100% | {tot['minutes']:.0f} |")


def cli_check(project, rows):
    """Compare, per model, this script's estimate with the cost Claude Code reported for the same headless sessions."""
    cli, seen = defaultdict(float), set()
    for f in list((project / "pv_work" / "logs" / "drive").glob("*.json")) + list((project / "bench_logs").glob("*.json")):
        try:
            d = json.loads(f.read_text())
        except Exception:
            continue
        sid = d.get("session_id") if isinstance(d, dict) else None
        if not sid or sid in seen or not isinstance(d.get("modelUsage"), dict):
            continue
        seen.add(sid)
        for m, v in d["modelUsage"].items():
            cli[re.sub(r"\[.*\]$", "", m)] += float(v.get("costUSD") or 0)
    if not seen:
        return None
    est, other = defaultdict(float), 0.0
    for r in rows:
        for m, c in r.get("cost_by_model", {}).items():
            if r["session"] in seen:
                est[m] += c
            else:
                other += c
    out = {"sessions": len(seen), "models": {}, "outside_cost_usd": round(other, 2)}
    for m in sorted(set(cli) | set(est)):
        out["models"][m] = {"transcripts": round(est.get(m, 0), 2), "claude_code": round(cli.get(m, 0), 2)}
    return out


def print_cli_check(chk):
    print(f"\n### Check against the cost Claude Code reported ({chk['sessions']} headless sessions)\n")
    print("| model | this script | Claude Code | difference |")
    print("|---|---:|---:|---:|")
    for m, v in chk["models"].items():
        a, b = v["transcripts"], v["claude_code"]
        diff = f"{100 * (a - b) / b:+.1f}%" if b else "—"
        print(f"| {m} | ${a:.2f} | ${b:.2f} | {diff} |")
    print(f"\nSessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): "
          f"${chk['outside_cost_usd']:.2f}. A difference of more than a few cents for one model means its row in "
          f"PRICES is out of date; the token counts are the same.")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--project", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--claude-dir", default=str(Path.home() / ".claude"))
    ap.add_argument("--since")
    ap.add_argument("--csv")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    project = Path(a.project).resolve()
    since = parse_ts(a.since + ("" if "+" in a.since or a.since.endswith("Z") else "+00:00")) if a.since else None
    rows = collect(project, Path(a.claude_dir), since)
    starts = [parse_ts(r["start"]) for r in rows if r["start"]]
    ends = [parse_ts(r["end"]) for r in rows if r["end"]]
    wall = round((max(ends) - min(starts)).total_seconds() / 60, 1) if starts and ends else 0.0
    if a.csv:
        with open(a.csv, "w", newline="") as fh:
            fields = [k for k in (rows[0].keys() if rows else ["role"]) if k != "cost_by_model"]
            w = csv.DictWriter(fh, fieldnames=fields, extrasaction="ignore")
            w.writeheader()
            w.writerows(rows)
    chk = cli_check(project, rows)
    if a.json:
        out = {"project": str(project), "wall_minutes": wall, "rows": rows,
               "by_role": {k: dict(v) for k, v in group(rows, "role").items()},
               "by_model": {k: dict(v) for k, v in group(rows, "model").items()},
               "by_result": {k: dict(v) for k, v in group(rows, "result").items()},
               "total_cost_usd": round(sum(r["cost_usd"] for r in rows), 4),
               "total_tokens": sum(r["input"] + r["output"] + r["cache_write"] + r["cache_read"] for r in rows),
               "claude_code_check": chk}
        print(json.dumps(out, indent=1))
        return
    print(f"## Token use — {project.name} (wall clock {wall:.0f} min; costs are list-price estimates)")
    table("By role", group(rows, "role"), ROLES)
    table("By model", group(rows, "model"))
    table("By result", group(rows, "result"))
    if chk:
        print_cli_check(chk)


if __name__ == "__main__":
    main()
