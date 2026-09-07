# Citation discipline — the claims-ledger protocol

The single biggest risk in AI-assisted academic or scientific grant writing is a fabricated or imprecise citation. A reviewer who spots a wrong PMID, a misattributed claim, or a paper that doesn't say what the application says it says doesn't just dock a point — they start reading the rest of the application looking for more of the same. For an early-career applicant that damage is durable. This protocol exists to make that failure mode mechanically difficult by requiring every factual claim in the draft to be traceable to a retrieved source, not a remembered one.

This file is funder-agnostic. It applies the same way whether the current program is a Danish national fund, an EU instrument, an NIH mechanism, or a private foundation grant — the only thing a program profile adds on top is *which citation style the funder expects*, not whether claims need sourcing.

## The rule

Every factual statement in the draft must fall into exactly one of these categories:

1. **Sourced.** Backed by a paper retrieved during this run (or supplied as input) whose abstract or full text is locally available. Logged in `claims-ledger.md` with a PMID/DOI and the exact supporting sentence(s) from the source.
2. **Hypothesis or assumption.** Inline-labeled `[HYPOTHESIS]` or `[ASSUMPTION]` with a short justification. Visible to the reviewer, not smuggled in as fact — the human reviser decides whether to keep, defend, or remove it.
3. **Methodological convention.** An established method with a widely-cited reference — e.g., "von Frey filaments using the up-and-down method (Chaplan et al., 1994)" — where the citation points to the canonical methods paper. Same ledger requirement applies.

There is no fourth category. A claim that fits none of these gets dropped, rewritten to not need it, or moved to `gaps.md`.

## What is not allowed

- **Citations from training memory.** Even if the paper is real and the claim is correct, citing from memory means there's no guarantee the PMID, year, journal, or supporting sentence are right. Always retrieve the paper before citing it.
- **Citations from web-search snippets without retrieval.** A search result's preview text is not enough — retrieve the paper or its abstract through an actual literature tool, save it locally, and quote from the saved version.
- **Plausibility-based citation.** "This is likely supported by [group]'s work on [mechanism]" without a specific paper and a specific supporting sentence is not a citation, it's a guess wearing a citation's clothes.
- **Citation chains.** "As reviewed in Smith 2020 (citing Jones 1995, Patel 2010, Wong 2018)…" hides which paper actually supports the claim. Cite the primary source, not the review that cites it.
- **Citation laundering.** Reusing a paper that supports claim A as the citation for an adjacent but distinct claim B that the paper doesn't actually support. The ledger's quoted supporting sentence is what makes this visible — if you can't find the sentence, the citation doesn't belong there.

## Retrieval priority — always prefer full text over an abstract

Abstracts summarize; they don't always contain the specific number, mechanism detail, or qualifier a claim depends on. Work down this list until a source is found, and don't skip a step just because a later one is more convenient:

