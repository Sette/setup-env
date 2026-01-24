#!/bin/bash

# This script instala UV, python e pipx e configura o ambiente de acordo com o shell especificado (bash ou zsh).
set -euo pipefail

if [ "$#" -ne 1 ] || ([ "$1" != "bash" ] && [ "$1" != "zsh" ]); then
  echo "Uso: $0 [bash|zsh]"
  exit 1
fi


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
  # Ensure in shell context
  $SHELL_TYPE -i -c 'pipx ensurepath'
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

# Adicione todos os caminhos comuns para uv ao PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Confere se 'uv' está no PATH
if ! command -v uv >/dev/null 2>&1; then
    echo "Erro: 'uv' não está disponível no PATH! Instalação falhou ou o PATH não foi ajustado."
    exit 1
fi

install_python_global

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo apt-get autoremove -y
check_success "sudo apt-get autoremove"

# Clean package cache
echo "Cleaning package cache..."
sudo apt-get autoclean -y
check_success "sudo apt-get autoclean"

echo "System update completed successfully!"
