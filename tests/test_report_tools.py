"""The v1.5 tools made from the records without a model: the verification graph (pv_graph.py), the one-page summary
(pv_summary.py), the standalone Lean project (pv_export.py), and autosetup/fetch_arxiv.py (offline, with --file)."""
import gzip
import hashlib
import io
import json
import os
import re
import tarfile
import unittest
from pathlib import Path

from helpers import KIT, PY, KitTestCase, Project, result, run, tool

LEAN_ENV = os.environ.get("PV_TEST_LEAN_ENV", "")

BLOCKERS = """# Issue records (Blockers)

## B01 — L03 / 2.3 — ERROR

- **In one sentence**: Lemma 2.3 is false for x = -2.
- **Evidence**: `pv_work/L03_Counterexample1.lean`, `verification/audits/L03_issue_1.md`.

## B02 — L02 / 2.2 — PAPER_ARGUMENT_GAP — RESOLVED (2026-10-01, revision 1)

- **In one sentence**: The step "by convexity" does not hold.
"""


def records():
    """Five results: unconditional, conditional (one checked condition), issue, a user of the issue, unfinished."""
    return [result("L01", pdf_number="2.1", title="first </script><b>bold</b>", stage="FINAL_PASSED",
                   verdict="UNCONDITIONAL", lean_main="pv_work/L01.lean:3 Paper.L01.main", summary_en="L01 holds."),
            result("P01", kind="Proposition", pdf_number="2.2", depends_on=["L01"], stage="FINAL_PASSED",
                   verdict="CONDITIONAL", conditions=["T1"], lean_main="pv_work/P01.lean:3 Paper.P01.main"),
            result("L03", pdf_number="2.3", stage="STOPPED", reason="ISSUE_RECORDED", verdict="ISSUE",
                   issues=["B01"], lean_main="pv_work/L03ModGaps.lean:3 Paper.L03.ghost"),
            result("C01", kind="Corollary", pdf_number="2.4", depends_on=["L03", "P01"], stage="FINAL_PASSED",
                   verdict="CONDITIONAL", conditions=["C01_L03Consumed"], upstream_issues=["B01"],
                   lean_main="pv_work/C01.lean:3 Paper.C01.main"),
            result("T01", kind="Theorem", pdf_number="2.5", depends_on=["C01"], stage="STOPPED",
                   reason="TRANSLATION_BLOCKED", verdict="UNFINISHED")]


def lean(ns, *imports):
    return "".join(f"import {m}\n" for m in imports) + f"namespace Paper.{ns}\ntheorem main : True := trivial\nend Paper.{ns}\n"


