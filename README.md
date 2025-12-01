<h1 align="center"><a href="https://www.hestiacp.com/">Hestia Control Panel</a></h1>

![HestiaCP Web Interface screenshot](https://storage.hestiacp.com/hestiascreen.png)

<h2 align="center">Lightweight and powerful control panel for the modern web</h2>

<p align="center"><strong>Latest stable release:</strong> Version 1.9.4 | <a href="https://github.com/hestiacp/hestiacp/blob/release/CHANGELOG.md">View Changelog</a></p>

<p align="center">
	<a href="https://www.hestiacp.com/">HestiaCP.com</a> |
	<a href="https://docs.hestiacp.com/">Documentation</a> |
	<a href="https://forum.hestiacp.com/">Forum</a>
	<br/><br/>
	<a href="https://drone.hestiacp.com/hestiacp/hestiacp">
		<img src="https://drone.hestiacp.com/api/badges/hestiacp/hestiacp/status.svg?ref=refs/heads/main" alt="Drone Status"/>
	</a>
	<a href="https://github.com/hestiacp/hestiacp/actions/workflows/lint.yml">
		<img src="https://github.com/hestiacp/hestiacp/actions/workflows/lint.yml/badge.svg" alt="Lint Status"/>
	</a>
	<a href="https://gurubase.io/g/hestia">
		<img src="https://img.shields.io/badge/Gurubase-Ask%20Hestia%20Guru-006BFF" alt="Gurubase"/>
	</a>
</p>

## **Welcome!**

Hestia Control Panel is designed to provide administrators an easy to use web and command line interface, enabling them to quickly deploy and manage web domains, mail accounts, DNS zones, and databases from one central dashboard without the hassle of manually deploying and configuring individual components or services.

## Donate

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ST87LQH2CHGLA)<br /><br />
Bitcoin : bc1q48jt5wg5jaj8g9zy7c3j03cv57j2m2u5anlutu<br>
Ethereum : 0xfF3Dd2c889bd0Ff73d8085B84A314FC7c88e5D51<br>
Binance: bnb1l4ywvw5ejfmsgjdcx8jn5lxj7zsun8ktfu7rh8<br>
Smart Chain: 0xfF3Dd2c889bd0Ff73d8085B84A314FC7c88e5D51<br>

## Features and Services

- Apache2 and NGINX with PHP-FPM
- Multiple PHP versions (5.6 - 8.4, 8.3 as default)
- DNS Server (Bind) with clustering capabilities
- POP/IMAP/SMTP mail services with Anti-Virus, Anti-Spam, and Webmail (ClamAV, SpamAssassin, Sieve, Roundcube)
- MariaDB/MySQL and/or PostgreSQL databases
- Let's Encrypt SSL support with wildcard certificates
- Firewall with brute-force attack detection and IP lists (iptables, fail2ban, and ipset).

## Supported platforms and operating systems

- **Debian:** 12, 11
- **Ubuntu:** 24.04 LTS, 22.04 LTS, 20.04 LTS

**NOTES:**

- Hestia Control Panel does not support 32 bit operating systems!
- Hestia Control Panel in combination with OpenVZ 7 or lower might have issues with DNS and/or firewall. If you use a Virtual Private Server we strongly advice you to use something based on KVM or LXC!

## Docker Installation (Alternative)

HestiaCP is now available as a Docker container! This provides an alternative installation method for testing or development environments.

> **Note:** The Docker version is intended for testing and development. For production use, we recommend installing HestiaCP directly on a server.

### Prerequisites

Before you begin, you'll need:

- A Linux server or computer (Ubuntu, Debian, etc.)
- OR Windows with WSL2 (Windows Subsystem for Linux) installed
- OR macOS with Docker Desktop
- At least 4GB of RAM
- At least 20GB of free disk space

### Step 1: Install Docker

Choose the instructions for your operating system:

#### On Ubuntu/Debian Linux:

```bash
# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to the docker group (so you don't need sudo)
sudo usermod -aG docker $USER

# Log out and log back in for the group change to take effect
```

