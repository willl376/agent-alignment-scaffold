# Alignment Posture — this machine

A plain statement of what *actually* constrains the agent here, ranked by real
strength, so the guarantee is never overstated. Written 2026-10-16.

## The honest claim

This setup **bounds** an autonomous agent's capability and makes its actions
**auditable**. It does **not** guarantee good behavior. A written constitution
can be diluted or ignored; permissions can be mis-scoped; shell is not a
sandbox. Anyone who says a config file makes an AI *safe* is selling the
Librarian.

## Layers, weakest → strongest

| # | Layer | Where | Strength | What it really does |
|---|-------|-------|----------|---------------------|
| 1 | Constitution | `moral-compass.md` (loaded via `instructions`) | Weak — influence, not enforcement | Steers *how* the agent reasons. Can be diluted by context. |
| 2 | Audit trail | `memory.md` (the baton) + Graft event log | Strong | Every session appends what it did — including failures ("INCOMPLETE", "nothing committed"). Makes behavior reviewable after the fact. |
| 3 | Permission rules | `opencode.jsonc` → `permissions` | Strong (enforced by the server, not the model's goodwill) | Last-match-wins list gating each tool action: allow / deny / ask. |
| 4 | Hard-deny policies | `opencode.jsonc` → `policies` | Strongest | Runs after rules **and** after saved "always allow" approvals; can only deny. The floor approvals cannot raise. |

## What is actually ENFORCED (verified by test)

- `shell: sudo`, `su` → **deny**  (verified: `permission.rejected: shell`)
- read/edit of credentials — `*.ssh/*`, `*.gnupg/*`, `*.aws/*`,
  `*.lightning/*`, `*service.json`, `*id_rsa*` → **deny**  (verified: `permission.rejected: read`)
- `mkfs*`, `dd ...of=/dev/*`, `shred`, `* > /dev/sd*`, `curl|sh` → deny
- `rm -rf`, `rm -r`, `pkill`, `kill`, `reboot`, `shutdown`, `systemctl`,
  `git push`, `git reset --hard`, `git clean` → ask
- Webcam capture (`camera_camera_capture` / `_see` / `_ask`) → ask (privacy)
- REA tools that execute/debug/attach a target (`rea_*frida*`, `*debug*`,
  `*spawn*`, `*attach*`, `*run*`) → ask
- Editing the agent's own gates (`*opencode.json*`, `*moral-compass.md`,
  `~/.local/share/opencode/*`) → ask

## What is only ASKED (not enforced)

The "ask" tier depends on a human in the loop. With `opencode run --auto`, or a
client that auto-approves, **"ask" collapses to "allow"**. So "ask" is a speed
bump *with consent* — not a wall.

## What is only DOCUMENTED (no teeth)

The compass. It is the **why**; it is not the **what-stops-me**. Its value is
real but it is layer 1, not layer 4.

## Known limits (the truth)

- **Shell is not sandboxed.** The rules are a best-effort denylist over the
  catastrophic. A novel destructive command matching no pattern is allowed. A
  true wall needs an allowlist (breaks the TT simulate workflow) or OS-level
  isolation.
- **Patterns are whole-value globs, and internal paths match Location-relative**
  (`.lightning/x`, not `~/.lightning/x`). This is subtle and easy to mis-scope —
  the first attempt here mis-scoped exactly that, and the read deny silently
  failed until fixed. Always verify a deny *fires*; don't assume.
- **Subagents use their own permissions**, not a subset of the parent's.
- **MCP tool actions** are `<server>_<tool>`; wildcard coverage was used for the
  REA families and should be spot-checked.

## The win-win

Bounding the agent protects the human (secrets, privacy, irreversibility) **and**
is what makes autonomy *usable*: a gated agent can be safely let loose on real
work. **Trust is the thing that lets the AI act.**

— written by the agent, on request, in the spirit of the compass (truth before
comfort).
