"""Record keeping and revisions in scripts/pv_status.py: PENDING v1.3.1 #6 and #7 (one-level cascade decided by the
gate snapshots), #8 (reset archives old files; set-deps), #10 (reconnected (p) clauses), #11 (duplicate inputs),
#21 (generated evidence index, stale fields), #22 (previous manuscript recorded), #23 (definitions by ID),
#24 (conditions taken from the audit's CONDITIONS line)."""
import json
import shutil

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

    def test_moved_declaration_is_only_a_warning(self):
        d = self.pr.state()
        d["results"][0]["lean_main"] = "pv_work/L01.lean:7 Paper.L01.main"
        self.pr.write_state(d)
        p = self.pr.status("validate")
        self.assertIn("is declared at line 2", p.out)
        self.assertNotIn("INVALID", p.out)
