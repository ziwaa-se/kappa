#!/usr/bin/env python3
"""pv_graph.py — the verification graph of this project, as one self-contained web page (kit v1.5).

Usage (from the project root):
  python3 scripts/pv_graph.py [--out FILE]      write verification/report/VERIFICATION_GRAPH.html (default)

Each numbered result is a box, colored by its verdict; an arrow runs from a result to every result whose proof uses
it (`depends_on`). Selecting a box shows the result's place in the paper, its Lean theorem, its conditions (the named
hypotheses, with a person's check where one is recorded), its issues (from BLOCKERS.md), what it uses and what uses
it. Below the graph, the same content is a table.

The page is built from the records only (RESULTS.json, BLOCKERS.md, KIT_VERSION): no language model, no network,
no external script or font. It opens in any browser, offline; `VERIFICATION_GRAPH.html#L03` opens with result L03 selected. Run it again whenever the
records change; /pv-report and the unattended driver run it at the end.
"""
import argparse
import html
import json
import os
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pv_status as S  # noqa: E402

OUT = S.ROOT / "verification" / "report" / "VERIFICATION_GRAPH.html"
W, H, GX, GY, PAD = 232, 62, 96, 20, 24
PROVENANCE = {"i": "result cited from the literature", "ii": "fact the paper asserts without proof",
              "iii": "used by the proof but never stated in the paper",
              "iv": "clause of one of the paper's results whose proof has an issue",
              "v": "standard fact not available in the pinned Mathlib",
              "p": "clause of an earlier result of the paper, used before that result was verified"}
COUNTED = {"UNCONDITIONAL": "verified unconditionally", "CONDITIONAL": "verified conditionally",
           "ISSUE": "with an issue recorded", "UNFINISHED": "unfinished"}
MEANING = {"UNCONDITIONAL": "The paper's proof of the whole statement compiles in Lean, with no unproved input.",
           "CONDITIONAL": "The proof compiles in Lean, but assumes the conditions listed below; a person should "
                          "check them.",
           "ISSUE": "An independently confirmed problem in this result's own statement or proof.",
           "UNFINISHED": "Not decided; stopped for the reason given. Never counted as an error in the paper."}


def kit_version():
    f = S.ROOT / "KIT_VERSION"
    return f.read_text().strip() if f.exists() else "?"


def layers(res):
    """Column of each result: 0 without prerequisites, else one more than its deepest prerequisite."""
    ids = {r["id"] for r in res}
    deps = {r["id"]: [d for d in S.as_list(r.get("depends_on")) if d in ids] for r in res}
    depth = {}

    def walk(i, seen=()):
        if i not in depth:
            if i in seen:                      # a cycle (validate reports it): cut it here
                return 0
            depth[i] = 1 + max([walk(d, seen + (i,)) for d in deps[i]], default=-1)
        return depth[i]

    for r in res:
        walk(r["id"])
    return depth, deps


def place(res):
    """{id: (x, y)}, columns by depth; within a column, ordered by the mean row of the prerequisites."""
    depth, deps = layers(res)
    order = {r["id"]: k for k, r in enumerate(res)}
    cols = {}
    for r in res:
        cols.setdefault(depth[r["id"]], []).append(r["id"])
    row = {}
    for c in sorted(cols):
        def key(i):
            ps = [row[d] for d in deps[i] if d in row]
            return (sum(ps) / len(ps) if ps else order[i], order[i])
        cols[c].sort(key=key)
        for k, i in enumerate(cols[c]):
            row[i] = k
    tallest = max(len(v) for v in cols.values())
    pos = {}
    for c, ids in cols.items():
        top = PAD + (tallest - len(ids)) * (H + GY) / 2
        for k, i in enumerate(ids):
            pos[i] = (PAD + c * (W + GX), top + k * (H + GY))
    return pos, deps, (len(cols), tallest)


def clip(s, n):
    s = " ".join(str(s or "").split())
    return s if len(s) <= n else s[:n - 1].rstrip() + "…"


