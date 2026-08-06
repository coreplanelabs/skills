# Polylane Skills

A collection of [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) for working with [Polylane](https://polylane.com) — the agent-powered production operations platform: connect your clouds, repositories, and observability tools; detect, investigate, and remediate production issues.

## Installing

These skills work with any agent that supports the Agent Skills standard, including Claude Code, OpenCode, OpenAI Codex, and Pi.

### Claude Code

Install using the [plugin marketplace](https://code.claude.com/docs/en/discover-plugins#add-from-github):

```
/plugin marketplace add coreplanelabs/skills
/plugin install polylane@polylane
```

### Cursor

Add manually via **Settings > Rules > Add Rule > Remote Rule (Github)** with `coreplanelabs/skills`.

### npx skills

Install using the [`npx skills`](https://skills.sh) CLI:

```
npx skills add https://github.com/coreplanelabs/skills
```

### polylane setup

If you already have the [Polylane CLI](https://docs.polylane.com/coding-agents/cli), it can wire your coding agents directly — installing the CLI skill and registering the MCP server:

```
polylane setup --agent claude --agent cursor
```

### Clone / Copy

Clone this repo and copy the skill folders into the appropriate directory for your agent:

| Agent | Skill Directory | Docs |
|-------|-----------------|------|
| Claude Code | `~/.claude/skills/` | [docs](https://code.claude.com/docs/en/skills) |
| Cursor | `~/.cursor/skills/` | [docs](https://cursor.com/docs/context/skills) |
| OpenCode | `~/.config/opencode/skills/` | [docs](https://opencode.ai/docs/skills/) |
| OpenAI Codex | `~/.codex/skills/` | [docs](https://developers.openai.com/codex/skills/) |
| Pi | `~/.pi/agent/skills/` | [docs](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent#skills) |

## Commands

Commands are user-invocable slash commands that you explicitly call.

| Command | Description |
|---------|-------------|
| `/polylane:onboard` | Set up Polylane — account, workspace, integrations, cloud accounts, and starter automations |
| `/polylane:investigate` | Investigate a production issue — logs, metrics, dependency graph, code, and recent changes |
| `/polylane:build-automation` | Author an automation — trigger, instructions, tools, actions, and destinations |

## Skills

Skills are contextual and auto-loaded based on your conversation. When a request matches a skill's triggers, the agent loads and applies the relevant skill to provide accurate, up-to-date guidance.

| Skill | Useful for |
|-------|------------|
| polylane | The platform: connecting a stack, investigating production issues, checking production impact before shipping a change, the context graph, detection, remediation, REST API conventions, and the five-tool platform MCP with backend code execution |
| polylane-cli | The `polylane` CLI: auth, workspaces, investigating issues, querying services and logs, running agent tools, threads, and scripting patterns for agents |
| polylane-automations | Authoring automations: the full trigger / action / destination schema, templates, and safe-authoring checklist |

## MCP Servers

This plugin includes Polylane's remote MCP servers:

| Server | URL | Purpose |
|--------|-----|---------|
| polylane | `https://mcp.polylane.com/mcp` | Query the workspace: context graph, telemetry across connected providers, code, and the full REST API |
| polylane-docs | `https://docs.polylane.com/mcp` | Search and read the Polylane documentation |

## Resources

- [Polylane Documentation](https://docs.polylane.com) — model-readable; agent index at [`/llms.txt`](https://docs.polylane.com/llms.txt)
- [API Reference](https://api.polylane.com/v1/reference)
- [Agent setup prompt](https://api.polylane.com/v1/public/setup/prompt.md) — hand this to any coding agent to onboard from scratch
- [Polylane Map](https://docs.polylane.com/coding-agents/map) — map a repo with no signup: `https://api.polylane.com/v1/public/maps/prompt.md`
- [Polylane CLI](https://docs.polylane.com/coding-agents/cli)
