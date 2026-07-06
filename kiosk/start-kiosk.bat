@echo off
rem =====================================================================
rem  Fullscreen KIOSK launcher for Windows 10/11 (offline).
rem  Browser: Edge -> Chrome -> Firefox (whichever is installed).
rem
rem  Usage: just double-click. The script auto-detects the game that
rem  sits next to it (build game OR quiz). Or pass it explicitly:
rem      start-kiosk.bat viktorina.html
rem  Exit kiosk: press Esc inside the game. No auto-relaunch.
rem
rem  NOTE: kept ASCII-only on purpose. Cyrillic text + codepage tricks
rem  (chcp) break .bat parsing on some Windows systems.
rem =====================================================================
setlocal enableextensions

rem Game folder = parent of this .bat's folder
pushd "%~dp0.."
set "GDIR=%CD%"
popd

rem Auto-pick the game if not passed as an argument (works in either folder)
set "GAME=%~1"
if "%GAME%"=="" if exist "%GDIR%\gay-stroika-prototype.html" set "GAME=gay-stroika-prototype.html"
if "%GAME%"=="" if exist "%GDIR%\viktorina.html" set "GAME=viktorina.html"
set "GPATH=%GDIR%\%GAME%"
if not exist "%GPATH%" (
  echo ERROR: game file not found: "%GPATH%"
  echo Available games:
  dir /b "%GDIR%\*.html"
  pause
  exit /b 1
)

rem file:/// URL (backslashes -> forward slashes)
set "URL=file:///%GPATH:\=/%"
set "PROFILE=%TEMP%\gay-kiosk-profile"

set "MODE="
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" ( set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" & set "MODE=edge" )
if not defined MODE if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" ( set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe" & set "MODE=chrome" )
if not defined MODE if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" ( set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" & set "MODE=chrome" )
if not defined MODE if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" ( set "BROWSER=%ProgramFiles%\Mozilla Firefox\firefox.exe" & set "MODE=firefox" )
if not defined MODE (
  echo ERROR: Edge, Chrome or Firefox not found.
  pause
  exit /b 1
)
echo Launching kiosk: %URL%
echo Press Esc in the game to close it. No auto-relaunch.
rem Launch once (fire-and-forget). Esc in the game closes the window; the
rem kiosk is NOT relaunched. This .bat window closes right after launching.
if "%MODE%"=="edge"    start "" "%BROWSER%" --kiosk "%URL%" --edge-kiosk-type=fullscreen --no-first-run --overscroll-history-navigation=0 --user-data-dir="%PROFILE%"
if "%MODE%"=="chrome"  start "" "%BROWSER%" --kiosk "%URL%" --no-first-run --disable-pinch --overscroll-history-navigation=0 --incognito --user-data-dir="%PROFILE%"
if "%MODE%"=="firefox" start "" "%BROWSER%" -kiosk "%URL%"
