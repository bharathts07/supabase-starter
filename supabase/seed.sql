insert into auth.users (id, aud, role, email)
values (
  '11111111-1111-1111-1111-111111111111',
  'authenticated',
  'authenticated',
  'ada@inventory.test'
);

insert into public.items (id, owner_id, name, sku, quantity)
values (
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111',
  'Notebook',
  'NB-1',
  4
);
