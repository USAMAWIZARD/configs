#!/usr/bin/env bash
set -euo pipefail

TERMINAL="${VIMANYWHERE_TERMINAL:-alacritty}"
EDITOR_CMD="${VIMANYWHERE_EDITOR:-${EDITOR:-nvim}}"

file="$(mktemp --tmpdir vimanywhere.XXXXXXXX)"
cleanup() { rm -f "$file"; }
trap cleanup EXIT

# a small delay is usually required when dealing with xdotool
sleep 0.5

xdotool key --clearmodifiers ctrl+shift+Home
xdotool key --clearmodifiers ctrl+c

prefix="$(
  { xclip -selection clipboard -o 2>/dev/null | tr -d '\r'; } || true
)"
va_line="$(( $(printf %s "$prefix" | tr -cd '\n' | wc -c | tr -d '[:space:]') + 1 ))"
last="${prefix##*$'\n'}"
va_col="$(( ${#last} + 1 ))"

[[ -n "$prefix" ]] && xdotool key --clearmodifiers Right

xdotool key --clearmodifiers ctrl+a
xdotool key --clearmodifiers ctrl+v

xclip -selection clipboard -o >"$file"

if [[ "$EDITOR_CMD" == nvim* || "$EDITOR_CMD" == *" nvim"* ]]; then
  "$TERMINAL" -e sh -lc "$EDITOR_CMD +\"call cursor($va_line,$va_col)\" \"${file}\""
else
  "$TERMINAL" -e sh -lc "$EDITOR_CMD \"${file}\""
fi

# when done with editing, copy contents to clipboard
xclip -selection clipboard -i <"$file"

sleep 0.1

# replace the selection which was just copied
xdotool key  ctrl+v
