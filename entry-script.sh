#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $(whoami)