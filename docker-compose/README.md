# 🐳 Docker Infrastructure Orchestration

This directory contains the modularized Docker Compose stacks that power the [Home-Lab](https://github.com/JJWren/Home-Lab) project.
The infrastructure is designed with a focus on **network isolation**, **resource efficiency**, and **persistent, production-grade orchestration**.
Stacks are intended to be modular, easily portable, and demonstrate best practices in self-hosted engineering for home or professional demonstration.

---

## 🏗️ Stack Organization

To ensure ease of maintenance, clear separation of concerns, and minimal blast radius, services are split into several logical stacks:

### 1. Media Acquisition Stack

* **Purpose:** Full media automation pipeline—acquisition, management, and post-processing of movies, TV, music, and books.
* **Key Features:**
  - All download and indexer traffic routed through an isolated VPN (`gluetun` service) for privacy and compliance.
  - Containers for Radarr, Sonarr, Lidarr, Bazarr, NZBGet, qBittorrent, Prowlarr, FlareSolverr, and Tdarr.
  - Hardware acceleration for transcoding and persistent config/media storage.
* **Sample Compose:** [`arrs-stack-sample.yml`](arrs-stack-sample.yml)

### 2. Public/Exposed Services Stack

* **Purpose:** Secure ingress and routing for public-facing services and custom web apps.
* **Key Features:**
  - Sits behind an Nginx-based reverse proxy (Nginx Proxy Manager) with automated SSL and multi-app support.
  - Includes apps like Overseerr (media requests), FairShare (custom CS calculator), and a static personal portfolio website.
* **Sample Compose:** [`exposed-stack-sample.yml`](exposed-stack-sample.yml)

### 3. Media Server Stack

* **Purpose:** Media serving (primarily Plex and metadata automation).
* **Key Features:**
  - Hardware-accelerated Plex with local and networked storage for seamless streaming.
  - Includes auxiliary tools (Kometa, etc) for metadata processing.
* **Sample Compose:** [`media-stack-sample.yml`](media-stack-sample.yml)

### 4. Utilities Stack

* **Purpose:** Proxy management, service dashboards, other utility tools.
* **Key Features:**
  - Apps like Nginx Proxy Manger (proxy), MKV (video file multiplexer), and Homepage (app dashboard) for a comprehensive utilities.
* **Sample Compose:** [`utilities-stack-sample.yml`](utilities-stack-sample.yml)

## 🛠️ Deployment Instructions

### 1. Prerequisites

* [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
* Recommended: Static IPs and mapped network drives (NAS, e.g., `/mnt/media/` or `M:/media` on Windows)
* Environment variables files (`.env`) created from provided samples

### 2. Environment Configuration

All stacks use variable substitution for secrets, credentials, and host paths.

1. Copy the relevant `.env` sample (e.g. `arrs-env-sample.env`) to `.env`
2. Fill in your environment-specific values (UID/GID, keys, volume paths, credentials, etc.)
3. Optionally update `/your-data` and `/your-media` in YAML to your actual media/storage mount points

### 3. Initializing Stacks

Services can be brought up individually or in groups as needed:

```bash
# Example: Start the media acquisition stack
docker compose -f arrs-stack-sample.yml --env-file arrs-env-sample.env up -d

# Example: Start public/exposed services
docker compose -f exposed-stack-sample.yml --env-file exposed-env-sample.env up -d
```

## 🛡️ Networking & Security

* **VPN Enforcement:** Media acquisition containers use `network_mode: "service:gluetun"` to guarantee no downloads or indexers can leak IP if the VPN is down.
* **Ingress Isolation:** All externally accessible services are reverse-proxied with certificate management, so no app is exposed “bare” to the internet.
* **Consistent Permissions:** `PUID` and `PGID` ensure volume writes (including on a NAS) use predictable and safe file ownership.
* **GPU Acceleration:** Where available, hardware devices are mapped for transcoding or AI workloads.
* **Separate Host Networks:** Application and media networks are isolated for best practice segmentation.

---

## 📂 Example File Structure

```plaintext
docker/
  arrs-stack/
    arrs-stack-sample.yml
    arrs-env-sample.env
    related-app1-in-stack/
    related-app2-in-stack/
  exposed-stack/
    exposed-stack-sample.yml
    exposed-env-sample.env
    related-app1-in-stack/
    related-app2-in-stack/
  media-stack/
    media-stack-sample.yml
    media-env-sample.env
    related-app1-in-stack/
    related-app2-in-stack/
  utilities-stack/
    utilities-stack-sample.yml
    utilities-env-sample.env
    related-app1-in-stack/
    related-app2-in-stack/
```
