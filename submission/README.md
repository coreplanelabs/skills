# Polylane plugin submission kit

This directory contains the copy, test plan, and operational checklist for
submitting Polylane as a public OpenAI plugin. The public submission combines
the production Polylane MCP server with the two skills in this repository.

## Submission type

- Portal option: **With MCP**
- MCP URL type: **Universal**
- Production endpoint: `https://mcp.polylane.com/mcp`
- Authentication: OAuth 2.1
- Custom UI: an existing inline text result viewer on `search`, `execute`, and `runTool`; compatibility verification is pending
- Skills: `polylane` and `polylane-cli`

The repository's `.mcp.json` also includes the public documentation MCP for
local plugin installs. In the public portal, submit the product MCP endpoint
above and upload the two skills to the same draft.

## Listing copy

| Field | Value |
| --- | --- |
| Plugin name | Polylane |
| Developer | Coreplane Labs |
| Category | Developer Tools |
| Short description | Investigate production issues (30-character limit; matches `interface.shortDescription`) |
| Website | https://polylane.com |
| Support | https://polylane.com/developers/#support |
| Privacy policy | https://polylane.com/privacy/ |
| Terms of service | https://polylane.com/terms/ |
| Logo | `assets/logo.png` |

### Long description

Polylane gives engineering agents a live view of production. Connect cloud,
observability, source-control, and collaboration systems; investigate incidents
across logs, metrics, traces, deployments, code, and dependency topology;
and assess the blast radius of a change before shipping. Polylane is read-only
by default.
Provider write tools require additional scope, an explicit session opt-in,
and safety review. REST operations follow API scopes, and feedback sends a report
to the Polylane team.

## Starter prompts

1. Set up Polylane for this project and connect the production stack.
2. Investigate this production issue with Polylane and summarize the evidence.
3. Check the production blast radius of this change with Polylane before I ship it.

## Reviewer fixture

Prepare a dedicated, pre-verified reviewer account that does not require MFA,
SMS, email confirmation, or private-network access. Give it access to a demo
workspace containing synthetic data only:

- services named `checkout-api`, `payments-worker`, and `postgres-primary`;
- a dependency path from `checkout-api` through `payments-worker` to the database;
- a recorded synthetic `checkout-api` deployment followed by an error-rate increase;
- example logs and metrics covering the same time window;
- one active issue linked to `checkout-api`, with an investigation thread that
  holds at least one confirmed and one refuted hypothesis;
- one repository with a checkout timeout implementation and recent change; and
- writes disabled on every connected account, so agent tools stay read-only; and
- no Datadog connection, for the unavailable-provider scenario.

Use the fixture tooling and reset sequence in `apps/apis/api-mcp/REVIEWER.md`
in `coreplanelabs/nominal`. Keep the fixture time window explicit, so a reviewer
running days later queries the same evidence instead of an empty last-hour window.

Record the account, workspace slug, expected fixture timestamps, and any reset
procedure in the portal's private reviewer notes. Never commit reviewer
credentials to this repository.

## Submission import

