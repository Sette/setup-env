#!/bin/bash
# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Update SO packages
echo "Updating SO packages..."
sudo apt-get dist-upgrade -y

# Cleaning SO packages
echo "Updating SO packages..."
sudo apt-get auto-remove -y

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
