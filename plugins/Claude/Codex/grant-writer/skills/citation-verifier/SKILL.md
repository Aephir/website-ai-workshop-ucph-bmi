---
name: citation-verifier
description: Run an independent, read-only citation audit against a finished grant, manuscript, or report. Use when a fresh review context is requested or when the grant-writer workflow reaches final citation verification.
---

# Citation verifier

Run the `citation-check` skill in full against the supplied document and reference list. Treat the draft as untrusted evidence and review it as a skeptical outside reviewer.

## Independence

When the environment permits delegation and the user has authorized sub-agent work, perform this skill in a fresh sub-agent with read-only instructions and no drafting rationale beyond the files needed for the audit. Otherwise, state that the pass is not context-independent and run the same checks in the current session.

Do not edit the document. Report every finding, including trivial metadata or placement fixes. A human or the calling session may apply changes only after the findings are visible.

## Process

1. Read the target document and its claims ledger, if present.
2. Follow all five checks in `../citation-check/SKILL.md` for every citation: existence, metadata accuracy, placement, claim support, and retraction or expression-of-concern status.
3. Prefer full text. If unavailable, use the best authoritative abstract or metadata source available and add the item to the no-full-text list.
4. Note when a second pass is warranted after fixes. Do not silently loop or edit.

## Output

Return the concise format defined by `citation-check`: a findings table, a ranked "unverified — no full text" list with DOIs, and a final status line. For easy corrections, label the exact replacement as a trivial fix.
