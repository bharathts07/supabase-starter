# Still to do

Steps 1–12 are written. The next session starts at item 1 below. Do one item, write its note, then stop.

The Notebook is `22222222-2222-2222-2222-222222222222`. Its quantity is 4. One movement already exists: `-1` on the Notebook. Ada is `11111111-1111-1111-1111-111111111111`. Bea is `44444444-4444-4444-4444-444444444444`.

When an item is done, add its note to [README.md](../README.md) and say so here.

## 1. The number and the history are two separate writes

**Ada subtracts one** changes `items.quantity` and writes nothing in `movements`. Inserting a movement records the change and leaves the quantity alone. Two requests can leave one of those writes behind. The number on hand and the history then disagree. The Notebook already shows a mild version: a `-1` movement exists, and the quantity is still 4.

The note names that gap. It does not add a function yet.

## 2. One function does both writes

A function is a named piece of SQL stored in the database. The page calls it with `POST /rest/v1/rpc/adjust_quantity`, passing the Notebook id and `-1`. That one call changes the quantity and inserts the movement. If the second write is rejected, the first is undone too. After a successful call, **Ask all three ways** shows the new quantity and the new `-1`.

The SQL editor script rolls back, so a re-run leaves the stored quantity at 4. The page button keeps the change. Restore the quantity to 4 and remove the extra movement after checking the button.

## 3. The function still uses the signed-in person

`security invoker` is the normal setting. The function runs as Ada or Bea, so the owner policies still decide the rows. Ada's call changes the Notebook and adds a movement. Bea's call matches no item row, the function stops with an error, and no movement is inserted. The earlier `PATCH` answered HTTP 200 and `[]`. This call says it failed.

## 4. Permission to call the function is its own switch

A new function in `public` can be called by the visitor as well as by a signed-in person. Revoke that permission from the visitor and leave it for `authenticated`. A visitor who posts to `/rest/v1/rpc/adjust_quantity` is turned away before any row is considered.

## 5. A function that skips the row rules

This is the `service_role` revisit. `security definer` means the function runs as its owner, and row policies do not apply to what it does. A signed-in person can call it and receive rows they could not read with a normal request. It stays last because it turns the earlier rules off for that one call.

Realtime, Storage, and Edge Functions stay out of this list.
