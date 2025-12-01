# HestiaCP for Umbrel

This directory contains the configuration files required to run HestiaCP as an app on UmbrelOS.

## Installation Guide

Follow these steps to manually install HestiaCP on your Umbrel device.

### Prerequisites
- SSH access to your Umbrel device
- `dennii/hestiacp:latest` image built and pushed to Docker Hub (or built locally)

### Step 1: Prepare the App Directory

1. SSH into your Umbrel device:
   ```bash
   ssh umbrel@umbrel.local
   # Or use your device's IP address
   ```

2. Create a temporary directory for the app files:
   ```bash
   mkdir -p ~/hestiacp-install
   ```

3. Copy the files from this repository to that directory. You can create them manually using `nano` or `scp` them over.

   **Create `umbrel-app.yml`:**
   ```bash
   nano ~/hestiacp-install/umbrel-app.yml
   # Paste the content of umbrel-app.yml here
   # Press Ctrl+X, then Y, then Enter to save
   ```

   **Create `docker-compose.yml`:**
   ```bash
   nano ~/hestiacp-install/docker-compose.yml
   # Paste the content of docker-compose.yml here
   # Press Ctrl+X, then Y, then Enter to save
   ```

### Step 2: Install the App

Run the Umbrel app installation script pointing to your directory:

```bash
sudo ~/umbrel/scripts/app install ~/hestiacp-install
```

The script will:
- Validate the configuration
- Pull the Docker image
- Create the data directories in `~/umbrel/app-data/hestiacp/`
- Start the HestiaCP container

### Step 3: Access HestiaCP

Once installed, HestiaCP will be available at:
- **URL**: `https://umbrel.local:8083` (or `https://<your-ip>:8083`)
- **Username**: `admin`
- **Password**: `changeme` (or whatever you set in `docker-compose.yml`)

## File Structure

After installation, your data will be stored in:
`/home/umbrel/umbrel/app-data/hestiacp/`

This includes:
- `data/` - HestiaCP configuration
- `home/` - User websites
- `mysql/` - Databases
- `mail/` - Email data

## Troubleshooting

**"App install failed"**
Check the logs:
```bash
sudo ~/umbrel/scripts/debug
```

**"Privileged mode error"**
If Umbrel blocks the installation because of `privileged: true`, you may need to modify your Umbrel security settings or use the Portainer method instead.

**"Systemd errors"**
Ensure you are using the latest `dennii/hestiacp:latest` image which includes the systemd startup fix.
