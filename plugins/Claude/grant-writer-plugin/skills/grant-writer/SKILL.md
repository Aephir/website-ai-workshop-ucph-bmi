---
name: grant-writer
description: Draft, structure, revise, or critique a grant/funding application's narrative (project description, specific aims, reference list) for any funder or program — not tied to one funder. Use whenever the user asks to write, draft, outline, revise, or critique a grant application or funding proposal narrative, or names a specific funding program (a research council instrument, an NIH mechanism, an ERC grant, a foundation RFP) in the context of applying to it. Trigger even without the word "grant" if the user describes writing something for a funder, a study section, a review panel, or a funding call. If the named program has no matching file in program-profiles/, say so and offer to build that profile from the current call rather than guessing at structure. Prefer this over hand-rolling a similar workflow from scratch.
---

# Grant writer

This skill drafts a defensible first draft of a grant or funding application's narrative content, with retrieval-grounded citations and a visible, auditable trail of what was drafted, what was checked, and what still needs a human decision. It works across funders and programs by keeping three layers of knowledge strictly separate — mixing them is the single most common way a generalized version of this workflow quietly breaks.

## The three layers — read this before doing anything else

1. **The project** — locked scope: hypothesis, personnel, tool materials, exclusions, stop conditions, and where outputs should go. Lives in a `BRIEF.md` the user supplies in their project's own working folder. This skill does not invent scope. If no BRIEF exists, ask for one before drafting.

