create policy "select own items"
on public.items
for select
to authenticated
using (owner_id = auth.uid());

create policy "insert own items"
on public.items
for insert
to authenticated
with check (owner_id = auth.uid());

create policy "update own items"
on public.items
for update
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create policy "delete own items"
on public.items
for delete
to authenticated
using (owner_id = auth.uid());
