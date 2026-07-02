@echo off
rem =====================================================================
rem  Запуск игры в полноэкранном КИОСКЕ на Windows 10/11.
rem  Браузер: Edge -> Chrome -> Firefox (что найдётся). Полный офлайн.
rem
rem  Использование:
rem    start-kiosk.bat                       - игра-стройка (по умолчанию)
rem    start-kiosk.bat viktorina.html        - викторина
rem  Выход из киоска:  Alt+F4  (окно перезапустится; чтобы остановить
rem                    совсем - закрыть это чёрное окно .bat).
rem =====================================================================
setlocal enableextensions

rem Папка игры = родитель папки этого .bat
pushd "%~dp0.."
set "GDIR=%CD%"
popd

set "GAME=%~1"
if "%GAME%"=="" set "GAME=gay-stroika-prototype.html"
set "GPATH=%GDIR%\%GAME%"
if not exist "%GPATH%" (
  echo ОШИБКА: не найден файл игры "%GPATH%"
  echo Доступные игры:
  dir /b "%GDIR%\*.html"
  pause & exit /b 1
)

rem file:/// URL (обратные слэши -> прямые)
set "URL=file:///%GPATH:\=/%"
set "PROFILE=%TEMP%\gay-kiosk-profile"

set "MODE="
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" ( set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" & set "MODE=edge" )
if not defined MODE if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" ( set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe" & set "MODE=chrome" )
if not defined MODE if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" ( set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" & set "MODE=chrome" )
if not defined MODE if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" ( set "BROWSER=%ProgramFiles%\Mozilla Firefox\firefox.exe" & set "MODE=firefox" )
if not defined MODE (
  echo ОШИБКА: не найден Edge, Chrome или Firefox.
  pause & exit /b 1
)
echo Браузер: %BROWSER%
echo Игра:    %URL%
echo (Alt+F4 - выйти; окно само перезапустится. Закрыть это окно - остановить.)

:loop
if "%MODE%"=="edge"    start "" /wait "%BROWSER%" --kiosk "%URL%" --edge-kiosk-type=fullscreen --no-first-run --overscroll-history-navigation=0 --user-data-dir="%PROFILE%"
if "%MODE%"=="chrome"  start "" /wait "%BROWSER%" --kiosk "%URL%" --no-first-run --disable-pinch --overscroll-history-navigation=0 --incognito --user-data-dir="%PROFILE%"
if "%MODE%"=="firefox" start "" /wait "%BROWSER%" -kiosk "%URL%"
timeout /t 2 /nobreak >nul
goto loop
