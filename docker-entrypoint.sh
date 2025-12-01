#!/bin/bash
set -e

# HestiaCP Docker Entrypoint Script
# This script initializes HestiaCP on first run and starts all services

HESTIA_INSTALLED_FLAG="/usr/local/hestia/.docker-installed"

# Function to log messages
log() {
    echo "[HestiaCP Docker] $1"
}

# Function to install HestiaCP
install_hestia() {
    log "Starting HestiaCP installation..."

    # Set hostname
    if [ -n "$HOSTNAME" ]; then
        hostnamectl set-hostname "$HOSTNAME" || true
        echo "127.0.0.1 $HOSTNAME" >> /etc/hosts
    fi

    # Run HestiaCP installer in non-interactive mode
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
}

# Function to start HestiaCP services
start_hestia() {
    log "Starting HestiaCP services..."

    # Enable and start HestiaCP service if it exists
    if [ -f /etc/systemd/system/hestia.service ]; then
        systemctl enable hestia.service || true
        systemctl start hestia.service || true
    fi

    log "HestiaCP services started"
}

# Main entrypoint logic
main() {
    log "HestiaCP Docker Container Starting..."

    # Check if this is the first run
    if [ ! -f "$HESTIA_INSTALLED_FLAG" ]; then
        log "First run detected - installing HestiaCP..."
        install_hestia
    else
        log "HestiaCP already installed, starting services..."
        start_hestia
    fi

    # Display access information
    log "=========================================="
    log "HestiaCP is ready!"
    log "Web Interface: https://localhost:8083"
    log "Username: ${ADMIN_USERNAME:-admin}"
    log "Password: ${ADMIN_PASSWORD:-changeme}"
    log "=========================================="

    # Execute the CMD (systemd)
    exec "$@"
}

# Run main function
main "$@"
