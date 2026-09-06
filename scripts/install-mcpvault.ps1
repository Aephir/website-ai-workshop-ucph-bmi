#
# install-mcpvault.ps1
#
# Sets up the Obsidian Vault MCP connector for Claude Desktop on Windows,
# from a blank machine: Node.js -> mcpvault -> which folder to use as your
# vault -> claude_desktop_config.json.
#
# Written for people who have never used PowerShell before. Don't double-
# click this file directly -- double-click install-mcpvault.bat instead,
# which is the file that actually runs this one. Both files need to stay
# in the same folder.
#
# If Windows blocks the .bat as an "unrecognized app" (SmartScreen), click
# "More info", then "Run anyway" -- that's the only extra step, still no
# admin password needed. If that option is missing entirely (some
# university/managed machines lock this down), open this .ps1 file, copy
# its contents, and paste them into Claude, Copilot, or ChatGPT with a
# prompt like "walk me through running this, one command at a time, in
# PowerShell" -- more friction, but it works, and it's a legitimate way to
# use an AI assistant, not a hack.
#
# Safe to run more than once -- it checks what's already done and skips it,
# and you can run it again later to add a second vault under a different
# name. Nothing here needs Administrator rights, and nothing outside your
# own Claude config and npm's own global folder is touched.

# ---------------------------------------------------------------------------
# Little helpers
# ---------------------------------------------------------------------------

function Say($msg)  { Write-Host ""; Write-Host $msg -ForegroundColor Cyan }
function Info($msg) { Write-Host "  $msg" }
function Ok($msg)   { Write-Host "  OK  $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "  !!  $msg" -ForegroundColor Yellow }
function Fail($msg) {
    Write-Host ""
    Write-Host "  X  $msg" -ForegroundColor Red
    Write-Host ""
    Write-Host "Something stopped the install. Nothing has been left half-edited --"
    Write-Host "your Claude config (if we got that far) was backed up first, see above."
    Write-Host "Copy the message above and send it to Walden if you are stuck."
    Write-Host ""
    Read-Host "Press Enter to close this window"
    exit 1
}
function Wait-Continue { Read-Host "  Press Enter to continue" | Out-Null }

function Confirm-YesNo($prompt) {
    $reply = Read-Host "  $prompt [Y/n]"
    if ($reply -match '^[nN]') { return $false }
    return $true
}

function Write-Utf8NoBom($Path, $Text) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $enc)
}

function Format-VaultPath($raw) {
    # Windows drag-and-drop onto a console window, and Explorer's "Copy as
    # path", only ever wrap the WHOLE path in one layer of double quotes
    # (when it contains spaces) -- never backslash-escaping, unlike macOS
    # Terminal. So this only needs to trim whitespace and strip one
    # optional layer of matching quotes.
    $s = $raw.Trim()
    if ($s.Length -ge 2) {
        $first = $s.Substring(0, 1)
        $last = $s.Substring($s.Length - 1, 1)
        if (($first -eq '"' -and $last -eq '"') -or ($first -eq "'" -and $last -eq "'")) {
            $s = $s.Substring(1, $s.Length - 2)
        }
    }
    return $s.Trim()
}

function Get-Slug($raw) {
    # Turns free text into a lowercase, hyphenated, JSON-key-safe identifier.
    $s = $raw.ToLowerInvariant()
    $s = [regex]::Replace($s, '[^a-z0-9]+', '-')
    $s = $s.Trim('-')
    return $s
}

# ---------------------------------------------------------------------------
# Admin check -- not needed, just a heads-up if someone right-clicked ->
# "Run as administrator" out of habit.
# ---------------------------------------------------------------------------

try {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
} catch {
    $isAdmin = $false
}
if ($isAdmin) {
    Write-Host ""
    Write-Host "  !!  This is running with Administrator rights." -ForegroundColor Yellow
    Info "That's not needed here. If you right-clicked and chose 'Run as"
    Info "administrator', you can close this and just double-click"
    Info "install-mcpvault.bat normally instead. Continuing anyway."
}

Clear-Host
Write-Host @"
====================================================================
  Obsidian Vault + Claude Desktop connector -- guided install (Windows)
====================================================================

