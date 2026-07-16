# RIP Current Status

**Status type:** Working project record based on prior setup sessions.  
**Verification note:** The infrastructure below has been reported and partially tested during earlier work, but it has not yet been re-audited automatically from the live Oracle VM for this repository. Do not invent or assume current health; capture a fresh inventory before implementation.

## Project state

RIP (Research Intelligence Platform) is currently in the architecture, documentation and infrastructure-baseline phase.

The objective is to build an evidence-first research platform that can:

- accept research projects;
- break them into smaller tasks;
- perform long-running research;
- verify claims against inspectable sources;
- store evidence and contradictions;
- support human review;
- publish approved intelligence to Maps;
- continuously revisit and update old information.

The RIP product is not yet operational. The infrastructure foundation exists and must be preserved, verified and stabilised.

---

# Existing Infrastructure — Reported State

## Oracle Cloud VM

Reported configuration:

- Oracle Cloud Free Tier VM;
- Oracle Linux 9.x;
- ARM / aarch64 architecture;
- rootless Podman containers;
- systemd user services and lingering enabled;
- firewall and SELinux active.

Still to record from the live host:

- exact VM shape;
- CPU and memory allocation;
- disk capacity and free space;
- public and private IP configuration;
- current operating-system patch level;
- measured idle and peak resource use.

## Container runtime

Reported as working:

- Podman;
- Docker-compatible Compose provider;
- persistent volumes;
- user-level service recovery.

Known issue encountered previously:

- a Compose network label mismatch occurred for `n8n_default` and must be checked during the baseline audit.

## n8n

Reported state:

- installed and running;
- reachable internally;
- PostgreSQL node tested;
- main workflow and worker components have previously been discussed or configured.

Intended responsibility:

- high-level orchestration;
- schedules;
- approvals;
- integrations;
- pipeline coordination;
- dispatching bounded research tasks.

Important boundary:

n8n coordinates RIP but is not the evidence store and should not perform unrestricted deep research itself.

Still to verify:

- installed version;
- execution mode;
- whether queue mode is active;
- worker count and connectivity;
- encryption-key persistence;
- credential storage;
- webhook and editor URLs;
- workflow export and restore process.

## PostgreSQL

Reported state:

- PostgreSQL 17 Alpine container deployed;
- healthy;
- connected to n8n;
- `research_jobs` table created and tested with a sample record.

Future responsibility:

- projects and plans;
- tasks and attempts;
- sources and snapshots;
- entities, claims and evidence;
- reviews;
- publication versions;
- audit history.

Still to verify:

- exact container version;
- database and role permissions;
- network exposure;
- volume location and ownership;
- backup automation;
- successful restore.

The existing `research_jobs` table and test data must be preserved until a tested migration exists.

## Redis

Reported state:

- Redis 7 Alpine deployed;
- `PING` returned `PONG`;
- container health reported healthy;
- persistent volume configured.

Future responsibility:

- background queues;
- leases and locks;
- bounded retries;
- temporary coordination;
- worker task dispatch.

Still to verify:

- authentication configuration;
- persistence mode;
- maximum memory policy;
- private network exposure;
- restart recovery;
- whether n8n and RIP will share Redis safely through separate logical databases or namespaced keys.

Redis must never be the only copy of important project or evidence state.

## Nginx Proxy Manager

Reported state:

- deployed;
- some proxy hosts configured;
- internal targets for dashboard and scraper were reported online;
- public TLS routing has not been consistently reliable.

Known issue:

- `ERR_SSL_UNRECOGNIZED_NAME_ALERT` was previously reported for an n8n hostname.

Required before RIP exposure:

- confirm DNS records;
- confirm hostname and certificate matching;
- verify proxy network reachability;
- enable reliable HTTPS;
- protect admin interfaces;
- expose only required web ports.

## Ollama and AI tools

Reported as available in the wider environment:

- Ollama;
- local models on one or more machines;
- ChatGPT;
- Claude;
- Codex and OpenCode workflows.

Architecture rule:

AI may plan, classify, extract and summarise. AI output is not source evidence. The Oracle-hosted product must continue functioning when a separate local computer is offline.

Do not assume that useful local inference can run on the Oracle VM until memory and performance are measured.

## GitHub

Current state:

- private repository `Mumoxa/RIP` exists;
- product and architecture documents are stored in Git;
- `AGENTS.md` defines contributor and coding-agent rules;
- application code has not yet been built.

GitHub is the source of truth for code, migrations, safe configuration templates, specifications and exported n8n workflows. It is not the runtime research engine.

---

# What Has Been Built

- Cloud compute foundation.
- Container runtime foundation.
- n8n orchestration foundation.
- PostgreSQL database foundation and test table.
- Redis queue foundation.
- Reverse-proxy foundation.
- GitHub source-of-truth repository.
- Product blueprint and supporting specifications.

# What Has Not Been Built

- verified infrastructure inventory;
- tested backup and restore process;
- reliable public DNS and TLS for all required services;
- RIP application repository structure;
- RIP control-centre frontend;
- authentication;
- RIP business API;
- research worker;
- production database migrations;
- evidence ingestion and snapshots;
- identity resolution;
- verification and contradiction handling;
- review queue;
- Maps publishing logic;
- re-verification engine;
- operational dashboards and alerts.

---

# Constraints

RIP must:

- avoid mandatory paid services and trial-dependent components;
- prefer open-source and self-hostable software;
- remain portable away from any external free tier;
- fit the measured Oracle VM resource budget;
- be understandable and operable by a non-technical founder;
- be built incrementally;
- preserve existing infrastructure and data unless a tested migration or architecture decision explicitly approves change.

“Free forever” is a design objective, not a promise that Oracle, GitHub or another provider will never change its policies. Portability, backups and replaceable integrations are therefore mandatory.

---

# Current Gate

The project must complete the **Operational Baseline** before product coding begins:

1. inspect and record the live Oracle VM;
2. verify containers, networking, volumes and restart recovery;
3. fix DNS and TLS;
4. implement automated backups;
5. complete a restore test;
6. measure available resources;
7. confirm the smallest application deployment shape.

After this gate passes, build one controlled vertical slice:

Research request → approved plan → small research batch → stored sources and evidence → verification → human review → one Maps publication → scheduled recheck.

See `instructions/ARCHITECTURE_REVIEW.md` and `instructions/NEXT_STEPS.md` for the approved sequence.