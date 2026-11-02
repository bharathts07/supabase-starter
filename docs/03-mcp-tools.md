# What the MCP server can do

`.cursor/mcp.json` uses `https://mcp.supabase.com/mcp`. That URL has no `read_only=true`.

`execute_sql` runs as the `postgres` role. That role bypasses row level security. It can `INSERT`, `UPDATE`, and `DELETE` rows. `apply_migration` changes the schema and can `DROP` tables. A destructive statement may ask for confirmation before it runs.

A read-only connection uses `https://mcp.supabase.com/mcp?read_only=true`.

## Account

The Supabase account around the database: organizations and projects.

`list_organizations`, `get_organization`, `list_projects`, `get_project`, `create_project`, `pause_project`, `restore_project`, `get_cost`, `confirm_cost`

Creating a project or a branch quotes a cost first.

## Database

The tables, rows, and schema inside a project.

`list_tables`, `list_extensions`, `list_migrations`, `execute_sql`, `apply_migration`

`execute_sql` runs queries and changes rows. `apply_migration` changes the schema and records the change as a migration.

## Project

Facts about one project and the doors onto it.

`get_project_url`, `get_publishable_keys`, `generate_typescript_types`, `get_advisors`, `query_logs`

The publishable key is readable here. The secret key and the database password are not.

## Edge Functions

JavaScript functions deployed beside the database.

`list_edge_functions`, `get_edge_function`, `deploy_edge_function`

## Branching

A separate copy of a project for trying changes.

`list_branches`, `create_branch`, `delete_branch`, `merge_branch`, `rebase_branch`, `reset_branch`

These need a paid plan.

## Docs

Search the Supabase documentation.

`search_docs`

Storage tools are absent from this connection.
