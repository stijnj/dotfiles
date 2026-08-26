#!/bin/bash
# Omarchy's SUPER+K, ported. Prints the live keymap straight from
# ~/.aerospace.toml, so it can never drift from what's actually bound.
#
# Install: Raycast › Extensions › Script Commands › Add Directories
#          -> point at this folder. Then give it hotkey Caps + K.
#
# @raycast.schemaVersion 1
# @raycast.title Keybindings
# @raycast.mode fullOutput
# @raycast.packageName Omakase
# @raycast.icon ⌨️

printf '  SUPER = Caps Lock (⌘⌃⌥)\n\n'

awk '
  /^# ── / { sub(/^# ── /,""); sub(/ ─+.*$/,""); printf "\n  %s\n", toupper($0); next }
  /^cmd-ctrl-alt/ {
    split($0, p, "=")
    key = p[1]; gsub(/[ \t]+$/, "", key)
    cmd = substr($0, index($0,"=")+1)
    gsub(/^[ \t]*.|.[ \t]*$/, "", cmd)
    gsub(/exec-and-forget open (-na |-a )?/, "", cmd)
    gsub(/--args -e /, "", cmd)
    gsub(/"/, "", cmd)
    gsub(/cmd-ctrl-alt-shift-/, "SUPER+SHIFT+", key)
    gsub(/cmd-ctrl-alt-/, "SUPER+", key)
    printf "    %-26s %s\n", key, cmd
  }
' ~/.aerospace.toml

cat <<'EOF'

  RAYCAST-OWNED
    SUPER+Space                Command menu
    SUPER+SHIFT+Space          App search
    SUPER+V                    Clipboard history
    SUPER+K                    This sheet
    SUPER+S                    Capture
    SUPER+X                    Extract text (OCR)
    SUPER+P                    Colour picker
    SUPER+Esc                  System menu

  MACOS NATIVE — Omarchy has these too, you already had them
    ⌘C / ⌘V / ⌘X               Universal clipboard
    ⌘Tab                       Cycle windows
    ⌃⌘Space                    Emoji picker
    Caps (tap)                 Escape
EOF
