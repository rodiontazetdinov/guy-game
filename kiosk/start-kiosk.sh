#!/usr/bin/env bash
# =====================================================================
#  Запуск игры в полноэкранном КИОСКЕ.
#  Для ноутбука музея под Astra Linux (Firefox или Chromium).
#  Полный офлайн: открывает локальный файл по file://, интернет не нужен.
#
#  Использование:
#    ./start-kiosk.sh                          # игра-стройка (по умолчанию)
#    ./start-kiosk.sh viktorina.html           # викторина
#  Остановить:  закрыть окно (Alt+F4) ИЛИ из терминала:
#    pkill -f start-kiosk ; pkill -f "\.html"  # watchdog + браузер игры
# =====================================================================
set -u

# Папка игры = родитель папки этого скрипта (работает с флешки из любого пути)
DIR="$(cd "$(dirname "$0")/.." && pwd)"
# Игра: 1-й аргумент; иначе игра-стройка, если есть; иначе первый *.html в папке (для папки только с викториной).
if [ -n "${1:-}" ]; then GAME_FILE="$1";
elif [ -f "$DIR/gay-stroika-prototype.html" ]; then GAME_FILE="gay-stroika-prototype.html";
else GAME_FILE="$(cd "$DIR" && ls *.html 2>/dev/null | head -1)"; fi
GAME="$DIR/$GAME_FILE"
URL="file://$GAME"

if [ ! -f "$GAME" ]; then
  echo "ОШИБКА: не найден файл игры: $GAME" >&2
  echo "Доступные игры в $DIR:" >&2
  ls "$DIR"/*.html 2>/dev/null | sed 's#.*/#  #' >&2
  exit 1
fi

# --- Отключить гашение экрана/заставку (чтобы проектор не тух) ---
if command -v xset >/dev/null 2>&1; then
  xset s off       2>/dev/null || true
  xset s noblank   2>/dev/null || true
  xset -dpms       2>/dev/null || true
fi

# --- Спрятать курсор при простое (если есть unclutter; в игре курсор и так прячется) ---
if command -v unclutter >/dev/null 2>&1; then
  unclutter -idle 1 >/dev/null 2>&1 &
fi

# --- Выбрать браузер: приоритет Firefox, затем Chromium/Chrome ---
launch() {
  if command -v firefox >/dev/null 2>&1; then
    echo "Браузер: Firefox (kiosk)"
    firefox --kiosk --new-instance "$URL"
  elif command -v chromium >/dev/null 2>&1 || command -v chromium-browser >/dev/null 2>&1 || command -v google-chrome >/dev/null 2>&1; then
    local BIN
    BIN="$(command -v chromium || command -v chromium-browser || command -v google-chrome)"
    echo "Браузер: $BIN (kiosk)"
    "$BIN" \
      --kiosk --app="$URL" \
      --user-data-dir=/tmp/gay-kiosk-profile \
      --no-first-run --no-default-browser-check \
      --disable-translate --disable-infobars \
      --disable-session-crashed-bubble --disable-pinch \
      --overscroll-history-navigation=0 --noerrordialogs \
      --incognito
  else
    echo "ОШИБКА: не найден ни Firefox, ни Chromium. Установите один из браузеров." >&2
    return 127
  fi
}

# --- Watchdog: перезапуск при закрытии/краше браузера ---
echo "Запуск киоска: $URL"
while true; do
  launch
  rc=$?
  # Если браузер не найден — выходим, перезапуск бессмысленен
  if [ "$rc" -eq 127 ]; then exit 127; fi
  echo "Браузер закрылся (код $rc). Перезапуск через 2 c... (Ctrl+C чтобы выйти)"
  sleep 2
done
