# Intelligent Health Claims Management System (HCMS)

A production-grade, microservices-based platform for end-to-end health insurance claims lifecycle management — built by a 3-developer team in 7 days.

---

## Team

| Developer | Role | Technology |
|-----------|------|-------------|
| ⚡ Pavan | Lead Backend | Java / Spring Boot |
| 🐍 Rahul | Backend + Frontend | Python / Django, React |
| 🐍 Shubham | Backend + Frontend | Python / Django, React |

---

## Architecture Overview

- **Spring Boot Services** (Pavan): Auth Service (:8081), Claims Service (:8082), Policy Service (:8083), API Gateway (:8080)
- **Django Services**: Document Service (Rahul, :9001), Admin Service (Shubham, :9002)
- **Frontend**: React 18 + Tailwind CSS
- **Database**: PostgreSQL (shared schema per bounded context)
- **Communication**: REST (sync) + Redis/RabbitMQ (async events)

---

## Tech Stack

```
┌─────────────────────────────────────────────────────────────┐
│                      Frontend                                │
│         React 18 + Tailwind + React Query + Zustand        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway (Spring Boot)                   │
│              Port 8080 - JWT Validation, Routing            │
└─────────────────────────────────────────────────────────────┘
          │                │                │                │
          ▼                ▼                ▼                ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Auth Service │  │Claims Service│  │Policy Service│  │Django Services│
│  :8081       │  │  :8082       │  │  :8083       │  │  :9001/9002  │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
          │                │                │                │
          └────────────────┴────────────────┴────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                       │
│         (users, policies, claims, documents, logs)          │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Start

```bash
# Clone and setup
git clone https://github.com/your-repo/hcms.git
cd hcms

# Start all services with Docker
docker-compose up --build

# Access the application
# - Frontend: http://localhost
# - API Gateway: http://localhost:8080
# - Django Admin: http://localhost:9002/admin
```

---

## Environment Variables

Create a `.env` file in the root directory:

```env
# Database
POSTGRES_DB=hcms_db
POSTGRES_USER=hcms_user
POSTGRES_PASSWORD=your_secure_password

# JWT Secret
JWT_SECRET=your_jwt_secret_key_min_32_chars

# Django Secret Key
DJANGO_SECRET_KEY=your_django_secret_key

