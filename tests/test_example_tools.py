"""The tools used to publish example runs: examples/tools/sanitize.py (no local paths, user names or e-mail
addresses) and examples/tools/blind_audit.py (no access to the answer key or the network)."""
import json
import re

from helpers import KIT, PY, KitTestCase, Project, result, run

TOOLS = KIT / "examples" / "tools"


class Sanitize(KitTestCase):
    def test_paths_and_user_are_replaced(self):
        pr = Project(self.tmp, results=[result("L01")])
        pr.write("verification/audits/L01_gate.md", f"read {pr.root}/source/main.tex as alice\nSTATEMENT GATE: PASS\n")
        p = run([PY, str(TOOLS / "sanitize.py"), str(pr.root), str(self.tmp / "out"), "--user", "alice"], cwd=self.tmp)
        self.assertEqual(p.returncode, 0, p.out)
        text = (self.tmp / "out/verification/audits/L01_gate.md").read_text()
        self.assertEqual(text, "read <project>/source/main.tex as <user>\nSTATEMENT GATE: PASS\n")
        self.assertTrue((self.tmp / "out/verification/RESULTS.json").exists())

    def test_email_addresses_stop_the_copy(self):
        pr = Project(self.tmp, results=[result("L01")])
        pr.write("verification/RESUME.md", "x\n")
        pr.write("verification/audits/L01_gate.md", "contact someone@example.org\n")
        p = run([PY, str(TOOLS / "sanitize.py"), str(pr.root), str(self.tmp / "out")], cwd=self.tmp)
        self.assertEqual(p.returncode, 1)
        self.assertIn("someone@example.org", p.out)
        self.assertFalse((self.tmp / "out").exists(), "nothing is written when an address remains")


class BlindAudit(KitTestCase):
    def transcript(self, pr, tool_inputs):
        d = self.tmp / "home" / "projects" / re.sub(r"[^A-Za-z0-9]", "-", str(pr.root))
        d.mkdir(parents=True)
        lines = [{"message": {"content": [{"type": "tool_use", "id": f"t{i}", "name": n, "input": inp}]}}
                 for i, (n, inp) in enumerate(tool_inputs)]
        (d / "s1.jsonl").write_text("\n".join(json.dumps(l) for l in lines) + "\n")

    def audit(self, pr):
        return run([PY, str(TOOLS / "blind_audit.py"), str(pr.root), "--forbid", "/secret/keys", "--term", "ANSWER_KEY",
                    "--claude-dir", str(self.tmp / "home")], cwd=self.tmp)

    def test_clean_run(self):
        pr = Project(self.tmp)
        self.transcript(pr, [("Bash", {"command": "scripts/pv_lean.sh check L01"}), ("Read", {"file_path": "source/main.tex"})])
        p = self.audit(pr)
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("tool calls: 2", p.out)

    def test_answer_key_and_network_are_found(self):
        pr = Project(self.tmp)
        self.transcript(pr, [("Read", {"file_path": "/secret/keys/ANSWER_KEY.md"}), ("WebFetch", {"url": "https://x.org"}),
                             ("Bash", {"command": "curl https://x.org"})])
        p = self.audit(pr)
        self.assertEqual(p.returncode, 1)
        self.assertIn("3 tool calls touched", p.out)
