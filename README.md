# vibe-guardrails

A Claude Code plugin that adds basic engineering guardrails to AI-assisted coding. If you build things with Claude Code but don't have a software engineering background, this plugin gives you the handful of habits that keep projects recoverable: save points you can roll back to, a project memory that survives between sessions, a moment of failure-thinking before you build, a clear definition of "done", and protection against committing secrets or running commands that destroy work.

## Who it's for

People who ship real projects with AI assistance but haven't spent years learning engineering discipline the hard way. You know enough to be productive; this plugin covers the parts that usually only bite you after something goes wrong. Experienced engineers won't find anything new here — that's fine, it isn't for them.

## What you get

Five skills plus one safety hook:

| Skill | What it does |
|---|---|
| `save-points` | Teaches you to create git save points before risky changes, so you can always roll back. |
| `project-memory` | Keeps a PROJECT_LOG.md so each new session starts with context instead of amnesia. |
| `before-you-build` | A short "what could go wrong?" pass before building anything non-trivial. |
| `done-checklist` | A concrete definition of done, so "it works on my machine" isn't the finish line. |
| `keep-secrets-secret` | Checks for API keys and credentials before they end up in your code or git history. |

**The guardrail hook** watches every shell command Claude Code is about to run and blocks a short list of commands that destroy work permanently (force pushes, hard resets, recursive deletes on risky paths, and similar). When it blocks something, it explains what the command would have destroyed and what to do instead.

## Install

In Claude Code, run these two commands:

```
/plugin marketplace add rwgb/vibe-guardrails
/plugin install vibe-guardrails@vibe-guardrails
```

Then **restart Claude Code** so the hook and skills load.

During install you'll see a **trust prompt** — Claude Code asking whether you trust this plugin before it runs anything. That's expected: plugins can run scripts on your machine (this one runs a small shell script before each command), so Claude Code makes you opt in explicitly. Read the prompt, and only accept if you're comfortable. The whole plugin is plain text in this repository, so you can read every line before deciding.

## Quick start

In an existing project, do these three things first:

1. **Initialize save points.** Ask Claude: "set up save points for this project" (the `save-points` skill will make sure git is initialized and create your first save point).
2. **Create your project memory.** Ask Claude: "create a PROJECT_LOG.md for this project" (the `project-memory` skill will capture what the project is and where it stands).
3. **Run the secrets check.** Ask Claude: "check this project for secrets" (the `keep-secrets-secret` skill will scan for API keys and credentials that shouldn't be in the code).

After that, the skills fire on their own when they're relevant.

## What this does NOT do

Being honest about the limits:

- **It is not a security audit.** The secrets check catches common patterns (API keys, tokens, passwords in code), not everything. Don't treat a clean pass as proof your project is secure.
- **It is not a replacement for learning.** The skills explain *why* each habit matters, but they're guardrails, not an engineering education. If your projects grow, invest in learning the fundamentals.
- **The hook is best-effort.** It blocks a specific list of known-destructive commands. Commands it doesn't recognize pass through, and it deliberately fails open (allows the command) if it can't inspect it — a guardrail that breaks your setup would be worse than none. It reduces the odds of a catastrophic mistake; it does not eliminate them. Save points are your real safety net.

## Roadmap

Candidates for v0.2 — staged, not promised:

- Code-style basics (naming, structure, when to split files)
- Multi-agent review recipes (having a second agent review the first one's work)
- Deploy safety (checks before pushing anything to production)

## License

MIT — see [LICENSE](LICENSE).
