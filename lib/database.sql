-- Create tables
create table
  public.bookmarks (
    id uuid not null default gen_random_uuid (),
    entry_id integer not null,
    time integer not null,
    owner_id uuid not null,
    constraint bookmarks_pkey primary key (id),
    constraint bookmarks_owner_id_fkey foreign key (owner_id) references auth.users (id) on delete cascade
  ) tablespace pg_default;

create table
  public.history (
    id uuid not null default gen_random_uuid (),
    entry_id integer not null,
    time integer not null, 
    owner_id uuid not null,
    constraint history_pkey primary key (id),
    constraint history_owner_id_fkey foreign key (owner_id) references auth.users (id) on delete cascade
  ) tablespace pg_default;

-- Create publication for powersync
create publication powersync for table bookmarks, history;

-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/auth/row-level-security for more details.
alter table public.bookmarks
  enable row level security;

alter table public.history
  enable row level security;

create policy "owned bookmarks" on public.bookmarks for ALL using (
  auth.uid() = owner_id
);

create policy "owned history" on public.history for ALL using (
  auth.uid() = owner_id
);