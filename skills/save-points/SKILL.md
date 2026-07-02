---
name: save-points
description: Git basics for total beginners, framed as save points for your project. Load when the user has no git set up, asks "what is git", "how do I save my progress", "how do I undo what the AI just did", "the AI broke my app, can I go back?", "how do I back up my project", "what is a commit / branch / repo", "put this on GitHub", or before letting AI make big changes to a project with no version control. Also load when the user wants to restore an older version of their code.
---

# Save Points for Your Project (git, explained from zero)

Git is a free tool that takes snapshots of your project. Each snapshot is called
a **commit** — think of it as a save point in a video game. If anything breaks,
you reload the last save. That's the whole idea.

**Why you need this BEFORE letting AI touch your code:** the single most common
disaster in AI-assisted coding is this — the app works, you ask the AI for "one
small change", the AI rewrites five files, and now nothing works and there is no
way back. With save points, "no way back" never happens. Without them, one bad
edit can erase days of work.

This reduces your risk a lot. It does not make you invincible — you still have
to actually make the save points.

## One-time setup (do this once per computer, then once per project)

Tell git who you are (once per computer). Any name and email work; they're just
labels on your save points.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
You should see: nothing. Silence means it worked.

Turn on save points for a project (once per project). Run this **inside your
project folder** — the folder with your code in it.

```bash
git init
```
You should see: `Initialized empty Git repository in ...`
This creates a hidden `.git` folder where all snapshots live. Don't delete it.

Windows note: these commands are the same. Use "Git Bash" or PowerShell after
installing git from git-scm.com. On macOS, running `git` the first time may
prompt you to install developer tools — say yes.

**Before your first save point:** if your project has a `.env` file (or any
file holding passwords or API keys), run `echo '.env' >> .gitignore` FIRST —
see the **keep-secrets-secret** skill. Otherwise your secrets get baked into
every save point forever, and pushing to GitHub publishes them.

## The core loop (the habit that saves you)

Every time your app is in a **working state** — it runs, the new thing works —
make a save point. Working state, save. Working state, save.

This stages every change and snapshots it with a label describing what changed:

```bash
git add -A && git commit -m "what changed, in plain words"
```
You should see: a line like `[main abc1234] what changed...` and a file count.

Good labels: `"login page works"`, `"before asking AI to redo the header"`.
Bad labels: `"stuff"`, `"asdf"` — future-you won't know which save to load.

**Rule of thumb:** save before every AI request, and after every success.

## See your save points

Lists your save points, newest first, one per line:

```bash
git log --oneline
```
You should see: lines like `abc1234 login page works`. That 7-character code
is the save point's ID (called a "sha"). You'll use it to go back.

## The three rescue moves

| Situation | Move |
|---|---|
| "What did the AI just change?" | `git diff` |
| "Undo everything since my last save" | `git checkout -- .` |
| "Load an older save point" | `git checkout <sha> -- .` then commit |

**1. See what changed (safe, changes nothing):**

```bash
git diff
```
You should see: removed lines with `-`, added lines with `+`. Press `q` to exit.
If you see nothing, nothing has changed since your last save.

**2. Undo uncommitted changes — throw away everything since the last save:**

```bash
git checkout -- .
```
You should see: nothing. Files git has saved before are now back to the last
save point.

**Honest limit:** this restores files git has saved before. Brand-new files
created since your last save point are NOT removed — run `git status` and
you'll see them listed under "Untracked files"; delete any you don't want by
name. If the app still misbehaves after restoring, leftover new files are the
first thing to check (ask the AI to list and remove them).

**Honest danger warning:** this permanently deletes all changes made since your
last commit — yours and the AI's. There is no undo for this undo. Run `git diff`
first and make sure nothing in there is worth keeping.

**3. Go back to an older save point** — first find its ID with
`git log --oneline`, then:

```bash
git checkout abc1234 -- .
```
(Replace `abc1234` with your save point's ID.) You should see: nothing, but
files git had saved at that point are now restored to that older version.

**Honest danger warning:** just like move 2, this overwrites any uncommitted
changes with no undo. Run `git diff` first — or make a save point — before
restoring, so nothing worth keeping is lost.

**Honest limit:** files created AFTER that save point are NOT removed — they
stay on disk. Run `git status` to see them under "Untracked files" and delete
any you don't want by name (or ask the AI to list and remove leftover new
files) if the app still misbehaves after restoring.

Then lock it in as a new save point:

```bash
git add -A && git commit -m "restored to the version where login worked"
```

This is the one recommended path. It never deletes history — your newer saves
still exist, so you can change your mind. Ignore advice online telling you to
use `git reset --hard` for this; see the danger list below.

## Branches: parallel save files (one paragraph, optional)

A **branch** is a parallel save file. `git checkout -b try-something` copies
your current state into a new line of saves named `try-something`; commit there
as much as you like. If the experiment works, keep going. If it flops, switch
back to your original save file with `git checkout main` and everything is as
you left it. You don't need branches to be safe — the core loop above is enough.

## Offsite backup: push to GitHub

Save points live on your computer. If the laptop dies, they die too. GitHub
stores a copy online, free and private.

Requires the GitHub command-line tool `gh` (install from cli.github.com), and
you must log in once with `gh auth login` (it walks you through it).

Creates a private online copy of your project and uploads all save points:

```bash
gh repo create --private --source=. --push
```
You should see: a URL like `https://github.com/yourname/yourproject`.

After that, upload new save points anytime with `git push`.
You should see: a few lines ending in something like `main -> main`.

## Never run these (until you truly understand them)

| Command | Why it's dangerous |
|---|---|
| `git push --force` | Overwrites the online backup with your local state — can destroy work permanently |
| `git reset --hard` | Deletes changes and can move you off save points with no confirmation |
| `rm -rf <anything>` | Deletes files and folders instantly, skipping the trash |

This plugin's guardrail hook will warn you if you (or the AI) try one of these.
A warning is a moment to stop and ask, not an obstacle to click through.

## Copy-paste checklist

- [ ] Once ever: `git config` name + email
- [ ] Once per project: `git init`
- [ ] If the project has a `.env` or any secrets file: `echo '.env' >> .gitignore` BEFORE the first save (see keep-secrets-secret)
- [ ] Before every AI request AND after every working change: `git add -A && git commit -m "..."`
- [ ] Before uploading: confirm no secrets are in your save points (keep-secrets-secret skill's pre-publish check)
- [ ] Once per project: `gh repo create --private --source=. --push`
- [ ] Then occasionally: `git push`

## When NOT to use this

- Writing down decisions, progress, and context between sessions → the **project-memory** skill
- Predicting what could go wrong before building something → the **before-you-build** skill
- Deciding whether a feature is actually finished → the **done-checklist** skill
- API keys, passwords, or `.env` files (never commit those!) → the **keep-secrets-secret** skill
