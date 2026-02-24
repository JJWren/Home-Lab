
# ⚖️ Project: FairShare Calculator

**Production URL:** [fairshare.theguywiththedogs.dev](https://fairshare.theguywiththedogs.dev)

**Source Code:** [JJWren/FairShare](https://github.com/JJWren/FairShare)

### 📝 Overview

FairShare is a full-stack web application designed to simplify child support obligation calculations based on state-specific legal guidelines. While the source code lives in a separate repository, this document outlines its **deployment lifecycle** and **infrastructure integration** within the home lab.

### 🏗️ Deployment Architecture

FairShare is deployed as a containerized microservice within the `exposed-services` stack.

* **Runtime:** .NET environment encapsulated in a Docker container.
* **Ingress:** Traffic is routed via **Nginx Proxy Manager** (NPM).
* **Security Layer:** Cloudflare WAF protects the endpoint from common web vulnerabilities (SQLi, XSS), while NPM handles SSL/TLS termination using Let's Encrypt certificates.

### 🔒 Security & Privacy Engineering

As an application dealing with sensitive financial logic, I implemented several "Privacy-by-Design" principles:

1. **Stateless Execution:**
   1. The demo application maintains a demo account that does not persist the entered forms in the database for calculation data. All inputs are processed in-memory and purged upon session termination.
   2. When self-hosted, an admin account is created and will persist the data in a local SQLite database.
2. **Environment Hardening:** * The container runs with a read-only filesystem where possible.
   * Limited resource quotas (CPU/RAM) are enforced via Docker Compose to prevent denial-of-service (DoS) via resource exhaustion.
3. **Encrypted Transit:** Enforced **HSTS (HTTP Strict Transport Security)** to ensure users never communicate with the demo calculator over an unencrypted connection.

### 🔄 CI/CD & Maintenance

* **Version Control:** Managed via Git, with changes staged and tested in a local dev container before being pulled to the production home server.
