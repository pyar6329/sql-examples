-- +migrate Up
create table posts (
  id bigserial not null primary key,
  title text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index on posts (created_at desc);
create index on posts (updated_at desc);

-- +migrate Down
drop table posts;
