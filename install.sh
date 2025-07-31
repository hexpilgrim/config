#!/usr/bin/env bash

set -euo pipefail

# CONFIGURATION
REPO_URL="https://github.com/hexpilgrim/nixcfgs.git"   # GitHub repo URL
REPO_BRANCH="main"                                  # Specific branch to clone
HOSTNAME="nixos"                                       # Flake hostname

# Detect current user
CURRENT_USER=$(whoami)

# Step 1: Clone the repo using nix-shell for git
REPO_NAME="$(basename "$REPO_URL" .git)"
echo "Cloning repository $REPO_URL (branch: $REPO_BRANCH) into $REPO_NAME..."
nix-shell -p git --run "git clone -b $REPO_BRANCH $REPO_URL"

# Step 2: Modify user.nix with the current username
USER_FILE="$REPO_NAME/user.nix"
if grep -q 'username = "james";' "$USER_FILE"; then
  echo "Updating username in $USER_FILE to '$CURRENT_USER'..."
  sed -i "s/username = \"james\";/username = \"$CURRENT_USER\";/" "$USER_FILE"
else
  echo "No 'username = \"james\";' entry found in $USER_FILE. Skipping update."
fi

# Step 3: Rebuild system using the flake
cd "$REPO_NAME"
echo "Rebuilding system using flake at $REPO_NAME..."

sudo IS_LOCAL_BUILD=1 \
  nixos-rebuild switch \
  --experimental-features 'nix-command flakes' \
  --flake "$PWD#$HOSTNAME"

echo "System rebuilt successfully from flake!"
