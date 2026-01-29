# vcore-manager
A comprehensive Bash script for Ubuntu server management. Features include: real-time monitoring (CPU/RAM), network status (open ports, connections), optimization (apt/journalctl), security hardening (UFW), and Docker installation.
# 🚀 V-Core Manager

A lightweight and stable VPS management tool for Ubuntu servers.
Monitor, optimize, and secure your server using a single command.

---

## ⚡ One-Line Install & Run

Run the following command to start V-Core Manager instantly:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/vcore-manager/main/vcore.sh)

Or using wget:
bash <(wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/vcore-manager/main/vcore.sh)
⚠️ Run as root or with sudo.

✨ Features

📊 Live system monitoring (CPU / RAM / processes)

🌐 View open ports and active services

👥 Show connected client IPs

🧹 System optimization (update & cleanup)

🔐 Basic security with UFW firewall

🐳 Docker & Docker Compose installation

🖥 Supported OS

Ubuntu 20.04

Ubuntu 22.04

Ubuntu 24.04

📦 Project Structure
vcore-manager/
├── vcore.sh
└── README.md

🛡 Security Notice

Always review scripts before running them on production servers.
