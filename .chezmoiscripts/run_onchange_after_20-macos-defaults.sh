#!/bin/bash
# macOS defaults. Re-runs only when this file changes.
#
# Section 1 was captured from this machine on 2026-08-26 by diffing every key
# against its live value — it is a record of settings actually in use, not a
# copy of someone else's preferences. The old .macos (777 lines, 175 keys) was
# discarded: 150 of its keys read UNSET here, i.e. it was never applied.
#
# Section 2 was added deliberately and was NOT previously set. These are the
# ones that change how the machine feels. It used to exist for AeroSpace;
# tiling is macOS native now, so the tiling keys are Apple's own.
set -euo pipefail

echo "macos: applying defaults"

# ── 1. Your existing settings ───────────────────────────────────────────────
# Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

# Dock
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock tilesize -int 32

# Input & text
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# ── 2. Window management, key repeat, motion ────────────────────────────────
# Tiling is macOS native, driven through Karabiner. No third-party window
# manager -- see docs/rejected/aerospace-workspace-assignments.md.

# Native tiling behaviour.
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool true
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true

# Spaces stay in a fixed order. Kept from the AeroSpace era: it is still what
# makes ctrl+1..9 mean the same space every time, if Mission Control spaces
# ever get set up.
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool true

# The Dock is on the left; autohide keeps a vertical strip from being lost on
# every tiled window.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Animations that cost time on every window resize.
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Omarchy's key repeat: fast, and press-and-hold off so key repeat works in vim.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Reduce Motion OFF. It was only ever on to kill AeroSpace's workspace-switch
# animation; with that gone the native tiling animation is wanted, not endured.
# This domain is TCC-protected: the write can fail silently without Full Disk
# Access, so the permissions checklist covers it too.
defaults write com.apple.universalaccess reduceMotion -bool false 2>/dev/null || \
  echo "macos: could not unset reduceMotion — turn it off by hand (Settings > Accessibility > Display)"

killall WindowManager >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall Finder >/dev/null 2>&1 || true
echo "macos: done (some settings need a logout to fully apply)"
