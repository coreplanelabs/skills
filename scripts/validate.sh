#!/usr/bin/env bash
# Validate the Polylane plugin for Claude Code, Cursor, and OpenAI Codex.
# Runs whatever validators are installed locally and skips the rest.
set -u
cd "$(dirname "$0")/.."
fail=0
say() { printf '\n== %s\n' "$*"; }

say "JSON manifests parse"
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json \
         .cursor-plugin/plugin.json .cursor-plugin/marketplace.json \
         .codex-plugin/plugin.json .agents/plugins/marketplace.json \
         .mcp.json mcp.json; do
  if python3 -m json.tool "$f" >/dev/null 2>&1; then echo "ok   $f"; else echo "FAIL $f"; fail=1; fi
done

say "mcp.json (Cursor) and .mcp.json (Claude Code, Codex) are identical"
if diff -q mcp.json .mcp.json >/dev/null; then echo "ok"; else echo "FAIL: files differ"; fail=1; fi

say "Claude Code: claude plugin validate --strict"
if command -v claude >/dev/null 2>&1; then
  for t in . .claude-plugin/plugin.json skills commands; do
    if out="$(claude plugin validate --strict "$t" 2>&1)"; then echo "ok   $t"
    else echo "FAIL $t"; printf '%s\n' "$out" | sed 's/^/     /'; fail=1; fi
  done
else echo "skip: claude CLI not installed"; fi

say "OpenAI Codex: bundled plugin-creator and skill-creator validators"
PV="$HOME/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py"
SV="$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py"
PYBIN="${CODEX_VALIDATOR_PYTHON:-python3}"
if [ ! -f "$PV" ] || [ ! -f "$SV" ]; then
  echo "skip: validators not found under ~/.codex/skills/.system (install Codex CLI or app)"
elif ! "$PYBIN" -c 'import yaml' 2>/dev/null; then
  echo "skip: PyYAML missing for $PYBIN (pip install pyyaml, or set CODEX_VALIDATOR_PYTHON)"
else
  if out="$("$PYBIN" "$PV" . 2>&1)"; then echo "ok   .codex-plugin/plugin.json"
  else echo "FAIL .codex-plugin/plugin.json"; printf '%s\n' "$out" | sed 's/^/     /'; fail=1; fi
  for d in skills/*/; do
    if out="$("$PYBIN" "$SV" "$d" 2>&1)"; then echo "ok   $d"
    else echo "FAIL $d"; printf '%s\n' "$out" | sed 's/^/     /'; fail=1; fi
  done
fi

say "Cursor: official JSON schemas from github.com/cursor/plugins"
if command -v npx >/dev/null 2>&1 && command -v curl >/dev/null 2>&1; then
  tmp="$(mktemp -d)"
  base="https://raw.githubusercontent.com/cursor/plugins/main/schemas"
  if curl -fsSL "$base/plugin.schema.json" -o "$tmp/plugin.schema.json" \
     && curl -fsSL "$base/marketplace.schema.json" -o "$tmp/marketplace.schema.json"; then
    for pair in "plugin.schema.json:.cursor-plugin/plugin.json" \
                "marketplace.schema.json:.cursor-plugin/marketplace.json"; do
      schema="${pair%%:*}"; data="${pair##*:}"
      if out="$(npx --yes -p ajv-cli@5 -p ajv-formats@2 ajv validate --spec=draft7 -c ajv-formats \
                 -s "$tmp/$schema" -d "$data" 2>&1)"; then echo "ok   $data"
      else echo "FAIL $data"; printf '%s\n' "$out" | sed 's/^/     /'; fail=1; fi
    done
  else echo "skip: could not download schemas"; fi
  rm -rf "$tmp"
else echo "skip: npx or curl not available"; fi

echo
if [ "$fail" -eq 0 ]; then echo "All available checks passed."; else echo "Some checks FAILED."; fi
exit "$fail"
