#!/bin/bash
# This script is intended to be run on Ubuntu 22.04 LTS
# It installs zsh, Oh My Zsh, and some useful plugins
# It also updates the system and installs some dependencies
# Path to the upgrade_system.sh script
UPGRADE_SCRIPT_PATH="./upgrade_system.sh"
# Check if the upgrade_system.sh script exists
if [ ! -f "$UPGRADE_SCRIPT_PATH" ]; then
  echo "Error: $UPGRADE_SCRIPT_PATH not found."
  exit 1
fi
# Make the upgrade_system.sh script executable
# and run it to update the system
echo "Making upgrade_system.sh executable..."
# Make the script executable
chmod +x $UPGRADE_SCRIPT_PATH
# Run the script
echo "Running upgrade_system.sh..."
./$UPGRADE_SCRIPT_PATH

# Install zsh
echo "Installing zsh..."
sudo apt-get install -y zsh git wget

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
RUNZSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Set Zsh as default shell for the current session
echo "Switching to zsh..."
export SHELL=$(which zsh)

# Clonning plugin projetcs
echo "Clonning plugin projetcs"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# Install fzf
echo "Installing fzf plugin"
Y | ~/.fzf/install

# Path to the .zshrc file (adjust if needed)
ZSHRC_FILE="${HOME}/.zshrc"

# Check if .zshrc exists
if [ ! -f "$ZSHRC_FILE" ]; then
  echo "Error: .zshrc file not found at $ZSHRC_FILE"
  exit 1
fi

# Replace the plugins=(git) line with the new plugins
echo "Updating plugins in $ZSHRC_FILE..."
sed -i 's/plugins=(git)/plugins=(\
  git\
  zsh-syntax-highlighting\
  zsh-autosuggestions\
  fzf\
)/' "$ZSHRC_FILE"

# Inform the user that the update was successful
echo "Plugins updated successfully in $ZSHRC_FILE"
