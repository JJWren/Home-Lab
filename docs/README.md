# 📖 Documentation Hub
This directory contains the detailed architectural specifications, security protocols, and research methodologies for the home lab infrastructure.

---

## 🗺️ Documentation Index
### 🏗️ System Architecture
Defines the hybrid-OS strategy and hardware integration.

_**Highlights:** Windows 11/WSL2 integration, NAS storage mapping via SMB 3.0, and the migration from local to networked storage._

### 🌐 Networking & Traffic Flow
Explains how data moves safely in and out of the lab.

_**Highlights:** Nginx Reverse Proxy logic, Wildcard SSL management, and VPN-sidecar "Killswitch" patterns._

### 🔬 Malware Analysis Sandbox
Documentation for the security research environment.

_**Highlights:** FlareVM isolation protocols, Host-Only networking, and the VirusTotal OSINT triage workflow._

### ⚖️ Project: FairShare Calculator
Deployment notes for the primary custom-coded application.

_**Highlights:** Containerization, stateless privacy design, and public-facing ingress security._

---

## 🎨 Diagram Legend
The documentation utilizes several architectural diagrams to visualize the flow of data. Below is a high-level logical map of the entire environment:

### Core Technical Pillars
**Isolation:** Segregating public-facing web apps from internal media automation.

**Hardening:** Using Nginx as a single-entry gatekeeper with automated SSL renewal.

**Efficiency:** Leveraging hardware-accelerated transcoding (GPU Passthrough) and atomic file moves (Hardlinking).

---

## 🛠️ Maintenance & Updates
These documents are updated alongside significant infrastructure changes (e.g., hardware upgrades or networking re-architecture). For sample deployment instructions, refer to the [Root README](https://github.com/JJWren/Home-Lab/README.md).
