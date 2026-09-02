#
# install-zotero-mcp.ps1
#
# Sets up the Zotero MCP connector for Claude Desktop on Windows, from a
# blank machine: uv -> zotero-mcp-server -> your API key/library ID ->
# claude_desktop_config.json.
#
# Written for people who have never used PowerShell before. Don't double-
# click this file directly -- double-click install-zotero-mcp.bat instead,
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
# Safe to run more than once -- it checks what's already done and skips it.
# Nothing here needs Administrator rights, and nothing outside your own
# Claude config and uv's own folders is touched.

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

# ---------------------------------------------------------------------------
# Admin check -- not needed, just a heads-up if someone right-clicked ->
# "Run as administrator" out of habit (the natural thing to try if
# something like this fails, per the macOS version of this script needing
# that exact fix for a "needed sudo" report).
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
    Info "install-zotero-mcp.bat normally instead. Continuing anyway."
}

Clear-Host
Write-Host @"
====================================================================
  Zotero + Claude Desktop connector -- guided install (Windows)
====================================================================

This script will, in order:

  1. Remind you to turn on Zotero's local API (one manual click)
  2. Install uv (a small tool installer), if you don't have it
  3. Install the Zotero connector itself
  4. Ask you to paste in a Zotero API key and library ID
  5. Back up, then edit, Claude Desktop's config file to turn it on

Each step explains itself before it does anything. Nothing is
irreversible -- step 5 makes a backup and tells you exactly how to
undo it if anything goes wrong.

You will need:
  - About 10 minutes
  - The Zotero desktop app already installed (get it from zotero.org
    if you don't have it -- you can still run steps 1-4 without it,
    but Zotero itself must be open for the connector to actually work)
  - Claude Desktop installed (the "Cowork" / desktop app, not just
    the web browser version)
====================================================================
"@
Wait-Continue

# ---------------------------------------------------------------------------
# Step 0: sanity checks
# ---------------------------------------------------------------------------

Say "Step 0 of 6 -- quick checks"

$zoteroCandidates = @(
    (Join-Path $env:LOCALAPPDATA "Zotero\Zotero.exe"),
    (Join-Path $env:ProgramFiles "Zotero\zotero.exe"),
    (Join-Path ${env:ProgramFiles(x86)} "Zotero\zotero.exe")
)
$zoteroInstalled = $zoteroCandidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if ($zoteroInstalled) {
    Ok "Zotero found at $zoteroInstalled."
} else {
    Warn "Zotero desktop app was not found in its usual install locations."
    Info "Download and install it from https://www.zotero.org/download/ -- you can"
    Info "keep this window open and come back to it, the rest of this script"
    Info "still works, but the connector won't actually do anything until"
    Info "Zotero is installed AND running."
    if (-not (Confirm-YesNo "Continue anyway?")) { Info "Come back once Zotero is installed."; exit 0 }
}

if (Get-Process -Name "Zotero" -ErrorAction SilentlyContinue) {
    Ok "Zotero desktop app is running."
} else {
    Warn "Zotero desktop app doesn't look like it's running right now."
    Info "It needs to be open for the connector to work -- the connector talks"
    Info "to Zotero's own app, not to zotero.org directly. Open it whenever you like,"
    Info "it doesn't have to be running for the rest of this install."
}

if (Get-Process -Name "Claude" -ErrorAction SilentlyContinue) {
    Warn "Claude Desktop looks like it's currently running."
    Info "That's fine for now -- you'll need to fully quit and reopen it at the"
    Info "very end, after we edit its config file. A reminder will print then."
}

# ---------------------------------------------------------------------------
# Step 1: Zotero's local API (manual -- can't be automated from here)
# ---------------------------------------------------------------------------

Say "Step 1 of 6 -- turn on Zotero's local API"
Info "The connector talks directly to the Zotero app on your machine, not to"
Info "zotero.org -- Zotero blocks this by default, and won't warn you either"
Info "way if it's off."
Write-Host ""
Info "In Zotero: Edit -> Settings -> Advanced tab."
Info "Under Miscellaneous, check 'Allow other applications on this computer"
Info "to communicate with Zotero.' Then restart Zotero."
Wait-Continue

# ---------------------------------------------------------------------------
# Step 2: uv
# ---------------------------------------------------------------------------

Say "Step 2 of 6 -- uv"
Info "uv is the tool that installs the Zotero connector itself."

$UvBin = Join-Path $env:USERPROFILE ".local\bin\uv.exe"
$existingUv = Get-Command uv -ErrorAction SilentlyContinue

if ($existingUv) {
    Ok "uv is already installed ($($existingUv.Source))."
    $UvBin = $existingUv.Source
} elseif (Test-Path $UvBin) {
    Ok "uv is already installed ($UvBin)."
} else {
    Info "Installing uv now via its official installer..."
    Wait-Continue
    try {
        Invoke-Expression (Invoke-RestMethod "https://astral.sh/uv/install.ps1")
    } catch {
        Fail "uv's installer did not finish successfully: $($_.Exception.Message)"
    }
    # uv's own installer updates PATH for *future* PowerShell windows, not
    # this one -- so we point straight at the known install location
    # instead of trusting PATH to have refreshed.
    if (-not (Test-Path $UvBin)) {
        Fail "Expected to find uv at $UvBin after installing it, but it's not there. Copy this message and send it to Walden."
    }
    Ok "uv installed at $UvBin"
}

# ---------------------------------------------------------------------------
# Step 3: the Zotero connector itself
# ---------------------------------------------------------------------------

