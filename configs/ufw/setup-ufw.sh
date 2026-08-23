#!/usr/bin/env bash
# Run with: sudo ./setup-ufw.sh
# IMPORTANT: SSH is allowed BEFORE ufw is enabled, to avoid locking
# yourself out of the instance.

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script with sudo." >&2
  exit 1
fi

echo "== Installing ufw =="
apt-get update -y
apt-get install -y ufw

echo "== Setting default policies (deny incoming, allow outgoing) =="
ufw default deny incoming
ufw default allow outgoing

echo "== Allowing SSH (rate-limited) BEFORE enabling ufw =="
ufw allow OpenSSH
ufw limit OpenSSH

# Uncomment if this instance also need to serve HTTP/HTTPS:
# ufw allow 80/tcp
# ufw allow 443/tcp

echo "== Enabling ufw =="
ufw --force enable

echo "== Status =="
ufw status verbose
