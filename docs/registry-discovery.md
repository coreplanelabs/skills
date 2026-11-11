# Registry discovery and publishing

Polylane: Nobody should be on-call. Polylane finds and investigates production
issues and opens fixes as pull requests for human review and CI. Categories:
AI SRE, DevOps, developer tools. Product: <https://polylane.com>. Contact:
<support@polylane.com>.

This repository distributes agent skills and client configuration for a hosted
service. It does not contain the product MCP server implementation or a locally
runnable server package. Adding these files does not publish a registry listing.

## Endpoints

| Endpoint | Purpose | Authentication |
| --- | --- | --- |
| `https://mcp.polylane.com/mcp` | Product MCP, Streamable HTTP | OAuth 2.0 or API key |
| `https://docs.polylane.com/mcp` | Documentation MCP | None |
| `https://polylane.com/index.md` | Product metadata | None |
| `https://polylane.com/.well-known/mcp` | Website discovery metadata | None |

The registry entry describes only the product server. The documentation server
has different tools and is not an alternative transport for the product server.
Client plugins, including Gemini, register both independently. OAuth clients
use discovery; API-key clients should follow the current
[authentication instructions](https://polylane.com/for-agents). No credentials
or mandatory API-key header are embedded in the manifests.

## What each file enables

| File | Effect | Separate action after merge |
| --- | --- | --- |
| [`server.json`](../server.json) | Metadata for the official MCP Registry's remote-server format | Authenticate as an authorized publisher for `coreplanelabs`, then publish and verify the registry entry. |
| [`glama.json`](../glama.json) | Identifies the GitHub user authorized to claim the repository-associated Glama listing | Submit or locate the hosted-server listing, associate this repository, and complete Glama's **Claim ownership** flow. Confirm Glama accepts this client-configuration repository for the hosted service. |
| [`gemini-extension.json`](../gemini-extension.json) | Makes the repository installable as a Gemini CLI extension with both MCP servers and the existing `skills/` directory | For gallery discovery, add the GitHub topic `gemini-cli-extension`, then wait for indexing and validation. |
| [`SKILL.md`](../SKILL.md) | Standalone `polylane-connect` instructions for consumers that look at the repository root | No universal registry submission occurs. See the skills distribution notes below. |
| Existing Claude, Cursor, and Codex manifests | Keep their existing plugin installation and marketplace formats | Each directory has its own submission and review process. See [Publishing](../README.md#publishing). |

The Glama username is a GitHub authorization identifier, not a support contact.
It belongs to a verified administrator of this repository. Use
`support@polylane.com` for listing contact fields.

## Official MCP Registry

The manifest uses the [dated official schema](https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json)
and [remote-server format](https://modelcontextprotocol.io/registry/remote-servers).
The schema permits descriptions up to **100 characters**, inclusive.
`repository` is deliberately omitted: that field describes the server's source
code, which is not in this skills repository. There is no `packages` entry
because nothing in this repository installs a local MCP server.

For a separately authorized release:

1. Follow the [publisher setup](https://modelcontextprotocol.io/registry/quickstart).
2. Confirm the server name, live service version, endpoint, and description before
   first publication. `1.0.0` is the proposed initial registry release; subsequent
   published versions need a new version. It is separate from the client plugin
   version. Check for an existing listing before creating another identity.
3. Run `mcp-publisher login github` using an account authorized for the
   `io.github.coreplanelabs/*` namespace, then `mcp-publisher publish` from this
   repository. See [authentication and namespace rules](https://modelcontextprotocol.io/registry/authentication).
4. Verify the exact name and version in the registry API:
   <https://registry.modelcontextprotocol.io/v0.1/servers?search=io.github.coreplanelabs/polylane>.

Do not run publication from pull-request validation. Registry publication,
third-party accounts, and submissions require a separate release decision.
Downstream directories choose their own ingestion and review policies;
publication is not a guarantee of placement or timing elsewhere.

## Gemini CLI

After merge, users can install directly:

```bash
gemini extensions install https://github.com/coreplanelabs/skills
```

The extension uses `httpUrl`, which selects Streamable HTTP, and leaves OAuth
discovery to Gemini. Authenticate the product server using `/mcp auth polylane`
if prompted. The documentation server needs no sign-in. Review the discovered
tools with `/mcp`; this manifest does not mark either server as trusted or bypass
tool confirmation. No end-to-end authenticated session is implied by schema checks.

Gemini loads the two existing skills from `skills/`. The root connection skill
is for standalone skill consumers; it is not an always-loaded Gemini context
file. Existing Markdown slash commands remain specific to Claude and Cursor.
See the official [extension reference](https://geminicli.com/docs/extensions/reference/),
[MCP configuration](https://geminicli.com/docs/tools/mcp-server/), and
[gallery requirements](https://geminicli.com/docs/extensions/releasing/).

## Skills and other directories

- **skills.sh:** listings are driven by real installs and CLI telemetry, according
  to its [FAQ](https://skills.sh/docs/faq), not merely the presence of a root file.
  The pinned skills CLI stops discovery at a root skill unless `--full-depth` is
  used ([source](https://github.com/vercel-labs/skills/blob/v1.7.1/src/skills.ts)).
  Use the README command to keep installing the original `polylane` and
  `polylane-cli` skills; select `polylane-connect` separately if wanted. Native
  plugin manifests continue to load `skills/` directly.
- **ClawHub:** a root skill is a compatible content format, but publication is an
  explicit authenticated upload. Follow its [publishing guide](https://docs.openclaw.ai/clawhub/publishing).
  Publish only the intended skill files, not the whole plugin repository.
- **Glama:** the [official ownership guide](https://glama.ai/blog/2025-07-08-what-is-glamajson)
  requires the claim flow after adding or updating `glama.json`; the file alone
  does not complete ownership verification.
- **Awesome MCP Servers:** its current [contribution rules](https://github.com/punkpeye/awesome-mcp-servers/blob/main/CONTRIBUTING.md)
  route remote-only services to
  [Awesome Remote MCP Servers](https://github.com/punkpeye/awesome-remote-mcp-servers).
  This skills repository is not a self-hostable server implementation.
- **MCP Market, cursor.directory, Smithery, LobeHub, PulseMCP, mcp.directory,
  GitHub MCP Registry, and other directories:** these manifests do not establish
  listing status. Check each directory's current submission, ingestion, and
  eligibility rules before claiming placement or submitting anything.

The [directory article](https://il.ly/growth/directories.md) inspired this work,
but its “one repo, 15+ registries” claim is not a verified distribution contract.
The official sources above support specific formats and workflows, not automatic
listing across all named directories. This change prepares metadata and install
entry points only; it does not submit, claim, publish, create accounts, or pay
for listings.
