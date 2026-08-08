# Connecting an Obsidian Vault

This is set up in the [claude_desktop_config.json](view.html?type=connector&id=claude-desktop-config) file.

Placeholder step-by-step guide text goes here.

1. Locate or choose your vault path. We will call this `$VAULTPATH` below
2. Configure the connector
    A. In a terminal, type `npm install -g @bitbonsai/mcpvault`
    B. Add the following in `claude_desktop_config.json` under the `mcpServers`section:
    ```
    "vault-work-notes": {
      "command": "/opt/homebrew/bin/mcpvault",
      "args": [
        "$VAULTPATH"
      ]
    },
    ```

3. Restart the client and verify indexing

