"""The parts of the mechanical audit that need no Lean (kit v1.5): which lines of a gate report are the snapshot
(scripts/pv_audit_mech.py and the cascade decision in pv_status.py), the check that every Lake package is the pinned,
unmodified git checkout (item 13), and `scripts/pv_lean.sh module`, which tells a library module that is in the
source but not built from one that does not exist; (v1.5.1) `pv_lean.sh preflight` and the check of `stopping` entries,
with a stand-in for `lake`; (v1.5.2) which report counts as a module's record."""
import importlib.util
import json
import os
import shutil
import stat
import sys
import unittest

from helpers import KitTestCase, Project, result, run

GATE = """# Gate P1

## Statement snapshot
<!-- PV SNAPSHOT BEGIN -->
```
Paper.P1.P1_main|thm|th=11|vh=-|bi=ee
Paper.P1.P1_S1|thm|th=22|vh=-|bi=
```
<!-- PV SNAPSHOT END -->

## Gap-file check
The probe (exit 0) prints `Paper.P1.P1_S1_Gap|def|th=33|vh=22|bi=`; earlier draft: `Paper.P1.P1_old|thm|th=44|vh=-|bi=`.

STATEMENT GATE: PASS
"""


def load(project, script):
    sys.modules.pop("pv_status", None)      # pv_audit_mech.py imports it: this project's, not the last test's
    spec = importlib.util.spec_from_file_location(script, str(project.root / "scripts" / f"{script}.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


class Snapshot(KitTestCase):
    def test_only_the_snapshot_block_is_gated(self):
        pr = Project(self.tmp, results=[result("P1")])
        f = pr.write("verification/audits/P1_gate.md", GATE)
        mech, status = load(pr, "pv_audit_mech"), load(pr, "pv_status")
        self.assertEqual(sorted(mech.snapshot(f)), ["Paper.P1.P1_S1", "Paper.P1.P1_main"])
        self.assertEqual(sorted(status.gate_fingerprints("P1", "verification/audits/P1_gate.md")),
                         ["Paper.P1.P1_S1", "Paper.P1.P1_main"])
        # a report without the markers (before v1.5) is read as a whole, but a quoted gap definition never counts
        f = pr.write("verification/audits/P1_gate_r2.md", GATE.replace("<!-- PV SNAPSHOT BEGIN -->\n", "")
                     .replace("<!-- PV SNAPSHOT END -->\n", ""))
        self.assertEqual(sorted(mech.snapshot(f)), ["Paper.P1.P1_S1", "Paper.P1.P1_main", "Paper.P1.P1_old"])


@unittest.skipUnless(shutil.which("git"), "needs git")
class Packages(KitTestCase):
    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("P1")])
        self.pkg = self.pr.root / ".lake/packages/foo"
        self.pr.write(".lake/packages/foo/Foo.lean", "def x := 1\n")
        self.pr.write(".lake/packages/foo/.gitignore", ".lake\n")
        self.git("init", "-q")
        self.git("add", "-A")
        self.git("-c", "user.name=test", "-c", "user.email=test@example.invalid", "commit", "-q", "-m", "pin")
        self.head = self.git("rev-parse", "HEAD").out.strip()
        self.manifest(self.head)

    def git(self, *args):
        p = run(["git", "-C", str(self.pkg)] + list(args), cwd=self.tmp)
        self.assertEqual(p.returncode, 0, p.out)
        return p

    def manifest(self, rev, extra=()):
        pk = [{"name": "foo", "type": "git", "rev": rev, "url": "https://example.invalid/foo"}] + list(extra)
        self.pr.write("lake-manifest.json", json.dumps({"version": "1.1.0", "packages": pk}))

    def check(self):
        return load(self.pr, "pv_audit_mech").package_checks()

    def test_clean_checkout_at_the_pin_passes(self):
        self.pr.write(".lake/packages/foo/.lake/build/Foo.olean", "built files are ignored")
        self.assertEqual(self.check(), ("PASS", "1 packages at the manifest revisions, no local changes"))

    def test_changed_or_moved_checkout_fails(self):
        self.pr.write(".lake/packages/foo/Foo.lean", "def x := 2\n")
        st, det = self.check()
        self.assertEqual(st, "FAIL")
        self.assertIn("foo: 1 local changes, e.g. `Foo.lean`", det)
        self.git("checkout", "-q", "Foo.lean")
        self.manifest("0" * 40)
        st, det = self.check()
        self.assertEqual(st, "FAIL")
        self.assertIn(f"foo: HEAD {self.head[:12]} but manifest 000000000000", det)
        self.manifest(self.head, [{"name": "bar", "type": "git", "rev": "1" * 40}])
        self.assertEqual(self.check(), ("FAIL", "bar: missing"))

    def test_no_git_checkout_is_not_recorded(self):
        shutil.rmtree(str(self.pkg / ".git"))
        st, det = self.check()
        self.assertEqual(st, "NOT RECORDED")
        self.assertIn("foo: not a git checkout", det)


