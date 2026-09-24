# MCP tool annotation justifications

Use these values after the server changes are deployed and Scan Tools matches
this table. Static hints describe the most capable supported credential and
session, including indirect effects; a read-only reviewer credential does not
change the published hints.

| Tool | readOnlyHint | destructiveHint | openWorldHint | Reviewer justification |
| --- | --- | --- | --- | --- |
| `search` | false | false | false | Searches the bounded Polylane API specification, populates schema caches, and records execution telemetry without invoking discovered operations. |
| `execute` | false | true | true | A sufficiently scoped credential can create, overwrite, or delete Polylane records and trigger external actions such as GitHub autofix pull requests. API authorization limits each request, but the static annotations cover those write-capable operations. |
| `searchTools` | false | false | false | Lists the bounded workspace tool catalog and records execution telemetry without running the listed tools. |
| `runTool` | false | true | true | Can query external providers and invoke provider mutations, including irreversible operations. Writes require `agent_tools:write`, session write opt-in, safety review, and confirmation through elicitation when the client supports it. |
| `runCode` | false | true | true | Chains the same external provider tools in a sandbox, so its maximum capabilities include destructive external writes. It inherits the scope, session opt-in, safety review, and client-dependent elicitation gates of `runTool`. |
| `reportFeedback` | false | true | false | Creates and delivers workspace-associated feedback with disclosed diagnostic context to the fixed Polylane support team; callers cannot select arbitrary recipients, and delivered information cannot be retracted. |

The [MCP annotation definitions](https://modelcontextprotocol.io/specification/2025-06-18/schema#toolannotations)
and [OpenAI review guidance](https://developers.openai.com/plugins/deploy/app-review)
use different emphasis for additive writes and irreversible communication.
Feedback is additive in Polylane's database, but its delivery cannot be undone;
we apply the conservative OpenAI reading and mark it destructive. An external
service's private workspace alone does not make a tool open-world: the provider
execution tools receive that hint because their full supported operations reach
external entities, not merely because their servers are hosted elsewhere.

Discovery tools use the submission convention that counts telemetry and cache
writes as state changes. A false read-only hint does not grant permission to
modify customer records. Feedback requires an OAuth or broker-authenticated
user session; API-key sessions cannot submit it.
