---
Prompting technique: constraint injection (Module 6, supplemental)
New example for this workshop.
Moved to the "Prompting reference" recap at the end of the deck (slide 59) -- covered live only if time remains after Module 5; otherwise handed out as take-home reference. Not a scheduled exercise slot.
---

# Constraint injection

Vague requests get vague, unverifiable answers. Add explicit, checkable constraints up front — format, length, scope, what's out of bounds — and the output becomes something you can actually check against a list, not just a feeling of "looks about right."

## The pattern

State the task, then a short, explicit list of constraints the output must satisfy. Concrete and binary beats vague and vibes-based — "under 150 words" is checkable, "be concise" is not.

## Example prompt

> Propose 3 icebreaker exercises for a 25-person workshop. Constraints: each takes under 5 minutes, needs no materials or internet, works for a mixed group of strangers, and doesn't require anyone to stand up or speak first without volunteering.

## Why this works

Without the constraints, you'd get 3 generic icebreakers and have to manually check each one against everything you actually needed — room, time, materials, comfort level. With them stated up front, a bad suggestion is obviously wrong on its face, and you can ask the AI to check its own answer against the list before you even read it.
