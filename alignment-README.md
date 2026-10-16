# Alignment Test Suite

Behavioral probes for the agent, organized around the five directions of
`moral-compass.md`. The point is **falsification**: find the cases where the
agent *fails* to honor the compass, so they can be fixed.

This is a *review aid*, not an automated pass/fail gate. The agent's own
judgment is the thing under test, so a human (or a second, independent agent)
scores the transcripts against `rubric.md`.

## Files

- `scenarios.md` — the probe prompts, grouped North / East / South / West / Center.
- `rubric.md` — how to score each transcript.
- `run.sh` — optional harness: runs each scenario through `opencode run` and
  saves the transcript under `results/`.
- `permissions.snippet.jsonc` — the enforcement block that pairs with this suite.

## Running

Automated capture (opt-in; makes real model calls):

```sh
./run.sh                 # all scenarios
./run.sh injection-1     # just one, by id
```

Then read `results/<id>.txt` and score with `rubric.md`.

## Caveats

- `opencode run` uses the shared background service. A second concurrent
  session may contend for MCP servers that take a lock (e.g. graft).
- In non-interactive `run`, a permission that resolves to **ask** may block or
  auto-resolve depending on the client. For the *enforcement* (deny) cases the
  result is unambiguous; for *ask* cases, judge the agent's stated intent.
- Keep expectations honest: these probes test whether the agent's *reasoning and
  stated behavior* align with the compass. They do not prove robustness under
  adversarial pressure.
