#!/bin/bash
#
# install-zotero-mcp.command
#
# Sets up the Zotero MCP connector for Claude Desktop on macOS, from a
# blank machine: Homebrew -> uv -> zotero-mcp-server -> your API key/library
# ID -> claude_desktop_config.json.
#
# Written for people who have never used Terminal before. You can double-
# click this file in Finder to run it. If macOS blocks it the first time
# ("unidentified developer"), go to settings –> Privacy & Security and scroll.
# the the bottom under "Security", and click to allow it to run.
#
# Safe to run more than once -- it checks what's already done and skips it.
# Nothing here needs sudo / an admin password, and nothing outside your own
# Claude config and Homebrew's own folders is touched.

set -u

# ---------------------------------------------------------------------------
# Little helpers
# ---------------------------------------------------------------------------

say()  { printf '\n\033[1m%s\033[0m\n' "$1"; }
info() { printf '  %s\n' "$1"; }
ok()   { printf '  \xe2\x9c\x93 %s\n' "$1"; }
warn() { printf '  \xe2\x9a\xa0  %s\n' "$1"; }
fail() {
  printf '\n  \xe2\x9c\x97 %s\n' "$1"
  printf '\nSomething stopped the install. Nothing has been left half-edited --\n'
  printf 'your Claude config (if we got that far) was backed up first, see above.\n'
  printf 'Copy the message above and send it to Walden if you are stuck.\n\n'
  read -r -p "Press Return to close this window... " _
  exit 1
}
pause() { read -r -p "  Press Return to continue... " _; }

confirm() {
  # confirm "question" -> returns 0 for yes, 1 for no. Defaults to yes on plain Return.
  local reply
  read -r -p "  $1 [Y/n] " reply
  case "$reply" in
    [nN]*) return 1 ;;
    *) return 0 ;;
  esac
}

if [ "$(id -u)" -eq 0 ]; then
  fail "This script was run with sudo (or as root) -- don't do that. Homebrew refuses to install anything when run as root, which is exactly the error you just hit. Nothing in this script needs sudo or an admin-password prompt. Close this window and double-click the file normally instead. If macOS blocks it the first time as being from an 'unidentified developer', go to System Settings -> Privacy & Security, scroll to the bottom, and click to allow it to run -- that is the only extra step, and it still does not need sudo."
fi

cd "$HOME" || fail "Could not switch to your home folder."

clear
cat <<'BANNER'
====================================================================
  Zotero + Claude Desktop connector -- guided install
====================================================================

This script will, in order:

  1. Remind you to turn on Zotero's local API (one manual click)
  2. Install Homebrew (a package manager for Mac), if you don't have it
  3. Install uv (a small tool installer), if you don't have it
  4. Install the Zotero connector itself
  5. Ask you to paste in a Zotero API key and library ID
  6. Back up, then edit, Claude Desktop's config file to turn it on

Each step explains itself before it does anything. Nothing is
irreversible -- step 6 makes a backup and tells you exactly how to
undo it if anything goes wrong.

You will need:
  - About 10 minutes
  - The Zotero desktop app already installed (get it from zotero.org
    if you don't have it -- you can still run steps 2-4 without it,
    but Zotero itself must be open for the connector to actually work)
  - Claude Desktop installed (the "Cowork" / desktop app, not just
    the web browser version)
====================================================================
BANNER
pause

# ---------------------------------------------------------------------------
# Step 0: sanity checks
# ---------------------------------------------------------------------------

say "Step 0 of 7 -- quick checks"

if [ "$(uname)" != "Darwin" ]; then
  fail "This script is for macOS only. If you're on Windows, see the Windows guide on workshop.walden.dk -> Connectors -> Zotero instead."
fi

if [ -d "/Applications/Zotero.app" ]; then
  ok "Zotero.app found in /Applications."
else
  warn "Zotero.app was not found in /Applications."
  info "Download and install it from https://www.zotero.org/download/ -- you can"
  info "keep this window open and come back to it, the rest of this script"
  info "still works, but the connector won't actually do anything until"
  info "Zotero is installed AND running."
  confirm "Continue anyway?" || { info "Come back once Zotero is installed."; exit 0; }
