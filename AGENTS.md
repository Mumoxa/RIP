# RIP Agent Instructions

These instructions apply to every AI coding agent, developer, automation, and contribution in this repository.

## 1. Read first

Before changing anything:

1. Read this file.
2. Read `instructions/RIP_blueprint_v0.1.md`.
3. Read the relevant specification files in `instructions/`.
4. Inspect the existing repository and deployment structure.
5. Confirm what already exists before creating new components.

Do not invent repository state, infrastructure, credentials, APIs, test results, or completed work.

## 2. Product mission

RIP is an evidence-first Research Intelligence Platform. It plans research, executes small tasks, stores source evidence, verifies claims, supports human review, and publishes approved results to Maps.

AI output is not evidence. Every material factual claim must trace to a stored source.

## 3. Locked foundation

Preserve and extend:

- Oracle Cloud VM running Oracle Linux;
- rootless Podman/Docker Compose;
- Nginx Proxy Manager;
- n8n;
- PostgreSQL;
- Redis.

Do not replace these services or introduce a competing orchestration, database, or queue system without an explicit architecture decision approved by the owner.

## 4. Working method

- Make the smallest complete change that advances one working user flow.
- Prefer vertical slices over disconnected infrastructure.
- Do not build multiple speculative agents before one end-to-end workflow succeeds.
- Reuse existing code and conventions.
- Keep changes reversible.
- Add migrations rather than manually changing production data.
- Preserve existing data and the legacy `research_jobs` table until a tested migration exists.
- Record meaningful decisions in documentation.

## 5. Evidence and research rules

- Never present model-generated text as a source.
- Store source URL, retrieval time, source snapshot or durable reference, and supporting passage.
- Preserve contradictions.
- Distinguish fact, inference, lead, and unresolved claim.
- Search snippets alone are not verification when the source can be inspected.
- Respect source terms, robots restrictions, access controls, privacy law, and POPIA.
- Do not implement bypasses for authentication, anti-bot controls, paywalls, or platform restrictions.

## 6. Architecture boundaries

- PostgreSQL is the durable system of record.
- Redis is for queues, leases, locks, and temporary coordination.
- n8n handles high-level workflow orchestration, schedules, approvals, and integrations.
- Python workers execute bounded, retryable research tasks.
- The API owns business rules and state transitions.
- The frontend never connects directly to PostgreSQL.
- Maps receives only approved public payloads.
- GitHub Actions may test and deploy but must not become the long-running research engine.

## 7. Security

Never commit:

- `.env` files;
- passwords;
- tokens;
- API keys;
- private keys;
- database dumps;
- private candidate data;
- raw personal information exports;
- production logs containing personal or secret data.

Use environment variables and documented placeholders. Keep PostgreSQL and Redis off the public internet. Apply least privilege.

## 8. UI quality

The UI is a research control centre for a non-technical operator.

- Use plain language.
- Make system state and failures visible.
- Include loading, empty, error, success, and recovery states.
- Do not hide autonomous actions.
- Avoid generic decorative dashboards.
- Provide pause, resume, retry, cancel, review, and audit visibility where relevant.
- Use accessible contrast, responsive layouts, and keyboard-accessible controls.
- Important status must not rely on colour alone.

## 9. Code quality

- Use clear names and typed interfaces.
- Validate external inputs.
- Use structured logs.
- Add timeouts and bounded retries for network operations.
- Make tasks idempotent where practical.
- Do not acknowledge queue work before durable storage succeeds.
- Avoid large dependencies without clear need.
- Keep service responsibilities narrow.

## 10. Testing and verification

Before claiming completion:

1. Run relevant formatting, linting, type checks, tests, and build commands.
2. Test the changed user flow, not only isolated functions.
3. Confirm failure and retry behaviour where applicable.
4. Report exactly what was run and the outcome.
5. State clearly what was not tested.

Never say a feature works without evidence from commands, tests, or a reproducible manual check.

## 11. Database changes

- Use versioned migrations.
- Include indexes and constraints.
- Store UTC timestamps.
- Preserve evidence and publication history.
- Avoid destructive migrations unless the owner explicitly approves and a backup/rollback plan exists.

## 12. Documentation

Update the relevant specification when behaviour changes. Keep `README.md` useful to a non-technical owner and technical contributor.

## 13. Completion format

When finishing work, provide:

- what changed;
- why it changed;
- files changed;
- migrations or deployment steps;
- tests and commands run;
- results;
- risks or unresolved items;
- what the owner should visually or operationally check.

## 14. Current priority

The first priority is one reliable vertical slice:

Create project → approve plan → research a small batch → capture evidence → verify claims → human review → publish one Maps record → schedule recheck.

Do not optimise for scale before this flow works end to end.