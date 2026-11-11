"""The unattended driver (scripts/pv_drive.sh) and its decisions (scripts/pv_drive_status.py), end to end against a
scripted stand-in for `claude`. Covers PENDING v1.3.1 #1 (auto-resume), #3 (exit status), #4 (reconnection counts as
progress), #5 (report mode), #2 (refused kit commands) and #12 (per-result session budget); v1.5.1: a review without
a shell; v1.5.2: the session cap, a new pass after a reset, a failed attempt to prove an input; v1.6: the discharge
stage."""
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
NO_SHELL = "Nothing could run.\n\nFINAL AUDIT: NOT RUN (no shell: scripts/pv_lean.sh preflight)\n"


def passes(rid, verdict="UNCONDITIONAL", conditions=""):
    """A scenario step in which a session brings rid to a verified verdict."""
    cmd = (f"python3 scripts/pv_status.py record {rid} --verdict {verdict} --stage FINAL_PASSED --statement-fixed true "
           f"--lean-main 'pv_work/{rid}.lean:1 Paper.{rid}.main'")
    if conditions:
        cmd += f" --conditions {conditions}"
    tried = "".join(f"REFUTATION: {c} NOT REFUTED — tried: test\n" for c in conditions.split(",") if c)
    return {"files": {f"verification/audits/{rid}_gate.md": tried + "STATEMENT GATE: PASS\n",
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
        try:
            zone = ZoneInfo("America/Indianapolis")
        except Exception:
            self.skipTest("no time zone data on this machine")
        now = datetime(2026, 10, 12, 1, 0, tzinfo=zone)
        w, _ = ds.reset_wait("resets 2:50am (America/Indianapolis)", now=now)
        self.assertEqual(w, 110 * 60 + 300)

    def test_a_zone_that_cannot_be_read_falls_back(self):
        self.assertEqual(ds.reset_wait("resets 2:50am (Nowhere/Atlantis)", now=self.NOW), (1800, ""))


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

    def test_infrastructure_stop_goes_to_the_gate(self):                 # v1.5
        pr = Project(self.tmp, results=[result("P1", stage="STOPPED", reason="INFRASTRUCTURE_RULING",
                                                partial="S4 needs about 200 helper lines")])
        ruling = {"files": {"verification/audits/P1_infra_r1.md": "route is technical\n\nINFRASTRUCTURE RULING: EXTEND 250\n"},
                  "run": ["python3 scripts/pv_status.py record P1 --stage PROVING --reason ''"]}
        p, st, fc = self.drive(pr, [ruling, passes("P1")])
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(st["reason"], "done")
        self.assertIn("scope: P1", fc.prompts()[0])
        self.assertIn("a RULING row still needs the gate's infrastructure ruling", fc.prompts()[0])
        self.assertEqual(pr.result("P1")["verdict"], "UNCONDITIONAL")

    def test_report_mode_archives_the_old_report(self):                  # PENDING #5
        pr = Project(self.tmp, results=[result("L01")])
        pr.write("verification/report/AUTHOR_REPORT.md", "old report\n")
        pr.write("verification/report/work/factcheck.md", "old factcheck\n")
        pr.write("verification/report/VERIFICATION_GRAPH.html", "old graph\n")
        pr.write("verification/report/REPORT_STAMP.json", "{}\n")
        report = {"files": {"verification/report/AUTHOR_REPORT.md": "new report\n",
                            "verification/report/work/factcheck.md": "new factcheck\n",
                            **{f"verification/report/work/{n}": "compiled\n"
                               for n in ("consistency_check.md", "author_notes.md", "external_tools.md")}}}
        p, st, fc = self.drive(pr, [passes("L01"), report], "--report")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(st["reason"], "done_report")
        self.assertIn("pv-report/SKILL.md", fc.prompts()[1])
        archived = list((pr.root / "verification/report_archive").glob("*/AUTHOR_REPORT.md"))
        self.assertEqual([a.read_text() for a in archived], ["old report\n"])
        self.assertEqual(pr.read("verification/report/AUTHOR_REPORT.md"), "new report\n")
        graphs = list((pr.root / "verification/report_archive").glob("*/VERIFICATION_GRAPH.html"))
        self.assertEqual([g.read_text() for g in graphs], ["old graph\n"])
        self.assertIn("Verification graph", pr.read("verification/report/VERIFICATION_GRAPH.html"))   # v1.5
        self.assertIn("# Check summary", pr.read("verification/report/CHECK_SUMMARY.md"))
        self.assertEqual(len(list((pr.root / "verification/report_archive").glob("*/REPORT_STAMP.json"))), 1)
        self.assertIn("results_sha256", pr.read("verification/report/REPORT_STAMP.json"))

    def test_report_incomplete(self):
        pr = Project(self.tmp, results=[result("L01")])
        p, st, _ = self.drive(pr, [passes("L01"), {"result": "could not finish"}], "--report")
        self.assertEqual(p.returncode, 8, p.out)
        self.assertEqual(st["reason"], "report_incomplete")

    def test_report_waits_when_its_agents_hit_the_limit(self):           # v1.3.2
        pr = Project(self.tmp, results=[result("L01")])
        cut = {"result": "The compiler agent terminated early due to a usage limit; the report is not done."}
        report = {"files": {"verification/report/AUTHOR_REPORT.md": "report\n",
                            "verification/report/work/factcheck.md": "factcheck\n"}}
        p, st, fc = self.drive(pr, [passes("L01"), cut, report], "--report", "--auto-resume")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(st["reason"], "done_report")
        self.assertEqual(len([l for l in p.out.splitlines() if l.startswith("SLEPT")]), 1, p.out)
        self.assertEqual(len(fc.calls()), 3)

    def test_invalid_records_get_one_resume_session(self):               # v1.3.2
        pr = Project(self.tmp, results=[result("L01"), result("L02")])
        broken = dict(passes("L01"), set={"L02": {"verdict": "ISSUE", "stage": "STOPPED"}})   # ISSUE without evidence
        repair = {"set": {"L02": {"verdict": "UNFINISHED", "stage": "INVENTORIED"}}, "result": "reconciled",
                  "run": ["python3 scripts/pv_status.py init-checklist --force"]}
        p, st, fc = self.drive(pr, [broken, repair, passes("L02")], PV_BATCH="1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(st["reason"], "done")
        self.assertIn("pv-resume/SKILL.md", fc.prompts()[1])
        self.assertIn("one resume session reconciles the records", p.out)

    def test_records_still_invalid_after_the_resume_session_stop_the_driver(self):
        pr = Project(self.tmp, results=[result("L01"), result("L02")])
        broken = dict(passes("L01"), set={"L02": {"verdict": "ISSUE", "stage": "STOPPED"}})
        p, st, fc = self.drive(pr, [broken, {"result": "could not reconcile"}], PV_BATCH="1")
        self.assertEqual(p.returncode, 5, p.out)
        self.assertEqual(st["reason"], "validate_failed")
        self.assertEqual(len(fc.calls()), 2)

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

    def denied_auditor(self, pr, session=1):
        """A subagent transcript: the auditor's first command was refused."""
        claude_dir = self.tmp / "claude-home"
        sub = claude_dir / "projects" / ds.encode(pr.root) / f"fake-session-{session}" / "subagents"
        sub.mkdir(parents=True)
        lines = [{"message": {"content": [{"type": "tool_use", "id": "t1", "name": "Bash",
                                           "input": {"command": "scripts/pv_lean.sh preflight"}}]}},
                 {"message": {"content": [{"type": "tool_result", "tool_use_id": "t1",
                                           "content": "Permission to use Bash has been denied."}]}}]
        (sub / "agent-a1.jsonl").write_text("\n".join(json.dumps(l) for l in lines) + "\n")
        return claude_dir

    def clean_result(self):
        return Project(self.tmp, results=[result("L01", stage="PROVED", reason="AUDIT_PENDING", statement_fixed=True)])

    def test_an_auditor_without_a_shell_gets_one_fresh_session(self):      # v1.5.1
        pr = self.clean_result()
        claude_dir = self.denied_auditor(pr)
        ok = passes("L01")
        ok["files"]["verification/audits/L01_final_r2.md"] = ok["files"].pop("verification/audits/L01_final.md")
        p, st, fc = self.drive(pr, [{"files": {"verification/audits/L01_final.md": NO_SHELL}, "result": "no shell"}, ok],
                               PV_CLAUDE_DIR=str(claude_dir))
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(len(fc.calls()), 2)
        self.assertIn("one fresh session tries again", p.out)
        self.assertEqual(pr.result("L01")["verdict"], "UNCONDITIONAL")
        self.assertEqual(pr.result("L01")["evidence"]["final"], "verification/audits/L01_final_r2.md")

    def test_no_shell_twice_stops_with_the_permission_problem(self):       # v1.5.1
        pr = self.clean_result()
        give_up = "python3 scripts/pv_status.py record L01 --verdict UNFINISHED --stage STOPPED --reason AUDIT_FAILED"
        steps = [{"files": {"verification/audits/L01_final.md": NO_SHELL}, "run": [give_up]},
                 {"files": {"verification/audits/L01_final_r2.md": NO_SHELL}, "run": [give_up]},
                 {"result": "must not run"}]
        p, st, fc = self.drive(pr, steps)
        self.assertEqual(p.returncode, 7, p.out)
        self.assertEqual(st["reason"], "permissions")
        self.assertEqual(len(fc.calls()), 2)
        self.assertIn("the review of L01 could not run in two sessions", self.last_line(p))
        r = pr.result("L01")
        self.assertEqual((r["stage"], r["reason"], r["verdict"]), ("PROVED", "AUDIT_PENDING", "UNFINISHED"))
        # the permissions fixed: the next run starts the review again and it passes
        (self.tmp / "scenario.json.count").unlink()
        ok = passes("L01")
        ok["files"]["verification/audits/L01_final_r3.md"] = ok["files"].pop("verification/audits/L01_final.md")
        p, st, _ = self.drive(pr, [ok])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(pr.result("L01")["evidence"]["final"], "verification/audits/L01_final_r3.md")

    def test_rules_a_review_needs_are_checked_before_any_session(self):    # v1.5.1
        pr = Project(self.tmp, results=[result("L01")])
        d = json.loads(pr.read(".claude/settings.json"))
        d["permissions"]["allow"] = [r for r in d["permissions"]["allow"] if "pv_audit_mech" not in r]
        pr.write(".claude/settings.json", json.dumps(d))
        p, st, fc = self.drive(pr, [passes("L01")])
        self.assertEqual(p.returncode, 7, p.out)
        self.assertEqual(fc.calls(), [])
        self.assertIn("`python3 scripts/pv_audit_mech.py T01` is not allowed", self.last_line(p))
        # a broader rule is enough; a deny rule is not
        d["permissions"]["allow"].append("Bash(python3 scripts/*)")
        pr.write(".claude/settings.json", json.dumps(d))
        self.assertEqual(pr.script("pv_drive_status.py", "preflight").returncode, 0)
        d["permissions"]["deny"].append("Bash(scripts/pv_lean.sh *)")
        pr.write(".claude/settings.json", json.dumps(d))
        p = pr.script("pv_drive_status.py", "preflight")
        self.assertEqual(p.returncode, 1)
        self.assertIn("`scripts/pv_lean.sh preflight` is denied", p.out)

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

    def test_the_cap_counts_this_run_not_the_session_numbers(self):      # v1.5.2
        pr = Project(self.tmp, results=[result(f"L0{i}") for i in range(1, 5)])
        for i in range(1, 40):
            pr.write(f"pv_work/logs/drive/session_{i}.json", '{"result": "an earlier session", "is_error": false}\n')
        steps = [passes("L01"), {"is_error": True, "result": LIMIT}, passes("L02"), passes("L03"), passes("L04")]
        p, st, fc = self.drive(pr, steps, "--auto-resume", "--max-sessions", "75", PV_BATCH="1")
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(len(fc.calls()), 5)
        self.assertTrue((pr.root / "pv_work/logs/drive/session_44.json").exists())

    def test_the_cap_is_named_when_it_ends_the_run(self):                # v1.5.2
        pr = Project(self.tmp, results=[result("L01"), result("L02"), result("L03")])
        for i in range(1, 40):
            pr.write(f"pv_work/logs/drive/session_{i}.json", '{"result": "an earlier session", "is_error": false}\n')
        p, st, fc = self.drive(pr, [passes("L01"), passes("L02")], "--max-sessions", "2", PV_BATCH="1")
        self.assertEqual(p.returncode, 6, p.out)
        self.assertEqual(st["reason"], "max_sessions")
        self.assertEqual(len(fc.calls()), 2)
        self.assertEqual(self.last_line(p), "DRIVER STOPPED: max_sessions — --max-sessions 2 reached; run the driver again "
                                            "to continue")

    def stopped(self, pr, rid):
        pr.write(f"verification/audits/{rid}_gate.md", "STATEMENT GATE: PASS\n")
        p = pr.status("record", rid, "--verdict", "UNFINISHED", "--stage", "STOPPED", "--reason", "BUDGET_EXHAUSTED",
                      "--statement-fixed", "true", "--partial", "S3 open")
        self.assertEqual(p.returncode, 0, p.out)

    def test_a_reset_result_is_not_left_without_its_second_pass(self):   # v1.5.2
        pr = Project(self.tmp, results=[result("T1")])
        pr.make_passed("T1")
        d = pr.state()
        d["results"][0]["round"] = 2
        pr.write_state(d)
        pr.status("reset", "T1", "--revision", "7")
        self.stopped(pr, "T1")
        p, st, fc = self.drive(pr, [passes("T1")])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(len(fc.calls()), 1)
        self.assertIn("do the second pass (§1 step 8) for: T1", fc.prompts()[0])
        self.assertEqual(pr.result("T1")["verdict"], "UNCONDITIONAL")

    def test_the_log_says_why_a_stopped_result_got_no_second_pass(self):  # v1.5.2
        pr = Project(self.tmp, results=[result("T1", round=2)])
        self.stopped(pr, "T1")
        p, st, fc = self.drive(pr, [])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(len(fc.calls()), 0)
        self.assertIn("  T1: its second pass is used (round 2), so it stays BUDGET_EXHAUSTED", p.out)

    def test_a_failed_attempt_to_prove_an_input_is_progress(self):       # v1.5.2
        pr = Project(self.tmp, results=[result("L01")], tools=[tool("T1", "ii", consumers=["L01"])])
        pr.make_passed("L01", verdict="CONDITIONAL", conditions=["T1"])
        pr.status("provable", "T1", "--why", "a short route")
        step = {"run": ["python3 scripts/pv_status.py provable T1 --undo --why 'the route needs more'"]}
        p, st, fc = self.drive(pr, [step])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(len(fc.calls()), 1)

    def test_the_discharge_stage_tries_the_inputs_before_the_report(self):   # v1.6
        pr = Project(self.tmp, results=[result("L01")], tools=[tool("V1", "v", consumers=["L01"])])
        pr.make_passed("L01", verdict="CONDITIONAL", conditions=["V1"])
        p, st, fc = self.drive(pr, [])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertIn("1 input(s) of provenance (ii) or (v) could be proved before they go to a person", p.out)
        self.assertEqual(len(fc.calls()), 0)
        fc_dir = self.tmp / "second"
        fc_dir.mkdir()
        step = {"run": ["python3 scripts/pv_status.py provable V1 --undo --why 'needs more than the project has'"]}
        fc2 = FakeClaude(fc_dir, [step])
        p = run(["scripts/pv_drive.sh", "--discharge"], cwd=pr.root, env=fc2.env(PV_CAFFEINATE="0", PV_SLEEP_CMD="echo SLEPT"))
        st = json.loads(pr.read("pv_work/logs/drive_status.json"))
        self.assertEqual(st["reason"], "done", p.out)
        self.assertIn("discharge stage: MARKED\tV1\t(v)\tused by L01", p.out)
        self.assertEqual(len(fc2.calls()), 1)
        self.assertIn("Also do the reconnections", fc2.prompts()[0])
        self.assertEqual(pr.state()["external_tools"][0]["provable_tried"]["why"], "needs more than the project has")


    def test_a_result_gated_before_v1_6_gets_its_refutation(self):        # v1.6
        pr = Project(self.tmp, results=[result("L01")], tools=[tool("T1", "i", consumers=["L01"])])
        pr.make_passed("L01", verdict="CONDITIONAL", conditions=["T1"])
        pr.write("verification/audits/L01_gate.md", "STATEMENT GATE: PASS\n")      # a gate from before v1.6
        d = pr.state()
        d["external_tools"][0].pop("refutation", None)
        pr.write_state(d)
        step = {"files": {"verification/audits/L01_refute.md": "REFUTATION: T1 NOT REFUTED — tried: n = 0\n\nREFUTATION CHECK: DONE\n"},
                "run": ["python3 scripts/pv_status.py refutations"]}
        p, st, fc = self.drive(pr, [step])
        self.assertEqual(st["reason"], "done", p.out)
        self.assertEqual(len(fc.calls()), 1)
        self.assertIn("scope: L01", fc.prompts()[0])
        self.assertEqual(pr.state()["external_tools"][0]["refutation"]["result"], "NOT REFUTED")


if __name__ == "__main__":
    unittest.main()
