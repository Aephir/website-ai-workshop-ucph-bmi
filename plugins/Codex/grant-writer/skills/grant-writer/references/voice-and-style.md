# Voice and style — generic academic/funding-application register

This is the default register for a grant or funding application's narrative prose: confident, technical, hypothesis-first, no hedging, no marketing. It's closer to a methods-paper introduction than to a pitch deck. A program profile may layer a thin adjustment on top of this for a specific program's expected tone (a private foundation's letter of intent reads differently from an R01 Specific Aims page, which reads differently again from a national-fund project description) — but the base rules here don't change program to program, because they're really about what makes prose read as considered and specific versus generated and generic.

## Register

Write for a competent scientist or program officer who is *not* a specialist in the applicant's exact sub-field, unless the program profile says otherwise. A reviewer in this position needs to, from the narrative alone:

- Understand the problem in the first paragraph.
- Find the hypothesis (or, for non-hypothesis-driven programs, the central question) without hunting for it.
- Trace the logic of each part of the plan without re-reading.
- Judge feasibility without needing to consult appendices.

Sentences average 15-25 words; paragraphs average 4-6 sentences. Avoid both telegraphic fragments and 50-word sentences with four subordinate clauses. Use one spelling convention (US or UK) consistently within a single application — pick whichever matches the applicant's institution or the funder's own house style, and don't mix them.

## Things to do

**Lead with the assertion.** A paragraph's topic sentence should make its claim; the rest of the paragraph supports it. Reviewers scan — the topic sentence is often the only sentence they read closely on a first pass.

**Write hypotheses as falsifiable statements.** "X causes Y" is a hypothesis. "Investigating the role of X in Y" is a topic, not a hypothesis — a topic doesn't commit to anything a result could contradict.

**Quantify when possible.** "Macrophage infiltration" is vaguer, and less persuasive, than "CD11b+/CD86+ macrophage infiltration quantified by flow cytometry." Specificity reads as competence.

**Use the active voice for what the project will do.** "We will measure cytokine release in nerve homogenate" is stronger than "Cytokine release will be measured in nerve homogenate." Reserve the passive for describing established methods where the actor genuinely doesn't matter.

**Name people and link them to specific tasks.** "Dr. X will perform the in vivo behavioral testing in her established facility" is concrete. "In vivo behavioral testing will be performed by an experienced collaborator" tells the reviewer nothing they can evaluate.

**State what would falsify a claim, where the format allows it.** "If [the inactive control] produces the same effect as [the active intervention], the effect is not mechanism-dependent and this claim falls" is unusual in grant prose and reads as unusually rigorous specifically because it is.

**Define an acronym once, then use it consistently.** Don't redefine it later in the document, and don't switch back to the spelled-out form for variety — that variety reads as inconsistency, not style.

## Things to avoid — the actual AI-slop patterns

Cut these on sight. They cost characters and, more importantly, they're exactly the patterns that make prose read as generated rather than considered:

**Empty signaling phrases** — "It is widely recognized that…", "Significant progress has been made in recent years…", "Increasing evidence suggests…", "A growing body of literature indicates…", "It is important to note that…", "There is a critical need for…", "Despite extensive research…". If the claim that follows is true, it doesn't need a preface announcing that it's true. If the claim isn't directly supported, the preface is doing the work of laundering it past scrutiny.

**Hyperbole** — "revolutionary," "unprecedented," "paradigm-shifting," "transformative," "game-changing," "world-class," "cutting-edge," "innovative platform," "novel approach," "next-generation." Replace with the specific claim; let the reviewer form their own opinion of the magnitude. A reviewer who has read a thousand applications treats these words as a signal to read more skeptically, not more favorably.

**Defensive hedging** — "While our hypothesis may not be fully supported by all available data…". If contradicting evidence exists, address it directly and explain why the project is still worth doing. Don't pre-apologize for a weakness before a reviewer has even raised it.

**Marketing language generally.** A funding narrative is not a product page. If a sentence would work equally well in a startup's pitch deck, it's in the wrong register here.

**Aspirational scope beyond what the project can actually establish.** A modest, well-scoped project does not "fundamentally change our understanding" of anything. It tests a specific claim, in a specific system, with a specific set of experiments. Calibrate the stated ambition to match the actual work — a reviewer is more persuaded by a precise, bounded claim than a sweeping one, because the bounded claim is the one they can actually evaluate as credible.

**Citation density without payoff.** A sentence carrying five citations for one substantive claim is wasted space. Either consolidate to the single most representative citation, or split the claim across sentences so each citation supports something distinct.

**Uniform sentence and paragraph rhythm.** Real writing has variance — some short sentences, some longer ones, paragraphs of different lengths depending on how much a point needs. A document where every paragraph runs to almost exactly the same length, or every sentence opens the same grammatical way, reads as machine-generated even when every individual sentence is fine on its own. (A dedicated pass for this, plus for repeated points across sections, belongs to `ai-slop-check` — see the parent skill's `SKILL.md`.)

## Specific patterns

### Opening sentence of a problem/aims statement

Pattern: `[Problem] is [why it matters] primarily because [the gap].`

This frames the work in under 20 words and tells the reviewer immediately where the unmet need is, rather than making them wait for it.

### Topic sentence of a background paragraph

Pattern: `[Subject] [verb of the central claim] [object/specifics].`

Weak: "There is a complex relationship between SSTR4 signaling and inflammation." (This describes a topic, not a claim.)
Strong: "Genetic deletion of SSTR4 in mice increases inflammation and pain sensitivity (Helyes et al., 2009)." (This is a claim the rest of the paragraph can support.)

### Hypothesis statement

Pattern: `We hypothesize that [mechanism] [directly causes / partly mediates / is required for] [observed phenomenon].`

"In part through" and "is causally required for" are testable phrasings. "May involve" and "is associated with" are not — they're topics wearing a hypothesis's clothes.

### Method description

Pattern: `[model/system], [n or scale with relevant splits], [intervention/manipulation], [primary readout], [secondary readouts], [analysis approach].`

One paragraph per major study/aim/work-package, in this order. Reviewers generally don't need protocol-level detail (exact reagent concentrations, primer sequences) — they need to see the experimental shape and judge whether it's sound and feasible.

### Outcome/deliverable statement

Pattern: `[Concrete deliverable], [what it establishes or rules out].`

The deliverable is what the specific piece of work produces, not what the field gains from it — field-level implications belong in a dedicated impact/significance section, stated with the calibration rules above.

### Conflict-of-interest disclosure

One factual sentence is normally sufficient: what the relationship is, and why it doesn't compromise the independence of the proposed work. A longer disclosure than the situation warrants reads as anxious; a shorter one than the situation warrants reads as evasive. Match the length to what actually needs disclosing, no more.

## Calibration test

Read the finished draft and ask: would a competent reviewer who is not a specialist in this exact sub-field come away persuaded that the work is well-conceived, feasible, and worth funding over the large majority of applications that won't be? If a sentence is trying to flatter or impress rather than inform, recalibrate it. If a sentence makes a specific claim, backs it with a specific citation, and points toward a specific deliverable, the calibration is right.
