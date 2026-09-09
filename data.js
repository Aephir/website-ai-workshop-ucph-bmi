const PROMPT_SECTIONS = [
  {
    id: "module-1",
    title: "Module 1: Memory Vault",
    description: "Set up durable project context and package reusable instructions.",
    prompts: [
      { title: "Memory vault: single project", contentPath: "prompts/11-memory-vault-single-project.md" },
      { title: "Memory vault: universal", contentPath: "prompts/12-memory-vault-universal.md" },
      { title: "Add-on: skill packager", contentPath: "prompts/13-addon-skill-packager.md" },
      { title: "Add-on: setup assistant", contentPath: "prompts/14-addon-setup-assistant.md" },
      { title: "Memory vault structure", contentPath: "prompts/setup-memory-vault-structure.md" }
    ]
  },
  {
    id: "module-3",
    title: "Module 3: Skills and connectors",
    description: "Turn corrections into reusable instructions and test a real connector.",
    prompts: [
      { title: "Self-update standing instruction", contentPath: "prompts/31-self-update-standing-instruction.md" },
      { title: "Summarize methods", contentPath: "prompts/32-connector-summarize-methods.md" },
      { title: "Find sample size and species", contentPath: "prompts/33-connector-sample-size.md" },
      { title: "Search for a mention", contentPath: "prompts/34-connector-mentions-search.md" },
      { title: "Compare limitations", contentPath: "prompts/35-connector-compare-limitations.md" }
    ]
  },
  {
    id: "module-4",
    title: "Module 4: Citation checking",
    description: "Practice a structured citation verification workflow.",
    prompts: [
      { title: "Citation-check exercise", contentPath: "prompts/41-citation-check-exercise.md" }
    ]
  },
  {
    id: "module-6",
    title: "Module 6: Prompting techniques",
    description: "Make AI outputs more specific, testable, and useful.",
    prompts: [
      { title: "CRAFT", contentPath: "prompts/61-craft.md" },
      { title: "Constraint injection", contentPath: "prompts/62-constraint-injection.md" },
      { title: "Worst-ideas-first", contentPath: "prompts/63-worst-ideas-first.md" },
      { title: "Idea stress test", contentPath: "prompts/64-idea-stress-test.md" }
    ]
  }
];

const SKILLS = [
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
    contents: "Three skills, a citation-verifier subagent, quality-control hooks, and MCP connections for PubMed, bioRxiv, ClinicalTrials, and BioRender.",
    downloads: [
      { label: "Download .plugin", href: "plugins/grant-writer-plugin.plugin", filename: "grant-writer-plugin.plugin" },
      { label: "Download .zip", href: "plugins/grant-writer-plugin.zip", filename: "grant-writer-plugin.zip" }
    ]
  }
];

const PLUGIN_COMPONENTS = [
  { id: "claude-grant-writer", platform: "claude", name: "grant-writer", type: "Skill", description: "Plans, drafts, and reviews funding applications.", contentPath: "plugins/Claude/grant-writer-plugin/skills/grant-writer/SKILL.md" },
  { id: "claude-citation-check", platform: "claude", name: "citation-check", type: "Skill", description: "Verifies the references and claims in a draft.", contentPath: "plugins/Claude/grant-writer-plugin/skills/citation-check/SKILL.md" },
  { id: "claude-ai-slop-check", platform: "claude", name: "ai-slop-check", type: "Skill", description: "Checks drafts for canned phrasing, redundancy, and writing tells.", contentPath: "plugins/Claude/grant-writer-plugin/skills/ai-slop-check/SKILL.md" },
  { id: "claude-citation-verifier", platform: "claude", name: "citation-verifier", type: "Subagent", description: "Runs an independent, read-only citation review.", contentPath: "plugins/Claude/grant-writer-plugin/agents/citation-verifier.md" },
  { id: "claude-hooks", platform: "claude", name: "quality-control hooks", type: "Hooks", description: "Runs phrase and claims-ledger checks after relevant Markdown edits.", contentPath: "plugins/Claude/grant-writer-plugin/hooks/hooks.json" },
  { id: "claude-connectors", platform: "claude", name: "research connectors", type: "MCP servers", description: "Connects PubMed, ClinicalTrials.gov, bioRxiv, and BioRender.", contentPath: "plugins/Claude/grant-writer-plugin/.claude-plugin/plugin.json" },
  { id: "codex-grant-writer", platform: "chatgpt", name: "grant-writer", type: "Skill", description: "Plans, drafts, and reviews funding applications.", contentPath: "plugins/Codex/grant-writer/skills/grant-writer/SKILL.md" },
  { id: "codex-citation-check", platform: "chatgpt", name: "citation-check", type: "Skill", description: "Verifies the references and claims in a draft.", contentPath: "plugins/Codex/grant-writer/skills/citation-check/SKILL.md" },
  { id: "codex-citation-verifier", platform: "chatgpt", name: "citation-verifier", type: "Skill", description: "Runs an independent, read-only citation review.", contentPath: "plugins/Codex/grant-writer/skills/citation-verifier/SKILL.md" },
  { id: "codex-ai-slop-check", platform: "chatgpt", name: "ai-slop-check", type: "Skill", description: "Checks drafts for canned phrasing, redundancy, and writing tells.", contentPath: "plugins/Codex/grant-writer/skills/ai-slop-check/SKILL.md" },
  { id: "codex-phrase-sweep", platform: "chatgpt", name: "phrase_sweep.py", type: "Script", description: "Runs a deterministic phrase check on a Markdown draft.", contentPath: "plugins/Codex/grant-writer/scripts/phrase_sweep.py" },
  { id: "codex-ledger-check", platform: "chatgpt", name: "check_ledger_format.py", type: "Script", description: "Checks the structure of a claims ledger.", contentPath: "plugins/Codex/grant-writer/scripts/check_ledger_format.py" }
];