class LibraryModule(KitTestCase):
    def test_built_in_source_not_built_and_missing(self):
        pr = Project(self.tmp, results=[result("P1")])
        m = ".lake/packages/mathlib/"
        pr.write(m + "Mathlib/A/B.lean", "import Mathlib.A.C\nimport Mathlib.A.D\n\nnamespace Mathlib.A.C\n")
        pr.write(m + "Mathlib/A/C.lean", "import Mathlib.Init\n")
        pr.write(m + "Mathlib/A/D.lean", "/- import Mathlib.A.E -/\nimport Mathlib.A.C\n")
        pr.write(m + ".lake/build/lib/lean/Mathlib/A/C.olean", "")
        p = pr.script("pv_lean.sh", "module", "Mathlib.A.B")
        self.assertEqual(p.returncode, 3, p.out)
        self.assertIn("MODULE Mathlib.A.B: in source, not built; 1 module(s) it imports (directly or not) are not "
                      "built either: Mathlib.A.D", p.out)
        self.assertIn("write 'in source, not built: Mathlib.A.B' in mathlib_search", p.out)
        p = pr.script("pv_lean.sh", "module", "Mathlib.A.D")
        self.assertIn("every module it imports is built, so building it compiles this one module only", p.out)
        p = pr.script("pv_lean.sh", "module", "Mathlib.A.C")
        self.assertEqual((p.returncode, p.out.strip()), (0, "MODULE Mathlib.A.C: built"))
        p = pr.script("pv_lean.sh", "module", "Mathlib.A.Nope")
        self.assertEqual(p.returncode, 1, p.out)
        self.assertIn("not in the source of any package", p.out)


