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

## What the check returned

| Caller | Result |
| --- | --- |
| `anon` | 0 rows |
| Ada, signed in | the Notebook row |
| A different signed-in id | 0 rows |

Ada’s insert of a Pen, sku `PN-1`, quantity 1, returned that new row. An insert of a row owned by Ada, sent as the other id, was rejected with `42501`, `new row violates row-level security policy for table "items"`.
