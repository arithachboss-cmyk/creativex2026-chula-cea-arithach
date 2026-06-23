-- CreativEX2026 Knowledge Platform
-- Run this in Supabase SQL Editor or any PostgreSQL database.

create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  full_name text not null,
  role text not null default 'learner'
    check (role in ('learner', 'instructor', 'executive', 'staff', 'admin')),
  organization text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.executives (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  position text not null,
  focus text not null,
  image_url text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.resources (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  summary text not null,
  category text not null
    check (category in ('creative', 'business', 'tech', 'governance', 'culture', 'tourism', 'investment', 'nation_brand')),
  file_url text,
  file_type text,
  owner_id uuid references public.profiles(id) on delete set null,
  status text not null default 'pending'
    check (status in ('draft', 'pending', 'published', 'approved', 'rejected', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.portfolios (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  detail text not null,
  owner_id uuid references public.profiles(id) on delete set null,
  cover_url text,
  status text not null default 'pending'
    check (status in ('draft', 'pending', 'reviewing', 'approved', 'featured', 'rejected', 'archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.learning_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  event_type text not null
    check (event_type in ('read_resource', 'upload_resource', 'create_portfolio', 'comment', 'approved_work', 'manual_adjustment')),
  points integer not null default 0,
  reference_type text,
  reference_id uuid,
  created_at timestamptz not null default now()
);

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  target_type text not null check (target_type in ('resource', 'portfolio')),
  target_id uuid not null,
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.badges (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  required_points integer not null default 0,
  description text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  target_type text,
  target_id uuid,
  created_at timestamptz not null default now()
);

create or replace view public.profile_scores as
select
  p.id,
  p.full_name,
  p.role,
  coalesce(sum(e.points), 0)::integer as total_points,
  count(e.id)::integer as activity_count
from public.profiles p
left join public.learning_events e on e.user_id = p.id
group by p.id, p.full_name, p.role;

create index if not exists resources_status_created_idx on public.resources(status, created_at desc);
create index if not exists portfolios_status_created_idx on public.portfolios(status, created_at desc);
create index if not exists learning_events_user_created_idx on public.learning_events(user_id, created_at desc);

alter table public.profiles enable row level security;
alter table public.executives enable row level security;
alter table public.resources enable row level security;
alter table public.portfolios enable row level security;
alter table public.learning_events enable row level security;
alter table public.comments enable row level security;
alter table public.badges enable row level security;
alter table public.audit_logs enable row level security;

create policy "Public can read published resources"
  on public.resources for select
  using (status in ('published', 'approved'));

create policy "Public can read approved portfolios"
  on public.portfolios for select
  using (status in ('approved', 'featured'));

create policy "Public can read executives"
  on public.executives for select
  using (true);

create policy "Public can read badges"
  on public.badges for select
  using (true);

create policy "Members can read own profile"
  on public.profiles for select
  using (auth.uid() = auth_user_id);

create policy "Members can update own profile"
  on public.profiles for update
  using (auth.uid() = auth_user_id)
  with check (auth.uid() = auth_user_id);

create policy "Members can create own resources"
  on public.resources for insert
  with check (
    owner_id in (select id from public.profiles where auth_user_id = auth.uid())
  );

create policy "Members can create own portfolios"
  on public.portfolios for insert
  with check (
    owner_id in (select id from public.profiles where auth_user_id = auth.uid())
  );

create policy "Members can read own learning events"
  on public.learning_events for select
  using (
    user_id in (select id from public.profiles where auth_user_id = auth.uid())
  );

create policy "Members can create own comments"
  on public.comments for insert
  with check (
    user_id in (select id from public.profiles where auth_user_id = auth.uid())
  );

insert into public.badges (name, required_points, description)
values
  ('เริ่มต้น', 0, 'เริ่มบันทึกเส้นทางการเรียนรู้'),
  ('กำลังเติบโต', 60, 'มีส่วนร่วมกับกิจกรรมและผลงาน'),
  ('นักแบ่งปัน', 120, 'แบ่งปันความรู้ให้ชุมชนอย่างต่อเนื่อง'),
  ('ผู้นำการเรียนรู้', 240, 'สร้างผลลัพธ์และช่วยขับเคลื่อนชุมชน')
on conflict do nothing;
