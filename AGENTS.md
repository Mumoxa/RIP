# RIP Agent Instructions

These instructions apply to every AI coding agent, developer, automation and contribution in this repository.

## 1. Read first

Before changing anything:

1. Read this file.
2. Read `instructions/CURRENT_STATUS.md`.
3. Read `instructions/ARCHITECTURE_REVIEW.md`.
4. Read `instructions/NEXT_STEPS.md`.
5. Read the relevant product specifications in `instructions/`.
6. Inspect the actual repository and live deployment state relevant to the task.
7. Confirm what already exists before creating new components.

Do not invent repository state, infrastructure state, credentials, APIs, test results or completed work.

## 2. Product mission

RIP is an evidence-first Research Intelligence Platform. It plans research, executes small tasks, stores source evidence, verifies claims, supports human review, and publishes approved results to Maps.

AI output is not evidence. Every material factual claim must trace to a stored, inspectable source.

## 3. Locked foundation

Preserve and extend:

- Oracle Cloud VM running Oracle Linux;
- rootless Podman with Compose compatibility;
- Nginx Proxy Manager;
- n8n;
- PostgreSQL;
- Redis;
- GitHub as the source of truth for code and documentation.

Do not replace these services or introduce a competing orchestration, database, queue or deployment platform without an explicit architecture decision approved by the owner.

The foundation is locked in principle but its live state must still be verified. Treat statements in `CURRENT_STATUS.md` as reported history until confirmed from the server.

## 4. Current gate

Do not begin broad application implementation until the Operational Baseline in `instructions/NEXT_STEPS.md` has been completed or the owner explicitly narrows the task.

The baseline includes:

- live server inventory;
- container, network and volume inventory;
- reboot recovery verification;
- DNS and TLS repair;
- private PostgreSQL and Redis exposure checks;
- automated backups;
- a successful restore test;
- resource measurement;
- confirmation of the smallest deployable application shape.

Backups and restore verification come before production schema expansion.

## 5. Working method

- Make the smallest complete change that advances one working user flow.
- Prefer vertical slices over disconnected infrastructure.
- Do not build multiple speculative agents before one end-to-end workflow succeeds.
- Reuse existing code and conventions.
- Keep changes reversible.
- Add migrations rather than manually changing production data.
- Preserve existing data and the legacy `research_jobs` table until a tested migration exists.
- Record meaningful decisions in documentation.
- Measure resource use before adding services to the Oracle VM.
- Treat the full database specification as a target model, not a requirement to create every table immediately.

## 6. Evidence and research rules

- Never present model-generated text as a source.
- Store source URL, retrieval time, source snapshot or durable reference, and supporting passage.
- Preserve contradictions.
- Distinguish fact, inference, lead and unresolved claim.
- Search snippets alone are not verification when the source can be inspected.
- Respect source terms, robots restrictions, access controls, privacy law and POPIA.
- Do not implement bypasses for authentication, anti-bot controls, paywalls or platform restrictions.
- The first release must use a narrow, lawful and bounded research use case.

## 7. Architecture boundaries

- PostgreSQL is the durable system of record.
- Redis is for queues, leases, locks and temporary coordination.
- n8n handles high-level workflow orchestration, schedules, approvals and integrations.
- Python workers execute bounded, retryable research tasks.
- The API owns business rules and state transitions.
- The frontend never connects directly to PostgreSQL.
- Maps receives only approved public payloads.
- GitHub Actions may test and deploy but must not become the long-running research engine.
- The Maps publisher should initially remain part of the main API rather than becoming a separate service.
- Avoid microservice expansion until measured need exists.

## 8. Cost and portability

RIP must avoid mandatory paid services and trial-dependent components. No external provider's free tier may be described as guaranteed forever.

Prefer:

- open-source components;
- self-hostable services;
- standard Git history;
- portable containers;
- exportable n8n workflows;
- restorable PostgreSQL backups;
- replaceable integrations.

Do not introduce a paid model router, hosted database, hosted queue or proprietary lock-in without explicit owner approval.

## 9. Security

Never commit:

- `.env` files;
- passwords;
- tokens;
- API keys;
- private keys;
- database dumps;
- private candidate data;
- raw personal-information exports;
- production logs containing personal or secret data.

Use environment variables and documented placeholders. Keep PostgreSQL, Redis and worker endpoints off the public internet. Apply least privilege. Do not display secrets in command output copied into documentation.

## 10. UI quality

The UI is a research control centre for a non-technical operator.

- Use plain language.
- Make system state and failures visible.
- Include loading, empty, error, success and recovery states.
- Do not hide autonomous actions.
- Avoid generic decorative dashboards.
- Provide pause, resume, retry, cancel, review and audit visibility where relevant.
- Use accessible contrast, responsive layouts and keyboard-accessible controls.
- Important status must not rely on colour alone.
- Build the minimum screens needed for the current vertical slice before expanding the interface.

## 11. Code quality

- Use clear names and typed interfaces.
- Validate external inputs.
- Use structured logs.
- Add timeouts and bounded retries for network operations.
- Make tasks idempotent where practical.
- Do not acknowledge queue work before durable storage succeeds.
- Avoid large dependencies without clear need.
- Keep service responsibilities narrow.
- Support ARM/aarch64 or document and test any exception before adoption.

## 12. Testing and verification

Before claiming completion:

1. Run relevant formatting, linting, type checks, tests and build commands.
2. Test the changed user flow, not only isolated functions.
3. Confirm failure and retry behaviour where applicable.
4. Report exactly what was run and the outcome.
5. State clearly what was not tested.
6. For infrastructure claims, include the commands and outputs that verified the live state.
7. For backups, demonstrate a restore rather than only successful backup creation.

Never say a feature or service works without evidence from commands, tests or a reproducible manual check.

## 13. Database changes

- Use versioned migrations.
- Include indexes and constraints required by the current flow.
- Store UTC timestamps.
- Preserve evidence and publication history.
- Avoid destructive migrations unless the owner explicitly approves and a backup/rollback plan exists.
- Create only the tables required for the current vertical slice; expand toward `instructions/DATABASE.md` incrementally.

## 14. Documentation

Update the relevant specification when behaviour changes. Keep `README.md` useful to both the non-technical owner and technical contributors.

When live infrastructure is inspected, update `instructions/CURRENT_STATUS.md` with the verification date, commands used and confirmed results. Do not store secrets or sensitive output.

## 15. Completion format

When finishing work, provide:

- what changed;
- why it changed;
- files changed;
- migrations or deployment steps;
- tests and commands run;
- results;
- risks or unresolved items;
- what the owner should visually or operationally check.

## 16. Approved sequence

Current immediate priority:

Verified Oracle operational baseline → backups and restore test → reliable DNS/TLS → measured application skeleton → first vertical slice.

First product vertical slice:

Create project → approve plan → research no more than five targets → capture evidence → verify claims → human review → publish one Maps record → schedule recheck.

Do not optimise for scale before this flow works end to end.