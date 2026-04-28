#!/usr/bin/env bash
set -e

# ==============================================================================
# Jaxon's Nix-Darwin macOS Automated Setup Script
# ==============================================================================
# This scripts aims to bypass the manual setup required in the README.md

echo "🍏 Starting Jaxon's Mac Setup..."

# --- 1. Check for Command Line Tools ---
if ! xcode-select -p &>/dev/null; then
  echo "🛠️  Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "⏳ Please wait for the Command Line Tools installation to finish."
  echo "Press Enter when the installation is complete..."
  read -r
else
  echo "✅ Command Line Tools installed."
fi

# --- 2. Install Nix (Using Determinate Systems) ---
if ! command -v nix &>/dev/null; then
  echo "❄️  Installing Nix (Determinate Systems Installer)..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  
  # Source the nix daemon for the current session
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "✅ Nix already installed."
fi

# --- 3. Install Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add brew to path for the current session
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew already installed."
fi

# --- 4. Enforce Hostnames to Match Configuration ---
# Our flake explicitly provisions the 'maple' configuration tree
TARGET_HOSTNAME="maple"
TARGET_COMPUTER_NAME="Jaxon's Mac"

CURRENT_LOCAL=$(scutil --get LocalHostName || echo "")

if [ "$CURRENT_LOCAL" != "$TARGET_HOSTNAME" ]; then
  echo "🔄 Setting system hostnames to '$TARGET_HOSTNAME' so the flake builds correctly..."
  sudo scutil --set HostName "$TARGET_HOSTNAME"
  sudo scutil --set LocalHostName "$TARGET_HOSTNAME"
  sudo scutil --set ComputerName "$TARGET_COMPUTER_NAME"
  echo "✅ Hostname updated to $TARGET_HOSTNAME"
else
  echo "✅ Hostname is already $TARGET_HOSTNAME"
fi

# --- 5. Bootstrapping Nix-Darwin ---
REPO_DIR="$HOME/Documents/Coding/nixos-configs-mac"

if [ ! -d "$REPO_DIR" ]; then
  echo "📥 Cloning configuration repository..."
  mkdir -p "$HOME/Documents/Coding"
  git clone https://github.com/JaxFry/nixos-configs-mac.git "$REPO_DIR"
fi

cd "$REPO_DIR"

echo "⚙️  Building macOS system configuration via Nix-Darwin..."
echo "⏳ This may take 20-30 minutes the very first time..."

# Make sure all changes are tracked so flakes can read them
git add .

# Run the initial build directly from nix run
nix run nix-darwin -- switch --flake .

echo ""
echo "🎉 Setup complete! Please completely restart your terminal to pick up all changes."
echo "👉 Note: Don't forget that manual apps (CleanShot X, Bartender 6, etc) still must be downloaded by hand."
