create table public.items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users (id) on delete cascade,
  name text not null,
  sku text not null,
  quantity integer not null default 0 check (quantity >= 0),
  created_at timestamptz not null default now(),
  unique (owner_id, sku)
);

alter table public.items enable row level security;
