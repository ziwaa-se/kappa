# Audit log

After each gate report, final audit report, issue ruling and counterexample audit is complete, the coordinator appends a section here. Each section states:
- the reviewer (subagent role) and the date (`date`);
- the path and sha256 of the reviewed artifact;
- the compilation result (the real `EXIT=`, the log path);
- the overall verdict and the suggested verdict (one of the four);
- the conditions and where they are used;
- the FAIL items and how they were handled;
- the assessment of the source.
