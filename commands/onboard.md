---
description: Set up Polylane — account, workspace, integrations, cloud accounts, and starter automations
argument-hint: [what to connect, e.g. "aws + datadog"]
allowed-tools: [Read, Glob, Grep, Bash, WebFetch]
---

# Onboard onto Polylane

## Arguments

The user invoked this command with: $ARGUMENTS

## Instructions

When this command is invoked:

1. Read the skill file at `skills/polylane-cli/SKILL.md` — especially Prerequisites and the Onboarding workflow
2. For per-type connect flags, run `polylane integration connect --help` / `polylane cloud connect --help` — they are authoritative
3. For platform concepts, fetch https://docs.polylane.com/raw/getting-started.md

## Setup Steps

1. **Install the CLI** if missing (`polylane --version`):
   ```bash
   npm install -g @coreplane/polylane        # or: curl -fsSL https://polylane.com/install.sh | bash
   ```
2. **Authenticate.** `polylane auth login` (browser OAuth) — use `--no-browser` over SSH, or `auth signup --email <email>` for a new account (a 6-digit code is emailed). Verify with `polylane auth status`.
3. **Workspace.** `polylane workspace list`; create one if needed: `polylane workspace create --name "<name>"` (becomes the default).
4. **Discover what can be connected.** `polylane integration catalog` (`--category tool` / `--category cloud`). Match against $ARGUMENTS and what the user's project actually uses (check the repo for provider config files before recommending).
5. **Connect integrations and clouds.** Each type has its own flags — check `polylane integration connect --help` / `polylane cloud connect --help` first. Browser flows print an install URL to stdout and exit 0 immediately; **confirm completion afterwards** with `integration list` / `cloud list`. Never echo API keys into the command history — prefer browser flows, or let the user paste keys interactively.
6. **Starter automations.** `polylane automation catalog`, then `polylane automation from-template <slug>` for the templates that match the user's stack. See `skills/polylane-automations/SKILL.md` for scoping custom ones.
7. **Wire up coding agents.** `polylane setup --agent claude` (and any others the user works in) installs the skill and MCP server locally.
8. **Verify everything.**
   ```bash
   polylane integration list
   polylane cloud list
   polylane service list          # infra discovered from connected accounts
   polylane automation list
   ```

## Wrap Up

Report what got connected, what was skipped (and why), and suggest the first investigation: `polylane issue list --active` or a thread — `polylane thread ask "give me an overview of my infrastructure"`.
