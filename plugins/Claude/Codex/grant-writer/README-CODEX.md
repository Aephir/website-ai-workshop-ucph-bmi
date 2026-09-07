# Grant Writer for Codex

This is the Codex/ChatGPT-app equivalent of the supplied Claude `grant-writer` plugin. It drafts and reviews funding-application narratives while keeping project scope, program conventions, and the current call separate.

## Included

- `grant-writer`: end-to-end grant planning, drafting, logging, and review.
- `citation-check`: five-part citation verification.
- `citation-verifier`: independent, read-only verification, delegated to a fresh sub-agent when available and authorized.
- `ai-slop-check`: phrase, redundancy, and prose-rhythm audit.
- `scripts/phrase_sweep.py`: deterministic phrase checker for Markdown files.
- `scripts/check_ledger_format.py`: structural checker for `claims-ledger.md`.
- Provider-neutral research instructions that use the literature and web-search tools available in the user's environment.

## Before using it

1. Add a project `BRIEF.md` that locks the hypothesis, personnel, materials, exclusions, stop conditions, and output location.
2. Supply the actual current funding call or guidelines. Limits, deadlines, required sections, and AI-use rules must be read fresh for every application.
3. Optionally provide a prior successful application as a style and structure reference only. Its claims and citations are never treated as verified.
4. For repeated work with one funding program, create a profile from `skills/grant-writer/program-profiles/_TEMPLATE.md`.

## Mechanical checks

Codex plugin manifests do not currently expose the Claude `PostToolUse` hooks used by the source plugin. Run the equivalent checks directly:

```bash
python3 scripts/phrase_sweep.py path/to/draft.md
python3 scripts/check_ledger_format.py path/to/claims-ledger.md
```

These scripts only catch deterministic formatting and phrase-list issues. They do not replace the citation or prose-review skills.

## Personal installation from the shared ZIP

1. Unzip the archive to a permanent local folder. Do not attach it to an ordinary browser chat.
2. Open ChatGPT desktop in Work mode or Codex, where the session can access that local folder.
3. Ask: `Use $plugin-creator to add the existing grant-writer plugin at /absolute/path/to/grant-writer to my personal marketplace.`
4. Restart or refresh ChatGPT desktop, open the Plugins Directory, select the personal/local source, and install **Grant Writer**.
5. Start a new chat so the installed skills are loaded.

The plugin is skills-only. It does not install or depend on MCP connectors.

## Boundaries

This plugin is not endorsed by any funder and does not determine whether AI use is permissible. It surfaces the current call's rules and records them. Do not use it with patient records, subject-level clinical data, or other identifiable sensitive data.
