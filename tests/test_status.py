"""Record keeping and revisions in scripts/pv_status.py: PENDING v1.3.1 #6 and #7 (one-level cascade decided by the
gate snapshots), #8 (reset archives old files; set-deps), #10 (reconnected (p) clauses), #11 (duplicate inputs),
#21 (generated evidence index, stale fields), #22 (previous manuscript recorded), #23 (definitions by ID),
#24 (conditions taken from the audit's CONDITIONS line); v1.5.1: reviews that could not run, one naming rule for
reports and no evidence older than a reset, a changed title; v1.5.2: which report counts, a snapshot after the verdict,
a new pass after a reset, helper limits, inputs a gate marks as cheap to prove."""
import importlib.util
import json
import os
import shutil
import sys

from helpers import KitTestCase, Project, result, tool


def gate_report(rid, defs, main=("main", "777")):
    """A gate report whose snapshot has the given {name: th} definitions and the main theorem."""
    lines = [f"Paper.{rid}.{n}|def|th={th}|vh={int(th) + 1}|bi=" for n, th in defs.items()]
    lines.append(f"Paper.{rid}.{main[0]}|thm|th={main[1]}|vh=-|bi=ee")
    lines.append(f"Paper.{rid}.S1|thm|th=5|vh=-|bi=")
    return "# Gate\n\n```\n" + "\n".join(lines) + "\n```\n\nSTATEMENT GATE: PASS\n"


class Conditions(KitTestCase):
    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01")], tools=[tool("T1"), tool("T2")])
        self.pr.write("verification/audits/L01_gate.md", "STATEMENT GATE: PASS\n")
        self.pr.write("pv_work/L01.lean", "theorem main : True := trivial\n")

    def final(self, conds):
        self.pr.write("verification/audits/L01_final.md",
                      f"x\nFINAL AUDIT: PASS\nSUGGESTED VERDICT: CONDITIONAL\nCONDITIONS: {conds}\n")

    def rec(self, *extra):
        return self.pr.status("record", "L01", "--verdict", "CONDITIONAL", "--stage", "FINAL_PASSED",
                              "--statement-fixed", "true", "--lean-main", "pv_work/L01.lean:1 Paper.L01.main", *extra)

    def test_conditions_come_from_the_audit(self):
        self.final("T1, T2")
        p = self.rec()
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["conditions"], ["T1", "T2"])

    def test_different_conditions_are_refused_unless_explained(self):
        self.final("T1, T2")
        p = self.rec("--conditions", "T1")
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("differ from the audit's CONDITIONS line", p.out)
        p = self.rec("--conditions", "T1", "--conditions-override", "T2 was removed by the human check")
        self.assertIn("T2 was removed by the human check", self.pr.read("verification/AUDIT.md"))
        self.assertIn("differ from the CONDITIONS line", self.pr.status("validate").out)

    def test_stale_partial_is_cleared(self):
        d = self.pr.state()
        d["results"][0]["partial"] = "clauses 1-2 only"
        self.pr.write_state(d)
        self.final("T1")
        self.rec()
        self.assertEqual(self.pr.result("L01")["partial"], "")

    def test_generated_evidence_index(self):
        self.final("T1")
        self.rec()
        self.rec()
        audit = self.pr.read("verification/AUDIT.md")
        self.assertEqual(audit.count("<!-- generated:start -->"), 1)
        self.assertIn("| L01 | L01 | Verified conditionally | `verification/audits/L01_gate.md`", audit)
        self.assertIn("| T1 |", self.pr.read("verification/EXTERNAL_TOOLS.md"))


class Reconnection(KitTestCase):
    def test_reconnected_clause_is_marked_and_cannot_return(self):
        pr = Project(self.tmp, results=[result("L01"), result("L02", depends_on=["L01"])],
                     tools=[tool("T1"), tool("L02_L01Consumed", "p", predecessor="L01")])
        pr.make_passed("L01")
        pr.make_passed("L02", verdict="CONDITIONAL", conditions=["T1", "L02_L01Consumed"])
        pr.write("verification/audits/L02_reconnect_r1.md", "RECONNECT AUDIT: PASS\nCONDITIONS: T1\n")
        pr.write("pv_work/L02Closed_r1.lean", "namespace Paper.L02\ntheorem main : True := trivial\nend Paper.L02\n")
        p = pr.status("record", "L02", "--verdict", "CONDITIONAL", "--stage", "FINAL_PASSED", "--evidence-reconnect",
                      "verification/audits/L02_reconnect_r1.md", "--lean-main", "pv_work/L02Closed_r1.lean:2 Paper.L02.main")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(pr.result("L02")["conditions"], ["T1"])
        t = next(x for x in pr.state()["external_tools"] if x["id"] == "L02_L01Consumed")
        self.assertTrue(t["status"].startswith("reconnected"))
        self.assertIn("reconnected in", pr.status("tools").out)


class ResolvedIssueClause(KitTestCase):
    def test_iv_clause_is_reconnected_once_its_lemma_is_verified(self):
        pr = Project(self.tmp, results=[result("L03"), result("C01", depends_on=["L03"])],
                     tools=[tool("C01_L03Consumed", "iv", predecessor="L03")])
        pr.make_passed("C01", verdict="CONDITIONAL", conditions=["C01_L03Consumed"])
        self.assertIn("no pending reconnections", pr.status("reconnect").out)
        pr.make_passed("L03")          # a revision fixed L03's proof, and it is verified now
        self.assertIn("C01\tuses C01_L03Consumed\tpredecessor L03 is UNCONDITIONAL", pr.status("reconnect").out)


class Duplicates(KitTestCase):
    def test_same_constant_is_refused_and_same_fact_is_flagged(self):
        pr = Project(self.tmp, results=[result("A06"), result("A08")])
        base = {"meaning": "McDiarmid bounded differences inequality for independent random variables",
                "provenance": "i", "source_loc": "source/app.tex:40 \\cite{BLM13}", "human_check": "Theorem 6.2"}
        self.assertEqual(pr.status("add-tool", json.dumps(dict(base, id="A06_McDiarmid", lean="pv_work/A06Stmt.lean:3 Paper.A06.McD"))).returncode, 0)
        p = pr.status("add-tool", json.dumps(dict(base, id="A08_McD", lean="pv_work/A06Stmt.lean:3 Paper.A06.McD")))
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("already registered as A06_McDiarmid", p.out)
        p = pr.status("add-tool", json.dumps(dict(base, id="A08_McDiarmid", lean="pv_work/A08Stmt.lean:5 Paper.A08.McD",
                                                  source_loc="source/app.tex:91 \\cite{BLM13}")))
        self.assertIn("looks like the same fact as A06_McDiarmid", p.out)
        t = next(x for x in pr.state()["external_tools"] if x["id"] == "A08_McDiarmid")
        self.assertEqual(t["possible_duplicate_of"], "A06_McDiarmid")


