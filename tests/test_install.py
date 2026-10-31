"""install.sh, the suggested permission file (scripts/pv_settings.py), the Lean IO guard and the rule cards.
Covers PENDING v1.3.1 #2 (spellings of kit commands), #17 (network and IO) and #20 (paths)."""
import json
import shutil

from helpers import KIT, PY, KitTestCase, Project, run


class Settings(KitTestCase):
    def allow(self, root):
        return json.loads((root / ".claude/settings.example.json").read_text())["permissions"]["allow"]

    def test_example_lists_every_spelling_for_this_project(self):
        pr = Project(self.tmp)
        allow = self.allow(pr.root)
        for rule in ["Bash(scripts/pv_lean.sh *)", "Bash(./scripts/pv_lean.sh *)", "Bash(bash scripts/pv_lean.sh *)",
                     f"Bash({pr.root}/scripts/pv_lean.sh *)", f"Bash(python3 {pr.root}/scripts/pv_status.py *)",
                     "Bash(python3 ./scripts/pv_audit_mech.py *)"]:
            self.assertIn(rule, allow)
        self.assertNotIn("Bash(lake env lean *)", allow)     # it would bypass pv_lean.sh and its IO guard
        for s in ("pv_graph.py", "pv_summary.py", "pv_export.py"):                                    # v1.5
            self.assertIn(f"Bash(python3 scripts/{s} *)", allow)
            self.assertIn(f"Bash(python3 {pr.root}/scripts/{s} *)", allow)

    def test_expand_is_idempotent_and_follows_a_moved_project(self):
        pr = Project(self.tmp)
        before = pr.read(".claude/settings.example.json")
        self.assertEqual(pr.script("pv_settings.py", "expand").returncode, 0)
        self.assertEqual(pr.read(".claude/settings.example.json"), before)
        moved = self.tmp / "moved"
        shutil.copytree(str(pr.root), str(moved), symlinks=True)
        run([PY, "scripts/pv_settings.py", "expand"], cwd=moved)
        allow = self.allow(moved)
        self.assertIn(f"Bash({moved}/scripts/pv_lean.sh *)", allow)
        self.assertFalse(any(str(pr.root) + "/" in r for r in allow), "old absolute paths must be dropped")

    def test_upgrade_does_not_report_the_generated_file_as_replaced(self):
        pr = Project(self.tmp)
        p = run([str(KIT / "install.sh"), str(pr.root), "--upgrade"], cwd=self.tmp)
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("REPLACED .claude/settings.example.json", p.out)

    def test_check_lists_missing_rules(self):
        pr = Project(self.tmp)
        cur = json.loads(pr.read(".claude/settings.json"))
        cur["permissions"]["allow"] = cur["permissions"]["allow"][:3]
        pr.write(".claude/settings.json", json.dumps(cur))
        p = pr.script("pv_settings.py", "check")
        self.assertEqual(p.returncode, 1)
        self.assertIn(f"Bash(python3 {pr.root}/scripts/pv_status.py *)", p.out)

    def test_linked_packages_are_readable_but_not_editable(self):
        lib = self.tmp / "lean-env" / ".lake" / "packages"
        (lib / "mathlib").mkdir(parents=True)
        root = self.tmp / "linked"
        p = run([str(KIT / "install.sh"), str(root)], cwd=self.tmp)
        self.assertEqual(p.returncode, 0, p.out)
        (root / ".lake").mkdir()
        (root / ".lake" / "packages").symlink_to(lib)
        run([PY, "scripts/pv_settings.py", "expand"], cwd=root)
        d = json.loads((root / ".claude/settings.example.json").read_text())["permissions"]
        real = str(lib.resolve())
        self.assertEqual(d["additionalDirectories"], [real])
        self.assertIn(f"Edit(/{real}/**)", d["deny"])
        self.assertIn("Edit(.lake/**)", d["deny"])

    def test_network_tools_are_denied(self):
        deny = json.loads((KIT / "template/.claude/settings.example.json").read_text())["permissions"]["deny"]
        for rule in ["WebFetch", "WebSearch", "Bash(curl *)", "Bash(wget *)", "Bash(git clone *)", "Bash(pip install *)",
                     "Bash(lake exe *)", "Edit(scripts/**)"]:
            self.assertIn(rule, deny)


class LeanGuard(KitTestCase):
    def test_lean_files_that_run_programs_are_refused(self):
        pr = Project(self.tmp)
        pr.write("pv_work/Bad.lean", 'def x := 1\n#eval IO.Process.run { cmd := "curl", args := #["x"] }\n')
        p = pr.script("pv_lean.sh", "check", "Bad")
        self.assertEqual(p.returncode, 5, p.out)
        self.assertIn("REFUSED Bad", p.out)
        pr.write("pv_work/Bad2.lean", "run_cmd Lean.logInfo \"hi\"\n")
        self.assertEqual(pr.script("pv_lean.sh", "probe", "pv_work/Bad2.lean").returncode, 5)

    def test_ordinary_files_and_comments_pass_the_guard(self):
        pr = Project(self.tmp)
        pr.write("pv_work/Good.lean", "-- IO is mentioned only in this comment\ntheorem t (IOx : Nat) : IOx = IOx := rfl\n")
        p = pr.script("pv_lean.sh", "check", "Good")
        self.assertNotIn("REFUSED", p.out)


class RuleCards(KitTestCase):
    def test_every_card_states_the_command_format(self):
        for card in (KIT / "template/.claude/agents").glob("*.md"):
            self.assertIn("**Commands (POLICY §4).**", card.read_text(), card.name)

    def test_cited_rule_sections_exist(self):
        pr = Project(self.tmp)
        p = pr.script("pv_cards_check.py")
        self.assertEqual(p.returncode, 0, p.out)
