# install.sh
#!/usr/bin/env bash

set -euo pipefail

# Colour definitions (bold included)
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m' # No Colour

# Configuration
REPO_URL="https://github.com/hexpilgrim/nixcfgs.git"
REPO_BRANCH="main"
HOSTNAME="nixos"

CURRENT_USER=$(whoami)

# Step 1: Enable flakes support
if [ -f "/etc/nixos/configuration.nix" ]; then
  if ! grep -q 'extra-experimental-features' /etc/nixos/configuration.nix; then
    printf "${YELLOW}Adding flake support before system.stateVersion...${NC}\n"
    sudo sed -i '/system\.stateVersion/ i nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];\n' /etc/nixos/configuration.nix
    printf "${BLUE}Rebuilding system configuration...${NC}\n"
    sudo nixos-rebuild switch
  else
    printf "${GREEN}Flake support already declared in configuration.nix.${NC}\n"
  fi
else
  mkdir -p ~/.config/nix
  printf "${YELLOW}Enabling flakes in user config (~/.config/nix/nix.conf)...${NC}\n"
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Step 2: Clone the repo using nix-shell
REPO_NAME="$(basename "$REPO_URL" .git)"
printf "${CYAN}Cloning repository ${REPO_URL} (branch: ${REPO_BRANCH}) into ${REPO_NAME}...${NC}\n"
nix-shell -p git --run "git clone -b $REPO_BRANCH $REPO_URL"

# Step 3: Replace hardware-configuration.nix
SOURCE_HW_CONFIG="/etc/nixos/hardware-configuration.nix"
TARGET_HW_CONFIG="$REPO_NAME/hardware-configuration.nix"
if [ -f "$SOURCE_HW_CONFIG" ]; then
  printf "${YELLOW}Replacing hardware-configuration.nix in repo with system version...${NC}\n"
  cp "$SOURCE_HW_CONFIG" "$TARGET_HW_CONFIG"
else
  printf "${RED}Warning: /etc/nixos/hardware-configuration.nix not found. Skipping update.${NC}\n"
fi

# Step 4: Update username in user.nix
USER_FILE="$REPO_NAME/user.nix"
if grep -q 'username = "james";' "$USER_FILE"; then
  printf "${MAGENTA}Updating username in $USER_FILE to '${CURRENT_USER}'...${NC}\n"
  sed -i "s/username = \"james\";/username = \"$CURRENT_USER\";/" "$USER_FILE"
else
  printf "${YELLOW}No 'username = \"james\";' found in $USER_FILE. Skipping update.${NC}\n"
fi

# Step 5: Rebuild system using flake
cd "$REPO_NAME"
printf "${BLUE}Rebuilding system from flake at ${REPO_NAME}...${NC}\n"
sudo nixos-rebuild switch --flake "$PWD#$HOSTNAME"

printf "${GREEN}System rebuilt successfully from flake!${NC}\n"
