insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change,
  raw_app_meta_data
)
select
  '00000000-0000-0000-0000-000000000000',
  '44444444-4444-4444-4444-444444444444',
  'authenticated',
  'authenticated',
  'bea@inventory.test',
  extensions.crypt('bea-password', extensions.gen_salt('bf')),
  now(),
  now(),
  now(),
  '',
  '',
  '',
  '',
  '{"provider":"email","providers":["email"]}'::jsonb
where not exists (
  select 1 from auth.users where id = '44444444-4444-4444-4444-444444444444'
);

insert into auth.identities (
  provider_id,
  user_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
)
select
  '44444444-4444-4444-4444-444444444444',
  '44444444-4444-4444-4444-444444444444',
  '{"sub":"44444444-4444-4444-4444-444444444444","email":"bea@inventory.test","email_verified":true}'::jsonb,
  'email',
  now(),
  now(),
  now()
where not exists (
  select 1
  from auth.identities
  where user_id = '44444444-4444-4444-4444-444444444444'
    and provider = 'email'
);

insert into public.items (id, owner_id, name, sku, quantity)
select
  '55555555-5555-5555-5555-555555555555',
  '44444444-4444-4444-4444-444444444444',
  'Stapler',
  'SP-1',
  2
where not exists (
  select 1 from public.items where id = '55555555-5555-5555-5555-555555555555'
);
