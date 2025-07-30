#!/usr/bin/env bash

set -euo pipefail

# CONFIGURATION
REPO="github:hexpilgrim/nixconfig" # GitHub repo
HOSTNAME="nixos"                   # flake hostname
LOCAL_BUILD=true                   # is local machine

# Step 1: Enable Nix flakes
echo "Enabling Nix flakes..."
sudo mkdir -p /etc/nix
if ! grep -q "experimental-features = nix-command flakes" /etc/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
  echo "Flakes enabled."
else
  echo "Flakes already enabled."
fi

# Step 2: Backup existing config
echo "Backing up existing configuration..."
sudo cp -r /etc/nixos /etc/nixos.backup.$(date +%s)

# Step 3: Clone the flake repo
cd /etc/nixos
if [ -d ".git" ] || [ -f "flake.nix" ]; then
  echo "Existing flake or git repo found in /etc/nixos. Skipping clone."
else
  echo "⬇Cloning flake from $REPO..."
  sudo nix flake clone "$REPO" .
fi

# Step 4: Rebuild with IS_LOCAL_BUILD
echo "Rebuilding system from flake with IS_LOCAL_BUILD=${LOCAL_BUILD}..."
if [[ "$LOCAL_BUILD" == "true" ]]; then
  sudo IS_LOCAL_BUILD=1 nixos-rebuild switch --flake .#$HOSTNAME
else
  sudo nixos-rebuild switch --flake .#$HOSTNAME
fi

echo "Flake configuration applied!"
