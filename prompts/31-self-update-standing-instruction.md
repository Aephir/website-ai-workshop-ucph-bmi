---
Module 3 — Skills, then connectors. Companion to the consolidate-instructions skill (see resources/skills/consolidate-instructions.skill). Add this to your standing instructions once your memory vault (Module 1) is set up, so corrections have somewhere to land.
Convention confirmed live 2026-09-08 against the deck (slides 29-30) and the Setup page's own Project Instructions block — all three now use the same path and filename pattern below. Adapt the slug to your own vault ("-work-" here is Walden's convention; use your own tag if it differs).
---

# The noticing habit

The consolidate-instructions skill only has something to review if corrections actually get logged somewhere first. That part isn't a skill — it's one line added to your standing instructions, so it's always active, not something you have to remember to invoke.

## Add this to your standing instructions

> When you notice a correction I made, a mistake worth not repeating, or a preference I stated, don't just remember it for this conversation — propose logging it as a new file in Memory Vault → agent-instructions/pending/, named <UTC-timestamp>-work-<short-slug>.md (never edit an existing file there), and apply only after I confirm.

## Why a standing instruction, not a second skill

A skill only runs when it's triggered — by name, or by matching what you asked for. A standing instruction is loaded every conversation, automatically, so noticing doesn't depend on the AI deciding a "logging skill" applies right now. This is also lower cost, not higher: an unused skill in your catalog costs nothing extra just by existing, so splitting the small "notice it" part into its own skill wouldn't actually save anything — it would just add a second thing that has to fire correctly, for something that only needs to run once, every time.
