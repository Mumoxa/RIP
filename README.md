# RIP — Research Intelligence Platform

RIP is an evidence-first, self-hosted platform for planning, executing, verifying, reviewing and publishing long-running research projects.

## Product objective

A user submits a plain-English research brief. RIP breaks the work into small tasks, gathers public-source evidence, resolves identities, verifies claims, presents uncertain or conflicting findings for review, and publishes approved results to Maps.

## Foundation

RIP extends the existing infrastructure:

- Oracle Cloud VM;
- Oracle Linux;
- rootless Podman with Compose compatibility;
- Nginx Proxy Manager;
- n8n;
- PostgreSQL;
- Redis;
- GitHub as the code and documentation source of truth.

The application layer is provisionally expected to include a web control centre, a business API and a Python research worker. The final deployment shape will be confirmed after the Oracle VM resource audit.

## Current status

The product is in the specification and operational-baseline stage.

Infrastructure has been installed and partially tested during prior setup sessions, but the repository does not yet contain a fresh automated audit of the live Oracle VM. Before application coding begins, RIP must verify the live inventory, reboot recovery, private networking, DNS/TLS, backups and restore capability.

After that gate passes, the first implementation target is one complete vertical slice:

Create project → approve plan → research a batch of no more than five targets → capture evidence → verify claims → human review → publish one Maps record → schedule a recheck.

## Documentation

Start here:

- `AGENTS.md` — mandatory instructions for coding agents and contributors.
- `instructions/CURRENT_STATUS.md` — reported live infrastructure and outstanding verification.
- `instructions/ARCHITECTURE_REVIEW.md` — reviewed architecture decision and corrected build sequence.
- `instructions/NEXT_STEPS.md` — gated implementation roadmap.
- `instructions/RIP_blueprint_v0.1.md` — founding blueprint.
- `instructions/PRD.md` — product requirements.
- `instructions/UI_SPEC.md` — control-centre screens and workflows.
- `instructions/ARCHITECTURE.md` — service architecture and deployment boundaries.
- `instructions/DATABASE.md` — target PostgreSQL domain model; not all tables are required immediately.
- `instructions/RESEARCH_ENGINE.md` — research, verification and queue behaviour.
- `instructions/MAPS_SPEC.md` — public publishing and privacy rules.

## Core principles

- AI output is not evidence.
- Every material claim must be traceable to a source.
- Contradictions are preserved and reviewed.
- Human approval is required before publication in version 1.
- PostgreSQL is the durable system of record.
- Existing infrastructure is extended, not replaced without an approved decision.
- Backups and restore tests precede production schema expansion.
- Scale follows reliability.
- External free tiers are replaceable dependencies, not permanent guarantees.

## Repository safety

Never commit secrets, `.env` files, database dumps, production personal data or private research exports. See `.gitignore` and `AGENTS.md`.

## Owner

Mumoxa