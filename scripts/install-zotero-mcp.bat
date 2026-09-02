@echo off
rem install-zotero-mcp.bat
rem
rem Double-click this file to run the Zotero + Claude Desktop connector
rem installer. This file must stay in the same folder as
rem install-zotero-mcp.ps1 -- it just launches that script the right way
rem (PowerShell blocks .ps1 files from running by double-click on purpose;
rem this works around that safely, for this one script only).
rem
rem If Windows shows a blue "Windows protected your PC" screen: click
rem "More info", then "Run anyway". That's expected for any new tool like
rem this one that hasn't been run on your machine before -- it still does
rem not need an admin password.

setlocal
set "SCRIPT_DIR=%~dp0"

if not exist "%SCRIPT_DIR%install-zotero-mcp.ps1" (
    echo Could not find install-zotero-mcp.ps1 next to this file.
    echo Make sure both install-zotero-mcp.bat and install-zotero-mcp.ps1
    echo are in the same folder, then try again.
    echo.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install-zotero-mcp.ps1"

if errorlevel 1 (
    echo.
    echo The installer exited with an error. Scroll up to see what happened.
    pause
)
