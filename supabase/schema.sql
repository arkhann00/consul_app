-- Consul app — tables aligned with Flutter models (run in Supabase SQL Editor).

-- Doctors
create table if not exists public.doctors (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  first_name text not null,
  last_name text not null,
  patronymic text,
  avatar_url text,
  position text,
  description text
);

-- News
create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  title text not null,
  text text not null,
  image_url text
);

-- User profile (app User model). Prefer linking to auth: id = auth.users.id
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  first_name text not null,
  second_name text not null,
  is_admin boolean not null default false
);

-- Optional: tie profiles to Supabase Auth (uncomment after you use Auth)
-- alter table public.profiles
--   drop constraint if exists profiles_id_fkey;
-- alter table public.profiles
--   add constraint profiles_id_fkey foreign key (id) references auth.users (id) on delete cascade;

alter table public.doctors enable row level security;
alter table public.news enable row level security;
alter table public.profiles enable row level security;

drop policy if exists "Anyone can read doctors" on public.doctors;
create policy "Anyone can read doctors" on public.doctors for select using (true);

drop policy if exists "Anyone can read news" on public.news;
create policy "Anyone can read news" on public.news for select using (true);

-- Profiles: readable only when logged in and row id matches JWT sub
drop policy if exists "Users read own profile" on public.profiles;
create policy "Users read own profile" on public.profiles for select using (auth.uid() = id);

drop policy if exists "Users update own profile" on public.profiles;
create policy "Users update own profile" on public.profiles for update using (auth.uid() = id);

-- Storage: create buckets `news_image` and `doctor_avatar` in Dashboard (public read).
drop policy if exists "Public read news_image" on storage.objects;
create policy "Public read news_image" on storage.objects for select using (bucket_id = 'news_image');

drop policy if exists "Public read doctor_avatar" on storage.objects;
create policy "Public read doctor_avatar" on storage.objects for select using (bucket_id = 'doctor_avatar');
