# 🏛️ System Architecture

## The Hybrid Host Logic

The core of this lab runs on **Windows 11 Pro**, chosen specifically to support a dual-purpose environment:

1. **Type-2 Hypervisor Host:** Running VirtualBox for the isolated FlareVM malware sandbox.
2. **WSL2 Container Host:** Leveraging the Windows Subsystem for Linux to run the Docker daemon with near-native Linux performance.

## 🗄️ Storage Integration (The NAS Connection)

The lab originated as a single-disk "All-in-One" prototype. As the data footprint expanded, I migrated the storage layer to a dedicated, custom-built **Network Attached Storage (NAS)** device. This transition presented a unique challenge: maintaining the high-speed I/O required for Docker services (specifically database consistency and high-bitrate media streaming) over a network protocol.

### Storage Mapping Strategy:

To bridge the gap between the Windows 11 host and the NAS, I implemented a tiered storage strategy using **SMB 3.0** with specific mount optimizations:

* **Config Tier (The Metadata):** Service-specific configuration folders (the `/config` volumes) are stored on a high-speed SSD-backed share and backed up to a public cloud server. This ensures that the SQLite databases used by the Media-stack suite and Plex remain responsive and free from corruption.
* **Data Tier (The Assets):** Large-scale media and application data are stored on high-capacity HDD arrays.
* **WSL2 Integration:** Because Docker runs within the WSL2 utility VM, I utilized **DrvFs** with specific mount metadata to ensure that Linux permissions (`PUID`/`PGID`) remain consistent across the Windows-mapped network drives.

### Key Infrastructure Decision: "Atomic Moves"

By centralizing the downloads and media folders under a single logical share on the NAS, I enabled **Hardlinking** within the Docker containers.

* **The Result:** Files move from `/downloads` to `/media` instantly without crossing the network interface twice, drastically reducing network congestion and disk wear.

## 🌡️ Monitoring & Management

- **Hardware:** Monitoring CPU/GPU thermals (critical for Tdarr transcoding) using host-level sensors.
- **Orchestration:** Managed via Portainer (for visual triage) and Docker Compose (for Version Control).