class Records(KitTestCase):
    def setUp(self):
        super().setUp()
        checked = {"by": "A. Reader", "date": "2026-10-02 10:00", "how": "against the book"}
        self.pr = Project(self.tmp, results=records(),
                          tools=[tool("T1", meaning="a cited bound", human_checked=checked),
                                 tool("C01_L03Consumed", "iv", predecessor="L03", meaning="Lemma 2.3 as printed")])
        self.pr.write("verification/BLOCKERS.md", BLOCKERS)
        self.pr.write("pv_work/Defs.lean", "-- shared definitions\n")
        self.pr.write("pv_work/L01Stmt.lean", "import Defs\n")
        self.pr.write("pv_work/L01.lean", lean("L01", "L01Stmt"))
        self.pr.write("pv_work/P01.lean", lean("P01", "L01"))
        self.pr.write("pv_work/L03ModGaps.lean", lean("L03", "Defs"))
        self.pr.write("pv_work/L03_Counterexample1.lean", "import Defs\n")
        self.pr.write("pv_work/C01.lean", lean("C01", "P01", "L03ModGaps"))
        self.pr.write("pv_work/T01Draft.lean", "theorem x : False := sorry\n")

    def graph_data(self):
        p = self.pr.script("pv_graph.py")
        self.assertEqual(p.returncode, 0, p.out)
        page = self.pr.read("verification/report/VERIFICATION_GRAPH.html")
        blob = re.search(r'<script type="application/json" id="data">(.*?)</script>', page, flags=re.S).group(1)
        return page, json.loads(blob)

    def test_graph_holds_every_result_with_its_links(self):
        page, d = self.graph_data()
        nodes = {n["id"]: n for n in d["nodes"]}
        self.assertEqual(list(nodes), ["L01", "P01", "L03", "C01", "T01"])
        self.assertEqual(nodes["L01"]["used_by"], ["P01"])
        self.assertEqual(nodes["C01"]["uses"], ["L03", "P01"])
        self.assertEqual(nodes["L03"]["issues"][0]["sentence"], "Lemma 2.3 is false for x = -2.")
        self.assertEqual(nodes["C01"]["upstream"][0]["codes"], ["ERROR"])
        self.assertTrue(nodes["P01"]["person"])
        self.assertIn("A. Reader", nodes["P01"]["conditions"][0]["checked"])
        self.assertEqual(nodes["L01"]["link"], "../../pv_work/L01.lean")
        self.assertEqual(d["meta"]["counts"], {"UNCONDITIONAL": 1, "CONDITIONAL": 2, "ISSUE": 1, "UNFINISHED": 1})
        self.assertEqual(page.count('class="node '), 5)
        self.assertEqual(page.count('class="edge"'), 4)

    def test_graph_is_self_contained_and_escapes_text(self):
        page, _ = self.graph_data()
        self.assertNotIn("<b>bold</b>", page)                    # neither in the SVG nor in the embedded data
        self.assertNotIn("<script src", page)
        self.assertNotIn("http", page.replace("http://www.w3.org/2000/svg", ""))

    def test_graph_survives_a_dependency_cycle(self):
        d = self.pr.state()
        d["results"][0]["depends_on"] = ["T01"]
        self.pr.write_state(d)
        _, data = self.graph_data()
        self.assertEqual(len(data["nodes"]), 5)

    def test_summary(self):
        p = self.pr.script("pv_summary.py", "--stdout")
        self.assertEqual(p.returncode, 0, p.out)
        s = p.out
        self.assertIn("**1 verified unconditionally · 2 verified conditionally · 1 with an issue recorded · "
                      "1 unfinished.**", s)
        self.assertIn("| B01 | 2.3 (L03) | ERROR | open | Lemma 2.3 is false for x = -2. |", s)
        self.assertIn("| B02 | 2.2 (L02) | PAPER_ARGUMENT_GAP | resolved |", s)
        self.assertLess(s.index("| B01 |"), s.index("| B02 |"))      # open issues first
        self.assertIn("A. Reader, 2026-10-02 10:00: against the book", s)
        self.assertIn("| `C01_L03Consumed` | Lemma 2.3 as printed |", s)
        self.assertIn("not yet", s)
        self.assertIn("2.5 (T01): STOPPED TRANSLATION_BLOCKED", s)
        self.assertIn("C01 (B01)", s)
        self.assertEqual(self.pr.script("pv_summary.py").returncode, 0)
        self.assertTrue((self.pr.root / "verification/report/CHECK_SUMMARY.md").exists())

    def test_export(self):
        p = self.pr.script("pv_export.py", "--pins", str(KIT / "lean-pins"))
        self.assertEqual(p.returncode, 0, p.out)
        out = self.pr.root / "export/lean"
        roots = re.search(r"roots = \[(.*)\]", (out / "lakefile.toml").read_text()).group(1)
        mods = json.loads("[" + roots + "]")
        self.assertEqual(set(mods), {"Defs", "L01Stmt", "L01", "P01", "L03ModGaps", "C01", "L03_Counterexample1"})
        self.assertLess(mods.index("Defs"), mods.index("L01Stmt"))
        self.assertLess(mods.index("L01Stmt"), mods.index("L01"))
        self.assertLess(mods.index("P01"), mods.index("C01"))
        self.assertFalse((out / "lean/T01Draft.lean").exists())           # unfinished: not exported
        for line in (out / "SHA256SUMS").read_text().splitlines():
            digest, path = line.split("  ")
            self.assertEqual(hashlib.sha256((out / path).read_bytes()).hexdigest(), digest)
            self.assertEqual((out / path).read_bytes(), (self.pr.root / "pv_work" / Path(path).name).read_bytes())
        axioms = (out / "Axioms.lean").read_text()
        self.assertIn("#print axioms Paper.C01.main", axioms)
        self.assertNotIn("Paper.L03.ghost", axioms)                     # lean_main names no real theorem
        self.assertIn("L03: lean_main names Paper.L03.ghost", (out / "README.md").read_text())
        self.assertIn('rev = "c44e0c8ee63ca166450922a373c7409c5d26b00b"', (out / "lakefile.toml").read_text())
        self.assertNotEqual(self.pr.script("pv_export.py", "--pins", str(KIT / "lean-pins")).returncode, 0)
        p = self.pr.script("pv_export.py", "--pins", str(KIT / "lean-pins"), "--force")
        self.assertEqual(p.returncode, 0, p.out)

    def test_export_needs_the_pins_and_never_replaces_other_folders(self):
        p = self.pr.script("pv_export.py")
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("lean-toolchain", p.out)
        self.pr.write("mine/notes.txt", "keep me\n")
        p = self.pr.script("pv_export.py", "--pins", str(KIT / "lean-pins"), "--out", "mine", "--force")
        self.assertNotEqual(p.returncode, 0)
        self.assertEqual(self.pr.read("mine/notes.txt"), "keep me\n")


def tar_gz(entries):
    """A gzipped tar archive in memory; entries are (name, bytes) or (name, None, linkname) for a symlink."""
    buf = io.BytesIO()
    with tarfile.open(fileobj=buf, mode="w:gz") as t:
        for e in entries:
            ti = tarfile.TarInfo(e[0])
            if len(e) == 3:
                ti.type, ti.linkname = tarfile.SYMTYPE, e[2]
                t.addfile(ti)
            else:
                ti.size = len(e[1])
                t.addfile(ti, io.BytesIO(e[1]))
    return buf.getvalue()


