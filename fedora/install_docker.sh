#!/bin/bash

# This script installs Docker on Fedora and performs post-installation steps.

set -euo pipefail

# Constants
UPGRADE_SCRIPT_PATH="./upgrade_system.sh"

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
  sudo dnf install -y dnf-plugins-core curl
}

function add_docker_repository() {
  echo "Adding Docker repository..."
  sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
}

function install_docker() {
  echo "Installing Docker..."
  sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function start_docker_service() {
  echo "Starting and enabling Docker service..."
  sudo systemctl enable --now docker
}

function test_docker_installation() {
  echo "Testing Docker installation..."
  sudo docker run hello-world
}

function configure_docker_post_install() {
  echo "Configuring Docker post-installation steps..."
  sudo groupadd docker || true  # Avoid error if group already exists
  sudo usermod -aG docker "$USER"
  echo "You need to log out and log back in for the group changes to take effect."
}

# Main script execution
check_upgrade_script
run_upgrade_script
install_prerequisites
add_docker_repository
install_docker
start_docker_service
test_docker_installation
configure_docker_post_install

echo "Docker installation and post-installation steps completed successfully."
