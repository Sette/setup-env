#!/bin/bash

# This script appends pyenv and pyenv-virtualenv configuration to ~/.zshrc if not already present.

set -euo pipefail

# === Constants ===
ZSHRC_FILE="${HOME}/.zshrc"
BASHRC_FILE="${HOME}/.bashrc"
PYENV_ROOT_LINE='export PYENV_ROOT="$HOME/.pyenv"'
PYENV_PATH_LINE='[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
PYENV_INIT_LINE='eval "$(pyenv init - bash)"'
PYENV_VIRTUALENV_LINE='eval "$(pyenv virtualenv-init -)"'

# === Functions ===

# Function to check command success
function check_success() {
  if [ $? -ne 0 ]; then
    echo "Error executing: $1"
    exit 1
  fi
}

function ensure_line_in_file() {
  local line="$1"
  local file="$2"
  if ! grep -Fxq "$line" "$file"; then
    echo "$line" >> "$file"
    echo "Added: $line"
  else
    echo "Line already present: $line"
  fi
}

CONFIG_LINES=(
  "$PYENV_ROOT_LINE"
  "$PYENV_PATH_LINE"
  "$PYENV_INIT_LINE"
  "$PYENV_VIRTUALENV_LINE"
)

function ensure_lines_in_file() {
  local file="$1"
  echo "Updating $file..."
  touch "$file"  # Ensure the file exists
  for line in "${CONFIG_LINES[@]}"; do
    if ! grep -Fxq "$line" "$file"; then
      echo "$line" >> "$file"
      echo "  Added: $line"
    else
      echo "  Already present: $line"
    fi
  done
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

function add_pyenv_config_to_interpreter() {
  echo "Adding pyenv configuration to $ZSHRC_FILE and $BASHRC_FILE..."
  ensure_lines_in_file "$ZSHRC_FILE"
  ensure_lines_in_file "$BASHRC_FILE"
  echo "pyenv configuration successfully updated in $ZSHRC_FILE and $BASHRC_FILE."
}


function install_last_python_global() {
  echo "Fetching latest stable Python version from pyenv..."
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
  pyenv install 3.12.10
  pyenv global 3.12.10
}

function install_pipx() {
  pip install pipx
  pipx install poetry
  pipx ensurepath
  # Ensure in Zsh context
  zsh -i -c 'pipx ensurepath'
}


# # === Main Execution ===
# Update package lists
echo "Updating package lists..."

#Instalando pyenv
echo "Instalando requirements system packages..."
sudo apt install -y make curl build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
check_success "sudo apt install"

# Download pyenv
echo "Upgrading system packages..."
curl https://pyenv.run | bash
check_success "curl https://pyenv.run"


add_pyenv_config_to_interpreter
reload_bashrc
install_python_global
reload_bashrc
install_pipx
reload_bashrc

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo apt-get autoremove -y
check_success "sudo apt-get autoremove"

# Clean package cache
echo "Cleaning package cache..."
sudo apt-get autoclean -y
check_success "sudo apt-get autoclean"

echo "System update completed successfully!"
