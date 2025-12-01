# HestiaCP for Umbrel

This directory contains the configuration files required to run HestiaCP as an app on UmbrelOS.

## Installation

1. **Manual Installation (Dev Mode)**:
   - SSH into your Umbrel device.
   - Navigate to the apps directory: `cd ~/umbrel/apps`
   - Create a directory for HestiaCP: `mkdir hestiacp`
   - Copy the files from this `umbrel/` directory into `~/umbrel/apps/hestiacp/`.
   - Install the app: `sudo ~/umbrel/scripts/app install hestiacp`

2. **App Store (Future)**:
   - Once submitted and approved, it will be available in the Umbrel App Store.

## Configuration

The `docker-compose.yml` is configured to use the `dennii/hestiacp:latest` image.

**Important Notes:**
- **Privileged Mode**: HestiaCP requires `privileged: true` and access to cgroups to run systemd. Ensure your Umbrel setup allows this.
- **Resources**: HestiaCP is resource-intensive. Ensure your device has at least 4GB RAM.
- **Ports**: The main interface is on port 8083.

## Data Persistence

Data is stored in the Umbrel app data directory (`~/umbrel/app-data/hestiacp/`), ensuring persistence across updates and restarts.
