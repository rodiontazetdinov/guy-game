@echo off
rem =====================================================================
rem  Auto-start the kiosk at Windows logon (creates a Startup shortcut).
rem  Run: double-click this file.
rem  Undo: delete the "Gay-kiosk" shortcut from the Startup folder
rem        (press Win+R, type  shell:startup ).
rem  ASCII-only on purpose (Cyrillic + codepage tricks break .bat parsing).
rem =====================================================================
setlocal
set "KDIR=%~dp0"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

rem Optional game argument. Empty = auto-detect the game next to start-kiosk.bat
rem (build game OR quiz). Or pass viktorina.html explicitly.
set "GAMEARG=%~1"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut((Join-Path '%STARTUP%' 'Gay-kiosk.lnk')); $s.TargetPath=(Join-Path '%KDIR%' 'start-kiosk.bat'); $s.Arguments='%GAMEARG%'; $s.WorkingDirectory='%KDIR%'; $s.WindowStyle=7; $s.Save()"

if errorlevel 1 ( echo ERROR: could not create the shortcut. & pause & exit /b 1 )
echo Auto-start installed: "%STARTUP%\Gay-kiosk.lnk"
echo The game will open in kiosk mode after the next reboot.
pause
