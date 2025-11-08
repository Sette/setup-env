#!/bin/bash

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

# Main execution
echo "Updating system packages and installing requirements..."

# Install required system packages on Fedora using dnf
sudo dnf install -y make curl gcc gcc-c++ openssl-devel bzip2-devel readline-devel sqlite-devel wget llvm ncurses-devel xz tk-devel libxml2-devel xmlsec1-devel libffi-devel lzma-sdk-devel

check_success "sudo dnf install"

# Install or upgrade uv - preferred method is via rpm or curl installer
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
check_success "curl -LsSf https://astral.sh/uv/install.sh"

# Install global Python version using uv
install_python_global

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo dnf autoremove -y
check_success "sudo dnf autoremove"

# Clean package cache
echo "Cleaning package cache..."
sudo dnf clean all
check_success "sudo dnf clean all"

echo "System update and Python environment setup completed successfully!"