def tag(r, issues):
    v = r.get("verdict", "UNFINISHED")
    if v == "ISSUE":
        own = [b for b in S.as_list(r.get("issues")) if b in issues]
        codes = sorted({c for b in own for c in issues[b]["codes"]})
        return "issue " + ", ".join(S.as_list(r.get("issues"))) + (f" ({', '.join(codes)})" if codes else "")
    if v == "UNFINISHED":
        return "stopped: " + (r.get("reason") or r.get("stage") or "not started")
    n = len(S.as_list(r.get("conditions")))
    if v == "CONDITIONAL":
        return f"{n} condition{'s' if n != 1 else ''}" if n else "conditional"
    return "no conditions"


def node_data(data, r, used_by, issues, tools, out_dir):
    lean_main = r.get("lean_main") or ""
    path = lean_main.split()[0].split(":")[0] if lean_main else ""
    link = os.path.relpath(str(S.ROOT / path), str(out_dir)) if path and (S.ROOT / path).exists() else ""
    conds = []
    for c in S.as_list(r.get("conditions")):
        t = tools.get(c, {})
        hc = t.get("human_checked") if isinstance(t.get("human_checked"), dict) else None
        conds.append({"id": c, "meaning": t.get("meaning", ""), "kind": PROVENANCE.get(t.get("provenance"), ""),
                      "source": t.get("source_loc", ""), "lean": t.get("lean", ""),
                      "checked": f"checked by {hc.get('by', '?')} ({hc.get('date', '')}): {hc.get('how', '')}"
                      if hc else ""})
    hist = r.get("history") if isinstance(r.get("history"), list) else []
    prev = hist[-1] if hist else None
    return {
        "id": r["id"], "kind": r.get("kind", ""), "number": r.get("pdf_number", ""), "title": r.get("title", ""),
        "verdict": r.get("verdict", "UNFINISHED"), "verdict_name": S.EN.get(r.get("verdict"), r.get("verdict")),
        "meaning": MEANING.get(r.get("verdict"), ""), "person": S.all_checked(data, r),
        "stage": r.get("stage", ""), "reason": r.get("reason", ""), "partial": r.get("partial") or "",
        "summary": r.get("summary_en", ""), "statement": r.get("statement_loc", ""), "proof": r.get("proof_loc", ""),
        "lean": lean_main, "link": link, "uses": S.as_list(r.get("depends_on")), "used_by": used_by,
        "conditions": conds, "debts": [str(x) for x in S.as_list(r.get("debts"))],
        "unencoded": [str(x) for x in S.as_list(r.get("unencoded"))],
        "issues": [issues.get(b, {"id": b}) for b in S.as_list(r.get("issues"))],
        "upstream": [issues.get(b, {"id": b}) for b in S.as_list(r.get("upstream_issues"))],
        "previous": f"before revision {prev.get('revision')}: {S.EN.get(prev.get('verdict'), prev.get('verdict'))}"
                    if prev else "",
        "recheck": r["recheck"].get("kind", "pending") if isinstance(r.get("recheck"), dict) else "",
    }


def svg(res, pos, deps, size, issues):
    cols, rows = size
    width = PAD * 2 + cols * W + (cols - 1) * GX
    height = PAD * 2 + rows * H + (rows - 1) * GY
    out = [f'<svg id="graph" viewBox="0 0 {width} {height}" width="{width}" height="{height}" role="group" '
           f'aria-label="Dependency graph of the numbered results">',
           '<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" '
           'orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" class="arrowhead"/></marker>'
           '<marker id="arrow-lit" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" '
           'orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" class="arrowhead lit"/></marker></defs>']
    for r in res:
        x2, y2 = pos[r["id"]]
        for d in deps[r["id"]]:
            x1, y1 = pos[d]
            a, b = (x1 + W, y1 + H / 2), (x2, y2 + H / 2)
            mid = (a[0] + b[0]) / 2
            out.append(f'<path class="edge" data-from="{html.escape(d)}" data-to="{html.escape(r["id"])}" '
                       f'd="M{a[0]:.1f},{a[1]:.1f} C{mid:.1f},{a[1]:.1f} {mid:.1f},{b[1]:.1f} {b[0]:.1f},{b[1]:.1f}" '
                       f'marker-end="url(#arrow)"/>')
    for r in res:
        x, y = pos[r["id"]]
        v = r.get("verdict", "UNFINISHED")
        head = " ".join(x for x in [r.get("kind", ""), str(r.get("pdf_number") or "")] if x) or r["id"]
        full = f'{head} ({r["id"]}): {r.get("title", "")} — {S.EN.get(v, v)}'
        out.append(f'<g class="node {v.lower()}" data-id="{html.escape(r["id"])}" tabindex="0" role="button" '
                   f'aria-label="{html.escape(full)}" transform="translate({x:.1f},{y:.1f})">'
                   f'<title>{html.escape(full)}</title>'
                   f'<rect width="{W}" height="{H}" rx="8"/><rect class="band" width="6" height="{H}" rx="3"/>'
                   f'<text x="16" y="20" class="head">{html.escape(clip(head, 22))} '
                   f'<tspan class="rid">{html.escape(r["id"])}</tspan></text>'
                   f'<text x="16" y="37" class="sub">{html.escape(clip(r.get("title"), 32))}</text>'
                   f'<text x="16" y="53" class="tag">{html.escape(clip(tag(r, issues), 33))}</text></g>')
    out.append("</svg>")
    return "\n".join(out)


