---
name: jira-blind-fix-benchmark
description: Benchmark the coding agent against a human fix. Given a Jira ticket ID (e.g. HRSS-2477) that has a linked, already-merged GitLab MR, reconstruct the pre-fix state, have a blind subagent fix the bug from the ticket alone, review it, then score the blind fix against the real human fix (% similarity + what each side missed). Use when the user asks to "benchmark", "test how good you are", or "blind fix" a ticket, or invokes /jira-blind-fix-benchmark <TICKET-ID>.
---

# Jira Blind-Fix Benchmark

Measure how close the agent's from-scratch fix comes to the human fix that already shipped — without the agent ever seeing that fix.

**Input:** a Jira ticket ID (e.g. `HRSS-2477`). The ticket must have a linked GitLab MR that is already merged.

**Output:** a terminal markdown report — a similarity percentage, what the agent missed vs. the human, and what the human missed vs. the agent.

## Configuration (defaults chosen by the user)

- **Jira source:** Atlassian MCP (Rovo) — `mcp__claude_ai_Atlassian_Rovo__*`.
- **Review step:** one independent reviewer subagent.
- **Output:** terminal report only (no saved file/artifact).

## Preconditions — verify before starting

Run these and fix any gap before proceeding:

1. `glab auth status` → must be logged in to the GitLab host.
2. Atlassian MCP connected. If `mcp__claude_ai_Atlassian_Rovo__getAccessibleAtlassianResources` isn't available, its schema is deferred — load with
   `ToolSearch: select:mcp__claude_ai_Atlassian_Rovo__getJiraIssue,mcp__claude_ai_Atlassian_Rovo__getAccessibleAtlassianResources`.
   If the connector isn't enabled at all, ask the user to enable it via `/mcp` (it's per-session), or fall back to pasted ticket text.
3. Working tree is clean-ish (the experiment uses a separate worktree, so the main tree is untouched, but confirm you're in the target git repo).

## Procedure

### 1. Fetch the ticket (Atlassian MCP)

- `getAccessibleAtlassianResources` → grab the `cloudId` (e.g. cegekamon = `1b1f4743-1895-42db-9fa4-00378c7cac6e`).
- `getJiraIssue` with `issueIdOrKey=<TICKET>`, `fields=["summary","description","status","issuetype","priority","labels","components","comment"]`, `responseContentFormat="markdown"`.
- Extract: summary, description (repro steps, current vs expected result), and note whether the description contains **technical hints** about the cause. Keep the ticket text — the fixer gets ONLY this.

### 2. Find the linked MR (glab)

- `glab mr list --search "<TICKET>" --all` (this repo's branches use `*-<TICKET>-*`). Note the MR number and branch.
- `glab mr view <NUM>` for context (MR description is often just the template — don't rely on it).
- Get the fix commit(s): `glab api "projects/<url-encoded-path>/merge_requests/<NUM>/commits"` → the fix commit SHA (`FIX`).
  - URL-encode the project path, e.g. `horizon_incubator%2Fccp%2Fmicroservices%2Ferp-service`.

### 3. Capture the human fix (keep it away from the fixer)

- `PARENT=$(git rev-parse FIX^)` — the pre-fix state.
- `git show FIX` — the authoritative human diff (source + tests). Save it for the comparison.
- **Gotcha:** `glab mr diff` can render a merged/squashed view. Trust `git show <FIX>` for exact per-file changes.

### 4. Reconstruct the pre-fix world in an isolated worktree

```
WT="$CLAUDE_scratch_or_tmp/<ticket>-wt"          # a path outside the repo working tree
git worktree add "$WT" <PARENT> -b experiment/<ticket>-blind
git -C "$WT" merge-base --is-ancestor <FIX> HEAD && echo REACHABLE-BAD || echo blind-ok
```

The `merge-base --is-ancestor` check MUST print blind-ok — it proves the fix commit is not reachable from the fixer's HEAD.

### 5. Spawn the FIXER subagent (blind)

`Agent`, `subagent_type: general-purpose`, `run_in_background: false`. Prompt must include:
- The worktree path, with "work EXCLUSIVELY inside this directory".
- The **ticket text only** (summary + description + repro + current/expected). No MR, no commit, no hints.
- Hard rules: do NOT `git log`/`git show`/`git checkout` other refs or branches, do NOT grep git history or the web for the ticket ID, solve from the code. May read/grep source & tests, run tests, make the minimal root-cause fix, add/adjust tests to repo conventions, do NOT commit.
- Deliverable: root cause (file:line), the exact `git diff`, tests added + result, confidence/assumptions.

### 6. Capture the fixer's diff

`git -C "$WT" status --short` and `git -C "$WT" diff` (plus contents of any untracked new test files).

### 7. Spawn the REVIEWER subagent (single, independent)

`Agent`, `subagent_type: general-purpose`, `run_in_background: false`. Prompt:
- The worktree path + the ticket context.
- "Review the uncommitted working-tree change on its own merits. Do NOT look for a pre-existing fix in history/branches."
- Assess: correctness/root-cause, data-shape assumptions (cite corroborating code), edge cases (incl. any secondary symptom the ticket mentions), test quality/gaps, regressions.
- Deliverable: APPROVE / APPROVE-WITH-NITS / REQUEST-CHANGES + findings with severity + one-line root-cause verdict.

### 8. Compare blind fix vs. human fix → score

Diff the two changes file-by-file (source first, then tests). For each:
- **Same root cause?** Same file/function/line?
- **Functional equivalence** of the code change (ignore formatting; note structural differences like try/except placement and their behavioral edge, e.g. fail-open vs fail-closed on malformed data).
- **Test overlap:** did both create/modify the same test files? Compare test names & covered branches. Note who covered more (exception paths, None handling, secondary symptoms).

**Critical verification rules (learned the hard way):**
- Before claiming a test "would break" under either fix, check whether that test **mocks out the function under change** (e.g. `@mock.patch(...validate_task_claiming)`). If the function is stubbed, mock-data shape is irrelevant — a subagent may confidently misreport this.
- Check whether a "new" test file actually existed at `PARENT` (`git cat-file -e <PARENT>:<path>`). Both human and agent may independently create the same file.
- Verify a claimed secondary-symptom gap by reading the real call site, not the ticket wording alone.

Compute a **similarity percentage** weighted mostly on the source fix (root cause + functional equivalence), with tests and scope as secondary. State the number plainly.

### 9. Report (terminal)

Markdown, in this shape:
- **Overall similarity: ~NN%** + one-line justification.
- **Source fix** table: human vs blind on root cause, key transforms, structural diffs, edge behavior.
- **Tests:** overlap + who covered what.
- **What the agent missed / got wrong** (vs human).
- **What the human missed** (vs agent / surfaced by the reviewer).
- **Bottom line.**

Be honest and symmetric — credit the human's cleaner choices AND the agent's catches. Don't inflate the score.

### 10. Clean up

```
git worktree remove "$WT" --force
git branch -D experiment/<ticket>-blind
git worktree list   # confirm gone
```

## Notes

- Keep the fixer and reviewer in separate `Agent` calls, run synchronously (`run_in_background: false`) since each step depends on the previous.
- If the ticket has no linked merged MR, stop and tell the user — there's nothing to benchmark against.
- If tests can't run in-env (missing private deps), say so; fall back to reading the code paths to reason about pass/fail rather than asserting.
