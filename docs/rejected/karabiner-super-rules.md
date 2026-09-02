# Karabiner Super rules (removed 2026-08-27)

Two of the three `complex_modifications` rules in `karabiner.json` were removed:
the terminal paste shim and the fifteen app launchers. Only **Caps Lock → Super
(⌘⌃⌥), Escape when tapped alone** remains.

This is a record, not a config. Nothing here is meant to be restored.

## Why

They were removed in Karabiner's own UI, and the removal was deliberate. The
rules survived only in the chezmoi source, which had drifted ahead of the live
file — the same failure mode as the AeroSpace assignments in this directory.
Rather than re-apply them, the source was reduced to match.

Removing them also emptied the `{{ if .work }}` conditional, which existed
solely to gate the five work-only launchers. `karabiner.json` is no longer a
template.

## Super + V — paste in terminals

A shim so `SUPER+V` sent plain `⌘V` inside terminal emulators, scoped by
`frontmost_application_if` to Ghostty, Terminal.app, kitty and iTerm2. The
description carried a warning that `SUPER+C` was _not_ to be paired with it,
because Raycast owns that key for Center.

```json
{
    "type": "basic",
    "conditions": [
        {
            "type": "frontmost_application_if",
            "bundle_identifiers": [
                "^com\\.mitchellh\\.ghostty$",
                "^com\\.apple\\.Terminal$",
                "^net\\.kovidgoyal\\.kitty$",
                "^com\\.googlecode\\.iterm2$"
            ]
        }
    ],
    "from": {
        "key_code": "v",
        "modifiers": {
            "mandatory": ["left_command", "left_control", "left_option"]
        }
    },
    "to": [{ "key_code": "v", "modifiers": ["left_command"] }]
}
```

## Super + key — launch applications

`shell_command` manipulators, inherited from AeroSpace's `exec-and-forget`
bindings when AeroSpace was dropped. `open` was spelled absolutely because
Karabiner runs `shell_command` with a minimal environment, not a login shell.

| Keys                  | Command                                          |
| --------------------- | ------------------------------------------------ |
| `SUPER + Enter`       | `/usr/bin/open -na Ghostty`                      |
| `SUPER+SHIFT + Enter` | `/usr/bin/open -na "Edge"`                       |
| `SUPER+SHIFT + B`     | `/usr/bin/open -na "Edge"`                       |
| `SUPER+SHIFT + F`     | `/usr/bin/open -a Finder`                        |
| `SUPER+SHIFT + O`     | `/usr/bin/open -a Obsidian`                      |
| `SUPER+SHIFT + M`     | `/usr/bin/open -a Spotify`                       |
| `SUPER+SHIFT + D`     | `/usr/bin/open -na Ghostty --args -e lazydocker` |
| `SUPER+SHIFT + G`     | `/usr/bin/open -na Ghostty --args -e lazygit`    |
| `SUPER+SHIFT + /`     | `/usr/bin/open -a "1Password"`                   |
| `SUPER+SHIFT + A`     | `/usr/bin/open -a "Claude"`                      |

Work-only, behind `{{ if .work }}`:

| Keys              | Command                                |
| ----------------- | -------------------------------------- |
| `SUPER+SHIFT + E` | `/usr/bin/open -a "Microsoft Outlook"` |
| `SUPER+SHIFT + C` | `/usr/bin/open -a "Outlook Calendar"`  |
| `SUPER+SHIFT + W` | `/usr/bin/open -a "Confluence"`        |
| `SUPER+SHIFT + J` | `/usr/bin/open -a "Jira"`              |
| `SUPER+SHIFT + T` | `/usr/bin/open -a "Microsoft Teams"`   |

The last three needed Safari **Share › Add to Dock** webapps named exactly
`Outlook Calendar`, `Confluence` and `Jira` before they resolved. That manual
step is gone from the README along with the keys.

## What replaced them

Nothing. Raycast and Spotlight both already open applications by name, which is
what these keys did with a fixed list and no discovery.
