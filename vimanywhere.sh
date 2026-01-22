#!/usr/bin/env bash
set -euo pipefail

# Edit the current selection in $EDITOR inside a terminal, then paste it back.
# Override via:
# - VIMANYWHERE_TERMINAL (default: alacritty)
# - VIMANYWHERE_EDITOR (default: $EDITOR, then nvim)

TERMINAL="${VIMANYWHERE_TERMINAL:-alacritty}"
EDITOR_CMD="${VIMANYWHERE_EDITOR:-${EDITOR:-nvim}}"

file="$(mktemp --tmpdir vimanywhere.XXXXXXXX)"
cleanup() { rm -f "$file"; }
trap cleanup EXIT

# a small delay is usually required when dealing with xdotool
sleep 0.5

# copy whatever was selected
xdotool key  ctrl+a
xdotool key  ctrl+c

# put clipboard contents inside a file
xclip -selection clipboard -o >"$file"

# open preferred text editor in a terminal
# NOTE: we use a shell so EDITOR_CMD can include args (e.g. "nvim -u NONE")
"$TERMINAL" -e sh -lc "$EDITOR_CMD \"${file}\""

# when done with editing, copy contents to clipboard
xclip -selection clipboard -i <"$file"

sleep 0.1

# replace the selection which was just copied
xdotool key  ctrl+v
