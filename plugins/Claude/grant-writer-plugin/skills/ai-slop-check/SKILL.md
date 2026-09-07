---
name: ai-slop-check
description: "Audit a drafted document for AI-writing tells and cross-section redundancy before it goes out — filler/hedging/hyperbole phrases, generic transitions, monotonous sentence rhythm, and the same point restated in multiple sections without adding anything."
---

# AI slop check

This skill finds two distinct failure modes in AI-assisted or AI-drafted prose: surface-level "AI writing tells" (stock phrases, hedges, hyperbole, filler transitions) and structural redundancy (the same substantive point restated in different sections without adding anything). Both make a document read as machine-generated even when the underlying content is sound, and both are easy for a human editor to miss because each individual sentence looks fine in isolation.

This skill does not check whether claims are true or whether citations are real — that is `citation-check`'s job. Run both on any document that cites sources; this one is blind to factual accuracy and only looks at how the prose is built.

## When to run this

Run it once a document (or a section) is drafted and before it is considered final — not mid-draft, since flagging phrasing before the content has settled wastes passes. If another skill is orchestrating a larger drafting workflow (grant writing, a report, long-form comms), it should invoke this skill as its own final-pass step, the same way it would invoke `citation-check`, rather than reimplementing phrase-matching or redundancy logic inline.

## What to do

1. **Read the whole document**, not excerpts. Redundancy detection specifically requires seeing all sections at once — a phrase-only sweep can be done section by section, but the redundancy pass cannot.

2. **Pass 1 — phrase and pattern sweep.** Read `references/banned-phrases.md` for the categorized default list (filler/signaling phrases, hedging, hyperbole and marketing language, generic transitions, and structural tells). Scan the document against it. For each hit, quote the offending phrase with its location (section/paragraph) and note the category. Do not silently rewrite — report findings first; rewriting is a separate, human-directed step unless the user has explicitly asked you to fix in place.

3. **Pass 2 — redundancy sweep.** For each paragraph, extract its core assertion in one line (a working index, not part of the output). Compare assertions across the whole document, including across sections that don't obviously overlap — redundancy most often hides between sections that serve different nominal purposes (e.g., a claim made in a background section reappears almost verbatim in a discussion or perspectives section). Flag a pair when the same substantive point is made twice with no new information, evidence, specificity, or function added the second time.

 Use this test before flagging: does the second instance add a new angle, a new piece of evidence, more specificity than the first, or serve a genuinely different rhetorical function (e.g., a claim introduced as a forward-looking hypothesis and later confirmed as a finding)? If yes, it is deliberate reinforcement of a load-bearing point and should not be flagged — some repetition is correct, especially for the one or two claims a document is actually built around. If no — it is the same sentence wearing different words — flag it as redundant and name both locations so the user can decide which to cut or how to merge them.

 Do not flag structural boilerplate that is supposed to repeat (a recurring template heading, a disclaimer, a defined term's expansion on first use elsewhere in a multi-document set).

4. **Pass 3 — rhythm check (optional, use when register matters, e.g. formal or academic documents).** Look for a tell that reads as machine-generated even without any banned phrase: uniform sentence length throughout, uniform paragraph length, or a repeated sentence-opening pattern (e.g., every paragraph opening with a topic sentence of the identical grammatical shape). Flag sections where this monotony is pronounced enough that a human reader would notice the cadence rather than the content.

5. **Report findings, don't auto-edit**, unless the user has asked for in-place fixes. For each finding: location, category (phrase / redundancy / rhythm), the exact offending text quoted, and — for redundancy — both locations involved. Group by severity: a hyperbole word is a one-word fix; a paragraph-length redundant restatement is a structural decision the author should make, not the skill.

## Extending the phrase list for a specific domain or house style

The default list in `references/banned-phrases.md` is general-purpose English business/academic prose. A calling skill or a specific user's house style may add its own banned terms (a company's marketing-speak blacklist, a funder's specific hyperbole aversions, a person's own known tics). When a caller supplies an additional list, treat it as additive to the default, not a replacement — the generic AI-tells still apply regardless of domain.

## What not to flag

- A phrase that would be a tell in isolation but is a defined term, a direct quotation, or a title (do not flag "Innovation" when it's literally the name of an NIH review criterion).
- Legitimate technical repetition — a method described once in detail and referred back to briefly elsewhere ("as described in Study 1") is efficient writing, not redundant.
- Short documents where a rhythm check would be reading noise into too small a sample — skip pass 3 below roughly 3-4 paragraphs.

## Output format

A flat findings list is sufficient for most uses:

```
### Phrase / pattern findings
1. [Hyperbole] "a revolutionary approach" — Section 2, paragraph 3
2. [Filler] "It is worth noting that patient adherence varies" — Section 4, paragraph 1

### Redundancy findings
1. The claim "SSTR4 activation reduces neuroinflammation" appears near-verbatim in Background (para 2) and again in Perspectives (para 1), with no new evidence or angle added the second time. Recommend cutting the Perspectives instance or replacing it with the forward-looking implication instead of restating the mechanism.

### Rhythm findings (if run)
1. Section 4: six consecutive paragraphs open with "Study N will..." — vary the opening construction or accept it as intentional template structure (it is, for numbered study blocks — likely not worth flagging here; use judgment).
```

If nothing of note is found in a pass, say so plainly rather than manufacturing minor findings to justify the pass.