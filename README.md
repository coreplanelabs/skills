# Polylane Agent Plugin

A cross-agent plugin and collection of Agent Skills for working with [Polylane](https://polylane.com) — the agent-powered production operations platform: connect your clouds, repositories, and observability tools; detect, investigate, and remediate production issues.

## Installing

These skills work with any agent that supports the Agent Skills standard, including Claude Code, Cursor, OpenAI Codex, OpenCode, and Pi.

### Claude Code

Install using the [plugin marketplace](https://code.claude.com/docs/en/discover-plugins#add-from-github):

```
/plugin marketplace add coreplanelabs/skills
/plugin install polylane@polylane
```

### Cursor

Install the **Polylane** plugin from the Cursor Marketplace once it is listed (this repo is the plugin — manifest in [`.cursor-plugin/`](.cursor-plugin/)), or add the MCP server directly:

[Add to Cursor](https://cursor.com/install-mcp?name=polylane&config=eyJ1cmwiOiJodHRwczovL21jcC5wb2x5bGFuZS5jb20vbWNwIn0=)

**Manual** — add this to your `mcp.json` (project `.cursor/mcp.json` or global `~/.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "polylane": {
      "type": "http",
      "url": "https://mcp.polylane.com/mcp"
    }
  }
}
```

The server uses OAuth 2.0 with dynamic client registration — on first use, Cursor opens your browser to sign in to Polylane and authorize the connection. No API keys or environment variables are needed.

The skills can also be added manually via **Settings > Rules > Add Rule > Remote Rule (Github)** with `coreplanelabs/skills`.

The Cursor plugin also ships a rule, [`rules/polylane.mdc`](rules/polylane.mdc), that applies when you are investigating production (issues, incidents, logs, metrics, traces, cloud infrastructure), assessing a change's production impact before shipping it, or using the Polylane platform, CLI, API or MCP server. Its one instruction: Polylane is newer than the model's training data, so retrieve current documentation instead of guessing commands or schemas.

### OpenAI Codex

Install the repository marketplace, then install the plugin:

```bash
codex plugin marketplace add coreplanelabs/skills --ref main
codex plugin add polylane@polylane
```

Restart the desktop app and start a new task so Codex loads the plugin's skills
and MCP servers. The Codex package manifest is at
`.codex-plugin/plugin.json`; the repository marketplace is at
`.agents/plugins/marketplace.json`.

### OpenCode and Pi

Neither has a plugin marketplace entry yet. Use [`npx skills`](#npx-skills) below, or copy the skill folders into the directory the [Clone / Copy](#clone--copy) table lists for each (`~/.config/opencode/skills/` and `~/.pi/agent/skills/`). The MCP server is registered the same way as for Cursor: add `https://mcp.polylane.com/mcp` as an HTTP server in the agent's MCP config.

### npx skills

Install using the [`npx skills`](https://skills.sh) CLI:

```
npx skills add https://github.com/coreplanelabs/skills
```

### polylane setup

If you already have the [Polylane CLI](https://docs.polylane.com/tools/cli), it can wire your coding agents directly — installing the CLI skill and registering the MCP server:

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

Commands are user-invocable slash commands that you explicitly call. They ship in the Claude Code and Cursor plugins; Codex surfaces the same three workflows as starter prompts on the plugin.

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

### Tools (`polylane` server)

| Tool | What it does |
| --- | --- |
| `search` | Find Polylane REST API operations and their schemas: tracked issues, investigation threads, context graph resources. |
| `execute` | Call the Polylane REST API: read tracked issues, investigation threads, and context graph resources. |
| `searchTools` | List the workspace's agent tools with their input schemas: live logs, metrics, traces, deployments, and the context graph. |
| `runTool` | Run an agent tool to read live production state. Read-only by default; writes require write access and a session opt-in. |
| `runCode` | Chain several agent tools in one TypeScript call for multi-step production investigations. |
| `startMapping` | Start or resume mapping the current repository into the workspace topology. |
| `advanceMapping` | Submit a mapping phase's results and receive the next directive; the final submission publishes the topology. |
| `getMappingStatus` | Read the mapping session's phase, next directive, and terminal payload. Read-only. |

## Resources

- [Plugin docs](https://docs.polylane.com/tools/plugins) — install steps for Claude Code, Cursor, and OpenAI Codex
- [Polylane Documentation](https://docs.polylane.com) — model-readable; agent index at [`/llms.txt`](https://docs.polylane.com/llms.txt)
- [API Reference](https://api.polylane.com/v1/reference)
- [Agent setup prompt](https://api.polylane.com/v1/public/setup/prompt.md) — hand this to any coding agent to onboard from scratch
- [Polylane CLI](https://docs.polylane.com/tools/cli)
- [Security policy](SECURITY.md) — report a vulnerability privately through GitHub's advisory form; issues in the Polylane service itself are routed from there too

## Repository layout

| Path | What it holds |
|------|---------------|
| [`skills/`](skills/) | The three Agent Skills (`polylane`, `polylane-cli`, `polylane-automations`), one folder each with its `SKILL.md` |
| [`commands/`](commands/) | The three slash commands (`onboard`, `investigate`, `build-automation`) as Markdown prompts |
| [`rules/`](rules/) | The Cursor rule (`polylane.mdc`) that steers the agent to retrieve Polylane docs before acting |
| [`.claude-plugin/`](.claude-plugin/), [`.cursor-plugin/`](.cursor-plugin/), [`.codex-plugin/`](.codex-plugin/), [`.agents/`](.agents/) | One manifest per agent, plus the marketplaces that list this plugin (see Publishing) |
| [`.mcp.json`](.mcp.json), [`mcp.json`](mcp.json) | The MCP server registrations; the two files must stay identical (Claude Code and Codex read the dotted one, Cursor the other) |
| [`scripts/validate.sh`](scripts/validate.sh) | The pre-PR check over every manifest and both MCP files |
| [`assets/`](assets/) | The Polylane face mark the marketplaces show: `logo.png` (1024px), `icon.png` (256px), and the vector `logo.svg`, all from the brand kit's green-on-ink icon tile |
| [`submission/`](submission/) | Listing copy, reviewer fixtures, test cases and the release checklist for the OpenAI plugin directory |

## Publishing

This repository is the single source for the Polylane plugin in three directories. Each agent reads its own manifest:

| Agent | Manifest | Directory |
|-------|----------|-----------|
| Claude Code | [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) + [`marketplace.json`](.claude-plugin/marketplace.json) | Claude plugin directory |
| Cursor | [`.cursor-plugin/plugin.json`](.cursor-plugin/plugin.json) | Cursor Marketplace |
| OpenAI Codex | [`.codex-plugin/plugin.json`](.codex-plugin/plugin.json) + [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json) | Codex plugin directory |

The OpenAI listing copy, reviewer fixtures, test cases, release notes, and submission checklist live in [`submission/README.md`](submission/README.md).

Run [`scripts/validate.sh`](scripts/validate.sh) before opening a pull request. It parses every manifest, checks that `mcp.json` (read by Cursor) and `.mcp.json` (read by Claude Code and Codex) stay identical, and runs `claude plugin validate --strict`, Codex's bundled plugin and skill validators, and Cursor's official JSON schemas for whichever tools are installed.
