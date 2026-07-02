#!/usr/bin/env bash
# =====================================================================
#  Сборка финальных папок поставки по двум контрактам.
#  Каждая папка самодостаточна и работает офлайн (двойной клик / киоск).
#  Запуск:  ./build-delivery.sh
# =====================================================================
set -eu
DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$DIR/delivery"
rm -rf "$OUT"
C1="$OUT/contract1-stroika"
C2="$OUT/contract2-viktorina"
mkdir -p "$C1/kiosk" "$C1/docs" "$C2/kiosk" "$C2/docs" "$C2/foto"
# (викторина — чистый HTML/CSS/JS, three.js/libs ей не нужны)

# --- Контракт №1: игра-стройка ---
cp "$DIR/gay-stroika-prototype.html"      "$C1/"
[ -f "$DIR/gay-fon.jpg" ] && cp "$DIR/gay-fon.jpg" "$C1/" || true   # фон стартового экрана
mkdir -p "$C1/foto"
cp "$DIR/foto/stage"*.jpg "$C1/foto/" 2>/dev/null || true            # архивные фото-превью этапов
cp -r "$DIR/libs"                          "$C1/"
cp -r "$DIR/kiosk/." "$C1/kiosk/"                                    # все скрипты киоска (Windows .bat + Linux .sh)
cp "$DIR/docs/Инструкция_по_установке.md" "$DIR/docs/Руководство_стройка.md" "$DIR/docs/Проверка_приёмки.md" "$C1/docs/"
[ -d "$DIR/audio" ] && cp -r "$DIR/audio" "$C1/" || true

# --- Контракт №2: викторина ---
cp "$DIR/viktorina.html"                   "$C2/"
cp -r "$DIR/kiosk/." "$C2/kiosk/"
cp "$DIR/docs/Инструкция_по_установке.md" "$DIR/docs/Руководство_викторина.md" "$DIR/docs/Проверка_приёмки.md" "$C2/docs/"
cp "$DIR/foto/"*.jpg "$DIR/foto/"*.jpeg "$DIR/foto/"*.png "$C2/foto/" 2>/dev/null || true   # фото вопросов + фон
mkdir -p "$C2/audio" && cp "$DIR/audio/q"*.mp3 "$DIR/audio/win"*.mp3 "$DIR/audio/draw.mp3" "$C2/audio/" 2>/dev/null || true   # озвучка вопросов + финала
[ -f "$DIR/foto/README.txt" ] && cp "$DIR/foto/README.txt" "$C2/foto/" || true

# викторина по умолчанию должна стартовать как viktorina.html — поправим шаблоны автозапуска копии
sed -i.bak 's#start-kiosk.sh#start-kiosk.sh viktorina.html#' "$C2/kiosk/gay-kiosk.desktop" && rm -f "$C2/kiosk/gay-kiosk.desktop.bak"

echo "Готово. Папки поставки:"
echo "  $C1"
echo "  $C2"
echo "Проверьте: открыть HTML двойным кликом или ./kiosk/start-kiosk.sh в каждой папке."