class Revision(KitTestCase):
    """P01 <- D01 <- Q01: a revision changes P01."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("P01"), result("D01", depends_on=["P01"]),
                                             result("Q01", depends_on=["D01"])])
        for rid in ("P01", "D01", "Q01"):
            self.pr.write(f"pv_work/{rid}Stmt.lean", "x\n")
            self.pr.make_passed(rid)
        self.pr.write("verification/audits/P01_gate.md", gate_report("P01", {"Conclusion": "100", "Hyp": "200"}))

    def test_reset_archives_files_and_marks_only_direct_dependents(self):
        p = self.pr.status("reset", "P01", "--revision", "2")
        self.assertEqual(p.returncode, 0, p.out)
        r = self.pr
        self.assertFalse((r.root / "pv_work/P01.lean").exists())
        self.assertTrue((r.root / "pv_work/superseded/rev2/P01.lean").exists())
        self.assertTrue((r.root / "pv_work/P01Stmt.lean").exists(), "the statement file stays for the drafter")
        self.assertTrue((r.root / "verification/audits/rev2/P01_final.md").exists())
        h = r.result("P01")["history"][-1]
        self.assertEqual(h["evidence"]["final"], "verification/audits/rev2/P01_final.md")
        self.assertEqual(h["baseline_before"], "verification/source_baseline_v1")
        self.assertEqual(r.result("D01")["recheck"]["kind"], "pending")
        self.assertNotIn("recheck", r.result("Q01"), "one level only")
        self.assertEqual(r.result("D01")["verdict"], "UNCONDITIONAL", "the dependent keeps its verdict for now")
        self.assertIn("re-check pending", r.status("table").out)

    def regate(self, defs):
        self.pr.write("verification/audits/P01_gate.md", gate_report("P01", defs))
        return self.pr.status("record", "P01", "--stage", "GATE_PASSED", "--statement-fixed", "true")

    def test_unchanged_statement_asks_only_for_a_recheck(self):
        self.pr.status("reset", "P01", "--revision", "2")
        p = self.regate({"Conclusion": "100", "Hyp": "200"})
        self.assertIn("gated statement unchanged", p.out)
        self.assertEqual(self.pr.result("D01")["recheck"]["kind"], "rebuild")
        self.assertIn("re-check waits until P01", self.pr.status("next").out)
        self.pr.make_passed("P01")
        self.assertIn("RECHECK\tD01", self.pr.status("next").out)
        self.pr.write("verification/audits/D01_recheck.md", "same fingerprints\nRECHECK: PASS\n")
        p = self.pr.status("record", "D01", "--recheck-passed")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("recheck", self.pr.result("D01"))
        self.assertEqual(self.pr.result("D01")["evidence"]["recheck"], "verification/audits/D01_recheck.md")

    def test_dropped_auxiliary_definition_asks_only_for_a_recheck(self):
        # v1.3.2: the old proof needed an auxiliary definition in the statement file; the rewritten one does not
        self.pr.write("verification/audits/P01_gate.md", gate_report("P01", {"Conclusion": "100", "Hyp": "200",
                                                                             "harmonicMean": "300"}))
        self.pr.write("pv_work/D01Stmt.lean", "def D01Consumed : Prop := Paper.P01.Conclusion\n")
        self.pr.status("reset", "P01", "--revision", "2")
        p = self.regate({"Conclusion": "100", "Hyp": "200"})
        self.assertIn("gated statement unchanged", p.out)
        self.assertIn("dropped, unused by dependents: harmonicMean", p.out)
        self.assertEqual(self.pr.result("D01")["recheck"]["kind"], "rebuild")

    def test_dropped_definition_used_by_a_dependent_counts_as_a_change(self):
        self.pr.write("verification/audits/P01_gate.md", gate_report("P01", {"Conclusion": "100", "Hyp": "200",
                                                                             "harmonicMean": "300"}))
        self.pr.write("pv_work/D01.lean", "theorem t : Paper.P01.harmonicMean 1 1 = 1 := by sorry\n")
        self.pr.status("reset", "P01", "--revision", "2")
        p = self.regate({"Conclusion": "100", "Hyp": "200"})
        self.assertIn("gated statement changed", p.out)
        self.assertEqual(self.pr.result("D01")["verdict"], "UNFINISHED")

    def test_changed_statement_resets_the_dependents_one_level(self):
        self.pr.status("reset", "P01", "--revision", "2")
        p = self.regate({"Conclusion": "101", "Hyp": "200"})
        self.assertIn("gated statement changed", p.out)
        self.assertEqual(self.pr.result("D01")["verdict"], "UNFINISHED")
        self.assertIn("the gated statement of P01 changed", self.pr.result("D01")["history"][-1]["note"])
        self.assertEqual(self.pr.result("Q01")["recheck"]["kind"], "pending")

    def test_set_deps(self):
        self.assertEqual(self.pr.status("set-deps", "D01", "Q01").returncode, 1)     # cycle D01 -> Q01 -> D01
        p = self.pr.status("set-deps", "Q01", "P01")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("Q01")["depends_on"], ["P01"])


class Definitions(KitTestCase):
    def test_only_the_changed_definition_counts(self):
        pr = Project(self.tmp, results=[result("P32", uses_defs=["D01"]), result("A07", uses_defs=["D02"])])
        old = ("\\documentclass{article}\\title{Test paper}\n\\begin{document}\n"
               "The Fourier norm is $\\|f\\|^2 = \\sum_k |\\hat f_k|^2 / |k|^2$.\n"
               "The weighted norm is defined for densities $p$.\n\\end{document}\n")
        pr.write("source/main.tex", old)
        shutil.copytree(str(pr.root / "source"), str(pr.root / "verification/source_baseline"))
        d = pr.state()
        d["source_defs"] = [{"id": "D01", "name": "Fourier norm", "loc": "source/main.tex:3-3"},
                            {"id": "D02", "name": "weighted norm", "loc": "source/main.tex:4-4"}]
        pr.write_state(d)
        pr.write("source/main.tex", old.replace("for densities $p$", "for probability measures $\\mu$")
                 .replace("\\begin{document}\n", "\\begin{document}\n% a new comment line\n"))
        p = pr.status("defs-changed")
        self.assertEqual(p.returncode, 1)
        self.assertRegex(p.out, r"\| D01 Fourier norm \| source/main.tex:3-3 \| UNCHANGED \| source/main.tex:4-4 \| P32 \|")
        self.assertRegex(p.out, r"\| D02 weighted norm \| source/main.tex:4-4 \| CHANGED \|\s*\| A07 \|")

    def test_unknown_definition_ids_are_errors(self):
        pr = Project(self.tmp, results=[result("P01", uses_defs=["D09"])])
        self.assertIn("uses_defs D09 is not in source_defs", pr.status("validate").out)


class RenamedMain(KitTestCase):
    """v1.3.2: a revision that renames the main file (arXiv v2 -> v3) is a new version, not a different paper."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01", uses_defs=["D01"])])
        d = self.pr.state()
        d["paper"] = dict(d.get("paper") or {}, main_tex="source/paper_v2.tex")
        d["source_defs"] = [{"id": "D01", "loc": "source/paper_v2.tex:3-3", "name": "norm"}]
        self.pr.write_state(d)
        self.old = "\\documentclass{article}\\title{Valid inference}\n\\begin{document}\nLet $N = 1$.\n\\end{document}\n"
        for where in ("source", "verification/source_baseline"):
            self.pr.write(f"{where}/paper_v2.tex", self.old)
        (self.pr.root / "source/paper_v2.tex").unlink()

    def test_same_title_is_a_new_version(self):
        self.pr.write("source/paper_v3.tex", self.old.replace("\\end{document}", "A new remark.\n\\end{document}"))
        p = self.pr.status("source-check")
        self.assertIn("SOURCE CHANGED", p.out)
        self.assertIn("main file renamed: source/paper_v2.tex -> source/paper_v3.tex", p.out)
        p = self.pr.status("defs-changed")
        self.assertIn("UNCHANGED", p.out)
        self.assertIn("source/paper_v3.tex:3-3", p.out)
        p = self.pr.status("set-main", "source/paper_v3.tex")
        self.assertEqual(p.returncode, 0, p.out)
        paper = self.pr.state()["paper"]
        self.assertEqual(paper["main_tex"], "source/paper_v3.tex")
        self.assertEqual(paper["previous_main_tex"], ["source/paper_v2.tex"])

    def test_other_title_is_a_different_paper(self):
        self.pr.write("source/paper_v3.tex", self.old.replace("Valid inference", "Another paper"))
        self.assertIn("DIFFERENT PAPER", self.pr.status("source-check").out)