# AWS S3 (optional)
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKET_NAME=
```

---

# 7-Day Execution Plan

## Instructions

Click the checkboxes ( `[ ]` ) to mark tasks as completed. In a text editor or Markdown preview, replace `[ ]` with `[x]` to mark a task done.

---

## Day 1: Foundation - Setup, Auth & Database Scaffolding

**Goal:** Project structure · JWT auth · All table migrations · CI setup

### ⚡ Pavan (Spring Boot)

- [ ] Init Spring Boot monorepo with Maven multi-module (gateway, auth-service, claims-service, policy-service)
- [ ] Configure Spring Security + JWT (HMAC-SHA512 signing)
- [ ] Implement `POST /api/auth/register` and `POST /api/auth/login`
- [ ] Create `users` table migration (Flyway)
- [ ] BCrypt password encoder bean, refresh token entity + repo
- [ ] JwtFilter, SecurityConfig, UserDetailsService implementation
- [ ] Output: Auth service running on :8081 with Postman-tested login/register

### 🐍 Rahul (Django - Document Service)

- [ ] Init Django project `document_service` with DRF, configure PostgreSQL
- [ ] Create Document, ClaimAuditLog models + migrations
- [ ] Setup Django CORS headers, JWT middleware (djangorestframework-simplejwt)
- [ ] Implement file upload endpoint `POST /api/documents/upload` with local storage (S3 later)
- [ ] React: Init Vite + React project, install Tailwind CSS, React Query, Zustand, Axios
- [ ] Build Login page UI with form validation (React Hook Form + Zod)
- [ ] Output: Django doc service + React login page rendering

### 🔷 Shubham (Django - Admin)

- [ ] Init Django project `admin_service`, configure DRF + PostgreSQL
- [ ] Create ClaimReport, Notification models + migrations
- [ ] Customize Django Admin: register User, Policy, Claim ModelAdmins with search/filter
- [ ] Setup Celery + Redis for background tasks skeleton
- [ ] React: Build Register page, shared AuthLayout component, ProtectedRoute HOC
- [ ] Implement Zustand auth store with token management
- [ ] Output: Admin Django app running, React auth flow working end-to-end

---

## Day 2: Core Services - Claims & Policy CRUD

**Goal:** Claims submission · Policy management · API contracts · Dashboard skeleton

### ⚡ Pavan (Spring Boot)

- [ ] Implement full Claims Service: `POST /api/claims`, `GET /api/claims`, `GET /api/claims/{id}`
- [ ] Create `claims` table migration, ClaimRepository with JPA specs for filtering
- [ ] ClaimService with business logic: policy validation, amount checks, claim number generation
- [ ] Pageable response wrapper (PageResponse DTO)
- [ ] Implement Policy Service: `POST /api/policies`, `GET /api/policies/my`, `GET /api/policies/{id}`
- [ ] Create `policies` table migration, coverage remaining calculation
- [ ] Output: Claims + Policy REST APIs fully functional

### 🐍 Rahul (Django + React)

- [ ] Implement `GET /api/documents/{id}/download` with pre-signed URL logic
- [ ] Build React User Dashboard page: stat cards (React Query fetching), recent claims list
- [ ] Build Sidebar navigation component with role-based menu items
- [ ] Implement claimsApi.js (Axios abstraction for all claims endpoints)
- [ ] ClaimCard reusable component with status badge (color-coded by status)
- [ ] Output: User Dashboard rendering live data from API

### 🔷 Shubham (Django + React)

- [ ] Admin service: `GET /api/admin/analytics/dashboard` — aggregate query via Django ORM
- [ ] Custom Django Admin dashboard view with KPI cards (override AdminSite.index)
- [ ] React: Build My Policies page with PolicyCard component, coverage progress bar
- [ ] Build Navbar with notifications bell icon + dropdown
- [ ] policyApi.js abstraction layer
- [ ] Output: Policies page working, Admin dashboard KPIs accessible

---

## Day 3: Claims Workflow - State Machine, Documents & Agent Queue

**Goal:** Status transitions · File upload UI · Claim detail page · RBAC enforcement

### ⚡ Pavan (Spring Boot)

- [ ] Implement claim state machine: `PUT /api/claims/{id}/status` with transition validation
- [ ] Create `claim_audit_logs` table + AuditService that logs every transition
- [ ] Agent assignment endpoint: `PUT /api/claims/{id}/assign` [ADMIN only]
- [ ] Implement refresh token endpoint: `POST /api/auth/refresh`
- [ ] Spring Boot Actuator + custom health checks for each service
- [ ] Output: Full claims lifecycle with audit trail

### 🐍 Rahul (Django + React)

- [ ] Django: Implement document list endpoint `GET /api/documents/claim/{claimId}`
- [ ] File type MIME validation + size enforcement in Django serializer
- [ ] React: Build Submit Claim multi-step form (Step 1: policy select, Step 2: details, Step 3: upload)
- [ ] Drag-and-drop file upload component using react-dropzone
- [ ] Upload progress bar with Axios onUploadProgress
- [ ] Output: Full claim submission flow working with document upload

### 🔷 Shubham (Django + React)

- [ ] Django Admin: Custom bulk_approve and bulk_reject actions on ClaimAdmin
- [ ] Inline DocumentInline on Claim detail in Django Admin
- [ ] React: Build Claim Detail page with status timeline (ClaimTimeline component)
- [ ] React: Build Claim History page: paginated table with status filter, date range picker
- [ ] Status badge + color mapping utility
- [ ] Output: Claim History and Detail pages fully functional

---

## Day 4: Admin Dashboard - Analytics, Charts & Agent Interface

**Goal:** Chart.js charts · Agent claim queue · Notifications · Policy admin

### ⚡ Pavan (Spring Boot)

- [ ] Policy admin endpoints: `PUT /api/policies/{id}`, `DELETE /api/policies/{id}` [ADMIN]
- [ ] Implement `GET /api/claims/agent/queue` — paginated claims assigned to requesting agent
- [ ] Notification service: `GET /api/notifications`, `PUT /api/notifications/{id}/read`
- [ ] Create `notifications` table migration + async notification trigger on claim status change
- [ ] Global exception handler (@ControllerAdvice) with standardized error response
- [ ] Output: Agent queue, notifications, policy admin APIs done

### 🐍 Rahul (Django + React)

- [ ] Django analytics: `GET /api/admin/analytics/claims-timeseries` for monthly bar chart data
- [ ] React: Build Admin Dashboard page with Chart.js charts: status donut + monthly bar
- [ ] Claims table in admin view with quick-action buttons (Approve / Reject)
- [ ] Modal component for reject with reason text input
- [ ] React Query optimistic updates on claim status change
- [ ] Output: Admin analytics page with live charts

### 🔷 Shubham (Django + React)

- [ ] Django analytics: `GET /api/admin/analytics/agents` — agent performance metrics
- [ ] Django: CSV export endpoint `GET /api/admin/claims/export?format=csv`
- [ ] React: Build Agent view — claim queue with filter, claim cards with status update dropdowns
- [ ] Notification dropdown in Navbar, mark-read functionality
- [ ] notificationApi.js abstraction + Zustand notification count badge
- [ ] Output: Agent queue, notifications fully working in React

---

## Day 5: Integration, API Gateway & Security Hardening

**Goal:** Gateway routing · Rate limiting · CORS · End-to-end integration testing

### ⚡ Pavan (Spring Boot)

- [ ] Configure API Gateway routing rules — proxy all `/api/documents/**` to Django :9001
- [ ] Implement rate limiting with Bucket4j (5 req/s per user, 20 req/s per IP)
- [ ] CORS configuration: whitelist only React dev origin + production domain
- [ ] JWT validation in gateway filter (no downstream services re-validate)
- [ ] Request logging filter with correlation ID (MDC)
- [ ] Write Spring Boot integration tests for auth + claims endpoints
- [ ] Output: All services reachable via single gateway on :8080

### 🐍 Rahul (Django + React)

- [ ] Django: Configure JWT middleware to validate tokens from Spring Auth service public key
- [ ] DRF throttling (AnonRateThrottle, UserRateThrottle)
- [ ] Write Django unit tests for document upload, permissions
- [ ] React: Axios interceptor for 401 → auto refresh token → retry logic
- [ ] React: Global error boundary + toast notification system (react-hot-toast)
- [ ] React: Form validation error display on all forms (Zod schemas)
- [ ] Output: Auth refresh working seamlessly, error handling polished

### 🔷 Shubham (Django + React)

- [ ] Django: Add Django-guardian for object-level permissions (agent can only see assigned claims)
- [ ] Celery task: RefreshAnalyticsSnapshot runs every 15 minutes
- [ ] Write Django tests for admin analytics endpoints
- [ ] React: Implement ProtectedRoute with role check (redirects ADMIN→admin, USER→dashboard)
- [ ] React: 404 and Unauthorized pages
- [ ] Full end-to-end test: register → login → submit claim → admin approves → user notified
- [ ] Output: Complete flow tested end-to-end

---

## Day 6: Polish, Edge Cases, Validation & Performance

**Goal:** Loading states · Empty states · Input sanitization · Responsive UI · Optimizations

### ⚡ Pavan (Spring Boot)

- [ ] Add database indexes: claims(user_id, status), claims(policy_id), documents(claim_id)
- [ ] Implement search endpoint: `GET /api/claims/search?q=CLM-2024`
- [ ] Add @Valid annotations + Bean Validation to all request DTOs
- [ ] Standardize all API error responses (code, message, timestamp, path)
- [ ] Swagger/OpenAPI 3.0 documentation for all Spring Boot endpoints
- [ ] Write JUnit 5 unit tests for ClaimService business logic (state machine)
- [ ] Output: Polished, documented, indexed backend

### 🐍 Rahul (Django + React)

- [ ] Django: drf-spectacular for auto OpenAPI docs on Django services
- [ ] Document virus scan placeholder (ClamAV hook) + file rename on upload
- [ ] React: Loading skeletons on all data-fetching pages (React Query isLoading)
- [ ] React: Empty state components (no claims yet, no policies)
- [ ] React: Fully responsive layout (mobile sidebar drawer, responsive tables)
- [ ] React: Debounced search input on Claim History page
- [ ] Output: Polished, mobile-friendly UI

### 🔷 Shubham (Django + React)

- [ ] Django: Pagination on all list endpoints, consistent response envelope
- [ ] Add Django signals for audit logging on Claim model save
- [ ] React: Confirmation dialogs before destructive actions (reject, cancel claim)
- [ ] React: Date formatting with date-fns, currency formatting with Intl.NumberFormat
- [ ] React: React Query cache invalidation strategy (staleTime, refetchOnWindowFocus)
- [ ] Write React component tests with Vitest + Testing Library for ClaimCard
- [ ] Output: Stable, well-tested frontend

---

## Day 7: Docker, Deployment & Final Demo

**Goal:** Dockerfiles · docker-compose · README · Environment config · Demo run-through

### ⚡ Pavan (Spring Boot)

- [ ] Dockerfile for each Spring Boot service (multi-stage: Maven build → JRE 17 slim)
- [ ] docker-compose.yml: PostgreSQL + Redis + all 4 Spring services + network config
- [ ] Environment variable externalization (application.yml → env vars)
- [ ] Database seed script: admin user, sample agent, 3 policies
- [ ] Spring Boot production profile: connection pooling (HikariCP), logging config
- [ ] Output: All Spring services running via docker-compose up

### 🐍 Rahul (Django + React)

- [ ] Dockerfile for Django document service (gunicorn, collectstatic)
- [ ] React: Production build optimizations (Vite config, code splitting by route)
- [ ] Nginx config: serve React build, proxy /api to gateway, gzip compression
- [ ] Django: gunicorn WSGI config, static files via WhiteNoise
- [ ] Write comprehensive README.md: setup, env vars, API examples
- [ ] Output: React + Django doc service containerized

### 🔷 Shubham (Django + React)

- [ ] Dockerfile for Django admin service + Celery worker
- [ ] Add all services to docker-compose.yml with health checks and depends_on
- [ ] Django: management command to seed admin user + sample data
- [ ] Full integration demo: run docker-compose, walk through complete user journey
- [ ] Record screen demo video (optional) for portfolio
- [ ] Final code review: remove debug logs, ensure no secrets in code, merge to main
- [ ] Output: One-command `docker-compose up` runs the entire system

---

## Progress Tracking

### Daily Completion Status

| Day | Date | Pavan | Rahul | Shubham | Notes |
|-----|------|-------|-------|---------|-------|
| D1  |      | [ ]   | [ ]   | [ ]     |       |
| D2  |      | [ ]   | [ ]   | [ ]     |       |
| D3  |      | [ ]   | [ ]   | [ ]     |       |
| D4  |      | [ ]   | [ ]   | [ ]     |       |
| D5  |      | [ ]   | [ ]   | [ ]     |       |
| D6  |      | [ ]   | [ ]   | [ ]     |       |
| D7  |      | [ ]   | [ ]   | [ ]     |       |

---

## API Endpoints Summary

### Auth Service (Spring Boot :8081)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Register new user | Public |
| POST | `/api/auth/login` | Login, receive JWT | Public |
| POST | `/api/auth/refresh` | Refresh access token | Required |

### Claims Service (Spring Boot :8082)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/claims` | Submit new claim | USER, AGENT |
| GET | `/api/claims` | List claims (paginated) | All |
| GET | `/api/claims/{id}` | Get claim detail | All |
| PUT | `/api/claims/{id}/status` | Update claim status | ADMIN, AGENT |
| PUT | `/api/claims/{id}/assign` | Assign to agent | ADMIN |
| GET | `/api/claims/agent/queue` | Agent's assigned claims | AGENT |

### Policy Service (Spring Boot :8083)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/policies` | Create policy | ADMIN |
| GET | `/api/policies/my` | User's policies | USER |
| GET | `/api/policies/{id}` | Get policy detail | All |
| PUT | `/api/policies/{id}` | Update policy | ADMIN |
| DELETE | `/api/policies/{id}` | Delete policy | ADMIN |

### Document Service (Django :9001)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/documents/upload` | Upload document | USER, AGENT |
| GET | `/api/documents/{id}/download` | Get download URL | All |
| GET | `/api/documents/claim/{claimId}` | List claim documents | All |

### Admin Service (Django :9002)

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | `/api/admin/analytics/dashboard` | KPI summary | ADMIN |
| GET | `/api/admin/analytics/claims-timeseries` | Monthly chart data | ADMIN |
| GET | `/api/admin/analytics/agents` | Agent performance | ADMIN |
| GET | `/api/admin/claims/export?format=csv` | Export claims | ADMIN |

---

## Database Schema

### users
- `id` (UUID, PK)
- `email` (VARCHAR, UNIQUE)
- `password_hash` (VARCHAR, BCrypt)
- `full_name` (VARCHAR)
- `phone` (VARCHAR, UNIQUE)
- `role` (ENUM: USER | ADMIN | AGENT)
- `is_active` (BOOLEAN)
- `created_at`, `updated_at`, `deleted_at`

### policies
- `id` (UUID, PK)
- `user_id` (FK → users)
- `policy_number` (VARCHAR, UNIQUE)
- `plan_name` (VARCHAR)
- `coverage_amount` (DECIMAL)
- `deductible` (DECIMAL)
- `premium` (DECIMAL)
- `start_date`, `end_date` (DATE)
- `status` (ENUM: ACTIVE | EXPIRED | CANCELLED)

### claims
- `id` (UUID, PK)
- `user_id` (FK → users)
- `policy_id` (FK → policies)
- `assigned_agent_id` (FK → users, NULLABLE)
- `claim_number` (VARCHAR, UNIQUE)
- `amount_claimed`, `amount_approved` (DECIMAL)
- `description` (TEXT)
- `incident_date` (DATE)
- `status` (ENUM: PENDING | UNDER_REVIEW | APPROVED | REJECTED | CANCELLED)
- `rejection_reason` (TEXT, NULLABLE)
- `submitted_at`, `reviewed_at`, `resolved_at`

### documents
- `id` (UUID, PK)
- `claim_id` (FK → claims)
- `uploaded_by` (FK → users)
- `file_name`, `storage_key` (VARCHAR)
- `file_size` (BIGINT)
- `mime_type`, `doc_type` (VARCHAR/ENUM)
- `uploaded_at`

### claim_audit_logs
- `id` (UUID, PK)
- `claim_id` (FK → claims)
- `actor_id` (FK → users)
- `previous_status`, `new_status` (VARCHAR)
- `notes` (TEXT)
- `created_at`

### notifications
- `id` (UUID, PK)
- `user_id` (FK → users)
- `title`, `message` (VARCHAR/TEXT)
- `is_read` (BOOLEAN)
- `type` (ENUM: CLAIM_UPDATE | POLICY_EXPIRY | GENERAL)
- `created_at`

---

## Security Checklist

| Area | Implementation | Status |
|------|----------------|--------|
| Passwords | BCryptPasswordEncoder(strength=12) | [ ] |
| JWT Storage | Access token in memory, refresh in httpOnly cookie | [ ] |
| HTTPS | Enforce TLS in production via nginx/load balancer | [ ] |
| CORS | Whitelist only frontend origin, no wildcard | [ ] |
| Rate Limiting | Login: 5 attempts / 15 min per IP | [ ] |
| Input Validation | Bean Validation (JSR-380) + Django serializers | [ ] |
| SQL Injection | JPA/Hibernate parameterized queries, Django ORM | [ ] |
| File Upload | MIME type check, file size limit, rename on save | [ ] |
| Audit Logging | Log all state changes with actor + timestamp | [ ] |
| Secrets | Environment variables, never in code | [ ] |

---

## Interview-Ready Talking Points

### Architecture
- "We used bounded context separation — each service owns its data"
- "Spring Boot gateway handles cross-cutting concerns so services stay clean"
- "Django was chosen for admin because of its built-in admin framework"

### Decisions Made
- "Refresh token rotation prevents replay attacks"
- "Claim state machine prevents invalid transitions at the service layer"
- "Audit log is append-only — we never update or delete audit records"

### What You'd Add Next
- "Kafka for event streaming between services instead of sync REST"
- "ML-based fraud detection on claim amounts"
- "Kubernetes with HPA for auto-scaling during peak claim periods"

---

## License

MIT License

---

## Contributors

- [Pavan](https://github.com/pavan) - Spring Boot / Java
- [Rahul](https://github.com/rahul) - Django / Python / React
- [Shubham](https://github.com/shubham) - Django / Python / React