# 🚀 Custom Projects & Applications
This directory documents the specific custom-built applications developed, containerized, and hosted within this lab. These entries focus on the Software Development Life Cycle (SDLC) and the transition from local development to production hosting.

---

## 📋 Project Index
### ⚖️ FairShare Calculator
**Status**: Live / Production (Demo)

**Tech**: HTML/CSS/Bootstrap, .NET, SQLite, Docker.

**Focus**: A financial tool for child support calculations. This project demonstrates my ability to handle complex business logic and deploy it securely with an emphasis on data privacy.

### 📁 Personal Portfolio & Brand Site (Draft)
**Status**: Live / Production

**Tech**: HTML/CSS/JS, Nginx, GitHub Actions.

**Focus**: A lightweight, high-performance static site served directly via a hardened Nginx container.

---

## 🛠️ The "Dev-to-Prod" Workflow
Every project in this directory follows a standardized deployment pipeline within the home lab:

1. **Local Development**: Code is authored on the Windows 11 host using VS Code, utilizing WSL2 for a native Linux environment during testing.
2. **Containerization**: Applications are packaged using multi-stage Docker builds to minimize image size and reduce the attack surface (e.g., using node:alpine or nginx:stable-alpine).
3. **Infrastructure Integration**:
    - Images are pulled into the exposed-services stack.
    - Nginx Proxy Manager is configured with an SSL/TLS certificate via Cloudflare DNS-01 challenges.
    - Environment variables are injected via the central lab .env system to maintain a "Single Source of Truth."

---

## 📈 Engineering Objectives
When developing for this lab, I prioritize three core metrics:
- **Zero/Minimal Persistence**: Avoiding databases where the logic doesn't strictly require it (as seen in FairShare) to minimize security risks.
- **Observability**: Implementing health-check endpoints that integrate with the lab's monitoring tools.
- **Security by Default**: Running application processes as non-root users (PUID/PGID mapping) within the container.