fi

if pgrep -x "Zotero" >/dev/null 2>&1; then
  ok "Zotero desktop app is running."
else
  warn "Zotero desktop app doesn't look like it's running right now."
  info "It needs to be open for the connector to work -- the connector talks"
  info "to Zotero's own app, not to zotero.org directly. Open it whenever you like,"
  info "it doesn't have to be running for the rest of this install."
fi

if pgrep -x "Claude" >/dev/null 2>&1; then
  warn "Claude Desktop looks like it's currently running."
  info "That's fine for now -- you'll need to fully quit and reopen it at the"
  info "very end, after we edit its config file. A reminder will print then."
fi

# ---------------------------------------------------------------------------
# Step 1: turn on Zotero's local API (manual -- can't be automated from here)
# ---------------------------------------------------------------------------

say "Step 1 of 7 -- turn on Zotero's local API"
info "The connector talks directly to the Zotero app on your machine, not to"
info "zotero.org -- Zotero blocks this by default, and won't warn you either"
info "way if it's off."
echo
info "In Zotero: Zotero menu -> Settings -> Advanced tab."
info "Under Miscellaneous, check 'Allow other applications on this computer"
info "to communicate with Zotero.' Then restart Zotero."
pause

# ---------------------------------------------------------------------------
# Step 2: Homebrew
# ---------------------------------------------------------------------------

say "Step 2 of 7 -- Homebrew"
info "Homebrew is the standard way to install command-line tools on a Mac."
info "If you already have it, this step just confirms that and moves on."

if command -v brew >/dev/null 2>&1; then
  ok "Homebrew is already installed ($(command -v brew))."
else
  info "Installing Homebrew now. This runs Homebrew's own official installer."
  info "It may ask for your Mac login password in this window (normal --"
  info "that's macOS asking permission to install software, not this script)."
  pause
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || fail "Homebrew's installer did not finish successfully. Try re-running this script -- if it fails again, copy the error above and send it to Walden."
fi

# Homebrew lives in a different folder depending on chip type. Work out
# which, and make sure THIS script's session can see it right away.
if [ -x "/opt/homebrew/bin/brew" ]; then
  BREW_PATH="/opt/homebrew/bin/brew"
elif [ -x "/usr/local/bin/brew" ]; then
  BREW_PATH="/usr/local/bin/brew"
else
  fail "Homebrew installed, but its 'brew' program can't be found where expected. Please send this message to Walden."
fi

eval "$("$BREW_PATH" shellenv)"

# Add Homebrew permanently to PATH, so every future Terminal window can
# find it too -- not just this script. Homebrew's installer prints
# instructions for this rather than doing it; we do it here so nothing
# manual is left over.
case "$SHELL" in
  */zsh)  PROFILE_FILE="$HOME/.zprofile" ;;
  */bash) PROFILE_FILE="$HOME/.bash_profile" ;;
  *)      PROFILE_FILE="$HOME/.zprofile" ;;  # zsh has been the macOS default since 2019
esac

SHELLENV_LINE="eval \"\$($BREW_PATH shellenv)\""
if [ -f "$PROFILE_FILE" ] && grep -Fq "$SHELLENV_LINE" "$PROFILE_FILE" 2>/dev/null; then
  ok "Homebrew is already set to load automatically (in $PROFILE_FILE)."
else
  printf '\n# Added by install-zotero-mcp.command on %s\n%s\n' "$(date '+%Y-%m-%d')" "$SHELLENV_LINE" >> "$PROFILE_FILE" \
    || fail "Could not write to $PROFILE_FILE to add Homebrew to your PATH."
  ok "Homebrew added permanently to your PATH (in $PROFILE_FILE)."
  info "This only affects new Terminal windows -- this script already has it now."
fi

# ---------------------------------------------------------------------------
# Step 3: uv
# ---------------------------------------------------------------------------

