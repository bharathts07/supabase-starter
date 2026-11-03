# The number and the history

`items.quantity` is the number on hand. A row in `movements` is a record of a change. Nothing in the database writes both at once. An update of the Notebook does not insert a movement. An insert into `movements` does not change the quantity.

The Notebook id is `22222222-2222-2222-2222-222222222222`. The stored quantity is 4. One movement already exists, `-1`. Run each block as one script. `rollback` puts that stored state back.

The first script changes the number and leaves the history alone. The result is `quantity` 3 and `movement_rows` 1.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;

update public.items
set quantity = quantity - 1
where id = '22222222-2222-2222-2222-222222222222';

select i.quantity,
       (select count(*)::int from public.movements m where m.item_id = i.id) as movement_rows
from public.items i
where i.id = '22222222-2222-2222-2222-222222222222';

rollback;
```

The second script records another `-1` and leaves the number alone. The result is `quantity` 4 and `movement_rows` 2.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;

insert into public.movements (item_id, quantity_change)
values ('22222222-2222-2222-2222-222222222222', -1);

select i.quantity,
       (select count(*)::int from public.movements m where m.item_id = i.id) as movement_rows
from public.items i
where i.id = '22222222-2222-2222-2222-222222222222';

rollback;
```

On [browser/index.html](../browser/index.html), **Ada subtracts one** is only the first write. It keeps the new quantity and does not add a movement. **Ask all three ways** still shows Ada's original `-1`. The scripts above roll their own change back. The button does not, so leave it unpressed if the stored quantity should stay 4.
