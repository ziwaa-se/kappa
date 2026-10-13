#!/usr/bin/env python3
"""Stand-in for the `claude` command in the kit's offline tests. It never contacts a model.

The tests put a `claude` wrapper that runs this file first on PATH. Each call plays the next step of the scenario in
$PV_FAKE_SCENARIO (a JSON list) inside the current directory (a throwaway project), then prints a result in the
shape of `claude -p --output-format json`. A step may contain:

  "run":    shell commands to run in the project (e.g. pv_status.py record ...), in order
  "files":  {"relative/path": "content"} files to write
  "set":    {"<result id>": {field: value, ...}} fields to change in verification/RESULTS.json
  "result": the result text (default "done"); "is_error": true/false; "subtype"; "cost" (total_cost_usd)
  "stdout": raw text to print instead of the JSON result (e.g. "" for a crash with no JSON)
  "stderr": text for stderr; "exit": exit code (default 0, or 1 when is_error)

Every call is appended to $PV_FAKE_SCENARIO.calls.jsonl (argv and working directory) for the tests to inspect.
"""
import json
import os
import subprocess
import sys
from pathlib import Path


def main():
    scen_path = Path(os.environ["PV_FAKE_SCENARIO"])
    steps = json.loads(scen_path.read_text())
    counter = Path(str(scen_path) + ".count")
    k = int(counter.read_text()) if counter.exists() else 0
    counter.write_text(str(k + 1))
    with open(str(scen_path) + ".calls.jsonl", "a") as fh:
        fh.write(json.dumps({"call": k + 1, "argv": sys.argv[1:], "cwd": os.getcwd()}) + "\n")
    if k >= len(steps):
        step = {"result": "fake claude: no scenario step left", "is_error": True}
    else:
        step = steps[k]
    for rel, text in (step.get("files") or {}).items():
        p = Path(rel)
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)
    if step.get("set"):
        f = Path("verification/RESULTS.json")
        d = json.loads(f.read_text())
        for r in d.get("results", []):
            r.update(step["set"].get(r.get("id"), {}))
        f.write_text(json.dumps(d, indent=2) + "\n")
    for cmd in step.get("run") or []:
        p = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
        if p.returncode:
            sys.stderr.write(f"fake claude: step command failed ({p.returncode}): {cmd}\n{p.stdout}\n")
    is_error = bool(step.get("is_error", False))
    if "stdout" in step:
        sys.stdout.write(step["stdout"])
    else:
        out = {"type": "result", "subtype": step.get("subtype", "error_during_execution" if is_error else "success"),
               "is_error": is_error, "result": step.get("result", "done"), "num_turns": 3,
               "session_id": f"fake-session-{k + 1}", "total_cost_usd": step.get("cost", 0.01),
               "terminal_reason": step.get("terminal_reason", "completed")}
        sys.stdout.write(json.dumps(out))
    sys.stderr.write(step.get("stderr", ""))
    sys.exit(step.get("exit", 1 if is_error else 0))


if __name__ == "__main__":
    main()
