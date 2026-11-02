# service_role

`anon` and `authenticated` are the two logins on the page. `service_role` is the third. The secret key on Project Settings → API Keys is this login. The Data API uses it when `Authorization` carries the secret key. That key stays out of this repo.

`service_role` skips row level security. The policies are not consulted. The select returns every row.

The SQL editor can switch to that login without the secret key. Run this as one script:

```sql
begin;

set local role service_role;
select current_user, name, sku, quantity
from public.items
order by name;

rollback;
```

`current_user` is `service_role`. The rows are the Notebook, the Pen, and the Stapler.

Without `set local role service_role`, `current_user` stays `postgres`. The row list is the same three, because `postgres` also skips row level security. The line is what makes the caller `service_role`. `begin` and `rollback` only limit how long that switch lasts.
