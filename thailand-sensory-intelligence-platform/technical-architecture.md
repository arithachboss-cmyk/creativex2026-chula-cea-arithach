# Technical Architecture

## 1. Stack

- Frontend: Next.js App Router, TypeScript, TailwindCSS.
- Backend: Next.js route handlers and server actions.
- Database: Supabase PostgreSQL.
- Authentication: Supabase Auth with organization-based roles.
- Storage: Supabase Storage for reports, research PDFs, images, and deployment files.
- AI: server-side agent orchestration with retrieval from approved Supabase records.
- Deployment: Vercel for web app, Supabase managed Postgres, scheduled jobs for reports and backups.

## 2. System Architecture

```text
Users
  |-- Executives
  |-- Researchers
  |-- City Partners
  |-- Institutional Partners
  |-- Administrators

Next.js Web App
  |-- Knowledge Library
  |-- Scent Intelligence Database
  |-- Research Repository
  |-- Project Dashboard
  |-- AI Research Assistant
  |-- Impact Evaluation
  |-- Executive Reports

API Layer
  |-- /api/scents
  |-- /api/research
  |-- /api/projects
  |-- /api/evaluations
  |-- /api/agents
  |-- /api/reports

Supabase
  |-- Auth
  |-- PostgreSQL
  |-- Row Level Security
  |-- Storage
  |-- Edge Functions or Cron Jobs

AI Agent Runtime
  |-- Retrieval
  |-- Prompt Policies
  |-- Citation Assembly
  |-- Human Review Queue
  |-- Report Generation
```

## 3. Application Modules

### Knowledge Library

Purpose: publish validated frameworks, cultural notes, policy briefs, case studies, and public-facing knowledge pages.

Key features:

- Category filters.
- Search.
- Evidence-grade badge.
- Citation panel.
- Public/private visibility.
- Review workflow.

### Scent Intelligence Database

Purpose: maintain the national scent archive and deployment-ready scent profiles.

Key features:

- Scent taxonomy.
- Ingredients.
- Emotional impact.
- Cultural significance.
- Use cases.
- Research references.
- Safety notes.
- Deployment history.

### Research Repository

Purpose: store scent science, global case studies, public experience research, and policy evidence.

Key features:

- PDF upload.
- Citation metadata.
- Evidence grade.
- Summary.
- Related scents and projects.
- AI retrieval eligibility.

### Project Dashboard

Purpose: manage city and institutional projects from idea to measurement.

Key features:

- Project status.
- Partner profiles.
- Deployment timeline.
- Budget.
- KPI cards.
- Risk register.
- Report generator.

### AI Research Assistant

Purpose: help teams generate grounded research, scent concepts, city recommendations, and executive reports.

Key features:

- Agent selection.
- Source-restricted retrieval.
- Citation-first output.
- Human review queue.
- Report export.

### Impact Evaluation

Purpose: measure baseline, intervention, and post-deployment impact.

Key features:

- Survey templates.
- KPI definitions.
- Pre/post comparison.
- Trust and recall scores.
- Qualitative insight coding.
- Export to executive report.

### Executive Reports

Purpose: generate board, government, investor, and UNESCO-ready outputs.

Key features:

- Report templates.
- Auto-populated metrics.
- Approval workflow.
- PDF export.
- Version history.

## 4. Role Model

| Role | Capabilities |
|---|---|
| Public Viewer | Read public knowledge pages and published scent records. |
| Researcher | Create research records, propose scent archive entries, run research agent. |
| Project Manager | Create projects, manage deployments, enter KPI data, generate reports. |
| Institution Partner | View assigned projects, submit feedback, access approved reports. |
| Executive | View dashboard and executive reports. |
| Admin | Manage users, governance, taxonomy, approvals, and system settings. |

## 5. API Design

### Scent Archive

```http
GET /api/scents?category=city&status=published
POST /api/scents
GET /api/scents/{id}
PATCH /api/scents/{id}
POST /api/scents/{id}/references
POST /api/scents/{id}/review
```

`POST /api/scents` body:

```json
{
  "name": "Scent Of Trust",
  "category": "institutional",
  "story": "A transparent civic scent for police service spaces.",
  "emotionalImpact": ["calm", "trust", "clarity"],
  "culturalSignificance": "Civic service and Thai public dignity.",
  "ingredients": ["bergamot", "thai basil", "cedar", "clean musk"],
  "useCases": ["police_station", "service_counter"],
  "status": "draft"
}
```

### Research Repository

```http
GET /api/research?evidenceGrade=A
POST /api/research
GET /api/research/{id}
PATCH /api/research/{id}
POST /api/research/{id}/link-scent
```

### Projects

