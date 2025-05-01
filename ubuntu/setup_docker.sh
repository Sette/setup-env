#!/bin/bash

# This script installs Docker on Ubuntu 22.04 LTS and performs post-installation steps.

set -euo pipefail

# Constants
UPGRADE_SCRIPT_PATH="./upgrade_system.sh"
DOCKER_GPG_KEY_URL="https://download.docker.com/linux/ubuntu/gpg"
DOCKER_APT_SOURCE_LIST="/etc/apt/sources.list.d/docker.list"
DOCKER_KEYRING_PATH="/etc/apt/keyrings/docker.asc"

# Functions
function check_upgrade_script() {
  if [ ! -f "$UPGRADE_SCRIPT_PATH" ]; then
    echo "Error: $UPGRADE_SCRIPT_PATH not found."
    exit 1
  fi
}

function run_upgrade_script() {
  echo "Making $UPGRADE_SCRIPT_PATH executable..."
  chmod +x "$UPGRADE_SCRIPT_PATH"
  echo "Running $UPGRADE_SCRIPT_PATH..."
  "$UPGRADE_SCRIPT_PATH"
}

function install_prerequisites() {
  echo "Installing prerequisites..."
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg
}

function add_docker_gpg_key() {
  echo "Adding Docker's official GPG key..."
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL "$DOCKER_GPG_KEY_URL" -o "$DOCKER_KEYRING_PATH"
  sudo chmod a+r "$DOCKER_KEYRING_PATH"
}

function add_docker_repository() {
  echo "Adding Docker repository..."
  echo "deb [arch=$(dpkg --print-architecture) signed-by=$DOCKER_KEYRING_PATH] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee "$DOCKER_APT_SOURCE_LIST" > /dev/null
  sudo apt-get update
}

function install_docker() {
  echo "Installing Docker..."
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function start_docker_service() {
  echo "Starting Docker service..."
  sudo service docker start
}

function test_docker_installation() {
  echo "Testing Docker installation..."
  sudo docker run hello-world
}

function configure_docker_post_install() {
  echo "Configuring Docker post-installation steps..."
  sudo groupadd docker || true  # Avoid error if group already exists
  sudo usermod -aG docker "$USER"
  newgrp docker
  echo "You need to log out and log back in for the group changes to take effect."
}

# Main script execution
check_upgrade_script
run_upgrade_script
install_prerequisites
add_docker_gpg_key
add_docker_repository
install_docker
start_docker_service
test_docker_installation
configure_docker_post_install

echo "Docker installation and post-installation steps completed successfully."