# RIP Way Forward Review

**Review date:** 2026-07-16  
**Status:** Approved with practical safeguards

## Executive conclusion

The current RIP direction is the best practical way forward for the owner's goals and constraints.

The existing Oracle Cloud, Podman, n8n, PostgreSQL, Redis, Nginx Proxy Manager and GitHub foundation should be retained. There is no benefit in replacing the stack now. The main risk is not the technology choice; it is adding too many services, agents or integrations before one trustworthy result works end to end.

The approved sequence is:

1. verify and stabilise the live Oracle environment;
2. implement backups and complete a restore test;
3. repair DNS and TLS;
4. measure the VM resource budget;
5. deploy the smallest authenticated RIP application skeleton;
6. build one narrow vertical research flow;
7. add reliability before scale.

## Why this stack is appropriate

- **Oracle Cloud VM** provides a permanent low-cost runtime.
- **Rootless Podman** is suitable for secure containerised deployment on Oracle Linux.
- **PostgreSQL** is a strong durable system of record for projects, evidence, claims, reviews and publication history.
- **Redis** is appropriate for temporary queue coordination, locks and leases, but not permanent evidence.
- **n8n** is useful for schedules, approvals and integrations, especially for a non-technical operator.
- **Python workers** are suitable for bounded research and verification tasks.
- **GitHub** is the correct source of truth for code, migrations, specifications and workflow exports.
- **Nginx Proxy Manager** is sufficient for the first deployment if DNS and TLS are stabilised.

## Required safeguards and corrections

### 1. Keep version 1 small

Do not begin with multiple specialised agents, a vector database, Kubernetes, a search cluster, or a separate Maps service.

The first deployable product should contain no more than:

- one private control-centre web application;
- one API or combined web/API application;
- one research worker;
- the existing n8n, PostgreSQL, Redis and reverse-proxy services.

Whether web and API are separate containers must be decided only after the VM resource audit.

### 2. The API must control durable state

n8n and workers should request state changes through the RIP API or a controlled internal service layer. They should not freely update business tables or manipulate Redis keys without defined contracts.

This prevents workflow logic from becoming scattered across n8n, Python and the frontend.

### 3. Define verification honestly

RIP cannot guarantee that every public statement is absolutely true. The product must define a verified record as:

> A claim supported by inspectable evidence that meets the approved source, recency, identity and confidence rules, with contradictions disclosed and human approval recorded.

Use terms such as:

- evidence-backed;
- source-verified;
- high confidence;
- last checked;
- conflicting evidence;
- needs review.

Do not promise mathematical certainty where public information can be incomplete or outdated.

### 4. Source snapshots require careful handling

Store only what is needed to prove the claim. Respect copyright, privacy law, POPIA, access controls and source terms.

Where storing a full page is inappropriate, retain:

- source URL;
- retrieval date and time;
- title and publisher;
- a limited supporting passage or structured extraction;
- content hash where useful;
- archived or durable reference where lawful.

Do not build authentication bypasses, anti-bot evasion or aggressive LinkedIn automation.

### 5. Backups are a hard gate

Product schema expansion must not begin until:

- PostgreSQL backups are automated;
- n8n workflows can be exported;
- a second backup location exists;
- one restore has succeeded and been documented.

### 6. Avoid a self-hosted GitHub runner initially unless needed

A self-hosted runner adds another persistent service and increases the attack surface. Start with a controlled deployment script or manual pull-and-deploy procedure on Oracle.

Add a self-hosted runner later only when:

- deployment steps are stable;
- rollback works;
- secrets are protected;
- the resource cost has been measured.

### 7. Choose one narrow first use case

The first research project should be small, lawful and easy to judge manually.

Recommended first use case:

> Identify up to five publicly discoverable professionals for one narrowly defined skill and geography, capture evidence of current role and selected skill claims, review the results, publish one approved Maps record, and schedule a recheck.

The first test must avoid bulk LinkedIn automation and should use approved public web sources that can be inspected directly.

## Decisions confirmed

- Preserve the current infrastructure.
- PostgreSQL remains the durable source of truth.
- Redis remains temporary coordination only.
- n8n remains the high-level orchestrator.
- Python workers perform bounded tasks.
- Human approval remains mandatory before publication in version 1.
- Maps publishing remains part of the main application initially.
- GitHub Actions will not run long research jobs.
- No scale work begins until the first vertical slice is reliable.

## Immediate next action

The next action is the Oracle Operational Baseline, not broad product development.

The baseline must capture:

- VM shape, CPU, RAM and disk;
- OS and architecture;
- containers, versions, health and restart behaviour;
- networks, volumes and public ports;
- n8n execution mode and worker setup;
- PostgreSQL and Redis exposure and persistence;
- DNS and TLS status;
- backup and restore evidence;
- measured idle resource use.

After that, update `instructions/CURRENT_STATUS.md` from reported status to verified status and proceed to the development skeleton.

## Final assessment

Proceed with the current architecture.

Do not restart the project, migrate to GitLab, replace n8n, or introduce a new agent framework. The current base is adequate. Progress should now be measured by working end-to-end outcomes rather than by the number of installed tools.