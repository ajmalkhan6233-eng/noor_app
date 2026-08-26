---
name: noor-approved-tooling
description: Consult before installing, configuring, or routing through any new tool, plugin, proxy, or environment variable that changes what model or service actually handles requests. Prevents accidentally routing Claude Code through unofficial third-party software.
---

# noor Approved Tooling

## Why this exists
There are third-party tools online that intercept Claude Code and
silently reroute it to a *different* underlying AI model (not Claude
at all) while presenting themselves as a way to "save money" on usage.
Some explicitly acknowledge in their own documentation that this
likely violates Anthropic's Terms of Service. This is a real risk to
the account this project runs on, and to consistency — a different
model underneath has no guarantee of following any of the rules in
this skills folder or in CLAUDE.md.

## Rule
Never configure, suggest, or install anything that:
- Sets `ANTHROPIC_BASE_URL` to a non-Anthropic endpoint
- Claims to make Claude Code "cheaper" by routing through OpenAI,
  Gemini, or other non-Anthropic model backends
- Requires new heavy infrastructure (Docker, WSL, a separate proxy
  server) specifically to intercept AI traffic
- Explicitly disclaims or hedges on Terms of Service compliance in
  its own documentation — treat that as an automatic disqualifier,
  not a minor caveat

## What's actually approved and already in use
- Official Anthropic model switching within Claude Code (e.g.
  switching to Fable 5 using its own separate credit) — this is
  legitimate, built-in, and already in use on this project.
- Plugins installed through Claude Code's own `/plugin marketplace`
  and `/plugin install` system (e.g. claude-mem) — this goes through
  Anthropic's own supported extension mechanism, not a traffic
  interception layer.
- Claude Code's built-in WebSearch/WebFetch tools, once permissions
  are confirmed working.

## If cost or usage limits come up again
The real, safe levers are: Fable 5's separate credit pool (for
long/complex sessions), claude-mem (reduces repeated re-explaining
across sessions), and working in focused, well-scoped batches per
CLAUDE.md's Build Loop discipline — not routing traffic through
unofficial software. If none of these feel like enough, that's a
conversation to have directly, not something to solve by installing
an unverified proxy.
