const PROMPT_SECTIONS = [
  {
    id: "section-1",
    title: "Section 1: Getting Started",
    description: "Short one-line description of this section.",
    prompts: [
      {
        title: "Example prompt 1",
        text: "This is placeholder prompt text for the first example.",
        contentPath: "prompts/section-1-example-prompt-1.md"
      },
      {
        title: "Example prompt 2",
        text: "Another placeholder prompt example.",
        contentPath: "prompts/section-1-example-prompt-2.md"
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
        text: "Act as a research assistant. Summarize the attached paper in 5 bullet points for a mixed technical audience.",
        contentPath: "prompts/section-2-role-and-goal-framing.md"
      },
      {
        title: "Constraint-first prompting",
        text: "Propose 3 workshop exercises. Constraints: no internet required, each under 10 minutes, and suitable for groups of 4-5.",
        contentPath: "prompts/section-2-constraint-first-prompting.md"
      },
      {
        title: "Iteration prompt",
        text: "Improve your previous answer for clarity. Keep the same structure, reduce jargon, and add one concrete example per section.",
        contentPath: "prompts/section-2-iteration-prompt.md"
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
        text: "Evaluate this draft against: accuracy, clarity, and actionability. Return a score from 1-5 for each and suggest one improvement.",
        contentPath: "prompts/section-3-quality-checklist.md"
      },
      {
        title: "Compare alternatives",
        text: "Generate two alternative agendas for the same workshop objective. One should be discussion-heavy and one should be demo-heavy.",
        contentPath: "prompts/section-3-compare-alternatives.md"
      }
    ]
  }
];

const SKILLS = [
  {
    id: "placeholder-skill-1",
    name: "Placeholder Skill 1",
    description: "One-line description of what this skill does.",
    filename: "placeholder-skill-1.md",
    content: `# Placeholder Skill 1\n\nFull placeholder skill text/markdown goes here - this is what renders in the viewer page and what the download file contains.\n\n## Example\n- Input: a short task description\n- Output: a structured response with key steps`,
    contentPath: "skills/placeholder-skill-1.md"
  },
  {
    id: "placeholder-skill-2",
    name: "Placeholder Skill 2",
    description: "A second placeholder skill focused on repeatable workflows.",
    filename: "placeholder-skill-2.md",
    content: `# Placeholder Skill 2\n\nThis is example content for a second skill file.\n\n## Workflow\n1. Gather context\n2. Generate options\n3. Validate outcome`,
    contentPath: "skills/placeholder-skill-2.md"
  },
  {
    id: "placeholder-skill-3",
    name: "Placeholder Skill 3",
    description: "A third placeholder skill for quality checks and review.",
    filename: "placeholder-skill-3.md",
    content: `# Placeholder Skill 3\n\nUse this for final checks before delivery.\n\n- Confirm formatting\n- Verify references\n- Summarize key decisions`,
    contentPath: "skills/placeholder-skill-3.md"
  }
];

const CONNECTORS = [
  {
    id: "claude-desktop-config",
    name: "Editing claude_desktop_config.json",
    description: "How to find and edit your Claude Desktop config file to add MCP connectors.",
    filename: "claude-desktop-config.md",
    contentPath: "connectors/claude-desktop-config.md",
    content: `# Editing claude_desktop_config.json\n\nPlaceholder step-by-step guide text goes here, including an example JSON config block.\n\n## Example JSON\n\n\`\`\`json\n{\n  "mcpServers": {\n    "example": {\n      "command": "node",\n      "args": ["server.js"]\n    }\n  }\n}\n\`\`\``
  },
  {
    id: "obsidian-vault",
    name: "Connecting an Obsidian Vault",
    description: "How to set up an MCP connector for an Obsidian vault.",
    filename: "obsidian-vault.md",
    contentPath: "connectors/obsidian-vault.md",
    content: `# Connecting an Obsidian Vault\n\nPlaceholder step-by-step guide text goes here.\n\n1. Locate your vault path\n2. Configure the connector\n3. Restart the client and verify indexing`
  },
  {
    id: "zotero",
    name: "Connecting Zotero",
    description: "How to set up an MCP connector for a Zotero library.",
    filename: "zotero.md",
    contentPath: "connectors/zotero.md",
    content: `# Connecting Zotero\n\nPlaceholder step-by-step guide text goes here.\n\n1. Export or access local metadata\n2. Configure connector credentials\n3. Test retrieval against known references`
  }
];

window.PROMPT_SECTIONS = PROMPT_SECTIONS;
window.SKILLS = SKILLS;
window.CONNECTORS = CONNECTORS;
