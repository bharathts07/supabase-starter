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
