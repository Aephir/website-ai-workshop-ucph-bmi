---
Add-on prompt: skill/agent packager
Use: paste AFTER `01-memory-vault-single-project.md` or `02-memory-vault-universal.md` is already working and you're happy with it, if you want to stop re-pasting it every session. Not guaranteed to work — trying it and seeing what your own tool can actually do is the point of this exercise.

Usable on (checked 2026-08-22 — this changed mid-August 2026 already, re-check before relying on it):
- Claude — yes. Skills are self-serve on any plan, saved once, reused automatically.
- Microsoft Copilot — yes, via Agent Builder, included in a standard Microsoft 365 Copilot license, no IT step. You still open the agent yourself — it won't fire automatically the way a Claude Skill does.
- Gemini — partial. A Gem can hold this, self-serve, but you open it manually — it won't trigger itself mid-conversation.
- ChatGPT — no, on a personal account. OpenAI blocked personal accounts from creating new Skills or custom GPTs as of Aug 16, 2026 (Business/Enterprise/Edu admins only now). Expect the assistant to tell you this rather than pretend otherwise.
- Perplexity — no equivalent feature found.
---

# Turn this into a standing skill

Take the memory-vault instructions I gave you above and check whether this platform has a real mechanism for saving a reusable, self-contained skill or custom agent — something reused, ideally invoked automatically, without me pasting the whole prompt again.

If it does: create it, using the vault instructions as the skill's content, and tell me exactly where it now lives and how it gets triggered — automatically, or do I have to open/select it myself.

If it doesn't, or only account admins can do it, or you're not sure: say so plainly. Don't invent a fake "I've saved it" confirmation. Tell me the closest real workaround this platform actually has (for example, pasting it into standing account-level instructions instead), and what I lose by using that instead of a real skill — auto-invocation, sharing, reach across projects.
