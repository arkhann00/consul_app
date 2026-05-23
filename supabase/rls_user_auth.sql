-- RLS для таблицы User (имя с заглавной буквы, как в Table Editor).
-- Выполните после того, как таблица public."User" уже существует.

alter table public."User" enable row level security;

drop policy if exists "User select own" on public."User";
create policy "User select own" on public."User"
  for select to authenticated
  using (auth.uid() = id);

drop policy if exists "User insert own" on public."User";
create policy "User insert own" on public."User"
  for insert to authenticated
  with check (auth.uid() = id);

drop policy if exists "User update own" on public."User";
create policy "User update own" on public."User"
  for update to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Сервисные роли (dashboard, SQL) обходят RLS; анонимная вставка в User запрещена.
