# Editing claude_desktop_config.json

Some connectors cannot, or should not be set up in the app user interface. They are instead written manually into s special file called `claude_desktop_config.json`.

This file is typically located at `~/Library/Application Support/Claude/claude_desktop_config.json`
Placeholder step-by-step guide text goes here, including an example JSON config block.

## Example JSON

```json
{
  "mcpServers": {
    "example_1": {
      "command": "node",
      "args": ["server.js"]
    },
    "example_2": {
      "command": "node",
      "args": ["server.js"]
    },
    "example_3": {
      "command": "node",
      "args": ["server.js"]
    }
  }
}
```
