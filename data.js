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
  { id: "efficient-reports", name: "efficient-reports", description: "Write concise, decision-ready reports with a front-loaded bottom line, appropriate evidence, and no filler.", filename: "efficient-reports.skill" },
  { id: "memory-vault", name: "memory-vault", description: "Retrieve and maintain durable project context through a structured external memory vault, with deliberate rules for discovery, writing, and maintenance.", filename: "memory-vault.skill", contentPath: "skills/memory-vault.md" },
  { id: "prompt-upgrade", name: "prompt-upgrade", description: "Turn a rough prompt, half-formed idea, or task description into a finished, ready-to-send prompt for any AI chat tool.", filename: "prompt-upgrade.skill", contentPath: "skills/prompt-upgrade.md" },
  { id: "zotero-word-citations", name: "zotero-word-citations", description: "Build live Zotero-linked citations and reference lists in Word documents, with a connectivity check and explicit fallback rules.", filename: "zotero-word-citations.skill", contentPath: "skills/zotero-word-citations.md" }
];

const PLUGINS = [
  {
    id: "grant-writer",
    name: "grant-writer",
    description: "A Claude plugin for drafting grant applications with scope control, research-backed citation checks, and final-draft quality checks.",
    repository: "https://github.com/Aephir/Claude-Plugins",
    contents: "Three skills, a citation-verifier subagent, quality-control hooks, and MCP connections for PubMed, bioRxiv, ClinicalTrials, and BioRender."
  }
];

const PLUGIN_COMPONENTS = [
  { id: "claude-grant-writer", platform: "claude", name: "grant-writer", type: "Skill", description: "Plans, drafts, and reviews funding applications.", contentPath: "plugins/Claude/grant-writer-plugin/skills/grant-writer/SKILL.md" },
  { id: "claude-citation-check", platform: "claude", name: "citation-check", type: "Skill", description: "Verifies the references and claims in a draft.", contentPath: "plugins/Claude/grant-writer-plugin/skills/citation-check/SKILL.md" },
  { id: "claude-ai-slop-check", platform: "claude", name: "ai-slop-check", type: "Skill", description: "Checks drafts for canned phrasing, redundancy, and writing tells.", contentPath: "plugins/Claude/grant-writer-plugin/skills/ai-slop-check/SKILL.md" },
  { id: "claude-citation-verifier", platform: "claude", name: "citation-verifier", type: "Subagent", description: "Runs an independent, read-only citation review.", contentPath: "plugins/Claude/grant-writer-plugin/agents/citation-verifier.md" },
  { id: "claude-hooks", platform: "claude", name: "quality-control hooks", type: "Hooks", description: "Runs phrase and claims-ledger checks after relevant Markdown edits.", contentPath: "plugins/Claude/grant-writer-plugin/hooks/hooks.json" },
  { id: "claude-connectors", platform: "claude", name: "research connectors", type: "MCP servers", description: "Connects PubMed, ClinicalTrials.gov, bioRxiv, and BioRender.", contentPath: "plugins/Claude/grant-writer-plugin/.claude-plugin/plugin.json" },
  { id: "codex-grant-writer", platform: "chatgpt", name: "grant-writer", type: "Skill", description: "Plans, drafts, and reviews funding applications.", contentPath: "plugins/Claude/Codex/grant-writer/skills/grant-writer/SKILL.md" },
  { id: "codex-citation-check", platform: "chatgpt", name: "citation-check", type: "Skill", description: "Verifies the references and claims in a draft.", contentPath: "plugins/Claude/Codex/grant-writer/skills/citation-check/SKILL.md" },
  { id: "codex-citation-verifier", platform: "chatgpt", name: "citation-verifier", type: "Skill", description: "Runs an independent, read-only citation review.", contentPath: "plugins/Claude/Codex/grant-writer/skills/citation-verifier/SKILL.md" },
  { id: "codex-ai-slop-check", platform: "chatgpt", name: "ai-slop-check", type: "Skill", description: "Checks drafts for canned phrasing, redundancy, and writing tells.", contentPath: "plugins/Claude/Codex/grant-writer/skills/ai-slop-check/SKILL.md" },
  { id: "codex-phrase-sweep", platform: "chatgpt", name: "phrase_sweep.py", type: "Script", description: "Runs a deterministic phrase check on a Markdown draft.", contentPath: "plugins/Claude/Codex/grant-writer/scripts/phrase_sweep.py" },
  { id: "codex-ledger-check", platform: "chatgpt", name: "check_ledger_format.py", type: "Script", description: "Checks the structure of a claims ledger.", contentPath: "plugins/Claude/Codex/grant-writer/scripts/check_ledger_format.py" }
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
];

const HOMEWORK = {
  skillId: "adversarial-debate-review",
  framing: "adversarial-debate-review: an outline, not yet validated. Three AI agents argue a claim — for, against, and a judge. The design is real; it hasn't earned full trust yet. Finish building and validating it yourself if you want to learn how."
};

const SETUP_CONTENT_PATH = "connectors/memory-vault.md";

window.PROMPT_SECTIONS = PROMPT_SECTIONS;
window.SKILLS = SKILLS;
window.PLUGINS = PLUGINS;
window.PLUGIN_COMPONENTS = PLUGIN_COMPONENTS;
window.CONNECTORS = CONNECTORS;
window.HOMEWORK = HOMEWORK;
window.SETUP_CONTENT_PATH = SETUP_CONTENT_PATH;
