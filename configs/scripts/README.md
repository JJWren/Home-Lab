# 📝 Scripts for Homelab Automation

This directory contains script examples and utilities for managing a production-grade homelab, focusing on automation, high availability, and secure container orchestration.

## 🔎 Overview

The scripts in this folder are intended to streamline frequent infrastructure tasks, such as backups, updates, and stack management, typically in a Docker-based home lab environment. They can be customized to fit the specific needs and structure of your setup.

### Example: 💾 Docker Backup Script

#### [`Backup-Docker.ps1`](Backup-Docker.ps1)

A PowerShell script to safely backup Docker configuration and data. Its main features include:

- **Stack Management:** Stops stacks in reverse order of priority before backup and starts them up in order after backup to honor service dependencies.
- **Automated Image Updates:** Pulls the latest Docker images for all stacks to ensure everything is current prior to backup.
- **Archiving:** Uses [7-Zip](https://www.7-zip.org/) to compress stacks and scripts, with options to exclude certain files and directories (e.g., socket and pipe files).
- **Backup Rotation:** Retains only the backups from the last three days, automatically cleaning up older files.
- **Cloud Integration:** Intended to work with cloud storage (such as OneDrive) for offsite backup.

My setup utilizes Task Scheduler to run a similar version to this script on a nightly basis.

#### Configuration

You should update the following variables in the script for your own environment:

- `$SourceDir`: Path to your Docker stack directories.
- `$BackupDest`: Backup storage location.
- `$7ZipPath`: Location of the 7-Zip executable.
- `$StackOrder`: The priority order for shutting down and starting up your Docker stacks.

See the script comments for detailed instructions.

#### Typical Usage Flow

1. **Stop Stacks:** Safely turn off all stacks (in dependency order).
2. **Pull Images:** Fetch latest container images.
3. **Backup Data:** Archive stack directories and scripts.
4. **Restart Stacks:** Bring services online in the correct order.
5. **Cleanup:** Automatically purge old backup files.

---

## ➕ Adding Your Own Scripts

Ideas for additional automation needs:

- Routine maintenance
- Monitoring and alerting
- Upgrading services
- Other backup solutions