const CONNECTOR_PLATFORMS = [
  {
    id: "claude",
    name: "Claude",
    sections: [
      ["Store", "Settings → Connectors → Browse connectors, or from any chat use Search and tools → Add connectors. Click a connector, select Connect, and authenticate."],
      ["Your own", "Customize → Connectors → + → Add custom connector, then paste your remote MCP server URL. It supports authless and OAuth-based servers. On Team/Enterprise, an organization owner adds the URL under Organization settings → Connectors first; members then connect it the same way."],
      ["Plan note", "Paid plans only: Pro, Max, Team, and Enterprise. Free plans get one custom connector. Browsing and adding works on web, desktop, and Cowork, not mobile."],
      ["Local-only note", "A locally run MCP server configured through claude_desktop_config.json is separate from the connector UI. Claude Desktop will not pick up a remote server placed directly in that file."]
    ]
  },
  {
    id: "copilot",
    name: "Microsoft Copilot",
    sections: [
      ["Store", "There is no self-serve browse-connectors store for end users. Connectors such as SharePoint sites and Graph connectors are provisioned by IT or an administrator. Once enabled, they appear as sources: in Copilot Chat, type / and search by name, or use Add and manage sources (+) to attach files, cloud files, or a SharePoint site."],
      ["Your own", "There is no self-serve custom-connector option in ordinary chat. Custom connectors require Copilot Studio, an add-on configured by IT or an administrator."],
      ["Plan note", "Access is administrator-gated end to end. What an individual sees depends on what their organization has enabled."]
    ]
  },
  {
    id: "chatgpt",
    name: "ChatGPT",
    sections: [
      ["Store", "OpenAI has folded Connectors into the Apps ecosystem. Browse through the Plugins or Apps directory from the composer's + menu or Settings → Apps, choose an app, select Connect, and authenticate. Naming and locations may continue to change."],
      ["Your own", "Turn on Developer Mode under Settings → Apps → Advanced Settings. Then use Settings → Apps → Create, enter your MCP server endpoint and authentication method, scan tools, and create the draft under Workspace Settings → Apps → Drafts."],
      ["Plan note", "Full custom MCP with write access is available to Business, Enterprise, and Edu. Plus and Pro get read-only access in Developer Mode. Prebuilt app connectors are broader but still vary by plan, workspace policy, and region."]
    ]
  },
  {
    id: "gemini",
    name: "Gemini",
    sections: [
      ["Store", "There is no separate connector directory. Google Workspace access to Gmail, Drive, Docs, Calendar, Tasks, and Keep is built in. In a chat, reference a service with @, such as @Drive, or ask Gemini to use it; approve the connection the first time. Manage active connections at gemini.google.com/apps → Connected Apps."],
      ["Your own", "There is no user-facing custom-connector or MCP mechanism in the consumer app."],
      ["Plan note", "Personal accounts need Keep Activity turned on. Work and school accounts need an administrator to enable app connections organization-wide."]
    ]
  },
  {
    id: "perplexity",
    name: "Perplexity",
    sections: [
      ["Store", "Account settings → Connectors lets you browse and connect prebuilt services such as Drive and Dropbox."],
      ["Your own", "On the same page, choose + Custom connector → Remote, enter a name and the MCP server HTTPS URL, optionally set authentication, transport, and icon, acknowledge the risk notice, select Add, then open the card to authenticate."],
      ["Plan note", "Pro users can add personal custom connectors. Organization-wide sharing and enabling connectors for other members requires an Enterprise administrator under Enterprise settings → Permissions → Connectors permissions."]
    ]
  }
];

const HOMEWORK = {
  skill: {
    id: "adversarial-debate-review",
    name: "adversarial-debate-review",
    filename: "adversarial-debate-review.skill",
    contentPath: "skills/adversarial-debate-review.md"
  },
  framing: "adversarial-debate-review: an outline, not yet validated. Three AI agents argue a claim — for, against, and a judge. The design is real; it hasn't earned full trust yet. Finish building and validating it yourself if you want to learn how."
};

const SETUP_CONTENT_PATH = "connectors/memory-vault.md";

window.PROMPT_SECTIONS = PROMPT_SECTIONS;
window.SKILLS = SKILLS;
window.PLUGINS = PLUGINS;
window.PLUGIN_COMPONENTS = PLUGIN_COMPONENTS;
window.CONNECTOR_PLATFORMS = CONNECTOR_PLATFORMS;
window.HOMEWORK = HOMEWORK;
window.SETUP_CONTENT_PATH = SETUP_CONTENT_PATH;
