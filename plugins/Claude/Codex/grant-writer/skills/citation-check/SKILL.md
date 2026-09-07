---
name: "citation-check"
description: "Verify that the citations/references in a document are trustworthy — each one exists, is cited with correct metadata, is placed next to the claim it actually belongs to, genuinely supports that claim, and hasn't been retracted. Use this whenever the user asks to check, verify, audit, or fact-check citations or a reference list, including phrasing like \"check my references\", \"are these citations legit\", \"verify this reference list\", \"fact-check the citations in this draft\", \"make sure the references in this grant/paper/manuscript hold up\", or when finalizing any document with citations before submission — even if the user doesn't use the word \"citation\" explicitly. Also use as a subroutine whenever another process needs to confirm a single citation actually grounds an argument (e.g., during an adversarial multi-agent review or fact-check). Works on a whole document or one citation on demand."
---

# Citation Check

## Requirements
Needs a reference-manager connector (built for Zotero) for library lookup and full-text retrieval — falls back to web/DOI lookup when unavailable. Benefits from subagent-spawning ability (e.g., an Agent or Task tool) for the iteration step in the Process section below; without it, the skill still works, just as a single pass instead of an iterating loop.

## Why this exists
A citation that doesn't exist, doesn't say what it's cited for, or has been retracted can quietly undermine an otherwise solid argument — and it's exactly the kind of error that's cheap to catch before submission and expensive after. This skill runs the check systematically, the way a domain expert doing due diligence would, rather than trusting that a citation is fine because it's formatted correctly.

Adopt the persona of a subject-matter expert with decades of experience in the document's field while doing this — the goal is a genuinely skeptical, well-informed read, not a mechanical formatting check.

## The five checks
For every reference in scope, run all five. Don't skip one because another looks fine — these fail independently. A citation can be perfectly formatted and still not support the claim it's attached to.

1. **Exists.** Look it up in the user's reference library first. If it's not there, don't assume it's fabricated — attempt external verification (DOI resolution, CrossRef, PubMed, or a web search on title/authors) before concluding anything. A reference that genuinely can't be found anywhere is a real, high-value finding; flag it clearly as unverified/possibly fabricated rather than silently dropping it.
2. **Cited correctly.** Authors, year, title, and journal/venue match the actual source.
3. **Placed correctly.** The citation sits next to the claim it's actually about, not a neighboring one it was never meant to support.
4. **Supports the claim.** Read the source and confirm it backs up what's being said. Prefer full text over an abstract — abstracts oversimplify, and a claim can look abstract-consistent while contradicting the actual findings.
   - **If full text isn't available**, don't stop and don't skip the check. Do the best you can with the abstract/metadata available, but also add the reference (by DOI) to a separate "unverified — no full text" list, ranked by how load-bearing it is to the document's argument (a reference propping up a central claim ranks above one supporting a minor aside). This list is informational, not a blocker — it lets the user decide afterward whether it's worth tracking down the full text themselves. Never let a missing PDF halt the run.
5. **Not retracted.** Check retraction / expression-of-concern status. A retracted paper cited as valid support is worth flagging even when everything else about the citation checks out.

## Process
1. Extract every reference in the document along with the specific claim or sentence it's attached to.
2. Run all five checks above for each reference.
3. Fix what can be fixed directly — wrong metadata, a misplaced citation. For anything needing human judgment (a claim that doesn't actually hold up, a reference that looks fabricated), flag it clearly rather than guessing at a fix.
4. If this pass found and fixed anything, hand off to a fresh agent instance with this exact same brief, and have it re-run the whole check from scratch on the corrected document. Use whatever subagent/fresh-instance mechanism is available in the current environment. A fresh instance matters here — an agent reviewing its own previous pass in the same context is prone to rubber-stamping it.
5. Repeat until a pass finds nothing new to fix, or 5 passes have run, whichever comes first. If the cap is hit while issues remain, stop and hand the remaining items to the user rather than continuing indefinitely — persistent disagreement after 5 rounds is itself useful information.

## Output
Always end with:
- A findings table: reference → issue found → fix applied, or flagged for human judgment
- The "unverified — no full text" list, ranked by importance, with DOIs
- A brief change log if this took more than one pass
- A final status line: clean, or capped out with N items remaining

Keep this short and scannable — a table, not an essay. The point is that the user can see at a glance what was wrong and what's still open.

## Modes
- **Whole document**: run the full process on every reference in the document.
- **Single citation**: when asked to check just one reference (e.g., invoked as a subroutine by another review process, such as an adversarial multi-agent debate that needs to verify a source before trusting an argument built on it), run the same five checks on that one reference and report the same way, scoped to it.

