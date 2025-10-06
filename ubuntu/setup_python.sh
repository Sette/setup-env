#!/bin/bash

# This script appends pyenv and pyenv-virtualenv configuration to ~/.zshrc if not already present.

set -euo pipefail

# === Constants ===
ZSHRC_FILE="${HOME}/.zshrc"
BASHRC_FILE="${HOME}/.bashrc"

# === Functions ===

# Function to check command success
function check_success() {
  if [ $? -ne 0 ]; then
    echo "Error executing: $1"
    exit 1
  fi
}


function reload_zshrc() {
  echo "Reloading $ZSHRC_FILE..."
  source "$ZSHRC_FILE"
  echo "$ZSHRC_FILE reloaded successfully."
}

function reload_bashrc() {
  echo "Reloading $BASHRC_FILE..."
  source "$BASHRC_FILE"
  echo "$BASHRC_FILE reloaded successfully."
}


function install_last_python_global() {
  echo "Fetching latest stable Python version from UV..."
  local latest_version
  latest_version=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | grep -v - | tail -1 | tr -d '[:space:]')

  if [ -z "$latest_version" ]; then
    echo "Could not determine the latest Python version."
    return 1
  fi

  echo "Installing Python $latest_version..."
  pyenv install "$latest_version"
  pyenv global "$latest_version"

  echo "Installing pipx and poetry..."
  pip install --upgrade pip
  pip install pipx
  pipx install poetry
  pipx ensurepath

  echo "Python $latest_version installed globally with Poetry via pipx."
}


function install_python_global() {
  uv python install 3.12.11
  uv python pin 3.12.11
}

function install_pipx() {
  uv venv
  source .venv/bin/activate
  uv pip install pipx
  pipx install poetry
  pipx ensurepath
  # Ensure in Zsh context
  zsh -i -c 'pipx ensurepath'
}


# # === Main Execution ===
# Update package lists
echo "Updating package lists..."

#Instalando UV
echo "Instalando requirements system packages..."
sudo apt install -y make curl build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
check_success "sudo apt install"

# Download UV
echo "Upgrading system packages..."
curl -LsSf https://astral.sh/uv/install.sh | sh
check_success "curl -LsSf https://astral.sh/uv/install.sh"

# reload_zshrc
install_python_global
install_pipx

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo apt-get autoremove -y
check_success "sudo apt-get autoremove"

# Clean package cache
echo "Cleaning package cache..."
sudo apt-get autoclean -y
check_success "sudo apt-get autoclean"

echo "System update completed successfully!"
