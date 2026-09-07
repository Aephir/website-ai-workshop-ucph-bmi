#!/usr/bin/env python3
"""Fast, deterministic sweep for banned AI-slop phrases.

This is the cheap, always-on floor described in ai-slop-check's SKILL.md —
it catches single-phrase tells (hyperbole, empty signaling phrases) the
instant they're written, for free, without waiting for someone to remember
to run the ai-slop-check skill's full pass. It cannot do that skill's
redundancy or rhythm checks, which need actual reading comprehension, not
pattern matching — this script only ever tells you a phrase from the list
appeared; it never tells you a document is otherwise fine.

Pass a Markdown file path as the first argument. The script skips anything
that isn't a markdown draft (and explicitly skips the
tracking files themselves — a phrase discussed inside decisions-log.md
while explaining a choice isn't a problem the way the same phrase in the
actual draft prose is), then greps the file against the phrase list bundled
in the ai-slop-check skill.

Exit code 2 means findings were detected; exit code 0 means no findings.
"""
import os
import re
import sys

# Files this sweep intentionally does not scan — the tracking files
# themselves are meant to name and discuss claims, choices, and phrasing,
# so a banned phrase appearing inside a *description* of a problem isn't
# the same as one appearing in submitted prose.
SKIP_BASENAMES = {
    "claims-ledger.md",
    "decisions-log.md",
    "gaps.md",
    "ai-use-log.md",
    "banned-phrases.md",  # the list itself, obviously
}


def find_phrase_list_path():
    """Locate the bundled phrase list relative to the plugin root.

    Resolve relative to this script so the command works from any project.
    """
    here = os.path.dirname(os.path.abspath(__file__))
    candidates = [os.path.normpath(os.path.join(
        here, "..", "skills", "ai-slop-check", "references", "banned-phrases.md"
    ))]
    for c in candidates:
        if os.path.isfile(c):
            return c
    return None


def load_phrases(list_path):
    """Extract quoted phrases from banned-phrases.md's bullet lists.

    The reference file is written as markdown bullets with the phrase in
    double quotes, e.g. `- "it is widely recognized that…"`. This pulls
    every quoted string rather than trying to fully parse the markdown,
    which keeps this script from breaking if the reference file's prose
    around the bullets changes.
    """
    with open(list_path, "r", encoding="utf-8") as f:
        text = f.read()
    phrases = re.findall(r'"([^"]{3,80})"', text)
    # Normalize: strip trailing ellipsis/punctuation used for readability
    # in the reference file, and drop anything too short to be meaningful.
    cleaned = []
    for p in phrases:
        p = p.strip().rstrip("…").strip()
        if len(p) >= 4:
            cleaned.append(p)
    return sorted(set(cleaned), key=len, reverse=True)


def main():
    file_path = sys.argv[1] if len(sys.argv) > 1 else None
    if not file_path or not os.path.isfile(file_path):
        print("Usage: phrase_sweep.py path/to/draft.md", file=sys.stderr)
        sys.exit(1)

    if os.path.basename(file_path) in SKIP_BASENAMES:
        sys.exit(0)
    if not file_path.endswith(".md"):
        sys.exit(0)

    list_path = find_phrase_list_path()
    if not list_path:
        sys.exit(0)  # list not found — fail open rather than error noisily

    phrases = load_phrases(list_path)
    if not phrases:
        sys.exit(0)

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    hits = []
    for phrase in phrases:
        pattern = re.compile(re.escape(phrase), re.IGNORECASE)
        for m in pattern.finditer(content):
            line_no = content.count("\n", 0, m.start()) + 1
            hits.append((line_no, phrase))
            if len(hits) >= 25:  # cap — this is a floor, not the full audit
                break
        if len(hits) >= 25:
            break

    if not hits:
        sys.exit(0)

    hits.sort()
    lines = [f"Phrase sweep flagged {len(hits)} hit(s) in {os.path.basename(file_path)}:"]
    for line_no, phrase in hits[:15]:
        lines.append(f'  line {line_no}: "{phrase}"')
    if len(hits) > 15:
        lines.append(f"  ...and {len(hits) - 15} more.")
    lines.append(
        "This is the mechanical floor only (single banned phrases) — it does not check "
        "redundancy across sections or sentence rhythm. Run the ai-slop-check skill for those "
        "before treating this document as final."
    )
    message = "\n".join(lines)

    print(message, file=sys.stderr)
    sys.exit(2)


if __name__ == "__main__":
    main()
