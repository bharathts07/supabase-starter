# Two owners

Run [supabase/bea.sql](../supabase/bea.sql) after Ada can sign in.

That adds `bea@inventory.test` with the password `bea-password`, and one item owned by Bea:

| name | sku | quantity |
| --- | --- | --- |
| Stapler | SP-1 | 2 |

Ada still owns the Notebook and the Pen. The same `GET /rest/v1/items` call returns a different list for each access token, because each policy compares `owner_id` with `auth.uid()`.

| Caller | Rows |
| --- | --- |
| Visitor, publishable key | none |
| Ada | Notebook, Pen |
| Bea | Stapler |

[browser/index.html](../browser/index.html) signs in as both and shows the three lists.

## SQL editor

The SQL editor starts as `postgres`, which skips row level security. A plain `select` shows every row. These scripts set the same caller the page sets with an access token. Run each block as one script. `rollback` ends the transaction, so the role switch does not stick.

Ada’s id is `11111111-1111-1111-1111-111111111111`. This returns the Notebook and the Pen.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;
select name, sku, quantity
from public.items
order by name;

rollback;
```

Bea’s id is `44444444-4444-4444-4444-444444444444`. This returns the Stapler.

```sql
begin;

select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);
set local role authenticated;
select name, sku, quantity
from public.items
order by name;

rollback;
```

The visitor is `anon`. `visible_rows` is 0.

```sql
begin;

set local role anon;
select count(*)::int as visible_rows
from public.items;

rollback;
```

`set local role anon` switches the login for the rest of that transaction. Without that line, the `select` stays on `postgres`. `postgres` skips row level security, so the same `select` returns the Notebook, the Pen, and the Stapler. `begin` and `rollback` do not hide rows. They only limit how long the role switch lasts.
