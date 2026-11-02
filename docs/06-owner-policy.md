# Let the owner through

Apply [supabase/migrations/20261102002000_owner_items_policies.sql](../supabase/migrations/20261102002000_owner_items_policies.sql).

`auth.uid()` is the id of the signed-in account. It is read from the session token. For this check that id was Ada’s, `11111111-1111-1111-1111-111111111111`.

## The select rule

```sql
create policy "select own items"
on public.items
for select
to authenticated
using (owner_id = auth.uid());
```

- `"select own items"` is the rule’s name.
- `on public.items` is the table.
- `for select` is the command this rule covers. The other commands in the file are `insert`, `update`, and `delete`.
- `to authenticated` is the login. `anon` is not listed, so `anon` still has no rule.
- `using (owner_id = auth.uid())` keeps a row when its `owner_id` is the signed-in account.

`using` tests rows already in the table. `select`, `update`, and `delete` use it. `with check` tests a row being written. `insert` and `update` use it. `update` has both: `using` finds the row, and `with check` tests the row after the change.

## How the caller was set

These checks did not sign Ada in. No session token was created, and the Data API was not called.

`auth.uid()` reads a setting named `request.jwt.claim.sub`. The check wrote an account id into that setting, then switched the login to `authenticated` for the rest of the same transaction. `set_config(..., true)` keeps the setting until the transaction ends. `set local role` does the same for the login.

Ada’s id is the `id` inserted in [supabase/seed.sql](../supabase/seed.sql):

`11111111-1111-1111-1111-111111111111`

The other id is not an account. It is only a different value in that same setting:

`33333333-3333-3333-3333-333333333333`

The SQL editor starts as `postgres`, and that role skips row level security. A plain `select` there shows every row. Run each block below as one script. Run line by line and the `set local role` is gone before the `select`.

Open the SQL editor and run:

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;
select name, sku, quantity
from public.items
order by name;

rollback;
```

That returns the Notebook and the Pen.

```sql
begin;

select set_config('request.jwt.claim.sub', '33333333-3333-3333-3333-333333333333', true);
set local role authenticated;
select count(*)::int as visible_rows
from public.items;

rollback;
```

`visible_rows` is 0.

```sql
begin;

set local role anon;
select count(*)::int as visible_rows
from public.items;

rollback;
```

`visible_rows` is 0.

## The two inserts

Ada’s insert was this script. It has already been run, so the Pen row is in the table. Running it again fails the unique rule on `(owner_id, sku)`.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;
insert into public.items (owner_id, name, sku, quantity)
values ('11111111-1111-1111-1111-111111111111', 'Pen', 'PN-1', 1)
returning name, sku, quantity;

commit;
```

The first run returned `Pen`, `PN-1`, `1`.

The other caller tried to insert a row whose `owner_id` is Ada’s id. That row was rejected. This one is safe to run again:

```sql
begin;

select set_config('request.jwt.claim.sub', '33333333-3333-3333-3333-333333333333', true);
set local role authenticated;
insert into public.items (owner_id, name, sku, quantity)
values ('11111111-1111-1111-1111-111111111111', 'Stolen', 'ST-1', 1)
returning name;

rollback;
```

The error is `42501`, `new row violates row-level security policy for table "items"`. `with check (owner_id = auth.uid())` failed: the written `owner_id` is Ada, and `auth.uid()` is `33333333-3333-3333-3333-333333333333`.
