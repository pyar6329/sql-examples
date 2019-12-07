create table if not exists posts (
  id text not null primary key,
  number serial not null,
  created timestamptz not null default now()
);
create unique index if not exists posts_number_key on posts (number);
create index if not exists posts_created_id_idx on posts (created, id);
