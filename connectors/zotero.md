# Connecting Zotero

Lets Claude search your Zotero library, read full text of your papers, and manage annotations/notes/collections directly from chat. Requires the Zotero desktop app to be installed and running (this connects to Zotero's local API, not zotero.org directly).

**Not a one-click connector.** This is a local server you install yourself. If that's more setup than you want, see *Easier alternatives* below before the full guide.

**There's also an automated install script** that walks you through the whole process below step by step — one for macOS, one for Windows. It runs the technical parts for you (installing `uv`, installing the connector, editing the config file) and prompts you for the manual parts (turning on Zotero's local API, pasting in your own API key and library ID). It makes a backup of your config file before touching it and tells you how to restore it. Download the installer for your platform: [macOS](scripts/install-zotero-mcp.command), [Windows PowerShell](scripts/install-zotero-mcp.ps1), or [Windows Command Prompt](scripts/install-zotero-mcp.bat). Built for people who've never used a terminal before.

## Easier alternatives (checked 2026-08-24)

- **Just drag a PDF into the chat window.** Works in Claude, ChatGPT, Copilot, Gemini — zero setup, reads the full text. Doesn't give you library search or citation metadata, but covers "ask the AI about this one paper" for most day-to-day use.
- **Microsoft Copilot + your OneDrive/SharePoint papers folder.** One-click, already enabled on your UCPH account, reads full PDF text via Microsoft's semantic index. If you keep your PDFs in a OneDrive folder anyway, this needs no extra setup at all.
- **Readwise Reader's official MCP** (mcp2.readwise.io) is a genuine one-click OAuth connector for Claude and ChatGPT, and returns full document text — but Reader is a read-it-later tool, not a citation manager (no BibTeX, no citation keys). Only worth it if you're open to importing papers into Reader instead of Zotero.
- A third-party hosted Zotero MCP now exists (search "MCP for Zotero" on the Zotero forums) that skips the `uv tool install` step below. It's not run by Zotero or Anthropic — it holds a copy of your Zotero API key on a server you don't control, so that's a real trust trade-off against the extra 10 minutes of local setup below. Your call.

None of the above is what we'll set up live in the workshop — see the workshop slides for what we do hands-on instead.

---

## Full guide: local Zotero MCP server

### 1. Turn on Zotero's local API

The connector talks directly to the Zotero desktop app on your machine, not to zotero.org — Zotero blocks this by default, silently (no error either way if you skip it).

1. In Zotero: **Zotero → Settings** (macOS) or **Edit → Settings** (Windows) → **Advanced** tab.
2. Under **Miscellaneous**, check **"Allow other applications on this computer to communicate with Zotero."**
3. Restart Zotero.

### 2. Get a Zotero API key and library ID

1. Go to [zotero.org/settings/keys](https://www.zotero.org/settings/keys) and create a new private key. Copy it somewhere safe — you won't see it again.
2. On the same page, note your **User ID** (this is your library ID) shown at the top.

### 3. Install `uv` (the tool that installs the connector)

**macOS** — open Terminal and run either of:
```bash
# via Homebrew (if you already use Homebrew)
brew install uv

# or via the official installer, no Homebrew needed
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows** — open PowerShell and run:
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 4. Install the Zotero connector

Same command on both operating systems:
```bash
uv tool install zotero-mcp-server
```

This installs a small program called `zotero-mcp`. Note where it lands — you'll need the path in step 6:
- **macOS**: `~/.local/bin/zotero-mcp`
- **Windows**: `%USERPROFILE%\.local\bin\zotero-mcp.exe` (uv does *not* add this to your PATH automatically — that's fine, we'll use the full path)

### 5. Find and open `claude_desktop_config.json`

See [Editing claude_desktop_config.json](view.html?type=connector&id=claude-desktop-config) for how to locate and open this file on your OS.

### 6. Add the Zotero entry

Paste this inside the `mcpServers` object, replacing the placeholders with your own key and ID from step 2:

**macOS**
```json
"zotero": {
  "command": "/Users/YOUR_USERNAME/.local/bin/zotero-mcp",
  "env": {
    "ZOTERO_LOCAL": "true",
    "ZOTERO_API_KEY": "YOUR_API_KEY_HERE",
    "ZOTERO_LIBRARY_ID": "YOUR_LIBRARY_ID_HERE"
  }
}
```

**Windows**
```json
"zotero": {
  "command": "C:\\Users\\YOUR_USERNAME\\.local\\bin\\zotero-mcp.exe",
  "env": {
    "ZOTERO_LOCAL": "true",
    "ZOTERO_API_KEY": "YOUR_API_KEY_HERE",
    "ZOTERO_LIBRARY_ID": "YOUR_LIBRARY_ID_HERE"
  }
}
```

Save the file.

### 7. Restart and test

1. Make sure the Zotero desktop app is open and running — the connector talks to it locally, not to zotero.org.
2. Fully quit and reopen Claude Desktop.
3. Ask Claude something like "search my Zotero library for papers on [your topic]" to confirm it's working.

### Troubleshooting

- **Nothing happens / Claude says it has no Zotero access**: confirm Zotero desktop is actually running, that Zotero → Settings → Advanced → "Allow other applications on this computer to communicate with Zotero" is checked (step 1 — Zotero doesn't warn you if it's off), and that you fully quit (not just closed the window) and reopened Claude Desktop after editing the config.
- **"command not found" errors**: double-check the path in step 6 matches exactly where `uv tool install` put the binary in step 4 — copy-paste it rather than retyping.
- Full command reference and support: `zotero-mcp setup-info` in Terminal/PowerShell prints your current config with secrets masked, useful for double-checking without re-copying your key.
