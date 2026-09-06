#!/bin/bash
#
# install-mcpvault.command
#
# Sets up the Obsidian Vault MCP connector for Claude Desktop on macOS,
# from a blank machine: Homebrew -> Node.js -> mcpvault -> which folder to
# use as your vault -> claude_desktop_config.json.
#
# Written for people who have never used Terminal before. You can double-
# click this file in Finder to run it. If macOS blocks it the first time
# ("Apple could not verify..."), go to System Settings -> Privacy &
# Security, scroll to the bottom, and click "Open Anyway", then double-
# click the file again.
#
# Safe to run more than once -- it checks what's already done and skips it,
# and you can run it again later to add a second vault under a different
# name. Nothing here needs sudo / an admin password, and nothing outside
# your own Claude config, Homebrew's own folders, and npm's global folder
# is touched.

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

normalize_path() {
  # Accepts a raw line as typed/pasted/drag-and-dropped into Terminal and
  # returns a clean, unescaped, unquoted path -- handles the two real-world
  # conventions (backslash-escaped, or whole-path quote-wrapped) without
  # misreading a literal apostrophe/quote inside an unquoted path as a
  # quote delimiter.
  local raw="$1" first last
  # Trim leading/trailing whitespace.
  raw="${raw#"${raw%%[![:space:]]*}"}"
  raw="${raw%"${raw##*[![:space:]]}"}"

  if [ ${#raw} -ge 2 ]; then
    first="${raw:0:1}"
    last="${raw: -1}"
    if { [ "$first" = "'" ] && [ "$last" = "'" ]; } || { [ "$first" = '"' ] && [ "$last" = '"' ]; }; then
      # Whole path is wrapped in one layer of matching quotes -- strip just
      # the wrapper, leave the inside exactly as-is (no further unescaping;
      # this convention and backslash-escaping are never mixed together).
      raw="${raw:1:${#raw}-2}"
      printf '%s' "$raw"
      return
    fi
  fi

  # Not quote-wrapped -- unescape backslash-escaped characters only
  # (Terminal's drag-and-drop style), leaving any bare quote/apostrophe
  # characters untouched as literal content.
  local out="" i=0 c
  while [ $i -lt ${#raw} ]; do
    c="${raw:$i:1}"
    if [ "$c" = "\\" ] && [ $((i+1)) -lt ${#raw} ]; then
      i=$((i+1))
      out+="${raw:$i:1}"
    else
      out+="$c"
    fi
    i=$((i+1))
  done
  printf '%s' "$out"
}

slugify() {
  # Turns free text into a lowercase, hyphenated, JSON-key-safe identifier.
  local s
  s="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  s="$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
  printf '%s' "$s"
}

if [ "$(id -u)" -eq 0 ]; then
  fail "This script was run with sudo (or as root) -- don't do that. Homebrew refuses to install anything when run as root. Nothing in this script needs sudo or an admin-password prompt. Close this window and double-click the file normally instead. If macOS blocks it the first time ('Apple could not verify...'), go to System Settings -> Privacy & Security, scroll to the bottom, and click 'Open Anyway' -- that is the only extra step, and it still does not need sudo."
fi

cd "$HOME" || fail "Could not switch to your home folder."

clear
cat <<'BANNER'
====================================================================
  Obsidian Vault + Claude Desktop connector -- guided install
====================================================================

This connects Claude Desktop to a folder of markdown notes (an Obsidian
vault, or just a plain folder of .md files -- Obsidian itself does NOT
need to be installed for this to work; the connector reads and writes
the files directly, it doesn't talk to the Obsidian app at all).

This script will, in order:

  1. Install Homebrew (a package manager for Mac), if you don't have it
  2. Install Node.js, if you don't have a recent enough version
  3. Install the vault connector itself (mcpvault)
  4. Ask you which folder to use as your vault
  5. Ask you for a short name for it
  6. Back up, then edit, Claude Desktop's config file to turn it on

Each step explains itself before it does anything. Nothing is
irreversible -- step 6 makes a backup and tells you exactly how to
undo it if anything goes wrong.

You will need:
  - About 5 minutes
  - A folder of notes you want Claude to be able to read/write (this can
    be an existing Obsidian vault, or any plain folder of markdown files)
  - Claude Desktop installed (the "Cowork" / desktop app, not just
    the web browser version)
====================================================================
BANNER
pause

# ---------------------------------------------------------------------------
# Step 0: sanity checks
# ---------------------------------------------------------------------------

say "Step 0 of 6 -- quick checks"

if [ "$(uname)" != "Darwin" ]; then
  fail "This script is for macOS only. If you're on Windows, see the Windows guide on workshop.walden.dk -> Connectors -> Obsidian Vault instead."
fi

if pgrep -x "Claude" >/dev/null 2>&1; then
  warn "Claude Desktop looks like it's currently running."
  info "That's fine for now -- you'll need to fully quit and reopen it at the"
  info "very end, after we edit its config file. A reminder will print then."
fi

# ---------------------------------------------------------------------------
# Step 1: Homebrew
# ---------------------------------------------------------------------------

say "Step 1 of 6 -- Homebrew"
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
  printf '\n# Added by install-mcpvault.command on %s\n%s\n' "$(date '+%Y-%m-%d')" "$SHELLENV_LINE" >> "$PROFILE_FILE" \
    || fail "Could not write to $PROFILE_FILE to add Homebrew to your PATH."
  ok "Homebrew added permanently to your PATH (in $PROFILE_FILE)."
  info "This only affects new Terminal windows -- this script already has it now."
fi

# ---------------------------------------------------------------------------
# Step 2: Node.js
# ---------------------------------------------------------------------------

say "Step 2 of 6 -- Node.js"
info "Node.js is what runs the vault connector."

NODE_OK=0
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR="$(node -e 'process.stdout.write(String(process.versions.node.split(".")[0]))' 2>/dev/null)"
  if [ -n "$NODE_MAJOR" ] && [ "$NODE_MAJOR" -ge 18 ] 2>/dev/null; then
    ok "Node.js is already installed ($(node -v))."
    NODE_OK=1
  else
    warn "Node.js is installed but looks older than version 18 ($(node -v 2>/dev/null))."
  fi
else
  info "Node.js not found."
fi

if [ "$NODE_OK" -ne 1 ]; then
  info "Installing Node.js via Homebrew..."
  brew install node || fail "'brew install node' failed. Copy the error above and send it to Walden."
  ok "Node.js installed ($(node -v))."
fi

# ---------------------------------------------------------------------------
# Step 3: the vault connector itself (mcpvault)
# ---------------------------------------------------------------------------

say "Step 3 of 6 -- vault connector"

if command -v mcpvault >/dev/null 2>&1; then
  ok "mcpvault is already installed."
  if confirm "Reinstall / update it to the latest version anyway?"; then
    npm install -g @bitbonsai/mcpvault || fail "Reinstalling @bitbonsai/mcpvault failed. Copy the error above and send it to Walden."
  fi
else
  info "Installing @bitbonsai/mcpvault..."
  npm install -g @bitbonsai/mcpvault || fail "'npm install -g @bitbonsai/mcpvault' failed. Copy the error above and send it to Walden."
fi

hash -r  # forget any cached "not found" lookup for mcpvault from before install

MCPVAULT_BIN="$(command -v mcpvault || true)"
if [ -z "$MCPVAULT_BIN" ]; then
  # Fallback: ask npm directly where its global bin folder is.
  NPM_PREFIX="$(npm config get prefix 2>/dev/null)"
  if [ -n "$NPM_PREFIX" ] && [ -x "$NPM_PREFIX/bin/mcpvault" ]; then
    MCPVAULT_BIN="$NPM_PREFIX/bin/mcpvault"
  fi
fi

if [ -z "$MCPVAULT_BIN" ] || [ ! -x "$MCPVAULT_BIN" ]; then
  fail "Installed mcpvault, but can't find the actual program afterwards. Copy this message and send it to Walden."
fi
ok "Connector installed at $MCPVAULT_BIN"

# ---------------------------------------------------------------------------
# Step 4: which folder is your vault
# ---------------------------------------------------------------------------

say "Step 4 of 6 -- point it at your vault"
cat <<'VAULTINFO'
  This connector needs to know which folder to use as your "vault" -- any
  folder of markdown notes works, whether or not it's an actual Obsidian
  vault, and Obsidian does not need to be open (or installed) for this.

  Easiest way: drag the folder from Finder into this Terminal window,
  right onto the line below, then press Return. macOS types the full path
  in for you automatically -- just drag, don't try to clean it up first.

  Or type/paste the path yourself. If you're not sure of the exact path,
  in Finder hold the Option key and right-click the folder -> "Copy '...'
  as Pathname", then paste it here (Cmd+V).
VAULTINFO

VAULT_PATH=""
while [ -z "$VAULT_PATH" ]; do
  read -r -p "  Drag your vault folder here, or type its path, then press Return: " RAW_VAULT_INPUT
  if [ -z "$RAW_VAULT_INPUT" ]; then
    warn "That was empty -- try again."
    continue
  fi

  CANDIDATE="$(normalize_path "$RAW_VAULT_INPUT")"

  # Expand a leading ~ to $HOME (only when it's the very first character).
  case "$CANDIDATE" in
    "~") CANDIDATE="$HOME" ;;
    "~/"*) CANDIDATE="$HOME/${CANDIDATE#\~/}" ;;
  esac

  # A path that doesn't start with / is either relative to $HOME or a
  # typo -- ask rather than guessing.
  case "$CANDIDATE" in
    /*) : ;;
    *)
      if confirm "  '$CANDIDATE' doesn't look like a full path -- did you mean '$HOME/$CANDIDATE'?"; then
        CANDIDATE="$HOME/$CANDIDATE"
      else
        warn "OK, try again -- drag the folder in, or paste the full path."
        continue
      fi
      ;;
  esac

  if [ ! -e "$CANDIDATE" ]; then
    warn "Nothing exists yet at: $CANDIDATE"
    if confirm "  Create this folder now?"; then
      mkdir -p "$CANDIDATE" || { warn "Could not create that folder -- try a different path."; continue; }
      ok "Created $CANDIDATE"
    else
      warn "OK, try again."
      continue
    fi
  elif [ ! -d "$CANDIDATE" ]; then
    warn "That's a file, not a folder: $CANDIDATE"
    continue
  fi

  # Canonicalize: resolves symlinks, drops any trailing slash, and
  # guarantees an absolute path -- so the config always gets a clean value.
  RESOLVED="$(cd "$CANDIDATE" 2>/dev/null && pwd -P)"
  if [ -z "$RESOLVED" ]; then
    warn "Could not access that folder -- try a different path."
    continue
  fi

  VAULT_PATH="$RESOLVED"
done

ok "Using vault folder: $VAULT_PATH"

# ---------------------------------------------------------------------------
# Step 5: give this vault a name
# ---------------------------------------------------------------------------

say "Step 5 of 6 -- name this vault"
info "Claude needs a short name for this connector, in case you add more"
info "than one vault later (just run this script again for a second one)."
info "Letters, numbers, and spaces are all fine -- it's cleaned up automatically."

read -r -p "  Name for this vault (e.g. 'Work Notes'), or press Return for 'vault': " VAULT_NAME_RAW
VAULT_SLUG="$(slugify "$VAULT_NAME_RAW")"
[ -z "$VAULT_SLUG" ] && VAULT_SLUG="vault"
SERVER_KEY="vault-$VAULT_SLUG"
ok "This will be added to your config as: $SERVER_KEY"

# ---------------------------------------------------------------------------
# Step 6: claude_desktop_config.json -- confirm path, back up, then edit
# ---------------------------------------------------------------------------

say "Step 6 of 6 -- Claude Desktop's config file"

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
apply_config_entry() {
  # apply_config_entry <overwrite: 0|1> -> prints OK / ALREADY_PRESENT / INVALID_JSON:...
  python3 - "$CONFIG_PATH" "$SERVER_KEY" "$MCPVAULT_BIN" "$VAULT_PATH" "$1" <<'PYEOF'
import json, sys

config_path, server_key, mcpvault_bin, vault_path, overwrite_flag = sys.argv[1:6]

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

if server_key in servers and overwrite_flag != "1":
    print("ALREADY_PRESENT")
    sys.exit(0)

servers[server_key] = {
    "command": mcpvault_bin,
    "args": [vault_path],
}

with open(config_path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")

# Confirm what we just wrote actually parses back cleanly.
with open(config_path, "r") as f:
    json.load(f)

print("OK")
PYEOF
}

PY_STATUS="$(apply_config_entry 0)"
PY_EXIT=$?

if [ $PY_EXIT -ne 0 ] || printf '%s' "$PY_STATUS" | grep -q "INVALID_JSON"; then
  cp "$BACKUP_PATH" "$CONFIG_PATH"
  fail "Your existing config file wasn't valid JSON, so nothing was changed and the original file is untouched. Details: $PY_STATUS"
fi

if printf '%s' "$PY_STATUS" | grep -q "ALREADY_PRESENT"; then
  warn "A '$SERVER_KEY' entry already exists in your config."
  if confirm "Overwrite it so it points at $VAULT_PATH?"; then
    PY_STATUS="$(apply_config_entry 1)"
    PY_EXIT=$?
    if [ $PY_EXIT -ne 0 ] || printf '%s' "$PY_STATUS" | grep -q "INVALID_JSON"; then
      cp "$BACKUP_PATH" "$CONFIG_PATH"
      fail "Something went wrong updating the entry, so nothing was changed and the original file is untouched. Details: $PY_STATUS"
    fi
    ok "Updated the '$SERVER_KEY' entry in your config."
  else
    info "Left it exactly as it was. If you meant to add a different vault, run this script again and give it a different name."
  fi
else
  ok "Vault connector entry added to your config as '$SERVER_KEY'."
fi

say "Done."
cat <<'TESTINFO'
  One thing left, outside this script: fully quit Claude Desktop (Claude
  menu -> Quit, or Cmd+Q -- not just closing the window) and reopen it.

  Then, in a new chat, try asking:
     "What files are in my vault?"

  If Claude says it has no access, see the Troubleshooting section at
  workshop.walden.dk -> Connectors -> Obsidian Vault.
TESTINFO
info "Backup of your original config, if you ever need it:"
info "  $BACKUP_PATH"
pause
