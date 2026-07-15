# RIP — Research Intelligence Platform (RIP)

Version: 0.1
Status: Founding Product Blueprint

## Vision

RIP is an open-source, cloud-hosted research operating system that accepts plain-English research requests, breaks them into smaller tasks, performs long-running research, verifies findings against multiple sources, and publishes approved results to Maps.

Core principles:

- Open source.
- Free to operate long term.
- Deployable on Oracle Cloud free tier.
- Understandable to a non-technical founder.
- Built incrementally on the existing stack.

## Locked Foundation

The existing stack is the permanent foundation:

- Oracle Cloud VM
- Podman / Docker
- n8n
- PostgreSQL
- Redis

Future work must extend this foundation rather than replace it.

## Product Goal

Transform research from one-off reports into a continuously updated intelligence asset.

Research outputs must be:

- searchable;
- versioned;
- evidence-backed;
- continuously refreshed;
- publishable.

## Core Modules

### Research Control Centre

- Create research projects.
- Define goals in plain English.
- Track progress.
- Review evidence.
- Approve publication.

### Research Engine

Break large requests into smaller tasks.

Example:

"Find senior backend engineers in Germany with Kubernetes and Go."

Tasks:

- Identify target companies.
- Search public sources.
- Verify employment history.
- Extract skills.
- Resolve identity conflicts.
- Calculate confidence.

### Verification Engine

Nothing is published without evidence.

Rules:

- Minimum of two independent sources.
- Contradictions flagged.
- Confidence scoring.
- Human review.

Statuses:

- Verified
- Needs Review
- Stale
- Rejected

### Maps Publishing Engine

Public website containing approved intelligence.

Each record includes:

- Entity details.
- Skills.
- Evidence summary.
- Confidence score.
- Last verification date.

### Continuous Monitoring

- Detect changes.
- Refresh stale records.
- Flag conflicts.

## Initial UI

1. Dashboard.
2. Create Research Project.
3. Live Progress.
4. Review Queue.
5. Maps Administration.

## AI Roles

- Planner.
- Researcher.
- Verifier.
- QA Reviewer.
- Publisher.

## Core Data Model

Tables:

- research_projects
- research_tasks
- evidence
- entities
- publication_queue

## Recommended Technology

Frontend:

- Next.js

Backend:

- FastAPI

Workflow:

- n8n

Database:

- PostgreSQL

Queue:

- Redis

AI:

- Ollama

Deployment:

- Oracle Cloud

## Development Principle

Every feature must answer:

1. Does it create evidence?
2. Can it be verified?
3. Does it strengthen Maps?

## Immediate Roadmap

1. Design the UI.
2. Create the database schema.
3. Build the first research worker.
4. Create Maps publishing.
5. Enable continuous research.
