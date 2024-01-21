#!/bin/bash

# Change to the home directory
cd ~

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker $(whoami)

# Install Ansible
sudo apt install ansible

# Export the RUNNER_TOKEN environment variable
export RUNNER_TOKEN="${runner_token}"

# Log the token to a file for debugging
echo "RUNNER_TOKEN is set to: $RUNNER_TOKEN" > /tmp/runner_token.log

mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
echo "29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278  actions-runner-linux-x64-2.311.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
./config.sh --url https://github.com/CatInTheBag/terraform-aws-final-project --token $RUNNER_TOKEN --labels self-hosted,ubuntu,ec2 --name aws-ec2 
./run.sh