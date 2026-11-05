"""Integration tests with a real Lean + Mathlib environment (kit pins). They run only when PV_TEST_LEAN_ENV names a
ready shared environment (autosetup/lean_env.sh), e.g.

    PV_TEST_LEAN_ENV=~/proofcheck/lean-env python3 -m unittest test_lean_integration

They compile small files, so they take a few minutes. They cover the mechanical audit (pv_audit_mech.py), including
the conditions traced from the gated theorems (PENDING v1.3.1 #16, #24) and the writer checks (#19, #26), and (v1.5)
the walk past compiler auxiliaries, the snapshot block of a gate report and the package check; (v1.5.2) which gate report
counts, and helper limits."""
import json
import os
import re
import unittest
from pathlib import Path

from helpers import KIT, PY, KitTestCase, Project, result, run, tool

LEAN_ENV = os.environ.get("PV_TEST_LEAN_ENV", "")

STMT = """import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace Paper.P01

/-- An external input that the proof uses. -/
def Tool : Prop := ∀ x : ℝ, 0 ≤ x ^ 2

/-- An external input that the statement takes but the proof never uses. -/
def Unused : Prop := True

def P01Conclusion : Prop := ∀ x : ℝ, 0 ≤ x ^ 2 + 1

end Paper.P01
"""

PROOF = """import P01Stmt

namespace Paper.P01

theorem P01_main (hT : Tool) (hU : Unused) : P01Conclusion := by
  intro x
  have := hT x
  linarith

end Paper.P01
"""


