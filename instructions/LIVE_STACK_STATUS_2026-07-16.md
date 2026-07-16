# RIP Live Stack Status — 16 July 2026

## Status

This document supersedes any interpretation that the stopped rootless Podman containers are the active production stack.

The verified live application stack is running as **rootful Docker services** under:

```text
/opt/mumoxa-stack
```

The earlier Oracle audit was executed as user `opc` and primarily inspected that user's rootless Podman environment. It therefore saw older stopped Podman containers and did not fully represent the active root-owned Docker stack.

## Verified running Docker services

The following containers were reported running on 16 July 2026:

| Container | Verified state |
|---|---|
| `mumoxa-scraper` | Running and healthy |
| `mumoxa-dashboard` | Running and healthy |
| `mumoxa-n8n` | Running |
| `mumoxa-n8n-worker` | Running |
| `mumoxa-nginx-proxy-manager` | Running |
| `mumoxa-postgres` | Running and healthy |
| `mumoxa-redis` | Running and healthy |

This confirms that the current foundation already includes:

- a dashboard service;
- a scraper/research service;
- n8n main and worker services;
- PostgreSQL;
- Redis;
- Nginx Proxy Manager;
- a functioning containerised application stack.

## Verified database work

### Existing database

The active PostgreSQL database is currently the `n8n` database, accessed with the `n8n` database role.

### `research_jobs`

A working `research_jobs` table exists with:

- `id`;
- `job_name`;
- `target_market`;
- `search_query`;
- `status`;
- `confidence_score`;
- `raw_data`;
- `created_at`;
- `updated_at`.

It includes indexes on status and creation time, plus an automatic updated-at trigger.

### `research_results`

A working `research_results` table exists with:

- foreign key to `research_jobs`;
- person name;
- current company;
- current title;
- location;
- LinkedIn URL;
- source URL;
- evidence;
- confidence;
- verification status;
- raw JSON data;
- created and updated timestamps.

It includes indexes for job, person name and verification status, plus an automatic updated-at trigger.

### Dashboard connectivity

The dashboard successfully returned:

```json
{"avg_confidence":null,"completed_jobs":0,"total_jobs":0,"total_results":0}
```

This verifies that the dashboard can reach the live database and that the API statistics endpoint is operational.

## Backup completed

Before applying the research schema, a PostgreSQL dump was created at:

```text
/opt/mumoxa-stack/backups/n8n-before-research-schema-20260716-095353.sql
```

The reported backup size was approximately 286 KB.

This is a useful safety checkpoint, but it is not yet a complete backup system. Automated rotation, off-volume storage and a restore test are still required.

## Important architecture correction

The active stack is presently based on **Docker**, not rootless Podman.

The repository must not instruct contributors to migrate the live stack to Podman merely for consistency. The correct immediate rule is:

> Preserve and stabilise the working Docker stack in `/opt/mumoxa-stack`. Treat the old rootless Podman containers as legacy until they are carefully identified and retired.

No legacy container, volume or network may be deleted until its data and purpose have been confirmed.

## Current practical position

RIP is further advanced than the initial audit suggested.

### Already built

- Oracle Cloud VM;
- Oracle Linux host;
- active Docker runtime and Compose stack;
- n8n main and worker;
- PostgreSQL;
- Redis;
- Nginx Proxy Manager;
- dashboard;
- scraper;
- research job schema;
- research result schema;
- dashboard-to-database connection;
- one manual pre-schema database backup.

### Still requiring verification or completion

- exact Docker Compose configuration and service dependencies;
- Docker restart policies and reboot recovery;
- current container image versions;
- health checks for n8n, n8n worker and Nginx Proxy Manager;
- Docker networks and published ports;
- environment-file and secret handling;
- DNS and TLS routing;
- firewall exposure;
- PostgreSQL and Redis external exposure;
- automated backups and retention;
- successful restore test;
- n8n workflow export and recovery;
- end-to-end research execution;
- evidence verification workflow;
- review queue;
- Maps publication.

## Immediate next audit

Run the next audit as root, against Docker and `/opt/mumoxa-stack`, without printing secrets. It must record:

1. `docker compose config --services`;
2. `docker ps -a` and health;
3. restart policies;
4. Docker networks and volumes;
5. published ports;
6. service image versions;
7. Compose file locations;
8. disk use by Docker and `/opt/mumoxa-stack`;
9. systemd status for Docker;
10. reboot recovery readiness;
11. PostgreSQL readiness and database inventory;
12. Redis readiness using authenticated configuration without exposing the password;
13. DNS and TLS status;
14. backup and restore readiness.

## Decision

Do not rebuild the foundation.

The next step is to verify and stabilise the live Docker stack, then test one existing research flow using the current dashboard, scraper, n8n, PostgreSQL and Redis services before creating a new application layer.
