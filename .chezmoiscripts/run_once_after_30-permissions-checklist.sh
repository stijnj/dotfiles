#!/bin/bash
# Prints the steps that cannot be scripted. Runs once per machine.
cat <<'TXT'

────────────────────────────────────────────────────────────────────────
  Manual steps — nothing below can be done by a script.

  1. Karabiner-Elements
     Install needs an interactive sudo:
         brew install --cask karabiner-elements
     Then open it once and approve the driver extension:
         System Settings > General > Login Items & Extensions
                         > Driver Extensions > enable Karabiner
     The Caps Lock -> Super rule is already in karabiner.json; you do NOT
     need to add it from the UI.

  2. AeroSpace
     Launch it, grant Accessibility when prompted:
         System Settings > Privacy & Security > Accessibility
     Verify:  aerospace list-workspaces --all

  3. Raycast hotkeys
     Main hotkey      -> Caps + Space  (⌘⌃⌥Space)
     Clipboard history-> Caps + V
     Leave ⌘Space on Spotlight so corporate search still works.
     Script Commands  -> Add Directory -> ~/.config/raycast/scripts
     Give "Keybindings" the hotkey Caps + K.

  4. Reduce Motion
     System Settings > Accessibility > Display > Reduce Motion: ON
     (The apply script tries this, but the domain is TCC-protected.)

  5. npm registry tokens
     Create the 1Password item the ~/.npmrc template reads:
         op item create --category="API Credential" --vault=Employee \
           --title="npm-registry-tokens" \
           "npmjs_token[password]=<token>" \
           "fontawesome_token[password]=<token>"
     The old tokens are in ~/dotfiles-backup-2026-08-26/home/.npmrc.

  Then:  dotfiles-doctor
────────────────────────────────────────────────────────────────────────

TXT
