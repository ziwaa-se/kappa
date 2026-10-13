"""Importing an earlier check that was not made with the kit (autosetup/import_legacy.py, PENDING v1.3.1 #9).
The rebuild test needs a Lean environment (PV_TEST_LEAN_ENV, see test_lean_integration.py)."""
import json
import os
import unittest
from pathlib import Path

from helpers import KIT, PY, KitTestCase, Project, result, run

LEAN_ENV = os.environ.get("PV_TEST_LEAN_ENV", "")
SCRIPT = str(KIT / "autosetup/import_legacy.py")


def legacy_tree(root):
    files = {"Paper/Base.lean": "namespace Paper\ntheorem base : 1 + 1 = 2 := rfl\nend Paper\n",
             "Paper/Uses.lean": "import Paper.Base\nnamespace Paper\ntheorem uses : 1 + 1 = 2 := base\nend Paper\n",
             "Paper/Draft.lean": "namespace Paper\ntheorem draft : 2 + 2 = 4 := sorry\nend Paper\n",
             "Paper/Broken.lean": "namespace Paper\ntheorem broken : 2 + 2 = 5 := rfl\nend Paper\n",
             "Paper/AfterBroken.lean": "import Paper.Broken\nnamespace Paper\ntheorem after : True := trivial\nend Paper\n"}
    for rel, text in files.items():
        p = root / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)


class ImportOffline(KitTestCase):
    def test_copy_protect_and_record(self):
        pr = Project(self.tmp, results=[result("T01"), result("L01")])
        legacy_tree(self.tmp / "old")
        (self.tmp / "v.tsv").write_text("T01\tISSUE\tB07 counterexample\nL01\tUNCONDITIONAL\t\nX99\tISSUE\t\n")
        p = run([PY, SCRIPT, str(pr.root), str(self.tmp / "old"), "--no-build", "--label", "prev-2026-09",
                 "--verdicts", str(self.tmp / "v.tsv")], cwd=self.tmp)
        self.assertEqual(p.returncode, 0, p.out)
        copied = pr.root / "pv_work/Paper/Uses.lean"
        self.assertTrue(copied.exists())
        self.assertFalse(os.access(str(copied), os.W_OK), "copies are read-only")
        self.assertIn("Edit(pv_work/Paper/**)", p.out)
        self.assertIn("no result X99", p.out)
        self.assertEqual(pr.result("T01")["history"][-1]["verdict"], "ISSUE")
        self.assertEqual(pr.result("T01")["history"][-1]["revision"], "prev-2026-09")
        brief = pr.read("verification/REVISION_BRIEF.md")
        self.assertIn("5 modules", brief)
        self.assertEqual(pr.status("validate").returncode, 0)

    def test_clashes_are_refused(self):
        pr = Project(self.tmp)
        (self.tmp / "old").mkdir()
        (self.tmp / "old/PVTools.lean").write_text("-- not the kit's\n")
        p = run([PY, SCRIPT, str(pr.root), str(self.tmp / "old"), "--no-build"], cwd=self.tmp)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("refused", p.out)

    def test_write_settings_adds_deny_rules_with_a_backup(self):
        pr = Project(self.tmp)
        legacy_tree(self.tmp / "old")
        run([PY, SCRIPT, str(pr.root), str(self.tmp / "old"), "--no-build", "--write-settings"], cwd=self.tmp)
        deny = json.loads(pr.read(".claude/settings.json"))["permissions"]["deny"]
        self.assertIn("Write(pv_work/Paper/**)", deny)
        self.assertTrue(list((pr.root / ".claude").glob("settings.json.before-import-*")))


@unittest.skipUnless(LEAN_ENV and Path(LEAN_ENV, ".lake/packages/mathlib").is_dir(), "set PV_TEST_LEAN_ENV")
class ImportBuild(KitTestCase):
    def test_rebuild_in_import_order(self):
        root = self.tmp / "proj"
        p = run([str(KIT / "install.sh"), str(root), "--lean-from", os.path.expanduser(LEAN_ENV), "--link-packages"],
                cwd=self.tmp, timeout=1800)
        self.assertEqual(p.returncode, 0, p.out)
        legacy_tree(self.tmp / "old")
        p = run([PY, SCRIPT, str(root), str(self.tmp / "old")], cwd=self.tmp, timeout=1800)
        self.assertEqual(p.returncode, 0, p.out)
        built = json.loads((root / "pv_work/logs/import_legacy_manifest.json").read_text())["built"]
        self.assertEqual(built["Paper.Base"], "built")
        self.assertEqual(built["Paper.Uses"], "built")
        self.assertEqual(built["Paper.Draft"], "built, uses sorry")
        self.assertEqual(built["Paper.Broken"], "failed")
        self.assertEqual(built["Paper.AfterBroken"], "skipped (an import failed)")
        self.assertTrue((root / "pv_work/Paper/Uses.olean").exists())
