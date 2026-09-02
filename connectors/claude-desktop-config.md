# Editing claude_desktop_config.json

Some connectors (mostly ones that run locally on your own machine, like Zotero) can't be set up by clicking "Connect" in the app — you add them by hand to a file called `claude_desktop_config.json`. This page covers the general mechanics; each connector's own page (e.g. [Zotero](view.html?type=connector&id=zotero)) tells you exactly what to paste in.

## Finding the file

The file may not exist yet the first time you do this — if so, create it at the path below with just `{"mcpServers": {}}` as its starting content.

**macOS**
1. In Finder, press `⇧ ⌘ G` ("Go to Folder").
2. Paste this path and press Enter:
   ```
   ~/Library/Application Support/Claude/claude_desktop_config.json
   ```

**Windows**
1. Open File Explorer.
2. Click into the address bar and paste:
   ```
   %APPDATA%\Claude\claude_desktop_config.json
   ```
3. Press Enter.

Open the file in any plain-text editor (TextEdit on macOS — turn off "rich text" in its Format menu first; Notepad on Windows is fine as-is).

## The general shape

Every connector gets its own entry inside `mcpServers`. You can have several at once:

```json
{
  "mcpServers": {
    "example_1": {
      "command": "node",
      "args": ["server.js"]
    },
    "example_2": {
      "command": "/Users/you/.local/bin/some-tool",
      "env": {
        "SOME_KEY": "your-value-here"
      }
    }
  }
}
```

- `command` — the program to run. On Windows this is the full path including `.exe` if it's a locally-installed binary (as opposed to something like `npx`, which doesn't need one).
- `args` — command-line arguments, if the tool needs any.
- `env` — environment variables the tool needs (API keys, config flags). Not every connector needs this.

**JSON is strict about commas and quotes.** If Claude Desktop won't start after you edit this file, the most common cause is a missing or extra comma between entries — check `%APPDATA%\Claude\logs` (Windows) or `~/Library/Application Support/Claude/logs` (macOS) for the actual error if it's not obvious.

## After editing

Fully quit Claude Desktop (not just close the window) and reopen it. New or changed entries only take effect after a full restart.
