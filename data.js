const PROMPT_SECTIONS = [
  {
    id: "memory-vault",
    title: "Module 1: Set it up",
    description: "A four-file memory-vault prompt set for keeping project context durable across conversations. Read the usage note first, then choose one base prompt and add-ons.",
    prompts: [
      { title: "Memory vault: single project", contentPath: "prompts/01-memory-vault-single-project.md" },
      { title: "Memory vault: universal", contentPath: "prompts/02-memory-vault-universal.md" },
      { title: "Add-on: skill packager", contentPath: "prompts/03-addon-skill-packager.md" },
      { title: "Add-on: setup assistant", contentPath: "prompts/04-addon-setup-assistant.md" }
    ]
  },
  {
    id: "prompting-techniques",
    title: "Prompting techniques",
    description: "Concrete patterns from the workshop for making AI outputs more specific, testable, and useful.",
    prompts: [
      { title: "Worst-ideas-first", contentPath: "prompts/06-worst-ideas-first.md" },
      { title: "Constraint injection", contentPath: "prompts/08-constraint-injection.md" },
      { title: "Idea stress test", contentPath: "prompts/09-idea-stress-test.md" },
      { title: "CRAFT", contentPath: "prompts/10-craft.md" }
    ]
  },
  {
    id: "exercises-and-workflows",
    title: "Exercises and workflows",
    description: "Exercises for testing a live connection and turning corrections into durable instructions.",
    prompts: [
      { title: "Ask a real question about your own paper", contentPath: "prompts/07-connector-test-query.md" },
      { title: "Self-update standing instruction", contentPath: "prompts/11-self-update-standing-instruction.md" }
    ]
  }
];

const SKILLS = [
  { id: "adversarial-debate-review", name: "adversarial-debate-review", description: "Run a structured three-agent adversarial debate to stress-test a specific factual claim or strategic decision.", filename: "adversarial-debate-review.skill", contentPath: "skills/adversarial-debate-review.md" },
  { id: "citation-check", name: "citation-check", description: "Verify that citations and references exist, have correct metadata, support their claims, and have not been retracted.", filename: "citation-check.skill", contentPath: "skills/citation-check.md" },
  { id: "consolidate-instructions", name: "consolidate-instructions", description: "Review corrections and preferences logged in a memory queue and propose exact wording for standing instructions or skills.", filename: "consolidate-instructions.skill", contentPath: "skills/consolidate-instructions.md" },
  { id: "prompt-upgrade", name: "prompt-upgrade", description: "Turn a rough prompt, half-formed idea, or task description into a finished, ready-to-send prompt for any AI chat tool.", filename: "prompt-upgrade.skill", contentPath: "skills/prompt-upgrade.md" },
  { id: "zotero-word-citations", name: "zotero-word-citations", description: "Build live Zotero-linked citations and reference lists in Word documents, with a connectivity check and explicit fallback rules.", filename: "zotero-word-citations.skill", contentPath: "skills/zotero-word-citations.md" }
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
  },
  {
    id: "pubmed",
    name: "Connecting PubMed",
    description: "How to connect PubMed to Claude, and what to do on platforms without a dedicated connector.",
    filename: "pubmed.md",
    contentPath: "connectors/pubmed.md",
    content: ""
  },
  {
    id: "memory-vault",
    name: "Memory vault",
    description: "A single-project memory system for keeping durable context in a small set of files.",
    filename: "memory-vault.md",
    contentPath: "connectors/memory-vault.md",
    content: ""
  }
];

const HOMEWORK = {
  skillId: "adversarial-debate-review",
  framing: "adversarial-debate-review: an outline, not yet validated. Three AI agents argue a claim — for, against, and a judge. The design is real; it hasn't earned full trust yet. Finish building and validating it yourself if you want to learn how."
};

const SETUP_CONTENT_PATH = "prompts/05-setup-exercise.md";

window.PROMPT_SECTIONS = PROMPT_SECTIONS;
window.SKILLS = SKILLS;
window.CONNECTORS = CONNECTORS;
window.HOMEWORK = HOMEWORK;
window.SETUP_CONTENT_PATH = SETUP_CONTENT_PATH;
