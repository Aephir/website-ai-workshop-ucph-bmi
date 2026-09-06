@echo off
rem install-mcpvault.bat
rem
rem Double-click this file to run the Obsidian Vault + Claude Desktop
rem connector installer. This file must stay in the same folder as
rem install-mcpvault.ps1 -- it just launches that script the right way
rem (PowerShell blocks .ps1 files from running by double-click on purpose;
rem this works around that safely, for this one script only).
rem
rem If Windows shows a blue "Windows protected your PC" screen: click
rem "More info", then "Run anyway". That's expected for any new tool like
rem this one that hasn't been run on your machine before -- it still does
rem not need an admin password.

setlocal
set "SCRIPT_DIR=%~dp0"

if not exist "%SCRIPT_DIR%install-mcpvault.ps1" (
    echo Could not find install-mcpvault.ps1 next to this file.
    echo Make sure both install-mcpvault.bat and install-mcpvault.ps1
    echo are in the same folder, then try again.
    echo.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install-mcpvault.ps1"

if errorlevel 1 (
    echo.
    echo The installer exited with an error. Scroll up to see what happened.
    pause
)
