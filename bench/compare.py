#!/usr/bin/env python3
"""compare.py — compare benchmark runs of the kit: tokens, cost, time, and verdict quality against the answer key.

Usage:  python3 bench/compare.py <run_dir> [<run_dir> ...] [--out bench/results/COMPARISON.md]

Each run_dir was made by bench/run_bench.sh. Token use comes from the Claude Code transcripts (pv_usage.py);
the CLI's own cost figure (list price, from the JSON result of each headless session) is shown next to it.
Results are matched by PDF number, because runs may assign different IDs.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
USAGE = HERE.parent / "template" / "scripts" / "pv_usage.py"
EXPECTED = {"2.1": {"UNCONDITIONAL"}, "2.2": {"CONDITIONAL", "UNCONDITIONAL"}, "2.3": {"ISSUE"}}
PREFERRED = {"2.1": "UNCONDITIONAL", "2.2": "CONDITIONAL", "2.3": "ISSUE"}
PLANTED = "2.3"
ROLES = ["coordinator", "pv-architect", "pv-drafter", "pv-gate", "pv-prover", "pv-auditor", "pv-issue-checker"]


def kit_label(d, meta):
    """The kit version of a run: recorded by run_bench.sh (v1.3.1+), else the project's KIT_VERSION, else the path."""
    ver = meta.get("kit_version")
    if not ver and (d / "KIT_VERSION").exists():
        ver = (d / "KIT_VERSION").read_text().strip()
    if ver and ver != "unknown":
        return "v" + ver
    return "v1.3" if "v1.3" in str(meta.get("kit")) else "v1.2.1"


def load_run(d):
    d = Path(d).resolve()
    meta = json.loads((d / "bench_logs" / "meta.json").read_text())
    meta["kit_label"] = kit_label(d, meta)
    usage = json.loads(subprocess.run([sys.executable, str(USAGE), "--project", str(d), "--json"],
                                      capture_output=True, text=True, check=True).stdout)
    state = json.loads((d / "verification" / "RESULTS.json").read_text())
    blockers = (d / "verification" / "BLOCKERS.md").read_text() if (d / "verification" / "BLOCKERS.md").exists() else ""
    blockers = re.sub(r"<!--.*?-->", "", blockers, flags=re.S)
    res = {}
    for r in state.get("results", []):
        codes = []
        for b in r.get("issues", []) or []:
            m = re.search(rf"^##\s+{re.escape(b)}\b.*$", blockers, flags=re.M)
            if m:
                codes += re.findall(r"\b(ERROR|PAPER_ARGUMENT_GAP|PAPER_ASSUMPTION_GAP|EXPOSITION_GAP|DOMAIN_CLARIFICATION)\b",
                                    m.group(0))
        res[str(r.get("pdf_number"))] = {"id": r.get("id"), "verdict": r.get("verdict"), "stage": r.get("stage"),
                                         "reason": r.get("reason", ""), "conditions": r.get("conditions", []),
                                         "codes": codes, "models": r.get("models_used", [])}
    # Cost and time from every headless session's own JSON result (a resumed run has several sessions; the pause
    # between them is not counted as run time).
    cli_cost, active_ms, sessions = 0.0, 0, 0
    for f in sorted((d / "bench_logs").glob("session_*.json")):
        try:
            j = json.loads(f.read_text())
        except Exception:
            continue
        sessions += 1
        cli_cost += j.get("total_cost_usd") or 0
    # Run time: for each main session, first to last timestamp over it and its subagents; summed over sessions.
    from datetime import datetime
    spans = {}
    for row in usage["rows"]:
        if row["start"] and row["end"]:
            a, b = datetime.fromisoformat(row["start"]), datetime.fromisoformat(row["end"])
            lo, hi = spans.get(row["session"], (a, b))
            spans[row["session"]] = (min(lo, a), max(hi, b))
    active_ms = sum((hi - lo).total_seconds() * 1000 for lo, hi in spans.values())
    return {"dir": d, "label": meta.get("label", d.name), "meta": meta, "usage": usage, "results": res,
            "cli_cost": cli_cost, "active_min": active_ms / 60000, "sessions": sessions}


def score(run):
    res = run["results"]
    ok = sum(1 for k, exp in EXPECTED.items() if res.get(k, {}).get("verdict") in exp)
    detected = res.get(PLANTED, {}).get("verdict") == "ISSUE"
    false_alarm = sum(1 for k in EXPECTED if k != PLANTED and res.get(k, {}).get("verdict") == "ISSUE")
    unfinished = sum(1 for k in EXPECTED if res.get(k, {}).get("verdict") in (None, "UNFINISHED"))
    return ok, detected, false_alarm, unfinished


def fmt_tok(n):
    return f"{n / 1e6:.2f}M"


