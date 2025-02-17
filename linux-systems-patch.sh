#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Detect OS type
if [ -f /etc/debian_version ]; then
    OS="Debian"
    UPDATE_CMD="apt update && apt upgrade -y"
elif [ -f /etc/redhat-release ]; then
    OS="RedHat"
    UPDATE_CMD="dnf update -y"
else
    echo "Unsupported Linux distribution"
    exit 1
fi

echo "Starting update process for $OS-based system..."

# Update and upgrade the system
eval $UPDATE_CMD

# Check if a reboot is required (Debian-based)
if [ -f /var/run/reboot-required ]; then
    echo "Reboot required. Restarting system..."
    reboot
else
    echo "System is up-to-date. No reboot required."
fi