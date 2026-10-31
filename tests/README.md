# Tests

Offline tests of the kit's scripts. They never contact a model or the network, and need only `bash` and Python 3.

```bash
python3 -m unittest discover -s tests
```

| File | What it covers |
|---|---|
| `test_drive.py` | the unattended driver end to end, against `fake_claude.py`, a scripted stand-in for the `claude` command: auto-resume after usage limits (reset-time parsing, fallback, limits on waits), the exit status and status file, reconnection as progress, report mode, refused kit commands, per-result session budgets, (v1.5) an infrastructure stop sent to the gate instead of a no-progress stop |
| `test_install.py` | `install.sh`, the suggested permission file (`pv_settings.py`), the Lean IO guard of `pv_lean.sh`, the rule cards |
| `test_guard.py` | the PreToolUse guard hook (`pv_guard.py`): writes outside the project, the coordinator's and the reviewers' limits, the write log |
| `test_status.py` | record keeping in `pv_status.py`: conditions from the audit's `CONDITIONS:` line, reconnected and duplicate external inputs, the generated evidence index, reset with archived files, the one-level cascade decided by gate snapshots, `set-deps`, `defs-changed`; (v1.5) results new in a revision, external inputs proved and connected later, infrastructure rulings, the report stamp |
| `test_usage.py` | `pv_usage.py`: the transcript estimate against the cost Claude Code reports |
| `test_legacy.py` | `autosetup/import_legacy.py` (copy, protection, history, revision brief; rebuild with Lean) |
| `test_example_tools.py` | the tools that publish example runs: `examples/tools/sanitize.py` (paths, user names, e-mail addresses) and `examples/tools/blind_audit.py` (no access to the answer key or the network) |
| `test_report_tools.py` | the tools made from the records without a model (v1.5): the verification graph (`pv_graph.py`), the one-page summary (`pv_summary.py`), the standalone Lean project (`pv_export.py`; with Lean: the exported files compile), and `autosetup/fetch_arxiv.py` offline (archives, single files, unsafe paths and links, no overwriting) |
| `test_mech_offline.py` | the parts of the mechanical audit that need no Lean (v1.5): the snapshot block of a gate report, the check that every Lake package is the pinned unmodified git checkout, and `pv_lean.sh module` (built, in the source but not built, absent) |
| `test_lean_integration.py` | the mechanical audit (`pv_audit_mech.py`) on real Lean files: conditions traced from the gated theorem, the writer and executor checks, (v1.5) the walk past compiler auxiliaries of a computable `def` and a gap fingerprint quoted outside the snapshot; the offline replay of a run (`examples/tools/replay.py`) |

**With Lean.** The tests that compile Lean files run only when `PV_TEST_LEAN_ENV` names a ready shared environment (`autosetup/lean_env.sh <base> --download` makes one in `<base>/lean-env`); otherwise they are skipped:

```bash
PV_TEST_LEAN_ENV=~/proofcheck/lean-env python3 -m unittest discover -s tests
```

`helpers.py` builds throwaway projects from `template/` in a temporary folder; nothing outside that folder is touched.
