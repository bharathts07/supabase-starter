# Update the quantity

`items.quantity` is the current number on hand. Both scripts run this same change on the Notebook, whose id is `22222222-2222-2222-2222-222222222222`. The stored quantity is 4.

The learning is what an update does when the caller cannot see the row. Ada can see the Notebook, so her update changes 4 to 3. Bea cannot see it, so her update changes nothing and raises no error. The quantity stays 4.

The update lines are the same. The shape around them is different so each result is visible. Ada's script uses `returning`, and the changed row is printed. Bea's script would print nothing with `returning`, because no row changed. The SQL editor then looks blank. `with updated as (...)` counts the rows that came back, so the editor prints `updated_rows` 0.

`rollback` undoes the change. Replace Ada's `rollback` with `commit` to keep 3.

The update policy is in [supabase/migrations/20261102002000_owner_items_policies.sql](../supabase/migrations/20261102002000_owner_items_policies.sql). `using` decides which existing rows the statement can touch. `with check` decides whether the row is allowed after the change. This statement changes `quantity` and leaves the owner as it was.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;
update public.items
set quantity = quantity - 1
where id = '22222222-2222-2222-2222-222222222222'
returning name, quantity;

rollback;
```

Bea runs the same update. The count is there so a change of no rows still prints a result.

```sql
begin;

select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);
set local role authenticated;
with updated as (
  update public.items
  set quantity = quantity - 1
  where id = '22222222-2222-2222-2222-222222222222'
  returning 1
)
select count(*)::int as updated_rows
from updated;

rollback;
```
