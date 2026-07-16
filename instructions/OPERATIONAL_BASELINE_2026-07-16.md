# RIP Operational Baseline — 16 July 2026

## Verified live runtime

The active RIP foundation is the rootful Docker Compose stack in `/opt/mumoxa-stack`.

Docker is confirmed:

- enabled at host boot;
- active at the time of inspection;
- running all seven Compose services;
- configured with `restart=unless-stopped` on every active container.

This confirms reboot recovery is configured. A controlled reboot test is still required after backups and TLS are verified.

## Verified active services

- `mumoxa-postgres` — running and healthy;
- `mumoxa-redis` — running and healthy;
- `mumoxa-n8n` — running;
- `mumoxa-n8n-worker` — running;
- `mumoxa-nginx-proxy-manager` — running;
- `mumoxa-scraper` — running and healthy;
- `mumoxa-dashboard` — running and healthy.

Only Nginx Proxy Manager publishes host ports. PostgreSQL, Redis, n8n, dashboard and scraper remain internal to Docker networking.

## Verified persistence

Named volumes exist for:

- PostgreSQL;
- Redis;
- n8n;
- Nginx Proxy Manager data;
- Nginx Proxy Manager certificates.

The application source/configuration directory `/opt/mumoxa-stack` uses approximately 70 MB. Most runtime storage is under Docker's data root rather than inside that directory.

## Disk status — immediate operational risk

The root filesystem is:

```text
30 GB total
27 GB used
3.5 GB available
89% used
```

Docker currently accounts for approximately:

- 6.9 GB of active images;
- 64 MB of writable container layers;
- 255 MB of build cache;
- 78 MB of named-volume data reported by `docker system df`.

The largest active images are approximately:

- n8n: 2.41 GB;
- scraper: 2.18 GB;
- Nginx Proxy Manager: 1.79 GB;
- PostgreSQL: 414 MB;
- dashboard: 255 MB;
- Redis: 58 MB.

These images are active and must not be removed. No `docker system prune --volumes` command may be run.

The 6.9 GB of active Docker images does not fully explain the 27 GB used on `/`. The host requires a read-only top-level disk investigation before any cleanup.

## Network status

Two Compose project networks exist:

- `mumoxa-stack_mumoxa-net`;
- `mumoxa-stack_mumoxa-network`.

The prior network-membership command did not return a captured result. Their membership and purpose remain unresolved. Neither network may be deleted until the Compose file and container attachments are inspected.

## Current gate status

### Passed

- host operating system and capacity recorded;
- active runtime identified as Docker;
- active Compose services recorded;
- container restart policies confirmed;
- Docker enabled and active;
- internal/public port boundaries confirmed;
- persistent named volumes confirmed;
- initial database schema and dashboard connection confirmed;
- one manual PostgreSQL backup created.

### Outstanding

- identify the directories consuming the remaining root disk;
- inspect network membership;
- inspect actual mounts for each container;
- verify DNS and TLS;
- add automated backups and retention;
- copy backups to a second location;
- perform a restore test;
- export and restore-test n8n workflows;
- perform a controlled reboot test;
- add health checks for n8n, n8n worker and Nginx Proxy Manager;
- pin floating image tags after current versions are recorded;
- test one complete research flow.

## Safe next commands

Run these read-only commands as root:

```bash
echo "=== TOP-LEVEL ROOT USAGE ==="
du -xhd1 / 2>/dev/null | sort -h

echo "=== VAR USAGE ==="
du -xhd1 /var 2>/dev/null | sort -h

echo "=== HOME USAGE ==="
du -xhd1 /home 2>/dev/null | sort -h

echo "=== OPT USAGE ==="
du -xhd1 /opt 2>/dev/null | sort -h

echo "=== DOCKER ROOT DIRECTORY ==="
docker info --format '{{.DockerRootDir}}'

echo "=== JOURNAL SIZE ==="
journalctl --disk-usage

echo "=== CONTAINER NETWORKS ==="
for c in $(docker ps --format '{{.Names}}'); do
  echo "--- $c"
  docker inspect --format '{{range $name,$network := .NetworkSettings.Networks}}{{$name}} {{end}}' "$c"
done

echo "=== CONTAINER MOUNTS ==="
for c in $(docker ps --format '{{.Names}}'); do
  echo "--- $c"
  docker inspect --format '{{range .Mounts}}{{.Type}} {{.Name}} {{.Source}} -> {{.Destination}}{{println}}{{end}}' "$c"
done
```

Do not delete anything until the output has been reviewed.

## Decision

The core architecture remains suitable. Disk pressure is now the first operational problem to solve, followed by backups, TLS and a controlled reboot test. Product expansion should wait until these baseline gates pass.
