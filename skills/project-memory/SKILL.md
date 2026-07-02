---
name: project-memory
description: Give your AI a memory with one PROJECT_LOG.md file so every new chat picks up where the last one stopped. Load when the user says "why does Claude forget everything", "I keep re-explaining my project", "how do I continue where I left off", "start where we left off", "what were we working on", "wrap up", "we're done for today", "update the log", "set up a project log / devlog / notes file", or starts or ends a work session on a project.
---

# Project Memory: Notes for Your AI

## The problem: every new chat has amnesia

When you close a Claude Code chat and open a new one, the new chat knows
**nothing** about your project. It has not read your old conversations.
So without help:

- You re-explain your project from scratch, every single time.
- The AI re-suggests ideas you already tried and rejected last week.
- Bugs you both knew about get "discovered" again.
- Half-finished work gets forgotten or redone differently.

Think of each chat session as a new employee on day one. Smart, but zero
history. You would not make a new employee guess — you would hand them a
handover note. That note is this skill.

## The fix: one file, PROJECT_LOG.md

Create one file called `PROJECT_LOG.md` at the **project root** — the top
folder of your project, the one that holds everything else. It is a plain
text file written in Markdown (text with simple symbols like `#` for
headings — no special software needed).

Rules of the file:

| Rule | Why |
|------|-----|
| One file, always the same name | The AI (and you) always know where to look |
| Newest entry at the **top** | The most useful info is read first, no scrolling |
| One entry per work session | A session = one sit-down with Claude, start to close |
| Plain honest notes, not polish | This is a handover note, not a publication |

To create it, ask Claude in plain words:

> Create a PROJECT_LOG.md file at the project root using the template
> from the project-memory skill, and fill in today's entry.

## The entry template

Every entry uses the same four headings. If a heading has nothing under
it, write "None" — do not delete the heading. That way nothing gets
silently skipped.

```markdown
## 2026-07-02 — Short goal for this session

### What works now
- Login page works: users can sign up and log in.
- The app runs locally without errors.

### What we decided and why
- Used SQLite for the database because it needs no server setup.
- Rejected adding user avatars for now — too much work before launch.

### What is broken
- Password reset email never arrives. Not fixed yet.

### Next steps
- [ ] Fix the password reset email.
- [ ] Add a logout button.
```

What goes under each heading:

| Heading | What to write |
|---------|---------------|
| **What works now** | Features that actually work — tested, not just written |
| **What we decided and why** | Choices made, ideas rejected, and the reason. This stops the AI from re-arguing settled decisions |
| **What is broken** | Known bugs and half-done things, so nobody "rediscovers" them |
| **Next steps** | A short checkbox list: what to do next time |

The "why" in decisions is the most valuable part. "We use SQLite" is
okay. "We use SQLite because it needs no server" tells the next session
not to suggest switching to something fancier.

## The two-bookend habit

Two sentences, spoken to Claude, at the edges of every session. That is
the whole habit.

**Bookend 1 — session START.** Before asking for anything else, say:

> Read PROJECT_LOG.md first, then tell me where we left off.

You should see Claude summarize the last entry — what works, what is
broken, what is next. If its summary sounds wrong, correct it now, before
any work starts.

**Bookend 2 — session END.** Before you close the chat, say:

> Update PROJECT_LOG.md with what we did today before we stop.

You should see Claude add a new entry at the **top** of the file with all
four headings. Skim it for 30 seconds. If it claims something works that
you did not see working, fix that line — a wrong log is worse than no
log, because the next session will trust it.

**The golden rule: a session that does not update PROJECT_LOG.md is an
unfinished session**, no matter how much got built. The code shows *what*
exists; only the log records *why*, *what broke*, and *what is next*.

If you forget a bookend once, no disaster — just do it next time. This
habit reduces wasted time and repeated mistakes; it does not make your
project bug-free or secure. See the keep-secrets-secret skill for the
security side.

## Log vs README: who is each file for?

Your project may also have a `README.md` — the traditional front-door
file that explains a project to people. Keep the two jobs separate:

| Question | Goes in | Because |
|----------|---------|---------|
| What did we do last session? | PROJECT_LOG.md | The AI needs it; visitors do not |
| Why did we reject idea X? | PROJECT_LOG.md | Stops the AI re-suggesting it |
| What is currently broken? | PROJECT_LOG.md | Session-to-session handover info |
| What is this project? | README.md | First thing a human visitor reads |
| How do I install and run it? | README.md | Humans setting it up need steps |

Rule of thumb: **PROJECT_LOG.md is written for your AI's next session.
README.md is written for humans.** One home per fact — if the same info
lives in both, one copy will go stale and mislead someone.

Never put passwords, API keys, or other secrets in either file — the
keep-secrets-secret skill covers what counts as a secret and where
secrets live instead.

## Quick reference card

| Moment | Say to Claude |
|--------|---------------|
| First time setup | "Create PROJECT_LOG.md at the project root using the project-memory template" |
| Every session start | "Read PROJECT_LOG.md first, then tell me where we left off" |
| Every session end | "Update PROJECT_LOG.md before we stop" |
| Coming back after weeks | Same start line — that is the point of the log |

## When NOT to use this

- Saving the **code itself** so you can undo mistakes — that is the
  save-points skill (git basics). The log remembers *context*; save
  points protect *files*.
- Deciding whether a feature is actually **finished** — that is the
  done-checklist skill.
- Planning what could go wrong **before** you build — that is the
  before-you-build skill.
- Handling passwords and API keys — that is the keep-secrets-secret
  skill.