FAIL_NO_SHELL = "No check could run.\n\nFINAL AUDIT: FAIL (Bash denied)\nSUGGESTED VERDICT: UNFINISHED\nCONDITIONS: none\n"
NOT_RUN = "Nothing was checked.\n\nFINAL AUDIT: NOT RUN (no shell: scripts/pv_lean.sh preflight)\n"
FINAL_PASS = "FINAL AUDIT: PASS\nSUGGESTED VERDICT: UNCONDITIONAL\nCONDITIONS: none\n"
FINAL_FAIL = "FINAL AUDIT: FAIL (step 3 differs)\nSUGGESTED VERDICT: UNFINISHED\nCONDITIONS: none\n"


class ReviewNotRun(KitTestCase):
    """v1.5.1: a reviewer without a shell did not fail the result."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01", stage="PROVED", reason="AUDIT_PENDING", statement_fixed=True)])
        self.pr.write("verification/audits/L01_gate.md", "STATEMENT GATE: PASS\n")

    def stop(self):
        return self.pr.status("record", "L01", "--verdict", "UNFINISHED", "--stage", "STOPPED", "--reason", "AUDIT_FAILED")

    def test_not_run_keeps_the_stage_and_is_listed(self):
        self.pr.write("verification/audits/L01_final.md", NOT_RUN)
        p = self.stop()
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("is not a failed review", p.out)
        self.assertEqual((self.pr.result("L01")["stage"], self.pr.result("L01")["reason"]), ("PROVED", "AUDIT_PENDING"))
        self.assertEqual(self.pr.status("not-run").out.strip(), "L01")
        nx = self.pr.status("next").out
        self.assertIn("NOT_RUN\tL01", nx)
        self.assertNotIn("READY\tL01", nx)
        v = self.pr.status("validate")
        self.assertEqual(v.returncode, 0, v.out)
        self.assertIn("the final review could not run", v.out)
        self.assertIn("FINAL AUDIT: NOT RUN", self.pr.status("outputs", "L01").out)

    def test_not_run_is_never_evidence(self):
        self.pr.write("verification/audits/L01_final.md", NOT_RUN)
        self.pr.status("record", "L01", "--stage", "PROVED", "--reason", "AUDIT_PENDING")
        self.assertNotIn("final", self.pr.result("L01")["evidence"])
        # the audit runs again under the next number, and is then what counts
        self.pr.write("verification/audits/L01_final_r2.md", FINAL_PASS)
        self.pr.write("pv_work/L01.lean", "namespace Paper.L01\ntheorem main : True := trivial\nend Paper.L01\n")
        self.assertEqual(self.pr.status("not-run").out.strip(), "")
        p = self.pr.status("record", "L01", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED",
                           "--lean-main", "pv_work/L01.lean:2 Paper.L01.main")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["evidence"]["final"], "verification/audits/L01_final_r2.md")

    def test_a_failed_audit_that_ran_no_script_is_refused(self):
        self.pr.write("verification/audits/L01_mech.md", "MECH CHECKS: PASS\n")
        self.pr.write("verification/audits/L01_final.md", FAIL_NO_SHELL)
        old = (self.pr.root / "verification/audits/L01_mech.md").stat().st_mtime - 100
        os.utime(str(self.pr.root / "verification/audits/L01_mech.md"), (old, old))
        self.pr.write("verification/audits/L01_final_r2.md", FAIL_NO_SHELL)
        p = self.stop()
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("pv_audit_mech.py wrote no report for it", p.out)
        self.assertEqual(self.pr.result("L01")["stage"], "PROVED")

    def test_a_real_failure_is_still_recorded(self):
        self.pr.write("verification/audits/L01_final.md", FINAL_FAIL)
        self.pr.write("verification/audits/L01_final_r2.md", FINAL_FAIL)
        self.pr.write("verification/audits/L01_mech_r2.md", "MECH CHECKS: FAIL (item 4)\n")
        p = self.stop()
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual((self.pr.result("L01")["stage"], self.pr.result("L01")["reason"]), ("STOPPED", "AUDIT_FAILED"))
        self.assertEqual(self.pr.status("not-run").out.strip(), "")

    def test_a_gate_without_a_shell_is_not_gate_failed(self):
        pr = Project(self.tmp, results=[result("L02", stage="STATEMENT_DRAFTED")], name="gate")
        pr.write("verification/audits/L02_gate.md", "STATEMENT GATE: NOT RUN (no shell: scripts/pv_lean.sh preflight)\n")
        p = pr.status("record", "L02", "--stage", "STOPPED", "--reason", "GATE_FAILED")
        self.assertNotEqual(p.returncode, 0)
        self.assertEqual(pr.result("L02")["stage"], "STATEMENT_DRAFTED")
        self.assertEqual(pr.status("not-run").out.strip(), "L02")
        # a report older than the review that passed does not count
        pr.write("verification/audits/L02_gate_r2.md", "STATEMENT GATE: PASS\n")
        self.assertEqual(pr.status("not-run").out.strip(), "")


class ReportNames(KitTestCase):
    """v1.5.1: one naming rule for reports; the evidence is the latest report since the last reset."""

    MAIN = "namespace Paper.L01\ntheorem main : True := trivial\nend Paper.L01\n"

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01")])

    def age(self, rel, days=1):
        f = self.pr.root / rel
        t = f.stat().st_mtime - days * 86400
        os.utime(str(f), (t, t))

    def verified(self, *extra):
        self.pr.write("pv_work/L01.lean", self.MAIN)
        return self.pr.status("record", "L01", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED",
                              "--statement-fixed", "true", "--lean-main", "pv_work/L01.lean:2 Paper.L01.main", *extra)

    def test_reset_clears_the_evidence_and_new_reports_are_found(self):
        self.pr.make_passed("L01")
        self.assertEqual(self.pr.status("reset", "L01", "--revision", "5").returncode, 0)
        self.assertEqual(self.pr.result("L01")["evidence"], {})
        self.pr.write("verification/audits/L01_gate.md", "STATEMENT GATE: PASS\n")
        self.pr.write("verification/audits/L01_final.md", FINAL_PASS)
        p = self.verified()
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["evidence"]["final"], "verification/audits/L01_final.md")

    def test_a_report_named_for_the_revision_is_refused_before_anything_changes(self):
        self.pr.make_passed("L01")
        self.pr.status("reset", "L01", "--revision", "5")
        self.pr.write("verification/audits/L01_gate.md", "STATEMENT GATE: PASS\n")
        self.pr.write("verification/audits/L01_final_rev5.md", FINAL_PASS)
        before = self.pr.result("L01")
        p = self.verified()
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("verification/audits/L01_final_rev5.md does not follow the naming rule", p.out)
        self.assertEqual(self.pr.result("L01"), before)
        # given by name it is recorded, and an older standard report does not replace it later
        p = self.verified("--evidence-final", "verification/audits/L01_final_rev5.md")
        self.assertEqual(p.returncode, 0, p.out)
        p = self.pr.status("record", "L01", "--summary-en", "still verified")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["evidence"]["final"], "verification/audits/L01_final_rev5.md")

    def test_a_report_older_than_the_reset_is_never_taken(self):
        self.pr.make_passed("L01")
        self.age("verification/audits/L01_gate.md")
        self.age("verification/audits/L01_final.md")
        self.pr.status("reset", "L01", "--revision", "5", "--keep-files")
        self.assertEqual(self.pr.result("L01")["evidence"], {})
        p = self.pr.status("record", "L01", "--stage", "PROVING")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["evidence"], {})
        # the one that is new is taken, under the next number
        self.pr.write("verification/audits/L01_gate_r2.md", "STATEMENT GATE: PASS\n")
        self.pr.write("verification/audits/L01_final_r2.md", FINAL_PASS)
        p = self.verified()
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["evidence"]["final"], "verification/audits/L01_final_r2.md")
        self.assertNotIn("older than the last reset", p.out)

    def test_evidence_older_than_the_reset_is_flagged(self):
        self.pr.make_passed("L01")
        self.age("verification/audits/L01_final.md")
        self.pr.status("reset", "L01", "--revision", "5", "--keep-files")
        self.pr.write("verification/audits/L01_gate_r2.md", "STATEMENT GATE: PASS\n")
        p = self.verified("--evidence-final", "verification/audits/L01_final.md")
        self.assertIn("is older than the last reset of L01", p.out)

    def test_a_later_audit_replaces_the_stored_one_without_a_reset(self):
        self.pr.write("verification/audits/L01_gate.md", "STATEMENT GATE: PASS\n")
        self.pr.write("verification/audits/L01_final.md", FINAL_FAIL)
        self.pr.status("record", "L01", "--stage", "PROVING", "--statement-fixed", "true")
        self.assertEqual(self.pr.result("L01")["evidence"]["final"], "verification/audits/L01_final.md")
        self.pr.write("verification/audits/L01_final_r2.md", FINAL_PASS)
        p = self.verified()
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual(self.pr.result("L01")["evidence"]["final"], "verification/audits/L01_final_r2.md")


def paper(title, sentence="For every sample of size $n$ the bound below holds with high probability under Assumption 1."):
    lemmas = "\n".join(f"\\begin{{lemma}}\\label{{lem:{i}}} {sentence} Case {i}.\\end{{lemma}}" for i in range(5))
    return f"\\documentclass{{article}}\n\\newcommand{{\\E}}{{\\mathbb E}}\n\\title{{{title}}}\n\\begin{{document}}\n{lemmas}\n\\end{{document}}\n"


class TitleChange(KitTestCase):
    """v1.5.1: a new title over the same text is a new version, not a different paper."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01")])
        d = self.pr.state()
        d["paper"].update(main_tex="source/main.tex", title="Old title")
        self.pr.write_state(d)
        self.pr.write("source/main.tex", paper("Old title"))
        self.assertEqual(self.pr.script("pv_snapshot.py", "baseline").returncode, 0)

    def test_only_the_title_changes(self):
        self.pr.write("source/main.tex", paper("A new title"))
        p = self.pr.status("source-check")
        self.assertIn("SOURCE CHANGED", p.out)
        self.assertIn("title changed, same paper", p.out)
        self.assertIn("'Old title' -> 'A new title'", p.out)
        self.assertNotIn("DIFFERENT", self.pr.status("validate").out)
        p = self.pr.status("set-title")
        self.assertEqual(p.returncode, 0, p.out)
        paper_rec = self.pr.state()["paper"]
        self.assertEqual((paper_rec["title"], paper_rec["previous_titles"]), ("A new title", ["Old title"]))
        self.assertIn("A new title", self.pr.read("verification/AUDIT.md"))

    def test_new_title_and_main_file_name(self):
        (self.pr.root / "source/main.tex").unlink()
        self.pr.write("source/main_v2.tex", paper("A new title"))
        p = self.pr.status("source-check")
        self.assertIn("SOURCE CHANGED", p.out)
        self.assertIn("main file renamed: source/main.tex -> source/main_v2.tex (new title: A new title)", p.out)

    def test_same_labels_with_much_new_text(self):
        new = paper("A new title").replace("holds with high probability under Assumption 1. Case 0",
                                           "was rewritten throughout for the journal version of this work. Case 0")
        self.pr.write("source/main.tex", new.replace("For every sample of size $n$ the bound below",
                                                     "Whatever the sample size, this new wording of the bound"))
        self.assertIn("title changed, same paper", self.pr.status("source-check").out)

    def test_new_title_over_another_text_is_a_different_paper(self):
        other = paper("Another paper", "Graphs with bounded degree admit a colouring found by the greedy method in linear time.")
        self.pr.write("source/main.tex", other)
        p = self.pr.status("source-check")
        self.assertIn("DIFFERENT PAPER", p.out)
        self.assertIn("0% of the text", p.out)
        self.assertIn("DIFFERENT", self.pr.status("validate").out)

    def test_another_paper_with_the_same_template_and_labels_is_different(self):
        other = paper("Another paper", "Graphs with bounded degree admit a colouring found by the greedy method.")
        self.pr.write("source/main.tex", other.replace("\\end{document}", "\\newcommand{\\F}{1}\n\\end{document}"))
        self.assertIn("DIFFERENT PAPER", self.pr.status("source-check").out)


