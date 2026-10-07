# pv_work/probes

One subdirectory per role: `drafter/`, `gate/`, `prover/`, `auditor/`, `issue/`. Below each, one directory per result: `<role>/<ID>/`. Probes are named `<role>_<ID>_<purpose>.lean`, and each role writes only to its own directory. Probes are not imported by any proof file.
