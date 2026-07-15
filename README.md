# RIP — Research Intelligence Platform

RIP is an evidence-first, self-hosted platform for planning, executing, verifying, reviewing, and publishing long-running research projects.

## Product objective

A user submits a plain-English research brief. RIP breaks the work into small tasks, gathers public-source evidence, resolves identities, verifies claims, presents uncertain or conflicting findings for review, and publishes approved results to Maps.

## Foundation

RIP extends the existing infrastructure:

- Oracle Cloud VM
- Oracle Linux
- rootless Podman/Docker Compose
- Nginx Proxy Manager
- n8n
- PostgreSQL
- Redis

Planned additions include a Next.js control centre, FastAPI backend, Python research worker, and Maps publishing layer.

## Current status

The repository is in the specification and foundation stage. The first implementation target is one complete vertical slice:

Create project → approve plan → research a small batch → capture evidence → verify claims → human review → publish one Maps record → schedule a recheck.

## Documentation

Start here:

- `AGENTS.md` — mandatory instructions for coding agents and contributors.
- `instructions/RIP_blueprint_v0.1.md` — founding blueprint.
- `instructions/PRD.md` — product requirements.
- `instructions/UI_SPEC.md` — control-centre screens and workflows.
- `instructions/ARCHITECTURE.md` — service architecture and deployment boundaries.
- `instructions/DATABASE.md` — proposed PostgreSQL data model.
- `instructions/RESEARCH_ENGINE.md` — research, verification, and queue behaviour.
- `instructions/MAPS_SPEC.md` — public publishing and privacy rules.

## Core principles

- AI output is not evidence.
- Every material claim must be traceable to a source.
- Contradictions are preserved and reviewed.
- Human approval is required before publication in version 1.
- PostgreSQL is the durable system of record.
- Existing infrastructure is extended, not replaced.
- Scale follows reliability.

## Repository safety

Never commit secrets, `.env` files, database dumps, production personal data, or private research exports. See `.gitignore` and `AGENTS.md`.

## Owner

Mumoxa
