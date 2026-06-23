create extension if not exists "pgcrypto";

create type public.platform_role as enum (
  'public_viewer',
  'researcher',
  'project_manager',
  'institution_partner',
  'executive',
  'admin'
);

create type public.scent_category as enum (
  'cultural',
  'city',
  'institutional',
  'wellness',
  'heritage',
  'hospitality'
);

create type public.review_status as enum (
  'draft',
  'in_review',
  'approved',
  'published',
  'archived',
  'rejected'
);

create table public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  organization_type text not null,
  country text not null default 'Thailand',
  city text,
  created_at timestamptz not null default now()
);

create table public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  organization_id uuid references public.organizations(id) on delete set null,
  full_name text not null,
  role public.platform_role not null default 'public_viewer',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.scents (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  category public.scent_category not null,
  story text not null,
  emotional_impact text[] not null default '{}',
  cultural_significance text not null,
  ingredients text[] not null default '{}',
  use_cases text[] not null default '{}',
  safety_notes text,
  evidence_grade text check (evidence_grade in ('A', 'B', 'C', 'D', 'ungraded')) default 'ungraded',
  status public.review_status not null default 'draft',
  created_by uuid references public.profiles(id) on delete set null,
  reviewed_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.research_references (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  authors text,
  publication_year integer,
  source_url text,
  source_type text not null,
  summary text,
  evidence_grade text check (evidence_grade in ('A', 'B', 'C', 'D', 'ungraded')) default 'ungraded',
  storage_path text,
  ai_retrieval_allowed boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.scent_research_references (
  scent_id uuid not null references public.scents(id) on delete cascade,
  research_reference_id uuid not null references public.research_references(id) on delete cascade,
  relationship_note text,
  primary key (scent_id, research_reference_id)
);

create table public.institutional_frameworks (
  id uuid primary key default gen_random_uuid(),
  institution_type text not null,
  title text not null,
  strategic_objectives text[] not null default '{}',
  psychological_goals text[] not null default '{}',
  experience_goals text[] not null default '{}',
  scent_profile_ids uuid[] not null default '{}',
  measurement_kpis text[] not null default '{}',
  deployment_guidelines text not null,
  status public.review_status not null default 'draft',
  created_at timestamptz not null default now()
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  project_type text not null,
  organization_id uuid references public.organizations(id) on delete set null,
  city text,
  country text not null default 'Thailand',
  status text not null default 'planning',
  start_date date,
  end_date date,
  budget_thb numeric(14,2),
  objectives text[] not null default '{}',
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.deployments (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  scent_id uuid references public.scents(id) on delete set null,
  zone_name text not null,
  device_type text,
  intensity_level integer check (intensity_level between 1 and 10),
  deployment_start timestamptz,
  deployment_end timestamptz,
  operational_notes text,
  created_at timestamptz not null default now()
);

create table public.kpi_definitions (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text not null,
  measurement_method text not null,
  unit text not null,
  created_at timestamptz not null default now()
);

create table public.kpi_measurements (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  kpi_definition_id uuid not null references public.kpi_definitions(id) on delete cascade,
  phase text not null check (phase in ('baseline', 'midpoint', 'post', 'follow_up')),
  value numeric(12,4) not null,
  sample_size integer,
  measurement_date date not null default current_date,
  notes text,
  created_at timestamptz not null default now()
);

create table public.ai_agents (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  responsibilities text[] not null default '{}',
  guardrails text[] not null default '{}',
  active boolean not null default true
);

create table public.ai_agent_runs (
  id uuid primary key default gen_random_uuid(),
  agent_id uuid not null references public.ai_agents(id) on delete cascade,
  project_id uuid references public.projects(id) on delete set null,
  requested_by uuid references public.profiles(id) on delete set null,
  prompt text not null,
  output text,
  source_ids uuid[] not null default '{}',
  review_status public.review_status not null default 'draft',
  created_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references public.projects(id) on delete set null,
  report_type text not null,
  title text not null,
  body text not null,
  storage_path text,
  status public.review_status not null default 'draft',
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.governance_reviews (
  id uuid primary key default gen_random_uuid(),
  target_type text not null,
  target_id uuid not null,
  review_board text not null,
  decision text not null check (decision in ('approved', 'changes_requested', 'rejected')),
  notes text,
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz not null default now()
);

create index scents_category_status_idx on public.scents(category, status);
create index projects_status_idx on public.projects(status);
create index kpi_measurements_project_idx on public.kpi_measurements(project_id, measurement_date);
create index ai_agent_runs_project_idx on public.ai_agent_runs(project_id, created_at desc);

alter table public.organizations enable row level security;
alter table public.profiles enable row level security;
alter table public.scents enable row level security;
alter table public.research_references enable row level security;
alter table public.scent_research_references enable row level security;
alter table public.institutional_frameworks enable row level security;
alter table public.projects enable row level security;
alter table public.deployments enable row level security;
alter table public.kpi_definitions enable row level security;
alter table public.kpi_measurements enable row level security;
alter table public.ai_agents enable row level security;
alter table public.ai_agent_runs enable row level security;
alter table public.reports enable row level security;
alter table public.governance_reviews enable row level security;

create policy "Public can read published scents"
  on public.scents for select
  using (status = 'published');

create policy "Public can read published frameworks"
  on public.institutional_frameworks for select
  using (status = 'published');

create policy "Authenticated users can read kpi definitions"
  on public.kpi_definitions for select
  using (auth.role() = 'authenticated');

create policy "Authenticated users can read active agents"
  on public.ai_agents for select
  using (auth.role() = 'authenticated' and active = true);

insert into public.kpi_definitions (name, description, measurement_method, unit)
values
  ('Satisfaction Score', 'Overall visitor or citizen satisfaction.', 'Survey average', 'score_1_5'),
  ('Trust Score', 'Perceived trust in the institution or place.', 'Survey average', 'score_1_5'),
  ('Recall Score', 'Ability to remember scent and associated identity.', 'Aided and unaided recall survey', 'percentage'),
  ('Employee Engagement', 'Staff acceptance and engagement with the deployment.', 'Staff pulse survey', 'score_1_5'),
  ('Economic Value Created', 'Estimated project, licensing, uplift, and local economic value.', 'Financial model', 'THB')
on conflict (name) do nothing;

insert into public.ai_agents (code, name, responsibilities, guardrails)
values
  ('research_agent', 'Research Agent', array['Research scent science', 'Gather global case studies', 'Generate reports'], array['Cite sources', 'Use approved references', 'No unsupported medical claims']),
  ('city_branding_agent', 'City Branding Agent', array['Analyze city identity', 'Recommend scent identity'], array['Respect local culture', 'Use city data', 'Flag uncertainty']),
  ('institutional_design_agent', 'Institutional Design Agent', array['Design institutional scent concepts'], array['Follow safety guidelines', 'Avoid sensitive zones', 'Require human review']),
  ('creative_economy_agent', 'Creative Economy Agent', array['Find business opportunities', 'Generate economic impact reports'], array['Separate assumptions from facts', 'Use approved financial model']),
  ('executive_brief_agent', 'Executive Brief Agent', array['Generate board presentations', 'Generate policy briefs'], array['Use approved metrics', 'Show citations', 'Label draft status'])
on conflict (code) do nothing;

