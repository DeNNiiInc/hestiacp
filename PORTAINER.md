# HestiaCP Portainer Deployment Guide

## Overview

This guide explains how to deploy HestiaCP using Portainer, a popular Docker management UI. Portainer makes it easy to manage containers, volumes, and networks through a web interface.

## Prerequisites

- Portainer installed and running
- At least 4GB RAM available
- At least 20GB free disk space

## Deployment Steps

### Step 1: Access Portainer

1. Open your web browser
2. Navigate to your Portainer instance (usually `http://your-server:9000`)
3. Log in with your Portainer credentials

### Step 2: Create a New Stack

1. Click on **Stacks** in the left sidebar
2. Click the **+ Add stack** button
3. Give your stack a name: `hestiacp`

### Step 3: Configure the Stack

#### Option A: Upload the Stack File

1. Select the **Upload** tab
2. Click **Select file**
3. Choose the `portainer-stack.yml` file from this repository
4. Click **Deploy the stack**

#### Option B: Use Web Editor

1. Select the **Web editor** tab
2. Copy the contents of `portainer-stack.yml`
3. Paste into the editor
4. **IMPORTANT:** Edit the environment variables:
   ```yaml
   environment:
     - ADMIN_USERNAME=admin
     - ADMIN_PASSWORD=YourSecurePassword123!
     - ADMIN_EMAIL=your@email.com
     - HOSTNAME=hestia.yourdomain.com
   ```
5. Click **Deploy the stack**

#### Option C: Use Git Repository

1. Select the **Repository** tab
2. Enter repository URL: `https://github.com/DeNNiiInc/hestiacp`
3. Set compose path: `portainer-stack.yml`
4. Click **Deploy the stack**

### Step 4: Monitor Deployment

1. After deployment, click on the stack name `hestiacp`
2. You'll see the container status
3. Click on the container name to view details
4. Click **Logs** to monitor the installation progress

**Installation Time:** The first deployment takes 30-60 minutes as HestiaCP installs all services.

### Step 5: Access HestiaCP

Once installation is complete:

1. Open your browser
2. Navigate to: `https://your-server-ip:8083`
3. Accept the self-signed certificate warning
4. Login with:
   - Username: The value you set in `ADMIN_USERNAME`
   - Password: The value you set in `ADMIN_PASSWORD`

## Volume Management in Portainer

All HestiaCP data is stored in named volumes that persist across container updates:

| Volume Name | Purpose | Location in Container |
|-------------|---------|----------------------|
| `hestiacp_data` | HestiaCP configuration | `/usr/local/hestia` |
| `hestiacp_home` | User websites and files | `/home` |
| `hestiacp_mysql` | MySQL databases | `/var/lib/mysql` |
| `hestiacp_postgresql` | PostgreSQL databases | `/var/lib/postgresql` |
| `hestiacp_mail` | Email data | `/var/vmail` |
| `hestiacp_ssl` | SSL certificates | `/etc/letsencrypt` |
| `hestiacp_dns` | DNS zones | `/var/named` |

### Viewing Volumes

1. Go to **Volumes** in Portainer sidebar
2. You'll see all `hestiacp_*` volumes
3. Click on any volume to see details and browse files

### Backing Up Volumes

1. Go to **Volumes** → Select a volume
2. Click **Browse** to see files
3. Use Portainer's backup feature or export volumes manually

## Port Configuration

The stack exposes these ports by default:

| Port(s) | Service | Can Change? |
|---------|---------|-------------|
| 80 | HTTP | ⚠️ Not recommended |
| 443 | HTTPS | ⚠️ Not recommended |
| 8083 | Admin Panel | ✅ Yes (e.g., `8084:8083`) |
| 22 | SSH | ✅ Yes (e.g., `2222:22`) |
| 21, 12000-12100 | FTP | ⚠️ Complex to change |
| 25, 587, 465 | SMTP | ⚠️ Not recommended |
| 110, 995 | POP3 | ⚠️ Not recommended |
| 143, 993 | IMAP | ⚠️ Not recommended |
| 53 | DNS | ⚠️ Not recommended |
| 3306 | MySQL | ✅ Yes or disable |
| 5432 | PostgreSQL | ✅ Yes or disable |

