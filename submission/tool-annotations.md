# MCP tool annotation justifications

Use these values after the server changes are deployed and Scan Tools matches
this table. Static hints describe the most capable supported credential and
session, including indirect effects; a read-only reviewer credential does not
change the published hints.

| Tool | readOnlyHint | destructiveHint | openWorldHint | Reviewer justification |
| --- | --- | --- | --- | --- |
| `search` | true | false | false | Searches Polylane's API schema without changing records or invoking the discovered operations. Its domain is the bounded Polylane API specification. |
| `execute` | false | true | true | A sufficiently scoped credential can create, overwrite, or delete Polylane records and trigger external actions such as GitHub autofix pull requests. API authorization limits each request, but the static annotations cover those write-capable operations. |
| `searchTools` | true | false | false | Lists the current workspace's permitted tool definitions without running them or changing records. The catalog is bounded by the workspace's integrations and credential scopes. |
| `runTool` | false | true | true | Can query external providers and invoke provider mutations, including irreversible operations. Writes require `agent_tools:write`, session write opt-in, safety review, and confirmation through elicitation when the client supports it. |
| `runCode` | false | true | true | Chains the same external provider tools in a sandbox, so its maximum capabilities include destructive external writes. It inherits the scope, session opt-in, safety review, and client-dependent elicitation gates of `runTool`. |
| `reportFeedback` | false | true | true | Creates a report delivered to the Polylane team with disclosed diagnostic context. The conservative destructive hint covers information already delivered to an external recipient, which the tool cannot retract. |

The [MCP annotation definitions](https://modelcontextprotocol.io/specification/2025-06-18/schema#toolannotations)
and [OpenAI review guidance](https://developers.openai.com/plugins/deploy/app-review)
use different emphasis for additive writes and irreversible communication.
Feedback is additive in Polylane's database, but its delivery cannot be undone;
we apply the conservative OpenAI reading and mark it destructive. An external
service's private workspace alone does not make a tool open-world: the provider
execution tools receive that hint because their full supported operations reach
external entities, not merely because their servers are hosted elsewhere.