```http
GET /api/projects?status=active
POST /api/projects
GET /api/projects/{id}
PATCH /api/projects/{id}
POST /api/projects/{id}/deployments
POST /api/projects/{id}/risks
```

### Evaluations

```http
GET /api/projects/{id}/evaluations
POST /api/projects/{id}/evaluations
POST /api/evaluations/{id}/responses
GET /api/evaluations/{id}/summary
```

### AI Agents

```http
POST /api/agents/research/run
POST /api/agents/city-branding/run
POST /api/agents/institutional-design/run
POST /api/agents/creative-economy/run
POST /api/agents/executive-brief/run
GET /api/agent-runs/{id}
POST /api/agent-runs/{id}/approve
```

`POST /api/agents/institutional-design/run` body:

```json
{
  "institutionType": "police_station",
  "projectId": "uuid",
  "objective": "Increase citizen trust and improve waiting experience.",
  "constraints": ["low intensity", "no medical claims", "public-sector environment"],
  "requiredOutputs": ["scent_profile", "deployment_guidelines", "kpi_plan"]
}
```

### Reports

```http
GET /api/reports?type=executive
POST /api/reports
GET /api/reports/{id}
POST /api/reports/{id}/export
POST /api/reports/{id}/publish
```

## 6. AI Agent Guardrails

- Agents can only cite approved research records, uploaded references, or explicitly allowed web sources.
- Agent outputs are draft until reviewed by a human.
- Medical, clinical, or therapeutic claims require evidence grade A and safety board approval.
- Cultural stories must not invent community traditions.
- All generated reports store source IDs and prompt metadata.

## 7. UI Wireframes

### Executive Dashboard

```text
+--------------------------------------------------------------+
| Thailand Sensory Intelligence Platform        User / Role     |
+-------------------+------------------------------------------+
| Sidebar           | National Overview                         |
| - Overview        | [Active Projects] [Cities] [Institutions] |
| - Scent Archive   | [Impact Score] [Economic Value]           |
| - Research        |                                          |
| - Projects        | Impact Trend Chart                        |
| - AI Assistant    |                                          |
| - Reports         | Active Project Table                      |
+-------------------+------------------------------------------+
```

### Scent Record

```text
+--------------------------------------------------------------+
| Scent: Scent Of Trust                         Status: Review  |
+--------------------------------------------------------------+
| Story                                                        |
| Emotional Impact     Cultural Significance                   |
| Ingredients          Use Cases                               |
| Research References  Safety Notes                            |
| Deployment History   KPI Results                             |
+--------------------------------------------------------------+
```

### AI Assistant

```text
+--------------------------------------------------------------+
| AI Research Assistant                                        |
+-----------------------------+--------------------------------+
| Agent                       | Request                        |
| ( ) Research Agent          | [Prompt textarea]              |
| ( ) City Branding Agent     | Source Scope: [Approved only]  |
| ( ) Institutional Design    | Output: [Brief] [Report]       |
| ( ) Creative Economy        | [Run Agent]                    |
| ( ) Executive Brief         |                                |
+-----------------------------+--------------------------------+
| Draft Output With Citations                                  |
| Human Review: [Approve] [Request Revision] [Reject]          |
+--------------------------------------------------------------+
```

### Impact Evaluation

```text
+--------------------------------------------------------------+
| Project: Police Station Signature Scent                      |
+--------------------------------------------------------------+
| Baseline Trust   Deployment Trust   Change                   |
| Baseline Recall  Deployment Recall  Change                   |
| Staff Engagement Visitor Satisfaction Complaint Frequency    |
| Survey Responses | Interview Notes | Export Report           |
+--------------------------------------------------------------+
```

## 8. Next.js Folder Structure

```text
app/
  (public)/
    page.tsx
    scents/[slug]/page.tsx
    library/page.tsx
  dashboard/
    page.tsx
    projects/[id]/page.tsx
    reports/page.tsx
  api/
    scents/route.ts
    projects/route.ts
    research/route.ts
    agents/research/run/route.ts
components/
  dashboard/
  scent/
  research/
  reports/
lib/
  supabase/
  auth/
  ai/
  evaluation/
types/
  database.ts
```

## 9. Environment Variables

```text
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
AI_PROVIDER_API_KEY=
REPORT_STORAGE_BUCKET=reports
RESEARCH_STORAGE_BUCKET=research
```

## 10. Deployment Plan

1. Create Supabase project.
2. Run `schema.sql`.
3. Create storage buckets: `research`, `reports`, `scent-assets`, `project-files`.
4. Configure RLS policies and admin role.
5. Deploy Next.js to Vercel.
6. Add environment variables.
7. Seed archive and institutional frameworks.
8. Run pilot acceptance tests.
9. Enable monitoring and backup.

