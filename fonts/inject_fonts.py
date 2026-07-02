#!/usr/bin/env python3
# Вставляет @font-face с base64-woff2 (Lobster + PT Sans, cyrillic+latin) в начало <style> HTML.
# Идемпотентно: повторный запуск не дублирует (проверяет маркер).
import base64, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
# Цель — первый аргумент (имя/путь HTML), по умолчанию игра-стройка.
_arg = sys.argv[1] if len(sys.argv) > 1 else "gay-stroika-prototype.html"
HTML = _arg if os.path.isabs(_arg) else os.path.join(HERE, "..", _arg)
MARKER = "/* OFFLINE-FONTS (base64) */"

CYR = "U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116"
LAT = ("U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, "
       "U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, "
       "U+2212, U+2215, U+FEFF, U+FFFD")

# (family, weight, unicode-range, woff2-файл)
FACES = [
    ("Lobster", 400, CYR, "lobster-cyr.woff2"),
    ("Lobster", 400, LAT, "lobster-lat.woff2"),
    ("PT Sans", 400, CYR, "ptsans400-cyr.woff2"),
    ("PT Sans", 400, LAT, "ptsans400-lat.woff2"),
    ("PT Sans", 700, CYR, "ptsans700-cyr.woff2"),
    ("PT Sans", 700, LAT, "ptsans700-lat.woff2"),
]

def b64(path):
    with open(path, "rb") as f:
        return base64.b64encode(f.read()).decode("ascii")

blocks = [MARKER]
for fam, wt, urange, fname in FACES:
    data = b64(os.path.join(HERE, fname))
    blocks.append(
        "@font-face{font-family:'%s';font-style:normal;font-weight:%d;font-display:swap;"
        "src:url(data:font/woff2;base64,%s) format('woff2');unicode-range:%s;}"
        % (fam, wt, data, urange)
    )
css = "\n".join(blocks) + "\n"

with open(HTML, "r", encoding="utf-8") as f:
    html = f.read()

if MARKER in html:
    print("Шрифты уже вшиты (маркер найден) — пропуск.")
    sys.exit(0)

idx = html.find("<style>")
if idx < 0:
    print("ОШИБКА: тег <style> не найден")
    sys.exit(1)
ins = idx + len("<style>")
html = html[:ins] + "\n" + css + html[ins:]

with open(HTML, "w", encoding="utf-8") as f:
    f.write(html)
print("Вшито 6 @font-face, общий размер CSS:", len(css), "символов")
