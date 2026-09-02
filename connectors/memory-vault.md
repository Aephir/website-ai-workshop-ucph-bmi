---
Connector guide: memory vault
Referenced from workshop deck v0.2 slide 25 ("workshop.walden.dk → Connectors → Memory vault"). Scope confirmed 2026-08-24: single-project version only for the workshop. Source prompt: resources/prompts/01-memory-vault-single-project.md (full modular set, incl. optional add-ons, in the same folder).
---

# Memory vault

Not a connector in the MCP sense — no install, no API key. It's a prompt you paste once into a Project (Claude), Notebook (Copilot), or equivalent, that gets the AI to keep a small, durable memory of that one piece of work in a few files it reads and writes itself, so you stop re-explaining context every session.

**Today's version is scoped to one project.** Memory stays inside that project only — nothing shared with your other work. A universal, cross-project version exists but isn't covered here; ask if you want it.

## What it needs

A container that can hold files across a conversation and that the AI can read from and write to:

- **Claude** — a Project. Full read/write, no extra setup.
- **Microsoft Copilot** — a Notebook, with the memory files kept in a referenced OneDrive/SharePoint folder. Full read/write.
- **ChatGPT / Gemini / Perplexity** — works, but "writing" usually means the assistant hands you updated file text to save back yourself, unless that platform's own file-edit tool is switched on.

## Set it up

1. Open (or create) the Project/Notebook/Space you want this memory attached to.
2. Paste the full prompt below as your first message.
3. From then on, ask the AI to save or update the memory whenever something worth keeping happens — it won't write automatically.

## The prompt

```
You are keeping a small, durable memory for this one project so I don't have to re-explain context every session. This is not a chat log -- it's your best current understanding of the project, kept as a few files.

Inside a memory/ folder in this project, keep:
- INDEX.md -- one-paragraph map: what this project is, what lives where.
- STATE.md -- current objective, status, open questions, next actions. Rewrite this as things change; don't append a history of superseded facts.
- DECISIONS.md -- append-only. Only for decisions whose reasoning will matter later, not routine choices. Format: date, decision, reason, alternatives if relevant.
- Notes/ -- supporting detail (meeting notes, research, drafts). Read only if STATE.md/DECISIONS.md don't answer the question.

If memory/ doesn't exist yet, create it with empty INDEX.md/STATE.md/DECISIONS.md the first time this becomes relevant.

Read STATE.md (and DECISIONS.md if past reasoning matters) whenever I refer to earlier work in this project, ask you to continue or resume, or ask what we decided. Don't read all of Notes/ for a quick question -- only if the summary files don't cover it. Skip this system entirely for a question that has nothing to do with this project's history.

Read automatically; write deliberately -- only when I ask you to save or update something, or when a state file you're already maintaining clearly needs updating as part of the work you're doing.

STATE.md is canonical current state, not a diary: when something changes, replace the old text rather than appending "we used to think X, now Y" -- unless that history itself is worth keeping, in which case it goes in DECISIONS.md, not STATE.md.

Tell me if something you expected to find is missing, a save fails, two notes disagree with no obvious answer, or the files have gotten too big or messy to route through quickly. Don't guess past these -- flag them.
```

## Two tiers, not one

This is the deliberate, structured tier — you control exactly what's in it, and it's portable (it's just files). Every major AI tool also now has some form of built-in native memory: zero setup, automatic, lighter-weight, but not something you curate. Use both — native memory for the small stuff it picks up on its own, this vault for the project-level context that actually needs to be right.
