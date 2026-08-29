# Nix-Darwin macOS Configuration

A declarative macOS system configuration managed with [nix-darwin](https://github.com/nix-darwin/nix-darwin), [Home Manager](https://github.com/nix-community/home-manager), and [Nix Flakes](https://wiki.nixos.org/wiki/Flakes). This repository contains a complete setup for macOS including system packages, GUI applications, development tools, shell configuration, and system preferences.

## Table of Contents

- [What is nix-darwin?](#what-is-nix-darwin)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration Overview](#configuration-overview)
- [What's Included](#whats-included)
- [Usage](#usage)
- [Customization](#customization)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Maintenance](#maintenance)

## What is nix-darwin?

[nix-darwin](https://github.com/nix-darwin/nix-darwin) is a tool that lets you manage your macOS system configuration declaratively using Nix. You can version control your entire system setup, making it reproducible and easy to replicate across machines. This means:

- **Reproducible**: Rebuild the exact same environment on any Mac
- **Version Controlled**: Track all changes in git
- **Declarative**: Define what you want, not how to get it
- **Atomic**: Updates are atomic - either everything works or nothing changes

## Features

- 🎨 **System Configuration**: Dock, Finder, Trackpad, Keyboard, and macOS preferences
- 📦 **Package Management**: System packages via Nix and GUI apps via Homebrew
- 🛠️ **Development Tools**: Docker (via OrbStack), and more
- 🐚 **Shell Configuration**: Zsh with Powerlevel10k prompt and useful aliases
- 📝 **Editor Setup**: NixVim (Neovim) and Cursor IDE with auto-installed extensions
- 🖥️ **Terminal Emulators**: Fully configured Kitty, Ghostty, and Tabby with Edo theme
- 🎨 **Theme System**: Custom Edo color theme with semantic colors
- 🔐 **Security**: Touch ID for sudo, system hardening options
- ⚡ **Optimizations**: Fast key repeat, dock animations, and system tweaks
- ⏰ **Menu Bar Apps**: Clock-rs with 24-hour time display

## Prerequisites

- macOS (tested on Apple Silicon, but Intel should work with modifications)
- Administrator access (for system configuration)
- Basic familiarity with terminal commands

## Installation

### Step 1: Install Nix

Choose one of the following installation methods:

#### Option A: Using Lix (Recommended)

[Lix](https://github.com/lix-project/lix) is a modern, community fork of Nix with improvements and fixes.

```bash
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

#### Option B: Using Determinate Systems Installer

[Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) is the easiest and most reliable way to install Nix—as well as our longest-running project.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Step 2: Source the Nix Environment

Apply the necessary Nix environment variables to your current shell session:

```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

**Important**: If using a new terminal session, you may need to source this again, or restart your terminal.

Verify Nix is installed:

```bash
nix --version
```

### Step 3: Install Homebrew

Homebrew is used for GUI applications (Casks) that aren't available in nixpkgs:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, add Homebrew to your PATH:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Step 4: Clone Configuration Repository

```bash
git clone https://github.com/JaxFry/nixos-configs-mac.git
cd nixos-configs-mac
```

### Step 5: Update Hostname (Optional)

The configuration now supports dynamic hostname detection! Check your Mac's hostname:

```bash
scutil --get LocalHostName
```

**Automatic Detection (Recommended):**

- `darwin-rebuild` will automatically detect and use your system's hostname when you run `darwin-rebuild switch --flake .`
- Simply add your hostname to the `hostnames` list in `flake.nix` (see below)
- After adding it once, it will work automatically on subsequent builds

**Manual Configuration (If you have multiple machines):**
Edit `flake.nix` and add your hostname(s) to the `hostnames` list at the top of the `let` block:

```nix
hostnames = [
  "maple"  # Current hostname
  "Your-New-Hostname"     # Add additional hostnames here
];
```

HostName, LocalHostName and ComputerName can be changed from CLI:

```bash
sudo scutil --set HostName maple
sudo scutil --set LocalHostName maple
sudo scutil --set ComputerName "Jaxon's Mac"
```

Confirm settings:

```bash
scutil --get HostName
scutil --get LocalHostName
scutil --get ComputerName
```

You may see different values, they each serve a slightly different purpose.

| Type           | Description                                         | Example                |
|----------------|-----------------------------------------------------|------------------------|
| **HostName**   | Used by network services (e.g., SSH, Terminal prompt). | `maple.local`    |
| **LocalHostName** | Used for Bonjour/AirDrop.                         | `maple`          |
| **ComputerName**  | Visible name in System Settings → General → Sharing. | `Jaxon's Mac` |

All configuration variables (hostnames, username) are now defined at the top of the `let` block for easy customization.

**Update Username:**
Edit `flake.nix` and change the `username` variable at the top of the `let` block:

```nix
username = "jaxon";  # Change to your macOS username
```

The configuration will automatically use this username throughout the setup.

**Update Git Configuration:**
Edit `modules/home/programs/git.nix` and update the git user settings:

```nix
programs.git = {
  settings = {
    user = {
      name = "";  # Change to your git username
      email = "";  # Change to your git email
    };
    # ... rest of config
  };
};
```

This will configure your git identity globally for all repositories.

### Step 6: Initial Build

Run the initial build to apply your configuration:

```bash
sudo nix run nix-darwin -- switch --flake .
```

This will:

- Install all system packages
- Configure macOS settings
- Set up Home Manager
- Install GUI applications via Homebrew
- Configure your shell and development tools

**First build may take 20-30 minutes** depending on your internet connection and system.

### Step 7: Verify Installation

## MANUAL INSTALL APPS
The following applications are strictly managed outside of Nix/Homebrew and must be manually installed:
- Superwhisper
- Bartender 6
- CleanShot X
- Dropover
- Hazel (app install only; rules/preferences restored from nix-managed backup)
- Cold Turkey Blocker

After the first build completes, verify everything is working:

```bash
# Test your update alias
update

# Check if packages are available
which nvim
which git

# Verify shell configuration
echo $SHELL  # Should show zsh
```

## Configuration Overview

This configuration uses:

- **nix-darwin**: System-level configuration and macOS settings
- **Home Manager**: User-level configuration and packages
- **Nix Flakes**: Modern Nix package management with locked dependencies
- **NixVim**: Neovim configuration managed in Nix

### Key Configuration Files

- `flake.nix`: Main flake configuration - inputs, outputs, and system setup
- `home.nix`: User configuration - imports all program modules
- `modules/packages.nix`: System packages installed via Nix and Homebrew
- `modules/system-settings.nix`: macOS system settings and preferences
- `modules/nix-core.nix`: Nix configuration settings
- `modules/aliases.nix`: Shell aliases (git, docker, etc.)
- `nixvim.nix`: Neovim configuration - plugins, themes, LSP servers

### Program Configuration Modules

All user programs are configured in `modules/home/programs/`:

- `zsh.nix`: Zsh shell with Powerlevel10k prompt
- `cursor.nix`: Cursor IDE with extensions and settings
- `kitty.nix`: Kitty terminal configuration
- `ghostty.nix`: Ghostty terminal configuration
- `tabby.nix`: Tabby terminal configuration
- `git.nix`: Git configuration
- `bat.nix`: Bat (cat replacement) configuration
- `fzf.nix`: Fuzzy finder configuration
- `tmux.nix`: Tmux configuration
- `clock-rs.nix`: Clock-rs menu bar app
- `antigravity.nix`: Antigravity configuration
- `hazel.nix`: Hazel rules/preferences restore (license excluded)
- `htop.nix`: Htop configuration
- `theme.nix`: Edo color theme definition

## What's Included

### System Packages (via Nix)

- **Communication**: Slack, Discord
- **Terminals & Shells**: Kitty, Nushell, Zsh, Fish
- **Development CLIs**: GitHub CLI, git, lazygit, direnv, act, tmux, zellij
- **Editors & Nix tooling**: Neovim, Vim, nil, nixd, nixpkgs-fmt
- **Core CLI tools**: curl, wget, ripgrep, fzf, eza, fd, zoxide, tree, jq, yq, delta
- **System & file tools**: htop, btop, bottom, neofetch, fastfetch, ranger, p7zip
- **Languages & runtimes**: Node.js 22, Yarn, Lua, uv
- **Media & transfer**: yt-dlp, ffmpeg, aria2
- **Virtualization**: Vagrant, Packer
- **Productivity**: Obsidian, Bitwarden CLI
- **Fonts**: Nerd Fonts (Fira Code, JetBrains Mono, Meslo LG, Hack)

### GUI Applications (via Homebrew Cask)

- **Editors**: Cursor and Visual Studio Code (fully configured), Zed
- **Browsers**: Brave, Google Chrome, Zen Browser
- **Terminals**: iTerm2, Ghostty, Tabby
- **Productivity**: Notion, Raycast
- **File Sharing/Downloads**: qBittorrent, Motrix, JDownloader
- **Containers**: OrbStack
- **System Tools**: Karabiner Elements, KeepassXC, Bitwarden, balenaEtcher
- **VPN & Networking**: Tailscale, Cloudflare WARP, Wireshark
- **Security testing**: Burp Suite, Metasploit, Angry IP Scanner
- **Media/Creator tools**: IINA, HandBrake, Audacity, OBS, DaVinci Resolve
- **Fonts**: SF Mono, SF Pro, Maple Mono, SF Symbols

### Development Tools (via Home Manager)

- **Infrastructure & security**: Ansible, gitleaks
- **Cloud**: AWS CLI, Google Cloud SDK (with GKE auth plugin)
- **Databases**: PostgreSQL, MariaDB
- **VPN**: Tailscale

### Shell Configuration

- **Zsh** with **Powerlevel10k** prompt (fast, compact, and context-aware)
- **Plugins**: git, docker, macos, fzf, and more
- **Aliases**: Git shortcuts, Docker shortcuts
- **Modern Tools**: eza (ls), bat (cat), fzf (fuzzy finder), tmux, zellij
- **Configuration**: Modular setup in `modules/home/programs/zsh.nix`

### Editor Configurations

#### Neovim (NixVim)

- **Theme**: Catppuccin
- **Plugins**: Lualine, nvim-tree, Telescope, Treesitter
- **LSP**: Nix (nil-ls), Lua (lua-ls)
- **Features**: Syntax highlighting, file tree, fuzzy finder, status bar

#### Cursor IDE & Visual Studio Code

Both Cursor and VS Code are managed declaratively to share an identical, robust setup:

- **Auto-installed Extensions**: Python, Go, Rust, Prettier, ESLint, GitLens, and more
- **Font**: SF Mono for editor, Nerd Fonts for terminal
- **Theme**: Cursor Dark Midnight (Cursor) / Catppuccin Mocha (VS Code)
- **Features**: Format on save, bracket pair colorization, minimap, and more
- **Configuration**: Managed in `modules/home/programs/cursor.nix` and `modules/home/programs/vscode.nix`

### Terminal Emulators

All terminals are configured with the **Edo theme** and **Nerd Fonts**:

- **Kitty**: Powerline tabs, Edo theme, JetBrainsMono Nerd Font, optimized spacing
- **Ghostty**: GPU-accelerated, Edo theme, Nerd Fonts, hidden titlebar
- **Tabby**: Modern terminal, Edo theme, Nerd Fonts, configurable profiles

Configuration files:

- `modules/home/programs/kitty.nix`
- `modules/home/programs/ghostty.nix`
- `modules/home/programs/tabby.nix`

### Theme System

- **Edo Theme**: Custom dark theme with excellent contrast
- **Semantic Colors**: Success, error, warning, info colors
- **Terminal Colors**: Optimized ANSI color palette
- **Configuration**: `modules/home/theme.nix`

### macOS System Settings

- **Dock**: Auto-hide, left position, optimized animations
- **Finder**: Show extensions, path bar, list view
- **Keyboard**: Caps Lock → Control, fast key repeat
- **Trackpad**: Tap to click, three-finger drag
- **Security**: Touch ID for sudo, guest account disabled
- **Screenshots**: PNG format, saved to `~/Pictures/Screenshots`
- **Menu Bar**: Clock-rs with 24-hour time display

## Usage

### Common Commands

```bash
# Update system configuration
update

# Update and rebuild with latest flake inputs
upgrade

# Clean up old Nix generations
cleanup

# Rebuild configuration (if you're already in the config directory)
sudo darwin-rebuild switch --flake .
```

### Useful Aliases

See `modules/aliases.nix` for the complete alias list, but here are some highlights:

**Git:**

- `g` = git
- `gs` = git status
- `ga` = git add
- `gcm` = git commit -m
- `gp` = git push


**Docker:**

- `d` = docker
- `dc` = docker-compose


## Customization

### Adding Packages

**System packages** (available to all users):
Edit `modules/packages.nix` and add to `environment.systemPackages`:

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  your-package-name
];
```

**User packages** (specific to your user):
Edit `modules/packages.nix` and add to `home-manager.users.${config.system.primaryUser}.home.packages`:

```nix
home-manager.users.${config.system.primaryUser}.home.packages = with pkgs; [
  # ... existing packages
  your-package-name
];
```

**Homebrew Casks** (GUI applications):
Edit `modules/packages.nix` and add to `homebrew.casks`:

```nix
homebrew = {
  casks = [
    # ... existing casks
    "your-app-name"
  ];
};
```

After making changes, rebuild:

```bash
update
```

### Changing Shell Configuration

Edit `modules/home/programs/zsh.nix` for shell configuration:

- **Powerlevel10k prompt**: Configured in `modules/home/programs/zsh.nix` (`~/.p10k.zsh` is managed by Home Manager)
- **Custom shell functions**: Add to `programs.zsh.initContent`

**Shell aliases** are in `modules/aliases.nix`:

- Edit `modules/aliases.nix` to add, modify, or remove aliases
- This keeps all aliases organized in one place

### Changing Git Configuration

Edit `modules/home/programs/git.nix` under `programs.git.settings.user`:

- **Name**: Change `user.name` to your git username
- **Email**: Change `user.email` to your git email
- **Aliases**: Add custom git aliases under `alias.*`
- **Editor**: Change `core.editor` if you prefer a different editor

### Changing Editor Configurations

**Neovim**: Edit `nixvim.nix`:

- **Theme**: Change `colorschemes.*.enable`
- **Plugins**: Add to `plugins.*`
- **Options**: Modify `opts.*`

**Cursor IDE**: Edit `modules/home/programs/cursor.nix`:

- **Extensions**: Add to `cursorExtensions` list (auto-installed)
- **Settings**: Modify `settings.json` content
- **Keybindings**: Modify `keybindings.json` content

### Changing Terminal Configurations

All terminals use the Edo theme from `modules/home/theme.nix`:

- **Kitty**: Edit `modules/home/programs/kitty.nix`
- **Ghostty**: Edit `modules/home/programs/ghostty.nix`
- **Tabby**: Edit `modules/home/programs/tabby.nix`

To change the theme colors, edit `modules/home/theme.nix`.

### Changing macOS Settings

Edit `modules/system-settings.nix`:

- Dock settings: `system.defaults.dock.*`
- Finder settings: `system.defaults.finder.*`
- Keyboard settings: `system.defaults.NSGlobalDomain.*`
- Trackpad settings: `system.defaults.trackpad.*`

## Project Structure

```bash
nixos-configs-mac/
├── flake.nix                    # Main flake configuration with inputs and outputs
├── flake.lock                   # Locked dependencies (auto-generated)
├── home.nix                     # User configuration: imports all program modules
├── nixvim.nix                   # Neovim configuration: plugins, themes, LSP
├── modules/                     # Modular configuration files
│   ├── packages.nix                # System packages (Nix) and Homebrew
│   ├── system-settings.nix         # macOS system settings and preferences
│   ├── nix-core.nix                # Nix configuration settings
│   ├── aliases.nix                 # Shell aliases (git, docker, etc.)
│   └── home/                      # Home Manager program configurations
│       ├── theme.nix                  # Edo color theme definition
│       └── programs/                 # Individual program configurations
│           ├── zsh.nix                  # Zsh with Powerlevel10k
│           ├── cursor.nix              # Cursor IDE configuration
│           ├── vscode.nix              # VS Code declarative setup
│           ├── kitty.nix               # Kitty terminal
│           ├── ghostty.nix             # Ghostty terminal
│           ├── tabby.nix               # Tabby terminal
│           ├── git.nix                # Git configuration
│           ├── bat.nix                # Bat configuration
│           ├── fzf.nix                # Fuzzy finder
│           ├── tmux.nix               # Tmux
│           ├── clock-rs.nix          # Clock-rs menu bar app
│           ├── antigravity.nix        # Antigravity
│           ├── hazel.nix              # Hazel config restore
│           ├── hazel-backup/          # Hazel rule/plist backup data
│           └── htop.nix               # Htop
└── README.md                    # This file
```

**Benefits of this modular structure:**

- **Better organization**: Each file has a single, clear purpose
- **Easier maintenance**: Find and edit specific configurations quickly
- **Cleaner files**: Main config files are more readable
- **Scalable**: Easy to add new modules as your configuration grows

## Troubleshooting

### Packages Not Found

**Issue**: Package not available after installation

**Solution**:

1. Check if the package name is correct in nixpkgs
2. Rebuild: `update`
3. Start a new terminal session

### Homebrew Apps Not Installing

**Issue**: Homebrew casks not installing

**Solution**:

1. Verify Homebrew is installed: `which brew`
2. Check if the cask name is correct: `brew search <app-name>`
3. Manually install to verify: `brew install --cask <app-name>`

### Shell Not Working

**Issue**: Zsh configuration not loading

**Solution**:

1. Verify zsh is your default shell: `echo $SHELL`
2. Check if home.nix is properly imported in flake.nix
3. Rebuild: `update`
4. Source your shell config: `source ~/.zshrc`

### Permission Errors

**Issue**: `sudo: ... command not found` or permission denied

**Solution**:

- Make sure you're using `sudo` for system-level changes
- Verify your user has sudo privileges
- Check file permissions if editing files directly

### Out of Disk Space

**Issue**: Nix store growing too large

**Solution**: Run cleanup regularly:

```bash
cleanup  # or: nix-collect-garbage -d
```

You can also adjust the garbage collection settings in `flake.nix`:

```nix
nix.gc = {
  automatic = true;
  interval = { Weekday = 7; };  # Run on Sundays
  options = "--delete-older-than 30d";  # Keep last 30 days
};
```

## Maintenance

### Regular Updates

**Update packages and configuration:**

```bash
upgrade
```

This updates all flake inputs and rebuilds your system.

**Update just packages (keep flake inputs locked):**

```bash
update
```

### Cleanup Old Generations

Nix keeps old system generations for rollback. Clean them up periodically:

```bash
cleanup
```

Or manually:\

```bash
nix-collect-garbage -d
```

### Backup Configuration

Your configuration is already version controlled! Just commit and push:

```bash
git add .
git commit -m "Update configuration"
git push
```

### Rollback

If something goes wrong, you can rollback to a previous generation:

```bash
sudo darwin-rebuild switch --rollback
```

Or list all generations:

```bash
sudo darwin-rebuild --list-generations
```

Then switch to a specific generation:

```bash
sudo darwin-rebuild switch --rollback <generation-number>
```

## Personal notes

```bash
# Powerlevel10k is managed declaratively via Home Manager.
```

Disable iPhone apps showing in Spotlight search:

1. Open System Settings ( menu > System Settings).
2. Click **Spotlight** in the sidebar (or search for "Spotlight" in the top search bar).
3. Under **Results from System**, find **iPhone Apps** - it might be a checkbox or toggle.
4. Uncheck to off "iPhone Apps".

## Additional Resources

- [nix-darwin Documentation](https://github.com/nix-darwin/nix-darwin)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [NixVim Documentation](https://github.com/nix-community/nixvim)

## License

This configuration is for personal use. Feel free to fork and adapt for your needs!

---

**Note**: This configuration is tailored for Apple Silicon Macs. If you're on Intel, change `hostPlatform` in `flake.nix` from `"aarch64-darwin"` to `"x86_64-darwin"`.
