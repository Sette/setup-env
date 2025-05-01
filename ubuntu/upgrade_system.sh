#!/bin/bash

# Function to check command success
check_success() {
  if [ $? -ne 0 ]; then
    echo "Error executing: $1"
    exit 1
  fi
}

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y
check_success "sudo apt-get update"

# Upgrade system packages
echo "Upgrading system packages..."
sudo apt-get dist-upgrade -y
check_success "sudo apt-get dist-upgrade"

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo apt-get autoremove -y
check_success "sudo apt-get autoremove"

# Clean package cache
echo "Cleaning package cache..."
sudo apt-get autoclean -y
check_success "sudo apt-get autoclean"

echo "System update completed successfully!"
