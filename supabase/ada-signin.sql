update auth.users
set
  instance_id = '00000000-0000-0000-0000-000000000000',
  encrypted_password = extensions.crypt('ada-password', extensions.gen_salt('bf')),
  email_confirmed_at = coalesce(email_confirmed_at, now()),
  created_at = coalesce(created_at, now()),
  updated_at = coalesce(updated_at, now()),
  confirmation_token = coalesce(confirmation_token, ''),
  recovery_token = coalesce(recovery_token, ''),
  email_change_token_new = coalesce(email_change_token_new, ''),
  email_change = coalesce(email_change, ''),
  raw_app_meta_data = '{"provider":"email","providers":["email"]}'::jsonb
where id = '11111111-1111-1111-1111-111111111111';

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
  '11111111-1111-1111-1111-111111111111',
  '11111111-1111-1111-1111-111111111111',
  '{"sub":"11111111-1111-1111-1111-111111111111","email":"ada@inventory.test","email_verified":true}'::jsonb,
  'email',
  now(),
  now(),
  now()
where not exists (
  select 1
  from auth.identities
  where user_id = '11111111-1111-1111-1111-111111111111'
    and provider = 'email'
);