class FetchArxiv(KitTestCase):
    MAIN = b"\\documentclass{article}\n\\begin{document}\\input{sec/a}\\end{document}\n"

    def fetch(self, ident, dest, data):
        f = self.tmp / "eprint"
        f.write_bytes(data)
        return run([PY, str(KIT / "autosetup/fetch_arxiv.py"), ident, str(dest), "--file", str(f)], cwd=self.tmp)

    def test_archive_into_a_project(self):
        pr = Project(self.tmp)
        (pr.root / "source/main.tex").unlink()
        data = tar_gz([("main.tex", self.MAIN), ("sec/a.tex", b"x\n"), ("._main.tex", b"mac"), ("sec/.DS_Store", b"")])
        p = self.fetch("https://arxiv.org/abs/2610.35596v1", pr.root, data)
        self.assertEqual(p.returncode, 0, p.out)
        self.assertIn("main file: main.tex", p.out)
        self.assertEqual(pr.read("source/main.tex").encode(), self.MAIN)
        self.assertTrue((pr.root / "source/sec/a.tex").exists())
        self.assertFalse((pr.root / "source/._main.tex").exists())
        self.assertNotEqual(self.fetch("2610.35596", pr.root, data).returncode, 0)        # never overwrites

    def test_single_file_submission(self):
        p = self.fetch("math/0601001", self.tmp / "out", gzip.compress(self.MAIN))
        self.assertEqual(p.returncode, 0, p.out)
        self.assertEqual((self.tmp / "out/main.tex").read_bytes(), self.MAIN)

    def test_unsafe_archives_and_wrong_inputs_are_refused(self):
        cases = [("2610.35596", tar_gz([("../escape.tex", b"x")]), "unsafe path"),
                 ("2610.35596", tar_gz([("/abs.tex", b"x")]), "unsafe path"),
                 ("2610.35596", tar_gz([("link.tex", None, "/etc/passwd")]), "link"),
                 ("2610.35596", b"%PDF-1.5", "only a PDF"),
                 ("not-an-id", tar_gz([("main.tex", self.MAIN)]), "not an arXiv identifier")]
        for k, (ident, data, msg) in enumerate(cases):
            dest = self.tmp / f"d{k}"
            p = self.fetch(ident, dest, data)
            self.assertNotEqual(p.returncode, 0, msg)
            self.assertIn(msg, p.out)
            self.assertFalse(dest.exists(), msg)
        self.assertFalse((self.tmp / "escape.tex").exists())


@unittest.skipUnless(LEAN_ENV and Path(LEAN_ENV, ".lake/packages/mathlib").is_dir(), "set PV_TEST_LEAN_ENV")
class ExportBuilds(KitTestCase):
    def test_exported_files_compile_and_use_standard_axioms(self):
        env = Path(os.path.expanduser(LEAN_ENV))
        root = self.tmp / "proj"
        p = run([str(KIT / "install.sh"), str(root), "--lean-from", str(env), "--link-packages"], cwd=self.tmp,
                timeout=1800)
        self.assertEqual(p.returncode, 0, p.out)
        pr = Project.__new__(Project)
        pr.root = root
        pr.write("pv_work/L01Stmt.lean", "import Mathlib.Data.Real.Basic\n\nnamespace Paper.L01\n"
                                         "def Claim : Prop := ∀ x : ℝ, 0 ≤ x ^ 2\nend Paper.L01\n")
        pr.write("pv_work/L01.lean", "import L01Stmt\n\nnamespace Paper.L01\n"
                                     "theorem L01_main : Claim := fun x => sq_nonneg x\nend Paper.L01\n")
        for m in ("L01Stmt", "L01"):
            b = pr.script("pv_lean.sh", "build", m)
            self.assertEqual(b.returncode, 0, b.out)
        d = pr.state()
        d["results"] = [result("L01", stage="FINAL_PASSED", verdict="UNCONDITIONAL",
                               lean_main="pv_work/L01.lean:4 Paper.L01.L01_main")]
        pr.write_state(d)
        p = pr.script("pv_export.py", "--out", str(self.tmp / "export"))
        self.assertEqual(p.returncode, 0, p.out)
        out = self.tmp / "export"
        (out / ".lake").mkdir()
        (out / ".lake/packages").symlink_to(env / ".lake/packages")   # read only: never `lake build` on a link
        build = out / "build"
        build.mkdir()
        lean_path = {"LEAN_PATH": f"{build}:{os.environ.get('LEAN_PATH', '')}"}
        for m in ("L01Stmt", "L01"):
            c = run(["lake", "env", "lean", "-R", "lean", "-o", str(build / f"{m}.olean"), f"lean/{m}.lean"], cwd=out,
                    env=lean_path, timeout=900)
            self.assertEqual(c.returncode, 0, c.out)
        c = run(["lake", "env", "lean", "Axioms.lean"], cwd=out, env=lean_path, timeout=900)
        self.assertEqual(c.returncode, 0, c.out)
        self.assertIn("'Paper.L01.L01_main' depends on axioms", c.out)
        self.assertNotIn("sorryAx", c.out)


if __name__ == "__main__":
    unittest.main()
