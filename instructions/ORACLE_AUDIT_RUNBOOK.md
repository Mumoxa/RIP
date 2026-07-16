# RIP Oracle VM Audit Runbook

## Purpose

This runbook verifies the live Oracle Cloud foundation before RIP application development begins.

The audit script is read-only. It does not install packages, restart services, alter firewall rules, expose ports, or change container configuration.

## What the audit checks

- Oracle Linux version and ARM architecture;
- CPU, memory, disk and current resource use;
- Podman and Compose versions;
- containers, images, health, ports and restart policies;
- Podman networks and persistent volumes;
- user-level systemd services and lingering;
- PostgreSQL and Redis readiness and exposure clues;
- n8n, Nginx Proxy Manager and related service presence;
- firewall and SELinux state;
- DNS and TLS clues for known RIP hostnames;
- backup files and backup timers;
- failed services and exited containers.

## Safety boundaries

The script deliberately does not print:

- environment variables;
- passwords;
- API keys;
- container environment configuration;
- database records;
- configuration file contents;
- private keys.

The report may contain hostnames, local IP addresses, public listener information and filesystem paths. Review it before sharing publicly. It may be shared privately for the RIP audit.

## How to run it

From the Oracle VM, use the checked-out RIP repository:

```bash
cd ~/RIP
git pull
chmod +x scripts/audit_oracle_vm.sh
./scripts/audit_oracle_vm.sh
```

The script writes a dated report similar to:

```text
/home/opc/rip-audit-20260716T123456Z.txt
```

To display the report:

```bash
cat ~/rip-audit-*.txt
```

To show only the latest report:

```bash
cat "$(ls -1t ~/rip-audit-*.txt | head -n 1)"
```

## When the repository is not yet cloned on Oracle

Clone it first using an authenticated GitHub method. Do not paste a GitHub token into chat or commit it to the repository.

```bash
cd ~
git clone https://github.com/Mumoxa/RIP.git
cd RIP
chmod +x scripts/audit_oracle_vm.sh
./scripts/audit_oracle_vm.sh
```

A private repository will prompt for authentication unless SSH or GitHub CLI authentication is already configured.

## Audit stages

### Stage A — Read-only inventory

Run the script and review the report. No reboot or configuration change occurs.

### Stage B — Risk assessment

Classify findings as:

- Critical: public data service, missing persistence, severe disk pressure, broken database, or exposed secret;
- High: no backups, no restart recovery, unreliable TLS, unhealthy core service;
- Medium: undocumented configuration, stale packages, weak resource headroom, missing health check;
- Low: naming, cleanup, or documentation issues.

### Stage C — Controlled verification

Only after reviewing Stage A:

- test backup creation;
- test restore into a separate temporary database;
- repair DNS and TLS;
- verify PostgreSQL and Redis remain private;
- plan a controlled reboot and confirm recovery.

Do not reboot or alter production services until the current state and rollback path are understood.

## Required audit output

The final audit record must include:

- date and time;
- commands or script version used;
- confirmed infrastructure inventory;
- confirmed healthy and unhealthy services;
- public exposure findings;
- backup and restore status;
- reboot recovery status;
- resource capacity assessment;
- risks and remediation order;
- decision on the minimum RIP deployment shape.

## Completion rule

The Oracle Operational Baseline passes only when:

1. the live stack has been inventoried;
2. core services are healthy;
3. PostgreSQL and Redis are private;
4. services recover after a controlled reboot;
5. HTTPS routing works for approved public endpoints;
6. an automated PostgreSQL backup exists;
7. a backup has been successfully restored;
8. n8n workflows can be exported and restored;
9. resource headroom is sufficient for the selected RIP application shape.
