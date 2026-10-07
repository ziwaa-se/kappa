#!/usr/bin/env python3
"""pv_cards_check.py — check that every rules section cited by a rule card still exists (kit v1.3).

Each agent in .claude/agents/ carries a rule card: excerpts of verification/rules/, tagged with their source, such as
"POLICY §1", "VERDICTS §4.1", "PIPELINE stage 4", "VERIFICATION_METHODS §2b", "LESSONS 18". The rules files stay
authoritative. Run this after changing a rules file; it lists every citation whose section is gone, so the cards can
be updated with the rule. It cannot check that a card's wording still matches the rule: that is for a person.

Usage: python3 scripts/pv_cards_check.py
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RULES = ROOT / "verification" / "rules"
AGENTS = ROOT / ".claude" / "agents"
FILES = {"POLICY": "POLICY.md", "VERDICTS": "VERDICTS.md", "PIPELINE": "PIPELINE.md",
         "VERIFICATION_METHODS": "VERIFICATION_METHODS.md", "LESSONS": "LESSONS.md"}
REF = re.compile(r"\b(POLICY|VERDICTS|PIPELINE|VERIFICATION_METHODS|LESSONS)(?:\.md)?\s*"
                 r"((?:§\s*[0-9]+[a-z]?(?:\.[0-9]+)?(?:\s*[–,-]\s*§?\s*[0-9]+[a-z]?(?:\.[0-9]+)?)*)|(?:stages?\s+[0-9]+[a-z]?(?:\s*(?:and|,)\s*[0-9]+[a-z]?)*)|(?:[0-9]+(?:\s*[–,-]\s*[0-9]+)*(?:\s*,\s*[0-9]+)*))?")


def sections(text):
    heads = set()
    for m in re.finditer(r"^#{2,4}\s+(?:Stage\s+)?([0-9]+[a-z]?(?:\.[0-9]+)?)[.:\s]", text, flags=re.M):
        heads.add(m.group(1))
    items = set(re.findall(r"^\s*([0-9]+)\.\s", text, flags=re.M))
    return heads, items


def expand(spec):
    spec = spec.replace("§", " ").replace("stages", " ").replace("stage", " ").replace("and", ",")
    out = []
    for part in re.split(r"\s*,\s*", spec.strip()):
        m = re.fullmatch(r"\s*([0-9]+)\s*[–-]\s*([0-9]+)\s*", part)
        if m:
            out += [str(k) for k in range(int(m.group(1)), int(m.group(2)) + 1)]
        elif part.strip():
            out.append(part.strip())
    return out


def main():
    texts = {k: (RULES / v).read_text() for k, v in FILES.items() if (RULES / v).exists()}
    bad, n = [], 0
    for agent in sorted(AGENTS.glob("*.md")):
        for m in REF.finditer(agent.read_text()):
            name, spec = m.group(1), m.group(2)
            if not spec or name not in texts:
                continue
            heads, items = sections(texts[name])
            for sec in expand(spec):
                n += 1
                ok = sec in items if name == "LESSONS" else (sec in heads or sec.split(".")[0] in heads)
                if not ok:
                    bad.append(f"{agent.name}: {name} {sec} not found in verification/rules/{FILES[name]}")
    for b in bad:
        print("MISSING", b)
    print(f"{n} citations checked; {len(bad)} missing" + ("" if bad else " — CARDS OK"))
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
