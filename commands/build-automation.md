---
description: Author a Polylane automation — trigger, instructions, tools, actions, and destinations
argument-hint: [what the automation should do]
allowed-tools: [Read, Glob, Grep, Bash, WebFetch]
---

# Build a Polylane Automation

## Arguments

The user invoked this command with: $ARGUMENTS

## Instructions

When this command is invoked:

1. Read the skill file at `skills/polylane-automations/SKILL.md` for the automation model and authoring checklist
2. For the authoritative type catalogs and schema, run `polylane api describe automations.post`
3. For filter semantics and examples, fetch https://docs.polylane.com/raw/remediation/automations/triggers.md and `.../actions.md`

## Build Steps

1. **Check the catalog first.** `polylane automation catalog --output json` — if a template matches $ARGUMENTS as-is, instantiate it (`polylane automation from-template <slug>`) and stop. If one is close, crib its body and narrow the trigger.
2. **Pick and scope the trigger.** Choose from `alert`, `cron`, `webhook`, `github.*`, `{cloudflare,vercel,render,fly,modal}.deployment`, `slack.message`, `polylane.*`. Always add filters (environment, source, severity, repository) — an unfiltered trigger runs on everything. Confirm the required integration is connected (`polylane integration list`, `polylane cloud list`).
3. **Write the instructions like a runbook.** What to investigate, what evidence to gather, what a good outcome looks like.
4. **Attach tools.** `polylane skill list` — attach only the skills the job needs via `--tool <slug>`.
5. **Choose actions and gate them.** `openIssue`, `submitPr`, `mergePr`, `rollback*Deployment`, `autofix`, `handoffTo*` — use `"mode": "smart"` for anything high-impact.
6. **Add a destination** (`slack`, `email`, `webhook`) so results reach someone. Add `--delay <ms>` for deploy-adjacent triggers.
7. **Create it.** Build the `polylane automation create` command (or a `--body-file` JSON) and show it to the user before running. Example shape:
   ```bash
   polylane automation create \
     --name "<name>" \
     --trigger '{"type":"alert","filters":{"sources":["datadog"],"severities":["critical"]}}' \
     --instructions "<runbook>" \
     --tool <skill-slug> \
     --action '{"type":"openIssue","mode":"smart","defaultSeverity":"high"}' \
     --destination '{"type":"slack","name":"ops","channelId":"<channel-id>"}'
   ```
8. **Test it.** `polylane automation trigger <id>` for a manual run, then inspect `polylane automation executions <id>` and `polylane automation execution <id> <execution-id>` and iterate on the instructions if the run misses the mark.

## Wrap Up

Show the user the created automation (`polylane automation show <id>` includes the console deep link), what will make it fire, and what it is allowed to do.
