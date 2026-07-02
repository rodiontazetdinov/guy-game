@echo off
rem =====================================================================
rem  Автозапуск киоска при входе в Windows (ярлык в папке Автозагрузка).
rem  Запуск: двойной клик по этому файлу.
rem  Откат: удалить ярлык "Гай-киоск" из папки автозагрузки (shell:startup).
rem =====================================================================
setlocal
set "KDIR=%~dp0"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

rem Какую игру запускать по умолчанию (пусто = игра-стройка; для викторины впишите viktorina.html)
set "GAMEARG=%~1"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut(Join-Path '%STARTUP%' 'Гай-киоск.lnk'); $s.TargetPath=Join-Path '%KDIR%' 'start-kiosk.bat'; $s.Arguments='%GAMEARG%'; $s.WorkingDirectory='%KDIR%'; $s.WindowStyle=7; $s.Save()"

if errorlevel 1 ( echo Не удалось создать ярлык. & pause & exit /b 1 )
echo Автозапуск установлен: "%STARTUP%\Гай-киоск.lnk"
echo После перезагрузки игра откроется в киоске автоматически.
pause
