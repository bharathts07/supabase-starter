# Create the items table

Apply [supabase/migrations/20261101234300_create_items.sql](../supabase/migrations/20261101234300_create_items.sql).

`public.items` then has:

- row level security enabled
- no policies
- `select`, `insert`, `update`, and `delete` granted to `anon`, `authenticated`, and `service_role`

The table is empty.

## public

Postgres keeps tables in named groups called schemas. `public` is the group for this app's tables, so the full name of the table is `public.items`. `auth` is a second group Supabase created for sign-in. `auth.users` is the table of accounts in that group.

## owner_id

`owner_id` stores the id of the account an item belongs to. The database rejects an item whose `owner_id` is not a row in `auth.users`.

## anon, authenticated, service_role

Three logins the Data API uses.

| Login | Who | Row level security |
| --- | --- | --- |
| `anon` | A visitor who is not signed in. The publishable key uses this login. | Applies |
| `authenticated` | A person who is signed in. | Applies |
| `service_role` | The secret key. | Bypassed |

A grant lets that login ask the table for rows. Row level security decides which rows come back.

## Row level security, and no policies

Row level security is a per-row check on the table. A policy is one rule in that check. An example rule, not written yet: a signed-in person can read a row when `owner_id` is their own id.

The check is on. The rule list is empty. `anon` and `authenticated` then receive no rows. `service_role` skips the check.
