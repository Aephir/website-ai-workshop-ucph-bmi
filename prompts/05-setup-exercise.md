---
Setup exercise: write it, then prove it
Source: workshop deck v0.2, Module 1 (slides 13-14). Baseline test prompt and correction step confirmed live in the deck's speaker notes — do not change the wording below without updating the deck to match.
Per-tool menu paths: [to be updated] — re-verify against each tool's live UI the week before the workshop, not just once during prep.
---

# Exercise: write it, then prove it

Four steps. The comparison should take seconds to see, not minutes to read — both runs stay under 100 words.

## Step 1 — Baseline

Before changing any settings, open a new conversation and paste this exactly:

> Give me feedback on this two-sentence summary of a research finding, written for a general audience. Respond with exactly 3 bullet points, no more than 100 words total.
>
> Summary: "Our lab found that a specific immune cell type builds up in aging tissue, and we're testing whether removing these cells with a small-molecule drug can improve organ function in old mice."

Keep this response visible — this is the "before."

## Step 2 — Write your standing instructions

Adapt this template:

> You are advising [your role — e.g., a group leader in biomedical pharmacology]. Be direct and factual: skip hedging and flattery like "great question" or "happy to help." If my reasoning or wording is weak, say so plainly instead of just polishing it. Default to prose over bullet points unless I ask for structure.
>
> Optional additions: preferred spelling convention (US/UK), preferred response length, 2-3 specific words or phrases you want banned.

## Step 3 — Save it

| Tool | Where |
|---|---|
| Claude | Settings → Profile → "What preferences should Claude consider in responses?" [to be updated] |
| ChatGPT | Profile icon → Customize ChatGPT, or Settings → Personalization → Custom Instructions [to be updated] |
| Microsoft Copilot | Copilot Chat → Settings → Personalization → Edit instructions [to be updated] |
| Perplexity | Settings → Personalization → Custom Instructions [to be updated] |
| Gemini | Menu → Settings & help → Personal Intelligence — personal accounts only, not available on UCPH work accounts [to be updated] |

## Step 4 — Re-run

Open a **brand-new** conversation — custom instructions apply going forward, not retroactively. Paste the identical prompt from Step 1.

## Step 5 — Compare

Put the before and after side by side with a neighbor.

- Different content, or just a different tone?
- Did it flatter you before, push back after?
- Which version would you trust for a gut check?
- What's still missing — what could a persona never fix on its own? (It changes tone and judgment, not what the AI actually knows about your work — that's what connectors are for.)

## Optional: prove it fixes a real mistake

If you have time, tell the AI it got one specific detail wrong in the summary — for example, "it's senescent cells, not immune cells" — and ask for a redo. Watch what the correction actually does to the answer: does it get folded in properly, or does it show up as a bolted-on patch ("Corrected: ...") instead of a rewritten sentence? That's one of the three ways instructions get ignored, covered later in the day.
