# adversarial-debate-review

Structured multi-agent technique for surfacing real, fact-grounded issues in a piece of writing or a proposed decision. It forces opposing sides to argue with citations and uses a separate arbiter to judge.

This is a subroutine, not a user-facing deliverable generator. Invoke it deliberately for high-stakes, claims-heavy points rather than every claim in a document.

## Modes

- `fact`: debate discrete factual claims using independently verifiable evidence.
- `decision`: debate proposed courses of action after checking their factual premises.

## Output

Return structured records containing the unit, domain and persona, verdict, winning argument, counterargument, citation verification, grounding tier, fabrication findings, and the standing caveat that the three roles are the same underlying model in different framings.
