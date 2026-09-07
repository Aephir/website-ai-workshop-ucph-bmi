#!/usr/bin/env python3
"""Check that claims-ledger.md entries have all required fields.

This exists because the self-review pass in grant-writer's
citation-protocol.md is a judgment-heavy LLM pass with a lot to hold in
mind at once (does every claim reconcile, is every confidence rating still
right) — it's easy for a purely mechanical thing, like a ledger entry
missing its Confidence line, to slip through unnoticed in the middle of
that. A script that checks the structural shape every time the file
changes can't miss it, because it isn't trying to hold anything else in
mind at the same time.

This only checks structure (are the required fields present), never
content (whether a claim is actually true, or whether a citation actually
supports it) — that's citation-check's / the citation-verifier agent's job,
which requires reading and judgment this script deliberately doesn't
attempt.
"""
import os
import re
import sys

REQUIRED_FIELDS = ["Claim", "Section", "Source", "Supporting sentence(s)", "Confidence"]


def main():
    file_path = sys.argv[1] if len(sys.argv) > 1 else None
    if not file_path or not os.path.isfile(file_path):
        print("Usage: check_ledger_format.py path/to/claims-ledger.md", file=sys.stderr)
        sys.exit(1)

    if os.path.basename(file_path) != "claims-ledger.md":
        sys.exit(0)

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Split into per-entry blocks on "## C###" headers.
    entries = re.split(r"(?m)^##\s+C\d+", content)[1:]
    entry_ids = re.findall(r"(?m)^##\s+(C\d+)", content)

    problems = []
    for entry_id, block in zip(entry_ids, entries):
        missing = [field for field in REQUIRED_FIELDS if f"**{field}:**" not in block]
        if missing:
            problems.append(f"{entry_id} is missing: {', '.join(missing)}")

    if not entry_ids:
        sys.exit(0)  # empty or not-yet-populated ledger — nothing to check yet

    if not problems:
        sys.exit(0)

    message = (
        f"claims-ledger.md structure check found {len(problems)} incomplete entr"
        + ("y" if len(problems) == 1 else "ies")
        + ":\n  " + "\n  ".join(problems)
        + "\nEvery entry needs all five fields (Claim, Section, Source, Supporting sentence(s), "
          "Confidence) — see the grant-writer skill's citation-protocol.md for the format. "
          "This is a structural check only; it says nothing about whether the citations "
          "themselves are correct."
    )

    print(message, file=sys.stderr)
    sys.exit(2)


if __name__ == "__main__":
    main()
