#!/usr/bin/env bash
#
# guardrail.sh — a safety net for destructive shell commands.
#
# Claude Code runs this script BEFORE executing any Bash command
# (it is wired up as a "PreToolUse" hook in hooks/hooks.json).
#
# How the conversation between Claude Code and this script works:
#   1. Claude Code sends us a JSON blob on stdin that describes the
#      command it is about to run.
#   2. We pull out the command text and check it against a short list
#      of patterns that destroy work permanently.
#   3. If the command looks dangerous, we print a plain-language
#      warning to stderr and exit with code 2. Exit code 2 tells
#      Claude Code: "block this command and show the warning."
#   4. If the command looks fine (or we can't tell), we exit 0 and
#      the command runs normally. When in doubt, we let things
#      through — this is a guardrail, not a cage.

set -euo pipefail

# ---------------------------------------------------------------------------
# Step 1: read the hook JSON from stdin and extract the command text.
#
# The JSON looks roughly like:
#   {"tool_name": "Bash", "tool_input": {"command": "git status", ...}, ...}
#
# We use python3 to parse it because python3 ships with macOS and
# almost every Linux distro, and hand-parsing JSON in bash is fragile.
# ---------------------------------------------------------------------------

# If python3 is not installed, we cannot inspect the command.
# "Fail open": exit 0 so we never break someone's setup just because
# the guardrail can't do its job.
if ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

# Parse stdin as JSON and print just the command string.
# If anything goes wrong (bad JSON, missing field), print nothing.
command_text="$(python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get("tool_input", {}).get("command", ""))
except Exception:
    pass
' || true)"

# No command to inspect? Nothing to do.
if [ -z "$command_text" ]; then
  exit 0
fi

# ---------------------------------------------------------------------------
# Step 2: a tiny helper that prints a warning and blocks the command.
#
# Everything printed to stderr here is shown to the user, so the
# messages explain WHAT would be destroyed and WHAT to do instead.
# ---------------------------------------------------------------------------
block() {
  echo "BLOCKED by vibe-guardrails:" >&2
  echo "" >&2
  echo "$1" >&2
  exit 2
}

# ---------------------------------------------------------------------------
# Step 3: check the command against each destructive pattern.
#
# We use "grep -Eq" (extended regex, quiet) on the command text.
# The patterns are deliberately narrow so normal day-to-day work
# is never blocked.
# ---------------------------------------------------------------------------

# --- git push --force / git push -f ----------------------------------------
# Force-pushing OVERWRITES history on the remote. If a teammate (or a
# past you) pushed commits you don't have locally, they are gone.
# Note: we allow "--force-with-lease" — it refuses to overwrite work
# you haven't seen, which is exactly the safer alternative we suggest.
if echo "$command_text" | grep -Eq 'git[[:space:]]+push([[:space:]].*)?[[:space:]](-f|--force)([[:space:]]|$)'; then
  block "'git push --force' overwrites the history on the remote. Any commits
there that you don't have locally are destroyed for everyone.

STOP: do not retry with another force variant. Explain to the user, in
plain words, why a force push seemed necessary and get their explicit OK
first. Only if they approve, '--force-with-lease' is the safer form.
Better yet, avoid rewriting pushed history at all."
fi

# --- git reset --hard -------------------------------------------------------
# This throws away ALL uncommitted changes in your working directory.
# There is no undo for changes that were never committed.
if echo "$command_text" | grep -Eq 'git[[:space:]]+reset[[:space:]]+.*--hard'; then
  block "'git reset --hard' throws away every uncommitted change in your
working directory. Uncommitted work cannot be recovered.

Instead: commit or stash first ('git stash' saves your changes and can
be undone with 'git stash pop'), then restore files with the save-points
skill's rescue move ('git checkout <sha> -- .') — not 'reset --hard',
which this guardrail always blocks."
fi

# --- git clean -f (and -fd, -fdx, etc.) -------------------------------------
# This permanently deletes untracked files — files git has never seen,
# so git cannot bring them back. New files you forgot to add are gone.
if echo "$command_text" | grep -Eq 'git[[:space:]]+clean[[:space:]]+-[A-Za-z]*f'; then
  block "'git clean -f' permanently deletes untracked files. Git has never
seen these files, so it cannot restore them.

Instead: run 'git clean -n' first — it lists what WOULD be deleted
without deleting anything. Only clean once you've read that list."
fi

# --- git branch -D ----------------------------------------------------------
# Capital -D force-deletes a branch even if its commits were never
# merged anywhere. Those commits become very hard to find again.
if echo "$command_text" | grep -Eq 'git[[:space:]]+branch[[:space:]]+.*-D([[:space:]]|$)'; then
  block "'git branch -D' force-deletes a branch even if its work was never
merged. The commits on it become orphaned and hard to recover.

Instead: use lowercase 'git branch -d' — it refuses to delete a branch
whose work isn't merged yet, which is the safety check you want."
fi

# --- rm -rf on risky targets ------------------------------------------------
# "rm -rf" deletes files and folders recursively with NO confirmation
# and NO trash can. We block it when the target contains:
#   /  — a path (could be anywhere on your machine, including system dirs)
#   ~  — your home directory
#   *  — a wildcard (can match far more than you intended)
#   . or .. as the whole target — the current/parent directory
#
# We deliberately do NOT block simple targets like "rm -rf node_modules"
# — deleting a single folder by name in the current directory is a
# normal, everyday operation.
if echo "$command_text" | grep -Eq '(^|[[:space:]])rm[[:space:]]+(-[A-Za-z]*r[A-Za-z]*f[A-Za-z]*|-[A-Za-z]*f[A-Za-z]*r[A-Za-z]*)[[:space:]]'; then
  # It is an rm -rf. Now look at what it is pointed at — only the
  # arguments of the rm command itself, stopping at command separators
  # (;, &, |), so 'rm -rf node_modules && ls src/' stays allowed.
  if echo "$command_text" | grep -Eq 'rm[[:space:]]+-[A-Za-z]+[[:space:]]+[^;&|]*(/|~|\*)' \
     || echo "$command_text" | grep -Eq 'rm[[:space:]]+-[A-Za-z]+[[:space:]]+\.\.?([[:space:]]|$)'; then
    block "'rm -rf' on a path, wildcard, or home-directory target deletes
files recursively with no confirmation and no trash can. One typo can
wipe a project — or your whole home directory.

Instead: 'ls' the exact target first to confirm what's there, then
delete the specific folder by name (e.g. 'rm -rf build') from inside
the directory that contains it."
  fi
fi

# ---------------------------------------------------------------------------
# Step 4: nothing matched — the command is fine. Let it run.
# ---------------------------------------------------------------------------
exit 0
