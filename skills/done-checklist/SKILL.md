---
name: done-checklist
description: "The minimum definition of done for AI-built software — run BEFORE the user calls anything finished, ships it, shares a link, or publishes. Load when the user says things like: 'is it done?', 'I think it's finished', 'it works!', 'can I publish this?', 'ready to share?', 'how do I know it's done?', 'the AI says it works', 'ship it', 'I'm done, right?', or asks what to check before showing their app to other people."
---

# The Done Checklist

"It works on my screen" is not done. "The AI said it works" is definitely not done.

Done means you personally verified six things. Not the AI — you. This checklist
catches the most common disasters (app won't start for anyone else, crashes on
normal input, leaked passwords, lost work, forgotten context, obvious security
holes). It does not catch everything, and finishing it does not make your app
"secure." It makes it *much less likely to embarrass or hurt you*. That's the
honest claim.

Run all six checks, in order, every time you finish a feature or an app.

| # | Check | Pass means |
|---|-------|------------|
| 1 | It runs from scratch | You restarted it and clicked through it yourself |
| 2 | Weird input doesn't break it | Empty, huge, quoted, and negative inputs handled |
| 3 | No secrets in the code | No passwords or API keys typed into your files |
| 4 | A save point exists | You committed your work (see the save-points skill) |
| 5 | PROJECT_LOG.md updated | Future-you knows what happened this session |
| 6 | (If public) Security review session | A fresh AI session reviewed it and you fixed the findings |

---

## Check 1 — It actually runs from scratch

**Why:** The AI often says "it works" based on reading its own code, not running
it. And an app that's been running on your machine for hours can have broken
startup code you'd never notice — until someone else (or future-you) tries to
start it cold. Restarting is the only proof.

**Horror story:** "It worked all week — then I rebooted my laptop and the app never started again."

Stop the app completely first. In the terminal window where it's running, press
`Ctrl+C` (that means: hold the Control key and press C — same on Mac, Linux,
and Windows). You should see the app stop and your normal prompt come back.

Then start it fresh with whatever command you normally use (ask the AI "what
command starts this app?" if you're not sure). You should see it start without
red error text.

Now click through the main flow yourself, in the actual app: open it, do the
main thing it exists to do, see the result. If any step fails, it is not done.

## Check 2 — The weird-input test

**Why:** Real people type things you didn't expect. Software that only works on
"nice" input crashes on day one. This five-minute test finds the most common
crashes before your users do — including one class of security hole (quote
characters breaking your app can mean attackers can do far worse).

**Horror story:** "My signup form worked great until someone named O'Brien tried to register."

In every form field and input box in your app, try each of these and confirm
the app either handles it or shows a polite error — never a crash or a blank
screen:

| Try this | Example |
|----------|---------|
| Nothing — submit the form empty | (leave every field blank, click submit) |
| Huge text | Paste a few thousand characters into a text field |
| Quote characters | `O'Brien` and `She said "hi" & left <fast>` |
| Negative and zero numbers | `-1`, `0`, `-999999` in any number field |

If anything crashes, tell the AI exactly what you typed and what happened, and
have it fix each one. Then re-run this check.

## Check 3 — No secrets in the code

**Why:** A secret (a password, or an API key — a long code that lets programs
use a paid service on your account) typed directly into your code files gets
copied everywhere your code goes. If the code ever becomes public, bots find
the key within minutes and run up bills on your account.

**Horror story:** "I published my project and woke up to a $3,000 cloud bill from a leaked key."

This command searches your project files for common secret patterns. Run it in
your project folder (macOS and Linux; on Windows, ask the AI for the
equivalent, or run it in Git Bash):

```
grep -rn -i -E "api[_-]?key|secret|password|token" --include="*.js" --include="*.ts" --include="*.py" --include="*.html" --include="*.json" . | grep -v node_modules
```

You should see either nothing, or only harmless lines (like a form field named
"password"). If you see an actual key or password value in a code file, stop —
open the keep-secrets-secret skill and follow it to move the secret out and
replace the leaked key.

## Check 4 — A save point exists

**Why:** A save point (a "commit" in git — think of it as a saved game you can
reload) is the only way back if the next AI session mangles your working code.
Working code that isn't committed is one bad prompt away from gone.

**Horror story:** "I asked the AI for one small tweak and it rewrote half the app. I had no saved copy of the working version."

Follow the save-points skill to commit. Quick verification that a recent save
point exists — this shows your latest saved snapshot:

```
git log -1 --oneline
```

You should see one line with a short code and a description. If it describes
work from *before* today's changes, you haven't saved yet — go make a commit.

## Check 5 — PROJECT_LOG.md updated

**Why:** The AI forgets everything between sessions, and so will you in two
weeks. A short note now — what you built, what's broken, what's next — is what
makes the next session start in minutes instead of an hour of re-explaining.

**Horror story:** "I came back after a month and couldn't remember why half the features existed or which ones actually worked."

Follow the project-memory skill for the format. Minimum bar: today's date, what
got done, what's still broken or unfinished.

## Check 6 — If it will be public: one security review session

**Why:** Everything above catches accidents. Making an app public invites
people who break things on purpose, and AI-generated code routinely contains
well-known security holes the AI won't mention unless asked. One dedicated
review session is cheap insurance — not a guarantee.

**Horror story:** "Someone found the admin page had no login check. They deleted every user's data through a URL."

Start a *fresh* AI session (fresh so it reads the code cold, instead of
defending what it just wrote) and ask:

```
Review this app for security problems before I publish it. Assume attackers
will use it. List each problem, how bad it is, and how to fix it.
```

Then fix what it finds — or ask it to — and re-run checks 1 and 2 afterward,
because security fixes can break working features. Repeat until a review comes
back with nothing serious. This reduces risk; it does not make the app secure.
If your app handles payments, health data, or other people's private
information, get a human professional to look at it too.

---

## After all six pass

Now you can say "done" — for this version. Every future change restarts the
clock: new feature, new run through the checklist. It gets fast with practice
(checks 1–5 take about ten minutes once you've done them twice).

## When NOT to use this skill

- Setting up commits and save points themselves → the save-points skill
- Writing or formatting PROJECT_LOG.md → the project-memory skill
- A secret already leaked, or moving secrets out of code → the keep-secrets-secret skill
- Planning what could go wrong *before* you build → the before-you-build skill
- Mid-build experiments you haven't finished — this checklist is for "I think it's done," not for every prompt.
