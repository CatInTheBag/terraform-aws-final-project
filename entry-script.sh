#!/bin/bash
set -e  # Exit script on any command that returns a non-zero status
set -x  # Enable debugging

LOG_FILE="$HOME/logfile.log"

# Function for logging
log() {
  local timestamp
  timestamp=$(date +"%Y-%m-%d %T")
  echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Update and upgrade the system
log "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install Docker
log "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $(whoami)

# Install Ansible
log "Installing Ansible..."
sudo apt install -y ansible

log "Script execution completed successfully."
