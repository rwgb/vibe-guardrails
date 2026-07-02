---
name: keep-secrets-secret
description: Credential safety for beginners — API keys, passwords, tokens, and .env files. Load when the user asks "where do I put my API key", "is it safe to put my key in the code", "check this project for exposed secrets", "I think I leaked my key", "what is a .env file", "why did I get a surprise bill", "how do I hide my password", or before publishing any project to GitHub or the internet.
---

# Keep Secrets Secret

The single most expensive mistake in beginner coding: pasting an API key into your code and publishing it. This skill prevents that. It reduces your risk — it does not make you "secure." Nothing does. But it stops the most common disaster.

## What counts as a secret?

A **secret** is any string of text that lets someone *be you* or *spend your money*. If a stranger having it would be bad, it's a secret.

| Type | What it looks like | What a thief can do with it |
|------|--------------------|------------------------------|
| API key | `sk-abc123...`, long random string | Spend money on your account (OpenAI, Anthropic, AWS, Stripe...) |
| Password | anything you'd type in a login box | Log in as you |
| Token | long random string, often starts with `ghp_`, `xoxb_`, etc. | Act as you on GitHub, Slack, etc. |
| Database URL | `postgres://user:PASSWORD@host/db` | Read, change, or delete all your app's data |

## The horror story (it's real, and it's fast)

1. You paste your API key into your code so it "just works."
2. You publish the project to GitHub (public by default).
3. **Bots scan every new public upload, around the clock.** They find keys in minutes — sometimes seconds.
4. The bot uses your key. You wake up to a bill for hundreds or thousands of dollars, or your account is banned.

This is not rare. It happens to beginners every day. The fix is one habit:

## The rule

**Secrets live in a `.env` file. Never in code files. Ever.**

A `.env` file (say "dot-env") is a plain text file that sits in your project folder and holds your secrets — like a locked drawer next to your desk instead of a sticky note on your monitor. Your code reads from the drawer. The drawer never gets published.

## Setup (do this once per project)

**Step 1 — create the `.env` file.** First check whether one already exists: run `ls -a` and look for `.env` in the list. If it's there, open it in your editor and add your key as a new line — do NOT run the command below, because the single `>` REPLACES the whole file and would silently wipe any secrets already in it (with no undo — `.env` is never saved by git, so save points can't bring it back).

If no `.env` exists yet, this command creates it with one example secret (replace with your real key):

```bash
echo 'MY_API_KEY=paste-your-real-key-here' > .env
```

You should see: nothing printed — that means it worked. A file named `.env` now exists. (To add MORE keys later, use `>>` — two arrows APPEND a line instead of replacing the file — or just edit the file.)

**Step 2 — tell git to never publish it.** Git is the tool that saves and publishes your code (the save-points skill explains it). A file named `.gitignore` is git's "do not pack this" list — anything listed in it never gets saved or published. This command adds `.env` to that list:

```bash
echo '.env' >> .gitignore
```

You should see: nothing printed. **Do this BEFORE your next save.** If `.env` gets saved even once, it's in your history forever (see "If a key already leaked" below).

**Step 3 — make a shareable example.** Other people (and future you) need to know *which* secrets the project needs, without seeing the real values. This creates a copy with placeholders:

```bash
echo 'MY_API_KEY=your-key-goes-here' > .env.example
```

You should see: nothing printed. `.env.example` contains no real secrets, so it's safe to publish.

## How your code reads secrets

Your code reads secrets from "environment variables" — named values the `.env` file provides, like labeled slots the program checks at startup.

**JavaScript / Node** — first install the helper (`npm install dotenv`, you should see it added to your project), then:

```js
require('dotenv').config();
const key = process.env.MY_API_KEY;
```

**Python** — first install the helper (`pip install python-dotenv`), then:

```python
from dotenv import load_dotenv
import os

load_dotenv()
key = os.environ["MY_API_KEY"]
```

In both: the name after the `=` sign in `.env` (`MY_API_KEY`) is the name your code asks for. No quotes needed in the `.env` file itself.

## Pre-publish check (run before EVERY publish)

This searches your project for key-shaped words — including brand-new files git isn't tracking yet — skipping documentation files:

```bash
git grep --untracked -iE "api[_-]?key|secret|token" -- . ':!*.md'
```

**How to read the results.** Each line is `filename:the line it found`. Judge each one:

| Result | Verdict |
|--------|---------|
| No output at all | Good — nothing found, you're clear |
| A hit in a code file with a **real value** (`API_KEY = "sk-abc..."`) | **STOP. Fix before publishing.** Move it to `.env` |
| A hit that reads from the environment (`process.env.MY_API_KEY`) | Fine — that's the correct pattern |
| A hit in a **brand-new code file** you haven't saved yet | **STOP. Fix before saving or publishing.** Move it to `.env` — new files leak just as fast once committed |
| Any hit in a file named `.env` | **Check `.gitignore`.** If `.env` is properly listed in `.gitignore`, this search skips it entirely — so a hit means git can see it. If it's tracked, run `git rm --cached .env`; either way, add `.env` to `.gitignore` now |
| A hit in `.env.example` with placeholder text | Fine |

(Windows note: run this in Git Bash — installed with git — not the old Command Prompt.)

Also make a habit of asking your AI assistant: **"Check this project for exposed secrets before I publish."** Do it regularly, not just once.

## If a key already leaked

Honest truth: **deleting the file or the commit does NOT unpublish it.** Git keeps history (every save point is kept forever), GitHub caches old versions, and bots copied it the moment it went up. Removing it from your code is cleanup, not rescue.

Do these in order:

1. **Revoke or rotate the key AT THE PROVIDER, immediately.** Log in to the website that issued it (OpenAI, GitHub, AWS, Stripe...), find the API keys page, and delete or regenerate the key. This is the ONLY step that actually stops a thief. Do it within minutes, not hours.
2. **Check the provider's billing/usage page** for charges you didn't make. Contact their support if you see any — many providers forgive first-time leak charges if you ask.
3. **Put the new key in `.env`**, confirm `.env` is in `.gitignore`, and remove the old key from your code.
4. Run the pre-publish check above before publishing again.

## Quick checklist

- [ ] Every secret is in `.env`, none in code files
- [ ] `.gitignore` contains a line that says `.env`
- [ ] `.env.example` exists with placeholder values only
- [ ] Pre-publish grep run, results reviewed
- [ ] If anything ever leaked: revoked at the provider, not just deleted

## When NOT to use this

This skill is about *credentials*. If your question is about saving or undoing code changes, use the **save-points** skill. If you're deciding whether the project is finished and ready to ship, use the **done-checklist** skill (which includes a secrets check as one of its gates).