@unittest.skipUnless(LEAN_ENV and Path(LEAN_ENV, ".lake/packages/mathlib").is_dir(), "set PV_TEST_LEAN_ENV")
class MechanicalAudit(KitTestCase):
    def setUp(self):
        super().setUp()
        root = self.tmp / "proj"
        p = run([str(KIT / "install.sh"), str(root), "--lean-from", os.path.expanduser(LEAN_ENV), "--link-packages"],
                cwd=self.tmp, timeout=1800)
        self.assertEqual(p.returncode, 0, p.out)
        self.pr = Project.__new__(Project)
        self.pr.root = root
        d = self.pr.state()
        d["paper"]["title"] = "Lean test"
        d["defs"] = [{"id": "NONE"}]
        d["results"] = [result("P01")]
        d["external_tools"] = [tool("P01_Tool", lean="pv_work/P01Stmt.lean:7 Paper.P01.Tool", consumers=["P01 (S1)"]),
                               tool("P01_Unused", lean="pv_work/P01Stmt.lean:10 Paper.P01.Unused", consumers=["P01"]),
                               tool("P01_Ghost", lean="pv_work/P01Stmt.lean:99 Paper.P01.Ghost", consumers=["P01"])]
        d["lean"]["pvtools_sha256"] = __import__("hashlib").sha256((root / "pv_work/PVTools.lean").read_bytes()).hexdigest()
        self.pr.write_state(d)
        self.pr.write("pv_work/P01Stmt.lean", STMT)
        self.pr.write("pv_work/P01.lean", PROOF)
        for m in ("P01Stmt", "P01"):
            b = self.pr.script("pv_lean.sh", "build", m)
            self.assertEqual(b.returncode, 0, b.out)
        # the gate snapshot: fingerprints of the statement file and of the proved theorem
        self.pr.write("pv_work/probes/gate/P01/gate_P01_snap.lean",
                      "import P01\nimport PVTools\n#pv_type_hashes P01Stmt\n#pv_type_hashes P01\n")
        s = self.pr.script("pv_lean.sh", "probe", "pv_work/probes/gate/P01/gate_P01_snap.lean")
        log = self.pr.read(re.search(r"log=(\S+)", s.out).group(1))
        fps = [l.strip() for l in log.splitlines() if re.search(r"\|(thm|def)\|th=", l)]
        self.assertTrue(fps, log)
        self.pr.write("verification/audits/P01_gate.md", "# Gate P01\n\n```\n" + "\n".join(fps) + "\n```\n\nSTATEMENT GATE: PASS\n")

    def log_writes(self, *recs):
        self.pr.write("pv_work/logs/writes.jsonl", "".join(json.dumps(r) + "\n" for r in recs))

    def test_conditions_are_traced_from_the_gated_theorem(self):
        self.log_writes({"role": "pv-prover", "agent_id": "abc12345", "path": "pv_work/P01.lean", "time": "t1"},
                        {"role": "pv-drafter", "agent_id": "def12345", "path": "pv_work/P01Stmt.lean", "time": "t0"},
                        {"role": "pv-auditor", "agent_id": "aud12345", "session": "sess1234", "script": "pv_audit_mech.py",
                         "command": "python3 scripts/pv_audit_mech.py P01", "time": "t2"})
        p = self.pr.script("pv_audit_mech.py", "P01")
        rep = self.pr.read("verification/audits/P01_mech.md")
        self.assertEqual(p.returncode, 0, p.out + rep)
        self.assertIn("TRACED CONDITIONS: P01_Tool", rep)
        self.assertIn("formal only (UNUSED hypotheses): P01_Unused", rep)
        self.assertIn("registered for this result but not reached: P01_Ghost", rep)
        self.assertIn("Run by: pv-auditor (agent aud12345", rep)
        self.assertRegex(rep, r"\| 12 \| last writer of `pv_work/P01.lean` \| PASS \| pv-prover")
        self.assertTrue(rep.rstrip().endswith("MECH CHECKS: PASS (2 manual checks listed above)"), rep[-400:])

    def mech_rows(self):
        reps = sorted((self.pr.root / "verification/audits").glob("P01_mech*.md"), key=lambda f: f.stat().st_mtime)
        rep = reps[-1].read_text()
        return {int(m.group(1)): m.group(2) for m in re.finditer(r"^\| (\d+) \| [^|]+ \| ([A-Z ]+) \|", rep, flags=re.M)}, rep

    def test_compiler_auxiliaries_and_quoted_gap_lines_do_not_fail(self):     # v1.5
        # a computable private def with a proof inside: its compiler auxiliary `_cstage1` refers to lcProof
        self.pr.write("pv_work/P01.lean", PROOF.replace("theorem P01_main",
                      "private def firstIdx (n : Nat) : Fin (n + 1) := ⟨0, by omega⟩\n\n"
                      "theorem idx_ok : (firstIdx 1).val = 0 := rfl\n\ntheorem P01_main"))
        b = self.pr.script("pv_lean.sh", "build", "P01")
        self.assertEqual(b.returncode, 0, b.out)
        gate = self.pr.read("verification/audits/P01_gate.md").replace("```\n", "<!-- PV SNAPSHOT BEGIN -->\n```\n", 1)
        gate = gate.replace("\n```\n\nSTATEMENT GATE", "\n```\n<!-- PV SNAPSHOT END -->\n\nA gap file had "
                            "`Paper.P01.P01_S1_Gap|def|th=1|vh=2|bi=`; the step is proved now.\n\nSTATEMENT GATE")
        self.pr.write("verification/audits/P01_gate.md", gate)
        p = self.pr.script("pv_audit_mech.py", "P01")
        rows, rep = self.mech_rows()
        self.assertEqual(p.returncode, 0, p.out + rep)
        self.assertEqual((rows[4], rows[6], rows[7], rows[13]), ("PASS", "PASS", "PASS", "PASS"), rep)
        self.assertIn("lcProof is reached only from internal names", rep)
        # a real axiom in the module still fails, also when walked declaration by declaration
        self.pr.write("pv_work/P01.lean", PROOF.replace("theorem P01_main",
                      "axiom extra : (1 : Nat) = 1\n\ntheorem uses : (1 : Nat) = 1 := extra\n\ntheorem P01_main"))
        self.assertEqual(self.pr.script("pv_lean.sh", "build", "P01").returncode, 0)
        p = self.pr.script("pv_audit_mech.py", "P01")
        rows, rep = self.mech_rows()
        self.assertEqual(p.returncode, 1, rep)
        self.assertEqual((rows[6], rows[7]), ("FAIL", "FAIL"), rep)
        self.assertIn("`Paper.P01.uses` ['Paper.P01.extra']", rep)

    def test_preflight_and_stopping_entries(self):                            # v1.5.1
        p = self.pr.script("pv_lean.sh", "preflight")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("PREFLIGHT OK", p.out)
        for name, stop, code in (("mod", "P01Stmt", 0), ("decl", "Paper.P01.Tool", 7)):
            f = f"pv_work/probes/auditor/P01/auditor_P01_{name}.lean"
            self.pr.write(f, f"import P01\nimport PVTools\n#pv_walk_decl Paper.P01.P01_main stopping {stop}\n")
            p = self.pr.script("pv_lean.sh", "probe", f)
            self.assertEqual(p.returncode, code, p.out)
            self.assertEqual("STOPPING ERROR" in p.out, code == 7, p.out)
        self.assertIn("Paper.P01.Tool is not a module", p.out)

    def test_offline_replay_confirms_a_recorded_verdict(self):
        self.log_writes({"role": "pv-prover", "agent_id": "abc12345", "path": "pv_work/P01.lean", "time": "t1"})
        self.assertEqual(self.pr.script("pv_audit_mech.py", "P01").returncode, 0)
        self.pr.write("verification/audits/P01_final.md",
                      "x\nFINAL AUDIT: PASS\nSUGGESTED VERDICT: CONDITIONAL\nCONDITIONS: P01_Tool\n")
        p = self.pr.status("record", "P01", "--verdict", "CONDITIONAL", "--stage", "FINAL_PASSED", "--statement-fixed",
                           "true", "--lean-main", "pv_work/P01.lean:5 Paper.P01.P01_main")
        self.assertEqual(p.returncode, 0, p.out)
        p = run([PY, str(KIT / "examples/tools/replay.py"), str(self.pr.root), "--lean-env", os.path.expanduser(LEAN_ENV),
                 "--work", str(self.tmp / "replay-work")], cwd=self.tmp, timeout=1800)
        self.assertEqual(p.returncode, 0, p.out)
        self.assertRegex(p.out, r"\| P01 \| CONDITIONAL \| P01 \| built \| PASS .*\| yes \|")

    def test_a_proof_written_by_the_coordinator_fails(self):
        self.log_writes({"role": "coordinator", "agent_id": "", "path": "pv_work/P01.lean", "time": "t1"})
        p = self.pr.script("pv_audit_mech.py", "P01")
        rep = self.pr.read("verification/audits/P01_mech.md")
        self.assertEqual(p.returncode, 1, rep)
        self.assertIn("MECH CHECKS: FAIL (writer)", rep)
        self.assertIn("Run by: not recorded", rep)

    # v1.5.2: which gate report counts
    def gate_files(self):
        """The fingerprints of the file as it is, and the same with another main theorem (a later statement)."""
        good = re.search(r"```\n(.*?)\n```", self.pr.read("verification/audits/P01_gate.md"), flags=re.S).group(1)
        other = re.sub(r"(P01_main\|thm\|th=)\d+", r"\g<1>12345", good)
        self.assertNotEqual(good, other)
        (self.pr.root / "verification/audits/P01_gate.md").unlink()
        return good, other

    @staticmethod
    def report(fps):
        return f"# Gate P01\n\n<!-- PV SNAPSHOT BEGIN -->\n```\n{fps}\n```\n<!-- PV SNAPSHOT END -->\n\nSTATEMENT GATE: PASS\n"

    def later(self, rel, text):
        f = self.pr.write(rel, text)
        t = f.stat().st_mtime + 60
        os.utime(str(f), (t, t))

    def row4(self):
        reps = sorted((self.pr.root / "verification/audits").glob("P01_mech*.md"), key=lambda f: f.stat().st_mtime)
        text = reps[-1].read_text()
        return next(l for l in text.splitlines() if l.startswith("| 4 |")), text

    def test_a_newer_gate_under_another_name_is_not_passed_over(self):
        good, other = self.gate_files()
        # the Lean file matches the older report: without the rule this was a clean PASS against a superseded snapshot
        self.pr.write("verification/audits/P01_gate_r3.md", self.report(good))
        self.later("verification/audits/P01_gate_rev5_r2.md", self.report(other))
        p = self.pr.script("pv_audit_mech.py", "P01")
        row, text = self.row4()
        self.assertEqual(p.returncode, 1, text)
        self.assertIn("MECH CHECKS: FAIL (statement)", text)
        self.assertIn("P01_gate_rev5_r2.md is newer than verification/audits/P01_gate_r3.md", row)
        # given by name it decides, and the report says that it is not the latest under the rule
        p = self.pr.script("pv_audit_mech.py", "P01", "--gate", "verification/audits/P01_gate_r3.md")
        row, text = self.row4()
        self.assertEqual(p.returncode, 0, text)
        self.assertIn("vs `verification/audits/P01_gate_r3.md`", row)
        self.assertIn("`--gate verification/audits/P01_gate_r3.md` was given, but", text)

    def test_a_gate_with_its_snapshot_after_the_verdict_is_used(self):
        good, other = self.gate_files()
        self.pr.write("verification/audits/P01_gate.md", self.report(good))
        tail = "# Gate\n\nSTATEMENT GATE: PASS\n\n<!-- PV SNAPSHOT BEGIN -->\n```\n" + other + "\n```\n<!-- PV SNAPSHOT END -->\nEXIT=0\n"
        self.pr.write("verification/audits/P01_gate_r2.md", tail)
        p = self.pr.script("pv_audit_mech.py", "P01")
        row, text = self.row4()
        self.assertEqual(p.returncode, 1, text)        # it is compared, and it differs; r1 does not stand in
        self.assertIn("vs `verification/audits/P01_gate_r2.md`", row)
        self.assertIn("changed", row)

    def test_a_helper_overrun_is_a_manual_item(self):
        helper = "private theorem padded : True := by\n" + "".join(f"  have h{i} : True := trivial\n" for i in range(18)) + "  trivial\n\n"
        proof = PROOF.replace("namespace Paper.P01\n\n", "namespace Paper.P01\n\n" + helper, 1).replace("  intro x\n", "  have := padded\n  intro x\n")
        self.pr.write("pv_work/P01.lean", proof)
        b = self.pr.script("pv_lean.sh", "build", "P01")
        self.assertEqual(b.returncode, 0, b.out)
        gate = self.pr.read("verification/audits/P01_gate.md")
        self.pr.write("verification/audits/P01_gate.md", gate.replace("STATEMENT GATE: PASS", "HELPER LIMIT: main 10\n\nSTATEMENT GATE: PASS"))
        self.assertEqual(self.pr.status("helper-lines", "P01").returncode, 1)
        p = self.pr.script("pv_audit_mech.py", "P01")
        rep = self.pr.read("verification/audits/P01_mech.md")
        self.assertEqual(p.returncode, 0, rep)         # a manual item, not a FAIL
        self.assertRegex(rep, r"\| 9 \| helper limits \| MANUAL \| `main`: 20 of 10 \|")
        self.assertIn("`main`: 20 helper lines, over the limit of 10 set in `verification/audits/P01_gate.md`", rep)
        self.assertRegex(rep, r"MECH CHECKS: PASS \(\d+ manual checks listed above\)")

    def test_the_record_of_a_module_follows_the_same_rule(self):
        self.pr.write("pv_work/P02.lean", "import P01\n\nnamespace Paper.P02\n\ntheorem P02_main (hT : Paper.P01.Tool) "
                      "(hU : Paper.P01.Unused) : Paper.P01.P01Conclusion :=\n  Paper.P01.P01_main hT hU\n\nend Paper.P02\n")
        b = self.pr.script("pv_lean.sh", "build", "P02")
        self.assertEqual(b.returncode, 0, b.out)
        d = self.pr.state()
        d["results"].append(result("P02", depends_on=["P01"]))
        self.pr.write_state(d)
        self.pr.write("verification/audits/P01_final.md", "FINAL AUDIT: PASS\n")
        self.pr.script("pv_audit_mech.py", "P02", "--skip-statement")
        rep = self.pr.read("verification/audits/P02_mech.md")
        self.assertRegex(rep, r"\| `P01` \| \d+ \| `verification/audits/P01_final.md` \|")
        self.later("verification/audits/P01_final_rev5.md", "FINAL AUDIT: PASS\n")
        self.pr.script("pv_audit_mech.py", "P02", "--skip-statement")
        rep = self.pr.read("verification/audits/P02_mech_r2.md")
        self.assertRegex(rep, r"\| `P01` \| \d+ \| \*\*NO RECORD")
        self.assertIn("module `P01` reached without an audit record (verification/audits/P01_final_rev5.md is newer", rep)


if __name__ == "__main__":
    unittest.main()