This connects Claude Desktop to a folder of markdown notes (an Obsidian
vault, or just a plain folder of .md files -- Obsidian itself does NOT
need to be installed for this to work; the connector reads and writes
the files directly, it doesn't talk to the Obsidian app at all).

This script will, in order:

  1. Install Node.js, if you don't have a recent enough version
  2. Install the vault connector itself (mcpvault)
  3. Ask you which folder to use as your vault
  4. Ask you for a short name for it
  5. Back up, then edit, Claude Desktop's config file to turn it on

Each step explains itself before it does anything. Nothing is
irreversible -- step 5 makes a backup and tells you exactly how to
undo it if anything goes wrong.

You will need:
  - About 5 minutes
  - A folder of notes you want Claude to be able to read/write (this can
    be an existing Obsidian vault, or any plain folder of markdown files)
  - Claude Desktop installed (the "Cowork" / desktop app, not just
    the web browser version)
====================================================================
"@
Wait-Continue

# ---------------------------------------------------------------------------
# Step 0: sanity checks
# ---------------------------------------------------------------------------

Say "Step 0 of 5 -- quick checks"

if (Get-Process -Name "Claude" -ErrorAction SilentlyContinue) {
    Warn "Claude Desktop looks like it's currently running."
    Info "That's fine for now -- you'll need to fully quit and reopen it at the"
    Info "very end, after we edit its config file. A reminder will print then."
}

# ---------------------------------------------------------------------------
# Step 1: Node.js
# ---------------------------------------------------------------------------

Say "Step 1 of 5 -- Node.js"
Info "Node.js is what runs the vault connector."

$NodeExe = $null
$existingNode = Get-Command node -ErrorAction SilentlyContinue
if ($existingNode) {
    $NodeExe = $existingNode.Source
} else {
    $candidate = Join-Path $env:ProgramFiles "nodejs\node.exe"
    if (Test-Path $candidate) { $NodeExe = $candidate }
}

$nodeOk = $false
if ($NodeExe) {
    try {
        $verString = (& $NodeExe -v).Trim()          # e.g. "v20.11.0"
        $major = [int]($verString.TrimStart('v').Split('.')[0])
        if ($major -ge 18) {
            Ok "Node.js is already installed ($verString)."
            $nodeOk = $true
        } else {
            Warn "Node.js is installed but looks older than version 18 ($verString)."
        }
    } catch {
        Warn "Found a node.exe but couldn't check its version: $($_.Exception.Message)"
    }
} else {
    Info "Node.js not found."
}

if (-not $nodeOk) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) {
        Warn "Node.js needs installing, but winget (Windows' app installer) isn't"
        Warn "available on this computer to do it automatically."
        Info "Please install Node.js yourself: go to https://nodejs.org, download"
        Info "the 'LTS' version for Windows, run the installer (defaults are fine),"
        Info "then close this window and run this script again."
        Wait-Continue
        exit 0
    }

    Info "Installing Node.js (LTS) via winget..."
    Info "This may show its own progress bars -- that's normal, let it finish."
    winget install -e --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Fail "Installing Node.js via winget failed (exit code $LASTEXITCODE). Copy the message above and send it to Walden, or install it yourself from https://nodejs.org (the 'LTS' version) and re-run this script."
    }

    # winget's installer updates PATH for *future* Windows sessions, not this
    # one -- so look for node.exe directly rather than trusting PATH to have
    # refreshed (the same issue as uv's installer on the Zotero script).
    $candidate = Join-Path $env:ProgramFiles "nodejs\node.exe"
    if (Test-Path $candidate) {
        $NodeExe = $candidate
    } else {
        Fail "Node.js installed, but node.exe isn't where expected ($candidate). Close this window, open a fresh one, and run this script again -- if it still fails, send this message to Walden."
    }
    Ok "Node.js installed ($((& $NodeExe -v).Trim()))."
}

$NodeDir = Split-Path $NodeExe -Parent
$NpmCmd = Join-Path $NodeDir "npm.cmd"
if (-not (Test-Path $NpmCmd)) {
    Fail "Found node.exe at $NodeExe but no npm.cmd alongside it at $NpmCmd. Copy this message and send it to Walden."
}

# ---------------------------------------------------------------------------
# Step 2: the vault connector itself (mcpvault)
# ---------------------------------------------------------------------------

Say "Step 2 of 5 -- vault connector"

