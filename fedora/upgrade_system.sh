#!/bin/bash

# Function to check command success
check_success() {
  if [ $? -ne 0 ]; then
    echo "Error executing: $1"
    exit 1
  fi
}

# Update package lists
echo "Checking for updates..."
sudo dnf check-update -y || true
check_success "sudo dnf check-update"

# Upgrade system packages
echo "Upgrading system packages..."
sudo dnf upgrade -y
check_success "sudo dnf upgrade"

# Remove unnecessary packages
echo "Removing unnecessary packages..."
sudo dnf autoremove -y
check_success "sudo dnf autoremove"

# Clean package cache
echo "Cleaning package cache..."
sudo dnf clean all
check_success "sudo dnf clean all"

echo "System update completed successfully!"