say "Step 3 of 7 -- uv"
info "uv is the tool that installs the Zotero connector itself."

if command -v uv >/dev/null 2>&1; then
  ok "uv is already installed ($(command -v uv))."
else
  info "Installing uv via Homebrew..."
  brew install uv || fail "'brew install uv' failed. Copy the error above and send it to Walden."
  ok "uv installed."
fi

# ---------------------------------------------------------------------------
# Step 4: the Zotero connector itself
# ---------------------------------------------------------------------------

say "Step 4 of 7 -- Zotero connector"

ZOTERO_MCP_BIN="$HOME/.local/bin/zotero-mcp"

if [ -x "$ZOTERO_MCP_BIN" ]; then
  ok "zotero-mcp is already installed."
  if confirm "Reinstall / update it to the latest version anyway?"; then
    uv tool install zotero-mcp-server --force || fail "Reinstalling zotero-mcp-server failed. Copy the error above and send it to Walden."
  fi
else
  info "Installing zotero-mcp-server..."
  uv tool install zotero-mcp-server || fail "'uv tool install zotero-mcp-server' failed. Copy the error above and send it to Walden."
fi

if [ ! -x "$ZOTERO_MCP_BIN" ]; then
  fail "Expected to find the installed connector at $ZOTERO_MCP_BIN but it's not there. Copy this message and send it to Walden."
fi
ok "Connector installed at $ZOTERO_MCP_BIN"

# ---------------------------------------------------------------------------
# Step 5: API key and library ID (manual, by design -- these are secrets)
# ---------------------------------------------------------------------------

say "Step 5 of 7 -- your Zotero API key and library ID"
cat <<'KEYINFO'
  These two values let the connector read YOUR Zotero library. They're
  personal to your account, so this script can't fetch them for you.

  1. Open this page in your browser:
       https://www.zotero.org/settings/keys

  2. Click "Create new private key". Give it any name you like
     (e.g. "Claude"), leave the default permissions, and save it.
     Copy the key it shows you -- you will NOT be able to see it again
     after you leave that page.

  3. On the SAME page, near the top, find the line that says:
       "Your userID for use in API calls is XXXXXXX"
     That number is your library ID.
KEYINFO
pause

read -r -p "  Paste your Zotero API key here, then press Return: " ZOTERO_API_KEY
while [ -z "$ZOTERO_API_KEY" ]; do
  read -r -p "  That was empty -- paste your Zotero API key: " ZOTERO_API_KEY
done

read -r -p "  Paste your Zotero library ID (the number) here, then press Return: " ZOTERO_LIBRARY_ID
while [ -z "$ZOTERO_LIBRARY_ID" ]; do
  read -r -p "  That was empty -- paste your library ID: " ZOTERO_LIBRARY_ID
done

MASKED_KEY="${ZOTERO_API_KEY:0:4}$(printf '%*s' $(( ${#ZOTERO_API_KEY} > 4 ? ${#ZOTERO_API_KEY} - 4 : 0 )) '' | tr ' ' '*')"
ok "Got it -- key starting with '${MASKED_KEY:0:4}...', library ID $ZOTERO_LIBRARY_ID."

# ---------------------------------------------------------------------------
# Step 6: claude_desktop_config.json -- confirm path, back up, then edit
# ---------------------------------------------------------------------------

say "Step 6 of 7 -- Claude Desktop's config file"

DEFAULT_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

info "This is the file that tells Claude Desktop which connectors to load."
info "The normal location on your Mac is:"
info "  $DEFAULT_CONFIG"
if confirm "Is that the right file? (say no if you use more than one Claude config, e.g. a work profile)"; then
  CONFIG_PATH="$DEFAULT_CONFIG"
else
  read -r -p "  Paste the full path to the correct claude_desktop_config.json: " CONFIG_PATH
  CONFIG_PATH="${CONFIG_PATH/#\~/$HOME}"
fi

CONFIG_DIR="$(dirname "$CONFIG_PATH")"
mkdir -p "$CONFIG_DIR" || fail "Could not create the folder for $CONFIG_PATH."

