# AeroSpace workspace assignments (removed 2026-08-26)

AeroSpace was dropped because its tree model didn't match how I think about
windows, and it carried too much vocabulary to learn — not because of anything
wrong with this configuration. Replaced by macOS native tiling driven through
Karabiner.

This is a record, not a config. Nothing here is meant to be restored.

## What was auto-placed where

Taken from the live `~/.aerospace.toml` as it actually ran, not from the source
template, which had drifted ahead of it and was never applied.

| Workspace | Apps | Bundle IDs |
|---|---|---|
| 1 | Edge | `com.microsoft.edgemac` |
| 2 | Ghostty, Obsidian, Teams *(work only)* | `com.mitchellh.ghostty`, `md.obsidian`, `com.microsoft.teams2` |
| 3 | Outlook *(work only)* | `com.microsoft.Outlook` |
| 4 | DataGrip, VS Code | `com.jetbrains.datagrip`, `com.microsoft.VSCode` |
| 5 | Claude | `com.anthropic.claudefordesktop` |
| 9 | Spotify | `com.spotify.client` |

Workspaces 6, 7, 8 and 10 were reachable by keystroke but nothing was ever
assigned to them.

Forced to float, never tiled: System Settings (`com.apple.systempreferences`),
1Password (`com.1password.1password`), Activity Monitor
(`com.apple.ActivityMonitor`), and Finder windows whose title ended in `Info`.

## The legend was wrong

The comment above the workspace bindings read:

```
# 1 term · 2 web · 3 code · 4 jira · 5 chat · 6 notes · 7 mail · 8 scratch · 9 media
```

That describes an intent, not the file it sat in. The actual rules put the
browser on 1 and the terminal on 2, code on 4 rather than 3, and never used 6,
7 or 8 at all. Worth remembering that the labels and the behaviour had already
come apart before anything was removed.

## Why none of this carried over

macOS native tiling has no workspace concept, so there is nothing to port these
to. The nearest equivalent is Mission Control Spaces with per-app assignment
(System Settings → Keyboard → Keyboard Shortcuts → Mission Control for
`ctrl+1..9`, then Dock → right-click app → Options → Assign To). That is
listed as optional in the README and has not been set up.

The app *launch* bindings did carry over — they are `shell_command`
manipulators in `karabiner.json.tmpl` now, on the same keys.
