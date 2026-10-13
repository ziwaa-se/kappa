"""The PreToolUse guard hook (scripts/pv_guard.py): PENDING v1.3.1 #19 (the coordinator wrote a proof line),
#20 (a subagent wrote outside the project) and the write log used for #26."""
import json
import subprocess

from helpers import PY, KitTestCase, Project


class Guard(KitTestCase):
    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp)

    def call(self, tool, role="", env=None, **inp):
        d = {"tool_name": tool, "tool_input": inp, "cwd": str(self.pr.root), "session_id": "s1",
             "hook_event_name": "PreToolUse"}
        if role:
            d.update(agent_type=role, agent_id="a1")
        e = {"CLAUDE_PROJECT_DIR": str(self.pr.root), "PATH": "/usr/bin:/bin"}
        e.update(env or {})
        p = subprocess.run([PY, "scripts/pv_guard.py"], cwd=str(self.pr.root), input=json.dumps(d), env=e,
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        self.assertEqual(p.returncode, 0, p.stderr)
        return json.loads(p.stdout)["hookSpecificOutput"]["permissionDecisionReason"] if p.stdout.strip() else None

    def abs(self, rel):
        return str(self.pr.root / rel)

    def test_coordinator_may_not_write_lean_or_reports(self):
        self.assertIn("does not write proofs", self.call("Edit", file_path=self.abs("pv_work/C314.lean")))
        self.assertIn("review reports", self.call("Write", file_path=self.abs("verification/audits/L01_final.md")))
        self.assertIsNone(self.call("Write", file_path=self.abs("verification/RESUME.md")))
        self.assertIsNone(self.call("Write", file_path=self.abs("pv_work/notes/x.md")))

    def test_writers_and_reviewers(self):
        self.assertIsNone(self.call("Write", role="pv-prover", file_path=self.abs("pv_work/L01.lean")))
        self.assertIsNone(self.call("Write", role="pv-drafter", file_path=self.abs("pv_work/L01Stmt.lean")))
        self.assertIsNone(self.call("Write", role="pv-issue-checker", file_path=self.abs("pv_work/L01_Counterexample1.lean")))
        self.assertIn("never modifies", self.call("Edit", role="pv-auditor", file_path=self.abs("pv_work/L01.lean")))
        self.assertIsNone(self.call("Write", role="pv-auditor",
                                    file_path=self.abs("pv_work/probes/auditor/L01/auditor_L01_walk.lean")))
        self.assertIn("never modifies", self.call("Write", role="pv-gate",
                                                  file_path=self.abs("pv_work/probes/auditor/L01/x.lean")))
        self.assertIsNone(self.call("Write", role="pv-gate", file_path=self.abs("verification/audits/L01_gate.md")))

    def test_nobody_writes_outside_the_project(self):
        parent = str(self.pr.root.parent / "pv_work/notes/C01.md")      # the path slip seen in a real run
        self.assertIn("outside the project", self.call("Write", role="pv-prover", file_path=parent))
        self.assertIn("outside the project", self.call("Write", file_path="/tmp/x.md"))
        self.assertIn("outside the project",
                      self.call("Bash", role="pv-auditor", command="python3 scripts/pv_audit_mech.py T38 > /tmp/T38.txt"))
        self.assertIn("outside the project", self.call("Bash", role="pv-prover", command="echo x | tee ../notes.md"))
        self.assertIsNone(self.call("Bash", role="pv-auditor", command="scripts/pv_lean.sh check L01 2>/dev/null"))

    def test_bash_redirect_into_a_proof_by_the_coordinator(self):
        self.assertIn("does not write proofs", self.call("Bash", command="cat x > pv_work/L01.lean"))

    def test_log_names_the_role_of_kit_script_calls(self):
        self.call("Bash", role="pv-auditor", command="python3 scripts/pv_audit_mech.py L01")
        self.call("Write", role="pv-prover", file_path=self.abs("pv_work/L01.lean"))
        recs = [json.loads(l) for l in self.pr.read("pv_work/logs/writes.jsonl").splitlines()]
        self.assertEqual((recs[0]["role"], recs[0]["script"]), ("pv-auditor", "pv_audit_mech.py"))
        self.assertEqual((recs[1]["role"], recs[1]["path"]), ("pv-prover", "pv_work/L01.lean"))

    def test_warn_and_off_modes(self):
        self.assertIsNone(self.call("Edit", file_path=self.abs("pv_work/L01.lean"), env={"PV_GUARD": "warn"}))
        self.assertIn("warn", self.pr.read("pv_work/logs/writes.jsonl"))
        self.assertIsNone(self.call("Edit", file_path=self.abs("pv_work/L01.lean"), env={"PV_GUARD": "off"}))

    def test_a_broken_input_never_blocks(self):
        p = subprocess.run([PY, "scripts/pv_guard.py"], cwd=str(self.pr.root), input="not json",
                           env={"CLAUDE_PROJECT_DIR": str(self.pr.root)}, stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, universal_newlines=True)
        self.assertEqual((p.returncode, p.stdout), (0, ""))
        self.assertIn("JSONDecodeError", self.pr.read("pv_work/logs/guard_errors.log"))
