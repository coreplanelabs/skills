---
name: polylane-connect
description: Connect an AI coding agent to Polylane's hosted MCP servers. Use when the user asks to set up Polylane MCP, choose its product or documentation endpoint, or troubleshoot the initial connection.
---

# Connect to Polylane

Polylane finds and investigates production issues and opens fixes as pull requests for human review and CI.

Before changing an agent's configuration, read the current [plugin documentation](https://docs.polylane.com/tools/plugins) and the target agent's MCP configuration instructions. Preserve its existing servers and permission settings.

- **Product MCP:** `https://mcp.polylane.com/mcp`, using Streamable HTTP. It requires a Polylane account and workspace access through OAuth 2.0 or an API key. Use the agent's OAuth flow where available. For API keys, retrieve the current authentication instructions from [Polylane's agent setup guide](https://polylane.com/for-agents); keep credentials in the client's secret storage, outside committed files and chat output.
- **Documentation MCP:** `https://docs.polylane.com/mcp`, with no authentication. It provides documentation, not access to production resources.
- **Gemini CLI:** use `httpUrl` for Streamable HTTP. Its `url` field selects SSE. This repository's `gemini-extension.json` registers both servers.

Verify that the configured server connects and exposes tools. A working documentation connection does not verify product access. If product access fails, report the authentication or workspace access problem without claiming to have inspected production.

For investigation or CLI work after connection, retrieve the relevant pages through the documentation MCP or [documentation index](https://docs.polylane.com/llms.txt). Discover live tool schemas before calling tools. Keep changes and external actions within the user's request; fixes go through pull requests, human review, and CI.

Product metadata is available at [index.md](https://polylane.com/index.md) and [MCP discovery metadata](https://polylane.com/.well-known/mcp). These describe the service; neither is the MCP endpoint. Support: support@polylane.com.
