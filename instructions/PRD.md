# RIP Product Requirements Document

## 1. Product

RIP is a self-hosted Research Intelligence Platform that accepts a plain-English research brief, breaks it into manageable tasks, runs research over time, stores source evidence, verifies findings, and publishes approved results to Maps.

## 2. Primary user

The initial user is the platform owner and research operator. The interface must be understandable without technical knowledge.

## 3. Core outcomes

RIP must allow the user to:

1. Create a research project in plain English.
2. Review and approve the proposed research plan.
3. See live progress at project, batch, task, entity, and source level.
4. Pause, resume, cancel, retry, and deepen research.
5. Review evidence and contradictions.
6. Approve or reject individual records.
7. Publish verified records to Maps.
8. Recheck published records on a schedule.
9. Export results without losing evidence links.

## 4. Non-negotiable principles

- Existing Oracle VM, Podman/Docker, n8n, PostgreSQL, and Redis remain the foundation.
- No material claim may be treated as verified without stored evidence.
- AI output is never evidence.
- Every claim must link to a source, retrieval time, and extracted supporting passage.
- The system must distinguish facts, inferences, conflicts, and unresolved questions.
- Human approval is required before public publication in version 1.
- Failed tasks must be visible and retryable.
- The platform must work incrementally and preserve completed work.
- Secrets and personal data must never be committed to GitHub.

## 5. Version 1 scope

### Included

- Single-user authentication.
- Research project creation.
- Plan generation and approval.
- Task batching.
- Queue-based execution.
- Web and public-source research.
- Entity resolution.
- Evidence extraction.
- Confidence scoring.
- Human review queue.
- Maps publishing.
- Scheduled re-verification.
- CSV export.
- Operational dashboard and error visibility.

### Excluded from version 1

- Paid data providers.
- Automated access that breaches platform terms.
- Fully autonomous publication.
- Multi-tenant billing.
- Mobile application.
- Complex enterprise permissions.

## 6. Core workflow

Research brief → plan → owner approval → task creation → queued execution → evidence collection → entity resolution → claim verification → QA review → owner approval → Maps publication → scheduled recheck.

## 7. Functional requirements

### Project creation

The user can provide a project title, objective, geography, target entities, skills or attributes, exclusions, source preferences, depth, and verification threshold.

### Planning

The system produces a readable plan containing workstreams, search strategies, expected outputs, batch sizes, risks, and estimated task count. No research begins until approved.

### Execution

Each task has an owner service, status, attempts, timestamps, dependencies, priority, and error history. Work resumes safely after restarts.

### Evidence

Each evidence item stores source URL, source type, publisher, retrieval time, captured text, claim supported, entity concerned, and reliability assessment.

### Verification

The verifier evaluates identity, recency, source independence, consistency, and claim strength. Contradictions are preserved rather than overwritten.

### Review

The user can view the proposed conclusion beside supporting and conflicting evidence, then approve, reject, edit, or request deeper research.

### Publishing

Only approved entities and approved claims are published. Public pages show verification status, last verified date, and source references where legally and ethically appropriate.

### Monitoring

Published records receive a next-review date. Rechecking creates new evidence and history rather than silently replacing old information.

## 8. Success measures

- A complete small research project can run end to end without manual database work.
- Every published claim is traceable to evidence.
- The user can identify where a job is stuck within two clicks.
- Restarting a service does not lose completed work.
- A failed task can be retried without rerunning the whole project.
- Maps can publish an approved record from the review screen.

## 9. Product rule

A feature is valuable only when it improves research quality, verification, operational visibility, or the usefulness of Maps.