class LeanScript(KitTestCase):
    """The parts of pv_lean.sh that read what the compiler prints, with a `lake` that prints a chosen log."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("P1")])
        self.bin = self.tmp / "bin"
        self.bin.mkdir()

    def lake(self, output, code=0):
        f = self.bin / "lake"
        (self.tmp / "lake_output").write_text(output)
        f.write_text(f"#!/bin/sh\ncat '{self.tmp / 'lake_output'}'\nexit {code}\n")
        f.chmod(f.stat().st_mode | stat.S_IEXEC)
        return {"PATH": f"{self.bin}{os.pathsep}{os.environ.get('PATH', '')}"}

    def probe(self, output, code=0):
        self.pr.write("pv_work/probes/auditor/P1/auditor_P1_walk.lean", "import PVTools\n")
        return self.pr.script("pv_lean.sh", "probe", "pv_work/probes/auditor/P1/auditor_P1_walk.lean", env=self.lake(output, code))

    def test_preflight(self):
        p = self.pr.script("pv_lean.sh", "preflight", env=self.lake(""))
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("PREFLIGHT OK", p.out)
        p = self.pr.script("pv_lean.sh", "preflight", env=self.lake("error: unknown package 'mathlib'\n", 1))
        self.assertEqual(p.returncode, 6, p.out)
        self.assertIn("PREFLIGHT FAILED exit=1", p.out)
        self.assertIn("unknown package", p.out)

    def test_a_declaration_name_fails_the_walk(self):
        self.pr.write("pv_work/L09.lean", "\n")
        p = self.probe("WALK declaration Paper.P1.main stopping [L09, Paper.L09.helper]: 1 roots, 9 constants reached\n"
                       "MODULE|L09|2 (stopped)\nMODULE|P1|3\n")
        self.assertEqual(p.returncode, 7, p.out)
        self.assertIn("exit=7", p.out)
        self.assertIn("STOPPING ERROR declaration Paper.P1.main: Paper.L09.helper is not a module", p.out)
        self.assertNotIn(": L09 is not", p.out)
        log = next((self.pr.root / "pv_work/logs").glob("auditor_P1_walk_*.log")).read_text()
        self.assertEqual(log.strip().splitlines()[-1], "EXIT=7")

    def test_module_names_pass(self):
        self.pr.write("pv_work/L09.lean", "\n")
        self.pr.write(".lake/packages/mathlib/Mathlib/A/B.lean", "\n")
        p = self.probe("WALK module P1 stopping [L09, Mathlib.A.B, Init.Prelude]: 5 roots, 9 constants reached\n"
                       "MODULE|L09|2 (stopped)\n")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("STOPPING", p.out)
        self.assertNotIn("NOTE", p.out)
        p = self.probe("WALK module P1 stopping []: 5 roots, 9 constants reached\n")
        self.assertEqual(p.returncode, 0, p.out)

    def test_a_module_the_walk_never_reached_is_noted(self):
        self.pr.write("pv_work/L09.lean", "\n")
        self.pr.write("pv_work/L10.lean", "\n")
        p = self.probe("WALK declaration Paper.P1.a stopping [L09]: 1 roots, 9 constants reached\nMODULE|P1|3\n"
                       "WALK declaration Paper.P1.b stopping [L10]: 1 roots, 9 constants reached\nMODULE|L10|1 (stopped)\n")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("NOTE declaration Paper.P1.a: the walk never reached module L09", p.out)
        self.assertNotIn("module L10", p.out)

    def test_a_compile_error_keeps_its_own_code(self):
        p = self.probe("x.lean:1:0: error: unknown\nWALK module P1 stopping [nope]: 1 roots, 1 constants reached\n", 1)
        self.assertEqual(p.returncode, 1, p.out)
        self.assertIn("STOPPING ERROR", p.out)



class ReportThatCounts(KitTestCase):
    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("P1")])
        self.mech = load(self.pr, "pv_audit_mech")

    def later(self, rel, text):
        f = self.pr.write(rel, text)
        t = f.stat().st_mtime + 60
        os.utime(str(f), (t, t))

    def current(self, rid="P1", kind="gate", prefix="STATEMENT GATE:"):
        rep, why = self.mech.current(self.pr.state(), rid, kind, prefix)
        return rep.name if rep else None, why

    def test_the_same_rule_as_record(self):
        self.pr.write("verification/audits/P1_gate_r3.md", "STATEMENT GATE: PASS\n")
        self.assertEqual(self.current(), ("P1_gate_r3.md", ""))
        self.later("verification/audits/P1_gate_rev5_r2.md", "STATEMENT GATE: PASS\n")
        rep, why = self.current()
        self.assertIsNone(rep)
        self.assertIn("P1_gate_rev5_r2.md is newer than", why)

    def test_a_report_from_before_the_reset_is_no_record(self):
        self.pr.make_passed("P1")
        self.assertEqual(self.pr.status("reset", "P1", "--revision", "2", "--keep-files").returncode, 0)
        for rel in ("verification/audits/P1_gate.md", "verification/audits/P1_final.md"):
            f = self.pr.root / rel
            t = f.stat().st_mtime - 86400
            os.utime(str(f), (t, t))
        self.assertEqual(self.current(), (None, ""))
        self.assertEqual(self.current(kind="final", prefix="FINAL AUDIT:"), (None, ""))

    def test_a_failed_newest_report_is_no_record(self):
        self.pr.write("verification/audits/P1_final.md", "FINAL AUDIT: PASS\n")
        self.pr.write("verification/audits/P1_final_r2.md", "FINAL AUDIT: FAIL\n")
        rep, why = self.current(kind="final", prefix="FINAL AUDIT:")
        self.assertIsNone(rep)
        self.assertIn("P1_final_r2.md does not end with", why)


if __name__ == "__main__":
    unittest.main()