$McpvaultBin = $null
$existingMcpvault = Get-Command mcpvault -ErrorAction SilentlyContinue
if ($existingMcpvault) {
    $McpvaultBin = $existingMcpvault.Source
}

if ($McpvaultBin) {
    Ok "mcpvault is already installed ($McpvaultBin)."
    if (Confirm-YesNo "Reinstall / update it to the latest version anyway?") {
        & $NpmCmd install -g "@bitbonsai/mcpvault"
        if ($LASTEXITCODE -ne 0) { Fail "Reinstalling @bitbonsai/mcpvault failed. Copy the error above and send it to Walden." }
    }
} else {
    Info "Installing @bitbonsai/mcpvault..."
    & $NpmCmd install -g "@bitbonsai/mcpvault"
    if ($LASTEXITCODE -ne 0) { Fail "'npm install -g @bitbonsai/mcpvault' failed. Copy the error above and send it to Walden." }
}

if (-not $McpvaultBin) {
    # Ask npm directly where its global bin folder is, rather than assuming
    # a fixed location -- this differs by Node install and can be
    # customized, same reasoning as the macOS script's npm-prefix fallback.
    $npmPrefix = (& $NpmCmd config get prefix 2>$null)
    if ($npmPrefix) { $npmPrefix = $npmPrefix.Trim() }
    if ($npmPrefix) {
        $candidate = Join-Path $npmPrefix "mcpvault.cmd"
        if (Test-Path $candidate) { $McpvaultBin = $candidate }
    }
}
if (-not $McpvaultBin) {
    $existingMcpvault = Get-Command mcpvault -ErrorAction SilentlyContinue
    if ($existingMcpvault) { $McpvaultBin = $existingMcpvault.Source }
}

if (-not $McpvaultBin -or -not (Test-Path $McpvaultBin)) {
    Fail "Installed mcpvault, but can't find the actual program afterwards. Copy this message and send it to Walden."
}
Ok "Connector installed at $McpvaultBin"

# ---------------------------------------------------------------------------
# Step 3: which folder is your vault
# ---------------------------------------------------------------------------

Say "Step 3 of 5 -- point it at your vault"
Write-Host @"
  This connector needs to know which folder to use as your "vault" -- any
  folder of markdown notes works, whether or not it's an actual Obsidian
  vault, and Obsidian does not need to be open (or installed) for this.

  Easiest way: drag the folder from File Explorer into this window, right
  onto the line below, then press Enter -- Windows types the full path in
  for you automatically (it wraps it in quotes if it has spaces, that's
  fine, this script handles that).

  Or type/paste the path yourself. If you're not sure of the exact path,
  in File Explorer hold Shift and right-click the folder -> "Copy as
  path", then paste it here (right-click or Ctrl+V).
"@

$VaultPath = $null
while (-not $VaultPath) {
    $rawInput = Read-Host "  Drag your vault folder here, or type its path, then press Enter"
    if ([string]::IsNullOrWhiteSpace($rawInput)) {
        Warn "That was empty -- try again."
        continue
    }

    $candidate = Format-VaultPath $rawInput

    if (-not [System.IO.Path]::IsPathRooted($candidate)) {
        $guess = Join-Path $env:USERPROFILE $candidate
        if (Confirm-YesNo "  '$candidate' doesn't look like a full path -- did you mean '$guess'?") {
            $candidate = $guess
        } else {
            Warn "OK, try again -- drag the folder in, or paste the full path."
            continue
        }
    }

    if (-not (Test-Path -LiteralPath $candidate)) {
        Warn "Nothing exists yet at: $candidate"
        if (Confirm-YesNo "  Create this folder now?") {
            try {
                New-Item -ItemType Directory -Force -Path $candidate -ErrorAction Stop | Out-Null
                Ok "Created $candidate"
            } catch {
                Warn "Could not create that folder ($($_.Exception.Message)) -- try a different path."
                continue
            }
        } else {
            Warn "OK, try again."
            continue
        }
    } elseif (-not (Get-Item -LiteralPath $candidate).PSIsContainer) {
        Warn "That's a file, not a folder: $candidate"
        continue
    }

    try {
        $resolved = (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).Path
    } catch {
        Warn "Could not access that folder ($($_.Exception.Message)) -- try a different path."
        continue
    }

    $VaultPath = $resolved
}

Ok "Using vault folder: $VaultPath"

