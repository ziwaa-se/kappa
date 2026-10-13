"""Shared helpers for the kit's offline tests.

`Project` installs the kit's template into a throwaway folder (no Lean, no Claude) and fills its records with
synthetic results. `fake_claude` puts tests/fake_claude.py on PATH as `claude`, so the unattended driver can be run
end to end against a scripted scenario. Nothing here contacts a model or the network.
"""
import json
import os
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

KIT = Path(__file__).resolve().parent.parent
TESTS = KIT / "tests"
PY = sys.executable


def run(cmd, cwd, env=None, timeout=300):
    """Run a command (list, or a string for the shell) and return the CompletedProcess (stdout+stderr in .out)."""
    e = dict(os.environ)
    e["PWD"] = str(cwd)          # as a shell would set it after `cd`
    e.update(env or {})
    p = subprocess.run(cmd, cwd=str(cwd), env=e, shell=isinstance(cmd, str), stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT, universal_newlines=True, timeout=timeout)
    p.out = p.stdout
    return p


def result(rid, **kw):
    """A result entry with every field of _example_result; keyword arguments override."""
    r = {"id": rid, "pdf_number": kw.pop("pdf_number", rid), "kind": "Lemma", "title": f"result {rid}", "label": "",
         "statement_loc": "source/main.tex:1-2", "proof_loc": "source/main.tex:3-4", "depends_on": [],
         "stage": "INVENTORIED", "statement_fixed": False, "round": 1, "reason": "", "verdict": "UNFINISHED",
         "conditions": [], "gaps": [], "debts": [], "unencoded": [], "issues": [], "upstream_issues": [],
         "partial": "", "lean_main": "", "evidence": {}, "summary_en": ""}
    r.update(kw)
    return r


class Project:
    """A kit project in a temporary folder, with synthetic records."""

    def __init__(self, tmp, results=(), tools=(), name="proj"):
        self.root = Path(tmp) / name
        p = run([str(KIT / "install.sh"), str(self.root)], cwd=tmp)
        if p.returncode:
            raise AssertionError("install.sh failed:\n" + p.out)
        shutil.copy(str(self.root / ".claude/settings.example.json"), str(self.root / ".claude/settings.json"))
        (self.root / "source/main.tex").write_text("\\documentclass{article}\\title{Test paper}\n\\begin{document}\n"
                                                  "\\begin{lemma}x\\end{lemma}\n\\end{document}\n")
        d = self.state()
        d["paper"]["title"] = "Test paper"
        d["defs"] = [{"id": "NONE"}]
        d["results"] = list(results)
        d["external_tools"] = list(tools)
        self.write_state(d)
        p = self.status("init-checklist")
        if p.returncode:
            raise AssertionError("init-checklist failed:\n" + p.out)

    # --- records -------------------------------------------------------------------------------------------------
    def state(self):
        return json.loads((self.root / "verification/RESULTS.json").read_text())

    def write_state(self, d):
        (self.root / "verification/RESULTS.json").write_text(json.dumps(d, indent=2) + "\n")

    def result(self, rid):
        return next(r for r in self.state()["results"] if r["id"] == rid)

    def write(self, rel, text):
        f = self.root / rel
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text(text)
        return f

    def read(self, rel):
        return (self.root / rel).read_text()

    def status(self, *args):
        return run([PY, "scripts/pv_status.py"] + list(args), cwd=self.root)

    def script(self, name, *args, env=None):
        exe = [PY, f"scripts/{name}"] if name.endswith(".py") else [f"scripts/{name}"]
        return run(exe + list(args), cwd=self.root, env=env)

    def make_passed(self, rid, verdict="UNCONDITIONAL", conditions=(), lean_main=None):
        """Give rid the files and records of a result that passed its gate and final audit."""
        self.write(f"verification/audits/{rid}_gate.md", f"# Gate {rid}\n\nSTATEMENT GATE: PASS\n")
        self.write(f"verification/audits/{rid}_final.md", f"# Final audit {rid}\n\nFINAL AUDIT: PASS\n"
                                                           f"SUGGESTED VERDICT: {verdict}\n"
                                                           f"CONDITIONS: {', '.join(conditions) or 'none'}\n")
        self.write(f"pv_work/{rid}Stmt.lean", f"namespace Paper.{rid}\nend Paper.{rid}\n")
        self.write(f"pv_work/{rid}.lean", f"namespace Paper.{rid}\ntheorem main : True := trivial\nend Paper.{rid}\n")
        args = ["record", rid, "--verdict", verdict, "--stage", "FINAL_PASSED", "--statement-fixed", "true",
                "--lean-main", lean_main or f"pv_work/{rid}.lean:2 Paper.{rid}.main", "--summary-en", f"{rid} passed"]
        if conditions:
            args += ["--conditions", ",".join(conditions)]
        p = self.status(*args)
        if p.returncode:
            raise AssertionError(f"record {rid} failed:\n" + p.out)
        return p


def tool(tid, provenance="i", predecessor=None, **kw):
    t = {"id": tid, "lean": f"pv_work/X.lean:1", "meaning": f"external input {tid}", "provenance": provenance,
         "source_loc": "source/main.tex:3", "consumers": [], "human_check": "check it"}
    if predecessor:
        t["predecessor"] = predecessor
    t.update(kw)
    return t


class FakeClaude:
    """Context manager: a PATH entry whose `claude` plays a scripted scenario (tests/fake_claude.py)."""

    def __init__(self, tmp, steps):
        self.dir = Path(tmp) / "fakebin"
        self.dir.mkdir(exist_ok=True)
        self.scenario = Path(tmp) / "scenario.json"
        self.scenario.write_text(json.dumps(steps))
        exe = self.dir / "claude"
        exe.write_text(f"#!/bin/sh\nexec '{PY}' '{TESTS / 'fake_claude.py'}' \"$@\"\n")
        exe.chmod(exe.stat().st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)

    def env(self, **extra):
        e = {"PATH": f"{self.dir}{os.pathsep}{os.environ.get('PATH', '')}", "PV_FAKE_SCENARIO": str(self.scenario)}
        e.update(extra)
        return e

    def calls(self):
        f = Path(str(self.scenario) + ".calls.jsonl")
        return [json.loads(l) for l in f.read_text().splitlines()] if f.exists() else []

    def prompts(self):
        out = []
        for c in self.calls():
            a = c["argv"]
            out.append(a[a.index("-p") + 1] if "-p" in a else "")
        return out


class KitTestCase(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory(prefix="pvkit-test-")
        self.tmp = Path(self._tmp.name)

    def tearDown(self):
        self._tmp.cleanup()
