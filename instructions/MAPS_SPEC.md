# RIP Maps Publishing Specification

## 1. Purpose

Maps is the public, owner-controlled knowledge layer created from RIP research. It is not a raw database dump and not an AI-generated report site. It publishes selected, approved, evidence-backed intelligence.

## 2. Publishing principles

- Private research and public content remain separate.
- Human approval is mandatory in version 1.
- Only approved claims may appear publicly.
- Publication must preserve source traceability internally.
- Public source display is controlled per claim and source.
- AI-generated wording may summarise verified claims but may not add facts.
- Uncertainty, recency, and verification dates must be visible.

## 3. Public record types

Version 1 should support:

- Candidate or professional profile.
- Company profile.
- Skill or technology pool.
- Market map.

The data model should permit additional entity types later.

## 4. Public candidate profile

Potential fields:

- Public name, initials, pseudonym, or anonymous identifier according to the approved privacy mode.
- Current verified role and company where lawful and appropriate.
- Location at an approved level of precision.
- Verified skills.
- Industry and domain experience.
- Evidence-backed career highlights.
- Confidence or verification badge.
- Last verified date.
- Source references selected for public display.
- Contact or consent status where applicable.

Private contact details, internal notes, confidence calculations, rejected claims, and sensitive data must not be exposed.

## 5. Anonymity and visibility modes

Each entity and field must support explicit visibility:

- private;
- internal summary;
- anonymous public;
- identified public;
- source-link visible;
- source-link hidden but internally retained.

The platform owner selects the mode before publication. Publication rules must account for POPIA, lawful purpose, consent, source terms, and reputational risk.

## 6. Verification display

Recommended public statuses:

- Verified: required evidence standard met.
- Partially Verified: selected claims verified but material gaps remain.
- Needs Refresh: verification age exceeds the configured threshold.
- Historical: accurate for a stated past period and not presented as current.

Do not display a percentage without a plain-language explanation.

## 7. Publication workflow

1. Entity reaches review-ready state.
2. Owner reviews claims and sources.
3. Owner selects public fields and anonymity mode.
4. System generates a preview from approved claims.
5. Owner approves the exact public version.
6. Publisher creates an immutable publication version.
7. Public page updates atomically.
8. Audit event and next-review date are recorded.

## 8. Versioning

Every public change creates a new publication version containing:

- approved claim IDs;
- public payload;
- source visibility rules;
- approver;
- approval time;
- publication time;
- reason for change.

Previous versions remain available internally for audit and rollback.

## 9. Corrections and removal

The owner must be able to:

- correct a public field;
- unpublish a claim;
- unpublish the whole record;
- mark a record stale;
- replace a public version after re-verification;
- record the reason for a correction or removal.

Unpublishing should remove public access quickly while retaining necessary internal audit history.

## 10. Public search and navigation

Maps should support filters appropriate to the content, such as:

- geography;
- company;
- role family;
- skill;
- seniority;
- industry;
- verification status;
- last verified period.

Search results must not expose private fields through URLs, metadata, APIs, page source, or client-side payloads.

## 11. SEO and indexing

Public indexing is configurable by map, entity, and page. Anonymous or sensitive profiles should default to noindex until a deliberate publication policy is approved.

## 12. Public API

A public read-only API may be added later. It must expose only the approved public payload, use rate limits, and never query private research tables directly.

## 13. Maps administration

The private control centre must provide:

- preview;
- field visibility controls;
- anonymous versus identified mode;
- source-link controls;
- publish and unpublish;
- version history;
- stale records;
- scheduled rechecks;
- correction and removal workflow.

## 14. First Maps milestone

Publish one approved record from the RIP review queue to a public Maps page with:

- controlled fields;
- verification status;
- last verified date;
- at least one approved evidence reference where appropriate;
- version history;
- unpublish capability.

The first milestone is trustworthy publication, not a large public directory.