# ---------------------------------------------------------------------------
# Step 4: give this vault a name
# ---------------------------------------------------------------------------

Say "Step 4 of 5 -- name this vault"
Info "Claude needs a short name for this connector, in case you add more"
Info "than one vault later (just run this script again for a second one)."
Info "Letters, numbers, and spaces are all fine -- it's cleaned up automatically."

$vaultNameRaw = Read-Host "  Name for this vault (e.g. 'Work Notes'), or press Enter for 'vault'"
$vaultSlug = Get-Slug $vaultNameRaw
if ([string]::IsNullOrWhiteSpace($vaultSlug)) { $vaultSlug = "vault" }
$ServerKey = "vault-$vaultSlug"
Ok "This will be added to your config as: $ServerKey"

# ---------------------------------------------------------------------------
# Step 5: claude_desktop_config.json -- confirm path, back up, then edit
# ---------------------------------------------------------------------------

Say "Step 5 of 5 -- Claude Desktop's config file"

# Claude Desktop on Windows keeps this file in one of two places depending
# on how it was installed -- the standard installer from claude.ai/download
# now defaults to Microsoft's MSIX packaging, which sandboxes the app into
# a virtualized folder under AppData\Local\Packages (the "new" location).
# The %APPDATA%\Claude path some guides mention (the "old" / non-Store
# location) only applies to older or non-Store installs. Using the wrong
# one means Claude Desktop silently never sees this entry, with no error
# at all. [to be updated -- this packaging detail can change]
$msixDir = Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA "Packages") -Filter "Claude_*" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
$standardDir = Join-Path $env:APPDATA "Claude"

if ($msixDir) {
    $DefaultConfig = Join-Path $msixDir.FullName "LocalCache\Roaming\Claude\claude_desktop_config.json"
    Info "Detected a Microsoft Store / packaged (MSIX) install of Claude Desktop (the newer location)."
    $autoDetected = $true
} elseif (Test-Path $standardDir) {
    $DefaultConfig = Join-Path $standardDir "claude_desktop_config.json"
    Info "Detected a standard (non-Store) install of Claude Desktop (the older location)."
    $autoDetected = $true
} else {
    $DefaultConfig = $null
    $autoDetected = $false
}

if ($autoDetected) {
    Info "This is the file that tells Claude Desktop which connectors to load."
    Info "The location for your install type is:"
    Info "  $DefaultConfig"
    Info "(If Claude still can't see the connector after this finishes, and you"
    Info "have both a Microsoft Store version and a regular version installed,"
    Info "that mismatch is the first thing worth checking.)"

    if (Confirm-YesNo "Is that the right file? (say no if you use more than one Claude config, e.g. a work profile)") {
        $ConfigPath = $DefaultConfig
    } else {
        $ConfigPath = Read-Host "  Paste the full path to the correct claude_desktop_config.json"
    }
} else {
    Warn "Could not automatically find Claude Desktop's config folder -- neither of"
    Warn "the two known locations exists yet on this computer:"
    Info "  Newer (Microsoft Store / MSIX): AppData\Local\Packages\Claude_...\LocalCache\Roaming\Claude"
    Info "  Older (standard installer):     %APPDATA%\Claude"
    Info "This usually just means Claude Desktop has never been opened on this"
    Info "computer yet. Easiest fix: close this window, open Claude Desktop once,"
    Info "then run this script again -- it should auto-detect after that."
    Info "Or, if you know exactly where your claude_desktop_config.json is (or"
    Info "should go), you can paste that path in now instead."
    if (Confirm-YesNo "Paste the path yourself now instead of reopening Claude Desktop first?") {
        $ConfigPath = Read-Host "  Paste the full path to claude_desktop_config.json"
    } else {
        Info "Open Claude Desktop once, then re-run this script."
        exit 0
    }
}

$ConfigDir = Split-Path -Parent $ConfigPath
New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null

if (-not (Test-Path $ConfigPath)) {
    Warn "No config file exists yet at that path -- this is normal if you've never added a connector by hand before."
    Write-Utf8NoBom -Path $ConfigPath -Text '{"mcpServers": {}}'
    Ok "Created a fresh config file."
}

