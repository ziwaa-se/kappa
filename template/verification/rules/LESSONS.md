# Known pitfalls

Problems that come up in faithful checking. Every role should know them. Agents cite the items by number (for example "LESSONS 10"), so keep the numbering.

## Mathematics and verdicts

1. **"mathlib does not have this interface" is often wrong.**
   - Interfaces that seem to be missing often exist under an unexpected name or in an unexpected module.
   - Any claim that something "does not exist" must come with `#check` or search evidence.
2. **A lemma in general form can be false while the instance actually used is true.**
   - For example, a lemma printed for an arbitrary function can fail for a constant one, while the results downstream apply it only to a specific function for which it holds.
   - Downstream results are then unaffected.
   - A verdict must spell out "false for what, credible for what".
3. **A suggested fix can itself be wrong.**
   - Adding a plausible condition (for example "non-degenerate") does not necessarily rescue a false statement; check it against the counterexample.
   - Suggestions must be checked before they go into the report to the author.
4. **The scope of an issue must be precise.**
   - A defect that occurs only in some cases (for example only for higher derivative orders) must not be reported as affecting a result that never uses those cases.
   - Conversely, check whether a result uses those cases in some branch of its proof.
   - Stating the scope too broadly and stating it too narrowly are both errors.
5. **"The justification fails" and "an exposition gap" are two different things.**
   - If the reason given for a step is false but the step itself is true, record `PAPER_ARGUMENT_GAP` (mild), not `EXPOSITION_GAP`.
6. **A better argument constructed by the reviewer** may serve only as a suggestion to the author; it must not be used to patch the verification.
7. **For "verified conditionally", distinguish the sources of the conditions.**
   - well-known theorems from the literature are low risk;
   - "a clause of the paper's own lemma, where that lemma's proof has a problem" is high risk.
   - The report must list the latter separately, as the class most in need of human check.

## Formalization and tools

8. **Text search gives false positives.**
   - the text "sorryAx" in a docstring ends up in the `.olean`;
   - some shells alias `grep` to a tool that skips binary files while `xargs grep` does not, so results can be inconsistent.
   - Always use `#pv_axioms` / `#pv_walk`.
9. **A walk may stop at an interface only if that interface was fully audited.**
   - Stopping at an interface whose final audit did not review, one by one, the earlier theorems it consumes leaves those theorems unchecked.
   - Rule: a walk may stop only at an interface where "every consumed theorem has its own individual PASS record".
10. **The gate can be wrong too.**
    - A step obligation missing a needed premise (for example a positivity condition on a parameter) can look "true as stated" and only fail to be derivable at the final audit.
    - Amendments must be approved in advance and disclosed in the report as formalization-side corrections; they **do not count as paper issues**.
11. **Changing a docstring changes the `.olean` hash.**
    - Record comment errors in reviewed files in `DOC_ERRATA.md`; do not edit the files directly.
12. **Drafts containing `sorry` do not produce an `.olean`**; otherwise downstream might use it by mistake.
13. **Decide whether a statement changed by comparing `#pv_type_hashes`**, not by eye.

## Process and coordination

14. **The coordinator makes mistakes**, and subagents or the fact check must catch them. Typical ones:
    - a macro copied wrongly into a task brief;
    - usable lemmas listed wrongly, causing a route deviation;
    - wrong claims about the tools (for example that changing a docstring does not affect the `.olean`);
    - estimated timestamps;
    - factual errors in the first draft of the final report.

    **Any summary written by the coordinator must go through an independent fact check.**
15. **A quota interruption kills subagents.**
    - Require all reports to be **written incrementally**;
    - when resuming, first check the partial work; continue it if possible (SendMessage to the original agent), and start over only if it cannot be continued.
16. **No downloads.**
    - Downloading a source without the user's permission is a violation; anything obtained from it counts as unverified, and the violation must be disclosed.
    - Every task brief must state "no downloads, no network access".
17. **Records can contradict each other**: stale status fields, closed issues not marked as closed, a row missing a dependency.
    - Do a consistency check before the final report.
18. **During inventory, list the things that "the paper never states but the proof silently uses"**, for example extending an identity from smooth test functions to less regular ones. These are the easiest to overlook.
