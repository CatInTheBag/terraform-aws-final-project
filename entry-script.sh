#!/bin/bash
set -e  # Exit script on any command that returns a non-zero status
set -x  # Enable debugging

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $(whoami)

# Install Ansible
echo "Before Ansible Installation"
sudo apt install -y ansible
echo "After Ansible Installation"

echo "$(ansible --version)"
