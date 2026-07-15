# RIP Architecture

## 1. Architecture decision

RIP extends the current Oracle Cloud foundation. No rip-and-replace is planned.

## 2. Existing services

- Oracle Linux VM: permanent compute host.
- Podman/Docker Compose: service packaging and lifecycle.
- Nginx Proxy Manager: reverse proxy and TLS termination.
- n8n: workflow control, schedules, approvals, and integrations.
- PostgreSQL: system of record.
- Redis: queues, locks, short-lived coordination, and worker state.

## 3. New services

### RIP Web

Next.js application providing the private control centre and public Maps frontend. It communicates through the RIP API and does not connect directly to PostgreSQL.

### RIP API

FastAPI service responsible for authentication, projects, plans, entities, evidence, reviews, publication, exports, and health endpoints.

### Research Worker

Python worker that consumes tasks from Redis, performs bounded research operations, stores evidence in PostgreSQL through the API or a controlled internal data layer, and reports status.

### Scheduler and Orchestrator

n8n remains responsible for high-level workflows, schedules, notifications, approvals, and launching or pausing research jobs. It must not become the evidence database.

### Maps Publisher

A controlled publishing component that creates or updates only approved public records. It may be part of the RIP API initially.

## 4. Logical flow

User → RIP Web → RIP API → PostgreSQL

RIP API → Redis queue → Research Worker → source retrieval → evidence storage

n8n → RIP API and Redis for workflow control

Approved entity → Publisher → public Maps page

## 5. Responsibility boundaries

- PostgreSQL stores durable truth.
- Redis never becomes the only copy of important information.
- n8n coordinates workflows but does not hold canonical business records.
- Workers perform small, retryable tasks.
- The API enforces permissions and state transitions.
- The frontend presents data and requests actions but does not contain business rules.
- AI models interpret, classify, plan, and summarise; they do not create evidence.

## 6. Deployment layout

Suggested container services:

- rip-web
- rip-api
- rip-worker
- n8n
- n8n-worker if queue mode is used
- postgres
- redis
- nginx-proxy-manager
- backup

Ollama may run on the Oracle VM only when the selected model fits available memory and performance. Heavier local inference may run on another trusted machine later, but the cloud system must continue operating when that machine is offline.

## 7. Networking

- Only Nginx Proxy Manager exposes public HTTP/HTTPS ports.
- PostgreSQL and Redis remain private on the container network.
- Admin interfaces require authentication.
- Worker endpoints are internal only.
- Separate hostnames are recommended for control centre, n8n, API, and public Maps.

## 8. Persistence

Persistent volumes are required for PostgreSQL, Redis where persistence is enabled, n8n data, and application uploads. Database backups must be written outside the live PostgreSQL volume and copied to a second location.

## 9. Security

- All secrets remain in server-side environment files or a future secret manager.
- `.env` files are excluded from Git.
- Use least-privilege database users.
- Use authenticated API calls between services.
- Record administrative and publication actions in an audit log.
- Rate-limit public and sensitive endpoints.
- Never expose Redis or PostgreSQL publicly.
- Comply with source terms, robots restrictions, privacy law, and POPIA where personal information is processed.

## 10. Reliability

- Tasks are idempotent where practical.
- A task is acknowledged only after durable result storage.
- Retries use limits and backoff.
- Dead-letter tasks remain visible.
- Workers send heartbeats.
- Stalled tasks return to the queue after a lease expires.
- Service restarts must not lose project state.

## 11. Observability

Version 1 requires structured logs, task attempt history, worker heartbeat, queue depth, service health, disk usage, database connectivity, and user-friendly failure messages. Additional monitoring can be added after the end-to-end product works.

## 12. Backups

Minimum backup design:

- Daily PostgreSQL dump.
- Retention rotation.
- Encrypted copy to a second location.
- Regular restore test.
- Export and version n8n workflows in GitHub.
- Back up configuration without committing secrets.

## 13. Development and deployment

GitHub is the source of truth for code and specifications. A self-hosted GitHub runner or controlled deployment script on Oracle may test and deploy changes. GitHub Actions must not be used as the long-running research engine.

## 14. Future options

Search indexing, object storage, multiple workers, local or remote model routing, team accounts, and stronger observability may be added without changing the foundation.