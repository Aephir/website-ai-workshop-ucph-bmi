---
Prompting technique: CRAFT
Retaught from the BMI retreat workshop — same framework, new example (not the intermittent-fasting-in-T2D example used there).
---

# CRAFT

Five things a good prompt states explicitly, so the AI isn't guessing at any of them:

- **Context** — the situation. What's this for, what does the AI need to know to get it right?
- **Role** — who the AI should act as, or who it's advising.
- **Action** — the actual task, stated as a specific instruction, not a topic.
- **Format** — the shape of the output: length, structure, what to include or leave out.
- **Target** — the audience. Who's actually going to read this, and what do they already know?

## Example — lazy vs. CRAFT

**Lazy:**

> Write something about our new imaging results for the collaboration meeting.

**CRAFT:**

> Context: We just got confocal imaging results showing stronger co-localization than expected between two markers in our knockout model — this changes our working hypothesis about the mechanism.
>
> Role: You're helping me, a group leader, prepare for a monthly collaboration meeting with an external lab.
>
> Action: Draft a short update on this finding for the meeting agenda.
>
> Format: One paragraph, under 120 words. State the finding, what it changes about our hypothesis, and one concrete next step. No hedging language.
>
> Target: The other lab's PI and two postdocs — they know the project background but haven't seen this data yet.

## One more thing: give it an example

The single highest-leverage addition beyond the five elements above: show it what "good" looks like, not just describe it. Adding one sentence like "Here's an example of the tone I want: [paste a paragraph you've written before]" often does more than another round of tuning Format and Target on their own.

## What changes

The lazy version forces the AI to guess your audience, your format, and how much background to assume — it'll default to something generic and probably too long or too vague to use as-is. CRAFT removes the guessing: every element the AI would otherwise have to invent is already decided, so the output is closer to something you'd actually send.
