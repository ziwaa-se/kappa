"""The parts of the mechanical audit that need no Lean (kit v1.5): which lines of a gate report are the snapshot
(scripts/pv_audit_mech.py and the cascade decision in pv_status.py), the check that every Lake package is the pinned,
unmodified git checkout (item 13), and `scripts/pv_lean.sh module`, which tells a library module that is in the
source but not built from one that does not exist."""
import importlib.util
import json
import shutil
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


if __name__ == "__main__":
    unittest.main()
