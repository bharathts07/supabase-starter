# Sign in, then ask again

Run [supabase/ada-signin.sql](../supabase/ada-signin.sql) after [supabase/seed.sql](../supabase/seed.sql).

That gives `ada@inventory.test` the password `ada-password` and an email identity. Auth refuses a password sign-in when `created_at` is empty, so the script fills it.

## Sign in

```bash
curl -s "https://bxuwbytxaoftlsurzblj.supabase.co/auth/v1/token?grant_type=password" \
  -H "apikey: sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af" \
  -H "Content-Type: application/json" \
  -d '{"email":"ada@inventory.test","password":"ada-password"}'
```

The response includes `access_token`. That token is Ada’s session. Its user id is `11111111-1111-1111-1111-111111111111`. Copy `access_token` for the next call. It expires, so sign in again when a later call is rejected.

`apikey` stays the publishable key. `Authorization` changes from that key to the access token. The Data API then sets the login to `authenticated` and sets `request.jwt.claim.sub` to Ada’s id. Those are the two settings the SQL editor set by hand in [docs/06-owner-policy.md](06-owner-policy.md).

## Ask for the rows

Publishable key only, from [docs/05-no-policies.md](05-no-policies.md). The response is `[]` with HTTP 200.

Ada’s session:

```bash
curl "https://bxuwbytxaoftlsurzblj.supabase.co/rest/v1/items?select=name,sku,quantity&order=name.asc" \
  -H "apikey: sb_publishable_zQKxYLKXuEnPG4OCJHZSYg_aT6R71Af" \
  -H "Authorization: Bearer <access_token>"
```

The response is HTTP 200:

```json
[
  {"name":"Notebook","sku":"NB-1","quantity":4},
  {"name":"Pen","sku":"PN-1","quantity":1}
]
```

Same address, same `apikey`. The access token is what lets the owner policies match Ada.

[browser/index.html](../browser/index.html) runs these two calls and keeps the token. See [docs/08-browser.md](08-browser.md).