$BackupPath = "$ConfigPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
try {
    Copy-Item -Path $ConfigPath -Destination $BackupPath -ErrorAction Stop
} catch {
    Fail "Could not create a backup before editing. Stopping without touching the original file. Details: $($_.Exception.Message)"
}
Ok "Backed up your current config to:"
Info "  $BackupPath"
Write-Host @"

  --------------------------------------------------------------
  To undo everything this step does and go back to exactly how
  your config was before, at any point in the future, run in
  PowerShell:

    Copy-Item "$BackupPath" "$ConfigPath"

  then fully quit and reopen Claude Desktop.
  --------------------------------------------------------------
"@
Wait-Continue

function Set-VaultConfigEntry($Overwrite) {
    $raw = Get-Content -Raw -Path $ConfigPath
    if ([string]::IsNullOrWhiteSpace($raw)) { $raw = '{}' }

    try {
        $configData = $raw | ConvertFrom-Json -ErrorAction Stop
    } catch {
        return "INVALID_JSON: $($_.Exception.Message)"
    }

    if ($configData -isnot [System.Management.Automation.PSCustomObject]) {
        return "INVALID_JSON: top level of the file is not a JSON object"
    }

    if (-not ($configData.PSObject.Properties.Name -contains 'mcpServers')) {
        $configData | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([PSCustomObject]@{})
    }

    if ($configData.mcpServers -isnot [System.Management.Automation.PSCustomObject]) {
        return "INVALID_JSON: 'mcpServers' in your config file is not a JSON object"
    }

    $alreadyThere = $configData.mcpServers.PSObject.Properties.Name -contains $ServerKey
    if ($alreadyThere -and -not $Overwrite) {
        return "ALREADY_PRESENT"
    }

    # cmd /c is required here -- mcpvault.cmd is a script, not a native
    # .exe, and Windows can't spawn a .cmd file directly without a shell
    # wrapper (this is the well-documented "spawn ENOENT" issue that hits
    # bare npx/npm-shim entries in claude_desktop_config.json on Windows).
    $entry = [PSCustomObject]@{
        command = "cmd"
        args    = @("/c", $McpvaultBin, $VaultPath)
    }

    if ($alreadyThere) {
        $configData.mcpServers.PSObject.Properties.Remove($ServerKey)
    }
    $configData.mcpServers | Add-Member -NotePropertyName $ServerKey -NotePropertyValue $entry

    Write-Utf8NoBom -Path $ConfigPath -Text ($configData | ConvertTo-Json -Depth 10)

    try {
        Get-Content -Raw -Path $ConfigPath | ConvertFrom-Json -ErrorAction Stop | Out-Null
    } catch {
        return "WRITE_FAILED: $($_.Exception.Message)"
    }

    return "OK"
}

$status = Set-VaultConfigEntry $false

if ($status -like "INVALID_JSON*") {
    Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
    Fail "Your existing config file wasn't valid JSON, so nothing was changed and the original file is untouched. Details: $status"
}

if ($status -eq "ALREADY_PRESENT") {
    Warn "A '$ServerKey' entry already exists in your config."
    if (Confirm-YesNo "Overwrite it so it points at $VaultPath?") {
        $status = Set-VaultConfigEntry $true
        if ($status -like "INVALID_JSON*" -or $status -like "WRITE_FAILED*") {
            Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
            Fail "Something went wrong updating the entry, so nothing was changed and the original file is untouched. Details: $status"
        }
        Ok "Updated the '$ServerKey' entry in your config."
    } else {
        Info "Left it exactly as it was. If you meant to add a different vault, run this script again and give it a different name."
    }
} elseif ($status -like "WRITE_FAILED*") {
    Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
    Fail "Something went wrong writing the new config, so nothing was changed and the original file is untouched. Details: $status"
} else {
    Ok "Vault connector entry added to your config as '$ServerKey'."
}

Say "Done."
Write-Host @"
  One thing left, outside this script: fully quit Claude Desktop and
  reopen it. Closing the window is often not enough -- if it has an icon
  in the system tray near the clock, right-click that and choose Quit
  (or use Task Manager) before reopening it.

  Then, in a new chat, try asking:
     "What files are in my vault?"

  If Claude says it has no access, see the Troubleshooting section at
  workshop.walden.dk -> Connectors -> Obsidian Vault.
"@
Info "Backup of your original config, if you ever need it:"
Info "  $BackupPath"
Wait-Continue
