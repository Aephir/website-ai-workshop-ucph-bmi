# grant-writer plugin

Drafts grant/funding application narratives with retrieval-grounded citations and a visible, auditable decision trail, for any funder or program. Bundles three skills, one subagent, two hooks, and four literature/data connectors. Read this before installing — it explains what this does and doesn't do, and what you still have to do yourself.

## This is not endorsed by any funder

Nothing in this plugin is affiliated with, endorsed by, or verified against any specific funder — not DFF, not NIH, not anyone. Page limits, required sections, and assessment criteria change, sometimes more than once a year, and this plugin is built specifically to never cache those numbers where they could go stale unnoticed (see `skills/grant-writer/SKILL.md`). You are responsible for reading the actual current call before every submission. This plugin surfaces what it finds there; it does not verify that what it finds is complete or current beyond what it's told to check.

## What it does not touch

This plugin does not work with patient data, subject-level clinical data, or anything with an identifiability concern — it's built for literature and application narrative text. Don't repurpose it for anything involving real patient records.

## Setup

1. **Per project, supply a `BRIEF.md`** with the locked scope (hypothesis, personnel, tool materials, exclusions, stop conditions). The `grant-writer` skill will ask for one if it's missing rather than inventing scope.
2. **Put the current call/guidelines** for the program you're applying to somewhere the session can read them — a project folder (e.g. `inputs/call/`) or attached directly to the session. Never rely on anything cached in a program profile for the actual limits.
3. **Optionally, put a prior successful application** in `inputs/style-template/` (yours, or one someone's shared with you) for structural/register reference. It will not be used as a source of citations — every claim gets re-verified regardless of where it appeared before.
4. **Build a program profile the first time you use a given program.** `skills/grant-writer/program-profiles/_TEMPLATE.md` has the format. This is a one-time cost per program (not per application) — it captures the stable shape, not this round's numbers.
5. **Four connectors are bundled in this plugin's manifest** (`mcpServers`), since the whole point is that claims trace to retrieved sources, not memory. Installing the plugin should prompt you to connect each:
   - **PubMed** — biomedical literature search and full-text retrieval. No account needed.
   - **bioRxiv** — preprint search across bioRxiv/medRxiv. No account needed.
   - **Clinical Trials** — ClinicalTrials.gov search, trial details, sponsor/investigator lookup, endpoint comparison. No account needed.
   - **BioRender** — for anyone making the figures a grant description references. Needs a free BioRender account; you'll be prompted to sign in the first time it's used.

   Optionally, also connect a reference manager (Zotero or equivalent) if you have one — it often already holds full text for papers you know are relevant. That one isn't bundled: it depends on your own local reference-manager install, so it's set up through your own account's connector settings rather than something a plugin manifest can point at.

   The four bundled entries point at the same hosted endpoints Anthropic's own official life-sciences connectors use — pulled directly from [anthropics/life-sciences](https://github.com/anthropics/life-sciences), a public repo, rather than guessed. That's a real difference from where this README stood before: earlier I couldn't get verified endpoint URLs through the tools available to me and declined to guess at one, on the same "don't fabricate what you can't verify" principle the citation-ledger protocol is built on. Finding that Anthropic publishes their real connector endpoints in the open resolved that — these URLs are copied from their repo, not invented.

   One caveat I can't resolve from inside this session: whether Cowork's plugin installer actually *acts* on a manifest's `mcpServers` field is still unconfirmed, for the same reason the hooks field turned out not to be wired up (see below). If installing this plugin doesn't prompt you to connect anything, that's most likely why — in which case, connect the four above manually through the normal connector directory; the skills check what's actually available at runtime regardless of how it got connected.

## What's in the box

- `skills/grant-writer/` — the core drafting skill: BRIEF → program profile → current call → outline → draft → self-review → verification.
- `skills/citation-check/` — independent citation verification (exists, cited correctly, placed correctly, supports the claim, not retracted).
- `skills/ai-slop-check/` — AI-writing-tell and cross-section redundancy audit.
- `agents/citation-verifier.md` — a subagent that runs `citation-check` from a fresh, read-only context with no memory of the drafting session, so verification doesn't share context with the thing it's verifying.
- `hooks/hooks.json` + `hooks/scripts/` — two automatic checks that fire on every save, no LLM call involved: a banned-phrase sweep on markdown drafts, and a structural completeness check on `claims-ledger.md` entries. These are a cheap floor, not a replacement for the skills above — they catch what a script can catch and nothing more.
- `mcpServers` in the manifest — PubMed, bioRxiv, Clinical Trials (all authless), and BioRender (free account), pointed at the same hosted endpoints Anthropic's official life-sciences connectors use.

## Known limitations, stated plainly

**Hooks do not currently run in Cowork.** This was tested directly, not assumed: writing a file containing several banned phrases, and a `claims-ledger.md` entry missing required fields, produced no warning from either hook in a Cowork session with this plugin installed. The plugin's detail view also shows only "Skills" and "Agents" tabs — no "Hooks" tab — which matches. The scripts themselves work correctly in isolation (each was unit-tested against a synthetic hook payload and produces the right output), so this looks like a gap in what Cowork's plugin loader currently wires up, not a bug in the scripts. They're kept in the plugin because the underlying mechanism (`PostToolUse`, matched by `Edit|Write` with an `if` glob) is Claude Code's documented, supported hook format, and they should work if this plugin is used from Claude Code (the CLI) instead of Cowork — that's untested here, since this was all built and used from within Cowork. Until one of us confirms hooks firing somewhere, treat `ai-slop-check` and `citation-verifier` as the two mechanisms actually doing the work, and the hooks as a bonus that may not be active in your environment yet.

**Whether the bundled connectors actually auto-connect on install is unconfirmed.** The manifest entries are real and correctly formatted (verified against Anthropic's own published connector plugins), but I haven't been able to confirm Cowork's installer consumes `mcpServers` the way it apparently doesn't consume `hooks`. If they don't prompt automatically, connect PubMed, bioRxiv, Clinical Trials, and BioRender manually — same four, just a manual step instead of an automatic one.
