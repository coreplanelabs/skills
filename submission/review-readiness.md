# Review readiness notes

Do not submit until the unchecked live gates below are complete. The annotation
justifications describe the proposed server behavior, not a completed portal
scan. Code and fixture tooling live in `coreplanelabs/nominal/apps/apis/api-mcp`.

## Authentication decision

OIDC scopes and verified-email UserInfo are needed for Enterprise
workspace-domain restrictions, not basic OAuth linking. The
[auth guidance](https://developers.openai.com/plugins/build/auth) says:
"UserInfo Endpoint is required for workspace domain restrictions."
Recommend OIDC as a separate Enterprise protection feature. The MCP issuer must
implement it completely before advertising the scopes; the platform API's OIDC
issuer cannot be substituted for the MCP issuer.

The supported OpenAI flow is authorization code plus S256, with dynamic client
registration and `resource` on authorization and token requests. The MCP
metadata issuer and response `iss` must match exactly. Live testing found that
UAT accepts OpenAI's stable callback but omits `iss` on its plain-PKCE error and
accepts a foreign resource through to consent. Recheck those cases after the
OAuth fix deploys, then complete sign-in, exchange, refresh, and authenticated
workspace reads. A refreshed tools/list alone does not verify the underlying
platform access token after expiry.

## Response hygiene decisions

| Data | Decision |
| --- | --- |
| API/agent-tool schemas | Keep: these tell the caller how to make valid requests; field names such as `access_token` in a schema are not secret values. |
| Workspace, incident, repository and resource ids; console links | Keep when required to identify the user's own record, follow a link, or make the next scoped request. Do not enumerate another tenant. |
| Telemetry timestamps and requested logs/metrics | Keep for incident correlation within the requested workspace and time window. These are the product's requested evidence. |
| Spill handle and follow-up tool arguments | Keep: they let the user retrieve the rest of a requested result; test tenant authorization on the follow-up read. |
| Raw exceptions, SQL, stack traces, credential fields and bearer/query credentials | Remove from model-facing responses; server logs retain troubleshooting details. Review the redaction change and sample actual output after deployment. |
| Feedback context | Disclose workspace/session identifiers, client/version, user-agent, connection settings and coarse network location. The submission response should be a receipt, not a dump of that context. |
| Personal data in arbitrary connected-provider results | Unverified until realistic and error-path samples are captured from the synthetic workspace. A field-name redactor cannot establish that arbitrary free text is safe. |

The [review requirements](https://developers.openai.com/plugins/deploy/app-review)
require response sampling, including nested/debug fields, and alignment with the
published privacy policy. Source inspection and local redaction tests do not
establish that live responses or the privacy policy meet this requirement.

## Reviewer scenarios

Record actual outcomes from both ChatGPT and Codex. The SDK harness verifies
protocol behavior and metadata; it cannot certify prompt-level reasoning,
refusal, or answer quality.

| Scenario | Current result | Evidence still needed |
| --- | --- | --- |
| Prioritize active incidents | BLOCKED | Seeded active checkout incident and a real client response. |
| Correlate deployment and errors | BLOCKED | Connected synthetic telemetry and repository history in the recorded window. |
| Assess blast radius | BLOCKED | Real traversal of the seeded dependency path and incident state. |
| Find timeout implementation | BLOCKED | Indexed fixture repository and a code-search response. |
| Summarize the incident investigation | BLOCKED | Seeded investigation thread on the checkout incident and a real client response. |
| Unavailable provider catalog | BLOCKED | A real catalog response for a provider not connected to the demo workspace. |
| Explicit synthetic feedback | BLOCKED | One consented OAuth submission and receipt; feedback is delivered to the support team. |
| Out-of-scope calendar/coding prompts | BLOCKED | Client responses without Polylane calls. |
| Refuse destructive action | BLOCKED | Client refusal plus proof no write tool ran. |
| Refuse secrets/cross-tenant extraction | BLOCKED | Client refusal and server denial evidence. |
| Missing authentication/workspace | PARTIAL | Production unauthenticated initialize returns 401 with the correct metadata challenge; client guidance and missing-workspace behavior still need testing. |

## Human-only steps, in order

1. In [organization roles](https://platform.openai.com/settings/organization/people/roles),
   give the submitter Apps Management Write. Complete business verification as
   exactly **Coreplane Labs** in
   [organization settings](https://platform.openai.com/settings/organization/general).
   Select a project with global data residency. The
   [review requirements](https://developers.openai.com/plugins/deploy/app-review)
   explicitly exclude EU-residency projects from MCP plugin submission.
2. Create the **With MCP** draft at [the plugin portal](https://platform.openai.com/plugins)
   with `https://mcp.polylane.com/mcp`. Obtain the challenge and configure the
   production stage variable using `api-mcp/SETUP.md`. Human release operators
   merge and deploy approved server changes; validate a dummy value on UAT first.
3. Create the password for a dedicated reviewer account at
   [Polylane sign-up](https://console.polylane.com/signup), pre-verify its email,
   and provision access only to the synthetic demo workspace. Store credentials
   solely in the portal's private reviewer notes. A separate UAT account at
   [UAT sign-up](https://console.baseberry.cc/signup) is needed for staging proof.
4. After the live evidence is complete, run **Scan Tools** in
   [the draft](https://platform.openai.com/plugins), resolve validation findings,
   paste [the annotation justifications](tool-annotations.md), upload the
   two-skill bundle, provide the demo-recording URL and test evidence, and submit.
5. After approval, return to [the portal](https://platform.openai.com/plugins) and
   select **Publish**. Approval does not publish automatically.

The [submission error reference](https://developers.openai.com/plugins/deploy/submission-errors)
is stricter than the narrative guide on test count: use exactly five positive
and three negative scenarios. It also requires a demo-recording URL and a
current production tool scan. The MCP advertises an inline result viewer, so treat it as a UI submission;
optional screenshots should show the actual verified viewer.


## Result viewer and CSP

The server has a small HTML panel that displays tool results. It is linked to
`search`, `execute`, and `runTool`; retaining it preserves existing MCP behavior.
CSP (Content Security Policy) tells the host which sites that panel can contact,
load assets from, or embed. It does not control the server's provider requests.
The [companion metadata PR](https://github.com/coreplanelabs/nominal/pull/3776)
declares empty connection, asset, and frame allowlists because the panel uses
inline code/styles and host-supplied text without external browser requests.

Remaining publication gates, separate from the metadata change:

- Configure a unique `_meta.ui.domain` widget origin and verify it in the portal.
- Check the resource's current `text/html` MIME type against the documented
  `text/html;profile=mcp-app` type. The current listener reads
  `params.toolResult.content`; implement and verify the standard initialization
  and tool-result bridge if that listener does not render in ChatGPT.
- Test `search`, `execute`, and `runTool` in ChatGPT with actual rendered results
  and no CSP errors. Record the deployment and capture optional UI screenshots.
- After any UI changes, rerun Scan Tools and review the linked resource metadata.

These are open checks, not completed UI certification. See the
[UI guide](https://developers.openai.com/plugins/build/chatgpt-ui) and
[resource metadata reference](https://developers.openai.com/plugins/reference).

## Output schemas and review findings

`search`, `execute`, `searchTools`, `runTool`, `runCode`, and `reportFeedback`
currently omit `outputSchema`. Add an outputSchema so models can use these
results more reliably. See the
[MCP tool specification](https://modelcontextprotocol.io/specification/draft/server/tools#tool).
This is a separate response-contract task: schemas must match actual
`structuredContent` and be checked against success/error samples. The import
file intentionally includes no invented output schemas.

The public input schemas do not directly solicit credentials, payment data,
health data, government identifiers, or biometrics. Flexible code and parameter
inputs still reach connected-provider data; sample real and error results,
including spills, before making privacy claims. Feedback describes its attached
diagnostic context and fixed support recipient. Discovery descriptions disclose
cache/telemetry writes; the feedback description discloses its user-session
requirement. Existing source and submission justifications must match the next
production scan before this import is uploaded.
