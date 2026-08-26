#!/bin/bash
# Claude Code status line: dir | model | ctx% | session cost
# Edit freely — just ask Claude to adjust it.

input=$(cat)

# Unit separator, not tab: bash `read` always collapses runs of tabs (IFS
# whitespace), which would shift fields when one is empty.
IFS=$'\x1f' read -r cwd model ctx_pct cost <<< "$(printf '%s' "$input" | jq -r '
  [
    (.workspace.current_dir // .cwd // ""),
    (.model.display_name // ""),
    (.context_window.used_percentage // ""),
    (.cost.total_cost_usd // "")
  ] | map(tostring) | join("\u001f")
' 2>/dev/null)"

[ -z "$cwd" ] && cwd="$PWD"

# Abbreviate $HOME as ~
display_dir="$cwd"
if [ -n "$HOME" ] && [ "${cwd#"$HOME"}" != "$cwd" ]; then
  display_dir="~${cwd#"$HOME"}"
fi

# ANSI colors (dim/subtle, Powerlevel10k-ish)
RESET=$'\033[0m'
DIM=$'\033[2m'
BLUE=$'\033[2;34m'
YELLOW=$'\033[2;33m'
MAGENTA=$'\033[2;35m'
CYAN=$'\033[2;36m'
PIPE="${DIM} | ${RESET}"

out="${BLUE}${display_dir}${RESET}"

if [ -n "$model" ]; then
  out="${out}${PIPE}${MAGENTA}${model}${RESET}"
fi

if [ -n "$ctx_pct" ] && [ "$ctx_pct" != "null" ]; then
  pct_int=$(printf '%.0f' "$ctx_pct" 2>/dev/null)
  [ -n "$pct_int" ] && out="${out}${PIPE}${CYAN}${pct_int}% ctx${RESET}"
fi

if [ -n "$cost" ] && [ "$cost" != "null" ]; then
  cost_fmt=$(printf '%.2f' "$cost" 2>/dev/null)
  [ -n "$cost_fmt" ] && out="${out}${PIPE}${YELLOW}\$${cost_fmt}${RESET}"
fi

printf '%s\n' "$out"
