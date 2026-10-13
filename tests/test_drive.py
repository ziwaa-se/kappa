"""The unattended driver (scripts/pv_drive.sh) and its decisions (scripts/pv_drive_status.py), end to end against a
scripted stand-in for `claude`. Covers PENDING v1.3.1 #1 (auto-resume), #3 (exit status), #4 (reconnection counts as
progress), #5 (report mode), #2 (refused kit commands) and #12 (per-result session budget)."""
import importlib.util
import json
import unittest
from datetime import datetime
from pathlib import Path

from helpers import KIT, FakeClaude, KitTestCase, Project, result, run, tool

spec = importlib.util.spec_from_file_location("pv_drive_status", str(KIT / "template/scripts/pv_drive_status.py"))
ds = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ds)

LIMIT = "You've hit your session limit · resets 3:45pm"


def passes(rid, verdict="UNCONDITIONAL", conditions=""):
    """A scenario step in which a session brings rid to a verified verdict."""
    cmd = (f"python3 scripts/pv_status.py record {rid} --verdict {verdict} --stage FINAL_PASSED --statement-fixed true "
           f"--lean-main 'pv_work/{rid}.lean:1 Paper.{rid}.main'")
    if conditions:
        cmd += f" --conditions {conditions}"
    return {"files": {f"verification/audits/{rid}_gate.md": "STATEMENT GATE: PASS\n",
                      f"verification/audits/{rid}_final.md": f"SUGGESTED VERDICT: {verdict}\nFINAL AUDIT: PASS\n",
                      f"pv_work/{rid}.lean": "theorem main : True := trivial\n"},
            "run": [cmd], "result": f"{rid} verified"}


class ResetTimes(unittest.TestCase):
    NOW = datetime(2026, 10, 12, 14, 0)

    def test_pm_time_today(self):
        w, at = ds.reset_wait(LIMIT, now=self.NOW)
        self.assertEqual(w, (1 * 3600 + 45 * 60) + 300)
        self.assertTrue(at.startswith("2026-10-12 15:45"))

    def test_am_time_is_tomorrow(self):
        w, _ = ds.reset_wait("limit · resets 2:50am", now=self.NOW)
        self.assertEqual(w, (12 * 3600 + 50 * 60) + 300)

    def test_date_and_hour(self):
        w, at = ds.reset_wait("weekly limit · resets Oct 14, 9am", now=self.NOW)
        self.assertEqual(w, (43 * 3600) + 300)
        self.assertTrue(at.startswith("2026-10-14 09:00"))

    def test_unreadable_time_falls_back(self):
        self.assertEqual(ds.reset_wait("limit reached, try later", now=self.NOW), (1800, ""))
        self.assertEqual(ds.reset_wait("resets 13:99pm", now=self.NOW)[0], 1800)

    def test_named_zone(self):
        try:
            from zoneinfo import ZoneInfo
        except ImportError:
            self.skipTest("zoneinfo needs Python 3.9")
        now = datetime(2026, 10, 12, 1, 0, tzinfo=ZoneInfo("America/Indianapolis"))
        w, _ = ds.reset_wait("resets 2:50am (America/Indianapolis)", now=now)
        self.assertEqual(w, 110 * 60 + 300)


class Classify(KitTestCase):
    def session(self, d, err=""):
        j = self.tmp / "s.json"
        j.write_text(d if isinstance(d, str) else json.dumps(d))
        e = self.tmp / "s.err"
        e.write_text(err)
        return ds.classify(str(j), str(e))[0]

    def test_kinds(self):
        self.assertEqual(self.session({"is_error": True, "result": LIMIT}), "usage_limit")
        self.assertEqual(self.session({"is_error": True, "result": "API error 500"}), "error")
        self.assertEqual(self.session({"is_error": True, "subtype": "error_max_budget_usd"}), "budget")
        self.assertEqual(self.session("", err=LIMIT), "usage_limit")
        self.assertEqual(self.session("", err="Traceback"), "no_json")

    def test_normal_session_mentioning_a_limit_is_not_a_limit(self):
        # the first auto-resume script took this summary for a usage limit
        self.assertEqual(self.session({"is_error": False, "result": "Done. Note: stay under the usage limit next time."}),
                         "ok")

    def test_agents_that_hit_the_limit(self):
        self.assertEqual(self.session({"is_error": False, "result": "The prover agent terminated early due to a "
                                                                   "usage limit; resume later."}), "limit_in_agents")


