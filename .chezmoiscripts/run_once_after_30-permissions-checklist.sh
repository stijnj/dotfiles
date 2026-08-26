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

  2. Webapp dock apps (work machines)
     SUPER+SHIFT+C / W / J call  open -a "Outlook Calendar" / "Confluence"
     / "Jira".  Those names do not resolve until you install each site as
     a dock app: open it in Safari, Share > Add to Dock, and name it
     exactly as above. Until then those three keys do nothing.

  3. Raycast hotkeys
     Main hotkey      -> Caps + Space  (⌘⌃⌥Space)
     Clipboard history-> Caps + V
     Leave ⌘Space on Spotlight so corporate search still works.
     Script Commands  -> Add Directory -> ~/.config/raycast/scripts
     Give "Keybindings" the hotkey Caps + K.

  4. Reduce Motion
     System Settings > Accessibility > Display > Reduce Motion: OFF
     (The apply script tries this, but the domain is TCC-protected.)

     Optional, undecided: macOS tiling has no workspaces. If you want
     something like them, bind ctrl+1..9 under System Settings > Keyboard
     > Keyboard Shortcuts > Mission Control, then pin apps with
     Dock > right-click app > Options > Assign To.

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
