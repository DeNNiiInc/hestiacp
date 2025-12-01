# HestiaCP Docker Image
# Based on Debian 12 (Bookworm)
FROM debian:12

# Metadata
LABEL maintainer="HestiaCP Community"
LABEL description="HestiaCP - Lightweight and powerful control panel for the modern web"
LABEL version="1.10.0-alpha"

# Environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive \
    HESTIA_INSTALL_VER=1.10.0~alpha \
    HESTIA=/usr/local/hestia \
    PATH=$PATH:/usr/local/hestia/bin

# Default admin credentials (should be overridden)
ENV ADMIN_USERNAME=admin \
    ADMIN_PASSWORD=changeme \
    ADMIN_EMAIL=admin@localhost \
    HOSTNAME=hestia.local

# Install systemd and basic dependencies
RUN apt-get update && \
    apt-get install -y \
    systemd \
    systemd-sysv \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    dirmngr \
    openssl \
    sudo \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Remove unnecessary systemd services for container
RUN cd /lib/systemd/system/sysinit.target.wants/ && \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f && \
    rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*

# Copy installation script
COPY install/hst-install.sh /tmp/hst-install.sh
COPY install/hst-install-debian.sh /tmp/hst-install-debian.sh
COPY install/common /tmp/install/common
COPY install/deb /tmp/install/deb

# Make installation script executable
RUN chmod +x /tmp/hst-install.sh /tmp/hst-install-debian.sh

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose ports
# 80, 443: HTTP/HTTPS
# 8083: HestiaCP Admin Panel
# 21: FTP
# 22: SSH
# 25, 587, 465: SMTP
# 110, 995: POP3
# 143, 993: IMAP
# 53: DNS (TCP/UDP)
# 3306: MySQL/MariaDB
# 5432: PostgreSQL
EXPOSE 80 443 8083 21 22 25 587 465 110 995 143 993 53/tcp 53/udp 3306 5432

# Create volume mount points
VOLUME ["/usr/local/hestia", "/home", "/var/lib/mysql", "/var/vmail", "/etc/letsencrypt"]

# Set systemd as the init system
STOPSIGNAL SIGRTMIN+3

# Entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/lib/systemd/systemd"]
