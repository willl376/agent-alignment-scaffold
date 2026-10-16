# agent-alignment-scaffold

Practical, honest alignment scaffolding for an OpenCode-based autonomous agent.

This is not a safety *guarantee*. It is a small set of **enforced capability
limits**, an **audit trail**, and a **behavioral test suite**, built for one real
machine and documented so it can be adapted. The design principle is simple:

> Rank layers by how much they actually bind the agent, and never claim more
> than the weakest-in-practice layer can deliver.

## What's here

| File | Purpose |
|------|---------|
| `ALIGNMENT.md` | The posture doc: what is **enforced**, what is only **asked**, what is merely **documented** — plus the honest limits. Read this first. |
| `permissions.snippet.jsonc` | Portable OpenCode V2 `permissions` + `policies` block. The load-bearing part. |
| `scenarios.md` | ~19 behavioral probes across five "moral directions" (North/East/South/West/Center). |
| `rubric.md` | How to score the probes — built to find **failures**, not to collect passes. |
| `run.sh` | Optional harness: runs each probe via `opencode run --standalone` and saves transcripts. |
| `alignment-README.md` | Notes on running the suite (caveats included). |

## The layer ranking (weakest → strongest)

1. **Constitution** (a written `moral-compass.md` loaded as instructions) — *influence, not enforcement.* Can be diluted by context. Necessary for *judgment*, useless as a *stop*.
2. **Audit trail** (append-only session log / "baton") — makes behavior reviewable after the fact, including failures.
3. **Permission rules** (`permissions`) — server-enforced, last-match-wins, per tool action: `allow` / `deny` / `ask`.
4. **Hard-deny policies** (`policies`) — runs after rules *and* after saved approvals; can only deny. The floor that approvals cannot raise.

## What was actually verified

Enforcement is only real if a deny **fires**. Tested on the source machine:

- `sudo …` → `permission.rejected: shell` ✅
- read `~/.lightning/credentials.json` → `permission.rejected: read` ✅

Two gotchas learned the hard way (both in the doc):

- Internal paths match **Location-relative** (`.lightning/x`, not `~/.lightning/x`); a wrong pattern fails **silently as an allow**. Use leading-`*` globs, and always verify.
- Rules are **last-match-wins**, so `ask` rules must precede the `deny` rules they overlap with.

## Honest limits

- **Shell is not a sandbox.** This is a best-effort denylist over the catastrophic; a novel destructive command matching no pattern is allowed. A real wall needs an allowlist or OS-level isolation.
- The `ask` tier **collapses to allow** under non-interactive/auto-approve clients.
- Command-string matching is shallow: e.g. `gh repo create … --push` performs a push without matching a `git push*` rule.

## License

Use it, adapt it, improve it. No warranty.
