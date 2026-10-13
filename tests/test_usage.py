"""Cost accounting (scripts/pv_usage.py): PENDING v1.3.1 #14. The transcript estimate is checked against the cost that
Claude Code itself reports for the same headless sessions; the two must agree when the price table is current."""
import json

from helpers import PY, KitTestCase, Project, run


def assistant(mid, model, out, read, write, ts):
    return {"type": "assistant", "timestamp": ts,
            "message": {"id": mid, "model": model, "usage": {"input_tokens": 10, "output_tokens": out,
                                                              "cache_read_input_tokens": read,
                                                              "cache_creation_input_tokens": write}}}


class Usage(KitTestCase):
    def setUp(self):
        super().setUp()
        self.pr = Project(self.tmp)
        self.home = self.tmp / "claude-home"
        d = self.home / "projects" / __import__("re").sub(r"[^A-Za-z0-9]", "-", str(self.pr.root.resolve()))
        (d / "s1" / "subagents").mkdir(parents=True)
        main = [{"type": "user", "timestamp": "2026-10-12T10:00:00Z", "message": {"content": "start"}},
                assistant("m1", "claude-sonnet-5-5", 1000, 1_000_000, 10_000, "2026-10-12T10:01:00Z"),
                assistant("m1", "claude-sonnet-5-5", 1000, 1_000_000, 10_000, "2026-10-12T10:01:00Z")]   # repeated block
        (d / "s1.jsonl").write_text("\n".join(json.dumps(x) for x in main) + "\n")
        sub = [assistant("a1", "claude-opus-5-5", 2000, 500_000, 20_000, "2026-10-12T10:02:00Z")]
        (d / "s1" / "subagents" / "agent-x.jsonl").write_text("\n".join(json.dumps(x) for x in sub) + "\n")
        (d / "s1" / "subagents" / "agent-x.meta.json").write_text(json.dumps({"agentType": "pv-prover"}))

    def usage(self, sonnet_cost):
        self.pr.write("pv_work/logs/drive/session_1.json", json.dumps({
            "session_id": "s1", "total_cost_usd": 0,
            "modelUsage": {"claude-sonnet-5-5": {"costUSD": sonnet_cost}, "claude-opus-5-5[1m]": {"costUSD": 0.24004}}}))
        return run([PY, "scripts/pv_usage.py", "--claude-dir", str(self.home), "--json"], cwd=self.pr.root)

    def test_estimate_matches_claude_code_with_current_prices(self):
        # Sonnet 5.5: 10 in, 1000 out, 1M cache read at 0.10, 10k cache write (5 min) at 2.5 -> 0.13502
        p = self.usage(0.13502)
        chk = json.loads(p.out)["claude_code_check"]
        self.assertEqual(chk["sessions"], 1)
        self.assertEqual(chk["models"]["claude-sonnet-5-5"], {"transcripts": 0.14, "claude_code": 0.14})
        self.assertEqual(chk["models"]["claude-opus-5-5"], {"transcripts": 0.24, "claude_code": 0.24})

    def test_report_shows_the_comparison(self):
        self.usage(0.13502)
        p = run([PY, "scripts/pv_usage.py", "--claude-dir", str(self.home)], cwd=self.pr.root)
        self.assertIn("Check against the cost Claude Code reported (1 headless sessions)", p.out)
        self.assertIn("| pv-prover |", p.out)