2. **The program** — stable, low-churn knowledge about how a specific program (a specific call/instrument from a funder, not the funder's whole portfolio) typically shapes its narrative and what its reviewers are told to look for. Lives in `program-profiles/<program-id>.md`, bundled with this skill. A funder's different programs are often more different from each other than similar programs are across different funders — a national fund's early-career instrument and its senior-PI instrument can have almost nothing structurally in common — so profiles are keyed to the program, not the funder.

3. **The current call, and optionally a style template** — the actual, dated rules for this specific round, and (optionally) a prior application used purely as a structural/pacing/register reference. Neither of these is ever bundled with this skill. Both live in the project's own folder (e.g. `inputs/call/`, `inputs/style-template/`) or get attached to the session directly. See "Why the current call and style template are never packaged here" below for why this matters more than it might seem to.

Collapsing any of these into another is the failure mode to watch for: baking a specific call's numeric limits into a program profile risks a future run silently using stale numbers; letting a style template's old citations stand in for freshly-verified ones risks reintroducing exactly the fabrication problem this skill exists to prevent; letting the BRIEF's scope drift because a program profile "suggested" a different angle risks the applicant no longer recognizing their own project in the draft.

## Why the current call and style template are never packaged here

Call guidelines, page limits, and character limits change — often more than once a year for an active program. A profile that embeds a specific call's numbers is a liability the moment a later call changes them: this skill would confidently draft to a stale limit, and the result can be administratively rejected without ever being read by a human reviewer. The current call therefore always gets read fresh from the project folder or a session attachment, never assumed from the profile or from memory.

A style template — a prior successful application used to calibrate structure, pacing, and register — is genuinely useful and welcome as an input. Whether it's the user's own past application or one a colleague has shared with them is their call, not something this skill polices. The one rule that does matter: a style template informs *how the narrative is shaped*, never *what it claims*. Every citation and every factual assertion gets freshly retrieved and re-verified this run, even if it appeared identically, word for word, in the template — the literature moves, funder expectations move, and the applicant's own subsequent work moves. Treating an old citation as pre-verified because it worked once is precisely the shortcut that reintroduces fabrication risk through the back door.

## Workflow

1. **Read the BRIEF.** If it's missing or clearly incomplete (no hypothesis, no personnel, no stop conditions), stop and ask rather than inventing the gaps.

2. **Identify the program and check for a profile.** Look for `program-profiles/<program-id>.md`. If one exists, read it for structural and voice guidance — but see step 3 for what it can't tell you. If none exists, say so and offer to build one now (see `program-profiles/_TEMPLATE.md`) using the current call together with the user, rather than silently borrowing another program's shape or guessing.

3. **Read the current call fresh — from the project folder or a session attachment, never from the profile or from memory.** Confirm, from this document alone: every page/character limit per component, the required sections and their order, submission-system quirks, the deadline, and — check this explicitly, don't skip it — whether the call or the funder's general guidelines say anything about AI-tool use in preparing the application. If they do, that constraint sits above everything else in this skill: some funders restrict AI assistance to grammar and formatting only, some require an explicit disclosure statement, some prohibit AI involvement in specific aims or hypothesis generation entirely. Log what was found in `decisions-log.md` and adjust behavior accordingly. If the call is silent on AI use, record that explicitly in `ai-use-log.md` — silence is a fact worth logging, not an assumption to skip past.

4. **Set up four tracking files** in the project's output location before drafting any prose: `claims-ledger.md`, `decisions-log.md`, `gaps.md`, `ai-use-log.md`. Full formats, the retrieval-priority order for sources, and the drafting/self-review loop are in `references/citation-protocol.md` — read it now if this is the first time in this project, and refer back to it while logging each entry. These four files are not paperwork bolted on afterward; for a project where AI assistance needs to be defensible, they're arguably as important as the draft itself, because they're what lets a human — the applicant, a co-author, or eventually a funder — see exactly how the draft came to say what it says.

5. **Check for a style template.** If the project folder or session has one, read it for structure, pacing, and register only — apply the non-negotiable rule from above: no claim or citation carries over unverified, no matter how minor it seems.

6. **Derive the section skeleton.** Build it from the current call's own stated required sections, informed by the program profile's cached structural pattern if one exists. If the call's own structure and the profile's cached pattern disagree, the call wins — profiles cache what's usually true, not what's true this round.

7. **Outline before drafting.** For each section, list the claims it will make before writing any prose. Map each claim to a candidate source (via the retrieval-priority order in `references/citation-protocol.md`) or an explicit `[HYPOTHESIS]`/`[ASSUMPTION]` label. Only once every claim has a candidate source or an explicit label does drafting start.

8. **Draft section by section**, following `references/voice-and-style.md` (plus the program profile's voice overlay, if it has one). After each section: append claims-ledger entries, check length against the running budget from the current call, update `ai-use-log.md` for what was drafted and what still needs human review.

9. **Self-review against the ledger**, per the process in `references/citation-protocol.md`. Expect to cut or rewrite a meaningful fraction of the drafted prose here — that's the process working, not a sign something went wrong earlier.

10. **Dispatch the `citation-verifier` agent** against the completed draft and reference list, rather than running `citation-check` inline in this same conversation. The claims-ledger discipline above is prevention during drafting; `citation-check` is independent detection afterward — but detection is weaker if the thing doing the detecting shares context with the thing that did the drafting, because it's already primed to see what it expects to see. `citation-verifier` is a fresh subagent with no memory of how the draft was written, that runs the `citation-check` skill and nothing else, read-only — it reports findings for a human (or this skill, on the human's instruction) to act on rather than silently patching the draft itself. A document worth submitting benefits from both the ledger discipline and this independent pass, not one instead of the other.

11. **Run `ai-slop-check`** against the completed draft before calling it done — for the redundancy and rhythm passes specifically. This plugin also wires up an automatic hook that sweeps every draft edit against the banned-phrase list the moment it's written, so most single-phrase tells (hyperbole, empty signaling phrases) should already be gone by the time this step runs; that hook can't do the harder part, which is noticing that a specific claim planted in a background section gets echoed almost verbatim in an impact or perspectives section without adding anything — a recurring failure mode in AI-assisted long-form drafting that requires actually understanding what each paragraph asserts, not just matching phrases. Let `ai-slop-check` flag these; deciding whether a given repeat is load-bearing (worth keeping, because it's one of the one or two claims the whole document is built around) or lazy (cut or merge) is a case-by-case judgment call, not something either the hook or the skill should make unilaterally.

12. **Stop at the stop conditions defined in the BRIEF.** Don't keep polishing past them.

## Where everything lives — quick reference

| What | Where | Owned by this skill? |
|---|---|---|
| Hypothesis, scope, personnel, exclusions | `BRIEF.md` in the project folder | No — user-supplied per project |
| Typical structure, criteria, jurisdiction conventions for a program | `program-profiles/<program-id>.md` | Yes — bundled, built once per program, reused |
| This round's actual limits, required forms, deadline | Current call in `inputs/call/` or a session attachment | No — always read fresh |
| A prior application used for structural reference | `inputs/style-template/` or a session attachment | No — optional, claims-blind |
| Claims ledger, decisions log, gaps, AI-use log, drafted sections | Project output location | Generated fresh each run |

## What this skill does not do

- Produce budget spreadsheets, CVs, or track-record documents — these use mandatory funder templates filled in by the applicant or their institution.
- Produce figures — it plans for them in the length budget and writes captions, but image creation is a separate step.
- Write collaboration or support letters — those come from collaborators directly, on their own letterhead.
- Assess the underlying science — the hypothesis and scope are inputs from the BRIEF, not outputs of this skill.
- Decide whether AI assistance is permitted for a given program. It surfaces what the current call says, logs the finding, and leaves compliance the applicant's responsibility — same as any other funder rule this skill can read but can't adjudicate on the applicant's behalf.

## Reference files

- `references/citation-protocol.md` — the claims-ledger discipline: what counts as sourced/hypothesis/methodological-convention, the retrieval-priority order (check the project's own supplied materials, then a connected reference manager, then whatever literature connectors are available, then abstract-only as a fallback, then ask the user), ledger/log formats, the drafting loop, and edge cases. Read this in full before setting up the tracking files.
- `references/voice-and-style.md` — the generic anti-slop academic/funding-application register: what to do (lead with the assertion, quantify, falsifiable hypotheses) and what to cut on sight (empty signaling phrases, hyperbole, hedging, marketing language, uniform sentence rhythm). Read this before drafting any prose, not during revision — it's much cheaper to write in the right register the first time than to retrofit it.
- `program-profiles/_TEMPLATE.md` — the format for a new program profile, and why certain fields must always be re-confirmed against the current call rather than trusted from the cache.

## Building a new program profile

When a named program has no matching profile: read the current call together with the user, identify the required sections and their approximate proportions, capture the stated assessment criteria in the funder's own wording, note jurisdictional conventions, and check for a stated AI-use policy. If the user has a prior successful application for this program they have the rights to use — their own past submission, or one a colleague has shared — it's a legitimate and often the best source for the structural pattern; draw the *shape* from it (section order, proportions, the kind of rhetorical devices its reviewers respond to) without copying forward any of its specific claims or citations into the profile itself. Mark every numeric or procedural field as "as of [date], confirm against current call" so a future run knows exactly how much to trust it.
