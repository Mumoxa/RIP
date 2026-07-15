# RIP Roadmap and Status

## Phase 0 — Completed Foundations

Completed:

- Oracle Cloud VM deployed.
- Oracle Linux configured.
- Podman and Docker compatibility working.
- Nginx Proxy Manager installed.
- n8n installed.
- PostgreSQL installed.
- Redis installed.
- GitHub repository created.
- Initial specifications written.

Outcome:

RIP has a stable technical foundation.

---

## Phase 1 — Product Definition (Current Phase)

Completed:

- Blueprint.
- Product requirements.
- UI specification.
- Architecture specification.
- Database specification.
- Research engine specification.
- Maps specification.
- Agent instructions.
- Infrastructure status.

Remaining:

- finalise user journeys;
- finalise evidence model;
- define permissions;
- define deployment workflow.

---

## Phase 2 — First Working Version

Target:

A user submits a research request and receives one verified record.

Build:

1. Next.js frontend.
2. FastAPI backend.
3. PostgreSQL schema.
4. Research worker.
5. Evidence viewer.
6. Review queue.
7. Maps publisher.

Success criteria:

The system produces one trustworthy result from start to finish.

---

## Phase 3 — Continuous Research

Build:

- scheduling;
- retries;
- stale record detection;
- monitoring;
- health dashboards.

---

## Phase 4 — Scale

Build:

- multiple concurrent projects;
- team accounts;
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
