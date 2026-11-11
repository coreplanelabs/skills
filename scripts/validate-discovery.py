#!/usr/bin/env python3
"""Validate registry schemas and keep hosted-server registrations consistent."""
import json
import re
from pathlib import Path
from urllib.request import urlopen

import jsonschema
import yaml

ROOT = Path(__file__).resolve().parent.parent


def read_json(path):
    return json.loads((ROOT / path).read_text())


def check(condition, message):
    if not condition:
        raise ValueError(message)


for filename, schema_url in (
    ("server.json", "https://static.modelcontextprotocol.io/schemas/2025-12-11/server.schema.json"),
    ("glama.json", "https://glama.ai/mcp/schemas/server.json"),
):
    manifest = read_json(filename)
    check(manifest["$schema"] == schema_url, f"Unexpected schema in {filename}")
    with urlopen(schema_url, timeout=30) as response:
        schema = json.load(response)
    jsonschema.validate(manifest, schema, format_checker=jsonschema.FormatChecker())
    print(f"ok   {filename}: official schema")

mcp = read_json(".mcp.json")["mcpServers"]
server = read_json("server.json")
check(server["remotes"] == [{"type": "streamable-http", "url": mcp["polylane"]["url"]}],
      "Registry must advertise the product endpoint, not the docs server")
check(not server.get("packages") and "repository" not in server,
      "This repository does not distribute the hosted server implementation")
check(bool(read_json("glama.json")["maintainers"]), "Glama needs a GitHub maintainer")

gemini = read_json("gemini-extension.json")
# Gemini documents this format but does not publish a standalone JSON schema.
check(set(gemini) == {"name", "version", "description", "mcpServers"},
      "Review new Gemini fields against the official extension reference")
check(gemini["name"] == "polylane", "Unexpected Gemini extension name")
check(isinstance(gemini["version"], str) and re.fullmatch(r"\d+\.\d+\.\d+", gemini["version"]),
      "Gemini version must be a concrete release version")
check(isinstance(gemini["description"], str) and gemini["description"].strip(),
      "Gemini description is required")
check(gemini["mcpServers"] == {name: {"httpUrl": config["url"]} for name, config in mcp.items()},
      "Gemini must use httpUrl for both existing Streamable HTTP endpoints")
print("ok   hosted endpoints and Gemini configuration")

names = set()
for path in [ROOT / "SKILL.md", *sorted((ROOT / "skills").glob("*/SKILL.md"))]:
    text = path.read_text()
    check(text.startswith("---\n"), f"Missing frontmatter: {path}")
    sections = text.split("---\n", 2)
    check(len(sections) == 3, f"Unterminated frontmatter: {path}")
    metadata = yaml.safe_load(sections[1])
    check(isinstance(metadata, dict), f"Invalid frontmatter: {path}")
    name = metadata.get("name")
    check(isinstance(name, str) and re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name)
          and len(name) <= 64, f"Invalid skill name: {path}")
    check(name not in names, f"Duplicate skill name: {name}")
    names.add(name)
    description = metadata.get("description")
    check(isinstance(description, str) and 0 < len(description) <= 1024,
          f"Invalid skill description: {path}")
    check(bool(sections[2].strip()), f"Empty skill instructions: {path}")
    print(f"ok   {path.relative_to(ROOT)}: skill frontmatter")