1. **The project's own supplied materials.** Check whatever folder of papers the user has already provided for this project — a pre-assembled library or just whatever's sitting in an inputs folder — before searching externally. If it's there, it's the fastest and most reliable source, and it's likely there because the user specifically wants it used.
2. **A connected reference manager**, if one is available this session (e.g., Zotero). These often already hold full-text PDFs for papers the applicant already knows are relevant — check before doing a fresh literature search.
3. **Whatever literature or clinical-data connectors are available this session** — a PubMed tool, a bioRxiv tool, a clinical-trials registry tool, or similar. Prefer full text where the tool can get it (PubMed Central open access, a preprint's own PDF) over an abstract-only result. Different sessions will have different connectors available — check what's actually connected rather than assuming a specific one; the discipline here doesn't depend on any particular vendor.
4. **Abstract-only, if that's genuinely all that's retrievable.** This is allowed, but mark the ledger entry's confidence as Medium or Low accordingly, and note in `gaps.md` that full text would strengthen the claim — especially for any numerical claim, where an abstract's rounded figure may not be precise enough to defend.
5. **Ask the user to supply the paper.** If nothing is retrievable through any of the above, say so and ask, rather than proceeding on memory or a search snippet. This is a normal, expected outcome for paywalled or obscure sources — not a failure of the process.

## File setup

Create these four files before drafting any prose, typically in an output folder for the project:

```
claims-ledger.md
decisions-log.md
gaps.md
ai-use-log.md
```

### `claims-ledger.md` format

One entry per factual claim, in this block format so a human can scan it quickly:

```markdown
## C001
**Claim:** SSTR4 activation in DRG neurons reduces capsaicin-induced TRPV1 currents through Gαi signaling.
**Section:** Background and significance, paragraph 2.
**Source:** Gorham, Just & Doods 2014. Neurosci Lett 573:35–39. PMID 24814980.
**Supporting sentence(s):** "[exact quoted sentence from the abstract or paper]"
**Confidence:** High. Direct experimental observation in the cited paper, full text retrieved.

## C002
**Claim:** Loss of SSTR4 in mice produces heightened inflammation and increased pain sensitivity.
**Section:** Background and significance, paragraph 3.
**Source:** Helyes et al. 2009. PNAS 106:13088–13093. PMID 19622738.
**Supporting sentence(s):** "[exact quoted sentence]"
**Confidence:** Medium. Abstract only — full text not accessible this session; see G00X.
```

Each entry needs:

- **Claim** — the exact assertion as it appears (or will appear) in the draft.
- **Section** — where in the draft it appears, so a human reviewer can find it fast.
- **Source** — full citation with PMID or DOI (preprints usually only have a DOI).
- **Supporting sentence(s)** — a verbatim quote from the source. Do not paraphrase here; the whole point is that a human can search for this exact string and find it in the source.
- **Confidence** — High / Medium / Low, and *why* (full text vs. abstract-only is the most common driver). Medium and Low entries get extra scrutiny in the self-review pass.

For any numerical claim (effect sizes, percentages, sample sizes, dose ranges), the supporting sentence must contain the specific number, or numbers from which it can be directly computed. A paraphrased "roughly N-fold" without a quoted figure backing it up is not sourced.

### `decisions-log.md` format

For choices made under uncertainty — this is for a human reviewer to understand *why* the draft says what it says, not just what it says.

```markdown
## D001 — [short title of the choice]
**Choice:** [what was decided]
**Alternatives considered:** [what else was on the table]
**Rationale:** [why this one, referencing the BRIEF/program-profile/current call as appropriate]
**Reversibility:** [reversible / not — and what it would cost to change]
```

Log things like: choice of model/comparator/method where more than one was plausible, choice of citation when multiple papers could support a claim, inclusion or exclusion of marginal sub-experiments, framing of a conflict-of-interest disclosure, framing of the hypothesis, and — new — any funder AI-use policy found in the current call and how the drafting process adjusted for it.

### `gaps.md` format

Anything that couldn't be sourced, couldn't be resolved, or needs a human decision. Each item should be concrete enough that a person can act on it in a bounded amount of time — "more research needed" is a non-actionable handwave, not a gap.

```markdown
## G001 — [short title]
**Issue:** [what's missing or unresolved]
**Current draft says:** "[the relevant sentence as currently drafted]"
**What's needed:** [the specific input, decision, or verification required]
**Where to address:** [section/paragraph]
```

### `ai-use-log.md` format

This file exists because funders are increasingly explicit that AI-substantially-developed content presented as the applicant's own original work, undisclosed, is treated as a misconduct risk rather than a style choice — NIH's guidance is one concrete, public example, and other funders are moving the same direction even where they haven't published a formal policy yet. Keeping this log costs almost nothing during drafting and makes disclosure and internal human review straightforward regardless of whether the specific program in play requires it.

```markdown
## Section: [name]
**AI-drafted:** Yes / Partially (describe what was AI-drafted vs. human-written)
**Verified against:** [what was checked — claims-ledger entries, the current call, the BRIEF, etc.]
**Needs human review:** [what a human still needs to read line-by-line before this is submission-ready]
```

If the current call's guidelines say anything about AI-tool use — some funders restrict AI assistance to grammar and formatting, some require an explicit disclosure statement, some are silent — note the finding here as well as in `decisions-log.md`, and note explicitly if the call was silent rather than assuming silence means no restriction applies.

## The drafting loop

For each section:

1. List the claims the section will make — before writing any prose.
2. For each claim, identify a candidate source using the retrieval priority order above.
3. Verify the source actually contains the claim — extract the supporting sentence(s) before writing a single word of prose that depends on it. Do not skip this step; most fabrications happen because a real paper was found and the model assumed it would contain the claim without checking.
4. If no source can be found after a reasonable search, either label the claim `[HYPOTHESIS]`/`[ASSUMPTION]` inline or move it to `gaps.md` and rewrite the sentence so it doesn't depend on an unsourced fact.
5. Write the prose.
6. Append ledger entries for every claim now in the draft, and update `ai-use-log.md` for the section.

## Self-review pass

After the full draft is complete, read the draft and the ledger together. For each paragraph:

1. Does every factual claim have a ledger entry?
2. Does each entry's supporting sentence actually support the claim — not just sit adjacent to it?
3. Are numerical claims backed by quoted numbers, or are they paraphrased approximations dressed up as precise?
4. Are the `[HYPOTHESIS]`/`[ASSUMPTION]` labels still appropriate, or should any move to `gaps.md` instead?

Expect this pass to cut or rewrite something like 10-15% of the drafted prose — that's normal, not a sign something went wrong earlier.

After the self-review pass, hand the draft to `citation-check` as an independent verification pass and to `ai-slop-check` as a prose-quality pass — see the parent skill's `SKILL.md` for how these fit into the overall workflow. This protocol is the prevention layer during drafting; those two skills are detection layers afterward, and a defensible application wants both.

## Edge cases

**A claim is supported by multiple papers.** Cite the most recent primary source, or the foundational primary source if recent work is purely incremental on it. Don't cite a review unless the claim is specifically about the field's consensus. Log the chosen citation in the ledger and note the alternatives considered in `decisions-log.md`.

**A paper supports the claim only partially.** Split the claim into two sentences with different sources, or weaken the claim to match exactly what the source says. Don't stretch a citation to cover more than it actually shows.

**A claim is methodological boilerplate**, not a factual assertion — "surgery was performed under isoflurane anesthesia" doesn't need a ledger entry. The line is between describing what the project *will do* (no entry needed) and asserting something about the world (entry needed).

**The applicant's own prior work is the source.** Same protocol applies in full — retrieve the paper, log the entry, quote the supporting sentence. Self-citation is fine; *unverified* self-citation is not, and it's an easy trap to fall into precisely because it feels like it shouldn't need checking.

**A retrieved abstract doesn't contain the claim, but the full text might.** Try to retrieve full text (open-access full text, a connected reference manager, or ask the user). If it's genuinely not retrievable, treat the claim as unsourced for now — label it or move it to `gaps.md`. Don't assume the full text would support it just because the abstract is adjacent to the topic.

**A style template (a prior application used for structural reference) contains a citation that would be useful again.** Re-retrieve and re-verify it from scratch, exactly as if it were new. The literature, the funder's expectations, and the applicant's own subsequent work can all have moved since the prior application was written — treating an old citation as pre-verified because it worked once is exactly the shortcut this protocol exists to prevent.
