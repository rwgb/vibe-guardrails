---
name: before-you-build
description: Make the AI predict its own top 5 failures BEFORE building anything big, then stop and wait for your answers. Load when the user is about to start a new app, a new feature, or anything touching money, logins, payments, or user data — or when they say "build me an app", "add a login", "add payments", "start a new project", "plan this", "how should we build this", "I want to make a website", "add a signup form", or "connect to Stripe/a database". Claude: when this plugin is installed and a request is big, run this routine proactively and halt.
---

# Before You Build: Make the AI Predict Its Own Failures

Before the AI builds anything big, make it list the top 5 ways it will probably
get it wrong — and then make it **stop and wait** for your answers.

Think of it like a contractor walking your house before renovating: five minutes
of "here's what could go wrong" saves weeks of tearing out bad work. This reduces
risk. It does not make your project bulletproof — nothing does.

## When to use this

Run the prediction before ANY of these:

| Situation | Examples |
|-----------|----------|
| A new app or project | "Build me a website", "make me an app" |
| A new feature | "Add a search page", "add a dashboard" |
| Anything touching money | Payments, subscriptions, Stripe, PayPal |
| Anything touching logins | Signup, passwords, "log in with Google" |
| Anything touching user data | Storing emails, profiles, files, messages |
| Anything you would cry about losing | Your database, your customer list, months of work |

Rule of thumb: if getting it wrong would cost you more than 30 minutes to
notice and undo, run the prediction first.

## The magic prompt (copy-paste this)

What it does: makes the AI confess its likely mistakes before writing any code.
What you should see: a 5-row table, then the AI stops and waits for you.

```
Before you write any code: list the top 5 ways you are likely to fail
at this task, as a table with three columns — the failure, why it would
happen, and one instruction from me that would prevent it. One of the
five rows must be about what AIs are genuinely bad at on THIS task
(for example: inventing functions or APIs that don't exist, or relying
on knowledge that is out of date). Then STOP. Do not plan or build
anything until I answer.
```

## Why this works

The AI always makes assumptions — which database, which login method, what
"done" means. Normally those assumptions stay hidden until they show up as
bugs. This prompt converts hidden assumptions into questions you can answer
in plain English, before any code exists. Fixing a wrong assumption in a
table takes one sentence. Fixing it after the app is built takes days.

Row about AI weaknesses matters most: AIs sometimes invent function names,
settings, or services that don't exist ("hallucinating"), and their knowledge
of tools has a cutoff date. That row tells you exactly what to double-check
against real documentation.

## How to answer the table

Go row by row:

| The row is... | You say... |
|---------------|-----------|
| Wrong ("I'm not using Stripe, I'm using PayPal") | Correct it in one sentence |
| Right (that assumption is fine) | "Row 2 is correct, keep it" |
| Something you don't understand | Ask: "Explain row 3 like I'm new to this" |

When every row is corrected or confirmed, say **"go ahead"**. The AI should
then start building immediately, with your corrections baked in — no re-asking.

If the AI starts building before you answered: stop it and paste the magic
prompt again. The STOP is the whole point.

## Instructions for Claude (read this if you ARE the AI)

When this plugin is installed and the user asks for something that matches
the "When to use this" table above:

1. Do NOT start planning or writing code.
2. Output exactly 5 rows in this table, filled in for THIS task:

> **Before I build this — here are the top 5 ways I'm likely to get it wrong:**
>
> | # | Likely failure | Why it would happen | Tell me this to prevent it |
> |---|----------------|---------------------|----------------------------|
> | 1 | Most likely misreading of what you asked for | ... | ... |
> | 2 | An assumption I'll make that you never stated | ... | ... |
> | 3 | Where I'll go vague or generic instead of specific | ... | ... |
> | 4 | What AIs are genuinely bad at here (invented APIs, out-of-date knowledge) — name the exact thing to verify | ... | "Check the official docs for: ..." |
> | 5 | Extra stuff I'll be tempted to add that you didn't ask for | ... | ... |
>
> **Correct anything wrong, confirm what's right, then say "go ahead."**

3. **HALT.** End the turn. Wait for the user. No "I'll get started meanwhile."
4. Row 4 must be honest and specific — never "AIs can make mistakes."
   Name the exact library, service, or fact at risk of being invented or stale.
5. When the user says "go ahead" (or similar), start immediately. Apply their
   corrections silently — no restating the table, no re-summarizing.

## Skip it for tiny changes

Do NOT run the prediction for:

- Changing text, colors, or wording
- Fixing one small bug
- Anything the user says is simple ("just do it, this is trivial")
- A change you could undo in under a minute

When in doubt: if the change touches money, logins, or data, predict first.

## When NOT to use this

This skill is only the before-you-start prediction. For other moments:

- Saving your work so you can undo mistakes → the **save-points** skill
- Keeping notes on what you built and why → the **project-memory** skill
- Checking whether something is actually finished → the **done-checklist** skill
- Passwords, API keys, and secret files → the **keep-secrets-secret** skill
