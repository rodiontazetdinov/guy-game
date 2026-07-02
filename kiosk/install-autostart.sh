#!/usr/bin/env bash
# =====================================================================
#  Установка автозапуска киоска в текущем пользователе Astra Linux.
#  Подставляет реальный путь к игре в шаблон .desktop и кладёт его
#  в ~/.config/autostart/ — после перезагрузки игра стартует сама.
#
#  Запуск (от обычного пользователя, НЕ root):  ./install-autostart.sh
#  Откат:  rm ~/.config/autostart/gay-kiosk.desktop
# =====================================================================
set -eu

KIOSK_DIR="$(cd "$(dirname "$0")" && pwd)"
GAME_DIR="$(cd "$KIOSK_DIR/.." && pwd)"
AUTOSTART_DIR="$HOME/.config/autostart"
TEMPLATE="$KIOSK_DIR/gay-kiosk.desktop"
TARGET="$AUTOSTART_DIR/gay-kiosk.desktop"

if ! ls "$GAME_DIR"/*.html >/dev/null 2>&1; then
  echo "ОШИБКА: рядом нет ни одного .html файла игры (ожидался в $GAME_DIR)" >&2
  exit 1
fi

chmod +x "$KIOSK_DIR/start-kiosk.sh"
mkdir -p "$AUTOSTART_DIR"

# Подставить абсолютный путь к игре в шаблон
sed "s#__GAME_DIR__#$GAME_DIR#g" "$TEMPLATE" > "$TARGET"

echo "Автозапуск установлен:"
echo "  $TARGET"
echo "  → Exec: $GAME_DIR/kiosk/start-kiosk.sh"
echo
echo "Готово. Игра запустится в киоске после перезагрузки."
echo "Проверить сейчас: $KIOSK_DIR/start-kiosk.sh"
