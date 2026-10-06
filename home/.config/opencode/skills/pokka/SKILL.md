---
name: pokka
description: Manage shared HTTP requests and history with the JSON CLI.
---

# Pokka agent workflow

Use when a project uses Pokka to share API requests with an agent. Use the
installed `pokka` binary CLI only, never edit SQLite, WAL, or application tables.
Do not add `.http`, request JSON, secrets, or workspace files to the target repo.
This is a local-development POC: only execute user-approved local fixtures with
synthetic data and dummy secrets, never production APIs or real credentials.
Actor metadata is caller-declared provenance, not identity or approval.

## Discover and select

Choose an isolated data directory **outside** the target repo and its worktrees.
Run from the target repo, not an ancestor of that data directory. Confirm the
user's intended workspace and existing association before creating anything.
Every CLI invocation must select data, workspace, and actor explicitly:

```sh
R=pokka
D="$HOME/.local/share/pokka-agent-demo" # isolated; must be outside the repo
W=demo
r() { "$R" --data-dir "$D" --workspace "$W" --actor opencode "$@"; }
r --help
r workspace list
# Only if the intended workspace does not exist:
r workspace create "$W" --repo "$PWD"
# Optional manual association of an existing worktree:
# r workspace associate "$W" /path/to/worktree
r request list
r env list
```

Workspace create/associate do not require the selected workspace to exist first.
No automatic Git worktree discovery exists. Use subcommand `--help` for details.
Commands return JSON stdout; input/lookup/storage errors return JSON stderr and
exit 1. Obtain actual IDs from JSON output; never invent IDs or execution results.

## JSON environments and request CRUD

After an approved fixture is running on loopback port 8765:

```sh
printf '%s' '{"variables":{"base_url":"http://127.0.0.1:8765"}}' | r env set local
r env show local
printf '%s' '{"name":"Health","method":"GET","url":"{{base_url}}/health","headers":{},"body":null}' | r request create
# Set ID to the actual returned request id, then read back:
ID=the-returned-request-id
r request show "$ID"
printf '%s' '{"name":"Local health","method":"GET","url":"{{base_url}}/health","headers":{"Accept":"application/json"},"body":null}' | r request update "$ID"
r request show "$ID"
```

JSON stdin is preferred; `--file` is allowed only with a file outside the repo.
Updates **replace** all editable fields: `name`, uppercase `method`, `url`,
string-map `headers`, string-or-null `body`. Never send saved `id` or `actor`
metadata back as input. `env set` also replaces the environment. Read back exact
updated targets and preserve unrelated requests/environments.

## Execute, inspect, verify

```sh
r request run "$ID" --env local --timeout-ms 1000 --max-body 4096
r history list --request "$ID" --limit 20
# Set EXECUTION_ID from the actual run/history JSON:
r history show "$EXECUTION_ID"
# Only if deletion was requested:
# r request delete "$ID"
# r request list
```

A run's **exit 0 means recorded**, not HTTP success. Inspect `error` and `status`:
`error=null` with status 200 is a successful HTTP response; a status 500 is a real
HTTP failure response, not a transport error. A non-null error indicates an
execution/transport failure even with exit 0. Report actual status, error and
history ID, and verify the exact history record through `history show`.
Request deletion leaves durable history intact. TUI observes CLI edits each second.

## Dummy origin-bound ENV references only

Environments can store ENV names and exact allowed origins, never secret values:

```json
{"variables":{"base_url":"http://127.0.0.1:8765"},"secrets":{"demo_token":{"env":"POKKA_DEMO_TOKEN","origins":["http://127.0.0.1:8765"]}}}
```

`POKKA_DEMO_TOKEN` must be explicitly dummy, not a credential. Use a placeholder
such as `"X-Demo-Token":"{{demo_token}}"` in a header/body. Never place secrets
or secret placeholders in URLs; never persist resolved values in headers, bodies,
logs, or nonsecret variables. Show/list do not resolve references. Allowed origins
are scheme + host + effective port; localhost differs from 127.0.0.1, and no
paths, queries, credentials, or fragments are allowed. Declaring any secrets
turns redirects off. Redaction is not protection against arbitrary server-side
transforms, raw literal secrets, process inspection, or malicious editors.
No vault/keychain, encryption, approval workflow, or authenticated actor exists.
Consult the project's README security limitations before use.
