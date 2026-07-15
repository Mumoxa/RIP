# RIP Database Specification

## 1. Principle

PostgreSQL is the durable system of record. Redis, n8n, logs, and AI prompts are supporting systems and must not contain the only copy of important state.

## 2. Data rules

- Use UUID primary keys for new RIP tables.
- Store timestamps in UTC.
- Prefer append-only history for evidence, verification, and publication changes.
- Never overwrite conflicting evidence.
- Every automated decision records model, prompt version, timestamp, and input references.
- Personal information must have a lawful purpose, retention rule, and visibility classification.

## 3. Core tables

### users

- id
- email
- password_hash or external_auth_id
- role
- is_active
- created_at
- updated_at

### research_projects

- id
- title
- objective
- desired_output
- status
- owner_id
- scope_json
- evidence_policy_json
- approved_plan_version_id
- created_at
- updated_at
- completed_at

Suggested statuses: draft, planning, awaiting_plan_approval, queued, running, paused, awaiting_review, completed, cancelled, failed.

### research_plan_versions

- id
- project_id
- version_number
- plan_json
- generated_by
- model_name
- prompt_version
- approval_status
- approved_by
- approved_at
- created_at

### research_batches

- id
- project_id
- plan_version_id
- name
- sequence_number
- status
- completion_condition_json
- created_at
- started_at
- completed_at

### research_tasks

- id
- project_id
- batch_id
- parent_task_id
- task_type
- title
- instructions_json
- status
- priority
- queue_name
- dependency_count
- max_attempts
- attempt_count
- lease_expires_at
- assigned_worker_id
- created_at
- started_at
- completed_at
- last_error

Suggested statuses: pending, blocked, queued, leased, running, succeeded, retry_wait, failed, cancelled.

### task_attempts

- id
- task_id
- attempt_number
- worker_id
- started_at
- completed_at
- status
- input_json
- output_json
- error_code
- error_message
- log_reference

### sources

- id
- canonical_url
- domain
- source_type
- publisher
- access_policy
- reliability_class
- first_seen_at
- last_checked_at

### source_snapshots

- id
- source_id
- retrieved_at
- http_status
- content_hash
- title
- extracted_text
- raw_storage_reference
- retrieval_method
- robots_allowed
- metadata_json

### entities

- id
- entity_type
- canonical_name
- public_slug
- lifecycle_status
- identity_confidence
- visibility
- created_at
- updated_at

Entity types may include person, company, role, skill, technology, location, project, and publication.

### entity_identifiers

- id
- entity_id
- identifier_type
- identifier_value
- source_id
- confidence
- is_primary

Examples: LinkedIn URL, GitHub username, company domain, public profile URL, or internal external-system key.

### entity_relationships

- id
- subject_entity_id
- relationship_type
- object_entity_id
- valid_from
- valid_to
- confidence
- status
- created_at

Examples: works_at, held_role, located_in, has_skill, contributed_to, acquired_by.

### claims

- id
- project_id
- entity_id
- claim_type
- claim_value_json
- valid_from
- valid_to
- status
- confidence_score
- created_at
- updated_at

Suggested statuses: proposed, supported, verified, conflicting, rejected, stale.

### evidence_items

- id
- claim_id
- source_snapshot_id
- task_id
- evidence_type
- supporting_excerpt
- evidence_position_json
- stance
- source_independence_group
- reliability_score
- recency_score
- created_at

Stance values: supports, contradicts, contextual, inconclusive.

### identity_candidates

- id
- project_id
- entity_id
- candidate_entity_id
- match_features_json
- match_score
- decision
- decided_by
- decided_at

### verification_runs

- id
- entity_id
- project_id
- ruleset_version
- model_name
- prompt_version
- input_claim_ids
- result_json
- confidence_score
- outcome
- created_at

### review_items

- id
- project_id
- entity_id
- review_type
- priority
- status
- reason_json
- assigned_to
- created_at
- decided_at
- decision_notes

### publication_records

- id
- entity_id
- current_version_id
- publication_status
- public_slug
- published_at
- unpublished_at
- next_review_at

### publication_versions

- id
- publication_record_id
- version_number
- public_payload_json
- approved_claim_ids
- source_visibility_json
- approved_by
- approved_at
- created_at

### audit_events

- id
- actor_type
- actor_id
- action
- object_type
- object_id
- before_json
- after_json
- created_at

### workers

- id
- name
- worker_type
- version
- status
- capabilities_json
- last_heartbeat_at
- current_task_id

## 4. Existing table migration

The existing `research_jobs` table must not be deleted. It should be assessed and either:

1. migrated into `research_projects`; or
2. retained temporarily as a legacy table with a documented migration path.

Any migration must preserve the existing test record and timestamps.

## 5. Indexes

Create indexes for:

- task status, priority, and queue;
- project and batch foreign keys;
- canonical URLs and domains;
- entity type and canonical name;
- identifiers by type and value;
- claims by entity, type, and status;
- review status and priority;
- publication status and next review date;
- timestamps used in monitoring.

## 6. Search

Version 1 can use PostgreSQL full-text and trigram indexes. A separate search engine should only be introduced when measured need justifies it.

## 7. Retention and privacy

- Preserve verification history.
- Define retention for raw source snapshots and personal data.
- Support unpublishing without erasing the audit history.
- Support lawful correction and deletion workflows where required.
- Public Maps payloads must be separated from private research data.