const PROMPT_SECTIONS = [
  {
    id: "section-1",
    title: "Section 1: Getting Started",
    description: "Short one-line description of this section.",
    prompts: [
      {
        title: "Example prompt 1",
        text: "This is placeholder prompt text for the first example."
      },
      {
        title: "Example prompt 2",
        text: "Another placeholder prompt example."
      }
    ]
  },
  {
    id: "section-2",
    title: "Section 2: Prompt Patterns",
    description: "Reusable patterns for clearer and more controllable prompts.",
    prompts: [
      {
        title: "Role and goal framing",
        text: "Act as a research assistant. Summarize the attached paper in 5 bullet points for a mixed technical audience."
      },
      {
        title: "Constraint-first prompting",
        text: "Propose 3 workshop exercises. Constraints: no internet required, each under 10 minutes, and suitable for groups of 4-5."
      },
      {
        title: "Iteration prompt",
        text: "Improve your previous answer for clarity. Keep the same structure, reduce jargon, and add one concrete example per section."
      }
    ]
  },
  {
    id: "section-3",
    title: "Section 3: Evaluation and Refinement",
    description: "Methods for testing quality and refining outputs quickly.",
    prompts: [
      {
        title: "Quality checklist",
        text: "Evaluate this draft against: accuracy, clarity, and actionability. Return a score from 1-5 for each and suggest one improvement."
      },
      {
        title: "Compare alternatives",
        text: "Generate two alternative agendas for the same workshop objective. One should be discussion-heavy and one should be demo-heavy."
      }
    ]
  }
];

const SKILLS = [
  {
    id: "placeholder-skill-1",
    name: "Placeholder Skill 1",
    description: "One-line description of what this skill does.",
    filename: "placeholder-skill-1.skill",
    content: `# Placeholder Skill 1\n\nFull placeholder skill text/markdown goes here — this is what renders in the viewer page and what the download file contains.\n\n## Example\n- Input: a short task description\n- Output: a structured response with key steps`
  },
  {
    id: "placeholder-skill-2",
    name: "Placeholder Skill 2",
    description: "A second placeholder skill focused on repeatable workflows.",
    filename: "placeholder-skill-2.skill",
    content: `# Placeholder Skill 2\n\nThis is example content for a second skill file.\n\n## Workflow\n1. Gather context\n2. Generate options\n3. Validate outcome`
  },
  {
    id: "placeholder-skill-3",
    name: "Placeholder Skill 3",
    description: "A third placeholder skill for quality checks and review.",
    filename: "placeholder-skill-3.skill",
    content: `# Placeholder Skill 3\n\nUse this for final checks before delivery.\n\n- Confirm formatting\n- Verify references\n- Summarize key decisions`
  }
];

const CONNECTORS = [
  {
    id: "claude-desktop-config",
    name: "Editing claude_desktop_config.json",
    description: "How to find and edit your Claude Desktop config file to add MCP connectors.",
    content: `# Editing claude_desktop_config.json\n\nPlaceholder step-by-step guide text goes here, including an example JSON config block.\n\nExample:\n{\n  "mcpServers": {\n    "example": {\n      "command": "node",\n      "args": ["server.js"]\n    }\n  }\n}`
  },
  {
    id: "obsidian-vault",
    name: "Connecting an Obsidian Vault",
    description: "How to set up an MCP connector for an Obsidian vault.",
    content: `# Connecting an Obsidian Vault\n\nPlaceholder step-by-step guide text goes here.\n\n1. Locate your vault path\n2. Configure the connector\n3. Restart the client and verify indexing`
  },
  {
    id: "zotero",
    name: "Connecting Zotero",
    description: "How to set up an MCP connector for a Zotero library.",
    content: `# Connecting Zotero\n\nPlaceholder step-by-step guide text goes here.\n\n1. Export or access local metadata\n2. Configure connector credentials\n3. Test retrieval against known references`
  }
];

window.PROMPT_SECTIONS = PROMPT_SECTIONS;
window.SKILLS = SKILLS;
window.CONNECTORS = CONNECTORS;