### Changing Ports

To change a port, edit the stack and modify the port mapping:

```yaml
ports:
  - "8084:8083"  # Changed from 8083:8083
```

Then click **Update the stack**.

## Updating HestiaCP

### Method 1: Update via Portainer UI

1. Go to **Stacks** → `hestiacp`
2. Click **Editor**
3. Change image tag if needed (e.g., `dennii/hestiacp:latest`)
4. Click **Update the stack**
5. Select **Re-pull image and redeploy**
6. Click **Update**

### Method 2: Recreate Container

1. Go to **Containers**
2. Select the `hestiacp` container
3. Click **Recreate**
4. Enable **Pull latest image**
5. Click **Recreate**

**Note:** Your data is safe in volumes and will persist across updates.

## Troubleshooting

### Container Won't Start

1. Check logs: **Containers** → `hestiacp` → **Logs**
2. Look for error messages
3. Common issues:
   - Port conflicts: Change port mappings
   - Insufficient resources: Increase RAM/disk
   - Permission issues: Ensure privileged mode is enabled

### Can't Access Admin Panel

1. Verify container is running: **Containers** → Check status
2. Check port mapping: Ensure 8083 is exposed
3. Check firewall: Allow port 8083 on your server
4. Try: `http://server-ip:8083` instead of `https://`

### Installation Seems Stuck

1. View logs: **Containers** → `hestiacp` → **Logs**
2. Installation takes 30-60 minutes - be patient!
3. Look for progress messages in logs

### Reset Admin Password

1. Go to **Containers** → `hestiacp`
2. Click **Console** → **Connect**
3. Run:
   ```bash
   /usr/local/hestia/bin/v-change-user-password admin NewPassword123!
   ```

## Advanced Configuration

### Using Custom Domains

Edit the stack environment variables:

```yaml
environment:
  - HOSTNAME=panel.yourdomain.com
```

Make sure DNS points to your server's IP.

### Limiting Database Access

Remove or comment out database port mappings if you don't need external access:

```yaml
ports:
  # - "3306:3306"   # MySQL - commented out
  # - "5432:5432"   # PostgreSQL - commented out
```

### Resource Limits

Add resource limits to prevent HestiaCP from consuming all server resources:

```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
    reservations:
      cpus: '2'
      memory: 4G
```

## Backup Strategy

### Automated Backups via Portainer

1. Install Portainer backup plugin or use external tools
2. Schedule volume backups
3. Store backups off-server

### Manual Backup

1. Stop the container: **Containers** → `hestiacp` → **Stop**
2. Backup volumes using Docker commands or Portainer export
3. Start the container: **Containers** → `hestiacp` → **Start**

## Security Recommendations

1. ✅ Change default admin password immediately
2. ✅ Use strong passwords for all accounts
3. ✅ Change SSH port from 22 to non-standard port
4. ✅ Configure firewall rules on your host
5. ✅ Keep HestiaCP updated regularly
6. ✅ Use HTTPS for admin panel access
7. ✅ Limit database port exposure

## Support

- **HestiaCP Documentation:** <https://docs.hestiacp.com/>
- **Portainer Documentation:** <https://docs.portainer.io/>
- **HestiaCP Forum:** <https://forum.hestiacp.com/>
- **GitHub Issues:** <https://github.com/hestiacp/hestiacp/issues>

## Additional Resources

- [Main Docker Documentation](DOCKER.md) - Comprehensive Docker guide
- [README.md](README.md) - General HestiaCP information
- [Portainer Official Docs](https://docs.portainer.io/) - Portainer documentation
