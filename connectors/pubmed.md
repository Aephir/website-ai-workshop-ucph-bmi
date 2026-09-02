---
Connector guide: PubMed
Referenced from workshop deck v0.3 (added 2026-09-02, per Walden's request following the resources-completeness check). Covers connecting PubMed to Claude, ChatGPT, Microsoft Copilot, Gemini, and Perplexity — connection is UI-driven and differs per platform, so each is documented separately. Researched 2026-09-02; UI paths tagged [to be updated] per project convention (see notes/to-be-updated.md).
---

# Connecting PubMed

PubMed is the National Library of Medicine's database of biomedical literature — over 36 million citations, with full text available for articles in PubMed Central. Connecting it to your AI assistant lets it search PubMed directly and pull real citations and abstracts into the conversation, instead of relying on what it already knows (or guessing).

Availability differs sharply by platform: Claude has an official one-click connector; the other four platforms currently don't.

## Claude — official connector, one click

Anthropic ships a first-party PubMed connector.

**Individual account:**
1. Settings → Connectors [to be updated]
2. Find "PubMed" in the list
3. Select "Connect"

**Team/Enterprise (org-managed):**
1. Admin settings → Connectors → Browse connectors [to be updated]
2. Select "PubMed" → "Add to your team"

Once connected, just ask — "find recent studies on senescent cells and fibrosis," "what are the most cited papers on this," "look up this citation." Full text is available for PubMed Central articles; other citations return metadata and abstract only.

## ChatGPT — not available

No PubMed connector exists for ChatGPT as of September 2026. OpenAI's recent health-related work (ChatGPT Health) connects consumer sources like Apple Health and Epic medical records — it doesn't touch PubMed or biomedical literature search. Third-party GPTs claiming PubMed access exist in the GPT store, but they're unofficial and vary in quality — vet before trusting one with real work.

Workaround: paste a citation, DOI, or PMID directly into the chat, or drag in a PDF — ChatGPT can work with what you give it, it just can't search PubMed itself.

## Microsoft Copilot — not available

No dedicated PubMed connector. The Researcher agent in Microsoft 365 Copilot searches the open web and your own work content (files, email, Teams) — it does not have PubMed as a distinct built-in source, and its exact scope depends on your organization's Copilot license and configuration [to be updated]. In practice it can often reach public PubMed pages the same way any web search does, but that's not the same as a real connector with structured search and metadata.

Workaround: same as ChatGPT — paste citations in directly, or point Copilot at PDFs already in your OneDrive/SharePoint (Copilot reads full PDF text there natively).

## Gemini — not available

No PubMed connector in the consumer Gemini app's Connected Apps list as of September 2026 (last expanded August 2026, with additions like Otter.ai, Wix, and several health/lifestyle apps — none scientific literature). A community-built PubMed extension exists for Gemini CLI (developer tool, not the consumer chat app) — not relevant for a general workshop audience.

Workaround: paste citations/PDFs directly, same as above.

## Perplexity — not available

No PubMed or NCBI connector among Perplexity's App Connectors, which focus on productivity and business tools (Gmail, Slack, Notion, GitHub, and similar). Perplexity Health, launched in 2026, is about personal health data, not literature search.

Perplexity's own web search does routinely surface PubMed results by default, since it's a general web-search-native tool — so for a quick "what does the literature say" question it often gets you further than ChatGPT/Copilot/Gemini without any setup at all. It's just not a structured connector with library-style search.

## Bottom line

If PubMed access matters to your workflow, Claude is currently the only one of these five with a real connector for it. Everyone else means manual paste-in, or living with general web search quality.
