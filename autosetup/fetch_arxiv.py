#!/usr/bin/env python3
"""fetch_arxiv.py — put the LaTeX source of an arXiv paper into a project's source/ folder (kit v1.5).

Usage: python3 autosetup/fetch_arxiv.py <arXiv id or URL> <project or folder> [--file E-PRINT]

  <arXiv id or URL>    2610.35596, 2610.35596v2, math/0601001v1, or an arxiv.org/abs/… or /pdf/… address. Without a
                       version, arXiv sends the latest one; give the version to get the one you mean.
  <project or folder>  a project made by install.sh or autosetup/new_project.sh (its source/ is used), or any other
                       folder. Files are written only there, and an existing file is never overwritten.
  --file E-PRINT       use an e-print file downloaded before, instead of downloading it

This script downloads the source from https://arxiv.org/e-print/<id>, so run it yourself, before the check. The
kit's agents never run it: they have no network access during a check. The archive is unpacked with care: only
regular files and folders, no absolute paths, no "..", no links, at most 500 MB in all. Nothing in it is run.

arXiv's source has no compiled PDF and usually no .aux. Add them to source/ if you have them: the .aux gives the
exact theorem numbers (autosetup/check_paper.py says what is still missing).
"""
import gzip
import io
import re
import sys
import tarfile
import urllib.error
import urllib.request
from pathlib import Path

MAX_BYTES = 500 * 1024 * 1024
NEW_ID = re.compile(r"^\d{4}\.\d{4,5}(v\d+)?$")
OLD_ID = re.compile(r"^[a-z][a-z.-]*(\.[A-Z]{2})?/\d{7}(v\d+)?$")


def kit_version():
    f = Path(__file__).resolve().parent.parent / "template" / "KIT_VERSION"
    return f.read_text().strip() if f.exists() else "?"


def parse_id(s):
    s = s.strip()
    m = re.search(r"arxiv\.org/(?:abs|pdf|e-print|src)/(.+?)(?:\.pdf)?/?(?:[?#].*)?$", s)
    if m:
        s = m.group(1)
    s = re.sub(r"^arXiv:", "", s, flags=re.I)
    if NEW_ID.match(s) or OLD_ID.match(s):
        return s
    sys.exit(f"not an arXiv identifier: {s!r} (examples: 2610.35596, 2610.35596v2, math/0601001)")


def target_dir(arg):
    d = Path(arg).expanduser()
    if (d / "KIT_VERSION").exists() or (d / "source").is_dir():
        d = d / "source"
    return d.resolve()


def download(aid):
    url = f"https://arxiv.org/e-print/{aid}"
    req = urllib.request.Request(url, headers={"User-Agent": f"KAPPA/{kit_version()} "
                                                             "(https://github.com/ziwaa-se/kappa)"})
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            data = r.read(MAX_BYTES + 1)
            name = re.search(r'filename="?([^";]+)', r.headers.get("Content-Disposition", "") or "")
    except urllib.error.HTTPError as e:
        sys.exit(f"arXiv answered {e.code} for {url}" + (": no such paper or version" if e.code == 404 else ""))
    except urllib.error.URLError as e:
        sys.exit(f"could not reach arXiv ({e.reason}); download {url} yourself and use --file")
    if len(data) > MAX_BYTES:
        sys.exit("the e-print is larger than 500 MB; not unpacked")
    return data, (name.group(1) if name else "")


def members(data):
    """[(relative path, bytes)] of the e-print: a (gzipped) tar archive, or one gzipped file."""
    if data[:4] == b"%PDF":
        sys.exit("arXiv has no LaTeX source for this paper, only a PDF")
    if data[:2] == b"\x1f\x8b":
        try:
            raw = gzip.GzipFile(fileobj=io.BytesIO(data)).read(MAX_BYTES + 1)
        except OSError as e:
            sys.exit(f"the e-print is not a valid gzip file: {e}")
        if len(raw) > MAX_BYTES:
            sys.exit("the unpacked e-print is larger than 500 MB; not unpacked")
    else:
        raw = data
    if raw[:4] == b"%PDF":
        sys.exit("arXiv has no LaTeX source for this paper, only a PDF")
    if raw.lstrip()[:15].lower().startswith((b"<!doctype html", b"<html")):
        sys.exit("arXiv sent a web page instead of a source file (withdrawn paper, or a wrong identifier?)")
    try:
        tar = tarfile.open(fileobj=io.BytesIO(raw), mode="r:*")
    except tarfile.TarError:
        return [("main.tex", raw)]          # a single-file submission
    out, total = [], 0
    for m in tar.getmembers():
        parts = Path(m.name).parts
        if m.name.startswith(("/", "\\")) or ".." in parts or re.match(r"^[A-Za-z]:", m.name):
            sys.exit(f"refused: the archive contains an unsafe path {m.name!r}")
        if m.isdir():
            continue
        if not m.isreg():
            sys.exit(f"refused: the archive contains a link or special file {m.name!r}")
        total += m.size
        if total > MAX_BYTES:
            sys.exit("the unpacked e-print is larger than 500 MB; not unpacked")
        rel = Path(*[p for p in parts if p not in ("", ".")])
        if str(rel) in (".", "") or rel.name == ".DS_Store" or rel.name.startswith("._") or "__MACOSX" in rel.parts:
            continue
        out.append((str(rel), tar.extractfile(m).read()))
    if not out:
        sys.exit("the archive is empty")
    return out


def main_files(dest, rels):
    found = []
    for rel in rels:
        if rel.endswith(".tex"):
            text = (dest / rel).read_text(errors="replace")
            if re.search(r"^[^%\n]*\\documentclass", text, flags=re.M):
                found.append(rel)
    return found


def main():
    args = sys.argv[1:]
    local = None
    if "--file" in args:
        k = args.index("--file")
        if k + 1 >= len(args):
            sys.exit(__doc__)
        local = Path(args[k + 1]).expanduser()
        del args[k:k + 2]
    if len(args) != 2:
        sys.exit(__doc__)
    aid = parse_id(args[0])
    dest = target_dir(args[1])
    if local:
        data, name = local.read_bytes(), local.name
    else:
        print(f"downloading https://arxiv.org/e-print/{aid} ...")
        data, name = download(aid)
    files = members(data)
    clash = [rel for rel, _ in files if (dest / rel).exists()]
    if clash:
        sys.exit(f"refused: these files already exist in {dest} and would be overwritten: {', '.join(clash[:10])}")
    for rel, blob in files:
        f = dest / rel
        dest.mkdir(parents=True, exist_ok=True)
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_bytes(blob)
    print(f"wrote {len(files)} file{'s' if len(files) != 1 else ''} of arXiv:{aid}" + (f" ({name})" if name else "") + f" into {dest}")
    mains = main_files(dest, [rel for rel, _ in files])
    if len(mains) == 1:
        print(f"main file: {mains[0]}")
    elif mains:
        print("files with \\documentclass (choose the main one): " + ", ".join(mains))
    else:
        print("no .tex file with \\documentclass was found; check the files")
    print(f"next: add the compiled PDF and .aux if you have them (arXiv's PDF: https://arxiv.org/pdf/{aid}), then "
          f"run python3 autosetup/check_paper.py on the project")


if __name__ == "__main__":
    main()