Say "Step 3 of 6 -- Zotero connector"

$ZoteroMcpBin = Join-Path $env:USERPROFILE ".local\bin\zotero-mcp.exe"

if (Test-Path $ZoteroMcpBin) {
    Ok "zotero-mcp is already installed."
    if (Confirm-YesNo "Reinstall / update it to the latest version anyway?") {
        & $UvBin tool install zotero-mcp-server --force
        if ($LASTEXITCODE -ne 0) { Fail "Reinstalling zotero-mcp-server failed. Copy the error above and send it to Walden." }
    }
} else {
    Info "Installing zotero-mcp-server..."
    & $UvBin tool install zotero-mcp-server
    if ($LASTEXITCODE -ne 0) { Fail "'uv tool install zotero-mcp-server' failed. Copy the error above and send it to Walden." }
}

if (-not (Test-Path $ZoteroMcpBin)) {
    Fail "Expected to find the installed connector at $ZoteroMcpBin but it's not there. Copy this message and send it to Walden."
}
Ok "Connector installed at $ZoteroMcpBin"

# ---------------------------------------------------------------------------
# Step 4: API key and library ID (manual, by design -- these are secrets)
# ---------------------------------------------------------------------------

Say "Step 4 of 6 -- your Zotero API key and library ID"
Write-Host @"
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
"@
Wait-Continue

$ZoteroApiKey = Read-Host "  Paste your Zotero API key here, then press Enter"
while ([string]::IsNullOrWhiteSpace($ZoteroApiKey)) {
    $ZoteroApiKey = Read-Host "  That was empty -- paste your Zotero API key"
}

$ZoteroLibraryId = Read-Host "  Paste your Zotero library ID (the number) here, then press Enter"
while ([string]::IsNullOrWhiteSpace($ZoteroLibraryId)) {
    $ZoteroLibraryId = Read-Host "  That was empty -- paste your library ID"
}

$maskedLen = [Math]::Max($ZoteroApiKey.Length - 4, 0)
$maskedKey = $ZoteroApiKey.Substring(0, [Math]::Min(4, $ZoteroApiKey.Length)) + ('*' * $maskedLen)
Ok "Got it -- key starting with '$maskedKey', library ID $ZoteroLibraryId."

# ---------------------------------------------------------------------------
# Step 5: claude_desktop_config.json -- confirm path, back up, then edit
# ---------------------------------------------------------------------------

Say "Step 5 of 6 -- Claude Desktop's config file"

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

$raw = Get-Content -Raw -Path $ConfigPath
if ([string]::IsNullOrWhiteSpace($raw)) { $raw = '{}' }

try {
    $configData = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
    Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
    Fail "Your existing config file wasn't valid JSON, so nothing was changed and the original file is untouched. Details: $($_.Exception.Message)"
}

if ($configData -isnot [System.Management.Automation.PSCustomObject]) {
    Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
    Fail "Your existing config file's top level isn't a JSON object, so nothing was changed and the original file is untouched."
}

if (-not ($configData.PSObject.Properties.Name -contains 'mcpServers')) {
    $configData | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([PSCustomObject]@{})
}

if ($configData.mcpServers -isnot [System.Management.Automation.PSCustomObject]) {
    Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
    Fail "'mcpServers' in your config file isn't a JSON object, so nothing was changed and the original file is untouched."
}

if ($configData.mcpServers.PSObject.Properties.Name -contains 'zotero') {
    Warn "A 'zotero' entry already exists in your config -- left it exactly as it was, in case you edited it on purpose."
    Info "If you want this script to overwrite it with the key/ID you just entered,"
    Info "restore the backup first (command printed above), then run this script again."
} else {
    $zoteroEntry = [PSCustomObject]@{
        command = $ZoteroMcpBin
        env     = [PSCustomObject]@{
            ZOTERO_LOCAL      = "true"
            ZOTERO_API_KEY    = $ZoteroApiKey
            ZOTERO_LIBRARY_ID = $ZoteroLibraryId
        }
    }
    $configData.mcpServers | Add-Member -NotePropertyName zotero -NotePropertyValue $zoteroEntry

    Write-Utf8NoBom -Path $ConfigPath -Text ($configData | ConvertTo-Json -Depth 10)

    # Confirm what we just wrote actually parses back cleanly.
    try {
        Get-Content -Raw -Path $ConfigPath | ConvertFrom-Json -ErrorAction Stop | Out-Null
    } catch {
        Copy-Item -Path $BackupPath -Destination $ConfigPath -Force
        Fail "Something went wrong writing the new config -- restored your backup. Details: $($_.Exception.Message)"
    }
    Ok "Zotero connector entry added to your config."
}

# ---------------------------------------------------------------------------
# Step 6: test it
# ---------------------------------------------------------------------------

Say "Step 6 of 6 -- test it"
Write-Host @"
  Almost done. Two things left, both outside this script:

  1. Make sure Zotero desktop is open and running.
  2. Fully quit Claude Desktop and reopen it. Closing the window is often
     not enough -- if it has an icon in the system tray near the clock,
     right-click that and choose Quit (or use Task Manager) before
     reopening it.

  Then, in a new chat, try asking:
     "Search my Zotero library for papers on [any topic in your library]"

  If Claude says it has no Zotero access, see the Troubleshooting
  section at workshop.walden.dk -> Connectors -> Zotero.
"@

Say "Done."
Info "Backup of your original config, if you ever need it:"
Info "  $BackupPath"
Wait-Continue
