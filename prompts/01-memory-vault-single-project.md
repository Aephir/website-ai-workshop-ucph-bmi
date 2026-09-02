---
Prompt: External Memory Vault — single-project version
Use: paste as your first message in a Project/Space/Notebook (or any chat you'll keep returning to) dedicated to one piece of work. Creates a small memory inside that one container only — nothing shared with your other projects.

Usable on (checked 2026-08-22 — verify before relying on it, these features move fast):
- Claude (Projects) — full read/write of the vault files by Claude itself.
- Microsoft Copilot (Notebooks) — full read/write via referenced OneDrive/SharePoint files.
- ChatGPT (Projects), Gemini (paste into a Gem or one recurring chat), Perplexity (Spaces) — works, but "writing" often just means the assistant gives you updated file text to save back yourself, unless that platform's file-edit tool is turned on.

Pair with `04-addon-setup-assistant.md` first if you want help with the technical part. Pair with `03-addon-skill-packager.md` afterward if you want to try making this reusable without re-pasting.
---

# Memory Vault — this project only

You are keeping a small, durable memory for this one project so I don't have to re-explain context every session. This is not a chat log — it's your best current understanding of the project, kept as a few files.

## Files

Inside a `memory/` folder in this project, keep:

- `INDEX.md` — one-paragraph map: what this project is, what lives where.
- `STATE.md` — current objective, status, open questions, next actions. Rewrite this as things change; don't append a history of superseded facts.
- `DECISIONS.md` — append-only. Only for decisions whose reasoning will matter later, not routine choices. Format: date, decision, reason, alternatives if relevant.
- `Notes/` — supporting detail (meeting notes, research, drafts). Read only if `STATE.md`/`DECISIONS.md` don't answer the question.

If `memory/` doesn't exist yet, create it with empty `INDEX.md`/`STATE.md`/`DECISIONS.md` the first time this becomes relevant.

## When to use it

Read `STATE.md` (and `DECISIONS.md` if past reasoning matters) whenever I refer to earlier work in this project, ask you to continue or resume, or ask what we decided. Don't read all of `Notes/` for a quick question — only if the summary files don't cover it. Skip this system entirely for a question that has nothing to do with this project's history.

## Writing rules

Read automatically; write deliberately — only when I ask you to save or update something, or when a state file you're already maintaining clearly needs updating as part of the work you're doing.

`STATE.md` is canonical current state, not a diary: when something changes, replace the old text rather than appending "we used to think X, now Y" — unless that history itself is worth keeping, in which case it goes in `DECISIONS.md`, not `STATE.md`.

## Tell me if

Something you expected to find is missing, a save fails, two notes disagree with no obvious answer, or the files have gotten too big or messy to route through quickly. Don't guess past these — flag them.
