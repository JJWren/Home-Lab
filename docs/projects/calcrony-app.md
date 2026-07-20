
# 📅 Project: CalCrony

**Source Code:** [JJWren/CalCrony](https://github.com/JJWren/CalCrony)

### 📝 Overview

CalCrony is a scheduling platform (in the spirit of sesh.fyi) composed of a REST API, a Discord bot, a static web frontend, and a PostgreSQL database. This document covers its **deployment lifecycle** within the home lab; the application itself lives in its own repository.

### 🏗️ Deployment Architecture

CalCrony runs as its own compose stack ([`calcrony-stack-sample.yml`](../../docker-compose/calcrony-stack-sample.yml)) rather than inside `exposed-services`, because it has a private database network and its own release cadence.

* **Runtime:** .NET API + Discord.Net bot + static web, all published as GHCR images.
* **Startup ordering:** `depends_on` with `condition: service_healthy` gates the chain — Postgres must pass `pg_isready`, then the API runs EF migrations and passes its `/health/ready` probe (which includes a DB check), and only then do the bot and web containers start.
* **Ingress:** The web frontend and API are reverse-proxied via Nginx Proxy Manager; the browser calls the API directly, so the API's public base URL and CORS origin are injected via environment.

### 🔒 Security & Reliability Engineering

1. **Pinned production images:** The prod stack pins `CALCRONY_IMAGE_TAG` to a release tag; only the parallel test stack tracks `latest`.
2. **Prod/test isolation:** A second copy of the stack runs as a separate Compose project (`docker compose -p test-calcrony`, or a second folder with its own `.env`), which gives it its own containers, network, and named volumes — plus a separate Discord application id, so test invites can never advertise the production bot.
3. **Fail-fast configuration:** Required secrets use compose's `${VAR:?}` syntax; the stack refuses to start if a signing key, bot token, or DB password is missing.
4. **Token encryption at rest:** Google Calendar OAuth tokens are encrypted with ASP.NET DataProtection keys persisted in a dedicated named volume (`dpkeys`).
5. **Storage placement:** Postgres data lives in a named volume inside the Docker VM (never on an SMB share), and is backed up out-of-band from the file-level stack backup.

### 🔄 CI/CD & Maintenance

* Images are built and pushed to GHCR from the CalCrony repository; deployments are a tag bump in `.env` followed by `docker compose up -d`.
