# RIP Architecture Review and Confirmed Way Forward

**Review status:** Approved with sequencing corrections  
**Purpose:** Confirm whether the current RIP direction is suitable before implementation begins.

## 1. Executive decision

The current foundation is suitable and should be retained:

- Oracle Cloud VM;
- Oracle Linux;
- rootless Podman with Compose compatibility;
- Nginx Proxy Manager;
- n8n;
- PostgreSQL;
- Redis;
- GitHub as the source of truth.

There is no technical reason to restart or replace this work. The correct approach is to stabilise it, document it, back it up, and add a small RIP application layer on top.

## 2. What is already correct

### Clear service responsibilities

- PostgreSQL is the durable record.
- Redis coordinates temporary work and queues.
- n8n controls high-level workflows, schedules and approvals.
- Python workers perform bounded research tasks.
- GitHub stores code, specifications, migrations and workflow exports.
- Oracle hosts the live services.
- Maps publishes only approved information.

These boundaries should remain.

### Evidence-first design

The rule that AI output is not evidence is essential. Claims must remain linked to inspectable sources, contradictions must be preserved, and a human must approve publication in version 1.

### Vertical-slice delivery

The first target must remain one complete result from request to publication. Building many agents or large-scale infrastructure before this works would be the wrong approach.

## 3. Corrections required before application development

### 3.1 Operational baseline comes first

Before writing the RIP frontend or worker, complete and record a server audit:

- VM shape, CPU, memory and available disk;
- Oracle Linux version and architecture;
- running containers and health status;
- container networks, volumes and restart behaviour;
- n8n mode and worker configuration;
- PostgreSQL version, database names and backup readiness;
- Redis configuration and persistence mode;
- exposed ports and firewall rules;
- DNS, reverse proxy and TLS status;
- current resource usage after a reboot.

The present documentation is based on work completed in prior sessions, not a fresh automated inspection of the VM. Treat live status as **reported** until this audit is captured.

### 3.2 Backups are a prerequisite, not a later feature

Before schema expansion or application deployment:

1. create an automated PostgreSQL backup;
2. export n8n workflows;
3. back up important configuration without secrets;
4. copy backups away from the live database volume;
5. perform and record one restore test.

A backup that has never been restored is not verified.

### 3.3 Fix access and TLS before adding more public services

External DNS, hostname and certificate routing must be made reliable before exposing RIP or Maps. PostgreSQL, Redis and internal worker endpoints must never be publicly exposed.

### 3.4 “Free forever” is a design constraint, not a guarantee

RIP must avoid mandatory paid services and paid trials. However, no external provider can be guaranteed to remain free forever. The safer rule is:

> Use open-source, self-hostable components and design every external dependency so it can be replaced or removed.

Oracle Cloud and GitHub may change their free-tier policies. RIP must therefore maintain portable container definitions, database backups and standard Git history.

## 4. Application architecture decision

The proposed Next.js, FastAPI and Python worker design is reasonable but remains **provisional until the VM capacity audit is complete**.

Version 1 should be implemented as a small modular system, not a collection of microservices.

Minimum deployable application services:

- `rip-web`: private control-centre UI and public Maps pages;
- `rip-api`: business rules and state transitions;
- `rip-worker`: research task execution.

The Maps publisher should initially live inside `rip-api`, not as a separate service. Authentication should initially support one owner account. Team accounts, advanced permissions and a separate search engine are deferred.

If VM capacity is too limited, the UI and API may be combined into one deployable application while preserving internal module boundaries. This decision must be based on measured resource usage, not preference.

## 5. Database scope correction

`instructions/DATABASE.md` is the target domain model, not the schema that must all be built immediately.

The first migration should include only what the vertical slice requires, likely:

- research projects;
- approved plan/version;
- tasks and task attempts;
- sources and snapshots;
- entities;
- claims and evidence;
- review items;
- publication records/versions;
- audit events.

Identity candidates, general entity relationships, worker registries and advanced lifecycle structures should be added only when the working flow demonstrates the need.

The existing `research_jobs` table must be preserved until a tested migration exists.

## 6. Research scope for the first release

The first release should not attempt unrestricted autonomous research across the whole web.

Use one controlled, lawful research use case with:

- a narrow target;
- a small result limit;
- approved public sources;
- inspectable evidence;
- bounded retries and timeouts;
- manual approval before publication.

A suitable acceptance test is:

> Submit one research project, generate and approve a plan, research a batch of no more than five targets, produce at least one evidence-backed record, review it, publish it to Maps, and schedule a recheck.

## 7. Required build order

### Gate 1 — Infrastructure verification

- capture live inventory;
- verify reboot recovery;
- fix DNS and TLS;
- implement backup and restore test;
- confirm private network boundaries;
- document operational commands.

### Gate 2 — Development skeleton

- establish repository folders;
- add local development configuration;
- add health endpoints;
- add migrations;
- add test and deployment checks;
- deploy an authenticated empty control centre.

### Gate 3 — First vertical slice

- create a project;
- generate and approve a research plan;
- create bounded tasks;
- process one small batch;
- capture source snapshots and evidence;
- create claims and confidence outcomes;
- review and approve one record;
- publish one Maps page;
- schedule re-verification.

### Gate 4 — Reliability

- retry and dead-letter handling;
- pause, resume and cancel;
- queue and worker visibility;
- audit trail;
- failure recovery;
- stale-record handling.

### Gate 5 — Scale only after evidence

- multiple workers;
- broader source coverage;
- concurrent projects;
- advanced identity resolution;
- team accounts;
- analytics and separate search indexing.

## 8. Decisions explicitly deferred

Do not decide or implement these yet:

- Kubernetes;
- a separate vector database;
- a separate search cluster;
- multiple agent frameworks;
- paid model routing services;
- independent Maps microservice;
- multi-tenant accounts;
- automatic publication without review;
- aggressive LinkedIn automation or bypassing platform restrictions.

## 9. Final assessment

The current direction is the best practical way forward provided the corrected sequence is followed.

The biggest project risk is no longer the choice of technology. It is adding too many components before one visible, trustworthy result works end to end.

The immediate next action is therefore **not product implementation**. It is a verified operational baseline of the Oracle VM, followed by backups and reliable TLS. Once those gates pass, implementation should begin with the smallest complete vertical slice.