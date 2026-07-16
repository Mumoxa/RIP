# RIP Roadmap and Status

## Phase 0 — Reported Foundations

Reported as completed in prior setup sessions:

- Oracle Cloud VM deployed.
- Oracle Linux configured.
- Rootless Podman and Compose compatibility working.
- Nginx Proxy Manager installed.
- n8n installed and running.
- PostgreSQL installed, healthy and connected to n8n.
- Redis installed and healthy.
- GitHub repository created.
- Initial specifications written.

Important qualification:

These items are based on prior work and conversation history. They still require a fresh, recorded live-server audit before they are treated as the verified production baseline.

---

## Phase 0.5 — Operational Baseline (Immediate Priority)

Do this before product implementation:

1. Capture the Oracle VM shape, CPU, memory, disk and architecture.
2. Record all running containers, health checks, networks, volumes and restart policies.
3. Confirm n8n mode, PostgreSQL connectivity and Redis persistence.
4. Reboot and verify automatic service recovery.
5. Fix DNS, reverse proxy and TLS routing.
6. Confirm PostgreSQL and Redis are not publicly reachable.
7. Implement daily PostgreSQL backups and n8n workflow exports.
8. Store a backup away from the live database volume.
9. Perform and document one restore test.
10. Record resource usage and determine whether the provisional application architecture fits the VM.

Success criteria:

- the live stack is inventoried;
- services recover after reboot;
- public HTTPS routing works;
- private data services remain private;
- a database backup has been successfully restored;
- the available resource budget is known.

---

## Phase 1 — Product Definition

Completed:

- founding blueprint;
- product requirements;
- UI specification;
- architecture specification;
- target database model;
- research engine specification;
- Maps specification;
- coding-agent instructions;
- infrastructure status note;
- formal architecture review.

Remaining before coding:

- choose the first narrow research use case;
- define its approved source types;
- confirm the minimum version-1 database tables;
- confirm the application deployment shape after the VM audit;
- define single-owner authentication;
- define the deployment and rollback workflow.

---

## Phase 2 — Development Skeleton

Build only after Phase 0.5 passes:

1. Establish repository folders for application, worker, migrations, deployment and n8n exports.
2. Add local development configuration with safe example environment variables.
3. Add database migrations without deleting the existing `research_jobs` table.
4. Add service health endpoints and structured logs.
5. Add automated formatting, linting, tests and build checks.
6. Deploy an authenticated empty control centre to Oracle.
7. Confirm deployment rollback.

Success criteria:

The owner can securely open the RIP control centre and see reliable service-health information.

---

## Phase 3 — First Working Vertical Slice

Target:

A user submits one narrow research request and publishes one reviewed, evidence-backed Maps record.

Build:

1. Create project.
2. Generate and approve a research plan.
3. Divide work into a batch of no more than five targets.
4. Queue bounded research tasks.
5. Retrieve approved public sources.
6. Store source snapshots, claims and evidence.
7. Flag contradictions and uncertainty.
8. Present the record in a human review queue.
9. Approve and publish one Maps page.
10. Schedule a recheck.

Success criteria:

The system produces at least one trustworthy result from start to finish, and every material published claim can be traced to stored evidence.

---

## Phase 4 — Reliability

Build:

- bounded retries and backoff;
- dead-letter visibility;
- pause, resume, retry and cancel;
- worker heartbeat and stalled-task recovery;
- audit trail;
- stale-record detection;
- operational alerts;
- clear failure and recovery states in the UI.

---

## Phase 5 — Scale

Only after the vertical slice is reliable:

- multiple concurrent projects;
- additional workers;
- broader source coverage;
- deeper identity resolution;
- team accounts and permissions;
- international markets;
- search optimisation;
- analytics.

---

# Product Principle

Every feature must answer:

1. What evidence does this produce?
2. How is that evidence verified?
3. How does it improve Maps?

If the answer is unclear, the feature should not be built.

# Cost and portability rule

RIP must avoid mandatory paid services and paid trials. Because no external free tier can be guaranteed forever, all critical components must remain open source, self-hostable and portable through standard Git, containers and database backups.