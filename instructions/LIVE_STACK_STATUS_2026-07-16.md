# RIP Live Stack Status — 16 July 2026

## Status

This document supersedes any interpretation that the stopped rootless Podman containers are the active production stack.

The verified live application stack is running as **rootful Docker services** under:

```text
/opt/mumoxa-stack
```

The earlier Oracle audit was executed as user `opc` and primarily inspected that user's rootless Podman environment. It therefore saw older stopped Podman containers and did not fully represent the active root-owned Docker stack.

## Verified host capacity

- Oracle Linux 9.8
- ARM / aarch64
- 2 vCPUs
- 10 GiB RAM
- 4 GiB swap
- low current CPU load

The available memory is sufficient for the existing stack and a small RIP version 1 application. Disk capacity remains a concern because the root filesystem was previously measured at 89% used.

## Verified Docker Compose services

`docker compose config --services` returned:

- `mumoxa-postgres`
- `mumoxa-redis`
- `mumoxa-n8n`
- `mumoxa-n8n-worker`
- `mumoxa-nginx-proxy-manager`
- `mumoxa-scraper`
- `mumoxa-dashboard`

The Compose file currently includes an obsolete top-level `version` property. Docker ignores it. This is harmless but should be removed during a controlled configuration cleanup.

## Verified running containers

| Container | State | Health | Published ports |
|---|---|---|---|
| `mumoxa-scraper` | Running | Healthy | Internal `8000/tcp` |
| `mumoxa-dashboard` | Running | Healthy | Internal `5000/tcp` |
| `mumoxa-n8n` | Running | No Docker health check | Internal `5678/tcp` |
| `mumoxa-n8n-worker` | Running | No Docker health check | Internal `5678/tcp` |
| `mumoxa-nginx-proxy-manager` | Running | No Docker health check | Public `80`, `81`, `443` |
| `mumoxa-postgres` | Running | Healthy | Internal `5432/tcp` |
| `mumoxa-redis` | Running | Healthy | Internal `6379/tcp` |

PostgreSQL, Redis, n8n, the worker, dashboard and scraper are not directly published on the host. This is the correct default network posture. Nginx Proxy Manager is the public entry point.

## Restart policies

All seven active containers use:

```text
restart=unless-stopped
```

This is correctly configured for Docker daemon restarts and host reboot recovery, provided Docker itself is enabled at boot. Actual reboot recovery has not yet been tested and remains a required gate.

## Health-check gap

Docker health checks exist for:

- scraper;
- dashboard;
- PostgreSQL;
- Redis.

Health checks are still missing for:

- n8n main;
- n8n worker;
- Nginx Proxy Manager.

A running state alone does not prove these services are operational. Add lightweight checks after the baseline is stable.

## Docker networks

Verified networks:

- `mumoxa-stack_mumoxa-net`;
- `mumoxa-stack_mumoxa-network`;
- standard Docker `bridge`, `host` and `none` networks.

Two project-specific networks may be intentional, but their service membership and purpose still need inspection. Do not merge or delete either network until the Compose file and attached containers are reviewed.

## Persistent volumes

Verified named volumes:

- `mumoxa-stack_n8n_data`;
- `mumoxa-stack_npm_data`;
- `mumoxa-stack_npm_letsencrypt`;
- `mumoxa-stack_postgres_data`;
- `mumoxa-stack_redis_data`.

This confirms durable storage exists for all critical stateful services.

Docker reported approximately 78 MB in local volume usage, but showed the volumes as reclaimable because no containers were detected as actively referencing them in the summary. This is suspicious and must not be interpreted as permission to prune. Run `docker inspect` and `docker volume inspect` before any cleanup. Never run `docker system prune --volumes` on this host without a verified backup and explicit approval.

## Docker disk use

Verified Docker storage use:

- images: approximately 6.9 GB;
- containers: approximately 64 MB;
- build cache: approximately 255 MB;
- named-volume data reported: approximately 78 MB.

The final `du -sh /opt/mumoxa-stack` result was not captured and still needs to be run. Root filesystem usage previously measured 89%, so disk investigation is an immediate priority.

## Verified database work

### Existing database

The active PostgreSQL database is currently the `n8n` database, accessed with the `n8n` database role.

This works for the current prototype but is not the preferred final separation. RIP should later receive its own database and least-privilege application role through a tested migration. Do not move the existing tables yet.

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

This is a useful safety checkpoint, but it is not yet a complete backup system. Automated rotation, off-volume storage and a successful restore test are still required.

## Important architecture correction

The active stack is based on **Docker**, not rootless Podman.

The repository must not instruct contributors to migrate the live stack to Podman merely for consistency. The correct immediate rule is:

> Preserve and stabilise the working Docker stack in `/opt/mumoxa-stack`. Treat the old rootless Podman containers as legacy until they are carefully identified and retired.

No legacy container, volume or network may be deleted until its data and purpose have been confirmed.

## Current practical position

### Verified as built

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
- persistent named volumes;
- private data-service ports;
- restart policies on all active containers;
- one manual pre-schema database backup.

### Still requiring verification or completion

- Docker service enabled at host boot;
- real reboot recovery test;
- n8n, worker and Nginx Proxy Manager health checks;
- purpose and membership of both project networks;
- exact image versions rather than floating `latest` tags;
- environment-file and secret handling;
- DNS and TLS routing;
- firewall exposure, especially public port `81`;
- automated backups and retention;
- off-host or second-location backup copy;
- successful restore test;
- n8n workflow export and recovery;
- disk cleanup or filesystem expansion;
- end-to-end research execution;
- evidence verification workflow;
- review queue;
- Maps publication.

## Immediate next actions

1. Capture `/opt/mumoxa-stack` and top-level disk usage.
2. Verify Docker is enabled at boot.
3. Inspect service-to-network and service-to-volume attachments.
4. Test internal service endpoints for n8n, worker, dashboard and scraper.
5. Verify DNS and TLS through Nginx Proxy Manager.
6. Implement automated PostgreSQL backups and n8n exports.
7. Perform a restore test.
8. Only then perform a controlled reboot test.
9. After the operational baseline passes, test one existing research flow before adding a new application layer.

## Decision

Do not rebuild the foundation. The stack is materially operational and suitable for RIP version 1.

The largest immediate risks are disk pressure, untested reboot recovery, incomplete backups, missing service health checks and unresolved TLS—not the core technology choices.