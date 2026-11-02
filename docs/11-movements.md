# Movements

Apply [supabase/migrations/20261102032800_create_movements.sql](../supabase/migrations/20261102032800_create_movements.sql).

[browser/index.html](../browser/index.html) asks for these rows with the same button as the items. Ada's list is `-1` on the Notebook. Bea's list is empty. The visitor's list is empty.

A movement is a recorded change to an item. The row stores `item_id` and `quantity_change`. It does not store an owner, and it does not change `items.quantity`.

`item_id uuid not null references public.items (id) on delete cascade` means the value must be an `items.id`. Deleting that item deletes its movements.

`quantity_change integer not null check (quantity_change <> 0)` means the number is required and cannot be zero.

The policy does not compare a column on `movements` with `auth.uid()`. It looks up the item and compares that item's `owner_id`.

```sql
exists (
  select 1
  from public.items
  where items.id = movements.item_id
    and items.owner_id = auth.uid()
)
```

`exists` is true when that lookup finds a row. `select` uses this test in `using`. `insert` uses it in `with check`. There is no update or delete policy, so a signed-in person cannot change or remove a movement.

## SQL editor

Run each block as one script. The Notebook's id is `22222222-2222-2222-2222-222222222222`.

Ada sees one movement, Notebook, quantity change `-1`. That insert has already been run. Running it again adds another row.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;
select i.name, m.quantity_change
from public.movements m
join public.items i on i.id = m.item_id
order by i.name;

rollback;
```

Bea sees `visible_rows` 0.

```sql
begin;

select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);
set local role authenticated;
select count(*)::int as visible_rows
from public.movements;

rollback;
```

Bea's insert of a movement on the Notebook is safe to run again. It is rejected with `42501`, `new row violates row-level security policy for table "movements"`.

```sql
begin;

select set_config('request.jwt.claim.sub', '44444444-4444-4444-4444-444444444444', true);
set local role authenticated;
insert into public.movements (item_id, quantity_change)
values ('22222222-2222-2222-2222-222222222222', -1)
returning item_id;

rollback;
```
