#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $(whoami)

# Install Ansible
sudo apt install -y ansible