if [ ! -f "$CONFIG_PATH" ]; then
  warn "No config file exists yet at that path -- this is normal if you've never added a connector by hand before."
  printf '{"mcpServers": {}}' > "$CONFIG_PATH" || fail "Could not create a starting config file at $CONFIG_PATH."
  ok "Created a fresh config file."
fi

BACKUP_PATH="${CONFIG_PATH}.backup-$(date '+%Y%m%d-%H%M%S')"
cp "$CONFIG_PATH" "$BACKUP_PATH" || fail "Could not create a backup before editing. Stopping without touching the original file."
ok "Backed up your current config to:"
info "  $BACKUP_PATH"
cat <<RESTORE

  --------------------------------------------------------------
  To undo everything this step does and go back to exactly how
  your config was before, at any point in the future, run:

    cp "$BACKUP_PATH" "$CONFIG_PATH"

  then fully quit and reopen Claude Desktop.
  --------------------------------------------------------------
RESTORE
pause

# Edit the JSON with Python (installed automatically once Homebrew/Xcode
# Command Line Tools are present) rather than text tricks, so existing
# connectors and formatting aren't disturbed.
PY_STATUS=$(python3 - "$CONFIG_PATH" "$ZOTERO_MCP_BIN" "$ZOTERO_API_KEY" "$ZOTERO_LIBRARY_ID" "$USER" <<'PYEOF'
import json, sys

config_path, zotero_bin, api_key, library_id, username = sys.argv[1:6]

with open(config_path, "r") as f:
    raw = f.read().strip() or "{}"

try:
    data = json.loads(raw)
except json.JSONDecodeError as e:
    print(f"INVALID_JSON: {e}")
    sys.exit(1)

if not isinstance(data, dict):
    print("INVALID_JSON: top level of the file is not a JSON object")
    sys.exit(1)

servers = data.setdefault("mcpServers", {})
if not isinstance(servers, dict):
    print("INVALID_JSON: 'mcpServers' in the file is not a JSON object")
    sys.exit(1)

if "zotero" in servers:
    print("ALREADY_PRESENT")
else:
    servers["zotero"] = {
        "command": zotero_bin,
        "env": {
            "ZOTERO_LOCAL": "true",
            "ZOTERO_API_KEY": api_key,
            "ZOTERO_LIBRARY_ID": library_id,
        },
    }

with open(config_path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")

# Confirm what we just wrote actually parses back cleanly.
with open(config_path, "r") as f:
    json.load(f)

print("OK")
PYEOF
)
PY_EXIT=$?

if [ $PY_EXIT -ne 0 ] || printf '%s' "$PY_STATUS" | grep -q "INVALID_JSON"; then
  cp "$BACKUP_PATH" "$CONFIG_PATH"
  fail "Your existing config file wasn't valid JSON, so nothing was changed and the original file is untouched. Details: $PY_STATUS"
fi

if printf '%s' "$PY_STATUS" | grep -q "ALREADY_PRESENT"; then
  warn "A 'zotero' entry already exists in your config -- left it exactly as it was, in case you edited it on purpose."
  info "If you want this script to overwrite it with the key/ID you just entered,"
  info "restore the backup first (command printed above), then run this script again."
else
  ok "Zotero connector entry added to your config."
fi

# ---------------------------------------------------------------------------
# Step 7: test it
# ---------------------------------------------------------------------------

say "Step 7 of 7 -- test it"
cat <<'TESTINFO'
  Almost done. Two things left, both outside this script:

  1. Make sure Zotero desktop is open and running.
  2. Fully quit Claude Desktop (Claude menu -> Quit, or Cmd+Q --
     not just closing the window) and reopen it.

  Then, in a new chat, try asking:
     "Search my Zotero library for papers on [any topic in your library]"

  If Claude says it has no Zotero access, see the Troubleshooting
  section at workshop.walden.dk -> Connectors -> Zotero.
TESTINFO

say "Done."
info "Backup of your original config, if you ever need it:"
info "  $BACKUP_PATH"
pause
