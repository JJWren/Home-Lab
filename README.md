# Home-Lab
A production-grade home infrastructure focused on high availability, security, and containerized service orchestration.

## 🛠 Tech Stack
**Runtime**: Docker, Docker Compose, WSL2.

**Networking**: Nginx (Reverse Proxy), Cloudflare (DNS/WAF), DDNS.

**Security**: Let's Encrypt (ACME), HSTS, Port Obfuscation, Permission & Volume Mapping, User Invite & Management System.

**Services**: Portfolio Hosting, Custom Hosted Web Apps (C#/.NET/etc.), Private Cloud Storage Solution, Aggregated API Indexers, Metadata Retrieval Middleware, Automated Media Lifecycle Manager, Private Content Delivery Network (CDN), Automated Data Pipelines


## 📐 Key Architectural Achievements
**Zero-Trust Inspired Edge**: Implemented a single-entry point via Nginx, reducing the public attack surface from multiple open ports to just 80/443.

**Automated Certificate Lifecycle**: Configured ACME protocols for automated SSL renewal, maintaining 100% uptime for encrypted traffic on .dev domains.

**Automated Asset Management**: Orchestrated a containerized pipeline to automate the discovery, acquisition, and organization of digital assets.
- **Tooling**: Utilized a suite of specialized automation tools to monitor RSS feeds and APIs for new content.
- **Logic**: Configured custom quality profiles to ensure assets meet specific standards before being ingested.
- **Storage**: Integrated with an atomic-move filesystem structure to minimize I/O overhead during library organization.