class LeanMain(KitTestCase):
    """v1.3.3: lean_main must name a theorem that exists in its file."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01")])
        self.pr.make_passed("L01")

    def test_existing_theorem_is_accepted(self):
        self.assertIn("VALID", self.pr.status("validate").out)

    def test_record_refuses_a_missing_theorem(self):
        p = self.pr.status("record", "L01", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED",
                           "--lean-main", "pv_work/L01.lean:1 Paper.L01.L01_main")
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("declares no theorem or lemma 'L01_main'", p.out)

    def test_validate_finds_a_missing_theorem(self):
        d = self.pr.state()
        d["results"][0]["lean_main"] = "pv_work/L01.lean:1 Paper.L01.L01_main"
        self.pr.write_state(d)
        p = self.pr.status("validate")
        self.assertIn("declares no theorem or lemma 'L01_main'", p.out)
        self.assertIn("INVALID", p.out)

    def test_theorem_with_universe_parameters_is_found(self):
        # v1.3.4: `theorem name.{u} ...` was not recognized by v1.3.3
        self.pr.write("pv_work/L01.lean", "namespace Paper.L01\ntheorem main.{u} (a : Sort u) : True := trivial\nend Paper.L01\n")
        p = self.pr.status("validate")
        self.assertNotIn("declares no theorem", p.out)
        self.assertIn("VALID", p.out)

    def test_moved_declaration_is_only_a_warning(self):
        d = self.pr.state()
        d["results"][0]["lean_main"] = "pv_work/L01.lean:7 Paper.L01.main"
        self.pr.write_state(d)
        p = self.pr.status("validate")
        self.assertIn("is declared at line 2", p.out)
        self.assertNotIn("INVALID", p.out)


class NewInRevision(KitTestCase):                                          # v1.5
    def test_new_result_is_marked_and_shown_as_new(self):
        pr = Project(self.tmp, results=[result("A1"), result("N1")])
        pr.make_passed("A1")
        p = pr.status("reset", "N1", "--revision", "4", "--new")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertTrue(p.out.rstrip().endswith("VALID"), p.out)
        r = pr.result("N1")
        self.assertEqual((r["reason"], r["history"][-1]["new"]), ("NEW_IN_REVISION", True))
        self.assertIn("| N1 | N1 | new (revision 4) | Unfinished |", pr.status("followup").out)
        self.assertIn("(before revision 4: new)", pr.status("table").out)
        self.assertIn("READY\tN1", pr.status("next").out)
        p = pr.status("reset", "A1", "--revision", "4", "--new")
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("not started yet", p.out)
        # its first gate pass decides nothing for dependents (there is no earlier statement)
        pr.write("verification/audits/N1_gate.md", "STATEMENT GATE: PASS\n")
        p = pr.status("record", "N1", "--stage", "GATE_PASSED", "--statement-fixed", "true")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("CASCADE", p.out)
        self.assertEqual(pr.result("N1")["reason"], "")


class DischargedInput(KitTestCase):                                        # v1.5
    """An external input that becomes provable after its result was verified (PIPELINE stage 6b)."""

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("X1"), result("Y1")],
                          tools=[tool("Ext1", "v", consumers=["X1", "Y1"],
                                      mathlib_search="in source, not built: Mathlib.Topology.Foo")])
        self.pr.make_passed("X1", verdict="CONDITIONAL", conditions=["Ext1"])
        self.pr.make_passed("Y1", verdict="CONDITIONAL", conditions=["Ext1"])

    def connect(self, rid):
        self.pr.write(f"verification/audits/{rid}_reconnect_r1.md", "# Reconnection\n\nRECONNECT AUDIT: PASS\nCONDITIONS: none\n")
        self.pr.write(f"pv_work/{rid}Closed_r1.lean", f"namespace Paper.{rid}\ntheorem main_closed : True := trivial\nend Paper.{rid}\n")
        return self.pr.status("record", rid, "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED",
                              "--evidence-reconnect", f"verification/audits/{rid}_reconnect_r1.md",
                              "--lean-main", f"pv_work/{rid}Closed_r1.lean:2 Paper.{rid}.main_closed")

    def test_built_module_or_mark_lists_the_input(self):
        pr = self.pr
        self.assertIn("no pending reconnections", pr.status("reconnect").out)
        self.assertIn("in the Mathlib source but not built: Mathlib.Topology.Foo", pr.status("tools").out)
        pr.write(".lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Topology/Foo.olean", "")
        out = pr.status("reconnect").out
        self.assertIn("X1\tuses Ext1\tMathlib module Mathlib.Topology.Foo is now built: prove it and connect it", out)
        self.assertIn("external input Ext1 can now be discharged", pr.status("validate").out)
        p = pr.status("provable", "Ext1", "--undo", "--why", "the route needs more than the lemma")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("no pending reconnections", pr.status("reconnect").out)
        p = pr.status("provable", "Ext1", "--why", "Mathlib's foo_bar gives it")
        self.assertIn("X1\tuses Ext1\tmarked provable: Mathlib's foo_bar", p.out)

    def test_proved_and_connected_input_is_no_longer_open(self):
        p = self.connect("X1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("final audit suggests", p.out)     # the reconnection, not the final audit, decides
        self.assertIn("external input Ext1: marked as proved in pv_work/X1Closed_r1.lean\n", p.out)
        self.assertIn("WARN Y1: external input Ext1 can now be discharged", p.out)
        t = next(x for x in self.pr.state()["external_tools"] if x["id"] == "Ext1")
        self.assertEqual(t["proved_in"], "pv_work/X1Closed_r1.lean")
        self.assertIn("still a condition of Y1 until connected there", t["status"])
        self.assertIn("Y1\tuses Ext1\tproved in Lean in pv_work/X1Closed_r1.lean: connect it", self.pr.status("reconnect").out)
        p = self.connect("Y1")
        self.assertNotIn("WARN", p.out)
        self.assertIn("no longer a condition", self.pr.status("tools").out)
        self.assertIn("no pending reconnections", self.pr.status("reconnect").out)
        self.assertEqual(self.pr.script("pv_summary.py").returncode, 0)
        self.assertIn("- `Ext1` (in `pv_work/Y1Closed_r1.lean`). ", self.pr.read("verification/report/CHECK_SUMMARY.md"))

    def test_last_predecessor_reconnection_gives_no_warning(self):
        pr = Project(self.tmp, results=[result("L01"), result("L02", depends_on=["L01"])],
                     tools=[tool("L02_L01Consumed", "p", predecessor="L01")], name="p")
        pr.make_passed("L01")
        pr.make_passed("L02", verdict="CONDITIONAL", conditions=["L02_L01Consumed"])
        pr.write("verification/audits/L02_reconnect_r1.md", "RECONNECT AUDIT: PASS\nCONDITIONS: none\n")
        pr.write("pv_work/L02Closed_r1.lean", "namespace Paper.L02\ntheorem main : True := trivial\nend Paper.L02\n")
        p = pr.status("record", "L02", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED", "--evidence-reconnect",
                      "verification/audits/L02_reconnect_r1.md", "--lean-main", "pv_work/L02Closed_r1.lean:2 Paper.L02.main")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("final audit suggests", p.out)


class InfrastructureRuling(KitTestCase):                                   # v1.5
    def test_stop_waits_for_the_gate_and_rulings_are_capped(self):
        pr = Project(self.tmp, results=[result("P1")])
        p = pr.status("record", "P1", "--verdict", "UNFINISHED", "--stage", "STOPPED", "--reason", "INFRASTRUCTURE_RULING",
                      "--partial", "S1-S3 proved; S4 needs about 200 helper lines")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertRegex(pr.status("next").out, r"RULING\tP1\tP1\t.*infrastructure-ruling mode .*ruling 1 of at most 2")
        self.assertNotIn("P1", pr.status("next", "--second-pass").out)
        pr.write("verification/audits/P1_infra_r1.md", "reasons\n\nINFRASTRUCTURE RULING: EXTEND 250\n")
        self.assertIn("ruling 2 of at most 2", pr.status("next").out)
        self.assertIn("INFRASTRUCTURE RULING: EXTEND 250", pr.status("outputs", "P1").out)
        pr.write("verification/audits/P1_infra_r2.md", "reasons\n\nINFRASTRUCTURE RULING: DECLINE\n")
        self.assertNotIn("RULING\tP1", pr.status("next").out)
        self.assertIn("record BUDGET_EXHAUSTED instead", pr.status("validate").out)


class ReportStamp(KitTestCase):                                            # v1.5
    def test_stale_report_is_flagged_and_an_update_without_the_compiler_refused(self):
        pr = Project(self.tmp, results=[result("A1"), result("A2")])
        pr.make_passed("A1")
        pr.write("verification/report/AUTHOR_REPORT.md", "report\n")
        p = pr.status("report-stamp")
        self.assertEqual(p.returncode, 1)
        self.assertIn("missing in verification/report/work/: consistency_check.md, author_notes.md, external_tools.md", p.out)
        for n in ("consistency_check.md", "author_notes.md", "external_tools.md"):
            pr.write(f"verification/report/work/{n}", f"{n} from the first compilation\n")
        self.assertEqual(pr.status("report-stamp").returncode, 0)
        self.assertNotIn("older records", pr.status("validate").out)
        pr.make_passed("A2")                              # the records change after the report
        self.assertIn("the report in verification/report/ was made from older records", pr.status("validate").out)
        pr.write("verification/report/work/external_tools.md", "updated by hand\n")
        p = pr.status("report-stamp")
        self.assertEqual(p.returncode, 1)
        self.assertIn("verification/report/work/consistency_check.md, verification/report/work/author_notes.md", p.out)
        self.assertNotIn("work/external_tools.md", p.out)
        for n in ("consistency_check.md", "author_notes.md"):
            pr.write(f"verification/report/work/{n}", f"{n} compiled again\n")
        self.assertEqual(pr.status("report-stamp").returncode, 0)
        self.assertNotIn("older records", pr.status("validate").out)


def status_module(pr):
    """pv_status.py of this project, for the functions that have no command of their own."""
    sys.modules.pop("pv_status", None)
    spec = importlib.util.spec_from_file_location("pv_status", str(pr.root / "scripts/pv_status.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


class ReportThatCounts(KitTestCase):
    """v1.5.2: the same answer for `record` and the mechanical audit; an older passing report never stands in."""

    MAIN = "namespace Paper.L01\ntheorem main : True := trivial\nend Paper.L01\n"
    PASS = "STATEMENT GATE: PASS\n"

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("L01")])
        self.pr.write("verification/audits/L01_gate.md", self.PASS)
        self.S = status_module(self.pr)

    def later(self, rel, text):
        f = self.pr.write(rel, text)
        t = f.stat().st_mtime + 60
        os.utime(str(f), (t, t))

    def current(self, since=None):
        return self.S.current_report("L01", "gate", "STATEMENT GATE:", since)

    def test_the_latest_passing_report_counts(self):
        self.later("verification/audits/L01_gate_r2.md", self.PASS)
        self.assertEqual(self.current(), ("verification/audits/L01_gate_r2.md", ""))

    def test_a_newer_report_under_another_name_stops_the_older_one(self):
        self.later("verification/audits/L01_gate_rev5_r2.md", self.PASS)
        rep, why = self.current()
        self.assertEqual(rep, "")
        self.assertIn("L01_gate_rev5_r2.md is newer than verification/audits/L01_gate.md", why)

    def test_an_older_report_under_another_name_is_left_alone(self):
        self.pr.write("verification/audits/L01_gate_rev4.md", self.PASS)
        f = self.pr.root / "verification/audits/L01_gate_rev4.md"
        t = f.stat().st_mtime - 3600
        os.utime(str(f), (t, t))
        self.assertEqual(self.current(), ("verification/audits/L01_gate.md", ""))

    def test_a_latest_report_that_does_not_pass_is_not_replaced_by_an_older_one(self):
        self.pr.write("verification/audits/L01_gate_r2.md", "STATEMENT GATE: FAIL\n")
        rep, why = self.current()
        self.assertEqual(rep, "")
        self.assertIn("the latest report verification/audits/L01_gate_r2.md does not end with", why)

    def test_a_review_that_could_not_run_is_passed_over(self):
        self.pr.write("verification/audits/L01_gate_r2.md", "STATEMENT GATE: NOT RUN (no shell: x)\n")
        self.assertEqual(self.current(), ("verification/audits/L01_gate.md", ""))

    def test_a_report_older_than_the_reset_does_not_count(self):
        since = (self.pr.root / "verification/audits/L01_gate.md").stat().st_mtime + 30
        self.assertEqual(self.current(since), ("", ""))

    def test_record_refuses_a_verdict_on_an_older_gate_pass(self):
        self.pr.write("verification/audits/L01_final.md", "FINAL AUDIT: PASS\nSUGGESTED VERDICT: UNCONDITIONAL\nCONDITIONS: none\n")
        self.pr.write("pv_work/L01.lean", self.MAIN)
        self.later("verification/audits/L01_gate_r2.md", "STATEMENT GATE: FAIL\n")
        args = ["record", "L01", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED", "--statement-fixed", "true",
                "--lean-main", "pv_work/L01.lean:2 Paper.L01.main"]
        before = self.pr.result("L01")
        p = self.pr.status(*args)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("refused: the latest gate report verification/audits/L01_gate_r2.md", p.out)
        self.assertEqual(self.pr.result("L01"), before)
        p = self.pr.status(*args, "--evidence-gate", "verification/audits/L01_gate.md")
        self.assertEqual(p.returncode, 0, p.out)


class SnapshotAfterTheVerdict(KitTestCase):
    """v1.5.2: the verdict is read outside the snapshot block, which may come after it."""

    SNAP = ("\n<!-- PV SNAPSHOT BEGIN -->\n```\nPaper.G1.main|thm|th=1|vh=-|bi=\nPaper.G1.S1|thm|th=2|vh=-|bi=\n"
            "Paper.G1.S2|thm|th=3|vh=-|bi=\nPaper.G1.S3|thm|th=4|vh=-|bi=\n```\n<!-- PV SNAPSHOT END -->\nEXIT=0\n")

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("G1")])

    def test_validate_stays_valid_and_the_verdict_is_found(self):
        self.pr.make_passed("G1")
        self.pr.write("verification/audits/G1_gate.md", "# Gate\n\nSTATEMENT GATE: PASS\n" + self.SNAP)
        p = self.pr.status("validate")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("VALID", p.out)
        S = status_module(self.pr)
        self.assertEqual(S.verdict_line("verification/audits/G1_gate.md", "STATEMENT GATE:"), "PASS")
        self.assertEqual(S.latest_report("G1", "gate", "STATEMENT GATE:"), "verification/audits/G1_gate.md")
        self.assertEqual(sorted(S.gate_fingerprints("G1", "verification/audits/G1_gate.md")),
                         ["Paper.G1.S1", "Paper.G1.S2", "Paper.G1.S3", "Paper.G1.main"])

    def test_it_replaces_the_older_report(self):
        self.pr.write("verification/audits/G1_gate.md", "STATEMENT GATE: PASS\n")
        self.pr.write("verification/audits/G1_gate_r2.md", "STATEMENT GATE: PASS\n" + self.SNAP)
        S = status_module(self.pr)
        self.assertEqual(S.current_report("G1", "gate", "STATEMENT GATE:"), ("verification/audits/G1_gate_r2.md", ""))

    def test_no_verdict_is_read_from_inside_the_block(self):
        self.pr.write("verification/audits/G1_gate.md", "<!-- PV SNAPSHOT BEGIN -->\nSTATEMENT GATE: PASS\n<!-- PV SNAPSHOT END -->\n")
        self.assertIsNone(status_module(self.pr).verdict_line("verification/audits/G1_gate.md", "STATEMENT GATE:"))

    def test_a_long_tail_without_markers_is_reported_as_such(self):
        self.pr.make_passed("G1")
        plain = self.SNAP.replace("<!-- PV SNAPSHOT BEGIN -->\n", "").replace("<!-- PV SNAPSHOT END -->\n", "")
        self.pr.write("verification/audits/G1_gate.md", "STATEMENT GATE: PASS\n" + plain)
        p = self.pr.status("validate")
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("(found None; the verdict is read from the last 5 lines outside the snapshot block)", p.out)


class NewPassAfterReset(KitTestCase):
    """v1.5.2: a reset starts a new pass, and next --second-pass says why it leaves a stopped result out."""

    def stop(self, pr, rid):
        pr.write(f"verification/audits/{rid}_gate.md", "STATEMENT GATE: PASS\n")
        p = pr.status("record", rid, "--verdict", "UNFINISHED", "--stage", "STOPPED", "--reason", "BUDGET_EXHAUSTED",
                      "--statement-fixed", "true", "--partial", "S3 open")
        self.assertEqual(p.returncode, 0, p.out)

    def test_a_reset_result_gets_its_second_pass(self):
        pr = Project(self.tmp, results=[result("T1", round=2)])
        pr.make_passed("T1")
        self.assertEqual(pr.status("reset", "T1", "--revision", "7").returncode, 0)
        r = pr.result("T1")
        self.assertEqual(r["round"], 1)
        self.assertEqual(r["history"][-1]["round"], 2)
        self.stop(pr, "T1")
        self.assertRegex(pr.status("next", "--second-pass", "--all").out, r"(?m)^READY\tT1\t")

    def test_a_used_second_pass_is_listed_with_the_reason(self):
        pr = Project(self.tmp, results=[result("T1", round=2), result("P1")])
        self.stop(pr, "T1")
        self.stop(pr, "P1")
        out = pr.status("next", "--second-pass", "--all").out
        self.assertRegex(out, r"(?m)^READY\tP1\t")
        self.assertRegex(out, r"(?m)^SKIPPED\tT1\tT1\tits second pass is used \(round 2\), so it stays BUDGET_EXHAUSTED")
        self.assertNotRegex(out, r"(?m)^READY\tT1\t")


class HelperLimits(KitTestCase):
    """v1.5.2: a limit the gate sets on helper code is counted; an overrun goes to the gate, not to the final audit."""

    @staticmethod
    def helper(name, lines, uses=""):
        body = "".join(f"  have h{i} : True := trivial\n" for i in range(lines - 2))
        return f"private theorem {name} : True := by\n{body}  {('exact ' + uses) if uses else 'trivial'}\n\n"

    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp, results=[result("P1")])

    def write(self, gate="", proof=None):
        self.pr.write("verification/audits/P1_gate.md", gate + "STATEMENT GATE: PASS\n")
        self.pr.write("pv_work/P1.lean", proof if proof is not None else (
            "namespace Paper.P1\n\n" + self.helper("big", 20)
            + "theorem P1_S1 : True := by\n  have := big\n  trivial\n\ntheorem P1_S2 : True := trivial\n\nend Paper.P1\n"))

    def test_an_overrun_is_named(self):
        self.write("HELPER LIMIT: S1 10\nHELPER LIMIT: S2 10\n")
        p = self.pr.status("helper-lines", "P1")
        self.assertEqual(p.returncode, 1, p.out)
        self.assertIn("OVER\tS1\t20 helper lines\tlimit 10 (verification/audits/P1_gate.md)", p.out)
        self.assertIn("OK\tS2\t0 helper lines\tlimit 10", p.out)

    def test_record_and_validate_say_so_without_being_asked(self):
        self.write("HELPER LIMIT: S1 10\n")
        p = self.pr.status("record", "P1", "--stage", "PROVED", "--reason", "AUDIT_PENDING", "--statement-fixed", "true")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("WARN P1: S1 has 20 helper lines, over the limit of 10 set in verification/audits/P1_gate.md", p.out)
        self.pr.write("verification/audits/P1_final.md", "FINAL AUDIT: PASS\nSUGGESTED VERDICT: UNCONDITIONAL\nCONDITIONS: none\n")
        p = self.pr.status("record", "P1", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED",
                           "--lean-main", "pv_work/P1.lean:25 Paper.P1.P1_S1")
        self.assertEqual(p.returncode, 0, p.out)      # a warning, not a refusal: the rule asks for a ruling
        self.assertIn("WARN P1: S1 has 20 helper lines", self.pr.status("validate").out)
        self.pr.write("verification/audits/P1_infra_r1.md", "HELPER LIMIT: S1 25\nINFRASTRUCTURE RULING: EXTEND 25\n")
        self.assertNotIn("helper lines", self.pr.status("validate").out)

    def test_within_the_limit(self):
        self.write("**HELPER LIMIT: S1 20**\n")
        p = self.pr.status("helper-lines", "P1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("OK\tS1\t20 helper lines\tlimit 20", p.out)

    def test_no_limit(self):
        self.write()
        p = self.pr.status("helper-lines", "P1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("no helper limit recorded for P1", p.out)

    def test_a_later_ruling_replaces_the_limit(self):
        self.write("HELPER LIMIT: S1 10\n")
        self.pr.write("verification/audits/P1_infra_r1.md", "HELPER LIMIT: S1 30\nINFRASTRUCTURE RULING: EXTEND 30\n")
        p = self.pr.status("helper-lines", "P1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("OK\tS1\t20 helper lines\tlimit 30 (verification/audits/P1_infra_r1.md)", p.out)

    def test_a_ruling_that_names_no_obligation_is_noted(self):
        self.write()
        self.pr.write("verification/audits/P1_infra_r1.md", "INFRASTRUCTURE RULING: EXTEND 30\n")
        self.assertIn("has no HELPER LIMIT line naming the obligation", self.pr.status("helper-lines", "P1").out)

    def test_helpers_of_helpers_count_and_comments_do_not(self):
        proof = ("namespace Paper.P1\n\n" + self.helper("inner", 5) + "/- a comment\nof two lines -/\n"
                 + "-- another\n" + self.helper("outer", 4, "inner") + self.helper("other", 9)
                 + "theorem P1_S1 : True := by\n  exact outer\n\nend Paper.P1\n")
        self.write("HELPER LIMIT: S1 8\n", proof)
        self.assertIn("OVER\tS1\t9 helper lines", self.pr.status("helper-lines", "P1").out)

    def test_another_obligation_is_not_a_helper(self):
        proof = ("namespace Paper.P1\n\n" + self.helper("big", 12) + "theorem P1_S1 : True := by\n  have := big\n  trivial\n\n"
                 "theorem P1_S2 : True := by\n  exact P1_S1\n\nend Paper.P1\n")
        self.write("HELPER LIMIT: S2 5\n", proof)
        p = self.pr.status("helper-lines", "P1")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("OK\tS2\t0 helper lines", p.out)

    def test_a_limit_on_a_gap_or_on_nothing(self):
        self.write("HELPER LIMIT: S1 10\nHELPER LIMIT: S9 10\n",
                   "namespace Paper.P1\n\ndef P1_S1_Gap : Prop := True\n\nend Paper.P1\n")
        out = self.pr.status("helper-lines", "P1").out
        self.assertIn("GAP\tS1\t", out)
        self.assertIn("MISSING\tS9\t", out)

    def test_a_limit_inside_the_snapshot_block_is_not_read(self):
        self.write("<!-- PV SNAPSHOT BEGIN -->\nHELPER LIMIT: S1 1\n<!-- PV SNAPSHOT END -->\n")
        self.assertIn("no helper limit recorded", self.pr.status("helper-lines", "P1").out)


class GateMarksAnInput(KitTestCase):
    """v1.5.2: a gate that finds an input cheap to prove says so in a line of its report; `next`, `reconnect` and the
    tables list it until it is proved or an attempt failed, and the report keeps a sentence about it."""

    LINE = "DISCHARGEABLE: Ext1 from the project's lemma X0_bound, about 60 lines\n"
    ROUTE = "from the project's lemma X0_bound, about 60 lines"

    def setUp(self):
        super().setUp()
        self.ext = tool("Ext1", "ii", lean="pv_work/X1Stmt.lean:3 Paper.X1.UniformBound", consumers=["X1 (S1)"])
        self.pr = Project(self.tmp, results=[result("X1")], tools=[self.ext])

    def ext_now(self):
        return next(x for x in self.pr.state()["external_tools"] if x["id"] == "Ext1")

    def gate(self, line=None):
        self.pr.write("verification/audits/X1_gate.md", (line or self.LINE) + "STATEMENT GATE: PASS\n")
        p = self.pr.status("record", "X1", "--stage", "GATE_PASSED", "--statement-fixed", "true")
        self.assertEqual(p.returncode, 0, p.out)
        return p

    def verify(self):
        self.pr.write("verification/audits/X1_final.md", "FINAL AUDIT: PASS\nSUGGESTED VERDICT: CONDITIONAL\nCONDITIONS: Ext1\n")
        self.pr.write("pv_work/X1.lean", "namespace Paper.X1\ntheorem main : True := trivial\nend Paper.X1\n")
        p = self.pr.status("record", "X1", "--verdict", "CONDITIONAL", "--stage", "FINAL_PASSED",
                           "--lean-main", "pv_work/X1.lean:2 Paper.X1.main")
        self.assertEqual(p.returncode, 0, p.out)

    def test_it_is_listed_until_it_is_proved(self):
        p = self.gate()
        self.assertIn("external input Ext1: marked as provable by verification/audits/X1_gate.md", p.out)
        self.assertEqual(self.ext_now()["provable"]["why"], self.ROUTE)
        out = self.pr.status("next", "--all").out
        self.assertRegex(out, r"(?m)^DISCHARGE\tExt1\tX1\tmarked provable by verification/audits/X1_gate.md: from the")
        self.assertIn("no pending reconnections", self.pr.status("reconnect").out)      # not verified yet
        self.verify()
        self.assertIn(f"X1\tuses Ext1\tmarked provable: {self.ROUTE}: prove it and connect it", self.pr.status("reconnect").out)
        self.assertIn(f"can be discharged now: marked provable: {self.ROUTE}", self.pr.status("tools").out)
        # proved in a Closed file: not listed any more, and the report says what happened
        self.pr.write("pv_work/X1Closed_r1.lean", "namespace Paper.X1\ntheorem main_closed : True := trivial\nend Paper.X1\n")
        self.pr.write("verification/audits/X1_reconnect_r1.md", "RECONNECT AUDIT: PASS\nCONDITIONS: none\n")
        p = self.pr.status("record", "X1", "--verdict", "UNCONDITIONAL", "--stage", "FINAL_PASSED", "--conditions", "",
                           "--evidence-reconnect", "verification/audits/X1_reconnect_r1.md",
                           "--lean-main", "pv_work/X1Closed_r1.lean:2 Paper.X1.main_closed")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("DISCHARGE", self.pr.status("next", "--all").out)
        self.assertIn("no pending reconnections", self.pr.status("reconnect").out)
        sentence = "The paper asserts this fact without proof; it was proved in Lean for this check."
        self.assertIn(sentence, self.pr.status("tools").out)
        self.assertEqual(self.pr.script("pv_summary.py").returncode, 0)
        self.assertIn(sentence, self.pr.read("verification/report/CHECK_SUMMARY.md"))

    def test_the_input_can_be_registered_after_the_gate(self):
        d = self.pr.state()
        d["external_tools"] = []
        self.pr.write_state(d)
        self.gate()
        self.assertNotIn("DISCHARGE", self.pr.status("next", "--all").out)
        t = {k: self.ext[k] for k in ("id", "lean", "meaning", "provenance", "source_loc", "consumers", "human_check")}
        p = self.pr.status("add-tool", json.dumps(t))
        self.assertIn("external input Ext1: marked as provable", p.out)

    def test_the_gate_may_use_the_lean_name(self):
        self.gate("**DISCHARGEABLE: `UniformBound` by the lemma**\n")
        self.assertEqual(self.ext_now()["provable"]["why"], "by the lemma")

    def test_a_failed_attempt_stops_the_listing_for_good(self):
        self.gate()
        self.verify()
        p = self.pr.status("provable", "Ext1", "--undo", "--why", "the route needs more than the lemma")
        self.assertEqual(p.returncode, 0, p.out)
        self.assertNotIn("DISCHARGE", self.pr.status("next", "--all").out)
        self.assertIn("no pending reconnections", self.pr.status("reconnect").out)
        self.assertEqual(self.pr.status("record", "X1", "--summary-en", "again").returncode, 0)
        self.assertNotIn("provable", self.ext_now())

    def test_a_predecessor_clause_is_not_marked(self):
        d = self.pr.state()
        d["external_tools"] = [tool("Ext1", "p", predecessor="X1")]
        self.pr.write_state(d)
        self.gate()
        self.assertNotIn("provable", self.ext_now())

    def test_a_line_inside_the_snapshot_block_does_not_mark(self):
        self.gate("<!-- PV SNAPSHOT BEGIN -->\n" + self.LINE + "<!-- PV SNAPSHOT END -->\n")
        self.assertNotIn("provable", self.ext_now())
