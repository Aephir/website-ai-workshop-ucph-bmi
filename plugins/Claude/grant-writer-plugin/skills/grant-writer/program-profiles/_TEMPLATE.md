# Program profile template

Copy this file to `program-profiles/<program-id>.md` (e.g. `program-profiles/dff-fp1.md`, `program-profiles/nih-r21.md`) when setting up a program this skill will be used for repeatedly. A program profile captures the *program's* stable shape — not a specific call's specific numbers, and not project-specific content.

## Why this file is not the current call

Everything in the "confirm against current call" fields below is exactly the kind of thing funders change between rounds — sometimes more than once a year. A profile that quietly goes stale on one of these fields doesn't just produce a slightly-off draft, it can get an otherwise strong application administratively rejected without being read, because the actual current call said 12,000 characters and the cached profile said 15,000. Treat every numeric or procedural field below as a cache that must be invalidated against the real call PDF/guidelines every single run — never as a fact this skill can rely on by itself.

The current call itself, and an optional style template (a prior successful application used for structural/register reference), are deliberately **not** stored here. They live in the project's own folder or get attached at the start of a session, because they're specific to one applicant's one submission at one point in time, not stable knowledge about the program in general. See the parent `SKILL.md` for where those belong.

## Profile format

```markdown
# Program: [Program name and instrument, e.g. "DFF Research Project 1 (FP1)"]

**Funder:** [Funder name]
**Jurisdiction:** [Country/region — drives ethics-body naming, spelling convention, etc.]
**Typical duration / budget envelope:** [rough scale — CONFIRM AGAINST CURRENT CALL]
**Last profile update:** [date]

## Structure (typical shape — confirm required sections against the current call every run)

List the sections this program's narrative typically breaks into, roughly in order, with an approximate proportion of the total length for each (e.g., "Background — roughly 15% of total length"). If you have a funded exemplar you have the rights to use as the basis for this pattern (your own past application, or one shared with you), it's fine to draw the pattern from it — just don't quote its actual claims or citations here; describe the *shape*, not the content.

## Assessment criteria (quote the funder's own stated criteria where possible)

List the dimensions this program's reviewers are told to score against, in the funder's own language if available. This is usually stable across rounds of the same program, but CONFIRM ANY SPECIFIC WORDING against the current call — funders do revise their stated criteria.

## Jurisdictional / procedural conventions

- Ethics body / regulatory body to name (e.g., which animal-research authority, which IRB-equivalent) — CONFIRM this hasn't changed.
- Spelling convention (US/UK) if the funder has a house preference.
- Submission-system quirks worth knowing (e.g., a specific portal's character counter behaving differently from a local word processor's count) — CONFIRM against the current call/portal, these are exactly the kind of detail that silently changes.
- Any known pattern in this program's expectations around figures, appendices, or supplementary material.

## Voice overlay (optional — only if this program's expected register differs from the generic default)

The parent skill's `references/voice-and-style.md` is the default register. Note here only what's genuinely different for this program (e.g., a program that explicitly wants a more narrative, less clinical tone; a program whose reviewers are specialists rather than generalists, which changes how much background explanation is warranted).

## Known AI-use policy (as of last profile update — CONFIRM AGAINST CURRENT CALL, this is actively changing across funders right now)

Note anything the funder has stated about AI-tool use in preparing applications, with a link/reference if possible. If nothing is known, say so explicitly rather than leaving this blank — a blank field looks like it was never checked.

## Fields explicitly NOT cached here (always read fresh)

- Page/character limits for every component.
- Required forms, their numbering, and page limits per form.
- Submission deadline(s).
- Any funder-supplied template files.

These come from the current call, every time, no exceptions.
```

## Building a new profile

When no profile exists yet for a program the user wants to apply to, build one together: read the current call to identify the required sections and their rough proportions, capture the assessment criteria in the funder's own wording, note jurisdictional conventions, and check for any stated AI-use policy. Mark every field above the "explicitly NOT cached" line as "as of [date]" so a future run knows how fresh the cached knowledge is, and don't assume it's still accurate just because it was accurate last time.
