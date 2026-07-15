# RIP Research Engine Specification

## 1. Purpose

The research engine turns a large research objective into small, bounded, retryable tasks that collect, verify, and organise source-backed information.

## 2. Core rule

The engine must never treat generated text as proof. AI may propose searches, interpret sources, classify evidence, and summarise verified facts, but every material claim must trace back to stored source evidence.

## 3. Processing stages

### Stage 1 — Brief interpretation

Convert the user's plain-English request into structured scope, required outputs, exclusions, evidence standard, completion conditions, and risk flags.

### Stage 2 — Planning

Create versioned workstreams, search strategies, batch definitions, task dependencies, expected evidence types, and stopping rules. Human approval is required in version 1.

### Stage 3 — Discovery

Generate targeted source queries and discover candidate entities. Discovery results are leads only and cannot be published.

### Stage 4 — Retrieval

Fetch permitted public source content, record retrieval metadata, and store a source snapshot or durable reference.

### Stage 5 — Extraction

Extract possible entities, identifiers, relationships, dates, skills, roles, employers, locations, and claim-supporting passages.

### Stage 6 — Identity resolution

Compare identifiers, timelines, employers, locations, names, education, public handles, and other evidence. Keep ambiguous identities separate until confidence is sufficient.

### Stage 7 — Verification

Evaluate each claim for source quality, independence, recency, consistency, specificity, and contradiction.

### Stage 8 — QA

A separate QA pass challenges the conclusion, searches for disconfirming evidence, checks unsupported wording, and identifies unresolved gaps.

### Stage 9 — Human review

The owner approves, rejects, edits, merges, splits, or requests deeper research.

### Stage 10 — Publication and monitoring

Approved claims are transformed into a public Maps payload. Re-verification tasks are scheduled based on volatility and last verified date.

## 4. Agent and service roles

### Planner

Produces the structured plan and task graph. It cannot approve its own plan.

### Query Generator

Creates diverse, targeted searches from the approved plan while avoiding duplicate or overly broad queries.

### Research Worker

Performs one bounded task, records all source interactions, and returns structured output.

### Extractor

Converts source content into proposed claims and exact supporting excerpts.

### Identity Resolver

Determines whether records refer to the same real-world entity and explains match or mismatch evidence.

### Verifier

Scores claim support and identifies contradictions.

### QA Challenger

Attempts to disprove or weaken the proposed conclusion.

### Publisher

Publishes only an approved version containing approved claims.

## 5. Task design

Each task must contain:

- objective;
- inputs and dependencies;
- allowed source types;
- expected structured output;
- evidence requirements;
- time or result limit;
- retry policy;
- completion condition;
- failure classification.

Tasks should normally finish in minutes, not hours. Long projects are achieved through many small tasks and persistent state.

## 6. Batch strategy

Projects are divided into controlled batches, for example 10–50 entities depending on task complexity. A batch completes verification and QA before uncontrolled expansion begins. This limits wasted work and allows the user to refine the approach from actual results.

## 7. Queue behaviour

- PostgreSQL holds canonical task state.
- Redis carries runnable task messages and leases.
- A worker leases one task at a time.
- Heartbeats extend the lease.
- The result is stored durably before acknowledgement.
- Expired leases return eligible tasks to the queue.
- Tasks exceeding retry limits move to a visible failed or dead-letter state.

## 8. Verification model

Confidence must be explainable and claim-specific. Suggested inputs:

- identity match strength;
- number of supporting sources;
- source independence;
- source authority;
- directness of evidence;
- recency;
- timeline consistency;
- contradiction severity;
- missing required evidence.

A high aggregate score must never hide a critical contradiction.

## 9. Source standards

- Prefer primary and authoritative sources.
- Preserve the exact URL and retrieval timestamp.
- Store the specific passage supporting the claim.
- Group syndicated or copied content so it does not count as independent confirmation.
- Distinguish current facts from historical facts.
- Do not automate access where prohibited or technically restricted.
- Search-engine snippets alone are not sufficient evidence when the underlying source can be checked.

## 10. Failure types

Failures must be classified as:

- temporary network failure;
- blocked or prohibited access;
- source removed;
- parsing failure;
- insufficient evidence;
- ambiguous identity;
- contradiction;
- model output invalid;
- worker or infrastructure failure;
- policy or privacy restriction.

Each type has a specific retry or review action.

## 11. Research completion

A project is complete when its approved completion conditions are met, not merely when no tasks remain. Completion conditions may include target quantity, required coverage, verification threshold, unresolved-conflict limit, and export or publication readiness.

## 12. Continuous research

Rechecks should be risk-based:

- volatile employment data: more frequent;
- stable historical facts: less frequent;
- weakly supported claims: earlier recheck;
- newly published profiles: initial confirmation cycle;
- failed sources: alternative-source task.

Rechecking creates new snapshots and verification history.

## 13. First working research project

The initial implementation must handle one narrow project end to end:

1. user submits a defined candidate or company research brief;
2. plan is generated and approved;
3. a small batch is researched;
4. source evidence is captured;
5. identities and claims are verified;
6. records appear in the review queue;
7. one approved record is published to Maps;
8. a recheck date is scheduled.

Scale is not the first milestone. Reliable completion is.