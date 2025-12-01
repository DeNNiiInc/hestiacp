# HestiaCP Docker Documentation

## Quick Start

### Using Docker Compose (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/hestiacp/hestiacp.git
   cd hestiacp
   ```

2. **Configure environment variables:**
   Edit `docker-compose.yml` and set your admin credentials:
   ```yaml
   environment:
     - ADMIN_USERNAME=admin
     - ADMIN_PASSWORD=your_secure_password
     - ADMIN_EMAIL=your@email.com
     - HOSTNAME=your.domain.com
   ```

3. **Start the container:**
   ```bash
   docker-compose up -d
   ```

4. **Access HestiaCP:**
   - Web Interface: `https://localhost:8083`
   - Username: `admin` (or your configured username)
   - Password: Your configured password

### Using Docker Run

```bash
docker run -d \
  --name hestiacp \
  --hostname hestia.local \
  --privileged \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=changeme123! \
  -e ADMIN_EMAIL=admin@example.com \
  -e HOSTNAME=hestia.local \
  -p 80:80 \
  -p 443:443 \
  -p 8083:8083 \
  -p 21:21 \
  -p 22:22 \
  -p 25:25 \
  -p 587:587 \
  -p 110:110 \
  -p 143:143 \
  -p 993:993 \
  -p 995:995 \
  -p 53:53/tcp \
  -p 53:53/udp \
  -p 3306:3306 \
  -p 5432:5432 \
  -v hestia_data:/usr/local/hestia \
  -v hestia_home:/home \
  -v hestia_mysql:/var/lib/mysql \
  -v hestia_mail:/var/vmail \
  -v hestia_ssl:/etc/letsencrypt \
  --cap-add SYS_ADMIN \
  --cap-add NET_ADMIN \
  hestiacp/hestiacp:latest
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `ADMIN_USERNAME` | Admin username | `admin` |
| `ADMIN_PASSWORD` | Admin password | `changeme` |
| `ADMIN_EMAIL` | Admin email address | `admin@localhost` |
| `HOSTNAME` | Server hostname (FQDN) | `hestia.local` |

## Port Mappings

| Port | Service | Protocol |
|------|---------|----------|
| 80 | HTTP | TCP |
| 443 | HTTPS | TCP |
| 8083 | HestiaCP Admin Panel | TCP |
| 21 | FTP | TCP |
| 22 | SSH | TCP |
| 25 | SMTP | TCP |
| 587 | SMTP Submission | TCP |
| 465 | SMTPS | TCP |
| 110 | POP3 | TCP |
| 995 | POP3S | TCP |
| 143 | IMAP | TCP |
| 993 | IMAPS | TCP |
| 53 | DNS | TCP/UDP |
| 3306 | MySQL/MariaDB | TCP |
| 5432 | PostgreSQL | TCP |

## Volume Management

### Persistent Data Volumes

- `/usr/local/hestia` - HestiaCP installation and configuration
- `/home` - User home directories and websites
- `/var/lib/mysql` - MySQL/MariaDB databases
- `/var/lib/postgresql` - PostgreSQL databases
- `/var/vmail` - Email data
- `/etc/letsencrypt` - SSL certificates
- `/var/named` - DNS zone files

### Backup and Restore

**Backup volumes:**
```bash
docker run --rm \
  -v hestia_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/hestia_data_backup.tar.gz /data
```

**Restore volumes:**
```bash
docker run --rm \
  -v hestia_data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/hestia_data_backup.tar.gz -C /
```

## System Requirements

- **RAM:** Minimum 2GB, recommended 4GB+
- **Disk:** Minimum 20GB free space
- **Docker:** Version 20.10 or higher
- **Docker Compose:** Version 1.29 or higher

## Security Considerations

> **⚠️ IMPORTANT:** This container runs in privileged mode to support systemd and all HestiaCP features.

1. **Change default credentials immediately** after first login
2. **Use strong passwords** for the admin account
3. **Configure firewall rules** on your host system
4. **Keep the container updated** regularly
5. **Use HTTPS** for the admin panel (configure SSL certificates)
6. **Limit exposed ports** to only what you need

## Troubleshooting

### Container won't start

Check logs:
```bash
docker-compose logs -f hestiacp
```

### Services not starting

Enter the container and check service status:
```bash
docker-compose exec hestiacp bash
systemctl status hestia
systemctl status nginx
systemctl status apache2
```

### Reset admin password

```bash
docker-compose exec hestiacp /usr/local/hestia/bin/v-change-user-password admin newpassword
```

### View HestiaCP logs

```bash
docker-compose exec hestiacp tail -f /var/log/hestia/system.log
```

## Upgrading

1. **Backup your data** (see Backup section above)
2. **Pull the latest image:**
   ```bash
   docker-compose pull
   ```
3. **Recreate the container:**
   ```bash
   docker-compose up -d
   ```

## Limitations

- **Firewall management** may have limited functionality in containers
- **Kernel-level features** depend on host kernel version
- **Performance** may be slightly lower than bare metal installation
- **Some system monitoring** features may not work as expected

## Support

- **Documentation:** https://docs.hestiacp.com/
- **Forum:** https://forum.hestiacp.com/
- **GitHub Issues:** https://github.com/hestiacp/hestiacp/issues

## License

HestiaCP is licensed under GPL v3. See [LICENSE](LICENSE) for details.
