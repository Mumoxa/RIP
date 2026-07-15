# RIP UI Specification

## 1. Design objective

The UI is the control centre for autonomous research. It must make work visible, understandable, interruptible, and trustworthy to a non-technical operator.

## 2. Navigation

Primary navigation:

- Dashboard
- Projects
- Review Queue
- Maps
- Sources
- System
- Settings

A persistent top bar shows global search, running-task count, alerts, and system health.

## 3. Dashboard

The dashboard answers four questions immediately:

1. What is running?
2. What needs my attention?
3. What completed recently?
4. Is the system healthy?

Components:

- Active projects with progress and current stage.
- Items awaiting approval.
- Failed or blocked tasks.
- Recently verified entities.
- Recently published Maps records.
- Worker, queue, database, n8n, and storage health.
- Daily and weekly research activity.

No decorative metrics without an operational purpose.

## 4. Create Project

A guided workflow replaces a generic form.

### Step 1 — Research objective

- Project name.
- Plain-English objective.
- Desired final output.
- Example of an ideal result.

### Step 2 — Scope

- Countries or regions.
- Industries.
- Entity types.
- Skills, technologies, titles, or attributes.
- Required inclusions.
- Exclusions.

### Step 3 — Evidence standard

- Required source count.
- Preferred source types.
- Recency threshold.
- Confidence threshold.
- Whether human approval is mandatory.

### Step 4 — Research depth

- Quick validation.
- Standard research.
- Deep research.
- Custom limits for batches, sources, and retries.

### Step 5 — Generated plan

The system displays the workstreams, task count, queries, likely sources, risks, and completion conditions. The user may edit, approve, or regenerate the plan.

## 5. Project Workspace

Tabs:

- Overview
- Plan
- Tasks
- Entities
- Evidence
- Review
- Activity
- Settings

### Overview

Shows progress by stage, records discovered, records verified, evidence count, conflicts, failures, and publishing readiness.

### Plan

Displays approved workstreams and dependencies in plain language. Changes create a new plan version.

### Tasks

Table and kanban views with filters for status, type, batch, priority, attempt count, and assigned worker. Actions include pause, resume, retry, cancel, and inspect logs.

### Entities

One row per candidate, company, technology, or other researched entity. Shows identity confidence, key claims, verification state, and last activity.

### Evidence

Searchable evidence ledger. Each item shows source, captured passage, retrieval date, supported claim, reliability, and whether it conflicts with other evidence.

### Review

Displays records ready for human decisions.

### Activity

Plain-language audit trail of plans, searches, agent decisions, retries, approvals, and publications.

## 6. Entity Review Screen

The review screen must never force the user to trust a score alone.

Layout:

- Proposed entity summary.
- Identity evidence.
- Claim-by-claim table.
- Supporting sources.
- Conflicting sources.
- Missing evidence.
- Confidence explanation.
- Last checked and next review dates.

Actions:

- Approve for Maps.
- Approve privately only.
- Reject.
- Edit factual metadata.
- Request deeper research.
- Merge duplicate.
- Split incorrectly merged identities.

## 7. Maps Administration

Views:

- Ready to publish.
- Published.
- Stale.
- Unpublished.
- Removed.

Each record provides preview, source visibility controls, public wording, verification badge, last verified date, and publish/unpublish actions.

## 8. Sources Screen

Shows source domains, success rate, recency, reliability classification, robots or access restrictions, error rate, and number of claims supported.

Blocked or prohibited sources must be clearly marked and excluded from automated access.

## 9. System Screen

Health cards:

- Oracle host resources.
- Containers.
- n8n.
- PostgreSQL.
- Redis.
- Research workers.
- Queue depth.
- Storage usage.
- Recent failures.

The user receives plain-language explanations and recommended next actions, not raw logs only.

## 10. Required states

Every screen must include:

- Loading state.
- Empty state.
- Success confirmation.
- Error state with recovery action.
- Permission or unavailable state where relevant.

## 11. Accessibility and usability

- Clear language and limited jargon.
- Responsive layout.
- Keyboard navigation.
- Accessible contrast.
- Confirmation for destructive actions.
- No hidden autonomous action.
- Important statuses must use text, not colour alone.

## 12. Version 1 screen order

1. Login.
2. Dashboard.
3. Create Project.
4. Generated Plan approval.
5. Project Workspace.
6. Review Queue.
7. Entity Review.
8. Maps Administration.
9. System Health.

The first usable milestone is one project moving through all nine screens into a published Maps record.