# 🐳 Docker Infrastructure Orchestration

This directory contains the modularized Docker Compose stacks that power the home lab. The infrastructure is designed with a focus on  **network isolation** ,  **resource efficiency** , and  **persistent storage management** .

---

## 🏗️ Stack Organization

To ensure ease of maintenance and reduce the "blast radius" of configuration changes, services are split into three logical stacks:

### 1. [Media &amp; Acquisition Stack](https://www.google.com/search?q=./media-stack.yml)

* **Purpose:** Automated content lifecycle management and processing.
* **Key Feature:** All traffic is routed through the `gluetun` VPN sidecar to ensure privacy and prevent IP leaks.
* **Services:** Gluetun (Wireguard), qBittorrent, Prowlarr, Radarr, Sonarr, Lidarr, Bazarr, Tdarr.

### 2. [Exposed Services Stack](https://www.google.com/search?q=./exposed.yml)

* **Purpose:** External-facing applications and ingress management.
* **Key Feature:** Isolated from the internal media pipeline; sits behind an Nginx Reverse Proxy with SSL termination.
* **Services:** Nginx Proxy Manager, Overseerr, FairShare Calculator, Personal Portfolio.

### 3. [Utilities Stack](https://www.google.com/search?q=./utilities.yml)

* **Purpose:** Lab management, monitoring, and personal productivity.
* **Services:** Tautulli (Plex monitoring), Actual Budget (Financials), Kometa (Metadata automation).

---

## 🛠️ Deployment Instructions

### 1. Prerequisites

* **Docker Desktop** (with WSL2 backend) or  **Docker Engine** .
* Network drives (NAS) mapped to the host (e.g., `M:/` and `Z:/` for Windows hosts).

### 2. Environment Configuration

The stacks rely on an `.env` file for secrets and pathing.

1. Copy the template: `cp .env.example .env`
2. Populate the `.env` with your specific Wireguard keys, PUID/PGID, and local mount points.

### 3. Initializing Stacks

Services can be brought up individually or as a complete environment:

```bash
# EXAMPLE:
# To start the core media stack
docker-compose -f media-stack-sample.yml up -d

# To start the public-facing services
docker-compose -f exposed-stack-sample.yml up -d
```

## 🛡️ Networking & Security

* **Network Namespacing:** Acquisition tools utilize `network_mode: "service:gluetun"`, ensuring they lack any network interface if the VPN tunnel is not established.
* **Hardware Acceleration:** The `tdarr` service is configured for  **NVIDIA GPU Passthrough** , allowing the container to access the host's GPU for hardware-accelerated transcoding within WSL2.
* **Permission Mapping:** Standardized `PUID` and `PGID` variables are used across all containers to ensure consistent file ownership on the NAS.
