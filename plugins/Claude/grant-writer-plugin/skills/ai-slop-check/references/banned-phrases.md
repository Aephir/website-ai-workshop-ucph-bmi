# Default banned-phrase list — general English business/academic prose

This is the base list `ai-slop-check` scans against. It's deliberately generic — not tied to grant writing, a specific field, or a specific house style — because these patterns read as AI-generated (or just as tired writing) in almost any register. A caller can add to this list; see SKILL.md's "Extending the phrase list" section. Matching should be case-insensitive and should tolerate minor wording variants (e.g., "it is important to note," "it's important to note," "it should be noted that" are the same offense).

## Table of contents

- Empty signaling / throat-clearing phrases
- Hedging and defensive qualifiers
- Hyperbole and marketing language
- Generic transitions and conclusions
- Structural tells (not single phrases — patterns)

## Empty signaling / throat-clearing phrases

These announce that a claim is true instead of just making the claim. If the claim is true, the announcement is dead weight; if it isn't well-supported, the announcement is doing the work of smuggling it past scrutiny.

- "It is widely recognized that…"
- "It is important to note that…" / "It should be noted that…"
- "It is worth noting that…"
- "Significant progress has been made in recent years in the field of…"
- "Increasing evidence suggests…"
- "A growing body of literature indicates…"
- "There is a critical need for…"
- "Despite extensive research…"
- "Numerous studies have shown…" (without naming which)
- "Research has shown that…" (without naming which)
- "It goes without saying that…"
- "Needless to say…"
- "In today's fast-paced world…" / "In today's [anything]…"
- "As we all know…"

## Hedging and defensive qualifiers

Pre-apologizing for a weakness before anyone has raised it, or qualifying a claim into meaninglessness.

- "While our hypothesis may not be fully supported by all available data…"
- "may involve" / "may play a role in" / "could potentially" (when used to avoid committing to a testable claim, not when genuine uncertainty is being reported)
- "is associated with" (when the actual relationship being described is causal and known to be — don't let this phrase quietly launder a causal claim into a correlational one, or vice versa)
- "seems to suggest"
- "it could be argued that" (used to introduce an argument the writer isn't willing to actually make)
- Excessive "somewhat," "relatively," "fairly," "arguably" stacked in the same sentence

## Hyperbole and marketing language

Words a skeptical reader has learned to discount, or that belong in a pitch deck rather than a proposal, report, or analysis.

- "revolutionary" / "unprecedented" / "paradigm-shifting" / "transformative" / "game-changing" / "groundbreaking"
- "world-class" / "cutting-edge" / "state-of-the-art" (when not a precise technical claim)
- "innovative platform" / "novel approach" / "next-generation" / "best-in-class"
- "seamless" / "robust" (as filler rather than a specific, defensible technical property)
- "leverage" (as a verb meaning "use")
- "delve" / "delve into"
- "tapestry" / "rich tapestry"
- "navigate the landscape" / "in the realm of"
- "boundaries" (as in "pushing boundaries")
- "multifaceted" (as filler rather than a specific enumeration)
- "boasts" (as in "the system boasts...")

## Generic transitions and conclusions

Filler connective tissue that could be deleted from any document about any topic without losing anything specific to this one.

- "In conclusion," / "Overall," / "In summary," when what follows just restates the preceding paragraph rather than adding something
- "Moving forward," (as a transition rather than a genuine reference to future work)
- "That being said,"
- "At the end of the day,"
- "I hope this helps." / "Let me know if…" (in a document meant to stand alone, not a conversational reply)
- "Furthermore," / "Moreover," / "Additionally," stacked more than once or twice in a short span — each one individually is fine, but a paragraph that opens every sentence with one of these reads as list-with-connectors rather than argument

## Structural tells (patterns, not single phrases)

These require reading more than one sentence to catch — see `ai-slop-check`'s Pass 3 (rhythm check).

- Every paragraph in a section is close to the same length.
- Every sentence in a paragraph is close to the same length (a healthy paragraph mixes short and long).
- A rule-of-three list appears repeatedly across unrelated paragraphs ("X, Y, and Z" structure used as a crutch rather than because three items are genuinely the right count each time).
- "Not only X, but also Y" used more than once in a document.
- Every section's topic sentence uses the identical grammatical construction (e.g., every section opens with a gerund phrase, or every section opens by restating the section heading as a sentence).
