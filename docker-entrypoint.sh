#!/bin/bash

# HestiaCP Docker Entrypoint Script
# This script initializes HestiaCP on first run and starts all services

HESTIA_INSTALLED_FLAG="/usr/local/hestia/.docker-installed"

# Function to log messages
log() {
    echo "[HestiaCP Docker] $1"
}

log "HestiaCP Docker Container Starting..."

# Check if this is the first run (before systemd starts)
if [ ! -f "$HESTIA_INSTALLED_FLAG" ]; then
    log "First run detected - HestiaCP will be installed after systemd starts"

    # Create a systemd service to run the installation on first boot
    cat > /etc/systemd/system/hestiacp-install.service <<EOF
[Unit]
Description=HestiaCP First-Time Installation
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/hestiacp-install.sh

[Install]
WantedBy=multi-user.target
EOF

    # Create the installation script
    cat > /usr/local/bin/hestiacp-install.sh <<'EOF'
#!/bin/bash
set -e

HESTIA_INSTALLED_FLAG="/usr/local/hestia/.docker-installed"

log() {
    echo "[HestiaCP Docker] $1"
}

if [ -f "$HESTIA_INSTALLED_FLAG" ]; then
    log "HestiaCP already installed, skipping..."
    exit 0
fi

log "Starting HestiaCP installation..."

# Set hostname
if [ -n "$HOSTNAME" ]; then
    hostnamectl set-hostname "$HOSTNAME" 2>/dev/null || true
    echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
fi

# Run HestiaCP installer in non-interactive mode
log "Running HestiaCP installer (this will take 30-60 minutes)..."
bash /tmp/hst-install.sh \
    --interactive no \
    --email "${ADMIN_EMAIL:-admin@localhost}" \
    --password "${ADMIN_PASSWORD:-changeme}" \
    --username "${ADMIN_USERNAME:-admin}" \
    --hostname "${HOSTNAME:-hestia.local}" \
    --force

# Mark as installed
touch "$HESTIA_INSTALLED_FLAG"

log "HestiaCP installation completed!"
log "=========================================="
log "HestiaCP is ready!"
log "Web Interface: https://localhost:8083"
log "Username: ${ADMIN_USERNAME:-admin}"
log "Password: ${ADMIN_PASSWORD:-changeme}"
log "=========================================="

# Disable this service so it doesn't run again
systemctl disable hestiacp-install.service
EOF

    chmod +x /usr/local/bin/hestiacp-install.sh

    # Enable the installation service
    systemctl enable hestiacp-install.service 2>/dev/null || true
else
    log "HestiaCP already installed"
fi

# Start systemd as PID 1
log "Starting systemd..."
exec /lib/systemd/systemd
