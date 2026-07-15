# RIP Current Status

## Project state

RIP (Research Intelligence Platform) is currently in the architecture and foundation phase.

The objective is to build an evidence-first research platform that can:

- accept research projects;
- break them into smaller tasks;
- perform long-running research;
- verify claims against multiple sources;
- store evidence;
- publish approved intelligence to Maps;
- continuously revisit and update old information.

The product is not yet operational.

The infrastructure foundation exists and must be preserved.

---

# Existing Infrastructure (Live)

## Cloud

- Oracle Cloud Free Tier VM.
- Oracle Linux 9.
- ARM / aarch64 architecture.
- Rootless Podman containers.
- Systemd services enabled.

---

## Container Runtime

Currently running:

- Podman.
- Docker-compatible compose.
- Persistent volumes.
- User services.

This layer is considered stable.

---

## Workflow Engine

### n8n

Current role:

- workflow orchestration;
- scheduling;
- human approvals;
- pipeline coordination;
- future research dispatching.

Status:

Running.

Important rule:

n8n orchestrates the system but does not perform deep research itself.

---

## Database

### PostgreSQL

Current status:

- deployed;
- healthy;
- connected to n8n;
- basic research tables tested.

Future responsibility:

- projects;
- tasks;
- evidence;
- entities;
- publication queue;
- audit history.

---

## Queue Layer

### Redis

Current status:

- deployed;
- healthy;
- persistent volume configured.

Future responsibility:

- background jobs;
- research queues;
- retries;
- long-running tasks.

---

## Proxy Layer

### Nginx Proxy Manager

Current status:

- deployed.
- proxy hosts configured.
- external routing partially configured.

Future responsibility:

- TLS.
- public access.
- Maps publication.
- RIP frontend access.

---

## AI Layer

Currently available:

- Ollama.
- Local models.
- ChatGPT.
- Claude.
- Codex.

Important principle:

AI is not trusted.

Evidence is trusted.

---

# What Has Not Been Built Yet

The following systems still need to be implemented:

- RIP frontend.
- authentication.
- research worker service.
- verification engine.
- evidence ingestion.
- identity resolution.
- Maps publishing API.
- re-verification engine.
- analytics.
- backups.

---

# Constraints

The project must remain:

- free forever;
- open source;
- deployable on Oracle Free Tier;
- understandable by a non-technical founder;
- incrementally built.

Existing infrastructure may be extended but should not be replaced.

---

# Immediate Next Objective

Build one vertical slice:

Research request → research worker → evidence → verification → approval → Maps publication.

No major infrastructure changes should occur until this flow works end to end.
