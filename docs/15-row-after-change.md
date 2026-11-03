# The row after the change

An update answers two questions.

Is this row yours right now? That test is `using`. Will it still be yours after the change? That test is `with check`.

The update rule on `items` requires both. The signed-in person must already own the row, and the saved row must still name that same person as `owner_id`.

Ada is `11111111-1111-1111-1111-111111111111`. Bea is `44444444-4444-4444-4444-444444444444`. The Notebook is `22222222-2222-2222-2222-222222222222`. The SQL editor starts as `postgres`, which skips these rules. Run each block as one script.

Ada changes the quantity. She owns the Notebook, and she still owns it afterward. The result is the Notebook and Ada's id. `rollback` puts the quantity back.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;

update public.items
set quantity = quantity - 1
where id = '22222222-2222-2222-2222-222222222222'
returning name, owner_id;

rollback;
```

Ada then sets `owner_id` to Bea. The first test passes, because Ada owns the Notebook now. The second test fails, because the saved row would belong to Bea. Postgres rejects the statement with `42501`, `new row violates row-level security policy for table "items"`. The Notebook's owner stays Ada.

```sql
begin;

select set_config('request.jwt.claim.sub', '11111111-1111-1111-1111-111111111111', true);
set local role authenticated;

update public.items
set owner_id = '44444444-4444-4444-4444-444444444444'
where id = '22222222-2222-2222-2222-222222222222'
returning name, owner_id;

rollback;
```

The rule is in [supabase/migrations/20261102002000_owner_items_policies.sql](../supabase/migrations/20261102002000_owner_items_policies.sql). `using` and `with check` are the two lines on `"update own items"`.