def page(data, out_file):
    res = [r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")]
    issues = {b["id"]: b for b in S.blocker_details()}
    tools = {t.get("id"): t for t in data.get("external_tools", []) if isinstance(t, dict)}
    used_by = {r["id"]: [] for r in res}
    for r in res:
        for d in S.as_list(r.get("depends_on")):
            if d in used_by:
                used_by[d].append(r["id"])
    nodes = [node_data(data, r, used_by[r["id"]], issues, tools, out_file.parent) for r in res]
    counts = {v: sum(1 for r in res if r.get("verdict", "UNFINISHED") == v) for v in S.VERDICTS}
    paper = data.get("paper", {}) or {}
    lean = data.get("lean", {}) or {}
    meta = {"title": paper.get("title") or "Untitled paper", "main": paper.get("main_tex", ""),
            "kit": kit_version(), "made": datetime.now().strftime("%Y-%m-%d %H:%M"),
            "toolchain": lean.get("toolchain", ""), "mathlib": lean.get("mathlib_rev", ""),
            "counts": counts, "names": COUNTED, "total": len(res)}
    graph = svg(res, *place(res), issues) if res else '<p class="empty">No numbered results are recorded yet.</p>'
    blob = json.dumps({"meta": meta, "nodes": nodes}, ensure_ascii=False).replace("</", "<\\/")
    return TEMPLATE.replace("__TITLE__", html.escape(meta["title"])).replace("__GRAPH__", graph) \
                   .replace("__DATA__", blob)


TEMPLATE = r"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Verification graph: __TITLE__</title>
<style>
:root {
  --bg: #ffffff; --fg: #1f2328; --muted: #59636e; --line: #d1d9e0; --panel: #f6f8fa; --edge: #8c959f;
  --unc: #1a7f37; --unc-bg: #dafbe1; --con: #0969da; --con-bg: #ddf4ff;
  --iss: #cf222e; --iss-bg: #ffebe9; --unf: #6e7781; --unf-bg: #eff2f5; --focus: #bf8700;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #0d1117; --fg: #e6edf3; --muted: #9198a1; --line: #3d444d; --panel: #151b23; --edge: #6e7681;
    --unc: #3fb950; --unc-bg: #12261e; --con: #4493f8; --con-bg: #121d2f;
    --iss: #f85149; --iss-bg: #2d1214; --unf: #9198a1; --unf-bg: #1c2128; --focus: #d29922;
  }
}
* { box-sizing: border-box; }
body { margin: 0; background: var(--bg); color: var(--fg);
       font: 15px/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif; }
header, main, footer { max-width: 1200px; margin: 0 auto; padding: 0 16px; }
header { padding-top: 24px; }
h1 { font-size: 22px; margin: 0 0 4px; }
h2 { font-size: 17px; margin: 28px 0 8px; }
.meta { color: var(--muted); font-size: 13px; margin: 0; }
.counts { display: flex; flex-wrap: wrap; gap: 8px; margin: 14px 0 6px; padding: 0; list-style: none; }
.counts li { border: 1px solid var(--line); border-left: 6px solid var(--c); border-radius: 6px; padding: 4px 10px;
             background: var(--bgc); font-size: 14px; }
