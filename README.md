# dotfiles

Single source of truth for my machine config, managed with
[chezmoi](https://chezmoi.io). Works across the Cegeka work Mac and the
personal Mac; everything that differs between them differs by template
variable, not by having two copies of a file.

## New machine

```bash
# 1. Homebrew, if it isn't there yet
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. chezmoi + this repo. Asks three questions, then does everything else.
brew install chezmoi
chezmoi init --apply https://github.com/stijnj/dotfiles.git
```

The three questions:

| Prompt | Meaning |
|---|---|
| Is this a work machine (Cegeka) | Gates Cegeka packages, Teams/Outlook/Jira bindings, the mysql-client PATH |
| Work git email | Used for repos with a `gitlab.cegeka.*` remote |
| Personal git email | Used for everything else |

Then:

```bash
dotfiles-doctor      # pass/fail on everything a script can check
```

## Manual steps

Nothing below can be scripted. `dotfiles-doctor` reports each one.

- [ ] **Karabiner-Elements** — `brew install --cask karabiner-elements` needs an
      interactive sudo, so it can fail during an unattended `chezmoi apply`.
      Run it by hand, then open the app once and approve the driver extension:
      **System Settings › General › Login Items & Extensions › Driver Extensions**.
      The Caps Lock → Super rule is already in `karabiner.json` — you do *not*
      need to add it from the UI.
- [ ] **AeroSpace Accessibility** — launch it and grant Accessibility under
      **System Settings › Privacy & Security › Accessibility**.
      Verify with `aerospace list-workspaces --all`.
- [ ] **Raycast hotkeys** — main hotkey to Caps+Space (`⌘⌃⌥Space`), clipboard
      history to Caps+V. Leave `⌘Space` on Spotlight so corporate search still
      works. Add `~/.config/raycast/scripts` under Script Commands and give
      "Keybindings" the hotkey Caps+K.
- [ ] **Reduce Motion** — **System Settings › Accessibility › Display › Reduce
      Motion: ON**. The apply script attempts this, but the domain is
      TCC-protected and the write can fail silently.
- [ ] **npm tokens** — create the 1Password item that `~/.npmrc` reads:
      ```
      op item create --category="API Credential" --vault=Employee \
        --title="npm-registry-tokens" \
        "npmjs_token[password]=<token>" "fontawesome_token[password]=<token>"
      ```

## Layout

| Path | What |
|---|---|
| `.chezmoi.toml.tmpl` | The three init prompts |
| `.chezmoitemplates/Brewfile` | Package list, rendered inline by the brew script — never written to `$HOME` |
| `.chezmoiscripts/` | Homebrew, macOS defaults, VS Code extensions, the manual checklist |
| `dot_zshrc.tmpl` | zsh + oh-my-zsh + starship |
| `dot_gitconfig.tmpl` | Identity split by remote URL |
| `dot_aerospace.toml.tmpl` | 64 bindings work / 59 personal |
| `private_dot_config/` | ghostty, karabiner, starship, git, raycast |
| `dot_claude/` | Claude Code settings, statusline, skills |
| `dot_local/bin/` | `dotfiles-doctor` |

## Decisions

- **Prompt is starship, not powerlevel10k.** Omarchy's `starship.toml` is used
  unchanged. This drops the kubecontext/Azure/gcloud/exit-code indicators p10k
  showed on demand — a deliberate trade. If they turn out to be missed, add
  starship's own `kubernetes`/`azure`/`gcloud`/`cmd_duration` modules rather
  than going back to p10k.
- **Git identity by remote, not path.** `~/Developer` is a flat mix of Cegeka
  GitLab and GitHub checkouts. Three `hasconfig` patterns are needed because
  the remotes come in three URL shapes.
- **Karabiner rules are inlined into `karabiner.json`**, not dropped into
  `assets/complex_modifications/`. The latter only makes a rule *available* and
  still needs enabling by hand on every machine. Cost: Karabiner rewrites this
  file when you change settings in its UI, so `chezmoi diff` will occasionally
  show drift.
- **No mise, no colima**, though Omarchy ships both — they would collide with
  pyenv/fnm and Docker Desktop. Listed commented-out in the Brewfile.
- **`.macos` was discarded, not migrated.** 150 of its 175 keys read UNSET on
  the work Mac: it had never been applied. The replacement script encodes the
  9 settings actually in use plus 11 added for AeroSpace.

## Secrets

Nothing sensitive is committed. `~/.npmrc` is the only file with credentials
and it is templated through `onepasswordRead`. Verified with `git log -S` over
every commit patch, not just the tree.
