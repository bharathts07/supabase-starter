# Ask for the row

Run [supabase/seed.sql](../supabase/seed.sql) after the items table exists.

That adds one account, `ada@inventory.test`, and one item owned by that account:

| name | sku | quantity |
| --- | --- | --- |
| Notebook | NB-1 | 4 |

## Data API

Enabling Data API at project creation starts an HTTPS service in front of the database. Each table in `public` gets an address:

`https://<project-ref>.supabase.co/rest/v1/<table>`

`/rest/v1/` is that service. `items` is the `public.items` table. The project ref is the subdomain from the project landing page.

For this project the ref is `bxuwbytxaoftlsurzblj`, so the items address is:

`https://bxuwbytxaoftlsurzblj.supabase.co/rest/v1/items`

## The call that was made

The publishable key was read with the MCP tool `get_publishable_keys` for project `bxuwbytxaoftlsurzblj`. The key used is named `default`:

`sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af`

The same value is on Project Settings → API Keys. The request was sent with `curl` from a terminal:

```bash
curl "https://bxuwbytxaoftlsurzblj.supabase.co/rest/v1/items?select=id,name,sku,quantity" \
  -H "apikey: sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af" \
  -H "Authorization: Bearer sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af"
```

- `apikey` names which project key is calling.
- `Authorization` carries who the caller is. This request has no signed-in person, so the publishable key is sent there too. The API treats the caller as `anon`.
- A signed-in person sends their session token in `Authorization` instead. That caller is `authenticated`.

The response was `[]` with HTTP 200. The call reached the table, and the row was left out.

The same rows read as `postgres` include the Notebook. `anon` and `authenticated` receive no rows. Row level security is on, and the policy list is empty.

## Keys

| Key | Where it is used | Login the API uses |
| --- | --- | --- |
| Publishable key `sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af` | The `curl` above | `anon`, until a session token is sent |
| Secret key | A server | `service_role`, which skips row level security |

The secret key was not read and is not written here. `get_publishable_keys` also returned an older anon key, a long JWT named `anon`. That key was not used.

## Insert

The insert used the same URL, the same publishable key, and the same two headers:

```bash
curl -X POST "https://bxuwbytxaoftlsurzblj.supabase.co/rest/v1/items" \
  -H "apikey: sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af" \
  -H "Authorization: Bearer sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{"owner_id":"11111111-1111-1111-1111-111111111111","name":"Pen","sku":"PN-1","quantity":1}'
```

The response is HTTP 401:

```json
{"code":"42501","message":"new row violates row-level security policy for table \"items\""}
```

## What this shows

The Notebook row is in the table. The publishable-key read still returned `[]` with HTTP 200. A successful response can mean the caller was shown no rows.

`anon` is allowed to query `public.items`. That permission is the grant. Row level security is on, and the policy list is empty, so the query is given nothing. `postgres` sees the Notebook because that role skips the row check.

A read hides the rows. A write is rejected out loud, with HTTP 401.

`owner_id` is set to Ada’s account, and that fact changed nothing. No policy looks at it yet, so `anon` and `authenticated` both receive no rows.
