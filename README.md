
# 🏠🧪 Hybrid Home Lab & Security Research Sandbox

![Architecture](https://img.shields.io/badge/Architecture-WSL2%20%7C%20Docker-blue)
![Security](https://img.shields.io/badge/Security-VPN%20Sidecar%20%7C%20SSL-green)
![Lab](https://img.shields.io/badge/Sandbox-FlareVM-red)

A production-grade, hybrid-OS home infrastructure focused on **Automation**, **Network Privacy**, and **Security Research**.

## 🏗️ Architecture Overview

* **Host OS:** Windows 11 Pro (WSL2 Backend)
* **Containerization:** Docker Desktop / Docker Compose
* **Security Lab:** Isolated FlareVM (VirtualBox)
* **Networking:** Nginx Proxy Manager + Gluetun VPN Sidecar
* **Storage:**
    * **Primary:** Dedicated NAS (SMB/NFS integration).
    * **Operational:** Internal server storage for high-I/O Docker configurations.
    * **Offsite:** Automated Google Drive synchronization for disaster recovery of configuration metadata.

## 📂 Repository Guide

* **docker-compose/:** The "Heart" of the lab. Modularized YAML stacks (Media, Exposed, Utilities) and an .env.example for environment replication.

* **docs/:** Technical documentation hub.

    * **Architecture:** Deep dive into the hybrid Windows/WSL2 logic and NAS storage migration.

    * **Networking:** Ingress/Egress strategies, VPN namespaces, and SSL lifecycle.

    * **Malware Sandbox:** Security research SOPs, FlareVM hardening, and VirusTotal integration.

    * **Projects/:** Showcases of custom-developed applications hosted in the lab.

        * **FairShare Calculator:** Full-stack deployment specs and privacy-by-design architecture.

        * **Personal Portfolio:** Nginx static hosting and security hardening.

* **configs/:** Sanitized configuration templates for Nginx, VPN profiles, and application-specific hardening.

## 🚀 Key Achievements

- **Hardened Ingress:** Implemented single-point entry via Nginx with automated Let's Encrypt certificates.
- **Privacy-First Routing:** Utilized Network Namespacing (Gluetun) to force specific service traffic through Wireguard.
- **Resource Optimization:** Configured NVIDIA GPU Passthrough in WSL2 for hardware-accelerated transcoding.


---



## 🗺️ Roadmap & Future Improvements

While the current infrastructure is stable and performant, I am actively working toward a more enterprise-aligned architecture.

### Phase 1: Bare-Metal Linux Migration (In Progress)

* **Goal:** Eliminate the WSL2 abstraction layer to gain native I/O performance.
* **Action:** Transition the primary host from Windows 11 to **Proxmox VE** or  **Debian Stable** . This will allow for dedicated LXC containers and better resource isolation.

### Phase 2: True Network Segmentation

* **Goal:** Move from a flat network to a **VLAN-based architecture** .
* **Action:** Implement a managed switch and a dedicated firewall (OPNsense/pfSense).
  * **VLAN 10 (Management):** Host access and NAS administration.
  * **VLAN 20 (Production):** Internal services (Arrs, Actual, Tautulli).
  * **VLAN 30 (DMZ):** Exposed services (FairShare, Portfolio).
  * **VLAN 40 (Lab):** High-risk isolation for the FlareVM sandbox.

### Phase 3: Infrastructure as Code (IaC)

* **Goal:** Replace manual Docker Compose deployments with automated configuration management.
* **Action:** Integrate **Ansible** for host hardening and **Terraform** for managing Cloudflare DNS records and Nginx Proxy Manager configurations.
