---
description: Investigate a production issue with Polylane — logs, metrics, dependency graph, code, and recent changes
argument-hint: [issue-id or symptom description]
allowed-tools: [Read, Glob, Grep, Bash, WebFetch]
---

# Investigate a Production Issue with Polylane

## Arguments

The user invoked this command with: $ARGUMENTS

## Instructions

When this command is invoked:

1. Read the skill file at `skills/polylane-cli/SKILL.md` for CLI usage, agent flags, contracts, and gotchas
2. For exact flags on any command, run `polylane <resource> <verb> --help` — it is authoritative
3. If deeper platform concepts are needed, fetch https://docs.polylane.com/raw/investigation.md

## Preconditions

```bash
polylane auth status || polylane auth login
polylane workspace list                      # confirm a workspace is set
```

Use `--output json --quiet --non-interactive` on every command so results are pipeable and nothing blocks on a prompt.

## Investigation Steps

1. **Anchor on the issue.** If $ARGUMENTS looks like an issue id, start with `polylane issue show <id>` and `polylane issue timeline <id>`. Otherwise, find candidates: `polylane issue list --active` and `polylane service find "<symptom>"`.
2. **Check what changed.** Recent deploys and infra changes are the most common cause: `polylane feed list --category change --since 24h` and `polylane feed list --category release --since 24h`.
3. **Drill into the affected service.** `polylane service logs <service-id> --since 1h --grep error` (add `--templates` for recurring patterns), `polylane service metrics <service-id> --since 1h`, and `polylane service graph <service-id> --direction both --depth 1` to see up/downstream dependencies.
4. **Correlate with code.** `polylane repo find "<area>"`, then `polylane repo grep <repo-id> "<pattern>"` and `polylane repo read <repo-id> <path>` to inspect the suspect code path.
5. **Go deeper with agent tools when the fixed commands aren't enough.** `polylane tools search "<capability>"`, then `polylane tools run <name> --params '{...}'` or chain several with `polylane tools code`.
6. **Record as you go.** `polylane issue note <id> "<what you did>"`, `polylane issue milestone <id> "Mitigated"` at state changes, and `polylane memory save "<confirmed finding>"` for anything future investigations should know.
7. **Escalate to the Polylane agent when useful.** `polylane thread ask "<focused question>" --context <ids>` — attach the relevant service/repo/issue ids so the agent starts with your context.

## Wrap Up

Summarize for the user: root cause (or leading hypothesis), evidence (logs/metrics/changes), what was recorded in Polylane, and the recommended next action (fix, rollback, automation to prevent recurrence — see `/polylane:build-automation`).