#### On Windows (WSL2):

1. Download and install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
2. During installation, ensure "Use WSL 2 instead of Hyper-V" is selected
3. Open Docker Desktop and go to Settings → Resources → WSL Integration
4. Enable integration with your WSL2 distribution
5. Open WSL2 terminal (Ubuntu) from the Start menu

#### On macOS:

1. Download and install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
2. Open Docker Desktop from Applications
3. Wait for Docker to start (you'll see the whale icon in the menu bar)
4. Open Terminal

### Step 2: Verify Docker Installation

Run this command to check if Docker is working:

```bash
docker --version
```

You should see something like: `Docker version 24.0.0, build abc1234`

### Step 3: Pull the HestiaCP Docker Image

Download the pre-built HestiaCP image from Docker Hub:

```bash
docker pull dennii/hestiacp:latest
```

This will download the image (approximately 2-3 GB). It may take several minutes depending on your internet connection.

### Step 4: Run HestiaCP Container

#### Option A: Quick Start (Recommended for Testing)

Run this single command to start HestiaCP:

```bash
docker run -d \
  --name hestiacp \
  --hostname hestia.local \
  --privileged \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=ChangeThisPassword123! \
  -e ADMIN_EMAIL=admin@example.com \
  -p 8083:8083 \
  -p 80:80 \
  -p 443:443 \
  -p 3306:3306 \
  -p 5432:5432 \
  -v hestia_data:/usr/local/hestia \
  -v hestia_home:/home \
  -v hestia_mysql:/var/lib/mysql \
  dennii/hestiacp:latest
```

**Important:** Change `ADMIN_PASSWORD` to a strong password of your choice!

#### Option B: Using Docker Compose (Recommended for Development)

1. **Clone the repository:**

   ```bash
   git clone https://github.com/DeNNiiInc/hestiacp.git
   cd hestiacp
   ```

2. **Edit the configuration (optional):**

   Open `docker-compose.yml` in a text editor and change the admin password:

   ```bash
   nano docker-compose.yml
   ```

   Find this line and change the password:

   ```yaml
   - ADMIN_PASSWORD=changeme123!
   ```

   Press `Ctrl+X`, then `Y`, then `Enter` to save.

3. **Start the container:**

   ```bash
   docker-compose up -d
   ```

### Step 5: Wait for Installation

The first time you start the container, HestiaCP will automatically install. This takes **30-60 minutes**.

**Check the installation progress:**

```bash
docker logs -f hestiacp
```

You'll see installation messages. Wait until you see:

```
[HestiaCP Docker] HestiaCP is ready!
[HestiaCP Docker] Web Interface: https://localhost:8083
```

Press `Ctrl+C` to exit the log view.

### Step 6: Access HestiaCP

1. **Open your web browser**
2. **Navigate to:** `https://localhost:8083`
3. **Accept the security warning** (the container uses a self-signed certificate)
4. **Login with:**
   - Username: `admin` (or what you set in ADMIN_USERNAME)
   - Password: The password you set in ADMIN_PASSWORD

🎉 **Congratulations!** You now have HestiaCP running in Docker!

### Common Commands

**View container status:**

```bash
docker ps
```

**Stop the container:**

```bash
docker stop hestiacp
```

**Start the container:**

```bash
docker start hestiacp
```

**Restart the container:**

```bash
docker restart hestiacp
```

**View logs:**

```bash
docker logs hestiacp
```

**Remove the container (WARNING: This deletes all data!):**

```bash
docker stop hestiacp
docker rm hestiacp
```

### Troubleshooting

**Problem: "Cannot connect to Docker daemon"**

- **Solution:** Make sure Docker is running. On Windows/Mac, open Docker Desktop. On Linux, run: `sudo systemctl start docker`

**Problem: "Port is already allocated"**

- **Solution:** Another service is using the port. Either stop that service or change the port mapping. For example, to use port 8084 instead of 8083:
  ```bash
  -p 8084:8083
  ```

**Problem: Container keeps restarting**

- **Solution:** Check the logs for errors:
  ```bash
  docker logs hestiacp
  ```

**Problem: Installation seems stuck**

- **Solution:** Be patient! The first installation takes 30-60 minutes. Check logs to see progress.

### Next Steps

- Read the full Docker documentation: [DOCKER.md](DOCKER.md)
- Learn about backing up your data
- Configure SSL certificates
- Add your first website

### Need Help?

- **Documentation:** <https://docs.hestiacp.com/>
- **Forum:** <https://forum.hestiacp.com/>
- **GitHub Issues:** <https://github.com/hestiacp/hestiacp/issues>

## Installing Hestia Control Panel

- **NOTE:** You must install Hestia Control Panel on top of a fresh operating system installation to ensure proper functionality.

While we have taken every effort to make the installation process and the control panel interface as friendly as possible (even for new users), it is assumed that you will have some prior knowledge and understanding in the basics how to set up a Linux server before continuing.

### Step 1: Log in

To start the installation, you will need to be logged in as **root** or a user with super-user privileges. You can perform the installation either directly from the command line console or remotely via SSH:

```bash
ssh root@your.server
```

### Step 2: Download

Download the installation script for the latest release:

```bash
wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
```

If the download fails due to an SSL validation error, please be sure you've installed the ca-certificate package on your system - you can do this with the following command:

```bash
apt-get update && apt-get install ca-certificates
```

### Step 3: Run

To begin the installation process, simply run the script and follow the on-screen prompts:

```bash
bash hst-install.sh
```

You will receive a welcome email at the address specified during installation (if applicable) and on-screen instructions after the installation is completed to log in and access your server.

### Custom installation

You may specify a number of various flags during installation to only install the features in which you need. To view a list of available options, run:

```bash
bash hst-install.sh -h
```

Alternatively, You can use <https://hestiacp.com/install.html> which allows you to easily generate the installation command via GUI.

## How to upgrade an existing installation

Automatic Updates are enabled by default on new installations of Hestia Control Panel and can be managed from **Server Settings > Updates**. To manually check for and install available updates, use the apt package manager:

```bash
apt-get update
apt-get upgrade
```

## Issues & Support Requests

- If you encounter a general problem while using Hestia Control Panel and need help, please [visit our forum](https://forum.hestiacp.com/) to search for potential solutions or post a new thread where community members can assist.
- Bugs and other reproducible issues should be filed via GitHub by [creating a new issue report](https://github.com/hestiacp/hestiacp/issues) so that our developers can investigate further. Please note that requests for support will be redirected to our forum.

**IMPORTANT: We _cannot_ provide support for requests that do not describe the troubleshooting steps that have already been performed, or for third-party applications not related to Hestia Control Panel (such as WordPress). Please make sure that you include as much information as possible in your forum posts or issue reports!**

## Contributions

If you would like to contribute to the project, please [read our Contribution Guidelines](https://github.com/hestiacp/hestiacp/blob/release/CONTRIBUTING.md) for a brief overview of our development process and standards.

## Copyright

"Hestia Control Panel", "HestiaCP", and the Hestia logo are original copyright of hestiacp.com and the following restrictions apply:

**You are allowed to:**

- use the names "Hestia Control Panel", "HestiaCP", or the Hestia logo in any context directly related to the application or the project. This includes the application itself, local communities and news or blog posts.

**You are not allowed to:**

- sell or redistribute the application under the name "Hestia Control Panel", "HestiaCP", or similar derivatives, including the use of the Hestia logo in any brand or marketing materials related to revenue generating activities,
- use the names "Hestia Control Panel", "HestiaCP", or the Hestia logo in any context that is not related to the project,
- alter the name "Hestia Control Panel", "HestiaCP", or the Hestia logo in any way.

## License

Hestia Control Panel is licensed under [GPL v3](https://github.com/hestiacp/hestiacp/blob/release/LICENSE) license, and is based on the [VestaCP](https://vestacp.com/) project.<br>