.counts b { font-variant-numeric: tabular-nums; }
.hint { color: var(--muted); font-size: 13px; margin: 6px 0 0; }
.layout { display: grid; grid-template-columns: minmax(0, 1fr) 360px; gap: 16px; align-items: start; }
@media (max-width: 900px) { .layout { grid-template-columns: minmax(0, 1fr); } }
.canvas { overflow: auto; border: 1px solid var(--line); border-radius: 8px; background: var(--panel);
          max-height: 75vh; }
#panel { border: 1px solid var(--line); border-radius: 8px; padding: 14px 16px; background: var(--bg);
         position: sticky; top: 12px; max-height: calc(100vh - 24px); overflow: auto; }
#panel h3 { font-size: 16px; margin: 0 0 2px; }
#panel .verdict { display: inline-block; font-weight: 600; padding: 1px 8px; border-radius: 10px; margin: 6px 0;
                  color: var(--c); background: var(--bgc); border: 1px solid var(--c); font-size: 13px; }
#panel dl { margin: 8px 0 0; }
#panel dt { font-weight: 600; font-size: 13px; color: var(--muted); margin-top: 10px; }
#panel dd { margin: 2px 0 0; overflow-wrap: anywhere; }
#panel ul { margin: 2px 0 0; padding-left: 18px; }
#panel li { margin: 3px 0; }
button.link { all: unset; color: var(--con); cursor: pointer; text-decoration: underline; }
button.link:focus-visible { outline: 2px solid var(--focus); }
code { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size: 12.5px; }
a { color: var(--con); }
.unconditional { --c: var(--unc); --bgc: var(--unc-bg); }
.conditional { --c: var(--con); --bgc: var(--con-bg); }
.issue { --c: var(--iss); --bgc: var(--iss-bg); }
.unfinished { --c: var(--unf); --bgc: var(--unf-bg); }
svg { display: block; font-family: inherit; }
.edge { fill: none; stroke: var(--edge); stroke-width: 1.5; }
.arrowhead { fill: var(--edge); }
.arrowhead.lit { fill: var(--focus); }
.edge.lit { stroke: var(--focus); stroke-width: 2.5; }
.node { cursor: pointer; outline: none; }
.node rect { fill: var(--bgc); stroke: var(--c); stroke-width: 1.5; }
.node rect.band { fill: var(--c); stroke: none; }
.node text { fill: var(--fg); font-size: 13px; }
.node .head { font-weight: 600; }
.node .rid, .node .tag { fill: var(--muted); font-size: 11.5px; font-weight: 400; }
.node .sub { font-size: 12.5px; }
.node.dim { opacity: .35; }
.node.sel rect:first-of-type, .node:focus-visible rect:first-of-type { stroke: var(--focus); stroke-width: 3; }
table { border-collapse: collapse; width: 100%; font-size: 14px; }
th, td { border-bottom: 1px solid var(--line); padding: 6px 8px; text-align: left; vertical-align: top; }
th { color: var(--muted); font-weight: 600; }
td.v { white-space: nowrap; font-weight: 600; color: var(--c); }
.tablewrap { overflow-x: auto; }
.empty { padding: 24px; color: var(--muted); }
footer { color: var(--muted); font-size: 13px; padding-top: 24px; padding-bottom: 32px; }
</style>
</head>
<body>
<header>
  <h1 id="title"></h1>
  <p class="meta" id="meta"></p>
  <ul class="counts" id="counts"></ul>
  <p class="hint">Arrows run from a result to the results whose proofs use it. Select a box (or focus it and press
  Enter) to see its details; press Escape to clear.</p>
</header>
<main>
  <div class="layout">
    <div class="canvas">__GRAPH__</div>
    <aside id="panel" aria-live="polite"><p class="hint">Select a result to see its verdict, its place in the
    paper, its Lean theorem, its conditions and its issues.</p></aside>
  </div>
  <h2>All results</h2>
  <div class="tablewrap"><table id="list"><thead><tr><th>No.</th><th>Result</th><th>Title</th><th>Verdict</th>
  <th>Conditions, issues, or where it stopped</th></tr></thead><tbody></tbody></table></div>