def main():
    args = sys.argv[1:]
    out = None
    if "--out" in args:
        i = args.index("--out")
        out = args[i + 1]
        args = args[:i] + args[i + 2:]
    runs = [load_run(a) for a in args]
    L = []
    L.append("## Benchmark runs: efficiency and quality\n")
    L.append("| Run | Kit | Coordinator | Sessions | Run time | Tokens (all kinds) | Est. cost (transcripts) | CLI-reported cost | "
             "Cost per verdict | Verdicts as expected | Planted error caught | False alarms | Unfinished |")
    L.append("|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|")
    for r in runs:
        ok, det, fa, unf = score(r)
        n = max(1, sum(1 for k in EXPECTED if r["results"].get(k, {}).get("verdict") not in (None, "UNFINISHED")))
        kit = r["meta"]["kit_label"]
        L.append(f"| {r['label']} | {kit} | {r['meta'].get('coordinator_model')}"
                 f"{' + driver' if r['meta'].get('driver') else ''} | {r['sessions']} | {r['active_min']:.0f} min | "
                 f"{fmt_tok(r['usage']['total_tokens'])} | ${r['usage']['total_cost_usd']:.2f} | ${r['cli_cost']:.2f} | "
                 f"${r['usage']['total_cost_usd'] / n:.2f} | {ok}/3 | {'yes' if det else 'no'} | {fa} | {unf} |")
    # Per kit: mean and range over repeated runs (is the difference stable?)
    kits = {}
    for r in runs:
        kit = r["meta"]["kit_label"]
        kits.setdefault(kit, []).append(r)
    if any(len(v) > 1 for v in kits.values()):
        L.append("\n### Per kit, over repeated runs (mean, and min–max)\n")
        L.append("| Kit | Runs | Cost | Tokens | Run time | Verdicts as expected |")
        L.append("|---|---:|---:|---:|---:|---|")
        for kit, rs in kits.items():
            c = [x["usage"]["total_cost_usd"] for x in rs]
            t = [x["usage"]["total_tokens"] / 1e6 for x in rs]
            m = [x["active_min"] for x in rs]
            ok = [f"{score(x)[0]}/3" for x in rs]
            L.append(f"| {kit} | {len(rs)} | ${sum(c)/len(c):.2f} (${min(c):.2f}–${max(c):.2f}) | "
                     f"{sum(t)/len(t):.1f}M ({min(t):.1f}–{max(t):.1f}M) | {sum(m)/len(m):.0f} min ({min(m):.0f}–{max(m):.0f}) | "
                     f"{', '.join(ok)} |")
    L.append("\n### Cost by role (list-price estimate from the transcripts)\n")
    L.append("| Role | " + " | ".join(r["label"] for r in runs) + " |")
    L.append("|---|" + "---:|" * len(runs))
    roles = ROLES + sorted({k for r in runs for k in r["usage"]["by_role"]} - set(ROLES))
    for role in roles:
        cells = []
        for r in runs:
            g = r["usage"]["by_role"].get(role)
            cells.append(f"${g['cost_usd']:.2f} ({int(g['agents'])}×, {fmt_tok(g['input'] + g['cache_write'] + g['cache_read'] + g['output'])})"
                         if g else "—")
        if any(c != "—" for c in cells):
            L.append(f"| {role} | " + " | ".join(cells) + " |")
    L.append("\n### Cost by model\n")
    L.append("| Model | " + " | ".join(r["label"] for r in runs) + " |")
    L.append("|---|" + "---:|" * len(runs))
    for m in sorted({k for r in runs for k in r["usage"]["by_model"]}):
        L.append(f"| {m} | " + " | ".join(f"${r['usage']['by_model'][m]['cost_usd']:.2f}" if m in r["usage"]["by_model"]
                                           else "—" for r in runs) + " |")
    L.append("\n### Verdicts (expected: 2.1 UNCONDITIONAL, 2.2 CONDITIONAL on Nesbitt, 2.3 ISSUE — planted error)\n")
    L.append("| PDF no. | Expected | " + " | ".join(r["label"] for r in runs) + " |")
    L.append("|---|---|" + "---|" * len(runs))
    for k in EXPECTED:
        cells = []
        for r in runs:
            x = r["results"].get(k)
            if not x:
                cells.append("missing")
                continue
            extra = []
            if x["conditions"]:
                extra.append("conditions: " + ", ".join(x["conditions"]))
            if x["codes"]:
                extra.append("codes: " + ", ".join(x["codes"]))
            if x["reason"]:
                extra.append(x["reason"])
            cells.append(f"{x['verdict']}" + (f" ({'; '.join(extra)})" if extra else ""))
        L.append(f"| {k} | {PREFERRED[k]} | " + " | ".join(cells) + " |")
    text = "\n".join(L) + "\n"
    print(text)
    if out:
        Path(out).write_text(text)


if __name__ == "__main__":
    main()
