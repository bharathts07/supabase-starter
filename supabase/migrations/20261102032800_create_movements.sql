create table public.movements (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.items (id) on delete cascade,
  quantity_change integer not null check (quantity_change <> 0),
  created_at timestamptz not null default now()
);

alter table public.movements enable row level security;

create policy "select own movements"
on public.movements
for select
to authenticated
using (
  exists (
    select 1
    from public.items
    where items.id = movements.item_id
      and items.owner_id = auth.uid()
  )
);

create policy "insert own movements"
on public.movements
for insert
to authenticated
with check (
  exists (
    select 1
    from public.items
    where items.id = movements.item_id
      and items.owner_id = auth.uid()
  )
);