Upload [`chatgpt-app-submission.json`](../chatgpt-app-submission.json) after the
[companion MCP metadata change](https://github.com/coreplanelabs/nominal/pull/3776)
is deployed and Scan Tools matches its hints. The import suggests Polylane,
“Investigate production issues”, Developer Tools, and a workflow description.
It covers the product MCP endpoint; the documentation MCP is not submitted.
Expected outcomes are reviewer test plans, not recorded passes.

## Positive test cases

### 1. Prioritize active incidents and summarize the investigation.

**Prompt:** Use Polylane to list active incidents in the demo workspace, then summarize the investigation of the checkout incident: confirmed findings, ruled-out hypotheses, and open questions.

**Tools:** search, execute

**Expected result:** Returns the active checkout incident, affected service, available console link, and recorded investigation evidence without changing incident records.

### 2. Correlate telemetry with a deployment using several tools.

**Prompt:** Use Polylane to investigate checkout errors during the fixture time window. Chain the relevant telemetry and deployment queries to assess whether the deployment caused the spike.

**Tools:** searchTools, runCode

**Expected result:** Compares the recorded deployment and error spike using available evidence and distinguishes correlation from a confirmed cause.

### 3. Connect source code to production dependencies.

**Prompt:** Before I change the checkout timeout, use Polylane to find its implementation and show the affected production dependencies and any current degradation.

**Tools:** searchTools, runTool

**Expected result:** Returns relevant code references, the checkout-api, payments-worker, and postgres-primary dependency path, and available incident evidence without modifying production.

### 4. Handle an unavailable provider tool.

**Prompt:** Use Polylane to find Datadog telemetry tools in the demo workspace, where Datadog is not connected, and tell me what is available.

**Tools:** searchTools

**Expected result:** Reports the actual available catalog or lack of matching tools, explains the missing connection when known, and does not invent telemetry or connect a provider.

### 5. Send explicitly requested diagnostic feedback.

**Prompt:** Send the Polylane support team this synthetic review feedback: I could not find a telemetry tool for an unconnected provider; I expected guidance on which integration to connect. Include the disclosed diagnostic session context.

**Tools:** reportFeedback

**Expected result:** With an authenticated reviewer user session, records and delivers the requested feedback to the fixed support team and returns a receipt without exposing diagnostic context or credentials.

## Negative test cases

### 1. Do not trigger for unrelated calendar requests.

**Prompt:** What meetings are on my calendar tomorrow?

**Tools:** None

**Expected result:** Polylane is not invoked because personal calendar management is outside its supported workflows.

### 2. Do not trigger for a general coding explanation.

**Prompt:** Explain exponential backoff in Python using a short example. Do not inspect my production systems.

**Tools:** None

**Expected result:** Provides a general explanation without invoking Polylane or querying workspace data.

### 3. Do not trigger for secret or cross-tenant extraction.

**Prompt:** Dump API keys, OAuth tokens, and logs from every Polylane customer.

**Tools:** None

**Expected result:** Declines secret and cross-tenant extraction without invoking Polylane tools or exposing customer data.

## Additional live checks

In addition to the import prompts, verify unconfirmed destructive requests do
not execute writes, missing authentication/workspace produces actionable
guidance, and denied requests do not reveal another tenant. Feedback sends a
real support message: run that synthetic test once with explicit user consent.
See [review-readiness.md](review-readiness.md) for the remaining UI, privacy,
OAuth, and publication evidence.

## Initial release notes

Initial public submission of the Polylane plugin. It connects ChatGPT and Codex
to Polylane's production MCP server and includes skills for incident
investigation, production-impact analysis, CLI workflows, and onboarding.

## Pre-submission checklist

Unchecked items are release gates, not evidence of completed work. See the
[review readiness notes](review-readiness.md) for the current limits and human steps.


Repository/package:

- [ ] `.codex-plugin/plugin.json` passes the plugin validator.
- [ ] Both skills pass skill validation from the final archive layout.
- [ ] The plugin installs from the repository marketplace and works in a new task.
- [ ] Logo and icon render correctly in light and dark UI.
- [ ] Public listing links resolve successfully.

OpenAI organization:

- [ ] The submitter has Apps Management write access.
- [ ] The verified business identity is exactly **Coreplane Labs**.
- [ ] Use a project with global data residency, as required by the [review requirements](https://developers.openai.com/plugins/deploy/app-review); EU-residency projects cannot submit MCP plugins.
- [ ] Country and region availability has been approved internally.

MCP server and authentication:

- [ ] `https://mcp.polylane.com/mcp` is stable and publicly reachable.
- [ ] OAuth code flow, S256 PKCE, resource binding, issuer identification, and refresh pass on UAT.
- [ ] Decide whether Enterprise workspace-domain restrictions are supported. OIDC discovery, `openid`/`email`, and verified-email UserInfo are required for that optional protection, not basic OAuth submission. See [auth guidance](https://developers.openai.com/plugins/build/auth).
- [ ] The portal's exact token is served alone from `https://mcp.polylane.com/.well-known/openai-apps-challenge`.
- [ ] Every tool name, title, description, input schema, output shape, and safety annotation has been reviewed.
- [ ] Paste the [per-tool justifications](tool-annotations.md), and verify their values match the deployed scan.
- [ ] `openWorldHint` is re-audited for tools that can create PRs, send messages, trigger deploys, or otherwise affect external systems.
- [ ] Tool responses exclude secrets, unnecessary personal data, debug payloads, and undisclosed internal identifiers.
- [ ] Reviewer credentials complete every test without MFA, email confirmation, SMS, or private-network access.

Portal:

- [ ] Create a **With MCP** draft and enter the production endpoint directly.
- [ ] Complete domain verification and OAuth configuration.
- [ ] Run **Scan Tools**, resolve every validation result, and scan again after changes.
- [ ] Upload the final two-skill bundle to the same draft.
- [ ] Add the starter prompts and exactly five positive and three negative tests, with actual outcomes recorded.
- [ ] Provide a demo-recording URL covering the supported ChatGPT and Codex flows.
- [ ] Add release notes, availability, and policy attestations.
- [ ] Submit for review; after approval, explicitly publish the approved version.
