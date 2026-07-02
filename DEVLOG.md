# DEVLOG — vibe-guardrails

## 2026-07-02 (II) — install verified, launch post drafted, v0.2 ordered

### Completed
- Maintainer installed the plugin from GitHub (marketplace registered in user settings) —
  skills confirmed loading; guardrail-hook live-fire test script provided, results pending
- Reddit launch post drafted, rewritten to r/vibecoding rule-3 format (build-process as
  the educational spine); final draft saved at drafts/reddit-launch-post.md (gitignored,
  local only — do not commit before posting)
- Memory-tools section added to the post (Spiderbrain, Mem0/OpenMemory, Letta,
  claude-mem), each verified against docs 2026-07-02; none driven end-to-end (stated)
- Scrubbed maintainer's first name from this public DEVLOG (Reddit persona separation)

### Decisions
- v0.2 ordering: `test-your-app` → `ci-basics` ahead of code-style basics (tests before
  CI — a green check with no tests manufactures false confidence)
- Memory-tool capability NOT built into the plugin: dependency ethos (nothing to
  install), BUSL license can't bundle, and prose pointer gets 90% of value. Instead:
  a "leveling up" paragraph in project-memory, v0.2, after user feedback
- Roadmap freeze holds: no building until 2–3 real users report back

### Issues Found
- None new

### Next Session
- [ ] Post the launch article (r/ClaudeAI or r/ClaudeCode first, then r/vibecoding);
      collect thread links
- [ ] Guardrail live-fire results from maintainer's scratch project (block reset --hard,
      NOT block rm -rf node_modules)
- [ ] Triage feedback into v0.2 per the ordering above

### Learnings
- Subreddit rule-3 ("no shilling") rewrites make better posts: leading with the build
  process instead of the project is both compliant and more transferable

---

## 2026-07-02 — v0.1.0: initial plugin build

### Completed
- Authored the full v0.1 plugin via multi-agent workflow (`wf_a5a10afe-e1c`, 10 agents,
  0 errors): 5 skills (save-points, project-memory, before-you-build, done-checklist,
  keep-secrets-secret), PreToolUse guardrail hook + script, plugin.json,
  marketplace.json (self-hosting marketplace, source "./"), README, MIT LICENSE
- 3-reviewer pass (factual — executed every command and fired synthetic hook JSON at the
  guardrail; beginner-usability; safety-doctrine): 0 blocking, 11 important, 13 minor.
  All 11 important fixed and re-verified
- `claude plugin validate .` passes clean

### Decisions
- One repo = plugin AND its own marketplace (verified against official plugin docs
  2026-07-02); install UX: `/plugin marketplace add rwgb/vibe-guardrails` →
  `/plugin install vibe-guardrails@vibe-guardrails`
- Audience: true beginners + copy-paste vibe coders; every command carries "what it does"
  and "what you should see"; save-point metaphor for git
- Rescue path: ONE recommended restore (`git checkout <sha> -- .` then commit); revert and
  reset --hard deliberately not taught
- Guardrail hook fails OPEN if python3 is missing (usability over completeness for
  beginners); block messages route through the human, never hand the AI a bypass
- v0.1 scope capped per failure-forecast row 5; v0.2 candidates staged in README roadmap
- Key fixes from review: quoted `${CLAUDE_PLUGIN_ROOT}` (spaces in paths), rm -rf regex
  scoped to the rm command's own args, `git grep --untracked` for the secrets scan,
  `.gitignore`-before-first-commit warning, honest untracked-files limit on `git checkout -- .`

### Issues Found
- 13 minor review findings deferred (journal: wf_a5a10afe-e1c) — polish, not correctness
- Install flow not yet tested end-to-end from GitHub (maintainer to manually test on a fresh
  project per failure-forecast row 4)

### Next Session
- [ ] Maintainer: manual install test on a fresh/scratch project; confirm skills load and the
      guardrail hook fires
- [ ] Share with 2–3 real vibe coders (Reddit) for feedback before ANY expansion
- [ ] Triage the 13 minor findings
- [ ] v0.2 candidates (only after user feedback): code-style basics, multi-agent review
      recipe, deploy safety

### Learnings
- The factual reviewer executing the guardrail with synthetic hook JSON caught an
  over-blocking regex and an unquoted path that a read-only review would have missed —
  execute-verify beats read-verify for anything executable