class Driver(KitTestCase):
    def drive(self, project, steps, *args, **env):
        fc = FakeClaude(self.tmp, steps)
        e = fc.env(PV_CAFFEINATE="0", PV_SLEEP_CMD="echo SLEPT", **env)
        p = run(["scripts/pv_drive.sh"] + list(args), cwd=project.root, env=e)
        status = json.loads(project.read("pv_work/logs/drive_status.json"))
        return p, status, fc

    def last_line(self, p):
        return p.out.strip().splitlines()[-1]

    def test_done_is_the_last_line_and_the_status(self):          # PENDING #3
        pr = Project(self.tmp, results=[result("L01")])
        p, st, fc = self.drive(pr, [passes("L01")])
        self.assertEqual(p.returncode, 0, p.out)
        self.assertTrue(self.last_line(p).startswith("DRIVER STOPPED: done"), p.out)
        self.assertEqual(st["reason"], "done")
        self.assertEqual(len(fc.calls()), 1)

    def test_usage_limit_without_auto_resume_stops_with_code_3(self):    # PENDING #1
        pr = Project(self.tmp, results=[result("L01")])
        p, st, _ = self.drive(pr, [{"is_error": True, "result": LIMIT}])
        self.assertEqual(p.returncode, 3, p.out)
        self.assertEqual(st["reason"], "usage_limit")
        self.assertTrue(st["reset_at"].endswith("15:45"), st)

    def test_auto_resume_sleeps_until_the_reset_and_continues(self):     # PENDING #1
        pr = Project(self.tmp, results=[result("L01"), result("L02")])
        steps = [{"is_error": True, "result": LIMIT}, passes("L01"), {"is_error": True, "result": "limit reached"},
                 passes("L02")]
        p, st, fc = self.drive(pr, steps, "--auto-resume", PV_BATCH="1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(st["reason"], "done")
        self.assertEqual(st["restarts"], 2)
        slept = [l for l in p.out.splitlines() if l.startswith("SLEPT")]
        self.assertEqual(len(slept), 2, p.out)
        self.assertEqual(slept[1], "SLEPT 1800")          # no reset time in the message: 30 minutes
        self.assertEqual(len(fc.calls()), 4)
        self.assertEqual(pr.result("L02")["verdict"], "UNCONDITIONAL")

    def test_limit_waits_do_not_use_up_max_sessions(self):
        pr = Project(self.tmp, results=[result("L01")])
        steps = [{"is_error": True, "result": LIMIT}] * 3 + [passes("L01")]
        p, st, _ = self.drive(pr, steps, "--auto-resume", "--max-sessions", "1")
        self.assertEqual(st["reason"], "done", p.out)

    def test_too_many_limit_waits(self):
        pr = Project(self.tmp, results=[result("L01")])
        p, st, _ = self.drive(pr, [{"is_error": True, "result": LIMIT}] * 3, "--auto-resume", PV_MAX_RESTARTS="2")
        self.assertEqual(p.returncode, 9, p.out)
        self.assertEqual(st["reason"], "max_restarts")

    def test_reconnection_only_session_is_progress(self):                # PENDING #4
        pr = Project(self.tmp, results=[result("L01"), result("L02", depends_on=["L01"])],
                     tools=[tool("T1"), tool("L02_L01Consumed", "p", predecessor="L01")])
        pr.make_passed("L01")
        pr.make_passed("L02", verdict="CONDITIONAL", conditions=["T1", "L02_L01Consumed"])
        recon = {"files": {"verification/audits/L02_reconnect_r1.md": "RECONNECT AUDIT: PASS\n",
                           "pv_work/L02Closed_r1.lean": "theorem main : True := trivial\n"},
                 "run": ["python3 scripts/pv_status.py record L02 --verdict CONDITIONAL --stage FINAL_PASSED "
                         "--conditions T1 --evidence-reconnect verification/audits/L02_reconnect_r1.md "
                         "--lean-main 'pv_work/L02Closed_r1.lean:1 Paper.L02.main'"]}
        p, st, fc = self.drive(pr, [recon])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertIn("reconnections", fc.prompts()[0])

    def test_status_names_the_running_session(self):
        pr = Project(self.tmp, results=[result("L01")])
        step = passes("L01")
        step["run"].insert(0, "cp pv_work/logs/drive_status.json pv_work/logs/status_during.json")
        self.drive(pr, [step])
        during = json.loads(pr.read("pv_work/logs/status_during.json"))
        self.assertEqual((during["reason"], during["session"], during["message"]), ("running", 1, "session 1 started"))

    def test_no_progress_stops_with_code_4(self):
        pr = Project(self.tmp, results=[result("L01")])
        p, st, _ = self.drive(pr, [{"result": "I looked around"}])
        self.assertEqual(p.returncode, 4, p.out)
        self.assertEqual(st["reason"], "no_progress")

    def test_report_mode_archives_the_old_report(self):                  # PENDING #5
        pr = Project(self.tmp, results=[result("L01")])
        pr.write("verification/report/AUTHOR_REPORT.md", "old report\n")
        pr.write("verification/report/work/factcheck.md", "old factcheck\n")
        report = {"files": {"verification/report/AUTHOR_REPORT.md": "new report\n",
                            "verification/report/work/factcheck.md": "new factcheck\n"}}
        p, st, fc = self.drive(pr, [passes("L01"), report], "--report")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(st["reason"], "done_report")
        self.assertIn("pv-report/SKILL.md", fc.prompts()[1])
        archived = list((pr.root / "verification/report_archive").glob("*/AUTHOR_REPORT.md"))
        self.assertEqual([a.read_text() for a in archived], ["old report\n"])
        self.assertEqual(pr.read("verification/report/AUTHOR_REPORT.md"), "new report\n")

    def test_report_incomplete(self):
        pr = Project(self.tmp, results=[result("L01")])
        p, st, _ = self.drive(pr, [passes("L01"), {"result": "could not finish"}], "--report")
        self.assertEqual(p.returncode, 8, p.out)
        self.assertEqual(st["reason"], "report_incomplete")

    def test_refused_kit_commands_stop_the_driver(self):                 # PENDING #2
        pr = Project(self.tmp, results=[result("L01")])
        claude_dir = self.tmp / "claude-home"
        sub = claude_dir / "projects" / ds.encode(pr.root) / "fake-session-1" / "subagents"
        sub.mkdir(parents=True)
        lines = [{"message": {"content": [{"type": "tool_use", "id": "t1", "name": "Bash",
                                           "input": {"command": "scripts/pv_lean.sh check L01Stmt"}}]}},
                 {"message": {"content": [{"type": "tool_result", "tool_use_id": "t1",
                                           "content": "Permission to use Bash has been denied."}]}}]
        (sub / "agent-a1.jsonl").write_text("\n".join(json.dumps(l) for l in lines) + "\n")
        p, st, _ = self.drive(pr, [passes("L01")], PV_CLAUDE_DIR=str(claude_dir))
        self.assertEqual(p.returncode, 7, p.out)
        self.assertEqual(st["reason"], "permissions")

    def test_other_denials_are_only_counted(self):
        pr = Project(self.tmp, results=[result("L01")])
        claude_dir = self.tmp / "claude-home"
        d = claude_dir / "projects" / ds.encode(pr.root)
        d.mkdir(parents=True)
        lines = [{"message": {"content": [{"type": "tool_use", "id": "t1", "name": "Bash",
                                           "input": {"command": "curl https://example.org"}}]}},
                 {"message": {"content": [{"type": "tool_result", "tool_use_id": "t1",
                                           "content": "Permission to use Bash has been denied."}]}}]
        (d / "fake-session-1.jsonl").write_text("\n".join(json.dumps(l) for l in lines) + "\n")
        p, st, _ = self.drive(pr, [passes("L01")], PV_CLAUDE_DIR=str(claude_dir))
        self.assertEqual(st["reason"], "done", p.out)
        self.assertIn("permission denials in session 1: 1", p.out)

    def test_result_budget_raises_the_session_cap(self):                 # PENDING #12
        pr = Project(self.tmp, results=[result("L01", session_budget_usd=75)])
        p, st, fc = self.drive(pr, [passes("L01")])
        argv = fc.calls()[0]["argv"]
        self.assertEqual(argv[argv.index("--max-budget-usd") + 1], "75", p.out)

    def test_the_driver_is_read_completely_before_it_runs(self):         # PENDING #18.1
        text = (KIT / "template/scripts/pv_drive.sh").read_text().rstrip().splitlines()
        self.assertEqual(text[-1], 'main "$@"; exit $?')


if __name__ == "__main__":
    unittest.main()
