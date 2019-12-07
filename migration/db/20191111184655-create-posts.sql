
-- +migrate Up
create table post_statuses (
  id bigserial not null primary key,
  name text not null
);
create unique index on post_statuses (name);

create table post_qualities (
  id bigserial not null primary key,
  name text not null
);
create unique index on post_qualities (name);

create table content_categories (
  id bigserial not null primary key,
  name text not null
);
create unique index on content_categories (name);

create table posts (
  id bigserial not null primary key,
  title text not null,
  description text not null default '',
  video_url text not null,
  origin_video_url text not null,
  thumbnail_url text not null,
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  post_status_id bigint not null,
  post_quality_id bigint not null,
  content_category_id bigint not null,
  foreign key (post_status_id) references post_statuses(id),
  foreign key (post_quality_id) references post_qualities(id),
  foreign key (content_category_id) references content_categories(id),
  uuid text not null
);
create index on posts (created_at desc);
create index on posts (updated_at desc);
create index on posts (post_status_id);
create index on posts (post_quality_id);
create index on posts (content_category_id);
create unique index on posts (uuid);

-- +migrate Down
drop table posts;
drop table content_categories;
drop table post_qualities;
drop table post_statuses;