</main>
<footer id="foot"></footer>
<script type="application/json" id="data">__DATA__</script>
<script>
(function () {
  "use strict";
  var D = JSON.parse(document.getElementById("data").textContent);
  var M = D.meta, byId = {};
  D.nodes.forEach(function (n) { byId[n.id] = n; });
  function el(tag, cls, text) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (text !== undefined && text !== null) e.textContent = text;
    return e;
  }
  function label(n) { return [n.kind, n.number].filter(Boolean).join(" ") || n.id; }
  document.getElementById("title").textContent = M.title;
  var meta = M.total + " numbered results · made " + M.made + " · KAPPA " + M.kit;
  if (M.toolchain) meta += " · " + M.toolchain.replace("leanprover/lean4:", "Lean ");
  if (M.mathlib) meta += " · Mathlib " + M.mathlib.slice(0, 8);
  document.getElementById("meta").textContent = meta;
  var counts = document.getElementById("counts");
  ["UNCONDITIONAL", "CONDITIONAL", "ISSUE", "UNFINISHED"].forEach(function (v) {
    var li = el("li", v.toLowerCase());
    li.appendChild(el("b", null, String(M.counts[v] || 0)));
    li.appendChild(document.createTextNode(" " + M.names[v]));
    counts.appendChild(li);
  });
  document.getElementById("foot").textContent = "Made by scripts/pv_graph.py from verification/RESULTS.json and " +
    "verification/BLOCKERS.md, without a language model. The Lean kernel checked the proofs; a person still has " +
    "to check the conditions and that each Lean statement says what the paper says.";

  function issueText(b) {
    var s = b.id + (b.codes && b.codes.length ? " (" + b.codes.join(", ") + ")" : "");
    if (b.open === false) s += ", resolved";
    if (b.sentence) s += ": " + b.sentence;
    return s;
  }
  function add(dl, term, value) {
    if (!value || (Array.isArray(value) && !value.length)) return;
    dl.appendChild(el("dt", null, term));
    var dd = el("dd");
    if (Array.isArray(value)) {
      var ul = el("ul");
      value.forEach(function (v) { var li = el("li"); li.appendChild(v instanceof Node ? v : el("span", null, v)); ul.appendChild(li); });
      dd.appendChild(ul);
    } else if (value instanceof Node) dd.appendChild(value);
    else dd.textContent = value;
    dl.appendChild(dd);
  }
  function jump(id) {
    var b = el("button", "link", label(byId[id] || {id: id}) + " (" + id + ")");
    b.type = "button";
    b.addEventListener("click", function () { select(id, true); });
    return b;
  }
  function show(n) {
    var p = document.getElementById("panel");
    p.textContent = "";
    p.className = n.verdict.toLowerCase();
    p.appendChild(el("h3", null, label(n) + " (" + n.id + ")"));
    if (n.title) p.appendChild(el("div", null, n.title));
    p.appendChild(el("span", "verdict", n.verdict_name + (n.person ? "; conditions checked by a person" : "")));
    p.appendChild(el("div", "hint", n.meaning));
    var dl = el("dl");
    add(dl, "Summary", n.summary);
    if (n.verdict === "UNFINISHED") add(dl, "Where it stopped", [n.stage, n.reason, n.partial].filter(Boolean).join(" · "));
    add(dl, "Re-check", n.recheck ? "pending (" + n.recheck + "): a result it uses was revised" : "");
    add(dl, "Previous verdict", n.previous);
    add(dl, "In the paper", [n.statement ? "statement: " + n.statement : "", n.proof ? "proof: " + n.proof : ""].filter(Boolean));
    if (n.lean) {
      var c = el("code", null, n.lean), box = el("span");
      if (n.link) { var a = el("a"); a.href = n.link; a.appendChild(c); box.appendChild(a); } else box.appendChild(c);
      add(dl, "Lean theorem", box);
    }
    add(dl, "Conditions (named hypotheses)", n.conditions.map(function (k) {
      var s = el("span");
      s.appendChild(el("code", null, k.id));
      var t = [k.meaning, k.kind ? "(" + k.kind + ")" : "", k.source ? "source: " + k.source : ""].filter(Boolean).join(" ");
      if (t) s.appendChild(document.createTextNode(": " + t));
      if (k.checked) s.appendChild(el("div", "hint", k.checked));
      return s;
    }));
    add(dl, "Recorded debts", n.debts);
    add(dl, "Not encoded", n.unencoded);
    add(dl, "Issues", n.issues.map(issueText));
    add(dl, "Issues of results it uses", n.upstream.map(issueText));
    add(dl, "Uses", n.uses.map(jump));
    add(dl, "Used by", n.used_by.map(jump));
    p.appendChild(dl);
  }
  var nodes = Array.prototype.slice.call(document.querySelectorAll(".node"));
  var edges = Array.prototype.slice.call(document.querySelectorAll(".edge"));
  function related(id) {
    var keep = {}; keep[id] = true;
    function up(i) { (byId[i] ? byId[i].uses : []).forEach(function (d) { if (!keep[d]) { keep[d] = true; up(d); } }); }
    function down(i) { (byId[i] ? byId[i].used_by : []).forEach(function (d) { if (!keep[d]) { keep[d] = true; down(d); } }); }
    up(id); down(id);
    return keep;
  }
  function select(id, focus) {
    var keep = id ? related(id) : null;
    nodes.forEach(function (g) {
      var i = g.getAttribute("data-id");
      g.classList.toggle("sel", i === id);
      g.classList.toggle("dim", !!keep && !keep[i]);
      if (i === id && focus) { g.focus(); g.scrollIntoView({block: "nearest", inline: "nearest"}); }
    });
    edges.forEach(function (e) {
      var lit = !!keep && !!keep[e.getAttribute("data-from")] && !!keep[e.getAttribute("data-to")];
      e.classList.toggle("lit", lit);
      e.setAttribute("marker-end", lit ? "url(#arrow-lit)" : "url(#arrow)");
    });
    if (id && byId[id]) show(byId[id]);
  }
  nodes.forEach(function (g) {
    var id = g.getAttribute("data-id");
    g.addEventListener("click", function () { select(id); });
    g.addEventListener("keydown", function (e) { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); select(id); } });
  });
  document.addEventListener("keydown", function (e) { if (e.key === "Escape") select(null); });
  function fromHash() { var h = decodeURIComponent(location.hash.slice(1)); if (h && byId[h]) select(h); }
  window.addEventListener("hashchange", fromHash);

  var tbody = document.querySelector("#list tbody");
  D.nodes.forEach(function (n) {
    var tr = el("tr", n.verdict.toLowerCase());
    tr.appendChild(el("td", null, n.number));
    var td = el("td"); td.appendChild(jump(n.id)); tr.appendChild(td);
    tr.appendChild(el("td", null, n.title));
    tr.appendChild(el("td", "v", n.verdict_name + (n.person ? "; conditions checked by a person" : "")));
    var bits = [];
    if (n.conditions.length) bits.push("conditions: " + n.conditions.map(function (k) { return k.id; }).join(", "));
    if (n.issues.length) bits.push("issues: " + n.issues.map(function (b) { return b.id; }).join(", "));
    if (n.upstream.length) bits.push("issues of results it uses: " + n.upstream.map(function (b) { return b.id; }).join(", "));
    if (n.verdict === "UNFINISHED") bits.push("stopped: " + [n.stage, n.reason].filter(Boolean).join(" "));
    tr.appendChild(el("td", null, n.summary || bits.join("; ")));
    tbody.appendChild(tr);
  });
  fromHash();
})();
</script>
</body>
</html>
"""


def main():
    ap = argparse.ArgumentParser(description="Write the verification graph as a self-contained web page.")
    ap.add_argument("--out", default=str(OUT), help="output file (default: verification/report/VERIFICATION_GRAPH.html)")
    a = ap.parse_args()
    out = Path(a.out)
    if not out.is_absolute():
        out = Path.cwd() / out
    data = S.load()
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(page(data, out), encoding="utf-8")
    n = len([r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")])
    try:
        shown = out.relative_to(S.ROOT)
    except ValueError:
        shown = out
    print(f"GRAPH {shown} ({n} results); open it in a browser")


if __name__ == "__main__":
    main()
